class UpdateEventDescriptionFactory
  def self.call(resource:, changed_fields:)
    case changed_fields.first
    when "status"
      "O status foi atualizado -> #{resource.status.humanize}"
    when "area"
      "A area envolvida foi atualizada -> #{resource.area.humanize}"
    when "responsible_id"
      "O responsável foi atualizado -> #{resource.responsible.name}"
    when "severity"
      "A gravidade foi atualizada -> #{resource.severity.humanize}"
    else
      "Uma atualização foi realizada"
    end
  end
end
