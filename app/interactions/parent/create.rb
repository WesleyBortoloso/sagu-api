class Parent::Create < BaseInteraction
  attr_reader :parent, :student

  def call
    create_parent!
    find_related_student! if student_id
    associate_student! if student

    parent
  end

  private

  def create_parent!
    @parent = Parent.create!(parent_params)
  end

  def associate_student!
    student.update!(parent: parent)
  end

  def find_related_student!
    @student = Student.find(params[:student_id])
  end

  def student_id
    params[:student_id]
  end

  def parent_params
    params.except(:student_id)
  end
end

