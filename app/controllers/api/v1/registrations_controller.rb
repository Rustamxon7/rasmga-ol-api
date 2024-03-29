module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      include RackSessionsFix
      respond_to :json

      private

      def respond_with(resource, _opts = {})
        if resource.persisted?
          # UserMailer.welcome_email(resource).deliver_now
          
          render json: resource, status: :ok
        else
          render json: {
            error: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"
          }, status: :unprocessable_entity
        end
      end
    end
  end
end
