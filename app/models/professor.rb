class Professor < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  #attr_accessible :email, :password, :password_confirmation, :name, :phone_number, :about

  has_many :courses
  has_many :notices
  has_many :comments
end

class Professor::ParameterSanitizer < Devise::ParameterSanitizer
  def sign_up
    default_params.permit(:email, :password, :name, :phone_number)
  end
end
