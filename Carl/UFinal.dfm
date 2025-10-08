object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 433
  ClientWidth = 284
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesigned
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 37
    Top = 176
    Width = 154
    Height = 15
    Caption = 'Verlauf der gezogenen H'#246'lzer'
  end
  object LabelPoints: TLabel
    Left = 37
    Top = 56
    Width = 61
    Height = 15
    Caption = 'LabelPoints'
  end
  object LabelPinsLeft: TLabel
    Left = 37
    Top = 139
    Width = 70
    Height = 15
    Caption = 'LabelPinsLeft'
  end
  object Label2: TLabel
    Left = 37
    Top = 89
    Width = 91
    Height = 15
    Caption = 'Nimm 1-3 H'#246'lzer'
  end
  object Label3: TLabel
    Left = 80
    Top = 8
    Width = 102
    Height = 28
    Caption = 'Nimm Spiel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object Button1: TButton
    Left = 164
    Top = 109
    Width = 85
    Height = 25
    Caption = 'Nimm'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit2: TEdit
    Left = 37
    Top = 110
    Width = 121
    Height = 23
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 37
    Top = 192
    Width = 212
    Height = 209
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
  end
end
