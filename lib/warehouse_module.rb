module WarehouseModule

  def obtenerIdAlmacenDespacho()
    almacenes = getAlmacenes()
    id = ""
    almacenes.each do |almacen|
      if almacen['despacho'] == true
        id = almacen['_id']
      end
    end
    return id
  end

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

  ##cambiar clave!
  def createHash(data)
    key = 'cd0A9ZK#u#vxES9'
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

  def producirStock(productId, trxId, cantidad)

    hash = createHash('PUT' + productId + cantidad.to_s + trxId )
    return JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).get("http://integracion-2016-dev.herokuapp.com/fabrica/fabricar?sku=" + productId + "&trxId=" + trxId + "&cantidad" + cantidad).to_s)

  end

######PARA B2B
  def moverStockBodega(productId, almacenId, idoc, precio)

    hash = createHash('POST' + productId + almacenId + idoc + precio)
    return JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).get("http://integracion-2016-dev.herokuapp.com/bodega/moverStockBodega?sku=" + productId + "&alamcenId=" + alamcenId + "&oc=" + idoc +"&precio=" + precio).to_s)

  end

  def getCuentaFabrica()

    hash = createHash('GET')
    return JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).get("http://integracion-2016-dev.herokuapp.com/bodega/getCuentaFabrica").to_s)

  end


####SOLO PARA EL CASO DEL CANAL INTERNACIONAL!!!!!!
  def despacharOrden(productId, direccion, precio, idoc)

    hash = createHash('DELETE' + productId + direccion + precio + idoc)
    return JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).delete("http://integracion-2016-dev.herokuapp.com/bodega/stock").to_s, :params => {:productId => productId , :direccion => direccion , :precio => precio , :idoc => idoc })

  end


  def despacharPedido(idoc, productId, cantidad, precio)

    almacenes = getAlmacenes()
    totalDespachados = 0
    idDespacho = obtenerIdAlmacenDespacho()
    almacenes.each do |almacen|
      if almacen['despacho'] == true
        productos = getProductStock2(alamcenId['_id'],productId)
        productos.each do |producto|
          if(totalDespachados < cantidad.to_i)
            ordendespachado = despacharOrden(productId,"a",precio,idoc)
            totalDespachados += 1
          end
        end
      end
    end
  end

  def despacharB2B(idoc, productId, cantidad, precio, almacenId)

    almacenes = getAlmacenes()
    totalDespachados = 0

    almacenes.each do |almacen|
      if almacen['despacho'] == true
        productos = getProductStock2(alamcenId['_id'],productId)
        productos.each do |producto|
          if(totalDespachados < cantidad.to_i)
            moverStockBodega(producto['_id'],alamcenId.to_s,idoc,precio)
            totalDespachados += 1
          end
        end
      end
    end
  end


#Metodos de Produccion##

def producirArroz(lote)

  lotes = lote.to_i
  cantidad = lote*1000
  precioArroz = 1286*cantidad
  productId = 13
  trxId = pagarProduccion(precioArroz)
  producirStock(productId,trxId,cantidad)

end

def producirAzucar(lote)

  lotes = lote.to_i
  cantidad = lote*560
  precioArroz = 782*cantidad
  productId = 25
  trxId = pagarProduccion(precioArroz)
  producirStock(productId,trxId,cantidad)

end


def pagarProduccion(precio)

  cuenta = getCuentaFabrica()
  idCuenta = cuenta['cuentaId']
  # Metodo transferir Banco
  #trx = transferir(precio,'572aac69bdb6d403005fb053',idCuenta)
  #trxId = trx['_id']
  # return trxId
end

end
