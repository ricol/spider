program Spider_XE5;

uses
  Forms,
  fMain in 'fMain.pas' {FormMain},
  About in 'About.pas' {AboutBox},
  Difficulty in 'Difficulty.pas' {FormDifficulty},
  Score in 'Score.pas' {FormScore},
  Option in 'Option.pas' {FormOption},
  Common in 'Common.pas',
  PokerArray in 'PokerArray.pas',
  PanelPoker in 'PanelPoker.pas',
  PokerPile in 'PokerPile.pas',
  GameOver in 'GameOver.pas' {FormGameOver},
  ColorLabel in 'ColorLabel.pas';

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
