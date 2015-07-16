require 'delegate'

class ItemWrapper < SimpleDelegator

  AGED_BRIE = 'Aged Brie'
  BACKSTAGE_PASS = 'Backstage passes to a TAFKAL80ETC concert'
  SULFURAS = 'Sulfuras, Hand of Ragnaros'

  QUALITY_BOUNDS = [0, 50]

  def self.wrap(item)
    case item.name
    when SULFURAS
      SulfurasItem.new(item)
    when AGED_BRIE
      AgedBrieItem.new(item)
    when BACKSTAGE_PASS
      BackstagePassItem.new(item)
    else
      new(item)
    end
  end

  def update
    update_quality
    update_sell_in
  end

  def update_sell_in
    self.sell_in -= 1
  end

  def update_quality
    return if QUALITY_BOUNDS.include?(quality)
    return self.quality = quality + past_expiration if expired?
    self.quality = quality + quality_delta
  end

  def quality_delta
    -1
  end

  def past_expiration
    quality_delta * 2
  end

  def expired?
    sell_in <= 0
  end
end

class SulfurasItem < ItemWrapper
  def update_sell_in
    # No updates for legendaries
  end

  def update_quality
    # No updates for legendaries
  end
end

class AgedBrieItem < ItemWrapper
  def quality_delta
    -super
  end
end

class BackstagePassItem < ItemWrapper
  def quality_delta
    if sell_in < 6
      3
    elsif sell_in < 11
      2
    else
      1
    end
  end

  def past_expiration
    -quality
  end
end

def update_quality(items)
  items.each do |item|
    ItemWrapper.wrap(item).update
  end
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

