class HomeController < ApplicationController
  def index
    @featured_products = Product.featured.in_stock.limit(8)
    @categories = Product::CATEGORIES


    # Get product counts per category
    @category_counts = Product.group(:category).count

    # For each category, get up to 4 products for the collage
    @category_products = {}

    @categories.each_key do |category_key|
      # Get up to 4 products from this category that have images
      category_products = Product.with_attached_images
                 .joins(:images_attachments)
                 .where(category: category_key)
                 .distinct
                 .order(created_at: :desc)
                 .limit(4)

      @category_products[category_key] = category_products if category_products.any?
    end
  end

  def mission
    @page = Page.find_by(slug: "our-mission") || create_default_page("our-mission", "Our Mission")
  end

  def about_us
    @page = Page.find_by(slug: "about-us") || create_default_page("about-us", "About Us")
  end

  def contact_us
    @page = Page.find_by(slug: "contact-us") || create_default_page("contact-us", "Contact Us")
  end

  private

  def create_default_page(slug, title)
    Page.create(
      slug: slug,
      title: title,
      content: default_content(slug)
    )
  end

  def default_content(slug)
    case slug
    when "contact-us"
      "<div class='max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12'>
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
    when "our-mission"
      "<div class='max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12'>
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
    when "about-us"
      "<div class='max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12'>
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
    else
      "<div class='max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12'><p>Page content coming soon...</p></div>"
    end
  end
end
