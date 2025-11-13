class Admin < ApplicationRecord
  ## -- Devise認証 --
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :trackable
end
