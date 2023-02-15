if !Rails.env.production? || ENV["SEED"]
  puts "Changes the localhost server name to 192.168.99.100."
  puts "This can be used when using Docker Toolbox for Windows"
  puts "The same action can be achieved (or reverted) by accessing http://hostame/system"

  organization = Decidim::Organization.first
  organization.host = "192.168.99.100"
  organization.save!
end