class V1::Occurrencies < Grape::API
  include UserAuthenticated

  helpers do
    def serialize(resource, meta)
      OccurrencySerializer.new(
        resource,
        meta: meta,
        links: pagination_links(resource, request.path)
      )
    end
  end

  resource :occurrencies do
    desc 'List all occurrencies'
    get do
      scope = apply_filters(Occurrency.all, %i[kind area status title])
      occurrencies, meta = apply_pagination(scope)

      present serialize(occurrencies, meta)
    end
  end
end
