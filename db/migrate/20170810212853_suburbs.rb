class Suburbs < ActiveRecord::Migration
  def change
    create_table :suburbs do |t|
      t.text :name
      t.float :currenttemperature
      t.float :currenthumidity
      t.timestamps null: false
    end

    add_column :homes, :suburb_id, :int
    add_foreign_key :homes, :suburbs
  end
end
