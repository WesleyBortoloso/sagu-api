class EventSerializer
  include JSONAPI::Serializer

  attributes :description, :created_at, :author_id, :eventable_id, :target_id

  belongs_to :author, serializer: UserSerializer
  belongs_to :target, serializer: UserSerializer
end
