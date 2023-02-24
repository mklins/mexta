# frozen_string_literal: true

require 'rails_helper'
require_relative 'shared_examples/redirects'
require_relative 'shared_examples/responses'

RSpec.describe 'Categories' do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe 'GET #index' do
    subject(:get_index) { get '/categories/' }

    let!(:category1) { create(:category, user:) }
    let!(:category2) { create(:category, user:) }
    let(:default_categories) { %w[Traveling Clothing Taxi Cafes Shops Other] }

    include_examples 'redirects guest to log in page'

    context 'when user' do
      before do
        create(:category, user: other_user)
        sign_in(user)
        get_index
      end

      it 'does proper assignment' do
        expect(assigns(:categories).pluck(:name)).to match_array(
          default_categories + [category1.name, category2.name]
        )
      end

      include_examples 'html response', :ok, :index
    end
  end

  describe 'GET #new' do
    subject(:get_new) { get '/categories/new' }

    include_examples 'redirects guest to log in page'

    context 'when user' do
      before do
        sign_in(user)
        get_new
      end

      it 'does proper assignment' do
        expect(assigns(:category)).to be_a_new(Category)
        expect(assigns(:category).user_id).to eq(user.id)
      end

      include_examples 'html response', :ok, :new
    end
  end

  describe 'GET #edit' do
    subject(:get_edit) { get "/categories/#{category.id}/edit" }

    let(:category) { create(:category, user:) }

    include_examples 'redirects guest to log in page'

    context 'when user' do
      before do
        sign_in(user)
        get_edit
      end

      it 'does proper assignment' do
        expect(assigns(:category)).to eq(category)
      end

      include_examples 'html response', :ok, :edit
    end
  end

  describe 'POST #create' do
    subject(:post_create) do
      post '/categories', params: { category: category_params }, headers:
    end

    let(:headers) { nil }
    let(:category_params) { { name: } }

    context 'with valid parameters' do
      let(:headers) { { 'Accept' => 'text/vnd.turbo-stream.html' } }
      let(:name) { 'Test' }

      include_examples 'redirects guest to log in page'

      context 'when user' do
        before do
          sign_in(user)
        end

        it 'saves new category' do
          expect { post_create }.to change(Category, :count).by(1)
        end

        describe 'assignments and responses' do
          it 'does proper assignment' do
            post_create
            expect(assigns(:category).name).to eq(name)
          end

          include_examples 'turbo_stream response'
        end
      end
    end

    context 'with invalid parameters' do
      let(:name) { '' }

      include_examples 'redirects guest to log in page'

      context 'when user' do
        before do
          sign_in(user)
        end

        it 'doesnt save new category' do
          expect { post_create }.not_to change(Category, :count)
        end

        include_examples 'html response', :unprocessable_entity, :new
      end
    end
  end

  describe 'PATCH #update' do
    subject(:patch_update) do
      patch "/categories/#{category.id}",
        params: { category: category_params },
        headers:
    end

    let(:headers) { nil }
    let(:category) { create(:category, user:) }
    let(:category_params) { { name: } }

    context 'with valid parameters' do
      let(:headers) { { 'Accept' => 'text/vnd.turbo-stream.html' } }
      let(:name) { 'Test' }

      include_examples 'redirects guest to log in page'

      context 'when user' do
        before do
          sign_in(user)
        end

        it 'saves category changes' do
          expect { patch_update }.to change { category.reload.name }.to(name)
        end

        describe 'assignments and responses' do
          it 'does proper assignment' do
            patch_update
            expect(assigns(:category)).to eq(category)
          end

          include_examples 'turbo_stream response'
        end
      end
    end

    context 'with invalid parameters' do
      let(:name) { '' }

      include_examples 'redirects guest to log in page'

      context 'when user' do
        before do
          sign_in(user)
        end

        it 'doesnt save category changes' do
          expect { patch_update }.not_to change { category.reload.name }
        end

        include_examples 'html response', :unprocessable_entity, :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    subject(:delete_destroy) { delete "/categories/#{category.id}", headers: }

    let(:headers) { nil }
    let(:category) { create(:category, user:) }

    include_examples 'redirects guest to log in page'

    context 'when user' do
      before do
        sign_in(user)
      end

      it 'destroys category' do
        expect { delete_destroy }.to change { Category.exists?(category.id) }.
          to(false)
      end

      describe 'assignments and responses' do
        it 'does proper assignment' do
          delete_destroy
          expect(assigns(:category)).to eq(category)
        end

        include_examples 'redirects to resourse index page', '/categories'

        include_examples 'turbo_stream response'
      end
    end
  end
end
