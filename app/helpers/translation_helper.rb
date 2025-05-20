module TranslationHelper
  def t_enum(record, attribute)
    value = record.send(attribute)
    return "-" if value.blank?

    model = record.class.model_name.i18n_key
    I18n.t("activerecord.attributes.#{model}.#{attribute}.#{value}", locale: :'pt-BR', default: value.to_s.humanize)
  end

  def t_model(record)
    model_key = record.class.model_name.i18n_key
    I18n.t("activerecord.models.#{model_key}", locale: :'pt-BR', default: model_key.to_s.humanize)
  end
end