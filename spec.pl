:- use_module(library(clpfd)).

/*
	submission for the second Prolog assessment
	Author:Jack Davey
	Date: 1st April 2015
*/



/*
	main predicate, 
	computes the kakuro puzzle we were asked to do
	OutputParams:  FlatList, the completed grid in a one diensional form. 
	not sure why anyone would want it, but decided to leave it in anyway. 
*/
main(FlatList) :-
	length(Grid,12),
	ensureListLengths(Grid),
	setBlacksMain(Grid),
	getDirectionalInfo(true,AccrossList),
	getDirectionalInfo(false,DownList),
	addSetOfConstraints(AccrossList,Grid,true),
	transpose(Grid,GridCols),
	addSetOfConstraints(DownList,GridCols,false),
	transpose(GridCols,TempList),
	flatten(TempList,FlatList),
	labeling([],FlatList),
	printOutPut(FlatList,1).


/*
	Genrate a row of 12 for each
	column of the grid
	InputParams : the grid itself. 
*/
ensureListLengths([]).
ensureListLengths([Head|Tail]) :-
	length(Head,12),
	ensureListLengths(Tail).


	
/*
	prints out the result in array form
	adding a new line every 12th character
	InputParams: 
	FlatList, the result of the main program
	Counter, the counter that tells us when to print a new line. 
*/	
printOutPut([],_).
printOutPut([Head|Tail],Counter) :-
	Counter == 12,
	formatOutPut(true,Head),
	printOutPut(Tail,1).
printOutPut([Head|Tail],Counter) :-
	formatOutPut(false,Head),
	NewCount is Counter + 1,
	printOutPut(Tail,NewCount).
	

/*
	predicate to deal with the formatting of the output
	InputParams:
	NewLine: boolean that tells us whether the low level 
	output  predicate needs to insert a newline or not.
	Char: the character to output, if it is a zero a  * will be printed
	in its place.
*/
formatOutPut(NewLine,0) :-
	displayOneChar(NewLine,*).
formatOutPut(NewLine,Char) :-
	displayOneChar(NewLine,Char).


/*
	low level output predicate
	InputParams:
	NewLine, if this is true, we print a newline after the output
	Char the char to print
*/
displayOneChar(true,Char) :-
	format(Char),
	format('\n').
displayOneChar(false,Char) :-
	format(Char).


/*
	add all the black constraints to the grid,
	InputParams: 
	Matrix, the matrix to work on
*/
setBlacksMain(Matrix) :-
	findall([Row,Col], black(Row,Col), Result),
	setBlacksHelper(Result,Matrix).

/*
	predicat to take a list of black positions and instatioates them
	InputParameters:
	List the list of  black spots
	Matrix, the matrix
*/
setBlacksHelper([],_).
setBlacksHelper([[Row,Col]|Tail],Matrix) :-
	nth1(Row,Matrix,Current),
	nth1(Col,Current,Black),
	Black in 0..0,
	setBlacksHelper(Tail,Matrix).
	

/*	
	calls findall to g
	et a all the 
	data for either across or down
	input parameters:
	direction, a boolean specifying direction
	Output Parameters:
	result  the output list
*/
getDirectionalInfo(Direction,Result) :-
	findall([X,Y,Length,Sum],
		computeSumAndLengthInformation(Direction,X,Y,Length,Sum), Result).	
	

/*
	predicate to call the right fact
	depending on the boolean pareameter
	InputParameters:
	isAcross;if true we call across, 
	if not we call down
	Row: the row to look at
	Col: the col to look at
	outputParameters: 
	Row: the row to look at
	Col: the col to look at
*/
computeSumAndLengthInformation(true,Row,Col,Sum,Length) :- 
	across(Row,Col,Sum,Length).
computeSumAndLengthInformation(false,Row,Col,Sum,Length) :- 
	down(Row,Col,Sum,Length).


/*
	predicate to add a set of constraints to a list
	Input Parametrs;
	RawData:  a list of lists, each list contains info about a 
	specific constraint gleaned by findall
	Matrix, the list of data on which we operate. 
	List Parametrs:
	Row: the row to look at
	Col: the column to look at
	Length the correct length
	Sum the correct sum
*/
addSetOfConstraints([],_,_).
addSetOfConstraints([[Row,Col,Length,Sum]|Tail], Matrix,Dir) :-
	rowCheck(Dir,Row,Col,Sum,Length,Matrix),
	addSetOfConstraints(Tail,Matrix,Dir).

