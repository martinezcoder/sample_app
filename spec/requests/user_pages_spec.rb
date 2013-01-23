require 'spec_helper'

describe "User Pages" do

  subject { page }

	describe "User new: Pagina de registro" do

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
	      it "no deberia crear un usuario" do
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
	        fill_in "Nombre",       with: "Example User"
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
					it { should have_link('Salir') }
				end

	    end

		end

	end

	describe "User show: Mostrando Pagina de perfil" do
		# introducimos un usuario en la BD de test
		let(:user) { FactoryGirl.create(:user) }

    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

		# En la tabla RESTful (7.1):
		#   HTTP request     |     URI    |    Action    |    Named route    |    Purpose
		#       GET          |  /users/1  |     show     |  user_path(user)  |  page to show user
		before { visit user_path(user) }

		it { should have_selector('h1', text: user.name) }
		it { should have_selector('title', text: user.name) }

    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end

    describe "follow/unfollow buttons" do
      let(:other_user) { FactoryGirl.create(:user) }
      before { sign_in user }

      describe "following a user" do
        before { visit user_path(other_user) }

        it "should increment the followed user count" do
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end

        it "should increment the other user's followers count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Follow" }
          it { should have_selector('input', value: 'Unfollow') }
        end
      end

      describe "unfollowing a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "should decrement the followed user count" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "should decrement the other user's followers count" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should have_selector('input', value: 'Follow') }
        end
      end
    end

	end

  describe "User index" do
    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end

    it { should have_selector('title', text: 'All users') }
    it { should have_selector('h1',    text: 'All users') }

    it "should list each user" do
      User.all.each do |user|
        page.should have_selector('li', text: user.name)
      end
    end
  end


	describe "User edit: Editando la Pagina de perfil" do

		# introducimos un usuario en la BD de test
		let(:user) { FactoryGirl.create(:user) }

		before do  
			sign_in user
			visit edit_user_path(user) 
			# En la tabla RESTful (7.1):
			#   HTTP request     |     URI         |    Action    |    Named route         |    Purpose
			#       GET          |  /users/1/edit  |     edit     |  edit_user_path(user)  |  page to edit user with id 1
		end

		it { should have_selector('h1', text: "Actualiza tu perfil") }
		it { should have_selector('title', text: "Editar usuario") }
		it { should have_link('change', href: 'http://gravatar.com/emails') }

		describe ". User Update:" do
			describe "con informacion invalida" do
				before { click_button "Guardar cambios" }
				it { should have_content('error')	}
			end


			describe "con informacion valida" do

				let(:new_name)  { "New Name" }
				let(:new_email) { "new@example.com" }

				before do
					fill_in "Nombre",								with: new_name
					fill_in "Email",								with: new_email
					fill_in "Password",							with: user.password
					fill_in "Confirme el password",	with: user.password
					click_button "Guardar cambios"
				end

				it { should have_selector('title', text: new_name) }
				it { should have_selector('div.alert.alert-success') }
				it { should have_link('Salir', href: signout_path) }
				specify { user.reload.name.should  == new_name }
				specify { user.reload.email.should == new_email }

			end

		end
	end

	describe "User Destroy:" do
	end

  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }

    describe "followed users" do
      before do
        sign_in user
        visit following_user_path(user)
      end

      it { should have_selector('title', text: full_title('Following')) }
      it { should have_selector('h3', text: 'Following') }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end

    describe "followers" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end

      it { should have_selector('title', text: full_title('Followers')) }
      it { should have_selector('h3', text: 'Followers') }
      it { should have_link(user.name, href: user_path(user)) }
    end
  end
	
end

