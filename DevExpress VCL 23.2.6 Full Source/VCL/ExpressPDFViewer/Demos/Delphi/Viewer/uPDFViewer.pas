unit uPDFViewer;

{$I cxVer.inc}

interface

uses
{$IFDEF DELPHI16}
  System.UITypes,
{$ENDIF}
{$IFDEF EXPRESSSKINS}
  dxSkinsdxRibbonPainter,
  dxSkinsCore, dxSkinsForm, dxSkinsdxBarPainter, dxSkinscxPCPainter,
  {$I dxSkins.inc}
{$ENDIF}
  dxPDFViewer, dxShellDialogs,
  dxRibbonCustomizationForm, dxRibbonSkins, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxTextEdit, cxSpinEdit, ImgList, Controls, dxPDFViewerActions, Classes, ActnList, dxActions, cxShellBrowserDialog,
  dxBar, dxRibbonGallery, dxSkinChooserGallery, cxBarEditItem, dxCustomPreview, cxClasses, dxRibbon,
  dxPDFDocument, dxBarBuiltInMenu, cxContainer, cxEdit, cxLabel, cxProgressBar, dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg,
  dxBkgnd, dxWrap, dxPrnDev, dxPSCompsProvider, dxPSFillPatterns, dxPSEdgePatterns, dxPSPDFExportCore, dxPSPDFExport,
  cxDrawTextUtils, dxPSPrVwStd, dxPSPrVwAdv, dxPSPrVwRibbon, dxPScxPageControlProducer, dxPSdxPDFViewerLnk,
  dxPScxEditorProducers, dxPScxExtEditorProducers, dxPSCore, cxImageList, dxPrinting, dxBarExtItems, cxTrackBar,
  dxZoomTrackBar, dxStatusBar, dxRibbonStatusBar, uExportToBitmaps, uExportToFileDialog, dxRibbonForm, dxProgressDialog,
  dxGDIPlusClasses, cxImage, dxPDFDocumentViewer, dxPDFBase, dxPDFText, dxPDFRecognizedObject, dxPDFCore, Dialogs, dxCore,
  dxX509Certificate, dxPDFForm, dxPDFFormData, dxPrintUtils, dxPDFTypes;

