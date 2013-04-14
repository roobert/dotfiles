require 'rubygems'

begin
    require 'ap' # Awesome Print
    require 'net-http-spy' # Print information about any HTTP requests being made
rescue => e
    puts e
    puts '!'
end

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
  # what methods are here that are not present on basic objects?
  def interesting_methods
    (self.methods - Object.new.methods).sort
  end

   def which_method(method_name)
      self.method(method_name.to_sym)
   end
end

puts 'loaded .irbrc!'

require 'boson/console'

