Rails.application.config.middleware.use OmniAuth::Builder do
  OmniAuth.config.allowed_request_methods = %i[post get]
  provider :google_oauth2, Rails.application.credentials.google[:client_id],
           Rails.application.credentials.google[:client_secret]
  provider :facebook, Rails.application.credentials.facebook[:app_id],
           Rails.application.credentials.facebook[:app_secret]
  provider :spotify, Rails.application.credentials.spotify[:client_id], Rails.application.credentials.spotify[:client_secret], scope: %w[
    playlist-read-private
    user-read-private
    user-read-email
    user-top-read
  ].join(' ')
end
