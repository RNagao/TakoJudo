:-use_module(library(lists)).
:-use_module(library(random)).

:- include('board.pl').
:- include('utilities.pl').
:- include('movement.pl').



/*player_head(+Player, -HeadValue)

Tentacles of a player have a positive value, while heads have a negative value,
in the internal matrix representation.*/
player_head(1, -1).
player_head(2, -2).



/*next_player(+Player, -NextPlayer)*/
next_player(1,2).
next_player(2,1).


/* last_move(XFrom, YFrom, XTo, YTo, Player) 

Stores the last tentacle move of the player; from the coordinates
of the starting cell to the coordinates of the destination cell.*/
last_move(_, _, _, _, _).



/*head_last_move(StartIndex1, StartIndex2, StartIndex3, StartIndex4, 
DestIndex1, DestIndex2, DestIndex3, DestIndex4, Player).

Stores the last head move of the player; it stores the indexes 
of the single head pieces, in the starting position and destination position.*/
head_last_move(_, _, _, _, _, _, _, _, _).


/*check_losing(+Player, +Board, +LastMove, -Res)

Gets all the valid movements of the player and, if the list is empty,
which means the player is blocked, returns in the Result that the player 
has lost.*/
check_losing(Player, Board, LastMove, HeadLastMoves, Res):-
            valid_movements(Player, Board, LastMove, HeadLastMoves, R),
            list_empty(R, Res).



/*lose(+Player)

If a player loses, the other one is declared the winner, and an ending screen gets called.
*/
lose(Player):-
            write('Player '),write(Player),write(' has no available moves.'),nl,nl,nl,
            write('Player '), next_player(Player,NP),write(NP),write(' is the winner!'),
            readFile('victory.txt'),
            nl,nl,nl.
            


/*choice(+Input, -Output)

Translates the human input into a number declaring the gamemode choice.
1 is Human vs Human, 2 is Human vs Bot, 3 is Bot vs Bot. */
choice('1', 1).
choice('2', 2).
choice('3', 3).
choice(_, -1).

/*ai_level(+Input, -Output)

Translates the human input into a number declaring the difficulty of the bots.
1 is Normal (bot moves randomly), 2 is Difficult(bot chooses
best current move, seeing one step ahead). */
ai_level('1', 1).
ai_level('2', 2).
ai_level(_, -1).


/*menu_gamestyle(?Gamestyle, -FinalGamestyle)

This menu asks the player for the gamestyle, and if it's not a valid 
input it starts again. */
menu_gamestyle(Gamestyle, FinalGamestyle):-
            write('Choose a game mode.'), nl,
            write('1) Human vs Human'), nl,
            write('2) Human vs Computer'), nl,
            write('3) Computer vs Computer'), nl,
			get_char(Choice), skip_line, nl,
            choice(Choice, Gamestyle),

            (Gamestyle = -1 -> nl, write('Enter a valid gamestyle'),nl,nl,nl,nl, menu_gamestyle(_, FinalGamestyle); 
            FinalGamestyle is Gamestyle).


/*menu_ailevel(?AILevel, -FinalAILevel)

This menu asks the player for the AI Level, and if it's not a valid 
input it starts again. */
menu_ailevel(AILevel, FinalAILevel):-
            write('Choose a strength level for the computer.'),nl,
            write('1) Normal'),nl,
            write('2) Difficult'),nl,
            get_char(AIChoice), skip_line, nl,
            ai_level(AIChoice, AILevel),

            (AILevel = -1 -> write('Enter a valid gamestyle'),nl,nl,nl,nl, menu_ailevel(_, FinalAILevel);
            FinalAILevel is AILevel).



/*play.

It prints the starting screen and the title,
then initializes the starting board, asks for the gamestyle
and (if needed) AI level, and then it starts the game.*/
play:-     
            nl,nl,nl,write('Welcome to TakoJudo! If you\'re experiencing any problems like'),
            write(' \'gamename.txt does not exist\''), write(' remember to set the working directory of SICStus'),
            write(' to the folder of the game.'),nl,nl,nl,
            readFile('gamename.txt'),
            readFile('mainscreen.txt'),
            init_board(Board),
            menu_gamestyle(_, Gamestyle),

            (Gamestyle = 1 -> AILevel is 0; 
            menu_ailevel(_, AILevel)),
            
	        playing(1, Board, [last_move(-1,-1,-1,-1, 1), last_move(-1,-1,-1,-1, 2)], [
            head_last_move(-1,-1,-1,-1,-1,-1,-1,-1, 1), 
            head_last_move(-1,-1,-1,-1,-1,-1,-1,-1, 2)], Gamestyle, AILevel).
				


