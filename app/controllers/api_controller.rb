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
		aceptado = getAcceptance(idoc)
		if aceptado == false
			rechazar idoc
		else
			recepcionar idoc
		end
		response = { :aceptado => aceptado, :idoc => idoc}
		render :json => response
		
	#	validateFact = generateFact(idoc)

	#	if !validateFact
	#		return
	#	end
	end

	def pago_recibir
		idtrx = params[0][:idtrx]
		idfact = params[0][:idfactura]
		trx = getTrx(idtrx)
		validated = getTrxValidation(trx)
		#algo como : #validateTrx =
		#####sE recibe el pago, se debe validar que corresponda a una transacción y que se haga el despacho
		response = { :aceptado => validated, :idtrx => idtrx}
		render :json =>response
	end

	def crear

	end




################## Métodos auxliares ##############


############# RECIBIR: 
	def getAcceptance(idoc)
		# params = {:idoc => idoc}.to_json
		orden= JSON.parse(HTTP.headers(:"Content-Type" => "application/json").get("http://mare.ing.puc.cl/oc/obtener/"+idoc).to_s, :symbolize_names => true)
		cantidad=orden[0][:cantidad] 

		sku = orden[0][:sku] 
		stock = getProductStock(sku)
		if ((orden[0][:cantidad]) > stock)
			return false
		end
		return true
	end

	def rechazar(idoc)
		
		HTTP.headers(:"Content-Type" => "application/json").post("http://mare.ing.puc.cl/oc/rechazar/"+idoc, :params => {:idoc => idoc , :rechazo => "No se posee stock para satisfacer demanda"})

	end

	def recepcionar(idoc)
		
		HTTP.headers(:"Content-Type" => "application/json").post("http://mare.ing.puc.cl/oc/recepcionar"+idoc, :params => {:idoc => idoc})

	end


###SE necesita el url del grupo|||
	def generateFact(idoc)
		factura = putFactura(idoc)
		idfact= factura[0][:id]
		#grupo = url del grupo
		envio= JSON.parse(HTTP.headers(:"Content-Type" => "application/json").get("http://"+grupo+".ing.puc.cl/api/facturas/recibir/"+idfact).to_s, :symbolize_names => true)
		if !envio[0][:valido]
			
			JSON.parse(HTTP.headers(:"Content-Type" => "application/json").post("http://mare.ing.puc.cl/api/facturas/cancel", :params => {:id => idfact, :motivo => "Factura no valiada por el cliente"}).to_s)
			return false
		end

		return true
	end

	def putFactura(idoc)
		
		factura= JSON.parse(HTTP.headers(:"Content-Type" => "application/json").put("http://mare.ing.puc.cl/facturas", :params => {:idoc => idoc} ).to_s, :symbolize_names => true)
		return factura
	end




############### pago recibir:

	def getTrx(idtrx)
		
		trx= JSON.parse(HTTP.headers(:"Content-Type" => "application/json").get("http://mare.ing.puc.cl/banco/trx/"+idtrx,).to_s, :symbolize_names => true))
		return trx
	end

	def getTrxValidation(trx)
		return true
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