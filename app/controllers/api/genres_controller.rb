class Api::GenresController < ApplicationController
  resource_description do
    short 'Station\'s Classic/Popular Genres'
    formats ['json']

    description <<-DESC

    Provide a handy list of classic, popular genres (i.e. categories) to use
    with Station search by genre

    DESC
  end

  api :GET, '/genres', 'Get a list of classic categories and subcategories for use station search by genre'
  description <<-DESC
  ### Example
      {
        "genres": {
          "news": [
            "local",
            "politics",
            "economics"
          ],
          "sport": [
            "curling",
            "handball",
            "rubgy"
          ],
          "chillout": [
            "ambiant",
            "dub",
            "chillstep"
          ]
        }
      }
  DESC
  def index
    render json: {
      genres: {
        test: [
          'trance',
          'news',
          'choucroute'
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
  ### Example
      {
        "genres": [
          "popular_genre1",
          "popular_genre2"
        ]
      }
  DESC
  def popular
    render json: { genres: ['popular_genre1', 'popular_genre2'] }
  end

end
