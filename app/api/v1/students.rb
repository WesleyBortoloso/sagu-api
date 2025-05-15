class V1::Students < Grape::API
  include UserAuthenticated

  helpers do
    def serialize(resource, meta)
      StudentSerializer
      .new(
        resource,
        meta: meta,
        links: pagination_links(resource, request.path)
      )
    end
  end

  resource :students do
    desc 'Create new student'
    params do
      requires :name, type: String, desc: "The student name"
      requires :email, type: String, desc: "The student email", regexp: URI::MailTo::EMAIL_REGEXP
      requires :password, type: String, desc: "The student password"
      requires :document, type: String, desc: "The student document", regexp: /^\d{11}$/
      requires :enrollment, type: String, desc: "The student enrollment number", regexp: /^\d+$/
      requires :situation, type: String, desc: "The student situation", values: Student.situations.keys
      optional :classroom_id, type: String, desc: "The related classroom id "
      optional :parent_id, type: String, desc: "The related parent id"
      optional :gender, type: String, desc: "The student gender", values: %w[M H]
      optional :birthdate, type: Date, desc: "The student birthdate"
      optional :phone, type: String, desc: "The student phone", regexp: /^\d{10,11}$/
      optional :institutional_id, type: Integer, desc: "The institutional id"
    end
  
    post do
      result = Student::Create.call(declared(params))
  
      present StudentSerializer.new(result)
    end

    desc "List all students"
    params do
      optional :filter, type: Hash 
      optional :page, type: Hash
    end

    get do
      scope = apply_filters(Student.all.order(name: :asc), %i[name email document classroom_id])
      paginated, meta = apply_pagination(scope)

      present serialize(paginated, meta)
    end

    route_param :student_id do
      mount V1::Students::Documents

      desc 'Show details of a specific student'
      params do
        requires :student_id, type: String, desc: 'Student UUID'
      end

      get do
        student = Student.find(params[:student_id])

        present StudentSerializer.new(
          student,
          include: [:classroom, :parent, :conditions]
        )
      end

      desc 'Generate student report as PDF'
      params do
        requires :student_id, type: String, desc: 'Student UUID'
      end

      post '/report' do
        result = Student::GenerateReport.call(declared(params))
      
        present StudentSerializer.new(result)
      end

      desc "Update an student"
      params do
        requires :student_id, type: String, desc: 'Student UUID'
        optional :email, type: String, desc: 'Student email', regexp: URI::MailTo::EMAIL_REGEXP
        optional :situation, type: String, values: Student.situations.keys, desc: 'Student situation'
        optional :phone, type: String, desc: 'Student phone', regexp: /^\d{10,11}$/
      end
    
      patch do
        result = Student::Update.call(declared(params), current_user: current_user)
    
        present StudentSerializer.new(result)
      end
    end
  end
end
