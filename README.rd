= em-http-fetcher

HTTP fetch client based on ruby EventMachne that has configureable
concurrency regardless of EM's thread pool.

= Example

  EM.run do
    trap(:INT) { EM.stop }
    fetcher = EM::HttpFetcher.new
    fetcher.callback do |req| # req is HttpRequest instance
      # Here is global callback block for all request
      p "Fetch success! #{req.last_effective_url} (#{req.response.size} bytes)"
    end

    %w(
      http://www.google.com/
      http://heroku.com/
      http://sourceforge.net/
      http://github.com/
    ).each do |url|
      fetcher.request url
    end

    req = fetcher.request 'http://www.ruby-lang.org/'
    req.callback do
      # Here is appendix callback block for this request.
      # Global callback block will also be called.
      puts "Hello Ruby!"
    end
  end

= Usage

== Options for HttpFetcher.new

: :concurrency
  Concurrency for all request.
: :host_concurrency
  Concurrency per host.
: :host_request_wait
  Wait specified seconds after request on each request thread.
: (all other keys)
  Pass through for HttpRequest.new

== Options for HttpFetcher#request

: :uri
  Target URI (String or URI object)
: :method (default=:get)
  Request method (get/head/put...)
: (all other keys)
  Pass through for HttpRequest#(get/head/put...)

If first argument is not a hash, it will be treated as :uri.

= Limitations

 * :host_concurrency is checked only for initial URI.
   When request is redirected, number of parallel requests for
   one host may be over host_concurrency.

= License

Same as Ruby 2.0 (2-clause BSDL or Ruby original license)
