unit UnitDifficulty;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TFormDifficulty = class(TForm)
    Label1: TLabel;
    BtnOk: TButton;
    BtnCancel: TButton;
    RBSingleColor: TRadioButton;
    RBDoubleColor: TRadioButton;
    RBDoubleDoubleColor: TRadioButton;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormDifficulty: TFormDifficulty;

implementation

uses UnitCommon;

{$R *.dfm}

var
  GDiff: TDifficulty;

procedure TFormDifficulty.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFormDifficulty.BtnOkClick(Sender: TObject);
begin
  if RBSingleColor.Checked then
    GDiff := EASY
  else if RBDoubleColor.Checked then
    GDiff := MEDIUM
  else if RBDoubleDoubleColor.Checked then
    GDiff := HARD;
  if GDiff <> GDifficulty then
  begin
    GDifficulty := GDiff;
    GNewDifficulty := true;
  end;
  Close;
end;

procedure TFormDifficulty.FormActivate(Sender: TObject);
begin
  if GDifficulty = EASY then
  begin
    RBSingleColor.Checked := true;
    RBDoubleColor.Checked := false;
    RBDoubleDoubleColor.Checked := false;
  end else if GDifficulty = MEDIUM then
  begin
    RBSingleColor.Checked := false;
    RBDoubleColor.Checked := true;
    RBDoubleDoubleColor.Checked := false;
  end else if GDifficulty = HARD then
  begin
    RBSingleColor.Checked := false;
    RBDoubleColor.Checked := false;
    RBDoubleDoubleColor.Checked := true;
  end;
  GDiff := GDifficulty;
  GNewDifficulty := false;
end;

end.
