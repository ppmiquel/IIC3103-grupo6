module OfertasModule

require bunny

def buscarOferta

	conn = Bunny.New(amqp://vbxaemul:bbBSE5xmmKhc6rinnl1QjpxT_k-42nzt@fox.rmq.cloudamqp.com/vbxaemul)
	conn.start

	ch = conn.create_channel
	q = ch.queue('ofertas', :auto_delete => true, :exclusive => false, :durable => false)

	promocion = q.pop

	oferta = {sku: promocion['sku'], precio: promocion['precio'],inicio: promocion['inicio'],fin: promocion['fin']
				, codigo: promocion['codigo'], publicar: promocion['publicar']}
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