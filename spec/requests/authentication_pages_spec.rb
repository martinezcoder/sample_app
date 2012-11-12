require 'spec_helper'

describe "Autenticacion:" do

	subject { page }

	describe "accediendo" do

	  let(:submit) { "Acceder" }
		
		before { visit signin_path }

		it { should have_selector('h1', text: 'Acceder') }
		it { should have_selector('title', text: 'Acceder') }

		describe "con informacion invalida" do
			before { click_button submit }
	
			it { should have_selector('title', text: 'Acceder') }
			it { should have_selector('div.alert.alert-error', text: 'Invalid') }

			describe "y posteriormente visitar otra pagina" do
				before { click_link "Home" }
				it { should_not have_selector('div.alert.alert-error') }
			end

		end

=begin		
	  describe "con informacion valida" do
			let(:user) { FactoryGirl.create(:user) }
	    before do
	        fill_in "Email",       with: user.email 
	        fill_in "Password",    with: user.password
					click_button submit 
	    end

			it { should have_selector('title', user.name) }
#			it { should have_link('Perfil', href: user_path(user)) }
#			it { should have_link('Salir', href: signout_path) }
#			it { should_not have_link('Acceder', href: signin_path) }
		end

=end
	end
	

end
