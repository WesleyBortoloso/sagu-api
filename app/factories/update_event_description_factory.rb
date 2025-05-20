class UpdateEventDescriptionFactory
  def self.call(resource:, changed_fields:)
    case changed_fields.first
    when "status"
      "O status da(o) #{t_enum(resource, :title)} foi atualizado: #{t_enum(resource, :status)}"
    when "area"
      "A area da(o) #{t_enum(resource, :title)} foi atualizada: #{t_enum(resource, :area)}"
    when "responsible_id"
      "O responsável foi atualizado: #{resource.responsible.name}"
    when "severity"
      "A gravidade da(o) #{t_enum(resource, :title)} foi atualizada: #{t_enum(resource, :severity)}"
    else
      "Uma atualização foi realizada"
    end
  end
end
