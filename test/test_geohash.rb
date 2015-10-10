require 'geohash'
require 'test/unit'

class PrGeoHashTests < Test::Unit::TestCase
  def test_decode
    {
      'c216ne' => [[45.3680419921875, -121.70654296875], [45.37353515625, -121.695556640625]],
      'C216Ne' => [[45.3680419921875, -121.70654296875], [45.37353515625, -121.695556640625]],
      'dqcw4'  => [[39.0234375, -76.552734375], [39.0673828125, -76.5087890625]],
      'DQCW4'  => [[39.0234375, -76.552734375], [39.0673828125, -76.5087890625]],
      'ezs42'  => [[ 42.5830078125, -5.625], [42.626953125, -5.5810546875]]
    }.each do |hash, latlng|
      assert_equal GeoHash.decode(hash), latlng
    end
  end

  def test_identity
    %w(7 2 8 r z dk zc zcp dr5r pbpb dqcw5 ezs42 xn774c gcpuvpk c23nb62w).each do |hash|
      dec = GeoHash.decode_center(hash)
      assert_equal hash, GeoHash.encode(*dec, hash.size)
    end
  end

  def test_encode
    {
      [ 45.37,      -121.7      ] => 'c216ne',
      [ 47.6062095, -122.3320708] => 'c23nb62w20sth',
      [ 35.6894875,  139.6917064] => 'xn774c06kdtve',
      [-33.8671390,  151.2071140] => 'r3gx2f9tt5sne',
      [ 51.5001524,   -0.1262362] => 'gcpuvpk44kprq',
      [ 37.8324, 112.5584] => 'ww8p1r4t8',
      [ 42.6, -5.6] => 'ezs42',
    }.each do |latlng, hash|
      assert_equal GeoHash.encode(latlng[0], latlng[1], hash.length), hash
    end
  end

  def test_neighbors
    #simple
    {
      '7' => ["4", "5", "6", "d", "e", "h", "k", "s"],
      'dk' => ["d5", "d7", "de", "dh", "dj", "dm", "ds", "dt"],
      'dr5r' => ["dr72", "dr78", "dr5x", "dr5w", "dr5q", "dr5n", "dr5p", "dr70"],
      'dqcw5' => ["dqcw7", "dqctg", "dqcw4", "dqcwh", "dqcw6", "dqcwk", "dqctf", "dqctu"],
      'ezs42' => ['ezefr', 'ezs43', 'ezefx', 'ezs48', 'ezs49', 'ezefp', 'ezs40', 'ezs41'],
      'xn774c' => ['xn774f','xn774b','xn7751','xn7749','xn774d','xn7754','xn7750','xn7748'],
      'gcpuvpk' => ['gcpuvps','gcpuvph','gcpuvpm','gcpuvp7','gcpuvpe','gcpuvpt','gcpuvpj','gcpuvp5'],
      'c23nb62w' => ['c23nb62x','c23nb62t','c23nb62y','c23nb62q','c23nb62r','c23nb62z','c23nb62v','c23nb62m'],
    }.each do |geohash, neighbors|
      assert_equal GeoHash.neighbors(geohash).sort, neighbors.sort
    end

    #dateline
    {
      "2" => ["0", "1", "3", "8", "9", "p", "r", "x"],
      "r" => ["0", "2", "8", "n", "p", "q", "w", "x"],
    }.each do |geohash, neighbors|
      assert_equal GeoHash.neighbors(geohash).sort, neighbors.sort
    end

    #borders
    {
      '8' => ['b', 'c', '9', '3', '2', 'r', 'x', 'z'],
      'bpbp' => ['bpbr', 'bpbq', 'bpbn', 'zzzy', 'zzzz'],
      'z' => ['w', 'x', 'y', '8', 'b'],
      'zc' => ["zf", "b4", "b1", "b0", "zb", "z8", "z9", "zd"],
      'zcp' => ["zcr", "b12", "b10", "b0b", "zbz", "zby", "zcn", "zcq"],
    }.each do |geohash, neighbors|
      assert_equal GeoHash.neighbors(geohash).sort, neighbors.sort
    end
  end

  def test_adjacent
    {
      ["dqcjq", :top]    => 'dqcjw',
      ["dqcjq", :bottom] => 'dqcjn',
      ["dqcjq", :left]   => 'dqcjm',
      ["dqcjq", :right]  => 'dqcjr'
    }.each do |position, hash|
      assert_equal GeoHash.adjacent(*position), hash
    end
  end

  def test_area
    p area = GeoHash.areas_by_radius(45.37, -121.7, 50)
    p "----------"
    p area = GeoHash.areas_by_radius(45.37, -121.7, 50_000)
  end

end
