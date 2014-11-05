require 'open-uri'
module RequestStubs
  def stub_get(path, fixture)
    stub_api(:get, "https://api.itbit.com/v1#{path}", fixture, {})
  end
  
  def stub_old(path, fixture, options = { })
    stub_api(:get, "https://www.itbit.com/api/v2#{path}", fixture, options)
  end
  
  def stub_api(method, url, fixture, options)
    fixture_path = File.expand_path("../../fixtures/#{fixture}.json", __FILE__)
    with = if method == :get
      {query: options}
    elsif method == :put
      {body: options.to_query }
    else
      {body: options.collect{|k,v| "#{k}=#{CGI.escape(v.to_s).gsub('+','%20')}"}* '&' }
    end
    stub_request(method, url)
      .with(with)
      .to_return(status: 200, body: File.read(fixture_path))
  end
end
