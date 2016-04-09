require 'open-uri'
module RequestStubs
  %w(get post delete).each do |verb|
    define_method("stub_#{verb}") do |path, fixture, options = {}|
      stub_api(verb.to_sym, "https://api.itbit.com/v1#{path}", fixture, options)
    end
  end
  
  def stub_api(method, url, fixture, options)
    response_body = if fixture
      File.read(File.expand_path("../../fixtures/#{fixture}.json", __FILE__))
    else
      ''
    end
    request = stub_request(method, url)

    unless options.empty?
      request = if method == :get
        request.with(query: options)
      else
        request.with(body: options.to_json)
      end
    end
    request.to_return(status: 200, body: response_body)
  end
end
