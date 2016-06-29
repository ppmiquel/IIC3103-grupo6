module OfertasModule

require 'bunny'
require 'json'

def buscarOferta

	conn = Bunny.new("amqp://vbxaemul:bbBSE5xmmKhc6rinnl1QjpxT_k-42nzt@fox.rmq.cloudamqp.com/vbxaemul")
	conn.start

	ch = conn.create_channel
	q = ch.queue('ofertas', :auto_delete => true, :exclusive => false, :durable => false)

	cantidad = q.message_count

	while cantidad > 0
		promo = q.pop
		promocion = JSON.parse(promo[2].to_s)
		
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
		end
		cantidad = q.message_count
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