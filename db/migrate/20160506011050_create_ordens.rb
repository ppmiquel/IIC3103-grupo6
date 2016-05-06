class CreateOrdens < ActiveRecord::Migration
  def change
    create_table :ordens do |t|
      t.string :idoc
      t.string :canal
      t.string :cliente
      t.string :sku
      t.integer :cantidad
      t.integer :precio
      t.integer :fecha_entrega
      t.string :idtrx
      t.string :idfact

      t.timestamps null: false
    end
  end
end
