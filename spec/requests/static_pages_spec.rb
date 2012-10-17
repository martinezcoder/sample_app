require 'spec_helper'

describe "Static pages" do

	subject { page }


	it "Debe tener bien los enlaces del header" do
		visit root_path
		click_link "Home"
		should have_selector 'title', text: full_title('')
		click_link "Ayuda"
		should have_selector 'title', text: full_title('Ayuda')
#		click_link "Entrar"
#		should have_selector 'title', text: full_title('Ayuda')
	end

	it "Debe tener bien los enlaces del footer" do
		visit root_path
		click_link "Sobre Nosotros"
		should have_selector 'title', text: full_title('Sobre Nosotros')
		click_link "Contacto"
		should have_selector 'title', text: full_title('Contacto')
	end


  describe "Home page" do
		before { visit root_path }

		it { should have_selector('h1', text: 'SocialWin Analytics') }
		it { should have_selector('title', text: full_title('')) }
    it { should_not have_selector 'title', text: "| Inicio" }

#		it "debe tener el link de Registro" do
#			click_link "Regístrate!"
#			should have_selector 'title', text: full_title('Registro')
#			click_link ""
#		end

	end

  describe "Ayuda page" do
		before { visit help_path }

		it { should have_selector('h1', text: 'Ayuda') }
		it { should have_selector('title', text: full_title('Ayuda')) }
	end

	describe "Nosotros page" do
		before { visit about_path }

		it { should have_selector('h1', :text => 'Sobre Nosotros') }
		it { should have_selector('title', text: full_title('Sobre Nosotros')) }
  end

	describe "Contact page" do
		before { visit contact_path }

		it { should have_selector('h1', text: 'Contacto') }
		it { should have_selector('title', text: full_title('Contacto')) }
	end

end


