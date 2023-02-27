# frozen_string_literal: true

require 'rails_helper'
require_relative 'shared_examples/redirects'
require_relative 'shared_examples/responses'

RSpec.describe 'Spendings' do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe 'GET #index' do
    subject(:get_index) { get '/spendings/', params: { q: search_params } }

    let(:search_params) { nil }

    let!(:spending1) { create(:spending, title: 'bank', user:) }
    let!(:spending2) { create(:spending, title: 'pool', user:) }

    include_examples 'redirects guest to log in page'

    context 'when user' do
      before do
        create(:spending, user: other_user)
        sign_in(user)
      end

      it 'does proper assignment' do
        get_index
        expect(assigns(:spendings)).to match_array([spending2, spending1])
      end

      describe 'search' do
        let(:search_params) { { title_cont: 'test' } }
        let!(:spending3) { create(:spending, title: 'test', user:) }
        let!(:spending4) { create(:spending, title: 'smthngTest', user:) }

        before do
          create(:spending, title: 'test', user: other_user)
          create(:spending, title: 'smthngTest', user: other_user)
          get_index
        end

        it 'does proper assignment' do
          expect(assigns(:q).result).to match_array([spending4, spending3])
        end
      end

      include_examples 'html response', :ok, :index
    end
  end

  describe 'GET #shared_index' do
    subject(:get_shared_index) do
      get "/users/#{user.id}/spendings/shared/#{share_link}",
        params: { q: search_params }
    end

    let(:share_link) { user.share_link }
    let(:search_params) { nil }

    let!(:spending1) { create(:spending, title: 'bank', user:) }
    let!(:spending2) { create(:spending, title: 'pool', user:) }

    before do
      create(:spending, user: other_user)
      create(:spending, user: other_user)
    end

    context 'when guest' do
      it 'doesnt update user share_link' do
        expect { get_shared_index }.not_to change { user.reload.share_link }
      end

      it 'does proper assignment' do
        get_shared_index
        expect(assigns(:user)).to eq(user)
        expect(assigns(:spendings)).to match_array([spending2, spending1])
      end

      describe 'search' do
        let(:search_params) { { title_cont: 'test' } }
        let!(:spending3) { create(:spending, title: 'test', user:) }
        let!(:spending4) { create(:spending, title: 'smthngTest', user:) }

        before do
          create(:spending, title: 'test', user: other_user)
          create(:spending, title: 'smthngTest', user: other_user)
          get_shared_index
        end

        it 'does proper assignment' do
          expect(assigns(:q).result).to match_array([spending4, spending3])
        end
      end

      include_examples 'html response', :ok, :shared_index

      context 'when NoMethodError occurred' do
        let(:share_link) { 'abc' }

        before { get_shared_index }

        it { expect(response).to redirect_to(root_path) }

        it do
          expect(flash[:alert]).to eq(
            'Sorry, the link you provided is not valid'
          )
        end
      end
    end

    context 'when user' do
      context 'when owner' do
        let(:share_link) { SecureRandom.hex(16) }

        before do
          sign_in(user)
        end

        it 'updates user share_link' do
          expect { get_shared_index }.to change { user.reload.share_link }.
            to(share_link)
        end

        it 'does proper assignment' do
          get_shared_index
          expect(assigns(:user)).to eq(user)
          expect(assigns(:spendings)).to match_array([spending2, spending1])
        end

        describe 'search' do
          let(:search_params) { { title_cont: 'test' } }
          let!(:spending3) { create(:spending, title: 'test', user:) }
          let!(:spending4) { create(:spending, title: 'smthngTest', user:) }

          before do
            create(:spending, title: 'test', user: other_user)
            create(:spending, title: 'smthngTest', user: other_user)
            get_shared_index
          end

          it 'does proper assignment' do
            expect(assigns(:q).result).to match_array([spending4, spending3])
          end
        end

        include_examples 'html response', :ok, :shared_index
      end

      context 'when other user' do
        it 'doesnt update user share_link' do
          expect { get_shared_index }.not_to change { user.reload.share_link }
        end

        it 'does proper assignment' do
          get_shared_index
          expect(assigns(:user)).to eq(user)
          expect(assigns(:spendings)).to match_array([spending2, spending1])
        end

        describe 'search' do
          let(:search_params) { { title_cont: 'test' } }
          let!(:spending3) { create(:spending, title: 'test', user:) }
          let!(:spending4) { create(:spending, title: 'smthngTest', user:) }

          before do
            create(:spending, title: 'test', user: other_user)
            create(:spending, title: 'smthngTest', user: other_user)
            get_shared_index
          end

          it 'does proper assignment' do
            expect(assigns(:q).result).to match_array([spending4, spending3])
          end
        end

        include_examples 'html response', :ok, :shared_index

        context 'when NoMethodError occurred' do
          let(:share_link) { 'abc' }

          before { get_shared_index }

          it { expect(response).to redirect_to(root_path) }

          it do
            expect(flash[:alert]).to eq(
              'Sorry, the link you provided is not valid'
            )
          end
        end
      end
    end
  end

  describe 'GET #new' do
    subject(:get_new) { get '/spendings/new' }

    include_examples 'redirects guest to log in page'

    context 'when user' do
      before { sign_in(user) }

      it 'does proper assignment' do
        get_new
        expect(assigns(:spending)).to be_a_new(Spending)
        expect(assigns(:spending).user_id).to eq(user.id)
      end

      include_examples 'html response', :ok, :new
    end
  end

  describe 'GET #edit' do
    subject(:get_edit) { get "/spendings/#{spending.id}/edit" }

    let(:spending) { create(:spending, user:) }

    include_examples 'redirects guest to log in page'

    context 'when user' do
      before { sign_in(user) }

      it 'does proper assignment' do
        get_edit
        expect(assigns(:spending)).to eq(spending)
      end

      include_examples 'html response', :ok, :edit
    end
  end

  describe 'POST #create' do
    subject(:post_create) do
      post '/spendings', params: { spending: spending_params }, headers:
    end

    let(:headers) { nil }
    let(:spending_params) { { title:, amount: 9.99 } }

    context 'with valid parameters' do
      let(:headers) { { 'Accept' => 'text/vnd.turbo-stream.html' } }
      let(:title) { 'Test' }

      include_examples 'redirects guest to log in page'

      context 'when user' do
        before { sign_in(user) }

        it 'saves new spending' do
          expect { post_create }.to change(Spending, :count).by(1)
        end

        describe 'assignments and responses' do
          it 'does proper assignment' do
            post_create
            expect(assigns(:spending).title).to eq(title)
            expect(assigns(:spending).amount).to eq(9.99)
          end

          include_examples 'turbo_stream response'
        end
      end
    end

    context 'with invalid parameters' do
      let(:title) { '' }

      include_examples 'redirects guest to log in page'

      context 'when user' do
        before { sign_in(user) }

        it 'doesnt save new spending' do
          expect { post_create }.not_to change(Spending, :count)
        end

        include_examples 'html response', :unprocessable_entity, :new
      end
    end
  end

  describe 'PATCH #update' do
    subject(:patch_update) do
      patch "/spendings/#{spending.id}",
        params: { spending: spending_params },
        headers:
    end

    let(:headers) { nil }
    let(:spending) { create(:spending, user:) }
    let(:spending_params) { { title: } }

    context 'with valid parameters' do
      let(:headers) { { 'Accept' => 'text/vnd.turbo-stream.html' } }
      let(:title) { 'Test' }

      include_examples 'redirects guest to log in page'

      context 'when user' do
        before { sign_in(user) }

        it 'saves spending changes' do
          expect { patch_update }.to change { spending.reload.title }.to(title)
        end

        describe 'assignments and responses' do
          it 'does proper assignment' do
            patch_update
            expect(assigns(:spending)).to eq(spending)
          end

          include_examples 'turbo_stream response'
        end
      end
    end

    context 'with invalid parameters' do
      let(:title) { '' }

      include_examples 'redirects guest to log in page'

      context 'when user' do
        before { sign_in(user) }

        it 'doesnt save spending changes' do
          expect { patch_update }.not_to change { spending.reload.title }
        end

        include_examples 'html response', :unprocessable_entity, :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    subject(:delete_destroy) { delete "/spendings/#{spending.id}", headers: }

    let(:headers) { nil }
    let(:spending) { create(:spending, user:) }

    include_examples 'redirects guest to log in page'

    context 'when user' do
      before { sign_in(user) }

      it 'destroys spending' do
        expect { delete_destroy }.to change { Spending.exists?(spending.id) }.
          to(false)
      end

      describe 'assignments and responses' do
        it 'does proper assignment' do
          delete_destroy
          expect(assigns(:spending)).to eq(spending)
        end

        include_examples 'redirects to resourse index page', '/spendings'

        include_examples 'turbo_stream response'
      end
    end
  end
end
