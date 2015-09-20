# replaces html classes with inline css

require 'nokogiri'
load 'css.rb'

INPUT_HTML_PATH = "./test.html" #change to the path to your html file you want the css to inline
TEMP_STYLE_ATTRIBUTE_NAME = 'inliner_style'

def strip_css_comments(css_string)
	css_string.gsub(/[\n\t]/, '').gsub(/\*\//, "*/\n").gsub(/\/\*.*\*\//, '')
end
def preprocess_css(css_string)
	# format the stylesheet one line per class so that the regex will work properly
	strip_css_comments(css_string).gsub(/[\s\t]/, "").gsub('}', "}\n")
end


# read html and get all linked css
page = Nokogiri::HTML(open(INPUT_HTML_PATH))
style_tags = page.css('link[rel=stylesheet]')
unless style_tags.length > 0
	raise "No CSS stylesheet link tags found in HTML file"
end

#collect all linked css files style data
css_styles = []

style_tags.each do |style_tag|
	style_sheet_path = style_tag['href']
	styles = File.read(style_sheet_path)
	styles = preprocess_css(styles)

	styles.split("\n").each do |line|
		css_styles << CSS::CSSStyle.new(line)
	end
end

#apply all styles to temporary attribute so that it won't overwrite existing style attributes so
#styles can be added according to css priority
css_styles.each do |css|
	page.css(css.selector).each do |element|
		current_temp_style = element[TEMP_STYLE_ATTRIBUTE_NAME] || ''
		element[TEMP_STYLE_ATTRIBUTE_NAME] = current_temp_style + css.style
	end
end

#add temporary attribute styles back to style tag
page.css('[inliner_style]').each do |element|
	current_style = element['style'] ||  ''
	element['style'] =  element[TEMP_STYLE_ATTRIBUTE_NAME] + current_style
end
#remove temporary inline styles
page.xpath("//@#{TEMP_STYLE_ATTRIBUTE_NAME}").remove

# output html with inline styles
puts page