type
  TPDFViewerExportFunc = function(AScale: Double; AExportDialog: TfrmExportToFileDialog): string of object;
  TPDFViewerExportDialogClass = class of TfrmExportToFileDialog;

  TfrmPDFViewer = class(TdxRibbonForm)
    dxBarManager1: TdxBarManager;
    dxRibbon1: TdxRibbon;
    dxBarManager1Bar2: TdxBar;
    cxBarEditItem1: TcxBarEditItem;
    dxPDFViewer1: TdxPDFViewer;
    sbdSelectFolderDialog: TcxShellBrowserDialog;
    ActionList1: TActionList;
    cxImageList1: TcxImageList;
    cxImageList2: TcxImageList;
    dxPDFViewerOpenDocumentAction: TdxPDFViewerOpenDocument;
    dxRibbonTabHome: TdxRibbonTab;
    dxBarFile: TdxBar;
    dxBarLargeButtonOpen: TdxBarLargeButton;
    dxPDFViewerGoToPrevPageAction: TdxPDFViewerGoToPrevPage;
    dxBarLargeButtonPreviousPage: TdxBarLargeButton;
    dxPDFViewerGoToNextPageAction: TdxPDFViewerGoToNextPage;
    dxBarLargeButtonNextPage: TdxBarLargeButton;
    dxBarSubItem1: TdxBarSubItem;
    dxPDFViewerGoToFirstPageAction: TdxPDFViewerGoToFirstPage;
    dxBarLargeButtonFirstPage: TdxBarLargeButton;
    dxPDFViewerGoToLastPageAction: TdxPDFViewerGoToLastPage;
    dxBarLargeButtonLastPage: TdxBarLargeButton;
    dxPDFViewerZoomOutAction: TdxPDFViewerZoomOut;
    dxBarZoom: TdxBar;
    dxBarLargeButtonZoomOut: TdxBarLargeButton;
    dxPDFViewerZoomInAction: TdxPDFViewerZoomIn;
    dxBarLargeButtonZoomIn: TdxBarLargeButton;
    lbtnZoomGroup: TdxBarSubItem;
    dxPDFViewerZoom10Action: TdxPDFViewerZoom10;
    dxBarLargeButton10: TdxBarLargeButton;
    dxPDFViewerZoom25Action: TdxPDFViewerZoom25;
    dxBarLargeButton25: TdxBarLargeButton;
    dxPDFViewerZoom50Action: TdxPDFViewerZoom50;
    dxBarLargeButton50: TdxBarLargeButton;
    dxPDFViewerZoom75Action: TdxPDFViewerZoom75;
    dxBarLargeButton75: TdxBarLargeButton;
    dxPDFViewerZoom100Action: TdxPDFViewerZoom100;
    dxBarLargeButton100: TdxBarLargeButton;
    dxPDFViewerZoom125Action: TdxPDFViewerZoom125;
    dxBarLargeButton125: TdxBarLargeButton;
    dxPDFViewerZoom150Action: TdxPDFViewerZoom150;
    dxBarLargeButton150: TdxBarLargeButton;
    dxPDFViewerZoom200Action: TdxPDFViewerZoom200;
    dxBarLargeButton200: TdxBarLargeButton;
    dxPDFViewerZoom400Action: TdxPDFViewerZoom400;
    dxBarLargeButton400: TdxBarLargeButton;
    dxPDFViewerZoom500Action: TdxPDFViewerZoom500;
    dxBarLargeButton500: TdxBarLargeButton;
    dxPDFViewerZoomActualSizeAction: TdxPDFViewerZoomActualSize;
    dxBarLargeButtonActualSize: TdxBarLargeButton;
    dxPDFViewerZoomToPageLevelAction: TdxPDFViewerZoomToPageLevel;
    dxBarLargeButtonZoomtoPageLevel: TdxBarLargeButton;
    dxPDFViewerZoomFitWidthAction: TdxPDFViewerZoomFitWidth;
    dxBarLargeButtonFitWidth: TdxBarLargeButton;
    dxBarAppearance: TdxBar;
    dxSkinChooserGalleryItem1: TdxSkinChooserGalleryItem;
    btnAbout: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    dxBarLargeButton3: TdxBarLargeButton;
    cxLookAndFeelController1: TcxLookAndFeelController;
    actExit: TAction;
    dxBarExit1: TdxBarLargeButton;
    dxBarAbout: TdxBar;
    dxBarButtonAbout: TdxBarLargeButton;
    dxBarManager1Bar4: TdxBar;
    dxBarButtonExportToTIFF: TdxBarLargeButton;
    dxBarButtonExportToPNG: TdxBarLargeButton;
    bmiNavigation: TdxBar;
    dxRibbonStatusBar1: TdxRibbonStatusBar;
    biStatusBarZoom: TdxBar;
    cxBarEditItem2: TcxBarEditItem;
    bilPageCount: TcxBarEditItem;
    dxRibbonStatusBar1Container5: TdxStatusBarContainerControl;
    tbZoom: TdxZoomTrackBar;
    biStatusBarCurrentZoom: TdxBarStatic;
    dxBarSubItem3: TdxBarSubItem;
    cxBarEditItem3: TcxBarEditItem;
    dxBarSeparator1: TdxBarSeparator;
    bteActualZoom: TcxBarEditItem;
    dxRibbonNavigationGroup: TdxBar;
    lbtnNavigation: TdxBarSubItem;
    bseActivePage: TcxBarEditItem;
    dxRibbonStatusBarActivePage: TdxBarSpinEdit;
    sseActivePage: TcxBarEditItem;
    dxBarStatic1: TdxBarStatic;
    sbPageCount: TdxBarStatic;
    dxPDFViewerShowPrintForm: TdxPDFViewerShowPrintForm;
    dxBarLargeButtonPrint: TdxBarLargeButton;
    dxPDFViewerCloseDocument: TdxPDFViewerCloseDocument;
    dxBarLargeButtonClose: TdxBarLargeButton;
    dxPDFViewerGoToPrevView: TdxPDFViewerGoToPrevView;
    dxBarLargeButtonPreviousView: TdxBarLargeButton;
    dxPDFViewerGoToNextView: TdxPDFViewerGoToNextView;
    dxBarLargeButtonNextView: TdxBarLargeButton;
    lbtnRotateView: TdxBarSubItem;
    dxPDFViewerRotateClockwise: TdxPDFViewerRotateClockwise;
    dxBarLargeButtonRotateClockwise: TdxBarLargeButton;
    dxPDFViewerRotateCounterClockwise: TdxPDFViewerRotateCounterClockwise;
    dxBarLargeButtonRotateCounterclockwise: TdxBarLargeButton;
    dxPDFViewerSelectTool: TdxPDFViewerSelectTool;
    dxBarTools: TdxBar;
    dxBarLargeButtonSelectTool: TdxBarLargeButton;
    dxPDFViewerHandTool: TdxPDFViewerHandTool;
    dxBarLargeButtonHandTool: TdxBarLargeButton;
    dxPDFViewerSelectAll: TdxPDFViewerSelectAll;
    dxBarLargeButtonSelectAll: TdxBarLargeButton;
    dxComponentPrinter1: TdxComponentPrinter;
    dxComponentPrinter1Link1: TdxPDFViewerReportLink;
    dxSearchProgressBar: TdxBar;
    cxBarEditItem4: TcxBarEditItem;
    dxPDFViewerFind: TdxPDFViewerFind;
    dxBarFind: TdxBar;
    dxBarLargeButtonFind: TdxBarLargeButton;
    bbAbortTextSearch: TdxBarButton;
    acSinglePageContinuous: TAction;
    lbtnSinglePageMode: TdxBarLargeButton;
    dxBarLargeButton4: TdxBarLargeButton;
    acSaveAs: TAction;
    SaveDialog1: TdxSaveFileDialog;
    bbModified: TdxBarStatic;
    biModified: TdxBarStatic;
    acSave: TAction;
    dxBarLargeButton5: TdxBarLargeButton;
    dxRibbon1Tab1: TdxRibbonTab;
    dxBarManager1Bar1: TdxBar;
    dxBarManager1Bar3: TdxBar;
    acFormDataImport: TAction;
    acFormDataExport: TAction;
    acFormDataReset: TAction;
    acAllowEdit: TAction;
    ofdOpenFormDataDialog: TdxOpenFileDialog;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton6: TdxBarLargeButton;
    dxBarLargeButton7: TdxBarLargeButton;
    dxBarLargeButton8: TdxBarLargeButton;
    procedure FormCreate(Sender: TObject);
    procedure bseActivePageChange(Sender: TObject);
    procedure dxPDFViewer1ZoomFactorChanged(Sender: TObject);
    procedure dxSkinChooserGalleryItem1SkinChanged(Sender: TObject; const ASkinName: string);
    procedure bteActualZoomChange(Sender: TObject);
    procedure dxPDFViewer1DocumentLoaded(ASender: TdxPDFDocument; const AInfo: TdxPDFDocumentLoadInfo);
    procedure actExitExecute(Sender: TObject);
    procedure dxBarButtonAboutClick(Sender: TObject);
    procedure dxBarButtonExportToPNGClick(Sender: TObject);
    procedure dxBarButtonExportToTIFFClick(Sender: TObject);
    procedure dxPDFViewer1SelectedPageChanged(Sender: TObject; APageIndex: Integer);
    procedure tbZoomPropertiesChange(Sender: TObject);
    procedure sseActivePageChange(Sender: TObject);
    procedure dxPDFViewer1DocumentUnloaded(Sender: TObject);
    procedure dxPDFViewer1HideFindPanel(Sender: TObject);
    procedure dxPDFViewer1ShowFindPanel(Sender: TObject);
    procedure dxPDFViewer1SearchProgress(Sender: TdxPDFDocument; APageIndex, APercent: Integer);
    procedure bbAbortTextSearchClick(Sender: TObject);
    procedure dxPDFViewer1HyperlinkClick(Sender: TdxPDFCustomViewer; const AURI: string; var AHandled: Boolean);
    procedure dxPDFViewer1CustomDrawPreRenderPage(Sender: TObject; ACanvas: TcxCanvas;
      const APageInfo: TdxPDFPreRenderPageInfo; var ADone: Boolean);
    procedure dxPDFViewer1CustomDrawPreRenderPageThumbnail(Sender: TObject; ACanvas: TcxCanvas;
      const APageInfo: TdxPDFPreRenderPageInfo; var ADone: Boolean);
    procedure dxPDFViewer1AttachmentOpen(Sender: TdxPDFCustomViewer; AAttachment: TdxPDFFileAttachment;
      var AHandled: Boolean);
    procedure dxPDFViewer1AttachmentSave(Sender: TdxPDFCustomViewer; AAttachment: TdxPDFFileAttachment;
      var AHandled: Boolean);
    procedure acSinglePageContinuousExecute(Sender: TObject);
    procedure acSaveAsUpdate(Sender: TObject);
    procedure acSaveAsExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure acSaveUpdate(Sender: TObject);
    procedure dxPDFViewerCloseDocumentExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acAllowEditExecute(Sender: TObject);
    procedure acFormDataResetExecute(Sender: TObject);
    procedure acFormDataExportExecute(Sender: TObject);
    procedure acFormDataImportExecute(Sender: TObject);
    procedure acAllowEditUpdate(Sender: TObject);
    procedure acFormDataResetUpdate(Sender: TObject);
    procedure acFormDataExportUpdate(Sender: TObject);
    procedure acFormDataImportUpdate(Sender: TObject);
  private
    FAbortTextSearch: Boolean;
    FLockCount: Integer;
    FPreRenderPageImage: TdxSmartImage;
    FPrevZoomFactor: Integer;
    FProgressDialog: TfrmProgress;

    function GetFormDataDialogFilter: string;
    function ExportToBitmaps(AScale: Double; AExportDialog: TfrmExportToFileDialog): string;
    function ExportToTIFF(AScale: Double; AExportDialog: TfrmExportToFileDialog): string;
    function ShowSaveAsDialog(const AFilter, AFileExtension: string; var AFileName: string): Boolean;

    function AllowFormDataOperation: Boolean;
    function IsLocked: Boolean;
    procedure BeginUpdate;
    procedure CancelUpdate;
    procedure UpdateControls;

    procedure AfterExport;
    procedure BeforeExport;
    procedure DrawPreRenderPage(ACanvas: TcxCanvas; const APageInfo: TdxPDFPreRenderPageInfo; AFontSizeFactor: Integer; var ADone: Boolean);
    procedure InitializeLookAndFeel;
    procedure SetSkin(ASkinItem: TdxSkinChooserGalleryGroupItem);
    procedure ShowExportDialog(ADialogClass: TPDFViewerExportDialogClass; AExportFunc: TPDFViewerExportFunc);
    procedure UpdateActivePageEditor(ASpinEdit: TcxBarEditItem);
    procedure OnDocumentSaveProgressHandler(Sender: TdxPDFDocument; Percent: Integer);
  public
    { Public declarations }
  end;

