# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
if Grupo.first.nil?
	if ### esperemos tener todos los datos

	####nos compran
		Grupo.create(idgrupo: "572aac69bdb6d403005fb042" , numero: 1, cuenta: "572aac69bdb6d403005fb04e" , importa: true ,sku1: ,sku2: ,sku3: ,sku4: ,sku5: ,sku6: )
	#compra y vende e 5
		Grupo.create(idgrupo: "572aac69bdb6d403005fb046", numero: 5, cuenta: "572aac69bdb6d403005fb052", importa: true,sku1: 52,sku2: ,sku3: ,sku4: ,sku5: ,sku6: )
	#compra y vende el 9
		Grupo.create(idgrupo: "572aac69bdb6d403005fb04a" , numero: 9, cuenta: "572aac69bdb6d403005fb04a", importa: true,sku1: 20,sku2: ,sku3: ,sku4: ,sku5: ,sku6: )
		Grupo.create(idgrupo: "572aac69bdb6d403005fb043", numero: 2, cuenta: "572aac69bdb6d403005fb04f", importa: true,sku1: ,sku2: ,sku3: ,sku4: ,sku5: ,sku6: )

	##### nos venden
		Grupo.create(idgrupo: "572aac69bdb6d403005fb04d" , numero: 12, cuenta: "572aac69bdb6d403005fb05a", importa: true,sku1: 7, sku2: ,sku3: ,sku4: ,sku5: ,sku6: )
	####compra y vende el 6
		Grupo.create(idgrupo: "572aac69bdb6d403005fb047", numero: 6, cuenta: "572aac69bdb6d403005fb053", importa: true,sku1: 13, sku2: 25, sku3: ,sku4: ,sku5: ,sku6: )
		Grupo.create(idgrupo: "572aac69bdb6d403005fb049", numero: 8, cuenta: "572aac69bdb6d403005fb056", importa: true,sku1: 26,sku2: ,sku3: ,sku4: ,sku5: ,sku6: )
		Grupo.create(idgrupo: "572aac69bdb6d403005fb045", numero: 4, cuenta: "572aac69bdb6d403005fb051", importa: true,sku1: 38,sku2: ,sku3: ,sku4: ,sku5: ,sku6: )
# template: Grupo.create(idgrupo: , numero:   , cuenta: , importa: true,sku1: ,sku2: ,sku3: ,sku4: ,sku5: ,sku6: )
		end
end
