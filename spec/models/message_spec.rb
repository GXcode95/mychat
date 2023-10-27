require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:message) { create(:message) }

  describe 'Create a record' do
    context 'factories' do
      it 'it is valid' do
        expect(message).to be_valid
      end
    end

    context 'when content is nil' do
      it 'it is not valid' do
        msg = build(:message, content: nil)
        expect(msg).to_not be_valid
      end
    end

    context 'when author is nil' do
      it 'it is not valid' do
        msg = build(:message, author: nil)
        expect(msg).to_not be_valid
      end
    end

    context 'when room is nil' do
      it 'it is not valid' do
        msg = build(:message, room: nil)
        expect(msg).to_not be_valid
      end
    end

    context 'when content is more than Message::MAX_LENGTH chars' do
      it 'it is not valid' do
        msg = build(:message, content: Faker::Alphanumeric.alpha(number: Message::MAX_LENGTH + 1))
        expect(msg).to_not be_valid
      end
    end
  end
end
