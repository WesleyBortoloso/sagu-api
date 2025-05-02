class Schedule < ApplicationRecord
  belongs_to :parent, class_name: 'Parent'
  belongs_to :student, class_name: 'Student'
  belongs_to :relator, class_name: 'User'

  enum :area, {
    academic: 'Acadêmica',
    administrative: 'Administrativa',
    pedagogic: 'Pedagógica'
  }

  enum :status, {
    waiting: 'Aguardando',
    confirmed: 'Confirmada',
    rejected: 'Rejeitada'
  }

  validates :starts_at, :subject, :area, :status, presence: true
  validate :must_be_afternoon
  validate :no_time_conflict

  def must_be_afternoon
    hour = scheduled_at.hour
    unless (13..18).include?(hour)
      errors.add(:scheduled_at, "só permite agendamento entre 13h e 18h")
    end
  end

  def no_time_conflict
    conflict = Schedule.where(relator: relator, scheduled_at: scheduled_at)
    conflict = conflict.where.not(id: id) if persisted?

    if conflict.exists?
      errors.add(:scheduled_at, "já reservado para este horário")
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[area status starts_at student_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[student]
  end
end
