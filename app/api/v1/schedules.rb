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

    desc 'Show details of a specific schedule'
    params do
      requires :id, type: String, desc: 'Schedule UUID'
    end

    route_param :id do
      get do
        schedule = Schedule.find(params[:id])

        present ScheduleSerializer.new(
          schedule,
          include: [:relator, :parent]
        )
      end
    end
  end
end
