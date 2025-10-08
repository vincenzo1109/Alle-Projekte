program Spritvebrauch_Rechner;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Spritverbauch_Programm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSpritverbauch_Programm, Spritverbauch_Programm);
  Application.Run;
end.
