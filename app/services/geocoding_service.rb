class GeocodingService
  def self.get_distance_between(lat1, lng1, lat2, lng2)
    earth_radius = 3958.8

    dLat = degrees_to_radius(lat2 - lat1)
    dLng = degrees_to_radius(lng2 - lng1)

    a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(degrees_to_radius(lat1)) * Math.cos(degrees_to_radius(lat2)) *
        Math.sin(dLng / 2) * Math.sin(dLng / 2)

    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

    earth_radius * c
  end

  def self.degrees_to_radius(deg)
    deg * (Math::PI / 180)
  end

  def self.find_coords_with_city(location)
    location = location.split(' ').join('&')
    resp = RestClient.get("https://api.mapbox.com/geocoding/v5/mapbox.places/#{location}.json?access_token=#{Rails.application.credentials.mapbox[:key]}")
    coords = JSON.parse(resp)['features'][0]['center'].reverse
  end
end
