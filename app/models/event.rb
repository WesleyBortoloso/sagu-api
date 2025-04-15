class Event < ApplicationRecord
  belongs_to :eventable, polymorphic: true
  belongs_to :author, polymorphic: true

  validates :description, presence: true
end
