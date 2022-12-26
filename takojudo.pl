:-use_module(library(lists)).

/* ascii equivalents of the numbers we store in the matrix  */
ascii(0):-  write(' ').    /* Blank space */
ascii(1):-  print(~).      /* Tentacle of player 1 */
ascii(-1):- print(@).      /* Head of player 1 */
ascii(2):-  print(\).      /* Tentacle of player 2 */
ascii(-2):- print('O').    /* Head of player 2  */

/* translating the board coordinates to the matrix coordinates */
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


/* initial state of the board */
init_board([[0,0,1,-1,-1,1,0,0],
			[0,0,1,-1,-1,1,0,0],
			[0,0,1,1,1,1,0,0],
			[0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0],
			[0,0,2,2,2,2,0,0],
			[0,0,2,-2,-2,2,0,0],
			[0,0,2,-2,-2,2,0,0]]).




/* printing the board */
print_board([], _):- 
			write(+---+---+---+---+---+---+---+---+), nl,
			write('  a   b   c   d   e   f   g   h'), nl, nl.
print_board([H|T], X):- 
			write(+---+---+---+---+---+---+---+---+), nl,
			print_line(H, X), 
			Y is X-1,
			print_board(T, Y).

print_line([], X):- 
			write('|'), write('  '), write(X), nl.
print_line([H|T], X):- 
			print_cell(H),
			print_line(T, X).

print_cell(X):- 
			write('|'), write(' '), ascii(X), write(' ').


/* changing the matrix */
replace(N, 0, [_|T], Result):- 
			append([N], T, Result).
replace(N, Index, [H|T], Result):- 
			Index1 is Index-1,
			replace(N, Index1, T, X),
			append([H], X, Result). 

row(_, [], []).
row(I, Board, R):-
		nth0(I, Board, R).

column( _, [], []).
column(I, [X|Xs], [Y|Ys]) :-
			nth0(I, X, Y),
			column(I, Xs, Ys).

right_diagonal(_, _, [], _, _).
right_diagonal(X, Y, [H|T], Level, [R|Rs]):-
			Sum is X+Y,
			Index is Sum-Level,
			Level1 is Level+1,
			(Index > -1, Index < 8 -> 
				nth0(Index, H, R),
				right_diagonal(X, Y, T, Level1, Rs);
				R is 0, right_diagonal(X, Y, T, Level1, Rs)
			).

left_diagonal(_, _, [], _, _).
left_diagonal(X, Y, [H|T], Level, [R|Rs]):-
			Difference is X-Y,
			Index is Difference+Level,
			Level1 is Level+1,
			(Index > -1, Index < 8 -> 
				nth0(Index, H, R),
				left_diagonal(X, Y, T, Level1, Rs);
				R is 0, left_diagonal(X, Y, T, Level1, Rs)
			).

reverseList([],[]). 
reverseList([H|T], R):-
    reverseList(T, R1), append(R1, [H], R). 
								  
nextplayer(1, 2).
nextplayer(2, 1).


find_head([], _, 0).
find_head([H|T], Player, R):-
			PlayerHead is Player*(-1),
			(H = PlayerHead -> check_blank_spaces(T, PlayerHead, R);
			find_head(T, Player, R)).


check_blank_spaces([], _, 1).
check_blank_spaces([H|T], PlayerHead, R):-
			(H = 0 -> check_blank_spaces(T, PlayerHead, R);
			H = PlayerHead -> check_blank_spaces(T, PlayerHead, R);
			R is 0).
			
split_list_between([_|T], Index1, Index2, Counter, R):-
			(Index1 \= Counter -> Counter1 is Counter+1, split_list_between(T, Index1, Index2, Counter1, R);
			split_list_left(T, (Index2-Index1-1), 0, R)).

split_list_left([], _, _, []):-!.
split_list_left([H|T], Index, Counter, [Y|Ys]):- 
			Counter1 is Counter+1,
			(Counter < Index -> Y is H, split_list_left(T, Index, Counter1, Ys);
			Y is 0, split_list_left(T, Index, Counter1, Ys)).

