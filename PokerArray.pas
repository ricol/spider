unit PokerArray;

interface

uses
  Windows, SysUtils, Common;

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
    constructor Create(diff: TDifficulty);
    destructor Destroy(); override;
    function GetPoke(): TPokeNum;
    procedure SwapPokeNum(var p1: TPokeNum; var p2: TPokeNum);
    procedure RandomData();
  end;

implementation

{ TPokeArray }

constructor TPokeArray.Create(diff: TDifficulty);
var
  i, j, k: integer;
begin
  k := 1;
  if diff = EASY then
  begin
    for i := 1 to 8 do
      for j := 1 to 13 do
      begin
        FPokeArray[k].x := j;
        FPokeArray[k].y := 4;
        inc(k);
      end;
  end
  else if diff = MEDIUM then
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

procedure TPokeArray.SwapPokeNum(var p1: TPokeNum;
  var p2: TPokeNum);
var
  tmp: TPokeNum;
begin
  tmp := p1;
  p1 := p2;
  p2 := tmp;
end;

end.
