module RSpec::PageRegression
  module ImageComparison
    class Delta < Base
      def initialize(filepaths)
        @filepaths = filepaths
        @score = 0.0
        @result = compare
      end

      def background
        Image.new(@expected.width, @expected.height, WHITE).with_alpha(0)
      end

      def analyze_pixels(a, b, x, y)
        pixels_diff = euclid(a, b) / (MAX * Math.sqrt(3))
        @score += pixels_diff
        @diff[x, y] = rgba(255, 0, 0, ((pixels_diff) * MAX).round)
      end

      def euclid(a, c)
        Math.sqrt(
          (r(a) - r(c)) ** 2 +
          (g(a) - g(c)) ** 2 +
          (b(a) - b(c)) ** 2
        )
      end

      def score
        @score / @expected.pixels.length
      end

      def create_diff_image
        @diff = Image.from_file(@filepaths.reference_screenshot).to_grayscale.compose!(@diff, 0, 0)
        @diff.save @filepaths.difference_image
      end
    end
  end
end
