class Api::V1::UserSerializer < Api::V1::BaseSerializer
  attributes :id, :first_name, :last_name, :sign_in_count, :role, :type, :proficiency
end