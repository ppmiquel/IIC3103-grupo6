require "http"
require "base64"
require "cgi"
require "openssl"
require "json"


class WelcomeController < ApplicationController
	def index
		
  		puts getProductStock('13')

	end


	def createHash(data)
		key = 'cd0A9ZK#u#vxES9'
		hmac = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'),key,data)
	  	hash = Base64.encode64(hmac).chomp
	  	return hash
	end

	def getAlmacenes

		hash = createHash('GET')

		return JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).get("http://integracion-2016-dev.herokuapp.com/bodega/almacenes").to_s)

	end

	def getProductsWithStock(almacenId)
		
		hash = createHash('GET' + almacenId)
		return JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).get("http://integracion-2016-dev.herokuapp.com/bodega/skusWithStock?almacenId=" + almacenId).to_s)

	end

	def getProductStock(productId, almacenId)

		hash = createHash('GET' + almacenId + productId)
		return JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).get("http://integracion-2016-dev.herokuapp.com/bodega/stock?almacenId=" + almacenId + "&sku=" + productId + "&limit=5").to_s)
	
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
end
