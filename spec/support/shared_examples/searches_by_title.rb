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