var
  frmPDFViewer: TfrmPDFViewer;

implementation

{$R *.dfm}

uses
  Windows, SysUtils, Types, Forms, Math, IOUtils, Graphics, dxCoreGraphics, AboutDemoForm, dxPDFCommandInterpreter,
  SkinDemoUtils, cxGeometry, dxPDFUtils, uSaveDialog, dxTypeHelpers;

const
  ApplicationCaption = 'VCL PDF Viewer Demo';
  SecurityWarningCaption = 'Security Warning';

function DropPercentChar(const S: string): string;
var
  I: Integer;
begin
  I := Length(S);
  while (I > 0) and (S[I] = '%') do
    Dec(I);
  Result := Copy(S, 1, I);
end;

{ TfrmPDFViewer }

procedure TfrmPDFViewer.bseActivePageChange(Sender: TObject);
begin
  if not IsLocked then
    dxPDFViewer1.CurrentPageIndex := bseActivePage.EditValue - 1;
end;

procedure TfrmPDFViewer.bteActualZoomChange(Sender: TObject);
var
  V: Variant;
begin
  try
    V := StrToInt(DropPercentChar(bteActualZoom.EditValue));
  except
    try
      V := Round(StrToFloat(DropPercentChar(bteActualZoom.EditValue)));
    except
      V := FPrevZoomFactor;
    end;
  end;
  dxPDFViewer1.OptionsZoom.ZoomFactor := V;
  FPrevZoomFactor := dxPDFViewer1.OptionsZoom.ZoomFactor;
  bteActualZoom.EditValue := IntToStr(dxPDFViewer1.OptionsZoom.ZoomFactor) + '%';
