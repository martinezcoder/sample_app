require 'spec_helper'

describe "User Pages" do

	subject { page }

	describe "Pagina de registro" do
		before { visit signup_path }

		it { should have_selector('h1',	text: 'Registro') }
		it { should have_selector('title', text: full_title('Registro')) }  
  end

	describe "Pagina de perfil de usuario" do
		# introducimos un usuario en la BD de test
		let(:user) { FactoryGirl.create(:user) }

		# En la tabla RESTful (7.1):
		#   HTTP request     |     URI    |    Action    |    Named route    |    Purpose
		#       GET          |  /users/1  |     show     |  user_path(user)  |  page to show user
		before { visit user_path(user) }

		it { should have_selector('h1', text: user.name) }
		it { should have_selector('title', text: user.name) }
	end

end

