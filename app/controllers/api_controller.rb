require 'warehouse_module'
require 'bank_module'
require 'oc_module'
require 'invoice_module'

class ApiController < ApplicationController

	include WarehouseModule
	include BankModule
	include OcModule
	include InvoiceModule

###################


# def test
# 	producto = getStock('13', '571262aaa980ba030058a2bc')
# 	render :json =>producto
# end


# def test
#
# 	producto  = moverStock('575222d0b6d39e03001fa3e2', '571262aaa980ba030058a2bd')
# 	render :json =>producto
# end


# def test
# vaciarBodegaRecepcion()
# response = { :validado => true}
# render :json =>response
# end
#
#
# def test
# 	response = getAlmacenes()
# 	render :json =>response
# end
#
# def test
# 	response = Orden.where(sku: '13')
# 	render :json =>response
# end
#
# def test
# 	productoId = '571262aaa980ba030058a2c1'
# 	direccion = "direccion"
# 	precio = 3858
# 	idoc= '5722604f7037060300d251ce'
# 	hash = createHash('DELETE' + productoId + direccion + precio.to_s + idoc)
# 	response = JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).delete("http://integracion-2016-dev.herokuapp.com/bodega/stock", :json => {:productoId => productoId , :direccion => direccion , :precio => precio , :oc => idoc}), :symbolize_names => true)
# 	render :json =>response
# end
#
# def test
# 	orden= Orden
# 	idoc= '5722604f7037060300d251ce'
# 	sku= '13'
# 	cantidad = 19
# 	precio = 3858
#     almacenes = getAlmacenes()
#     totalDespachados = 0
#     idDespacho = obtenerIdAlmacenDespacho()
#     almacenes.each do |almacen|
#       if almacen['despacho']
#         productos = getStock(sku, almacen["_id"])
#         productos.each do |producto|
#           if(totalDespachados < cantidad)
# 						puts ('entro')
#             ordendespachado = despacharStock(producto["_id"],"direccion",precio, idoc)
#             totalDespachados += 1
#           end
#         end
# 			end
#     end
#
# 	response =totalDespachados
# 	render :json =>response
# end
#
# def test
# 	sku = '13'
# 	cantidad= 440
# 		almacenes = getAlmacenes()
# 	  movidos = 0
# 	  idDespacho = obtenerIdAlmacenDespacho()
# 	  almacenes.each do |almacen|
# 	    if almacen['despacho'] == false
# 	      productos = getStock(sku, almacen['_id'])
# 	      productos.each do |producto|
# 	        if(movidos < cantidad.to_i)
# 	          moverStock(producto['_id'],idDespacho)
# 						movidos = movidos +1
# 	        end
# 	      end
# 	    end
# 	  end
# 	puts(trxId.class)
# 	render :json =>trxId
# end
#
# def test
# 	lote = 1
#   cantidad = lote*560
# 	puts(cantidad)
#   precioArroz = 782*cantidad
#   sku = '25'
#   trxId = pagarProduccion(precioArroz)
# 	puts(trxId)
#   response = producirStock(sku, trxId, cantidad)
# 	render :json =>response
# end
#
# def test
# moverInsumo('13',20)
# response = { :stock => "se movio"}
# render :json =>response
# end



	def pedir (cantidad, sku, dias, ngrupo)
		canal="b2b"
		##proveedor= Group.vendeor(sku)
		#proveedor = idgrupo
		proveedor = Group.where(numero: ngrupo).take.idgrupo
		#proveedor= Group.where(numero: 6).take.idgrupo
		cliente= Group.where(numero: 6).take.idgrupo
		############# q pasa con el precio??
		precio= 10
		#que pasa con el precio?
		notas ="sjjd"
		fecha = Time.now.to_i * 1000 + dias*24*60*60*1000
		oc = crearOC(canal, cantidad, sku, cliente, proveedor, precio, notas, fecha)

		ord =Orden.create(idoc: oc[:_id], canal:oc[:canal], cliente: oc[:cliente], sku: oc[:sku], cantidad: oc[:cantidad], precio:oc[:precioUnitario], fecha_entrega: (oc[:fechaEntrega]).to_i )

		numerox = Group.where(idgrupo: proveedor).take.numero
		acepted = solicitar(oc[:_id], numerox)
		return acepted


	end

	def solicitar (idoc, numerox)
		urlGrupo = "integra" + numerox.to_s

		#puts "http://"+urlGrupo+".ing.puc.cl/api/oc/recibir/"+idoc

	    envio= JSON.parse(HTTP.headers(:"Content-Type" => "application/json").get("http://"+urlGrupo+".ing.puc.cl/api/oc/recibir/"+idoc).to_s, :symbolize_names => true)
	   	return envio[:aceptado]


	end


##############################
##############################

	def consultar
		id = params[:sku]
		product_stock = getProductStock(id)
		response = { :stock => product_stock, :sku => id}
		#pedir(10, id, 2, 6)
		render :json => response
	end

