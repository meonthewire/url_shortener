require 'sinatra'
require 'sinatra/activerecord'
require 'uri'
require 'alphadecimal'

db = URI.parse(ENV['DATABASE_URL'] || 'postgres://ec2-23-21-209-85.compute-1.amazonaws.com/d9jjk8gveghpi')

ActiveRecord::Base.establish_connection(
  :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
  :host     => db.host,
  :port     => db.port,
  :username => "qjtzitbepiiydm",
  :password => "0Q63db8pccT76NjcjzbcDk0CBg",
  :database => db.path[1..-1],
  :encoding => 'utf8'
)

class ShortenedUrl < ActiveRecord::Base
  validates_uniqueness_of :url
  validates_presence_of :url

  def shorten
    self.id.alphadecimal
  end

  def self.find_by_shortened(shortened)
    find_by_id(shortened.alphadecimal)
  end

end

get '/' do
  haml :index
end

post '/' do
  @short_url = ShortenedUrl.find_or_create_by_url(params[:url])
  if @short_url.valid?
    haml :success
  else
    haml :index
  end
end

get '/:shortened' do
  short_url = ShortenedUrl.find_by_shortened(params[:shortened])
  redirect short_url.url
end


