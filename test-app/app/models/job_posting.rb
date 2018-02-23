class JobPosting < ApplicationRecord
  validates :title, presence: true

  enum status: {
    new_post: 0,
    pending: 1,
    complete: 2
  }

  after_initialize :set_defaults

  private

  def set_defaults
    self.posted_at ||= Time.zone.now
    self.status ||= "new_post"
  end
end
