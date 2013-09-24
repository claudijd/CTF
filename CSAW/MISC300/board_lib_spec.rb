require_relative 'board_lib'

describe Cell do
  before :each do
    @live_cell = Cell.new("*")
    @dead_cell = Cell.new(" ")
  end

  it "should die with less two live neighbors" do
    @live_cell.neighbors = 1
    @live_cell.next!.should == false
  end

  it "should live on to the next generation with 2 neighbors" do
    @live_cell.neighbors = 2
    @live_cell.next!.should == true
  end

  it "should live on to the next generation with 3 neighbors" do
    @live_cell.neighbors = 3
    @live_cell.next!.should == true
  end

  it "should die on to the next generation with more than 3 neighbors" do
    @live_cell.neighbors = 4
    @live_cell.next!.should == false
  end

  it "should die on to the next generation with more than 3 neighbors" do
    @live_cell.neighbors = 5
    @live_cell.next!.should == false
  end

  it "should die on to the next generation with more than 3 neighbors" do
    @live_cell.neighbors = 6
    @live_cell.next!.should == false
  end

  it "should die on to the next generation with more than 3 neighbors" do
    @live_cell.neighbors = 7
    @live_cell.next!.should == false
  end

  it "should be resurrected on to the next generation with exactly 3 neighbors" do
    @dead_cell.neighbors = 3
    @dead_cell.next!.should == true
  end

  it "should not be resurrected on to the next generation with 2 neighbors" do
    @dead_cell.neighbors = 2
    @dead_cell.next!.should == false
  end

end

describe Board do
  before :each do
    @raw_board1 = "##### Round 1: 57 Generations #####\n" + 
                 "###############\n" + 
                 "#             #\n" +
                 "#  *    *     #\n" +
                 "#      *      #\n" +
                 "###############\n"
    @board1 = Board.new(@raw_board1)

    @raw_board2 = "##### Round 1: 57 Generations #####\n" + 
                 "###############\n" + 
                 "#  ** *       #\n" +
                 "#  **    *  **#\n" +
                 "#      * *   *#\n" +
                 "###############\n"
    @board2 = Board.new(@raw_board2)

    @raw_board3 = "##### Round 1: 57 Generations #####\n" + 
                  "########\n" + 
                  "#*     #\n" +
                  "#      #\n" +
                  "#     *#\n" +
                  "#######\n"

    @board3 = Board.new(@raw_board3)
  end

  it "should have the right width" do
    @board1.parse()
    @board1.width.should == 13
  end

  it "should have the right height" do
    @board1.parse()
    @board1.height.should == 3
  end

  it "should have the right header" do
    @board1.parse()
    @board1.header.should == "##### Round 1: 57 Generations #####"
  end

  it "should have the right generation" do
    @board1.parse()
    @board1.generation.should == 57
  end

  it "should have the right number of lines" do
    @board1.parse()
    @board1.lines.size.should == 3
  end

  it "should have the right number of neighbors" do
    @board1.parse()
    @board1.alive_neighbours(0,0).should == 0
  end

  it "should have the right number of neighbors" do
    @board1.parse()
    @board1.alive_neighbours(1,0).should == 1
  end

  it "should have the right number of neighbors" do
    @board1.parse()
    @board1.alive_neighbours(0,1).should == 0
  end

  it "should have the right number of neighbors" do
    @board1.parse()
    @board1.alive_neighbours(2,0).should == 1
  end

  it "should have the right number of neighbors" do
    @board1.parse()
    @board1.alive_neighbours(2,1).should == 0
  end

  it "should have the right number of neighbors" do
    @board1.parse()
    @board1.alive_neighbours(0,2).should == 0
  end

  it "should have the right number of neighbors" do
    @board1.parse()
    @board1.alive_neighbours(1,2).should == 1
  end

  it "should print out properly" do
    @board1.parse()
    @board1.to_s.should == "###############\n" + 
                           "#             #\n" + 
                           "#  *    *     #\n" + 
                           "#      *      #\n" + 
                           "###############\n"
  end

  it "should generate the next generation" do
    @board1.parse()
    @board1.next!()
    @board1.to_s.should == "###############\n" + 
                           "#             #\n" + 
                           "#             #\n" +
                           "#             #\n" + 
                           "###############\n" 
  end

  it "should generate the next generation" do
    @board2.parse()
    @board2.next!()
    @board2.to_s.should == "###############\n" + 
                           "#  ***        #\n" + 
                           "#  ***  *   **#\n" + 
                           "#       *   **#\n" + 
                           "###############\n"
  end

  it "should generate the next generation" do
    @board3.parse()
    @board3.next!()
    @board3.to_s.should == "########\n" + 
                           "#      #\n" + 
                           "#      #\n" + 
                           "#      #\n" + 
                           "########\n"
  end


end












