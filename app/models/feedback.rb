class Feedback < ActiveRecord::Base
  belongs_to :user

  def url_path
    URI.parse(self.url).path
  end

end
