program AgendaViewDemoDXE7;

uses
  Forms,
  AgendaViewDemoMain in 'AgendaViewDemoMain.pas' {AgendaViewDemoMainForm},
  DemoUtils in '..\Common\DemoUtils.pas',
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo},
  DemoBasicMain in '..\Common\DemoBasicMain.pas' {DemoBasicMainForm},
  SkinDemoUtils in '..\Common\SkinDemoUtils.pas';

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressScheduler AgendaViewDemoDXE7';
  Application.CreateForm(TAgendaViewDemoMainForm, AgendaViewDemoMainForm);
  Application.Run;
end.