end;

function TfrmPDFViewer.GetFormDataDialogFilter: string;
var
  AFormat: TdxPDFFormDataFormat;
  AFormatExtension: string;
begin
  Result := '';
  for AFormat := Low(TdxPDFFormDataFormat) to High(TdxPDFFormDataFormat) do
  begin
    AFormatExtension := dxPDFFormDataFormatFileExtension(AFormat);
    Result :=  Result + UpperCase(AFormatExtension) + ' Files (*.' + AFormatExtension + ')|*.'+ AFormatExtension;
    if AFormat <> High(TdxPDFFormDataFormat) then
      Result := Result + '|';
  end;
end;

function TfrmPDFViewer.ExportToBitmaps(AScale: Double; AExportDialog: TfrmExportToFileDialog): string;
begin
  if sbdSelectFolderDialog.Execute then
  begin
    BeforeExport;
    try
      FProgressDialog.Show;
      Result := sbdSelectFolderDialog.Path;
      dxPDFDocumentExportToPNG(dxPDFViewer1.Document, Result, TfrmExportToBitmaps(AExportDialog).teFilePrefix.Text,
        AScale, FProgressDialog, dxPDFViewer1.RotationAngle);
    finally
      AfterExport;
    end;
  end;
end;

function TfrmPDFViewer.ExportToTIFF(AScale: Double; AExportDialog: TfrmExportToFileDialog): string;
begin
  if ShowSaveAsDialog('TIFF - Tag Image File Format (*.tiff)|*.tiff;', 'tiff', Result) then
  begin
    BeforeExport;
    try
      FProgressDialog.Show;
      dxPDFDocumentExportToTIFF(dxPDFViewer1.Document, Result, AScale, FProgressDialog, dxPDFViewer1.RotationAngle);
    finally
      AfterExport;
    end;
  end;
end;

