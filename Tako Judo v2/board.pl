:-use_module(library(lists)).

/* This file contains the code regarding the Board of the game: its structure,
how to print it, how to get specific cells of the Board, and so on.*/


/* ascii(+number)

Prints the corresponding visual representation of the internal values of the board. */
ascii(0):-  write(' ').    /* Blank space */
ascii(1):-  print(~).      /* Tentacle of player 1 */
ascii(-1):- print(@).      /* Head of player 1 */
ascii(2):-  print(\).      /* Tentacle of player 2 */
ascii(-2):- print('O').    /* Head of player 2  */



/* translate_input_x(+input_x, -output_x)

Translate the user input of the x coordinate to the internal coordinates of the board. 
If the input is invalid, it will output -1.  */
translate_input_x('a',0).
translate_input_x('b',1).
translate_input_x('c',2).
translate_input_x('d',3).
translate_input_x('e',4).
translate_input_x('f',5).
translate_input_x('g',6).
translate_input_x('h',7).
translate_input_x(_, -1).



/* translate_input_y(+input_y, -output_y)

Translate the user input of the x coordinate to the internal coordinates of the board. 
If the input is invalid, it will output -1. */
translate_input_y('1',7).
translate_input_y('2',6).
translate_input_y('3',5).
translate_input_y('4',4).
translate_input_y('5',3).
translate_input_y('6',2).
translate_input_y('7',1).
translate_input_y('8',0).
translate_input_y(_, -1).



/*cell(+X, +Y, +Value, +Row, +Column, +Left_diagonal, +Right_diagonal, +Index)

Creates a cell which stores the coordinates, the value of the cell, the diagonals
it is part of, and an unique index. */
cell(_, _, _, _, _, _, _, _).



/*init_board(-Board)

Creates the initial board.  */
init_board(
[cell('a', 8, 0, 0, 0, 1, 1, 1),
 cell('b', 8, 0, 1, 0, 2, 2, 2),
 cell('c', 8, 2, 2, 0, 3, 3, 3),
 cell('d', 8, -2, 3, 0, 4, 4, 4),
 cell('e', 8, -2, 4, 0, 5, 5, 5),
 cell('f', 8, 2, 5, 0, 6, 6, 6),
 cell('g', 8, 0, 6, 0, 7, 7, 7),
 cell('h', 8, 0, 7, 0, 8, 8, 8),
 cell('a', 7, 0, 0, 1, 9, 2, 9),
 cell('b', 7, 0, 1, 1, 1, 3, 10),
 cell('c', 7, 2, 2, 1, 2, 4, 11),
 cell('d', 7, -2, 3, 1, 3, 5, 12),
 cell('e', 7, -2, 4, 1, 4, 6, 13),
 cell('f', 7, 2, 5, 1, 5, 7, 14),
 cell('g', 7, 0, 6, 1, 6, 8, 15),
 cell('h', 7, 0, 7, 1, 7, 9, 16),
 cell('a', 6, 0, 0, 2, 10, 3, 17),
 cell('b', 6, 0, 1, 2, 9, 4, 18),
 cell('c', 6, 2, 2, 2, 1, 5, 19),
 cell('d', 6, 2, 3, 2, 2, 6, 20),
 cell('e', 6, 2, 4, 2, 3, 7, 21),
 cell('f', 6, 2, 5, 2, 4, 8, 22),
 cell('g', 6, 0, 6, 2, 5, 9, 23),
 cell('h', 6, 0, 7, 2, 6, 10, 24),
 cell('a', 5, 0, 0, 3, 11, 4, 25),
 cell('b', 5, 0, 1, 3, 10, 5, 26),
 cell('c', 5, 0, 2, 3, 9, 6, 27),
 cell('d', 5, 0, 3, 3, 1, 7, 28),
 cell('e', 5, 0, 4, 3, 2, 8, 29),
 cell('f', 5, 0, 5, 3, 3, 9, 30),
 cell('g', 5, 0, 6, 3, 4, 10, 31),
 cell('h', 5, 0, 7, 3, 5, 11, 32),
 cell('a', 4, 0, 0, 4, 12, 5, 33),
 cell('b', 4, 0, 1, 4, 11, 6, 34),
 cell('c', 4, 0, 2, 4, 10, 7, 35),
 cell('d', 4, 0, 3, 4, 9, 8, 36),
 cell('e', 4, 0, 4, 4, 1, 9, 37),
 cell('f', 4, 0, 5, 4, 2, 10, 38),
 cell('g', 4, 0, 6, 4, 3, 11, 39),
 cell('h', 4, 0, 7, 4, 4, 12, 40),
 cell('a', 3, 0, 0, 5, 13, 6, 41),
 cell('b', 3, 0, 1, 5, 12, 7, 42),
 cell('c', 3, 1, 2, 5, 11, 8, 43),
 cell('d', 3, 1, 3, 5, 10, 9, 44),
 cell('e', 3, 1, 4, 5, 9, 10, 45),
 cell('f', 3, 1, 5, 5, 1, 11, 46),
 cell('g', 3, 0, 6, 5, 2, 12, 47),
 cell('h', 3, 0, 7, 5, 3, 13, 48),
 cell('a', 2, 0, 0, 6, 14, 7, 49),
 cell('b', 2, 0, 1, 6, 13, 8, 50),
 cell('c', 2, 1, 2, 6, 12, 9, 51),
 cell('d', 2, -1, 3, 6, 11, 10, 52),
 cell('e', 2, -1, 4, 6, 10, 11, 53),
 cell('f', 2, 1, 5, 6, 9, 12, 54),
 cell('g', 2, 0, 6, 6, 1, 13, 55),
 cell('h', 2, 0, 7, 6, 2, 14, 56),
 cell('a', 1, 0, 0, 7, 15, 8, 57),
 cell('b', 1, 0, 1, 7, 14, 9, 58),
 cell('c', 1, 1, 2, 7, 13, 10, 59),
 cell('d', 1, -1, 3, 7, 12, 11, 60),
 cell('e', 1, -1, 4, 7, 11, 12, 61),
 cell('f', 1, 1, 5, 7, 10, 13, 62),
 cell('g', 1, 0, 6, 7, 9, 14, 63),
 cell('h', 1, 0, 7, 7, 1, 15, 64)
]).



