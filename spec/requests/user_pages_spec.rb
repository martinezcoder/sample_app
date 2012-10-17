require 'spec_helper'

describe "User Pages" do

	subject { page }

	describe "Pagina de registro" do
		before { visit signup_path }

		it { should have_selector('h1',	text: 'Registro') }
		it { should have_selector('title', text: full_title('Registro')) }  
  end
end
