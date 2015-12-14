# Pure Ruby Geohash

This is a pure Ruby implementation of the [Geohash](http://en.wikipedia.org/wiki/Geohash) encoding.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ibotta_geohash'
```

And then execute:

    $ `bundle`

Or install it yourself as:

    $ `gem install ibotta_geohash`

## Usage

```ruby
require 'ibotta_geohash'
```

Encode a latitude and longitude into a geohash

```ruby
GeoHash.encode(47.6062095, -122.3320708, 6)
# => "c23nb62w20st"
```

Decode a geohash into a bounding box

```ruby
GeoHash.decode("c23nb6")
 # => [[47.603759765625, -122.332763671875], [47.6092529296875, -122.32177734375]]
```

Calculate ajacent hashes

```ruby
GeoHash.neighbors("xn774c")
# => ["xn774f", "xn7754", "xn7751", "xn7750", "xn774b", "xn7748", "xn7749", "xn774d"]
```

Calculate hashes covering a radius

```ruby
GeoHash.areas_by_radius(45.37, -121.7, 50_000)
# => ["c216nekg2", "c216nekg8", "c216nekg9", "c216nekg3", "c216nekg1", "c216nekg0", "c216nekep", "c216neker", "c216nekex"]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Known issues

* This pure ruby implementation is not fast.
  * There are micro-optimizations, but a native C gem will be faster
  * David Troy's geohash gem does not compile under Ruby 2
  * Currently working on using C code from the Redis project
  * Possible to convert to using integer math instead (like C)
* Ordering and structure of return types is not ideal

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Ibotta/ibotta_geohash. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Forked From

http://github.com/masuidrive/pr_geohash

### Original LICENSE:

> (The MIT License)

> Copyright (c) 2009 [Yuichiro MASUI](http://masuidrive.jp)

> Permission is hereby granted, free of charge, to any person obtaining
> a copy of this software and associated documentation files (the
> 'Software'), to deal in the Software without restriction, including
> without limitation the rights to use, copy, modify, merge, publish,
> distribute, sublicense, and/or sell copies of the Software, and to
> permit persons to whom the Software is furnished to do so, subject to
> the following conditions:

> The above copyright notice and this permission notice shall be
> included in all copies or substantial portions of the Software.

> THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
> EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
> IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
> CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
> TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
> SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

### Based library is

> http://github.com/davetroy/geohash-js/blob/master/geohash.js

> Geohash library for Javascript
> Copyright (c) 2008 David Troy, Roundhouse Technologies LLC
> Distributed under the MIT License
