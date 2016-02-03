class Answer < ActiveRecord::Base
  belongs_to :learning_object

  # Predvolene sa pracuje iba s viditelnymi odpovedami.
  default_scope { where(visible: true) }

  def self.force_all
    return unscope where: :visible
  end
end