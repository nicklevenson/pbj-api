class GeocodingService
  EARTH_RADIUS = 3963.19

  def self.get_distance_between(lat1, lng1, lat2, lng2)
    dLat = degrees_to_radians(lat2 - lat1)
    dLng = degrees_to_radians(lng2 - lng1)

    a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(degrees_to_radians(lat1)) * Math.cos(degrees_to_radians(lat2)) *
        Math.sin(dLng / 2) * Math.sin(dLng / 2)

    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

    EARTH_RADIUS * c
  end

  def self.get_directional_coordinates(lat, lng, miles_away, direction)
    case direction
    when 'west'
      bearing = 270
      calculate_destination_point(lat, lng, miles_away, bearing)
    when 'east'
      bearing = 90
      calculate_destination_point(lat, lng, miles_away, bearing)
    when 'north'
      bearing = 0
      calculate_destination_point(lat, lng, miles_away, bearing)
    when 'south'
      bearing = 180
      calculate_destination_point(lat, lng, miles_away, bearing)
    end
  end

  def self.calculate_destination_point(lat, lng, miles_away, bearing)
    lat = degrees_to_radians(lat)
    lng = degrees_to_radians(lng)
    angular_distance = miles_away / EARTH_RADIUS
    bearing = degrees_to_radians(bearing)

    lat2 = Math.asin(
      Math.sin(lat) * Math.cos(angular_distance) +
      Math.cos(lat) * Math.sin(angular_distance) * Math.cos(bearing)
    )
    lng2 = lng + Math.atan2(
      Math.sin(bearing) * Math.sin(angular_distance) * Math.cos(lat),
      Math.cos(angular_distance) - Math.sin(lat) * Math.sin(lat2)
    )

    {
      new_lat: radians_to_degrees(lat2),
      new_lng: radians_to_degrees(lng2)
    }
  end

  def self.radians_to_degrees(radians)
    radians * (180 / Math::PI)
  end

  def self.degrees_to_radians(deg)
    deg * (Math::PI / 180)
  end

  def self.find_coords_with_city(location)
    location = location.split(' ').join('&')
    resp = RestClient.get("https://api.mapbox.com/geocoding/v5/mapbox.places/#{location}.json?access_token=#{Rails.application.credentials.mapbox[:key]}")
    coords = JSON.parse(resp)['features'][0]['center'].reverse
  end
end
