object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Primzahlsieb'
  ClientHeight = 458
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 24
    Width = 217
    Height = 15
    Caption = 'Obergrenze der zu '#252'berpr'#252'fenden Zahlen'
  end
  object Edit1: TEdit
    Left = 231
    Top = 21
    Width = 362
    Height = 23
    TabOrder = 0
  end
  object Button1: TButton
    Left = 8
    Top = 56
    Width = 585
    Height = 25
    Caption = 'Primzahlen rausfinden'
    TabOrder = 1
    OnClick = Button1Click
  end
  object ListBoxTrue: TListBox
    Left = 8
    Top = 113
    Width = 289
    Height = 337
    ItemHeight = 15
    TabOrder = 2
  end
  object ListBoxFalse: TListBox
    Left = 303
    Top = 113
    Width = 290
    Height = 337
    ItemHeight = 15
    TabOrder = 3
  end
  object Button2: TButton
    Left = 8
    Top = 87
    Width = 585
    Height = 25
    Caption = 'Text zur'#252'cksetzen'
    TabOrder = 4
    OnClick = Button2Click
  end
end
