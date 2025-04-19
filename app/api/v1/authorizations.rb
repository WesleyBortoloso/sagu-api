class V1::Authorizations < Grape::API
  include UserAuthenticated

  helpers do
    def serialize(resource, meta)
      AuthorizationSerializer.new(
        resource,
        meta: meta,
        links: pagination_links(resource, request.path)
      )
    end
  end

  resource :authorizations do
    desc 'List all authorizations'
    get do
      scope = apply_filters(Authorization.all, %i[date])
      authorizations, meta = apply_pagination(scope)

      present serialize(authorizations, meta)
    end
  end
end
