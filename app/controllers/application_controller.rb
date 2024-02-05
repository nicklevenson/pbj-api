class ApplicationController < ActionController::API
  def encode_token(user_id)
    payload = {
      user_id: user_id,
      exp: 7.days.from_now.to_i
    }
    JWT.encode(payload, Rails.application.credentials.jwt[:secret])
  end

  def decode_token(token)
    JWT.decode(token, Rails.application.credentials.jwt[:secret])[0]
  end

  def auth_header
    request.headers['Authorization']
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      begin
        JWT.decode(token, Rails.application.credentials.jwt[:secret], true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def get_user_id
    auth_header.split(' ')[2] if auth_header
  end

  def current_user
    if decoded_token
      user_id = decoded_token[0]['user_id']['user_id']
      user = User.find_by(id: user_id)
    end
  end

  def logged_in?
    !!current_user
  end

  def authorized
    unless logged_in? && current_user.id === get_user_id.to_i
      render json: { message: 'Please Login',
                     status: :unauthorized }
    end
  end

  def authenticate
    redirect_to '/auth/google_oauth2'
  end
end
