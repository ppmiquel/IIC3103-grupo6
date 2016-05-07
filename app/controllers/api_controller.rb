require 'warehouse_module'
require 'bank_module'
require 'oc_module'
require 'invoice_module'

class ApiController < ApplicationController

	include WarehouseModule
	include BankModule
	include OcModule
	include InvoiceModule

	def consultar
		id = params[:sku]
		product_stock = getProductStock(id)
		response = { :stock => product_stock, :sku => id}
		render :json => response
	end

#### recibir trx
	def pago_recibir
		idtrx = params[:idtrx]
		idfact = params[:idfactura]
		trx = obtenerTransaccion(idtrx)
		validated = ValidacionTransaccion(trx)

		trans = Transaction.create(idtrx:idtrx, monto: trx[0][:monto], cuenta_o: trx[0][origen], cuenta_d: trx[0][:destino], usada: false)
		response = { :aceptado => validated, :idtrx => idtrx}
		render :json =>response

		if validated
			checkFact(idtrx) ## sE envìa a validar segùn enunciado
			trans.usada = true ##SE dice que q la transacciǹ ya fue usada
			####se debe conectar el modelo, diciendo que esa transacciòn pertenece a un orden y una factura
			fact = Factura.where(idfact: idfact)
			orden = Orden.where(ifoc: fact.idoc)
			fact.idtrx = idtrx
			orden.idtrx =idtrx

			almacenId= #####falta mètodo para obtener el almacén
			moverStockBodega(orden.sku, almacenId, orden.idoc, orden.precio,)

#################
############### Falta agregar algunos detalles al modelo, como por ejemplo la cantidad despachada
############### pero cmo nuestra logica es bàsica, aun no es necesario
################
		end

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
		puts idoc
		puts "a a antes an antes"

		ord = Orden.getOrden(idoc)
######### FIN DE inicializar factura


		group= Grupo.where(idgrupo: ord.cliente)
		grupoSend= group.numero ###############################Falta implmentar
		validateFact = sendFact(idfact, grupoSend)

			if !validateFact #Puede ser que la factura no se aceptada,entonces no vale seguir /viviendo/
				return
			end
	end

end
