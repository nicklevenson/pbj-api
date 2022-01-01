class UsersController < ApplicationController
  # before_action :authorized, except: %i[index create show unsubscribe_to_email]
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
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  def get_supporting_info
    other_user = User.find(params[:other_user_id])
    render json: @user, serializer: SupportingUserInfoSerializer, other_user: other_user
  end

  def get_recommended_users
    recommendations = @user.user_feed(params[:range], params[:instruments], params[:genres])
    render json: recommendations.pluck(:id), root: false
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

  def auth
    request.env['omniauth.auth']
  end
end
