class PageView < ApplicationRecord
  validates :path, :viewed_on, presence: true

  def self.record(path)
    record = find_or_initialize_by(path: path, viewed_on: Date.current)
    record.count = record.count.to_i + 1
    record.save!
  end
end
