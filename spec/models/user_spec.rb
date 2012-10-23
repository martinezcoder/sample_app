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
#  pending "add some examples to (or delete) #{__FILE__}"

	before { @user = User.new(name: "test user", email: "user@test.es")}

	subject { @user }

	it { should respond_to(:name)  }
	it { should respond_to(:email) }
#	it { should respond_to(:otro)  }

end