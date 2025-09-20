program BaselinesDemoD102Tokyo;

uses
  Forms,
  BaselinesDemoMain in 'BaselinesDemoMain.pas' {BaselinesDemoMainForm},
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo},
  DemoBasicMain in '..\Common\DemoBasicMain.pas' {DemoBasicMainForm},
  SkinDemoUtils in '..\Common\SkinDemoUtils.pas';

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressGanttControl Baselines Demo';
  Application.CreateForm(TBaselinesDemoMainForm, BaselinesDemoMainForm);
  Application.Run;
end.
