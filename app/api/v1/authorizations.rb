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

    desc "Create an authorization"
    params do
      requires :date, type: String, desc: "Authorization starts at"
      requires :description, type: String, desc: "Authorization subject"
      requires :status, type: String, values: Authorization.statuses.keys, desc: "Authorization status"
      requires :student_id, type: String, desc: "Related student"
    end

    post do
      result = Authorization::Create.call(declared(params), current_user: current_user)

      present AuthorizationSerializer.new(result)
    end

    route_param :authorization_id do
      desc 'Show details of a specific authorization'
      params do
        requires :authorization_id, type: String, desc: 'Authorization UUID'
      end

      get do
        authorization = Authorization.find(params[:authorization_id])

        present AuthorizationSerializer.new(
          authorization,
          include: [:student, :parent, :events]
        )
      end

      desc "Update an authorization"
      params do
        requires :authorization_id, type: String, desc: 'Authorization UUID'
        optional :status, type: String, values: Authorization.statuses.keys, desc: 'Authorization status'
      end

      patch do
        result = Authorization::Update.call(declared(params), current_user: current_user)
    
        present AuthorizationSerializer.new(
          result, include: [:events]
        )
      end
    end
  end
end
