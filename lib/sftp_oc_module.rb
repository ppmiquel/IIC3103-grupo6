
def leerSftp
  session = Net::SSH.start('moto.ing.puc.cl', 'integra6', password: 'qQLEV4n6', port: 22)
  sftp = Net::SFTP::Session.new(session)
  sftp.connect!
  sftp.dir.foreach('/pedidos') do |archivo|
    if((archivo.name).end_with?('.xml'))
      file = sftp.download!("/pedidos/"<<archivo.name)
      doc = Nokogiri::XML(file)
      orden = obtenerOC(doc.css("id").map.first.children.text);
      Orden.create(idoc: orden[0][:_id], canal:orden[0][:canal], cliente: orden[0][:cliente], sku: orden[0][:sku], cantidad: orden[0][:cantidad], precio:orden[0][:precioUnitario], :estado => 'leida', fecha_entrega: (orden[0][:fechaEntrega]).to_i )
      sftp.rename("/pedidos/"<<archivo.name, "/pedidos/leidos/"<<archivo.name)
    end
  end
end
