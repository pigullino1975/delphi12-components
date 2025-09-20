program CloudStorageDemo;

{$SETPEOSVERSION 5.0}
{$SETPESUBSYSVERSION 5.0}

uses
  Forms,
  dxDemoUtils in '..\Common\dxDemoUtils.pas',
  dxAboutDemo in '..\Common\dxAboutDemo.pas' {dxAboutDemoForm},
  dxDemoBaseMainForm in '..\Common\dxDemoBaseMainForm.pas' {frmMainBase},
  dxDemoPrintFrame in '..\Common\dxDemoPrintFrame.pas' {frmPrinting: TFrame},
  dxDemoObjectInspector in '..\Common\dxDemoObjectInspector.pas' {frmInspector},
  dxExportProgressDialog in '..\Common\dxExportProgressDialog.pas',
  uCloudStorageDemoMain in 'uCloudStorageDemoMain.pas' {fmCloudStorageDemoForm},
  uCloudSetupForm in 'uCloudSetupForm.pas' {fmCloudSetupWizard},
  uDocumentEditor in '..\Common\uDocumentEditor.pas',
  uPDFViewerEditor in '..\Common\uPDFViewerEditor.pas' {PDFViewer},
  uRichEditControlEditor in '..\Common\uRichEditControlEditor.pas' {RichEditControlEditor},
  uSpreadSheetEditor in '..\Common\uSpreadSheetEditor.pas' {SpreadSheetEditor};

{$R *.res}
{$R ..\Common\dxDPIAwareManifestPM2.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmCloudStorageDemoForm, fmCloudStorageDemoForm);
  Application.Run;
end.
