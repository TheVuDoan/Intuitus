# frozen_string_literal: true

namespace :opensearch do
  desc "init opensearch index"
  task create_index: :environment do
    require 'dotenv/load'

    index_name = "intuitus_posts_#{Rails.env}"

    puts "Creating index: #{index_name} in #{Rails.env} environment..."

    client = OpenSearch::Client.new(
      url: ENV['OPENSEARCH_URL']
    )

    index_settings = {
      settings: {
        index: {
          number_of_shards: 1,
          number_of_replicas: 0
        }
      },
      mappings: {
        properties: {
          source: { type: 'integer' },
          title: { type: 'text' },
          description: { type: 'text' },
          publish_date: { type: 'date' }
        }
      }
    }

    if client.indices.exists?(index: index_name)
      puts "Index '#{index_name}' already exists."
    else
      client.indices.create(index: index_name, body: index_settings)
      puts "Index '#{index_name}' created successfully."
    end
  end
end
