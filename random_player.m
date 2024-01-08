function chosen_column = random_player(grid, player, how_many_to_connect)
    got_good_entry = false;
    while got_good_entry == false
        chosen_column = randi(size(grid,2));
        if ~isempty(find(grid(:,chosen_column)==0, 1))
            got_good_entry = true;
        end
    end
end