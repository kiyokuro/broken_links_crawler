require 'nokogiri'
require 'open-uri'
require 'pry'

url = "/wedding_note/items/"

def scrape_item_page(domain, url, last_id_number)
  (last_id_number.to_i + 1).times do |id|
    charset = nil
    begin
      html = open("http://" + domain + url + id.to_s) do |f|
        charset = f.charset
        f.read
      end
    rescue OpenURI::HTTPError => e
      next
    end
    doc = Nokogiri::HTML.parse(html, nil, charset)
    quoted_page_path = doc.xpath("//div[@class='wedding-note-item-detail__quoted-link taC js_ga-block']")[0].children[1].attributes["href"].value
    scrape_quoted_page(quoted_page_path, id)
  end
end

def scrape_quoted_page(quoted_page_path, item_id)
  begin
    html = open(quoted_page_path)
    Nokogiri::HTML(html)
  rescue OpenURI::HTTPError => e
    p ("path = " + quoted_page_path + " |  item_id = " + item_id.to_s) if e.message == "404 Not Found"
  end
end

scrape_item_page(ARGV[0], url, ARGV[1])
