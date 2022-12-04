module GeolocationModule
  def user_distance(other_user)
    if lat && lng && other_user.lat && other_user.lng
      lat1 = other_user.lat
      lng1 = other_user.lng
      lat2 = lat
      lng2 = lng
      GeocodingService.get_distance_between(lat1, lng1, lat2, lng2)
    else
      500
    end
  end

  def is_in_range(other_user, range)
    # range in miles
    user_distance(other_user) <= range
  end

  def users_in_range(users, range)
    miles_away = range

    north_west_most_point = GeocodingService.get_directional_coordinates(lat, lng, miles_away,
                                                                         'north west')
    north_east_most_point = GeocodingService.get_directional_coordinates(lat, lng, miles_away,
                                                                         'north east')
    south_west_most_point = GeocodingService.get_directional_coordinates(lat, lng, miles_away,
                                                                         'south west')
    south_east_most_point = GeocodingService.get_directional_coordinates(lat, lng, miles_away,
                                                                         'south east')

    users.where(
      'lat >= ? AND lat <= ? AND lng >= ? AND lng <= ?',
      south_west_most_point[:new_lat],
      north_west_most_point[:new_lat],
      south_west_most_point[:new_lng],
      south_east_most_point[:new_lng]
    )
  end

  def set_coords_and_location(location_name)
    coords = GeocodingService.find_coords_with_city(location_name)
    update(location: location_name, lat: coords[0], lng: coords[1])
  end
end
