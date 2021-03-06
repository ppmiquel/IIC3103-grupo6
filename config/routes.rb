Rails.application.routes.draw do


  get 'facturas/index'

  resources :facturas
  resources :facturas
  resources :facturas
  resources :facturas
  resources :invoices
  resources :boleta
  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
  mount Spree::Core::Engine, at: '/tienda/'



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index2'

  get 'twi/:mensaje' => 'welcome#twitt'

  get 'face/:mensaje' => 'welcome#face'


  get 'vars' => 'api#vars'

  get 'doc' => 'welcome#doc', path: 'api/documentacion'
  get 'orders' => 'ordens#index', path: 'orders'
  get 'facturas' => 'facturas#index', path: 'facturas'
  get 'transactions' => 'transactions#index', path: 'transactions'
  get 'panel' => 'dashboard#panel', path: 'panel'
  get 'dashboard' => 'dashboard#index', path: 'dashboard'
  get 'index2' => 'welcome#index2', path: 'welcome/index2'
  post 'chagen_date' => 'dashboard#reload',path:'reloadCharts'


  get 'static_table' => 'welcome#static_table', path: 'static_table.html.erb'
  get 'datatable' => 'welcome#datatable', path: 'datatable.html.erb'

  get 'success' =>'welcome#success', path: 'tienda/success/:id'

  get 'error' =>'welcome#error', path: 'tienda/error'
  get 'error' =>'welcome#stock', path: 'tienda/stock'
  get 'error' =>'welcome#noAddress', path: 'tienda/noAddress'

  get 'api/facturas/recibir/:idfact' => 'api#fact_recibir'

  get 'api/producirArroz' => 'api#producirArrozOnline'

  get 'api/producirAzucar' => 'api#producirAzucarOnline'

  get 'api/verBodegas' => 'api#verBodegas'

  get 'api' => 'api#cambiar'
  get 'api/hash' => 'api#hash'

  get 'api/test' => 'api#test'

  get 'api/procesarFtp' => 'api#procesarFtp'

  get 'api/vaciarRecepcion' => 'api#vaciarBodegaRecepcionOnline'

  get 'api/vaciarPulmon' => 'api#vaciarPulmonOnline'

  get 'api/consultar/:sku' => 'api#consultar'

  get 'api/test' => 'api#test'

  get 'api/leerFtp' => 'api#leerFtp'

  get 'api/oc/recibir/:idoc' => 'api#recibir'

  get 'api/pagos/recibir' => 'api#pago_recibir'


  get 'api/despachos/recibir/:idfactura' =>'api#recibir_despacho'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
