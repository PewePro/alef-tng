class Api::V1::BaseSerializer < ActiveModel::Serializer

  def created_at
    object.created_at.in_time_zone.iso8601 if object.created_at
  end

  def updated_at
    object.updated_at.in_time_zone.iso8601 if object.updated_at
  end

  def deleted_at
    object.deleted_at.in_time_zone.iso8601 if object.deleted_at
  end

end