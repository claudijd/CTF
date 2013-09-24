require 'socket'

class Cell
  attr_accessor :neighbors
  attr_reader :alive

  def initialize(char)
    @alive = char == "*" ? true : false
  end

  def next!
    @alive = @alive ? (2..3) === @neighbors : 3 == @neighbors
  end

  def to_i
    @alive ? 1 : 0
  end

  def to_s
    @alive ? '*' : ' '
  end
end

class Board
  attr_reader :raw, :round, :generation, :header, :lines, :cells, :height, :width

  def initialize(raw)
    @raw = raw
    @round = nil
    @generation = nil
    @header = nil
    @lines = []
    @cells = []
    @height = nil
    @width = nil
  end

  def parse()
    @raw.sub!(/^[\n]+/, "")

    raw_lines = @raw.split("\n")
    @header = raw_lines.first
    
    @round = @header.match(/Round (\d+)/)[1].to_i
    @generation = @header.match(/(\d+) Generations/)[1].to_i

    raw_lines.each do |raw_line|
      if match = raw_line.match(/^[#]{1}([ *]+)[#]$/)
        @lines << match[1]
      end
    end

    @lines.each do |line|
      row = []

      line.chars.each do |char|
        row << Cell.new(char)
      end

      @cells << row
    end

    @height = @cells.size
    @width = @cells.first.size
  end

  def next!
    @generation += 1

    @cells.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        cell.neighbors = alive_neighbours(x, y)
      end
    end

    @cells.each { |row| row.each { |cell| cell.next! } }
  end

  def alive_neighbours(x, y)
    sum = 0

    positions = [
      [-1, 0], [1, 0], #sides
      [-1, 1], [0, 1], [1, 1], # over
      [-1, -1], [0, -1], [1, -1] # under
    ]

    positions.each do |position_x, position_y|
      # Avoid array over/under runs
      if x == 0 && position_x == -1
        next
      elsif y == 0 && position_y == -1
        next
      elsif x == @width - 1 && position_x == 1
        next
      elsif y == @height - 1 && position_y == 1
        next
      end

      sum += @cells[position_y + y][position_x + x].to_i
    end

    return sum
  end

  def to_s
    buff = ""
    buff << "#" + ("#" * @width) + "#\n"

    @cells.each do |row|
      buff << "#"

      row.each_with_index do |cell|
        buff << cell.to_s
      end

      buff << "#"
      buff << "\n"
    end

    buff << "#" + ("#" * @width) + "#\n"
  end

  def solve(num)
    num.times { self.next! }
  end
end

class BoardClient
  attr_reader :sock

  def initialize(ip, port)
    @ip = ip
    @port = port
    @sock = nil
  end

  def connect
    @sock = TCPSocket.new(@ip, @port)
  end

  def read_board()
    buffer = ""    
    edge_count = 0

    while line = @sock.gets
      edge_count += 1 if line.match(/[#]+{4,400}/)
      buffer << line if edge_count > 0
      break if edge_count == 3
    end

    if buffer == "" || buffer.nil?
      raise StandardError, "Nothing in the buffer from the target"
    end

    return Board.new(buffer)
  end

  def write_board(board)
    @sock.write(board.to_s + "\n")
  end 

  def close
    @sock.close rescue nil
  end
end
