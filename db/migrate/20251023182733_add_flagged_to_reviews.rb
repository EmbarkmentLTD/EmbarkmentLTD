class AddFlaggedToReviews < ActiveRecord::Migration[8.0]
  def change
    add_column :reviews, :flagged, :boolean
  end
end
