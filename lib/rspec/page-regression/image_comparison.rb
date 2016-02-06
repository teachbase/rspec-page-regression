if RUBY_PLATFORM == 'java'
  require "chunky_png"
else
  require 'oily_png'
end

module RSpec::PageRegression
  module ImageComparison
    require 'rspec/page-regression/image_comparison/base'
    require 'rspec/page-regression/image_comparison/delta'
    require 'rspec/page-regression/image_comparison/grayscale'
  end
end
