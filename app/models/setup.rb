class Setup < ActiveRecord::Base
  belongs_to :course
  has_many :user_to_lo_relations
  has_many :setups_users
  has_many :weeks
  has_many :learning_objects, through: :weeks
  has_and_belongs_to_many :users

  FILEPATH_RELATIVE = "shared/statreports/"
  FILEPATH_ABSOLUTEPREFIX = Rails.root

  def self.get_full_path(report_relative_path)
    return File.join(FILEPATH_ABSOLUTEPREFIX, report_relative_path)
  end

  def self.get_relative_path(report_filename)
    return File.join(FILEPATH_RELATIVE, report_filename)
  end

  def self.ensure_reports_path_exists
    FileUtils.mkdir_p File.join(FILEPATH_ABSOLUTEPREFIX, FILEPATH_RELATIVE)
  end

  def compute_stats()
    filename = "course#{self.id}_report_#{Time.now.strftime("%Y_%m_%d_-_%H_%M_%S")}.xlsx"

    filepath_relative = self.class.get_relative_path(filename)
    filepath_full = self.class.get_full_path(filepath_relative)

    self.class.ensure_reports_path_exists

    Stats::StatsComputer::save_stats(self, filepath_full)

    return filepath_full
  end

  def get_actual_weeks()
    all_weeks = self.weeks.order(:number).reverse_order
    right_weeks = all_weeks.select { |aw| (aw.start_at <= Time.now.to_date)}
    return right_weeks
  end
end