program ProviderModeDemoD104Sydney;

uses
  Forms,
  ProviderModeDemoMain in 'ProviderModeDemoMain.pas' {ProviderModeDemoMainForm},
  DemoRating in '..\Common\DemoRating.pas' {DemoRatingForm},
  DemoBasicMain in '..\Common\DemoBasicMain.pas' {DemoBasicMainForm},
  ProviderModeDemoClasses in 'ProviderModeDemoClasses.pas',
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo},
  SkinDemoUtils in '..\Common\SkinDemoUtils.pas',
  DemoUtils in '..\Common\DemoUtils.pas';

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressQuantumTreeList ProviderModeDemoD104Sydney ';
  Application.HelpFile := '..\..\Help\ExpressQuantumTreeList.hlp';
  Application.CreateForm(TProviderModeDemoMainForm, ProviderModeDemoMainForm);
  Application.Run;
end.
