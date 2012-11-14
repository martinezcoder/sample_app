module SessionsHelper

	def sign_in(user)
		#no cierra hasta que no salgamos:   cookies.permanent[:remember_token] = user.remember_token
		cookies[:remember_token] = user.remember_token
		self.current_user = user
	end

	def signed_in?
		!current_user.nil?  # esto llamará a la función "def curren_user" que buscará en BD el token del usuario
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		@current_user ||= User.find_by_remember_token(cookies[:remember_token])
	end

	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
	end

end
