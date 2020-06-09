module BrainstemAdaptor
  module Parsers
    module ArrayParser
      # Parse irregular endpoints that return an array of objects instead of the standard JSON response
      def self.parse(response_data, collection_name)
        raise InvalidResponseError, "collection name is not specified" unless collection_name

        {
          "count" => response_data.count,
          "results" => response_data.map do |obj|
            {
              "key" => collection_name,
              "id" => obj["id"].to_s
            }
          end,
          collection_name => response_data.reduce({}) do |hash, obj|
            hash[obj["id"].to_s] = obj
            hash
          end
        }
      end
    end
  end
end
