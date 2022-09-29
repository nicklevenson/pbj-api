module SpotifyModule
  def fetch_and_store_spotify_tags
    if provider == 'spotify'
      items = fetch_spotify_data
      if items.present?
        # remove_old_spotify_tags
        items.each do |i|
          tag_attributes = {
            name: i['name'],
            kind: Tag::KIND_MAPPINGS[:spotify],
            image_url: i['images'][0]['url'],
            link: i['href'],
            uri: i['uri']
          }
          tag = Tag.find_or_create_by(tag_attributes)
          tags << tag unless tags.include?(tag)
        end

        save
      end
    end
  end

  def fetch_spotify_data
    refresh_spotify_token
    header = {
      Authorization: "Bearer #{token}"
    }
    resp = RestClient.get('https://api.spotify.com/v1/me/top/artists', header)
    JSON.parse(resp)['items']
  end

  def remove_old_spotify_tags
    tags = self.tags.where(kind: Tag::KIND_MAPPINGS[:spotify])
    tags.destory_all
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
    update(token: json['access_token'])
  end
end
