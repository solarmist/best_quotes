# best_quotes/app/controllers/quotes_controller.rb

class QuotesController < Rulers::Controller
  def index
    quotes = FileModel.all
    render :index, :quotes => quotes
  end

  def new_quote
    attrs = {
      "submitter" => "web user",
      "quote" => "A picture is worth a thousand pixels.",
      "attribution" => "Me"
    }

    quote = FileModel.create attrs
    ua = request.user_agent
    render :quote, :obj => quote, :ua => ua
  end

  def show
    quote = FileModel.find(params["id"])
    ua = request.user_agent
    render :quote, :obj => quote, :ua => ua
  end

  def update_quote
    # return index unless env["REQUEST_METHOD"] == "POST"
    quote = FileModel.save 2, {"submitter" => "Josh"}
    ua = request.user_agent
    render :quote, :obj => quote, :ua => ua
  end

  def a_quote
    render :a_quote, :noun => :winking
  end

  def quote
    quote = FileModel.find env['QUERY_STRING']
    ua = request.user_agent
    render :quote, :obj => quote, :ua => ua
  end

  def exception
    raise "It's a bad one!"
  end
end
