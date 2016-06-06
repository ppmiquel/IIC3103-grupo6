

class Banco < ActiveRecord::Base

def self.crearBoleta(total)
  idproveedor='572aac69bdb6d403005fb047'
  cliente='lala'
  boleta= JSON.parse(HTTP.headers(:"Content-Type" => "application/json").put("http://moto.ing.puc.cl/facturas/boleta", :json => {:proveedor => idproveedor,:cliente=>cliente,:total=> total}).to_s, :symbolize_names => true)
  idbol=boleta[:_id]
  cliente =boleta[:cliente]

  proveedor = boleta[:proveedor]
  valor_bruto = boleta[:bruto]
  iva = boleta[:iva]
  total = boleta[:total]
  estado = boleta[:estado]
  created_at = boleta[:created_at]
  updated_at = boleta[:updated_at]
  oc = boleta[:oc]

  Boletum.create(created_at: created_at, updated_at: updated_at, cliente: cliente, proveedor: proveedor, bruto: valor_bruto, iva: iva, total: total, oc:oc,id_boleta:idbol,estado:estado)

  return boleta[:_id]
end

end
