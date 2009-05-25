# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def api_table(name = false,*labels,&block)
    table = ItemTable.new
    yield table
    concat(subhead(name)) if name
    concat(render(:partial => 'components/api_table', :locals => {:items => table.items,:labels => labels}))
  end
  
  def options_table(name = false,*labels,&block)
    table = ItemTable.new
    yield table
    concat(subhead(name)) if name
    concat(render(:partial => 'components/options_table', :locals => {:items => table.items,:labels => labels}))
  end
  
  def events_table(name = false,*labels,&block)
    table = ItemTable.new
    yield table
    concat(subhead(name)) if name
    concat(render(:partial => 'components/events_table', :locals => {:items => table.items,:labels => labels}))
  end
  
  def examples_table(name = false,*labels,&block)
    table = ItemTable.new(false)
    yield table
    concat(subhead(name)) if name
    concat(render(:partial => 'components/examples_table', :locals => {:items => table.items,:labels => labels}))
  end
  
  class ItemTable	  
	  def initialize(sort = true)
	    @sort = sort
	    @items = []
	  end
	  
	  def item(item)
	    @items.push(item)
	  end
	  
	  def items
	    return @items if !@sort
	    @items.sort_by do |item|
	      if item[:signature]
	        if item[:signature].match(/^\s?(initialize|load)\(/)
	          "1"
	        elsif !item[:signature].match(/^\s?[\w\_]+\s?\(/)
	          "zzz" + item[:signature]
	        else
	          item[:signature]
	        end
	      elsif item[:name]
	        item[:name]
	      else
	        ""
	      end
	    end
	  end
	end
	
	def javascript(name = false,&block)
	  concat(subhead(name)) if name
	  concat('<pre class="highlighted"><code class="javascript">')
    yield
	  concat('</code></pre>')
	end
	
	def html(name = false,&block)
	  concat(subhead(name)) if name
	  concat('<pre class="highlighted"><code class="xml">')
    yield
	  concat('</code></pre>')
	end
	
	def css(name = false,&block)
	  concat(subhead(name)) if name
	  concat('<pre class="highlighted"><code class="css">')
    yield
	  concat('</code></pre>')
	end
	
	def header(name = '',&block)
	  if block_given?	  
  	  concat('<h1>')
  	  yield
  	  concat('</h1>')
	  else
	    "<h1>#{name}</h1>"
	  end
	end
	
	def subhead(name = '',options = {},&block)
	  if block_given?
  	  concat('<h3' + (options[:border] === false ? ' class="borderless"' : '') + '>')
  	  yield
  	  concat('</h3>')
    else
      "<h3" + (options[:border] === false ? ' class="borderless"' : '') + ">#{name}</h3>"
    end
	end
	
	def introduction(introduction = '',&block)
	  if block_given?
  	  concat('<p class="introduction">')
  	  yield
  	  concat('</p>')
	  else
	    "<p class=\"introduction\">#{introduction}</p>"
	  end
	end
	
	def paragraph(name = false,&block)
	  concat(subhead(name)) if name
	  concat('<p>')
	  yield
	  concat('</p>')
  end
  
  def section(id,&block)
	  concat("<div id=\"#{id}\">")
	  yield
	  concat('</div>')
  end
  
  def tabs(id,&block)
    tabs = Tabs.new(id)
    yield tabs
    concat(render(:partial => 'components/tabs',:locals => {:tabs => tabs}))
  end
  
  class Tabs
    attr_reader :tabs, :id, :source, :li_id
    
    def initialize(id)
      @li_id = li_id
      @id = id
      @tabs = []
      @source = nil
    end
    
    def tab(id,label,li_id = nil)
      @tabs.push({
        :id => id,
        :label => label,
        :li_id => li_id
      })
    end
    
    def source(url = false)
      return @source if !url
      @source = url
    end
  end

  [
    "contextmenu",
    "pagination",
    "progressbar",
    "rating",
    "scrollbar",
    "selection",
    "selectmultiple",
    "tabs",
    "textarea",
    "window"
  ].each do |control|
    eval "def control_#{control}_url; control_url :control => '#{control}' end"
  end
end
