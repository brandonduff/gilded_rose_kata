def update_quality(items)
  items.each(&:update)
end

class Item

  attr_accessor :name, :sell_in, :quality

  def self.new(name, sell_in, quality)
    item_class = subclasses.detect { |subclass| subclass.name == name }
    object = item_class.allocate
    object.initialize(sell_in, quality)
    object
  end

  def self.subclasses
    ObjectSpace.each_object(Class).select { |klass| klass <= self }
  end

  def self.name
    'NORMAL ITEM'
  end

  public def initialize(sell_in, quality)
    @sell_in = sell_in
    @quality = quality
  end

  def update
    @quality -= quality_scalar
    @sell_in -= sell_in_scalar
    quality_cap
  end

  private

  def sell_in_scalar
    1
  end

  def quality_cap
    @quality = 0 if @quality < 0
  end

  def quality_scalar
    @sell_in <= 0 ? 2 : 1
  end
end

class AgedBrie < Item
  def self.name
    'Aged Brie'
  end

  private

  def quality_scalar
    -super
  end

  def quality_cap
    @quality = 50 if @quality > 50
  end
end

class Sulfuras < Item
  def self.name
    'Sulfuras, Hand of Ragnaros'
  end

  private

  def quality_scalar
    0
  end

  def sell_in_scalar
    0
  end

  def quality_cap

  end
end

class BackstagePass < Item
  def self.name
    'Backstage passes to a TAFKAL80ETC concert'
  end

  private

  def quality_scalar
    if @sell_in > 10
      -1
    elsif @sell_in > 5
      -2
    elsif @sell_in > 0
      -3
    else
      @quality
    end
  end

  def quality_cap
    @quality = 50 if @quality > 50
  end
end

class ConjuredItem < Item
  def self.name
    'Conjured Mana Cake'
  end

  private

  def quality_scalar
    super * 2
  end
end
