require_relative "env"

class Notes < Sinatra::Base
  get "/" do
    File.read "public/index.html"
  end
end