/*playing(+Player, +Board, +LastMoves, +HeadLastMoves, +Gamestyle, +AILevel)

Depending on the gamestyle the code changes: in human vs human it 
will need human input both turns, in human vs bot just in one,
and in bot vs bot never.

Human vs Human
It starts by printing the board and checking if the player is losing;
it asks for coordinates and if the movement is not valid it will start over.
If the movement is valid, it checks if it's a head movement or tentacle movement,
then it changes the board in such way. Switches to next player and starts
over with the new board and new "last moves".

Human vs Bot
Works the same way but, after the user input, playing_bot
is called and the bot moves will be done there.

Bot vs Bot
This just calls playing_bot over and over.
An "input" is required for the bots to go on but it's just blank,
it's only for being able to observe the boards.
*/
playing(Player, Board, LastMoves, HeadLastMoves, 1, 0):-
			print_board(Board, 8), nl,
            
            nth1(Player, LastMoves, LastMove),
            check_losing(Player, Board, LastMove, HeadLastMoves, Losing),
            (Losing = 1 -> lose(Player); 
            

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

            player_head(Player, Head),
            moving_head(Head, Cell1, MovingHead),

            (MovingHead = 1 -> can_move_head(Cell1, Cell2, Board, Player, LastMove, 1, Head2, Head2Destination, Head3, Head3Destination, Head4, Head4Destination, HeadLastMoves, R), write(R),nl;
			can_move(Cell1, Cell2, Board, Player, LastMove, 1, 0, R)),

            (R = 1 ->
                (MovingHead = 1 ->
                    change_board_cell(Cell1, 0, Board, NewBoard1),
                    change_board_cell(Head2, 0, NewBoard1, NewBoard2),
                    change_board_cell(Head3, 0, NewBoard2, NewBoard3),
                    change_board_cell(Head4, 0, NewBoard3, NewBoard4),
                    change_board_cell(Cell2, Head, NewBoard4, NewBoard5),
                    change_board_cell(Head2Destination, Head, NewBoard5, NewBoard6),
                    change_board_cell(Head3Destination, Head, NewBoard6, NewBoard7),
                    change_board_cell(Head4Destination, Head, NewBoard7, FinalBoard),

                    switch_last_head_move_container(Player, Cell1, Head2, Head3, Head4,
                    Cell2, Head2Destination, Head3Destination, Head4Destination, HeadLastMoves,
                    CurrentHeadMoves),
                    switch_last_move(Player, -1, -1, -1, -1, LastMoves, CurrentMoves);
                    
                    change_board_cell(Cell1, 0, Board, NewBoard1),
                    change_board_cell(Cell2, Player, NewBoard1, FinalBoard),

                    switch_last_head_move(Player, -1, -1, -1, -1,
                    -1, -1, -1, -1, HeadLastMoves,
                    CurrentHeadMoves),
                    switch_last_move(Player, XFrom, YFrom, XTo, YTo, LastMoves, CurrentMoves)
                    ),
                next_player(Player, NP),!,
                playing(NP, FinalBoard, CurrentMoves, CurrentHeadMoves, 1, 0);
            playing(Player, Board, LastMoves, HeadLastMoves, 1, 0),!
            )).

