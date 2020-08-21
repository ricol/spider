object FormOption: TFormOption
  Left = 459
  Top = 307
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = #34584#34523#36873#39033
  ClientHeight = 210
  ClientWidth = 299
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
  object BtOK: TButton
    Left = 56
    Top = 175
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 0
    OnClick = BtOKClick
  end
  object BtnCancel: TButton
    Left = 168
    Top = 175
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 1
    OnClick = BtnCancelClick
  end
  object CBAnimateEffect: TCheckBox
    Left = 16
    Top = 16
    Width = 227
    Height = 17
    Caption = #21457#29260#26102#36827#34892#21160#30011#22788#29702'(&A)'
    Checked = True
    State = cbChecked
    TabOrder = 2
  end
  object CBAutoSaveWhenExit: TCheckBox
    Left = 16
    Top = 41
    Width = 227
    Height = 17
    Caption = #36864#20986#26102#33258#21160#20445#23384#28216#25103'(&S)'
    TabOrder = 3
  end
  object CBAutoOpenLastGame: TCheckBox
    Left = 16
    Top = 67
    Width = 227
    Height = 17
    Caption = #21551#21160#26102#33258#21160#25171#24320#19978#27425#28216#25103'(&O)'
    TabOrder = 4
  end
  object CBShowMessageBeforeSave: TCheckBox
    Left = 16
    Top = 92
    Width = 227
    Height = 17
    Caption = #20445#23384#28216#25103#21069#25552#31034'(&P)'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object CBShowMessageOpenLastGame: TCheckBox
    Left = 16
    Top = 118
    Width = 227
    Height = 17
    Caption = #25171#24320#24050#20445#23384#30340#28216#25103#21069#25552#31034'(&B)'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object CBSoundEffect: TCheckBox
    Left = 16
    Top = 144
    Width = 227
    Height = 17
    Caption = #20351#29992#22768#38899#25928#26524'(&E)'
    Checked = True
    State = cbChecked
    TabOrder = 7
  end
end
