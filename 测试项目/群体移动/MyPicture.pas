unit MyPicture;

interface

uses
  Messages, Windows, ExtCtrls, Common;

type
  TMyPicture = class(TImage)
  private
    FOldX, FOldY: integer;
    FCanMove: boolean;
    FParentHandle: Cardinal;
    FInitiator: boolean;
    procedure SetCanMove(const Value: boolean);
    procedure SetParentHandle(const Value: Cardinal);
    procedure SetInitiator(const Value: boolean);
  public
    procedure Process_WM_LBUTTONDOWN(var msg: TWMLButtonDOWN); message WM_LBUTTONDOWN;
    procedure Process_WM_MOUSEMOVE(var msg: TWMMouseMove); message WM_MOUSEMOVE;
    procedure Process_WM_LBUTTONUP(var msg: TWMLButtonUP); message WM_LBUTTONUP;
    property CanMove: boolean read FCanMove write SetCanMove;
    property ParentHandle: Cardinal read FParentHandle write SetParentHandle;
    property Initiator: boolean read FInitiator write SetInitiator;
  end;

implementation

procedure TMyPicture.Process_WM_LBUTTONDOWN(var msg: TWMLButtonDOWN);
begin
  FCanMove := true;
  FOldX := (msg.XPos);  // horizontal position of cursor
  FOldY := (msg.YPos);  // vertical position of cursor
  if not GMoveAsGroup then
    Self.BringToFront;
  Self.Initiator := true;
  inherited;
  if GMoveAsGroup then
    SendMessage(FParentHandle, WM_BEGINMOVE, FOldX, FOldY);
end;

procedure TMyPicture.Process_WM_LBUTTONUP(var msg: TWMLButtonUP);
begin
  FCanMove := false;
  Self.Initiator := false;
  inherited;
  if GMoveAsGroup then
    SendMessage(FParentHandle, WM_ENDMOVE, 0, 0);
end;

procedure TMyPicture.Process_WM_MOUSEMOVE(var msg: TWMMouseMove);
begin
  if not FCanMove then exit;
  Self.Left := Self.Left + ((msg.XPos) - FOldX);
  Self.Top := Self.Top + ((msg.YPos) - FOldY);
  inherited;
  if GMoveAsGroup then
    SendMessage(FParentHandle, WM_MOVING, (msg.XPos) - FOldX, (msg.YPos) - FOldY);
end;

procedure TMyPicture.SetCanMove(const Value: boolean);
begin
  FCanMove := Value;
end;

procedure TMyPicture.SetInitiator(const Value: boolean);
begin
  FInitiator := Value;
end;

procedure TMyPicture.SetParentHandle(const Value: Cardinal);
begin
  FParentHandle := Value;
end;


end.
