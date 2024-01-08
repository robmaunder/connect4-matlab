function chosen_column = assisted_human_player(grid, player, how_many_to_connect)

    get_win = false(size(grid,2));
    avoid_loss = false(size(grid,2));
    for column = 1:size(grid,2)
        if ~isempty(find(grid(:,column)==0, 1))
            [chains_made, chains_blocked] = evaluate_play(make_play(grid,column,player),column,how_many_to_connect);
            if chains_made(how_many_to_connect) > 0
                get_win(column) = true;
            end
            if chains_blocked(how_many_to_connect) > 0
                avoid_loss(column) = true;
            end        
        end
    end
    acceptible_columns = find(get_win);
    if isempty(acceptible_columns)
        acceptible_columns = find(avoid_loss);
        if length(acceptible_columns) ~= 1
            acceptible_columns = 1:size(grid,2);
        end
    end


    print_grid(grid);
    print_indices(grid);
    got_good_entry = false;
    while got_good_entry == false
        my_string = sprintf("Player %d, enter index of column to play: ",player);
        chosen_column = input(my_string);
        if chosen_column >= 1 && chosen_column <= size(grid,2) && ~isempty(find(grid(:,chosen_column)==0, 1))
            if isempty(find(acceptible_columns == chosen_column, 1))
                fprintf("Not a good idea. Try again.\n");
            else
                got_good_entry = true;
            end
        else
            fprintf("Not valid. Try again.\n");
        end
    end
end