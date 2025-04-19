class ParentSerializer
  include JSONAPI::Serializer

  attributes :name, :email, :document

  has_many :students, serializer: StudentSerializer
end
