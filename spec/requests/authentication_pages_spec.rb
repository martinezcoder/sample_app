require 'spec_helper'

describe "Autenticacion:" do

	subject { page }

	describe "Un usuario visita la pagina de Acceso a la session. " do

		before { visit signin_path }

		it { should have_selector('h1', text: 'Acceder') }
		it { should have_selector('title', text: 'Acceder') }

		describe "Introduce informacion INVALIDA y presiona Acceder. " do
			before { clicar_submit }
	
			it { should have_selector('title', text: 'Acceder') }
			it { should have_selector('div.alert.alert-error', text: 'Invalid') }

			describe "Posteriormente visita otra pagina. " do
				before { click_link "Home" }
				it { should_not have_selector('div.alert.alert-error') }
			end

		end

	  describe "Introduce informacion valida y presiona Acceder. " do
			let(:user) { FactoryGirl.create(:user) }
			before { sign_in user }

			it { should have_selector('title', text: user.name) }
			it { should have_link('Perfil', href: user_path(user)) }
			it { should have_link('Ajustes', href: edit_user_path(user)) } 
			it { should have_link('Salir', href: signout_path) }
			it { should_not have_link('Acceder', href: signin_path) }

			describe "Y sale de la session. " do
				before { click_link "Salir" }
				it { should have_link('Entrar') }
			end

		end

	end
	

	describe "Autorizacion. " do

		describe "Si no estas loggeado y " do

			let(:user) { FactoryGirl.create(:user)  }
				
			describe "intentas editar un usuario: debe ir a la pag de LOGIN " do
				before { visit edit_user_path(user) }
				it { should have_selector('title', text: 'Acceder') }
			end

			describe "accedes a la accion PUT del controlador: debe ir a la pag de LOGIN " do
				before { put user_path(user) }
				specify { response.should redirect_to(signin_path) }
			end
		
		end

		describe "Si eres un usuario incorrecto y " do

			let(:user) { FactoryGirl.create(:user)  }
			let(:wrong_user) { FactoryGirl.create(:user, email: "otrouser@ejemplo.com") }
			before { sign_in user }

	
			describe "intentas editar otro usuario. " do
				before { visit edit_user_path(wrong_user) }
				it { should_not have_selector('title', text: full_title('Editar usuario')) }
			end

			describe "accedes a la accion PUT del controlador. " do
				before { put user_path(wrong_user) }
				specify { response.should redirect_to(root_path) }
			end

		end

	end

end
