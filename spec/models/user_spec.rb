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

end

