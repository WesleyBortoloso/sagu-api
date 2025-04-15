class Parent < User
  has_many :authorizations, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :orientations, dependent: :destroy
end
