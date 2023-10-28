require 'rails_helper'

RSpec.describe RoomsController, type: :request do
  let!(:room) { create(:room) }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:valid_attributes) { { name: Faker::Alphanumeric.alpha(number: 10) } }
  let(:private_valid_attributes) { { is_private: true } }

  context 'when user is connected' do
    before do
      sign_in user
    end

    describe 'GET index' do
      it 'assigns @rooms' do
        get rooms_path
        expect(assigns(:rooms)).to eq([room])
      end

      it 'renders the index template' do
        get rooms_path
        expect(response).to render_template(:index)
      end

      it 'returns status code ok' do
        get rooms_path
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'GET show' do
      it 'assigns @room' do
        get room_path(room)
        expect(assigns(:room)).to eq(room)
      end

      it 'renders the template show' do
        get room_path(room)
        expect(response).to render_template(:show)
      end

      it 'return a status code ok' do
        get room_path(room)
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'GET new' do
      it 'assigns @room' do
        get new_room_path
        expect(assigns(:room)).to be_a_new(Room)
      end

      it 'renders the template new' do
        get new_room_path
        expect(response).to render_template(:new)
      end

      it 'return a status code ok' do
        get new_room_path
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'POST create' do
      context 'with valid params' do
        context 'when room is public' do
          it 'creates a room' do
            params = { room: valid_attributes }
            expect do
              post rooms_path(format: :turbo_stream), params: params
            end.to change(Room, :count).by(1)
          end

          it 'redirects to to the show of the created room' do
            params = { room: valid_attributes }
            post rooms_path(format: :turbo_stream), params: params
            expect(response).to redirect_to(room_path(Room.last))
          end

          it 'returns a status code found' do
            params = { room: valid_attributes }
            post rooms_path(format: :turbo_stream), params: params
            expect(response).to have_http_status(:found)
          end
        end

        context 'when room is private' do
          it 'creates a room' do
            params = {
              room: {
                is_private: true
              },
              user_id: other_user.id
            }
            expect do
              post rooms_path(format: :turbo_stream), params: params
            end.to change(Room, :count).by(1)
          end

          it 'redirects to to the show of the created room' do
            params = {
              room: {
                is_private: true
              },
              user_id: other_user.id
            }
            post rooms_path(format: :turbo_stream), params: params
            expect(response).to redirect_to(room_path(Room.last))
          end

          it 'returns a status code found' do
            params = {
              room: {
                is_private: true
              },
              user_id: other_user.id
            }
            post rooms_path(format: :turbo_stream), params: params
            expect(response).to have_http_status(:found)
          end
        end
      end

      context 'with unvalid params' do
        it 'does not create record' do
          expect do
            post rooms_path(format: :turbo_stream), params: { room: { name: nil } }
          end.to change(Room, :count).by(0)
        end

        it 'renders flash' do
          post rooms_path(format: :turbo_stream), params: { room: { name: nil } }
          expect(response).to render_template('layouts/flash')
        end

        it 'returns a status code unprocessable_entity' do
          post rooms_path(format: :turbo_stream), params: { room: { name: nil } }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'GET edit' do
      it 'it assigns @room' do
        get edit_room_path(room)
        expect(assigns(:room)).to eq(room)
      end

      it 'renders the template edit' do
        get edit_room_path(room)
        expect(response).to render_template(:edit)
      end

      it 'returns status code ok' do
        get edit_room_path(room)
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'PUT update' do
      context 'with valid params' do
        it 'update a room' do
          params = { room: { name: 'new name' } }
          put room_path(room, format: :turbo_stream), params: params
          expect(room.reload.name).to eq('new name')
        end

        it 'redirects to to the show of the created room' do
          params = { room: valid_attributes }
          put room_path(room, format: :turbo_stream), params: params
          expect(response).to redirect_to(room_path(room))
        end

        it 'returns a status code found' do
          params = { room: valid_attributes }
          put room_path(room, format: :turbo_stream), params: params
          expect(response).to have_http_status(:found)
        end
      end

      context 'with unvalid params' do
        it 'does not update record' do
          expect do
            put room_path(room, format: :turbo_stream), params: { room: { name: nil } }
          end.to_not change(room, :name)
        end

        it 'renders flash' do
          put room_path(room, format: :turbo_stream), params: { room: { name: nil } }
          expect(response).to render_template('layouts/flash')
        end

        it 'returns a status code unprocessable_entity' do
          put room_path(room, format: :turbo_stream), params: { room: { name: nil } }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'DELETE destroy' do
      it 'delete the room' do
        delete room_path(room)
        expect { room.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'redirects to rooms index' do
        delete room_path(room)
        expect(response).to redirect_to(:rooms)
      end

      it 'returns a status code found' do
        delete room_path(room)
        expect(response).to have_http_status(:found)
      end
    end
  end

  context 'when user is not connected' do
    describe 'GET index' do
      it 'redirects to sign in' do
        get rooms_path
        expect(response).to redirect_to(:new_user_session)
      end
    end

    describe 'GET show' do
      it 'redirects to sign in' do
        get room_path(room)
        expect(response).to redirect_to(:new_user_session)
      end
    end

    describe 'GET new' do
      it 'redirects to sign in' do
        get new_room_path
        expect(response).to redirect_to(:new_user_session)
      end
    end

    describe 'GET edit' do
      it 'redirects to sign in' do
        get edit_room_path(room)
        expect(response).to redirect_to(:new_user_session)
      end
    end

    describe 'GET create' do
      it 'redirects to sign in' do
        post rooms_path
        expect(response).to redirect_to(:new_user_session)
      end
    end

    describe 'GET update' do
      it 'redirects to sign in' do
        put room_path(room)
        expect(response).to redirect_to(:new_user_session)
      end
    end

    describe 'GET destroy' do
      it 'redirects to sign in' do
        delete room_path(room)
        expect(response).to redirect_to(:new_user_session)
      end
    end
  end

end
