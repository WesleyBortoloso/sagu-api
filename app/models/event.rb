class Event < ApplicationRecord
  belongs_to :eventable, polymorphic: true
  belongs_to :author, polymorphic: true
  belongs_to :target, polymorphic: true, optional: true

  validates :description, presence: true
end