module DecidimHacks
	module ParserHelper

		def replace_html_image(text, image, replacement)
			text.gsub!("<img src=\"#{image}\"", "<img src=\"#{replacement}\"")
		end

		def extract_images_from_html(text)
			text.scan(/<img src="([^\"]+)"/).pluck 0
		end

		def replace_md_image(text, image, replacement)
			text.gsub!("![](#{image})", "![](#{replacement})")
		end

		def extract_images_from_md(text)
			text.scan(/!\[\]\(([^\)]+)\)/).pluck 0
		end

		def replace_md_link(text, link, replacement)
			text.gsub!("](#{link})", "](#{replacement})")
		end

		def extract_links_from_md(text)
			text.scan(/\[Exercise [0-9+]\]\(([^\)]+)\)/).pluck 0
		end

		def multi_render(text)
			if text.respond_to? :each
				text.each do |key, value|
					text[key] = md_render value
				end
			else
				text = md_render text
			end
			text
		end

		def md_render(text)
      text = Redcarpet::Markdown.new(markdown, autolink: true, tables: true, fenced_code_blocks: true).render(text)
			"<div class=\"decidim-hacks\">#{text}</div>"
		end

		def markdown
			@markdown ||= Redcarpet::Render::HTML.new(prettify: true)
		end
	end
end