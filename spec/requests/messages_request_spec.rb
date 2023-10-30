require 'rails_helper'

RSpec.describe MessagesController, type: :request do
  let!(:users_room_member) { create(:users_room_member) }
  let(:user) { users_room_member.user }
  let(:room) { users_room_member.room }
  let(:message) { create(:message, author: user, room: room) }

  let!(:users_room_owner) { create(:users_room_owner, room: room) }
  let(:owner) { users_room_owner.user }

  let!(:users_room_admin) { create(:users_room_admin, room: room) }
  let(:admin) { users_room_admin.user }

  let!(:other_users_room_member) { create(:users_room_member, room: room)}
  let(:other_member) { other_users_room_member.user }
  let(:other_member_message) { create(:message, author: other_member, room: room) }

  let(:other_room) { create(:room) }
  let(:other_room_message) { create(:message, room: other_room) }

  let(:valid_attributes) { { content: 'This is a content', room_id: message.room.id } }
  let(:unvalid_attributes) { { content: nil, room_id: message.room.id } }

  context 'when user is member' do
    before do
      sign_in user
    end

    describe 'GET edit' do
      context 'when user is the author' do
        it 'it assigns @message' do
          get edit_room_message_path(room, message)
          expect(assigns(:message)).to eq(message)
        end

        it 'renders the template edit' do
          get edit_room_message_path(room, message)
          expect(response).to render_template(:edit)
        end

        it 'returns status code ok' do
          get edit_room_message_path(room, message)
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when user is not the author' do
        it 'raise  CanCan::AccessDenied:' do
          expect do
            get edit_room_message_path(room, other_member_message)
          end.to raise_error(CanCan::AccessDenied)
        end
      end
    end

    describe 'POST create' do
      context 'with valid params' do
        it 'creates a message' do
          params = { message:  valid_attributes }
          expect do
            post room_messages_path(room, format: :turbo_stream), params: params
          end.to change(Message, :count).by(1)
        end

        it 'responds with turbo_stream' do
          params = { message: valid_attributes }
          post room_messages_path(room, format: :turbo_stream), params: params
          expect(response.media_type).to eq Mime[:turbo_stream]
        end

        it 'returns a turbo_stream tag with replace action' do
          params = { message: valid_attributes }
          post room_messages_path(room, format: :turbo_stream), params: params
          expect(response.body).to include('<turbo-stream action="update" target="new_message">')
        end

        it 'returns a turbo_stream tag with append action' do
          params = { message: valid_attributes }
          post room_messages_path(room, format: :turbo_stream), params: params
          expect(response.body).to include('<turbo-stream action="prepend" target="flash">')
        end

        it 'returns a status code found' do
          params = { message: valid_attributes }
          post room_messages_path(room, format: :turbo_stream), params: params
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with unvalid params' do
        it 'does not create record' do
          params = { message: unvalid_attributes }
          expect do
            post room_messages_path(room, format: :turbo_stream), params: params
          end.to change(Message, :count).by(0)
        end

        it 'renders flash' do
          params = { message: unvalid_attributes }
          post room_messages_path(room, format: :turbo_stream), params: params
          expect(response).to render_template('layouts/flash')
        end

        it 'responds with turbo_stream' do
          params = { message: valid_attributes }
          post room_messages_path(room, format: :turbo_stream), params: params
          expect(response.media_type).to eq Mime[:turbo_stream]
        end

        it 'returns a status code unprocessable_entity' do
          params = { message: unvalid_attributes }
          post room_messages_path(room, format: :turbo_stream), params: params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'PUT update' do
      context 'with valid params' do
        context 'when use is author' do
          it 'update the message' do
            params = { message: valid_attributes }
            put room_message_path(room, message, format: :turbo_stream), params: params
            expect(message.reload.content).to eq(valid_attributes[:content])
          end

          it 'returns an empty body' do
            params = { message: valid_attributes }
            put room_message_path(room, message, format: :turbo_stream), params: params
            expect(response.body).to include("<turbo-stream action=\"replace\" target=\"message_#{message.id}\">")
          end

          it 'returns a status code ok' do
            params = { message: valid_attributes }
            put room_message_path(room, message, format: :turbo_stream), params: params
            expect(response).to have_http_status(:ok)
          end
        end

        context 'when user is not the author' do
          it 'raise  CanCan::AccessDenied:' do
            params = { message: valid_attributes }
            expect do
              put room_message_path(room, other_member_message, format: :turbo_stream), params: params
            end.to raise_error(CanCan::AccessDenied)
          end
        end
      end

      context 'with unvalid params' do
        it 'does not update message' do
          params = { message: unvalid_attributes }
          expect do
            put room_message_path(room, message, format: :turbo_stream), params: params
          end.to_not change(message, :content)
        end

        it 'renders the template layouts/flash' do
          params = { message: unvalid_attributes }
          put room_message_path(room, message, format: :turbo_stream), params: params
          expect(response).to render_template('layouts/flash')
        end

        it 'responds with turbo_stream' do
          params = { message: unvalid_attributes }
          put room_message_path(room, message, format: :turbo_stream), params: params
          expect(response.media_type).to eq Mime[:turbo_stream]
        end

        it 'returns a status code unprocessable_entity' do
          params = { message: unvalid_attributes }
          put room_message_path(room, message, format: :turbo_stream), params: params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'DELETE destroy' do
      context 'when user is the author' do
        it 'delete the message' do
          delete room_message_path(room, message)
          expect { message.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end

        it 'returns an empty body' do
          delete room_message_path(room, message)
          expect(response.body).to eq('')
        end

        it 'returns a status no_content' do
          delete room_message_path(room, message)
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'when user is not the author' do
        it 'raise  CanCan::AccessDenied:' do
          expect do
            delete room_message_path(room, other_member_message)
          end.to raise_error(CanCan::AccessDenied)
        end
      end
    end
  end

  context 'when user is connected as room owner' do
    before do
      sign_in owner
    end

    context 'managing message in his room' do
      describe 'GET edit' do
        it 'it assigns @message' do
          get edit_room_message_path(room, message)
          expect(assigns(:message)).to eq(message)
        end

        it 'renders the template edit' do
          get edit_room_message_path(room, message)
          expect(response).to render_template(:edit)
        end

        it 'returns status code ok' do
          get edit_room_message_path(room, message)
          expect(response).to have_http_status(:ok)
        end
      end

      describe 'PUT update' do
        it 'update the message' do
          params = { message: valid_attributes }
          put room_message_path(room, message, format: :turbo_stream), params: params
          expect(message.reload.content).to eq(valid_attributes[:content])
        end

        it 'returns an empty body' do
          params = { message: valid_attributes }
          put room_message_path(room, message, format: :turbo_stream), params: params
          expect(response.body).to include("<turbo-stream action=\"replace\" target=\"message_#{message.id}\">")

        end

        it 'returns a status code ok' do
          params = { message: valid_attributes }
          put room_message_path(room, message, format: :turbo_stream), params: params
          expect(response).to have_http_status(:ok)
        end
      end

      describe 'DELETE destroy' do
        it 'delete the message' do
          delete room_message_path(room, message)
          expect { message.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end

        it 'returns an empty body' do
          delete room_message_path(room, message)
          expect(response.body).to eq('')
        end

        it 'returns a status no_content' do
          delete room_message_path(room, message)
          expect(response).to have_http_status(:no_content)
        end
      end
    end

    context 'managing message from an other room' do
      describe 'GET edit' do
        it 'raise  CanCan::AccessDenied:' do
          expect do
            get edit_room_message_path(other_room, other_room_message)
          end.to raise_error(CanCan::AccessDenied)
        end
      end

      describe 'PUT update' do
        it 'raise  CanCan::AccessDenied:' do
          params = { message: valid_attributes }
          expect do
            put room_message_path(other_room, other_room_message, format: :turbo_stream), params: params
          end.to raise_error(CanCan::AccessDenied)
        end
      end

      describe 'DELETE destroy' do
        it 'raise  CanCan::AccessDenied:' do
          expect do
            delete room_message_path(other_room, other_room_message)
          end.to raise_error(CanCan::AccessDenied)
        end
      end
    end
  end

  context 'when user is connected as room admin' do
    before do
      sign_in admin
    end

    context 'managing message in his room' do
      describe 'GET edit' do
        it 'it assigns @message' do
          get edit_room_message_path(room, message)
          expect(assigns(:message)).to eq(message)
        end

        it 'renders the template edit' do
          get edit_room_message_path(room, message)
          expect(response).to render_template(:edit)
        end

        it 'returns status code ok' do
          get edit_room_message_path(room, message)
          expect(response).to have_http_status(:ok)
        end
      end

      describe 'PUT update' do
        it 'update the message' do
          params = { message: valid_attributes }
          put room_message_path(room, message, format: :turbo_stream), params: params
          expect(message.reload.content).to eq(valid_attributes[:content])
        end

        it 'returns an empty body' do
          params = { message: valid_attributes }
          put room_message_path(room, message, format: :turbo_stream), params: params
          expect(response.body).to include("<turbo-stream action=\"replace\" target=\"message_#{message.id}\">")

        end

        it 'returns a status code ok' do
          params = { message: valid_attributes }
          put room_message_path(room, message, format: :turbo_stream), params: params
          expect(response).to have_http_status(:ok)
        end
      end

      describe 'DELETE destroy' do
        it 'delete the message' do
          delete room_message_path(room, message)
          expect { message.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end

        it 'returns an empty body' do
          delete room_message_path(room, message)
          expect(response.body).to eq('')
        end

        it 'returns a status no_content' do
          delete room_message_path(room, message)
          expect(response).to have_http_status(:no_content)
        end
      end
    end

    context 'managing message from an other room' do
      describe 'GET edit' do
        it 'raise  CanCan::AccessDenied:' do
          expect do
            get edit_room_message_path(other_room, other_room_message)
          end.to raise_error(CanCan::AccessDenied)
        end
      end

      describe 'PUT update' do
        it 'raise  CanCan::AccessDenied:' do
          params = { message: valid_attributes }
          expect do
            put room_message_path(other_room, other_room_message, format: :turbo_stream), params: params
          end.to raise_error(CanCan::AccessDenied)
        end
      end

      describe 'DELETE destroy' do
        it 'raise  CanCan::AccessDenied:' do
          expect do
            delete room_message_path(other_room, other_room_message)
          end.to raise_error(CanCan::AccessDenied)
        end
      end
    end
  end

  context 'when user is not connected' do
    describe 'GET edit' do
      it 'redirects to sign in' do
        get edit_room_message_path(room, message)
        expect(response).to redirect_to(:new_user_session)
      end
    end

    describe 'GET create' do
      it 'redirects to sign in' do
        post room_messages_path(room)
        expect(response).to redirect_to(:new_user_session)
      end
    end

    describe 'GET update' do
      it 'red1irects to sign in' do
        put room_message_path(room, message)
        expect(response).to redirect_to(:new_user_session)
      end
    end

    describe 'GET destroy' do
      it 'redirects to sign in' do
        delete room_message_path(room, message)
        expect(response).to redirect_to(:new_user_session)
      end
    end
  end
end
