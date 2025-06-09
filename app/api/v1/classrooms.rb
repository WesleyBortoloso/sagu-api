class V1::Classrooms < Grape::API
  include UserAuthenticated

  helpers do
    def serialize(resource, meta)
      ClassroomSerializer.new(
        resource,
        meta: meta,
        links: pagination_links(resource, request.path)
      )
    end
  end

  resource :classrooms do
    desc "List all classrooms"
    get do
      scope = apply_filters(Classroom.all, %i[year name grade])
      classrooms, meta = apply_pagination(scope)

      present serialize(classrooms, meta)
    end
  end
end
