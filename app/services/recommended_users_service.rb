class RecommendedUsersService
  attr_accessor :assorted_users, :user, :range, :instruments, :genres

  def initialize(user:, range: nil, instruments: nil, genres: nil)
    @user = user
    @range = range
    @instruments = instruments
    @genres = genres
    @assorted_users = []
  end

  def get_recommendation
    base_selection
    filter_by_range
    apply_genre_instrument_filters
    order_by_similarity
  end

  def base_selection
    # use cache for this
    wide_selection = User.all

    # users not be queried (connected and rejected users)
    exclude_ids = @user.connected_users.ids.push(@user.id)
    @assorted_users = wide_selection.where.not(id: exclude_ids)
  end

  def filter_by_range
    if @range
      ids_in_range =  @user.users_in_range(@assorted_users, @range)
      @assorted_users = @assorted_users.where(id: ids_in_range)
    end
  end

  def apply_genre_instrument_filters
    if @genres || @instruments
      @assorted_users = @assorted_users.where(id: (filter_by_genres + filter_by_instruments).uniq)
    end
  end

  def filter_by_genres
    if @genres
      @assorted_users.where(id: UserTag.where(tag: Tag.genre.where(name: @genres)).pluck(:user_id))
    else
      []
    end
  end

  def filter_by_instruments
    if @instruments
      @assorted_users.where(id: UserTag.where(tag: Tag.instrument.where(name: @instruments)).pluck(:user_id))
    else
      []
    end
  end

  def order_by_similarity
    conn = ActiveRecord::Base
    user_ids = @assorted_users.try(:ids) ? @assorted_users.ids : nil
    sql = <<~SQL
      SELECT u.*, COALESCE(matching_tag_counts.n, 0) AS similarity_score
      FROM users AS u
        LEFT OUTER JOIN (
          SELECT user_id, COUNT(*) AS n
          FROM user_tags
          WHERE #{conn.sanitize_sql_array(['tag_id IN(?)', @user.tag_ids])}
          GROUP BY user_id
        ) AS matching_tag_counts ON u.id=matching_tag_counts.user_id
        WHERE #{conn.sanitize_sql_array(['id IN(?)', user_ids])}
        ORDER BY similarity_score DESC
        LIMIT 1000
    SQL

    @assorted_users = User.find_by_sql(sql)
  end
end
