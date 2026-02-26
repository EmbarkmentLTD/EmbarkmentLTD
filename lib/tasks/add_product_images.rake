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

    # Get LoremFlickr URL for keyword (better rate limits than Unsplash source)
    def food_image_url(keyword, category)
      # Clean keyword for URL
      search_term = keyword.gsub(/[^a-z0-9\s]/i, '').strip.gsub(/\s+/, ',')
      
      # LoremFlickr supports keyword-based images
      # Add category context for better results
      category_terms = {
        'fruits' => 'fruit',
        'vegetables' => 'vegetable,greens',
        'grains' => 'rice,grain,wheat',
        'herbs' => 'spices,herbs',
        'nuts' => 'nuts,seeds',
        'dairy' => 'cheese,dairy,milk',
        'meat' => 'meat,beef,chicken',
        'other' => 'food,cooking'
      }
      
      context = category_terms[category] || 'food'
      
      # Use loremflickr.com for keyword-based images
      "https://loremflickr.com/400/400/#{search_term},#{context}/all?random=#{rand(10000)}"
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
        # Extract keyword from product name for relevant image search
        keyword = extract_keyword(product.name)
        image_url = food_image_url(keyword, product.category)
        
        puts "\n  #{product.name} -> searching: #{keyword}" if (index + 1) % 25 == 0
        
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

    # Extract search keyword from product name
    def extract_keyword(name)
      clean_name = name.gsub(/Nigerian|Ghanaian|Ethiopian|Kenyan|South African|Moroccan|Egyptian|Tunisian|Senegalese|Cameroonian|Tanzanian|Ugandan|Zambian|Zimbabwean|Malawian|Mozambique|Congolese|Ivorian|Beninese|Togolese|Burkinabe|Malian|Japanese|Korean|Chinese|Thai|Vietnamese|Indian|French|Italian|Spanish|Greek|Turkish|Lebanese|Mexican|Peruvian|Brazilian|American|Canadian|Australian|British|German|Dutch|Polish|Irish|Scottish|Norwegian|Swedish|Danish|Finnish|Austrian|Swiss|Belgian|Portuguese|Chilean|Argentine|Colombian|Venezuelan|Filipino|Indonesian|Malaysian|Sri Lankan|Hawaiian|California|Jamaican|Trinidadian|Dominican|Cuban|Puerto Rican|Georgian|Russian|Ukrainian|Hungarian|Czech|New Zealand|Premium|Fresh|Organic|Wild|Raw|Dried|Smoked|Fermented|Traditional|Golden|Royal|Giant|Baby/i, '')
      
      words = clean_name.strip.split(/\s+/)
      food_words = %w[mango banana apple orange lemon lime coconut avocado pineapple papaya guava tomato pepper onion garlic ginger carrot potato yam cassava rice wheat flour corn maize millet sorghum quinoa oats barley basil mint oregano thyme rosemary parsley cilantro coriander cumin turmeric cinnamon pepper chili honey oil butter cheese milk yogurt cream egg chicken beef pork lamb fish salmon tuna shrimp crab lobster beans lentils peas nuts almonds cashews peanuts walnut pistachio hazelnut coffee tea cocoa chocolate vanilla sugar salt vinegar sauce plantain spinach kale cabbage lettuce cucumber squash pumpkin melon watermelon grape berry date fig olive palm okra eggplant mushroom truffle sausage ham bacon prosciutto salami jerky biltong]
      
      name_lower = clean_name.downcase
      food_words.each do |food|
        return food if name_lower.include?(food)
      end
      
      words.last&.downcase&.gsub(/[^a-z]/, '') || 'food'
    end

    def food_image_url(keyword, category)
      search_term = keyword.gsub(/[^a-z0-9\s]/i, '').strip.gsub(/\s+/, '-')
      category_context = {
        'fruits' => 'fruit',
        'vegetables' => 'vegetable',
        'grains' => 'grain-food',
        'herbs' => 'spice-herb',
        'nuts' => 'nuts',
        'dairy' => 'dairy-cheese',
        'meat' => 'meat-food',
        'other' => 'food'
      }
      context = category_context[category] || 'food'
      "https://source.unsplash.com/400x400/?#{search_term},#{context}"
    end

    def picsum_url
      "https://picsum.photos/400/400?random=#{rand(10000)}"
    end

    products = Product.all
    total = products.count
    
    puts "Replacing images for #{total} products..."
    puts "This will DELETE existing images and add new relevant ones."
    
    success_count = 0
    error_count = 0

    products.find_each.with_index do |product, index|
      begin
        # Remove existing images
        product.images.purge if product.images.attached?
        
        # Extract keyword from product name
        keyword = extract_keyword(product.name)
        image_url = food_image_url(keyword, product.category)
        
        # Download new image
        downloaded_image = URI.open(image_url, 
          "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)",
          read_timeout: 15,
          open_timeout: 15,
          redirect: true
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
        
        sleep(0.2) # Be nice to Unsplash
        
      rescue => e
        error_count += 1
        puts "\nError for #{product.name} (#{keyword}): #{e.message}"
        
        # Fallback to picsum
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
          puts " Fallback failed: #{e2.message}"
        end
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
