# EmbarkmentLTD Platform
## Comprehensive Web Application Architecture & Terminology Glossary

**Version:** 1.0  
**Last Updated:** March 2026  
**For:** Platform Users, Partners, and Stakeholders

---

## Table of Contents

1. [Platform Overview](#1-platform-overview)
2. [User Roles & Accounts](#2-user-roles--accounts)
3. [Product Catalog System](#3-product-catalog-system)
4. [Quotation Request (RFQ) System](#4-quotation-request-rfq-system)
5. [Order Management System](#5-order-management-system)
6. [Review & Rating System](#6-review--rating-system)
7. [Email Verification System](#7-email-verification-system)
8. [Support & Communication](#8-support--communication)
9. [Account Security & Sessions](#9-account-security--sessions)
10. [Navigation & Site Structure](#10-navigation--site-structure)
11. [Technical Terminology](#11-technical-terminology)
12. [Status Definitions](#12-status-definitions)
13. [Error Messages & Troubleshooting](#13-error-messages--troubleshooting)
14. [Data Privacy & Storage](#14-data-privacy--storage)
15. [Platform Architecture Overview](#15-platform-architecture-overview)

---

## 1. Platform Overview

### What is EmbarkmentLTD?

EmbarkmentLTD is a **Business-to-Business (B2B) Agricultural Food Marketplace** that connects agricultural producers, farmers, and food suppliers with buyers such as restaurants, retailers, distributors, and food service companies.

### Core Value Proposition

| Feature | Description |
|---------|-------------|
| **Quotation-Based Trading** | Request custom quotes for bulk orders instead of fixed checkout |
| **Verified Suppliers** | Trust system with email verification and quality ratings |
| **Quality Assurance** | Review system with supplier responses and admin oversight |
| **Direct Communication** | Built-in support chat for seamless communication |
| **Agricultural Focus** | Specialized for fresh produce, grains, dairy, meat, and more |

### Platform Mission

To facilitate trusted, efficient B2B transactions in the agricultural food sector by providing a verified marketplace where quality suppliers meet discerning buyers.

---

## 2. User Roles & Accounts

### 2.1 User Types

#### **Buyer**
A registered user who purchases or requests quotations for agricultural products.

| Capability | Description |
|------------|-------------|
| Browse Products | View all available products in the marketplace |
| Search & Filter | Find specific products using advanced search |
| Build Quotation Cart | Compile products for bulk quotation requests |
| Submit RFQs | Send formal requests for quotation to suppliers |
| Place Orders | Purchase products directly (after verification) |
| Write Reviews | Rate and review products after purchase |
| Chat with Support | Access customer support for assistance |

#### **Supplier (Seller)**
A registered user who lists and sells agricultural products.

| Capability | Description |
|------------|-------------|
| Create Products | List new products with images, pricing, and details |
| Manage Inventory | Update stock levels and product availability |
| Respond to RFQs | Review and respond to quotation requests |
| Process Orders | Confirm, ship, and fulfill customer orders |
| Respond to Reviews | Reply to customer feedback professionally |
| View Analytics | Access sales and product performance data |

#### **Administrator (Admin)**
Platform staff with full management access.

| Capability | Description |
|------------|-------------|
| User Management | Verify, suspend, or manage all user accounts |
| Product Oversight | Review and moderate product listings |
| Content Management | Edit platform pages (About, Mission, Contact) |
| Analytics Dashboard | View comprehensive platform metrics |
| Review Moderation | Flag or remove inappropriate reviews |
| System Configuration | Manage platform settings and policies |

#### **Support Staff**
Dedicated customer service representatives.

| Capability | Description |
|------------|-------------|
| Handle Inquiries | Respond to user questions via chat |
| Verification Assistance | Help users complete email verification |
| Dispute Resolution | Mediate between buyers and suppliers |

### 2.2 Account Terminology

| Term | Definition |
|------|------------|
| **Account** | Your unique profile on EmbarkmentLTD containing your personal information, preferences, and activity history |
| **Profile** | The public-facing page displaying your name, location, role, and (for suppliers) your product listings |
| **Serial Number** | A unique identifier automatically assigned to every user account (format: USR-XXXXX) |
| **Avatar** | Your profile picture or image that represents you on the platform |
| **Role** | Your designated function on the platform (Buyer, Supplier, Admin, or Support) |
| **Verified Account** | An account where the email address has been confirmed through the verification process |
| **Unverified Account** | An account pending email confirmation; limited functionality until verified |

### 2.3 Registration Process

1. **Sign Up**: Provide email, password, name, phone, location, and select role
2. **Email Validation**: System checks your email domain is legitimate (MX record verification)
3. **Verification Code**: 6-digit code sent to your email
4. **Account Activation**: Enter code to verify and unlock full platform access
5. **Profile Completion**: Add avatar and additional details

---

## 3. Product Catalog System

### 3.1 Product Categories

EmbarkmentLTD organizes products into **8 primary categories**:

| Category | Description | Examples |
|----------|-------------|----------|
| **Fruits** | Fresh and dried fruits | Mangoes, Apples, Bananas, Dates, Berries |
| **Vegetables** | Fresh produce and root vegetables | Tomatoes, Potatoes, Carrots, Peppers, Okra |
| **Grains** | Cereals, rice, and flour products | Rice, Wheat, Millet, Quinoa, Sorghum |
| **Herbs** | Spices, seasonings, and culinary herbs | Basil, Turmeric, Ginger, Cinnamon, Thyme |
| **Nuts** | Nuts and seeds | Cashews, Almonds, Peanuts, Walnuts |
| **Dairy** | Milk products and derivatives | Cheese, Milk, Yogurt, Butter, Cream |
| **Meat** | Animal protein products | Beef, Chicken, Lamb, Fish, Pork |
| **Other** | Specialty and miscellaneous items | Honey, Oils, Coffee, Chocolate, Sauces |

### 3.2 Product Attributes

Every product listing contains the following information:

| Attribute | Description |
|-----------|-------------|
| **Product Name** | Official name/title of the product |
| **Description** | Detailed explanation of the product, its origin, quality, and uses |
| **Category** | Classification bucket (one of the 8 categories) |
| **Price** | Cost per unit in GBP (£) |
| **Unit** | Measurement unit (kg, piece, dozen, case, pallet, etc.) |
| **Stock Quantity** | Number of units currently available |
| **Availability** | Whether the product is currently for sale |
| **Location** | Geographic origin or supplier's location |
| **Organic** | Certification flag indicating organic production |
| **Verified** | Trust badge indicating supplier verification |
| **Images** | Product photographs (minimum 1 required) |
| **Harvest Date** | When the product was harvested (for fresh items) |
| **Expiry Date** | Best-before or expiration date |
| **Serial Number** | Unique product identifier (format: PRD-XXXXX) |
| **Average Rating** | Aggregate customer rating (1-5 stars) |
| **Review Count** | Total number of customer reviews |

### 3.3 Product Discovery

| Feature | Description |
|---------|-------------|
| **Search Bar** | Text search across product names, descriptions, and locations |
| **Category Filter** | Filter by product category |
| **Organic Filter** | Show only certified organic products |
| **Stock Filter** | Show only in-stock items |
| **Price Range** | Filter by minimum and maximum price |
| **Location Filter** | Filter by supplier/product location |
| **Rating Filter** | Filter by minimum star rating |
| **Pagination** | Browse results in pages (12 products per page) |
| **Featured Products** | Highlighted products on homepage |
| **Category Collages** | Visual category navigation on homepage |

### 3.4 Product Page Elements

| Element | Description |
|---------|-------------|
| **Image Gallery** | Multiple product photos with zoom capability |
| **Price Display** | Current price per unit with currency |
| **Stock Indicator** | Visual indication of availability |
| **Add to Cart** | Button to add product to shopping cart |
| **Add to Quote** | Button to add product to quotation cart |
| **Supplier Info** | Link to supplier's profile and other products |
| **Reviews Section** | Customer feedback and ratings |
| **Related Products** | Similar items you might be interested in |

---

## 4. Quotation Request (RFQ) System

### 4.1 What is an RFQ?

A **Request for Quotation (RFQ)** is a formal document sent to suppliers asking for pricing and availability on specific products and quantities. This is the preferred method for bulk/wholesale purchases on EmbarkmentLTD.

### 4.2 RFQ Terminology

| Term | Definition |
|------|------------|
| **Quotation Cart** | A temporary collection of products you want to request quotes for |
| **Quotation Request** | The formal submission sent to suppliers with your requirements |
| **Quotation Item** | An individual product line within your quotation request |
| **RFQ Form** | The form where you enter delivery and contact details |
| **Request Status** | Current state of your quotation (Pending, Responded, Accepted, Rejected) |
| **Delivery Timeframe** | When you need the products delivered |
| **Special Requirements** | Custom specifications or handling instructions |
| **Request Method** | How you want to receive the quote (Email or WhatsApp) |

### 4.3 RFQ Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│                    QUOTATION REQUEST WORKFLOW                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. BROWSE        2. ADD TO         3. REVIEW         4. FILL  │
│  ─────────        QUOTE CART        ─────────         ────────  │
│  Find products    Click "Add to     View your         Complete  │
│  you need         Quote" button     selected items    RFQ form  │
│                                                                 │
│  5. SUBMIT        6. AWAIT          7. RECEIVE        8. ACCEPT │
│  ─────────        RESPONSE          QUOTE             OR REJECT │
│  Send RFQ to      Supplier          Get pricing       Proceed   │
│  supplier(s)      reviews request   & terms           to order  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 4.4 RFQ Form Fields

| Field | Required | Description |
|-------|----------|-------------|
| **Your Name** | Yes | Contact person for this request |
| **Email Address** | Yes | Where to send the quotation |
| **Phone Number** | Yes | For urgent communications |
| **Company Name** | No | Your business/organization name |
| **Street Address** | Yes | Delivery location address |
| **City** | Yes | Delivery city |
| **State/Province** | No | Delivery state or province |
| **ZIP/Postal Code** | Yes | Delivery postal code |
| **Country** | Yes | Delivery country |
| **Order Details** | No | Specific requirements for the order |
| **Special Requirements** | No | Handling, packaging, or quality needs |
| **Delivery Timeframe** | No | When you need the products |
| **Delivery Terms** | No | Preferred shipping/delivery arrangements |
| **Request Method** | Yes | Email or WhatsApp |

### 4.5 Quotation Cart vs Shopping Cart

| Quotation Cart | Shopping Cart |
|----------------|---------------|
| For bulk/wholesale inquiries | For direct purchases |
| Sends RFQ to suppliers | Proceeds to checkout |
| Price negotiable | Fixed pricing |
| No immediate payment | Payment required |
| Best for large orders | Best for smaller orders |
| Supplier responds with quote | Instant order placement |

---

## 5. Order Management System

### 5.1 Order Terminology

| Term | Definition |
|------|------------|
| **Order** | A confirmed purchase transaction between buyer and supplier |
| **Order ID** | Unique identifier for tracking purposes |
| **Order Item** | Individual product line within an order |
| **Order Status** | Current state in the fulfillment process |
| **Order Total** | Sum of all items including any applicable fees |
| **Unit Price** | Price per unit at time of order (locked in) |
| **Order History** | Complete record of all your past orders |
| **Cart** | Temporary holding area for products before checkout |

### 5.2 Order Status Flow

```
┌──────────┐    ┌───────────┐    ┌─────────┐    ┌───────────┐
│ PENDING  │───▶│ CONFIRMED │───▶│ SHIPPED │───▶│ DELIVERED │
└──────────┘    └───────────┘    └─────────┘    └───────────┘
     │                                               
     │          ┌───────────┐                        
     └─────────▶│ CANCELLED │                        
                └───────────┘                        
```

| Status | Description |
|--------|-------------|
| **Pending** | Order placed, awaiting supplier confirmation |
| **Confirmed** | Supplier has accepted and is preparing the order |
| **Shipped** | Order dispatched and in transit |
| **Delivered** | Order successfully received by buyer |
| **Cancelled** | Order cancelled by buyer or supplier |

### 5.3 Checkout Requirements

To complete an order, you must:

1. ✅ Have a registered account
2. ✅ Complete email verification
3. ✅ Have items in your shopping cart
4. ✅ Provide valid delivery information
5. ✅ Accept terms and conditions

### 5.4 Order Details

Each order record contains:

- Order ID and date
- Buyer and supplier information
- List of items with quantities and prices
- Delivery address
- Order status and history
- Total amount
- Any special instructions

---

## 6. Review & Rating System

### 6.1 Review Terminology

| Term | Definition |
|------|------------|
| **Review** | Written feedback about a product from a buyer |
| **Rating** | Star score from 1 to 5 indicating satisfaction |
| **Average Rating** | Mean of all ratings for a product |
| **Review Count** | Total number of reviews a product has received |
| **Supplier Response** | The supplier's reply to a customer review |
| **Flagged Review** | A review marked by admin for policy violation |

### 6.2 Rating Scale

| Stars | Meaning | Description |
|-------|---------|-------------|
| ⭐ (1) | Poor | Significant quality or service issues |
| ⭐⭐ (2) | Fair | Below expectations, some problems |
| ⭐⭐⭐ (3) | Average | Meets basic expectations |
| ⭐⭐⭐⭐ (4) | Good | Exceeds expectations, minor issues |
| ⭐⭐⭐⭐⭐ (5) | Excellent | Outstanding quality and service |

### 6.3 Review Guidelines

**Requirements:**
- Minimum 10 characters in review text
- One review per user per product
- Must have purchased the product
- Honest and factual content

**Prohibited Content:**
- Profanity or offensive language
- Personal attacks on suppliers
- False or misleading claims
- Promotional or spam content
- Disclosure of private information

### 6.4 Supplier Responses

Suppliers can respond to reviews to:
- Thank customers for positive feedback
- Address concerns professionally
- Explain circumstances
- Offer solutions or remedies

---

## 7. Email Verification System

### 7.1 Purpose

Email verification ensures:
- Authentic user identities
- Reduced spam and fraud
- Trusted marketplace transactions
- Reliable communication channels

### 7.2 Verification Terminology

| Term | Definition |
|------|------------|
| **Verification Code** | 6-digit numeric code sent to your email |
| **Verified Email** | An email address confirmed through code entry |
| **MX Record Check** | Technical validation of email domain legitimacy |
| **Verification Attempts** | Number of tries to enter the correct code (max 5) |
| **Code Expiry** | Time limit for code validity (1 hour) |
| **Resend Code** | Request a new verification code |

### 7.3 Verification Process

```
┌─────────────────────────────────────────────────────────────────┐
│                    EMAIL VERIFICATION FLOW                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. REGISTER      2. CODE SENT      3. CHECK EMAIL    4. ENTER │
│  ──────────       ─────────────     ────────────────  ──────── │
│  Create your      System sends      Open email from   Input    │
│  account          6-digit code      EmbarkmentLTD     6 digits │
│                                                                 │
│  5. VERIFIED      ← SUCCESS                                    │
│  ──────────                                                    │
│  Full access      Code accepted,    (If failed, you have       │
│  unlocked         account active    4 more attempts)           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 7.4 Access Comparison

| Feature | Unverified | Verified |
|---------|------------|----------|
| Browse products | ✅ | ✅ |
| Search and filter | ✅ | ✅ |
| View product details | ✅ | ✅ |
| Add to quotation cart | ✅ | ✅ |
| Submit quotation requests | ❌ | ✅ |
| Place orders | ❌ | ✅ |
| Write reviews | ❌ | ✅ |
| Chat with support | ❌ | ✅ |
| List products (suppliers) | ❌ | ✅ |

### 7.5 Verification Reminders

- System sends daily reminders to unverified accounts
- Reminders spaced 24 hours apart
- Contains new verification code
- Encourages account completion

---

## 8. Support & Communication

### 8.1 Support Chat System

| Term | Definition |
|------|------------|
| **Support Chat** | Real-time messaging with customer service |
| **Conversation** | A thread of messages between you and support |
| **Unread Count** | Number of new messages awaiting your attention |
| **Message Status** | Whether a message has been read |
| **Support Dashboard** | Interface for managing support conversations |

### 8.2 Accessing Support

1. Navigate to "Support" or "Help" in the menu
2. Start a new conversation or continue existing one
3. Type your message and send
4. Support staff will respond during business hours
5. Check back for responses (you'll see unread indicator)

### 8.3 Support Capabilities

Support staff can help with:
- Account verification issues
- Order problems or disputes
- Product listing questions
- Technical difficulties
- Policy clarifications
- General inquiries

### 8.4 Communication Best Practices

**Do:**
- Be clear and specific about your issue
- Provide relevant order/product IDs
- Include screenshots if helpful
- Be patient for responses
- Check back regularly

**Don't:**
- Share passwords or sensitive data
- Use offensive language
- Spam multiple messages
- Request actions outside staff authority

---

## 9. Account Security & Sessions

### 9.1 Security Terminology

| Term | Definition |
|------|------------|
| **Password** | Secret credential for account access |
| **Session** | Your active login period on the platform |
| **Session Timeout** | Automatic logout after inactivity (30 minutes) |
| **Remember Me** | Option to extend session duration |
| **Password Recovery** | Process to reset a forgotten password |
| **Account Lockout** | Temporary suspension after failed login attempts |

### 9.2 Session Management

```
┌─────────────────────────────────────────────────────────────────┐
│                    SESSION LIFECYCLE                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  LOGIN ──▶ ACTIVE SESSION ──▶ ACTIVITY ──▶ CONTINUE            │
│                   │                                             │
│                   ▼                                             │
│           30 MIN INACTIVITY                                     │
│                   │                                             │
│                   ▼                                             │
│           AUTOMATIC LOGOUT                                      │
│                   │                                             │
│                   ▼                                             │
│           REDIRECT TO LOGIN                                     │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 9.3 Security Features

| Feature | Description |
|---------|-------------|
| **Encrypted Passwords** | Passwords stored securely, never in plain text |
| **Session Timeout** | Auto-logout after 30 minutes of inactivity |
| **Secure Cookies** | Session data protected from tampering |
| **MX Validation** | Email domains verified for legitimacy |
| **Attempt Limits** | Protection against brute force attacks |

### 9.4 Password Requirements

- Minimum 6 characters
- Case-sensitive
- Special characters recommended
- Should not be easily guessable
- Unique to this platform

### 9.5 Account Recovery

If you forget your password:
1. Click "Forgot Password?" on login page
2. Enter your registered email address
3. Check email for reset instructions
4. Click the reset link
5. Create a new password
6. Log in with new credentials

---

## 10. Navigation & Site Structure

### 10.1 Public Pages

| Page | URL | Description |
|------|-----|-------------|
| **Homepage** | `/` | Platform landing, featured products, categories |
| **Products** | `/products` | Full product catalog with search/filters |
| **Product Detail** | `/products/:id` | Individual product page |
| **About Us** | `/about-us` | Company information |
| **Our Mission** | `/our-mission` | Platform mission and values |
| **Contact Us** | `/contact-us` | Contact information and form |
| **Sign In** | `/users/sign_in` | Login page |
| **Register** | `/users/sign_up` | Account creation |

### 10.2 Authenticated Pages

| Page | URL | Access | Description |
|------|-----|--------|-------------|
| **Profile** | `/profile` | All users | Your account profile |
| **Verify Email** | `/verify` | All users | Email verification page |
| **Orders** | `/orders` | Buyers | Order history |
| **Quotation Cart** | `/quotations/cart` | Buyers | RFQ cart |
| **My Products** | `/my_products` | Suppliers | Product management |
| **Support Chat** | `/support/dashboard` | All verified | Customer support |

### 10.3 Admin Pages

| Page | URL | Description |
|------|-----|-------------|
| **Dashboard** | `/admin/dashboard` | Analytics and overview |
| **Users** | `/admin/users` | User management |
| **Products** | `/admin/products` | Product oversight |
| **Orders** | `/admin/orders` | Order management |
| **Reviews** | `/admin/reviews` | Review moderation |
| **Quotations** | `/admin/quotation_requests` | RFQ management |
| **Pages** | `/admin/pages` | Content management |

### 10.4 Navigation Elements

| Element | Description |
|---------|-------------|
| **Header** | Top navigation bar with logo, menu, and account links |
| **Footer** | Bottom section with links, contact info, legal |
| **Sidebar** | Filter panel on product listing pages |
| **Breadcrumbs** | Navigation path showing current location |
| **Pagination** | Page navigation for large result sets |
| **Search Bar** | Text input for finding products |

---

## 11. Technical Terminology

### 11.1 General Terms

| Term | Definition |
|------|------------|
| **Platform** | The EmbarkmentLTD web application and services |
| **Dashboard** | Overview page showing key metrics and actions |
| **Marketplace** | The virtual space where buyers and suppliers trade |
| **Listing** | A product entry on the platform |
| **Catalog** | The complete collection of available products |

### 11.2 E-Commerce Terms

| Term | Definition |
|------|------------|
| **B2B** | Business-to-Business; transactions between companies |
| **RFQ** | Request for Quotation; formal price inquiry |
| **SKU** | Stock Keeping Unit; product identifier |
| **MOQ** | Minimum Order Quantity |
| **Lead Time** | Time between order and delivery |
| **Wholesale** | Bulk purchasing at discounted rates |

### 11.3 Web Application Terms

| Term | Definition |
|------|------------|
| **URL** | Web address (e.g., www.embarkment.co.uk/products) |
| **Form** | Input fields for entering data |
| **Button** | Clickable element that performs an action |
| **Link** | Clickable text that navigates to another page |
| **Modal** | Pop-up window overlaying the current page |
| **Notification** | Alert message informing you of events |
| **Filter** | Tool to narrow down search results |
| **Sort** | Arrange items in a specific order |

### 11.4 File & Media Terms

| Term | Definition |
|------|------------|
| **Image Upload** | Adding photos to product listings or profile |
| **Avatar** | Profile picture representing a user |
| **Gallery** | Collection of images for a product |
| **Thumbnail** | Small preview version of an image |
| **Attachment** | File connected to a message or order |

---

## 12. Status Definitions

### 12.1 Account Statuses

| Status | Meaning |
|--------|---------|
| **Active** | Account in good standing with full access |
| **Unverified** | Email not yet confirmed; limited features |
| **Suspended** | Temporarily disabled by admin |
| **Blocked** | Permanently restricted from platform |

### 12.2 Product Statuses

| Status | Meaning |
|--------|---------|
| **Available** | Product is for sale and in stock |
| **Out of Stock** | Temporarily unavailable due to inventory |
| **Unavailable** | Product listing disabled by supplier |
| **Verified** | Product quality confirmed by platform |

### 12.3 Order Statuses

| Status | Meaning |
|--------|---------|
| **Pending** | Awaiting supplier confirmation |
| **Confirmed** | Supplier accepted, preparing order |
| **Shipped** | Order dispatched, in transit |
| **Delivered** | Successfully received by buyer |
| **Cancelled** | Order cancelled before fulfillment |

### 12.4 Quotation Statuses

| Status | Meaning |
|--------|---------|
| **Pending** | Awaiting supplier response |
| **Responded** | Supplier has provided a quote |
| **Accepted** | Buyer accepted the quotation |
| **Rejected** | Quotation declined by buyer |
| **Expired** | Quotation no longer valid |

### 12.5 Review Statuses

| Status | Meaning |
|--------|---------|
| **Published** | Review visible on product page |
| **Flagged** | Marked for admin review |
| **Removed** | Review deleted for policy violation |

---

## 13. Error Messages & Troubleshooting

### 13.1 Common Error Messages

| Error | Meaning | Solution |
|-------|---------|----------|
| "Email has already been taken" | Email already registered | Use different email or recover password |
| "Invalid email or password" | Credentials don't match | Check spelling, reset password if needed |
| "Email verification required" | Feature needs verified email | Complete email verification process |
| "Session expired" | Logged out due to inactivity | Log in again |
| "Product not available" | Item out of stock | Check back later or find alternative |
| "Invalid verification code" | Code entered incorrectly | Check code carefully, request new one |
| "Maximum attempts exceeded" | Too many failed code entries | Wait and request new code |
| "Code has expired" | Verification code past 1 hour | Request new verification code |

### 13.2 Troubleshooting Guide

**Can't log in?**
1. Verify email spelling
2. Check caps lock is off
3. Try password reset
4. Clear browser cookies
5. Contact support

**Not receiving verification email?**
1. Check spam/junk folder
2. Verify email address is correct
3. Wait 5 minutes and check again
4. Request code resend
5. Check email provider isn't blocking

**Can't place order?**
1. Ensure email is verified
2. Check product is in stock
3. Complete all required fields
4. Try refreshing the page
5. Contact support

**Images not uploading?**
1. Check file size (max 10MB)
2. Use supported formats (JPG, PNG)
3. Try a different browser
4. Clear browser cache
5. Reduce image resolution

---

## 14. Data Privacy & Storage

### 14.1 What Data We Collect

| Data Type | Purpose |
|-----------|---------|
| **Account Information** | Name, email, phone, location for identification |
| **Transaction Data** | Orders, quotations for business operations |
| **Reviews** | Product feedback for marketplace quality |
| **Messages** | Support communications for assistance |
| **Usage Data** | Page views for platform improvement |

### 14.2 Data Protection

| Measure | Description |
|---------|-------------|
| **Encryption** | Passwords and sensitive data encrypted |
| **Secure Transmission** | HTTPS/SSL for all connections |
| **Access Control** | Role-based permissions |
| **Data Backup** | Regular backups for disaster recovery |
| **Limited Retention** | Data kept only as long as necessary |

### 14.3 Your Rights

You have the right to:
- Access your personal data
- Correct inaccurate information
- Request data deletion
- Export your data
- Opt out of marketing

### 14.4 Contact for Privacy

For privacy-related inquiries:
- Email: info@embarkment.co.uk
- Visit: Contact Us page

---

## 15. Platform Architecture Overview

### 15.1 System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    EMBARKMENTLTD ARCHITECTURE                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐        │
│  │   BUYERS    │    │  SUPPLIERS  │    │   ADMINS    │        │
│  └──────┬──────┘    └──────┬──────┘    └──────┬──────┘        │
│         │                  │                  │                │
│         └──────────────────┼──────────────────┘                │
│                            │                                   │
│                            ▼                                   │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │                    WEB APPLICATION                       │  │
│  │  ┌───────────┐ ┌───────────┐ ┌───────────┐            │  │
│  │  │ Products  │ │  Orders   │ │  Reviews  │            │  │
│  │  └───────────┘ └───────────┘ └───────────┘            │  │
│  │  ┌───────────┐ ┌───────────┐ ┌───────────┐            │  │
│  │  │Quotations │ │  Support  │ │  Users    │            │  │
│  │  └───────────┘ └───────────┘ └───────────┘            │  │
│  └─────────────────────────────────────────────────────────┘  │
│                            │                                   │
│                            ▼                                   │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │                      DATABASE                            │  │
│  │    Products │ Users │ Orders │ Reviews │ Messages       │  │
│  └─────────────────────────────────────────────────────────┘  │
│                            │                                   │
│                            ▼                                   │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │                    FILE STORAGE                          │  │
│  │         Product Images │ Avatars │ Attachments          │  │
│  └─────────────────────────────────────────────────────────┘  │
│                                                                │
└─────────────────────────────────────────────────────────────────┘
```

### 15.2 Key Components

| Component | Purpose |
|-----------|---------|
| **Web Application** | Core platform hosting all features |
| **Database** | Secure storage for all platform data |
| **File Storage** | Image and document storage system |
| **Email System** | Transactional emails and notifications |
| **Background Jobs** | Automated tasks (reminders, cleanup) |
| **Cache** | Performance optimization layer |

### 15.3 Technology Stack (For Technical Users)

| Layer | Technology |
|-------|------------|
| **Frontend** | TailwindCSS, Turbo, Stimulus |
| **Backend** | Ruby on Rails 8.0 |
| **Database** | PostgreSQL |
| **File Storage** | Active Storage |
| **Background Processing** | Solid Queue |
| **Authentication** | Devise |
| **Authorization** | Pundit |

### 15.4 Security Layers

```
┌────────────────────────────────────────┐
│            SSL/HTTPS                   │  ← Encrypted connection
├────────────────────────────────────────┤
│         Authentication                 │  ← Login required
├────────────────────────────────────────┤
│          Authorization                 │  ← Role-based access
├────────────────────────────────────────┤
│          Validation                    │  ← Data integrity
├────────────────────────────────────────┤
│          Encryption                    │  ← Password protection
└────────────────────────────────────────┘
```

---

## Appendix: Quick Reference Card

### Essential Links

| Action | URL |
|--------|-----|
| Homepage | embarkment.co.uk |
| Browse Products | embarkment.co.uk/products |
| Sign In | embarkment.co.uk/users/sign_in |
| Register | embarkment.co.uk/users/sign_up |
| Contact | embarkment.co.uk/contact-us |

### Key Contacts

| Department | Contact |
|------------|---------|
| General Inquiries | info@embarkment.co.uk |
| Support | Use in-app support chat |
| Business | info@embarkment.co.uk |

### Quick Tips

✅ Always verify your email for full access  
✅ Use quotation cart for bulk inquiries  
✅ Check product reviews before ordering  
✅ Keep your contact information updated  
✅ Log out when using shared computers  
✅ Contact support for any issues  

---

**Document End**

*This glossary is maintained by EmbarkmentLTD. For corrections or additions, please contact the platform administrators.*

*© 2026 EmbarkmentLTD. All rights reserved.*
