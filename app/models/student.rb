class Student < User
  jsonb_accessor :extra_info,
                 enrollment: :string,
                 external_id: :integer,
                 situation: :string

  belongs_to :classroom, optional: true
  belongs_to :parent, class_name: 'Parent', optional: true

  has_many :occurrencies, dependent: :nullify, inverse_of: :student
  has_many :authorizations, dependent: :destroy
  has_many :orientations, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :documents, class_name: '::Document', dependent: :destroy
  has_and_belongs_to_many :conditions, join_table: 'conditions_students'
  has_one_attached :report_file

  validates :enrollment, presence: true

  enum :situation, {
    active: 'active',
    inactive: 'inactive',
    in_process: 'in_process'
  }

  def self.ransackable_attributes(auth_object = nil)
    %w[name email document classroom_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[classrooms]
  end

  def scholarships
    conditions.scholarship
  end

  def special_needs
    conditions.special_need
  end
end
