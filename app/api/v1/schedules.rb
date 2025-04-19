class V1::Schedules < Grape::API
  include UserAuthenticated

  helpers do
    def serialize(resource, meta)
      ScheduleSerializer.new(
        resource,
        meta: meta,
        links: pagination_links(resource, request.path)
      )
    end
  end

  resource :schedules do
    desc 'List all schedules'
    get do
      scope = apply_filters(Schedule.all, %i[area status])
      schedules, meta = apply_pagination(scope)

      present serialize(schedules, meta)
    end
  end
end
