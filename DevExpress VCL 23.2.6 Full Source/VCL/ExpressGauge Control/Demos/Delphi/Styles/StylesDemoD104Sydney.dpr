program StylesDemoD104Sydney;

uses
  Forms,
  uMain in 'uMain.pas' {frmGaugeStyles};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmGaugeStyles, frmGaugeStyles);
  Application.Run;
end.
