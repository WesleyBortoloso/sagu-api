class OrientationSerializer
  include JSONAPI::Serializer

  attributes :title, :description, :student_id,
             :area, :status, :relator_id,
             :parent_id, :created_at, :responsible_id
end