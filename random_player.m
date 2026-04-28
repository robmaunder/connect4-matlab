function chosen_column = random_player(grid, player, how_many_to_connect, difficulty)
    valid = find(any(grid == 0)); 
    chosen_column = valid(randi(length(valid)));
end