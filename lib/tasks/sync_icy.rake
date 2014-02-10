namespace :sync do
  desc "Update station and streams according to data returned from IcyHeaders. rake sync:icy STATIONS='Station.all'"
  task icy: :environment do
    puts "Station selection expression => #{ENV['STATIONS']}"
    stations = eval ENV['STATIONS']

    stations.each do |station|
      puts "Launching updater for Station : #{station.slug}"
      updater = IcyUpdater.new(station)
      updater.update!
    end
  end
  end
