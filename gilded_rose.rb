require 'delegate'

class ItemWrapper < SimpleDelegator

  AGED_BRIE = 'Aged Brie'
  BACKSTAGE_PASS = 'Backstage passes to a TAFKAL80ETC concert'
  SULFURAS = 'Sulfuras, Hand of Ragnaros'

  QUALITY_BOUNDS = [0, 50]

  def update

    if name != AGED_BRIE && name != BACKSTAGE_PASS
      if quality > QUALITY_BOUNDS.min
        if name != SULFURAS
          update_quality_by -1
        end
      end
    else
      if quality < QUALITY_BOUNDS.max
        update_quality_by 1
        if name == BACKSTAGE_PASS
          if sell_in < 11
            if quality < QUALITY_BOUNDS.max
              update_quality_by 1
            end
          end
          if sell_in < 6
            if quality < QUALITY_BOUNDS.max
              update_quality_by 1
            end
          end
        end
      end
    end

    update_sell_in

    if sell_in < QUALITY_BOUNDS.min
      if name != AGED_BRIE
        if name != BACKSTAGE_PASS
          if quality > QUALITY_BOUNDS.min
            if name != SULFURAS
              update_quality_by -1
            end
          end
        else
          update_quality_by -quality # in others word, set to 0.
        end
      else
        if quality < QUALITY_BOUNDS.max
          update_quality_by 1
        end
      end
    end
  end

  def update_sell_in
    return if name == SULFURAS
    self.sell_in -= 1
  end

  def update_quality_by(delta)
    self.quality = quality + delta
  end
end

def update_quality(items)
  items.each do |item|
    ItemWrapper.new(item).update
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

