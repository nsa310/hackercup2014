=begin
Alice and Bob like to play what they call the "Coins Game". In this game Bob starts with K identical coins and N identical jars. A jar can fit any number of coins and Bob has to distribute all the coins in whatever way he wants.

After the coins are distributed Alice takes the jars and shuffles them at random while Bob isn't looking. Alice will move jars around but will not move any coins between the jars. The jars are opaque so after the shuffle Bob doesn't see how many coins are in each.

  Now Bob has P moves. In each move he points at one of the jars. If the jar contains any coins Alice takes a single coin from it and hands it to Bob. If the jar is empty Alice tells Bob. Bob remembers his initial distribution and the moves he has made so far.

  The goal of the game is to check whether Bob is able to acquire at least C coins after his P moves. If he can do that he wins the game. After losing the first few games Bob is determined to figure out what's the minimal number of moves P that can guarantee his win. Your job is to help him, that is find the minimal value P for which there exists an initial coins distribution and moves strategy that makes Bob win no matter what order the jars are in.

  Input
The first line of the input consists of a single integer T, the number of test cases.
  Each test case is a single line with three integers: N K C

Output
For each test case i numbered from 1 to T, output "Case #i: ", followed by an integer P, the minimal number of moves for which there exists a winning strategy.

  Constraints
1 ≤ T ≤ 20
1 ≤ N ≤ 1000000
1 ≤ C ≤ K ≤ 1000000
=end
File.open(ARGV[0]).each_with_index do |line, index|
  if index == 0
    @total_tests = line.to_i
  else
    n, k, c = line.split(' ').map!(&:to_i)
    jars_with_equal_coins = n
    total_moves = 0
    if n > k
      #distribute 1 coin into as many jars as possible
      empty_jars = n - k
      total_moves = empty_jars + c
    else
      if k % n != 0
        if c<=((k/n)*n)
          total_moves = c
        else
          max_jars_with_max_equal_coins = n - 1
          while (k/max_jars_with_max_equal_coins) < (k%max_jars_with_max_equal_coins)
            max_jars_with_max_equal_coins = max_jars_with_max_equal_coins - 1
          end
          puts max_jars_with_max_equal_coins
          poor_jars = n - max_jars_with_max_equal_coins
          if c < (k - (max_jars_with_max_equal_coins * (k/max_jars_with_max_equal_coins)))
            total_moves = c
          else
            total_moves = poor_jars + c
          end
        end
      else
        total_moves = c
      end
    end
    puts "#{n}, #{k}, #{c}, total moves: #{total_moves}"
    File.open('coins_game_output.txt', 'a+') {|f| f.write("Case ##{index}: #{total_moves}\n")}
  end
end
