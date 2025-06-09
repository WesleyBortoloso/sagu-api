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
    desc "List all schedules"
    get do
      scope = apply_filters(SchedulePolicy.new(current_user).resolve.order(starts_at: :asc), %i[area status starts_at student_id])
      schedules, meta = apply_pagination(scope)

      present serialize(schedules, meta)
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

    desc "List all available hours for a specific date"
    params do
      requires :starts_at, type: Date, desc: "Target date"
      requires :relator_id, type: String, desc: "Relator ID"
    end
    get :available_slots do
      available = Schedule.available_slots_for(
        date: params[:starts_at],
        relator: params[:relator_id]
      )

      present(data: { date: params[:starts_at].to_s, available_slots: available })
    end

    route_param :schedule_id do
      desc "Show details of a specific schedule"
      params do
        requires :schedule_id, type: String, desc: "Schedule UUID"
      end

      get do
        schedule = Schedule.find(params[:schedule_id])

        present ScheduleSerializer.new(
          schedule,
          include: [:relator, :parent, :student, :events]
        )
      end

      desc "Update an schedule"
      params do
        requires :schedule_id, type: String, desc: "Schedule UUID"
        optional :area, type: String, values: Schedule.areas.keys, desc: "Schedule area"
        optional :status, type: String, values: Schedule.statuses.keys, desc: "Schedule status"
      end
    
      patch do
        result = Schedule::Update.call(declared(params), current_user: current_user)
    
        present ScheduleSerializer.new(
          result, include: [:events]
        )
      end
    end
  end
end
