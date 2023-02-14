# frozen_string_literal: true

module Decidim
  module Dev
    # for this development instance we don't the accessibilty analyzer
    # so we override the concern to do nothing
    module NeedsDevelopmentTools
      extend ActiveSupport::Concern
    end
  end
end