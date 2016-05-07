class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :idgrupo
      t.integer :numero
      t.string :cuenta
      t.boolean :importa
      t.string :sku1
      t.string :sku2
      t.string :sku3
      t.string :sku4
      t.string :sku5
      t.string :sku6

      t.timestamps null: false
    end
  end
end
