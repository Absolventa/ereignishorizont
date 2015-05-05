shared_examples_for 'searches by title' do

  describe 'GET index' do
    it 'searches within "title"' do
      event = FactoryGirl.create(klass_symbol, title: "Hello World - how are things")
      FactoryGirl.create(klass_symbol, title: 'Bar') # will not be found
      get :index, query: { title: 'world' }
      expect(response).to be_success
      expect(response).to render_template 'index'
      expect(assigns(klass_symbol.pluralize).to_a).to eql [event]
    end

    def klass_symbol
      described_class.to_s.gsub('Controller', '').singularize.underscore
    end
  end

end

RSpec.shared_examples_for 'filters by remote' do

  describe 'GET index' do
    let(:remote_side) { events.last.remote_side }
    let!(:events) do
      2.times.map { create klass_symbol, remote_side: create(:remote_side) }
    end

    it 'filters by remote' do
      get :index, query: { remote_side_id: remote_side.id }
      expect(response).to be_success
      expect(response).to render_template 'index'
      expect(assigns(klass_symbol.pluralize).to_a).to eql [events.last]
    end

    def klass_symbol
      described_class.to_s.gsub('Controller', '').singularize.underscore
    end

  end
end
