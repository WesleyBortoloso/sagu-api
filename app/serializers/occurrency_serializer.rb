class OccurrencySerializer
  include JSONAPI::Serializer

  attributes :title, :description, :kind, :status,
             :student_id, :relator_id,
             :responsible_id
end
