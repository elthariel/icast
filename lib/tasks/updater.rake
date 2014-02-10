namespace :updater do
  desc "Run an Update. rake updater:run UPDATER='IcyUpdater' STATIONS='Station.all'"
  task run: :environment do
    puts "Station selection expression => #{ENV['STATIONS']}"
    puts "Station Updater => #{ENV['UPDATER']}"

    updater_klass = ENV['UPDATER'].constantize
    stations = eval ENV['STATIONS']

    stations.each do |station|
      puts "Launching updater for Station : #{station.slug}"
      updater = updater_klass.new(station)
      updater.update!
    end
  end
end
