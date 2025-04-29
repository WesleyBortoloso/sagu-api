class Student < User
  jsonb_accessor :extra_info,
                 enrollment: :string,
                 external_id: :integer,
                 situation: :integer

  belongs_to :classroom, optional: true
  belongs_to :parent, class_name: 'Parent', optional: true

  has_many :occurrencies, dependent: :nullify, inverse_of: :student
  has_many :authorizations, dependent: :destroy
  has_many :orientations, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :documents, class_name: '::Document', dependent: :destroy

  validates :enrollment, :situation, presence: true

  enum :situation, {
    active: 'Ativo',
    inactive: 'Inativo',
    in_process: 'Em processo'
  }

  def self.ransackable_attributes(auth_object = nil)
    %w[name email document classroom_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[classrooms]
  end
end
