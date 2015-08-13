# replaces html classes with inline css
#only supports class selectors, not elements, ids or nested selectors
# if you use quotes (e.g. font-family), use double quotes
INPUT_HTML_PATH = "./test.html"
STYLESHEET_PATH = "./styles.css"

# read files
raw_html = File.read(INPUT_HTML_PATH)
styles = File.read(STYLESHEET_PATH)

# format the stylesheet one line per class so that the regex will work properly
styles.gsub!(/[\s\t]/, "").gsub!('}', "}\n")

# put all stylesheet data in hash for effeciency
styles_hash = Hash.new
styles.split("\n").each do |line|
	key = line.scan(/\..*{/)[0].gsub(/[\.{]/,'')
	style = line.scan(/\{.*\}/)[0].gsub(/[\{\}]/,'')
	styles_hash[key] = style
end

# find all class declarations in html
classes = raw_html.scan(/class=['"].+['"]/)

classes.each do |class_data|
	class_names = class_data.gsub(/class=['"]|['"]/, '')
	class_style = "style='"
	class_names.split(/\s+/).each do |class_name|
		begin
			class_style = class_style + styles_hash[class_name]
		rescue
			# don't do anything if class not declared in stylesheet
		end
	end
	class_style = class_style + "'"
	raw_html.sub!(class_data, class_style)
end

# output html with inline styles
puts raw_html

