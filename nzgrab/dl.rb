require 'Nokogiri'
require 'open-uri'
require 'haml'
require 'reverse_markdown'
require 'sqlite3'
require 'csv'
require 'yaml'
require 'date'
require 'openssl'
# require 'kristin'

# https://www.idrsolutions.com/online-pdf-to-html5-converter/

TURL = 'http://formshelp.immigration.govt.nz/SkilledMigrant/ExpressionOfInterest/historyofselectionpoints/eoi2016.htm'.freeze

def get_doc(url)
  ua = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0.1) Gecko/20100101 Firefox/9.0.1'
  charset = 'utf-8'
  error = nil
  # html = open("vic-graduates.html")
  html = open(url, 'User-Agent' => ua)
  doc = Nokogiri::HTML.parse(html, nil, charset)
end

def download_doc(url, name)
  open("2016/#{name}", 'wb') do |file|
    puts "download #{name}"
    file << open(url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE).read
  end
end

def download_last(_nums)
  doc = get_doc(TURL)
  uri = URI(TURL)
  allhref = doc.css('a')

  count = 0

  allhref.each do |ahref|
    h = ahref.attr('href').to_s
    next if h.start_with?('#')
    next if h.start_with?('javascript')
    next if h.empty?

    currenturlpath = h.delete("\u00A0").strip

    currenturl = "#{uri.scheme}://#{uri.host}#{currenturlpath}"

    fname = currenturlpath.split('/').last.to_s

    p currenturl

    download_doc(currenturl, fname)

    count += 1

    break if count > _nums
  end
end

download_last(8)
