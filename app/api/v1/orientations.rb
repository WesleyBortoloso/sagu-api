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
    desc "List all orientations"
    get do
      scope = apply_filters(OrientationPolicy.new(current_user).resolve.order(created_at: :desc), %i[area status student_id])
      orientations, meta = apply_pagination(scope)

      present serialize(orientations, meta)
    end

    desc "Create an orientation"
    params do
      requires :title, type: String, desc: "Orientation title"
      requires :description, type: String, desc: "Orientation description"
      requires :area, type: String, desc: "Orientation area"
      requires :status, type: String, values: Orientation.statuses.keys, desc: "Orientation status"
      requires :student_id, type: String, desc: "Related student"
      requires :responsible_id, type: String, desc: "Related responsible"
    end

    post do
      result = Orientation::Create.call(declared(params), current_user: current_user)

      present OrientationSerializer.new(result)
    end

    route_param :orientation_id do
      desc "Show details of a specific orientation"
      params do
        requires :orientation_id, type: String, desc: 'Orientation UUID'
      end
      get do
        orientation = Orientation.find(params[:orientation_id])

        present OrientationSerializer.new(
          orientation,
          include: [:relator, :parent, :events, :responsible, :student]
        )
      end

      desc "Update an orientation"
      params do
        requires :orientation_id, type: String, desc: 'Orientation UUID'
        optional :area, type: String, values: Orientation.areas.keys, desc: 'Orientation area'
        optional :status, type: String, values: Orientation.statuses.keys, desc: 'Orientation status'
        optional :responsible_id, type: String, desc: 'Orientation responsible'
      end
    
      patch do
        result = Orientation::Update.call(declared(params), current_user: current_user)
    
        present OrientationSerializer.new(
          result, include: [:responsible, :events]
        )
      end
    end
  end
end
