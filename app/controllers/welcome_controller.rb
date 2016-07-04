require "http"
require "base64"
require "cgi"
require "openssl"
require "json"
require 'koala'
require 'proms_module'


class WelcomeController < ApplicationController
	include PromsModule

	def index

	end

	def index2

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




	def face

		msg = publica params[:mensaje] , "nada"

	   response = { :estado => "aceptado", :tweet => msg}
		render :json => response

	end


	def promocionar (mensaje, url)
		faceboki mensaje url
		twitt mensaje
	end




end
