require "http"
require "base64"
require "cgi"
require "openssl"
require "json"


class WelcomeController < ApplicationController
	def index

	end

	def doc

	end

	def success

	end


	def twitt 

		tweet = twitte params[:mensaje]  , "nada"

	   response = { :estado => "aceptado", :tweet => tweet}
		render :json => response

	end

	def twitte (mensaje, url)

		tweet=mensaje + " " + url
		require 'koala'

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



	def face mensaje


		msg = faceboki params[:mensaje] ,"nada"

	   response = { :estado => "aceptado", :tweet => msg}
		render :json => response

	end

	def faceboki (mensaje, url)
		promo = mensaje
		
		@page = Koala::Facebook::API.new('EAACEdEose0cBAKTJYnTFldZApk4g7KOnCooLVEeFciYxYuReobzJ6pn5K8Hpr9UhTn7YPweEkroIbkZCd1PYFLRiLyogE4iyAzyTvd3mQum2N8sAYnZCEw2O9dzxKbz414076SeRAVk6OL25wQRJqmgnmDzZCZB3bn5NmFTRtaFrQxZCNYmuhM')
		puts "hola"

		@page.put_connections('me', "photos", :caption => promo , :url => "http://integra6.ing.puc.cl/spree/products/1/product/arroz.jpg")

		@user = Koala::Facebook::API.new("EAACEdEose0cBAMReVE4VpAuWEeywrxiYm7fX6N45q0PN20Gg1FjhQ2hkZCZAYuBXcwNBJ79CRWN2Nz2KpGvvVQqD2YgvouZCIwwuho28VIllmS8To3Ib4LLHLysqTuHqhEtqg5S3ZCGW6G8zalBCw72Nxa5zZBQ2UMLZCcyqztxrqgiixPkbnj")
		@user.put_connections("me", "feed", :message => promo, :image_url => url) ## "http://integra6.ing.puc.cl/spree/products/1/product/arroz.jpg")

		promo
	end


	def promocionar (mensaje, url)
		faceboki mensaje url
		twitt mensaje
	end




end
