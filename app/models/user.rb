class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Allowlist
  devise :database_authenticatable, :jwt_authenticatable,
         :validatable, jwt_revocation_strategy: self

  validates :name, :document, presence: true
  has_many :allowlisted_jwts, class_name: 'AllowlistedJwt', dependent: :destroy

  enum role: {
    psychologist: "psychologist",
    server: "server",
    manager: "manager"
  }, _prefix: true
end
