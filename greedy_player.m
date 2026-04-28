function preferred_columns = greedy_player(grid, player, how_many_to_connect, difficulty)

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
