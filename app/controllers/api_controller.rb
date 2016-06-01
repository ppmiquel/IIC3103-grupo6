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
	sku = '13'
    stock = 0
    almacenes = getAlmacenes()
    almacenes.each do |almacen|
      productos = getProductsWithStock(almacen['_id'])
      productos.each do |producto|
        if(producto["_sku"] == sku)
          stock = stock + producto["total"]
        end
      end
    end
    response = stock
	render :json => response
end


def test6

	productId = '13'
	trxId = '574e518df1af1e03003c08fb'
	cantidad = '1000'
	key = 'cd0A9ZK#u#vxES9'
	data = 'PUT' + productId + cantidad + trxId
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

	def test4
	productId = '571262b6a980ba030058a68c'
	idoc = '⁠⁠⁠57449d142a303103007ce033'
	direccion = 'a'
	precio = 3858
    hash = createHash('DELETE' + productId + direccion + precio.to_s + idoc)
    response = JSON.parse(HTTP.headers(:"Content-Type" => "application/json", :Authorization => "INTEGRACION grupo6:" + hash).delete("http://integracion-2016-dev.herokuapp.com/bodega/stock", :json => {:productoId => productId , :direccion => direccion , :precio => precio , :idoc => idoc }).to_s, :symbolize_names => true)
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
