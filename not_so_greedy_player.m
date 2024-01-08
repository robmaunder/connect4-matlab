function chosen_column = not_so_greedy_player(grid, player, how_many_to_connect)
    global difficulty
    if isempty(difficulty)
        difficulty = 0.5;
    end

    preferred_columns = greedy_player(grid, player, how_many_to_connect);
    if length(preferred_columns) == 1 || rand<0.5+difficulty/2
        chosen_column = preferred_columns(1);
    else
        chosen_column = preferred_columns(2);
    end



% second_best_column = 0;
% second_best_chains = zeros(2*how_many_to_connect,1);
% 
% found_first = false;
% for column = 1:size(grid,2)
%     if ~isempty(find(grid(:,column)==0, 1))
%         [chains_made, chains_blocked] = evaluate_play(make_play(grid,column,player),column,how_many_to_connect);
%         chains = reshape([chains_blocked';chains_made'],[2*how_many_to_connect,1]);
% 
%         if found_first == false
%             best_chains = chains;
%             best_column = column;
%             found_first = true;
%         else
%             better_than_best = false;
%             for chain_index = length(chains):-1:1
%                 if chains(chain_index) < best_chains(chain_index)
%                     break
%                 elseif chains(chain_index) > best_chains(chain_index)
%                     second_best_chains = best_chains;
%                     second_best_column = best_column;
%                     best_chains = chains;
%                     best_column = column;
%                     better_than_best = true;
%                     break;
%                 end                
%             end
% 
%             if better_than_best == false
%                 for chain_index = length(chains):-1:1
%                     if chains(chain_index) < second_best_chains(chain_index)
%                         break
%                     elseif chains(chain_index) > second_best_chains(chain_index)
%                         second_best_chains = chains;
%                         second_best_column = column;
%                         break;
%                     end                
%                 end
%             end  
%         end
%     end
% end
% 
% if second_best_column == 0 || rand<0.5+difficulty/2
%     column_just_played = best_column;
% else
%     column_just_played = second_best_column;
% end
% 
% if column_just_played<= 0
%     error('Rob2');
% end
% 
% if column_just_played> size(grid,2)
%     error('Rob3');
% end
% 
% if isempty(find(grid(:,column_just_played)==0, 1))
%     error('Rob');
% end