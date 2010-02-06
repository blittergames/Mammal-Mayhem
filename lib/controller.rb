class Score

  def initialize screen, points
    @screen = screen
    @font = TTF.new("fonts/LVDCGO__.TTF",18)
    @score = points
    @text_str = "#{@score}"
	@text = @font.render(@text_str,false,[242,0,255])
  end
  
  def update
  	@text.blit(@screen, [150,10])
  end
end


class Landing
attr_accessor :screen, :rect
  def initialize screen
  
    @screen = screen
    @img = Surface.load("graphics/tank.png")
	@rect = @img.make_rect
	@rect.x = 150
	@rect.y = 455
  end
  
  def update
    @img.blit(@screen,[@rect.x,@rect.y])
    #@screen.flip()
  end
  
end

class Mammal
	include Rubygame::EventHandler::HasEventHandler
	attr_accessor :queue, :screen, :x, :y, :direction, :rect
	def initialize screen, speed, x, y
		@screen = screen
		@img = Surface.load("graphics/whale.png")
		@rect = @img.make_rect
	    @rect.x = x
		@rect.y = y
		@speed = speed
		@direction = "left"
	end
			
		def update
			if @direction == "left"
				@rect.x -= @speed
				
			else
				@rect.y += @speed + 5
			end
			@img.blit(@screen,[@rect.x,@rect.y])
			#@screen.flip()
		end
	end

	class Player
		include Rubygame::EventHandler::HasEventHandler
		attr_accessor :queue, :screen, :x, :y, :load, :score, :speed, :tank, :points, :text, :score_sdn
		def initialize screen
		  @screen = screen
		  @queue = Rubygame::EventQueue.new()
		  @queue.enable_new_style_events()
		@img = Surface.load("graphics/helicopter.png")
		@points = 0
	    @x = 300
		@y = 50
		@speed = 2
		@load_x = @x + 30
		@load_y = @y + 34
		@load = Mammal.new(screen, @speed, @load_x, @load_y)
		@tank = Landing.new(screen)
		@score = Score.new(screen, @points)
		
      @font = TTF.new("fonts/LVDCGO__.TTF",18)
      @text_str = "#{@points}"
	  @text = @font.render(@text_str,false,[242,0,255])
	  @score_snd = Sound.load("sounds/score.ogg")
	end
	
	def release
		puts 'spacebar key hit!'
		#call release function for mammal to go vertical
		@load.direction = "down"
	end
	
	def movement_hook
		movement_hooks = {
		:space => :release,
		}
		make_magic_hooks(movement_hooks)
	end	
	
	def move    
		@queue.each do |event|
		handle(event)
		end
	end
	
	def check_hit
	  if @load.rect.collide_rect?(@tank.rect)
		@score_snd.play
		puts "hit! points: #{@points}"
		@points += 10
		@text_str = "#{@points}"
		@text = @font.render(@text_str,false,[242,0,255])
		puts "hit!! points: #{@points}"
	  end
	end
			
	def update
	    @x -= @speed
		@img.blit(@screen,[@x,@y])
		check_hit
		@text.blit(@screen,[10,10])
		@load.update
		@tank.update
		#@score.update
		@screen.flip()
	end
end


class Controller
    include Rubygame::EventHandler::HasEventHandler
    def initialize screen
		@screen = screen
		@queue = Rubygame::EventQueue.new()
		@queue.enable_new_style_events()
		@clock = Rubygame::Clock.new()
		@clock.target_framerate = 30
		@p1 = Player.new(@screen)
	end

	def quit
		Rubygame.quit()
		exit
	end

	def hook_quit
		quit_hooks = {
		:escape => :quit,
		Rubygame::Events::QuitRequested => :quit
		}
		make_magic_hooks(quit_hooks)
		
		hook = {
			:owner => @p1,
			:trigger => Rubygame::EventTriggers::YesTrigger.new(),
			:action => Rubygame::EventActions::MethodAction.new(:handle)
			}
		append_hook(hook)
		
	end
  
    def fps_update()
        @screen.title = "FPS: #{@clock.framerate()}" 
    end
  
	def run
	  	@p1.movement_hook()
		hook_quit()
		loop do
			@queue.each do |event|
				#puts "This is the controller."
				handle(event)
			end
			fps_update()
			@screen.fill([0,0,0])
			@p1.move()
			@p1.update()
			@screen.flip()
			@clock.tick()
		end
	end
end
