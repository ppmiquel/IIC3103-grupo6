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
  def getAlmacenes

    hash = createHash('GET')

    return JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).get("http://integracion-2016-dev.herokuapp.com/bodega/almacenes").to_s)

  end
  def createHash(data)
    key = 'zHHatno@hjie%xU'
    hmac = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'),key,data)
    hash = Base64.encode64(hmac).chomp
    return hash
  end

  def getProductsWithStock(almacenId)

    hash = createHash('GET' + almacenId)
    return JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).get("http://integracion-2016-dev.herokuapp.com/bodega/skusWithStock?almacenId=" + almacenId).to_s)

  end

  def getProductStock2(productId, almacenId)

    hash = createHash('GET' + almacenId + productId)
    return JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).get("http://integracion-2016-dev.herokuapp.com/bodega/stock?almacenId=" + almacenId + "&sku=" + productId + "&limit=100").to_s)

  end

  def moverStock(productId, almacenId)

    hash = createHash('POST' + productId + almacenId)
    return JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).get("http://integracion-2016-dev.herokuapp.com/bodega/moverStock?sku=" + productId + "&alamcenId=" + alamcenId + "&limit=100").to_s)

  end

  def moverStockBodega(productId, almacenId)

    hash = createHash('POST' + productId + almacenId)
    return JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).get("http://integracion-2016-dev.herokuapp.com/bodega/moverStockBodega?sku=" + productId + "&alamcenId=" + alamcenId + "&limit=100").to_s)

  end

  def getCuentaFabrica()

    hash = createHash('GET')
    return JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).get("http://integracion-2016-dev.herokuapp.com/bodega/getCuentaFabrica").to_s)

  end
end
