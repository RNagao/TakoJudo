ascii(0):- write(' ').    /* Blank space */
ascii(1):- print(~).     /* Tentacle of player 1 */
ascii(-1):- print(@).   /* Head of player 1 */
ascii(2):- print(\).      /* Tentacle of player 2 */
ascii(-2):- print('O').  /* Head of player 2  */


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