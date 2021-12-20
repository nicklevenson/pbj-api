class RecommendedUsersService
  attr_accessor :assorted_users, :user, :range, :instruments, :genres

  def initialize(user:, range: nil, instruments: nil, genres: nil)
    @user = user
    @range = range
    @instruments = instruments
    @genres = genres
    @assorted_users = base_selection
  end

  def get_recommendation
    filter_by_range
    filter_by_genres
    filter_by_instruments
    order_by_similarity
  end

  def base_selection
    # use cache for this
    wide_selection = User.all

    # users not be queried (connected and rejected users)
    exclude_ids = @user.connected_users.ids.push(@user.id)

    wide_selection.where.not(id: exclude_ids)
  end

  def filter_by_range
    @assorted_users = @user.users_in_range(@assorted_users, range) if @range
  end

  def filter_by_genres
    if @genres

    end
  end

  def filter_by_instruments
    if @instruments

    end
  end

  def order_by_similarity
    conn = ActiveRecord::Base
    sql = <<~SQL
      SELECT u.*, COALESCE(matching_tag_counts.n, 0) AS similarity_score
      FROM users AS u
        LEFT OUTER JOIN (
          SELECT user_id, COUNT(*) AS n
          FROM user_tags
          WHERE #{conn.sanitize_sql_array(['tag_id IN(?)', @user.tag_ids])}
          GROUP BY user_id
        ) AS matching_tag_counts ON u.id=matching_tag_counts.user_id
        ORDER BY similarity_score DESC
        LIMIT 1000
    SQL

    @assorted_users = @assorted_users.find_by_sql(sql)
  end
end
