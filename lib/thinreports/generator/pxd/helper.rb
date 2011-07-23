# coding: utf-8

require 'erb'

module ThinReports
  module Generator
    
    # @private
    module Pxd::Helper
    private
      
      def content_tag(tag_name, content = nil, attrs = nil, options = {})
        content = h(content) unless options[:escape] == false
        tag(tag_name, attrs, true) << content.to_s << "</#{h(tag_name)}>"
      end
      
      def tag(tag_name, attrs = nil, open = false)
        attrs = tag_attributes(attrs)
        attrs = ' ' + attrs unless attrs.blank?
        "<#{h(tag_name)}#{attrs}#{open ? '' : ' /'}>"
      end
      
      def tag_attributes(attrs)
        attrs && attrs.map{|k, v| "#{h(k)}=\"#{h(v)}\"" }.join(' ')
      end
      
      def h(s)
        ERB::Util.html_escape(s)
      end
    end
    
  end
end