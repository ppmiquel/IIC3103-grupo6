module BankModule

  def obtenerTransaccion(idtrx)
    trx= JSON.parse(HTTP.headers(:"Content-Type" => "application/json").get("http://mare.ing.puc.cl/banco/trx/"+idtrx,).to_s, :symbolize_names => true)
    return trx
  end

  def ValidacionTransaccion(trx)
    return true
  end


#ok#ok
  def transferir(monto, origen, destino)
  	trx= JSON.parse(HTTP.headers(:"Content-Type" => "application/json").put("http://mare.ing.puc.cl/banco/trx", :json => {:monto => monto, :origen => origen, :destino => destino} ).to_s, :symbolize_names => true)
    return trx
  end


  def obtenerCartola(fechaInicio, fechaFin, id)
  	cartola = JSON.parse(HTTP.headers(:"Content-Type" => "application/json").post("http://mare.ing.puc.cl/banco/cartola/"+id, :params => {:fechaInicio => fechaInicio , :fechaFin => fechaFin, :id => id}).to_s, :symbolize_names => true)
  	return cartola
  end

  def obtenerCuenta(id)
	cuenta = JSON.parse(HTTP.headers(:"Content-Type" => "application/json").get("http://mare.ing.puc.cl/banco/cuenta/"+id,).to_s, :symbolize_names => true)
	return cuenta
  end
end
