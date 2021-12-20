class RecommendedUsersService
  def self.similarly_tagged_users(range: nil, instruments: nil, genres: nil)
    conn = ActiveRecord::Base
    all_users = User.all
    no_ids = connected_users.ids.push(id).concat(rejections.pluck(:rejected_id))

    if range
      range_ids = users_in_range(all_users, range)
      range_query = range_ids.empty? ? 'false' : conn.sanitize_sql_array(['u.id IN(?)', range_ids])

    else
      range_query = 'true'
    end

    # must fix issue when filter is set but there are no results (currently displaying all results)
    if instruments || genres
      instrument_user_ids = Userinstrument.where(instrument_id: Instrument.where(name: instruments)).pluck(:user_id)
      genre_user_ids = Usergenre.where(genre_id: Genre.where(name: genres)).pluck(:user_id)
      combined_ids = genre_user_ids.concat(instrument_user_ids)
      genre_instrument_query = if !combined_ids.empty?
                                 conn.sanitize_sql_array(['u.id IN(?)', combined_ids])
                               else
                                 'false'
                               end
    else
      genre_instrument_query = 'true'
    end

    sql2 = <<~SQL
      SELECT u.*, COALESCE(matching_tag_counts.n, 0) AS similarity_score,#{' '}
      COALESCE(matching_genre_count.x, 0) AS genre_score
      FROM users AS u
        LEFT OUTER JOIN (
          SELECT user_id, COUNT(*) AS n
          FROM usertags
          WHERE #{conn.sanitize_sql_array(['tag_id IN(?)', tag_ids])}
          GROUP BY user_id
        ) AS matching_tag_counts ON u.id=matching_tag_counts.user_id
        LEFT OUTER JOIN (
          SELECT user_id, COUNT(*) AS x
          FROM usergenres
          WHERE #{conn.sanitize_sql_array(['genre_id IN(?)', genre_ids])}
          GROUP BY user_id
        ) AS matching_genre_count ON u.id=matching_genre_count.user_id
        WHERE #{conn.sanitize_sql_array(['u.id NOT IN(?)', no_ids])}
        AND #{range_query}
        AND #{genre_instrument_query}
        ORDER BY similarity_score DESC, genre_score DESC
        LIMIT 50
    SQL
    sanatized = ActiveRecord::Base.sanitize_sql(sql2)
    results = User.find_by_sql(sanatized)
  end
end
