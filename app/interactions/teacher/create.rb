class Teacher::Create < BaseInteraction
  attr_reader :teacher

  def call
    create_teacher!

    teacher
  end

  private

  def create_teacher!
    @teacher = Teacher.create!(teacher_params)
  end

  def teacher_params
    params
  end
end
