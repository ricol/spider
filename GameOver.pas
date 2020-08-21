unit GameOver;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormGameOver = class(TForm)
    BtnYES: TButton;
    BtnNO: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure BtnYESClick(Sender: TObject);
    procedure BtnNOClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormGameOver: TFormGameOver;

implementation

uses Common;

{$R *.dfm}

procedure TFormGameOver.BtnNOClick(Sender: TObject);
begin
  close;
end;

procedure TFormGameOver.BtnYESClick(Sender: TObject);
begin
  GGameRestart := true;
  close;
end;

procedure TFormGameOver.FormActivate(Sender: TObject);
begin
  GGameRestart := false;
end;

end.
