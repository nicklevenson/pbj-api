class SessionsController < ApplicationController
  def authenticate_google
    redirect_to '/auth/google_oauth2'
  end

  def authenticate_facebook
    redirect_to '/auth/facebook'
  end

  def authenticate_spotify
    redirect_to '/auth/spotify'
  end
end
