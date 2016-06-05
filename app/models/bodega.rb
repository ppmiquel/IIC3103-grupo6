
class Bodega < ActiveRecord::Base

  def self.getStock(id)
  	stock = getProductStock(id)
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
      return JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).get("http://integracion-2016-dev.herokuapp.com/bodega/almacenes").to_s)
    end

    ##cambiar clave!
    #OK#OK
    def self.createHash(data)
      key = 'cd0A9ZK#u#vxES9'
      hmac = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'),key,data)
      hash = Base64.encode64(hmac).chomp
      return hash
    end

    def self.getProductsWithStock(almacenId)
      hash = createHash('GET' + almacenId)
      return JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).get("http://integracion-2016-dev.herokuapp.com/bodega/skusWithStock?almacenId=" + almacenId).to_s)
    end


end
