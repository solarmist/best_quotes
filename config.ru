# best_quotes/config.ru
require 'rack/lobster'

require './config/application'

map "/lobster" do
  use Rack::ShowExceptions
  run Rack::Lobster.new
end

map "/lobster/but_not" do
  run proc {
    [200, {}, ["Really not a lobster"]]
  }
end

class BenchMarker
  def initialize(app, runs = 100)
    @app, @runs = app, runs
  end

  def call(env)
    t = Time.now

    result = nil
    @runs.times { result = @app.call(env)}

    t2 = Time.now - t
    STDERR.puts <<OUTPUT
#{@runs} runs
#{t2.to_f} seconds total
#{t2.to_f * 1000.0 / @runs} milliseconds/run
OUTPUT

    result
  end
end

class Canadianize
  def initialize(app, arg = "")
    @app = app
    @arg = arg
  end

  def call(env)
    status, headers, content = @app.call(env)
    content[-1] += @arg + ", eh?"
    headers['Content-Length'] = "#{content.join('').length}"
    [status, headers, content]
  end
end

use Rack::Auth::Basic, "app" do |user, pass|
    'secret' == pass && user == 'josh'
end
use BenchMarker, 10_000
use Rack::ContentType
use Canadianize, ", simple"

run BestQuotes::Application.new
# run proc{
#   [200, {'Content-Type' => 'text/html'},
#    ["Hello, world"]]
# }
