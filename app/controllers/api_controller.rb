require 'warehouse_module'
require 'bank_module'
require 'oc_module'
require 'invoice_module'

class ApiController < ApplicationController

	include WarehouseModule
	include BankModule
	include OcModule
	include InvoiceModule




def test
	idoc = "574e35adf1af1e03003c085f"
	response = JSON.parse(HTTP.headers(:"Content-Type" => "application/json").delete("http://mare.ing.puc.cl/oc/anular/"+idoc, :params => {:idoc => idoc , :anulacion => "soy millionaria y no estoy ni ahi"}));
	render :json => response
end

def test4
	idoc = "57449d142a303103007ce033"
	response = JSON.parse(HTTP.headers(:"Content-Type" => "application/json").post("http://mare.ing.puc.cl/oc/rechazar/"+idoc , :json => {:idoc => idoc , :rechazo => "No se posee stock para satisfacer demanda"}))
	render :json => response
end


def test3

	productId= "571262b6a980ba030058a690"
	almacenId= '571262aaa980ba030058a2bb'
	key = 'cd0A9ZK#u#vxES9'
	data = 'POST' + productId + almacenId
	hmac = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'),key,data)
	hash = Base64.encode64(hmac).chomp
	response = hash
	render :json => response
end

	def test2
		productId="571262b6a980ba030058a68c"
		almacenId= '571262aaa980ba030058a2bb'
    hash = createHash('POST' + productId + almacenId)
    response = JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).post("http://integracion-2016-dev.herokuapp.com/bodega/moveStock", :json => {:productoId => productId, :almacenId => almacenId}))
		render :json => response
	end

	def test1
		notas = "notas"
  	cliente= "6"
  	proveedor= "6"
  	sku= "13"
  	fechaEntrega= 1495646864000
  	precioUnitario= "1"
  	cantidad= 3
  	canal= "b2b"

		response JSON.parse(HTTP.headers(:"Content-Type" => "application/json").put("http://mare.ing.puc.cl/oc/crear", :json => {:canal => canal , :cantidad => cantidad, :sku => sku, :cliente=>cliente, :proveedor => proveedor, :precioUnitario => precioUnitario, :fechaEntrega => fechaEntrega, :notas => notas}))
		#response = JSON.str(response)
		render :json => response

	end

	def consultar
		id = params[:sku]
		product_stock = getProductStock(id)
		response = { :stock => product_stock, :sku => id}
		render :json => response
	end

#### recibir trx
# 	def pago_recibir
# 		idtrx = params[:idtrx]
# 		idfact = params[:idfactura]
# 		trx = obtenerTransaccion(idtrx)
# 		validated = ValidacionTransaccion(trx)
#
# 		trans = Transaction.create(idtrx:idtrx, monto: trx[0][:monto], cuenta_o: trx[0][origen], cuenta_d: trx[0][:destino], usada: false)
# 		response = { :aceptado => validated, :idtrx => idtrx}
# 		render :json =>response
#
# 		if validated
# 			checkFact(idtrx) ## sE envìa a validar segùn enunciado
# 			trans.usada = true ##SE dice que q la transacciǹ ya fue usada
# 			####se debe conectar el modelo, diciendo que esa transacciòn pertenece a un orden y una factura
# 			fact = Factura.where(idfact: idfact)
# 			orden = Orden.where(ifoc: fact.idoc)
# 			fact.idtrx = idtrx
# 			orden.idtrx =idtrx
#
#
# 			group= Grupo.where(idgrupo: orden.cliente)
# 			almacenId= group.warehouse
# 			moverStockBodega(orden.sku, almacenId, orden.idoc, orden.precio,)
#
# #################
# ############### Falta agregar algunos detalles al modelo, como por ejemplo la cantidad despachada
# ############### pero cmo nuestra logica es bàsica, aun no es necesario
# ################
# 		end
	#
	# end






########## recibir oc
# 	def recibir
# 		idoc = params[:idoc]
# 		aceptado = getAcceptance(idoc)
# 		if aceptado == false
# 			rechazar idoc
# 			response = { :aceptado => aceptado, :idoc => idoc}
# 			render(:json => response) and return
#
# 		else
# 			orden = recepcionar idoc
# 			#guardar enbd
# 			Orden.create(idoc: orden[0][:_id], canal:orden[0][:canal], cliente: orden[0][:cliente], sku: orden[0][:sku], cantidad: orden[0][:cantidad], precio:orden[0][:precioUnitario], fecha_entrega: (orden[0][:fechaEntrega]).to_i )
# 		end
# 		response = { :aceptado => aceptado, :idoc => idoc}
# 		render :json => response
#
# 		factura =generateFact(idoc)
#
# ######### inicializar factura
# 		idfact=factura[:_id]
# 		cliente =factura[:cliente]
#
# 		proveedor = factura[:proveedor]
# 		valor_bruto = factura[:bruto]
# 		iva = factura[:iva]
# 		estado = factura[:estado]
#
# 		Factura.create(idfact: idfact, cliente: cliente, proveedor: proveedor, valor_bruto: valor_bruto, iva: iva, estado: estado, idoc: idoc)
# 		puts idoc
# 		puts "a a antes an antes"
#
# 		ord = Orden.getOrden(idoc)
# ######### FIN DE inicializar factura
#
#
# 		group= Group.where(numero: ord.cliente.to_i)
# 		grupoSend= group.numero
# 		validateFact = sendFact(idfact, grupoSend)
#
# 			if !validateFact #Puede ser que la factura no se aceptada,entonces no vale seguir /viviendo/
# 				return
# 			end
# 	end
#
 end
