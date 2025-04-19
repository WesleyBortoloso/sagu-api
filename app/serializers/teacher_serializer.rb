class TeacherSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :email, :document, :external_id
end
