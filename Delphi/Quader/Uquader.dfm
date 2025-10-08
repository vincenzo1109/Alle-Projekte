object Quaderberchnung: TQuaderberchnung
  Left = 0
  Top = 0
  Caption = 'Quaderberchnung'
  ClientHeight = 442
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object LabelSideA: TLabel
    Left = 56
    Top = 16
    Width = 42
    Height = 15
    Caption = 'Seite a='
  end
  object LabelSideB: TLabel
    Left = 56
    Top = 37
    Width = 43
    Height = 15
    Caption = 'Seite b='
  end
  object LabelSideC: TLabel
    Left = 56
    Top = 56
    Width = 42
    Height = 15
    Caption = 'Seite c='
  end
  object LabelVolume: TLabel
    Left = 192
    Top = 16
    Width = 55
    Height = 15
    Caption = 'Volumen='
  end
  object LabelSurface: TLabel
    Left = 192
    Top = 37
    Width = 66
    Height = 15
    Caption = 'Oberfl'#228'che='
  end
  object LabelSideCube: TLabel
    Left = 192
    Top = 58
    Width = 79
    Height = 15
    Caption = 'W'#252'rfel seite a='
  end
  object EditSideA: TEdit
    Left = 104
    Top = 16
    Width = 72
    Height = 15
    TabOrder = 0
  end
  object EditSideB: TEdit
    Left = 104
    Top = 39
    Width = 72
    Height = 13
    TabOrder = 1
  end
  object EditSideC: TEdit
    Left = 104
    Top = 58
    Width = 72
    Height = 13
    TabOrder = 2
  end
  object EditVolume: TEdit
    Left = 277
    Top = 16
    Width = 72
    Height = 15
    TabOrder = 3
  end
  object EditSurface: TEdit
    Left = 277
    Top = 37
    Width = 72
    Height = 15
    TabOrder = 4
  end
  object EditSideCube: TEdit
    Left = 277
    Top = 58
    Width = 72
    Height = 15
    TabOrder = 5
  end
  object ButtonCalculate: TButton
    Left = 56
    Top = 136
    Width = 132
    Height = 41
    Caption = 'Berechne'
    TabOrder = 6
    OnClick = ButtonCalculateClick
  end
  object ButtonEnd: TButton
    Left = 240
    Top = 136
    Width = 132
    Height = 41
    Caption = 'Ende'
    TabOrder = 7
    OnClick = ButtonEndClick
  end
end
