class InvoiceController < ApplicationController

  ###SE necesita el url del grupo|||
  def generateFact(idoc)
    factura = putFactura(idoc)
    idfact= factura[0][:id]
    #grupo = url del grupo
    envio= JSON.parse(HTTP.headers(:"Content-Type" => "application/json").get("http://"+grupo+".ing.puc.cl/api/facturas/recibir/"+idfact).to_s, :symbolize_names => true)
    if !envio[0][:valido]

      JSON.parse(HTTP.headers(:"Content-Type" => "application/json").post("http://mare.ing.puc.cl/api/facturas/cancel", :params => {:id => idfact, :motivo => "Factura no valiada por el cliente"}).to_s)
      return false
    end

    return true
  end

  def putFactura(idoc)

    factura= JSON.parse(HTTP.headers(:"Content-Type" => "application/json").put("http://mare.ing.puc.cl/facturas", :params => {:idoc => idoc} ).to_s, :symbolize_names => true)
    return factura
  end
end