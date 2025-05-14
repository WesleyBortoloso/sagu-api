class V1::Announcements < Grape::API
  include UserAuthenticated

  resource :announcements do
    desc "List most recents announcements"
    get do
      announcements = Announcement.order(date: :desc).limit(3)
      present AnnouncementSerializer.new(announcements)
    end

    desc "Create a new announcement"
    params do
      requires :title, type: String, desc: "The announcement title"
      requires :content, type: String, desc: "The announcement content"
      requires :date, type: Date, desc: "The announcement date"
    end
    post do
      require_manager!
      announcement = Announcement.create!(declared(params))
      present AnnouncementSerializer.new(announcement)
    end
  end
end