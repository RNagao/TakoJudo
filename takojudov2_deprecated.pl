:-use_module(library(lists)).

/* ascii equivalents of the numbers we store in the matrix  */
ascii(0):-  write(' ').    /* Blank space */
ascii(1):-  print(~).      /* Tentacle of player 1 */
ascii(-1):- print(@).      /* Head of player 1 */
ascii(2):-  print(\).      /* Tentacle of player 2 */
ascii(-2):- print('O').    /* Head of player 2  */

/* translating the board coordinates to the internal coordinates */
translate_input_x('a',0).
translate_input_x('b',1).
translate_input_x('c',2).
translate_input_x('d',3).
translate_input_x('e',4).
translate_input_x('f',5).
translate_input_x('g',6).
translate_input_x('h',7).
translate_input_x(_,-1).

translate_input_y('1',7).
translate_input_y('2',6).
translate_input_y('3',5).
translate_input_y('4',4).
translate_input_y('5',3).
translate_input_y('6',2).
translate_input_y('7',1).
translate_input_y('8',0).
translate_input_y(_,-1).

player_head(1, -1).
player_head(2, -2).
cell(X, Y, Value, Row, Column, Left_diagonal, Right_diagonal, Index).

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

next_player(1,2).
next_player(2,1).

print_board([], _):- 
			write(+---+---+---+---+---+---+---+---+), nl,
			write('  a   b   c   d   e   f   g   h'), nl, nl.
print_board(Board, X):- 
			write(+---+---+---+---+---+---+---+---+), nl,
            split_list(Board, 8, LeftList, RightList),
			print_line(LeftList, X), 
			Y is X-1,
			print_board(RightList, Y).

print_line([], X):- 
			write('|'), write(' '), write(X), nl.
print_line([H|T], X):- 
			print_cell(H),
			print_line(T, X).

print_cell(cell(_,_,Value,_,_,_,_,_)):- 
			write('|'), write(' '), ascii(Value), write(' ').


split_list([], _, [], []).
split_list(T, 0, [], T).
split_list([H|T], X, [H|LeftList], RightList):-
            X1 is X-1,
            split_list(T, X1, LeftList, RightList).

reverseList([],[]). 
reverseList([H|T], R):-
    reverseList(T, R1), append(R1, [H], R). 

coordinates([], _, 0).								  
coordinates(_, [], 0).
coordinates(cell(_,_,_,X,Y,_,_,_), [cell(_,_,_, X, Y, _,_,_)|_], 1).
coordinates(cell(_,_,_,X,Y,_,_,_), [cell(_,_,_, _, _, _,_,_)|T], R):-
            coordinates(cell(_,_,_,X,Y,_,_,_), T, R).

free_destination_square([],0).
free_destination_square(cell(_,_,0,_,_,_,_,_),1).
free_destination_square(cell(_,_,0,_,_,_,_,_),0).

piece_ownership([], _, 0).
piece_ownership(cell(_,_,Player,_,_,_,_,_), Player, 1).
piece_ownership(cell(_,_,_,_,_,_,_,_), Player, 0).

same_row(cell(_,_,_,_,Y,_,_,_), cell(_,_,_,_,Y,_,_,_), 1).
same_row([], _, 0).
same_row(_, [], 0).
same_row(cell(_,_,_,_,_,_,_,_), cell(_,_,_,_,_,_,_,_), 0).

same_column(cell(_,_,_,X,_,_,_,_), cell(_,_,_,X,_,_,_,_), 1).
same_column([], _, 0).
same_column(_, [], 0).
same_column(cell(_,_,_,_,_,_,_,_), cell(_,_,_,_,_,_,_,_), 0).

same_left_diag(cell(_,_,_,_,_,L,_,_), cell(_,_,_,_,_,L,_,_), 1).
same_left_diag([], _, 0).
same_left_diag(_, [], 0).
same_left_diag(cell(_,_,_,_,_,_,_,_), cell(_,_,_,_,_,_,_,_), 0).

same_right_diag(cell(_,_,_,_,_,_,R,_), cell(_,_,_,_,_,_,R,_), 1).
same_right_diag([], _, 0).
same_right_diag(_, [], 0).
same_right_diag(cell(_,_,_,_,_,_,_,_), cell(_,_,_,_,_,_,_,_), 0).

moveset(0,0,0,0,0).
moveset(_,_,_,_,1).

