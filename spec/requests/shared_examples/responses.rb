# frozen_string_literal: true

RSpec.shared_examples 'html response' do |status, template|
  describe 'response' do
    before { subject }

    it do
      expect(response).to have_http_status(status)
      expect(response.content_type).to eq('text/html; charset=utf-8')
      expect(response).to render_template(template)
    end
  end
end

RSpec.shared_examples 'turbo_stream response' do
  describe 'response' do
    let(:headers) { { 'Accept' => 'text/vnd.turbo-stream.html' } }

    before { subject }

    it do
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq(
        'text/vnd.turbo-stream.html; charset=utf-8'
      )
    end
  end
end
