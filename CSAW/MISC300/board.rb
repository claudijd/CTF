require_relative 'board_lib'

board_client = BoardClient.new("128.238.66.216", 45678)
board_client.connect()

100.times do
  board = board_client.read_board()
  board.parse()
  puts "Playing Round #{board.round}"
  board.solve(board.generation)
  board_client.write_board(board)
end

puts board_client.sock.read(17)
puts board_client.sock.read(82)