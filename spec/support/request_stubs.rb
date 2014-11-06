require 'open-uri'
module RequestStubs
  %w(get post delete).each do |verb|
    define_method("stub_#{verb}") do |path, fixture, options = {}|
      stub_api(verb.to_sym, "https://api.itbit.com/v1#{path}", fixture, options)
    end
  end
  
  def stub_old(path, fixture, options = { })
    stub_api(:get, "https://www.itbit.com/api/v2#{path}", fixture, options)
  end
  
  def stub_api(method, url, fixture, options)
    response_body = if fixture
      File.read(File.expand_path("../../fixtures/#{fixture}.json", __FILE__))
    else
      ''
    end
    with = if options.empty?
      {}
    elsif method == :get
      {query: options}
    else
      {body: options.to_json} 
    end
    stub_request(method, url)
      .with(with).to_return(status: 200, body: response_body)
  end
end
