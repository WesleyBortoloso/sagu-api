class StudentSerializer
  include JSONAPI::Serializer

  attributes :name, :email, :document, :enrollment, :situation
end
