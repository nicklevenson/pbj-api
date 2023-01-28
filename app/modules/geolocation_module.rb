module GeolocationModule
  def users_in_range(users, range)
    approximate_ranged_users = users_in_approximate_range(users, range)
    # only query precisely if below 10000 records
    if approximate_ranged_users.length > 10_000
      approximate_ranged_users
    else
      users_in_precise_range(approximate_ranged_users, range)
    end
  end

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

  # less efficient, but precise range query based on radial calculation from center
  def users_in_precise_range(users, range)
    users.select do |other_user|
      is_in_range(other_user, range)
    end
  end

  # quick approximate query based on a rectangular border bounds
  # increases requested range to cast rectangle that would fit the radial circle
  def users_in_approximate_range(users, range)
    hypotenuse_miles_away = Math.sqrt((range**2) + (range**2))
    miles_away = hypotenuse_miles_away

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
