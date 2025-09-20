program RTTIInspectorDemoDXE7;

uses
  Forms,
  RTTIInspectorDemoMain in 'RTTIInspectorDemoMain.pas' {RTTIInspectorDemoMainForm},
  DemoBasicAbout in '..\Common\DemoBasicAbout.pas' {DemoBasicAboutForm},
  DemoBasicMain in '..\Common\DemoBasicMain.pas' {DemoBasicMainForm},
  DemoRating in '..\Common\DemoRating.pas' {DemoRatingForm},
  RTTIInspectorDemoVGEditor in 'RTTIInspectorDemoVGEditor.pas',
  RTTIInspectorDemoPropEditors in 'RTTIInspectorDemoPropEditors.pas',
  RTTIInspectorDemoData in 'RTTIInspectorDemoData.pas' {RTTIInspectorDemoMainDM: TDataModule},
  DemoUtils in '..\Common\DemoUtils.pas',
  CarsData in '..\Common\CarsData.pas' {dmCars: TdmCars};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressVerticalGrid RTTIInspector Demo';
  Application.CreateForm(TdmCars, dmCars);
  Application.CreateForm(TRTTIInspectorDemoMainDM, RTTIInspectorDemoMainDM);
  Application.CreateForm(TRTTIInspectorDemoMainForm, RTTIInspectorDemoMainForm);
  Application.Run;
end.