function TfrmPDFViewer.ShowSaveAsDialog(const AFilter, AFileExtension: string; var AFileName: string): Boolean;
var
  ASaveDialog: TdxSaveFileDialog;
begin
  ASaveDialog := TdxSaveFileDialog.Create(nil);
  ASaveDialog.Options := ASaveDialog.Options + [ofOverwritePrompt];
  ASaveDialog.Filter := AFilter;
  ASaveDialog.DefaultExt := AFileExtension;
  try
    Result := ASaveDialog.Execute;
    if Result then
      AFileName := ASaveDialog.FileName
    else
      AFileName := '';
  finally
    ASaveDialog.Free;
  end;
end;

function TfrmPDFViewer.AllowFormDataOperation: Boolean;
var
  AFieldCount: Integer;
begin
  AFieldCount := 0;
  dxPDFViewer1.Document.Form.ForEach(
    procedure(AField: TdxPDFCustomField)
    begin
      if AField.FieldType <> ftSignature  then
        Inc(AFieldCount);
    end);
  Result := AFieldCount > 0;
end;

procedure TfrmPDFViewer.sseActivePageChange(Sender: TObject);
begin
  if not IsLocked then
    dxPDFViewer1.CurrentPageIndex := sseActivePage.EditValue - 1;
end;

procedure TfrmPDFViewer.tbZoomPropertiesChange(Sender: TObject);
begin
  biStatusBarCurrentZoom.Caption := IntToStr(tbZoom.Position) + '%';
  dxPDFViewer1.OptionsZoom.ZoomFactor := tbZoom.Position;
end;

function TfrmPDFViewer.IsLocked: Boolean;
begin
  Result := FLockCount <> 0;
end;

procedure TfrmPDFViewer.OnDocumentSaveProgressHandler(Sender: TdxPDFDocument; Percent: Integer);
var
  AIntf: IcxProgress;
begin
  if Supports(FProgressDialog, IcxProgress, AIntf) then
    AIntf.OnProgress(nil, Percent);
end;

procedure TfrmPDFViewer.BeginUpdate;
begin
  Inc(FLockCount);
end;

procedure TfrmPDFViewer.CancelUpdate;
begin
  Dec(FLockCount);
end;

procedure TfrmPDFViewer.UpdateControls;
begin
  if dxPDFViewer1.IsDocumentLoaded and (dxPDFViewer1.Document.Information.FileName <> '') then
    Caption := TPath.GetFullPath(dxPDFViewer1.Document.Information.FileName) + ' - ' + ApplicationCaption
  else
    Caption := ApplicationCaption;
  dxBarButtonExportToPNG.Enabled := dxPDFViewer1.IsDocumentLoaded;
  dxBarButtonExportToTIFF.Enabled := dxPDFViewer1.IsDocumentLoaded;
  tbZoom.Enabled := dxPDFViewer1.IsDocumentLoaded;
  bteActualZoom.Enabled := dxPDFViewer1.IsDocumentLoaded;
  bseActivePage.Enabled := dxPDFViewer1.IsDocumentLoaded;

  lbtnSinglePageMode.Enabled := dxPDFViewer1.IsDocumentLoaded;
  lbtnZoomGroup.Enabled := dxPDFViewer1.IsDocumentLoaded;
  lbtnRotateView.Enabled := dxPDFViewer1.IsDocumentLoaded;
  lbtnNavigation.Enabled := dxPDFViewer1.IsDocumentLoaded;


  dxRibbonStatusBar1.Visible := dxPDFViewer1.IsDocumentLoaded;
  UpdateActivePageEditor(bseActivePage);
  UpdateActivePageEditor(sseActivePage);
  sbPageCount.Caption := ' of ' + IntToStr(dxPDFViewer1.PageCount);
end;

procedure TfrmPDFViewer.bbAbortTextSearchClick(Sender: TObject);
begin
  FAbortTextSearch := True;
  bbAbortTextSearch.Enabled := False;
end;

procedure TfrmPDFViewer.dxBarButtonAboutClick(Sender: TObject);
begin
  ShowAboutDemoForm;
end;

procedure TfrmPDFViewer.dxBarButtonExportToPNGClick(Sender: TObject);
begin
  ShowExportDialog(TfrmExportToBitmaps, ExportToBitmaps);
end;

procedure TfrmPDFViewer.dxBarButtonExportToTIFFClick(Sender: TObject);
begin
  ShowExportDialog(TfrmExportToFileDialog, ExportToTIFF);
end;

procedure TfrmPDFViewer.dxPDFViewer1AttachmentOpen(Sender: TdxPDFCustomViewer; AAttachment: TdxPDFFileAttachment;
  var AHandled: Boolean);
var
  AMessage: string;
