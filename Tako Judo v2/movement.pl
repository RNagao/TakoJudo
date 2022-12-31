:-use_module(library(lists)).

/* This file contains the rule that were used for managing movement and 
its validity.*/


/*coordinates(+Cell, +Board, -Result)

Given a Cell and a Board, if a Cell with with its specific coordinates
exists inside the Board, the Result will be 1. */
coordinates([], _, 0).								  
coordinates(_, [], 0).
coordinates(cell(_,_,_,X,Y,_,_,_), [cell(_,_,_, X, Y, _,_,_)|_], 1).
coordinates(cell(_,_,_,X,Y,_,_,_), [cell(_,_,_, _, _, _,_,_)|T], R):-
            coordinates(cell(_,_,_,X,Y,_,_,_), T, R).



/*free_destination_square(+Cell1, +Cell2, +IsHead, -Result)

Given the starting Cell1 of the movement and the destination Cell2, it tells if 
the Destination is free (Value=0) for the player to go to. Cell1 and IsHead are used 
when the player wants to move the head, because then the destination cell
can be also a cell that contains the head itself. */
free_destination_square(_, [], _, 0).
free_destination_square(cell(_,_,Head,_,_,_,_,_),cell(_,_,0,_,_,_,_,_), Head, 1).
free_destination_square(cell(_,_,Head,_,_,_,_,_),cell(_,_,Head,_,_,_,_,_), Head, 1).
free_destination_square(_,cell(_,_,0,_,_,_,_,_), _, 1).
free_destination_square(_,cell(_,_,_,_,_,_,_,_), _, 0).



/*piece_ownership(+Cell1, +Player, +Head, +IsHead, -Result)

Given the cell with the piece that the player wants to move, the Result
indicates whether the piece is owned by the player or not. 
The IsHead is used only when checking head movement, because in that case
the code treats each head cell as a tentacle and checks, for their freedom
of movement, so it bypasses the ownership check.*/
piece_ownership(_, _, _, 1, 1).
piece_ownership([], _, _, 0, 0).
piece_ownership(cell(_,_,Player,_,_,_,_,_), Player, _, 0, 1).
piece_ownership(cell(_,_,Head,_,_,_,_,_), _, Head, 0, 1).
piece_ownership(_, _, _, 0, 0).



/*same_row(+Cell1, +Cell2, -Result)

Checks if the two cells are on the same row. */
same_row(cell(_,_,_,_,Y,_,_,_), cell(_,_,_,_,Y,_,_,_), 1).
same_row([], _, 0).
same_row(_, [], 0).
same_row(cell(_,_,_,_,_,_,_,_), cell(_,_,_,_,_,_,_,_), 0).



/*same_column(+Cell1, +Cell2, -Result)

Checks if the two cells are on the same column. */
same_column(cell(_,_,_,X,_,_,_,_), cell(_,_,_,X,_,_,_,_), 1).
same_column([], _, 0).
same_column(_, [], 0).
same_column(cell(_,_,_,_,_,_,_,_), cell(_,_,_,_,_,_,_,_), 0).



/*same_left_diag(+Cell1, +Cell2, -Result)

Checks if the two cells are on the same left diagonal. */
same_left_diag(cell(_,_,_,_,_,L,_,_), cell(_,_,_,_,_,L,_,_), 1).
same_left_diag([], _, 0).
same_left_diag(_, [], 0).
same_left_diag(cell(_,_,_,_,_,_,_,_), cell(_,_,_,_,_,_,_,_), 0).



/*same_right_diag(+Cell1, +Cell2, -Result)

Checks if the two cells are on the same right diagonal. */
same_right_diag(cell(_,_,_,_,_,_,R,_), cell(_,_,_,_,_,_,R,_), 1).
same_right_diag([], _, 0).
same_right_diag(_, [], 0).
same_right_diag(cell(_,_,_,_,_,_,_,_), cell(_,_,_,_,_,_,_,_), 0).




