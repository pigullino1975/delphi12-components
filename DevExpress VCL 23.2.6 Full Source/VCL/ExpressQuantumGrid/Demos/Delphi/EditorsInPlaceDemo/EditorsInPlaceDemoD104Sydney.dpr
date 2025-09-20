program EditorsInPlaceDemoD104Sydney;

uses
  Forms,
  CarsData in '..\Common\CarsData.pas' {dmCars},
  CarsDataForGrid in '..\Common\CarsDataForGrid.pas' {dmGridCars},
  EditorsInPlaceDemoMain in 'EditorsInPlaceDemoMain.pas' {EditorsInPlaceDemoMainForm},
  EditorsInPlaceDemoData in 'EditorsInPlaceDemoData.pas' {EditorsInPlaceDemoDataDM: TDataModule},
  EditorsInPlaceDemoCities in 'EditorsInPlaceDemoCities.pas' {EditorsInPlaceDemoCitiesForm},
  EditorsInPlaceDemoCars in 'EditorsInPlaceDemoCars.pas' {EditorsInPlaceDemoCarsForm},
  AboutDemoForm in '..\AboutDemoForm.pas' {formAboutDemo},
  DemoUtils in '..\DemoUtils.pas',
  SkinDemoUtils in '..\SkinDemoUtils.pas',
  BaseForm in '..\BaseForm.pas' {fmBaseForm};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressQuantumGrid EditorsInPlaceDemoD104Sydney';
  Application.CreateForm(TdmGridCars, dmGridCars);
  Application.CreateForm(TEditorsInPlaceDemoDataDM, EditorsInPlaceDemoDataDM);
  Application.CreateForm(TEditorsInPlaceDemoMainForm, EditorsInPlaceDemoMainForm);
  Application.CreateForm(TEditorsInPlaceDemoCitiesForm, EditorsInPlaceDemoCitiesForm);
  Application.CreateForm(TEditorsInPlaceDemoCarsForm, EditorsInPlaceDemoCarsForm);
  Application.Run;
end.
