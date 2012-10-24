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
		@user = User.new(name: "test user", email: "user@test.es")
	end

	subject { @user }

	it { should respond_to(:name)  }
	it { should respond_to(:email) }

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

end