/*can_move(+Cell1, +Cell2, +Board, +Player, +LastMove, +Print, +IsHead, -Result)

Checks if a Player can move from Cell1 to Cell2 in this specific Board.
It uses the LastMove to check for Twiddling, has a clause for knowing
whether to print an error or not, and uses IsHead for when it gets used
for checking if head movement is possible.*/
can_move([], _, _, _, _, 0, _, 0). 
can_move(_, [], _, _, _, 0, _, 0).
can_move([], _, _, _, _, _, _, 0):- write('Invalid coordinates.'), nl.
can_move(_, [], _, _, _, _, _, 0):- write('Invalid coordinates.'), nl.
can_move(Cell1, Cell2, Board, Player, LastMove, Print, IsHead, R):-
            coordinates(Cell1, Board, R0), 
            coordinates(Cell2, Board, R1),
            player_head(Player, Head),
            piece_ownership(Cell1, Player, Head, IsHead, R8),
            free_destination_square(Cell1, Cell2, Head, R2),
            same_row(Cell1, Cell2, R3),
            same_column(Cell1, Cell2, R4), 
            same_left_diag(Cell1, Cell2, R5),
            same_right_diag(Cell1, Cell2, R6),
            moveset(R3, R4, R5, R6, R7),
            player_head(Player, Head),
            tentacles_in_sight(Cell1, Board, Player, Head, R9),
            free_line_movement(Cell1, Cell2, Board, R10),
            twiddling_container(Cell1, Cell2, Player, LastMove, IsHead, R11),
            free_movement(R0, R1, R2, R7, R8, R9, R10, R11, Print, R).



/*free_movement(+Coordinates1, +Coordinates2, +FreeDest, +InMoveset, +OwningPiece, +InSight,
+FreeLine, +Twiddling, +Print, -Result)

Checks if all the requirements are met for having a valid movement. 
The coordinates have to be valid, the Destination cell has to be free, 
the movement has to be legal, the player must own the piece,
the piece must be in sight of the tentacle and the line between
destination and arrival should be empty. Also the player can't
"Twiddle", going back to the square where they were in the turn before.
Print is used for printing the errors to make the player know what they did wrong. */
free_movement(1, 1, 1, 1, 1, 1, 1, 1, _, 1).
free_movement(0, _, _, _, _, _, _, _, 1, 0):- write('Invalid coordinates.'), nl.
free_movement(_, 0, _, _, _, _, _, _, 1, 0):- write('Invalid coordinates.'), nl.
free_movement(_, _, _, _, 0, _, _, _, 1, 0):- write('There are no tentacles you own on that starting square.'), nl.
free_movement(_, _, _, 0, _, _, _, _, 1, 0):- write('Illegal move: tentacles move in columns, rows or diagonals.'), nl.
free_movement(_, _, _, _, _, 0, _, _, 1, 0):- write('That tentacle isn\'t in sight of the head.'), nl.
free_movement(_, _, 0, _, _, _, _, _, 1, 0):- write('Destination square has to be empty.'), nl.
free_movement(_, _, _, _, _, _, 0, _, 1, 0):- write('The line between the starting square and the destination has to be empty.'), nl.
free_movement(_, _, _, _, _, _, _, 0, 1, 0):- write('Twiddling, bro.'), nl.
free_movement(_, _, _, _, _, _, _, _, 0, 0).  



/* moveset(+Column, +Row, +LeftDiagonal, +RightDiagonal, -Result)

It checks if any of the requirements for moving like a chess queen are met.*/
moveset(0,0,0,0,0).
moveset(_,_,_,_,1).



