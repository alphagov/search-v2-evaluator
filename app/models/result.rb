class Result
  include ActiveModel::Model

  attr_accessor :title, :description, :link, :content_id, :document_type, :public_timestamp, :parts

  def parts?
    parts.any?
  end
end
