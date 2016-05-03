
module WarehouseModule

  def getProductStock(productId)

    stock = 0
    almacenes = getAlmacenes()

    almacenes.each do |almacen|
      skus = getProductsWithStock(almacen['_id'])

      skus.each do |sku|
        if(sku["_id"] == productId)
          stock = stock + sku["total"]
        end
      end
    end

    return stock

  end

end