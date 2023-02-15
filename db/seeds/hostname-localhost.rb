if !Rails.env.production? || ENV["SEED"]
  puts "Changes the localhost server name to localhost."
  puts "This can be used when using Docker Toolbox for Windows"
  puts "The same action can be achieved (or reverted) by accessing http://hostame/system"

  organization = Decidim::Organization.first
  organization.host = "localhost"
  organization.save!
end