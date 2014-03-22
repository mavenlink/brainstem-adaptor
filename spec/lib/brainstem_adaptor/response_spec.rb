require 'spec_helper'

describe BrainstemAdaptor::Response do
  let(:json_response) do
    <<-JSON_RESPONSE
    {
      "count": 2,
      "results": [{ "key": "workspaces", "id": "10" }, { "key": "workspaces", "id": "11" }],
      "workspaces": {
        "10": {
          "id": "10",
          "title": "some project",
          "participant_ids": ["2", "6"],
          "primary_counterpart_id": "6"
        },
        "11": {
          "id": "11",
          "title": "another project",
          "participant_ids": ["2", "8"],
          "primary_counterpart_id": "8"
        }
      },
      "users": {
        "2": { "id": "2", "full_name": "bob" },
        "6": { "id": "6", "full_name": "chaz" },
        "8": { "id": "8", "full_name": "jane" }
      }
    }
    JSON_RESPONSE
  end

  let(:response_hash) { BrainstemAdaptor.parser.parse(json_response) }

  let(:specification) do
    {
      'workspaces' => {
        'fields' => {
          'title' => {
            'type' => 'string',
            'required' => true
          },
        },
        'associations' => {
          'participants' => {
            'foreign_key' => 'participant_ids',
            'collection' => 'users'
          },
          'primary_counterpart' => {
            'foreign_key' => 'primary_counterpart_id',
            'collection' => 'users'
          }
        }
      },
      'users' => {
        'fields' => {
          'full_name' => {
            'type' => 'string',
            'required' => true
          },
        }
      }
    }
  end

  before do
    BrainstemAdaptor.specification = specification
  end

  subject(:response) do
    described_class.new(json_response)
  end

  describe 'collection' do
    its(:count) { should == 2 }

    specify do
      expect(response.results).to have(2).records
    end

    describe 'records data' do
      specify do
        expect(response.results[0]).to be_a BrainstemAdaptor::Record
      end

      specify do
        expect(response.results[1]).to be_a BrainstemAdaptor::Record
      end

      specify do
        expect(response.results[0].collection_name).to eq('workspaces')
      end

      specify do
        expect(response.results[1].collection_name).to eq('workspaces')
      end

      specify do
        expect(response.results[0]).to eq(response_hash['workspaces']['10'])
      end

      specify do
        expect(response.results[1]).to eq(response_hash['workspaces']['11'])
      end
    end
  end

  describe 'associations' do
    specify do
      expect(response['users']).to eq(response_hash['users'])
    end

    describe '"has many" relations' do
      specify do
        expect(response.results[0]['participants'][0]).to be_a BrainstemAdaptor::Record
      end

      specify do
        expect(response.results[0]['participants'][1]).to be_a BrainstemAdaptor::Record
      end

      specify do
        expect(response.results[1]['participants'][0]).to be_a BrainstemAdaptor::Record
      end

      specify do
        expect(response.results[1]['participants'][1]).to be_a BrainstemAdaptor::Record
      end

      specify do
        expect(response.results[0]['participants']).to eq([response_hash['users']['2'], response_hash['users']['6']])
      end

      specify do
        expect(response.results[1]['participants']).to eq([response_hash['users']['2'], response_hash['users']['8']])
      end
    end

    describe '"has one" relations' do
      specify do
        expect(response.results[0]['primary_counterpart']).to be_a BrainstemAdaptor::Record
      end

      specify do
        expect(response.results[1]['primary_counterpart']).to be_a BrainstemAdaptor::Record
      end
    end
  end
end