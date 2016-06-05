# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
if Group.first.nil?
	if ### esperemos tener todos los datos

	####nos compran
		Group.create(idgrupo: "572aac69bdb6d403005fb042" , numero: 1, cuenta: "572aac69bdb6d403005fb04e" , importa: true ,sku1: 47)
	#compra y vende e 5
		Group.create(idgrupo: "572aac69bdb6d403005fb046", numero: 5, cuenta: "572aac69bdb6d403005fb052", importa: true,sku1: 52 )
	#compra y vende el 9
		Group.create(idgrupo: "572aac69bdb6d403005fb04a" , numero: 9, cuenta: "572aac69bdb6d403005fb04a", importa: true,sku1: 20 )
		Group.create(idgrupo: "572aac69bdb6d403005fb043", numero: 2, cuenta: "572aac69bdb6d403005fb04f", importa: true)

	##### nos venden
		Group.create(idgrupo: "572aac69bdb6d403005fb04d" , numero: 12, cuenta: "572aac69bdb6d403005fb05a", importa: true,sku1: 7 )
	####compra y vende el 6
		Group.create(idgrupo: "572aac69bdb6d403005fb047" , numero: 6, cuenta: "571262c3a980ba030058ab62", importa: true,sku1: 13, sku2: 25 )
		Group.create(idgrupo: "572aac69bdb6d403005fb049", numero: 8, cuenta: "572aac69bdb6d403005fb056", importa: true,sku1: 26 )
		Group.create(idgrupo: "572aac69bdb6d403005fb045", numero: 4, cuenta: "572aac69bdb6d403005fb051", importa: true,sku1: 38 )
# template: Grupo.create(idgrupo: , numero:   , cuenta: , importa: true,sku1: ,sku2: ,sku3: ,sku4: ,sku5: ,sku6: )
		end
end


Spree::Auth::Engine.load_seed if defined?(Spree::Auth)



# *** ---- SPREE ---- ***

tax_category = Spree::TaxCategory.create(name: 'IVA',is_default: true)
tax_category.save
tax_rate = Spree::TaxRate.create(amount: 0.19, tax_category_id: 1, included_in_price: true)
tax_rate.save



productos_list = [
	["Arroz", "Arroz Blanco", Time.now, "arroz", 1504, "arroz.jpg", "13"],
	["Pan Integral", "Pan orgánico", Time.now, "pan", 10492, "pan.jpg", "53"],
	["Cereal Arroz", "Es natur", Time.now, "cereal", 8779, "cereal.jpg", "17"],
	["Azúcar", "Azúcar Blanca", Time.now, "azucar", 1016, "azucar.jpg", "25"]
]

productos_list.each do |name, description, available_on, meta_keywords, price, image_name, sku|
	product = Spree::Product.create(sku: sku, cost_currency: "CLP", name: name, description: description, available_on: available_on, meta_keywords: meta_keywords, tax_category_id: 1, shipping_category_id: 1, promotionable: false, price: price)
	path = 'public/spree/products/' + meta_keywords + '/product/' + image_name
   id = Spree::Variant.find_by(product_id: product.id).id
 	i = Spree::Image.create!(attachment: File.open(path), viewable_type: "Spree::Variant", viewable_id: id, attachment_file_name: image_name)
   product.images << i
   product.save
   path = 'public/spree/products/' + meta_keywords + '/product/' + image_name
   image = Spree::Image.create(attachment: File.open(path), viewable: product.master, viewable_id: product.id, viewable_type: 'Spree::Variant', attachment_file_name: image_name , type: "Spree::Image")
 image.save
product.save
end
