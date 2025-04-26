module V1
  class Base < Grape::API
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
  end
end
