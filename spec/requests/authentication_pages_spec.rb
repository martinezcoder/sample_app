require 'spec_helper'

describe "Autenticacion:" do

	subject { page }

	describe "Un usuario visita la pagina de Acceso a la session" do

	  let(:submit) { "Acceder" }
		
		before { visit signin_path }

		it { should have_selector('h1', text: 'Acceder') }
		it { should have_selector('title', text: 'Acceder') }

		describe ". Introduce informacion INVALIDA y presiona Acceder" do
			before { click_button submit }
	
			it { should have_selector('title', text: 'Acceder') }
			it { should have_selector('div.alert.alert-error', text: 'Invalid') }

			describe ". Posteriormente visita otra pagina" do
				before { click_link "Home" }
				it { should_not have_selector('div.alert.alert-error') }
			end

		end

	  describe ". Introduce informacion valida y presiona Acceder" do
			let(:user) { FactoryGirl.create(:user) }
	    before do
	        fill_in "Email",       with: user.email 
	        fill_in "Password",    with: user.password
					click_button submit 
	    end

			it { should have_selector('title', text: user.name) }
			it { should have_link('Perfil', href: user_path(user)) }
			it { should have_link('Salir', href: signout_path) }
			it { should_not have_link('Acceder', href: signin_path) }

			describe ". Y sale de la session" do
				before { click_link "Salir" }
				it { should have_link('Entrar') }
			end

		end

	end
	

end
