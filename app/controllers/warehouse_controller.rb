require 'warehouse_module'

class WarehouseController < ApplicationController
  include WarehouseModule

  def consultar
    id = params[:sku]
    product_stock = getProductStock(id)
    response = { :stock => product_stock, :sku => id}
    render :json => response
  end









end