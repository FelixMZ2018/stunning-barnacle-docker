# frozen_string_literal: true

module Api
  module V1
    class MessagesController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
      rescue_from ActiveRecord::ValueTooLong, with: :message_to_long

      def record_not_found
        render json: { message: "Message not found" }, status: 404
      end

      def message_to_long
        render json: { message: "Message longer than 255 characters" }, status: 400
      end

      def index
        messages = Message.all
        render json: { count: messages.count, messages: messages }, status: 200
      end

      def create
        message = Message.new(message_params)
        message.content = santize_content(message.content)
        if message.valid?
          message.save
          render json: { message: message }, status: 200
        else
          render json: { error: message.errors }, status: 400
        end
      end

      def show
        message = Message.find(params[:id])
        message.counter = message.counter + 1.to_i
        message.save
        render json: { message: message }, status: 200
      end

      def update
        message = Message.find(params[:id])
        validate = message.update(content: santize_content(params[:content]))
        if validate
          render json: { message: message }, status: 200
        else
          render json: { message: message.errors }, status: 400
        end
      end

      def destroy
        message = Message.find(params[:id])
        render json: { status: 200, message: "Message with ID:#{message.id} was deleted" }
        message.destroy
      end

      private

      def santize_content(content)
        Rails::Html::SafeListSanitizer.new.sanitize(content, tags: ["a"], attributes: ["href"])
      end

      def message_params
        params.permit(:content)
      end
    end
  end
end
