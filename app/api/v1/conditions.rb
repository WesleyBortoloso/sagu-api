class V1::Conditions < Grape::API
    include UserAuthenticated

    resource :conditions do
      desc 'List all conditions'
      get do
        conditions = Condition.order(:category, :name)
        present ConditionSerializer.new(conditions)
      end

      desc 'List all students filtered by condition category'
      params do
        optional :category, type: String, values: %w[scholarship special_need], desc: 'Category of condition'
      end
      get :students do
        scope = Student.joins(:conditions)
        scope = scope.where(conditions: { category: params[:category] }) if params[:category].present?
        scope = scope.distinct.order(:name)

        paginated, meta = apply_pagination(scope)

        present StudentSerializer.new(
          paginated,
          meta: meta,
          include: [:classroom, :conditions]
        )
      end

      route_param :condition_id do
        desc 'List students by specific condition'
        get :students do
          condition = Condition.find(params[:condition_id])
          students = condition.students.order(:name)

          paginated, meta = apply_pagination(students)

          present StudentSerializer.new(
            paginated,
            meta: meta,
            include: [:classroom, :conditions]
          )
        end
      end
    end
  end

