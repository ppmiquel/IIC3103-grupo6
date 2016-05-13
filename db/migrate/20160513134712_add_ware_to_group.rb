class AddWareToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :warehouse, :string
  end
end
