program ResourceDemoD102Tokyo;

uses
  Forms,
  ResourceMainUnit in 'ResourceMainUnit.pas' {ResourceDemoMainForm},
  RentUnit in 'RentUnit.pas' {frmRentCar},
  CancelReservationUnit in 'CancelReservationUnit.pas' {frmCancelReservation},
  DemoUtils in '..\Common\DemoUtils.pas',
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo},
  DemoBasicMain in '..\Common\DemoBasicMain.pas' {DemoBasicMainForm},
  SkinDemoUtils in '..\Common\SkinDemoUtils.pas';

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Exotic sport cars';
  Application.CreateForm(TResourceDemoMainForm, ResourceDemoMainForm);
  Application.Run;
end.
