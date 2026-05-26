
# frozen_string_literal: true

# Tune a little the default seeds to add meaningful content
require "decidim_hacks/parser_helper"
require "decidim_hacks/seed_helper"

if !Rails.env.production? || ENV["SEED"]
  seeds_root = File.join(__dir__)
  images_root = File.join(seeds_root, 'images')

  background = Dir[File.join(images_root, "hackers", "*.jpg")].sample
  organization = Decidim::Organization.first
  hero_content_block = Decidim::ContentBlock.find_by(organization: organization, manifest_name: :hero, scope_name: :homepage)
  hero_content_block.images_container.background_image.attach(
    io: File.new(background),
    filename: File.basename(background), 
    content_type: "image/jpg"
  )
end