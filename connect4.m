function connect4(players, rows, columns, how_many_to_connect, difficulty)

if ~exist('players','var')
    players{1} = @assisted_human_player;
    players{2} = @mcts_player;
end
if ~exist('rows','var')
    rows = 6;
end
if ~exist('columns','var')
    columns = 7;
end
if ~exist('how_many_to_connect','var')
    how_many_to_connect = 4;
end
if ~exist('difficulty','var')
    difficulty = 1;
end

[winner, grid] = run_game(players, rows, columns, how_many_to_connect, difficulty);

print_grid(grid)
if winner == 0
    fprintf("Draw\n");
else
    fprintf("Player %d wins!\n", winner);
end


    