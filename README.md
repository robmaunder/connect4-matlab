# connect4-matlab

A Connect 4 engine in MATLAB with pluggable AI players, including a Monte Carlo Tree Search (MCTS) implementation. Players can be mixed and matched freely — human vs AI, AI vs AI, or multi-player variants.

## Quick start

```matlab
% Human (with hints) vs MCTS, standard 6×7 board
connect4()

% Two humans
connect4({@human_player, @human_player})

% MCTS (2-second thinking time) vs greedy AI
connect4({@mcts_player, @greedy_player}, 6, 7, 4, 2)

% Run a 1000-game tournament between greedy and MCTS (0.1s per move)
run_tournament({@greedy_player, @mcts_player}, 6, 7, 4, 1000, 0.1)
```

## Functions

### `connect4(players, rows, columns, how_many_to_connect, difficulty)`

Plays a single game and prints the result.

| Argument | Default | Description |
|---|---|---|
| `players` | `{@assisted_human_player, @not_so_greedy_player}` | Cell array of player function handles |
| `rows` | `6` | Number of rows |
| `columns` | `7` | Number of columns |
| `how_many_to_connect` | `4` | Chain length needed to win |
| `difficulty` | `0` | Passed to each player function (meaning depends on player) |

### `run_tournament(players, rows, columns, how_many_to_connect, games_to_play, difficulty)`

Plays many games between the given players, randomising who goes first each game, and prints win counts.

| Argument | Default | Description |
|---|---|---|
| `games_to_play` | `1000` | Number of games |
| other arguments | same as `connect4` | — |

## Players

| Function | Description | `difficulty` effect |
|---|---|---|
| `human_player` | Text prompt, no hints | Ignored |
| `assisted_human_player` | Text prompt; rejects moves that miss a win or fail to block an opponent's forced win | Ignored |
| `random_player` | Picks a random valid column | Ignored |
| `greedy_player` | Evaluates all valid columns using chain heuristics and ranks them best-to-worst | Ignored |
| `not_so_greedy_player` | Greedy, but with a chance of playing the second-best move. `difficulty=1` → always best move; `difficulty=0` → 50/50 best vs second-best | Blend parameter (0–1) |
| `mcts_player` | Monte Carlo Tree Search; stronger than greedy with enough time | Search time in seconds |

### Board display

During human turns the board is printed with `print_grid` and column indices with `print_indices`:

```
| | | | | | | |
| | | | | | | |
| | | | | | | |
| | | |1| | | |
| | |2|1| | | |
| |2|1|2|1| | |

 1 2 3 4 5 6 7
Player 1, enter index of column to play:
```

Player 1's pieces are shown as `1`, player 2's as `2`.

## Player interface

Every player function must have the signature:

```matlab
function preferred_columns = my_player(grid, player, how_many_to_connect, difficulty)
```

| Argument | Description |
|---|---|
| `grid` | `rows × columns` matrix; `0` = empty, `1`/`2` = that player's piece |
| `player` | This player's number (1 or 2) |
| `how_many_to_connect` | Chain length needed to win |
| `difficulty` | Passed through from `connect4`/`run_tournament`; use as needed |

The return value must be a non-empty vector of valid column indices. `run_game` uses only `preferred_columns(1)`, so returning a ranked list (like `greedy_player`) or a scalar both work. Columns are numbered 1 to `columns` left-to-right. Pieces obey gravity — they fall to the lowest empty row.

## Core engine functions

### `run_game(players, rows, columns, how_many_to_connect, difficulty)`

Runs one game, alternating players in order. Returns `[winner, grid]` where `winner` is 0 for a draw.

### `make_play(grid, column, player)`

Returns a new grid with the player's piece dropped into `column`. Errors if the column is full.

### `check_for_win(grid, column_just_played, how_many_to_connect)`

Returns `true` if the piece most recently placed in `column_just_played` completes a winning chain. Checks all four directions (horizontal, vertical, and both diagonals).

### `evaluate_play(grid, column_just_played, how_many_to_connect)`

Returns `[chains_made, chains_blocked]`, both vectors of length `how_many_to_connect`. `chains_made(k)` counts windows of size `how_many_to_connect` that contain exactly `k` of the just-played player's pieces and no opponent pieces. `chains_blocked(k)` counts windows where the just-played piece entered an opponent's partial chain of length `k`. Used by `greedy_player` and `assisted_human_player`.

## MCTS player details

`mcts_player` builds a search tree using the standard UCB1 (UCT) algorithm:

```
UCT(child) = wins(child)/visits(child)  +  √2 · √(ln(visits(parent)) / visits(child))
```

Each iteration: **select** a leaf via UCT, **expand** one child, **simulate** a random rollout to a terminal state, **backpropagate** the result. The final move is the root child with the most visits.

`difficulty` sets the thinking time in seconds. Values ≤ 0.01 are clamped to 0.01 s. Suggested values:

| Context | `difficulty` |
|---|---|
| Quick tournament | 0.05 – 0.2 |
| Casual play | 1 – 2 |
| Strong play | 5 – 10 |

## Writing a custom player

Create a file `my_player.m`:

```matlab
function preferred_columns = my_player(grid, player, how_many_to_connect, difficulty)
    % grid(row, col): row 1 is the top, row end is the bottom
    % Pieces fall to the lowest empty row in the chosen column.
    % Return any non-empty vector; only preferred_columns(1) is used.

    valid = find(any(grid == 0, 1));  % columns that are not full
    preferred_columns = valid(randi(length(valid)));  % random for now
end
```

Then pass it as a function handle:

```matlab
connect4({@my_player, @greedy_player}, 6, 7, 4, 1)
```

## Testing

`test_check_for_win.m` is a stress-test script that generates random winning configurations in all four directions and verifies that `check_for_win` detects them. Run it from the MATLAB command window and stop it with Ctrl-C once satisfied.

```matlab
run('test_check_for_win.m')
```
