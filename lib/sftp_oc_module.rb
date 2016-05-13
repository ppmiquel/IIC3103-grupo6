def saveSftpOc()
  #nos conectamos
  session = Net::SFTP.start('mare.ing.puc.cl', 'integra6', :password => 'BSnt6txv', :port =>22)
  sftp = Net::SFTP::Session.new(session)
    sftp.dir.foreach("/pedidos") do |archivo|
      orden = archivo.attribute('id').content
      #guardar enbd
      Orden.create(idoc: orden[0][:_id], canal:orden[0][:canal], cliente: orden[0][:cliente], sku: orden[0][:sku], cantidad: orden[0][:cantidad], precio:orden[0][:precioUnitario], fecha_entrega: (orden[0][:fechaEntrega]).to_i )
    end
     #myfile.csv /my/dir/myfile.csv
end
