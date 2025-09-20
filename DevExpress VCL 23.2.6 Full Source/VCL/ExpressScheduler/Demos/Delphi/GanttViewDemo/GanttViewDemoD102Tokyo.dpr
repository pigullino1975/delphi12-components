program GanttViewDemoD102Tokyo;

uses
  Forms,
  GanttViewDemoMain in 'GanttViewDemoMain.pas' {GanttViewDemoMainForm},
  DemoUtils in '..\Common\DemoUtils.pas',
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo},
  DemoBasicMain in '..\Common\DemoBasicMain.pas' {DemoBasicMainForm},
  SkinDemoUtils in '..\Common\SkinDemoUtils.pas';

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressScheduler GanttViewDemoD102Tokyo';
  Application.CreateForm(TGanttViewDemoMainForm, GanttViewDemoMainForm);
  Application.Run;
end.
