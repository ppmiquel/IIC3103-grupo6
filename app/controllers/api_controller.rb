require "http"
require "base64"
require "cgi"
require "openssl"
require "json"


class ApiController < ApplicationController
	

##################Métodos de API #############
	def consultar
		id = params[:sku]
		stock = getProductStock(id)
		response = { :stock => stock, :sku => id}
		render :json => response

	end


	def recibir
		idoc = params[:idoc]
		aceptado = getAcceptance (idoc)
		if aceptado == false
			rechazar idoc
		end
		else
			recepcionar idoc
		end
		response = { :aceptado => aceptado, :idoc => idoc}
		render :json => response
		
		validateFact = generateFact(idoc)

		if !validateFact
			return
		end


	end

	def pago_recibir
		idtrx = params[:idtrx]
		trx = getTrx(idtrx)
		#####sE recibe el pago, se debe validar que corresponda a una transacción y que se haga el despacho
		#Falta el response
	end




################## Métodos auxliares ##############


############# RECIBIR: 
	def getAcceptance(idoc)
		params = {:idoc => idoc}.to_json
		orden= JSON.parse(HTTP.headers(:"Content-Type" => "application/json").get("http://mare.ing.puc.cl/oc/obtener"+idoc, params).to_s)
		sku= orden[:sku]
		stock = getProductStock(sku)
		if orden[:cantidad] > stock
			return false
		end
		return true
	end

	def rechazar(idoc)
		params = {:idoc => idoc , :rechazo => "No se posee stock para satisfacer demanda"}.to_json
		HTTP.headers(:"Content-Type" => "application/json").post("http://mare.ing.puc.cl/oc/rechazar"+idoc, params)

	end

	def recepcionar(idoc)
		params = {:idoc => idoc}.to_json
		HTTP.headers(:"Content-Type" => "application/json").post("http://mare.ing.puc.cl/oc/recepcionar"+idoc, params)

	end


###SE necesita el url del grupo|||
	def generateFact(idoc)
		factura = putFactura(idoc)
		idfact= factura[:id]
		grupo
		envio= JSON.parse(HTTP.headers(:"Content-Type" => "application/json").post("http://"+grupo+".ing.puc.cl/api/facturas/recibir/"+idfact, params).to_s)
		if !envio[:valido]
			params = {:id => idfact, :motivo => "Factunar no valiada por el cliente"}.to_json
			JSON.parse(HTTP.headers(:"Content-Type" => "application/json").post("http://mare.ing.puc.cl/api/facturas/cancel", params).to_s)
			return false
		end

		return true
	end

	def putFacura(idoc)
		params = {:idoc => idoc}.to_json
		factura= JSON.parse(HTTP.headers(:"Content-Type" => "application/json").put("http://mare.ing.puc.cl/facturas", params).to_s)
		return factura
	end




############### pago recibir:

	def getTrx(idtrx)
		params = {:idoc => idtrx}.to_json
		trx= JSON.parse(HTTP.headers(:"Content-Type" => "application/json").get("http://mare.ing.puc.cl/banco/trx/"+idtrx, params).to_s)
		return trx
	end



##############ACCESO A BODEGA:
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
