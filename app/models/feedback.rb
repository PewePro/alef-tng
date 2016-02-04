class Feedback < ActiveRecord::Base
  belongs_to :user
  scope :not_reviewed, -> { where(accepted: nil) }
  scope :visible, -> { where(visible: true) }

  def url_path
    URI.parse(self.url).path
  end

end