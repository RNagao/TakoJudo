:-use_module(library(lists)).

/* This file contains some utilities that were used for managing lists,
data and files. */


/* Empty(-EmptyList) 

This returns true when it gets an empty list as an input.*/
empty([]).



/*readFile(+Filename) 

Reads a file given a Filename, and then it prints its content.*/
readFile(Filename):-
    open(Filename, read, File),nl,
    read_lines(File, Lines),
    close(File),
    write_lines(Lines).



/*read_lines(+Files, -Result)

Given a file, returns a list of all its Lines as a Result.*/
read_lines(File,[]):- 
            at_end_of_stream(File).
read_lines(File,[X|L]):-
            \+ at_end_of_stream(File),
            get_char(File,X),
            read_lines(File,L).



/*write_lines(+Lines) 

Given a List of Lines, it writes all of them.*/
write_lines([]).
write_lines([H|T]):- write(H), write_lines(T).



/*split_list(+List, +Index, -LeftList, -RightList)

Given a list, it splits it at its Index, returning as LeftList
the list on the left of the Index, and as RightList the List containing
the element at the Index and the elements on its right. */
split_list([], _, [], []).
split_list(T, 0, [], T).
split_list([H|T], X, [H|LeftList], RightList):-
            X1 is X-1,
            split_list(T, X1, LeftList, RightList).



/*reverseList(+List, -Result)

Given a list, it reverses it.*/
reverseList([],[]). 
reverseList([H|T], R):-
            reverseList(T, R1), append(R1, [H], R). 




/*flatten(+List, -Result)

Given a list which may contain other lists inside it, it returns a list
with all the elements it found inside, but the result list doesn't have
sublists. Example: flatten([[1,2,[3,4]],5], [1,2,3,4,5]).  */
flatten(Xs, Fs):-     
            flatten(Xs, [], Rs),
            reverse(Rs, Fs).  
flatten([], Fs, Fs).
flatten([X|Xs], Ts, Fs):-
            is_list(X),               
            !,                       
            flatten(X, Ts, T1),          
            flatten(Xs, T1, Fs).
flatten([X|Xs], Ts, Fs):-
            flatten(Xs, [X|Ts], Fs).    



/*list_empty(+List, -Result) 

If a list only contains empty lists, then it's empty, and the Result will be 1.
Otherwise the Result will be 0.*/
list_empty([[]], 1).
list_empty([[]|T], R):-
            list_empty(T, R).
list_empty([_|_], 0).

