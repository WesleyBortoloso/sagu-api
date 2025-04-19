class Parent::DetailsSerializer
  include JSONAPI::Serializer

  attributes :name, :email, :document, :external_id

  has_many :authorizations, serializer: OccurrencySerializer
  has_many :schedules, serializer: OccurrencySerializer
  has_many :orientations, serializer: OccurrencySerializer
  has_many :students, serializer: OccurrencySerializer
end
