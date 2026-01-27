class Page < ApplicationRecord
  validates :title, :slug, :content, presence: true
  validates :slug, uniqueness: true

  before_validation :set_defaults

  private

  def set_defaults
    self.slug ||= title.parameterize if title
  end
end
