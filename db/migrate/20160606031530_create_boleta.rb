class CreateBoleta < ActiveRecord::Migration
  def change
    create_table :boleta do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.string :cliente
      t.string :proveedor
      t.integer :bruto
      t.integer :iva
      t.integer :total
      t.string :oc
      t.string :id_boleta
      t.string :estado

      t.timestamps null: false
    end
  end
end
