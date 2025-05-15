class ClassroomSerializer
  include JSONAPI::Serializer

  attributes :name, :year, :grade, :course,
             :external_id, :created_at
end