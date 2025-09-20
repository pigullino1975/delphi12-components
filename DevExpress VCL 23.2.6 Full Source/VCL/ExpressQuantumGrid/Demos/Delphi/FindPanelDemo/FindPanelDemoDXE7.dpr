program FindPanelDemoDXE7;

uses
  Forms,
  CarsData in '..\Common\CarsData.pas' {dmCars},
  CarsDataForGrid in '..\Common\CarsDataForGrid.pas' {dmGridCars},
  FindPanelDemoMain in 'FindPanelDemoMain.pas' {frmMain},
  BaseForm in '..\BaseForm.pas' {fmBaseForm},
  SkinDemoUtils in '..\SkinDemoUtils.pas',
  AboutDemoForm in '..\AboutDemoForm.pas' {formAboutDemo};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressQuantumGrid FindPanel Demo';
  Application.CreateForm(TdmGridCars, dmGridCars);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
