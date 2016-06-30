
class Bodega < ActiveRecord::Base

  $heroku_url = 'http://integracion-2016-dev.herokuapp.com/'
  $hash_key = 'cd0A9ZK#u#vxES9'
  
  def self.despacharPedido(idoc, sku, cantidad, precio, direccion)
    almacenes = getAlmacenes()
    totalDespachados = 0
    idDespacho = obtenerIdAlmacenDespacho()
    moverInsumo(sku,cantidad)
    almacenes.each do |almacen|
      if almacen['despacho'] == true
        productos = getStock(sku, almacen['_id'])
        productos.each do |producto|
          if(totalDespachados < cantidad.to_i)
            ordendespachado = despacharStock(producto['_id'],direccion,precio,idoc)
            totalDespachados += 1
          end
        end
      end
    end
  end

  def self.moverInsumo(sku,cantidad)
  	almacenes = getAlmacenes()
    movidos = 0
    #cambiado:)
    idDespacho = obtenerIdAlmacenDespacho()
    almacenes.each do |almacen|
      if almacen['despacho'] == false
        productos = getStock(sku, almacen['_id'])
        productos.each do |producto|
          if(movidos < cantidad.to_i)
            moverStock(producto['_id'],idDespacho)
  					movidos = movidos +1
          end
        end
      end
    end
  end

  def self.obtenerIdAlmacenDespacho()
    almacenes = getAlmacenes()
    id = ""
    almacenes.each do |almacen|
      if almacen['despacho'] == true
        id = almacen['_id']
      end
    end
    return id
  end

  def self.moverStock(productoId, almacenId)
    hash = createHash('POST' + productoId + almacenId)
    return JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).post($heroku_url + "bodega/moveStock", :json => {:productoId => productoId, :almacenId => almacenId}))
 end


  def self.despacharStock(productoId, direccion, precio, idoc)
    hash = createHash('DELETE' + productoId + direccion + precio.to_s + idoc)
    return JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).delete($heroku_url + "bodega/stock", :json => {:productoId => productoId , :direccion => direccion , :precio => precio , :oc => idoc}), :symbolize_names => true)
  end

  def self.getTheStock(id)
  	stock = getProductStock(id)
  end

  def self.getStock(sku, almacenId)
    hash = createHash('GET' + almacenId + sku)
    return JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).get($heroku_url + "bodega/stock?almacenId=" + almacenId + "&sku=" + sku + "&limit=100").to_s)
  end

  def self.getProductStock(sku)
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

    def self.getAlmacenes
      hash = createHash('GET')
      return JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).get($heroku_url + "bodega/almacenes").to_s)
    end

    ##cambiar clave!
    #OK#OK
    def self.createHash(data)
      key = $hash_key
      puts data
      hmac = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'),key,data)
      hash = Base64.encode64(hmac).chomp
      return hash
    end

    def self.getProductsWithStock(almacenId)
      hash = createHash('GET' + almacenId)
      return JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).get($heroku_url + "bodega/skusWithStock?almacenId=" + almacenId).to_s)
    end


end
