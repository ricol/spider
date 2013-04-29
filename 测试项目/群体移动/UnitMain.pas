unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, UnitCommon, UnitTMyPicture;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    procedure Process_WM_BEGINMOVE(var tmpMsg: TMessage); message WM_BEGINMOVE;
    procedure Process_WM_MOVING(var tmpMsg: TMessage); message WM_MOVING;
    procedure Process_WM_ENDMOVE(var tmpMsg: TMessage); message WM_ENDMOVE;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TMyPicture }

var
  GPicture: array[1..3] of TMyPicture;

procedure TForm1.Button1Click(Sender: TObject);
var
  i: Integer;
begin
  for i := 1 to 3 do
  begin
    GPicture[i] := TMyPicture.Create(Self);
    GPicture[i].Parent := Self;
    GPicture[i].Left := 0;
    GPicture[i].Top := (i - 1) * 100;
    GPicture[i].Width := 71;
    GPicture[i].Height := 96;
    GPicture[i].ParentHandle := Self.Handle;
    GPicture[i].CanMove := false;
    GPicture[i].Initiator := false;
    GPicture[i].Picture.Bitmap.LoadFromFile(IntToStr(i) + '.bmp');
    GPicture[i].Show;
  end;
  Button1.Enabled := false;
  Button2.Enabled := true;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i: Integer;
begin
  for i := 1 to 3 do
  begin
    GPicture[i].Free;
  end;
  Button1.Enabled := true;
  Button2.Enabled := false;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  i: Integer;
begin
  if Button2.Enabled then
  for i := 1 to 3 do
  begin
    GPicture[i].Left := 0;
    GPicture[i].Top := (i - 1) * 100;
  end;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  GMoveAsGroup := not GMoveAsGroup;
end;

procedure TForm1.Process_WM_BEGINMOVE(var tmpMsg: TMessage);
begin
  inherited;
end;

procedure TForm1.Process_WM_ENDMOVE(var tmpMsg: TMessage);
begin
  inherited;
end;

procedure TForm1.Process_WM_MOVING(var tmpMsg: TMessage);
var
  i: Integer;
begin
  for i := 1 to 3 do
  begin
    if GPicture[i].Initiator then continue;
    GPicture[i].Left := GPicture[i].Left + tmpMsg.WParam;
    GPicture[i].Top := GPicture[i].Top + tmpMsg.LParam;
  end;
  inherited;
end;

end.
