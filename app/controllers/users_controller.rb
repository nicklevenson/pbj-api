class UsersController < ApplicationController
  before_action :authorized, except: %i[index create show unsubscribe_to_email]
  before_action :set_user, except: %i[index create]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  def create
    user = User.find_or_create_by(uid: auth['uid'], provider: auth['provider']) do |u|
      u.providerImage = auth['info']['image']
      u.username = auth['info']['name']
      u.email = auth['info']['email']
      if auth['credentials']['token']
        u.token = auth['credentials']['token']
        u.refresh_token = auth['credentials']['refresh_token']
      end
    end
    if user
      user.login_count = user.login_count + 1
      # save image whenever its a login - since they can expire
      user.providerImage = auth['info']['image']
      user.fetch_spotify_data
      user.save

      token = encode_token(user_id: user.id)
      if user.login_count === 1
        redirect_to('http://localhost:3001/login' + "?token=#{token}" + "?&id=#{user.id}" + '?&new=true')
      else
        redirect_to('http://localhost:3001/login' + "?token=#{token}" + "?&id=#{user.id}")
      end
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entityå
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  def get_similar_tags
    render json: MultiJson.dump(@user.similar_tags(params[:other_user_id]))
  end

  def get_supporting_info
    similar_tags = @user.similar_tags(params[:other_user_id])
    instruments = @user.instruments.pluck(:name)
    genres = @user.genres.pluck(:name)
    generic_tags = @user.tags.where(tag_type: nil).or(@user.tags.where.not(tag_type: 'spotify_artist'))
    spotify_tags = @user.tags.where(tag_type: 'spotify_artist')

    info = { similar_tags: similar_tags,
             instruments: instruments,
             genres: genres,
             generic_tags: generic_tags,
             spotify_tags: spotify_tags }
    render json: MultiJson.dump(info)
  end

  def get_connected_users
    render json: MultiJson.dump(@user.connected_users, include: :tags)
  end

  def get_recommended_users
    recommendations = @user.recommended_users(recommended_users_params)

    render json: MultiJson.dump(recommendations) if recommendations
  end

  def get_incoming_requests
    render json: MultiJson.dump(@user.incoming_pending_requests)
  end

  def get_user_chatrooms
    @user = User.includes(chatrooms: [{ userchatrooms: :user }, :users, { messages: :user }]).find(params[:id])
    render json: MultiJson.dump(@user.chatrooms, include: [:users, { messages: {
                                  include: [user: { only: %i[username id location photo providerImage] }]
                                } }])
  end

  def get_user_notifications
    render json: MultiJson.dump(@user.notifications)
  end

  def request_connection
    render json: { message: 'Successfully requested' } if @user.request_connection(params[:requested_id])
  end

  def accept_connection
    render json: { message: 'Successfully accepted' } if @user.accept_incoming_connection(params[:requesting_user_id])
  end

  def reject_connection
    render json: { message: 'Successfully rejected' } if @user.reject_incoming_connection(params[:requesting_user_id])
  end

  def reject_user
    render json: { message: 'Successfully rejected' } if @user.reject_user(params[:rejected_id])
  end

  def upload_photo
    req = Cloudinary::Uploader.upload(
      params[:photo],
      public_id: @user.id + @user.uid.to_i,
      crop: :fill, width: 500, height: 500,
      format: 'jpg',
      gravity: :face
    )
    if req['url']
      @user.photo = req['url']
      @user.save
      render json: { message: 'Successful upload' }
    else
      render json: { message: 'Bad Upload' }, status: :unprocessable_entity
    end
  end

  def unsubscribe_to_email
    @user.email_subscribe = false
    @user.save
    redirect_to('http://localhost:3001/unsubscribed')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.

  def user_params
    params.require(:user).permit(
      :email, :username,
      :bio, :location, :lat, :lng,
      :spotify_link, :soundcloud_link, :bandcamp_link, :youtube_link, :apple_music_link, :instagram_link,
      tags_attributes: %i[name tag_type uri image_url link],
      genres_attributes: [:name], instruments_attributes: [:name]
    )
  end

  def recommended_users_params
    params.require(:filterParamsObject).permit(:noFilter, :mileRange, { instruments: [] }, { genres: [] })
  end

  def auth
    request.env['omniauth.auth']
  end
end
