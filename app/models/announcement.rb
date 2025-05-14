class Announcement < ApplicationRecord
  validates :title, :content, :date, presence: true
end