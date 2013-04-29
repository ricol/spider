unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Timer1: TTimer;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

type
  TMy = (INCREASE, DECREASE);
  TNum = (RED, GREEN, BLUE);

var
  GRed, GGreen, GBlue: integer;
  num: TNum;
  GR, GG, GB: TMy;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Timer1.Enabled := not Timer1.Enabled;
  if Timer1.Enabled then
    Button1.Caption := 'Í£Ö¹'
  else
    Button1.Caption := '¿ªÊ¼';
  GRed := 255;
  GR := DECREASE;
  GGreen := 0;
  GG := INCREASE;
  GBlue := 0;
  GB := INCREASE;
  num := GREEN;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if num = RED then
  begin
    if GR = INCREASE then
    begin
      inc(GRed, 5);
      if GRed >= 255 then
      begin
        GR := DECREASE;
        num := BLUE;
        OutputDebugString(PChar('GR <= DECREASE; num <= BLUE'));
      end;
    end else begin
      dec(GRed, 5);
      if GRed <= 0 then
      begin
        GR := INCREASE;
        num := BLUE;
        OutputDebugString(PChar('GR <= INCREASE; num <= BLUE'));
      end;
    end;
  end else if num = GREEN then
  begin
    if GG = INCREASE then
    begin
      inc(GGreen, 5);
      if GGreen >= 255 then
      begin
        GG := DECREASE;
        num := RED;
        OutputDebugString(PChar('GR <= DECREASE; num <= RED'));
      end;
    end else begin
      dec(GGreen, 5);
      if GGreen <= 0 then
      begin
        GG := INCREASE;
        num := RED;
        OutputDebugString(PChar('GR <= INCREASE; num <= RED'));
      end;
    end;
  end else begin
    if GB = INCREASE then
    begin
      inc(GBlue, 5);
      if GBlue >= 255 then
      begin
        GB := DECREASE;
        num := GREEN;
        OutputDebugString(PChar('GR <= DECREASE; num <= GREEN'));
      end;
    end else begin
      dec(GBlue, 5);
      if GBlue <= 0 then
      begin
        GB := INCREASE;
        num := GREEN;
        OutputDebugString(PChar('GR <= INCREASE; num <= GREEN'));
      end;
    end;
  end;
  Label1.Font.Color := RGB(GRed, GGreen, GBlue);
end;

end.
