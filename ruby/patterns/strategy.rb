class BattleFiled
  attr_accessor :army_num, :wit, :force

  def get_army_num_after_tricked(trick_type)
    trick_type.calc(army_num, wit, force)
  end
end

# 计谋
class Trick
  def calc(army_num, wit, force)
    raise 'don't call me'
  end
end

# 火计
class Fire < Trick
  def calc(army_num, wit, force)
    puts '智x13/10+30 '
    army_num -= wit * 13 / 10 + 30
  end
end

# 要击
class SneakAttack < Trick
  def calc(army_num, wit, force)
    puts '(武x20)/10'
    army_num -= force * 20 / 10
  end
end

# 落石
class RockFall < Trick
  def calc(army_num, wit, force)
    puts '330+(武+智)/2'
    army_num -= 330 + (wit + force) / 2
  end
end


bf = BattleFiled.new
bf.army_num = 1000

# 孔明
bf.force = 62
bf.wit = 99

bf.get_army_num_after_tricked(RockFall.new)
bf.get_army_num_after_tricked(Fire.new)
