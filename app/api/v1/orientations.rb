class V1::Orientations < Grape::API
  include UserAuthenticated

  helpers do
    def serialize(resource, meta)
      OrientationSerializer.new(
        resource,
        meta: meta,
        links: pagination_links(resource, request.path)
      )
    end
  end

  resource :orientations do
    desc 'List all orientations'
    get do
      scope = apply_filters(Orientation.all.order(created_at: :desc), %i[area status student_id])
      orientations, meta = apply_pagination(scope)

      present serialize(orientations, meta)
    end

    desc 'Show details of a specific orientation'
    params do
      requires :orientation_id, type: String, desc: 'Orientation UUID'
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
  end
end
