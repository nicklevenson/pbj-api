class TagsController < ApplicationController
  def instruments_and_genres
    instruments = Tag.instrument.pluck(:name)
    genres = Tag.genre.pluck(:name)

    render json: {
      instruments: instruments,
      genres: genres
    }
  end
end
