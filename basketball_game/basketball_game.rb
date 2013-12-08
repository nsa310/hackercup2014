=begin
A group of N high school students wants to play a basketball game. To divide themselves into two teams they first rank all the players in the following way:

Players with a higher shot percentage are rated higher than players with a lower shot percentage.
  If two players have the same shot percentage, the taller player is rated higher.
  Luckily there are no two players with both the same shot percentage and height so they are able to order themselves in an unambiguous way. Based on that ordering each player is assigned a draft number from the range [1..N], where the highest-rated player gets the number 1, the second highest-rated gets the number 2, and so on. Now the first team contains all the players with the odd draft numbers and the second team all the players with the even draft numbers.

  Each team can only have P players playing at a time, so to ensure that everyone gets similar time on the court both teams will rotate their players according to the following algorithm:

  Each team starts the game with the P players who have the lowest draft numbers.
  If there are more than P players on a team after each minute of the game the player with the highest total time played leaves the playing field. Ties are broken by the player with the higher draft number leaving first.
  To replace her the player on the bench with the lowest total time played joins the game. Ties are broken by the player with the lower draft number entering first.
  The game has been going on for M minutes now. Your task is to print out the names of all the players currently on the field, (that is after M rotations).

  Input

The first line of the input consists of a single number T, the number of test cases.

  Each test case starts with a line containing three space separated integers N M P

The subsequent N lines are in the format "<name> <shot_percentage> <height>". See the example for clarification.

  Constraints

1 ≤ T ≤ 50
2 * P ≤ N ≤ 30
1 ≤ M ≤ 120
1 ≤ P ≤ 5
Each name starts with an uppercase English letter, followed by 0 to 20 lowercase English letters. There can be players sharing the same name. Each shot percentage is an integer from the range [0..100]. Each height is an integer from the range [100..240]
=end
def custom_sort(array, default, tie_break)
  array.sort{|x,y| if x[default]!=y[default] then x[default]<=>y[default] else x[tie_break]<=>y[tie_break] end}.reverse
end

def custom_bench_sort(array, default, tie_break)
  array.sort{|x,y| if x[default]!=y[default] then x[default]<=>y[default] else x[tie_break]<=>y[tie_break] end}
end

def get_updated_stats(players_stats)
  updated_stats = []
  players_stats.each do |item|
    name, shot_percentage, height = item.split(' ')
    updated_stats << {'name'=> name, 'shot_percentage'=> shot_percentage.to_i, 'height'=> height.to_i, 'timer'=>0}
  end
  updated_stats = custom_sort(updated_stats, 'shot_percentage', 'height')
  updated_stats.each_with_index do |item, index|
    item['draft'] = index + 1
  end
  updated_stats
end

def play_game(n, m, p, players_stats)
  a_bench = []
  a_players= []
  b_bench = []
  b_players = []
  a_team = []
  b_team = []
  updated_stats = get_updated_stats(players_stats)
  return updated_stats.sort_by{|hash| hash['name']} if n == p*2
  updated_stats.each do |item|
    if item['draft']%2 == 0
      b_players<< item
    else
      a_players<< item
    end
  end
  (0...p).each do |index|
    a_team << a_players[index]
    b_team << b_players[index]
  end
  a_bench = a_players - a_team
  b_bench = b_players - b_team
  (1..m).each do |current_rotation|
    a_team.each {|player| player['timer'] = player['timer']+1}
    b_team.each {|player| player['timer'] = player['timer']+1}
    a_team_elimination = custom_sort(a_team, 'timer', 'draft').first
    b_team_elimination = custom_sort(b_team, 'timer', 'draft').first

    a_bench_selection = custom_bench_sort(a_bench, 'timer', 'draft').first
    b_bench_selection = custom_bench_sort(b_bench, 'timer', 'draft').first

    a_team = a_team - [a_team_elimination]
    b_team = b_team - [b_team_elimination]
    a_team << a_bench_selection
    b_team << b_bench_selection

    a_bench = a_bench - [a_bench_selection]
    b_bench = b_bench - [b_bench_selection]
    a_bench << a_team_elimination
    b_bench << b_team_elimination
  end
  result  = a_team + b_team
  result.sort_by{|hash| hash['name']}
end

total_players, total_rotations, total_players_allowed_on_the_court = 0, 0, 0
temporary_n = 0
players_stats = []
case_counter = 0
File.open(ARGV[0]).each_with_index do |line, index|
    if index == 0
      @total_tests = line.to_i
    else
      if temporary_n > 0
        players_stats << line.to_s
        temporary_n = temporary_n - 1
        if temporary_n == 0
          puts total_players, total_rotations, total_players_allowed_on_the_court
          puts players_stats
          result = play_game(total_players.to_i, total_rotations.to_i, total_players_allowed_on_the_court.to_i, players_stats)
          output = []
          result.each do |item|
            output << item['name']
          end
          case_counter = case_counter + 1
          File.open('basketball_game_output.txt', 'a+') {|f| f.write("Case ##{case_counter}: #{output.join(' ')}\n")}
        end
      else
        input_params = line.to_s
        total_players, total_rotations, total_players_allowed_on_the_court= input_params.split(' ')
        temporary_n = total_players.to_i
        players_stats = []
      end
    end
end

