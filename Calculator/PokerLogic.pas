unit PokerLogic;

interface

const

  Suits: array [1 .. 4] of string = ('�����', '�����', '�����', '����');

  Nominals: array [1 .. 13] of string = ('2', '3', '4', '5', '6', '7', '8', '9',
    '10', 'J', 'Q', 'K', 'A');

  OneSuit: array[1..13, 1..13] of Byte = (
  (1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1),
  (0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1),
  (0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1),
  (0, 0, 1, 2, 1, 1, 0, 0, 0, 0, 0, 1, 1),
  (0, 0, 0, 1, 2, 1, 1, 1, 0, 0, 0, 1, 2),
  (0, 0, 0, 1, 1, 3, 1, 1, 1, 1, 0, 1, 2),
  (0, 0, 0, 0, 1, 1, 3, 2, 2, 2, 2, 1, 2),
  (0, 0, 0, 0, 1, 1, 2, 3, 3, 3, 2, 2, 2),
  (0, 0, 0, 0, 0, 1, 2, 3, 3, 3, 3, 3, 3),
  (0, 0, 0, 0, 0, 1, 2, 3, 3, 3, 3, 3, 3),
  (0, 0, 0, 0, 0, 0, 2, 2, 3, 3, 3, 3, 3),
  (1, 1, 1, 1, 1, 1, 1, 2, 3, 3, 3, 3, 3),
  (1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 3)
  );

  TwoSuits: array[1..13, 1..13] of Byte = (
  (1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
  (0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
  (0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
  (0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0),
  (0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0),
  (0, 0, 0, 0, 0, 3, 1, 1, 0, 0, 0, 0, 1),
  (0, 0, 0, 0, 0, 1, 3, 1, 1, 1, 0, 0, 1),
  (0, 0, 0, 0, 0, 1, 1, 3, 1, 1, 1, 1, 1),
  (0, 0, 0, 0, 0, 0, 1, 1, 3, 2, 2, 2, 3),
  (0, 0, 0, 0, 0, 0, 1, 1, 2, 3, 2, 3, 3),
  (0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 3, 3, 3),
  (0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 3, 3, 3),
  (0, 0, 0, 0, 0, 1, 1, 1, 3, 3, 3, 3, 3));

type

  TMask = array[1..10] of Boolean;

  TAllCards = array[1..4, 1..13] of Boolean;

  TProb = array of array[2..10] of Real;

  TRec = record
    Suit: Byte;
    Nominal: Byte;
  end;

  TByteCards = array of TRec;

  TData = record
    Suit: string;
    Nominal: string;
  end;

  TCards = array of TData;

  TFunc = function(Cards: TByteCards): Boolean;

  TArrFunc = array[2..10] of TFunc;

function HighCard(Cards: TByteCards): string;
function NeedToPlay(N1, N2, S1, S2: string): string;
function PositionIsCorrect(Cards: TCards): Byte;
function ConvertIntoByteArray(Cards: TCards): TByteCards;
function GenerateProb(Cards: TByteCards; Amount: Integer; Mask: TMask; NumberOfOpponents: Byte): TProb;
procedure GenerateProbFull(Cards: TByteCards; var Mask: TMask);
function PositionWithoutSuits(Cards: TCards): Byte;
procedure FillCardsWithoutSuit(var Cards: TCards);
function GenerateOppFull(Cards: TByteCards; Amount: Integer; var Mask: TMask; NumberOfOpponents: Byte): TProb;

implementation

uses System.DateUtils, System.SysUtils;

var Funcs: TArrFunc;

function NominalOrd(ToCheck: string): Byte;
var i:Byte;
begin
  Result:=0;
  for i:=1 to 13 do
  begin
    if Nominals[i] = ToCheck then
    Result:=i;
  end;
end;

function SuitOrd(ToCheck: string): Byte;
var i:Byte;
begin
  Result:=0;
  for i:=1 to 4 do
  begin
    if Suits[i] = ToCheck then
    Result:=i;
  end;
end;

function CheckNominal(ToCheck: string):Boolean;
var i: Byte;
begin
  Result:=False;
  for i:=1 to 13 do
  begin
    if Nominals[i] = ToCheck then
    Result:=True;
  end;
end;

function CheckSuit(ToCheck: string):Boolean;
var i: Byte;
begin
  Result:=False;
  for i:=1 to 4 do
  begin
    if Suits[i] = ToCheck then
    Result:=True;
  end;
end;

function NeedToPlay(N1, N2, S1, S2: string): string;
var Temp: Byte;
Cards: TCards;
begin
  SetLength(Cards, 2);
  Cards[0].Suit:=S1;
  Cards[1].Suit:=S2;
  Cards[0].Nominal:=N1;
  Cards[1].Nominal:=N2;
  if PositionIsCorrect(Cards) = 2 then
  begin
    if S1 = S2 then
    Temp:=OneSuit[NominalOrd(N1)][NominalOrd(N2)]
    else
    Temp:=TwoSuits[NominalOrd(N1)][NominalOrd(N2)];
    if Temp = 0 then
    Result:='�� ������� ������'
    else if Temp = 1 then
    Result:='������� ������ � ������� ������'
    else if Temp = 2 then
    Result:='������� � ������� � ������� ������'
    else if Temp = 3 then
    Result:='������� � ����� �������'
  end
  else
  Result:='������';
end;

procedure FillCardsWithoutSuit(var Cards: TCards);
var i, Temp: Byte;
CardsSuit: array[1..13] of Byte;
begin
  for i:=1 to 13 do
    CardsSuit[i]:=0;
  for i:=0 to length(Cards)-1 do
  begin
    Temp:=CardsSuit[NominalOrd(Cards[i].Nominal)];
    Cards[i].Suit:=Suits[Temp+1];
    Inc(CardsSuit[NominalOrd(Cards[i].Nominal)]);
  end;
end;

function ConvertIntoByteArray(Cards: TCards): TByteCards;
  var i: Byte;
  begin
    SetLength(Result, Length(Cards));
    for i:=0 to Length(Cards)-1 do
    begin
      Result[i].Suit:=SuitOrd(Cards[i].Suit);
      Result[i].Nominal:=NominalOrd(Cards[i].Nominal);
    end;
  end;

function HighCard(Cards: TByteCards): string;
var i, Max: Byte;
begin
  Max:=0;
  for i:= 0 to Length(Cards)-1 do
  begin
    if Cards[i].Nominal>Max then
    Max:=Cards[i].Nominal;
  end;
  Result:=Nominals[Max];
end;

function PositionIsCorrect(Cards: TCards): Byte;
var
isCorrect: Boolean;
i, j:Byte;
begin
  isCorrect:=True;
  for i:=0 to Length(Cards)-1 do
  begin
    if not (CheckSuit(Cards[i].Suit) and CheckNominal(Cards[i].Nominal)) then
    isCorrect:=False;
  end;
  if isCorrect then
  begin
    for i:=0 to Length(Cards)-2 do
    begin
      for j := i+1 to Length(Cards)-1 do
      if (Cards[i].Suit = Cards[j].Suit) and (Cards[i].Nominal = Cards[j].Nominal) then
      isCorrect:=False;
    end;
  end;
  if isCorrect then
  Result:=Length(Cards)
  else
  Result:=0;
end;

function PositionWithoutSuits(Cards: TCards): Byte;
var i, j:Byte;
isCorrect: Boolean;
NominalsWithoutSuit: array[1..13] of Byte;
begin
  IsCorrect:=True;
  for i:=0 to length(Cards) - 1 do
  begin
    if (Cards[i].Suit <> '') or not (CheckNominal(Cards[i].Nominal)) then
    IsCorrect:=False;
  end;
  if isCorrect then
  begin
    for i:=1 to 13 do
    begin
      NominalsWithoutSuit[i]:=0;
    end;
    for i:=0 to length(Cards)-1 do
    begin
      Inc(NominalsWithoutSuit[NominalOrd(Cards[i].Nominal)]);
    end;
    for i:=1 to 13 do
    begin
      if NominalsWithoutSuit[i]>4 then
      isCorrect:=False;
    end;
  end;
  if not isCorrect then
  Result:=0
  else
  Result:=Length(Cards);
end;

function CheckPair(Cards: TByteCards): Boolean;
var i, j, Len: Byte;
begin
  Result:=False;
  Len:=Length(Cards);
  for i:=0 to len-2 do
  begin
    for j:=i+1 to Len-1 do
    begin
      if Cards[i].Nominal = Cards[j].Nominal then
      Result:=True;
    end;
  end;
end;

function CheckTwoPairs(Cards: TByteCards): Boolean;
var i, j, Len, Pair1Nominal: Byte;
begin
  Result:=False;
  Len:=Length(Cards);
  Pair1Nominal:=0;
  for i:=0 to Len-2 do
  begin
    for j:=i+1 to len-1 do
    begin
      if (Cards[i].Nominal = Cards[j].Nominal) and (Cards[i].Nominal <> Pair1Nominal) then
      begin
        if Pair1Nominal = 0 then
        Pair1Nominal:=Cards[i].Nominal
        else
        Result:=True;
      end;
    end;
  end;
end;

function CheckThree(Cards: TByteCards): Boolean;
var i, j, k, Len: Byte;
begin
  Result:=False;
  Len:=Length(Cards);
  for i:=0 to Len - 3 do
  begin
    for j:=i+1 to Len - 2 do
    begin
      for k:=j+1 to Len - 1 do
      begin
        if (Cards[i].Nominal = Cards[j].Nominal) and (Cards[i].Nominal = Cards[k].Nominal) then
        Result:=True;
      end;
    end;
  end;
end;

function CheckFour(Cards: TByteCards): Boolean;
var i, j, k, h, Len: Byte;
begin
  Result:=false;
  Len:=Length(Cards);
  for i:=0 to len - 4 do
  begin
    for j:=i+1 to len - 3 do
    begin
      for k:=j+1 to len - 2 do
      begin
        for h:=k+1 to len - 1 do
        begin
          if (Cards[i].Nominal = Cards[j].Nominal) and (Cards[i].Nominal = Cards[k].Nominal)
          and (Cards[i].Nominal = Cards[h].Nominal) then
          Result:=True;
        end;
      end;
    end;
  end;
end;

function CheckFlash(Cards: TByteCards): Boolean;
var
NumberPerSuit: array[1..4] of Byte;
i: Byte;
begin
  Result:=False;
  for i:=1 to 4 do
  begin
    NumberPerSuit[i]:=0;
  end;
  for i:=0 to length(Cards)-1 do
  begin
    Inc(NumberPerSuit[Cards[i].Suit]);
    if (NumberPerSuit[Cards[i].Suit]) = 5 then
    Result:=True;
  end;
end;

function CheckFullHouse(Cards: TByteCards): Boolean;
var i, j, k, i0, j0, k0, Len: Byte;
Temp: TRec;
isFound: Boolean;
begin
  Result:=False;
  isFound:=False;
  Len:=Length(Cards);
  for i:=0 to Len-3 do
  begin
    for j:=i+1 to Len-2 do
    begin
      for k:=j+1 to Len-1 do
      begin
        if (Cards[i].Nominal = Cards[j].Nominal) and (Cards[i].Nominal = Cards[k].Nominal) then
        begin
          isFound:=True;
          i0:=i;
          j0:=j;
          k0:=k;
        end;
      end;
    end;
  end;
  if isFound then
  begin
    Temp:=Cards[Len-3];
    Cards[Len-3]:=Cards[i0];
    Cards[i0]:=Temp;

    Temp:=Cards[Len-2];
    Cards[Len-2]:=Cards[j0];
    Cards[j0]:=Temp;

    Temp:=Cards[Len-1];
    Cards[Len-1]:=Cards[k0];
    Cards[k0]:=Temp;

    SetLength(Cards, Len-3);
    Result:=CheckPair(Cards);
  end;
end;

function CheckStreet(Cards: TByteCards): Boolean;
var NominalsMas: array[1..13] of Boolean;
i, Count: Byte;
begin
  Result:=False;
  for i:=1 to 13 do
  begin
    NominalsMas[i]:=False;
  end;
  for i:=0 to Length(Cards)-1 do
  begin
    NominalsMas[Cards[i].Nominal]:=True;
  end;
  Count:=0;
  for i:=1 to 13 do
  begin
    if NominalsMas[i] then
    Inc(Count)
    else
    Count:=0;
    if Count = 5 then
      Result:=True;
  end;
  if NominalsMas[1] and NominalsMas[2] and NominalsMas[3] and NominalsMas[4] and NominalsMas[13] then
  Result:=True;
end;

function CheckStreetFlash(Cards: TByteCards): Boolean;
var i, j, Count: Byte;
AllSuits: array[1..4, 1..13] of Boolean;
begin
  Result:=False;
  for i:=1 to 4 do
  begin
    for j:=1 to 13 do
    begin
      AllSuits[i][j]:=False;
    end;
  end;
  for i:=0 to length(Cards)-1 do
  begin
    AllSuits[Cards[i].Suit][Cards[i].Nominal]:=True;
  end;
  for i:=1 to 4 do
  begin
    Count:=0;
    for j:=1 to 13 do
    begin
      if AllSuits[i][j] then
      Inc(Count)
      else
      Count:=0;
      if Count = 5 then
      Result:=True;
    end;
    if AllSuits[i][1] and AllSuits[i][2] and AllSuits[i][3] and AllSuits[i][4] and AllSuits[i][13] then
    Result:=True;
  end;
end;

function CheckRoyalStreet(Cards: TByteCards): Boolean;
var i, j: Byte;
AllSuits: array[1..4, 1..13] of Boolean;
begin
  Result:=False;
  for i:=1 to 4 do
  begin
    for j:=1 to 13 do
    begin
      AllSuits[i][j]:=False;
    end;
  end;
  for i:=0 to length(Cards)-1 do
  begin
    AllSuits[Cards[i].Suit][Cards[i].Nominal]:=True;
  end;
  for i:=1 to 4 do
  begin
    if AllSuits[i][9] and AllSuits[i][10] and AllSuits[i][11] and AllSuits[i][12] and AllSuits[i][13] then
    Result:=True;
  end;
end;

function GenerateProb(Cards: TByteCards; Amount: Integer; Mask: TMask; NumberOfOpponents: Byte): TProb;
var AllCards: TAllCards;
i: Integer;
i1, i2, Len: Byte;
TempCards: TByteCards;
OppCards: array of TByteCards;
isUnique, Exsists: Boolean;
x, y: Byte;
begin
  randomize;
  SetLength(OppCards, NumberOfOpponents, 7);
  if NumberOfOpponents>0 then
  SetLength(Result, 2)
  else
  SetLength(Result, 1);
  for i:=2 to 10 do                             //������ � ���������� ��� �����
  begin
    for i1:=0 to Length(Result)-1 do
    begin
      Result[i1][i]:=0;
    end;
  end;
  for i:=1 to Amount do
  begin
    randomize;
    for i1:=1 to 4 do
    begin
      for i2:=1 to 13 do
      begin
        AllCards[i1][i2]:=False;
      end;
    end;
    TempCards:=Cards;
    for i1:= 0 to Length(TempCards)-1 do
      AllCards[TempCards[i1].Suit][TempCards[i1].Nominal]:=True;
    Len:=Length(TempCards);
    SetLength(TempCards, 7);
    while Len<7 do
    begin
      isUnique:=False;
      while not isUnique do
      begin
        x:=Random(4)+1;
        y:=Random(13)+1;
        isUnique:=not AllCards[x][y];
        AllCards[x][y]:=True;
      end;
      TempCards[Len].Suit:=x;
      TempCards[Len].Nominal:=y;
      Inc(Len);
    end;
    if NumberOfOpponents>0 then
    begin
      for i1:=0 to NumberOfOpponents-1 do
      begin
        for i2:=2 to 6 do
        begin
          OppCards[i1][i2].Suit:=TempCards[i2].Suit;
          OppCards[i1][i2].Nominal:=TempCards[i2].Nominal;
        end;
      end;
      for i1:=0 to NumberOfOpponents-1 do
      begin
        for i2:=0 to 1 do
        begin
          isUnique:=False;
          while not isUnique do
          begin
            x:=Random(4)+1;
            y:=Random(13)+1;
            isUnique:=not AllCards[x][y];
            AllCards[x][y]:=True;
          end;
          OppCards[i1][i2].Suit:=x;
          OppCards[i1][i2].Nominal:=y;
        end;
      end;
    end;
    for i1:=2 to 10 do
    begin
      if Mask[i1] then
      begin
      if Funcs[i1](TempCards) then
        Result[0][i1]:=Result[0][i1]+1;
      Exsists:=False;
      i2:=0;
      while not Exsists and (i2<NumberOfOpponents) do
        begin
          if Funcs[i1](OppCards[i2]) then
          begin
            Result[1][i1]:=Result[1][i1]+1;
            Exsists:=True;
          end;
          Inc(i2);
        end;
      end;
    end;
  end;
  if NumberOfOpponents>0 then
  begin
    for i:=2 to 10 do
    Result[1][i]:=Result[1][i]/Amount*100;
  end;
  for i:=2 to 10 do
    Result[0][i]:=Result[0][i]/Amount*100;
end;

procedure GenerateProbFull(Cards: TByteCards; var Mask: TMask);
var i:Byte;
begin
  for i:=2 to 10 do
    Mask[i]:=Funcs[i](Cards) and Mask[i];
end;

function GenerateOppFull(Cards: TByteCards; Amount: Integer; var Mask: TMask; NumberOfOpponents: Byte): TProb;
var CleanAllCards, AllCards: TAllCards;
i: Integer;
i1, i2, Len: Byte;
OppCards: array of TByteCards;
isUnique, Exsists: Boolean;
x, y: Byte;
begin
  randomize;
  SetLength(OppCards, NumberOfOpponents, 7);
  SetLength(Result, 1);
  for i:=2 to 10 do
  begin
    Result[0][i]:=0;
  end;
  for i1:=1 to 4 do
  begin
    for i2:=1 to 13 do
    begin
      CleanAllCards[i1][i2]:=False;
    end;
  end;
  for i:=1 to Amount do
  begin
    randomize;
    AllCards:=CleanAllCards;
    for i1:= 0 to Length(Cards)-1 do
      AllCards[Cards[i1].Suit][Cards[i1].Nominal]:=True;
    for i1:=0 to NumberOfOpponents-1 do
    begin
      for i2:=0 to 1 do
      begin
        isUnique:=False;
        while not isUnique do
        begin
          x:=Random(4)+1;
          y:=Random(13)+1;
          isUnique:=not AllCards[x][y];
          AllCards[x][y]:=True;
        end;
        OppCards[i1][i2].Suit:=x;
        OppCards[i1][i2].Nominal:=y;
      end;
      for i2:=2 to 6 do
      begin
        OppCards[i1][i2].Suit:=Cards[i2].Suit;
        OppCards[i1][i2].Nominal:=Cards[i2].Nominal;
      end;
    end;
    for i1:=2 to 10 do
    begin
      if Mask[i1] then
      begin
      Exsists:=False;
      i2:=0;
      while not Exsists and (i2<NumberOfOpponents) do
        begin
          if Funcs[i1](OppCards[i2]) then
          begin
            Result[0][i1]:=Result[0][i1]+1;
            Exsists:=True;
          end;
          Inc(i2);
        end;
      end;
    end;
  end;
  for i:=2 to 10 do
  Result[0][i]:=Result[0][i]/Amount*100;
end;

initialization

Funcs[2]:=@CheckPair;
Funcs[3]:=@CheckTwoPairs;
Funcs[4]:=@CheckThree;
Funcs[5]:=@CheckStreet;
Funcs[6]:=@CheckFlash;
Funcs[7]:=@CheckFullHouse;
Funcs[8]:=@CheckFour;
Funcs[9]:=@CheckStreetFlash;
Funcs[10]:=@CheckRoyalStreet;

end.
