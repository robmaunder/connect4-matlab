function preferred_columns = mcts_player(grid, player, how_many_to_connect, how_many_players)
% https://en.wikipedia.org/wiki/Monte_Carlo_tree_search

seconds = 2;

addpath matlab-tree

t = tree(struct('num',0,'den',0,'player',player,'grid',grid,'column',0, 'columns_not_yet_explored', columns_not_yet_explored(grid),'game_over',false));
tic
while toc < seconds

    % selection
    current_node = 1; % Start at the root node
    current_node_data = t.get(current_node);
    while ~any(current_node_data.columns_still_to_explore)
        children_of_current_node = t.getchildren(current_node);
        nums = zeros(length(children_of_current_node));
        dens = zeros(length(children_of_current_node));
        for child_index = 1:length(children_of_current_node)
            child_node_data = t.get(children_of_current_node(child_index));
            nums(child_index) = child_node_data.num;
            dens(child_index) = child_node_data.den;
        end
        scores = nums./dens + sqrt(2)*sqrt(log(sum(dens))/dens);
        [~,best_index] = max(scores);
        current_node = t.get(children_of_current_node(best_index));
        current_node_data = t.get(current_node);
    end
    % keep_going = true;
    % while keep_going
    %     current_node_data = t.get(current_node);
    %     if ~any(current_node_data.columns_still_to_explore)
    %         children_of_current_node = t.getchildren(current_node);
    %         nums = zeros(length(children_of_current_node));
    %         dens = zeros(length(children_of_current_node));
    %         for child_index = 1:length(children_of_current_node)
    %             child_node_data = t.get(children_of_current_node(child_index));
    %             nums(child_index) = child_node_data.num;
    %             dens(child_index) = child_node_data.den;
    %         end
    %         scores = nums./dens + sqrt(2)*sqrt(log(sum(dens))/dens);
    %         [~,best_index] = max(scores);
    %         current_node = t.get(children_of_current_node(best_index));
    %     else
    %         keep_going = false;
    %     end
    % end

    % expansion
    next_column = find(current_node_data.columns_still_to_explore,1);
    next_player = mod(current_node_data.player,how_many_players)+1;
    next_grid = make_play(current_node_data.grid,next_column,next_player);
    next_columns_still_to_explore = columns_not_yet_explored(next_grid);
    current_node_data.columns_still_to_explore(next_column) = false;
    t = t.set(current_node,current_node_data);
    [t, current_node] = t.addnode(current_node,struct('num',0,'den',0,'player',next_player,'grid',next_grid,'column',next_column, 'columns_not_yet_explored', next_columns_still_to_explore,'game_over',false));

    % simulation

    % backpropagation


end

preferred_columns = greedy_player(grid, player, how_many_to_connect);

    function out = columns_not_full(grid)
        out = sum(grid == 0)>0;
    end