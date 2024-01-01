class TagsController < ApplicationController
  def index
    instruments = Tag.instrument.pluck(:name)
    genres = Tag.genre.pluck(:name)
    generic = Tag.generic.pluck(:name)

    render json: {
      instruments: instruments,
      genres: genres,
      generic: generic
    }
  end
end
