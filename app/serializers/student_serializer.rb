class StudentSerializer
  include JSONAPI::Serializer

  attributes :name, :email, :document, :enrollment, :situation, :phone, :gender, :birthdate

  belongs_to :classroom
  belongs_to :parent
  has_many :occurrencies
  has_many :authorizations
  has_many :orientations
  has_many :schedules
  has_many :documents
end
