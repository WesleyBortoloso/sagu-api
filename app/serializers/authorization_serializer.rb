class AuthorizationSerializer
  include JSONAPI::Serializer

  attributes :date, :description, :student_id,
             :parent_id, :created_at
end