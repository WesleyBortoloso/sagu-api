class ConditionSerializer
  include JSONAPI::Serializer

  attributes :name, :category, :description
end