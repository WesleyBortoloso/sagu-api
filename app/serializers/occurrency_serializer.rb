class OccurrencySerializer
  include JSONAPI::Serializer

  attributes :title, :description, :kind, :status

  belongs_to :student
  belongs_to :relator, serializer: UserSerializer
  belongs_to :responsible, serializer: UserSerializer
  has_many :events
end
