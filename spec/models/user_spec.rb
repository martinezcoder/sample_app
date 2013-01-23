# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do

	before do
		@user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
	end

	subject { @user }

	it { should respond_to(:name)  }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:authenticate) }
	it { should respond_to(:remember_token) }

	it { should respond_to(:authenticate) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }

  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }
  
	it { should be_valid }

	describe "cuando el nombre es NIL" do
		before { @user.name = " " }

		it { should_not be_valid }
	end

	describe "cuando el email es NIL" do
		before { @user.email = " " }

		it { should_not be_valid }
	end

	describe "cuando el nombre es demasiado largo" do
		before { @user.name = "a" * 51 }

		it { should_not be_valid }
	end

	describe "cuando el formato de email es invalido" do
		it "no debe dejarnos ponerlo" do
			emails = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
			emails.each do |email_malo|
				@user.email = email_malo
				@user.should_not be_valid
			end
		end
	end

	describe "cuando el formate de email es valido" do
		it "debe dejarnos ponerlo" do
			emails = %w[user@foo.cOM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
			emails.each do |email_bueno|
				@user.email = email_bueno
				@user.should be_valid
			end
		end
	end

	describe "cuando el email ya existe en BD" do
		before do
			usuario_repetido = @user.dup
			usuario_repetido.email = usuario_repetido.email.upcase
			usuario_repetido.save
		end
		
		it { should_not be_valid } 
	end
	
	describe "cuando el emails esta en mayus y minus" do
		let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

		it "debe estar todo en lower-case" do
			@user.email = mixed_case_email
			@user.save
			@user.reload.email.should == mixed_case_email.downcase
		end
	end

	describe "cuando el password esta vacio" do
		before { @user.password = @user.password_confirmation = " " }
		it { should_not be_valid }
	end

	describe "cuando el password no coincide con la confirmacion" do
		before { @user.password_confirmation = "diferente" }
		it { should_not be_valid }
	end

	describe "cuando el password es nulo" do
		before { @user.password_confirmation = nil }
		it { should_not be_valid }
	end


	describe "cuando el password es demasiado corto" do
		before { @user.password = @user.password_confirmation = "a" * 5 }
		it { should be_invalid }
	end

	describe "devuelve el valor de autenticarse" do
		before { @user.save }
		let(:found_user) { User.find_by_email(@user.email) }

		describe "con password valido" do
			it { should == found_user.authenticate(@user.password) }
		end
		
		describe "con password invalido" do
			let(:user_for_invalid_password) { found_user.authenticate("invalid") }

			it { should_not == user_for_invalid_password }
			specify { user_for_invalid_password.should be_false }
		end
	end

	describe "remember token no debe estar en blanco:" do
		before { @user.save }
		its(:remember_token) { should_not be_blank }
	end



  describe "micropost associations" do

    before { @user.save }
    let!(:older_micropost) do 
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      @user.microposts.should == [newer_micropost, older_micropost]
    end

    it "should destroy associated microposts" do
      microposts = @user.microposts.dup
      @user.destroy
      microposts.should_not be_empty
      microposts.each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        @user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "Lorem ipsum") }
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do
        followed_user.microposts.each do |micropost|
          should include(micropost)
        end
      end
    end
  end
  
  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }    
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end

    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end

end

