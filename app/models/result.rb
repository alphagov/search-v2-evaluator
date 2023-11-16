class Result
  include ActiveModel::Model

  attr_accessor :title, :description, :link, :metadata, :content_id, :document_type
end
