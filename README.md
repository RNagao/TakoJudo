# TakoJudo

The project is a Tako Judo game implemented in Prolog.

##Data Structure
### Board
For the board, we will use a 8x8 matriz that will keep the position of the pieces. The 0 value will represent an empty square, 1 player1's tentacles, -1 player1's head, 2 player2's tentacles and -2 player2's head. So the initial state of the board will be:
[[0,0,1,-1,-1,1,0,0],
[0,0,1,-1,-1,1,0,0],
[0,0,1,1,1,1,0,0]
[0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0],
[0,0,2,2,2,2,0,0],
[0,0,2,-2,-2,2,0,0],
[0,0,2,-2,-2,2,0,0]]

##Players
For the pieces of each player, we will keep their positions in an array with the positions of each piece. For example the initial state of player1's pieces:
[[0,3],   --head
[0,2],    --tentacle1
[1,2],    --tentacle2
[2,2],    --tentacle3
[2,3],    --tentacle4
[2,4],    --tentacle5
[2,5],    --tentacle6
[1,5],    --tentacle7
[0,5]]    --tentacle8

##PlayerLastMovement
In this array we will store the last movement of each player in order to avoid Twiddling. There we are going to store the last piece that the player move and where it was before the movement, that way we can avoid that in the next turn the player goes back in to the same space wit the same piece.
[[player1's piece, row, colunm],
[player2's piece, row, colunm]

As we can see, the 0 index of the array stores the top left corner of the head and the rest of them stores the position of a tentacles

#Methods
##TentaclesInSight
When it comes to a players turn, we need to know which pieces he can move in the board. The function will check which tentacles the head can see and are able to move.

##TentaclesNotSurrounded
This function will receive the tentacles that are in sight and check which ones are surrounded and can't move, if there are pieces blocking all his paths or the only movement available is twiddling. It returns a list of tentacles that are able to move.

##HeadSurrounded
If there are no tentacles available to move, this function will be called to check if the head can move or it has his movements blocked. 

##PlayerPiecesAvailable
This function makes use of the 3 before to build an array with the pieces that are able to move. It also checks if there is no pieces available, if that happens, the game is over and declares victory to the opponent

##GetMovementDirect
This function receives two parameters, the actual position of the piece and the next pretending position. With this info, it returns the direction of the movement:
N - north
S - south
E - east
W - west
NE - northeast
NW - northwest
SE - southeast
SW - southwest

##CanMove
This function receives three parameters, the actual position of the piece, the next position and the direction. It will check in the board matriz if every space between the two positions are 0s, if not the movement is blocked.

##MoveTentacle
If the player selects to move a tentacle, this function is called. It takes the chosen tentacle of the player, the actual position, check if the movement is valid with CanMove. If it is valid it changes the board and player variable according to the movement. If not it asks for another movement.

##MovePiece
After receiving the list of pieces he can move, the player select each one of them he wants to move and the position that he wants it to go.