split_list_right([], _, _, [0]).
split_list_right([H|T], Index, Counter, [Y|Ys]):- 
			Counter1 is Counter+1,
			(Counter > Index -> Y is H, split_list_right(T, Index, Counter1, Ys);
			split_list_right(T, Index, Counter1, [Y|Ys])).

check_sight(List, Index, Player, R):-
			split_list_left(List, Index, 0, List1),
			split_list_right(List, Index, 0, List2),
			find_head(List1, Player, R1),
			reverseList(List2, ReversedList2),
			find_head(ReversedList2, Player, R2),
			((R1 + R2) > 0  ->  R is 1;
			R is 0).


tentacles_in_sight(X, Y, Board, Player, R):-
			column(X, Board, List1),
			check_sight(List1, Y, Player, R1),
			row(Y, Board, List2),
			check_sight(List2, X, Player, R2),
			right_diagonal(X, Y, Board, 0, List3),
			check_sight(List3, X, Player, R3),
			left_diagonal(X, Y, Board, 0, List4),
			check_sight(List4, Y, Player, R4),
			write(R1), write(R2), write(R3), write(R4),
			((R1+R2+R3+R4) > 0 -> R is 1;
			R is -4).

direction(-1, 0,'w'). 
direction(1, 0, 'e').
direction(0, 1, 'n').
direction(0, -1, 's').
direction(1, 1,'ne').
direction(1, -1, 'se').
direction(-1, 1,'nw').
direction(-1, -1,'sw').

directioncheck(X, Y1, X, Y2, R):-
			Vertical is Y1-Y2,
			(Vertical > 0, direction(0, 1, R);
			direction(0, -1, R)).

directioncheck(X1, Y, X2, Y, R):-
			Horizontal is X1-X2,
			(Horizontal > 0, direction(-1, 0, R);
			direction(1, 0, R)).

directioncheck(X1, Y1, X2, Y2, R):-
			Horizontal is X1-X2,
			Vertical is Y1-Y2, 
			(Horizontal > 0 ->
				(Vertical > 0 -> direction(-1,1,R);
				direction(-1,-1,R));
			(Vertical > 0 -> direction(1, 1, R);
			direction(1, -1, R))).


check_empty('n', X1, Y1, _, Y2, Board, R):-
			column(X1, Board, List),
			split_list_left(List, Y1, 0, List1),
			split_list_right(List1, Y2, 0, List2),
			check_blank_spaces(List2, 0, R).
check_empty('s', X1, Y1, _, Y2, Board, R):-
			column(X1, Board, List),
			split_list_left(List, Y2, 0, List1),
			split_list_right(List1, Y1, 0, List2),
			check_blank_spaces(List2, 0, R).
check_empty('e', X1, Y1, X2, _, Board, R):-
			row(Y1, Board, List),
			split_list_left(List, X1, 0, List1),
			split_list_right(List1, X2, 0, List2),
			check_blank_spaces(List2, 0, R).
check_empty('w', X1, Y1, X2, _, Board, R):-
			row(Y1, Board, List),
			split_list_left(List, X2, 0, List1),
			split_list_right(List1, X1, 0, List2),
			check_blank_spaces(List2, 0, R).
check_empty('nw', X1, Y1, _, Y2, Board, R):-
			left_diagonal(X1, Y1, Board, 0, List1),
			split_list_between(List1, Y2, Y1, 0, List2),
			check_blank_spaces(List2, 0, R).
check_empty('ne', X1, Y1, _, Y2, Board, R):- %no work
			right_diagonal(X1, Y1, Board, 0, List1),
			split_list_between(List1, Y2, Y1, 0, List2),
			check_blank_spaces(List2, 0, R).		
check_empty('sw', X1, Y1, _, Y2, Board, R):-
			right_diagonal(X1, Y1, Board, 0, List1),
			split_list_between(List1, Y1, Y2, 0, List2),
			check_blank_spaces(List2, 0, R).		
check_empty('se', X1, Y1, _, Y2, Board, R):-
			left_diagonal(X1, Y1, Board, 0, List1),
			split_list_between(List1, Y1, Y2, 0, List2),
			check_blank_spaces(List2, 0, R).	

