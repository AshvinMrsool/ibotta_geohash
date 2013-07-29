=begin
geohash.rb
Pure ruby GeoHashing library, updated and cleaned up by Justin Hart @ Ibotta.com


Based on:
https://github.com/masuidrive/pr_geohash
Geohash library for pure ruby
Distributed under the MIT License

Based on:
// http://github.com/davetroy/geohash-js/blob/master/geohash.js
// geohash.js
// Geohash library for Javascript
// (c) 2008 David Troy
// Distributed under the MIT License
=end

module GeoHash
  VERSION = "0.1"

  # Decode bounding box from geohash string
  #
  # == Parameters:
  # geohash:: geohash string
  #
  # == Returns:
  # decoded bounding box [[north latitude, west longitude],[south latitude, east longitude]]
  def decode(geohash)
    latlng = [[-90.0, 90.0], [-180.0, 180.0]]
    is_lng = 1
    geohash.downcase.scan(/./) do |c|
      BITS.each do |mask|
        latlng[is_lng][(BASE32.index(c) & mask)==0 ? 1 : 0] = (latlng[is_lng][0] + latlng[is_lng][1]) / 2
        is_lng ^= 1
      end
    end
    latlng.transpose
  end
  module_function :decode

  # Encode latitude and longitude into geohash
  #
  # == Parameters:
  # latitude:: float latitude point
  # longitude:: float longitude point
  # precision:: number of characters as precision
  #
  # == Returns:
  # encoded geohash string
  def encode(latitude, longitude, precision=12)
    latlng = [latitude, longitude]
    points = [[-90.0, 90.0], [-180.0, 180.0]]
    is_lng = 1
    (0...precision).map do
      ch = 0
      5.times do |bit|
        mid = (points[is_lng][0] + points[is_lng][1]) / 2
        points[is_lng][latlng[is_lng] > mid ? 0 : 1] = mid
        ch |=  BITS[bit] if latlng[is_lng] > mid
        is_lng ^= 1
      end
      BASE32[ch,1]
    end.join
  end
  module_function :encode

  # Calculate each 8 direction neighbors as geohash
  #
  # == Parameters:
  # geohash:: string center geohash
  #
  # == Returns:
  # array of neighbors from top clockwise (top, topright, right...)
  def neighbors(geohash)
    [[:top, :right], [:right, :bottom], [:bottom, :left], [:left, :top]].map do |dirs|
      point = adjacent(geohash, dirs[0])
      [point, adjacent(point, dirs[1])]
    end.flatten
  end
  module_function :neighbors

  # calculate one adjacent neighbor
  #
  # == Parameters:
  # geohash:: string origin geohash
  # dir:: which direction to get a geohash of (only top, right, bottom, left)
  #
  # == Returns:
  # string geohash of neighbor
  def adjacent(geohash, dir)
    if geohash == ''
      geohash
    else
      base, lastChr = geohash[0..-2], geohash[-1,1]
      type = (geohash.length % 2)==1 ? :odd : :even
      if BORDERS[dir][type].include?(lastChr)
        base = adjacent(base, dir)
      end
      base + BASE32[NEIGHBORS[dir][type].index(lastChr),1]
    end
  end
  module_function :adjacent

  BITS = [0x10, 0x08, 0x04, 0x02, 0x01].freeze
  BASE32 = "0123456789bcdefghjkmnpqrstuvwxyz".freeze

  NEIGHBORS = {
    :right  => { :even => "bc01fg45238967deuvhjyznpkmstqrwx", :odd => "p0r21436x8zb9dcf5h7kjnmqesgutwvy" },
    :left   => { :even => "238967debc01fg45kmstqrwxuvhjyznp", :odd => "14365h7k9dcfesgujnmqp0r2twvyx8zb" },
    :top    => { :even => "p0r21436x8zb9dcf5h7kjnmqesgutwvy", :odd => "bc01fg45238967deuvhjyznpkmstqrwx" },
    :bottom => { :even => "14365h7k9dcfesgujnmqp0r2twvyx8zb", :odd => "238967debc01fg45kmstqrwxuvhjyznp" }
  }.freeze

  BORDERS = {
    :right  => { :even => "bcfguvyz", :odd => "prxz" },
    :left   => { :even => "0145hjnp", :odd => "028b" },
    :top    => { :even => "prxz"    , :odd => "bcfguvyz" },
    :bottom => { :even => "028b"    , :odd => "0145hjnp" }
  }.freeze

end # module GeoHash
