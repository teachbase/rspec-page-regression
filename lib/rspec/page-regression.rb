require 'rspec/page-regression/file_paths'
require 'rspec/page-regression/image_comparison'
require 'rspec/page-regression/matcher'
require 'rspec/page-regression/renderer'
require 'rspec/page-regression/version'
require 'rspec/page-regression/viewport'

module RSpec::PageRegression
  RENDER_ARGS = [:selector, :full]
  ALLOWED_ARGS = [:viewport, :except_viewport, :label, :mode, :diff] + RENDER_ARGS
  MODES = {
    rgb: 'Base',
    grayscale: 'Grayscale',
    delta_e: 'Delta'
  }.freeze

  def self.configure
    yield self
  end

  def self.viewports=(viewports)
    @@viewports = viewports.map{ |vp| Viewport.new(*vp) }
  end

  def self.viewports
    @@viewports ||= [ Viewport.new(:default, [1024, 768]) ]
  end

  def self.default_viewports=(defaults)
    @@default_viewports = viewports.select { |vp| vp.is_included_in?(defaults) }
  end

  def self.default_viewports
    @@default_viewports ||= viewports
  end

  def self.threshold=(threshold)
    @@threshold = threshold
  end

  def self.threshold
    @@threshold ||= 0.0
  end

  def self.mode=(mode)
    @@mode = mode
  end

  def self.mode
    @@mode ||= :rgb
  end
end
