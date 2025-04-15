class Staff < User
  include Relator
  include Responsible

  jsonb_accessor :extra_info,
                 role: :string,
                 department: :string

  validates :role, :department, presence: true
end
