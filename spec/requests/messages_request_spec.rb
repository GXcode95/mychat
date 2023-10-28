require 'rails_helper'

RSpec.describe MessagesController, type: :request do
  let(:user) { create(:user) }
  let(:message) { create(:message, author: user) }
  let(:room) { message.room }
  let(:valid_attributes) { { content: 'This is a content', room_id: message.room.id } }
  let(:unvalid_attributes) { { content: nil, room_id: message.room.id } }

  context 'when user is connected' do
    before do
      sign_in user
    end

    describe 'GET new' do
      it 'assigns @message' do
        get new_message_path
        expect(assigns(:message)).to be_a_new(Message)
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

    # TODO; Check with turbo_stream edit
    describe 'GET edit' do
      it 'it assigns @message' do
        get edit_message_path(message)
        expect(assigns(:message)).to eq(message)
      end

      it 'renders the template edit' do
        get edit_message_path(message)
        expect(response).to render_template(:edit)
      end

      it 'returns status code ok' do
        get edit_message_path(message)
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'POST create' do
      context 'with valid params' do
        it 'creates a message' do
          params = { message:  valid_attributes }
          expect do
            post messages_path(format: :turbo_stream), params: params
          end.to change(Message, :count).by(1)
        end

        it 'responds with turbo_stream' do
          params = { message: valid_attributes }
          post messages_path(format: :turbo_stream), params: params
          expect(response.media_type).to eq Mime[:turbo_stream]
        end

        it 'returns a turbo_stream tag with replace action' do
          params = { message: valid_attributes }
          post messages_path(format: :turbo_stream), params: params
          expect(response.body).to include('<turbo-stream action="update" target="new_message">')
        end

        it 'returns a turbo_stream tag with append action' do
          params = { message: valid_attributes }
          post messages_path(format: :turbo_stream), params: params
          expect(response.body).to include('<turbo-stream action="prepend" target="flash">')
        end

        it 'returns a status code found' do
          params = { message: valid_attributes }
          post messages_path(format: :turbo_stream), params: params
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with unvalid params' do
        it 'does not create record' do
          params = { message: unvalid_attributes }
          expect do
            post messages_path(format: :turbo_stream), params: params
          end.to change(Message, :count).by(0)
        end

        it 'renders flash' do
          params = { message: unvalid_attributes }
          post messages_path(format: :turbo_stream), params: params
          expect(response).to render_template('layouts/flash')
        end

        it 'responds with turbo_stream' do
          params = { message: valid_attributes }
          post messages_path(format: :turbo_stream), params: params
          expect(response.media_type).to eq Mime[:turbo_stream]
        end

        it 'returns a status code unprocessable_entity' do
          params = { message: unvalid_attributes }
          post messages_path(format: :turbo_stream), params: params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'PUT update' do
      context 'with valid params' do
        it 'update the message' do
          params = { message: valid_attributes }
          put message_path(message, format: :turbo_stream), params: params
          expect(message.reload.content).to eq(valid_attributes[:content])
        end

        it 'returns an empty body' do
          params = { message: valid_attributes }
          put message_path(message, format: :turbo_stream), params: params
          expect(response.body).to eq('')
        end

        it 'returns a status code found' do
          params = { message: valid_attributes }
          put message_path(message, format: :turbo_stream), params: params
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'with unvalid params' do
        it 'does not update message' do
          params = { message: unvalid_attributes }
          expect do
            put message_path(
              message, format: :turbo_stream), params: params
          end.to_not change(message, :content)
        end

        it 'renders the template layouts/flash' do
          params = { message: unvalid_attributes }
          put message_path(message, format: :turbo_stream), params: params
          expect(response).to render_template('layouts/flash')
        end

        it 'responds with turbo_stream' do
          params = { message: unvalid_attributes }
          put message_path(message, format: :turbo_stream), params: params
          expect(response.media_type).to eq Mime[:turbo_stream]
        end

        it 'returns a status code unprocessable_entity' do
          params = { message: unvalid_attributes }
          put message_path(message, format: :turbo_stream), params: params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'DELETE destroy' do
      it 'delete the message' do
        delete message_path(message)
        expect { message.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'returns an empty body' do
        delete message_path(message)
        expect(response.body).to eq('')
      end

      it 'returns a status no_content' do
        delete message_path(message)
        expect(response).to have_http_status(:no_content)
      end
    end
  end

  context 'when user is not connected' do
    describe 'GET new' do
      it 'redirects to sign in' do
        get new_message_path
        expect(response).to redirect_to(:new_user_session)
      end
    end

    describe 'GET edit' do
      it 'redirects to sign in' do
        get edit_message_path(message)
        expect(response).to redirect_to(:new_user_session)
      end
    end

    describe 'GET create' do
      it 'redirects to sign in' do
        post messages_path
        expect(response).to redirect_to(:new_user_session)
      end
    end

    describe 'GET update' do
      it 'red1irects to sign in' do
        put message_path(message)
        expect(response).to redirect_to(:new_user_session)
      end
    end

    describe 'GET destroy' do
      it 'redirects to sign in' do
        delete message_path(message)
        expect(response).to redirect_to(:new_user_session)
      end
    end
  end

end
