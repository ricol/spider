unit UnitTPanelPoke;

interface

uses
  Messages, Windows, SysUtils, Classes, Graphics, Controls, ExtCtrls, UnitCommon, MMSystem;

type
  TPanelPoke = class(TImage)
  private
    FbmpPositiveFace, FbmpNegativeFace: TBitmap;
    FOldX, FOldY: integer;
    FInitiator: boolean;
    FCanMoveAsGroup: boolean;
    FCanDrag: boolean;
    FHandle: cardinal;
    FNumber: integer;
    FPositiveFlag: boolean;
    FFType: TType;
    FPositiveNumber: integer;
    FPileNumber: integer;
    FX: integer;
    FY: integer;
    procedure SetInitiator(const Value: boolean);
    procedure SetCanMoveAsGroup(const Value: boolean);
    procedure SetCanDrag(const Value: boolean);
    procedure SetHandle(const Value: cardinal);
    procedure SetNumber(const Value: integer);
    procedure SetPositiveFlag(const Value: boolean);
    procedure SetFType(const Value: TType);
    procedure SetPositiveNumber(const Value: integer);
    procedure SetPileNumber(const Value: integer);
    procedure SetX(const Value: integer);
    procedure SetY(const Value: integer);
  public
    destructor Destroy(); override;
    procedure Init(tmpX, tmpY: integer; tmpHandle: cardinal;
    tmpPileNumber, tmpNumber: integer; tmpFlag: boolean; tmpHaveMoved: boolean;
    tmpType: TTYpe; tmpPositiveNumber: integer; tmpParent: TComponent);
    procedure ShowPicture();
    procedure ShowMe();
    procedure MoveTo(tmpTargetPile, tmpTargetNumber, tmpPositiveNumber: integer; tmpType: TTYpe);
    procedure Reverse(tmpFlag: boolean);
    procedure Dark(tmpFlag: boolean);
    property Handle: cardinal read FHandle write SetHandle;
    property X: integer read FX write SetX;
    property Y: integer read FY write SetY;
    property CanDrag: boolean read FCanDrag write SetCanDrag;
    property Initiator: boolean read FInitiator write SetInitiator;
    property CanMoveAsGroup: boolean read FCanMoveAsGroup write SetCanMoveAsGroup;
    property Number: integer read FNumber write SetNumber;
    property PositiveFlag: boolean read FPositiveFlag write SetPositiveFlag;
    property FType: TType read FFType write SetFType;
    property PositiveNumber: integer read FPositiveNumber write SetPositiveNumber;
    property PileNumber: integer read FPileNumber write SetPileNumber;
    function Match(tmpParentPoke: TPanelPoke): boolean;
    procedure Process_WM_LBUTTONDOWN(var tmpMsg: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure Process_WM_LBUTTONUP(var tmpMsg: TWMLButtonUP); message WM_LBUTTONUP;
    procedure Process_WM_MOUSEMOVE(var tmpMsg: TWMMouseMove); message WM_MOUSEMOVE;
    procedure Process_WM_RBUTTONDOWN(var tmpMsg: TWMRButtonDown); message WM_RBUTTONDOWN;
  end;

implementation

{ TUnitTPanelPoke }

procedure TPanelPoke.Dark(tmpFlag: boolean);
begin
  if tmpFlag then
  begin
    with Self.Picture.Bitmap do
      PatBlt(Canvas.Handle, 0, 0, Width - 1, Height - 1, DSTINVERT);
  end else
    Self.Picture.Bitmap := FbmpPositiveFace;
  Self.Refresh;
end;

destructor TPanelPoke.Destroy;
begin
  FbmpPositiveFace.Free;
  FbmpNegativeFace.Free;
  inherited;
end;

procedure TPanelPoke.Init(tmpX, tmpY: integer; tmpHandle: cardinal;
  tmpPileNumber, tmpNumber: integer; tmpFlag: boolean; tmpHaveMoved: boolean;
  tmpType: TTYpe; tmpPositiveNumber: integer; tmpParent: TComponent);
begin
  Parent := TWinControl(tmpParent);
  FCanDrag := false;
  FHandle := tmpHandle;
  FbmpPositiveFace := TBitmap.Create;
  FPileNumber := tmpPileNumber;
  FNumber := tmpNumber;
  Fx := tmpX;
  Fy := tmpY;
  FbmpPositiveFace.LoadFromResourceName(hInstance, 'BMPPOKE' + Format('%d_%d', [tmpX, tmpY]));
  FbmpNegativeFace := TBitmap.Create;
  FbmpNegativeFace.LoadFromResourceName(hInstance, 'BMPCARDBACK');
  FPositiveFlag := tmpFlag;
  FType := tmpType;
  FInitiator := false;
  FCanMoveAsGroup := false;
end;

function TPanelPoke.Match(tmpParentPoke: TPanelPoke): boolean;
begin
  result := false;
  if Self.Fx <> tmpParentPoke.Fx - 1 then exit;
  result := true;
end;

procedure TPanelPoke.MoveTo(tmpTargetPile, tmpTargetNumber, tmpPositiveNumber: integer; tmpType: TTYpe);
var
  tmpTargetX, tmpTargetY, tmpOldX, tmpOldY, tmpX, tmpY, i, tmpIncX, tmpIncY: integer;
begin
  if not GAnimateEffect then exit;
  tmpTargetX := 0;
  tmpTargetY := 0;
  if tmpType = MAIN then
  begin
    tmpTargetX := (tmpTargetPile - 1) * GMainLenX + GMainStartX;
    tmpTargetY := 2 * tmpPositiveNumber * GMainLenY + (tmpTargetNumber - 1) *  2 * GMainLenY + GMainStartY - tmpTargetNumber * GMainLenY - tmpPositiveNumber * GMainLenY;
  end else if tmpType = RECYCLE then
  begin
    tmpTargetX := (tmpTargetPile - 1) * GRecycleLenX + GRecycleStartX;
    tmpTargetY := GRecycleStartY;
  end;
  tmpOldX := Self.Left;
  tmpOldY := Self.Top;
  tmpX := tmpOldX;
  tmpY := tmpOldY;
  tmpIncX := (tmpTargetX - tmpOldX) div TIMES;
  tmpIncY := (tmpTargetY - tmpOldY) div TIMES;
  Self.BringToFront;
  for i := 1 to TIMES - 1 do
  begin
    tmpX := tmpX + tmpIncX;
    tmpY := tmpY + tmpIncY;
    Self.Left := tmpX;
    Self.Top := tmpY;
    Self.Refresh;
    Sleep(10);
  end;
  Self.Left := tmpTargetX;
  Self.Top := tmpTargetY;
  Self.Refresh;
end;

procedure TPanelPoke.Process_WM_LBUTTONDOWN(var tmpMsg: TWMLButtonDown);
begin
  if FType = MAIN then
  begin
    if not FPositiveFlag then
    begin
      inherited;
      exit;
    end;
    FOldX := tmpMsg.XPos;
    FOldY := tmpMsg.YPos;
    SoundEffect('SOUND5');
    Self.FInitiator := true;
    SendMessage(Self.FHandle, WM_BEGINMOVE, Self.FPileNumber, Self.FNumber);
  end;
  inherited;
end;

procedure TPanelPoke.Process_WM_LBUTTONUP(var tmpMsg: TWMLButtonUP);
begin
  if FType = TEMP then
    SendMessage(Self.Handle, WM_SENDCARDS, 0, 0)
  else if FType = MAIN then
  begin
    FCanDrag := false;
    SoundEffect('SOUND2');
    Self.FInitiator := false;
    SendMessage(FHandle, WM_ENDMOVE, FPileNumber, FNumber);
  end;
  inherited;
end;

procedure TPanelPoke.Process_WM_MOUSEMOVE(var tmpMsg: TWMMouseMove);
begin
  if FType <> MAIN then
  begin
    inherited;
    exit;
  end;
  if not FCanDrag then
  begin
    inherited;
    exit;
  end;
  Left := Left + (tmpMsg.XPos - FOldX);
  Top := Top + (tmpMsg.YPos - FOldY);
  SendMessage(FHandle, WM_MOVING, (tmpMsg.XPos - FOldX), (tmpMsg.YPos - FOldY));
  inherited;
end;

procedure TPanelPoke.Process_WM_RBUTTONDOWN(var tmpMsg: TWMRButtonDown);
begin
  Beep;
end;

procedure TPanelPoke.Reverse(tmpFlag: boolean);
begin
  FPositiveFlag := tmpFlag;
  Self.ShowPicture;
end;

procedure TPanelPoke.SetCanDrag(const Value: boolean);
begin
  FCanDrag := Value;
end;

procedure TPanelPoke.SetCanMoveAsGroup(const Value: boolean);
begin
  FCanMoveAsGroup := Value;
end;

procedure TPanelPoke.SetFType(const Value: TType);
begin
  FFType := Value;
end;

procedure TPanelPoke.SetHandle(const Value: cardinal);
begin
  FHandle := Value;
end;

procedure TPanelPoke.SetInitiator(const Value: boolean);
begin
  FInitiator := Value;
end;

procedure TPanelPoke.SetNumber(const Value: integer);
begin
  FNumber := Value;
end;

procedure TPanelPoke.SetPileNumber(const Value: integer);
begin
  FPileNumber := Value;
end;

procedure TPanelPoke.SetPositiveFlag(const Value: boolean);
begin
  FPositiveFlag := Value;
end;

procedure TPanelPoke.SetPositiveNumber(const Value: integer);
begin
  FPositiveNumber := Value;
end;

procedure TPanelPoke.SetX(const Value: integer);
begin
  FX := Value;
end;

procedure TPanelPoke.SetY(const Value: integer);
begin
  FY := Value;
end;

procedure TPanelPoke.ShowMe;
begin
  case FType of
    MAIN:
    begin
      if FPositiveFlag then
        Top := 2 * FPositiveNumber * GMainLenY + (FNumber - 1) *  2 * GMainLenY + GMainStartY - FNumber * GMainLenY - FPositiveNumber * GMainLenY
      else
      Top := (FNumber - 1) * GMainLenY + GMainStartY;
      Left := (FPileNumber - 1) * GMainLenX + GMainStartX;
      Width := POKEWIDTH;
      Height := POKEHEIGHT;
    end;
    TEMP:
    begin
      Left := (FPileNumber - 1) * GTempLenX + GTempStartX;
      Top := GTempStartY;
      Width := POKEWIDTH;
      Height := POKEHEIGHT;
    end;
    RECYCLE:
    begin
      Left := (FPileNumber - 1) * GRecycleLenX + GRecycleStartX;
      Top := GRecycleStartY;
      Width := POKEWIDTH;
      Height := POKEHEIGHT;
    end;
  end;
  ShowPicture;
end;

procedure TPanelPoke.ShowPicture;
begin
  if FPositiveFlag then
    Self.Picture.Bitmap := FbmpPositiveFace
  else
    Self.Picture.Bitmap := FbmpNegativeFace;
  Show;
end;

end.