rowCheck(true,Row,Col,Sum,Length,Matrix) :-
	addConstraint(Row,Col,Sum,Length,Matrix).
rowCheck(false,Row,Col,Sum,Length,Matrix) :-
	addConstraint(Col,Row,Sum,Length,Matrix).

/*
	adds  a consrtaint for one set of ro and column data
	Input Parameters :
	Row: the row to look at
	Col: the column to look at
	Length the correct length
	Sum the correct sum
	Matrix, the list of data on which we operate.
*/
addConstraint(Row,Col,Sum,Length,Matrix) :-
	nth1(Row,Matrix,CurrentRow),    	
	getSlice(CurrentRow,Col,Length,ListToWorkOn),
	checkListProperties(ListToWorkOn,Length,Sum).


/*
	get a slice from the given list
	InputParams:
	Row the row to slice into
	Start the start position of the slice
	Length the length of the slice
	OutputParams: 
	SecondList the slice in question
*/
getSlice(Row,Start,Length,SecondList) :-
	PrefLength is Start -1,
	length(JunkList, PrefLength),
	length(SecondList, Length),
	append(JunkList,SecondList ,Res),
	prefix(Res,Row).
	

/*
predicate to check that the sum 
and the length are the right thing for a given list
InputParams:
TheList: the  list to check
Length the correct length
Sum the correct sum
*/
checkListProperties(TheList,Length,Sum) :-
	length(TheList,Length),
	TheList ins 1..9,
	all_different(TheList),
	sum(TheList, #=, Sum).
	
/*
	* these are the origninal predicates supplied to us to help with the assessment. 
*/

% black(R, C).
black(1, 1).
black(1, 2).
black(1, 3).
black(1, 4).
black(1, 5).
black(1, 6).
black(1, 7).
black(1, 8).
black(1, 9).
black(1, 10).
black(1, 11).
black(1, 12).

black(2, 1).
black(2, 2).
black(2, 3).
black(2, 6).
black(2, 7).
black(2, 8).
black(2, 9).
black(2, 12).

black(3, 1).
black(3, 2).
black(3, 3).
black(3, 8).
black(3, 9).
black(3, 12).

black(4, 1).
black(4, 2).
black(4, 5).
black(4, 10).

black(5, 1).
black(5, 6).
black(5, 7).
black(5, 10).

black(6, 1).
black(6, 4).
black(6, 9).

black(7, 1).
black(7, 2).
black(7, 5).
black(7, 9).
black(7, 12).

black(8, 1).
black(8, 5).
black(8, 10).

black(9, 1).
black(9, 4).
black(9, 7).
black(9, 8).

black(10, 1).
black(10, 4).
black(10, 9).
black(10, 12).

black(11, 1).
black(11, 2).
black(11, 5).
black(11, 6).
black(11, 11).
black(11, 12).

black(12, 1).
black(12, 2).
black(12, 5).
black(12, 6).
black(12, 7).
black(12, 8).
black(12, 11).
black(12, 12).

% across(R, C, L, S)
across(2,4,2,4).
across(2,10,2,4).	
across(3,4,4,12).
across(3,10,2,6).
across(4,3,2,6).
across(4,6,4,10).	
across(4,11,2,3).	
across(5,2,4,12).
across(5,8,2,3).	
across(5,11,2,6).	
across(6,2,2,6).
across(6,5,4,10).	
across(6,10,3,7).
across(7,3,2,7).
across(7,6,3,8).	
across(7,10,2,8).
across(8,2,3,11).
across(8,6,4,15).	
across(8,11,2,8).
across(9,2,2,4).
across(9,5,2,6).
across(9,9,4,14).	
across(10,2,2,12).
across(10,5,4,15).
across(10,10,2,11).
across(11,3,2,8).
across(11,7,4,11).
across(12,3,2,11).
across(12,9,2,7).

% down(R, C, L, S)
down(5,2,2,3).
down(8,2,3,8).
down(4,3,9,45).
down(2,4,4,13).
down(7,4,2,6).
down(11,4,2,3).
down(2,5,2,8).
down(5,5,2,3).
down(9,5,2,6).
down(3,6,2,3).
down(6,6,5,16).
down(3,7,2,5).
down(6,7,3,10).
down(10,7,2,5).
down(4,8,5,20).
down(10,8,2,4).
down(4,9,2,5).
down(8,9,2,3).
down(11,9,2,5).
down(2,10,2,3).
down(6,10,2,3).
down(9,10,4,12).
down(2,11,9,45).
down(4,12,3,7).
down(8,12,2,4).
