class Teacher < User
  include Relator
  include Responsible

  jsonb_accessor :extra_info, external_id: :integer

  has_many :classrooms_teachers, dependent: :destroy
  has_many :classrooms, through: :classrooms_teachers
end
