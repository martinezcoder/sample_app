require 'spec_helper'

describe "User Pages" do

	subject { page }

	describe "User New: Pagina de registro" do

		before { visit signup_path }

		describe "Texto de pagina" do
			it { should have_selector('h1',	text: 'Registro') }
			it { should have_selector('title', text: full_title('Registro')) }  
		end

		describe "Accion Signup" do

	    let(:submit) { "Crear mi cuenta" }

	    describe "con informacion invalida" do
				before do
					# no rellenamos nada de nada. Todos los campos a NIL
				end
	      it "should not create a user" do
	        expect { click_button submit }.not_to change(User, :count)
	      end
	    
				describe "despues de clicar button Registro" do
					before { click_button submit }
					it { should have_selector('title', text: 'Registro') }
					it { should have_content('error') }
					it { should_not have_content('Password digest') }
				end
			end

	    describe "con informacion valida" do
	      before do
	        fill_in "Nombre",         with: "Example User"
	        fill_in "Email",        with: "user@example.com"
	        fill_in "Password",     with: "foobar"
	        fill_in "Confirme el password", with: "foobar"
	      end

	      it "should create a user" do
	        expect { click_button submit }.to change(User, :count).by(1)
	      end

				describe "una vez registrado el usuario" do
					before { click_button submit }
					let(:user) { User.find_by_email("user@example.com") }
					it { should have_selector('title', text: user.name) }
					it { should have_selector('div.alert.alert-success') }
				end

	    end

		end

	end


	describe "User Show: Pagina de perfil" do
		# introducimos un usuario en la BD de test
		let(:user) { FactoryGirl.create(:user) }

		# En la tabla RESTful (7.1):
		#   HTTP request     |     URI    |    Action    |    Named route    |    Purpose
		#       GET          |  /users/1  |     show     |  user_path(user)  |  page to show user
		before { visit user_path(user) }

		it { should have_selector('h1', text: user.name) }
		it { should have_selector('title', text: user.name) }
	end

	describe "User Create:" do
	end

	describe "User Index:" do
	end

	describe "User Edit:" do
	end

	describe "User Update:" do
	end

	describe "User Destroy:" do
	end

end

