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

Spree::Core::Engine.load_seed if defined?(Spree::Core)
Spree::Auth::Engine.load_seed if defined?(Spree::Auth)
