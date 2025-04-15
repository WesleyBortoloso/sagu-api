module Relator
  extend ActiveSupport::Concern

  included do
    has_many :reported_occurrencies, class_name: 'Occurrency', foreign_key: :relator_id, dependent: :nullify
    has_many :reported_orientations, class_name: 'Orientation', foreign_key: :relator_id, dependent: :nullify
    has_many :reported_events, as: :author, class_name: 'Event', dependent: :nullify
  end
end
