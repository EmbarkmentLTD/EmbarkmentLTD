
# Clear existing data (order matters for foreign keys)
QuotationItem.destroy_all if defined?(QuotationItem)
Quotation.destroy_all if defined?(Quotation)
QuotationRequest.destroy_all if defined?(QuotationRequest)
OrderItem.destroy_all if defined?(OrderItem)
Order.destroy_all
Product.destroy_all
User.destroy_all
Page.destroy_all

# Skip email callbacks during seeding
User.skip_callback(:commit, :after, :send_initial_emails)

# Create admin user (auto-activated, skip email validation for seeds)
admin = User.new(
  name: 'Admin User',
  email: 'admin@embarkmentltd.com',
  password: 'admin123',
  location: 'Springfield, IL',
  role: 'admin',
  email_verified_at: Time.current
)
admin.save!(validate: false)

# Create sample suppliers
supplier1 = User.new(
  name: 'John Supplier',
  email: 'supplier1@example.com',
  password: 'test123',
  location: 'Springfield, IL',
  role: 'supplier'
)
supplier1.save!(validate: false)

supplier2 = User.new(
  name: 'Sarah Grower',
  email: 'supplier2@example.com',
  password: 'test123',
  location: 'Shelbyville, IL',
  role: 'supplier'
)
supplier2.save!(validate: false)

# Create sample customer
customer = User.new(
  name: 'Mike Customer',
  email: 'buyer1@example.com',
  password: 'buyer123',
  location: 'Springfield, IL',
  role: 'buyer'
)
customer.save!(validate: false)

# Create sample products
products = [
  {
    name: 'Organic Honey Crisp Apples',
    description: 'Freshly picked organic honey crisp apples from our family orchard. Sweet and crisp perfection. Grown without pesticides or synthetic fertilizers.',
    category: 'fruits',
    price: 3.99,
    stock_quantity: 50,
    unit: 'lb',
    location: 'Springfield, IL',
    is_organic: true,
    featured: true,
    harvest_date: Date.today - 5.days,
    user: supplier1
  },
  {
    name: 'Heirloom Tomatoes',
    description: 'Vine-ripened heirloom tomatoes with rich flavor and vibrant colors. Perfect for salads, sandwiches, and sauces.',
    category: 'vegetables',
    price: 4.50,
    stock_quantity: 25,
    unit: 'lb',
    location: 'Shelbyville, IL',
    is_organic: true,
    featured: true,
    harvest_date: Date.today - 2.days,
    user: supplier2
  },
  {
    name: 'Fresh Basil',
    description: 'Aromatic fresh basil leaves, perfect for pesto, Italian dishes, and garnishes. Grown in our greenhouse.',
    category: 'herbs',
    price: 2.99,
    stock_quantity: 15,
    unit: 'bunch',
    location: 'Springfield, IL',
    is_organic: false,
    featured: false,
    harvest_date: Date.today - 1.day,
    user: supplier1
  },
  {
    name: 'Organic Carrots',
    description: 'Sweet and crunchy organic carrots, freshly harvested. Great for snacking, roasting, or juicing.',
    category: 'vegetables',
    price: 2.50,
    stock_quantity: 30,
    unit: 'lb',
    location: 'Shelbyville, IL',
    is_organic: true,
    featured: true,
    harvest_date: Date.today - 3.days,
    user: supplier2
  },
  {
    name: 'Mixed Bell Peppers',
    description: 'Colorful mix of red, yellow, and green bell peppers. Sweet and crisp, perfect for stir-fries and salads.',
    category: 'vegetables',
    price: 3.75,
    stock_quantity: 20,
    unit: 'lb',
    location: 'Springfield, IL',
    is_organic: false,
    featured: false,
    harvest_date: Date.today - 2.days,
    user: supplier1
  }
]

products.each do |product_attrs|
  product = Product.new(product_attrs)
  product.save(validate: false)  # Skip validation
  puts "Created product: #{product.name}"
end

# Create sample reviews
reviews = [
  {
    product: Product.first,
    user: customer,
    rating: 5,
    comment: 'Absolutely delicious apples! Sweet, crisp, and perfectly fresh. Will definitely order again.'
  },
  {
    product: Product.second,
    user: customer,
    rating: 4,
    comment: 'Great tomatoes, very flavorful. Perfect for my caprese salad.'
  }
]

reviews.each do |review_attrs|
  review = Review.create!(review_attrs)
  puts "Created review for #{review.product.name}"
end

# Update product ratings
Product.all.each do |product|
  product.update_average_rating
  # Ensure defaults are set
  product.update_columns(
    average_rating: product.average_rating,
    reviews_count: product.reviews_count
  )
end

