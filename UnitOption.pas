unit UnitOption;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormOption = class(TForm)
    BtOK: TButton;
    BtnCancel: TButton;
    CBAnimateEffect: TCheckBox;
    CBAutoSaveWhenExit: TCheckBox;
    CBAutoOpenLastGame: TCheckBox;
    CBShowMessageBeforeSave: TCheckBox;
    CBShowMessageOpenLastGame: TCheckBox;
    CBSoundEffect: TCheckBox;
    procedure BtOKClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormOption: TFormOption;

implementation

uses UnitCommon;

{$R *.dfm}

procedure TFormOption.BtnCancelClick(Sender: TObject);
begin
  CBAnimateEffect.Checked := GAnimateEffect;
  CBAutoSaveWhenExit.Checked := GAutoSaveWhenExit;
  CBAutoOpenLastGame.Checked := GAutoOpenLastGame;
  CBShowMessageBeforeSave.Checked := GShowMessageBeforeSave;
  CBShowMessageOpenLastGame.Checked := GShowMessageOpenLastGame;
  CBSoundEffect.Checked := GSoundEffect;
  Close;
end;

procedure TFormOption.BtOKClick(Sender: TObject);
begin
  GAnimateEffect := CBAnimateEffect.Checked;
  GAutoSaveWhenExit := CBAutoSaveWhenExit.Checked;
  GAutoOpenLastGame := CBAutoOpenLastGame.Checked;
  GShowMessageBeforeSave := CBShowMessageBeforeSave.Checked;
  GShowMessageOpenLastGame := CBShowMessageOpenLastGame.Checked;
  GSoundEffect := CBSoundEffect.Checked;
  Close;
end;

procedure TFormOption.FormActivate(Sender: TObject);
begin
  CBAnimateEffect.Checked := GAnimateEffect;
  CBAutoSaveWhenExit.Checked := GAutoSaveWhenExit;
  CBAutoOpenLastGame.Checked := GAutoOpenLastGame;
  CBShowMessageBeforeSave.Checked := GShowMessageBeforeSave;
  CBShowMessageOpenLastGame.Checked := GShowMessageOpenLastGame;
  CBSoundEffect.Checked := GSoundEffect;
end;

end.
