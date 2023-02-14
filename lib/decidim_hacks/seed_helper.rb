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
			    						      content_type: "image/png")
			    process.banner_image.attach(
			    						      io: File.new(image),
			    						      filename: File.basename(image), 
			    						      content_type: "image/png")
			  end
		    process.save!

		    extract_images_from_html(process.description["en"]).each do |image|
		      attach = attach_image_to(image, process)
		      replace_html_image(process.description["en"], image, attach.url)
		    end
		    process.save!

		    # seed_proposals("#{slug}.yml", process)
		  end
		end

		def seed_proposals(file, process)
			# Proposals for a process
		  params = {
		    name: {
		      en: "Exercises"
		    },
		    manifest_name: :proposals,
		    published_at: Time.current,
		    participatory_space: process
		  }
		  component = Decidim::Component.find_by(participatory_space_type: "Decidim::ParticipatoryProcess",
		                                         participatory_space_id: process.id,
		                                         name: {en: "Exercises"}) || Decidim::Component.create!(params)

		  exercises = YAML.load_file(File.join(@@content_root, file))
		  exercises.each do |key, parts|
		    params = {
		      component: component,
		      title: "[#{key}] #{parts['title']}",
		      body: parts['body'],
		      answered_at: Time.current,
		      published_at: Time.current
		    }
		    proposal = find_exercise(component.id, key) || Decidim::Proposals::Proposal.new(params)
		    proposal.add_coauthor(@@organization)
		    proposal.save!
		    extract_images_from_md(params[:body]).each do |image|
		      attach = attach_image_to(image, proposal)
		      replace_md_image(params[:body], image, attach.url)
		    end

		    extract_links_from_md(params[:body]).each do |link|
		      # find proposal
		      exercise = find_exercise(component.id, link.sub("/",""))
		      replace_md_link(params[:body], link, Decidim::ResourceLocatorPresenter.new(exercise).url)
		    end
		    proposal.update_attributes params
		    proposal.save!
		  end
		end

		def attach_image_to(image, entity)
      Decidim::Attachment.find_by(title: {en: image}).try(:destroy)
			Decidim::Attachment.create!(
        title: {en: image},
        file: ActiveStorage::Blob.create_and_upload!(
          io: File.open(File.join(@@images_root, image)),
          filename: image,
          content_type: "image/png"
        ),
        content_type: "image/png",
        attached_to: entity
      )
		end

		def find_exercise(component_id, key)
			Decidim::Proposals::Proposal.where("decidim_component_id=#{component_id} AND title LIKE '[#{key}] %'").first
		end
	end
end