class DocumentSerializer
  include JSONAPI::Serializer
  
  attributes :id, :name, :kind
  
  attribute :file_url do |object|
    next unless object.file.attached?

    Rails.application.routes.url_helpers.rails_blob_url(object.file, disposition: "inline")
  end

  attribute :download_url do |object|
    next unless object.file.attached?

    Rails.application.routes.url_helpers.rails_blob_url(object.file, disposition: "attachment")
  end
end