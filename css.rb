module CSS
	class CSSStyle
		include Comparable
		attr_reader :selector, :style, :specificity
		#css_style_declaration css for both selector and style e.g. body{ margin: 0 auto}
		def initialize(css_style_declaration)
			css_style_declaration.gsub!("\n", '') #make sure all on one line
			@selector = css_style_declaration.scan(/.+{/)[0].gsub(/[{]/,'')
			@style = css_style_declaration.gsub(/[{}]|#{@selector}/, '')
			@specificity = calculate_specificity()
		end

		def to_s()
			@selector + '{' + @style + '}'
		end

		def <=> other
    		specificity = @specificity
    		other_specificity = other.specificity
    		if specificity[:id] != other_specificity[:id]
    			specificity[:id] <=> other_specificity[:id]
    		elsif specificity[:class] != other_specificity[:class]
    			specificity[:class] <=> other_specificity[:class]
    		else
    			specificity[:element] <=> other_specificity[:element]
    		end
  		end

		#based on http://www.sitepoint.com/web-foundations/specificity/ calculations
		#not worrying about pseudo-elements or pseudo-classes since that's not going to work on inline styles anyway
		def calculate_specificity()
			specificity = Hash.new
			#counts ids in selector
			specificity[:id] = @selector.scan(/#/).size
			#counts classes and attributes in selector
			specificity[:class] = @selector.scan(/\.|\[/).size
			specificity[:element] = @selector.scan(/^[\s]*[\w-]+|[\s>]+[\w-]+/).size
			specificity
		end
	end
end