program SpellCheckerSimpleDemoD104Sydney;

uses
  Forms,
  SimpleDemoMain in 'SimpleDemoMain.pas' {fmCV},
  DemoUtils in '..\Common\DemoUtils.pas';

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmCV, fmCV);
  Application.Run;
end.