/*can_move_head(+Head1, +Head1Destination, +Board, +Player, +LastMove, 
-Head2, -Head2Destination, -Head3, -Head3Destination, -Head4, -Head4Destination,
+HeadLastMoves, -Result)

Checks if the head can move. It also returns all the other cells that make up the head,
and the destinations they should go to, according to the movement of the part of 
head that the player chose. It treats each part of the head as a tentacle and 
uses can_move to check if all of them can move; it also checks for head
twiddling (different than normal twiddling) and returns the availability status
of the movement.*/
can_move_head([], _, _, _, _, 0, _, _, _, _, _, _, 0).
can_move_head(_, [], _, _, _, 0, _, _, _, _, _, _, 0).
can_move_head([], _, _, _, _, 1, _, _, _, _, _, _, 0):- write('Invalid coordinates.'), nl.
can_move_head(_, [], _, _, _, 1, _, _, _, _, _, _, 0):- write('Invalid coordinates.'), nl.
can_move_head(Head1, Head1Destination, Board, Player, _, Print, Head2, Head2Destination, Head3, Head3Destination, Head4, Head4Destination, HeadLastMoves, R):-
            get_other_head_cells(Head1, Board, Player, Head2, Head3, Head4),
            cell_coordinates(Head1, Xfrom, Yfrom),
            cell_coordinates(Head1Destination, Xto, Yto),
            HorizontalMove is Xto-Xfrom,
            VerticalMove is Yto-Yfrom,
            

            cell_coordinates(Head2, Xafrom, Yafrom),
            cell_coordinates(Head3, Xbfrom, Ybfrom),
            cell_coordinates(Head4, Xcfrom, Ycfrom),

            
            Head2MoveX is Xafrom + HorizontalMove,
            Head3MoveX is Xbfrom + HorizontalMove,
            Head4MoveX is Xcfrom + HorizontalMove,
            Head2MoveY is Yafrom + VerticalMove,
            Head3MoveY is Ybfrom + VerticalMove,
            Head4MoveY is Ycfrom + VerticalMove,
            

            get_cell_from_coordinates(Head2MoveX, Head2MoveY, Board, Head2Destination),
            get_cell_from_coordinates(Head3MoveX, Head3MoveY, Board, Head3Destination),
            get_cell_from_coordinates(Head4MoveX, Head4MoveY, Board, Head4Destination),


            get_cell_index(Head1Destination, DestIndex1),
            get_cell_index(Head2Destination, DestIndex2),
            get_cell_index(Head3Destination, DestIndex3),
            get_cell_index(Head4Destination, DestIndex4),

            nth1(Player, HeadLastMoves, HeadMovesForTwiddling),
            get_start_index_head_twiddling(HeadMovesForTwiddling, StartIndex1, StartIndex2, StartIndex3, StartIndex4),
            head_twiddling(DestIndex1, DestIndex2, DestIndex3, DestIndex4,
            StartIndex1, StartIndex2, StartIndex3, StartIndex4, R5
            ), 
            clean_board_of_head(Board, Head1, Head2, Head3, Head4, CleanBoard),

            can_move(Head1, Head1Destination, CleanBoard, Player, last_move(-1,-1,-1,-1, 1), Print, 1, R1),
            can_move(Head2, Head2Destination, CleanBoard, Player, last_move(-1,-1,-1,-1, 1), 0, 1, R2),
            can_move(Head3, Head3Destination, CleanBoard, Player, last_move(-1,-1,-1,-1, 1), 0, 1, R3),
            can_move(Head4, Head4Destination, CleanBoard, Player, last_move(-1,-1,-1,-1, 1), 0, 1, R4),
            approve_head(R1,R2,R3,R4,R5,Print,R).



/*approve_head(+Head1CanMove, +Head2CanMove, +Head3CanMove, +Head4CanMove, +HeadNotTwiddling, +Print, -Result)

Checks if the overall head can move.*/
approve_head(1,1,1,1,1,1,1).
approve_head(1,1,1,1,1,0,1).
approve_head(_,_,_,_,0,1,0):- write('You\'re twiddling with your head... That\'s illegal.'),nl.
approve_head(_,_,_,_,_,_,0).


