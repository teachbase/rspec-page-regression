module RSpec::PageRegression
	module ImageComparison
		class Grayscale < Base
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
      	Image.from_file(@filepaths.reference_screenshot)
      end

      def analyze_pixels(a, b, x, y)
      	@diff[x, y] = rgb(255, 0, 0)
      end

      def pixels_equal?(a, b)
      	brightness(a) == brightness(b)
      end

      def brightness(a)
      	0.3 * r(a) + 0.59 * g(a) + 0.11 * b(a)
      end
		end
	end
end
