program ViewChartDemoDXE7;

uses
  Forms,
  ViewChartDemoMain in 'ViewChartDemoMain.pas' {frmMain},
  BaseForm in '..\BaseForm.pas' {fmBaseForm},
  SkinDemoUtils in '..\SkinDemoUtils.pas',
  AboutDemoForm in '..\AboutDemoForm.pas' {formAboutDemo};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressQuantumGrid ViewChart Demo';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
