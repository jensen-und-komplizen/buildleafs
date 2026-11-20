# frozen_string_literal: true

# Test list (Story 1):
# - [ ] a successful build describes itself as "successful"

require_relative "../test_helper"
require_relative "../../lib/buildleafs/build_status"

module Buildleafs
  class BuildStatusTest < Minitest::Test
    def test_successful_build_describes_itself_as_successful
      status = BuildStatus.new(:success)

      description = status.to_s

      assert_equal "successful", description
    end
  end
end
