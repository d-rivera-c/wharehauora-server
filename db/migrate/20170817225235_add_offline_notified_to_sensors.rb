class AddOfflineNotifiedToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :offlinenotified, :boolean, null: false, default: false
  end
end
