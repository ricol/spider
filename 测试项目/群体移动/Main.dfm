object Form1: TForm1
  Left = 0
  Top = 0
  Caption = #28436#31034#22914#20309#25972#20307#31227#21160#19981#21516#30340#31383#21475
  ClientHeight = 459
  ClientWidth = 646
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 567
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Create'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 567
    Top = 39
    Width = 75
    Height = 25
    Caption = 'Destroy'
    Enabled = False
    TabOrder = 1
    OnClick = Button2Click
  end
  object CheckBox1: TCheckBox
    Left = 567
    Top = 110
    Width = 75
    Height = 17
    Caption = #25972#20307#31227#21160
    TabOrder = 2
    OnClick = CheckBox1Click
  end
  object Button3: TButton
    Left = 567
    Top = 70
    Width = 75
    Height = 25
    Caption = 'ReSet'
    TabOrder = 3
    OnClick = Button3Click
  end
end
