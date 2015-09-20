#CSS Style Inliner

CSS Style Inliner is a Ruby script to aid HTML email development by taking a stylesheet with single element or class selectors (id selectors, comma delimited selectors or nested selectors are not supported at this time) and in-lining the styles as a style attribute in the relevant HTML element.

##Dependencies

* Ruby 2.*
* Nokogiri

##Getting Started

* Download or clone the project and `cd` into the project directory
* If you don't have Nokogiri already installed, type `gem install nokogiri`
* Type `ruby css-style-inliner.rb` to run the script with the sample input files
* Edit the `INPUT_HTML_PATH` constant inside the ` css-style-inliner.rb` file to point to your HTML file

##License

CSS Style Inliner is released under the MIT License. See license.txt for more details.