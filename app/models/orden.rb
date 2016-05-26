class Orden < ActiveRecord::Base

	def self.getOrden (idoc)
		puts "buscando ccsknc nkcnkncnjdkjcnj"
		return Orden.where(idoc: idoc).take
	end
end
