unit UFinal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit2: TEdit;
    Label1: TLabel;
    LabelPoints: TLabel;
    Label2: TLabel;
    LabelPinsLeft: TLabel;
    Memo1: TMemo;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure WerHatGewonnen();
    procedure Reset();
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;
  PinRest, player, Player1Points, Player2Points, Arrayindex, b: integer;
  ArrayPinsToken: Array [0 .. 20] of integer;

implementation

{$R *.dfm}


// Start Aussehen
procedure TForm1.FormCreate(Sender: TObject);
begin
  Memo1.clear;
  PinRest := 21;
  player := 0; // Zählvariable
  LabelPinsLeft.Caption := IntToStr(21);
  Arrayindex := 0;
  Player1Points := 0;
  Player2Points := 0;
  LabelPoints.Caption := 'Punktestand: ' + IntToStr(Player1Points) + ' : ' + IntToStr(Player2Points);
end;


procedure TForm1.Button1Click(Sender: TObject);
var
  PinToken: integer;
begin
  PinToken := StrToInt(Edit2.Text);

  ArrayPinsToken[Arrayindex] := PinToken;
  Arrayindex := Arrayindex + 1;

  if (PinToken < 1) OR (PinToken > 3) then
    ShowMessage('Die Zahl muss zwischen 1 und 3 sein')
  else if PinToken > PinRest then
    ShowMessage('Sind nicht mehr genug Streichhölzer da')
  else
  begin
    player := player + 1;
    PinRest := PinRest - PinToken;

    b := b + 1; // Zählvar. für Array
    if PinRest = 0 then
      WerHatGewonnen(); // Procedure-Beginn (weiter unten)

    LabelPoints.Caption := 'Punktestand: ' + IntToStr(Player1Points) + ' : ' + IntToStr(Player2Points);
    // aktuelle Punktestand
    LabelPinsLeft.Caption := IntToStr(PinRest);
  end;
end;


procedure TForm1.WerHatGewonnen();
begin

  for Arrayindex := 0 to b-1 do // For-Schleife (i wird immer um 1 erhöht)
    Memo1.lines.add(IntToStr(ArrayPinsToken[Arrayindex]));

  if player Mod 2 = 0 then
  begin
    ShowMessage('Spieler 1 hat gewonnen');
    Player1Points := Player1Points + 1;
  end
  else
  begin
    ShowMessage('Spieler 2 hat gewonnen');
    Player2Points := Player2Points + 1;
  end;
  Reset();
end;


procedure TForm1.Reset();                                                    cschull
begin
  PinRest := 21;
  player := 0;
  Memo1.clear;
  Arrayindex := 0;
  b := 0;
end;

end.
