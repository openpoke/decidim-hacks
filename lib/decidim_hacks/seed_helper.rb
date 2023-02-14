module DecidimHacks
	module SeedHelper
		@@seeds_root = ""
		@@images_root = ""
		@@content_root = ""
		@@organization = nil

		def unpromote_all
			Decidim::ParticipatoryProcess.all.each do |process|
				process.promoted = false
				process.save!
			end
		end

		def seed_process(file)
		  processes = YAML.load_file(File.join(@@content_root, file))
		  processes.each do |slug, parts|
		  	puts "Creating process #{slug}..."
		    process = Decidim::ParticipatoryProcess.find_by(slug: slug) || Decidim::ParticipatoryProcess.new(
		    	slug: slug,
		      start_date: Date.current,
		      published_at: 2.weeks.ago,
		    )
		    process.promoted = true
		    process.organization = @@organization
		    process.end_date = 2.months.from_now

		    parts.each do |key, text|
		      next if key == "image"

		      text = multi_render(text) if key.in? ["short_description", "description"]
	      	process.send("#{key}=", text)
		    end

		    if (image = parts["image"])
		    	image = File.join(@@images_root, image)
			    process.hero_image.attach(
			    						      io: File.new(image),
			    						      filename: File.basename(image), 
			    						      content_type: content_type_from(image))
			    process.banner_image.attach(
			    						      io: File.new(image),
			    						      filename: File.basename(image), 
			    						      content_type: content_type_from(image))
			  end
		    process.save!

		    extract_images_from_html(process.description["en"]).each do |image|
		      attach = attach_image_to(image, process)
		      replace_html_image(process.description["en"], image, attach.url)
		    end
		    process.save!

		    seed_proposals("#{slug}.yml", process)
		  end
		end

		def seed_proposals(file, process)
			# Proposals for a process
		  component = Decidim::Component.find_by(participatory_space: process,
		                                         name: {en: "Exercises"}) || Decidim::Component.new(
		                                           participatory_space: process,
		                                           name: {en: "Exercises"})
		  component.manifest_name = :proposals
		  component.published_at = Time.current
		  component.save!

		  exercises = YAML.load_file(File.join(@@content_root, file))
		  exercises.each do |key, parts|
		    proposal = find_exercise(component, key) || Decidim::Proposals::Proposal.new(component: component)
		    proposal.title = { en: "[#{key}] #{parts['title']}" }
		    puts "Creating exercise #{proposal.title["en"]}..."
		    proposal.body = { en: parts['body'] }
		    proposal.answered_at = Time.current
		    proposal.published_at = Time.current

		    proposal.add_coauthor(@@organization)
		    # destroy all attachments
		    proposal.attachments.each do |attach|
		      attach.file.try(:destroy)
		      attach.destroy
		    end
		    proposal.save!
		    extract_images_from_md(proposal.body["en"]).each do |image|
		      attach = attach_image_to(image, proposal)
		      replace_md_image(proposal.body["en"], image, attach.url)
		    end

		    extract_links_from_md(proposal.body["en"]).each do |link|
		      # find proposal
		      exercise = find_exercise(component, link.sub("/",""))
		      replace_md_link(proposal.body["en"], link, Decidim::ResourceLocatorPresenter.new(exercise).url)
		    end
		    proposal.save!
		  end
		end

		def attach_image_to(image, entity)
			if (attachment = Decidim::Attachment.find_by(title: {en: image}))
				attachment.file.try(:destroy)
				attachment.destroy
			end
			Decidim::Attachment.create!(
        title: {en: image},
        attached_to: entity,
        content_type: content_type_from(image),
        file: ActiveStorage::Blob.create_and_upload!(
          io: File.open(File.join(@@images_root, image)),
          filename: image,
          content_type: content_type_from(image)
        )
      )
		end

		def content_type_from(image)
			case File.extname(image)
			when ".png"
				"image/png"
			when ".jpg", ".jpeg"
				"image/jpeg"
			when ".gif"
				"image/gif"
			when ".webm"
				"video/webm"
			end
		end

		def find_exercise(component, key)
			Decidim::Proposals::Proposal.where(component: component).where("title->>'en' LIKE ?", "[#{key}] %").first
		end
	end
end