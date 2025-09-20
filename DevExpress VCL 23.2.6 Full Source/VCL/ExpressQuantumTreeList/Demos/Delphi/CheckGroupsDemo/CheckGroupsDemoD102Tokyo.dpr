program CheckGroupsDemoD102Tokyo;

uses
  Forms,
  CheckGroupsDemoMain in 'CheckGroupsDemoMain.pas' {fmGheckGroupsDemo},
  DemoRating in '..\Common\DemoRating.pas' {DemoRatingForm},
  DemoBasicMain in '..\Common\DemoBasicMain.pas' {DemoBasicMainForm},
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo},
  SkinDemoUtils in '..\Common\SkinDemoUtils.pas',
  DemoUtils in '..\Common\DemoUtils.pas';

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressQuantumTreeList CheckGroupsDemoD102Tokyo ';
  Application.HelpFile := '..\..\Help\ExpressQuantumTreeList.hlp';
  Application.CreateForm(TfmGheckGroupsDemo, fmGheckGroupsDemo);
  Application.Run;
end.
