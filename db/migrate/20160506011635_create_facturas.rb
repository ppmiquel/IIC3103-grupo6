class CreateFacturas < ActiveRecord::Migration
  def change
    create_table :facturas do |t|
      t.string :idfact
      t.string :cliente
      t.string :proveedor
      t.integer :valor_bruto
      t.integer :iva
      t.string :estado
      t.string :idoc
      t.string :idtrx

      t.timestamps null: false
    end
  end
end
