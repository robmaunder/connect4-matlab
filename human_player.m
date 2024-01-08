function chosen_column = human_player(grid, player, how_many_to_connect)
    print_grid(grid);
    print_indices(grid);
    got_good_entry = false;
    while got_good_entry == false
        my_string = sprintf("Player %d, enter index of column to play: ",player);
        chosen_column = input(my_string);
        if chosen_column >= 1 && chosen_column <= size(grid,2) && ~isempty(find(grid(:,chosen_column)==0, 1))
            got_good_entry = true;
        else
            fprintf("Not valid. Try again.\n");
        end
    end
end