begin
  AMessage := 'The file ' + QuotedStr(AAttachment.FileName) + ' may contain programs, macros, or viruses that could ' +
    'potentially harm your computer. Do you want to open it?';
  AHandled := Application.MessageBox(PChar(AMessage), PChar(SecurityWarningCaption), MB_YESNO + MB_ICONWARNING) <> ID_YES;
end;

procedure TfrmPDFViewer.dxPDFViewer1AttachmentSave(Sender: TdxPDFCustomViewer; AAttachment: TdxPDFFileAttachment;
  var AHandled: Boolean);
var
  ASaveDialog: TdxSaveFileDialog;
  AFileName: string;
begin
  AHandled := True;
  ASaveDialog := TdxSaveFileDialog.Create(Application);
  try
    ASaveDialog.Filter := '*.*';
    ASaveDialog.FileName := AAttachment.FileName;
    if ASaveDialog.Execute(Handle) then
    begin
      AFileName := TPath.GetDirectoryName(ASaveDialog.FileName) + '\' + TPath.GetFileName(ASaveDialog.FileName);
      TdxPDFUtils.SaveToFile(AFileName, AAttachment.Data);
    end;
  finally
    ASaveDialog.Free;
  end;
end;

procedure TfrmPDFViewer.dxPDFViewer1CustomDrawPreRenderPage(Sender: TObject; ACanvas: TcxCanvas;
  const APageInfo: TdxPDFPreRenderPageInfo; var ADone: Boolean);
begin
  DrawPreRenderPage(ACanvas, APageInfo, 4, ADone)
end;

procedure TfrmPDFViewer.dxPDFViewer1CustomDrawPreRenderPageThumbnail(Sender: TObject; ACanvas: TcxCanvas;
  const APageInfo: TdxPDFPreRenderPageInfo; var ADone: Boolean);
begin
  DrawPreRenderPage(ACanvas, APageInfo, 1, ADone)
end;

procedure TfrmPDFViewer.dxPDFViewer1DocumentLoaded(ASender: TdxPDFDocument; const AInfo: TdxPDFDocumentLoadInfo);
begin
  dxPDFViewer1.BeginUpdate;
  try
    dxPDFViewer1.OptionsZoom.ZoomFactor := 100;
    dxPDFViewer1.ClearViewStateHistory;
    dxPDFViewer1.Document.OnSaveProgress := OnDocumentSaveProgressHandler;
  finally
    dxPDFViewer1.EndUpdate;
  end;
  UpdateControls;
end;

procedure TfrmPDFViewer.dxPDFViewer1DocumentUnloaded(Sender: TObject);
begin
  cxBarEditItem4.EditValue := 0;
  UpdateControls;
end;

procedure TfrmPDFViewer.dxPDFViewer1HideFindPanel(Sender: TObject);
begin
  dxSearchProgressBar.Visible := False;
end;

procedure TfrmPDFViewer.dxPDFViewer1HyperlinkClick(Sender: TdxPDFCustomViewer; const AURI: string;
  var AHandled: Boolean);
var
  AMessage: string;
begin
  AMessage := 'The document is trying to access an external resource by using the following URL:' +
    dxCRLF + QuotedStr(AURI) + dxCRLF + 'Do you want to open it nevertheless?';
  if Application.MessageBox(PChar(AMessage), PChar(SecurityWarningCaption), MB_YESNO + MB_ICONWARNING) = ID_YES then
    dxShellExecute(AUri, SW_SHOWMAXIMIZED);
  AHandled := True;
end;

procedure TfrmPDFViewer.dxPDFViewer1SearchProgress(Sender: TdxPDFDocument; APageIndex, APercent: Integer);
begin
  cxBarEditItem4.EditValue := APercent;
  Application.ProcessMessages;
  if FAbortTextSearch then
  begin
    FAbortTextSearch := False;
    bbAbortTextSearch.Enabled := False;
    Abort;
  end
  else
    bbAbortTextSearch.Enabled := APercent < 100;
end;

procedure TfrmPDFViewer.dxPDFViewer1SelectedPageChanged(Sender: TObject; APageIndex: Integer);
begin
  BeginUpdate;
  try
    bseActivePage.EditValue := dxPDFViewer1.CurrentPageIndex + 1;
    sseActivePage.EditValue := Min(Max(bseActivePage.EditValue, 1), dxPDFViewer1.PageCount);
    sbPageCount.Caption := ' of ' + IntToStr(dxPDFViewer1.PageCount);
  finally
    CancelUpdate;
  end;
end;

procedure TfrmPDFViewer.dxPDFViewer1ShowFindPanel(Sender: TObject);
begin
  dxSearchProgressBar.Visible := True;
end;

