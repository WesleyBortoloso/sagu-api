class ScheduleSerializer
  include JSONAPI::Serializer

  attributes :subject, :area, :status

  attribute :starts_at do |object|
    object.starts_at.iso8601
  end

  belongs_to :relator, serializer: UserSerializer
  belongs_to :parent
  belongs_to :student
  has_many :events
end