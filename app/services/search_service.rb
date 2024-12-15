
class SearchService < BaseService
  SEARCHABLE_MODELS = {
    users: User,
    doctors: Doctor,
    sites: Site,
    cdoms: Cdom
  }.freeze

  def self.search(model:, query:, page: 1, per_page: 10)
    new(model, query, page, per_page).search
  end

  def initialize(model, query, page, per_page)
    @model = SEARCHABLE_MODELS[model]
    @query = query
    @page = page
    @per_page = per_page
  end

  def search
    return failure("Invalid model") unless @model
    return failure("Query required") if @query.blank?

    results = search_model
    success(results: results)
  end

  private

  def search_model
    case @model.name
    when 'User', 'Doctor'
      search_by_name
    when 'Site'
      search_by_site_name
    when 'Cdom'
      search_by_department
    end
  end

  def search_by_name
    @model.where(
      "LOWER(first_name) LIKE :query OR LOWER(last_name) LIKE :query",
      query: "%#{@query.downcase}%"
    ).page(@page).per(@per_page)
  end

  def search_by_site_name
    @model.where(
      "LOWER(name) LIKE :query",
      query: "%#{@query.downcase}%"
    ).page(@page).per(@per_page)
  end

  def search_by_department
    @model.where(
      "LOWER(departement) LIKE :query",
      query: "%#{@query.downcase}%"
    ).page(@page).per(@per_page)
  end
end
