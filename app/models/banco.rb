
class Banco < ActiveRecord::Base


def self.crearBoleta(total)
  idproveedor='571262b8a980ba030058ab54'
  cliente='lala'
  boleta= JSON.parse(HTTP.headers(:"Content-Type" => "application/json").put("http://mare.ing.puc.cl/facturas/boleta", :json => {:proveedor => idproveedor,:cliente=>cliente,:total=> total}).to_s, :symbolize_names => true)
  return boleta[:_id]
end

end
