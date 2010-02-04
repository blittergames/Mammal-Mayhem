# mammalmayhem.rb
# This is for executing the game
# Haroon Khalid
# 02/02/2010

require "rubygems"
require "rubygame"
require "lib/controller.rb"
require "lib/setup.rb"

include Rubygame

TTF.setup
setup = Setup.new()
setup.run()
	
