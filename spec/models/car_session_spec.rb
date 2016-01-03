require 'rails_helper'

RSpec.describe CarSession, type: :model do
  describe '::for_user' do
    let (:user) { create(:user) }
    let (:car_session) { create(:car_session, user: user) }
    let (:params) { build(:car_session_params) }
    subject { CarSession.for_user(user, params) }

    context 'when no session at all' do
      it 'create new session' do
        expect(subject).to eq(CarSession.first)
        expect(CarSession.count).to eq(1)
      end
    end

    context 'when expired session without location' do
      let! (:car_session) { create(:car_session, user: user, created_at: Time.now - 16.minutes) }

      it 'create new session' do
        expect(subject).not_to eq(car_session)
        expect(CarSession.count).to eq(2)
      end
    end

    context 'when session with expired location' do
      let! (:car_location) { create(:car_location, car_session: car_session, created_at: Time.now - 16.minutes ) }

      it 'create new session' do
        expect(subject).not_to eq(car_session)
        expect(CarSession.count).to eq(2)
      end
    end

    context 'when actual session without location' do
      let! (:car_session) { create(:car_session, user: user) }

      it 'create new session' do
        expect(subject).to eq(car_session)
        expect(CarSession.count).to eq(1)
      end
    end

    context 'when session with actual location' do
      let! (:car_location) { create(:car_location, car_session: car_session ) }

      it 'create new session' do
        expect(subject).to eq(car_session)
        expect(CarSession.count).to eq(1)
      end
    end
  end
end
