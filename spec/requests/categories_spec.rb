# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Categories' do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe 'GET #index' do
    subject(:get_index) { get '/categories/' }

    let!(:category1) { create(:category, user:) }
    let!(:category2) { create(:category, user:) }
    let(:default_categories) { %w[Traveling Clothing Taxi Cafes Shops Other] }

    context 'when guest' do
      before { get_index }

      it { expect(response).to redirect_to('/users/sign_in') }
    end

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

      it 'renders index template' do
        expect(response).to have_http_status(:ok)
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET #new' do
    subject(:get_new) { get '/categories/new' }

    context 'when guest' do
      before { get_new }

      it { expect(response).to redirect_to('/users/sign_in') }
    end

    context 'when user' do
      before do
        sign_in(user)
        get_new
      end

      it 'does proper assignment' do
        expect(assigns(:category)).to be_a_new(Category)
        expect(assigns(:category).user_id).to eq(user.id)
      end

      it 'renders new template' do
        expect(response).to have_http_status(:ok)
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    subject(:get_edit) { get "/categories/#{category.id}/edit" }

    let(:category) { create(:category, user:) }

    context 'when guest' do
      before { get_edit }

      it { expect(response).to redirect_to('/users/sign_in') }
    end

    context 'when user' do
      before do
        sign_in(user)
        get_edit
      end

      it 'does proper assignment' do
        expect(assigns(:category)).to eq(category)
      end

      it 'renders edit template' do
        expect(response).to have_http_status(:ok)
        expect(response).to render_template :edit
      end
    end
  end

  describe 'POST #create' do
    subject(:post_create) do
      post '/categories', params: { category: category_params }, headers:
    end

    let(:category_params) { { name: } }

    context 'with valid parameters' do
      let(:headers) { { 'Accept' => 'text/vnd.turbo-stream.html' } }
      let(:name) { 'Test' }

      context 'when guest' do
        before { post_create }

        it { expect(response).to redirect_to('/users/sign_in') }
      end

      context 'when user' do
        before do
          sign_in(user)
        end

        it 'saves new category' do
          expect { post_create }.to change(Category, :count).by(1)
        end

        describe 'assignments and responses' do
          before { post_create }

          it 'does proper assignment' do
            expect(assigns(:category).name).to eq(name)
          end

          it 'responds in proper format' do
            expect(response).to have_http_status(:ok)
            expect(response.content_type).to eq(
              'text/vnd.turbo-stream.html; charset=utf-8'
            )
          end
        end
      end
    end

    context 'with invalid parameters' do
      let(:headers) { nil }
      let(:name) { '' }

      context 'when guest' do
        before { post_create }

        it { expect(response).to redirect_to('/users/sign_in') }
      end

      context 'when user' do
        before do
          sign_in(user)
        end

        it 'doesnt save new category' do
          expect { post_create }.not_to change(Category, :count)
        end

        it 'responds in proper format' do
          post_create
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq 'text/html; charset=utf-8'
          expect(response).to render_template :new
        end
      end
    end
  end

  describe 'PATCH #update' do
    subject(:patch_update) do
      patch "/categories/#{category.id}",
        params: { category: category_params },
        headers:
    end

    let(:category) { create(:category, user:) }
    let(:category_params) { { name: } }

    context 'with valid parameters' do
      let(:headers) { { 'Accept' => 'text/vnd.turbo-stream.html' } }
      let(:name) { 'Test' }

      context 'when guest' do
        before { patch_update }

        it { expect(response).to redirect_to('/users/sign_in') }
      end

      context 'when user' do
        before do
          sign_in(user)
        end

        it 'saves category changes' do
          expect { patch_update }.to change { category.reload.name }.to(name)
        end

        describe 'assignments and responses' do
          before { patch_update }

          it 'does proper assignment' do
            expect(assigns(:category)).to eq(category)
          end

          it 'responds in proper format' do
            expect(response).to have_http_status(:ok)
            expect(response.content_type).to eq(
              'text/vnd.turbo-stream.html; charset=utf-8'
            )
          end
        end
      end
    end

    context 'with invalid parameters' do
      let(:headers) { nil }
      let(:name) { '' }

      context 'when guest' do
        before { patch_update }

        it { expect(response).to redirect_to('/users/sign_in') }
      end

      context 'when user' do
        before do
          sign_in(user)
        end

        it 'doesnt save category changes' do
          expect { patch_update }.not_to change { category.reload.name }
        end

        it 'responds in proper format' do
          patch_update
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq 'text/html; charset=utf-8'
          expect(response).to render_template :edit
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    subject(:delete_destroy) { delete "/categories/#{category.id}", headers: }

    let(:category) { create(:category, user:) }

    context 'when guest' do
      before { delete_destroy }

      it { expect(response).to redirect_to('/users/sign_in') }
    end

    context 'when user' do
      before do
        sign_in(user)
      end

      it 'destroys category' do
        expect { delete_destroy }.to change { Category.exists?(category.id) }.
          to(false)
      end

      describe 'assignments and responses' do
        before { delete_destroy }

        it 'does proper assignment' do
          expect(assigns(:category)).to eq(category)
        end

        describe 'html response' do
          let(:headers) { nil }

          it 'responds in proper format' do
            expect(response).to redirect_to('/categories')
            expect(response).to have_http_status(:see_other)
          end
        end

        describe 'turbo_stream response' do
          let(:headers) { { 'Accept' => 'text/vnd.turbo-stream.html' } }

          it 'responds in proper format' do
            expect(response).to have_http_status(:ok)
            expect(response.content_type).to eq(
              'text/vnd.turbo-stream.html; charset=utf-8'
            )
          end
        end
      end
    end
  end
end
