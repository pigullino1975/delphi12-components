program PhotoViewer;

{$SETPEOSVERSION 5.0}
{$SETPESUBSYSVERSION 5.0}

uses
  Vcl.Forms,
  IOUtils,
  Main in 'Main.pas' {frmMain},
  dxAboutDemo in '..\Common\dxAboutDemo.pas' {dxAboutDemoForm},
  uDataModule in 'uDataModule.pas' {DataModule1: TDataModule},
  uEntityEditor in 'Dialogs\uEntityEditor.pas' {BaseEditor},
  uAlbumEditor in 'Dialogs\uAlbumEditor.pas' {AlbumEditor},
  PhotoViewerClasses in 'PhotoViewerClasses.pas',
  uPhotoEditor in 'Dialogs\uPhotoEditor.pas' {PhotoEditor},
  uFilterEditor in 'Dialogs\uFilterEditor.pas' {FilterEditor},
  uPhotoViewerForm in 'Forms\uPhotoViewerForm.pas' {PhotoViewerForm},
  uPhotos in 'Forms\uPhotos.pas' {Photos},
  uAlbumPhotos in 'Forms\uAlbumPhotos.pas' {AlbumPhotos},
  uFilters in 'Forms\uFilters.pas' {Filters},
  uPhotoBaseForm in 'Forms\uPhotoBaseForm.pas' {PhotoBaseForm},
  uEditor in 'Forms\uEditor.pas' {Editor},
  dxSplashUnit in 'Dialogs\dxSplashUnit.pas' {frmSplash},
  uSlideShow in 'Dialogs\uSlideShow.pas' {SlideShow},
  dxEMFChart in 'Utils\dxEMFChart.pas',
  dxEMFModelObjects in 'Utils\dxEMFModelObjects.pas',
  dxEMFModelValidator in 'Utils\dxEMFModelValidator.pas',
  dxEMFToolConsts in 'Utils\dxEMFToolConsts.pas',
  dxEMFToolTypes in 'Utils\dxEMFToolTypes.pas',
  dxEMFToolTypeToStrConverters in 'Utils\dxEMFToolTypeToStrConverters.pas',
  uModelViewer in 'Utils\uModelViewer.pas' {ModelViewer},
  dxDemoUtils in '..\Common\dxDemoUtils.pas';

{$R *.res}
{$R ..\Common\dxDPIAwareManifestPM2.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TModelViewer, FModelViewer);
  FModelViewer.OnClose := frmMain.ModelViewerCloseHandler;
  FModelViewer.OnShow := frmMain.ModelViewerShowHandler;
  FModelViewer.LoadFromFile(TPath.GetDirectoryName(Application.ExeName) + '\Data\PhotoViewer.dmf');
  FModelViewer.Show;
  Application.Run;
end.
