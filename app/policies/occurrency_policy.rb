class OccurrencyPolicy
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def resolve
    return parent_scope     if user.is_a?(Parent)
    return teacher_scope    if user.is_a?(Teacher)
    return psychologist_scope if user.is_a?(Staff) && user.role_psychologist?
    return manager_scope    if user.is_a?(Staff) && user.role_manager?
    return staff_scope      if user.is_a?(Staff)

    Occurrency.none
  end

  private

  def teacher_scope
    Occurrency.where(private: false)
              .where("relator_id = :id OR responsible_id = :id", id: user.id)
  end

  def psychologist_scope
    Occurrency.where("relator_id = :id OR responsible_id = :id", id: user.id)
  end

  def manager_scope
    Occurrency.where(private: false)
  end

  def staff_scope
    Occurrency.where(private: false)
              .where("relator_id = :id OR responsible_id = :id", id: user.id)
  end

  def parent_scope
    Occurrency.where(student_id: user.students.pluck(:id))
  end
end
