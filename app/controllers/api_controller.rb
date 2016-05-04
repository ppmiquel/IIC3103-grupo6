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

end