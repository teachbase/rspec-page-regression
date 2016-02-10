module RSpec::PageRegression
	module ImageComparison
    module ColorMethods
      include ChunkyPNG::Color

      def brightness(a)
        0.3 * r(a) + 0.59 * g(a) + 0.11 * b(a)
      end
    end

	  class Base
      class Image < ChunkyPNG::Image
        include RSpec::PageRegression::ImageComparison::ColorMethods

        def each_pixel
          height.times do |y|
            row(y).each_with_index do |pixel, x|
              yield(pixel, x, y)
            end
          end
        end

        def to_grayscale
          each_pixel do |test_pixel, x, y|
            self[x, y] = grayscale(brightness(test_pixel).round)
          end
          self
        end

        def with_alpha(value)
          each_pixel do |test_pixel, x, y|
            self[x, y] = rgba(r(test_pixel), g(test_pixel), b(test_pixel), value)
          end
          self
        end
      end

      include RSpec::PageRegression::ImageComparison::ColorMethods

      attr_reader :result, :filepaths

      def initialize(filepaths)
        @filepaths = filepaths
        @result = compare
      end

      def expected_size
        [@expected.width , @expected.height]
      end

      def test_size
        [@test.width , @test.height]
      end

      private

      def compare
        @filepaths.difference_image.unlink if @filepaths.difference_image.exist?

        return :missing_reference_screenshot unless @filepaths.reference_screenshot.exist?
        return :missing_test_screenshot unless @filepaths.test_screenshot.exist?

        @expected = Image.from_file(@filepaths.reference_screenshot)
        @test = Image.from_file(@filepaths.test_screenshot)

        return :size_mismatch if test_size != expected_size

        analyze_images

        return :match if score <= RSpec::PageRegression.threshold

        create_diff_image
        return :difference
      end

      def analyze_images
        @diff = background
        @xmin = @test.width + 1
        @xmax = -1
        @ymin = @test.height + 1
        @ymax = -1
        @mismatch_count = 0.0
        @test.each_pixel do |test_pixel, x, y|
          expected_pixel = @expected[x, y]
          next if pixels_equal?(test_pixel, expected_pixel)
          udpate_bounds(x, y)
          @mismatch_count += 1
          analyze_pixels(expected_pixel, test_pixel, x, y)
        end
      end

      def background
        Image.new(@expected.width, @expected.height, BLACK)
      end

      def analyze_pixels(a, b, x, y)
        @diff[x,y] = rgb(
                       (r(a) - r(b)).abs,
                       (g(a) - g(b)).abs,
                       (b(a) - b(b)).abs
                     )
      end

      def create_diff_image
        @diff.rect(@xmin - 1, @ymin - 1, @xmax + 1, @ymax + 1, rgb(255,0,0))
        @diff.save @filepaths.difference_image
      end

      def udpate_bounds(x, y)
        @xmin = x if x < @xmin
        @xmax = x if x > @xmax
        @ymin = y if y < @ymin
        @ymax = y if y > @ymax
      end

      def score
        (@mismatch_count / @expected.pixels.length)
      end

      def pixels_equal?(a, b)
        a == b
      end
    end
  end
end
