class ClassroomSerializer
  include JSONAPI::Serializer

  attributes :name, :year, :grade,
             :external_id, :created_at
end