module RSpec::PageRegression
	module ImageComparison
		class Grayscale < Base
      def background
        Image.from_file(@filepaths.reference_screenshot).to_grayscale
      end

      def analyze_pixels(a, b, x, y)
      	@diff[x, y] = rgb(255, 0, 0)
      end

      def pixels_equal?(a, b)
      	alpha = color_similar?(a(a), a(b))
      	brightness = color_similar?(brightness(a), brightness(b))
      	alpha && brightness
      end

      def color_similar?(a, b)
      	tolerance = 16
      	d = (a - b).abs
      	d < tolerance
      end
		end
	end
end
