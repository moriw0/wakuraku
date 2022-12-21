require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  describe '#index' do
    context 'as an authenticated user' do
      before do
        @user = FactoryBot.create(:user)
      end

      it 'resoponds successfully' do
        sign_in @user
        get :index
        expect(response).to be_successful
      end

      it 'returns a 200 response' do
        sign_in @user
        get :index
        expect(response).to have_http_status '200'
      end
    end
    
    context 'as a guest' do
      it 'returns a 302 response' do
        get :index
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        get :index
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#create' do
    context 'as an authenticated user' do
      before do
        @user = FactoryBot.create(:user)
      end

      context 'with valid attributes' do
        it 'adds a event' do
          event_params = FactoryBot.attributes_for(:event, :with_hosted_dates)
          sign_in @user
          expect {
            post :create, params: { event: event_params, owner: @user }
          }.to change(@user.created_events, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not add a event' do
          event_params = FactoryBot.attributes_for(:event, :with_hosted_dates, name: nil)
          sign_in @user
          expect {
            post :create, params: { event: event_params, owner: @user }
          }.to_not change(@user.created_events, :count)
        end
      end
    end

    context 'as a guest' do
      it 'returns a 302 response' do 
        event_params = FactoryBot.attributes_for(:event, :with_hosted_dates)
        post :create, params: { event: event_params }
        expect(response).to have_http_status '302'
      end

      it 'redirect to the sign-in page' do
        event_params = FactoryBot.attributes_for(:event, :with_hosted_dates)
        post :create, params: { event: event_params }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#show' do
    context 'as an authenticated user' do
      before do
        @user = FactoryBot.create(:user)
        @event = FactoryBot.create(:event, :with_hosted_dates)
      end

      it 'responds successfully' do
        sign_in @user
        get :show, params: { id: @event.id }
        expect(response).to be_successful
      end

      it 'returns a 200 response' do
        sign_in @user
        get :show, params: { id: @event.id }
        expect(response).to have_http_status '200'
      end
    end

    context 'as a guest' do
      before do
        @event = FactoryBot.create(:event, :with_hosted_dates)
      end

      it 'responds successfully' do
        get :show, params: { id: @event.id }
        expect(response).to be_successful
      end

      it 'returns a 200 response' do
        get :show, params: { id: @event.id }
        expect(response).to have_http_status '200'
      end
    end
  end

  describe '#update' do
    context 'as an authorized user' do
      before do
        @user = FactoryBot.create(:user)
        @event = FactoryBot.create(:event, :with_hosted_dates, owner: @user, name: 'old_name')
      end

      it 'updates the event' do
        event_params = FactoryBot.attributes_for(:event, :with_hosted_dates, name: 'new_name')
        sign_in @user
        patch :update, params: { id: @event.id, event: event_params }
        expect(@event.reload.name).to eq 'new_name'
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @event = FactoryBot.create(:event, :with_hosted_dates, owner: other_user, name: 'old_name')
      end
      
      it 'raises exeption error' do
        event_params = FactoryBot.attributes_for(:event, :with_hosted_dates, name: 'new_name')
        sign_in @user
        expect {
          patch :update, params: { id: @event.id, event: event_params }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'as a guest' do
      before do
        user = FactoryBot.create(:user)
        @event = FactoryBot.create(:event, :with_hosted_dates, owner: user, name: 'old_name')
      end

      it 'retunes a 302 response' do
        event_params = FactoryBot.attributes_for(:event, :with_hosted_dates, name: 'new_event')
        patch :update, params: { id: @event.id, event: event_params }
        expect(response).to have_http_status'302'
      end
      
      it 'redirects to the sign-in page' do
        event_params = FactoryBot.attributes_for(:event, :with_hosted_dates, name: 'new_event')
        patch :update, params: { id: @event.id, event: event_params }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#destroy' do
    context 'as an authorized user' do
      before do
        @user = FactoryBot.create(:user)
        @event = FactoryBot.create(:event, :with_hosted_dates, owner: @user)
      end

      it 'destroys the event' do
        sign_in @user
        expect {
          delete :destroy, params: { id: @event.id }
        }.to change(@user.created_events, :count).by(-1)
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @event = FactoryBot.create(:event, :with_hosted_dates, owner: other_user)
      end
      
      it 'raises exeption error' do
        sign_in @user
        expect {
          delete :destroy, params: { id: @event.id }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'as a guest' do
      before do
        user = FactoryBot.create(:user)
        @event = FactoryBot.create(:event, :with_hosted_dates, owner: user)
      end

      it 'retunes a 302 response' do
        delete :destroy, params: { id: @event.id }
        expect(response).to have_http_status'302'
      end
      
      it 'redirects to the sign-in page' do
        delete :destroy, params: { id: @event.id }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end
