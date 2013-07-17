class Student < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :student_number, :name, :phone_number

  has_many :courses, through: :enrolls
  has_many :assignments, dependent: :destroy
end
