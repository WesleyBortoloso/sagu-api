class ScheduleSerializer
  include JSONAPI::Serializer

  attributes :starts_at, :subject, :area, :status

  belongs_to :relator, serializer: UserSerializer
  belongs_to :parent, serializer: ParentSerializer
end