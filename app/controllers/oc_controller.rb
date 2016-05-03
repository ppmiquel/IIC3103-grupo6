require 'warehouse_module'

class OcController < ApplicationController
  include WarehouseModule

  def recibir
    idoc = params[:idoc]
    aceptado = getAcceptance(idoc)
    if aceptado == false
      rechazar idoc
    else
      recepcionar idoc
    end
    response = { :aceptado => aceptado, :idoc => idoc}
    render :json => response

    #	validateFact = generateFact(idoc)

    #	if !validateFact
    #		return
    #	end
  end

  def getAcceptance(idoc)
    # params = {:idoc => idoc}.to_json
    orden= JSON.parse(HTTP.headers(:"Content-Type" => "application/json").get("http://mare.ing.puc.cl/oc/obtener/"+idoc).to_s, :symbolize_names => true)
    cantidad=orden[0][:cantidad]

    sku = orden[0][:sku]
    stock = getProductStock(sku)
    if ((orden[0][:cantidad]) > stock)
      return false
    end
    return true
  end

  def rechazar(idoc)

    HTTP.headers(:"Content-Type" => "application/json").post("http://mare.ing.puc.cl/oc/rechazar/"+idoc, :params => {:idoc => idoc , :rechazo => "No se posee stock para satisfacer demanda"})

  end

  def recepcionar(idoc)

    HTTP.headers(:"Content-Type" => "application/json").post("http://mare.ing.puc.cl/oc/recepcionar"+idoc, :params => {:idoc => idoc})

  end


end