#### recibir trx
	def pago_recibir

		idtrx = params[:idtrx]
		idfact = params[:idfactura]
		trx = obtenerTransaccion(idtrx)
		validated = ValidacionTransaccion(trx)

		puts "000000000             000000000000000"
		puts "000000000             000000000000000"
		puts trx
		puts idfact
		puts "000000000             000000000000000"
		puts "000000000             000000000000000"

		trans = Transaction.create(idtrx:idtrx, monto: trx[0][:monto], cuenta_o: trx[0][:origen], cuenta_d: trx[0][:destino], usada: false)
		response = { :aceptado => validated, :idtrx => idtrx}
		render :json =>response

		if validated
			checkFact(idtrx) ## sE envìa a validar segùn enunciado
			trans.usada = true ##SE dice que q la transacciǹ ya fue usada
			####se debe conectar el modelo, diciendo que esa transacciòn pertenece a un orden y una factura
			fact = Factura.where(idfact: idfact).take
			ordenx = Orden.where(idoc: fact.idoc).take
			fact.idtrx = idtrx
			ordenx.idtrx =idtrx


			group= Group.where(idgrupo: ordenx.cliente).take
			almacenId= group.warehouse

			puts "sku: "  + ordenx.sku

			puts "idoc: "  + ordenx.idoc
			puts "precio: "  + ordenx.precio.to_s
			puts  almacenId
			moverStockBodega(ordenx.sku, almacenId, ordenx.idoc, ordenx.precio)

			numero = group.numero
			avisar_despacho(idfact, numero)

#################
############### Falta agregar algunos detalles al modelo, como por ejemplo la cantidad despachada
############### pero cmo nuestra logica es bàsica, aun no es necesario
################
		end

	end

	def avisar_despacho(idfact, numero)
		urlGrupo = "integra"+numero.to_s
		JSON.parse(HTTP.headers(:"Content-Type" => "application/json").get("http://"+urlGrupo+".ing.puc.cl/api/despachos/recibir/"+idfact).to_s, :symbolize_names => true)
	end


########## recibir oc
	def recibir
		idoc = params[:idoc]
		aceptado = getAcceptance(idoc)
		if aceptado == false
			rechazar idoc
			response = { :aceptado => aceptado, :idoc => idoc}
			render(:json => response) and return

		else
			orden = recepcionar idoc
			#guardar enbd
			Orden.create(idoc: orden[0][:_id], canal:orden[0][:canal], cliente: orden[0][:cliente], sku: orden[0][:sku], cantidad: orden[0][:cantidad], precio:orden[0][:precioUnitario], fecha_entrega: (orden[0][:fechaEntrega]).to_i )
		end
		response = { :aceptado => aceptado, :idoc => idoc}
		render :json => response

		factura =generateFact(idoc)

######### inicializar factura
		idfact=factura[:_id]
		cliente =factura[:cliente]

		proveedor = factura[:proveedor]
		valor_bruto = factura[:bruto]
		iva = factura[:iva]
		estado = factura[:estado]

		Factura.create(idfact: idfact, cliente: cliente, proveedor: proveedor, valor_bruto: valor_bruto, iva: iva, estado: estado, idoc: idoc)

		puts "a a antes an antes"

		ord = Orden.getOrden(idoc)

######### FIN DE inicializar factura
		puts ord.cliente
		puts "se buscarà"
		grupox = Group.where(idgrupo: ord.cliente).take

		grupoSend= grupox.numero.to_i

		puts "se entrarà al send"
		validateFact = sendFact(idfact, grupoSend)

			if !validateFact #Puede ser que la factura no se aceptada,entonces no vale seguir /viviendo/
				return
			end
	end


	def fact_recibir
		idfact= params[:idfact]

		factu= obtenerFactura(idfact)
		trx = pagar(factu);

		enviar_trx(trx, idfact)

		response = { :validado => true, :idfactura => idfact}
		render :json =>response
	end

	def pagar(factu)

		monto= (factu[0][:total])
		origen = Group.where(idgrupo: factu[0][:cliente]).take.cuenta
		destino = Group.where(idgrupo: factu[0][:proveedor]).take.cuenta
		trx = transferir(monto, origen, destino)
		puts "aaaaaaaaaaaaaa"
		puts "aaaaaaaaaaaaa"
		puts trx
		return trx
	end


	def enviar_trx (trx,idfact)
		cuentax = trx[:destino]
		grupo= Group.where(cuenta: cuentax).take
		grupoSend= grupo.numero
		urlGrupo = "integra"+grupoSend.to_s
		JSON.parse(HTTP.headers(:"Content-Type" => "application/json").get("http://"+urlGrupo+".ing.puc.cl/api/pagos/recibir?idtrx="+trx[:_id]+"&idfactura="+idfact).to_s, :symbolize_names => true)
	end

	def recibir_despacho
		response = { :validado => true}
		render :json =>response
	end


end
