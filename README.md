# TakoJudo

## Identification of the Work and Group
This project implements the TakoJudo board game in Prolog language.
The elements of the group are Munteanu Nicolae (202202842) and Raphael Nagao (X).
Each of the team members contributed to 50% of the total work.

## Installation and Execution
In order to execute the game, one has to consult the 'main.pl' file in SICStus,
and set SICStus' working directory to the folder containing the files. 
Then, in order to start the game, the predicate play/0 must be called.

## Game Description
The game takes place on an 8x8 board. Each player has control of an octopus, which
is made up of eight tentacles and one head. The head takes up a 2x2 square on the board.
Players can move their tentacles like a chess queen: in diagonals, rows, or columns. 
In order to move a tentacle, it has to be in sight of the octopus's head: the head sees 
also in diagonals, rows and columns. The space between the tentacle and the destination must
also be empty. The head moves in a similar way, but requires more free space because it's bigger.
Twiddling is also banned: a player can't go back and forth between the same squares in consecutive
turns.
The objective is to block the opponent so that they can't move any of their pieces anymore; the first
to do so wins. 

The rules for the game were searched on the wayback machine, since the site of the house that made the 
game doesn't host the rules anymore, so the file will be attached in the ZIP archive. 
For other details, YouTube videos were watched, like https://youtu.be/aK7GkFOUNHU.

## Game Logic
### Internal representation of the state of the game
To represent the playing board, we used a List of Cells. Each cell contains information like coordinates,
the piece it contains, the diagonals it is in, and an unique index. To count the diagonals, we just gave 
each an unique value. In this excel file it is visible because the colours represent the diagonals.
https://docs.google.com/spreadsheets/d/1RRaiHDq2adU5R7ls0PEgs5pDiZLlStzMEwtJ_g0aF8I/edit?usp=sharing

The Value part of a cell indicates what it contains: 0 if it's empty,
1 if it's Player 1's tentacles,
-1 if it's Player 1's head,
2 if it's Player 2's tentacles,
-2 if it's Player 2's head.

cell(+X, +Y, +Value, +Row, +Column, +Left_diagonal, +Right_diagonal, +Index).

