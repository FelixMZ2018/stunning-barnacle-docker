module Api
  module V1
    class AppController < ApplicationController
      def status
        render json: { status: 200, message: "API is running" }
      end
    end
  end
end
