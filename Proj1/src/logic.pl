startGame(Player1, Player2) :-
    initialBoard(InitialBoard),
    display_game(InitialBoard),
    gameLoop(InitialBoard).

movePiece(Board,NewBoard,Symbol) :-
    write('Which piece you would like to move?\n'),
    chooseCell(Row,NumColumn),
    ((checkCell(Board,Row,NumColumn,Symbol) -> movePiece(Board, NewBoard,Symbol));
    (replaceRows(Board,Row,NumColumn,0,BoardAux),
    chooseDest(BoardAux,NewBoard,Symbol,Row,NumColumn))).

chooseDest(Board,NewBoard,Symbol,Row,NumColumn) :-
    listValidMoves(Board,Row,NumColumn,MovesList),
    write('To Where?\n'),
    chooseCell(Row1,NumColumn1),
    ((checkValidMove(MovesList,Row1,NumColumn1) -> replaceRows(Board,Row1,NumColumn1,Symbol,NewBoard));
    chooseDest(Board,NewBoard,Symbol,Row,NumColumn)).

chooseCell(Row,NumColumn) :-
    askRow(RowAux),
    numberRow(RowAux,Row),
    askColumn(Column),
    numberColumn(Column,NumColumn).

gameLoop(Board) :-
    movePiece(Board,NewBoard,1),
    display_game(NewBoard),
    checkWin([[1,3],[1,4],[1,5],[1,6]]),
    movePiece(NewBoard,RoundBoard,2),
    display_game(RoundBoard),
    gameLoop(RoundBoard).

checkCell(Board,Row,NumColumn,Symbol) :-
    nth1(Row,Board,List),
    nth1(NumColumn,List,Value),!,
    Value \= Symbol.

listValidMoves(Board,Row,NumColumn,MovesList):-
    listColumnDown(Board,MovesList1,Row,NumColumn,TempMovesList),
    listColumnUp(Board,MovesList2,Row,NumColumn,TempMovesList1),
    listRowRight(Board,MovesList3,Row,NumColumn,TempMovesList2),
    listRowLeft(Board,MovesList4,Row,NumColumn,TempMovesList3),
    append(MovesList1,MovesList2,MovesListAux),
    append(MovesListAux,MovesList3,MovesListAux1),
    append(MovesListAux1,MovesList4,MovesList),
    write('You can move the piece to : \n'),
    print_list(MovesList).

listColumnDown(Board,FinalList,Row,NumColumn,ListTemp) :-
    Row1 is Row + 1,
    ((Row1 < 9 , \+ checkCell(Board,Row1,NumColumn,0))
    -> (
        numberColumn(Column,NumColumn),
        append(ListTemp,[[Row1,Column]],ListAux),
        listColumnDown(Board,FinalList,Row1,NumColumn,ListAux));
    append([],ListTemp,FinalList)).

listColumnUp(Board,FinalList,Row,NumColumn,ListTemp) :-
    Row1 is Row - 1,
    ((Row1 > 0 , \+ checkCell(Board,Row1,NumColumn,0))
    -> (
        numberColumn(Column,NumColumn),
        append(ListTemp,[[Row1,Column]],ListAux),
        listColumnUp(Board,FinalList,Row1,NumColumn,ListAux));
    append([],ListTemp,FinalList)).

listRowRight(Board,FinalList,Row,NumColumn,ListTemp) :-
    NumColumn1 is NumColumn + 1,
    ((NumColumn1 < 9 , \+ checkCell(Board,Row,NumColumn1,0))
    -> (
        numberColumn(Column,NumColumn1),
        append(ListTemp,[[Row,Column]],ListAux),
        listRowRight(Board,FinalList,Row,NumColumn1,ListAux));
    append([],ListTemp,FinalList)).


listRowLeft(Board,FinalList,Row,NumColumn,ListTemp) :-
    NumColumn1 is NumColumn - 1,
    ((NumColumn1 > 0 , \+ checkCell(Board,Row,NumColumn1,0))
    -> (
        numberColumn(Column,NumColumn1),
        append(ListTemp,[[Row,Column]],ListAux),
        listRowLeft(Board,FinalList,Row,NumColumn1,ListAux));
    append([],ListTemp,FinalList)).


checkValidMove(MovesList,Row2b,NumColumn2b):-
    numberColumn(Column2b,NumColumn2b),
    append([],[Row2b,Column2b],Move),!,
    member(Move,MovesList).


checkWin(PiecesPositionsList):-
    distanceBetween2(1,2,PiecesPositionsList,DistanceList,ListTemp),
    print_listAux(DistanceList).
    



    
distanceBetween2(PieceIndex,5, PiecesPositionsList,DistanceList,DistanceListAux):-
    (PieceIndex < 4,
    PieceIndex1 is PieceIndex + 1,
    OtherPieceIndex1 is PieceIndex1 + 1,
    distanceBetween2(PieceIndex1,OtherPieceIndex1, PiecesPositionsList,DistanceList,DistanceListAux));
    append([],DistanceListAux,DistanceList).

distanceBetween2(PieceIndex,OtherPieceIndex, PiecesPositionsList,DistanceList,DistanceListAux):-
    OtherPieceIndex < 5,
    OtherPieceIndex1 is OtherPieceIndex +1,
    nth1(PieceIndex,PiecesPositionsList,Coords1),
    nth1(OtherPieceIndex,PiecesPositionsList,Coords2),
    distance(Coords1,Coords2,Distance),
    append(DistanceListAux,[Distance],DistanceListAux1),
    distanceBetween2(PieceIndex,OtherPieceIndex1,PiecesPositionsList,DistanceList,DistanceListAux1).


  
distance([H1|T1], [H2|T2], Distance):-
    Row is (H2-H1)^2,
    NumColumn is (T2-T1)^2,
    Distance is sqrt(Row + NumColumn).    

replaceColumns([_|T], 1, Value, [Value|T]).
replaceColumns([C|T], Column, Value, [C|TNew]) :-
        Column > 1,
        Column1 is Column - 1,
        replaceColumns(T, Column1, Value, TNew).

replaceRows([L|T], 1, Column,Value, [LNew|T]) :-
        replaceColumns(L, Column, Value, LNew).

replaceRows([L|T], Row, Column, Value, [L|TNew]) :-
        Row > 1,
        Row1 is Row - 1,
        replaceRows(T, Row1, Column, Value, TNew).
