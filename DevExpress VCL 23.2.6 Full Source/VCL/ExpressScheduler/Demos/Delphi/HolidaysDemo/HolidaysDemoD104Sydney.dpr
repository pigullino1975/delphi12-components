program HolidaysDemoD104Sydney;

uses
  Forms,
  HolidaysDemoMain in 'HolidaysDemoMain.pas' {HolidaysDemoMainForm},
  DemoUtils in '..\Common\DemoUtils.pas',
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo},
  DemoBasicMain in '..\Common\DemoBasicMain.pas' {DemoBasicMainForm},
  SkinDemoUtils in '..\Common\SkinDemoUtils.pas';

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressScheduler UnboundDemo';
  Application.CreateForm(THolidaysDemoMainForm, HolidaysDemoMainForm);
  Application.Run;
end.
