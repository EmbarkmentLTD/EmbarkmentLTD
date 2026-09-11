namespace :products do
  desc "Fetch temporary images from Unsplash API for products without images"
  task fetch_temp_images: :environment do
    require "net/http"
    require "json"

    # Unsplash API endpoint (free tier - no key required for basic functionality)
    # For production, consider using: https://pixabay.com/api/ or https://pexels.com/api/
    # Or direct free image URLs from a CDN

    TEMP_IMAGE_URLS = {
      "fruits" => [
        "https://images.unsplash.com/photo-1560806e614dc54006382f7e7a6db72c?w=400&h=400&fit=crop",
        "https://images.unsplash.com/photo-1557804506-669714d2e9d8?w=400&h=400&fit=crop",
        "https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=400&h=400&fit=crop"
      ],
      "vegetables" => [
        "https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=400&h=400&fit=crop",
        "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=400&fit=crop",
        "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&h=400&fit=crop"
      ],
      "grains" => [
        "https://images.unsplash.com/photo-1585328707804-8108bc8ca984?w=400&h=400&fit=crop",
        "https://images.unsplash.com/photo-1574943320219-553eb213f72d?w=400&h=400&fit=crop"
      ],
      "herbs" => [
        "https://images.unsplash.com/photo-1590856029620-ce4ecbae4b36?w=400&h=400&fit=crop",
        "https://images.unsplash.com/photo-1516986556328-44b7d6e95149?w=400&h=400&fit=crop"
      ],
      "nuts" => [
        "https://images.unsplash.com/photo-1585254825915-c3400ca199e7?w=400&h=400&fit=crop",
        "https://images.unsplash.com/photo-1585704032915-c3400ca199e7?w=400&h=400&fit=crop"
      ],
      "dairy" => [
        "https://images.unsplash.com/photo-1618164436241-4473940571cd?w=400&h=400&fit=crop",
        "https://images.unsplash.com/photo-1589924749821-b99e33dc6c16?w=400&h=400&fit=crop"
      ],
      "meat" => [
        "https://images.unsplash.com/photo-1432139555190-58524dae6a55?w=400&h=400&fit=crop",
        "https://images.unsplash.com/photo-1615485276934-a65bde88f764?w=400&h=400&fit=crop"
      ],
      "other" => [
        "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=400&fit=crop"
      ]
    }.freeze

    puts "Fetching temporary images for products without images..."

    products_without_images = Product.where("NOT EXISTS (SELECT 1 FROM active_storage_attachments WHERE active_storage_attachments.record_id = products.id AND active_storage_attachments.record_type = 'Product')")

    count = 0
    products_without_images.find_each do |product|
      category = product.category || "other"
      image_urls = TEMP_IMAGE_URLS[category] || TEMP_IMAGE_URLS["other"]

      # Select a random image URL for this product
      image_url = image_urls.sample

      begin
        # Download image from URL
        uri = URI(image_url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        response = http.get(uri.request_uri)

        if response.code == "200"
          # Attach the image to the product
          product.images.attach(
            io: StringIO.new(response.body),
            filename: "#{product.name.parameterize}_#{SecureRandom.hex(4)}.jpg",
            content_type: "image/jpeg"
          )

          count += 1
          puts "✓ Added temp image to: #{product.name} (#{category})"
        else
          puts "✗ Failed to fetch image for #{product.name} (HTTP #{response.code})"
        end
      rescue => e
        puts "✗ Error fetching image for #{product.name}: #{e.message}"
      end
    end

    puts "\n✅ Completed! Added temporary images to #{count} products."
    puts "\n📝 Note: These are temporary placeholder images from Unsplash."
    puts "   Sellers should upload their own product images to replace these."
    puts "   Images can be removed by the admin panel when seller uploads are ready."
  end
end
