module PromsModule
	$contador=1


	def publicar (mensaje , url)
		twitte $contador.to_s + ". " +mensaje , url
		faceboki $contador.to_s + ". " +mensaje , url
		$contador +=1
	end


	def twitte (mensaje, url)

		tweet=mensaje + " " + url
	

		  puts ENV['TWITTER_API_KEY']
		#Obtenemos lo que el usuario digite

		$client = Twitter::REST::Client.new do |config|
        config.consumer_key        = "3AfUr9FNARgNshCdTSGqwCjab"
          config.consumer_secret     = "wIVqmXvd4Q7cKOsINjvPEQuMylXJxXzyvAo5MK90TgPALFUXry"
          config.access_token        = "747830570693033986-W135KI7EOgqturqlk7AoF6TDS9SH8aV"
          config.access_token_secret = "YuU1cTnI7obvb2ugESPCWYGrCVqRq3DeHwgLCva2uFUDC"
      end


	   $client.update(tweet)

	   tweet

	end





	def faceboki (mensaje, url)
		promo = mensaje

		@user = Koala::Facebook::API.new("EAAP57BMYZCtsBALrNnkeSWe0ZBW01oR6ocrl26O3Q7i0QWA5A6ooi7RNZBtrjnI7ApPhGDsAQTxb8rEuKlv2qAXVSZCAtP5rqLZBXYj00i0qqZBr7A0pmrddipFvEASSdCS0LVwWhBqG6heLtrljxs4fkE4P8MHDgZD")
		@user.put_connections("me", "feed", :message => promo, :image_url => url) ## "http://integra6.ing.puc.cl/spree/products/1/product/arroz.jpg")


		@page = Koala::Facebook::API.new('EAAP57BMYZCtsBAGh6NFIKfaHO3uidCYYfz7LjNk3AsOvLZASO7ycFd0JzzTaAxedZC5tnmnSv3kZCzgbPh4OfoDykcFGxYMKOfTEsj7pfCGhGUhdxI409C1Eag1OMny906n4WuB5ZBHZBbQkUCvhjoXt2ugiBaGZBJZCC9p9Vd8bQvaZAWZB9Eu6lg')
		puts "hola"


		@page.put_connections('me', "photos", :caption => promo , :url => "http://integra6.ing.puc.cl/spree/products/1/product/arroz.jpg")

		
		promo
	end


	def promocionar (mensaje, url)
		faceboki mensaje url
		twitt mensaje
	end





end