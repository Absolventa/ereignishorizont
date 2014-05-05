module SearchesByTitle
  extend ActiveSupport::Concern

  included do
    before_action :load_collection, only: :index
  end

  protected

  def load_collection
    collection = if search_term
                   klass_name.where("title ILIKE :query", query: "%#{search_term}%")
                 else
                   klass_name
                 end
    collection = collection.order(sort_column + ' ' + sort_direction).
      page(params[:page]).per_page(10)

    instance_variable_set instance_variable_name, collection
  end

  private

  def instance_variable_name
    "@#{controller_name.gsub('controller', '')}"
  end

  def klass_name
    self.class.to_s.gsub('Controller', '').singularize.constantize
  end

  def search_term
    params.fetch(:query, {})[:title]
  end

end