/* free_movement(Coordinates1, Coordinates2, FreeDest, InMoveset, OwningPiece, InSight,
FreeLine R) */
free_movement(1, 1, 1, 1, 1, 1, 1,  1).
free_movement(0, _, _, _, _, _, _, 0):- write('Invalid coordinates.'), nl.
free_movement(_, 0, _, _, _, _, _, 0):- write('Invalid coordinates.'), nl.
free_movement(_, _, _, _, 0, _, _, 0):- write('There are no tentacles you own on that starting square.'), nl.
free_movement(_, _, _, 0, _, _, _, 0):- write('Illegal move: tentacles move in columns, rows or diagonals.'), nl.
free_movement(_, _, _, _, _, 0, _, 0):- write('That tentacle isn\'t in sight of the head.'), nl.
free_movement(_, _, 0, _, _, _, _, 0):- write('Destination square has to be empty.'), nl.
free_movement(_, _, _, _, _, _, 0, 0):- write('The line between the starting square and the destination has to be empty.'), nl.

can_move([], _, _, _, 0):- write('Invalid coordinates.'), nl.
can_move(_, [], _, _, 0):- write('Invalid coordinates.'), nl.
can_move(Cell1, Cell2, Board, Player, R):-
            coordinates(Cell1, Board, R0),
            coordinates(Cell2, Board, R1),
            piece_ownership(Cell1, Player, R8),
            free_destination_square(Cell2, R2),
            same_row(Cell1, Cell2, R3), 
            same_column(Cell1, Cell2, R4), 
            same_left_diag(Cell1, Cell2, R5), 
            same_right_diag(Cell1, Cell2, R6), 
            moveset(R3, R4, R5, R6, R7),
            player_head(Player, Head),
            tentacles_in_sight(Cell1, Board, Player, R9),
            free_line_movement(Cell1, Cell2, Board, R10),
            free_movement(R0, R1, R2, R7, R8, R9, R10, R).


get_cell_from_coordinates(_, _, [], []).
get_cell_from_coordinates(X, Y, [cell(Xa,Ya,Value,X,Y,LeftD,RightD,Index)|_], cell(Xa,Ya,Value,X,Y,LeftD,RightD,Index)).
get_cell_from_coordinates(X, Y, [cell(_,_,_,_,_,_,_,_)|T], Cell):-
            get_cell_from_coordinates(X, Y, T, Cell).

change_board_cell(cell(Xa, Ya, _, Xb, Yb, LeftD, RightD, Index), NewValue, Board, NewBoard):-
            TrueIndex is Index-1,
            split_list(Board, TrueIndex, L, [_|Rs]),
            append(L, [cell(Xa,Ya, NewValue, Xb, Yb, LeftD, RightD, Index)|Rs], NewBoard).

get_column(_, [], []).
get_column(Xb, [cell(Xa,Ya,Value,Xb,Yb,LeftD,RightD, Index)|T], [cell(Xa,Ya,Value,Xb,Yb,LeftD,RightD,Index)|Rs]):-
            get_column(Xb, T, Rs).
get_column(Xb, [cell(_,_,_,_,_,_,_,_)|T], R):-
            get_column(Xb, T, R).

get_row(_, [], []).
get_row(Yb, [cell(Xa,Ya,Value,Xb,Yb,LeftD,RightD, Index)|T], [cell(Xa,Ya,Value,Xb,Yb,LeftD,RightD,Index)|Rs]):-
            get_row(Yb, T, Rs).
get_row(Yb, [cell(_,_,_,_,_,_,_,_)|T], R):-
            get_row(Yb, T, R).

get_left_diag(_, [], []).
get_left_diag(LeftD, [cell(Xa,Ya,Value,Xb,Yb,LeftD,RightD, Index)|T], [cell(Xa,Ya,Value,Xb,Yb,LeftD,RightD,Index)|Rs]):-
            get_left_diag(LeftD, T, Rs).
get_left_diag(LeftD, [cell(_,_,_,_,_,_,_,_)|T], R):-
            get_left_diag(LeftD, T, R).

get_right_diag(_, [], []).
get_right_diag(RightD, [cell(Xa,Ya,Value,Xb,Yb,LeftD,RightD, Index)|T], [cell(Xa,Ya,Value,Xb,Yb,LeftD,RightD,Index)|Rs]):-
            get_right_diag(RightD, T, Rs).
get_right_diag(RightD, [cell(_,_,_,_,_,_,_,_)|T], R):-
            get_right_diag(RightD, T, R).            

free_space(Destination, Player,
[cell(_,_,Player,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,Destination,_,_,_,_,_)], 1).

free_space(Destination, Player,
[cell(_,_,Player,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,Destination,_,_,_,_,_)|_], 1).

free_space(Destination, Player,
[cell(_,_,Player,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,Destination,_,_,_,_,_)|_], 1).

free_space(Destination, Player,
[cell(_,_,Player,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,Destination,_,_,_,_,_)|_], 1).

