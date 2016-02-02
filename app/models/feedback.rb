class Feedback < ActiveRecord::Base
  belongs_to :user

  enum admin_status: { new: 0, solved: 1 }

  def url_path
    URI.parse(self.url).path
  end

end
