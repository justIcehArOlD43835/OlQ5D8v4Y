# 代码生成时间: 2025-09-21 13:15:01
# interactive_chart_generator.rb
# This program is an interactive chart generator using Ruby and Grape framework.

require 'grape'
require 'grape-entity'
require 'json'
require 'active_support/core_ext/hash/deep_merge'
require 'chartkick' # Gem 'chartkick' required
require 'highcharts' # Gem 'highcharts' required

# Define our Grape API
class ChartAPI < Grape::API
  # Define our namespace for chart-related endpoints
  namespace :charts do
    # Define an endpoint for generating a chart
    get :generate do
      # Check if the data is provided
      error!('No data provided', 400) unless params[:data]
      
      # Prepare the chart data
      chart_data = JSON.parse(params[:data])
      
      # Check if the chart data is valid
      if chart_data.empty?
        error!('Invalid chart data', 400)
      end
      
      # Generate the chart using Chartkick
      chart = Chartkick.options[:library].new('generated_chart', chart_data)
      
      # Return the chart as HTML string
      present chart, with: ChartEntity
    end
  end
end

# Define a Grape entity for chart representation
class ChartEntity < Grape::Entity
  expose :to_html
end

# Error handling for Grape
class API < Grape::API
  # Custom error formatter
  format :json
  
  # Error handling for internal server errors
  error_formatter :json, ->(err, _opts) do
    { error: err.message }
  end
end