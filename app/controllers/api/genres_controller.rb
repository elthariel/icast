class Api::GenresController < ApplicationController
  resource_description do
    resource_id 'genres'
    short 'Station\'s Classic/Popular Genres'
    formats ['json']

    description <<-DESC

    Provide a handy list of classic, popular genres (i.e. categories) to use
    with Station search by genre. We try to keep this list in sync with the
    directory usage. If the are many new radio of a specific subgenre, we
    are likely to add this subgenre here.

    If you want to provide a global overview of the stations availables, you are
    likely to be at the right place. The recommended usage would be to query
    here the list of genre/subgenre, then lazily to use the /stations/genre api
    to get a list of stations for each genre.

    DESC
  end

  api :GET, '/genres', 'Get a list of classic categories and subcategories for use station search by genre'
  description <<-DESC

  This API call returns a list of classic/popular genre and subgenres.

  DESC
  see "stations_search#genre"
  def index
    render json: {
      genres: {
        test: [
          'trance',
          'news',
          'choucroute',
          'pate'
        ],
        news: [
          'local',
          'politics',
          'economics'
          ],
        sport: [
          'curling',
          'handball',
          'rubgy'
          ],
        chillout: [
          'ambiant',
          'dub',
          'chillstep'
        ]
      }
    }
  end

  api :GET, '/genres/popular', 'Get a list of popular categories and subcategories for use station search by genre'
  description <<-DESC

  This calls returns a list of popular genres. While this is still unimpleted,
  this call will return a daily computed list of the most active
  genres/subgenres on the directory not yet included in the /genres.json list.

  DESC
  see "stations_search#genre"
  def popular
    render json: { genres: ['popular_genre1', 'popular_genre2'] }
  end

end