check_empty_line(X1, Y1, X2, Y2, Board, R):-
			directioncheck(X1, Y1, X2, Y2, R1),
			check_empty(R1, X1, Y1, X2, Y2, Board, R).


valid_coordinates(-1, _, _, _, 0).
valid_coordinates(_, -1, _, _, 0).
valid_coordinates(_, _, -1, _, 0).
valid_coordinates(_, _, _, -1, 0).
valid_coordinates(X1, _, X1, _, 1). /* same row */
valid_coordinates(_, Y1, _, Y1, 1). /* same column */
valid_coordinates(X1, Y1, X2, Y2, R):-
			Sum1 is X1+Y1,
			Sum2 is X2+Y2,
			Difference1 is X1-Y1,
			Difference2 is X2-Y2,
			(Sum1 \= Sum2 ->
				(Difference1 \= Difference2 -> R is -5;
				R is 1);
			R is 1).


valid_move(Cell1, Cell2, Player, R):-
			PlayerHead is Player*(-1),
			(Cell2 \= 0 -> R is -1;                    % -1 means occupied cell 
				(Cell1 = 0 -> R is -2;                 % -2 means empty starting square 
					(Cell1 = Player -> R is 1;         % 1 means player is moving tentacle
						(Cell1 = PlayerHead -> R is 2; % 2 means player is moving Head
						R is -3)                       % -3 means trying to move other players pieces
			))).


print_move_error(0):- write('Those coordinates don\'t exist.'), nl.
print_move_error(-1):- write('The destination square is occupied.'), nl.
print_move_error(-2):- write('There is no piece on the starting square you specified.'), nl.
print_move_error(-3):- write('Those pieces aren\'t yours.'), nl.
print_move_error(-4):- write('Tentacle not in sight.'), nl.
print_move_error(-5):- write('Illegal move: tentacles behave like chess queens.'), nl.
print_move_error(-6):- write('Line between starting and arrival must be empty.'), nl.

player_move(Movefrom_x, Movefrom_y, Moveto_x, Moveto_y, Board, Player, Result):-
			translate_input_x(Moveto_x, X1), 
			translate_input_y(Moveto_y, Y1), 
			translate_input_x(Movefrom_x, X2), 
			translate_input_y(Movefrom_y, Y2), 
			!,

			valid_coordinates(X1, Y1, X2, Y2, V),
			(V < 1 -> print_move_error(V), write('Redo your move.'), nl, nl;
			

			nth0(Y2, Board, Row1),
			nth0(X2, Row1, Cell1),

			nth0(Y1, Board, Row2),
			nth0(X1, Row2, Cell2),
						
			valid_move(Cell1, Cell2, Player, R),
			(R < 1 -> print_move_error(R), write('Redo your move.'), nl, nl;
				check_empty_line(X2, Y2, X1, Y1, Board, E),
				(E < 1 -> print_move_error(-6), write('Redo your move.'), nl,nl;
					tentacles_in_sight(X2, Y2, Board, Player, R1),
					(R1 \= 1 -> print_move_error(R1), write('Redo your move.'), nl, nl;
						(R = 1  -> tentacles_in_sight(X2, Y2, Board, Player, R1),
							(R1 \= 1 -> print_move_error(R1), write('Redo your move.'), nl, nl;
							player_move_tentacle(X1, Y1, X2, Y2, Cell1, Board, Result));
						player_move_head(X1, Y1, X2, Y2, Cell1, Board, Result)
						)
			)))).

player_move_tentacle(X1, Y1, X2, Y2, Char, Board, Result):- 
			nth0(Y1, Board, Row1),
			replace(Char, X1, Row1, R),
			replace(R, Y1, Board, Result1),
																		  
			nth0(Y2, Result1, Row2),
			replace(0, X2, Row2, R2),
			replace(R2, Y2, Result1, Result).  


playStart:- init_board(X),
			play(1,X).
				

play(Player, Board):- write(Board),nl,
			print_board(Board, 8),nl,
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
			
			player_move(X1, Y1, X2, Y2, Board, Player, Result),
			(Result = 0 -> play(Player, Board);
			nextplayer(Player, NP),
			play(NP,  Result)).
									   