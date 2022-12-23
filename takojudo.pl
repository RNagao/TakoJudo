:-use_module(library(lists)).

ascii(0):- write(' ').    /* Blank space */
ascii(1):- print(~).     /* Tentacle of player 1 */
ascii(-1):- print(@).   /* Head of player 1 */
ascii(2):- print(\).      /* Tentacle of player 2 */
ascii(-2):- print('O').  /* Head of player 2  */

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



init_board([[0,0,1,-1,-1,1,0,0],
					 [0,0,1,-1,-1,1,0,0],
					 [0,0,1,1,1,1,0,0],
					 [0,0,0,0,0,0,0,0],
					 [0,0,0,0,0,0,0,0],
					 [0,0,2,2,2,2,0,0],
					 [0,0,2,-2,-2,2,0,0],
					 [0,0,2,-2,-2,2,0,0]]).


print_board([], X):- write(+---+---+---+---+---+---+---+---+), nl,
								 write('  a   b   c   d   e   f   g   h'), nl, nl.
print_board([H|T], X):- write(+---+---+---+---+---+---+---+---+), nl,
								print_line(H, X), 
								Y is X-1,
								print_board(T, Y).

print_line([], X):- write('|'), write('  '), write(X), nl.
print_line([H|T], X):- print_cell(H),
									print_line(T, X).

print_cell(X):- write('|'), write(' '), ascii(X), write(' ').

replace(N, 0, [H|T], Result):- append([N], T, Result).
replace(N, Index, [H|T], Result):- Index1 is Index-1,
											replace(N, Index1, T, X),
											append([H], X, Result). 
											
player_move(Movefrom_x, Movefrom_y, Moveto_x, Moveto_y, Board, Player, Result):-
						translate_input_x(Moveto_x, X1), 
						translate_input_y(Moveto_y, Y1), 
						translate_input_x(Movefrom_x, X2), 
						translate_input_y(Movefrom_y, Y2), 
						
						X1 > -1, 
						X2 > -1, 
						Y1 > -1, 
						Y2 > -1,
						
						nth0(Y1, Board, Row2),
						nth0(X1, Row2, Cell2),
						Cell2 = 0,
						
						nth0(Y2, Board, Row1),
						nth0(X2, Row1, Cell1),
						Cell1 \= 0, 
						(Cell1 = 1  -> 
							(Player = 1 -> player_move_tentacle(X1, Y1, X2, Y2, Cell1, Board, Result);
							write('You can\'t move other players\' pieces!'), nl, Result is 0);
						  Cell1 = 2  -> 
							(Player = 2 -> player_move_tentacle(X1, Y1, X2, Y2, Cell1, Board, Result);
							write('You can\'t move other players\' pieces!'), nl, Result is 0);
						  Cell1 = -1  -> 
							(Player = 1 -> player_move_head(X1, Y1, X2, Y2, Cell1, Board, Result);
							write('You can\'t move other players\' pieces!'), nl, Result is 0);
						  Cell1 = -2 -> 
							(Player = 2 -> player_move_head(X1, Y1, X2, Y2, Cell1, Board, Result);
							write('You can\'t move other players\' pieces!'), nl, Result is 0);
						  write('Illegal value in cell'), nl, Result is 0
						).

player_move_tentacle(X1, Y1, X2, Y2, Char, Board, Result):- 
																		  nth0(Y1, Board, Row1),
																		  replace(Char, X1, Row1, R),
																		  replace(R, Y1, Board, Result1),
																		  
																		  nth0(Y2, Result1, Row2),
																		  replace(0, X2, Row2, R2),
																		  replace(R2, Y2, Result1, Result). 


nextplayer(1, 2).
nextplayer(2, 1).

playStart:- init_board(X),
				play(1,X).

play(Player, Board):- print_board(Board, 8),nl,
									   write('Player '),write(Player),write('\'s turn.'),nl,
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
									   