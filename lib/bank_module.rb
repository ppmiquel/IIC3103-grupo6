module BankModule
  def getTrx(idtrx)

    trx= JSON.parse(HTTP.headers(:"Content-Type" => "application/json").get("http://mare.ing.puc.cl/banco/trx/"+idtrx,).to_s, :symbolize_names => true)
    return trx
  end

  def getTrxValidation(trx)
    return true
  end
end