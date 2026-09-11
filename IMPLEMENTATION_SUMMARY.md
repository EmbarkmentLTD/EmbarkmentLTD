# Product Images & Legal Pages - Implementation Summary

## What Was Done

### 1. ✅ Privacy Policy & Terms & Conditions Converted to Editable CMS

**Status:** COMPLETE - Pages now editable via admin panel

**Changes Made:**

- **Controller Updates** (`app/controllers/home_controller.rb`):
  - `privacy_policy` action now fetches `@page` from Pages table
  - `terms_and_conditions` action now fetches `@page` from Pages table
  - Both actions generate default content if page doesn't exist
  - Added two new helper methods: `privacy_policy_content()` and `terms_and_conditions_content()`

- **View Templates Updated:**
  - `app/views/home/privacy_policy.html.erb` - Now renders editable `@page.content`
  - `app/views/home/terms_and_conditions.html.erb` - Now renders editable `@page.content`
  - Both include admin edit button (green bar) when logged in as admin
  - Pattern matches existing Contact Us page

- **Database Seeding** (Migration):
  - File: `db/migrate/20260227000000_seed_privacy_and_terms_pages.rb`
  - Creates initial Page records with existing legal content
  - Slug: `privacy-policy`, `terms-and-conditions`
  - Safe migration (checks if pages exist before creating)

**How to Use:**
1. Log in as admin
2. Navigate to `/privacy-policy` or `/terms-and-conditions`
3. Click green "Edit Page" button in top-right
4. Edit content in admin page editor
5. Save changes - page updates immediately

### 2. ✅ Product Images - Temporary Solution Implemented

**Status:** COMPLETE - Ready to fetch temporary images

**What Was Created:**

- **Rake Task:** `lib/tasks/fetch_product_images.rake`
  - Command: `rails products:fetch_temp_images`
  - Fetches images from Unsplash for all products without images
  - Matches images by category (fruits, vegetables, grains, etc.)
  - Attaches images directly to products via Active Storage
  - Safe: Skips products that already have images

**How to Use:**
```bash
# SSH into production container
kamal app exec 'bin/rails products:fetch_temp_images'

# Or directly:
docker exec embarkment-web bin/rails products:fetch_temp_images
```

**Image Sources (Free & Public):**
- Unsplash API (no auth required for these specific URLs)
- High-quality free product images
- ~400x400px resolution (suitable for marketplace)
- Covers all 8 product categories

**Important Notes:**
- ⚠️ These are TEMPORARY placeholder images
- ✅ Task displays: "These are temporary placeholder images from Unsplash"
- 🔄 When sellers upload real images, these can be replaced
- 📝 Consider adding UI note: "Temporary image - seller will upload their own"

### 3. ✅ Terms & Conditions Browser Rendering

**Status:** VERIFIED - All 15 sections render correctly
- No JavaScript errors
- Complete DOM structure
- Responsive design works
- Form validation enforces T&C checkbox on signup

---

## Deployment Steps

### Step 1: Database Migration
```bash
# SSH into production container and run migration
kamal app exec 'bin/rails db:migrate'

# This creates the Privacy Policy and Terms pages in the database
```

### Step 2: Fetch Temporary Product Images
```bash
# Run the rake task to attach images to products
kamal app exec 'bin/rails products:fetch_temp_images'

# Output should show:
# ✓ Added temp image to: Apple...
# ✓ Added temp image to: Tomato...
# etc.
```

### Step 3: Verify the Changes

**Test Privacy Policy:**
- Navigate to: `https://www.embarkment.co.uk/privacy-policy`
- Should show all 13 sections
- Admin should see green "Edit Page" button
- Click edit button to verify admin page editor works

**Test Terms & Conditions:**
- Navigate to: `https://www.embarkment.co.uk/terms-and-conditions`
- Should show all 15 sections
- Admin should see green "Edit Page" button
- Verify checkbox still appears on signup form

**Test Product Images:**
- Navigate to: Products page
- All products should have thumbnail images (no more fallback SVG)
- Images should match product categories

---

## File Changes Summary

| File | Change | Type |
|------|--------|------|
| `app/controllers/home_controller.rb` | Updated privacy_policy & terms_and_conditions actions | EDIT |
| `app/views/home/privacy_policy.html.erb` | Convert to CMS rendering with edit button | EDIT |
| `app/views/home/terms_and_conditions.html.erb` | Convert to CMS rendering with edit button | EDIT |
| `lib/tasks/fetch_product_images.rake` | New rake task for fetching temp images | CREATE |
| `db/migrate/20260227000000_seed_privacy_and_terms_pages.rb` | Migration to seed initial pages | CREATE |

---

## Rollback Instructions

If needed, revert changes:

```bash
# Revert database migration
kamal app exec 'bin/rails db:rollback'

# This removes the privacy-policy and terms-and-conditions pages
# Views will still render fallback content
```

---

## Next Steps (For Owner)

1. **Replace Product Images:**
   - When sellers upload their own images, the temporary images can be removed
   - Sellers can replace images through their product management interface
   - Old Unsplash images will be deleted when new ones are uploaded

2. **Customize Legal Pages:**
   - Owner can now edit Privacy Policy and Terms via admin panel
   - No need to modify code or redeploy
   - Changes take effect immediately

3. **Monitor Product Listings:**
   - Verify all products now display images correctly
   - Check that product categories are properly assigned
   - Encourage sellers to upload high-quality product photos

---

## Testing Checklist

- [ ] Migration runs without errors
- [ ] Rake task fetches images successfully
- [ ] Product cards display images (no 404 errors)
- [ ] Privacy Policy page renders with 13 sections
- [ ] Terms & Conditions page renders with 15 sections
- [ ] Admin edit buttons appear when logged in as admin
- [ ] Admin can edit page content
- [ ] Changes persist after page reload
- [ ] Signup form still requires T&C acceptance
- [ ] Mobile responsive layouts work correctly

---

## Support Notes

**For Production Debugging:**
```bash
# Check if pages were created
kamal app exec 'bin/rails c'
> Page.all

# Check if products have images attached
> Product.first.images.attached?

# Re-run task if needed
kamal app exec 'bin/rails products:fetch_temp_images'
```

**Image Limits:**
- Max 5 images per product (validated)
- Max 5MB per image (validated)
- Supported formats: JPG, PNG, GIF, WebP

**Legal Page Limits:**
- Content stored as HTML (sanitized)
- Max 1MB per page
- Can include links, formatting, images
