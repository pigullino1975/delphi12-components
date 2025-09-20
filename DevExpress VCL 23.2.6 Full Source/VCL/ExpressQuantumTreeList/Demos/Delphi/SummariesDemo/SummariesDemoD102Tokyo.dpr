program SummariesDemoD102Tokyo;

uses
  Forms,
  SummariesDemoMain in 'SummariesDemoMain.pas' {SummariesDemoMainForm},
  SummariesDemoData in 'SummariesDemoData.pas' {SummariesDemoDataDM: TDataModule},
  DemoRating in '..\Common\DemoRating.pas' {DemoRatingForm},
  DemoBasicMain in '..\Common\DemoBasicMain.pas' {DemoBasicMainForm},
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo},
  SkinDemoUtils in '..\Common\SkinDemoUtils.pas',
  DemoUtils in '..\Common\DemoUtils.pas';

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressQuantumTreeList SummariesDemoD102Tokyo';
  Application.HelpFile := '..\..\Help\ExpressQuantumTreeList.hlp';
  Application.CreateForm(TSummariesDemoDataDM, SummariesDemoDataDM);
  Application.CreateForm(TSummariesDemoMainForm, SummariesDemoMainForm);
  Application.Run;
end.
