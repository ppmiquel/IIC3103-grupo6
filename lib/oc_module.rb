module OcModule

  def getAcceptance(idoc)
    # params = {:idoc => idoc}.to_json
    orden= JSON.parse(HTTP.headers(:"Content-Type" => "application/json").get("http://"+ $url +"/oc/obtener/"+idoc).to_s, :symbolize_names => true)
    cantidad=orden[0][:cantidad]
    sku = orden[0][:sku]
    stock = getProductStock(sku)
    if ((orden[0][:cantidad]) > stock)
      return false
    end
    return true
  end

  def rechazar(idoc)

    HTTP.headers(:"Content-Type" => "application/json").post("http://"+ $url +"/oc/rechazar/"+idoc, :json => {:idoc => idoc , :rechazo => "No se posee stock para satisfacer demanda"})

  end

  def recepcionar(idoc)

    HTTP.headers(:"Content-Type" => "application/json").post("http://"+ $url +"/oc/recepcionar/"+idoc, :json => {:idoc => idoc})
    orden= JSON.parse(HTTP.headers(:"Content-Type" => "application/json").get("http://"+ $url +"/oc/obtener/"+idoc).to_s, :symbolize_names => true)
    return orden
  end


   def anularOC(idoc , razon)

    HTTP.headers(:"Content-Type" => "application/json").delete("http://"+ $url +"/oc/anular/"+idoc, :json => {:idoc => idoc , :razon => razon})

  end

  def obtenerOC(idoc)

    oc = JSON.parse(HTTP.headers(:"Content-Type" => "application/json").get("http://"+ $url +"/oc/obtener/"+idoc, :params => {:idoc => idoc}), :symbolize_names => true)
    return oc

  end

  # No esta listo
  def crearOC(canal, cantidad, sku, cliente,  proveedor, precio, notas, fecha)

    oc = JSON.parse(HTTP.headers(:"Content-Type" => "application/json").put("http://"+ $url +"/oc/crear", :json => {:canal => canal , :cantidad => cantidad, :sku => sku, :cliente => cliente, :proveedor => proveedor,:precioUnitario => precio, :notas => notas, :fechaEntrega => fecha}), :symbolize_names => true)
    return oc

  end


  ### NUEVO

    ### DESPACHAR PRODUCTO

  def despacharProducto(idoc)

    oc = JSON.parse(HTTP.headers(:"Content-Type" => "application/json").get("http://"+ $url +"cl/oc/", :params => {:id => idoc}), :symbolize_names => true)
    return oc

  end

end
