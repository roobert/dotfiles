require 'rubygems'

require 'ap' # Awesome Print
require 'net-http-spy' # Print information about any HTTP requests being made
require 'looksee'

IRB.conf[:USE_READLINE] = true
IRB.conf[:AUTO_INDENT]  = false

# Save History between irb sessions
require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"

# Enable colored output
require 'wirble'
Wirble.init
Wirble.colorize

# the default colors suck, mod to use your own
colors = Wirble::Colorize.colors.merge({
   # set the comma color to blue
   :comma => :green,
   :refers => :green,
})

Wirble::Colorize.colors = colors

# Bash-like tab completion
require 'bond'
Bond.start

IRB.conf[:PROMPT_MODE] = :SIMPLE

class Object
  def interesting_methods
    ap (self.methods - Object.new.methods).sort
  end

  alias_method :show_methods,  :interesting_methods
  alias_method :print_methods, :interesting_methods
  alias_method :list_methods,  :interesting_methods
end

require 'boson/console'

# if you don't see this then irbrc silently failed somewhere, try: ruby ~/.irbrc
puts 'loaded .irbrc!'

