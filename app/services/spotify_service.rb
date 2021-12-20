class SpotifyService
  def fetch_spotify_data
    if provider === 'spotify'
      refresh_spotify_token
      header = {
        Authorization: "Bearer #{token}"
      }
      resp = RestClient.get('https://api.spotify.com/v1/me/top/artists', header)
      items = JSON.parse(resp)['items']
      if items[0]
        remove_old_spotify_tags
        items.each do |i|
          name = i['name']
          tag = Tag.find_or_create_by(name: name)
          tag.tag_type = 'spotify_artist'
          tag.image_url = i['images'][0]['url']
          tag.link = i['href']
          tag.uri = i['uri']
          tag.save
          tags << tag
        end
      end
    end
  end

  def remove_old_spotify_tags
    tags = self.tags.where(tag_type: 'spotify_artist')
    tags.each do |t|
      self.tags.delete(t)
    end
  end

  def refresh_spotify_token
    body = {
      grant_type: 'refresh_token',
      refresh_token: refresh_token,
      client_id: Rails.application.credentials.spotify[:client_id],
      client_secret: Rails.application.credentials.spotify[:client_secret]
    }

    resp = RestClient.post('https://accounts.spotify.com/api/token', body)
    json = JSON.parse(resp)
    self.token = json['access_token']
  end
end
