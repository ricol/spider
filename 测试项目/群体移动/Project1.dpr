program Project1;

uses
  Forms,
  UnitMain in 'UnitMain.pas' {Form1},
  UnitTMyPicture in 'UnitTMyPicture.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
