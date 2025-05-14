class AnnouncementSerializer
  include JSONAPI::Serializer

  attributes :title, :content, :date
end