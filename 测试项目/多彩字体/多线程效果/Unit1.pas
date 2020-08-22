unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    BtnStart: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnStartClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses ColorLabel;

{$R *.dfm}

var
  GColorLabel: TColorLabel;

procedure TForm1.BtnStartClick(Sender: TObject);
begin
  GColorLabel.Go := not GColorLabel.Go;
  if GColorLabel.Go then
    BtnStart.Caption := 'Í£Ö¹'
  else
    BtnStart.Caption := '¿ªÆô';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  GColorLabel := TColorLabel.Create(Self);
  GColorLabel.Parent := Self;
  GColorLabel.Caption := 'ÄãÓ®ÁË£¡';
  GColorLabel.Font.Size := 50;
  GColorLabel.Font.Name := 'ËÎÌå';
  GColorLabel.Font.Style := [fsBold];
  GColorLabel.Left := Self.ClientWidth div 2 - GColorLabel.Width div 2;
  GColorLabel.Top := Self.ClientHeight div 2 - GColorLabel.Height div 2;
  GColorLabel.Show;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  GColorLabel.Free;
end;

end.
