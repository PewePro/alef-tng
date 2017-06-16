class Answer < ActiveRecord::Base
  acts_as_paranoid without_default_scope: true, column: :visible

  belongs_to :learning_object
  has_many :user_solution_lo_relations

  # Predvolene sa pracuje iba s viditelnymi odpovedami.
  default_scope { where(visible: true) }

  def self.force_all
    return unscope where: :visible
  end
end