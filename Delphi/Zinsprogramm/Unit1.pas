unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Math;

type
  TZinsprogramm_Jährlich = class(TForm)
    EditCredit: TEdit;
    EditInterestRate: TEdit;
    Label1: TLabel;
    Button1: TButton;
    EditYears: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    MemoOutput: TMemo;
    procedure berechne(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Zinsprogramm_Jährlich: TZinsprogramm_Jährlich;

implementation

{$R *.dfm}


procedure TZinsprogramm_Jährlich.berechne(Sender: TObject);
begin
    var Credit : Real;
    var Years,I : integer;

    Years:= StrToInt(EditYears.Text);
    credit:= StrToFloat(EditCredit.Text);

    for I := 1 to Years do
      begin
          credit := credit * ( 1 + StrToFloat(EditInterestRate.Text) / 100);
          MemoOutput.Lines.Add('Guthaben nach ' + IntToStr(I) + ' Jahren: ' +  FloatToStr(RoundTo(credit, -2)) + '€');

      end;


end;

end.




