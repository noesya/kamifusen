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

    def keycdn_url
      url = "#{Kamifusen.keycdn}/#{variant.blob.key}?"
      transformations = variant.variation.transformations
      url += "&format=#{transformations[:format]}" if transformations.has_key? :format
      url += "&quality=#{transformations[:quality]}" if transformations.has_key? :quality
      if transformations.has_key? :resize
        resize = transformations[:resize]
        # 100>
        if '>'.in? resize
          width = resize.split('>').first.to_i
          url += "&width=#{width}"
        end
      end
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
