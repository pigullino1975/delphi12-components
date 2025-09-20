program GridModeDemoD102Tokyo;

uses
  Forms,
  GridModeDemoMain in 'GridModeDemoMain.pas' {GridModeDemoMainForm},
  GridModeDemoData in 'GridModeDemoData.pas' {GridModeDemoDataDM: TDataModule},
  GridModeDemoTerminate in 'GridModeDemoTerminate.pas' {GridModeDemoTerminateForm},
  BaseForm in '..\BaseForm.pas' {fmBaseForm},
  SkinDemoUtils in '..\SkinDemoUtils.pas',
  AboutDemoForm in '..\AboutDemoForm.pas' {formAboutDemo};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressQuantumGrid GridModeDemoD102Tokyo';
  Application.CreateForm(TGridModeDemoDataDM, GridModeDemoDataDM);
  Application.CreateForm(TGridModeDemoMainForm, GridModeDemoMainForm);
  Application.Run;
end.
