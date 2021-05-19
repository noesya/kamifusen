# Kamifūsen

![Kamifūsen in Yamagata](https://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/%E4%B8%AD%E6%B4%A5%E5%B7%9D%E9%9B%AA%E3%81%BE%E3%81%A4%E3%82%8A.jpg/1024px-%E4%B8%AD%E6%B4%A5%E5%B7%9D%E9%9B%AA%E3%81%BE%E3%81%A4%E3%82%8A.jpg)

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/kamifusen`. To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kamifusen'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install kamifusen

## Usage

When you want to use an image in a website, the basic code is:
```html
<img src="path/image.jpg" alt="A nice image">
```

which in rails can be generated with (assuming the image is an active storage blob):
```erb
<%= image_tag object.image, alt: 'A nice image' %>
```

If the image is a 5 mo jpg file, 3500 px width by 5000 px height, then your page is very heavy, which is bad for the user and bad for the environment.

There are many things to do to improve the weight and the experience:
- resize the image server side
- remove any metadata (EXIF...) that have a size and no use in a web context
- provide more efficient formats (webp, AVIF)
- load and decode asynchronously  


The new helper is:
```erb
<%= kamifusen_tag object.image, alt: 'A nice image' %>
```



## References

- https://www.industrialempathy.com/posts/image-optimizations/
- https://github.com/google/eleventy-high-performance-blog/blob/60902bfdaf764f5b16b2af62cf10f63e0e74efbc/README.md#images

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/kamifusen. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/kamifusen/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Kamifusen project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/kamifusen/blob/master/CODE_OF_CONDUCT.md).
