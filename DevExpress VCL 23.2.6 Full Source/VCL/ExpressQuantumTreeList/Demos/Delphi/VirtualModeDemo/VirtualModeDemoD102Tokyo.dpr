program VirtualModeDemoD102Tokyo;

uses
  Forms,
  VirtualModeDemoMain in 'VirtualModeDemoMain.pas' {fmVirtualModeDemoMain},
  DemoRating in '..\Common\DemoRating.pas' {DemoRatingForm},
  DemoBasicMain in '..\Common\DemoBasicMain.pas' {DemoBasicMainForm},
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo},
  SkinDemoUtils in '..\Common\SkinDemoUtils.pas',
  DemoUtils in '..\Common\DemoUtils.pas';

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressQuantumTreeList VirtualModeDemoD102Tokyo';
  Application.HelpFile := '..\..\Help\ExpressQuantumTreeList.hlp';
  Application.CreateForm(TfmVirtualModeDemoMain, fmVirtualModeDemoMain);
  Application.Run;
end.