playing(Player, Board, LastMoves, HeadLastMoves, 2, AILevel):-
			print_board(Board, 8), nl,
            
            nth1(Player, LastMoves, LastMove),
            check_losing(Player, Board, LastMove, HeadLastMoves, Losing),
            (Losing = 1 -> lose(Player); 


			write('Player '), write(Player), write('\'s turn.'), nl,
			write('X coordinate of the piece you want to move.'), nl,
			get_char(X1), skip_line, nl,
			write('Y coordinate of the piece you want to move.'), nl,
			get_char(Y1), skip_line, nl,
			write('X coordinate of where you want to move.'), nl,
			get_char(X2),  skip_line, nl,
			write('Y coordinate of where you want to move.'), nl,
			get_char(Y2), skip_line, nl,
			write(X1), write(Y1), write(X2), write(Y2), nl,

            translate_input_x(X1,XFrom),
            translate_input_y(Y1,YFrom),
            translate_input_x(X2,XTo),
            translate_input_y(Y2,YTo),


            get_cell_from_coordinates(XFrom, YFrom, Board, Cell1),!,
            get_cell_from_coordinates(XTo, YTo, Board, Cell2),!,

            player_head(Player, Head),
            moving_head(Head, Cell1, MovingHead),

            (MovingHead = 1 -> can_move_head(Cell1, Cell2, Board, Player, LastMove, 1, Head2, Head2Destination, Head3, Head3Destination, Head4, Head4Destination, HeadLastMoves, R);
			can_move(Cell1, Cell2, Board, Player, LastMove, 1, 0, R)),

            (R = 1 ->
                (MovingHead = 1 ->
                    change_board_cell(Cell1, 0, Board, NewBoard1),
                    change_board_cell(Head2, 0, NewBoard1, NewBoard2),
                    change_board_cell(Head3, 0, NewBoard2, NewBoard3),
                    change_board_cell(Head4, 0, NewBoard3, NewBoard4),
                    change_board_cell(Cell2, Head, NewBoard4, NewBoard5),
                    change_board_cell(Head2Destination, Head, NewBoard5, NewBoard6),
                    change_board_cell(Head3Destination, Head, NewBoard6, NewBoard7),
                    change_board_cell(Head4Destination, Head, NewBoard7, FinalBoard),
                
                
                switch_last_head_move_container(Player, Cell1, Head2, Head3, Head4,
                Cell2, Head2Destination, Head3Destination, Head4Destination, HeadLastMoves,
                CurrentHeadMoves),
                switch_last_move(Player, -1, -1, -1, -1, LastMoves, CurrentMoves);
                
                change_board_cell(Cell1, 0, Board, NewBoard1),
                change_board_cell(Cell2, Player, NewBoard1, FinalBoard),
                
                switch_last_head_move(Player, -1, -1, -1, -1,
                -1, -1, -1, -1, HeadLastMoves,
                CurrentHeadMoves),
                switch_last_move(Player, XFrom, YFrom, XTo, YTo, LastMoves, CurrentMoves)
                ),

                print_board(FinalBoard, 8),

                next_player(Player, NP),!,
                /*bot's turn */ 
                
                write('Bot\'s turn'),nl,write('Press anything when you\'re ready.'),nl,
                get_char(_), nl,
                playing_bot(NP, FinalBoard, CurrentMoves, CurrentHeadMoves, 2, AILevel);
            playing(Player, Board, LastMoves, HeadLastMoves, 2, AILevel),!
            )).

playing(Player, Board, LastMoves, HeadLastMoves, 3, AILevel):-
            print_board(Board, 8), nl,
            write('Bot '), write(Player), write('\'s turn'), nl,
            get_char(_), nl,
            playing_bot(Player, Board, LastMoves, HeadLastMoves, 3, AILevel).




