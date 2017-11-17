class Game

  attr_accessor :board, :player_1, :player_2

  def initialize(player_1 = Players::Human.new("X"), player_2 = Players::Human.new("O"), board = Board.new)
    @player_1 = player_1
    @player_2 = player_2
    @board = board
  end

  WIN_COMBINATIONS = [
    [0,1,2],
    [3,4,5],
    [6,7,8],
    [0,3,6],
    [1,4,7],
    [2,5,8],
    [0,4,8],
    [6,4,2]
  ]

  def current_player
    board.turn_count.even? ? player_1 : player_2
  end

  def over?
    draw? || won?
  end

  def won?
    WIN_COMBINATIONS.detect do |combo|
    @board.cells[combo[0]] == @board.cells[combo[1]] &&
    @board.cells[combo[1]] == @board.cells[combo[2]] &&
    @board.taken?(combo[0]+1)
    end
  end

  def draw?
    true if board.full? && !won?
  end

  def winner
    board.cells[won?[0]] if won?
  end


  def turn
    player = current_player
    move = player.move(@board)
    if !@board.valid_move?(move)
   turn
  else
    puts "Turn: #{@board.turn_count+1}\n"
    @board.display
    @board.update(move, player)
    puts "#{player.token} moved #{move}"
    @board.display
    puts "\n\n"
  end

  def play
    while !over?
      turn
    end
    if won?
      puts "Congratulations #{winner}!"
    elsif draw?
      puts "Cat's Game!"
    end
  end

  def start
    puts "Welcome to Tic Tac Toe!"
    puts "How many players? (Enter 0, 1, or 2?)"
    input = gets.strip

    case input

    when "0"
      new_game = Game.new(Players::Computer.new("X"), Players::Computer.new("O"))

    when "1"
      puts "Who goes first? p(layer)/c(omp)"
      first = gets.strip
      puts "X or O?"
      piece = gets.strip.upcase
      piece == "X" ? other_piece = "O" : other_piece = "X"
        if first == "p"
        new_game = Game.new(Players::Human.new(piece), Players::Computer.new(other_piece))
      else
      new_game = Game.new(Players::Computer.new(other_piece), Players::Human.new(piece))
    end

    when "2"
      puts "Player 1 is X or O?"
      piece = gets.strip.upcase
      piece == "X" ? other_piece = "O" : other_piece = "X"
      new_game = Game.new(Players::Human.new(piece), Players::Human.new(other_piece))

    when "wargames"
      draw = 0
      player_1 = 0
      player_2 = 0
      10.times do
        new_game = Game.new(Players::Computer.new("X"), Players::Computer.new("O"))
        case new_game.play
        when 0
          draw += 1
        when 1
          player_1 +=1
        when 2
          player_2 += 1
        end
        puts "Player 1: #{player_1}"
        puts "Player 2: #{player_2}"
        puts "Draw: #{draw}"
        puts ""
      end
      puts "Play again? (y/n)"
      input = gets.strip.downcase
      start if input == "y"
      exit if input == "n"

    when "exit"
      exit

    else
      start
    end

    new_game.play
    puts "Play again? (y/n)"
    input = gets.strip.downcase
    start if input == "y"
    exit if input == "n"
  end
end
end
