module V1
  class Base < Grape::API
    before do
      error!('Unauthorized - Invalid API Key', 401) unless valid_api_key?
    end

    mount V1::Auth
    mount V1::Occurrencies
    mount V1::Students
    mount V1::Parents
    mount V1::Staffs
    mount V1::Teachers
    mount V1::Authorizations
    mount V1::Schedules
    mount V1::Orientations
    mount V1::Classrooms
    mount V1::Dashboard
    mount V1::Events
    mount V1::Conditions
    mount V1::Users
    mount V1::PushTokens
    mount V1::Announcements
  end
end