/*print_board(+Board, +Size)

It prints a board and uses its Size to know the number of lines and to print out 
the corresponding numerical coordinates. In this game the size is always 8. */
print_board([], _):- 
			write(+---+---+---+---+---+---+---+---+), nl,
			write('  a   b   c   d   e   f   g   h'), nl, nl.
print_board(Board, X):- 
			write(+---+---+---+---+---+---+---+---+), nl,
            split_list(Board, 8, LeftList, RightList),
			print_line(LeftList, X), 
			Y is X-1,
			print_board(RightList, Y).



/*print_line(+Cells, +Size)

An auxiliary function for print_board, it gets a list of Cells and it prints them.*/
print_line([], X):- 
			write('|'), write(' '), write(X), nl.
print_line([H|T], X):- 
			print_cell(H),
			print_line(T, X).



/*print_cell(+Lines, +Size)

An auxiliary function for print_line, it gets a Cell and it prints it
accordingly to the ascii representation of the internal values.*/
print_cell(cell(_,_,Value,_,_,_,_,_)):- 
			write('|'), write(' '), ascii(Value), write(' ').



/*cell_coordinates(+Cell, -X, -Y)

It gets a cell and it returns its X and Y internal coordinates. */
cell_coordinates(cell(_,_,_,X,Y,_,_,_), X, Y).



/*get_cell_index(+Cell, -Index)

It gets a cell and it returns its unique Index. If the cell does not exist,
it returns -2 as a flag number to indicate it's not a real cell. */
get_cell_index([], -2).
get_cell_index(cell(_,_,_,_,_,_,_,Index), Index).



/*get_all_player_pieces(+Value, +Board, -Result)

It returns all the pieces of the Board that have the Value indicated. 
The result is in form of a list. */
get_all_player_pieces(_, [], []).
get_all_player_pieces(Player, [cell(Xa,Ya,Player,Xb,Yb,LeftD,RightD, Index)|T], [cell(Xa,Ya,Player,Xb,Yb,LeftD,RightD,Index)|Rs]):-
            get_all_player_pieces(Player, T, Rs).
get_all_player_pieces(Player, [cell(_,_,_,_,_,_,_, _)|T], R):-
            get_all_player_pieces(Player, T, R).



/*get_cell_from_coordinates(+X, +Y, +Board, -Result)

It gets the X and Y coordinates, the Board, and returns the cell with
the specified coordinates. If it doesn't find it, it returns the empty list. */
get_cell_from_coordinates(_, _, [], []).
get_cell_from_coordinates(X, Y, [cell(Xa,Ya,Value,X,Y,LeftD,RightD,Index)|_], cell(Xa,Ya,Value,X,Y,LeftD,RightD,Index)).
get_cell_from_coordinates(X, Y, [cell(_,_,_,_,_,_,_,_)|T], Cell):-
            get_cell_from_coordinates(X, Y, T, Cell).


/*get_column(+X, +Board, -Result)

Given an X coordinate, it returns all the cells that share that X coordinate, which 
is the Xth column of the board. */
get_column(_, [], []).
get_column(Xb, [cell(Xa,Ya,Value,Xb,Yb,LeftD,RightD, Index)|T], [cell(Xa,Ya,Value,Xb,Yb,LeftD,RightD,Index)|Rs]):-
            get_column(Xb, T, Rs).
