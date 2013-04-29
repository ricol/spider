unit UnitMain;

{
CONTACT: WANGXINGHE1983@GMAIL.COM
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, StdCtrls, MMSystem,
  UnitCommon, UnitTPokePile, UnitTPokeArray, UnitTPanelPoke;

type
  TFormMain = class(TForm)
    ImageBackGround: TImage;
    MainMenu1: TMainMenu;
    MenuGame: TMenuItem;
    MenuGameStart: TMenuItem;
    MenuGameRestart: TMenuItem;
    N6: TMenuItem;
    MenuGameUndo: TMenuItem;
    MenuGameContinue: TMenuItem;
    MenuGameHelp: TMenuItem;
    N10: TMenuItem;
    MenuGameDifficulty: TMenuItem;
    MenuGameStatus: TMenuItem;
    MenuGameOption: TMenuItem;
    N14: TMenuItem;
    MenuGameOpen: TMenuItem;
    MenuGameSave: TMenuItem;
    N17: TMenuItem;
    MenuGameExit: TMenuItem;
    MenuContinue: TMenuItem;
    MenuHelp: TMenuItem;
    MenuHelpContent: TMenuItem;
    N20: TMenuItem;
    MenuHelpAbout: TMenuItem;
    MenuGameClose: TMenuItem;
    N1: TMenuItem;
    MenuAutoMove: TMenuItem;
    MenuAutoMoveInOrder: TMenuItem;
    MenuAutoMoveInRandom: TMenuItem;
    MenuAutoMoveStart: TMenuItem;
    N2: TMenuItem;
    procedure MenuHelpAboutClick(Sender: TObject);
    procedure MenuGameExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuGameDifficultyClick(Sender: TObject);
    procedure MenuGameStatusClick(Sender: TObject);
    procedure MenuGameOptionClick(Sender: TObject);
    procedure MenuGameStartClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure MenuContinueClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure MenuGameRestartClick(Sender: TObject);
    procedure MenuGameCloseClick(Sender: TObject);
    procedure MenuGameContinueClick(Sender: TObject);
    procedure MenuGameHelpClick(Sender: TObject);
    procedure MenuAutoMoveStartClick(Sender: TObject);
    procedure MenuAutoMoveInOrderClick(Sender: TObject);
    procedure MenuAutoMoveInRandomClick(Sender: TObject);
  private
    procedure ImageClick(Sender: TObject);
    procedure FreeObject();
    procedure FindHintPoke();
    procedure BeginSuccessDemo();
    procedure EndSuccessDemo();
    procedure Process_WM_BEGINMOVE(var tmpMsg: TMessage); message WM_BEGINMOVE;
    procedure Process_WM_MOVING(var tmpMsg: TMessage); message WM_MOVING;
    procedure Process_WM_ENDMOVE(var tmpMsg: TMessage); message WM_ENDMOVE;
    procedure Process_WM_SENDCARDS(var tmpMsg: TMessage); message WM_SENDCARDS;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

uses UnitAbout, UnitDifficulty, UnitScore, UnitOption, UnitGameOver, UnitTColorLabel;

{$R *.dfm}

var
  GPokePile: array[1..MAXMAIN] of TPokePile;
  GPokePileTemp: array[1..MAXTEMP] of TPokePile;
  GPokePileRecycle: array[1..MAXRECYCLE] of TPokePile;
  GPokeHint: array[1..MAXHINT] of THint;
  GGameRunning: boolean;
  GCanMoveAsGroup, GPokeMoving, GAutoMove, GAutoMoveInOrder: boolean;
  GCanMoveAsGroupPileNumber, GCanMoveAsGroupNumber, GHintNumber, GHintNow, GRecycleNumber: integer;
  GPanel: TPanel = nil;
  GImage: TImage = nil ;
  GLabelOperation: TLabel = nil;
  GLabelScore: TLabel = nil;
  GColorLabel: TColorLabel = nil;
  GImageRunning: boolean = false;
  GObjectFree: boolean = true;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  GGameRunning := false;
  GPokeMoving := false;
  GAutoMove := false;
  GAutoMoveInOrder := false;
  GDifficulty := EASY;
  GSoundEffect := true;
  GAnimateEffect := true;
  GShowMessageBeforeSave := true;
  GShowMessageOpenLastGame := true;
  GAutoOpenLastGame := false;
  GAutoSaveWhenExit := false;
  Self.Width := 822;
  Self.Height := 625;
  GMainStartX := MAINSTARTX;
  GMainStartY := MAINSTARTY;
  GTempLenX := TEMPLENX;
  GTempLenY := TEMPLENY;
  GRecycleLenX := RECYCLELENX;
  GRecycleLenY := RECYCLELENY;
  GRecycleStartX := RECYCLESTARTX;
  GRecycleStartY := Self.Height - 175;
  GMainLenX := Self.ClientWidth div 10;
  GMainLenY := 10;
  GTempStartX := Self.ClientWidth - 142;
  GTempStartY := Self.Height - 175;
  if GPanel <> nil then
  begin
    GPanel.Left := Self.ClientWidth div 2 - GPanel.Width div 2;
    GPanel.Top := Self.ClientHeight - GPanel.Height - 20;
  end;
  GCanMoveAsGroup := false;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  try
    if GColorLabel <> nil then
    begin
      GColorLabel.Go := false;
      GColorLabel.Free;
      GColorLabel := nil;
    end;
  except

  end;
  FreeObject;
end;

procedure TFormMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F2 then
    MenuGameStartClick(Sender)
  else if Key = VK_F12 then
    MenuAutoMoveStartClick(Sender)
  else if Key = VK_ESCAPE then
    MenuGameCloseClick(Sender);
end;

procedure TFormMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if UpperCase(Key) = 'M' then
    ImageClick(Sender)
  else if UpperCase(Key) = 'D' then
    MenuContinueClick(Sender);
end;

procedure TFormMain.FormResize(Sender: TObject);
var
  i: integer;
begin
  if GPanel <> nil then
  begin
    GPanel.Left := Self.ClientWidth div 2 - GPanel.Width div 2;
    GPanel.Top := Self.ClientHeight - GPanel.Height - 20;
  end;
  GMainLenX := Self.ClientWidth div 10;
  GMainLenY := 10;
  GTempStartX := Self.ClientWidth - 142;
  GTempStartY := Self.Height - 175;
  GTempLenX := TEMPLENX;
  GRecycleLenX := RECYCLELENX;
  GRecycleLenY := RECYCLELENY;
  GRecycleStartX := RECYCLESTARTX;
  GRecycleStartY := Self.Height - 175;
  if GColorLabel <> nil then
  begin
    GColorLabel.Left := Self.ClientWidth div 2 - GColorLabel.Width div 2;
    GColorLabel.Top := Self.ClientHeight div 2 - GColorLabel.Height div 2;
  end;
  if not GGameRunning then
    exit;
  for i := 1 to MAXMAIN do
    GPokePile[i].Show;
  for i := MAXTEMP downto 1 do
    GPokePileTemp[i].Show;
  for i := 1 to GRecycleNumber do
    GPokePileRecycle[i].Show;
end;

procedure TFormMain.FreeObject;
var
  i: integer;
begin
  if GObjectFree then exit;
  for i := 1 to MAXMAIN do
    try
      GPokePile[i].Free;
      GPokePile[i] := nil;
    except

    end;
  for i := 1 to MAXTEMP do
    try
      GPokePileTemp[i].Free;
      GPokePileTemp[i] := nil;
    except

    end;
  for i := 1 to MAXRECYCLE do
    try
      GPokePileRecycle[i].Free;
      GPokePileRecycle[i] := nil;
    except

    end;
  try
    GLabelOperation.Free;
    GLabelOperation := nil;
  except

  end;
  try
    GLabelScore.Free;
    GLabelScore := nil;
  except

  end;
  try
    GImage.Free;
    GImage := nil;
  except

  end;
  try
    GPanel.Free;
    GPanel := nil;
  except

  end;
  GGameRunning := false;
  GRecycleNumber := 0;
  GObjectFree := true;
end;

procedure TFormMain.EndSuccessDemo;
begin
  try
    if GColorLabel <> nil then
    begin
      GColorLabel.Free;
      GColorLabel := nil;
    end;
  except

  end;
end;

procedure TFormMain.FindHintPoke;
var
  tmpCard, tmpTargetCard, tmpOne, tmpTwo: TPanelPoke;
  i, j, k, tmpIndex: integer;
begin
  if not GGameRunning then exit;
  GHintNumber := 0;
  GHintNow := 0;
  for i := 1 to MAXMAIN do
  begin
    tmpIndex := GPokePile[i].FIndex;
    tmpOne := GPokePile[i].GetPoke(tmpIndex);
    if tmpOne = nil then continue;
    for j := tmpIndex - 1 downto 1 do
    begin
      tmpTwo := GPokePile[i].GetPoke(j);
      if tmpTwo = nil then break;
      if tmpTwo.PositiveFlag then
      begin
        if (tmpOne.Y = tmpTwo.Y) and (tmpOne.X = tmpTwo.X - 1) then
        begin
          tmpOne := tmpTwo;
          continue;
        end
        else break;
      end else break;
    end;
    inc(j);
    tmpCard := GPokePile[i].GetPoke(j);
    if tmpCard = nil then continue;
    for k := 1 to MAXMAIN do
    begin
      if i = k then continue;
      tmpTargetCard := GPokePile[k].GetPoke(GPokePile[k].FIndex);
      if tmpTargetCard = nil then continue;
      if tmpCard.Match(tmpTargetCard) then
      begin
        inc(GHintNumber);
        GPokeHint[GHintNumber].SourcePileNumber := i;
        GPokeHint[GHintNumber].SourceNumber := j;
        GPokeHint[GHintNumber].SourceMaxIndexNumber := tmpIndex;
        GPokeHint[GHintNumber].TargetPileNumber := k;
      end;
    end;
  end;
end;

procedure TFormMain.ImageClick(Sender: TObject);
var
  i, SourceIndex, SourceMaxIndexNumber, SourceNumber, TargetIndex, tmpNum: integer;
  tmpPoke: TPanelPoke;
  tmpOldPoint: TPoint;
begin
  if GImageRunning then exit;
  GImageRunning := true;
  if not GGameRunning then
  begin
    GImageRunning := false;
    exit;
  end;
  if GPokeMoving then
  begin
    GImageRunning := false;
    exit;
  end;
  if GHintNumber <> 0 then
    SoundEffect('SOUND3')
  else
  begin
    SoundEffect('SOUND4');
    GImageRunning := false;
    exit;
  end;
  inc(GHintNow);
  if GHintNow > GHintNumber then GHintNow := 1;
  SourceIndex := GPokeHint[GHintNow].SourcePileNumber;
  SourceNumber := GPokeHint[GHintNow].SourceNumber;
  SourceMaxIndexNumber := GPokeHint[GHintNow].SourceMaxIndexNumber;
  for i := SourceNumber to SourceMaxIndexNumber do
  begin
    tmpPoke := GPokePile[SourceIndex].GetPoke(i);
    tmpPoke.Dark(true);
  end;
  Sleep(200);
  for i := SourceNumber to SourceMaxIndexNumber do
  begin
    tmpPoke := GPokePile[SourceIndex].GetPoke(i);
    tmpPoke.Dark(false);
  end;
  TargetIndex := GPokeHint[GHintNow].TargetPileNumber;
  tmpPoke := GPokePile[TargetIndex].GetPoke(GPokePile[TargetIndex].FIndex);
  if tmpPoke <> nil then
  begin
    tmpPoke.Dark(true);
    Application.ProcessMessages;
    Sleep(200);
    Application.ProcessMessages;
    tmpPoke.Dark(false);
  end;
  if GAutoMove then
  begin
    if not GAutoMoveInOrder then
    begin
      tmpNum := Random(GHintNumber) + 1;
      SourceIndex := GPokeHint[tmpNum].SourcePileNumber;
      SourceNumber := GPokeHint[tmpNum].SourceNumber;
      TargetIndex := GPokeHint[tmpNum].TargetPileNumber;
    end;
    tmpPoke := GPokePile[SourceIndex].GetPoke(SourceNumber);
    GetCursorPos(tmpOldPoint);
    SetCursorPos(Self.Left + tmpPoke.Left + GMainStartX, Self.Top + tmpPoke.Top + GMainStartY + (Self.Height - Self.ClientHeight));
    mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
    tmpPoke := GPokePile[TargetIndex].GetPoke(GPokePile[TargetIndex].FIndex);
    if tmpPoke <> nil then
    begin
      SetCursorPos(Self.Left + tmpPoke.Left + GMainStartX, Self.Top + tmpPoke.Top + GMainStartY + (Self.Height - Self.ClientHeight));
    end;
    mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
    SetCursorPos(tmpOldPoint.X, tmpOldPoint.Y);
  end;
  GImageRunning := false;
end;

procedure TFormMain.MenuAutoMoveInOrderClick(Sender: TObject);
begin
  MenuAutoMoveInOrder.Checked := not MenuAutoMoveInOrder.Checked;
  MenuAutoMoveInRandom.Checked := not MenuAutoMoveInRandom.Checked;
  GAutoMoveInOrder := not GAutoMoveInOrder;
end;

procedure TFormMain.MenuAutoMoveInRandomClick(Sender: TObject);
begin
  MenuAutoMoveInOrder.Checked := not MenuAutoMoveInOrder.Checked;
  MenuAutoMoveInRandom.Checked := not MenuAutoMoveInRandom.Checked;
  GAutoMoveInOrder := not GAutoMoveInOrder;
end;

procedure TFormMain.MenuAutoMoveStartClick(Sender: TObject);
begin
  MenuAutoMoveStart.Checked := not MenuAutoMoveStart.Checked;
  GAutoMove := not GAutoMove;
  if GAutoMove then
    Self.Caption := STRCAPTION + ' - 自动'
  else
    Self.Caption := STRCAPTION;
  MenuAutoMoveInOrder.Enabled := GAutoMove;
  MenuAutoMoveInOrder.Checked := false;
  MenuAutoMoveInRandom.Checked := true;
  MenuAutoMoveInRandom.Enabled := GAutoMove;
  GAutoMoveInOrder := false;
end;

procedure TFormMain.MenuContinueClick(Sender: TObject);
var
  tmpPoke, tmpTargetPoke: TPanelPoke;
  i, j: integer;
begin
  if not GGameRunning then exit;
  if GPokeMoving then exit;
  for i := 1 to MAXTEMP do
  begin
    if GPokePileTemp[i].FIndex = 0 then continue;
    for j := 1 to 10 do
    begin
      GPokeMoving := true;
      SoundEffect('SOUND1');
      tmpPoke := GPokePileTemp[i].GetPoke(GPokePileTemp[i].FIndex);
      if tmpPoke <> nil then
        GPokePileTemp[i].RemovePoke(tmpPoke);
      tmpPoke.Reverse(true);
      Application.ProcessMessages;
      tmpTargetPoke := GPokePile[j].GetPoke(GPokePile[j].FIndex);
      if tmpTargetPoke <> nil then
        tmpPoke.MoveTo(j, GPokePile[j].FIndex + 1, tmpTargetPoke.PositiveNumber + 1, MAIN)
      else
        tmpPoke.MoveTo(j, 1, 1, MAIN);
      GPokePile[j].AddPoke(tmpPoke);
      GPokePile[j].CaculatePositiveNumber;
      GPokePile[j].Show;
    end;
    FindHintPoke;
    break;
  end;
  GPokeMoving := false;
end;

procedure TFormMain.MenuGameCloseClick(Sender: TObject);
begin
  if GGameRunning then
    if MessageBox(Self.Handle, '游戏正在进行，是否继续关闭？', '蜘蛛', MB_YESNO or MB_ICONINFORMATION or MB_DEFBUTTON2) = ID_YES then
      FreeObject;
end;

procedure TFormMain.MenuGameContinueClick(Sender: TObject);
begin
  MenuContinueClick(Sender);
end;

procedure TFormMain.MenuGameDifficultyClick(Sender: TObject);
begin
  if GGameRunning then
  begin
    if MessageBox(Self.Handle, '关闭该游戏之前是否保存？', '蜘蛛', MB_YESNOCANCEL or MB_ICONQUESTION) = ID_YES then
      MessageBox(Self.Handle, '保存游戏功能暂时没有实现！', '蜘蛛', MB_OK);
  end;
  FormDifficulty.Left := Self.Left + (Self.Width div 2) - FormDifficulty.Width div 2;
  FormDifficulty.Top := Self.Top + (Self.Height div 2) - FormDifficulty.Height div 2;
  FormDifficulty.ShowModal;
  if GNewDifficulty then
    MenuGameStartClick(Sender);
end;

procedure TFormMain.MenuGameExitClick(Sender: TObject);
begin
  FreeObject;
  Close;
end;

procedure TFormMain.MenuGameHelpClick(Sender: TObject);
begin
  ImageClick(Sender);
end;

procedure TFormMain.MenuGameOptionClick(Sender: TObject);
begin
  FormOption.Left := Self.Left + (Self.Width div 2) - FormOption.Width div 2;
  FormOption.Top := Self.Top + (Self.Height div 2) - FormOption.Height div 2;
  FormOption.ShowModal;
end;

procedure TFormMain.MenuGameRestartClick(Sender: TObject);
begin
  if not GGameRunning then MenuGameStartClick(Sender)
  else begin
    if MessageBox(Self.Handle, '是否从头开始这次游戏？', '蜘蛛', MB_YESNO or MB_ICONINFORMATION or MB_DEFBUTTON2) = ID_YES then
      MenuGameStartClick(Sender);
  end;
end;

procedure TFormMain.MenuGameStartClick(Sender: TObject);
var
  i, j: Integer;
  tmpPoke: TPanelPoke;
  tmpPokeArray: TPokeArray;
  tmpPokeNum: TPokeNum;
begin
  if GPokeMoving then exit;
  FreeObject;
  EndSuccessDemo;
  GPanel := TPanel.Create(Self);
  GPanel.Hide;
  GPanel.Parent := Self;
  GPanel.Color := clBlack;
  GPanel.ParentBackground := false;
  GPanel.Width := 217;
  GPanel.Height := 113;
  GPanel.Left := Self.ClientWidth div 2 - GPanel.Width div 2;
  GPanel.Top := Self.ClientHeight - GPanel.Height - 20;
  GPanel.BevelOuter := bvNone;
  GPanel.BorderWidth := 1;
  GPanel.Show;
  GPanel.SendToBack;
  GImage := TImage.Create(Self);
  GImage.Hide;
  GImage.Parent := GPanel;
  GImage.Align := alClient;
  GImage.Picture.Bitmap.LoadFromResourceName(hInstance, 'BMPINFORBACKGROUND');
  GImage.OnClick := ImageClick;
  GImage.Show;
  GLabelOperation := TLabel.Create(Self);
  GLabelOperation.Parent := GPanel;
  GLabelOperation.Left := 75;
  GLabelOperation.Top := 31;
  GLabelOperation.Width := 56;
  GLabelOperation.Height := 16;
  GLabelOperation.Caption := '分数：500';
  GLabelOperation.Font.Color := clWhite;
  GLabelOperation.Font.Size := 10;
  GLabelOperation.Transparent := true;
  GLabelOperation.OnClick := ImageClick;
  GLabelOperation.Show;
  GLabelScore := TLabel.Create(Self);
  GLabelScore.Parent := GPanel;
  GLabelScore.Left := 75;
  GLabelScore.Top := 65;
  GLabelScore.Width := 56;
  GLabelScore.Height := 16;
  GLabelScore.Caption := '操作：0';
  GLabelScore.Font.Color := clWhite;
  GLabelScore.Font.Size := 10;
  GLabelScore.Transparent := true;
  GLabelScore.OnClick := ImageClick;
  GLabelScore.Show;
  tmpPokeArray := TPokeArray.Create(GDifficulty);
  for i := 1 to 4 do
  begin
    GPokePile[i] := TPokePile.Create;
    GPokePile[i].FType := MAIN;
    GPokePile[i].Handle := FormMain.Handle;
    GPokePile[i].PileNumber := i;
    for j := 1 to 5 do
    begin
      tmpPokeNum := tmpPokeArray.GetPoke;
      tmpPoke := TPanelPoke.Create(Self);
      tmpPoke.Init(tmpPokeNum.x, tmpPokeNum.y, Self.Handle, i, j, false, false, MAIN, 0, Self);
      GPokePile[i].AddPoke(tmpPoke);
    end;
    GPokePile[i].CaculatePositiveNumber;
    GPokePile[i].Show;
  end;
  for i := 5 to MAXMAIN do
  begin
    GPokePile[i] := TPokePile.Create;
    GPokePile[i].FType := MAIN;
    GPokePile[i].Handle := FormMain.Handle;
    GPokePile[i].PileNumber := i;
    for j := 1 to 4 do
    begin
      tmpPokeNum := tmpPokeArray.GetPoke;
      tmpPoke := TPanelPoke.Create(Self);
      tmpPoke.Init(tmpPokeNum.x, tmpPokeNum.y, Self.Handle, i, j, false, false, MAIN, 0, Self);
      GPokePile[i].AddPoke(tmpPoke);
    end;
    GPokePile[i].CaculatePositiveNumber;
    GPokePile[i].Show;
  end;
  for i := MAXTEMP downto 1 do
  begin
    GPokePileTemp[i] := TPokePile.Create;
    GPokePileTemp[i].FType := TEMP;
    GPokePileTemp[i].Handle := FormMain.Handle;
    GPokePileTemp[i].PileNumber := i;
    for j := 1 to 10 do
    begin
      tmpPokeNum := tmpPokeArray.GetPoke;
      tmpPoke := TPanelPoke.Create(Self);
      tmpPoke.Init(tmpPokeNum.x, tmpPokeNum.y, Self.Handle, i, j, false, false, TEMP, 0, Self);
      GPokePileTemp[i].AddPoke(tmpPoke);
    end;
    GPokePileTemp[i].Show;
  end;
  GGameRunning := true;
  tmpPokeArray.Free;
  GRecycleNumber := 0;
  GObjectFree := false;
  MenuContinueClick(Sender);
end;

procedure TFormMain.MenuGameStatusClick(Sender: TObject);
begin
  FormScore.Left := Self.Left + (Self.Width div 2) - FormScore.Width div 2;
  FormScore.Top := Self.Top + (Self.Height div 2) - FormScore.Height div 2;
  FormScore.ShowModal;
end;

procedure TFormMain.MenuHelpAboutClick(Sender: TObject);
begin
  AboutBox.Left := Self.Left + (Self.Width div 2) - AboutBox.Width div 2;
  AboutBox.Top := Self.Top + (Self.Height div 2) - AboutBox.Height div 2;
  AboutBox.ShowModal;
end;

procedure TFormMain.Process_WM_SENDCARDS(var tmpMsg: TMessage);
begin
  MenuContinueClick(nil);
end;

procedure TFormMain.BeginSuccessDemo;
begin
  GColorLabel := TColorLabel.Create(Self);
  GColorLabel.Parent := Self;
  GColorLabel.Caption := '你赢了!';
  GColorLabel.Font.Size := 50;
  GColorLabel.Font.Style := [fsBold];
  GColorLabel.Font.Name := '宋体';
  if GColorLabel <> nil then
  begin
    GColorLabel.Left := Self.ClientWidth div 2 - GColorLabel.Width div 2;
    GColorLabel.Top := Self.ClientHeight div 2 - GColorLabel.Height div 2;
  end;
  GColorLabel.Show;
  GColorLabel.Go := true;
end;

procedure TFormMain.Process_WM_BEGINMOVE(var tmpMsg: TMessage);
var
  tmpPileNumber, tmpNumber, tmpMax, i, tmpNum: integer;
  tmpPoke, tmpPokeUP, tmpPokeDown: TPanelPoke;
  j: Integer;
begin
  tmpPileNumber := tmpMsg.WParam;
  tmpNumber := tmpMsg.LParam;
  tmpMax := GPokePile[tmpPileNumber].FIndex;
  GCanMoveAsGroup := true;
  GCanMoveAsGroupPileNumber := tmpPileNumber;
  GCanMoveAsGroupNumber := tmpNumber;
  for i := tmpNumber to tmpMax do
  begin
    tmpPokeUP := GPokePile[tmpPileNumber].GetPoke(i);
    if tmpPokeUp <> nil then
    begin
      tmpPokeUp.CanMoveAsGroup := true;
      tmpPokeDown := GPokePile[tmpPileNumber].GetPoke(i + 1);
      if tmpPokeDown <> nil then
      begin
        tmpPokeDown.CanMoveAsGroup := CanMove(tmpPokeUP.X, tmpPokeUP.Y, tmpPokeDown.X, tmpPokeDown.Y);
        if not tmpPokeDown.CanMoveAsGroup then break;
      end else break;
    end else break;
  end;
  tmpNum := tmpMax - tmpNumber + 1;
  for i := tmpNumber to tmpMax do
  begin
    tmpPoke := GPokePile[tmpPileNumber].GetPoke(i);
    if tmpPoke <> nil then
    begin
      if not tmpPoke.CanMoveAsGroup then
      begin
        GCanMoveAsGroup := false;
        for j := tmpNumber to tmpMax do
        begin
          tmpPoke := GPokePile[tmpPileNumber].GetPoke(j);
          tmpPoke.CanMoveAsGroup := false;
        end;
        break;
      end;
    end;
  end;
  for i := 1 to tmpNum do
  begin
    GPokePile[tmpPileNumber].GetPoke(tmpNumber + i - 1).BringToFront;
  end;
  if GCanMoveAsGroup then
  begin
    tmpPoke := GPokePile[tmpPileNumber].GetPoke(tmpNumber);
    tmpPoke.CanDrag := true;
  end;
end;

procedure TFormMain.Process_WM_ENDMOVE(var tmpMsg: TMessage);
var
  tmpLastPoke, tmpMovingFirstPoke, tmpPoke, tmpNextPoke: TPanelPoke;
  tmpCenterX, tmpCenterY, tmpPileNumber, tmpNumber, i, j, k, tmpTargetPileNumber, tmpMax: integer;
  tmpFound, tmpIsEmpty, tmpCanDelete, tmpGameOver: boolean;
  tmpPokeArray: array of TPanelPoke;
  tmpIndex, tmpTarget: integer;
begin
  //First, Get the center point of Moving Poke
  tmpPileNumber := tmpMsg.WParam;
  tmpNumber := tmpMsg.LParam;
  tmpMovingFirstPoke := GPokePile[tmpPileNumber].GetPoke(tmpNumber);
  tmpCenterX := tmpMovingFirstPoke.Left + tmpMovingFirstPoke.Width div 2;
  tmpCenterY := tmpMovingFirstPoke.Top + tmpMovingFirstPoke.Height div 2;
  tmpFound := false;
  tmpLastPoke := nil;
  tmpIsEmpty := false;
  tmpTargetPileNumber := 0;
  for i := 1 to MAXMAIN do
  begin
    if i = tmpMsg.WParam then continue;
    if not GPokePile[i].IsEmpty then
    begin
      tmpLastPoke := GPokePile[i].GetPoke(GPokePile[i].FIndex);
      if (tmpCenterX >= tmpLastPoke.Left) and (tmpCenterX <= tmpLastPoke.Left + tmpLastPoke.Width) and
         (tmpCenterY >= tmpLastPoke.Top) and (tmpCenterY <= tmpLastPoke.Top + tmpLastPoke.Height) then
      begin
        tmpFound := true;
        tmpIsEmpty := false;
        break;
      end;
    end else begin
      if (tmpCenterX >= (GPokePile[i].PileNumber - 1) * GMainLenX + GMainStartX) and
         (tmpCenterX <= (GPokePile[i].PileNumber - 1) * GMainLenX + GMainStartX + POKEWIDTH) and
         (tmpCenterY >= GMainStartY) and
         (tmpCenterY <= GMainStartY + POKEHEIGHT) then
      begin
        tmpFound := true;
        tmpTargetPileNumber := GPokePile[i].PileNumber;
        tmpIsEmpty := true;
        break;
      end;
    end;
  end;
  //Second, Whether the moving poke matches the target poke
  if tmpFound then
  begin
    if not tmpIsEmpty then
    begin
      tmpTargetPileNumber := tmpLastPoke.PileNumber;
      if tmpMovingFirstPoke.Match(tmpLastPoke) then
      begin
        j := 0;
        tmpMax := GPokePile[tmpPileNumber].FIndex;
        SetLength(tmpPokeArray, tmpMax - tmpNumber + 1);
        for i := Low(tmpPokeArray) to High(tmpPokeArray) do
        begin
          tmpPokeArray[i] := GPokePile[tmpPileNumber].GetPoke(tmpNumber + j);
          GPokePile[tmpTargetPileNumber].AddPoke(tmpPokeArray[i]);
          inc(j);
        end;
        for i := High(tmpPokeArray) downto Low(tmpPokeArray) do
          GPokePile[tmpPileNumber].RemovePoke(tmpPokeArray[i]);
        SetLength(tmpPokeArray, 0);
        GPokePile[tmpPileNumber].CaculatePositiveNumber;
        GPokePile[tmpTargetPileNumber].CaculatePositiveNumber;
        GPokePile[tmpPileNumber].Show;
        GPokePile[tmpTargetPileNumber].Show;
      end else
        GPokePile[tmpPileNumber].Show;
    end else begin
      j := 0;
      tmpMax := GPokePile[tmpPileNumber].FIndex;
      SetLength(tmpPokeArray, tmpMax - tmpNumber + 1);
      for i := Low(tmpPokeArray) to High(tmpPokeArray) do
      begin
        tmpPokeArray[i] := GPokePile[tmpPileNumber].GetPoke(tmpNumber + j);
        GPokePile[tmpTargetPileNumber].AddPoke(tmpPokeArray[i]);
        inc(j);
      end;
      for i := High(tmpPokeArray) downto Low(tmpPokeArray) do
        GPokePile[tmpPileNumber].RemovePoke(tmpPokeArray[i]);
      SetLength(tmpPokeArray, 0);
      GPokePile[tmpPileNumber].CaculatePositiveNumber;
      GPokePile[tmpTargetPileNumber].CaculatePositiveNumber;
      GPokePile[tmpPileNumber].Show;
      GPokePile[tmpTargetPileNumber].Show;
    end;
    //check whether there are some cards which can be discarded.
    for i := 1 to MAXMAIN do
    begin
      tmpTarget := i;
      tmpCanDelete := true;
      if not GPokePile[i].IsEmpty then
      begin
        tmpIndex := GPokePile[i].FIndex;
        tmpPoke := GPokePile[i].GetPoke(tmpIndex);
        if tmpPoke.X = 1 then
        begin
          for j := 1 to 12 do
          begin
            tmpNextPoke := GPokePile[i].GetPoke(tmpIndex - j);
            if tmpNextPoke = nil then
            begin
              tmpCanDelete := false;
              break;
            end else begin
              if tmpNextPoke.Y <> tmpPoke.Y then
              begin
                tmpCanDelete := false;
                break;
              end else begin
                if tmpNextPoke.X <> (tmpPoke.X + 1) then
                begin
                  tmpCanDelete := false;
                  break;
                end;
              end;
              tmpPoke := tmpNextPoke;
            end;
          end;
        end else
          tmpCanDelete := false;
      end else
      begin
        tmpCanDelete := false;
      end;
      if tmpCanDelete then
      begin
        SetLength(tmpPokeArray, 13);
        inc(GRecycleNumber);
        GPokeMoving := true;
        GPokePileRecycle[GRecycleNumber] := TPokePile.Create;
        GPokePileRecycle[GRecycleNumber].PileNumber := GRecycleNumber;
        GPokePileRecycle[GRecycleNumber].Handle := Self.Handle;
        GPokePileRecycle[GRecycleNumber].FType := RECYCLE;
        k := GPokePile[tmpTarget].FIndex;
        for j := Low(tmpPokeArray) to High(tmpPokeArray) do
        begin
          tmpPokeArray[i] := GPokePile[tmpTarget].GetPoke(k);
          GPokePile[tmpTarget].RemovePoke(tmpPokeArray[i]);
          SoundEffect('SOUND1');
          tmpPokeArray[i].MoveTo(GRecycleNumber, 0, 0, RECYCLE);
          Application.ProcessMessages;
          GPokePileRecycle[GRecycleNumber].AddPoke(tmpPokeArray[i]);
          dec(k);
        end;
        GPokePileRecycle[GRecycleNumber].Show;
        SetLength(tmpPokeArray, 0);
        GPokePile[tmpTarget].CaculatePositiveNumber;
        GPokePile[tmpTarget].Show;
        //Check the game whether it is over
        tmpGameOver := true;
        GPokeMoving := false;
        for k := 1 to MAXMAIN do
        begin
          if GPokePile[k].FIndex <> 0 then
          begin
            tmpGameOver := false;
            break;
          end;
        end;
        if tmpGameOver then
        begin
          SoundEffect('SOUND6');
          FreeObject;
          BeginSuccessDemo();
          FormGameOver.Left := Self.Left + Self.Width - FormGameOver.Width - 20;
          FormGameOver.Top := Self.Top + Self.Height - FormGameOver.Height - 20;
          FormGameOver.ShowModal;
          if GGameRestart then
            MenuGameStartClick(nil);
          exit;
        end;
      end;
    end;
    FindHintPoke;
  end else
    GPokePile[tmpPileNumber].Show;
end;

procedure TFormMain.Process_WM_MOVING(var tmpMsg: TMessage);
var
  tmpPoke: TPanelPoke;
  i, tmpMax: integer;
begin
  if not GCanMoveAsGroup then exit;
  tmpMax := GPokePile[GCanMoveAsGroupPileNumber].FIndex;
  for i := GCanMoveAsGroupNumber to tmpMax do
  begin
    tmpPoke := GPokePile[GCanMoveAsGroupPileNumber].GetPoke(i);
    if tmpPoke.Initiator then continue;
    if tmpPoke.CanMoveAsGroup then
    begin
      tmpPoke.Left := tmpPoke.Left + tmpMsg.WParam;
      tmpPoke.Top := tmpPoke.Top + tmpMsg.LParam;
    end;
  end;
end;

end.
