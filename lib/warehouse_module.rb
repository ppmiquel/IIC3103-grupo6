require 'bank_module'

module WarehouseModule



include BankModule

#OK#OK
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

#OK#OK:)
def getProductStock(sku)
    stock = 0
    almacenes = getAlmacenes()
    almacenes.each do |almacen|
      products = getProductsWithStock(almacen['_id'])
      products.each do |product|
        if(product["_id"] == sku)
          stock = stock + product["total"]
        end
      end
    end
    return stock
  end


#OK#OK
  def getAlmacenes
    hash = createHash('GET')
    return JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).get( $heroku_url + "bodega/almacenes").to_s)
  end

  ##cambiar clave!
  #OK#OK
  def createHash(data)
    key = $hash_key
    hmac = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'),key,data)
    hash = Base64.encode64(hmac).chomp
    return hash
  end


#OK#OK
  def getProductsWithStock(almacenId)
    hash = createHash('GET' + almacenId)

    return JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).get($heroku_url + "bodega/skusWithStock?almacenId=" + almacenId).to_s)
  end

#OK#OK
  def getStock(sku, almacenId)
    hash = createHash('GET' + almacenId + sku)
    return JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).get($heroku_url + "bodega/stock?almacenId=" + almacenId + "&sku=" + sku + "&limit=100").to_s)

  end

#OK#OK
  def moverStock(productoId, almacenId)
    hash = createHash('POST' + productoId + almacenId)
    return JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).post($heroku_url + "bodega/moveStock", :json => {:productoId => productoId, :almacenId => almacenId}))
 end


#OK#OK
  def producirStock(sku, trxId, cantidad)
    hash = createHash('PUT' + sku + cantidad.to_s + trxId )
    return JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).put($heroku_url + "bodega/fabrica/fabricar", :json => {:sku => sku ,:trxId => trxId, :cantidad => cantidad}).to_s, :symbolize_names => true)
  end

######PARA B2B
#OK#
  def moverStockBodega(sku, almacenId, idoc, precio)
    hash = createHash('POST' + sku + almacenId + idoc + precio)
    return JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).post($heroku_url + "bodega/moveStockBodega", :json => {:productoId=> productoId,:almacenId=> almacenId, :oc=>idoc, :precio=> precio}))
  end



#OK#OK
  def getCuentaFabrica()
    hash = createHash('GET')

    cuenta = JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).get($heroku_url + "bodega/fabrica/getCuenta").to_s)
    return cuenta['cuentaId']
  end


#OK#OK
####SOLO PARA EL CASO DEL CANAL INTERNACIONAL!!!!!!
  def despacharStock(productoId, direccion, precio, idoc)
    hash = createHash('DELETE' + productoId + direccion + precio.to_s + idoc)
    return JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).delete($heroku_url + "bodega/stock", :json => {:productoId => productoId , :direccion => direccion , :precio => precio , :oc => idoc}), :symbolize_names => true)
  end



  def despacharPedido(idoc, sku, cantidad, precio)
    almacenes = getAlmacenes()
    totalDespachados = 0
    idDespacho = $idDespacho
    moverInsumo(sku,cantidad)
    almacenes.each do |almacen|
      if almacen['despacho'] == true
        productos = getStock(sku, almacen['_id'])
        productos.each do |producto|
          if(totalDespachados < cantidad.to_i)
            ordendespachado = despacharStock(producto['_id'],"internacional",precio,idoc)
            totalDespachados += 1
            for i in 1..500000
              puts "despachados"+ totalDespachados.to_s
            end
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
        productos = getStock(alamcenId['_id'],productId)
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

#OK#OK
def producirArroz(lote)
  lotes = lote.to_i
  cantidad = lote*1000
  precioArroz = 1286*cantidad
  sku = '13'
  trxId = pagarProduccion(precioArroz)
  puts ("sku:" + sku)
  puts ("trx:" + trxId)
  # puts (cantidad)
  response = producirStock(sku,trxId,cantidad)

end


#OK#OK
def producirAzucar(lote)
  lotes = lote.to_i
  cantidad = lote*560
  precioAzucar = 782*cantidad
  sku = '25'
  trxId = pagarProduccion(precioAzucar)
  response = producirStock(sku,trxId,cantidad)

end

def getMiCuenta
  return $idBanco
end



#OK
def pagarProduccion(precio)
  cuenta = getCuentaFabrica()
  # Metodo transferir Banco
  trx = transferir(precio, $idBanco, cuenta)
	trxId = trx[:_id]
  return trxId
end



#OKOK
def moverInsumo(sku,cantidad)
	almacenes = getAlmacenes()
  movidos = 0
  #cambiado:)
  idDespacho = $idDespacho
  almacenes.each do |almacen|
    if almacen['despacho'] == false
      productos = getStock(sku, almacen['_id'])
      productos.each do |producto|
        if(movidos < cantidad.to_i)
          moverStock(producto['_id'],idDespacho)
					movidos = movidos +1
          for i in 1..500000
            puts "movidos a despacho:" + movidos.to_s
          end
        end
      end
    end
  end
end

# def producirPanIntegral(lote)
#
#   moverInsumo('52',500)
#   moverInsumo('26',63)
#   moverInsumo('38',250)
#   moverInsumo('7',651)
#   cantidad = lote*620
#   precioPanIntegral = 2632*cantidad
#   sku = '53'
#   trxId = pagarProduccion(precioPanIntegral)
#   producirStock(sku,trxId,cantidad)
# end


