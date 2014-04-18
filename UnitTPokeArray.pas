unit UnitTPokeArray;

interface

uses
  Windows, SysUtils, UnitCommon;

const
  CARDNUMBER = 104;
  RANDOMNUM = 1000;

type
  TPokeNum = record
    x, y: integer;
  end;

  TPokeArray = class // this class is to generate random cards.
  private
    FPokeArray: array [1 .. CARDNUMBER] of TPokeNum;
    FIndex: integer;
  public
    constructor Create(tmpDifficulty: TDifficulty);
    destructor Destroy(); override;
    function GetPoke(): TPokeNum;
    procedure SwapPokeNum(var tmpPokeNum1: TPokeNum; var tmpPokeNum2: TPokeNum);
    procedure RandomData();
  end;

implementation

{ TPokeArray }

constructor TPokeArray.Create(tmpDifficulty: TDifficulty);
var
  i, j, k: integer;
begin
  k := 1;
  if tmpDifficulty = EASY then
  begin
    for i := 1 to 8 do
      for j := 1 to 13 do
      begin
        FPokeArray[k].x := j;
        FPokeArray[k].y := 4;
        inc(k);
      end;
  end
  else if tmpDifficulty = MEDIUM then
  begin
    for i := 1 to 4 do
      for j := 1 to 13 do
      begin
        FPokeArray[k].x := j;
        FPokeArray[k].y := 4;
        inc(k);
      end;
    for i := 1 to 4 do
      for j := 1 to 13 do
      begin
        FPokeArray[k].x := j;
        FPokeArray[k].y := 3;
        inc(k);
      end;
  end
  else
  begin
    for i := 1 to 8 do
      for j := 1 to 13 do
      begin
        FPokeArray[k].x := j;
        FPokeArray[k].y := (i + 1) div 2;
        inc(k);
      end;
  end;
  FIndex := 1;
  RandomData();
end;

destructor TPokeArray.Destroy;
begin
  inherited;
end;

function TPokeArray.GetPoke: TPokeNum;
begin
  result := FPokeArray[FIndex];
  inc(FIndex);
end;

procedure TPokeArray.RandomData;
var
  i: integer;
begin
  Randomize;
  for i := 1 to RANDOMNUM do
    SwapPokeNum(FPokeArray[Random(CARDNUMBER) + 1],
      FPokeArray[Random(CARDNUMBER) + 1]);
end;

procedure TPokeArray.SwapPokeNum(var tmpPokeNum1: TPokeNum;
  var tmpPokeNum2: TPokeNum);
var
  tmpPokeNum: TPokeNum;
begin
  tmpPokeNum := tmpPokeNum1;
  tmpPokeNum1 := tmpPokeNum2;
  tmpPokeNum2 := tmpPokeNum;
end;

end.
