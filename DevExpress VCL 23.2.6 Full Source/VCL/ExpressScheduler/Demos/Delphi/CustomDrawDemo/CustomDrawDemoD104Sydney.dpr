program CustomDrawDemoD104Sydney;

uses
  Forms,
  CustomDrawDemoMain in 'CustomDrawDemoMain.pas' {CustomDrawDemoMainForm},
  DemoBasicMain in '..\Common\DemoBasicMain.pas' {DemoBasicMainForm},
  DemoUtils in '..\Common\DemoUtils.pas',
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo},
  SkinDemoUtils in '..\Common\SkinDemoUtils.pas';


  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressScheduler CustomDrawDemoD104Sydney';
  Application.CreateForm(TCustomDrawDemoMainForm, CustomDrawDemoMainForm);
  Application.Run;
end.
