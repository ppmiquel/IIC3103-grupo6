require 'bank_module'

module WarehouseModule

include BankModule


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
  trx = transferir(precio,'572aac69bdb6d403005fb053',idCuenta)
  trxId = trx['_id']
  return trxId
end

def moverInsumo(productId,cantidad)

  almacenes = getAlmacenes()
  movidos = 0
  idDespacho = obtenerIdAlmacenDespacho()
  almacenes.each do |almacen|
    if almacen['despacho'] == false
      productos = getProductStock2(alamcenId['_id'],productId)
      productos.each do |producto|
        if(movidos < cantidad.to_i)
          moverStock(producto['_id'],despacho)
        end
      end
    end
  end
end

def producirPanIntegral(lote)

  moverInsumo(52,500)
  moverInsumo(26,63)
  moverInsumo(38,250)
  moverInsumo(7,651)
  cantidad = lote*620
  precioPanIntegral = 2632*cantidad
  productId = 53
  trxId = pagarProduccion(precioPanIntegral)
  producirStock(productId,trxId,cantidad)
end


def producirCerealArroz(lote)

  moverInsumo(25,360)
  moverInsumo(20,350)
  moverInsumo(13,290)
  cantidad = lote*1000
  precioCerealArroz = 2184*cantidad
  productId = 17
  trxId = pagarProduccion(precioCerealArroz)
  producirStock(productId,trxId,cantidad)
end

def materialesPanIntegral(lote)

  lotes = lote.to_i
  harina = getProductStock(52)
  sal = getProductStock(26)
  semillas = getProductStock(38)
  leche = getProductStock(7)

  hayHarina = false
  haySal = false
  haySemillas = false
  hayLeche = false
  if(harina >= 500*lotes)
    hayHarina = true
  end
  if(sal >= 63*lotes)
    haySal = true
  end
  if(semillas >= 250*lotes)
    haySemillas = true
  end
  if(leche >= 651*lotes)
    hayLeche = true
  end

  return JSON.parse({:harina => hayHarina, :sal => haySal, :semillas => haySemillas, :leche => hayLeche})

end

def materialesCerealArroz(lote)

  lotes = lote.to_i
  azucar = getProductStock(25)
  cacao = getProductStock(20)
  arroz = getProductStock(13)

  hayAzucar = false
  hayCacao = false
  hayArroz = false
  if(azucar >= 360*lotes)
    hayAzucar = true
  end
  if(cacao >= 350*lotes)
    hayCacao = true
  end
  if(arroz >= 290*lotes)
    hayArroz = true
  end

  return JSON.parse({:azucar => hayAzucar, :cacao => hayCacao, :arroz => hayArroz})
end

def mandarProducirArroz()

  arroz = getProductStock(13)
  if(arroz < 5000)
    cantidad = 5000 - arroz
    lote = cantidad/1000
    producirArroz(lote)
  end
end

def mandarProducirAzucar()

  azucar = getProductStock(25)
  if(azucar < 5000)
    cantidad = 5000 - azucar
    lote = cantidad/560
    producirAzucar(lote)
  end
end

def mandarProducirPanIntegral()

  panIntegral = getProductStock(53)
  if(panIntegral <= 5000)
    cantidad = 5000 - panIntegral
    lote = cantidad/620
    materiales = materialesPanIntegral(lote)
    if(materiales['harina']&&materiales['sal']&&materiales['semillas']&&materiales['leche'])
      producirPanIntegral(lote)
    end
    if(materiales['harina'] == false)
      ##Comprar harina
    end
    if(materiales['sal'] == false)
      ##Comprar sal
    end
    if(materiales['semillas'] == false)
      ##Comprar semillas
    end
    if(materiales['leche'] == false)
      ##Comprar leche
    end
  end
end

def mandarProducirCerealArroz()

  cerealArroz = getProductStock(17)
  if(cerealArroz <= 5000)
    cantidad = 5000 - cerealArroz
    lote = cantidad/1000
    materiales = materialesCerealArroz(lote)
    if(materiales['azucar']&&materiales['cacao']&&materiales['arroz'])
      producirCerealArroz(lote)
    end
    if(materiales['cacao'] == false)
      ##Comprar cacao
    end
  end
end

## Metodos ordenar bodegas##

def vaciarBodegaPulmon()

  #id de Desarrollo#
  idPulmon = '571262aaa980ba030058a2f6'
  idPrincipal = '571262aaa980ba030058a2f5'
  idPrincipal2 = '571262aaa980ba030058a2bd'

  productosPulmon = getProductsWithStock(idPulmon)
  if(productosPulmon.size() > 0)
    productosPulmon.each do |productos|
      productId = productos['_id']
      stockProducto = getProductStock2(productId,idPulmon)
      stockProducto.each do |stock|
        movido = false
        almacenes = getAlmacenes()
        almacenes.each do |almacen|
          if(almacen['_id']=idPrincipal && almacen['totalSpace'] > almacen['usedSpace'] && movido = false)
            moverStock(stock['_id'],idPrincipal)
            movido = true
          elsif(almacen['_id']=idPrincipal2 && almacen['totalSpace'] > almacen['usedSpace'] && movido = false)
            moverStock(stock['_id'],idPrincipal2)
            movido = true
          end
        end
      end
    end
  end
end

def vaciarBodegaRecepcion()

  #id de Desarrollo#
  idPulmon = '571262aaa980ba030058a2f6'
  idRecepcion = '571262aaa980ba030058a2bb'
  idPrincipal = '571262aaa980ba030058a2f5'
  idPrincipal2 = '571262aaa980ba030058a2bd'

  productosRecepcion = getProductsWithStock(idRecepcion)
  if(productosRecepcion.size() > 0)
    productosRecepcion.each do |productos|
      productId = productos['_id']
      stockProducto = getProductStock2(productId,idRecepcion)
      stockProducto.each do |stock|
        movido = false
        almacenes = getAlmacenes()
        almacenes.each do |almacen|
          if(almacen['_id']=idPrincipal && almacen['totalSpace'] > almacen['usedSpace'] && movido = false)
            moverStock(stock['_id'],idPrincipal)
            movido = true
          elsif(almacen['_id']=idPrincipal2 && almacen['totalSpace'] > almacen['usedSpace'] && movido = false)
            moverStock(stock['_id'],idPrincipal2)
            movido = true
          elsif(almacen['_id']=idPulmon && almacen['totalSpace'] > almacen['usedSpace'] && movido = false)
            moverStock(stock['_id'],idPulmon)
            movido = true
          end
        end
      end
    end
  end
end
end
