module RSpec::PageRegression
  module ImageComparison
    class Delta < Base
      class Image < ChunkyPNG::Image
        def each_pixel
          height.times do |y|
            row(y).each_with_index do |pixel, x|
              yield(pixel, x, y)
            end
          end
        end
      end

      def background
        @score = 0.0
        Image.new(@expected.width, @expected.height, WHITE)
      end

      def analyze_pixels(a, b, x, y)
        pixels_diff = euclid(a, b) / (MAX * Math.sqrt(3))
        @score += pixels_diff
        @diff[x, y] = grayscale(((1 - pixels_diff) * MAX).round)
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
    end
  end
end
