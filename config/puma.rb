require 'fileutils'

workers ENV.fetch('WEB_CONCURRENCY') { 1 }
threads ENV.fetch('MIN_THREADS') { 1 }.to_i, ENV.fetch('MAX_THREADS') { 1 }.to_i
bind "tcp://#{ENV.fetch('BIND', '0.0.0.0')}:#{ENV.fetch('PORT', 3000)}"

on_worker_shutdown do
  $stderr.puts "[#{$$}] Shutting down"
end

app do |env|
  $stderr.puts "[#{$$}] Received a #{env['REQUEST_METHOD']} request to #{env['REQUEST_URI']}"
  case env['REQUEST_URI']
  when '/'
    body = "Hello, World!\n"
    [
      200,
      {
        'Content-Type' => 'text/plain',
        'Content-Length' => body.length.to_s
      },
      [body]
    ]
  else
    [
      404,
      {},
      []
    ]
  end
end
