class Parent < User
  has_many :authorizations, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :orientations, dependent: :destroy
  has_many :students, foreign_key: :parent_id, dependent: :nullify
end
