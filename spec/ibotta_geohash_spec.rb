require 'spec_helper'

describe IbottaGeohash do
  it 'version' do
    expect(described_class::VERSION).not_to be nil
  end

  describe "::decode" do
    it 'known' do
      {
        'c216ne' => [[45.3680419921875, -121.70654296875], [45.37353515625, -121.695556640625]],
        'C216Ne' => [[45.3680419921875, -121.70654296875], [45.37353515625, -121.695556640625]],
        'dqcw4'  => [[39.0234375, -76.552734375], [39.0673828125, -76.5087890625]],
        'DQCW4'  => [[39.0234375, -76.552734375], [39.0673828125, -76.5087890625]],
        'ezs42'  => [[ 42.5830078125, -5.625], [42.626953125, -5.5810546875]]
      }.each do |hash, latlng|
        expect(described_class.decode(hash)).to eq latlng
      end
    end
    it 'random fuzz' do
      1024.times do
        len = rand(1..12)
        hash = len.times.map { described_class::BASE32.each_char.to_a.sample(1) }.join("")
        s, w, n, e = described_class.decode(hash).flatten

        expect(s).to be_between(-90, 90)
        expect(n).to be_between(-90, 90)
        expect(s < n).to eq true

        expect(w).to be_between(-180, 180)
        expect(e).to be_between(-180, 180)
        expect(w < e).to eq true
      end
    end
  end

  describe "::identity" do
    it 'known' do
      %w(7 2 8 r z dk zc zcp dr5r pbpb dqcw5 ezs42 xn774c gcpuvpk c23nb62w).each do |hash|
        dec = described_class.decode_center(hash)
        expect(described_class.encode(*dec, hash.size)).to eq hash
      end
    end
    it 'random fuzz' do
      1024.times do
        len = rand(1..12)
        hash = len.times.map { described_class::BASE32.each_char.to_a.sample(1) }.join("")
        dec = described_class.decode_center(hash)
        expect(described_class.encode(*dec, hash.size)).to eq hash
      end
    end
  end

  describe "::encode" do
    it 'known' do
      {
        [ 45.37,      -121.7      ] => 'c216ne',
        [ 47.6062095, -122.3320708] => 'c23nb62w20sth',
        [ 35.6894875,  139.6917064] => 'xn774c06kdtve',
        [-33.8671390,  151.2071140] => 'r3gx2f9tt5sne',
        [ 51.5001524,   -0.1262362] => 'gcpuvpk44kprq',
        [ 37.8324, 112.5584] => 'ww8p1r4t8',
        [ 42.6, -5.6] => 'ezs42',
      }.each do |latlng, hash|
        expect(described_class.encode(latlng[0], latlng[1], hash.length)).to eq hash
      end
    end
    it 'random fuzz' do
      1024.times do
        len = rand(1..12)
        lat = rand(-90.0..90.0)
        lng = rand(-180.0..180.0)
        expect(described_class.encode(lat, lng, len).size).to eq len
      end
    end
  end

  describe "::neighbors" do
    it 'simple known' do
      {
        '7' => ["4", "5", "6", "d", "e", "h", "k", "s"],
        'dk' => ["d5", "d7", "de", "dh", "dj", "dm", "ds", "dt"],
        'dr5r' => ["dr72", "dr78", "dr5x", "dr5w", "dr5q", "dr5n", "dr5p", "dr70"],
        'dqcw5' => ["dqcw7", "dqctg", "dqcw4", "dqcwh", "dqcw6", "dqcwk", "dqctf", "dqctu"],
        'ezs42' => ['ezefr', 'ezs43', 'ezefx', 'ezs48', 'ezs49', 'ezefp', 'ezs40', 'ezs41'],
        'xn774c' => ['xn774f','xn774b','xn7751','xn7749','xn774d','xn7754','xn7750','xn7748'],
        'gcpuvpk' => ['gcpuvps','gcpuvph','gcpuvpm','gcpuvp7','gcpuvpe','gcpuvpt','gcpuvpj','gcpuvp5'],
        'c23nb62w' => ['c23nb62x','c23nb62t','c23nb62y','c23nb62q','c23nb62r','c23nb62z','c23nb62v','c23nb62m'],
      }.each do |hash, neighbors|
        expect(described_class.neighbors(hash)).to match_array neighbors
      end
    end

    it 'spanning dateline known' do
      {
        "2" => ["0", "1", "3", "8", "9", "p", "r", "x"],
        "r" => ["0", "2", "8", "n", "p", "q", "w", "x"],
      }.each do |hash, neighbors|
        expect(described_class.neighbors(hash)).to match_array neighbors
      end
    end

    it 'on borders' do
      {
        '8' => ['b', 'c', '9', '3', '2', 'r', 'x', 'z'],
        'bpbp' => ['bpbr', 'bpbq', 'bpbn', 'zzzy', 'zzzz'],
        'z' => ['w', 'x', 'y', '8', 'b'],
        'zc' => ["zf", "b4", "b1", "b0", "zb", "z8", "z9", "zd"],
        'zcp' => ["zcr", "b12", "b10", "b0b", "zbz", "zby", "zcn", "zcq"],
      }.each do |hash, neighbors|
        expect(described_class.neighbors(hash)).to match_array neighbors
      end
    end
    it 'random' do
      1024.times do
        len = rand(1..12)
        hash = len.times.map { described_class::BASE32.each_char.to_a.sample(1) }.join("")
        ns = described_class.neighbors(hash)
        expect(ns).to_not include(hash)
        expect(ns.size > 2).to eq true #todo what is min neighbors anyway? 5?
      end
    end
  end

  describe "::adjacent" do
    it 'known' do
      {
        ["dqcjq", :top]    => 'dqcjw',
        ["dqcjq", :bottom] => 'dqcjn',
        ["dqcjq", :left]   => 'dqcjm',
        ["dqcjq", :right]  => 'dqcjr'
      }.each do |position, hash|
        expect(described_class.adjacent(*position)).to eq hash
      end
    end
    it 'random' do
      1024.times do
        len = rand(1..12)
        hash = len.times.map { described_class::BASE32.each_char.to_a.sample(1) }.join("")
        dir = described_class::NEIGHBORS.keys.sample(1).first
        adj = described_class.adjacent(hash, dir)
        #random here is hard because it has to be somewhat valid. for now, just ensure it doesnt barf
      end
    end
  end

  describe "::areas_by_radius" do
    it 'known' do
      p area = described_class.areas_by_radius(45.37, -121.7, 50)
      p "----------"
      p area = described_class.areas_by_radius(45.37, -121.7, 50_000)
    end
    it 'random' do
      1024.times do
        lat = rand(-90.0..90.0)
        lng = rand(-180.0..180.0)
        radius = rand(1..900_000)
        ns = described_class.areas_by_radius(lat,lng,radius)
        expect(ns).to_not be_empty
      end
    end
  end

  describe "::estimate_steps_by_radius" do
    it 'known'
    it 'random' do
      1024.times do
        steps = described_class.estimate_steps_by_radius(rand(1..900_000))
        expect(steps > 0).to eq true
      end
    end
  end

  #todo having trouble finding any references to go off of for this to create tests
  describe "::bounding_box" do
    it 'known' do
      s,w,n,e = box = described_class.bounding_box(51, 7, 111000)
      expect(s).to be_within(0.01).of(50)
      expect(w).to be_within(0.01).of(5.41)
      expect(n).to be_within(0.01).of(51.99)
      expect(e).to be_within(0.01).of(8.58)
    end
    it 'random' do
      1024.times do
        radius = rand(1..described_class::MERCATOR.max)
        lat = rand(-90.0..90.0)
        lng = rand(-180.0..180.0)
        s, w, n, e = box = described_class.bounding_box(lat, lng, radius)
        # p lat, lng, radius, box

        # expect(s).to be_between(-90, 90)
        # expect(n).to be_between(-90, 90)
        expect(s < n).to eq true

        # expect(w).to be_between(-180, 180)
        # expect(e).to be_between(-180, 180)
        expect(w < e).to eq true
      end
    end
  end
end
