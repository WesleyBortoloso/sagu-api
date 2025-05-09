class Schedule < ApplicationRecord
  belongs_to :parent, class_name: 'Parent'
  belongs_to :student, class_name: 'Student'
  belongs_to :relator, class_name: 'User'
  has_many :events, as: :eventable, dependent: :destroy

  enum :area, {
    academic: 'Acadêmica',
    administrative: 'Administrativa',
    pedagogic: 'Pedagógica'
  }

  enum :status, {
    waiting: 'waiting',
    confirmed: 'confirmed',
    rejected: 'rejected'
  }

  validates :starts_at, :subject, :area, :status, presence: true
  validate :must_be_afternoon
  validate :no_time_conflict

  scope :on_date, ->(date) {
    where(starts_at: date.beginning_of_day..date.end_of_day)
  }
  
  scope :for_relator, ->(relator_id) {
    where(relator_id: relator_id)
  }

  def must_be_afternoon
    hour = starts_at.hour
    unless (13..18).include?(hour)
      errors.add(:starts_at, "só permite agendamento entre 13h e 18h")
    end
  end
  
  def no_time_conflict
    conflict = Schedule.where(relator: relator, starts_at: starts_at)
    conflict = conflict.where.not(id: id) if persisted?
  
    if conflict.exists?
      errors.add(:starts_at, "já reservado para este horário")
    end
  end

  def self.available_slots_for(date:, relator: nil)
    hours = (13..18).map { |h| Time.zone.parse("#{date} #{h}:00") }
  
    taken = Schedule.on_date(date)
    taken = taken.for_relator(relator) if relator.present?
  
    taken_hours = taken.pluck(:starts_at).map { |t| t.strftime('%H:%M') }
  
    hours.reject { |t| taken_hours.include?(t.strftime('%H:%M')) }
         .map { |t| t.strftime('%H:%M') }
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[area status starts_at student_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[student]
  end
end
