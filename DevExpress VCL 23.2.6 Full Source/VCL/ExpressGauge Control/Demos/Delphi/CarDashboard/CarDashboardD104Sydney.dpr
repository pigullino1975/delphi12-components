program CarDashboardD104Sydney;

uses
  Forms,
  uCarDashboard in 'uCarDashboard.pas' {frmCarDashboard};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmCarDashboard, frmCarDashboard);
  Application.Run;
end.
