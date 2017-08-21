namespace :geographic_area do
  desc 'Tasks for geographic areas'
  task get_wunderground_data: :environment do
    baseurl = 'http://api.wunderground.com/api/'

    Suburb.all.each do |s|
      response = Faraday.get "#{baseurl}#{ENV['WUNDERGROUND_API_KEY']}/conditions/q/NZ/#{s.name}.json"

      data = JSON.parse(response.body)

      next if data['response']['error']
      next unless data['current_observation']

      s.currenttemperature = data['current_observation']['temp_c']
      s.currenthumidity = data['current_observation']['relative_humidity']

      s.save
    end
  end
end
