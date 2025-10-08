object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object LabelInp: TLabel
    Left = 8
    Top = 112
    Width = 62
    Height = 15
    Caption = 'Guess Input'
  end
  object LabelWordOut: TLabel
    Left = 128
    Top = 24
    Width = 433
    Height = 37
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object EditInp: TEdit
    Left = 8
    Top = 133
    Width = 62
    Height = 23
    TabOrder = 0
  end
  object ButtonTry: TButton
    Left = 8
    Top = 162
    Width = 62
    Height = 25
    Caption = 'Try'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = ButtonTryClick
  end
end
