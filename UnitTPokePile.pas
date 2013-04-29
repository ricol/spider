unit UnitTPokePile;

interface

uses
  Messages, Windows, SysUtils, Graphics, UnitCommon, UnitTPanelPoke;

type
  //this class represents the card pile including MAIN, TEMP and RECYCLE cards.
  TPokePile = class
  private
    FPoke: array[1..MAXPOKE] of TPanelPoke;
    FFIndex: integer;
    FPileNumber: integer;
    FHandle: cardinal;
    FFType: TType;
    procedure SetFIndex(const Value: integer);
    procedure SetPileNumber(const Value: integer);
    procedure SetHandle(const Value: cardinal);
    procedure SetFType(const Value: TType);
  public
    constructor Create();
    destructor Destroy(); override;
    function GetPoke(tmpIndex: integer): TPanelPoke;
    function IsEmpty(): boolean;
    procedure CaculatePositiveNumber();
    procedure Show();
    procedure AddPoke(tmpPoke: TPanelPoke);
    procedure RemovePoke(tmpPoke: TPanelPoke);
    property FIndex: integer read FFIndex write SetFIndex;
    property PileNumber: integer read FPileNumber write SetPileNumber;
    property Handle: cardinal read FHandle write SetHandle;
    property FType: TType read FFType write SetFType;
  end;

implementation

{ TPokePile }

procedure TPokePile.AddPoke(tmpPoke: TPanelPoke);
begin
  if FType = MAIN then
  begin
    inc(FFIndex);
    FPoke[FFIndex] := tmpPoke;
    FPoke[FFIndex].PileNumber := FPileNumber;
    FPoke[FFIndex].Number := FIndex;
    FPoke[FFIndex].FType := MAIN;
    FPoke[FFIndex].Initiator := false;
    FPoke[FFIndex].PositiveNumber := 0;
    FPoke[FFIndex].CanMoveAsGroup := false;
    FPoke[FFIndex].BringToFront;
  end else if FType = TEMP then
  begin
    inc(FFIndex);
    FPoke[FFIndex] := tmpPoke;
    FPoke[FFIndex].PileNumber := FPileNumber;
    FPoke[FFIndex].Number := FIndex;
    Fpoke[FFIndex].BringToFront;
  end else if FType = RECYCLE then
  begin
    inc(FFindex);
    FPoke[FFIndex] := tmpPoke;
    FPoke[FFIndex].PileNumber := FPileNumber;
    FPoke[FFIndex].Number := FIndex;
    FPoke[FFIndex].FType := RECYCLE;
    FPoke[FFIndex].BringToFront;
  end;
end;

procedure TPokePile.CaculatePositiveNumber;
var
  i, num: integer;
begin
  num := 1;
  for i := 1 to FIndex do
  begin
    if FPoke[i].PositiveFlag then
    begin
      FPoke[i].PositiveNumber := num;
      inc(num);
    end else
      FPoke[i].PositiveNumber := 0;
  end;
end;

constructor TPokePile.Create;
var
  i: integer;
begin
  FIndex := 0;
  FHandle := 0;
  for i := 1 to MAXPOKE do
    FPoke[i] := nil;
end;

destructor TPokePile.Destroy;
var
  i: integer;
begin
  for i := 1 to MAXPOKE do
    try
      FPoke[i].Free;
    except

    end;
  inherited;
end;

function TPokePile.GetPoke(tmpIndex: integer): TPanelPoke;
begin
  if (tmpIndex <= 0) or (tmpIndex > FIndex) then
    result := nil
  else
    result := FPoke[tmpIndex];
end;

function TPokePile.IsEmpty: boolean;
begin
  result := false;
  if FIndex <= 0 then
    result := true;
end;

procedure TPokePile.RemovePoke(tmpPoke: TPanelPoke);
begin
  if FType = MAIN then
  begin
    FPoke[FFIndex] := nil;
    dec(FFIndex);
    if FFIndex > 0 then
      FPoke[FFIndex].Reverse(true);
  end else if FType = TEMP then
  begin
    FPoke[FFIndex] := nil;
    dec(FFIndex);
    tmpPoke.Hide;
  end;
end;

procedure TPokePile.SetFIndex(const Value: integer);
begin
  FFIndex := Value;
end;

procedure TPokePile.SetFType(const Value: TType);
begin
  FFType := Value;
end;

procedure TPokePile.SetHandle(const Value: cardinal);
begin
  FHandle := Value;
end;

procedure TPokePile.SetPileNumber(const Value: integer);
begin
  FPileNumber := Value;
end;

procedure TPokePile.Show();
var
  i: integer;
begin
  for i := 1 to FIndex do
    FPoke[i].ShowMe;
end;

end.
