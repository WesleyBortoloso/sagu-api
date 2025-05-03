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

    desc "Create an schedule"
    params do
      requires :starts_at, type: String, desc: "Schedule starts at"
      requires :subject, type: String, desc: "Schedule subject"
      requires :area, type: String, values: Schedule.areas.keys, desc: "Schedule kind"
      requires :status, type: String, values: Schedule.statuses.keys, desc: "Schedule status"
      requires :student_id, type: String, desc: "Related student"
    end

    post do
      result = Schedule::Create.call(declared(params), current_user: current_user)

      present ScheduleSerializer.new(result)
    end

    route_param :orientation_id do
      get do
        orientation = Orientation.find(params[:orientation_id])

        present OrientationSerializer.new(
          orientation,
          include: [:relator, :parent, :events, :responsible, :student]
        )
      end
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
