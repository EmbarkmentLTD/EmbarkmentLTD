class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def purge
    attachment = ActiveStorage::Attachment.find(params[:id])

    if can_delete_attachment?(attachment)
      # Allow removing the only image - remove any restrictions
      attachment.purge
      redirect_back fallback_location: edit_product_path(attachment.record),
                    notice: "Image removed successfully."
    else
      redirect_back fallback_location: root_path,
                    alert: "Not authorized to remove this image."
    end
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: root_path,
                  alert: "Image not found."
  end

  private

  def can_delete_attachment?(attachment)
    return true if current_user.admin?

    if attachment.record.respond_to?(:user)
      attachment.record.user == current_user
    else
      false
    end
  end
end
