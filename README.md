# Minuteman

![Minuteman](http://upload.wikimedia.org/wikipedia/commons/thumb/4/4b/Minute_Man_Statue_Lexington_Massachusetts_cropped.jpg/220px-Minute_Man_Statue_Lexington_Massachusetts_cropped.jpg)

Fast analytics using Redis bitwise operations

## Origin


**conanbatt:** anyone here knows some good web app metrics tool ?

**conanbatt:** i use google analytics for the page itself, and its good, but for the webapp its really not useful

**tizoc: conanbatt:** [http://amix.dk/blog/post/19714]() you can port this (if an equivalent doesn't exist already)

**conanbatt:** the metrics link is excellent but its python and released 5 days ago lol

**elcuervo: tizoc:** the idea it's awesome

**elcuervo:** interesting...


## Inspiration

* [http://blog.getspool.com/2011/11/29/fast-easy-realtime-metrics-using-redis-bitmaps/]()
* [http://amix.dk/blog/post/19714]()
* [http://en.wikipedia.org/wiki/Bit_array]()

## Installation

### Important!

Depends on Redis 2.6 for the `bitop` operation. You can install it using:

```bash
brew install --devel redis
```

or upgrading your current version:

```bash
brew upgrade --devel redis
```

And then install the gem

```bash
gem install minuteman
```

## Usage

```ruby
# Accepts an options hash that will be sent as is to Redis.new
analytics = Minuteman.new

# Mark an event for a given id
analytics.mark("login:successfull", user.id)
analytics.mark("login:successfull", other_user.id)

# Mark in bulk
analytics.mark("programming:love:ruby", User.where(favorite: "ruby").map(&:id))

# Fetch events for a given time
today_events = analytics.day("login:successfull", Time.now.utc)

# Check event length
today_events.length
#=> 2

# Check for existance
today_events.include?(user.id)
#=> true
today_events.include?(admin.id)
#=> false

# Bulk check
today_events.include?(User.all.map(&:id))
#=> [true, true, false, false]
```
