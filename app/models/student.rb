class Student < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :authentication_keys => [:student_number]
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable

  #attr_accessible :email, :password, :password_confirmation, :student_number, :name, :phone_number

  has_many :enrolls
  has_many :courses, through: :enrolls
  has_many :assignments, dependent: :destroy
end

class Student::ParameterSanitizer < Devise::ParameterSanitizer
  def sign_up
    default_params.permit(:student_number, :email, :password, :name, :phone_number)
  end
end
