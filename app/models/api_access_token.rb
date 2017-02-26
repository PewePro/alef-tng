class ApiAccessToken < ActiveRecord::Base
  belongs_to :user

  def self.verify(token)
    tkn = ApiAccessToken.where(token: token).first

    if tkn && tkn.expires_at < Time.now
      tkn.destroy!
      return false
    end

    tkn ? tkn : nil
  end

end