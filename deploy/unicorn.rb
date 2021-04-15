require 'securerandom'

worker_processes 4
working_directory File.realpath(File.join(__dir__, '../server'))

timeout 600

listen "#{__dir__}/sock/unicorn.sock", backlog: 64
pid "#{__dir__}/pid/unicorn.pid"

stderr_path "#{__dir__}/log/unicorn.err.log"
stdout_path "#{__dir__}/log/unicorn.out.log"

@session_secret = SecureRandom.base64(48)
before_fork do |_server, _worker|
  # share session_secret between worker processes
  ENV['RACK_SESSION_SECRET'] = @session_secret
end
