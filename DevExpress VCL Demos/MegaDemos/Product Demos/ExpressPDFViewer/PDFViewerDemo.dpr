program PDFViewerDemo;

{$SETPEOSVERSION 5.0}
{$SETPESUBSYSVERSION 5.0}

uses
  Forms,
  uPDFViewer in 'uPDFViewer.pas' {frmPDFViewer},
  dxAboutDemo in '..\Common\dxAboutDemo.pas' {dxAboutDemoForm},
  uDocumentEditor in '..\Common\uDocumentEditor.pas',
  uRichEditControlEditor in '..\Common\uRichEditControlEditor.pas' {RichEditControlEditor},
  uSpreadSheetEditor in '..\Common\uSpreadSheetEditor.pas' {SpreadSheetEditor},
  uPDFViewerEditor in '..\Common\uPDFViewerEditor.pas' {PDFViewer},
  dxDemoUtils in '..\Common\dxDemoUtils.pas',
  uSaveDialog in 'uSaveDialog.pas' {frmSaveDialogForm};

{$R *.res}
{$R ..\Common\dxDPIAwareManifestPM2.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPDFViewer, frmPDFViewer);
  Application.Run;
end.