# def producirCerealArroz(lote)
#
#   moverInsumo('25',360)
#   moverInsumo('20',350)
#   moverInsumo('13',290)
#   cantidad = lote*1000
#   precioCerealArroz = 2184*cantidad
#   sku = '17'
#   trxId = pagarProduccion(precioCerealArroz)
#   producirStock(sku,trxId,cantidad)
# end

# def materialesPanIntegral(lote)
#
#   lotes = lote.to_i
#   harina = getProductStock('52')
#   sal = getProductStock('26')
#   semillas = getProductStock('38')
#   leche = getProductStock('7')
#
#   hayHarina = false
#   haySal = false
#   haySemillas = false
#   hayLeche = false
#   if(harina >= 500*lotes)
#     hayHarina = true
#   end
#   if(sal >= 63*lotes)
#     haySal = true
#   end
#   if(semillas >= 250*lotes)
#     haySemillas = true
#   end
#   if(leche >= 651*lotes)
#     hayLeche = true
#   end
#
#   return JSON.parse({:harina => hayHarina, :sal => haySal, :semillas => haySemillas, :leche => hayLeche})
#
# end

# def materialesCerealArroz(lote)
#
#   lotes = lote.to_i
#   azucar = getProductStock('25')
#   cacao = getProductStock('20')
#   arroz = getProductStock('13')
#
#   hayAzucar = false
#   hayCacao = false
#   hayArroz = false
#   if(azucar >= 360*lotes)
#     hayAzucar = true
#   end
#   if(cacao >= 350*lotes)
#     hayCacao = true
#   end
#   if(arroz >= 290*lotes)
#     hayArroz = true
#   end
#
#   return JSON.parse({:azucar => hayAzucar, :cacao => hayCacao, :arroz => hayArroz})
# end

# def mandarProducirArroz()
#
#   arroz = getProductStock('13')
#   if(arroz < 5000)
#     cantidad = 5000 - arroz
#     lote = cantidad/1000
#     producirArroz(lote)
#   end
# end
#
# def mandarProducirAzucar()
#
#   azucar = getProductStock('25')
#   if(azucar < 5000)
#     cantidad = 5000 - azucar
#     lote = cantidad/560
#     producirAzucar(lote)
#   end
# end

# def mandarProducirPanIntegral()
#
#   panIntegral = getProductStock('53')
#   if(panIntegral <= 5000)
#     cantidad = 5000 - panIntegral
#     lote = cantidad/620
#     materiales = materialesPanIntegral(lote)
#     if(materiales['harina']&&materiales['sal']&&materiales['semillas']&&materiales['leche'])
#       producirPanIntegral(lote)
#     end
#     if(materiales['harina'] == false)
#       ##Comprar harina
#     end
#     if(materiales['sal'] == false)
#       ##Comprar sal
#     end
#     if(materiales['semillas'] == false)
#       ##Comprar semillas
#     end
#     if(materiales['leche'] == false)
#       ##Comprar leche
#     end
#   end
# end

# def mandarProducirCerealArroz()
#
#   cerealArroz = getProductStock('17')
#   if(cerealArroz <= 5000)
#     cantidad = 5000 - cerealArroz
#     lote = cantidad/1000
#     materiales = materialesCerealArroz(lote)
#     if(materiales['azucar']&&materiales['cacao']&&materiales['arroz'])
#       producirCerealArroz(lote)
#     end
#     if(materiales['cacao'] == false)
#       ##Comprar cacao
#     end
#   end
# end

## Metodos ordenar bodegas##

def vaciarBodegaPulmon()

  productosPulmon = getProductsWithStock($idPulmon)
  i=0
  if(productosPulmon.size() > 0)
    productosPulmon.each do |productos|
      productId = productos['_id']
stockProducto = getStock(productId,$idPulmon)
      stockProducto.each do |stock|
        movido = false
        almacenes = getAlmacenes()
        # puts i
        almacenes.each do |almacen|
          if(almacen['_id']==$idPrincipal && almacen['totalSpace'] > almacen['usedSpace'] && movido ==false)
            moverss = moverStock(stock['_id'], $idPrincipal)
            movido = true
            i +=1
            for j in 1..100000
              puts "movidos a despacho:" + i.to_s
            end
          elsif(almacen['_id']==$idPrincipal2 && almacen['totalSpace'] > almacen['usedSpace'] && movido ==false)
            moverss = moverStock(stock['_id'], $idPrincipal2)
            movido = true
            i +=1
            for j in 1..100000
              puts "movidos a despacho:" + i.to_s
            end
          end
        end
      end
    end
  end
end

def vaciarBodegaRecepcion()

  productosRecepcion = getProductsWithStock($idRecepcion)
  if(productosRecepcion.size() > 0)
    productosRecepcion.each do |productos|
      productId = productos['_id']

      stockProducto = getStock(productId,$idRecepcion)
      stockProducto.each do |stock|

        movido = false
        almacenes = getAlmacenes()
        almacenes.each do |almacen|
           if(almacen['_id']==$idPrincipal && almacen['totalSpace'] > almacen['usedSpace'] && movido == false)
             moverss = moverStock(stock['_id'], $idPrincipal)
             movido = true
          elsif(almacen['_id']==$idPrincipal2 && almacen['totalSpace'] > almacen['usedSpace'] && movido == false)
            moverss = moverStock(stock['_id'], $idPrincipal2)
            movido = true
          end
        end
      end
    end
  end
end
end