procedure TfrmPDFViewer.dxPDFViewer1ZoomFactorChanged(Sender: TObject);
begin
  bteActualZoom.EditValue := dxPDFViewer1.OptionsZoom.ZoomFactor;
  tbZoom.Position := dxPDFViewer1.OptionsZoom.ZoomFactor;
end;

procedure TfrmPDFViewer.dxPDFViewerCloseDocumentExecute(Sender: TObject);
var
  AMessage: string;
begin
  if dxPDFViewer1.Document.Modified then
  begin
    AMessage := Format('The document %s was changed. Do you want to save your changes before closing?',
      [TPath.GetFileNameWithoutExtension(dxPDFViewer1.Document.Information.FileName)]);
    case Application.MessageBox(PChar(AMessage), PChar(Application.Title), MB_YESNOCANCEL OR MB_ICONINFORMATION) of
      ID_OK:
        acSave.Execute;
      ID_NO:
       dxPDFViewer1.Clear;
    else
      Exit;
    end;
  end
  else
    dxPDFViewer1.Clear;
end;

procedure TfrmPDFViewer.SetSkin(ASkinItem: TdxSkinChooserGalleryGroupItem);
begin
  ASkinItem.ApplyToRootLookAndFeel;
  dxRibbon1.ColorSchemeName := ASkinItem.SkinName;
end;

procedure TfrmPDFViewer.ShowExportDialog(ADialogClass: TPDFViewerExportDialogClass; AExportFunc: TPDFViewerExportFunc);
var
  AFileName: string;
  AExportDialog: TfrmExportToFileDialog;
  ANeedOpenAfterExport: Boolean;
begin
  AExportDialog := ADialogClass.Create(Self);
  try
    if AExportDialog.ShowModal = mrOk then
    begin
      ANeedOpenAfterExport := AExportDialog.cbOpenAfterExport.Checked;
      AFileName := AExportFunc(AExportDialog.sePageZoom.EditValue / 100, AExportDialog);
      if ANeedOpenAfterExport and (AFileName <> '') then
        dxShellExecute(AFileName);
    end;
  finally
    AExportDialog.Free;
  end;
end;

procedure TfrmPDFViewer.UpdateActivePageEditor(ASpinEdit: TcxBarEditItem);
begin
  ASpinEdit.Enabled := dxPDFViewer1.IsDocumentLoaded;
  (ASpinEdit.Properties as TcxSpinEditProperties).MaxValue := dxPDFViewer1.PageCount;
  (ASpinEdit.Properties as TcxSpinEditProperties).MinValue := 1;
  ASpinEdit.EditValue := Max(dxPDFViewer1.CurrentPageIndex, 1);
end;

procedure TfrmPDFViewer.dxSkinChooserGalleryItem1SkinChanged(Sender: TObject; const ASkinName: string);
begin
  SetSkin(dxSkinChooserGalleryItem1.SelectedGroupItem);
end;

procedure TfrmPDFViewer.acAllowEditExecute(Sender: TObject);
begin
  dxPDFViewer1.OptionsForm.AllowEdit := not dxPDFViewer1.OptionsForm.AllowEdit;
end;

procedure TfrmPDFViewer.acAllowEditUpdate(Sender: TObject);
begin
  acAllowEdit.Checked := dxPDFViewer1.IsDocumentLoaded and not dxPDFViewer1.OptionsForm.AllowEdit;
end;

procedure TfrmPDFViewer.acFormDataExportExecute(Sender: TObject);
var
  AFileName: string;
begin
  if ShowSaveAsDialog(GetFormDataDialogFilter, 'fdf', AFileName) then
    dxPDFViewer1.Document.Form.SaveDataToFile(AFileName);
end;

procedure TfrmPDFViewer.acFormDataExportUpdate(Sender: TObject);
begin
  acFormDataExport.Enabled := AllowFormDataOperation;
end;

procedure TfrmPDFViewer.acFormDataImportExecute(Sender: TObject);
begin
  if ofdOpenFormDataDialog.Execute(Handle) then
    dxPDFViewer1.Document.Form.LoadDataFromFile(ofdOpenFormDataDialog.FileName);
end;

procedure TfrmPDFViewer.acFormDataImportUpdate(Sender: TObject);
begin
  acFormDataImport.Enabled := AllowFormDataOperation;
end;

procedure TfrmPDFViewer.acFormDataResetExecute(Sender: TObject);
begin
  dxPDFViewer1.Document.Form.Reset;
end;

procedure TfrmPDFViewer.acFormDataResetUpdate(Sender: TObject);
begin
  acFormDataReset.Enabled := AllowFormDataOperation;
end;

procedure TfrmPDFViewer.acSaveAsExecute(Sender: TObject);
var
  AFileName: string;
