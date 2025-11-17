module ApplicationHelper
  def variant_processor_version
    case ActiveStorage.variant_processor
    when :vips
      Vips.version_string
    when :mini_magick
      MiniMagick.cli_version
    else
      "unknown"
    end
  end
end
