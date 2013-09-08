require_relative "env"

class Notes < Sinatra::Base
  
  # @@notes = []
  @@note = nil
  
  get "/" do
    File.read "public/index.html"
  end
  
  get "/load" do
    # { note: @@note }.to_json
    @@note
  end
  
  post "/store" do
    @@note = params[:note]
    { status: "success" }.to_json
    # { status: "failed", message: "sinatra server error" }
  end
end