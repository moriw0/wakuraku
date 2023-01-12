require 'rails_helper'

RSpec.describe DashboardsController, type: :controller do
  describe '#event_reservations' do
    let(:user) { create(:user) }
    let(:event) { create(:event, owner: user) }

    context 'with an authorized user' do
      it 'responds successfully' do
        sign_in user
        get :event_reservations, params: { event_id: event.id }
        expect(response).to be_successful
      end
    end

    context 'with an unauthorized user' do
      let(:other_user) { create(:user) }

      it 'returns a 404 response' do
        sign_in other_user
        get :event_reservations, params: { event_id: event.id }
        expect(response).to have_http_status '404'
      end
    end
  end
end
