module SearchesByTitle
  extend ActiveSupport::Concern

  included do
    before_action :load_collection, only: :index
  end

  protected

  def load_collection
    collection = klass_name
    collection = collection.where("title ILIKE :query", query: "%#{search_term}%") if search_term
    collection = collection.where(remote_side_id: remote_side_id) if remote_side_id
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

  def remote_side_id
    @remote_side_id ||= params.fetch(:query, {})[:remote_side_id]
  end

end
