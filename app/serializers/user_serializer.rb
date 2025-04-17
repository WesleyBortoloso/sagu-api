class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :name, :document, :type
end
