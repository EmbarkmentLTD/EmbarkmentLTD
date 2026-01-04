# app/controllers/maintenance_controller.rb
class MaintenanceController < ApplicationController
  def seed
    if Rails.env.production?
      load Rails.root.join('db/seeds.rb')
      render plain: "Production database seeded successfully!"
    else
      render plain: "Not allowed"
    end
  end
end
