unit ColorLabel;

interface

uses
  Messages, Windows, SysUtils, Classes, StdCtrls, Dialogs, SyncObjs;

type
  TDirection = (INCREASE, DECREASE);
  TNum = (NUMRED, NUMGREEN, NUMBLUE);

  TMyThread = class(TThread)
  private
    FColorLabel: Pointer;
    FNum: TNum;
    FRed: integer;
    FGreen: integer;
    FBlue: integer;
    FR: TDirection;
    FG: TDirection;
    FB: TDirection;
    FSpeed: cardinal;
    FCriticalSection: TCriticalSection;
    procedure SetFColorLabel(const Value: Pointer);
    procedure SetNum(const Value: TNum);
    procedure SetRed(const Value: integer);
    procedure SetGreen(const Value: integer);
    procedure SetBlue(const Value: integer);
    procedure SetR(const Value: TDirection);
    procedure SetG(const Value: TDirection);
    procedure SetB(const Value: TDirection);
    procedure SetSpeed(const Value: cardinal);
    procedure SetColor();
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean); overload;
    destructor Destroy(); override;
    property ColorLabel: Pointer read FColorLabel write SetFColorLabel;
    property Num: TNum read FNum write SetNum;
    property Red: integer read FRed write SetRed;
    property Green: integer read FGreen write SetGreen;
    property Blue: integer read FBlue write SetBlue;
    property R: TDirection read FR write SetR;
    property G: TDirection read FG write SetG;
    property B: TDirection read FB write SetB;
    property Speed: cardinal read FSpeed write SetSpeed;
  end;

  TColorLabel = class(TLabel)
  private
    FGo: Boolean;
    FMyThread: TMyThread;
    procedure ProcessMessage_WM_MBUTTONDOWN(var msg: TWMMButtonDown); message WM_MBUTTONDOWN;
    procedure SetGo(const Value: Boolean);
  published
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy(); override;
    procedure AdjustPlace();
    property Go: Boolean read FGo write SetGo;
  end;

implementation

procedure TColorLabel.AdjustPlace;
var
  parentHandle: cardinal;
  winPlaceMent: WINDOWPLACEMENT;
  parentWidth, parentHeight: integer;
begin
  parentHandle := Self.Parent.Handle;
  GetWindowPlacement(parentHandle, winPlaceMent);
  parentWidth := winPlaceMent.rcNormalPosition.Right - winPlaceMent.rcNormalPosition.Left;
  parentHeight := winPlaceMent.rcNormalPosition.Bottom - winPlaceMent.rcNormalPosition.Top - 100;
  Self.Left := parentWidth div 2 - Self.Width div 2;
  Self.Top := parentHeight div 2 - Self.Height div 2;
end;

constructor TColorLabel.Create(AOwner: TComponent);
begin
  inherited;
  FGo := false;
  FMyThread := TMyThread.Create(true);
  with FMyThread do
  begin
    FColorLabel := Pointer(Self);
    Num := NUMGREEN;
    Red := 255;
    Green := 0;
    Blue := 0;
    R := DECREASE;
    G := INCREASE;
    B := INCREASE;
    Speed := 20;
  end;
end;

destructor TColorLabel.Destroy;
begin
  FMyThread.Terminate;
  // FMyThread.WaitFor;//remember it can return only if thread is executing!
  FMyThread.Free;
  inherited;
end;

procedure TColorLabel.ProcessMessage_WM_MBUTTONDOWN(var msg: TWMMButtonDown);
var
  s: string;
begin
  s := Self.Caption;
  if msg.msg = WM_MBUTTONDOWN then
  begin
    Beep;
    s := InputBox('����', '��������Ҫ��ʾ����Ϣ��', s);
    if s <> '' then
      Self.Caption := s;
    AdjustPlace;
  end;
  inherited;
end;

procedure TColorLabel.SetGo(const Value: Boolean);
begin
  if FGo <> Value then
  begin
    FGo := Value;
    if Value then
    begin
      FMyThread.Resume;
    end
    else
    begin
      FMyThread.Suspend;
    end;
  end;
end;

{ TMyThread }

constructor TMyThread.Create(CreateSuspended: Boolean);
begin
  inherited;
  FCriticalSection := TCriticalSection.Create;
end;

destructor TMyThread.Destroy;
begin
  FCriticalSection.Free;
  inherited;
end;

procedure TMyThread.Execute;
begin
  inherited;
  repeat
    if FNum = NUMRED then
    begin
      if FR = INCREASE then
      begin
        inc(FRed, 5);
        if FRed >= 255 then
        begin
          FR := DECREASE;
          FNum := NUMBLUE;
        end;
      end
      else
      begin
        dec(FRed, 5);
        if FRed <= 0 then
        begin
          FR := INCREASE;
          FNum := NUMBLUE;
        end;
      end;
    end
    else if FNum = NUMGREEN then
    begin
      if FG = INCREASE then
      begin
        inc(FGreen, 5);
        if FGreen >= 255 then
        begin
          FG := DECREASE;
          FNum := NUMRED;
        end;
      end
      else
      begin
        dec(FGreen, 5);
        if FGreen <= 0 then
        begin
          FG := INCREASE;
          FNum := NUMRED;
        end;
      end;
    end
    else
    begin
      if FB = INCREASE then
      begin
        inc(FBlue, 5);
        if FBlue >= 255 then
        begin
          FB := DECREASE;
          FNum := NUMGREEN;
        end;
      end
      else
      begin
        dec(FBlue, 5);
        if FBlue <= 0 then
        begin
          FB := INCREASE;
          FNum := NUMGREEN;
        end;
      end;
    end;
    // FCriticalSection.Enter;
    // TColorLabel(Self.FColorLabel).Font.Color := RGB(FRed, FGreen, FBlue);
    Synchronize(SetColor);
    // FCriticalSection.Leave;
    if Self.Terminated then
      break;
    Sleep(FSpeed);
  until false;
end;

procedure TMyThread.SetB(const Value: TDirection);
begin
  FB := Value;
end;

procedure TMyThread.SetBlue(const Value: integer);
begin
  FBlue := Value;
end;

procedure TMyThread.SetColor;
begin
  TColorLabel(Self.FColorLabel).Font.Color := RGB(FRed, FGreen, FBlue);
end;

procedure TMyThread.SetFColorLabel(const Value: Pointer);
begin
  FColorLabel := Value;
end;

procedure TMyThread.SetG(const Value: TDirection);
begin
  FG := Value;
end;

procedure TMyThread.SetGreen(const Value: integer);
begin
  FGreen := Value;
end;

procedure TMyThread.SetNum(const Value: TNum);
begin
  FNum := Value;
end;

procedure TMyThread.SetR(const Value: TDirection);
begin
  FR := Value;
end;

procedure TMyThread.SetRed(const Value: integer);
begin
  FRed := Value;
end;

procedure TMyThread.SetSpeed(const Value: cardinal);
begin
  FSpeed := Value;
end;

end.