free_space(Destination, Player,
[cell(_,_,Player,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,Destination,_,_,_,_,_)|_], 1).

free_space(Destination, Player,
[cell(_,_,Player,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,Destination,_,_,_,_,_)|_], 1).

free_space(Destination, Player,
[cell(_,_,Player,_,_,_,_,_), 
cell(_,_,Destination,_,_,_,_,_)|_], 1).

free_space(Destination, _, 
[cell(_,_,Destination,_,_,_,_,_)|_], 0).

free_space(_, Player,
[cell(_,_,Player,_,_,_,_,_)], 0).


free_space(_, _,  [], 0).
free_space(_, _, _, 0).

/* */
free_inbetween_space(DestIndex, StartIndex,
[cell(_,_,_,_,_,_,_,DestIndex), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,_,_,_,_,_,StartIndex)], 1).

free_inbetween_space(DestIndex, StartIndex,
[cell(_,_,_,_,_,_,_,DestIndex), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,_,_,_,_,_,StartIndex)|_], 1).

free_inbetween_space(DestIndex, StartIndex,
[cell(_,_,_,_,_,_,_,DestIndex), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,_,_,_,_,_,StartIndex)|_], 1).

free_inbetween_space( DestIndex, StartIndex,
[cell(_,_,_,_,_,_,_,DestIndex), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,_,_,_,_,_,StartIndex)|_], 1).

free_inbetween_space( DestIndex, StartIndex,
[cell(_,_,_,_,_,_,_,DestIndex), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,_,_,_,_,_,StartIndex)|_], 1).

free_inbetween_space(DestIndex, StartIndex,
[cell(_,_,_,_,_,_,_,DestIndex), 
cell(_,_,0,_,_,_,_,_), 
cell(_,_,_,_,_,_,_,StartIndex)|_], 1).

free_inbetween_space(DestIndex, StartIndex,
[cell(_,_,_,_,_,_,_,DestIndex), 
cell(_,_,_,_,_,_,_,StartIndex)|_], 1).

free_inbetween_space(DestIndex, _,
[cell(_,_,_,_,_,_,_,DestIndex)|_], 0).

free_inbetween_space( _, StartIndex, 
[cell(_,_,Player,_,_,_,_,_)|_], 0).


free_inbetween_space(_, _, [], 0).
free_inbetween_space(_, _, _, 0).

left_or_right(0, 0, 0).
left_or_right(_, _, 1).

list_in_sight(cell(Xa, Ya, Player, Xb, Yb, LeftD, RightD, Index), List, Player, R):-
            nth0(ElemIndex, List, cell(Xa, Ya, Value, Xb, Yb, LeftD, RightD, Index)),
            split_list(List, ElemIndex, Ls, Rs),
            append(Ls, [cell(Xa, Ya, Value, Xb, Yb, LeftD, RightD, Index)], Ls1),
            reverseList(Ls1, Ls2),
            player_head(Player, Head),
            free_space(Head, Player, Ls2, R1),
            free_space(Head, Player, Rs, R2),
            left_or_right(R1, R2, R).
list_in_sight(cell(_, _, _, _, _, _, _, _), _, _, 0).

sight(0, 0, 0, 0, 0).
sight(_, _, _, _, 1).
            
tentacles_in_sight([], _, _, 0).           
tentacles_in_sight(cell(Xa, Ya, Value, Xb, Yb, LeftD, RightD, Index), Board, Player, R):-
            get_row(Yb, Board, Row),
            list_in_sight(cell(Xa, Ya, Value, Xb, Yb, LeftD, RightD, Index), Row, Player, R1),
            
            get_column(Xb, Board, Column),
            list_in_sight(cell(Xa, Ya, Value, Xb, Yb, LeftD, RightD, Index), Column, Player, R2),
            
            get_left_diag(LeftD, Board, LeftDiagonal),
            list_in_sight(cell(Xa, Ya, Value, Xb, Yb, LeftD, RightD, Index), LeftDiagonal, Player, R3),
            
            get_right_diag(RightD, Board, RightDiagonal),
            list_in_sight(cell(Xa, Ya, Value, Xb, Yb, LeftD, RightD, Index), RightDiagonal, Player, R4),
            sight(R1, R2, R3, R4, R).


free_line_movement([], _, _, 0).
free_line_movement(_, [], _, 0).
free_line_movement(cell(Xa,Ya,Value,Xb,Yb,LeftD,RightD,Index), cell(Xa,Ya2,Value2,Xb,Yb2,LeftD2,RightD2,Index2), Board, R):-
            get_column(Xb, Board, List),
            free_movement_list(cell(Xa,Ya,Value,Xb,Yb,LeftD,RightD,Index), cell(Xa,Ya2,Value2,Xb,Yb2,LeftD2,RightD2,Index2), List, R).

