class V1::Teachers < Grape::API
  include UserAuthenticated

  helpers do
    def serialize(resource, meta)
      TeacherSerializer
      .new(
        resource,
        meta: meta,
        links: pagination_links(resource, request.path)
      )
    end
  end

  resource :teachers do
    desc 'Create new teacher'
    params do
      requires :name, type: String, desc: "The teacher name"
      requires :email, type: String, desc: "The teacher email", regexp: URI::MailTo::EMAIL_REGEXP
      requires :password, type: String, desc: "The teacher password"
      requires :document, type: String, desc: "The teacher document", regexp: /^\d{11}$/
      optional :external_id, type: Integer, desc: "The teacher external id"
      optional :gender, type: String, desc: "The teacher gender", values: %w[M H]
      optional :birthdate, type: Date, desc: "The teacher birthdate"
      optional :phone, type: String, desc: "The teacher phone", regexp: /^\d{10,11}$/
    end
  
    post do
      result = Teacher::Create.call(declared(params))
  
      present TeacherSerializer.new(result)
    end

    desc "List all teachers"
    params do
      optional :filter, type: Hash 
      optional :page, type: Hash
    end

    get do
      scope = apply_filters(Teacher.all, %i[name email document])
      paginated, meta = apply_pagination(scope)

      present serialize(paginated, meta)
    end

    route_param :id do
      desc "Show teacher details"
      params do
        requires :id, type: String, desc: "Teacher ID"
      end

      get do
        teacher = Teacher.find(params[:id])

        present Teacher::DetailsSerializer.new(
          teacher,
          include: [:reported_occurrencies, 
          :responsible_occurrencies]
         )
      end
    end
  end
end
