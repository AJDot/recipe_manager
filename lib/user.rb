require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt
  has_secure_password

  validates :email, uniqueness: {case_sensitive: false}

  def self.authenticate(params = {})
    return nil if params[:email].blank? || params[:password].blank?

    email = params[:email].downcase
    user = User.find_by(email: email)
    return nil if user.blank?

    password_hash = Password.new(user.password_digest)
    user if password_hash == params[:password] # The password param gets hashed for us by ==
  end
end