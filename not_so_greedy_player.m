function chosen_column = not_so_greedy_player(grid, player, how_many_to_connect)
    global difficulty
    if isempty(difficulty)
        difficulty = 0.5;
    end

    preferred_columns = greedy_player(grid, player, how_many_to_connect);
    if length(preferred_columns) == 1 || rand<0.5+difficulty/2
        chosen_column = preferred_columns(1);
    else
        chosen_column = preferred_columns(2);
    end
