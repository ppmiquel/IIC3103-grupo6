class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :idtrx
      t.integer :monto
      t.string :cuenta_o
      t.string :cuenta_d
      t.string :grupo_o
      t.string :grupo_d
      t.boolean :usada

      t.timestamps null: false
    end
  end
end
