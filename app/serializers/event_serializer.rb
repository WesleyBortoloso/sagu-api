class EventSerializer
  include JSONAPI::Serializer

  attributes :description, :created_at, :author_id, :eventable_id
end
