# frozen_string_literal: true

RSpec.shared_examples 'redirects guest to log in page' do
  context 'when guest' do
    before { subject }

    it { expect(response).to redirect_to('/users/sign_in') }
  end
end

RSpec.shared_examples 'redirects to resourse index page' do |path|
  describe 'redirect' do
    before { subject }

    it do
      expect(response).to redirect_to(path)
      expect(response).to have_http_status(:see_other)
    end
  end
end
