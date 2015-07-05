/*
  Author :Jack Davey
  Date: 10th March 2015
  This file contains the solution to the 'catch
  a thief' assessment. 
*/

/*
  predicate that permutes the inputList
  input parameters:
  InputList: the input list
  Output parameters:
  OutputList, the permuted list
*/
permute([],[]).
permute([Head|Tail],OutputList) :-
  permute(Tail,PartialResult),
  insert(Head,PartialResult,OutputList).

/*
    predicate to insert an 
    elemtn of the list somehwee in the result list. 
    input parameters :
    ElementToInsert: the element to insert
    InputList, the list that we want o insert into
    Output parameters:
    OutLIst the result list
*/
insert(ElementToInsert,InputList,[ElementToInsert|InputList]).
insert(ElementToInsert,[InputHead|InputTail],[InputHead|NextTail]) :-
  insert(ElementToInsert,InputTail,NextTail).


/*
    this is the main theif
    predicate,
    it gives the rules given in 
    the assesment spec to provide the result
    Output Parameters:
    Dude: the subject in question
 */
thief(Dude) :-
 	Names = [brian,john,larry,marty,bill,fred],
	Weights = [W210,W150,W180,W190,_,W170],
	Cars = [_,BlackCar,GreenCar,PurpleCar,WhiteCar,_],
	Shoes = [Tan,Blue,Black,Brown,_,_],
	Brollies = [RedBrolly,PurpleBrolly,_,_,_,_],
	Tan = PurpleCar,
	GreenCar = W180,
	brian = GreenCar,
	Blue = BlackCar,
	Tan = W150,
	john = RedHair,
	larry = W210,
	Blue = W190,
	bill = Brown,
	PurpleBrolly = marty,
	permuteLists(Names,Cars,Shoes,Weights,Brollies),
	addInequalityConstraints(Black,RedBrolly,WhiteCar,W170,W190,RedHair,marty),
	Dude = BlackCar.

/*
	function to check all the 'not equal to'
	bits of the sultion. 
	input parameters:
	black, variable representing black shoes
	RedBrolly, variable representing a red umbrella
	WhiteCar, variable representing  a white car
	W170, the weight 170,
	W190, the weight 190,
	RedHair, ture if a person has red hair,
	marty, a variable to represent the person marty. 
*/
addInequalityConstraints(Black,RedBrolly,WhiteCar,W170,W190,RedHair,marty) :-
	Black \== RedBrolly,
	WhiteCar \== W170,
	W190 \== RedHair,
	marty \== W190.
	
/*
	predicate to permute all of the input lists
	Input parameters:
	Names the list of names
	Cars the list of cars
	Shoes, the list of shoe colours
	Weights the list of weights
	Brollies the list of umbrella colours
*/
permuteLists(Names,Cars,Shoes,Weights,Brollies) :-
	permute(Names,Cars),
	permute(Names,Shoes),
	permute(Names,Weights),
	permute(Names,Brollies).


