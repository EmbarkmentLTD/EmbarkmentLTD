namespace :products do
  desc "Add relevant images to products based on product name"
  task add_images: :environment do
    require 'open-uri'
    require 'tempfile'

    # Extract search keyword from product name
    def extract_keyword(name)
      # Remove country/region prefixes and common words
      clean_name = name.gsub(/Nigerian|Ghanaian|Ethiopian|Kenyan|South African|Moroccan|Egyptian|Tunisian|Senegalese|Cameroonian|Tanzanian|Ugandan|Zambian|Zimbabwean|Malawian|Mozambique|Congolese|Ivorian|Beninese|Togolese|Burkinabe|Malian|Japanese|Korean|Chinese|Thai|Vietnamese|Indian|French|Italian|Spanish|Greek|Turkish|Lebanese|Mexican|Peruvian|Brazilian|American|Canadian|Australian|British|German|Dutch|Polish|Irish|Scottish|Norwegian|Swedish|Danish|Finnish|Austrian|Swiss|Belgian|Portuguese|Chilean|Argentine|Colombian|Venezuelan|Filipino|Indonesian|Malaysian|Sri Lankan|Hawaiian|California|Jamaican|Trinidadian|Dominican|Cuban|Puerto Rican|Georgian|Russian|Ukrainian|Hungarian|Czech|New Zealand|Premium|Fresh|Organic|Wild|Raw|Dried|Smoked|Fermented|Traditional|Golden|Royal|Giant|Baby/i, '')
      
      # Get main product word (usually the last significant word)
      words = clean_name.strip.split(/\s+/)
      
      # Common food keywords to prioritize
      food_words = %w[mango banana apple orange lemon lime coconut avocado pineapple papaya guava tomato pepper onion garlic ginger carrot potato yam cassava rice wheat flour corn maize millet sorghum quinoa oats barley basil mint oregano thyme rosemary parsley cilantro coriander cumin turmeric cinnamon pepper chili honey oil butter cheese milk yogurt cream egg chicken beef pork lamb fish salmon tuna shrimp crab lobster beans lentils peas nuts almonds cashews peanuts walnut pistachio hazelnut coffee tea cocoa chocolate vanilla sugar salt vinegar sauce]
      
      # Find food word in name
      name_lower = clean_name.downcase
      food_words.each do |food|
        return food if name_lower.include?(food)
      end
      
      # Fallback: use last word or category-based keyword
      words.last&.downcase&.gsub(/[^a-z]/, '') || 'food'
    end

    # Curated Unsplash image URLs by category (direct URLs, no rate limits)
    CATEGORY_IMAGES = {
      'fruits' => [
        'https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=400&h=400&fit=crop', # mixed fruits
        'https://images.unsplash.com/photo-1546548970-71785318a17b?w=400&h=400&fit=crop', # tropical fruits
        'https://images.unsplash.com/photo-1568702846914-96b305d2uj38?w=400&h=400&fit=crop', # mangoes
        'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400&h=400&fit=crop', # bananas
        'https://images.unsplash.com/photo-1528825871115-3581a5387919?w=400&h=400&fit=crop', # pineapple
        'https://images.unsplash.com/photo-1587735243615-c03f25aaff15?w=400&h=400&fit=crop', # oranges
        'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400&h=400&fit=crop', # apples
        'https://images.unsplash.com/photo-1553279768-865429fa0078?w=400&h=400&fit=crop', # papayas
        'https://images.unsplash.com/photo-1601004890684-d8cbf643f5f2?w=400&h=400&fit=crop', # avocados
        'https://images.unsplash.com/photo-1595475207225-428b62bda831?w=400&h=400&fit=crop'  # watermelon
      ],
      'vegetables' => [
        'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400&h=400&fit=crop', # mixed veg
        'https://images.unsplash.com/photo-1597362925123-77861d3fbac7?w=400&h=400&fit=crop', # leafy greens
        'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=400&h=400&fit=crop', # peppers
        'https://images.unsplash.com/photo-1590165482129-1b8b27698780?w=400&h=400&fit=crop', # tomatoes
        'https://images.unsplash.com/photo-1447175008436-054170c2e979?w=400&h=400&fit=crop', # carrots
        'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=400&h=400&fit=crop', # potatoes
        'https://images.unsplash.com/photo-1587411768638-ec71f8e33b78?w=400&h=400&fit=crop', # spinach
        'https://images.unsplash.com/photo-1596591606975-97ee5cef3a1e?w=400&h=400&fit=crop', # okra
        'https://images.unsplash.com/photo-1597062462912-d41e7b51e7d6?w=400&h=400&fit=crop', # onions
        'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=400&h=400&fit=crop'  # eggplant
      ],
      'grains' => [
        'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&h=400&fit=crop', # rice
        'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400&h=400&fit=crop', # wheat
        'https://images.unsplash.com/photo-1536304993881-ff6e9eefa2a6?w=400&h=400&fit=crop', # grains
        'https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?w=400&h=400&fit=crop', # quinoa
        'https://images.unsplash.com/photo-1604977042946-1eecc30f269e?w=400&h=400&fit=crop', # oats
        'https://images.unsplash.com/photo-1614961909012-76b36e98fb3a?w=400&h=400&fit=crop', # millet
        'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=400&h=400&fit=crop', # corn
        'https://images.unsplash.com/photo-1509358271058-acd22cc93898?w=400&h=400&fit=crop'  # barley
      ],
      'herbs' => [
        'https://images.unsplash.com/photo-1466637574441-749b8f19452f?w=400&h=400&fit=crop', # herbs
        'https://images.unsplash.com/photo-1599909533919-72952cc8b3fc?w=400&h=400&fit=crop', # spices
        'https://images.unsplash.com/photo-1509358435850-0d3b7df8e5f4?w=400&h=400&fit=crop', # basil
        'https://images.unsplash.com/photo-1542745936701-53d3d18d1cdc?w=400&h=400&fit=crop', # mint
        'https://images.unsplash.com/photo-1596547609652-9cf5d8d76921?w=400&h=400&fit=crop', # rosemary
        'https://images.unsplash.com/photo-1518732714860-b62714ce0c59?w=400&h=400&fit=crop', # turmeric
        'https://images.unsplash.com/photo-1607198179219-cd8b835fdda7?w=400&h=400&fit=crop', # ginger
        'https://images.unsplash.com/photo-1590301157890-4810ed352733?w=400&h=400&fit=crop'  # cinnamon
      ],
      'nuts' => [
        'https://images.unsplash.com/photo-1590005354167-6da97870c757?w=400&h=400&fit=crop', # mixed nuts
        'https://images.unsplash.com/photo-1536591562845-6d56a7a8d3a8?w=400&h=400&fit=crop', # peanuts
        'https://images.unsplash.com/photo-1563412885-3dc0b7c28a72?w=400&h=400&fit=crop', # cashews
        'https://images.unsplash.com/photo-1604193661793-f98b2a82a7c2?w=400&h=400&fit=crop', # almonds
        'https://images.unsplash.com/photo-1600345276015-7eb7c12ad68d?w=400&h=400&fit=crop', # walnuts
        'https://images.unsplash.com/photo-1616684000067-36952fde56ec?w=400&h=400&fit=crop', # hazelnuts
        'https://images.unsplash.com/photo-1615228402326-7adf9a257f2b?w=400&h=400&fit=crop'  # pistachios
      ],
      'dairy' => [
        'https://images.unsplash.com/photo-1628088062854-d1870b4553da?w=400&h=400&fit=crop', # cheese
        'https://images.unsplash.com/photo-1559598467-f8b76c8155d0?w=400&h=400&fit=crop', # milk
        'https://images.unsplash.com/photo-1486297678162-eb2a19b0a32d?w=400&h=400&fit=crop', # yogurt
        'https://images.unsplash.com/photo-1587664729688-d5a3c8a14e4c?w=400&h=400&fit=crop', # butter
        'https://images.unsplash.com/photo-1552767059-bdc1d11c3de7?w=400&h=400&fit=crop', # cream
        'https://images.unsplash.com/photo-1634487359989-3e90c9432133?w=400&h=400&fit=crop'  # cheese board
      ],
      'meat' => [
        'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=400&h=400&fit=crop', # steak
        'https://images.unsplash.com/photo-1602470520998-f4a52199a3d6?w=400&h=400&fit=crop', # chicken
        'https://images.unsplash.com/photo-1551028150-64b9f398f678?w=400&h=400&fit=crop', # lamb
        'https://images.unsplash.com/photo-1499028344343-cd173ffc68a9?w=400&h=400&fit=crop', # bbq meat
        'https://images.unsplash.com/photo-1448907503123-67254d59ca4f?w=400&h=400&fit=crop', # sausages
        'https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=400&h=400&fit=crop', # fish
        'https://images.unsplash.com/photo-1551135049-8a33b5883817?w=400&h=400&fit=crop'  # salmon
      ],
      'other' => [
        'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400&h=400&fit=crop', # honey
        'https://images.unsplash.com/photo-1606787366850-de6330128bfc?w=400&h=400&fit=crop', # breakfast
        'https://images.unsplash.com/photo-1498837167922-ddd27525d352?w=400&h=400&fit=crop', # healthy food
        'https://images.unsplash.com/photo-1504387432042-8aca549e4729?w=400&h=400&fit=crop', # coffee
        'https://images.unsplash.com/photo-1559058789-672da06263d8?w=400&h=400&fit=crop', # olive oil
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&h=400&fit=crop', # chocolate
        'https://images.unsplash.com/photo-1587049352851-8d4e89133924?w=400&h=400&fit=crop'  # spices
      ]
    }.freeze

    def category_image_url(category)
      images = CATEGORY_IMAGES[category] || CATEGORY_IMAGES['other']
      images.sample
    end

    # Fallback: Use Picsum for random placeholder images  
    def picsum_url
      "https://picsum.photos/400/400?random=#{rand(10000)}"
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
        # Get category-specific image URL
        image_url = category_image_url(product.category)
        
        # Download the image (follow redirects from source.unsplash.com)
        downloaded_image = URI.open(image_url, 
          "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)",
          read_timeout: 15,
          open_timeout: 15,
          redirect: true
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

  desc "Replace all product images with better matched images"
  task replace_images: :environment do
    require 'open-uri'
    require 'tempfile'

    products = Product.all
    total = products.count
    
    puts "Replacing images for #{total} products with category-appropriate images..."
    puts "This will DELETE existing images and add new relevant ones."
    
    success_count = 0
    error_count = 0

    products.find_each.with_index do |product, index|
      begin
        # Remove existing images
        product.images.purge if product.images.attached?
        
        # Get category-appropriate image URL
        image_url = category_image_url(product.category)
        
        # Download new image
        downloaded_image = URI.open(image_url, 
          "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)",
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
        print "."
        
      rescue => e
        error_count += 1
        puts "\nError for #{product.name}: #{e.message}"
      end
      
      if (index + 1) % 50 == 0
        puts "\nProcessed #{index + 1}/#{total}..."
      end
    end

    puts "\n\nCompleted!"
    puts "Successfully replaced images: #{success_count}"
    puts "Errors: #{error_count}"
  end
end
