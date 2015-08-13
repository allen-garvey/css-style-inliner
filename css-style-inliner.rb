# replaces html classes with inline css
# css classes must be written all in one line
# if you use quotes in font-family, use double quotes

raw_html = File.read("./test.html")
styles = File.read("./styles.css")

classes = raw_html.scan(/class=['"].+['"]/)

classes.each do |class_data|
	class_name = class_data.gsub(/class=['"]|['"]/, '')
	class_style = "style='#{styles.scan(/\.#{Regexp.escape(class_name)}{.*}/)[0].gsub(/.*{|}/,'')}'"
	raw_html.sub!(class_data, class_style)
end

puts raw_html

