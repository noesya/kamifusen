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

    def get_quality
      if transformations.has_key? :quality
        warn "[DEPRECATION] kamifusen: `variant(quality:)` is deprecated. Please use `variant(saver: { quality: })` instead."
        return transformations[:quality]
      end
      transformations.dig(:saver, :quality)
    end

    def get_resize_width
      width = nil
      if transformations.has_key? :resize
        resize = transformations[:resize]
        # resize: "100>"
        if '>'.in? resize
          warn "[DEPRECATION] kamifusen: `resize(\"\#{width}>\")` transformation is deprecated. Please use `resize_to_limit(width, nil)` instead."
          width = resize.split('>').first.to_i
        end
      elsif transformations.has_key? :resize_to_limit
        # resize_to_limit: [100, nil]
        width = transformations[:resize_to_limit].first.to_i
      end
      width
    end

    def keycdn_url
      url = "#{Kamifusen.keycdn}/#{variant.blob.key}?"
      url += "format=#{transformations[:format]}&" if transformations.has_key? :format

      width = get_resize_width
      url += "width=#{width}" unless width.nil?

      quality = get_quality
      url += "quality=#{quality}&" unless quality.nil?

      url
    end

    def active_storage_url
      url = nil
      url = processed_url if active_storage_direct_url
      url ||= smart_url
      url ||= explicit_url
      url
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
