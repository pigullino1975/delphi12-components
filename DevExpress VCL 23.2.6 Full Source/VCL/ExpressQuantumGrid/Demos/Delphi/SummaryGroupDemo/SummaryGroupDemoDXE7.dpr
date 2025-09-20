program SummaryGroupDemoDXE7;

uses
  Forms,
  SummaryGroupDemoMain in 'SummaryGroupDemoMain.pas' {SummaryGroupDemoMainForm},
  SummaryGroupDemoData in 'SummaryGroupDemoData.pas' {SummaryGroupDemoDataDM: TDataModule},
  AboutDemoForm in '..\AboutDemoForm.pas' {formAboutDemo},
  BaseForm in '..\BaseForm.pas' {fmBaseForm},
  SkinDemoUtils in '..\SkinDemoUtils.pas',
  DemoUtils in '..\DemoUtils.pas';

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressQuantumGrid SummaryGroupDemoDXE7';
  Application.CreateForm(TSummaryGroupDemoDataDM, SummaryGroupDemoDataDM);
  Application.CreateForm(TSummaryGroupDemoMainForm, SummaryGroupDemoMainForm);
  Application.Run;
end.
