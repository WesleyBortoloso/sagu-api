class AuthorizationSerializer
  include JSONAPI::Serializer

  attributes :date, :description, :status, :created_at

  belongs_to :student
  belongs_to :parent
  has_many :events
end