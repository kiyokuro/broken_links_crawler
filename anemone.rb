require 'anemone'
require 'pry'

url = "/wedding_note/items/"

def crawl_item_page(domain, url, last_id_number)
  p "start"
  (last_id_number.to_i + 1).times { |id|
    p id
    Anemone.crawl("http://" + domain + url + id.to_s) do |item_page|
      item_page.on_every_page do |page|
        crawl_quoted_page(page.links[16]) unless page.code == 404
      end
    end
  }
end

def crawl_quoted_page(url)
  Anemone.crawl(url) do |quoted_page|
    quoted_page.on_every_page do |page|
      p url
    end
  end
end

crawl_item_page(ARGV[0], url, ARGV[1])
