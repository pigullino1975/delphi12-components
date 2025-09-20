program FlowChartDemoD102Tokyo;

uses
  Forms,
  main in 'main.pas' {MainForm};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
