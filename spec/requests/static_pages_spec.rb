require 'spec_helper'

describe "Static pages" do

	subject { page }

  describe "Home page" do
		before { visit root_path }

		it { should have_selector('h1', text: 'SocialWin Analytics') }
		it { should have_selector('title', text: full_title('')) }
    it { should_not have_selector 'title', text: "| Inicio" }
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


