program DBDemoDXE7;

uses
  Forms,
  DBDemoMainUnit in 'DBDemoMainUnit.pas' {DBDemoMainForm},
  DemoUtils in '..\Common\DemoUtils.pas',
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo},
  DemoBasicMain in '..\Common\DemoBasicMain.pas' {DemoBasicMainForm},
  SkinDemoUtils in '..\Common\SkinDemoUtils.pas';

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressScheduler DBDemoDXE7';
  Application.CreateForm(TDBDemoMainForm, DBDemoMainForm);
  Application.Run;
end.
