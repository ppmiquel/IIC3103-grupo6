json.array!(@ordens) do |orden|
  json.extract! orden, :id, :idoc, :canal, :cliente, :sku, :cantidad, :precio, :fecha_entrega, :idtrx, :idfact, :estado
  json.url orden_url(orden, format: :json)
end
