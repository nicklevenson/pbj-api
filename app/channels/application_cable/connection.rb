module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected
  
    def find_verified_user
      if current_user = decoded_user
        current_user
      else
        reject_unauthorized_connection
      end
    end

    def decoded_token
      if request.params[:token]
        token = request.params[:token]
        begin
          JWT.decode(token, Rails.application.credentials.jwt[:secret], true, algorithm: 'HS256')
        rescue JWT::DecodeError
          nil
        end
      end
    end

    def decoded_user
      if decoded_token
        user_id = decoded_token[0]['user_id']
        user = User.find_by(id: user_id)
      end
    end
  end
end
