
class Banco < ActiveRecord::Base


def self.crearBoleta(total)
  idproveedor='572aac69bdb6d403005fb047'
  cliente='lala'
  boleta= JSON.parse(HTTP.headers(:"Content-Type" => "application/json").put("http://moto.ing.puc.cl/facturas/boleta", :json => {:proveedor => idproveedor,:cliente=>cliente,:total=> total}).to_s, :symbolize_names => true)
  

  return boleta[:_id]
end

end
