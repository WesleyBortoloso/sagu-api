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
      scope = apply_filters(Authorization.all.order(created_at: :desc), %i[date status student_id])
      authorizations, meta = apply_pagination(scope)

      present serialize(authorizations, meta)
    end

    desc 'Show details of a specific authorization'
    params do
      requires :authorization_id, type: String, desc: 'Authorization UUID'
    end

    route_param :authorization_id do
      get do
        authorization = Authorization.find(params[:authorization_id])

        present AuthorizationSerializer.new(
          authorization,
          include: [:student, :parent]
        )
      end
    end
  end
end
