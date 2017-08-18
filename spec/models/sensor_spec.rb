require 'rails_helper'

RSpec.describe Sensor, type: :model do
  let(:sensor) { FactoryGirl.create(:sensor) }

  describe 'sensor is offline' do
    it 'sets offlinenotified to true' do
      expect(sensor.offlinenotified).to eq false
      sensor.set_offline
      expect(sensor.offlinenotified).to eq true
    end
  end
end
