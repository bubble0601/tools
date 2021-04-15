require 'securerandom'

@root = File.realpath(File.join(__dir__, '..'))
worker_processes 4
working_directory @root

timeout 600

listen "#{@root}/deploy/sock/unicorn.sock", backlog: 64
pid "#{@root}/deploy/pid/unicorn.pid"

stderr_path "#{@root}/deploy/log/unicorn.err.log"
stdout_path "#{@root}/deploy/log/unicorn.out.log"

# Unicornの再起動時にダウンタイムなしで再起動
preload_app true

@session_secret = SecureRandom.base64(48)
before_fork do |server, worker|
  # share session_secret between worker processes
  ENV['RACK_SESSION_SECRET'] = @session_secret

  # USR2シグナルを受けると古いプロセスを止める
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # nop
    end
  end
end
