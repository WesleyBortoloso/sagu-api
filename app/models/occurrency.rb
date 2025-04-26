class Occurrency < ApplicationRecord
  belongs_to :student, class_name: 'Student', inverse_of: :occurrencies
  belongs_to :relator, class_name: 'User'
  belongs_to :responsible, class_name: 'User'
  has_many :events, as: :eventable, dependent: :destroy

  enum :kind, {
    health: 'Saúde',
    discipline: 'Disciplinar',
    administrative: 'Administrativa',
    other: 'Outra'
  }

  enum :severity, {
    normal: 'Normal',
    medium: 'Média',
    high: 'Alta'
  }

  enum :status, {
    open: 'Aberta',
    in_progress: 'Em progresso',
    resolved: 'Resolvida',
    closed: 'Fechada'
  }

  validate :valid_relator_responsible

  def valid_relator_responsible
    allowed = %w[Teacher Staff]
    errors.add(:relator, 'invalid type') unless relator.type.in?(allowed)
    errors.add(:responsible, 'invalid type') unless responsible.type.in?(allowed)
  end
end