/*tentacles_in_sight(+Cell, +Board, +Player, +IsHead, -Result)

Given a cell the player wants to move, it checks to see if it is in sight of the head,
checking for rows, columns, and diagonals.*/
tentacles_in_sight([], _, _, _,0).    
tentacles_in_sight(cell(_, _, Head, _, _, _, _, _), _, _, Head, 1).       
tentacles_in_sight(cell(Xa, Ya, Value, Xb, Yb, LeftD, RightD, Index), Board, Player, _, R):-
            get_row(Yb, Board, Row),
            list_in_sight(cell(Xa, Ya, Value, Xb, Yb, LeftD, RightD, Index), Row, Player, R1),
            
            get_column(Xb, Board, Column),
            list_in_sight(cell(Xa, Ya, Value, Xb, Yb, LeftD, RightD, Index), Column, Player, R2),
            
            get_left_diag(LeftD, Board, LeftDiagonal),
            list_in_sight(cell(Xa, Ya, Value, Xb, Yb, LeftD, RightD, Index), LeftDiagonal, Player, R3),
            
            get_right_diag(RightD, Board, RightDiagonal),
            list_in_sight(cell(Xa, Ya, Value, Xb, Yb, LeftD, RightD, Index), RightDiagonal, Player, R4),
            sight(R1, R2, R3, R4, R).


/*sight(+Row, +Column, +LeftDiagonal, +RightDiagonal, -Result)

Checks if the tentacle is visible in any way. */
sight(0, 0, 0, 0, 0).
sight(_, _, _, _, 1).
            

/*list_in_sight(+Cell, +List, +Player, -Result)

Given a List that has the Cell we want to move, it splits it in two at the index
of the cell, and then it reverses the left side of the list after adding the
cell on the index, so that the Lists start with the cells. It then tests if any
these two lists are in sight of the head.
*/
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



/*left_or_right(+Left, -Right, -Result) 

Auxiliary to list_in_sight, it checks if any of the lists are in sight of the head.*/
left_or_right(0, 0, 0).
left_or_right(_, _, 1).



/*free_space(+Destination, +Player, +List, -Result)

Checks if the line between the Destination(Head of the player) and
the Player is empty (the cells between them are value 0).*/
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



/*free_line_movement(+Cell1, +Cell2, +Board, -Result)

Given starting cell and destination cell, it checks whether they are on the same
row, column, or diagonal; after finding that, it returns the corresponding 
list of elements.*/
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


/*free_movement_list(+Cell1, +Cell2, +List, -Result)

Given starting cell, destination cell and the line that they belong to, it finds where
the destination cell is, and divides the list in two parts using the destination as 
an index. The left list is added the Destination cell and then reversed, and we
check the two lists to see if the space inbetween Cell1 and Cell2 is available. */
free_movement_list(cell(_,_,_,_,_,_,_,Index), cell(_,_,Value2,_,_,_,_,Index2), List, R):-
            nth0(DestIndex, List, cell(_, _, _, _, _, _, _, Index2)),
            split_list(List, DestIndex, Ls, Rs),
            append(Ls, [cell(_, _, Value2, _, _, _, _, Index2)], Ls1),
            reverseList(Ls1, Ls2),
            free_inbetween_space(Index2, Index, Ls2, R1),
            free_inbetween_space(Index2, Index, Rs, R2),
            left_or_right(R1, R2, R).



/*free_inbetween_space(+DestIndex, +StartIndex, +List, -Result)

It returns true when the cells between the cell with the DestIndex
and the StartIndex are all empty (Value is 0). */
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

free_inbetween_space( _, _, 
[cell(_,_,_,_,_,_,_,_)|_], 0).

free_inbetween_space(_, _, [], 0).
free_inbetween_space(_, _, _, 0).



