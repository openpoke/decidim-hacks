# frozen_string_literal: true

Rails.application.config.to_prepare do
  Decidim::Proposals::ApplicationHelper.include DecidimHacks::ProposalsApplicationHelperOverride
end