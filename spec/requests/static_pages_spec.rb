require 'spec_helper'

describe "Static pages" do

	subject { page }


	it "Debe tener bien los enlaces del header" do
		visit root_path
		click_link "Home"
		should have_selector 'title', text: full_title('')
		click_link "Ayuda"
		should have_selector 'title', text: full_title('Ayuda')
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

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end
  
        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end

    end

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


