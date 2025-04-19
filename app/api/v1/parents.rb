class V1::Parents < Grape::API
  include UserAuthenticated

  helpers do
    def serialize(resource, meta)
      ParentSerializer
      .new(
        resource,
        meta: meta,
        links: pagination_links(resource, request.path)
      )
    end
  end

  resource :parents do
    desc 'Create new parent'
    params do
      requires :name, type: String, desc: "The parent name"
      requires :email, type: String, desc: "The parent email", regexp: URI::MailTo::EMAIL_REGEXP
      requires :password, type: String, desc: "The parent password"
      requires :document, type: String, desc: "The parent document", regexp: /^\d{11}$/
      requires :student_id, type: String, desc: "Related student"
      optional :gender, type: String, desc: "The parent gender", values: %w[M H]
      optional :birthdate, type: Date, desc: "The parent birthdate"
      optional :phone, type: String, desc: "The parent phone", regexp: /^\d{10,11}$/
    end
  
    post do
      result = Parent::Create.call(declared(params))
  
      present ParentSerializer.new(result)
    end

    desc "List all parents"
    params do
      optional :filter, type: Hash 
      optional :page, type: Hash
    end

    get do
      scope = apply_filters(Parent.all, %i[name email document])
      paginated, meta = apply_pagination(scope)

      present serialize(paginated, meta)
    end
  end
end
