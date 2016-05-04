require 'warehouse_module'

class WarehouseController < ApplicationController

  include WarehouseModule

  def consultar
    id = params[:sku]
    stock = getProductStock(id)
    response = { :stock => stock, :sku => id}
    render :json => response
  end

end