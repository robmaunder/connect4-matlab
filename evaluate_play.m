function [chains_made, chains_blocked] = evaluate_play(grid, column_just_played, how_many_to_connect)
row_just_played = find(grid(:,column_just_played)>0,1);
if isempty(row_just_played)
    error('column_just_played is empty');
end
player_just_played = grid(row_just_played, column_just_played);

attempts = cell(how_many_to_connect*4,1);
attempt_count = 0;

for offset = 0:how_many_to_connect-1
    % Check vertical
    row_stop = row_just_played+offset;
    row_start = row_stop-how_many_to_connect+1;
    if row_start >=1 && row_stop <= size(grid,1)
        attempt_count = attempt_count+1;
        attempts{attempt_count} = grid(row_start:row_stop,column_just_played);
    end

    % Check horizontal
    column_stop = column_just_played+offset;
    column_start = column_stop-how_many_to_connect+1;
    if column_start >=1 && column_stop <= size(grid,2)
        attempt_count = attempt_count+1;
        attempts{attempt_count} = grid(row_just_played,column_start:column_stop);
    end

    % Check backslash diagonal
    row_stop = row_just_played+offset;
    row_start = row_stop-how_many_to_connect+1;
    column_stop = column_just_played+offset;
    column_start = column_stop-how_many_to_connect+1;
    if row_start >=1 && row_stop <= size(grid,1) && column_start >=1 && column_stop <= size(grid,2)
        attempt_count = attempt_count+1;
        attempts{attempt_count} = diag(grid(row_start:row_stop,column_start:column_stop));
    end

    % Check forwardslash diagonal
    row_start = row_just_played-offset;
    row_stop = row_start+how_many_to_connect-1;
    column_stop = column_just_played+offset;
    column_start = column_stop-how_many_to_connect+1;
    if row_start >=1 && row_stop <= size(grid,1) && column_start >=1 && column_stop <= size(grid,2)
        attempt_count = attempt_count+1;
        attempts{attempt_count} = diag(fliplr(grid(row_start:row_stop,column_start:column_stop)));
    end
end

chains_made = zeros(how_many_to_connect,1);
chains_blocked = zeros(how_many_to_connect,1);

for attempt_index = 1:attempt_count
    attempt = attempts{attempt_index};
    unique_in_attempt = unique(attempt);
    
    if length(unique_in_attempt) == 1
        chains_made(how_many_to_connect) = chains_made(how_many_to_connect)+1;
    elseif length(unique_in_attempt) == 2
        if unique_in_attempt(1) == 0
            chains_made(sum(attempt == player_just_played)) = chains_made(sum(attempt == player_just_played)) + 1;
        else
            if sum(attempt == player_just_played) == 1            
                chains_blocked(how_many_to_connect) = chains_blocked(how_many_to_connect)+1;
            end
        end
    elseif length(unique_in_attempt) == 3
        if unique_in_attempt(1) == 0
            if sum(attempt == player_just_played) == 1
                chains_blocked(how_many_to_connect-sum(attempt == 0)) = chains_blocked(how_many_to_connect-sum(attempt == 0)) + 1;
            end
        end
    end


end

% print_grid(grid)
% column_just_played
% chains_made
% chains_blocked