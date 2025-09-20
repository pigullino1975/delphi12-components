program ViewChartStackedDemoDXE7;

uses
  Forms,
  BaseForm in '..\BaseForm.pas' {fmBaseForm},
  ViewChartStackedDemoMain in 'ViewChartStackedDemoMain.pas' {frmMain},
  SkinDemoUtils in '..\SkinDemoUtils.pas',
  AboutDemoForm in '..\AboutDemoForm.pas' {formAboutDemo};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressQuantumGrid ViewChart Stacked Diagrams Demo';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
