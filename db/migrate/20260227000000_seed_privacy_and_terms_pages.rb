class SeedPrivacyAndTermsPages < ActiveRecord::Migration[8.0]
  def up
    # Create Privacy Policy page
    unless Page.exists?(slug: "privacy-policy")
      privacy_policy_content = %q{
        <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
          <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-8 md:p-10">
            <h1 class="text-3xl md:text-4xl font-bold text-gray-900 mb-3">Privacy Policy</h1>
            <p class="text-sm text-gray-500 mb-8">Last updated: #{Date.current.strftime("%d %B %Y")}</p>

            <div class="prose prose-gray max-w-none">
              <p>
                This Privacy Policy explains how EmbarkmentLTD ("Embarkment", "we", "us", "our") collects,
                uses, stores, shares, and protects personal information when you use our marketplace services.
              </p>

              <h2>1. Scope</h2>
              <p>
                This policy applies to buyers, suppliers, visitors, support users, and other individuals who interact
                with our website, accounts, quotes, messaging, and support channels.
              </p>

              <h2>2. Information We Collect</h2>
              <ul>
                <li>Account data: name, email address, role, and location.</li>
                <li>Profile data: optional avatar and profile-related preferences.</li>
                <li>Commercial data: product listings, quote requests, order details, and related records.</li>
                <li>Communications: support conversations and service-related messages.</li>
                <li>Technical data: IP address, browser type, device details, session identifiers, and usage analytics.</li>
              </ul>

              <h2>3. How We Use Information</h2>
              <ul>
                <li>To provide and operate the marketplace safely and reliably.</li>
                <li>To process registrations, authentication, quotes, and product interactions.</li>
                <li>To prevent abuse, detect fraud, and enforce platform policies.</li>
                <li>To improve product quality, stability, and user experience.</li>
                <li>To send essential operational communications and support responses.</li>
              </ul>

              <h2>4. Lawful Basis and Consent</h2>
              <p>
                We process personal data where necessary for contractual performance, legitimate interests,
                legal obligations, and consent where required. You may withdraw consent where applicable,
                subject to legal and operational limitations.
              </p>

              <h2>5. Data Sharing</h2>
              <ul>
                <li>With service providers who support hosting, security, analytics, and communications.</li>
                <li>With buyers and suppliers where required to facilitate a quote or order workflow.</li>
                <li>With regulators, courts, or law enforcement where legally required.</li>
                <li>With professional advisers during audits, disputes, or compliance matters.</li>
              </ul>
              <p>We do not sell personal data.</p>

              <h2>6. Data Security</h2>
              <p>
                We use reasonable organizational, technical, and administrative controls to protect information,
                including access controls, credential safeguards, encrypted transport where applicable,
                and internal authorization boundaries.
              </p>

              <h2>7. Data Retention</h2>
              <p>
                We retain personal data only as long as needed for business operations, legal obligations,
                dispute resolution, and record-keeping. Retention periods may vary by data type and legal context.
              </p>

              <h2>8. Your Rights</h2>
              <ul>
                <li>Request access to personal data we hold about you.</li>
                <li>Request correction of inaccurate or incomplete data.</li>
                <li>Request deletion where legally permissible.</li>
                <li>Request restrictions or object to certain processing activities.</li>
                <li>Request data portability where applicable.</li>
              </ul>

              <h2>9. Children and Vulnerable Individuals</h2>
              <p>
                Our marketplace is not intended for unlawful use by minors or for activities that may harm
                vulnerable individuals. We reserve the right to remove accounts or listings that breach this principle.
              </p>

              <h2>10. Public Interest and Platform Safety</h2>
              <p>
                We may moderate content, suspend accounts, and report unlawful behavior to protect users,
                suppliers, buyers, and the wider public from fraud, harmful goods, misinformation, or abuse.
              </p>

              <h2>11. International Transfers</h2>
              <p>
                Where data is transferred across jurisdictions, we apply reasonable safeguards consistent
                with applicable privacy and data-protection requirements.
              </p>

              <h2>12. Changes to This Policy</h2>
              <p>
                We may update this policy from time to time. Material updates become effective when posted
                on this page with a revised date.
              </p>

              <h2>13. Contact</h2>
              <p>
                For privacy questions or requests, contact
                <a href="mailto:info@embarkment.co.uk">info@embarkment.co.uk</a>.
              </p>
            </div>
          </div>
        </div>
      }

      Page.create!(
        title: "Privacy Policy",
        slug: "privacy-policy",
        content: privacy_policy_content
      )
      puts "✅ Created Privacy Policy page"
    end

    # Create Terms and Conditions page
    unless Page.exists?(slug: "terms-and-conditions")
      terms_content = %q{
        <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
          <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-8 md:p-10">
            <h1 class="text-3xl md:text-4xl font-bold text-gray-900 mb-3">Terms and Conditions</h1>
            <p class="text-sm text-gray-500 mb-8">Last updated: #{Date.current.strftime("%d %B %Y")}</p>

            <div class="prose prose-gray max-w-none">
              <p>
                These Terms and Conditions ("Terms") govern access to and use of EmbarkmentLTD
                ("Embarkment", "we", "us", "our"). By creating an account or using the service,
                you agree to these Terms.
              </p>

              <h2>1. Marketplace Role</h2>
              <p>
                Embarkment provides an online marketplace to connect buyers and suppliers. We do not guarantee
                that every listing, transaction, delivery, or commercial outcome will meet user expectations.
              </p>

              <h2>2. Eligibility and Accounts</h2>
              <ul>
                <li>You must provide accurate and current information when registering.</li>
                <li>You are responsible for account credentials and activity under your account.</li>
                <li>You must not impersonate another person or business.</li>
                <li>We may suspend or terminate accounts that violate law, policy, or these Terms.</li>
              </ul>

              <h2>3. Buyer Responsibilities</h2>
              <ul>
                <li>Review product details and supplier terms before requesting quotes or placing orders.</li>
                <li>Provide accurate delivery and communication details.</li>
                <li>Use the platform lawfully and in good faith.</li>
              </ul>

              <h2>4. Supplier Responsibilities</h2>
              <ul>
                <li>List products accurately, including category, quality, quantity, and pricing.</li>
                <li>Comply with food safety, labeling, and consumer laws applicable in your jurisdiction.</li>
                <li>Fulfil accepted orders and communicate material changes promptly.</li>
                <li>Do not list illegal, counterfeit, unsafe, or prohibited goods.</li>
              </ul>

              <h2>5. Prohibited Conduct</h2>
              <ul>
                <li>Fraud, deceptive behavior, harassment, abuse, or unlawful discrimination.</li>
                <li>Uploading malicious code, scraping data unlawfully, or disrupting service operation.</li>
                <li>Posting misleading claims, unsafe products, or content harmful to the public.</li>
              </ul>

              <h2>6. Pricing, Quotes, and Transactions</h2>
              <p>
                Prices and quotes are provided by suppliers unless explicitly stated otherwise.
                Embarkment may display or transmit quote and order information but is not a party
                to every commercial contract between buyer and supplier.
              </p>

              <h2>7. Public and Community Protection</h2>
              <p>
                We may remove listings, block users, or report unlawful activities to protect the company,
                buyers, suppliers, and the general public from harm, fraud, public health risks,
                intellectual property abuse, and other legal violations.
              </p>

              <h2>8. Intellectual Property</h2>
              <ul>
                <li>Embarkment and its branding are protected by applicable IP laws.</li>
                <li>Users retain rights to their content but grant us a non-exclusive license to host,
                    process, and display it for platform operation and moderation.</li>
              </ul>

              <h2>9. Availability and Service Changes</h2>
              <p>
                We may modify, suspend, or discontinue features at any time, including for maintenance,
                legal compliance, or security reasons.
              </p>

              <h2>10. Disclaimers</h2>
              <p>
                The platform is provided on an "as is" and "as available" basis to the extent permitted by law.
                We do not warrant uninterrupted access, absolute error-free operation, or guaranteed results.
              </p>

              <h2>11. Limitation of Liability</h2>
              <p>
                To the maximum extent permitted by law, Embarkment is not liable for indirect,
                incidental, consequential, special, or punitive damages, including loss of profit,
                reputation, or data arising from platform use.
              </p>

              <h2>12. Indemnity</h2>
              <p>
                You agree to indemnify and hold Embarkment harmless from claims, losses, liabilities,
                and expenses arising from your misuse of the platform, breach of these Terms,
                or violation of law or third-party rights.
              </p>

              <h2>13. Termination</h2>
              <p>
                We may suspend or terminate access immediately where required for legal compliance,
                fraud prevention, safety, or policy enforcement.
              </p>

              <h2>14. Governing Law</h2>
              <p>
                These Terms are governed by applicable laws of the operating jurisdiction of Embarkment,
                without prejudice to mandatory consumer protections that apply by law.
              </p>

              <h2>15. Contact</h2>
              <p>
                Questions about these Terms can be sent to
                <a href="mailto:info@embarkment.co.uk">info@embarkment.co.uk</a>.
              </p>
            </div>
          </div>
        </div>
      }

      Page.create!(
        title: "Terms and Conditions",
        slug: "terms-and-conditions",
        content: terms_content
      )
      puts "✅ Created Terms and Conditions page"
    end
  end

  def down
    Page.find_by(slug: "privacy-policy")&.destroy
    Page.find_by(slug: "terms-and-conditions")&.destroy
    puts "Removed Privacy Policy and Terms pages"
  end
end
