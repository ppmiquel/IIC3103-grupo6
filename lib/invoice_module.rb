module InvoiceModule
  ###SE necesita el url del grupo|||
  def generateFact(idoc)
    facturax = putFactura idoc
    return facturax

  end


  def sendFact(idfact, grupo)
#hay que tener un get grupo segùn OC
    urlGrupo = "integra"+grupo
    envio= JSON.parse(HTTP.headers(:"Content-Type" => "application/json").get("http://"+urlGrupo+".ing.puc.cl/api/facturas/recibir/"+idfact).to_s, :symbolize_names => true)
    
    # no me acpeta la factura?
    if !(envio[:valido])  ##OJO!! PUEDE QUE SE NECESITE HACER envio[0][:valido] (agregar [0])
      #Cancelo la factura
      JSON.parse(HTTP.headers(:"Content-Type" => "application/json").post("http://mare.ing.puc.cl/api/facturas/cancel", :json => {:id => idfact, :motivo => "Factura no valiada por el cliente"}).to_s)
      return false #anuncio cancelaciòn
    end

    return true
  end



#consumo api para generar un factura
  def putFactura(oc)  
    
    facturax= JSON.parse(HTTP.headers(:"Content-Type" => "application/json").put("http://mare.ing.puc.cl/facturas/", :json => {:oc => oc}), :symbolize_names => true)
    return facturax
  end

  def checkFact(idtrx)
    JSON.parse(HTTP.headers(:"Content-Type" => "application/json").post("http://mare.ing.puc.cl/facturas/pay", :json => {:id => idtrx} ).to_s, :symbolize_names => true)

  end

end