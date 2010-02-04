# Main class for setting up the game ie. window size
class Setup

  # This is needed for handling input/events
  include Rubygame::EventHandler::HasEventHandler

  def initialize
	# Setting up the window screen
    @screen = Screen.new([320,480],0,[Rubygame::HWSURFACE,Rubygame::DOUBLEBUF])
	# Setting up the que to handle input events
	@queue = Rubygame::EventQueue.new()
	@queue.enable_new_style_events()
	@control = Controller.new(@screen)
	# Setting the intro screen image
	@intro_screen = Surface.load("graphics/intro_screen.png")
  end
  
  # For exiting out of the game	
  def quit
    Rubygame.quit()
    exit
  end

  # Handling input to exit the game	
  def hook_quit
	quit_hooks = {
	  :escape => :quit,
	  Rubygame::Events::QuitRequested => :quit,
	}
	make_magic_hooks(quit_hooks)
  end

  # Main loop for setup class
  def run
	hook_run()
	hook_quit()
	# Handling input
	loop do
	  @queue.each do |event|
		handle(event)
      end
	# Draw the image to screen
	@intro_screen.blit(@screen,[0,0])
	@screen.flip()
    end
  end
  
  # Handling input when pressing enter	
  def hook_run
	run_hook = {
	  :return => :execute
	}
	make_magic_hooks(run_hook)
  end

  # Executing the "run" method from the Control class	
  def execute
	@control.run()
  end

end
