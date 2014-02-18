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
    genres = YAML::load_file Rails.root.join('config', 'genres.yml')
    puts genres.inspect
    render json: { genres: genres }
  end

  api :GET, '/genres/popular', 'Get a list of popular categories and subcategories for use station search by genre'
  description <<-DESC

  This calls returns a list of popular genres. While this is still unimpleted,
  this call will return a daily computed list of the most active
  genres/subgenres on the directory not yet included in the /genres.json list.

  DESC
  see "stations_search#genre"
  def popular
    render json: {

      genres: ["pop", "rock", "various", "dance", "misc", "alternative",
      "christian", "oldies", "talk", "radio", "house", "electronic", "gospel",
      "80s", "jazz", "top", "folk", "news", "classical", "40", "techno",
      "classic", "reggae", "latin", "music", "rap", "metal", "country", "and",
      "90s", "trance", "hop", "blues", "soul", "hip", "b", "disco", "70s", "r",
      "adult", "electro", "easy", "listening", "contemporary", "hits", "greek",
      "ambient", "top40", "indie", "world", "urban", "college", "public",
      "funk", "schlager", "lounge", "new", "salsa", "60s", "sports", "decades",
      "hard", "rnb", "mixed", "punk", "bass", "discofox", "international",
      "old", "drum", "progressive", "electronica", "smooth", "hardcore",
      "christmas", "age", "community", "chillout", "dancehall", "dubstep",
      "european", "club", "mix", "downtempo", "comedy", "live", "chill",
      "reggaeton", "cumbia", "tamil", "eclectic", "hiphop", "soft", "scanner",
      "latino", "spiritual", "s", "minimal", "industrial", "charts", "n/a",
      "zouk", "time", "gothic", "deep", "inspirational", "modern", "goth",
      "bachata", "anime", "dub", "80", "regional", "wave", "arabic", "african",
      "heavy", "the", "best", "musica", "50s", "southern", "retro",
      "unspecified", "jungle", "of", "breakbeat", "jpop", "tech", "y", "manele",
      "italo", "merengue", "soca", "americana", "-", "hit", "r&b", "classics",
      "narodna", "roots", "psychedelic", "bollywood", "ska", "ac", "romantica",
      "garage", "game", "&", "ebm", "asian", "video", "religious", "latina",
      "hardstyle", "caribbean", "other", "school", "slow", "underground", "00s",
      "dnb", "soundtracks", "polskie", "tejano", "swing", "political", "all",
      "black", "love", "genre", "kpop", "russian", "big", "polska", "songs",
      "90", "70", "worship", "nederlands", "edm", "acid", "spoken", "populara",
      "romantic", "volksmusik", "instrumental", "mexican", "eurodance",
      "tropical", "hot", "adulto", "breaks", "la", "banda", "polka", "trip",
      "mainstream", "zabavna", "meditation", "indian", "dj", "experimental",
      "more", "word", "bluegrass", "roll", "party", "catholic", "educational",
      "chr", "holiday", "soulful", "tango", "rockabilly", "celtic", "post",
      "dark", "hindi", "band", "de", "motown", "80er", "piraten", "turkce",
      "praise", "n", "60", "brazilian", "local", "jrock", "mexicano", "variety",
      "fox", "popschlager", "etno", "hrvatska", "fm", "greece", "folklore",
      "italy", "sermons", "information", "darkwave", "fusion", "prog", "amp",
      "pinoy", "services", "religion", "filipino", "traditional", "turkish",
      "out", "90er", "80's", "up", "varios", "vocal", "demo", "100", "light",
      "goa", "idm", "italian", "funky", "neo", "teaching", "work", "/", "nu",
      "remix", "oldskool", "default", "hip-hop", "grunge", "spanish", "trap",
      "western", "querbeet", "space", "bossa", "sport", "kompa", "japanese",
      "afrikaans", "musique", "dancepunk", "irish", "cool", "station", "groove",
      "xmas", "today", "opera", "power", "storm", "themes", "quiet", "croatia",
      "gold", "piano", "britpop", "italia", "korean", "french", "hands",
      "islamic", "freestyle", "a", "remixes", "alt", "politics", "health",
      "corporation", "broadcasting", "australian", "100%", "promodj", "baladas",
      "beat", "laika", "mixtapes", "independent", "oldschool", "euro", "in",
      "synthpop", "i", "und", "entertainment", "generaliste", "24", "album",
      "40s", "npr", "speech", "ranchera", "british", "eska", "medicine",
      "france", "(null)", "deutschrock", "free", "seasonal", "south",
      "tropicalia", "contemporaneo", "deephouse"]
    }
  end

end
