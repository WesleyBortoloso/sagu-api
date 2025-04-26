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
      scope = apply_filters(Event.all, %i[created_at author_id eventable_id])
      events, meta = apply_pagination(scope)

      present serialize(events, meta)
    end
  end
end
