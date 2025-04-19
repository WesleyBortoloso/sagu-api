class V1::Staffs < Grape::API
  include UserAuthenticated

  helpers do
    def serialize(resource, meta)
      StaffSerializer
      .new(
        resource,
        meta: meta,
        links: pagination_links(resource, request.path)
      )
    end
  end

  resource :staffs do
    desc 'Create new staff'
    params do
      requires :name, type: String, desc: "The staff name"
      requires :email, type: String, desc: "The staff email", regexp: URI::MailTo::EMAIL_REGEXP
      requires :password, type: String, desc: "The staff password"
      requires :document, type: String, desc: "The staff document", regexp: /^\d{11}$/
      requires :role, type: String, desc: "The staff role"
      requires :department, type: String, desc: "The staff department"
      optional :gender, type: String, desc: "The staff gender", values: %w[M H]
      optional :birthdate, type: Date, desc: "The staff birthdate"
      optional :phone, type: String, desc: "The staff phone", regexp: /^\d{10,11}$/
    end
  
    post do
      result = Staff::Create.call(declared(params))
  
      present StaffSerializer.new(result)
    end

    desc "List all staffs"
    params do
      optional :filter, type: Hash 
      optional :page, type: Hash
    end

    get do
      scope = apply_filters(Staff.all, %i[name email document])
      paginated, meta = apply_pagination(scope)

      present serialize(paginated, meta)
    end
  end
end
