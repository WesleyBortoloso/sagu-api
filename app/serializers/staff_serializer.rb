class StaffSerializer
  include JSONAPI::Serializer

  attributes :name, :email, :document, :role,
             :department
end
