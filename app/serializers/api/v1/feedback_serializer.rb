class Api::V1::FeedbackSerializer < Api::V1::BaseSerializer
  attributes :id, :message, :user_id, :url, :created_at, :learning_object_id
end