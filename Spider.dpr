program Spider;

uses
  Forms,
  UnitMain in 'UnitMain.pas' {FormMain},
  UnitAbout in 'UnitAbout.pas' {AboutBox},
  UnitDifficulty in 'UnitDifficulty.pas' {FormDifficulty},
  UnitScore in 'UnitScore.pas' {FormScore},
  UnitOption in 'UnitOption.pas' {FormOption},
  UnitCommon in 'UnitCommon.pas',
  UnitTPokeArray in 'UnitTPokeArray.pas',
  UnitTPanelPoke in 'UnitTPanelPoke.pas',
  UnitTPokePile in 'UnitTPokePile.pas',
  UnitGameOver in 'UnitGameOver.pas' {FormGameOver},
  UnitTColorLabel in 'UnitTColorLabel.pas';

{$R *.res}
{$R MyResource.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := '÷©÷Î÷Ω≈∆';
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TFormDifficulty, FormDifficulty);
  Application.CreateForm(TFormScore, FormScore);
  Application.CreateForm(TFormOption, FormOption);
  Application.CreateForm(TFormGameOver, FormGameOver);
  Application.Run;
end.
