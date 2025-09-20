program FixedDataRowsDemoD104Sydney;

uses
  Forms,
  CarsData in '..\Common\CarsData.pas' {dmCars},
  CarsDataForGrid in '..\Common\CarsDataForGrid.pas' {dmGridCars},
  FixedDataRowsMain in 'FixedDataRowsMain.pas' {frmMain},
  BaseForm in '..\BaseForm.pas' {fmBaseForm},
  SkinDemoUtils in '..\SkinDemoUtils.pas',
  AboutDemoForm in '..\AboutDemoForm.pas' {formAboutDemo};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressQuantumGrid Fixed Data Rows Demo';
  Application.CreateForm(TdmGridCars, dmGridCars);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
