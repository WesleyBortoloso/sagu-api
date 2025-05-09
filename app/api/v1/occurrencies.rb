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
      scope = apply_filters(Occurrency.all.order(created_at: :desc), %i[kind area status student_id])
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

    route_param :occurrency_id do
      desc 'Show details of a specific occurrency'
      params do
        requires :occurrency_id, type: String, desc: 'Occurrency UUID'
      end
      get do
        occurrency = Occurrency.find(params[:occurrency_id])

        present OccurrencySerializer.new(
          occurrency,
          include: [:relator, :responsible, :student, :events]
        )
      end

      desc "Update an occurrency"
      params do
        requires :occurrency_id, type: String, desc: 'Occurrency UUID'
        optional :kind, type: String, values: Occurrency.kinds.keys, desc: 'Occurrency kind'
        optional :status, type: String, values: Occurrency.statuses.keys, desc: 'Occurrency status'
        optional :severity, type: String, values: Occurrency.severities.keys, desc: 'Occurrency severity'
        optional :responsible_id, type: String, desc: 'Occurrency responsible'
      end
    
      patch do
        result = Occurrency::Update.call(declared(params), current_user: current_user)
    
        present OccurrencySerializer.new(
          result, include: [:responsible, :events]
        )
      end
    end
  end
end
