set :database, {
  adapter: 'postgresql',
  encoding: 'utf8',
  database: 'shortner_development',
  pool: 5,
  username: 'postgres',
  password: 153759,
  host: 'localhost'
}

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


