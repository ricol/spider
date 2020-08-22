program Project1;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  MyPicture in 'MyPicture.pas',
  Common in 'Common.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
