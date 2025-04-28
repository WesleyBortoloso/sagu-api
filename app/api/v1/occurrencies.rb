class V1::Occurrencies < Grape::API
  include UserAuthenticated

  helpers do
    def serialize(resource, meta)
      OccurrencySerializer.new(
        resource,
        meta: meta,
        links: pagination_links(resource, request.path)
      )
    end
  end

  resource :occurrencies do
    desc 'List all occurrencies'
    get do
      scope = apply_filters(Occurrency.all, %i[kind area status title])
      occurrencies, meta = apply_pagination(scope)

      present serialize(occurrencies, meta)
    end

    desc "Create an occurrency"
    params do
      requires :title, type: String, desc: "Ocurrency title"
      requires :description, type: String, desc: "Ocurrency description"
      requires :kind, type: String, values: Occurrency.kinds.keys, desc: "Ocurrency kind"
      requires :status, type: String, values: Occurrency.statuses.keys, desc: "Ocurrency status"
      requires :severity, type: String, values: Occurrency.severities.keys, desc: "Ocurrency severity"
      requires :student_id, type: String, desc: "Related student"
      requires :responsible_id, type: String, desc: "Related responsible"
    end

    post do
      result = Occurrency::Create.call(declared(params), current_user: current_user)

      present OccurrencySerializer.new(
        result, include: [:student, :relator, :responsible, :events]
      )
    end

    desc 'Show details of a specific occurrency'
    params do
      requires :id, type: String, desc: 'Occurrency UUID'
    end

    route_param :id do
      get do
        occurrency = Occurrency.find(params[:id])

        present OccurrencySerializer.new(
          occurrency,
          include: [:relator, :responsible, :student, :events]
        )
      end
    end
  end
end
