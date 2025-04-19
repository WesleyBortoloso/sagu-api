module JsonapiFiltering
  extend ActiveSupport::Concern

  included do
    def apply_filters(scope, allowed_filters = [])
      return scope unless params[:filter].is_a?(Hash)

      ransack_filters = {}
      params[:filter].each do |key, value|
        next unless allowed_filters.include?(key.to_sym)

        ransack_filters["#{key}_eq"] = value
      end
      scope.ransack(ransack_filters).result(distinct: true)
    end

    def apply_pagination(scope)
      page = (params.dig(:page, :number) || 1).to_i
      per_page = (params.dig(:page, :size) || 20).to_i
      paginated = scope.page(page).per(per_page)

      [paginated, pagination_meta(paginated)]
    end

    def pagination_meta(paginated)
      {
        current_page: paginated.current_page,
        next_page: paginated.next_page,
        prev_page: paginated.prev_page,
        total_pages: paginated.total_pages,
        total_count: paginated.total_count
      }
    end

    def pagination_links(paginated, path)
      base = request.base_url + path
      {
        self: "#{base}?page[number]=#{paginated.current_page}&page[size]=#{paginated.limit_value}",
        next: (paginated.next_page ? "#{base}?page[number]=#{paginated.next_page}&page[size]=#{paginated.limit_value}" : nil),
        prev: (paginated.prev_page ? "#{base}?page[number]=#{paginated.prev_page}&page[size]=#{paginated.limit_value}" : nil),
        first: "#{base}?page[number]=1&page[size]=#{paginated.limit_value}",
        last: "#{base}?page[number]=#{paginated.total_pages}&page[size]=#{paginated.limit_value}"
      }.compact
    end
  end
end
