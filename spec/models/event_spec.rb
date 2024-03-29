require 'rails_helper'

RSpec.describe Event, type: :model do
  it 'is valid with a name, place, title, discription, price, required_time, capacity and is_published' do
    new_event = build(:event)
    expect(new_event).to be_valid
  end

  it 'is valid with images less than 5MB' do
    new_event = build(:event)
    new_event.images = [
      fixture_file_upload('1000x800_2.1MB.png'),
      fixture_file_upload('1000x800_3.2MB.png'),
      fixture_file_upload('1000x800_4.2MB.png')
    ]
    expect(new_event).to be_valid
  end

  it 'is invalid with images greater than 5MB' do
    new_event = build(:event)
    new_event.images = [
      fixture_file_upload('1000x800_5.3MB.png')
    ]
    new_event.valid?
    expect(new_event.errors[:images]).to include('は5MB以下である必要があります')
  end

  it 'is invalid without a name' do
    new_event = build(:event, name: nil)
    new_event.valid?
    expect(new_event.errors[:name]).to include('が入力されていません。')
  end

  it 'is invalid without a place' do
    new_event = build(:event, place: nil)
    new_event.valid?
    expect(new_event.errors[:place]).to include('が入力されていません。')
  end

  it 'is invalid without a title' do
    new_event = build(:event, title: nil)
    new_event.valid?
    expect(new_event.errors[:title]).to include('が入力されていません。')
  end

  it 'is invalid without a discription' do
    new_event = build(:event, discription: nil)
    new_event.valid?
    expect(new_event.errors[:discription]).to include('が入力されていません。')
  end

  it 'is invalid without a price' do
    new_event = build(:event, price: nil)
    new_event.valid?
    expect(new_event.errors[:price]).to include('が入力されていません。')
  end

  it 'is invalid without a required_time' do
    new_event = build(:event, required_time: nil)
    new_event.valid?
    expect(new_event.errors[:required_time]).to include('が入力されていません。')
  end

  it 'is invalid without a capacity' do
    new_event = build(:event, capacity: nil)
    new_event.valid?
    expect(new_event.errors[:capacity]).to include('が入力されていません。')
  end

  it 'is invalid without a is_published' do
    new_event = build(:event, is_published: nil)
    new_event.valid?
    expect(new_event.errors[:is_published]).to include('は一覧にありません')
  end

  it 'is invalid with a longer name than maximum length 50' do
    new_event = build(:event, name: '*' * 51)
    new_event.valid?
    expect(new_event.errors[:name]).to include('は50文字以下に設定して下さい。')
  end

  it 'is invalid with a longer place than maximum length 100' do
    new_event = build(:event, place: '*' * 101)
    new_event.valid?
    expect(new_event.errors[:place]).to include('は100文字以下に設定して下さい。')
  end

  it 'is invalid with a longer title than maximum length 100' do
    new_event = build(:event, title: '*' * 101)
    new_event.valid?
    expect(new_event.errors[:title]).to include('は100文字以下に設定して下さい。')
  end

  it 'is invalid with a longer discription than maximum length 2000' do
    new_event = build(:event, discription: '*' * 2001)
    new_event.valid?
    expect(new_event.errors[:discription]).to include('は2000文字以下に設定して下さい。')
  end

  it 'is invalid with a longer price than maximum length 7' do
    new_event = build(:event, price: 10**7)
    new_event.valid?
    expect(new_event.errors[:price]).to include('は7文字以下に設定して下さい。')
  end

  it 'is invalid with a longer required_time than maximum length 3' do
    new_event = build(:event, required_time: 10**3)
    new_event.valid?
    expect(new_event.errors[:required_time]).to include('は3文字以下に設定して下さい。')
  end

  it 'is invalid with a longer capacity than maximum length 3' do
    new_event = build(:event, capacity: 10**3)
    new_event.valid?
    expect(new_event.errors[:capacity]).to include('は3文字以下に設定して下さい。')
  end

  it 'can have many hosted_dates' do
    event = create(:event, :with_hosted_dates)
    expect(event.hosted_dates.length).to eq 3
  end

  describe 'owner' do
    let(:user) { create(:user) }
    let(:event) { create(:event, owner: user) }

    it 'is this user' do
      expect(event).to be_created_by(user)
    end

    it 'is not other user' do
      other_user = create(:user)
      expect(event).to_not be_created_by(other_user)
    end
  end
end
