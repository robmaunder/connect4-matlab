while true

    rows = randi(10);
    columns = randi(10);
    how_many_to_connect = randi(min(rows,columns));
    direction = randi(4);
    fprintf ("%d %d %d %d\n",rows, columns, how_many_to_connect, direction);

    grid = zeros(rows, columns);

    if direction == 1 % vertical
        start_row = randi(rows-how_many_to_connect+1);
        stop_row = start_row+how_many_to_connect-1;
        column = randi(columns);
        grid(start_row:stop_row,column)=1;
        column_just_played = column;
    elseif direction == 2 % horizontal
        start_column = randi(columns-how_many_to_connect+1);
        stop_column = start_column+how_many_to_connect-1;
        row = randi(rows);
        grid(row,start_column:stop_column)=1;
        column_just_played = randi([start_column,stop_column]);
    elseif direction == 3 % backslash
        start_row = randi(rows-how_many_to_connect+1);
        stop_row = start_row+how_many_to_connect-1;
        start_column = randi(columns-how_many_to_connect+1);
        stop_column = start_column+how_many_to_connect-1;
        grid(start_row:stop_row,start_column:stop_column)=eye(how_many_to_connect);
        column_just_played = randi([start_column,stop_column]);
    else % forwardslash
        start_row = randi(rows-how_many_to_connect+1);
        stop_row = start_row+how_many_to_connect-1;
        start_column = randi(columns-how_many_to_connect+1);
        stop_column = start_column+how_many_to_connect-1;
        grid(start_row:stop_row,start_column:stop_column)=fliplr(eye(how_many_to_connect));
        column_just_played = randi([start_column,stop_column]);
    end

    if ~check_for_win(grid,column_just_played,how_many_to_connect)
        grid
        column_just_played
        error('Broken');
    end
       
       


end