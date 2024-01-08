function run_tournament(players, rows, columns, how_many_to_connect, games_to_play)

global difficulty
difficulty=0;

if ~exist('players','var')
    players{1} = @greedy_player;
    players{2} = @not_so_greedy_player;
end
if ~exist('rows','var')
    rows = 6;
end
if ~exist('columns','var')
    columns = 7;
end
if ~exist('how_many_to_connect','var')
    how_many_to_connect = 4;
end

if ~exist('games_to_play','var')
    games_to_play = 1000;
end

wins = zeros(1,length(players));

for game_index = 1:games_to_play
    perm = randperm(length(players));
    permuted_players = players(perm);

    [permuted_winner_index, grid] = run_game(permuted_players, rows, columns, how_many_to_connect);

    permuted_winner = zeros(1,length(players));
    if permuted_winner_index > 0
        permuted_winner(permuted_winner_index) = 1;
    end

    winner(perm) = permuted_winner;

    wins = wins + winner;
end

wins
    