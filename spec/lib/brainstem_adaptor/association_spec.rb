require 'spec_helper'

describe BrainstemAdaptor::Association do
  let(:nickolai) { { 'name' => 'Nickolai', 'friend_ids' => ['13', '14'], 'enemy_id' => '14' } }
  let(:ivan)     { { 'name' => 'Ivan',     'friend_ids' => [],           'enemy_id' => '12' } }
  let(:anatolii) { { 'name' => 'Anatolii', 'friend_ids' => ['13', '14'], 'enemy_id' => '12' } }

  let(:response_data) do
    {
      'count' => 0,
      'results' => [],
      'users' => {
        '12' => nickolai,
        '13' => ivan,
        '14' => anatolii
      }
    }
  end

  let(:specification) do
    {
      'users' => {
        'fields' => {
          'name' => {}
        },
        'associations' => {
          'friends' => {
            'foreign_key' => 'friend_ids',
            'collection' => 'users'
          },
          'enemy' => {
            'foreign_key' => 'enemy_id',
            'collection' => 'users'
          },
          'mother_in_law' => {
            'foreign_key' => 'mother_in_law_id',
            'collection' => 'users'
          }
        }
      }
    }
  end

  let(:response) do
    BrainstemAdaptor::Response.new(response_data, specification)
  end

  let(:nickolai_user) { BrainstemAdaptor::Record.new('users', '12', response) }
  let(:ivan_user)     { BrainstemAdaptor::Record.new('users', '13', response) }
  let(:anatolii_user) { BrainstemAdaptor::Record.new('users', '14', response) }

  let(:nickolai_friends) { described_class.new(nickolai_user, 'friends') }
  let(:ivan_friends)     { described_class.new(ivan_user,     'friends') }
  let(:anatoliy_friends) { described_class.new(anatolii_user, 'friends') }

  let(:nickolai_enemy) { described_class.new(nickolai_user, 'enemy') }
  let(:ivan_enemy)     { described_class.new(ivan_user,     'enemy') }
  let(:anatoliy_enemy) { described_class.new(anatolii_user, 'enemy') }

  describe '#==' do
    context 'has_many relations' do
      specify do
        expect(nickolai_friends).to eq(anatoliy_friends)
      end

      specify do
        expect(nickolai_friends).not_to eq(ivan_friends)
      end

      specify do
        expect(nickolai_friends).to eq(nickolai_friends)
      end

      specify do
        expect(ivan_friends).not_to eq(nickolai_friends)
      end

      specify do
        expect(ivan_friends).not_to eq(anatoliy_friends)
      end

      specify do
        expect(ivan_friends).to eq(ivan_friends)
      end

      specify do
        expect(anatoliy_friends).to eq(nickolai_friends)
      end

      specify do
        expect(anatoliy_friends).not_to eq(ivan_friends)
      end

      specify do
        expect(anatoliy_friends).to eq(anatoliy_friends)
      end
    end

    context 'has_one relations' do
      specify do
        expect(nickolai_enemy).not_to eq(anatoliy_enemy)
      end

      specify do
        expect(nickolai_enemy).not_to eq(ivan_enemy)
      end

      specify do
        expect(nickolai_enemy).to eq(nickolai_enemy)
      end

      specify do
        expect(ivan_enemy).not_to eq(nickolai_enemy)
      end

      specify do
        expect(ivan_enemy).to eq(anatoliy_enemy)
      end

      specify do
        expect(ivan_enemy).to eq(ivan_enemy)
      end

      specify do
        expect(anatoliy_enemy).not_to eq(nickolai_enemy)
      end

      specify do
        expect(anatoliy_enemy).to eq(ivan_enemy)
      end

      specify do
        expect(anatoliy_enemy).to eq(anatoliy_enemy)
      end
    end
  end

  describe '#[]' do
    specify do
      expect(nickolai_friends[0]).to eq(ivan)
    end

    specify do
      expect(nickolai_friends[0]).to eq(ivan_user)
    end

    specify do
      expect(nickolai_friends[1]).to eq(anatolii)
    end

    specify do
      expect(nickolai_friends[1]).to eq(anatolii_user)
    end

    specify do
      expect(nickolai_friends[2]).to be_nil
    end

    specify do
      expect(nickolai_enemy[0]).to eq(anatolii)
    end

    specify do
      expect(nickolai_enemy[0]).to eq(anatolii_user)
    end

    specify do
      expect(nickolai_enemy[1]).to be_nil
    end
  end

  describe '#each' do
    specify do
      expect(nickolai_friends.each).to be_a Enumerable
    end
  end

  describe '#records' do
    specify do
      expect(nickolai_friends.records).to eq([ivan, anatolii])
    end

    specify do
      expect(nickolai_enemy.records).to eq([anatolii])
    end
  end

  describe '#reflect' do
    specify do
      expect(nickolai_friends.reflect).to eq(nickolai_friends)
    end

    specify do
      expect(nickolai_enemy.reflect).to eq(anatolii)
    end
  end

  context 'association is not included in specification' do
    subject { described_class.new(nickolai_user, 'something wrong') }

    specify do
      expect { subject }.to raise_error ArgumentError, /specification/
    end
  end

  describe '#has_many?' do
    specify do
      expect(nickolai_friends.has_many?).to eq(true)
    end

    specify do
      expect(nickolai_enemy.has_many?).to eq(false)
    end
  end

  describe '#has_one?' do
    specify do
      expect(nickolai_friends.has_one?).to eq(false)
    end

    specify do
      expect(nickolai_enemy.has_one?).to eq(true)
    end
  end

  describe '#loaded?' do
    specify do
      expect(nickolai_user.association_by_name('mother_in_law').loaded?).to eq(false)
    end

    specify do
      expect(nickolai_user.association_by_name('friends').loaded?).to eq(true)
    end
  end
end
