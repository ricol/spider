unit PanelPoker;

interface

uses
  Messages, Windows, SysUtils, Classes, Graphics, Controls, ExtCtrls,
  Common, MMSystem;

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
    procedure Init(x, y: integer; handle: cardinal;
      pileNum, num: integer; flag: boolean;
      bHaveMoved: boolean; _type: TType; posNum: integer;
      parentComponent: TComponent);
    procedure ShowPicture();
    procedure ShowMe();
    procedure MoveTo(targetPile, targetNum, posNum: integer;
      _type: TType);
    procedure Reverse(tmpFlag: boolean);
    procedure Dark(flag: boolean);
    property Handle: cardinal read FHandle write SetHandle;
    property X: integer read FX write SetX;
    property Y: integer read FY write SetY;
    property CanDrag: boolean read FCanDrag write SetCanDrag;
    property Initiator: boolean read FInitiator write SetInitiator;
    property CanMoveAsGroup: boolean read FCanMoveAsGroup
      write SetCanMoveAsGroup;
    property Number: integer read FNumber write SetNumber;
    property PositiveFlag: boolean read FPositiveFlag write SetPositiveFlag;
    property FType: TType read FFType write SetFType;
    property PositiveNumber: integer read FPositiveNumber
      write SetPositiveNumber;
    property PileNumber: integer read FPileNumber write SetPileNumber;
    function Match(parentPoker: TPanelPoke): boolean;
    procedure Process_WM_LBUTTONDOWN(var tmpMsg: TWMLButtonDown);
      message WM_LBUTTONDOWN;
    procedure Process_WM_LBUTTONUP(var tmpMsg: TWMLButtonUP);
      message WM_LBUTTONUP;
    procedure Process_WM_MOUSEMOVE(var tmpMsg: TWMMouseMove);
      message WM_MOUSEMOVE;
    procedure Process_WM_RBUTTONDOWN(var tmpMsg: TWMRButtonDown);
      message WM_RBUTTONDOWN;
  end;

implementation

{ TUnitTPanelPoke }

procedure TPanelPoke.Dark(flag: boolean);
begin
  if flag then
  begin
    with Self.Picture.Bitmap do
      PatBlt(Canvas.Handle, 0, 0, Width - 1, Height - 1, DSTINVERT);
  end
  else
    Self.Picture.Bitmap := FbmpPositiveFace;
  Self.Refresh;
end;

destructor TPanelPoke.Destroy;
begin
  FbmpPositiveFace.Free;
  FbmpNegativeFace.Free;
  inherited;
end;

procedure TPanelPoke.Init(x, y: integer; handle: cardinal;
  pileNum, num: integer; flag: boolean; bHaveMoved: boolean;
  _type: TType; posNum: integer; parentComponent: TComponent);
begin
  Parent := TWinControl(parentComponent);
  FCanDrag := false;
  FHandle := handle;
  FbmpPositiveFace := TBitmap.Create;
  FPileNumber := pileNum;
  FNumber := num;
  FX := x;
  FY := y;
  FbmpPositiveFace.LoadFromResourceName(hInstance, 'BMPPOKE' + Format('%d_%d',
    [x, y]));
  FbmpNegativeFace := TBitmap.Create;
  FbmpNegativeFace.LoadFromResourceName(hInstance, 'BMPCARDBACK');
  FPositiveFlag := flag;
  FType := _type;
  FInitiator := false;
  FCanMoveAsGroup := false;
end;

function TPanelPoke.Match(parentPoker: TPanelPoke): boolean;
begin
  result := false;
  if Self.FX <> parentPoker.FX - 1 then
    exit;
  result := true;
end;

procedure TPanelPoke.MoveTo(targetPile, targetNum, posNum
  : integer; _type: TType);
var
  targetX, targetY, oldX, oldY, x, y, i, incX,
    incY: integer;
begin
  if not GAnimateEffect then
    exit;
  targetX := 0;
  targetY := 0;
  if _type = MAIN then
  begin
    targetX := (targetPile - 1) * GMainLenX + GMainStartX;
    targetY := 2 * posNum * GMainLenY + (targetNum - 1) * 2
      * GMainLenY + GMainStartY - targetNum * GMainLenY -
      posNum * GMainLenY;
  end
  else if _type = RECYCLE then
  begin
    targetX := (targetPile - 1) * GRecycleLenX + GRecycleStartX;
    targetY := GRecycleStartY;
  end;
  oldX := Self.Left;
  oldY := Self.Top;
  x := oldX;
  y := oldY;
  incX := (targetX - oldX) div TIMES;
  incY := (targetY - oldY) div TIMES;
  Self.BringToFront;
  for i := 1 to TIMES - 1 do
  begin
    x := x + incX;
    y := y + incY;
    Self.Left := x;
    Self.Top := y;
    Self.Refresh;
    Sleep(10);
  end;
  Self.Left := targetX;
  Self.Top := targetY;
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
          Top := 2 * FPositiveNumber * GMainLenY + (FNumber - 1) * 2 * GMainLenY
            + GMainStartY - FNumber * GMainLenY - FPositiveNumber * GMainLenY
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
