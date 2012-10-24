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

class User < ActiveRecord::Base
  attr_accessible :email, :name
	
	validates :name, presence: true, length: { maximum: 50 }  # lo mismo que:  validates(:name, presence: true, ...)

	VALID_EMAIL_REGEX = /\A[\w+\-.]@[a-z\d\-.]+\.[a-z]+\z/i

	#VALID_EMAIL_REGEX =	/\A(_+|.+|\w+)@\w+(.+|\w+)\w+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }

end
