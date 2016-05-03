class OC
  def consultar
    id = params[:sku]
    stock = getProductStock(id)
    response = { :stock => stock, :sku => id}
    render :json => response
  end
end