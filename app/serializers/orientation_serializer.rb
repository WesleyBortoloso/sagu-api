class OrientationSerializer
  include JSONAPI::Serializer

  attributes :title, :description,
             :area, :status, :created_at

  belongs_to :student
  belongs_to :parent
  belongs_to :relator, serializer: UserSerializer
  belongs_to :responsible, serializer: UserSerializer
  has_many :events, serializer: EventSerializer
end