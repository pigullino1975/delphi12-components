program MapControlFeaturesDemo;

{$SETPEOSVERSION 5.0}
{$SETPESUBSYSVERSION 5.0}

uses
  Forms,
  dxDemoBaseMainForm in '..\Common\dxDemoBaseMainForm.pas' {frmMainBase},
  dxDemoObjectInspector in '..\Common\dxDemoObjectInspector.pas' {frmInspector},
  dxDemoPrintFrame in '..\Common\dxDemoPrintFrame.pas' {frmPrinting: TFrame},
  dxExportProgressDialog in '..\Common\dxExportProgressDialog.pas',
  Main in 'Main.pas' {frmMain},
  dxAboutDemo in '..\Common\dxAboutDemo.pas' {dxAboutDemoForm},
  dxMapControlBaseFormUnit in 'dxMapControlBaseFormUnit.pas' {dxMapControlDemoUnitForm},
  dxMapControlDataProvidersFormUnit in 'dxMapControlDataProvidersFormUnit.pas' {frmDataProviders},
  dxMapControlWorldWeatherFormUnit in 'dxMapControlWorldWeatherFormUnit.pas' {frmWorldWeather},
  dxSplashUnit in '..\Common\dxSplashUnit.pas' {frmSplash},
  WorldWeatherChangeVisibilityDialog in 'WorldWeatherChangeVisibilityDialog.pas' {WorldWeatherChangeVisibilityDialogForm},
  WorldWeatherDemoAddCityDialog in 'WorldWeatherDemoAddCityDialog.pas' {WorldWeatherDemoAddCityDialogForm},
  dxMapControlSalesDashboardFormUnit in 'dxMapControlSalesDashboardFormUnit.pas' {frmSalesDashboard},
  Sales in 'Sales.pas',
  OpenWeatherMapService in 'OpenWeatherMapService.pas',
  dxMapControlBingServicesFormUnit in 'dxMapControlBingServicesFormUnit.pas' {frmBingServices},
  dxMapControlShapefileSupportFormUnit in 'dxMapControlShapefileSupportFormUnit.pas' {frmShapefileSupport},
  dxMapControlDayAndNightFormUnit in 'dxMapControlDayAndNightFormUnit.pas' {fmDayAndNight},
  dxDemoUtils in '..\Common\dxDemoUtils.pas';

{$R *.res}
{$R ..\Common\dxDPIAwareManifestPM2.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TWorldWeatherChangeVisibilityDialogForm, WorldWeatherChangeVisibilityDialogForm);
  Application.CreateForm(TWorldWeatherDemoAddCityDialogForm, WorldWeatherDemoAddCityDialogForm);
  Application.Run;
end.