/*valid_movements(+Player, +Board, +LastMove, +HeadLastMoves, -Result)

It searches for all the valid movements that the player can do in that board.
It looks for the possible tentacle movements and for the possible head movements, 
since they work in different ways. It gets a list of the pieces of the player
and of the empty squares of the board, then uses manage_piece_testing
to test the pieces. */
valid_movements(Player, Board, LastMove, HeadLastMoves, R):-
            get_all_player_pieces(Player, Board, Pieces),
            player_head(Player, Head),
            get_all_player_pieces(Head, Board, Heads),
            get_all_player_pieces(0, Board, FreeSquares),
            get_all_player_pieces(0, Board, FreeSquares2),
            manage_piece_testing(Heads, FreeSquares2, Board, Player, LastMove, 1, HeadLastMoves, R2),
            manage_piece_testing(Pieces, FreeSquares, Board, Player, LastMove, 0, HeadLastMoves, R1),
            append(R1, R2, R).



/*manage_piece_testing(+PiecesList, +FreeSquares, +Board, +Player, +LastMove, +IsHead, 
+HeadLastMoves, -Result)

Auxiliary to valid_movements, it calls test_pieces to test a single piece gainst
all the empty squares; it gets the result, excludes the empty elements, and then
continues with the next piece of the PiecesList.*/
manage_piece_testing([], _, _, _, _, _, _, []).
manage_piece_testing([Piece|Pieces], FreeSquares, Board, Player, LastMove, IsHead, HeadLastMoves, [Y|Ys]):-
            test_pieces(Piece, FreeSquares, Board, Player, LastMove, IsHead, HeadLastMoves, ResultList), 
            exclude(empty, ResultList, Y),
            manage_piece_testing(Pieces, FreeSquares, Board, Player, LastMove, IsHead, HeadLastMoves, Ys).



/*test_pieces(+Piece, +FreeSquares, +Board, +Player, +LastMove, +IsHead, 
+HeadLastMoves, -Result)

Auxiliary to manage_piece_testing, it gets one single piece and a list of the
free squares of the board. It will call test_single_piece to test it against
all of the squares. */
test_pieces(_, [], _, _, _, _, _, []).
test_pieces(Piece, [H|Ts], Board, Player, LastMove, IsHead, HeadLastMoves, [Y|Ys]):-
            test_single_piece(Piece, H, Board, Player, LastMove, IsHead, HeadLastMoves, Y),
            test_pieces(Piece, Ts, Board, Player, LastMove, IsHead, HeadLastMoves, Ys).



/*test_single_piece(+Piece, +Destination, +Board, +Player, +LastMove, +IsHead, 
+HeadLastMoves, -Result)

It tests if a Piece can go to a Destination (if the move is valid). If it is,
it adds the piece to a list of valid movements. IsHead is used for testing
head pieces. */
test_single_piece(Piece, Destination, Board, Player, LastMove, 0, _, Result):-
            can_move(Piece, Destination, Board, Player, LastMove, 0, 0, R),
            add_piece_to_valid_list(R, Piece-Destination, Result).
test_single_piece(Piece, Destination, Board, Player, LastMove, 1, HeadLastMoves, Result):-
            can_move_head(Piece, Destination, Board, Player, LastMove, 0, _, _, _, _, _, _, HeadLastMoves, R),
            add_piece_to_valid_list(R, Piece-Destination, Result).



/*add_piece_to_valid_list(+R, +Piece-Destination, -Result)

If the piece is valid and R is equal to 1, it adds the Piece-Destination pair
to a list. */
add_piece_to_valid_list(1, Piece-Destination, Piece-Destination).
add_piece_to_valid_list(0, _, []).



/*twiddling_container(+Cell1, +Cell2, +Player, +LastMove, +IsHead, -R)

A container for calling twiddling/7 to check for tentacle twiddling. It gets the 
two cells and extracts the coordinates from them then calls the term. If it's
an Head, R is 1(no twiddling) because the twiddling for the head is different 
than twiddling for the tentacles.*/
twiddling_container(_, _, _, _, 1, 1).
twiddling_container(cell(_,_,_,XFrom,YFrom,_,_,_), cell(_,_,_,XTo,YTo,_,_,_), Player, LastMove, 0, R):-
        twiddling(Player, XFrom, YFrom, XTo, YTo, LastMove, R).



