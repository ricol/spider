object FormGameOver: TFormGameOver
  Left = 304
  Top = 266
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsDialog
  Caption = #28216#25103#32467#26463
  ClientHeight = 104
  ClientWidth = 249
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 32
    Top = 16
    Width = 108
    Height = 12
    Caption = #24685#21916#24685#21916#65292#20320#36194#20102#65281
  end
  object Label2: TLabel
    Left = 32
    Top = 40
    Width = 96
    Height = 12
    Caption = #26159#21542#24320#22987#26032#28216#25103#65311
  end
  object BtnYES: TButton
    Left = 32
    Top = 71
    Width = 75
    Height = 25
    Caption = #26159'(&Y)'
    TabOrder = 0
    OnClick = BtnYESClick
  end
  object BtnNO: TButton
    Left = 144
    Top = 71
    Width = 75
    Height = 25
    Caption = #21542'(&N)'
    TabOrder = 1
    OnClick = BtnNOClick
  end
end