# Create default pages
pages = [
  {
    slug: 'contact-us',
    title: 'Contact Us',
    content: "<div class='max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12'>
      <h1 class='text-4xl font-bold text-gray-900 mb-8 text-center'>Contact Us</h1>
      <div class='grid grid-cols-1 md:grid-cols-2 gap-8'>
        <div class='bg-white rounded-xl shadow-sm p-6'>
          <h2 class='text-2xl font-semibold text-gray-800 mb-4'>Get In Touch</h2>
          <div class='space-y-4'>
            <div class='flex items-center'>
              <i data-lucide='mail' class='h-5 w-5 text-green-600 mr-3'></i>
              <span class='text-gray-700'>support@embarkmentltd.com</span>
            </div>
            <div class='flex items-center'>
              <i data-lucide='phone' class='h-5 w-5 text-green-600 mr-3'></i>
              <span class='text-gray-700'>+1 (555) 123-4567</span>
            </div>
            <div class='flex items-center'>
              <i data-lucide='map-pin' class='h-5 w-5 text-green-600 mr-3'></i>
              <span class='text-gray-700'>123 Farm Street, Agriculture City</span>
            </div>
          </div>
        </div>
        <div class='bg-white rounded-xl shadow-sm p-6'>
          <h2 class='text-2xl font-semibold text-gray-800 mb-4'>Send us a Message</h2>
          <p class='text-gray-600 mb-4'>We'd love to hear from you. Send us a message and we'll respond as soon as possible.</p>
          <p class='text-gray-600'>Our support team is available Monday to Friday, 9am to 5pm EST.</p>
        </div>
      </div>
    </div>"
  },
  {
    slug: 'our-mission',
    title: 'Our Mission',
    content: "<div class='max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12'>
      <h1 class='text-4xl font-bold text-gray-900 mb-8 text-center'>Our Mission</h1>
      <div class='bg-white rounded-xl shadow-sm p-8'>
        <div class='prose prose-lg max-w-none'>
          <h2 class='text-2xl font-semibold text-green-600 mb-4'>Connecting Farmers & Consumers</h2>
          <p class='text-gray-700 mb-6'>At EmbarkmentLTD, we believe in creating a sustainable future by bridging the gap between local farmers and conscious consumers.</p>

          <div class='grid grid-cols-1 md:grid-cols-2 gap-6 mb-8'>
            <div class='bg-green-50 rounded-lg p-6'>
              <h3 class='text-xl font-semibold text-gray-800 mb-3'>🌱 For Farmers</h3>
              <p class='text-gray-700'>Providing a platform to reach more customers and get fair prices for their hard work.</p>
            </div>
            <div class='bg-green-50 rounded-lg p-6'>
              <h3 class='text-xl font-semibold text-gray-800 mb-3'>🛒 For Consumers</h3>
              <p class='text-gray-700'>Offering fresh, locally-sourced products with complete transparency about their origin.</p>
            </div>
          </div>

          <h3 class='text-xl font-semibold text-gray-800 mb-4'>Our Values</h3>
          <ul class='list-disc list-inside text-gray-700 space-y-2 mb-6'>
            <li>Supporting local farming communities</li>
            <li>Promoting sustainable agriculture</li>
            <li>Ensuring food transparency and traceability</li>
            <li>Building trust between producers and consumers</li>
          </ul>
        </div>
      </div>
    </div>"
  },
  {
    slug: 'about-us',
    title: 'About Us',
    content: "<div class='max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12'>
      <h1 class='text-4xl font-bold text-gray-900 mb-8 text-center'>About Us</h1>
      <div class='bg-white rounded-xl shadow-sm p-8'>
        <div class='prose prose-lg max-w-none'>
          <h2 class='text-2xl font-semibold text-green-600 mb-4'>Our Story</h2>
          <p class='text-gray-700 mb-6'>EmbarkmentLTD was founded with a simple mission: to create a direct connection between local farmers and their communities.</p>

          <p class='text-gray-700 mb-6'>We believe that everyone deserves access to fresh, high-quality produce while supporting the hardworking farmers who grow our food.</p>

          <div class='grid grid-cols-1 md:grid-cols-3 gap-6 mb-8'>
            <div class='text-center'>
              <div class='bg-green-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4'>
                <i data-lucide='users' class='h-8 w-8 text-green-600'></i>
              </div>
              <h3 class='text-lg font-semibold text-gray-800 mb-2'>Community First</h3>
              <p class='text-gray-600 text-sm'>Building stronger local food ecosystems</p>
            </div>
            <div class='text-center'>
              <div class='bg-green-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4'>
                <i data-lucide='shield' class='h-8 w-8 text-green-600'></i>
              </div>
              <h3 class='text-lg font-semibold text-gray-800 mb-2'>Quality Guarantee</h3>
              <p class='text-gray-600 text-sm'>Rigorous standards for all our products</p>
            </div>
            <div class='text-center'>
              <div class='bg-green-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4'>
                <i data-lucide='heart' class='h-8 w-8 text-green-600'></i>
              </div>
              <h3 class='text-lg font-semibold text-gray-800 mb-2'>Farmer Support</h3>
              <p class='text-gray-600 text-sm'>Fair prices and direct market access</p>
            </div>
          </div>
        </div>
      </div>
    </div>"
  }
]

pages.each do |page_data|
  Page.find_or_create_by(slug: page_data[:slug]) do |page|
    page.title = page_data[:title]
    page.content = page_data[:content]
  end
  puts "Created page: #{page_data[:title]}"
end


puts ""
puts "Database seeded successfully!"
puts "Admin login: admin@embarkmentltd.com / admin123"
puts "Supplier login: supplier1@example.com / supplier123"
puts "Supplier login: supplier2@example.com / supplier123"
puts "Buyer login: buyer1@example.com / buyer123"
