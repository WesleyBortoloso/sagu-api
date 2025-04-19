class Teacher < User
  include Relator
  include Responsible

  jsonb_accessor :extra_info, external_id: :integer

  has_many :classrooms_teachers, dependent: :destroy
  has_many :classrooms, through: :classrooms_teachers

  def self.ransackable_attributes(auth_object = nil)
    %w[name email document]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[classrooms classrooms_teachers]
  end  
end
