namespace :products do
  desc "Populate 500 diverse products (African focus + worldwide)"
  task populate: :environment do
    puts "Creating 500 products..."
    
    # Get or create a supplier user for products
    supplier = User.find_by(role: 'supplier') || User.find_by(role: 'admin')
    
    unless supplier
      puts "No supplier or admin user found. Please run db:seed first."
      exit
    end

    # African locations (60%)
    african_locations = [
      "Lagos, Nigeria", "Accra, Ghana", "Nairobi, Kenya", "Dar es Salaam, Tanzania",
      "Kampala, Uganda", "Addis Ababa, Ethiopia", "Kigali, Rwanda", "Lusaka, Zambia",
      "Harare, Zimbabwe", "Maputo, Mozambique", "Dakar, Senegal", "Abidjan, Ivory Coast",
      "Cape Town, South Africa", "Johannesburg, South Africa", "Cairo, Egypt",
      "Casablanca, Morocco", "Tunis, Tunisia", "Douala, Cameroon", "Kinshasa, DRC",
      "Bamako, Mali", "Ouagadougou, Burkina Faso", "Conakry, Guinea", "Freetown, Sierra Leone",
      "Monrovia, Liberia", "Lome, Togo", "Cotonou, Benin", "Niamey, Niger"
    ]

    # World locations (40%)
    world_locations = [
      "London, UK", "Manchester, UK", "Birmingham, UK", "Paris, France", "Lyon, France",
      "Berlin, Germany", "Munich, Germany", "Amsterdam, Netherlands", "Brussels, Belgium",
      "Madrid, Spain", "Barcelona, Spain", "Rome, Italy", "Milan, Italy", "Lisbon, Portugal",
      "Dublin, Ireland", "Stockholm, Sweden", "Oslo, Norway", "Copenhagen, Denmark",
      "New York, USA", "Los Angeles, USA", "Chicago, USA", "Miami, USA", "Houston, USA",
      "Toronto, Canada", "Vancouver, Canada", "Sydney, Australia", "Melbourne, Australia",
      "Auckland, New Zealand", "Tokyo, Japan", "Seoul, South Korea", "Singapore",
      "Mumbai, India", "Delhi, India", "Bangkok, Thailand", "Jakarta, Indonesia",
      "São Paulo, Brazil", "Buenos Aires, Argentina", "Mexico City, Mexico", "Lima, Peru"
    ]

    # FRUITS (80 products) - African tropical focus
    fruits = [
      # African Fruits
      { name: "Golden Kalahari Mangoes", desc: "Sun-ripened mangoes from the heart of Africa. Bursting with tropical sweetness and velvety texture.", african: true },
      { name: "Nigerian Agbalumo (Star Apple)", desc: "The beloved African cherry! Sweet, tangy, and impossibly refreshing. A true taste of Lagos streets.", african: true },
      { name: "Rwandan Passion Fruit Paradise", desc: "Intensely aromatic passion fruits from the hills of Rwanda. Each bite is a tropical explosion!", african: true },
      { name: "Zanzibar Coconuts", desc: "Fresh young coconuts from the spice island. Sweet water and tender flesh straight from paradise.", african: true },
      { name: "Ethiopian Highland Avocados", desc: "Creamy, buttery avocados from Ethiopia's fertile highlands. Perfect ripeness guaranteed.", african: true },
      { name: "Kenyan Sweet Bananas", desc: "Finger-licking sweet bananas from Mount Kenya slopes. Nature's perfect energy snack!", african: true },
      { name: "Ghanaian Pawpaw Perfection", desc: "Juicy, sunset-orange papayas from Ghana. Rich in enzymes and absolutely divine.", african: true },
      { name: "South African Citrus Burst", desc: "Premium oranges from Cape vineyards. Perfectly balanced sweet-tart flavor.", african: true },
      { name: "Ugandan Jackfruit Giants", desc: "Massive, meaty jackfruits from Uganda. The vegetarian's dream fruit!", african: true },
      { name: "Tanzanian Pineapple Gold", desc: "Extra-sweet pineapples from Tanzania's volcanic soils. Pure liquid sunshine!", african: true },
      { name: "Senegalese Baobab Fruit", desc: "Superfruit from the African tree of life. Tangy, nutritious, and utterly unique.", african: true },
      { name: "Cameroon Bush Mango (Ogbono)", desc: "Wild harvested bush mangoes. Essential for authentic African soups!", african: true },
      { name: "Malawian Guavas", desc: "Pink-fleshed guavas bursting with vitamin C. Fragrant and irresistible.", african: true },
      { name: "Moroccan Blood Oranges", desc: "Ruby-red citrus treasures from Morocco. Dramatically beautiful and delicious.", african: true },
      { name: "Nigerian Soursop (Graviola)", desc: "Creamy, tangy soursop with legendary health benefits. Africa's healing fruit.", african: true },
      { name: "Ivory Coast Plantains", desc: "Premium cooking plantains, perfect for kelewele or dodo. Kitchen essential!", african: true },
      { name: "Egyptian Dates Premium", desc: "Medjool-style dates from the Nile Valley. Nature's caramel candy.", african: true },
      { name: "Zambian Wild Loquats", desc: "Honey-sweet loquats from Zambia's wilderness. A rare seasonal treat!", african: true },
      { name: "Congolese Safou (African Plum)", desc: "Buttery, savory African plums. Roast them for an unforgettable snack.", african: true },
      { name: "Mozambique Cashew Apples", desc: "The forgotten fruit! Sweet, tangy, and packed with vitamin C.", african: true },
      { name: "Benin Shea Fruits", desc: "Fresh shea fruits with sweet pulp. Rare and incredibly nutritious.", african: true },
      { name: "Togo Tamarind Pods", desc: "Tangy-sweet tamarind perfect for drinks and sauces. African flavor bomb!", african: true },
      { name: "Niger Desert Melons", desc: "Sweet melons thriving in Sahel conditions. Refreshing and resilient.", african: true },
      { name: "Burkina Faso Néré Fruits", desc: "Traditional locust bean fruits. Essential for authentic dawadawa.", african: true },
      { name: "Guinea Forest Berries Mix", desc: "Wild-harvested berry medley from Guinea's rainforests. Antioxidant powerhouse!", african: true },
      { name: "Sierra Leone Palm Fruits", desc: "Fresh palm fruits for traditional palm oil. Farm to table freshness.", african: true },
      { name: "Liberian Kola Nuts", desc: "Ceremonial kola nuts with natural caffeine. Cultural significance in every bite.", african: true },
      { name: "Mali Jujube Fruits", desc: "Desert dates with apple-like crunch. Sweet, healthy, and satisfying.", african: true },
      { name: "Chad Wild Figs", desc: "Sun-dried Saharan figs. Intensely sweet with chewy texture.", african: true },
      { name: "Namibian !Nara Melons", desc: "Ancient desert melons from Namibia. A 8000-year-old delicacy!", african: true },
      { name: "Botswana Marula Fruits", desc: "The elephant's favorite fruit! Makes the famous Amarula cream.", african: true },
      { name: "Eswatini Sugar Plums", desc: "Wild plums from Eswatini mountains. Perfectly tart and refreshing.", african: true },
      { name: "Lesotho Mountain Peaches", desc: "High-altitude peaches with intense flavor. Cold nights make them sweeter!", african: true },
      { name: "Mauritius Victoria Pineapples", desc: "The queen of pineapples! Extra sweet, low acid, pure luxury.", african: true },
      { name: "Madagascar Lychees", desc: "Fragrant lychees from the Red Island. Floral, sweet, and addictive.", african: true },
      { name: "Seychelles Coco de Mer", desc: "The world's largest seed! Rare, exotic, and unforgettable.", african: true },
      { name: "Comoros Ylang Ylang Fruits", desc: "Aromatic fruits from the perfume islands. Unique and fragrant.", african: true },
      { name: "Djibouti Dragon Fruits", desc: "Vibrant pink pitaya from Horn of Africa. Instagram-worthy superfood!", african: true },
      { name: "Eritrean Cactus Pears", desc: "Beles fruits beloved in Eritrea. Sweet, cooling, and nutritious.", african: true },
      { name: "Somali Frankincense Berries", desc: "Rare berries from frankincense trees. Sacred and medicinal.", african: true },
      # World Fruits
      { name: "Spanish Seville Oranges", desc: "The marmalade maker's dream! Bitter, aromatic, and utterly British-approved.", african: false },
      { name: "Italian Amalfi Lemons", desc: "Massive, fragrant lemons from Italy's stunning coast. Limoncello perfection!", african: false },
      { name: "French Provence Melons", desc: "Charentais melons with intoxicating aroma. The taste of French summer.", african: false },
      { name: "Greek Kalamata Figs", desc: "Honey-dripping figs from ancient groves. Mediterranean sweetness.", african: false },
      { name: "Turkish Sultana Grapes", desc: "Golden grapes destined for wine or raisins. Sun-kissed excellence.", african: false },
      { name: "Brazilian Açaí Berries", desc: "Superfood sensation from Amazon! Purple power for your smoothie bowl.", african: false },
      { name: "Colombian Dragon Fruit", desc: "Yellow pitaya with white flesh. Sweeter than its pink cousin!", african: false },
      { name: "Peruvian Lucuma", desc: "The gold of the Incas! Butterscotch-maple flavor like nothing else.", african: false },
      { name: "Mexican Mamey Sapote", desc: "Creamy, pumpkin-pie flavored tropical gem. Central American treasure.", african: false },
      { name: "Thai Mangosteen Queen", desc: "The queen of fruits! Purple shell hides snow-white, heavenly segments.", african: false },
      { name: "Vietnamese Rambutan", desc: "Hairy lychee cousin with sweet, juicy flesh. Fun to eat!", african: false },
      { name: "Philippine Carabao Mangoes", desc: "Voted world's sweetest mango! Silky, fiberless, unforgettable.", african: false },
      { name: "Indonesian Durian King", desc: "Love it or hate it! The infamous king of fruits with custard flesh.", african: false },
      { name: "Japanese Yubari Melons", desc: "Premium cantaloupe from Hokkaido. Gift-worthy perfection.", african: false },
      { name: "Korean Asian Pears", desc: "Crispy-juicy pears with apple texture. Refreshingly different.", african: false },
      { name: "Chinese Lychees Premium", desc: "Traditional lychees from Guangdong. Floral sweetness in every bite.", african: false },
      { name: "Indian Alphonso Mangoes", desc: "The champagne of mangoes! Saffron-colored, intensely aromatic.", african: false },
      { name: "New Zealand Kiwis", desc: "Fuzzy green goodness! More vitamin C than oranges.", african: false },
      { name: "Australian Finger Limes", desc: "Citrus caviar! Lime pearls burst in your mouth.", african: false },
      { name: "American Honeycrisp Apples", desc: "The perfect apple! Explosive crunch, balanced sweetness.", african: false },
      { name: "Canadian Wild Blueberries", desc: "Tiny but mighty! More antioxidants than cultivated berries.", african: false },
      { name: "Chilean Cherries", desc: "Summer cherries in winter! Sweet, plump, and perfect.", african: false },
      { name: "Argentine Pears Williams", desc: "Classic European pear variety from Patagonia. Butter-smooth.", african: false },
      { name: "UK Victoria Plums", desc: "British heritage plums. Perfect for crumbles and jams!", african: false },
      { name: "German Quetsch Plums", desc: "Traditional damson-style plums. Ideal for schnaps!", african: false },
      { name: "Polish Wild Strawberries", desc: "Forest strawberries with intense aroma. Tiny flavor bombs!", african: false },
      { name: "Dutch Greenhouse Tomatoes", desc: "Year-round perfection from Netherlands' glass city.", african: false },
      { name: "Belgian Conference Pears", desc: "Elegant, elongated pears. Smooth and sophisticated.", african: false },
      { name: "Swiss Mountain Apricots", desc: "Alpine apricots with concentrated flavor. Sunshine preserved!", african: false },
      { name: "Austrian Wachau Apricots", desc: "Famous Danube Valley apricots. Austria's orange gold.", african: false }
    ]

    # VEGETABLES (100 products)
    vegetables = [
      # African Vegetables
      { name: "Nigerian Ugu Leaves (Fluted Pumpkin)", desc: "The king of Nigerian soups! Deep green, nutrient-dense, irreplaceable.", african: true },
      { name: "Kenyan Sukuma Wiki", desc: "East Africa's beloved collard greens. Daily nutrition for millions!", african: true },
      { name: "Ghanaian Kontomire", desc: "Cocoyam leaves for authentic palava sauce. Silky and nutritious.", african: true },
      { name: "Ethiopian Gomen", desc: "Spiced collard greens Ethiopian-style. Perfect with injera!", african: true },
      { name: "South African Morogo", desc: "Wild African spinach. Packed with iron and tradition.", african: true },
      { name: "Nigerian Ewedu Leaves", desc: "Jute leaves for that slippery, delicious Yoruba soup. Essential!", african: true },
      { name: "Cameroonian Eru Leaves", desc: "Wild forest vegetable for eru soup. Meaty texture, deep flavor.", african: true },
      { name: "Nigerian Bitter Leaf", desc: "Medicinal and culinary! Key ingredient in bitterleaf soup.", african: true },
      { name: "Tanzanian Mchicha", desc: "African amaranth greens. Quick-cooking, highly nutritious.", african: true },
      { name: "Ugandan Nakati", desc: "Traditional Ugandan eggplant leaves. Subtle, satisfying flavor.", african: true },
      { name: "Zimbabwean Covo", desc: "Collard green cousin perfect for sadza. Daily staple!", african: true },
      { name: "Nigerian Waterleaf", desc: "Succulent leaves for edikang ikong. Juicy and refreshing.", african: true },
      { name: "Malian Baobab Leaves", desc: "Dried superfood leaves for sauces. Protein-rich green power!", african: true },
      { name: "Senegalese Bissap Leaves", desc: "Hibiscus greens for traditional dishes. Tangy and healthy.", african: true },
      { name: "Nigerian Okra (Perfect Cut)", desc: "Fresh lady fingers, pre-sliced for soups. Mucilaginous magic!", african: true },
      { name: "Kenyan Garden Eggs", desc: "Small African eggplants. Slightly bitter, deeply satisfying.", african: true },
      { name: "Ghanaian Shito Peppers", desc: "Fiery peppers for authentic Ghanaian black pepper sauce.", african: true },
      { name: "Nigerian Scotch Bonnets", desc: "Ata rodo! Extreme heat with fruity undertones. Handle with care!", african: true },
      { name: "Ethiopian Berbere Chillies", desc: "Sun-dried chillies for the essential spice blend.", african: true },
      { name: "Moroccan Preserved Lemons", desc: "Salt-cured sunshine! Essential for tagines and couscous.", african: true },
      { name: "Egyptian Molokhia", desc: "Jute mallow for the national dish. Slippery, savory, soulful.", african: true },
      { name: "Tunisian Harissa Peppers", desc: "Smoked peppers for North Africa's famous paste.", african: true },
      { name: "Nigerian Locust Beans (Iru)", desc: "Fermented umami bombs! The African Parmesan alternative.", african: true },
      { name: "Cameroon Fresh Cassava", desc: "Starchy root for fufu and garri. Carb-loading done right!", african: true },
      { name: "Nigerian Yam Tubers", desc: "King of tubers! Pounded yam dreams start here.", african: true },
      { name: "Ghanaian Cocoyam", desc: "Taro root for fufu and mpotompoto. Creamy when cooked.", african: true },
      { name: "Kenyan Sweet Potatoes", desc: "Orange-fleshed varieties packed with beta-carotene. Sweet nutrition!", african: true },
      { name: "Ugandan Matooke (Green Bananas)", desc: "Cooking bananas for the national dish. Starchy staple!", african: true },
      { name: "Tanzanian Cassava Leaves", desc: "Sombe ingredients! Pounded leaves for creamy stews.", african: true },
      { name: "Nigerian Tiger Nuts", desc: "Actually tubers! Sweet, crunchy, perfect for kunnu drink.", african: true },
      { name: "South African Gem Squash", desc: "Tennis ball-sized squash. Stuff them, bake them, love them!", african: true },
      { name: "Botswana Morula Seeds", desc: "Nutritious seeds for traditional dishes. Hidden gems!", african: true },
      { name: "Zambian Pumpkin Leaves", desc: "Chibwabwa! Tender leaves for creamy groundnut dishes.", african: true },
      { name: "Mozambique Matapa Leaves", desc: "Cassava leaves for coconut-peanut stew. Coastal treasure!", african: true },
      { name: "Zimbabwean Muboora", desc: "Pumpkin leaves prepared the Shona way. Comfort food!", african: true },
      { name: "Nigerian Oha Leaves", desc: "Ora leaves for traditional Igbo soup. Aromatic and authentic.", african: true },
      { name: "Nigerian Uziza Leaves", desc: "Peppery leaves with unique spicy kick. One of a kind!", african: true },
      { name: "Kenyan Arrow Roots", desc: "Nduma tubers! Starchy, filling, naturally gluten-free.", african: true },
      { name: "Ethiopian Injera Teff", desc: "Not a vegetable but essential! For spongy flatbread.", african: true },
      { name: "Rwandan Isombe Ingredients", desc: "Cassava leaves kit for the national dish.", african: true },
      # World Vegetables
      { name: "Japanese Shiitake Mushrooms", desc: "Umami kings! Meaty texture, immune-boosting power.", african: false },
      { name: "Korean Kimchi Cabbage", desc: "Napa cabbage ready for fermentation. K-food essential!", african: false },
      { name: "Chinese Bok Choy Baby", desc: "Tender Asian greens. Stir-fry in 2 minutes flat!", african: false },
      { name: "Thai Holy Basil", desc: "Krapao! Essential for authentic pad krapao. Peppery and divine.", african: false },
      { name: "Vietnamese Water Spinach", desc: "Morning glory greens! Hollow stems, amazing stir-fried.", african: false },
      { name: "Indian Curry Leaves", desc: "Aromatic leaves that define South Indian cuisine. Irreplaceable!", african: false },
      { name: "Mexican Poblano Peppers", desc: "Mild heat, rich flavor. Stuff them, roast them, love them!", african: false },
      { name: "Peruvian Purple Potatoes", desc: "Ancient Incan variety! Antioxidant-rich, gorgeous color.", african: false },
      { name: "Italian San Marzano Tomatoes", desc: "The pizza tomato! Sweet, low-acid, sauce perfection.", african: false },
      { name: "Spanish Piquillo Peppers", desc: "Flame-roasted red peppers. Sweet and sophisticated.", african: false },
      { name: "French Shallots", desc: "The chef's onion! Sweet, complex, essential for sauces.", african: false },
      { name: "Dutch Baby Carrots", desc: "Sweet, tender, perfect for snacking. Kids love them!", african: false },
      { name: "Belgian Endive", desc: "Elegant chicory spears. Bitter-sweet sophistication.", african: false },
      { name: "German Sauerkraut Cabbage", desc: "Fermentation-ready cabbages. Probiotics await!", african: false },
      { name: "Polish Beets", desc: "Deep purple borscht bombs. Earthy and nutritious.", african: false },
      { name: "UK Jersey Royals", desc: "The champagne of potatoes! Nutty, buttery, seasonally limited.", african: false },
      { name: "Scottish Neeps", desc: "Turnips for haggis night! Traditional Burns supper.", african: false },
      { name: "Irish Colcannon Cabbage", desc: "Savoy cabbage for Irish mashed potato magic.", african: false },
      { name: "Greek Gigantes Beans", desc: "Giant white beans for baked Greek goodness.", african: false },
      { name: "Turkish Dolma Leaves", desc: "Grape leaves for stuffing. Mediterranean essential!", african: false },
      { name: "Lebanese Zaatar Mix", desc: "Wild thyme blend ingredients. Middle Eastern aroma!", african: false },
      { name: "Israeli Couscous", desc: "Pearl pasta, technically! Toasty, chewy, versatile.", african: false },
      { name: "Australian Finger Eggplants", desc: "Slender purple beauties. Perfect for grilling whole.", african: false },
      { name: "New Zealand Kumara", desc: "Maori sweet potatoes! Orange, creamy, delicious.", african: false },
      { name: "Canadian Fiddleheads", desc: "Wild fern shoots! Seasonal forest delicacy.", african: false },
      { name: "American Hot Peppers Mix", desc: "Ghost pepper to jalapeño range. Heat seekers welcome!", african: false },
      { name: "Brazilian Hearts of Palm", desc: "Sustainable palmito! Delicate, crunchy, sophisticated.", african: false },
      { name: "Argentine White Asparagus", desc: "Prized pale spears grown underground. Delicate luxury!", african: false },
      { name: "Chilean Giant Artichokes", desc: "Mediterranean vegetable thriving in Chile. Leaf by leaf heaven.", african: false },
      { name: "Colombian Arracacha", desc: "Andean root vegetable. Celery-carrot-chestnut flavor!", african: false },
      { name: "Ecuadorian Chayote", desc: "Mild squash for Latin cooking. Versatile and refreshing.", african: false },
      { name: "Guatemalan Loroco Flowers", desc: "Edible flower buds for pupusas. Unique floral flavor!", african: false },
      { name: "Costa Rican Palmito", desc: "Fresh heart of palm. Rare and delicate.", african: false },
      { name: "Panamanian Otoe", desc: "Starchy root like taro. Creamy when cooked.", african: false },
      { name: "Jamaican Callaloo", desc: "Leafy greens for national breakfast. Caribbean soul food!", african: false },
      { name: "Trinidadian Christophene", desc: "Chayote squash Caribbean-style. Cool and crunchy.", african: false },
      { name: "Haitian Breadfruit", desc: "Starchy tree fruit. Roast, fry, or boil – always good!", african: false },
      { name: "Dominican Yautía", desc: "Taro-like tuber for mangú. Breakfast staple!", african: false },
      { name: "Cuban Malanga", desc: "Root vegetable for traditional soups. Earthy goodness!", african: false },
      { name: "Puerto Rican Recao", desc: "Culantro! Stronger than cilantro, essential for sofrito.", african: false }
    ]

    # GRAINS (60 products)
    grains = [
      # African Grains
      { name: "Ethiopian Teff Grain", desc: "Ancient supergrain! Gluten-free, iron-rich, injera perfection.", african: true },
      { name: "Nigerian Ofada Rice", desc: "Aromatic local rice with earthy flavor. Premium indigenous variety!", african: true },
      { name: "Ghanaian Brown Rice", desc: "Whole grain goodness from Ghana's paddies. Nutritious and filling.", african: true },
      { name: "Senegalese Broken Rice", desc: "Thieboudienne essential! Traditional for Senegal's national dish.", african: true },
      { name: "Malian Millet Gold", desc: "Pearl millet for porridge and couscous. Sahel's ancient grain.", african: true },
      { name: "Burkina Faso Sorghum", desc: "Drought-resistant supergrain. Red variety for brewing and porridge.", african: true },
      { name: "Kenyan Finger Millet", desc: "Wimbi! Nutritious grain for uji porridge. Iron powerhouse!", african: true },
      { name: "Nigerian Acha (Fonio)", desc: "World's fastest cooking grain! Nutty, ancient, nutritious.", african: true },
      { name: "Cameroon Corn Meal", desc: "Maize flour for fufu corn. Golden and satisfying.", african: true },
      { name: "South African Samp", desc: "Dried corn kernels for umngqusho. Mandela's favorite dish!", african: true },
      { name: "Ugandan Millet Flour", desc: "Bulo flour for traditional porridge. Fermented flavor!", african: true },
      { name: "Tanzanian Sembe", desc: "Maize meal for ugali. East African staple starch.", african: true },
      { name: "Zambian Mealie Meal", desc: "Roller mill maize for nshima. Smooth and silky.", african: true },
      { name: "Zimbabwe Sadza Flour", desc: "Fine maize meal for the perfect sadza. Daily bread!", african: true },
      { name: "Mozambique Xima Flour", desc: "Maize flour for Mozambican staple. Portuguese influence!", african: true },
      { name: "Malawian Nsima Flour", desc: "Traditional maize preparation. Warm Lake nation comfort.", african: true },
      { name: "Egyptian Freekeh", desc: "Roasted green wheat! Smoky, chewy, protein-packed.", african: true },
      { name: "Moroccan Couscous", desc: "Hand-rolled semolina pearls. Friday feast essential!", african: true },
      { name: "Tunisian Barley", desc: "Ancient Mediterranean grain. Hearty soups and salads.", african: true },
      { name: "Algerian Semolina", desc: "Durum wheat for bread and sweets. Golden granules.", african: true },
      { name: "Nigerian Guinea Corn", desc: "Sorghum variety for pap and burukutu. Traditional brew base!", african: true },
      { name: "Ghanaian Tom Brown Mix", desc: "Roasted corn-based weaning food. Childhood nostalgia!", african: true },
      { name: "Ivorian Attieke Base", desc: "Fermented cassava couscous. Côte d'Ivoire's gift!", african: true },
      { name: "Beninese Gari", desc: "Fermented cassava granules. Eba and gari soakings!", african: true },
      { name: "Togolese Akume Flour", desc: "Fermented corn dough starter. Tangy traditional taste.", african: true },
      { name: "Niger Millet Couscous", desc: "Traditional hand-rolled millet. Desert hospitality grain.", african: true },
      # World Grains
      { name: "Italian Arborio Rice", desc: "Risotto perfection! Creamy, starchy, slow-release energy.", african: false },
      { name: "Japanese Sushi Rice", desc: "Short grain perfection for nigiri and maki. Sticky and sweet.", african: false },
      { name: "Thai Jasmine Rice", desc: "Fragrant long grain! Floral aroma fills the kitchen.", african: false },
      { name: "Indian Basmati Premium", desc: "The prince of rice! Aged, aromatic, elongates when cooked.", african: false },
      { name: "Spanish Bomba Rice", desc: "Paella essential! Absorbs flavors, stays firm.", african: false },
      { name: "American Wild Rice", desc: "Not actually rice! Aquatic grass with nutty flavor.", african: false },
      { name: "Canadian Oats Steel-Cut", desc: "Irish-style oats for hearty porridge. Morning fuel!", african: false },
      { name: "Scottish Oatmeal", desc: "Stone-ground tradition for proper porridge.", african: false },
      { name: "German Spelt", desc: "Ancient wheat variety. Nutty, nutritious, digestible.", african: false },
      { name: "Polish Buckwheat", desc: "Kasha! Toasted and earthy. Gluten-free despite the name!", african: false },
      { name: "Russian Kasha", desc: "Roasted buckwheat groats. Eastern European comfort.", african: false },
      { name: "Turkish Bulgur", desc: "Cracked wheat for tabbouleh and pilafs. Quick-cooking goodness.", african: false },
      { name: "Lebanese Freekeh", desc: "Smoky immature wheat. Ancient Levantine treasure.", african: false },
      { name: "Israeli Pearl Barley", desc: "Polished barley for cholent and soups. Chewy satisfaction.", african: false },
      { name: "Greek Orzo", desc: "Rice-shaped pasta for Mediterranean dishes.", african: false },
      { name: "French Wheat Berries", desc: "Whole wheat kernels. Chewy salad addition!", african: false },
      { name: "Dutch Rye", desc: "Dark bread grain. Dense, nutritious, satisfying.", african: false },
      { name: "Swedish Crispbread Rye", desc: "For perfect knäckebröd. Light and crunchy.", african: false },
      { name: "Norwegian Barley Flour", desc: "Traditional Scandinavian baking grain.", african: false },
      { name: "Finnish Oat Groats", desc: "Whole oats for porridge and baking. Pure energy!", african: false },
      { name: "Peruvian Quinoa Rainbow", desc: "Complete protein ancient grain! Red, white, and black mix.", african: false },
      { name: "Bolivian Royal Quinoa", desc: "Largest quinoa variety. Fluffy and nutty.", african: false },
      { name: "Mexican Blue Corn", desc: "Antioxidant-rich colored corn. Tortilla dreams!", african: false },
      { name: "Colombian Arepa Flour", desc: "Pre-cooked corn for Venezuelan and Colombian arepas.", african: false },
      { name: "Brazilian Corn Grits", desc: "For angu and polenta-style dishes.", african: false },
      { name: "Chinese Black Rice", desc: "Forbidden rice! Purple-black, antioxidant-rich.", african: false },
      { name: "Vietnamese Red Rice", desc: "Unpolished cargo rice. Nutty and nutritious.", african: false },
      { name: "Korean Mixed Grains", desc: "Multigrain rice mix for bibimbap. Healthy variety!", african: false },
      { name: "Philippine Purple Yam Rice", desc: "Ube-infused rice! Purple and sweet.", african: false }
    ]

    # HERBS (60 products)
    herbs = [
      # African Herbs
      { name: "Nigerian Scent Leaves", desc: "Nchuanwu! Aromatic herb essential for pepper soup. Unmistakable!", african: true },
      { name: "Nigerian Utazi Leaves", desc: "Bittersweet herb for abacha and isiewu. Distinctive flavor!", african: true },
      { name: "Ghanaian Prekese", desc: "Aidan fruit pods! Aromatic spice with medicinal powers.", african: true },
      { name: "Ethiopian Sacred Basil", desc: "Besobila! Holy basil for berbere spice blend.", african: true },
      { name: "Nigerian Uziza Seeds", desc: "West African pepper with numbing, spicy kick!", african: true },
      { name: "Cameroonian Njangsa Seeds", desc: "Wild mango seeds for yellow soup. Thickening wonder!", african: true },
      { name: "Nigerian Ogiri", desc: "Fermented locust beans. Intense umami for soups!", african: true },
      { name: "Kenyan Lemongrass", desc: "Cymbopogon from Kenya highlands. Tea and cooking essential.", african: true },
      { name: "Moroccan Mint", desc: "Nana mint for the famous tea! Spearmint perfection.", african: true },
      { name: "Egyptian Dill", desc: "Shibbit for molokhia! Feathery and fragrant.", african: true },
      { name: "Tunisian Caraway Seeds", desc: "For harissa and bread. Earthy, slightly anise.", african: true },
      { name: "Algerian Ras el Hanout", desc: "30+ spice blend! North African complexity in one jar.", african: true },
      { name: "South African Rooibos", desc: "Red bush tea! Caffeine-free, antioxidant-rich.", african: true },
      { name: "Cape Town Buchu", desc: "Indigenous medicinal herb. Mint-camphor aroma.", african: true },
      { name: "Nigerian Dawadawa", desc: "Fermented locust bean cakes. African miso!", african: true },
      { name: "Ghanaian Grains of Paradise", desc: "Melegueta pepper! Peppery, cardamom notes. Medieval spice!", african: true },
      { name: "Ethiopian Korerima", desc: "False cardamom! Essential for berbere spice.", african: true },
      { name: "Somali Frankincense", desc: "Boswellia resin for incense and medicine. Sacred!", african: true },
      { name: "Zanzibar Cloves", desc: "Spice island treasure! Intense, warming, essential.", african: true },
      { name: "Malagasy Vanilla Beans", desc: "World's finest vanilla! Bourbon vanilla perfection.", african: true },
      { name: "Malagasy Pink Pepper", desc: "Not true pepper! Delicate, fruity, beautiful.", african: true },
      { name: "Nigerian Cameroon Pepper", desc: "Black pepper's intense African cousin. Serious heat!", african: true },
      { name: "Congolese Pili Pili", desc: "Bird's eye chillies. Small but mighty!", african: true },
      { name: "Rwandan Coffee Leaves", desc: "Tea from coffee plant! Smooth, caffeinated, unique.", african: true },
      { name: "Burkina Soumbala", desc: "Fermented néré seeds. Deep savory flavor!", african: true },
      # World Herbs
      { name: "Thai Lemongrass", desc: "Tom yum essential! Citrusy, aromatic, refreshing.", african: false },
      { name: "Vietnamese Coriander", desc: "Rau ram! Spicier than regular cilantro.", african: false },
      { name: "Indian Garam Masala", desc: "Warming spice blend. Cinnamon, cardamom, clove magic!", african: false },
      { name: "Chinese Five Spice", desc: "Star anise, cloves, cinnamon, pepper, fennel. Balance!", african: false },
      { name: "Japanese Shiso Leaves", desc: "Perilla herb! Minty, basil-like, uniquely Japanese.", african: false },
      { name: "Korean Perilla Leaves", desc: "Sesame leaves for BBQ wrapping. Vegetal and nutty.", african: false },
      { name: "Mexican Epazote", desc: "Pungent herb for black beans. Love it or hate it!", african: false },
      { name: "Peruvian Huacatay", desc: "Black mint! Essential for Peruvian green sauce.", african: false },
      { name: "Italian Basil Genovese", desc: "Pesto perfection! Sweet, aromatic, essential.", african: false },
      { name: "French Herbes de Provence", desc: "Lavender, thyme, rosemary blend. Provençal magic!", african: false },
      { name: "Spanish Saffron Threads", desc: "Red gold! World's most expensive spice. Worth every penny.", african: false },
      { name: "Greek Oregano", desc: "More intense than Italian! Pizza and lamb essential.", african: false },
      { name: "Turkish Sumac", desc: "Tangy red spice! Citrusy without the liquid.", african: false },
      { name: "Lebanese Za'atar Blend", desc: "Thyme, sesame, sumac. Middle Eastern breakfast staple!", african: false },
      { name: "Iranian Dried Limes", desc: "Loomi! Tangy, earthy, essential for Persian stews.", african: false },
      { name: "UK Lavender Culinary", desc: "English lavender for baking. Floral sophistication!", african: false },
      { name: "British Sage", desc: "Stuffing essential! Earthy, slightly camphor notes.", african: false },
      { name: "American Bay Leaves", desc: "California bay. More intense than Turkish!", african: false },
      { name: "Canadian Juniper Berries", desc: "Gin botanicals! Pine-citrus for game meats.", african: false },
      { name: "Swedish Dill", desc: "Gravlax essential! Feathery anise-like freshness.", african: false },
      { name: "Hungarian Paprika", desc: "Sweet or hot! Deep red, essential for goulash.", african: false },
      { name: "Czech Caraway", desc: "Rye bread and sauerkraut spice. Eastern European signature.", african: false },
      { name: "Austrian Poppy Seeds", desc: "Blue-grey seeds for baking. Nutty crunch!", african: false },
      { name: "Russian Horseradish", desc: "Nasal-clearing heat! Roast beef's best friend.", african: false },
      { name: "Ukrainian Dill Seeds", desc: "For pickling and borscht. Anise undertones.", african: false },
      { name: "Georgian Khmeli Suneli", desc: "Blue fenugreek blend! Unique Georgian aroma.", african: false },
      { name: "Sri Lankan Cinnamon", desc: "True Ceylon cinnamon! Delicate, sweet, superior.", african: false },
      { name: "Indonesian Nutmeg", desc: "Banda Islands' treasure! Warm, sweet, essential.", african: false },
      { name: "Malaysian Pandan Leaves", desc: "Asian vanilla! Fragrant leaves for rice and desserts.", african: false },
      { name: "Filipino Calamansi Leaves", desc: "Citrus leaves for Filipino aroma!", african: false }
    ]

    # NUTS (50 products)
    nuts = [
      # African Nuts
      { name: "Nigerian Groundnuts", desc: "Roasted peanuts! Perfect for kulikuli and groundnut soup.", african: true },
      { name: "Ghanaian Tiger Nuts", desc: "Sweet tuber-nuts for refreshing tiger nut drink!", african: true },
      { name: "Mozambique Cashews Raw", desc: "Premium cashews from world's top producer. Creamy and sweet!", african: true },
      { name: "Kenyan Macadamia Nuts", desc: "Hawaii's rival! Buttery, crunchy, irresistible.", african: true },
      { name: "Nigerian Palm Kernel Nuts", desc: "For palm kernel oil. Traditional skincare ingredient!", african: true },
      { name: "South African Marula Nuts", desc: "Inside the famous fruit! Protein-packed, delicate.", african: true },
      { name: "Cameroon Palm Nuts", desc: "Fresh banga nuts for palm fruit soup. Orange gold!", african: true },
      { name: "Nigerian Egusi Seeds", desc: "Melon seeds for soup! Thickening, nutritious, essential.", african: true },
      { name: "Burkina Faso Shea Nuts", desc: "For shea butter! Cosmetic and culinary gold.", african: true },
      { name: "Mali Bambara Groundnuts", desc: "Underground beans! Balanced nutrition, great roasted.", african: true },
      { name: "Ethiopian Niger Seeds", desc: "Black seeds for noog oil. Nutty Ethiopian classic!", african: true },
      { name: "Zambian Mongongo Nuts", desc: "San people's staple! Protein-rich survival food.", african: true },
      { name: "Namibian Manketti Nuts", desc: "Drought-resistant nutrition! Desert treasure.", african: true },
      { name: "Botswana Kgengwe Seeds", desc: "Wild melon seeds. Traditional San food!", african: true },
      { name: "Malawian Groundnut Flour", desc: "Peanut powder for thickening. Nsima companion!", african: true },
      { name: "Congolese Pumpkin Seeds", desc: "Pepitas African-style! Crunchy protein snack.", african: true },
      { name: "Tunisian Pine Nuts", desc: "Mediterranean treasure! Pesto and couscous garnish.", african: true },
      { name: "Moroccan Argan Nuts", desc: "For precious argan oil! Culinary and cosmetic.", african: true },
      { name: "Egyptian Watermelon Seeds", desc: "Roasted seeds, popular snack! Salty and satisfying.", african: true },
      # World Nuts
      { name: "California Almonds", desc: "World's most popular nut! Versatile and nutritious.", african: false },
      { name: "Italian Pine Nuts", desc: "Pignoli for pesto! Sweet, buttery, essential.", african: false },
      { name: "Spanish Marcona Almonds", desc: "The queen of almonds! Flat, buttery, superior.", african: false },
      { name: "Turkish Hazelnuts", desc: "Nutella's secret! 70% of world supply.", african: false },
      { name: "Iranian Pistachios", desc: "Green gold of Persia! Sweet, salty perfection.", african: false },
      { name: "American Pecans", desc: "Buttery Southern beauties. Pie and praline essential!", african: false },
      { name: "Hawaiian Macadamias", desc: "Volcanic soil magic! World's creamiest nut.", african: false },
      { name: "Brazilian Brazil Nuts", desc: "Selenium powerhouse! One nut = daily requirement.", african: false },
      { name: "Vietnamese Cashews", desc: "Perfectly processed! Whole grades available.", african: false },
      { name: "Indian Cashews", desc: "Crescent-shaped treasure. Curry essential!", african: false },
      { name: "Chinese Chestnuts", desc: "Winter warmers! Sweet when roasted.", african: false },
      { name: "European Walnuts", desc: "Brain-shaped brain food! Omega-3 rich.", african: false },
      { name: "Japanese Ginkgo Nuts", desc: "Temple tree seeds! Unique savory-sweet.", african: false },
      { name: "Korean Pine Nuts", desc: "Asian variety! Larger and more resinous.", african: false },
      { name: "Australian Bunya Nuts", desc: "Indigenous giant seeds! Chestnut flavor.", african: false },
      { name: "Mexican Peanuts", desc: "Jumbo variety! Great for mole sauces.", african: false },
      { name: "Argentinian Peanuts", desc: "Premium quality for peanut butter.", african: false },
      { name: "Greek Pistachios", desc: "Aegina variety! Smaller but more flavorful.", african: false },
      { name: "Georgian Walnuts", desc: "For satsivi walnut sauce! Georgian essential.", african: false },
      { name: "Lebanese Mixed Nuts", desc: "Roasted blend for mezze! Party essential.", african: false },
      { name: "Dutch Coconut Flakes", desc: "Dried and shredded. Baking essential!", african: false },
      { name: "Thai Coconut Cream", desc: "First press coconut! Rich and creamy.", african: false }
    ]

    # DAIRY (50 products)
    dairy = [
      # African Dairy
      { name: "Nigerian Wara Cheese", desc: "West African cottage cheese! Soft, mild, versatile.", african: true },
      { name: "Kenyan Mursik", desc: "Fermented milk in calabash! Maasai tradition.", african: true },
      { name: "Ethiopian Ayib", desc: "Fresh cheese similar to cottage! Injera companion.", african: true },
      { name: "South African Amasi", desc: "Fermented buttermilk! Creamy, tangy, probiotic.", african: true },
      { name: "Maasai Blood Milk", desc: "Traditional warrior drink! High protein, iron-rich.", african: true },
      { name: "Nigerian Fura de Nono", desc: "Millet balls with fermented milk! Street food treasure.", african: true },
      { name: "Fulani Fresh Milk (Nono)", desc: "Traditional fermented milk from nomadic herders.", african: true },
      { name: "Egyptian Laban", desc: "Middle Eastern buttermilk! Refreshing and digestive.", african: true },
      { name: "Moroccan Raib", desc: "Thick fermented milk for couscous.", african: true },
      { name: "Tunisian Leben", desc: "Cultured buttermilk! Cool and tangy.", african: true },
      { name: "Sudanese Karkaday Yogurt", desc: "Hibiscus-infused fermented milk! Pink and tangy.", african: true },
      { name: "Ugandan Ghee", desc: "Clarified butter East African style. Cooking gold!", african: true },
      { name: "Ethiopian Niter Kibbeh", desc: "Spiced clarified butter! Flavored with korerima and bishop's weed.", african: true },
      { name: "Zambian Lacto Drink", desc: "Commercial fermented milk. Modern mursik!", african: true },
      { name: "Nigerian Peak Milk Style", desc: "Evaporated milk for tea and pap. Breakfast essential!", african: true },
      # World Dairy
      { name: "Greek Feta Cheese", desc: "Briny sheep's milk block! Salad and pastry essential.", african: false },
      { name: "French Camembert", desc: "Creamy, bloomy rind! Napoleon's favorite cheese.", african: false },
      { name: "Italian Parmigiano-Reggiano", desc: "King of cheese! 24-month aged perfection.", african: false },
      { name: "Dutch Gouda", desc: "Sweet, crystalline aged cheese. Dutch pride!", african: false },
      { name: "Swiss Gruyère", desc: "Fondue essential! Nutty, complex, melts perfectly.", african: false },
      { name: "Spanish Manchego", desc: "Sheep's milk masterpiece! Aged for depth.", african: false },
      { name: "British Cheddar", desc: "Sharp, crumbly, iconic! The world's favorite.", african: false },
      { name: "Irish Butter", desc: "Grass-fed gold! Kerrygold quality.", african: false },
      { name: "French Crème Fraîche", desc: "Cultured cream! Tangy and luxurious.", african: false },
      { name: "Greek Yogurt", desc: "Strained, thick, protein-packed! Breakfast revolution.", african: false },
      { name: "Turkish Labneh", desc: "Strained yogurt cheese! Creamy spreadable delight.", african: false },
      { name: "Indian Paneer", desc: "Fresh cheese that doesn't melt! Curry essential.", african: false },
      { name: "Indian Ghee", desc: "Clarified butter for high-heat cooking. Ayurvedic gold!", african: false },
      { name: "Italian Mascarpone", desc: "Triple cream cheese! Tiramisu essential.", african: false },
      { name: "Italian Ricotta", desc: "Whey cheese! Light and versatile.", african: false },
      { name: "Italian Burrata", desc: "Mozzarella stuffed with cream! Instagram famous.", african: false },
      { name: "Danish Blue Cheese", desc: "Sharp, tangy blue mold! Bold flavor.", african: false },
      { name: "British Stilton", desc: "Christmas cheese tradition! Complex blue.", african: false },
      { name: "French Roquefort", desc: "Cave-aged sheep's milk blue! Intense and salty.", african: false },
      { name: "Norwegian Brunost", desc: "Brown cheese! Caramelized whey, sweet-savory.", african: false },
      { name: "Icelandic Skyr", desc: "Viking yogurt! Thick, tangy, protein-rich.", african: false },
      { name: "German Quark", desc: "Fresh cheese between yogurt and cottage. Cheesecake base!", african: false },
      { name: "Polish Twaróg", desc: "Farmer's cheese! Pierogi filling classic.", african: false },
      { name: "Mexican Queso Fresco", desc: "Fresh crumbly cheese! Taco essential.", african: false },
      { name: "Venezuelan Queso de Mano", desc: "Hand-stretched fresh cheese! Arepa topper.", african: false },
      { name: "Japanese Cream Cheese", desc: "Ultra-smooth for cheesecake! Soft and mild.", african: false }
    ]

    # MEAT (50 products)
    meat = [
      # African Meat
      { name: "Nigerian Suya Strips", desc: "Pre-spiced beef for grilling! Yaji magic included.", african: true },
      { name: "South African Biltong", desc: "Air-dried cured meat! Better than jerky.", african: true },
      { name: "South African Droëwors", desc: "Dried sausage! Coriander-spiced perfection.", african: true },
      { name: "Nigerian Kilishi", desc: "Hausa-style jerky! Thin, spicy, irresistible.", african: true },
      { name: "Nigerian Ponmo", desc: "Cow skin! Gelatinous texture, soup essential.", african: true },
      { name: "Nigerian Shaki (Tripe)", desc: "Cow intestine for pepper soup! Chewy delicacy.", african: true },
      { name: "Ethiopian Kitfo Mince", desc: "Beef tartare cuts! For raw or rare eating.", african: true },
      { name: "Moroccan Lamb Shoulder", desc: "Tagine-ready! Fall-off-bone tenderness.", african: true },
      { name: "Egyptian Kofta Mince", desc: "Spiced lamb for kebabs! Middle Eastern-African fusion.", african: true },
      { name: "Kenyan Nyama Choma Cuts", desc: "Goat for roasting! BBQ essential.", african: true },
      { name: "Nigerian Goat Meat", desc: "For authentic pepper soup! Lean and flavorful.", african: true },
      { name: "Ghanaian Bush Meat", desc: "Traditional game meats! Wild and sustainable.", african: true },
      { name: "South African Boerewors", desc: "Coiled farmer's sausage! Braai essential!", african: true },
      { name: "Nigerian Snail Meat", desc: "Giant African snails! Delicacy for pepper soup.", african: true },
      { name: "Cameroon Smoked Fish", desc: "Crayfish-stockfish combo! Soup flavor base.", african: true },
      { name: "Nigerian Stockfish", desc: "Air-dried cod! Essential for Nigerian soups.", african: true },
      { name: "Nigerian Dried Prawns", desc: "Crayfish! Umami powder for soups.", african: true },
      { name: "Senegalese Thiof", desc: "Nile perch for thieboudienne! National dish fish.", african: true },
      # World Meat
      { name: "Australian Wagyu Beef", desc: "Marbled perfection! Melt-in-mouth luxury.", african: false },
      { name: "Japanese A5 Wagyu", desc: "Ultimate beef! Snowflake marbling, pure bliss.", african: false },
      { name: "American Prime Ribeye", desc: "Classic steakhouse cut! Rich and juicy.", african: false },
      { name: "Argentine Grass-Fed Beef", desc: "Pampas-raised perfection! Lean and flavorful.", african: false },
      { name: "Spanish Ibérico Pork", desc: "Acorn-fed pigs! Ham destined for curing.", african: false },
      { name: "Italian Prosciutto", desc: "Dry-cured ham! 18-month aged elegance.", african: false },
      { name: "French Duck Confit", desc: "Preserved in own fat! Crispy skin, tender meat.", african: false },
      { name: "British Lamb Leg", desc: "Spring lamb! Sweet and succulent.", african: false },
      { name: "New Zealand Lamb Rack", desc: "French-trimmed elegance! Herb-crusted perfection.", african: false },
      { name: "Irish Lamb Chops", desc: "Grass-fed flavor! Perfect for grilling.", african: false },
      { name: "German Bratwurst", desc: "Grill sausage! Beer garden essential.", african: false },
      { name: "Polish Kielbasa", desc: "Smoked sausage! Garlic and marjoram.", african: false },
      { name: "Hungarian Kolbász", desc: "Paprika sausage! Smoky and spiced.", african: false },
      { name: "Mexican Chorizo", desc: "Fresh spicy sausage! Taco filling dream.", african: false },
      { name: "Thai Chicken Wings", desc: "Free-range premium! Ready for larb or curry.", african: false },
      { name: "Korean BBQ Beef", desc: "Pre-sliced for bulgogi! Marinate and grill.", african: false },
      { name: "Vietnamese Pork Belly", desc: "Five-spice ready! Thit kho caramelization.", african: false },
      { name: "Chinese Peking Duck", desc: "Whole duck for roasting! Crispy skin ritual.", african: false },
      { name: "Indian Tandoori Chicken", desc: "Jointed and ready! Yogurt-marinate and roast.", african: false },
      { name: "Turkish Lamb Kebab", desc: "Ground lamb for shish! Flame-grilled perfection.", african: false },
      { name: "Greek Lamb Souvlaki", desc: "Cubed for skewers! Oregano and lemon.", african: false },
      { name: "Canadian Bacon", desc: "Back bacon! Leaner than American strips.", african: false },
      { name: "Norwegian Salmon", desc: "Cold-water perfection! Omega-3 rich.", african: false },
      { name: "Scottish Smoked Salmon", desc: "Cold-smoked tradition! Silky and saline.", african: false }
    ]

    # OTHER (50 products)
    other = [
      # African Other
      { name: "Nigerian Palm Oil", desc: "Red gold of Africa! Essential for jollof and soups.", african: true },
      { name: "Ghanaian Shea Butter", desc: "Unrefined for cooking and skin! Multi-purpose gold.", african: true },
      { name: "Nigerian Groundnut Oil", desc: "Peanut oil for frying! High smoke point.", african: true },
      { name: "Moroccan Argan Oil", desc: "Culinary liquid gold! Nutty drizzling oil.", african: true },
      { name: "Egyptian Black Seed Oil", desc: "Nigella sativa! The cure for everything but death.", african: true },
      { name: "Ethiopian Coffee Beans", desc: "Birthplace of coffee! Yirgacheffe single origin.", african: true },
      { name: "Kenyan AA Coffee", desc: "Bright, wine-like acidity! High-altitude beans.", african: true },
      { name: "Rwandan Coffee Premium", desc: "Thousand hills flavor! Recovery story in a cup.", african: true },
      { name: "Nigerian Zobo Mix", desc: "Hibiscus, ginger, cloves for zobo drink!", african: true },
      { name: "Ghanaian Cocoa Powder", desc: "From the cocoa belt! Rich baking essential.", african: true },
      { name: "Ivorian Cocoa Beans", desc: "World's top producer! Bean-to-bar ready.", african: true },
      { name: "Nigerian Honey Raw", desc: "Bush honey! Unprocessed, antibacterial.", african: true },
      { name: "Ethiopian Tej Honey", desc: "For honey wine! Fermenting-grade sweetness.", african: true },
      { name: "South African Honeybush", desc: "Caffeine-free tea alternative! Sweet and mild.", african: true },
      { name: "Senegalese Bissap Flowers", desc: "Dried hibiscus for juice! Ruby red refreshment.", african: true },
      { name: "Nigerian Kuli Kuli", desc: "Groundnut cakes! Protein-packed snack.", african: true },
      { name: "Ghanaian Kelewele Spice", desc: "Pre-mixed for fried plantains! Ginger-pepper magic.", african: true },
      { name: "Nigerian Suya Spice (Yaji)", desc: "Groundnut-based BBQ rub! Smoky, spicy perfection.", african: true },
      { name: "Ethiopian Berbere Spice", desc: "Signature red blend! 20+ spices in one.", african: true },
      { name: "Moroccan Ras el Hanout", desc: "Head of the shop blend! 30+ luxurious spices.", african: true },
      { name: "Tunisian Harissa Paste", desc: "Spicy chili paste! North African heat.", african: true },
      { name: "Nigerian Ogbono Seeds", desc: "Wild mango seeds! Thickening and nutritious.", african: true },
      { name: "Nigerian Crayfish Powder", desc: "Ground dried prawns! Umami essential.", african: true },
      { name: "Ghanaian Waakye Leaves", desc: "Sorghum leaves for rice coloring! Pink magic.", african: true },
      { name: "Nigerian Potash (Kaun)", desc: "Traditional tenderizer! For beans and vegetables.", african: true },
      # World Other
      { name: "Japanese Miso Paste", desc: "Fermented soybean! Umami breakfast soup.", african: false },
      { name: "Korean Gochujang", desc: "Fermented chili paste! Sweet-spicy-savory.", african: false },
      { name: "Thai Fish Sauce", desc: "Liquid umami! Southeast Asian essential.", african: false },
      { name: "Vietnamese Sriracha", desc: "Rooster sauce! Chili-garlic perfection.", african: false },
      { name: "Chinese Soy Sauce", desc: "Fermented classic! Light or dark.", african: false },
      { name: "Japanese Toasted Sesame Oil", desc: "Nutty finishing oil! A little goes far.", african: false },
      { name: "Indian Mango Chutney", desc: "Sweet-spicy condiment! Curry companion.", african: false },
      { name: "British Marmalade", desc: "Seville orange breakfast spread! Bittersweet tradition.", african: false },
      { name: "French Dijon Mustard", desc: "Smooth, sharp, essential! Not just for sandwiches.", african: false },
      { name: "Italian Balsamic Vinegar", desc: "Aged Modena treasure! Sweet-tart perfection.", african: false },
      { name: "Spanish Extra Virgin Olive Oil", desc: "Liquid gold! First cold press.", african: false },
      { name: "Greek Kalamata Olives", desc: "Purple-black brine beauties! Salad essential.", african: false },
      { name: "Turkish Pomegranate Molasses", desc: "Tangy sweet syrup! Middle Eastern depth.", african: false },
      { name: "Lebanese Tahini", desc: "Sesame seed paste! Hummus and halva base.", african: false },
      { name: "Mexican Hot Sauce", desc: "Aged pepper vinegar! Tangy heat.", african: false },
      { name: "American BBQ Sauce", desc: "Sweet, smoky, tangy! Grill essential.", african: false },
      { name: "Canadian Maple Syrup", desc: "Grade A amber! Pancake perfection.", african: false },
      { name: "New Zealand Manuka Honey", desc: "Medicinal-grade! Antibacterial gold.", african: false },
      { name: "Australian Vegemite", desc: "Love it or hate it! Yeast extract spread.", african: false },
      { name: "British Marmite", desc: "The original yeast extract! Savory umami.", african: false },
      { name: "Dutch Stroopwafel Syrup", desc: "Caramel waffle filling! Dutch indulgence.", african: false },
      { name: "Belgian Chocolate Couverture", desc: "Professional-grade! 70% cacao.", african: false },
      { name: "Swiss Chocolate Bars", desc: "Milk chocolate perfection! Alpine tradition.", african: false },
      { name: "Colombian Coffee Beans", desc: "Supremo grade! Balanced and smooth.", african: false },
      { name: "Brazilian Santos Coffee", desc: "Full-bodied, low acid! World's top producer.", african: false }
    ]

    categories = {
      'fruits' => fruits,
      'vegetables' => vegetables,
      'grains' => grains,
      'herbs' => herbs,
      'nuts' => nuts,
      'dairy' => dairy,
      'meat' => meat,
      'other' => other
    }

    created_count = 0
    
    categories.each do |category, products_list|
      products_list.each do |product_data|
        location = product_data[:african] ? african_locations.sample : world_locations.sample
        is_organic = [true, false, false].sample  # 33% organic
        is_featured = [true, false, false, false, false].sample  # 20% featured
        
        product = Product.new(
          name: product_data[:name],
          description: product_data[:desc],
          category: category,
          price: rand(1.50..25.00).round(2),
          stock_quantity: rand(10..200),
          unit: ['kg', 'lb', 'bunch', 'pack', 'piece', 'bottle', 'bag'].sample,
          location: location,
          is_organic: is_organic,
          featured: is_featured,
          harvest_date: Date.today - rand(1..30).days,
          user: supplier
        )
        
        if product.save(validate: false)
          created_count += 1
          print "." if created_count % 10 == 0
        else
          puts "\nFailed to create: #{product_data[:name]} - #{product.errors.full_messages.join(', ')}"
        end
      end
    end

    puts "\n\nSuccessfully created #{created_count} products!"
    puts "\nProducts by category:"
    categories.keys.each do |cat|
      count = Product.where(category: cat).count
      puts "  #{cat.capitalize}: #{count}"
    end
  end

  desc "Remove populated products (keeps seed products)"
  task clear_populated: :environment do
    count = Product.where("name LIKE '%African%' OR name LIKE '%Nigerian%' OR name LIKE '%Ghanaian%' OR name LIKE '%Ethiopian%' OR name LIKE '%Kenyan%' OR name LIKE '%Moroccan%' OR name LIKE '%Golden%' OR name LIKE '%Premium%' OR name LIKE '%Japanese%' OR name LIKE '%French%'").count
    Product.where("name LIKE '%African%' OR name LIKE '%Nigerian%' OR name LIKE '%Ghanaian%' OR name LIKE '%Ethiopian%' OR name LIKE '%Kenyan%' OR name LIKE '%Moroccan%' OR name LIKE '%Golden%' OR name LIKE '%Premium%' OR name LIKE '%Japanese%' OR name LIKE '%French%'").destroy_all
    puts "Removed #{count} populated products"
  end
end
