unit Score;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TFormScore = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    BtnOk: TButton;
    BtnReset: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    GroupBox10: TGroupBox;
    Label22: TLabel;
    GroupBox11: TGroupBox;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    GroupBox12: TGroupBox;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    GroupBox4: TGroupBox;
    Label8: TLabel;
    GroupBox5: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    GroupBox6: TGroupBox;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    procedure BtnOkClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormScore: TFormScore;

implementation

{$R *.dfm}

procedure TFormScore.BtnOkClick(Sender: TObject);
begin
  Close;
end;

procedure TFormScore.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

end.
