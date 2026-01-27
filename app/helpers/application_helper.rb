module ApplicationHelper
  def google_maps_embed_src(address)
    q = ERB::Util.url_encode(address.to_s.strip)
    "https://www.google.com/maps?q=#{q}&output=embed"
  end
end
