# replaces html classes with inline css
# only supports a single class selector or element selector; not ids or nested or combined selectors
# if you use quotes (e.g. font-family), use double quotes

def get_css_classes(element_opening_tag)
	class_attribute = get_class_attribute(element_opening_tag)
	if class_attribute.nil?
		return []
	end
	class_names = class_attribute.gsub(/class=['"]|['"]/, '')
	return class_names.split(/\s+/)
end

def get_class_attribute(element_opening_tag)
	return element_opening_tag.scan(/class=['"].+['"]/)[0]
end
def strip_css_comments(css_string)
	return css_string.gsub(/[\n\t]/, '').gsub(/\*\//, "*/\n").gsub(/\/\*.*\*\//, '')
end


INPUT_HTML_PATH = "./test.html"
STYLESHEET_PATH = "./styles.css"

# read files
raw_html = File.read(INPUT_HTML_PATH)
styles = File.read(STYLESHEET_PATH)

# strip comments
styles = strip_css_comments(styles)

# format the stylesheet one line per class so that the regex will work properly
styles.gsub!(/[\s\t]/, "").gsub!('}', "}\n")

# put all stylesheet data for classes in hash for effeciency
class_styles_hash = Hash.new
element_styles_hash = Hash.new

styles.split("\n").each do |line|
	# search for class selectors
	key = line.scan(/\..*{/)
	style_hash = nil
	if key.length > 0
		key = key[0].gsub(/[\.{]/,'')
		style_hash = class_styles_hash
	# must be an element selector then
	else
		key = line.scan(/^\s*[a-zA-Z]+.*{/)[0].gsub(/[\.{]/,'')
		style_hash = element_styles_hash
	end
	# extract css style
	style = line.scan(/\{.*\}/)[0].gsub(/[\{\}]/,'')
	# test for redundant selectors
	if style_hash.key?(key)
		style_hash[key] = style_hash[key] + style
	else
		style_hash[key] = style
	end
end

#find all elements in html
element_opening_tags = raw_html.scan(/<[a-zA-Z]+[a-zA-Z0-9\-_';=()&+:"{}\[%$#@!,?\/\\|\].\s\t\n]*>/)
# puts element_opening_tags

# find all class declarations in html
classes = raw_html.scan(/class=['"].+['"]/)

element_opening_tags.each do |element_tag|
	style_attribute = "style='"
	# get styles for element
	element = element_tag.scan(/<[a-zA-Z]+/)[0].sub('<', '')
	style = element_styles_hash[element]
	# get styles for classes
	get_css_classes(element_tag).each do |class_name|
		class_style = class_styles_hash[class_name]
		if !class_style.nil?
			style = style + class_style
		end
	end

	if !style.nil?
		# add inline style attribute
		styled_element_open_tag = element_tag.sub(/>[\s\n\t]*$/, '') + style_attribute + style + "'" + '>'
		# remove class attribute
		styled_element_open_tag.gsub!(get_class_attribute(element_tag), '')
		# replace only first occurrence since we are going through the elements in order
		raw_html.sub!(element_tag, styled_element_open_tag)
	end
end





# output html with inline styles
puts raw_html

