program FilterControlDemoD104Sydney;

uses
  Forms,
  FilterControlDemoMain in 'FilterControlDemoMain.pas' {frmMain},
  DemoBasicMain in '..\Common\DemoBasicMain.pas' {DemoBasicMainForm},
  SkinDemoUtils in '..\Common\SkinDemoUtils.pas',
  DemoUtils in '..\Common\DemoUtils.pas',
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo},
  DemoRating in '..\Common\DemoRating.pas' {DemoRatingForm};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressQuantumTreeList FindPanel Demo';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
