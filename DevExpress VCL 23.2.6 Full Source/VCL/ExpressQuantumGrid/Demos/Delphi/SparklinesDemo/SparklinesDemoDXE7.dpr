program SparklinesDemoDXE7;

uses
  Forms,
  SparklinesDemoMain in 'SparklinesDemoMain.pas' {fmSparklines},
  AboutDemoForm in '..\AboutDemoForm.pas' {formAboutDemo},
  BaseForm in '..\BaseForm.pas' {fmBaseForm},
  SkinDemoUtils in '..\SkinDemoUtils.pas',
  DemoUtils in '..\DemoUtils.pas';

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressQuantumGrid Sparklines Demo';
  Application.CreateForm(TfmSparklines, fmSparklines);
  Application.Run;
end.
