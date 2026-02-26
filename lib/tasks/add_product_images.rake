namespace :products do
  desc "Add placeholder images to products without images"
  task add_images: :environment do
    require 'open-uri'
    require 'tempfile'

    # Category-specific Unsplash/placeholder keywords for better images
    category_images = {
      'fruits' => [
        'https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=400&h=400&fit=crop', # fruits
        'https://images.unsplash.com/photo-1568702846914-96b305d2uj38?w=400&h=400&fit=crop',
        'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=400&h=400&fit=crop'
      ],
      'vegetables' => [
        'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400&h=400&fit=crop', # vegetables
        'https://images.unsplash.com/photo-1597362925123-77861d3fbac7?w=400&h=400&fit=crop',
        'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=400&h=400&fit=crop'
      ],
      'grains' => [
        'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&h=400&fit=crop', # grains/rice
        'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400&h=400&fit=crop',
        'https://images.unsplash.com/photo-1536304993881-ff6e9eefa2a6?w=400&h=400&fit=crop'
      ],
      'herbs' => [
        'https://images.unsplash.com/photo-1466637574441-749b8f19452f?w=400&h=400&fit=crop', # herbs/spices
        'https://images.unsplash.com/photo-1509358271058-acd22cc93898?w=400&h=400&fit=crop',
        'https://images.unsplash.com/photo-1599909533919-72952cc8b3fc?w=400&h=400&fit=crop'
      ],
      'nuts' => [
        'https://images.unsplash.com/photo-1590005354167-6da97870c757?w=400&h=400&fit=crop', # nuts
        'https://images.unsplash.com/photo-1536591562845-6d56a7a8d3a8?w=400&h=400&fit=crop',
        'https://images.unsplash.com/photo-1563412885-3dc0b7c28a72?w=400&h=400&fit=crop'
      ],
      'dairy' => [
        'https://images.unsplash.com/photo-1628088062854-d1870b4553da?w=400&h=400&fit=crop', # dairy/cheese
        'https://images.unsplash.com/photo-1559598467-f8b76c8155d0?w=400&h=400&fit=crop',
        'https://images.unsplash.com/photo-1486297678162-eb2a19b0a32d?w=400&h=400&fit=crop'
      ],
      'meat' => [
        'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=400&h=400&fit=crop', # meat
        'https://images.unsplash.com/photo-1602470520998-f4a52199a3d6?w=400&h=400&fit=crop',
        'https://images.unsplash.com/photo-1551028150-64b9f398f678?w=400&h=400&fit=crop'
      ],
      'other' => [
        'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400&h=400&fit=crop', # food general
        'https://images.unsplash.com/photo-1606787366850-de6330128bfc?w=400&h=400&fit=crop',
        'https://images.unsplash.com/photo-1498837167922-ddd27525d352?w=400&h=400&fit=crop'
      ]
    }

    # Alternative: Use Picsum for random placeholder images
    def picsum_url
      "https://picsum.photos/400/400?random=#{rand(1000)}"
    end

    products_without_images = Product.left_joins(:images_attachments).where(active_storage_attachments: { id: nil })
    total = products_without_images.count
    
    puts "Found #{total} products without images"
    
    if total == 0
      puts "All products have images!"
      exit
    end

    success_count = 0
    error_count = 0

    products_without_images.find_each.with_index do |product, index|
      begin
        # Get category-specific image URL or use picsum
        urls = category_images[product.category] || category_images['other']
        image_url = urls.sample
        
        # Download the image
        downloaded_image = URI.open(image_url, 
          "User-Agent" => "Mozilla/5.0",
          read_timeout: 10,
          open_timeout: 10
        )
        
        # Create a temp file with proper extension
        temp_file = Tempfile.new(['product_image', '.jpg'])
        temp_file.binmode
        temp_file.write(downloaded_image.read)
        temp_file.rewind
        
        # Attach to product
        product.images.attach(
          io: temp_file,
          filename: "#{product.name.parameterize}-#{SecureRandom.hex(4)}.jpg",
          content_type: 'image/jpeg'
        )
        
        temp_file.close
        temp_file.unlink
        
        success_count += 1
        print "." if success_count % 10 == 0
        
        # Small delay to be nice to the image server
        sleep(0.1)
        
      rescue => e
        error_count += 1
        puts "\nError for #{product.name}: #{e.message}"
        
        # Try with picsum as fallback
        begin
          downloaded_image = URI.open(picsum_url, 
            "User-Agent" => "Mozilla/5.0",
            read_timeout: 15,
            open_timeout: 15
          )
          
          temp_file = Tempfile.new(['product_image', '.jpg'])
          temp_file.binmode
          temp_file.write(downloaded_image.read)
          temp_file.rewind
          
          product.images.attach(
            io: temp_file,
            filename: "#{product.name.parameterize}-#{SecureRandom.hex(4)}.jpg",
            content_type: 'image/jpeg'
          )
          
          temp_file.close
          temp_file.unlink
          
          success_count += 1
          error_count -= 1
          print "+"
        rescue => e2
          puts " Fallback also failed: #{e2.message}"
        end
      end
      
      # Progress update every 50 products
      if (index + 1) % 50 == 0
        puts "\nProcessed #{index + 1}/#{total} products..."
      end
    end

    puts "\n\nCompleted!"
    puts "Successfully added images: #{success_count}"
    puts "Errors: #{error_count}"
    
    # Verify
    remaining = Product.left_joins(:images_attachments).where(active_storage_attachments: { id: nil }).count
    puts "Products still without images: #{remaining}"
  end
end
