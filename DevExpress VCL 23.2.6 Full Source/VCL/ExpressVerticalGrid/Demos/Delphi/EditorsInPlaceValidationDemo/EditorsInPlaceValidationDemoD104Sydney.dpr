program EditorsInPlaceValidationDemoD104Sydney;

uses
  Forms,
  EditorsInPlaceValidationDemoMain in 'EditorsInPlaceValidationDemoMain.pas' {EditorsInPlaceValidationDemoMainForm},
  EditorsInPlaceValidationDemoData in 'EditorsInPlaceValidationDemoData.pas' {EditorsInPlaceValidationDemoDataDM: TDataModule},
  DemoRating in '..\Common\DemoRating.pas' {DemoRatingForm},
  DemoBasicAbout in '..\Common\DemoBasicAbout.pas' {DemoBasicAboutForm},
  DemoBasicMain in '..\Common\DemoBasicMain.pas' {DemoBasicMainForm},
  DemoUtils in '..\Common\DemoUtils.pas';

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressVerticalGrid EditorsInPlaceValidation Demo';
  Application.CreateForm(TEditorsInPlaceValidationDemoDataDM, EditorsInPlaceValidationDemoDataDM);
  Application.CreateForm(TEditorsInPlaceValidationDemoMainForm, EditorsInPlaceValidationDemoMainForm);
  Application.Run;
end.
