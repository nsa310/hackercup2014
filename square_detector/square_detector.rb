=begin
You want to write an image detection system that is able to recognize different geometric shapes. In the first version of the system you settled with just being able to detect filled squares on a grid.

You are given a grid of N×N square cells. Each cell is either white or black. Your task is to detect whether all the black cells form a square shape.

Input
The first line of the input consists of a single number T, the number of test cases.

Each test case starts with a line containing a single integer N. Each of the subsequent N lines contain N characters. Each character is either "." symbolizing a white cell, or "#" symbolizing a black cell. Every test case contains at least one black cell.

Output
For each test case i numbered from 1 to T, output "Case #i: ", followed by YES or NO depending on whether or not all the black cells form a completely filled square with edges parallel to the grid of cells.

Constraints
1 ≤ T ≤ 20
1 ≤ N ≤ 20

=end
total_cells_temp = 0
total_cells_perm= 0
cell_matrix = []
already_visited = []
case_counter = 0
already_found_a_square = false
def verify_square(n, cell_matrix, i, j, already_visited)
  black_cell_count = 0
  temp = j
  while temp<n and cell_matrix[i][temp] == '#'
    black_cell_count = black_cell_count + 1
    already_visited[i][temp] = 1
    temp = temp + 1
  end
  return 'YES' if black_cell_count == 1
  (1...black_cell_count).each do |offset|
    current_row= i + offset
    current_column = j
    black_cell_count.times do
      if cell_matrix[current_row][current_column] != '#'
        return 'NO'
      end
      already_visited[current_row][current_column] = 1
      current_column = current_column + 1
    end
  end
end
def check_for_black_squares(n, cell_matrix, already_visited, already_found_a_square)
  (0...n).each do |i|
    (0...n).each do |j|
      if cell_matrix[i][j] == '#' and already_visited[i][j] == 0
        if already_found_a_square == false
          if verify_square(n, cell_matrix, i, j, already_visited) == 'NO'
            return 'NO'
          end
          already_found_a_square = true
        else
          return 'NO'
        end
      end
    end
  end
  return 'YES'
end

File.open(ARGV[0]).each_with_index do |line, index|
    if index == 0
      @total_tests = line.to_i
    else
      if total_cells_temp >0
        cell_matrix << line.to_s.scan(/./)
        temp = []
        line.to_s.size.times do
          temp << 0
        end
        already_visited << temp
        total_cells_temp = total_cells_temp - 1
        if total_cells_temp == 0 and !cell_matrix.empty?
          puts total_cells_perm
          puts cell_matrix.inspect
          puts already_visited.inspect
          case_counter = case_counter+1
          result = check_for_black_squares(total_cells_perm, cell_matrix, already_visited, already_found_a_square)
          File.open('square_detector_output.txt', 'a+') {|f| f.write("Case ##{case_counter}: #{result}\n")}
          puts result
        end
      else
        total_cells_temp = line.to_i
        total_cells_perm = line.to_i
        cell_matrix = []
        already_visited = []
      end
    end
end

