function new_grid = make_play(grid, column_just_played, player_just_played)
    row_previously_played = find(grid(:,column_just_played)>0,1);
    if isempty(row_previously_played)
        row_just_played = size(grid,1);
    else
        row_just_played = row_previously_played-1;
        if row_just_played <= 0
            error('column is full');
        end
    end
    new_grid = grid;
    new_grid(row_just_played,column_just_played) = player_just_played;
end
