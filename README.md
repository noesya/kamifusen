# Kamifūsen

Images in Ruby on Rails, as lightweight as possible!

![Kamifūsen in Yamagata](https://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/%E4%B8%AD%E6%B4%A5%E5%B7%9D%E9%9B%AA%E3%81%BE%E3%81%A4%E3%82%8A.jpg/1024px-%E4%B8%AD%E6%B4%A5%E5%B7%9D%E9%9B%AA%E3%81%BE%E3%81%A4%E3%82%8A.jpg)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kamifusen'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install kamifusen

In the views, use (where object is an active record model, and image is an active storage attachment):

```erb
<%= kamifusen_tag object.image, alt: 'A nice image' %>
```

If you want to disable webp, in config/initializers/kamifusen.rb:

```ruby
Kamifusen.with_webp = false
```

If you render kamifusen tags inside a sanitized text, please make sure you allow these tags and attributes in `config/application.yml`:

```ruby
config.action_view.sanitized_allowed_tags = ['picture', 'source', 'img']
config.action_view.sanitized_allowed_attributes = ['src', 'type', 'srcset', 'width', 'height', 'alt', 'sizes', 'loading', 'decoding']
```

## Usage

Simply use `kamifusen_tag` instead of `image_tag` in your rails views.## What's the problem?

### The initial situation

When you use an image in a website, the basic code is:
```html
<img src="image.jpg" alt="A nice image">
```

which in rails can be generated with (assuming the image is an active storage blob):
```erb
<%= image_tag object.image, alt: 'A nice image' %>
```

If the image is a 5 mo jpg file, 3500px width by 5000px height, then your page is very heavy, which is bad for the user and bad for the environment.

There are many things to do to improve the weight and the experience, as we'll now see.

### Ways to optimize

#### 1. Resize the image server side

If the screen you use is a mobile with a 375px wide screen, retina, then the image should be resized server side to a maximum of 750px. Ideally, if the image in the page is shown at 200px wide, then it should be resized to a 400px width. The technology used to manage that is the srcset.

The sizes are managed like:

```html
<img srcset="image-320w.jpg 320w,
             image-480w.jpg 480w,
             image-800w.jpg 800w"
     sizes="(max-width: 320px) 280px,
            (max-width: 480px) 440px,
            800px"
     src="image-800w.jpg" alt="A nice image">
```

And the retina like:

```html
<img srcset="image-320w.jpg,
             image-480w.jpg 1.5x,
             image-640w.jpg 2x"
     src="image-640w.jpg" alt="A nice image">
 ```

#### 2. Remove any metadata (EXIF...) and optimize compression (tinyfy)

Images can contain interesting metadata, which are heavy and useless in a standard web context. The technology used is imagemagick, through active storage.

#### 3. Provide more efficient formats (webp, AVIF)

Webp and AVIF are more efficient formats than jpg and png. They allow better compression with lower quality, but are not compatible with all browsers. The technology used is picture, allowing multiple sources to be defined and letting the browser choose the one it can handle.

```html
<picture>
  <source type="image/avif" srcset="image.avif">
  <source type="image/webp" srcset="image.webp">
  <img src="image.jpg" alt="A nice image">
</picture>
```

#### 4. Load and decode asynchronously  

```
<img decoding="async" … />
```

### The final situation

https://noesya.github.io/kamifusen/

The new helper is:

```erb
<%= kamifusen_tag object.image, alt: 'A nice image' %>
```

It generates a code like:

```html
<picture>
  <source srcset="image-800w.avif, image-1600w.avif 2x" type="image/avif"  media="(min-width: 800px)">
  <source srcset="image-400w.avif, image-800w.avif 2x"  type="image/avif"  media="(min-width: 400px)">
  <source srcset="image-800w.webp, image-1600w.webp 2x" type="image/webp"  media="(min-width: 800px)">
  <source srcset="image-400w.webp, image-800w.webp 2x"  type="image/webp"  media="(min-width: 400px)">
  <source srcset="image-800w.jpg, image-1600w.jpg 2x"   type="image/jpg"   media="(min-width: 800px)">
  <source srcset="image-400w.jpg, image-800w.jpg 2x"    type="image/jpg"   media="(min-width: 400px)">
  <img src="image-800.jpg" alt="A nice image" srcset="image-800.jpg, image-1600.jpg 2x">
</picture>
```

### Parameters

You can set different parameters : 

```
    class: "img_class",
    alt: "alt",
    height: height,
    width: width,
    sizes: sizes,
    active_storage_direct_url: direct_url,
    async: async
```

Example of sizes parameter : 

```
sizes: {
    '(max-width: 576px)': '315px',
    '(max-width: 991px)': '210px',
    '(max-width: 1199px)': '290px',
    '(max-width: 1439px)': '350px',
    '(min-width: 1440px)': '420px'
}
```

## References

- https://developer.mozilla.org/fr/docs/Learn/HTML/Multimedia_and_embedding/Responsive_images
- https://cloudfour.com/thinks/responsive-images-101-definitions/
- https://www.industrialempathy.com/posts/image-optimizations/
- https://github.com/google/eleventy-high-performance-blog/blob/60902bfdaf764f5b16b2af62cf10f63e0e74efbc/README.md#images
- http://rbuchberger.github.io/jekyll_picture_tag/
- https://vitobotta.com/2020/09/24/resize-and-optimise-images-on-upload-with-activestorage/
- https://www.filamentgroup.com/lab/load-css-simpler/
- https://mattwilcox.net/web-development/keeping-srcset-and-sizes-under-control
- https://developers.google.com/web/fundamentals/design-and-ux/responsive/images?hl=fr
- https://www.smashingmagazine.com/2014/05/responsive-images-done-right-guide-picture-srcset/
- https://web.dev/use-srcset-to-automatically-choose-the-right-image/
- https://web.dev/use-imagemin-to-compress-images/
- https://code.luasoftware.com/tutorials/bootstrap/responsive-image-with-srcset-using-bootstrap-breakpoints/

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/noesya/kamifusen. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/kamifusen/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Kamifusen project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/kamifusen/blob/master/CODE_OF_CONDUCT.md).
