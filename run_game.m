function [winner, grid] = run_game(players, rows, columns, how_many_to_connect)
if rows<how_many_to_connect || columns < how_many_to_connect
    error('grid too small');
end

grid = zeros(rows,columns);

winner = 0;

for turn = 1:rows*columns
    player = mod(turn-1,length(players))+1;
    my_function = players{player};
    preferred_columns = my_function(grid, player, how_many_to_connect);
    column_just_played = preferred_columns(1);
    grid = make_play(grid, column_just_played, player);
    if check_for_win(grid, column_just_played, how_many_to_connect)
        winner = player;
        return
    end
end





    