begin
  if TfrmSaveDialogForm.Execute(dxPDFViewer1.Document) and SaveDialog1.Execute(Handle) then
  begin
    dxPDFViewer1.Document.Information.Producer := 'PDF Viewer Demo';
    BeforeExport;
    try
      FProgressDialog.Caption := 'Saving...';
      FProgressDialog.lbTitle.Caption := 'Please wait while the document is saved.';
      FProgressDialog.Show;
      AFileName := SaveDialog1.FileName;
      if TPath.GetExtension(AFileName) = '' then
        AFileName := AFileName + '.pdf';
      dxPDFViewer1.Document.SaveToFile(AFileName, False);
    finally
      AfterExport;
    end;
  end;
end;

procedure TfrmPDFViewer.acSaveAsUpdate(Sender: TObject);
begin
  acSaveAs.Enabled := dxPDFViewer1.IsDocumentLoaded;
end;

procedure TfrmPDFViewer.acSaveExecute(Sender: TObject);
begin
  dxPDFViewer1.Document.SaveToFile(dxPDFViewer1.Document.Information.FileName, False, True);
end;

procedure TfrmPDFViewer.acSaveUpdate(Sender: TObject);
begin
  acSave.Enabled := dxPDFViewer1.Document.Modified and dxPDFViewer1.IsDocumentLoaded;
end;

procedure TfrmPDFViewer.acSinglePageContinuousExecute(Sender: TObject);
const
  LayoutMap: array[Boolean] of TdxPDFViewerPageLayout = (plDefault, plSinglePageContinuous);
begin
  dxPDFViewer1.OptionsView.PageLayout := LayoutMap[acSinglePageContinuous.Checked];
end;

procedure TfrmPDFViewer.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmPDFViewer.AfterExport;
begin
  FProgressDialog.Free;
  dxPDFViewer1.Enabled := True;
end;

procedure TfrmPDFViewer.BeforeExport;
begin
  dxPDFViewer1.Enabled := False;
  FProgressDialog := TfrmProgress.Create(Self);
end;

procedure TfrmPDFViewer.DrawPreRenderPage(ACanvas: TcxCanvas; const APageInfo: TdxPDFPreRenderPageInfo;
  AFontSizeFactor: Integer; var ADone: Boolean);
var
  ARect: TRect;
  AThumbnailSize: TSize;
begin
  ADone := APageInfo.Thumbnail = nil;
  if ADone then
  begin
    ACanvas.Brush.Color := clWhite;
    ACanvas.FillRect(APageInfo.Bounds);

    AThumbnailSize := cxSize(APageInfo.Bounds.Width div 3, APageInfo.Bounds.Height div 3);
    ARect := cxRect(APageInfo.Bounds.CenterPoint, APageInfo.Bounds.CenterPoint);
    ARect.Inflate(AThumbnailSize.cx, AThumbnailSize.cy);
    ACanvas.StretchDraw(cxGetImageRect(ARect, FPreRenderPageImage.Size, ifmProportionalStretch), FPreRenderPageImage);
  end;
end;

procedure TfrmPDFViewer.InitializeLookAndFeel;
begin
  cxLookAndFeelController1.NativeStyle := False;
  cxLookAndFeelController1.SkinName := sdxDefaultSkinName;
  dxSkinChooserGalleryItem1.SelectedSkinName := RootLookAndFeel.Painter.LookAndFeelName;
  dxRibbon1.ColorSchemeName := cxLookAndFeelController1.SkinName;
end;

procedure TfrmPDFViewer.FormCreate(Sender: TObject);
begin
{$IFNDEF EXPRESSSKINS}
  dxBarAppearance.Visible := False;
{$ENDIF}
  DisableAero := True;
  InitializeLookAndFeel;
  acSinglePageContinuous.Checked := True;
  acSinglePageContinuousExecute(Self);

  ofdOpenFormDataDialog.Filter := GetFormDataDialogFilter;

  FPreRenderPageImage := TdxSmartImage.Create;
  FPreRenderPageImage.LoadFromFile('..\..\Data\PreRenderPageImage.svg');

  dxPDFViewer1.BeginUpdate;
  dxPDFViewer1.OptionsForm.AllowEdit := True;
  dxPDFViewer1.OptionsZoom.ZoomStep := 8;
  dxPDFViewer1.OptionsLockedStateImage.ShowText := True;
  dxPDFViewer1.OptionsLockedStateImage.Effect := lsieLight;
  dxPDFViewer1.LoadFromFile('..\..\Data\Demo.pdf');
  dxPDFViewer1.OptionsFindPanel.HighlightSearchResults := True;
  dxPDFViewer1.EndUpdate;
  dxPDFViewer1ZoomFactorChanged(nil);
  dxRibbonTabHome.Active := True;
end;

procedure TfrmPDFViewer.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FPreRenderPageImage);
end;

end.
