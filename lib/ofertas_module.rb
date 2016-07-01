module OfertasModule

require 'bunny'
require 'json'
require 'proms_module'

def buscarOferta

	include PromsModule
	conn = Bunny.new($ampq)
	conn.start

	ch = conn.create_channel
	q = ch.queue('ofertas', :auto_delete => true, :exclusive => false, :durable => false)

	cantidad = q.message_count
	puts("Quedan: " + cantidad.to_s)
	while cantidad > 0
		promo = q.pop
		promocionJson = promo[2].to_s
		promocion = JSON.parse(promocionJson)

		sku = promocion['sku']			
		puts("El sku de la oferta es " + sku)
					
		if(sku == '13' || sku == '17' || sku == '25' || sku == '53' )
			precio = promocion['precio']
			inicio = promocion['inicio']
			fin = promocion['fin']
			codigo = promocion['codigo']
			publicar = promocion['publicar']
			puts ("sku: " + sku)
			puts (" precio: " + precio.to_s)
			puts (" inicio: " + inicio.to_s)
			puts (" fin: " + fin.to_s)
			puts (" codigo: " + codigo)
			Oferta.create(sku: sku, precio:precio, inicio: inicio, fin: fin, codigo: codigo)
			if publicar
				nombre = ""
				imagen = ""
				case sku
				when "13"
				  nombre= "Arroz "
				  imagen= "http://integra6.ing.puc.cl/spree/products/1/product/arroz.jpg"
				when "17"
				  nombre="Cereal de Arroz"
				  imagen = "http://integra6.ing.puc.cl/spree/products/3/product/cereal.jpg"
				when "25"
				  nombre="Azucar "
				  imagen = "http://integra6.ing.puc.cl/spree/products/2/product/azucar.jpg"
				else
				  nombre="Pan Integral "
				  imagen = "http://integra6.ing.puc.cl/spree/products/4/product/pan.jpg"
				end
				start = Time.strptime(inicio.to_s, '%Q').strftime("%Y-%m-%d %H:%M:%S")
				ending = Time.strptime(fin.to_s, '%Q').strftime("%Y-%m-%d %H:%M:%S")
				mensaje= " "+nombre+ "a solo $" + precio.to_s + " desde: " + start.to_s + " hasta: " + ending.to_s + "\nCódigo: " +codigo
				publica mensaje , imagen
			end


		 end
		cantidad = q.message_count
		puts ("cantidad: " + cantidad.to_s)
	end
	ch.close
	conn.stop

end

# def publicarOfertas

# 	conn = Bunny.New(amqp://vbxaemul:bbBSE5xmmKhc6rinnl1QjpxT_k-42nzt@fox.rmq.cloudamqp.com/vbxaemul)
# 	conn.start

# 	ch = conn.create_channel
# 	e = ch.exchange('ofertas')
# 	e.publish('', :key => 'ofertas')



# end

end