class UsersController < ApplicationController
  # before_action :authorized, except: %i[index create show unsubscribe_to_email]
  before_action :set_user, except: %i[create]

  def show
    render json: @user, root: false
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
      user.update(
        login_count: user.login_count + 1,
        providerImage: auth['info']['image']
      )

      user.fetch_and_store_spotify_tags

      token = encode_token(user_id: user.id)

      if user.login_count === 1
        redirect_to('http://localhost:3001/login' + "?token=#{token}" + "?&id=#{user.id}" + '?&new=true')
      else
        redirect_to('http://localhost:3001/login' + "?token=#{token}" + "?&id=#{user.id}")
      end
    end
  end

  def update
    if @user.update(user_params)
      render json: { success: true }, root: false
    else
      render json: { success: false, errors: @user.errors }, status: :unprocessable_entity
    end
  end

  def get_supporting_info
    other_user = User.find(params[:other_user_id])
    render json: @user, serializer: SupportingUserInfoSerializer, other_user: other_user
  end

  def get_recommended_users
    recommendations = @user.user_feed(params[:range]&.to_i, params[:instruments], params[:genres])
    render json: recommendations.pluck(:id), root: false
  end

  def get_user_notifications
    render json: MultiJson.dump(@user.notifications)
  end

  def request_connection
    if @user.request_connection(params[:requested_id])
      other_user = User.find(params[:requested_id])
      render json: @user, serializer: SupportingUserInfoSerializer, other_user: other_user
    end
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
      :crop => :fill, :width => 200, :height => 200, 
      format: 'jpg', 
      :gravity => :face)
    if req["url"]
      @user.photo = req["url"]
      @user.save
      render json: {message: "Successful upload"}
    else
      render json: {message: "Bad Upload"}, status: :unprocessable_entity
    end
  end

  def unsubscribe_to_email
    @user.email_subscribe = false
    @user.save
    redirect_to('http://localhost:3001/unsubscribed')
  end

  def update_tag
    if params[:update_type] == 'add'
      tag = Tag.find_or_create_by(name: params[:name], kind: Tag::KIND_MAPPINGS[params[:kind].to_sym])
      @user.tags << tag unless @user.tags.include?(tag)
      @user.save
    elsif params[:update_type] == 'remove'
      @user.tags.delete(Tag.find_by(name: params[:name], kind: Tag::KIND_MAPPINGS[params[:kind].to_sym]))
      @user.save
    end

    render json: @user, root: false
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
      social_links_attributes: %i[type url],
      tags_attributes: %i[name tag_type uri image_url link],
      genres_attributes: [:name], instruments_attributes: [:name]
    )
  end

  def auth
    request.env['omniauth.auth']
  end
end
