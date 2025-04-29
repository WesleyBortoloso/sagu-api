class V1::Students::Documents < Grape::API
  resource :documents do

    desc 'List all documents for a student'
    params do
      optional :filter, type: Hash
      optional :page, type: Hash
    end

    get do
      student = Student.find(params[:student_id])
      documents_scope = student.documents

      documents_scope = apply_filters(documents_scope, %i[name kind])
      paginated, meta = apply_pagination(documents_scope)

      present DocumentSerializer.new(
        paginated,
        meta: meta,
        links: pagination_links(paginated, request.path)
      )
    end

    desc 'Create a new document for a student with PDF file'
    params do
      requires :name, type: String, desc: 'Document name'
      requires :kind, type: String, desc: 'Document kind'
      requires :file, type: File, desc: 'PDF file to attach'
    end

    post do
      result = Student::Document::Create.call(declared(params))
  
      present DocumentSerializer.new(result)
    end
  end
end  