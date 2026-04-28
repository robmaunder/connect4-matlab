function chosen_column = mcts_player(grid, player, how_many_to_connect, difficulty)
% Monte Carlo Tree Search player. Assumes a 2-player game (players 1 and 2).
% difficulty proportionally sets the search time in seconds

    time_limit = difficulty;
%    time_limit = difficulty/6; % Similar difficulty to greedy_player
    if time_limit <= 0.01
        time_limit = 0.01;
    end

    [num_rows, num_cols] = size(grid);
    C_EXPLORE = sqrt(2);
    MAX_NODES = 100000;

    % Parallel arrays, one entry per tree node (indexed 1..num_nodes).
    % n_player(i)   = the player whose turn it is AT node i (who moves next)
    % n_wins(i)     = rollout wins for the player who moved INTO node i
    %                 = 3 - n_player(i), the "creator"
    % n_children(col, i) = child node index for that column (0 = unexpanded)
    n_parent   = zeros(1, MAX_NODES);
    n_children = zeros(num_cols, MAX_NODES);
    n_visits   = zeros(1, MAX_NODES);
    n_wins     = zeros(1, MAX_NODES);
    n_player   = zeros(1, MAX_NODES);
    n_terminal = false(1, MAX_NODES);
    n_winner   = zeros(1, MAX_NODES);  % winning player if terminal, 0 = draw
    n_grids    = zeros(num_rows, num_cols, MAX_NODES, 'int8');

    num_nodes      = 1;
    n_player(1)    = player;
    n_grids(:,:,1) = int8(grid);

    t_start = tic;
    while toc(t_start) < time_limit

        %% SELECTION: walk down via UCT until we reach a non-fully-expanded or terminal node
        node = 1;
        while true
            if n_terminal(node)
                break
            end
            g     = double(n_grids(:,:,node));
            valid = find(any(g == 0, 1));
            if isempty(valid)
                n_terminal(node) = true;
                break
            end
            child_exists = n_children(valid, node)' > 0;
            if ~all(child_exists)
                break  % has at least one unexpanded valid move
            end
            % Fully expanded: descend to the child with the best UCT score
            best_uct   = -Inf;
            best_child = 0;
            log_pv     = log(max(n_visits(node), 1));
            for col = valid
                c  = n_children(col, node);
                cv = n_visits(c);
                if cv == 0
                    uct_val = Inf;
                else
                    uct_val = n_wins(c)/cv + C_EXPLORE * sqrt(log_pv/cv);
                end
                if uct_val > best_uct
                    best_uct   = uct_val;
                    best_child = c;
                end
            end
            node = best_child;
        end

        %% EXPANSION: add one child for a randomly chosen unexpanded column
        if n_terminal(node)
            sim_winner = n_winner(node);
        else
            g            = double(n_grids(:,:,node));
            valid        = find(any(g == 0, 1));
            child_exists = n_children(valid, node)' > 0;
            unexpanded   = valid(~child_exists);
            col          = unexpanded(randi(length(unexpanded)));
            cur_player   = n_player(node);

            % Place piece (inlined make_play)
            new_grid = g;
            r = find(new_grid(:, col) > 0, 1);
            if isempty(r), row = num_rows; else, row = r - 1; end
            new_grid(row, col) = cur_player;

            is_win  = check_for_win(new_grid, col, how_many_to_connect);
            is_draw = ~is_win && ~any(new_grid(:) == 0);

            if num_nodes >= MAX_NODES
                break  % tree full; use what we have
            end
            num_nodes = num_nodes + 1;

            n_parent(num_nodes)    = node;
            n_player(num_nodes)    = 3 - cur_player;
            n_grids(:,:,num_nodes) = int8(new_grid);
            n_terminal(num_nodes)  = is_win || is_draw;
            if is_win
                n_winner(num_nodes) = cur_player;
            end
            n_children(col, node) = num_nodes;
            node = num_nodes;

            %% SIMULATION: random rollout from the new node
            if n_terminal(node)
                sim_winner = n_winner(node);
            else
                sim_grid   = new_grid;
                sim_player = 3 - cur_player;
                sim_winner = 0;
                while true
                    sim_valid = find(any(sim_grid == 0, 1));
                    if isempty(sim_valid)
                        break  % draw
                    end
                    sim_col = sim_valid(randi(length(sim_valid)));
                    % Inlined make_play for speed
                    r = find(sim_grid(:, sim_col) > 0, 1);
                    if isempty(r), sim_row = num_rows; else, sim_row = r - 1; end
                    sim_grid(sim_row, sim_col) = sim_player;
                    if check_for_win(sim_grid, sim_col, how_many_to_connect)
                        sim_winner = sim_player;
                        break
                    end
                    sim_player = 3 - sim_player;
                end
            end
        end

        %% BACKPROPAGATION: update visits and wins from leaf to root
        i = node;
        while i > 0
            n_visits(i) = n_visits(i) + 1;
            % Credit the player who moved into this node (the creator)
            if sim_winner == 3 - n_player(i)
                n_wins(i) = n_wins(i) + 1;
            end
            i = n_parent(i);
        end

    end

    %% Choose the root child with the most visits (robust final selection)
    best_visits   = -1;
    chosen_column = -1;
    for col = 1:num_cols
        c = n_children(col, 1);
        if c > 0 && n_visits(c) > best_visits
            best_visits   = n_visits(c);
            chosen_column = col;
        end
    end

    % Fallback: random valid move (e.g. if time_limit was too short for any expansion)
    if chosen_column == -1
        valid = find(any(grid == 0, 1));
        chosen_column = valid(randi(length(valid)));
    end

end
