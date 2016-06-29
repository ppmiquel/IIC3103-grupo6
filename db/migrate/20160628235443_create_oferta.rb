class CreateOferta < ActiveRecord::Migration
  def change
    create_table :oferta do |t|
      t.integer :sku
      t.integer :precio
      t.date :inicio
      t.date :fin
      t.string :codigo

      t.timestamps null: false
    end
  end
end
