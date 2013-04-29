object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #23450#26102#22120#25216#26415#23454#29616#26631#31614#23383#20307#39068#33394#21464#21270#25928#26524
  ClientHeight = 389
  ClientWidth = 646
  Color = clNavy
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 208
    Top = 152
    Width = 228
    Height = 56
    Caption = #20320#36194#20102#65281
    Color = clSilver
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -56
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Button1: TButton
    Left = 561
    Top = 8
    Width = 75
    Height = 25
    Caption = #24320#22987
    TabOrder = 0
    OnClick = Button1Click
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 20
    OnTimer = Timer1Timer
    Left = 600
    Top = 48
  end
end
