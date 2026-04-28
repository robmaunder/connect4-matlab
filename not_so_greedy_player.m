function chosen_column = not_so_greedy_player(grid, player, how_many_to_connect, difficulty)
    preferred_columns = greedy_player(grid, player, how_many_to_connect);
    if length(preferred_columns) == 1 || rand<0.5+difficulty/2
        chosen_column = preferred_columns(1);
    else
        chosen_column = preferred_columns(2);
    end
