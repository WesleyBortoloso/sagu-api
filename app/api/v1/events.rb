class V1::Events < Grape::API
  include UserAuthenticated

  helpers do
    def serialize(resource, meta)
      EventSerializer.new(
        resource,
        meta: meta,
        links: pagination_links(resource, request.path)
      )
    end
  end

  resource :events do
    desc 'List all events'
    get do
      current_user_events = Event.where("author_id = :id OR target_id = :id", id: current_user.id)
                                 .order(created_at: :desc)
      scope = apply_filters(current_user_events, %i[created_at author_id eventable_id])
      events, meta = apply_pagination(scope)

      present serialize(events, meta)
    end

    desc "Create an event"
    params do
      requires :eventable_id, type: String, desc: "Eventable UUID"
      requires :eventable_type, type: String, desc: "Eventable Type"
      requires :description, type: String, desc: "Event description"
    end

    post do
      result = Event::CreateForEventable.call(declared(params), current_user: current_user)

      present EventSerializer.new(result)
    end

    desc 'List notifications'
    get :notifications do
      events = Event.where(target: current_user)
                    .order(created_at: :desc)
                    .limit(5)

      present EventSerializer.new(events)
    end
  end
end
