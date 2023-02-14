# frozen_string_literal: true

require "decidim_hacks/parser_helper"

module DecidimHacks
	module ProposalsApplicationHelperOverride
		extend ActiveSupport::Concern

		included do
			include DecidimHacks::ParserHelper

      def render_proposal_body(proposal)
				if proposal.participatory_space.slug.starts_with? "level"
					text = md_render(present(proposal).body)
					# replace webm links for video links
					return text.gsub(/<img src="(.+).webm\"(.*)"(.*)>/, "<video autoplay loop width=\"100%\"><source src=\"\\1\.webm\" type=\"video/webm\"></video>").html_safe
				end
        sanitized = render_sanitized_content(proposal, :body)
        if safe_content?
          Decidim::ContentProcessor.render_without_format(sanitized).html_safe
        else
          Decidim::ContentProcessor.render(sanitized, "div")
        end
      end
		end
	end
end