get_column(Xb, [cell(_,_,_,_,_,_,_,_)|T], R):-
            get_column(Xb, T, R).



/*get_row(+Y, +Board, -Result)

Given a Y coordinate, it returns all the cells that share that Y coordinate, which 
is the Yth row of the board. */
get_row(_, [], []).
get_row(Yb, [cell(Xa,Ya,Value,Xb,Yb,LeftD,RightD, Index)|T], [cell(Xa,Ya,Value,Xb,Yb,LeftD,RightD,Index)|Rs]):-
            get_row(Yb, T, Rs).
get_row(Yb, [cell(_,_,_,_,_,_,_,_)|T], R):-
            get_row(Yb, T, R).



/*get_left_diag(+LeftD, +Board, -Result)

Given a Left Diagonal identifier, it returns all the cells that share it. */
get_left_diag(_, [], []).
get_left_diag(LeftD, [cell(Xa,Ya,Value,Xb,Yb,LeftD,RightD, Index)|T], [cell(Xa,Ya,Value,Xb,Yb,LeftD,RightD,Index)|Rs]):-
            get_left_diag(LeftD, T, Rs).
get_left_diag(LeftD, [cell(_,_,_,_,_,_,_,_)|T], R):-
            get_left_diag(LeftD, T, R).



/*get_right_diag(+LeftD, +Board, -Result)

Given a Right Diagonal identifier, it returns all the cells that share it. */
get_right_diag(_, [], []).
get_right_diag(RightD, [cell(Xa,Ya,Value,Xb,Yb,LeftD,RightD, Index)|T], [cell(Xa,Ya,Value,Xb,Yb,LeftD,RightD,Index)|Rs]):-
            get_right_diag(RightD, T, Rs).
get_right_diag(RightD, [cell(_,_,_,_,_,_,_,_)|T], R):-
            get_right_diag(RightD, T, R).            



/*change_board_cell(+Cell, +NewValue, +Board, -NewBoard)

It gets a cell and the new Value it should store, so it changes the Board to an updated
version NewBoard. */
change_board_cell(cell(Xa, Ya, _, Xb, Yb, LeftD, RightD, Index), NewValue, Board, NewBoard):-
            TrueIndex is Index-1,
            split_list(Board, TrueIndex, L, [_|Rs]),
            append(L, [cell(Xa,Ya, NewValue, Xb, Yb, LeftD, RightD, Index)|Rs], NewBoard).



/*print_bot_moves(+Cell1, +Cell2)

Prints the moves that the computer chose. */
print_bot_moves(cell(Xa,Ya,_,_,_,_,_,_), cell(Xb,Yb,_,_,_,_,_,_)):- 
            write(Xa), write(Ya), write(Xb), write(Yb).




/*clean_board_of_head(+Board, +Head1, +Head2, +Head3, +Head4, -CleanBoard

It creates a board where the specified heads don't exist. It is used for 
easier head movement management. */
clean_board_of_head(Board, Head1, Head2, Head3, Head4, CleanBoard):-
            change_board_cell(Head1, 0, Board, NewBoard1),
            change_board_cell(Head2, 0, NewBoard1, NewBoard2),
            change_board_cell(Head3, 0, NewBoard2, NewBoard3),
            change_board_cell(Head4, 0, NewBoard3, CleanBoard).



/*get_other_head_cells(+Cell, +Board, +Player, -Head2, Head3, Head4)

Given a Cell (which will be a Head Cell), a Board and a Player, it finds the
rest of the heads on the board, and it returns the other three cells that make up
the head. */
get_other_head_cells(cell(_,_,_,_,_,_,_,HeadIndex), Board, Player, Head2, Head3, Head4):-
            player_head(Player, HeadValue),
            get_all_player_pieces(HeadValue, Board, Heads),
            assign_heads(Heads, Head2, HeadIndex, NextHeads1),
            assign_heads(NextHeads1, Head3, HeadIndex, NextHeads2),
            assign_heads(NextHeads2, Head4, HeadIndex, _).



/*assign_heads(+HeadList, -Head, +OriginalHeadIndex, -NewHeadList)

Auxiliary function for get_other_head_cells. It assigns the first cell from the
HeadList that has an Index different from the first Head piece that the user
chose to move. */
assign_heads([cell(_,_,_,_,_,_,_,HeadIndex)|T], Head, HeadIndex, List):-
            assign_heads(T, Head, HeadIndex, List).
assign_heads([H|T], H, _, T).



/*cell_is_head(+Cell, +Head, -Result)

Checks if a specific cell is a head. */
cell_is_head(cell(_,_,Head,_,_,_,_,_), Head, 1).
cell_is_head(_, _, 0).







