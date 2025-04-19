class Staff::DetailsSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :email, :document, :external_id

  has_many :reported_occurrencies, serializer: OccurrencySerializer
  has_many :responsible_occurrencies, serializer: OccurrencySerializer
end
