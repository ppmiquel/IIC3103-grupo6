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

def producirArrozOnline
arroz =producirArroz(2)
render :json =>arroz
end

def producirAzucarOnline
azucar =producirAzucar(2)
render :json =>azucar
end


def vaciarBodegaRecepcionOnline
vaciarBodegaRecepcion()
response = { :validado => true}
render :json =>response
end

#
def verBodegas
	response = getAlmacenes()
	render :json =>response
end

def vaciarPulmonOnline
	vaciarBodegaPulmon()
	response = { :validado => true}
	render :json =>response
end

def leerFtp

end


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
