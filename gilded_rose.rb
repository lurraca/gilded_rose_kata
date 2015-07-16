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
      else
        new(item)
      end
  end

  def update

    if name != AGED_BRIE && name != BACKSTAGE_PASS
      update_quality_by -1
    else
      update_quality_by 1
      if name == BACKSTAGE_PASS
        if sell_in < 11
          update_quality_by 1
        end
        if sell_in < 6
          update_quality_by 1
        end
      end
    end

    update_sell_in

    if sell_in < 0
      if name != AGED_BRIE
        if name != BACKSTAGE_PASS
          update_quality_by -1
        else
          update_quality_by -quality # in others word, set to 0.
        end
      else
        update_quality_by 1
      end
    end
  end

  def update_sell_in
    self.sell_in -= 1
  end

  def update_quality_by(delta)
    if delta < 0
      return unless quality > QUALITY_BOUNDS.min
    else
      return unless quality < QUALITY_BOUNDS.max
    end
    self.quality = quality + delta
  end
end

class SulfurasItem < ItemWrapper

  def update_sell_in
    # No updates for legendaries
  end

  def update_quality_by(delta)
    # No updates for legendaries
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

