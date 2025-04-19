class ScheduleSerializer
  include JSONAPI::Serializer

  attributes :starts_at, :subject, :area,
             :status, :parent_id,
             :relator_id, :student_id
             :created_at
end