free_line_movement(cell(Xa,Ya,Value,Xb,Yb,LeftD,RightD,Index), cell(Xa2,Ya,Value2,Xb2,Yb,LeftD2,RightD2,Index2), Board, R):-
            get_row(Yb, Board, List),
            free_movement_list(cell(Xa,Ya,Value,Xb,Yb,LeftD,RightD,Index), cell(Xa2,Ya,Value2,Xb2,Yb,LeftD2,RightD2,Index2), List, R).

free_line_movement(cell(Xa,Ya,Value,Xb,Yb,LeftD,RightD,Index), cell(Xa2,Ya2,Value2,Xb2,Yb2,LeftD,RightD2,Index2), Board, R):-
            get_left_diag(LeftD, Board, List),
            free_movement_list(cell(Xa,Ya,Value,Xb,Yb,LeftD,RightD,Index), cell(Xa2,Ya2,Value2,Xb2,Yb2,LeftD,RightD2,Index2), List, R).

free_line_movement(cell(Xa,Ya,Value,Xb,Yb,LeftD,RightD,Index), cell(Xa2,Ya2,Value2,Xb2,Yb2,LeftD2,RightD,Index2), Board, R):-
            get_right_diag(RightD, Board, List),
            free_movement_list(cell(Xa,Ya,Value,Xb,Yb,LeftD,RightD,Index), cell(Xa2,Ya2,Value2,Xb2,Yb2,LeftD2,RightD,Index2), List, R).

free_line_movement(_, _, _, 0).


free_movement_list(cell(Xa,Ya,Value,Xb,Yb,LeftD,RightD,Index), cell(Xa2,Ya2,Value2,Xb2,Yb2,LeftD2,RightD2,Index2), List, R):-
            nth0(DestIndex, List, cell(Xa2, Ya2, Value2, Xb2, Yb2, LeftD2, RightD2, Index2)),
            split_list(List, DestIndex, Ls, Rs),
            append(Ls, [cell(Xa2, Ya2, Value2, Xb2, Yb2, LeftD2, RightD2, Index2)], Ls1),
            reverseList(Ls1, Ls2),
            free_inbetween_space(Index2, Index, Ls2, R1),
            free_inbetween_space(Index2, Index, Rs, R2),
            left_or_right(R1, R2, R).

get_all_player_pieces(_, [], []).
get_all_player_pieces(Player, [cell(Xa,Ya,Player,Xb,Yb,LeftD,RightD, Index)|T], [cell(Xa,Ya,Player,Xb,Yb,LeftD,RightD,Index)|Rs]):-
            get_all_player_pieces(Player, T, Rs).
get_all_player_pieces(Player, [cell(_,_,_,_,_,_,_, _)|T], R):-
            get_all_player_pieces(Player, T, R).

test_piece(Piece, Board, Player, Results):-
            findall(Piece, can_move(Piece, Cell2, Board, Player, 1), Results).
valid_movements(Player, Board, Results):-
            get_all_player_pieces(Player, Board, [H|T]),
            test_piece(H, Board, Player, Results).

play:-      
            init_board(X),
	        playing(1,X).
				

playing(Player, Board):-
			print_board(Board, 8), nl,
			write('Player '), write(Player), write('\'s turn.'), nl,
			write('X coordinate of the piece you want to move.'), nl,
			get_char(X1), skip_line, nl,
			write('Y coordinate of the piece you want to move.'), nl,
			get_char(Y1), skip_line, nl,
			write('X coordinate of where you want to move.'), nl,
			get_char(X2),  skip_line, nl,
			write('Y coordinate of where you want to move.'), nl,
			get_char(Y2), skip_line, nl,
			write(X1),write(Y1),write(X2),write(Y2),nl,

            translate_input_x(X1,XFrom),
            translate_input_y(Y1,YFrom),
            translate_input_x(X2,XTo),
            translate_input_y(Y2,YTo),

            get_cell_from_coordinates(XFrom, YFrom, Board, Cell1),!,
            get_cell_from_coordinates(XTo, YTo, Board, Cell2),!,
            
			can_move(Cell1, Cell2, Board, Player, R),
            
            (R = 1 ->
                change_board_cell(Cell1, 0, Board, NewBoard1),
                change_board_cell(Cell2, Player, NewBoard1, NewBoard),
                next_player(Player, NP),!,
                playing(NP, NewBoard);
            playing(Player, Board),!
            ).

/*
    Adding head movement
    Adding twiddling
    Adding all moves
    Adding menu
    Adding winning and losing
*/