The initial board looks like this:
init_board(
[cell('a', 8, 0, 0, 0, 1, 1, 1),\
 cell('b', 8, 0, 1, 0, 2, 2, 2),\
 cell('c', 8, 2, 2, 0, 3, 3, 3),\
 cell('d', 8, -2, 3, 0, 4, 4, 4),\
 cell('e', 8, -2, 4, 0, 5, 5, 5),\
 cell('f', 8, 2, 5, 0, 6, 6, 6),\
 cell('g', 8, 0, 6, 0, 7, 7, 7),\
 cell('h', 8, 0, 7, 0, 8, 8, 8),\
 cell('a', 7, 0, 0, 1, 9, 2, 9),\
 cell('b', 7, 0, 1, 1, 1, 3, 10),\
 cell('c', 7, 2, 2, 1, 2, 4, 11),\
 cell('d', 7, -2, 3, 1, 3, 5, 12),\
 cell('e', 7, -2, 4, 1, 4, 6, 13),\
 cell('f', 7, 2, 5, 1, 5, 7, 14),\
 cell('g', 7, 0, 6, 1, 6, 8, 15),\
 cell('h', 7, 0, 7, 1, 7, 9, 16),\
 cell('a', 6, 0, 0, 2, 10, 3, 17),\
 cell('b', 6, 0, 1, 2, 9, 4, 18),\
 cell('c', 6, 2, 2, 2, 1, 5, 19),\
 cell('d', 6, 2, 3, 2, 2, 6, 20),\
 cell('e', 6, 2, 4, 2, 3, 7, 21),\
 cell('f', 6, 2, 5, 2, 4, 8, 22),\
 cell('g', 6, 0, 6, 2, 5, 9, 23),\
 cell('h', 6, 0, 7, 2, 6, 10, 24),\
 cell('a', 5, 0, 0, 3, 11, 4, 25),\
 cell('b', 5, 0, 1, 3, 10, 5, 26),\
 cell('c', 5, 0, 2, 3, 9, 6, 27),\
 cell('d', 5, 0, 3, 3, 1, 7, 28),\
 cell('e', 5, 0, 4, 3, 2, 8, 29),\
 cell('f', 5, 0, 5, 3, 3, 9, 30),\
 cell('g', 5, 0, 6, 3, 4, 10, 31),\
 cell('h', 5, 0, 7, 3, 5, 11, 32),\
 cell('a', 4, 0, 0, 4, 12, 5, 33),\
 cell('b', 4, 0, 1, 4, 11, 6, 34),\
 cell('c', 4, 0, 2, 4, 10, 7, 35),\
 cell('d', 4, 0, 3, 4, 9, 8, 36),\
 cell('e', 4, 0, 4, 4, 1, 9, 37),\
 cell('f', 4, 0, 5, 4, 2, 10, 38),\
 cell('g', 4, 0, 6, 4, 3, 11, 39),\
 cell('h', 4, 0, 7, 4, 4, 12, 40),\
 cell('a', 3, 0, 0, 5, 13, 6, 41),\
 cell('b', 3, 0, 1, 5, 12, 7, 42),\
 cell('c', 3, 1, 2, 5, 11, 8, 43),\
 cell('d', 3, 1, 3, 5, 10, 9, 44),\
 cell('e', 3, 1, 4, 5, 9, 10, 45),\
 cell('f', 3, 1, 5, 5, 1, 11, 46),\
 cell('g', 3, 0, 6, 5, 2, 12, 47),\
 cell('h', 3, 0, 7, 5, 3, 13, 48),\
 cell('a', 2, 0, 0, 6, 14, 7, 49),\
 cell('b', 2, 0, 1, 6, 13, 8, 50),\
 cell('c', 2, 1, 2, 6, 12, 9, 51),\
 cell('d', 2, -1, 3, 6, 11, 10, 52),\
 cell('e', 2, -1, 4, 6, 10, 11, 53),\
 cell('f', 2, 1, 5, 6, 9, 12, 54),\
 cell('g', 2, 0, 6, 6, 1, 13, 55),\
 cell('h', 2, 0, 7, 6, 2, 14, 56),\
 cell('a', 1, 0, 0, 7, 15, 8, 57),\
 cell('b', 1, 0, 1, 7, 14, 9, 58),\
 cell('c', 1, 1, 2, 7, 13, 10, 59),\
 cell('d', 1, -1, 3, 7, 12, 11, 60),\
 cell('e', 1, -1, 4, 7, 11, 12, 61),\
 cell('f', 1, 1, 5, 7, 10, 13, 62),\
 cell('g', 1, 0, 6, 7, 9, 14, 63),\
 cell('h', 1, 0, 7, 7, 1, 15, 64)\
]).

### Gamestate View 
To visualize the game, we use print_board, which takes as input a list of cells and the board "size" (in this case, 8).
It divides the list in lines and then prints each cell - the specifics can be found in the comments of the board.pl file.

+---+---+---+---+---+---+---+---+\
|   |   | \ | O | O |   |   |   | 8\
+---+---+---+---+---+---+---+---+\
|   |   | \ | O | O | \ | \ |   | 7\
+---+---+---+---+---+---+---+---+\
|   |   | \ | \ | \ | \ |   |   | 6\
+---+---+---+---+---+---+---+---+\
|   |   |   |   |   |   |   |   | 5\
+---+---+---+---+---+---+---+---+\
|   |   |   | ~ |   |   |   |   | 4\
+---+---+---+---+---+---+---+---+\
|   |   | ~ |   | ~ | ~ |   |   | 3\
+---+---+---+---+---+---+---+---+\
|   |   | ~ | @ | @ | ~ |   |   | 2\
+---+---+---+---+---+---+---+---+\
|   |   | ~ | @ | @ | ~ |   |   | 1\
+---+---+---+---+---+---+---+---+\
  a   b   c   d   e   f   g   h\

This is a tipical gamestate. Player 1 has head "@" and tentacles "~", while Player 2 has head "O" and tentacles "\". 
The board has letter and number coordinates.

When the game starts, txt files containing ASCII art for the title and for the main screen will be read and written.
It was done using txts because escaping the characters correctly in the .pl file was a very unintuitive task.
An ASCII art screen is also available for Victory.

The menu code is in the main.pl file and keeps asking the player for a choice until the input is valid. It asks
for the gamemode and for the difficulty of the AI, if needed.

### Moves Execution

The corresponding code is in the movement.pl file.

