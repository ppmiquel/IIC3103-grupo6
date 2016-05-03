class BankController< ApplicationController

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

  def getTrx(idtrx)

    trx= JSON.parse(HTTP.headers(:"Content-Type" => "application/json").get("http://mare.ing.puc.cl/banco/trx/"+idtrx,).to_s, :symbolize_names => true)
    return trx
  end

  def getTrxValidation(trx)
    return true
  end

end