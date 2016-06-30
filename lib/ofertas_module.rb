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
				  imagen= "goo.gl/jL7s3r"
				when "17"
				  nombre="Cereal de Arroz"
				  imagen = "goo.gl/6hgBBX"
				when "25"
				  nombre="Azucar"
				  imagen = "goo.gl/DgvaQf"
				else
				  nombre="Pan Integral "
				  imagen = "http://goo.gl/QcU6HH"
				end
				mensaje= " "+nombre+ "a solo " + precio.to_s + "hasta: " + fin.to_s + "\nCódigo: " +codigo
				publica mensaje , imagen
			end
		end
		cantidad = q.message_count
		puts ("cantidad: " + cantidad.to_s)
	end
	ch.close
	conn.stop

	return oferta
end

# def publicarOfertas

# 	conn = Bunny.New(amqp://vbxaemul:bbBSE5xmmKhc6rinnl1QjpxT_k-42nzt@fox.rmq.cloudamqp.com/vbxaemul)
# 	conn.start

# 	ch = conn.create_channel
# 	e = ch.exchange('ofertas')
# 	e.publish('', :key => 'ofertas')



# end

end