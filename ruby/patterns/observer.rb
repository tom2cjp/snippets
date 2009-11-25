module ObserverPattern
  def initialize
    @observers = []
  end

  def register(observer)
    @observers << observer
  end

  def remove(observer)
    @observers.delete(observer)
  end

  def notify()
    @observers.each do |observer|
      observer.update(self)
    end
  end
end

# 煮包子的人class BunCook
  include ObserverPattern
  attr_reader :name
  attr_accessor :name, :status_know_bun_rape

  def initialize(name)
    super()
    @name = name
  end

  def call
    if status_know_bun_rape?
      puts "包子熟了，来吃啊"
      notify
    end
  end
end

# 饿汉
class HungryMan
  attr_reader :name
  
  def initialize(name)
    @name = name
  end
  
  def come
    puts "好， 来了"
  end

  def update
    come
  end
end

# 不饿的人
class FullMan
  attr_reader :name
  
  def initialize(name)
    @name = name
  end

  def programming
    puts "programming"
  end

  def update
    programming
  end
end

linx = Observer.new("linx")
hammer = HungryMan.new("hammer")
tommy = FullMan.new("tommy")
linx.register(hammer)
linx.register(tommy)
linx.status_know_bun_rape = true
linx.cry
