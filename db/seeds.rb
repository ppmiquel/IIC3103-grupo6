# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
if Grupo.first.nil?
	if false ### esperemos tener todos los datos

	####nos compran
		Grupo.create(idgrupo: , numero: 1, cuenta: , importa: true ,sku1: ,sku2: ,sku3: ,sku4: ,sku5: ,sku6: )
	#compra y vende e 5	
		Grupo.create(idgrupo: , numero: 5, cuenta: , importa: true,sku1: 52,sku2: ,sku3: ,sku4: ,sku5: ,sku6: )
	#compra y vende el 9
		Grupo.create(idgrupo: , numero: 9, cuenta: , importa: true,sku1: 20,sku2: ,sku3: ,sku4: ,sku5: ,sku6: )
		Grupo.create(idgrupo: , numero: 2, cuenta: , importa: true,sku1: ,sku2: ,sku3: ,sku4: ,sku5: ,sku6: )
		
	##### nos venden
		Grupo.create(idgrupo: , numero: 12, cuenta: , importa: true,sku1: 7, sku2: ,sku3: ,sku4: ,sku5: ,sku6: )
	####compra y vende el 6	
		Grupo.create(idgrupo: , numero: 6, cuenta: , importa: true,sku1: 13, sku2: 25, sku3: ,sku4: ,sku5: ,sku6: )
		Grupo.create(idgrupo: , numero: 8, cuenta: , importa: true,sku1: 26,sku2: ,sku3: ,sku4: ,sku5: ,sku6: )
		Grupo.create(idgrupo: , numero: 4, cuenta: , importa: true,sku1: 38,sku2: ,sku3: ,sku4: ,sku5: ,sku6: )
# template: Grupo.create(idgrupo: , numero:   , cuenta: , importa: true,sku1: ,sku2: ,sku3: ,sku4: ,sku5: ,sku6: )
		end
end