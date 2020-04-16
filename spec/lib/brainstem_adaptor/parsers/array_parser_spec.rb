require "spec_helper"

describe BrainstemAdaptor::Parsers::ArrayParser do
  describe ".parse" do
    subject { described_class.parse(response_data, collection_name) }

    let(:response_data) do
      [
        {
          "id" => "1",
          "title" => "An object"
        },
        {
          "id" => "2",
          "title" => "A newer object"
        }
      ]
    end

    let(:collection_name) { "workspaces" }

    let(:formatted_response) do
      {
        "count" => response_data.count,
        "results" => [
          {
            "key" => collection_name,
            "id" => response_data[0]["id"]
          },
          {
            "key" => collection_name,
            "id" => response_data[1]["id"]
          }
        ],
        collection_name => {
          response_data[0]["id"] => response_data[0],
          response_data[1]["id"] => response_data[1]
        }
      }
    end

    it "formats the response to match brainstem" do
      expect(subject).to eq formatted_response
    end

    context "when collection name is not given" do
      let(:collection_name) { nil }

      it "raises an InvalidResponseError" do
        expect { subject }.to raise_error(BrainstemAdaptor::InvalidResponseError)
      end
    end
  end
end
