require 'sinatra/base'
require 'tilt/erubis'
require 'json'
require 'yaml'
require 'date'

require_relative 'pivertiser/helpers'
require_relative 'pivertiser/racks'

module Pivertiser
  class App < Sinatra::Base
    helpers do
      include Pivertiser::Helpers
    end

    PI_RACK = {}

    get '/' do
      headers 'Vary' => 'Accept'

      respond_to do |wants|
        wants.html do
          @content = "<h1>Raspis we've heard from recently</h1>"
          @title = 'Pivertiser'
          @github_url = CONFIG['github_url']
          erb :index, layout: :default
        end

        wants.json do
          {
            app: 'Pivertiser'
          }.to_json
        end
      end
    end

    get '/:pi_name/:pi_ip' do
      PI_RACK[params[:pi_name]] = [
        params[:pi_ip],
        DateTime.now.strftime('%Y-%m-%d %H:%M:%S')
      ]
    end

    # start the server if ruby file executed directly
    run! if app_file == $0
  end
end
