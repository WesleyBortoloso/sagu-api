class DocumentSerializer
  include JSONAPI::Serializer
  
  attributes :id, :name, :kind
  
  attribute :file_url do |object|
    return unless object.file.attached?
      
    Rails.application.routes.url_helpers.rails_blob_url(object.file, only_path: true)
  end
end