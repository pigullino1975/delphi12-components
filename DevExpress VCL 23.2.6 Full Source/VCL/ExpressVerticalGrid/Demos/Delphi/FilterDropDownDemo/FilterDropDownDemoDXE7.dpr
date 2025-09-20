program FilterDropDownDemoDXE7;

uses
  Forms,
  FilterDropDownDemoMain in 'FilterDropDownDemoMain.pas' {frmMain},
  DemoRating in '..\Common\DemoRating.pas' {DemoRatingForm},
  DemoBasicAbout in '..\Common\DemoBasicAbout.pas' {DemoBasicAboutForm},
  DemoBasicMain in '..\Common\DemoBasicMain.pas' {DemoBasicMainForm},
  DemoUtils in '..\Common\DemoUtils.pas';

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressQuantumGrid Filter Dropdown Demo';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
