class OrientationPolicy
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def resolve
    return parent_scope     if user.is_a?(Parent)
    return teacher_scope    if user.is_a?(Teacher)
    return staff_scope      if user.is_a?(Staff)
    return manager_scope    if user.is_a?(Staff) && user.role_manager?

    Orientation.none
  end

  private

  def teacher_scope
    Orientation.where("relator_id = :id OR responsible_id = :id", id: user.id)
  end

  def manager_scope
    Orientation.all
  end

  def staff_scope
    Orientation.where("relator_id = :id OR responsible_id = :id", id: user.id)
  end

  def parent_scope
    Orientation.where(student_id: user.students.pluck(:id))
  end
end
