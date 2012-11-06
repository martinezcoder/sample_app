class UsersController < ApplicationController

	def new
		@user = User.new
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			flash[:success] = "Bienvenido a SocialWin Analytics!"
			redirect_to @user # ¿sería lo mismo poner:	render 'show'?
		else
			render 'new'
		end
	end

	def show
		@user = User.find(params[:id])
	end



end
