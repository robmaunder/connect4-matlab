function preferred_columns = greedy_player(grid, player, how_many_to_connect)

good_columns = 0;

chains = NaN(size(grid,2),2*how_many_to_connect);
for column = 1:size(grid,2)
     if ~isempty(find(grid(:,column)==0, 1))
        good_columns = good_columns+1;
        [chains_made, chains_blocked] = evaluate_play(make_play(grid,column,player),column,how_many_to_connect);
        chains(column,:) = reshape([chains_blocked';chains_made'],[1,2*how_many_to_connect]);
     end
end
[~,preferred_columns] = sortrows(chains,2*how_many_to_connect:-1:1,'descend','MissingPlacement','last');
preferred_columns = preferred_columns(1:good_columns);

% 
% found_first = false;
% 
% for column = 1:size(grid,2)
%     if ~isempty(find(grid(:,column)==0, 1))
%         [chains_made, chains_blocked] = evaluate_play(make_play(grid,column,player),column,how_many_to_connect);
%         chains = reshape([chains_blocked';chains_made'],[2*how_many_to_connect,1]);
%         if found_first == false
%             preferred_columns = column;
%             best_chains = chains;
%             found_first = true;
%         else
%             for chain_index = length(chains):-1:1
%                 if chains(chain_index) < best_chains(chain_index)
%                     break
%                 elseif chains(chain_index) > best_chains(chain_index)
%                     best_chains = chains;
%                     preferred_columns = column;
%                     break;
%                 end                
%             end
%         end
%     end
% end