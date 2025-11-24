module Kamifusen
  class Processor
    attr_reader :variant, :active_storage_direct_url

    def initialize(variant, active_storage_direct_url = false)
      @variant = variant
      @active_storage_direct_url = active_storage_direct_url
    end

    def url
      Kamifusen.keycdn.present? ? keycdn_url
                                : active_storage_url
    end

    protected

    def transformations
      @transformations ||= variant.variation.transformations
    end

    def format
      return @format if defined?(@format)
      @format = transformations.fetch(:format)
    end

    def quality
      return @quality if defined?(@quality)
      @quality =  case ActiveStorage.variant_processor
                  when :vips
                    transformations.dig(:saver, :quality)
                  when :mini_magick
                    transformations.fetch(:quality)
                  end
    end

    def width
      return @width if defined?(@width)
      if transformations.has_key?(:resize)
        Kamifusen.deprecator.warn("The `resize` transformation is deprecated. Please use `resize_to_limit` instead.")
        # resize: "100>"
        resize = transformations[:resize]
        @width = resize.split('>').first.to_i if '>'.in?(resize)
      elsif transformations.has_key?(:resize_to_limit)
        # resize_to_limit: [100, nil]
        @width = transformations[:resize_to_limit].first.to_i
      elsif transformations.has_key?(:resize_to_fill)
        # resize_to_fill: [400, 600]
        @width = transformations[:resize_to_fill].first.to_i
      end
      @width
    end

    def height
      return @height if defined?(@height)
      if transformations.has_key?(:resize_to_fill)
        # resize_to_fill: [400, 600]
        @height = transformations[:resize_to_fill].second.to_i
      end
      @height
    end

    def crop
      return @crop if defined?(@crop)
      @crop = transformations.has_key?(:resize_to_fill)
    end

    def keycdn_url
      return @keycdn_url if defined?(@keycdn_url)
      @keycdn_url = "#{Kamifusen.keycdn}/#{variant.blob.key}?"
      @keycdn_url += "format=#{format}&" if format.present?
      @keycdn_url += "width=#{width}&" if width.present?
      @keycdn_url += "height=#{height}&" if crop && height.present?
      @keycdn_url += "quality=#{quality}&" if quality.present?
      @keycdn_url
    end

    def active_storage_url
      return @active_storage_url if defined?(@active_storage_url)
      @active_storage_url = nil
      @active_storage_url = processed_url if active_storage_direct_url
      @active_storage_url ||= smart_url
      @active_storage_url ||= explicit_url
      @active_storage_url
    end

    def processed_url
      # Pour générer la processed url, il faut savoir où sont stockées les images
      # https://discuss.rubyonrails.org/t/define-host-so-absolute-urls-work-in-development-and-test/75085
      # https://stackoverflow.com/questions/60425407/uriinvalidurierror-bad-uriis-not-uri-nil-active-storage-service-url
      variant.processed.url
    rescue
      # Not compatible with DiskService, which returns a URI::InvalidURIError
    end

    def smart_url
      Rails.application.routes.url_helpers.url_for(variant)
    rescue
      # Host might not be defined
    end

    def explicit_url
      Rails.application.routes.url_helpers.rails_representation_path(variant, only_path: true)
    end
  end
end