can_move(Cell1, Cell2, Board, Player, LastMove, Print, IsHead, R):-\
            coordinates(Cell1, Board, R0), \
            coordinates(Cell2, Board, R1),\
            player_head(Player, Head),\
            piece_ownership(Cell1, Player, Head, IsHead, R8),\
            free_destination_square(Cell1, Cell2, Head, R2),\
            same_row(Cell1, Cell2, R3),\
            same_column(Cell1, Cell2, R4), \
            same_left_diag(Cell1, Cell2, R5),\
            same_right_diag(Cell1, Cell2, R6),\
            moveset(R3, R4, R5, R6, R7),\
            player_head(Player, Head),\
            tentacles_in_sight(Cell1, Board, Player, Head, R9),\
            free_line_movement(Cell1, Cell2, Board, R10),\
            twiddling_container(Cell1, Cell2, Player, LastMove, IsHead, R11),\
            free_movement(R0, R1, R2, R7, R8, R9, R10, R11, Print, R).\

This is the predicate for a tentacle movement. IT hecks if all the requirements are met for having a valid movement. 
The coordinates have to be valid, the Destination cell has to be free, 
the movement has to be legal, the player must own the piece,
the piece must be in sight of the tentacle and the line between
destination and arrival should be empty. Also the player can't
"Twiddle", going back to the square where they were in the turn before.
Print is used for printing the errors to make the player know what they did wrong.
The specifics for each step of the validation are in the code file.

Movement for the head behaves differently: it uses can_move_head, since the head is made up 
of four different cells. When an user wants to move a cell with a Head value, all other cells
of the head will be found, and for each it will be checked if they can move or not (as if they
behaved like 4 different tentacles). 

### List of Valid Moves

valid_movements(Player, Board, LastMove, HeadLastMoves, R):-\
            get_all_player_pieces(Player, Board, Pieces),\
            player_head(Player, Head),\
            get_all_player_pieces(Head, Board, Heads),\
            get_all_player_pieces(0, Board, FreeSquares),\
            get_all_player_pieces(0, Board, FreeSquares2),\
            manage_piece_testing(Heads, FreeSquares2, Board, Player, LastMove, 1, HeadLastMoves, R2),\
            manage_piece_testing(Pieces, FreeSquares, Board, Player, LastMove, 0, HeadLastMoves, R1),\
            append(R1, R2, R).\
            
After getting all the pieces that the player can move, both head and tentacles, it searches for the
squares of the board that are empty and so permit movement. Then it does a can_move check for each pair of
piece and destination. It combines everything into a final list.

### End of Game

check_losing(Player, Board, LastMove, HeadLastMoves, Res):-\
            valid_movements(Player, Board, LastMove, HeadLastMoves, R),\
            list_empty(R, Res).\

lose(Player):-
            write('Player '),write(Player),write(' has no available moves.'),nl,nl,nl,\
            write('Player '), next_player(Player,NP),write(NP),write(' is the winner!'),\
            readFile('victory.txt'),\
            nl,nl,nl.\
            
If the list of valid movements of the player is empty, then he has lost, and the opposing player has won.
 
### Board Evaluation

For level 2 AI, the board evaluation works by seeing how many moves your opponent can make.
States in which the opponent has the minimum amount of movements possible are the best.

### Computer Move
Level 1: 
            valid_movements(Player, Board, LastMove, HeadLastMoves, MovementsList),\
            exclude(empty, MovementsList, Y),\
            random_select(F1, Y, DontCare),\
            random_select(Piece-Destination, F1, DontCare),\
            print_bot_moves(Piece, Destination),nl,nl,\
It gets all the valid moves and chooses one at random.\

Level 2: 
It uses the predicate valid_movements_level2 which can be found in the movement.pl file.
Basically it finds all the valid moves, and tests each of them to see which one
leaves the opponent with the minimum amount of possible moves.

## Conclusions

The project was fun to realize and managed to make us understand better how Prolog works.
We are happy to have a working project while still knowing that things could be better,
both in the code and in the execution- things like the running time of the Level 2 AI 
could be fixed in various ways, and the code could be more optimized, we are however satisfied
with what we managed to accomplish.

## Bibliography

Moodle Prolog Slides
Github Projects of "Board Games" in prolog (like https://github.com/BlueDi/Shiftago-Prolog/blob/master/board.pl)