/*twiddling(+Player, +XFrom, +YFrom, +XTo, +YTo, +LastMove, -Result)

It checks if the coordinates the player wants to go to are equal to the coordinates
where he was in the LastMove. If they are, the player is twiddling, so the 
result is 0 (it won't pass the valid movement test).*/
twiddling(Player, XFrom, YFrom, XTo, YTo, last_move(XTo, YTo, XFrom, YFrom, Player), 0).
twiddling(_, _, _, _, _, _, 1).



/*head_twiddling(+Dest1, +Dest2, +Dest3, +Dest4, +Start1, +Start2, +Start3, +Start4, -R)

It checks if the destinations of the parts of the head are the same as where the 
parts of the head were in the turn before. Since one can move the head by choosing
any part of it, it checks if the lists are permutations of one another, since
the order of the pieces is not always the same.*/
head_twiddling(NewDestIndex1, NewDestIndex2, NewDestIndex3, NewDestIndex4,
OldStartIndex1, OldStartIndex2, OldStartIndex3, OldStartIndex4, R):-
        (permutation([NewDestIndex1, NewDestIndex2, NewDestIndex3, NewDestIndex4],
        [OldStartIndex1, OldStartIndex2, OldStartIndex3, OldStartIndex4]) -> R is 0;
        R is 1).


/* get_start_index_head_twiddling(+HeadLastMove, -StartIndex1, -StartIndex2,
 -StartIndex3, -StartIndex4) 

Gets the Indexes of the cells where the head was in the last move, so that 
the indexes can get used for checking twiddling.*/
get_start_index_head_twiddling(head_last_move(StartIndex1, StartIndex2, StartIndex3, StartIndex4, _, _, _, _, _), StartIndex1, StartIndex2, StartIndex3, StartIndex4).



/*valid_movements_level2(+Movements, +Board, +Player, +LastMoves, +HeadLastMoves, +Min,
-CurrentPiece, -CurrentDestination, -Result)

Used for Level 2 AI. Getting the list of valid movements and all the rest of the
information, it tries all of the valid movements possible, modifying
the board, and for each of them it checks how it affects the board:
if the opponent player has less possible moves, "Min" is updated,
and the new best move is put in the Result.*/
valid_movements_level2([_|[]], _, _, _, _, _, RPiece, RDest, RPiece-RDest).
valid_movements_level2([(Piece-Destination)|T], Board, Player, LastMoves, HeadLastMoves, Min, RPiece, RDest, Result):-
            player_head(Player, Head),
            moving_head(Head, Piece, MovingHead),
            nth1(Player, LastMoves, LastMove),
            (MovingHead = 1 -> can_move_head(Piece, Destination, Board, Player, LastMove, 1, Head2, Head2Destination, Head3, Head3Destination, Head4, Head4Destination, HeadLastMoves, _),
                    change_board_cell(Piece, 0, Board, NewBoard1),
                    change_board_cell(Head2, 0, NewBoard1, NewBoard2),
                    change_board_cell(Head3, 0, NewBoard2, NewBoard3),
                    change_board_cell(Head4, 0, NewBoard3, NewBoard4),
                    change_board_cell(Destination, Head, NewBoard4, NewBoard5),
                    change_board_cell(Head2Destination, Head, NewBoard5, NewBoard6),
                    change_board_cell(Head3Destination, Head, NewBoard6, NewBoard7),
                    change_board_cell(Head4Destination, Head, NewBoard7, FinalBoard);

                    change_board_cell(Piece, 0, Board, NewBoard1),
                    change_board_cell(Destination, Player, NewBoard1, FinalBoard)
            ),
            next_player(Player, AdversaryPlayer),
            nth1(AdversaryPlayer, LastMoves, APLastMove),
            valid_movements(AdversaryPlayer, FinalBoard, APLastMove, HeadLastMoves, R1),
            flatten(R1, R2),
            length(R2, Value), 
            (Value < Min -> valid_movements_level2(T, Board, Player, LastMoves, HeadLastMoves, Value, Piece, Destination, Result);
            valid_movements_level2(T, Board, Player, LastMoves, HeadLastMoves, Min, RPiece, RDest, Result)).


            
