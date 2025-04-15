module Responsible
  extend ActiveSupport::Concern

  included do
    has_many :responsible_occurrencies, class_name: 'Occurrency', foreign_key: :responsible_id, dependent: :nullify
    has_many :responsible_orientations, class_name: 'Orientation', foreign_key: :responsible_id, dependent: :nullify
  end
end