/*playing_bot(+Player, +Board, +LastMoves, +HeadLastMoves, +Gamestyle, +AILevel)

The bot makes a move. If its AILevel is one, it will just pick a random move 
from the valid movements;
if the AILevel is 2, it will get all possible moves, and look for the one that 
minimizes the possible moves of the adversary player. The rest works like
"playing".
*/
playing_bot(Player, Board, LastMoves, HeadLastMoves, Gamestyle, 1):-
            nth1(Player, LastMoves, LastMove),
            check_losing(Player, Board, LastMove, HeadLastMoves, Losing),
            (Losing = 1 -> lose(Player); 
            
            valid_movements(Player, Board, LastMove, HeadLastMoves, MovementsList),
            exclude(empty, MovementsList, Y),
            random_select(F1, Y, _),
            random_select(Piece-Destination, F1, _),
            print_bot_moves(Piece, Destination),nl,nl,

            cell_coordinates(Piece, XFrom, YFrom),
            cell_coordinates(Destination, XTo, YTo),

            player_head(Player, Head),
            moving_head(Head, Piece, MovingHead),

            (MovingHead = 1 -> can_move_head(Piece, Destination, Board, Player, LastMove, 1, Head2, Head2Destination, Head3, Head3Destination, Head4, Head4Destination, HeadLastMoves, _),
                    change_board_cell(Piece, 0, Board, NewBoard1),
                    change_board_cell(Head2, 0, NewBoard1, NewBoard2),
                    change_board_cell(Head3, 0, NewBoard2, NewBoard3),
                    change_board_cell(Head4, 0, NewBoard3, NewBoard4),
                    change_board_cell(Destination, Head, NewBoard4, NewBoard5),
                    change_board_cell(Head2Destination, Head, NewBoard5, NewBoard6),
                    change_board_cell(Head3Destination, Head, NewBoard6, NewBoard7),
                    change_board_cell(Head4Destination, Head, NewBoard7, FinalBoard),

                    switch_last_head_move_container(Player, Piece, Head2, Head3, Head4,
                    Destination, Head2Destination, Head3Destination, Head4Destination, HeadLastMoves,
                    CurrentHeadMoves),
                    switch_last_move(Player, -1, -1, -1, -1, LastMoves, CurrentMoves);
                    change_board_cell(Piece, 0, Board, NewBoard1),
                    change_board_cell(Destination, Player, NewBoard1, FinalBoard),

                    switch_last_head_move(Player, -1, -1, -1, -1,
                    -1, -1, -1, -1, HeadLastMoves,
                    CurrentHeadMoves),
                    switch_last_move(Player, XFrom, YFrom, XTo, YTo, LastMoves, CurrentMoves)
                    ),
                next_player(Player, NP),!,
                playing(NP, FinalBoard, CurrentMoves, CurrentHeadMoves, Gamestyle, 1)
            ).

playing_bot(Player, Board, LastMoves, HeadLastMoves, Gamestyle, 2):-
            write('Bot is thinking...'),nl,
            nth1(Player, LastMoves, LastMove),
            check_losing(Player, Board, LastMove, HeadLastMoves, Losing),
            (Losing = 1 -> lose(Player); 
            
            valid_movements(Player, Board, LastMove, HeadLastMoves, MovementsList),
            exclude(empty, MovementsList, Y1),
            flatten(Y1, Y2),
            append(Y2,['stop'], Y),
            valid_movements_level2(Y, Board, Player, LastMoves, HeadLastMoves, 200, _, _, Piece-Destination),
            print_bot_moves(Piece, Destination),nl,nl,

            cell_coordinates(Piece, XFrom, YFrom),
            cell_coordinates(Destination, XTo, YTo),

            player_head(Player, Head),
            moving_head(Head, Piece, MovingHead),

            (MovingHead = 1 -> can_move_head(Piece, Destination, Board, Player, LastMove, 1, Head2, Head2Destination, Head3, Head3Destination, Head4, Head4Destination, HeadLastMoves, _),
                    change_board_cell(Piece, 0, Board, NewBoard1),
                    change_board_cell(Head2, 0, NewBoard1, NewBoard2),
                    change_board_cell(Head3, 0, NewBoard2, NewBoard3),
                    change_board_cell(Head4, 0, NewBoard3, NewBoard4),
                    change_board_cell(Destination, Head, NewBoard4, NewBoard5),
                    change_board_cell(Head2Destination, Head, NewBoard5, NewBoard6),
                    change_board_cell(Head3Destination, Head, NewBoard6, NewBoard7),
                    change_board_cell(Head4Destination, Head, NewBoard7, FinalBoard),

                    switch_last_head_move_container(Player, Piece, Head2, Head3, Head4,
                    Destination, Head2Destination, Head3Destination, Head4Destination, HeadLastMoves,
                    CurrentHeadMoves),
                    switch_last_move(Player, -1, -1, -1, -1, LastMoves, CurrentMoves);
                    change_board_cell(Piece, 0, Board, NewBoard1),
                    change_board_cell(Destination, Player, NewBoard1, FinalBoard),

                    switch_last_head_move(Player, -1, -1, -1, -1,
                    -1, -1, -1, -1, HeadLastMoves,
                    CurrentHeadMoves),
                    switch_last_move(Player, XFrom, YFrom, XTo, YTo, LastMoves, CurrentMoves)
                    ),
                next_player(Player, NP),!,
                playing(NP, FinalBoard, CurrentMoves, CurrentHeadMoves, Gamestyle, 2)
            ).




