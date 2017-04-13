class Api::V1::UserToLoRelationSerializer < Api::V1::BaseSerializer
  attributes :id, :user_id, :learning_object_id, :setup_id, :type, :interaction, :created_at, :updated_at
end