class Student < User
  jsonb_accessor :extra_info,
                 enrollment: :string,
                 external_id: :integer,
                 situation: :string

  validates :enrollment, :situation, presence: true

  belongs_to :classroom, optional: true
  has_many :occurrencies, dependent: :nullify, inverse_of: :student
  has_many :authorizations, dependent: :destroy
  has_many :orientations, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :documents, dependent: :destroy
end
