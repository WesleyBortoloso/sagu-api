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
      scope = apply_filters(Schedule.all.order(starts_at: :desc), %i[area status starts_at student_id])
      schedules, meta = apply_pagination(scope)

      present serialize(schedules, meta)
    end

    desc 'Show details of a specific schedule'
    params do
      requires :schedule_id, type: String, desc: 'Schedule UUID'
    end

    route_param :schedule_id do
      get do
        schedule = Schedule.find(params[:schedule_id])

        present ScheduleSerializer.new(
          schedule,
          include: [:relator, :parent, :student]
        )
      end
    end
  end
end
