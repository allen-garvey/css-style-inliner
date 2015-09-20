module CSS
	class CSSStyle
		attr_reader :selector, :style
		#css_style_declaration css for both selector and style e.g. body{ margin: 0 auto}
		def initialize(css_style_declaration)
			css_style_declaration.gsub!("\n", '') #make sure all on one line
			@selector = css_style_declaration.scan(/.+{/)[0].gsub(/[{]/,'')
			@style = css_style_declaration.gsub(/[{}]|#{@selector}/, '')
		end

		def to_s()
			@selector + '{' + @style + '}'
		end
		
	end
end