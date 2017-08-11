namespace :geographic_area do
  desc 'TODO'
  task get_wunderground_data: :environment do
    Suburb.all.each do |s|
      response = Faraday.get "http://api.wunderground.com/api/de9de20a26d90cbd/conditions/q/NZ/#{s.name}.json"

      data = JSON.parse(response.body)

      next if data['response']['error']
      next unless data['current_observation']

      s.currenttemperature = data['current_observation']['temp_c']
      s.currenthumidity = data['current_observation']['relative_humidity']

      s.save
    end
  end
end
