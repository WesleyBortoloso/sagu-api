class Student::Document::Create < BaseInteraction
  attr_reader :document, :student

  def call
    fetch_student!
    validate_file_type!
    create_document!
    attach_file!

    document
  end

  private

  def fetch_student!
    @student ||= Student.find(params[:student_id])
  end

  def create_document!
    @document = student.documents.create!(document_params)
  end

  def attach_file!
    document.file.attach(
      io: params[:file][:tempfile],
      filename: params[:file][:filename],
      content_type: params[:file][:type]
    )
  end

  def validate_file_type!
    error!({ error: 'Invalid file type', detail: 'Only PDF files are allowed' }, 422) unless params[:file][:type] == 'application/pdf'
  end

  def document_params
    params.slice(:name, :kind)
  end
end
