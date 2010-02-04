
class Animal type
  @type = type
  
  def greet
  
  if @type == "dog"
	print "hi dog"
  end
  end
end

d = Animal.new("dog")
d.greet
