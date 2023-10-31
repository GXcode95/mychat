require 'rails_helper'

RSpec.describe UsersRoomsController, type: :request do
  let!(:users_room_owner) { create(:users_room_owner) }
  let(:room) { users_room_owner.room }
  let(:owner) { users_room_owner.user }

  let!(:users_room_admin) { create(:users_room_admin, room: room) }
  let(:admin) { users_room_admin.user }
  let!(:users_room_member) { create(:users_room_member, room: room) }
  let(:member) { users_room_member.user }

  let(:users_room_pending) { create(:users_room_pending, room: room) }

  let(:other_user) { create(:user)}

  let(:valid_attributes) { { status: :accepted, role: :owner } }

  context 'when current user is owner of the room' do
    before do
      sign_in owner
    end

    describe 'POST create' do
      it 'creates a users_room' do
        # expect do
        # end.to raise_error(CanCan::AccessDenied)
        expect do
          post users_rooms_path(format: :turbo_stream), params: { room_id: room.id }
        end.to_not change(room.users_rooms, :count)
      end

      it 'render the template flash' do
        post users_rooms_path(format: :turbo_stream), params: { room_id: room.id }
        expect(response).to render_template('layouts/flash')
      end

      it 'respond with turbo_stream' do
        post users_rooms_path(format: :turbo_stream), params: { room_id: room.id }
        expect(response.media_type).to eq(Mime[:turbo_stream])
      end

    #TODO RAISE ERROR
    end

    describe 'PUT update' do
      context 'with valid params' do
        it 'update the users_room' do
          params = {
            room_id: users_room_pending.room.id,
            users_room: {
              status: :accepted
            }
          }
          put users_room_path(users_room_pending, format: :turbo_stream), params: params
          expect(users_room_pending.reload.status).to eq('accepted')
        end

        it 'returns a turbo_stream tag with remove action' do
          params = {
            room_id: users_room_pending.room.id,
            users_room: {
              status: :accepted
            }
          }
          put users_room_path(users_room_pending, format: :turbo_stream), params: params
          expect(response.body).to include("<turbo-stream action=\"remove\" target=\"request_users_room_#{users_room_pending.id}\">")
        end

        it 'returns a turbo_stream tag with prepend action' do
          params = {
            room_id: users_room_pending.room.id,
            users_room: {
              status: :accepted
            }
          }
          put users_room_path(users_room_pending, format: :turbo_stream), params: params
          expect(response.body).to include('<turbo-stream action="prepend" target="room_members">')
        end

        it 'returns a status code found' do
          params = {
            room_id: users_room_pending.room.id,
            users_room: {
              status: :accepted
            }
          }
          put users_room_path(users_room_pending, format: :turbo_stream), params: params
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with unvalid params' do
        it 'does not update record' do
          params = {
            room_id: users_room_pending.room.id,
            users_room: {
              status: nil
            }
          }
          expect do
            put users_room_path(users_room_pending, format: :turbo_stream), params: params
          end.to_not change(users_room_pending, :status)
        end

        it 'renders the template layouts/flash' do
          params = {
            room_id: users_room_pending.room.id,
            users_room: {
              status: nil
            }
          }
          put users_room_path(users_room_pending, format: :turbo_stream), params: params
          expect(response).to render_template('layouts/flash')
        end

        it 'responds with turbo_stream' do
          params = {
            room_id: users_room_pending.room.id,
            users_room: {
              status: nil
            }
          }
          put users_room_path(users_room_pending, format: :turbo_stream), params: params
          expect(response.media_type).to eq Mime[:turbo_stream]
        end

        it 'returns a status code unprocessable_entity' do
          params = {
            room_id: users_room_pending.room.id,
            users_room: {
              status: nil
            }
          }
          put users_room_path(users_room_pending, format: :turbo_stream), params: params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'DELETE destroy' do
      it 'delete the room' do
        delete users_room_path(users_room_pending, format: :turbo_stream)
        expect { users_room_pending.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'returns a turbo_stream tag with replace action' do
        delete users_room_path(users_room_pending, format: :turbo_stream)
        expect(response.body).to include("<turbo-stream action=\"replace\" target=\"room_#{users_room_pending.room.id}\"")
      end

      it 'returns a turbo_stream tag with remove action' do
        delete users_room_path(users_room_pending, format: :turbo_stream)
        expect(response.body).to include("<turbo-stream action=\"remove\" target=\"member_users_room_#{users_room_pending.id}\"")
      end

      it 'returns a turbo_stream tag with remove action' do
        delete users_room_path(users_room_pending, format: :turbo_stream)
        expect(response.media_type).to eq Mime[:turbo_stream]
      end

      it 'returns a status code ok' do
        delete users_room_path(users_room_pending, format: :turbo_stream)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  context 'when current user is admin of the room' do
    before do
      sign_in admin
    end

    describe 'PUT update' do
      context 'with valid params' do
        it 'update the users_room' do
          params = {
            room_id: users_room_pending.room.id,
            users_room: {
              status: :accepted
            }
          }
          put users_room_path(users_room_pending, format: :turbo_stream), params: params
          expect(users_room_pending.reload.status).to eq('accepted')
        end

        it 'returns a turbo_stream tag with remove action' do
          params = {
            room_id: users_room_pending.room.id,
            users_room: {
              status: :accepted
            }
          }
          put users_room_path(users_room_pending, format: :turbo_stream), params: params
          expect(response.body).to include("<turbo-stream action=\"remove\" target=\"request_users_room_#{users_room_pending.id}\">")
        end

        it 'returns a turbo_stream tag with prepend action' do
          params = {
            room_id: users_room_pending.room.id,
            users_room: {
              status: :accepted
            }
          }
          put users_room_path(users_room_pending, format: :turbo_stream), params: params
          expect(response.body).to include('<turbo-stream action="prepend" target="room_members">')
        end

        it 'returns a status code found' do
          params = {
            room_id: users_room_pending.room.id,
            users_room: {
              status: :accepted
            }
          }
          put users_room_path(users_room_pending, format: :turbo_stream), params: params
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with unvalid params' do
        it 'does not update record' do
          params = {
            room_id: users_room_pending.room.id,
            users_room: {
              status: nil
            }
          }
          expect do
            put users_room_path(users_room_pending, format: :turbo_stream), params: params
          end.to_not change(users_room_pending, :status)
        end

        it 'renders the template layouts/flash' do
          params = {
            room_id: users_room_pending.room.id,
            users_room: {
              status: nil
            }
          }
          put users_room_path(users_room_pending, format: :turbo_stream), params: params
          expect(response).to render_template('layouts/flash')
        end

        it 'responds with turbo_stream' do
          params = {
            room_id: users_room_pending.room.id,
            users_room: {
              status: nil
            }
          }
          put users_room_path(users_room_pending, format: :turbo_stream), params: params
          expect(response.media_type).to eq Mime[:turbo_stream]
        end

        it 'returns a status code unprocessable_entity' do
          params = {
            room_id: users_room_pending.room.id,
            users_room: {
              status: nil
            }
          }
          put users_room_path(users_room_pending, format: :turbo_stream), params: params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'DELETE destroy' do
      it 'delete the room' do
        delete users_room_path(users_room_pending, format: :turbo_stream)
        expect { users_room_pending.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'returns a turbo_stream tag with replace action' do
        delete users_room_path(users_room_pending, format: :turbo_stream)
        expect(response.body).to include("<turbo-stream action=\"replace\" target=\"room_#{users_room_pending.room.id}\"")
      end

      it 'returns a turbo_stream tag with remove action' do
        delete users_room_path(users_room_pending, format: :turbo_stream)
        expect(response.body).to include("<turbo-stream action=\"remove\" target=\"member_users_room_#{users_room_pending.id}\"")
      end

      it 'returns a turbo_stream tag with remove action' do
        delete users_room_path(users_room_pending, format: :turbo_stream)
        expect(response.media_type).to eq Mime[:turbo_stream]
      end

      it 'returns a status code ok' do
        delete users_room_path(users_room_pending, format: :turbo_stream)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  context 'when current user is member of the room' do
    before do
      sign_in member
    end

    describe 'PUT update' do
      it 'update the users_room' do
        params = {
          room_id: users_room_pending.room.id,
          users_room: {
            status: :accepted
          }
        }
        expect do
          put users_room_path(users_room_pending, format: :turbo_stream), params: params
        end.to raise_error(CanCan::AccessDenied)
      end
    end

    describe 'DELETE destroy' do
      it 'delete the room' do
        expect do
          delete users_room_path(users_room_pending, format: :turbo_stream)
        end.to raise_error(CanCan::AccessDenied)
      end
    end
  end

  context 'when user is not related to the room' do
    before do
      sign_in other_user
    end

    describe 'POST create' do
      it 'creates a users_room' do
        expect do
          post users_rooms_path(format: :turbo_stream), params: { room_id: room.id }
        end.to change(room.users_rooms, :count).by(1)
      end

      it 'returns a turbo_stream tag with replace action' do
        post users_rooms_path(format: :turbo_stream), params: { room_id: room.id }
        expect(response.body).to include("<turbo-stream action=\"replace\" target=\"room_#{room.id}\">")
      end

      it 'responds with turbo_stream' do
        post users_rooms_path(format: :turbo_stream), params: { room_id: room.id }
        expect(response.media_type).to eq Mime[:turbo_stream]
      end

      it 'returns a status code found' do
        post users_rooms_path(format: :turbo_stream), params: { room_id: room.id }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  context 'when user is not connected' do
    describe 'GET create' do
      it 'redirects to sign in' do
        post users_rooms_path
        expect(response).to redirect_to(:new_user_session)
      end
    end

    describe 'GET update' do
      it 'redirects to sign in' do
        put users_room_path(create(:users_room))
        expect(response).to redirect_to(:new_user_session)
      end
    end

    describe 'GET destroy' do
      it 'redirects to sign in' do
        delete users_room_path(create(:users_room))
        expect(response).to redirect_to(:new_user_session)
      end
    end
  end

end
