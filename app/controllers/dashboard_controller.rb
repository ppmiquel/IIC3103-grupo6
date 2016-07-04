


class DashboardController < ApplicationController
	skip_before_action :verify_authenticity_token
	layout "dashboard"

	def panel
		respond_to do |format|
			format.js
		end
	end
	def index
	end

	def invoices

	end

	def transactions

	end

	def self.current_date
		Date.today
	end


	def self.get_stock_arroz(date,offset)
	
	end

	def self.get_saldo(date,offset)
		puts 'entre'
		if date.to_s == "0"
			date = current_date+offset
		else
			date = date+offset
		end
		trxs_dia = Transaction.all.where("created_at >= :start_date AND created_at <= :end_date",
																		 {start_date: date, end_date: date+1});
		result =trxs_dia.where(cuenta_d: 'Grupo 6').sum("monto")-trxs_dia.where(cuenta_o:'Grupo 6').sum("monto")
		result
	end


	def self.get_fact(date,offset)
		puts 'entre'
		if date.to_s == "0"
			date = current_date+offset
		else
			date = date+offset
		end
		fact_dia = Factura.all.where("created_at >= :start_date AND created_at <= :end_date",
																		 {start_date: date, end_date: date+1});
		puts fact_dia.count
		result =fact_dia.count
		result
	end

	def reload
		@date = Date.parse(params[:date])

		respond_to do |format|
			format.js
		end
	end
	#
end
