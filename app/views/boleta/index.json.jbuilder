json.array!(@boleta) do |boletum|
  json.extract! boletum, :id, :created_at, :updated_at, :cliente, :proveedor, :bruto, :iva, :total, :oc, :id, :estado
  json.url boletum_url(boletum, format: :json)
end