/*switch_last_move(+Player, +XFrom, +YFrom, +XTo, +YTo, +LastMoves, -CurrentMoves)

LastMoves is a list of two elements. First element is the last moves for Player 1
and second element has the last moves for Player 2. This updates the last moves
depending on what player has played.*/
switch_last_move(1, XFrom, YFrom, XTo, YTo, [_|T], [last_move(XFrom, YFrom, XTo, YTo, 1)|T]).
switch_last_move(2, XFrom, YFrom, XTo, YTo, [H|_], CurrentMoves):-
            append([H], [last_move(XFrom, YFrom, XTo, YTo, 2)], CurrentMoves).



/*switch_last_head_move_container(+Player, +Head1, +Head2, +Head3, +Head4,
 +Head1Destination, +Head2Destination, +Head3Destination, +Head4Destination,
 +HeadLastMoves, -NewMoves)

It's a wrapper for switch_last_head_move, it gets the indexes of all the starting
and destination cells of the head.*/
switch_last_head_move_container(Player, cell(_,_,_,_,_,_,_,StartIndex1),
        cell(_,_,_,_,_,_,_,StartIndex2),
        cell(_,_,_,_,_,_,_,StartIndex3),
        cell(_,_,_,_,_,_,_,StartIndex4),
        cell(_,_,_,_,_,_,_,DestIndex1),
        cell(_,_,_,_,_,_,_,DestIndex2),
        cell(_,_,_,_,_,_,_,DestIndex3),
        cell(_,_,_,_,_,_,_,DestIndex4),
        HeadLastMoves, NewMoves):-
            switch_last_head_move(Player, StartIndex1, StartIndex2, 
            StartIndex3, StartIndex4, DestIndex1, DestIndex2, 
            DestIndex3, DestIndex4, HeadLastMoves, NewMoves).



/*switch_last_head_move(+Player, +StartIndex1, +StartIndex2, +StartIndex3, +StartIndex4, 
+DestIndex1, +DestIndex2, +DestIndex3, +DestIndex4, +HeadLastMoves, -NewMoves)

HeadLastMoves works like an array with two elements, first element are the 
last head moves of Player 1, and the second is for Player 2. This switches
the last head moves with the current ones.*/
switch_last_head_move(1, StartIndex1, StartIndex2, StartIndex3, StartIndex4, 
            DestIndex1, DestIndex2, DestIndex3, DestIndex4, 
            [_|T],
            [head_last_move(StartIndex1, 
            StartIndex2, StartIndex3, StartIndex4, 
            DestIndex1, DestIndex2, DestIndex3, DestIndex4, 1)|T]).
switch_last_head_move(2, StartIndex1, StartIndex2, StartIndex3, StartIndex4, 
            DestIndex1, DestIndex2, DestIndex3, DestIndex4, [H|_], CurrentMoves):-
            append([H], [head_last_move(StartIndex1, 
            StartIndex2, StartIndex3, StartIndex4, 
            DestIndex1, DestIndex2, DestIndex3, DestIndex4, 2)], CurrentMoves).



/*moving_head(+Head, +Cell, -Result)

Checks if the player is moving a cell that contains a head. */
moving_head(PlayerHead, cell(_,_,PlayerHead,_,_,_,_,_), 1).
moving_head(_, _, 0).

