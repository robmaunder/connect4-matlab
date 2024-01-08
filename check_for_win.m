function win = check_for_win(grid, column_just_played, how_many_to_connect)
row_just_played = find(grid(:,column_just_played)>0,1);
if isempty(row_just_played)
    error('column_just_played is empty');
end
player_just_played = grid(row_just_played, column_just_played);

win = false;

% Check vertical
row_start = row_just_played;
row_stop = row_start+how_many_to_connect-1;
if row_start >=1 && row_stop <= size(grid,1)
    attempt = grid(row_start:row_stop,column_just_played);
    if length(unique(attempt)) == 1
        win = true;
        return
    end
end

for offset = 0:how_many_to_connect-1
    % Check horizontal
    column_stop = column_just_played+offset;
    column_start = column_stop-how_many_to_connect+1;
    if column_start >=1 && column_stop <= size(grid,2)
        attempt = grid(row_just_played,column_start:column_stop);
        if length(unique(attempt)) == 1
            win = true;
            return
        end
    end

    % Check backslash diagonal
    row_stop = row_just_played+offset;
    row_start = row_stop-how_many_to_connect+1;
    if row_start >=1 && row_stop <= size(grid,1) && column_start >=1 && column_stop <= size(grid,2)
        attempt = diag(grid(row_start:row_stop,column_start:column_stop));
        if length(unique(attempt)) == 1
            win = true;
            return
        end
    end

    % Check forwardslash diagonal
    row_start = row_just_played-offset;
    row_stop = row_start+how_many_to_connect-1;
    if row_start >=1 && row_stop <= size(grid,1) && column_start >=1 && column_stop <= size(grid,2)
        attempt = diag(fliplr(grid(row_start:row_stop,column_start:column_stop)));
        if length(unique(attempt)) == 1
            win = true;
            return
        end
    end
end





