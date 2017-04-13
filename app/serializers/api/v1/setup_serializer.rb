class Api::V1::SetupSerializer < Api::V1::BaseSerializer
  attributes :id, :name, :first_week_at, :week_count, :course_id
end