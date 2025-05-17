class Student::GenerateReport < BaseInteraction
  attr_reader :student, :pdf_content

  def call
    fetch_student!
    generate_pdf!
    attach_report!
    student
  end

  private

  def fetch_student!
    @student = Student.includes(:occurrencies, :orientations, :conditions).find(params[:student_id])
  rescue ActiveRecord::RecordNotFound
    error!({ error: 'Student not found', detail: "ID #{params[:student_id]} is invalid" }, 404)
  end

  def attach_report!
    io = StringIO.new(pdf_content.dup)
    io.set_encoding('BINARY') if io.respond_to?(:set_encoding)
    io.rewind

    @student.report_file.attach(
      io: io,
      filename: "relatorio_aluno_#{student.id}.pdf",
      content_type: 'application/pdf'
    )

    raise ActiveStorage::IntegrityError, "Erro ao anexar o PDF do relatório" unless student.report_file.attached?
  end

  def generate_pdf!
    @pdf_content = StudentReportFactory.new(student).generate
  end
end
