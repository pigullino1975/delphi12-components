unit dxDemoBaseMainForm;

{$I cxVer.inc}

interface

uses
{$IFDEF DELPHI16}
  System.UITypes,
{$ENDIF}
  Types, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ImgList, ActnList, Menus, StdCtrls, Generics.Collections,
  cxClasses, dxCore, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxLabel, cxTextEdit, cxSplitter,
  dxPgsDlg, dxPSCore, dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg, dxBkgnd, dxWrap,
  dxPrnDev,
  dxPSCompsProvider, dxPSFillPatterns, dxPSEdgePatterns, dxPSPDFExportCore,
  dxPSPDFExport, cxDrawTextUtils, dxPSPrVwStd, dxPSPrVwAdv, dxPSPrVwRibbon,
  dxPScxPageControlProducer, dxPScxEditorProducers, dxPScxExtEditorProducers,
  dxRibbonSkins, dxBar, dxBarApplicationMenu, dxRibbon, dxRibbonForm, dxStatusBar,
  dxBarExtItems, dxRibbonGallery,
  dxNavBar, dxNavBarBase, dxNavBarCollns, dxNavBarStyles,
  dxSkinsForm, dxSkinChooserGallery, dxNavBarViewsFact, dxShellDialogs,
  dxSkinsdxNavBarPainter, dxSkinsdxNavBarAccordionViewPainter, dxSkinsdxBarPainter, dxSkinsdxRibbonPainter,
  dxSkinsdxStatusBarPainter, dxSkinscxPCPainter, dxDemoUtils, dxDemoObjectInspector, dxGDIPlusClasses, dxLayoutContainer,
  dxLayoutControl, dxLayoutcxEditAdapters, dxLayoutLookAndFeels, dxPScxDBEditorLnks, dxPSTextLnk, dxPSdxLCLnk, 
  dxRibbonCustomizationForm, dxSkinsCore,  dxScreenTip, dxCustomHint, cxHint, cxImageList, cxImage, dxLayoutControlAdapters, 
  cxButtons, dxSpellCheckerUtils,  dxRibbonBackstageView, dxDemoPrintFrame, cxScrollBox, dxGallery, dxGalleryControl,
  dxRibbonBackstageViewGalleryControl, dxBevel, cxGroupBox, dxPSdxSpreadSheetLnk;

const
  dxFirstNavBarGroupIndex = 1;

type
  TdxDemoPrintAction = (dpaPrint, dpaPageSetup, dpaPreview);

  TfrmMainBase = class(TdxRibbonForm)
    actExit: TAction;
    ActionList1: TActionList;
    actModifyProperties: TAction;
    actPageSetup: TAction;
    actPrint: TAction;
    actPrintPreview: TAction;
    actTouchMode: TAction;
    barAppearance: TdxBar;
    barInfo: TdxBar;
    barOptions: TdxBar;
    barPrintAndExport: TdxBar;
    barQuickAccess: TdxBar;
    biExit: TdxBarButton;
    biExportTo: TdxBarSubItem;
    biExportToExcel: TdxBarLargeButton;
    biExportToExcel97: TdxBarLargeButton;
    biExportToHTML: TdxBarLargeButton;
    biExportToPDF: TdxBarLargeButton;
    biExportToText: TdxBarLargeButton;
    biExportToXML: TdxBarLargeButton;
    biHintContainer: TdxBarControlContainerItem;
    biPageSetup: TdxBarLargeButton;
    biPrint: TdxBarLargeButton;
    biPrintPreview: TdxBarLargeButton;
    biShowInspector: TdxBarLargeButton;
    biTouchMode: TdxBarButton;
    dxBarManager: TdxBarManager;
    dxComponentPrinter: TdxComponentPrinter;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutControl1Item1: TdxLayoutItem;
    dxLayoutGroup1: TdxLayoutGroup;
    dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList;
    dxLayoutSkinLookAndFeel1: TdxLayoutSkinLookAndFeel;
    dxPageSetupDialog1: TdxPageSetupDialog;
    dxPSEngineController1: TdxPSEngineController;
    dxRibbon1: TdxRibbon;
    dxRibbon1Tab1: TdxRibbonTab;
    dxSkinController1: TdxSkinController;
    edtNavBarFilterText: TcxTextEdit;
    ilBarLarge: TcxImageList;
    ilBarSmall: TcxImageList;
    NavBar: TdxNavBar;
    NavBarSite: TcxGroupBox;
    plClient: TcxGroupBox;
    pnlAllArea: TcxGroupBox;
    RibbonApplicationMenu: TdxBarApplicationMenu;
    SaveDialog: TdxSaveFileDialog;
    SplitterNavBar: TcxSplitter;
    cxHintStyleController1: TcxHintStyleController;
    biFullWindowMode: TdxBarLargeButton;
    biCustomProperties: TdxBarLargeButton;
    bClearNavBarFilter: TcxButton;
    liClearNavBarFilter: TdxLayoutItem;
    nbsItemStyle: TdxNavBarStyleItem;
    nbsGroupStyle: TdxNavBarStyleItem;
    dxLayoutSkinLookAndFeelDescription: TdxLayoutSkinLookAndFeel;
    dxLayoutSkinLookAndFeelBoldItemCaption: TdxLayoutSkinLookAndFeel;
    dxRibbonBackstageView1: TdxRibbonBackstageView;
    bvtPrint: TdxRibbonBackstageViewTabSheet;
    bvtExport: TdxRibbonBackstageViewTabSheet;
    gbBackstageViewTabCaption: TcxGroupBox;
    lbbvTabExportCaption: TcxLabel;
    gbExportItems: TcxGroupBox;
    gbExportPane: TcxGroupBox;
    dxBevel1: TdxBevel;
    bvgcExport: TdxRibbonBackstageViewGalleryControl;
    bsiScrollbarMode: TdxBarSubItem;
    biClassic: TdxBarButton;
    biTouch: TdxBarButton;
    biHybrid: TdxBarButton;
    nbgSearch: TdxNavBarGroup;
    nbcSearch: TdxNavBarGroupControl;

    procedure actExitExecute(Sender: TObject);
    procedure actModifyPropertiesExecute(Sender: TObject);
    procedure actPageSetupExecute(Sender: TObject);
    procedure actPrintExecute(Sender: TObject);
    procedure actPrintPreviewExecute(Sender: TObject);
    procedure actTouchModeExecute(Sender: TObject);
    procedure dxComponentPrinterGenerateReportProgress(Sender: TObject; AReportLink: TBasedxReportLink; APercentDone: Double);
    procedure dxComponentPrinterPrintDeviceBusy(Sender: TObject; var ADone: Boolean);
    procedure dxComponentPrinterPrintDeviceError(Sender: TObject; var ADone: Boolean);
    procedure edtNavBarFilterTextPropertiesChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure NavBarLinkClick(Sender: TObject; ALink: TdxNavBarItemLink);
    procedure biFullWindowModeClick(Sender: TObject);
    procedure biCustomPropertiesClick(Sender: TObject);
    procedure bClearNavBarFilterClick(Sender: TObject);
    procedure bvgcExportItemClick(Sender: TObject; AItem: TdxRibbonBackstageViewGalleryItem);
    procedure biHybridClick(Sender: TObject);
    procedure dxRibbon1ApplicationMenuClick(Sender: TdxCustomRibbon; var AHandled: Boolean);
  private
    FFullWindowModeOn: Boolean;
    FGalleryItemClickHelper: TNotifyEvent;
    FInspector: TfrmInspector;

    function NeedReflectProgressStage: Boolean;
    procedure SetFullWindowMode(AValue: Boolean);
  protected
    function IsExportOptionsAvailable: Boolean; virtual;
    function IsModifyPropertiesAvailable: Boolean; virtual;
    function IsPrintOptionsAvailable: Boolean; virtual;
    function IsUseBackstageView: Boolean;

    procedure ActivateDemo(AID: Integer); virtual;
    procedure CustomizeSetupRibbonGroups; virtual;
    procedure DoExport(AExportType: TSupportedExportType; ADataOnly: Boolean); virtual;
    procedure DoExportToFile(AExportType: TSupportedExportType; ADataOnly: Boolean; const AFileName: string; AHandler: TObject); virtual; abstract;
    procedure DoPrint(APrintAction: TdxDemoPrintAction); virtual;
    procedure DrawSearchEditButton(Sender: TcxEditButtonViewInfo; ACanvas: TcxCanvas; var AHandled: Boolean); virtual;
    function GetActiveObject: TPersistent; virtual;
    function GetActiveReportLink: TBasedxReportLink; virtual; abstract;
    function GetDemoCaption: string; virtual;
    function GetExportFileName: string; virtual; abstract;
    function GetInspectedObject: TPersistent; virtual;
    function GetMainFormCaption: string; virtual;
    function GetSkinsMenuItemsBar: TdxBar; virtual;
    function GetSupportedDataOnlyExportTypes: TSupportedExportTypes; virtual;
    procedure GetSupportedExportTypes(AList: TList<TSupportedExportType>); virtual;
    procedure InitNavBar; virtual;
    procedure InspectedObjectChanged(ASender: TObject); virtual;
    procedure InspectorChanged(ASender: TObject); virtual;
    function IsApplicationButtonAvailable: Boolean; virtual;
    function IsBarOptionsVisible: Boolean; virtual;
    function IsNavBarSplitterVisible: Boolean; virtual;
    function NeedPageSetup: Boolean; virtual;
    function NeedShowPrintDialog: Boolean; virtual;
    procedure SearchEditButtonClick(Sender: TObject; AButtonIndex: Integer);
    procedure SetNavBarFilter(AFilterText: string); virtual;
    procedure SetNavBarWidth;
    procedure SwitchDemoCustomPropertiesSetup; virtual;
    procedure SwitchFullWindowMode; virtual;

    property FullWindowModeOn: Boolean read FFullWindowModeOn write SetFullWindowMode;
  public
    constructor Create(AOwner: TComponent); override;
    procedure UpdateBaseMenuOptions; virtual;
    procedure UpdateInspectedObject;

    property ActiveObject: TPersistent read GetActiveObject;
    property DemoCaption: string read GetDemoCaption;
  end;

  TdxNavBarModernizedAccordionGroupViewInfo = class(TdxNavBarAccordionGroupViewInfo)
  public
    procedure CalculateBounds(var X, Y: Integer); override;
    function CaptionFontColor: TColor; override;
    function GetCaptionContentHeight: Integer; override;
  end;

  TdxNavBarModernizedAccordionViewInfo = class(TdxNavBarAccordionViewInfo)
  protected
    function CanHasSignInGroupCaption: Boolean; override;
    procedure CorrectGroupPositions; override;
    function GetGroupCaptionHeightAddon: Integer; override;
    function GetGroupCaptionSeparatorWidth: Integer; override;
    function GetGroupEdges: TPoint; override;
    function GetGroupsArea: TRect; override;
    function GetItemCaptionOffsets: TRect; override;
    function GetScrollContentHeight: Integer; override;
  end;

  TdxNavBarModernizedAccordionViewPainter = class(TdxNavBarAccordionViewPainter)
  private
    procedure DrawAcrylicRootGroupSeparator(const ARect: TRect; AColor: TColor);
  protected
    class function GetGroupViewInfoClass: TdxNavBarGroupViewInfoClass; override;
    class function GetViewInfoClass: TdxNavBarViewInfoClass; override;
  public
    procedure DrawItemSelection(ALinkViewInfo: TdxNavBarLinkViewInfo); override;
    procedure DrawGroupCaptionButton(AGroupViewInfo: TdxNavBarGroupViewInfo); override;
  end;

var
  frmMainBase: TfrmMainBase;

implementation

{$R *.dfm}

uses
  dxCoreGraphics, dxNavBarSkinBasedViews, ShellApi, dxExportProgressDialog, cxGeometry, Math;

const
  dxNavBarModernizedAccordionViewID = 1000;

type
  TdxNavBarViewInfoAccess = class(TdxNavBarViewInfo);
  TdxNavBarGroupViewInfoAccess = class(TdxNavBarGroupViewInfo);

procedure WarningMessage(const Message: string);
begin
  MessageBeep(MB_ICONEXCLAMATION);
  MessageBox(Application.Handle, PChar(Message),
    PChar(dxPrintingSystemProductName), MB_OK or MB_ICONEXCLAMATION);
end;

constructor TfrmMainBase.Create(AOwner: TComponent);
var
  AFrame: TfrmPrinting;
begin
  inherited Create(AOwner);

  if IsUseBackstageView then
  begin
    AFrame := TfrmPrinting.Create(Self);
    AFrame.Align := alClient;
    AFrame.AlignWithMargins := True;
    AFrame.Margins.Bottom := 40;
    AFrame.Margins.Left := 40;
    AFrame.Margins.Right := 40;
    AFrame.Margins.Top := 40;
    AFrame.Parent := bvtPrint;
    AFrame.Initialize(dxComponentPrinter, dxRibbon1);
  end;
end;

procedure TfrmMainBase.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMainBase.actModifyPropertiesExecute(Sender: TObject);
begin
  if FInspector = nil then
  begin
    FInspector := TfrmInspector.Create(Self);
    FInspector.OnInspectedObjectChanged := InspectedObjectChanged;
    FInspector.OnShow := InspectorChanged;
    FInspector.OnHide := InspectorChanged;
    if Application.MainForm.WindowState = wsMaximized then
    begin
      with Application.MainForm.BoundsRect do
      begin
        FInspector.Left := Right - FInspector.Width;
        FInspector.Top := Bottom - FInspector.Height;
      end;
    end
    else
    begin
      FInspector.Left := Screen.Width - FInspector.Width;
      FInspector.Top := Screen.Height - FInspector.Height;
    end;
  end;
  if (Sender as TAction).Checked then
  begin
    UpdateInspectedObject;
    FInspector.Show;
  end
  else
    FInspector.Hide;
end;

procedure TfrmMainBase.actPageSetupExecute(Sender: TObject);
begin
  DoPrint(dpaPageSetup);
end;

procedure TfrmMainBase.actPrintExecute(Sender: TObject);
begin
  DoPrint(dpaPrint);
end;

procedure TfrmMainBase.actPrintPreviewExecute(Sender: TObject);
begin
  DoPrint(dpaPreview);
end;

procedure TfrmMainBase.actTouchModeExecute(Sender: TObject);
begin
  dxSkinController1.TouchMode := actTouchMode.Checked;
end;

procedure TfrmMainBase.UpdateBaseMenuOptions;
const
  AItemVisibile: array[Boolean] of TdxBarItemVisible = (ivNever, ivAlways);

  procedure CheckPrintAndExportCaption;
  begin
    if not IsExportOptionsAvailable then
      barPrintAndExport.Caption := 'Print'
    else
      if not IsPrintOptionsAvailable then
        barPrintAndExport.Caption := 'Export';
  end;

begin
  biExportTo.Visible := AItemVisibile[IsExportOptionsAvailable];
  if IsPrintOptionsAvailable then
  begin
    biPrintPreview.Visible := ivAlways;
    biPrint.Visible := ivAlways;
    biPageSetup.Visible := AItemVisibile[NeedPageSetup];
  end
  else
  begin
    biPrintPreview.Visible := ivNever;
    biPrint.Visible := ivNever;
    biPageSetup.Visible := ivNever;
  end;
  barPrintAndExport.Visible := IsExportOptionsAvailable or IsPrintOptionsAvailable;
  if barPrintAndExport.Visible then
    CheckPrintAndExportCaption;
  barOptions.Visible := IsBarOptionsVisible;
  dxRibbon1.ApplicationButton.Visible := IsApplicationButtonAvailable;
end;

procedure TfrmMainBase.UpdateInspectedObject;
begin
  if FInspector <> nil then
  begin
    FInspector.InspectedObject := GetInspectedObject;
    if FInspector.InspectedObject = nil then
      FInspector.Hide;
  end;
end;

function TfrmMainBase.IsExportOptionsAvailable: Boolean;
begin
  Result := ActiveObject <> nil;
end;

function TfrmMainBase.IsModifyPropertiesAvailable: Boolean;
begin
  Result := GetInspectedObject <> nil;
end;

function TfrmMainBase.IsPrintOptionsAvailable: Boolean;
begin
  Result := ActiveObject <> nil;
end;

function TfrmMainBase.IsUseBackstageView: Boolean;
begin
  Result := dxRibbon1.ApplicationButton.Visible and (dxRibbon1.ApplicationButton.Menu = dxRibbonBackstageView1);
end;

procedure TfrmMainBase.NavBarLinkClick(Sender: TObject;
  ALink: TdxNavBarItemLink);
begin
  ActivateDemo(ALink.Item.Tag);
end;

procedure TfrmMainBase.ActivateDemo(AID: Integer);
begin
end;

procedure TfrmMainBase.CustomizeSetupRibbonGroups;
begin
  biFullWindowMode.Visible := ivNever;
  biCustomProperties.Visible := ivNever;
end;

procedure TfrmMainBase.bClearNavBarFilterClick(Sender: TObject);
begin
  edtNavBarFilterText.Text := '';
end;

procedure TfrmMainBase.DoExport(AExportType: TSupportedExportType; ADataOnly: Boolean);

const
  scxConfirm  = 'Confirm';
  scxOpenFile = 'Open file %s?';

var
  AFileName: string;
  AProgressDialog: TfrmExportProgress;
begin
  if AExportType = exPDF then
    dxPSExportToPDF(GetActiveReportLink)
  else
  begin
    SaveDialog.FileName := GetExportFileName + '.' + SupportedExportExtensions[AExportType];
    SaveDialog.Filter := SupportedExportSaveDialogFilters[AExportType];
    if SaveDialog.Execute then
    begin
      AFileName := SaveDialog.FileName;
      AProgressDialog := TfrmExportProgress.Create(Self);
      try
        AProgressDialog.Show;
        DoExportToFile(AExportType, ADataOnly, AFileName, AProgressDialog);
      finally
        AProgressDialog.Free;
      end;
      if MessageBox(0, PChar(Format(scxOpenFile, [AFileName])), scxConfirm, MB_ICONINFORMATION or MB_YESNO) = mrYes then
        ShellExecute(Handle, PChar('OPEN'), PChar(AFileName), nil, nil, SW_SHOWMAXIMIZED);
    end;
  end;
end;

procedure TfrmMainBase.DoPrint(APrintAction: TdxDemoPrintAction);
const
  sdxExpressPrintingMessage = 'The ' + dxPrintingSystemProductName + ' allows you to render and ' +
    'print the contents of the %s, as well as a number of' +
    ' other Developer Express controls. This component library is not part of ' +
    'the %s Suite and can be acquired separately via our site at: www.devexpress.com.';
var
  AReportLink: TBasedxReportLink;
begin
  Application.MessageBox(PChar(Format(sdxExpressPrintingMessage, [dxProductNames[dxMegaDemoProductIndex],
    dxProductNames[dxMegaDemoProductIndex]])), dxPrintingSystemProductName, MB_ICONINFORMATION);
  AReportLink := GetActiveReportLink;
  AReportLink.RebuildReport;
  case APrintAction of
    dpaPrint:
      AReportLink.Print(NeedShowPrintDialog, nil);
    dpaPreview:
      AReportLink.Preview;
  else //dpaPageSetup
    AReportLink.PageSetup;
  end;
  AReportLink.Active := False;
end;

procedure TfrmMainBase.DrawSearchEditButton(Sender: TcxEditButtonViewInfo;
  ACanvas: TcxCanvas; var AHandled: Boolean);
var
  ARect: TRect;
begin
  AHandled := True;
  if ACanvas <> nil then
  begin
    if not (Sender.Data.UseSkins or Sender.Data.NativeStyle) then
      FillRectByColor(ACanvas.Handle, Sender.Bounds, Sender.Data.BackgroundColor);
    if Sender.ButtonIndex = 0 then
      RootLookAndFeel.Painter.DrawScaledSearchEditButtonGlyph(ACanvas, Sender.Bounds, cxbsNormal, Sender.ScaleFactor)
    else
    begin
      ARect := cxRectCenter(Sender.Bounds, RootLookAndFeel.Painter.GetScaledClearButtonGlyphSize(Sender.ScaleFactor));
      RootLookAndFeel.Painter.DrawScaledClearButtonGlyph(ACanvas, ARect, EditBtnStateToButtonState[Sender.Data.State], Sender.ScaleFactor);
    end;
  end;
end;

procedure TfrmMainBase.dxComponentPrinterGenerateReportProgress(Sender: TObject;
  AReportLink: TBasedxReportLink; APercentDone: Double);
begin
//
end;

procedure TfrmMainBase.dxComponentPrinterPrintDeviceBusy(Sender: TObject;
  var ADone: Boolean);
begin
  WarningMessage('Printer currently is busy.');
end;

procedure TfrmMainBase.dxComponentPrinterPrintDeviceError(Sender: TObject;
  var ADone: Boolean);
begin
  WarningMessage('An error has been encountered during printing.');
end;

procedure TfrmMainBase.dxRibbon1ApplicationMenuClick(Sender: TdxCustomRibbon; var AHandled: Boolean);
begin
  if IsUseBackstageView then
    dxComponentPrinter.RebuildReport();
end;

function TfrmMainBase.GetActiveObject: TPersistent;
begin
  Result := nil;
end;

function TfrmMainBase.GetDemoCaption: string;
begin
  Result := Application.Title;
end;

function TfrmMainBase.GetMainFormCaption: string;
begin
  Result := dxProductNames[dxMegaDemoProductIndex] + ' Features Demo';
end;

function TfrmMainBase.GetInspectedObject: TPersistent;
begin
  Result := ActiveObject;
end;

function TfrmMainBase.GetSkinsMenuItemsBar: TdxBar;
begin
  Result := barAppearance;
end;

function TfrmMainBase.GetSupportedDataOnlyExportTypes: TSupportedExportTypes;
begin
  Result := [];
end;

procedure TfrmMainBase.GetSupportedExportTypes(AList: TList<TSupportedExportType>);
begin
  AList.Add(exExcel97);
  AList.Add(exExcel);
  AList.Add(exText);
  AList.Add(exPDF);
  AList.Add(exHTML);
  AList.Add(exXML);
end;

procedure TfrmMainBase.biCustomPropertiesClick(Sender: TObject);
begin
  SwitchDemoCustomPropertiesSetup;
end;

procedure TfrmMainBase.biFullWindowModeClick(Sender: TObject);
begin
  FullWindowModeOn := biFullWindowMode.Down;
end;

procedure TfrmMainBase.bvgcExportItemClick(Sender: TObject; AItem: TdxRibbonBackstageViewGalleryItem);
begin
  if Assigned(FGalleryItemClickHelper) then
    FGalleryItemClickHelper(AItem);
end;

procedure TfrmMainBase.biHybridClick(Sender: TObject);
begin
  RootLookAndFeel.ScrollbarMode := TdxScrollbarMode((Sender as TComponent).Tag);
end;

procedure TfrmMainBase.InitNavBar;
var
  I: Integer;
begin
  for I := 0 to NavBar.RootGroupCount - 1 do
    NavBar.RootGroups[I].OptionsExpansion.Expandable := False;
end;

procedure TfrmMainBase.InspectedObjectChanged(ASender: TObject);
begin
//
end;

procedure TfrmMainBase.InspectorChanged(ASender: TObject);
begin
  actModifyProperties.Checked := (FInspector <> nil) and FInspector.Visible;
end;

function TfrmMainBase.IsApplicationButtonAvailable: Boolean;
begin
  Result := biPrintPreview.Visible = ivAlways;
end;

function TfrmMainBase.IsBarOptionsVisible: Boolean;
begin
  Result := IsModifyPropertiesAvailable;
end;

function TfrmMainBase.IsNavBarSplitterVisible: Boolean;
begin
  Result := False;
end;

function TfrmMainBase.NeedPageSetup: Boolean;
begin
  Result := False;
end;

function TfrmMainBase.NeedShowPrintDialog: Boolean;
begin
  Result := False;
end;

procedure TfrmMainBase.SetNavBarFilter(AFilterText: string);
var
  I, J: Integer;
  AGroup: TdxNavBarGroup;
begin
  NavBar.BeginUpdate;
  try
    for I := 0 to NavBar.Items.Count - 1 do
      NavBar.Items[I].Visible := (AFilterText = '') or
        (Pos(AnsiUpperCase(AFilterText),
          AnsiUpperCase(NavBar.Items[I].Caption)) <> 0);
    for I := dxFirstNavBarGroupIndex to NavBar.Groups.Count - 1 do
    begin
      AGroup := NavBar.Groups[I];
      AGroup.Visible := False;
      for J := 0 to AGroup.LinkCount - 1 do
        AGroup.Visible := AGroup.Visible or AGroup.Links[J].Item.Visible;
    end;
  finally
    NavBar.EndUpdate;
  end;
end;

procedure TfrmMainBase.SetNavBarWidth;
var
  I: Integer;
  AMaxWidth, AWidth, AIndent: Integer;
begin
  AIndent := ScaleFactor.Apply(35);
  AMaxWidth := 0;
  try
    if NavBar.Groups.Count > 1 then
      Canvas.Font.Assign(NavBar.Groups[0].StyleHeader.Style.Font);
    for I := 0 to NavBar.Groups.Count - 1 do
      AMaxWidth := Max(AMaxWidth, Canvas.TextWidth(NavBar.Groups[I].Caption) + AIndent);

    if NavBar.Items.Count > 0 then
      Canvas.Font.Assign(NavBar.Items[0].Style.Style.Font);
    for I := 0 to NavBar.Items.Count - 1 do
    begin
      AWidth := Canvas.TextWidth(NavBar.Items[I].Caption) + AIndent;
      if NavBar.OptionsImage.SmallImages <> nil then
        Inc(AWidth, NavBar.OptionsImage.SmallImages.Width);
      AMaxWidth := Max(AMaxWidth, AWidth);
    end;
  finally
    Canvas.Font.Assign(Font);
  end;
  NavBarSite.Width := AMaxWidth + NavBar.ScrollBar.Width;
end;

procedure TfrmMainBase.SearchEditButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if AButtonIndex = 1 then
    edtNavBarFilterText.Text := '';
end;

procedure TfrmMainBase.SetFullWindowMode(AValue: Boolean);
begin
  if FFullWindowModeOn <> AValue then
  begin
    FFullWindowModeOn := AValue;
    SwitchFullWindowMode;
  end;
end;

procedure TfrmMainBase.SwitchDemoCustomPropertiesSetup;
begin
//
end;

procedure TfrmMainBase.SwitchFullWindowMode;
begin
  NavBar.Visible := not FullWindowModeOn;
//  NavBarSite.Visible := not FullWindowModeOn;
//  SplitterNavBar.Visible := IsNavBarSplitterVisible and NavBarSite.Visible;
end;

function TfrmMainBase.NeedReflectProgressStage: Boolean;
begin
  Result := not dxComponentPrinter.PreviewExists;
end;

procedure TfrmMainBase.edtNavBarFilterTextPropertiesChange(Sender: TObject);
begin
  SetNavBarFilter(edtNavBarFilterText.Text);
//  liClearNavBarFilter.Visible := Trim(edtNavBarFilterText.Text) <> '';
  edtNavBarFilterText.Properties.Buttons[1].Visible := Trim(edtNavBarFilterText.Text) <> '';
end;

procedure TfrmMainBase.FormCreate(Sender: TObject);
var
  AGalleryExport: TdxRibbonBackstageViewGalleryControl;
  ASupportedExportTypes: TList<TSupportedExportType>;
begin
  Navbar.View := dxNavBarModernizedAccordionViewID;
  Caption := GetMainFormCaption;
  Application.Title := Caption;
  CreateSkinsMenuItems(dxBarManager, GetSkinsMenuItemsBar, dxSkinController1, dxRibbon1, True);

  AGalleryExport := nil;
  FGalleryItemClickHelper := nil;
  if IsUseBackstageView then
    AGalleryExport := bvgcExport;
  ASupportedExportTypes := TList<TSupportedExportType>.Create;
  try
    GetSupportedExportTypes(ASupportedExportTypes);
    CreateExportMenuItems(dxBarManager, nil, biExportTo, DoExport, ASupportedExportTypes, GetSupportedDataOnlyExportTypes,
      AGalleryExport, FGalleryItemClickHelper, True);
  finally
    ASupportedExportTypes.Free;
  end;
  CreateHelpMenuItems(dxBarManager, dxRibbon1, barInfo, True);
  SplitterNavBar.Visible := IsNavBarSplitterVisible;
  DisableAero := True;
  CustomizeSetupRibbonGroups;
  plClient.DoubleBuffered := True;
  InitNavBar;
  SetNavBarWidth;
  nbgSearch.Position := 0;
  actTouchMode.Checked := dxSkinController1.TouchMode;
  NavigationControl := NavBar;
  EnableAcrylicEffects := True;
  AdjustLayoutForNonClientDrawing := False;
  Height := ScaleFactor.Apply(856);
  Width := ScaleFactor.Apply(1271);
  Position := poScreenCenter;
  edtNavBarFilterText.Properties.Buttons.Add.Kind := bkGlyph;
  edtNavBarFilterText.Properties.Buttons[0].LeftAlignment := True;
  edtNavBarFilterText.Properties.Buttons.Add.Kind := bkGlyph;
  edtNavBarFilterText.Properties.Buttons[1].Visible := False;
  edtNavBarFilterText.Properties.OnButtonClick := SearchEditButtonClick;
  edtNavBarFilterText.ViewInfo.OnDrawButton := DrawSearchEditButton;
end;

procedure TfrmMainBase.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if NeedReflectProgressStage and (cpsBuilding in dxComponentPrinter.State) and (Key = VK_ESCAPE) then
    dxComponentPrinter.AbortBuilding := True;
end;


{ TdxNavBarModernizedAccordionGroupViewInfo }

procedure TdxNavBarModernizedAccordionGroupViewInfo.CalculateBounds(var X, Y:
    Integer);
begin
  inherited CalculateBounds(X, Y);
  if IsCaptionVisible and (NavBar.OptionsImage.SmallImages = nil) then
    FCaptionTextRect.Left := X + (ViewInfo as TdxNavBarModernizedAccordionViewInfo).GetItemCaptionOffsets.Left;
  if Group.Index = 0 then
    Y := Y - TdxNavBarModernizedAccordionViewInfo(ViewInfo).GetSpaceBetweenGroups;
end;

{ TdxNavBarModernizedAccordionGroupViewInfo }

function TdxNavBarModernizedAccordionGroupViewInfo.CaptionFontColor: TColor;
var
  ABackColor: TColor;
  AARGB, AARGB1, AARGB2: TRGBQuad;
  AHelper: TdxNavBarSkinBasedPainterHelper;
begin
  AHelper := TdxNavBarModernizedAccordionViewPainter(Painter).FSkinBasedPainterHelper;
  if (AHelper = nil) or (AHelper.NavBarItem = nil) or (AHelper.NavBarBackground = nil) then
    Result := inherited CaptionFontColor
  else
  begin
    Result := AHelper.NavBarItem.TextColor;
    AARGB1 := dxColorToRGBQuad(Result);
    ABackColor := AHelper.NavBarBackground.Color;
    AARGB2 := dxColorToRGBQuad(ABackColor);
    AARGB.rgbBlue := Trunc(0.65 * AARGB1.rgbBlue + 0.35 * AARGB2.rgbBlue);
    AARGB.rgbRed := Trunc(0.65 * AARGB1.rgbRed + 0.35 * AARGB2.rgbRed);
    AARGB.rgbGreen := Trunc(0.65 * AARGB1.rgbGreen + 0.35 * AARGB2.rgbGreen);
    AARGB.rgbReserved := 0;
    Result := dxRGBQuadToColor(AARGB);
  end;
end;

function TdxNavBarModernizedAccordionGroupViewInfo.GetCaptionContentHeight: Integer;
begin
  Result := cxTextHeight(CaptionFont);
end;

procedure TdxNavBarModernizedAccordionViewPainter.DrawAcrylicRootGroupSeparator(const ARect: TRect; AColor: TColor);
var
  R: TRect;
begin
  R := ARect;
  R.Top := R.Bottom - ScaleFactor.Apply(1);
  dxGpFillRect(Canvas.Handle, R, AColor, 64);
end;

procedure TdxNavBarModernizedAccordionViewPainter.DrawItemSelection(ALinkViewInfo: TdxNavBarLinkViewInfo);
var
  R: TRect;
begin
  inherited DrawItemSelection(ALinkViewInfo);
  if ALinkViewInfo.GroupViewInfo.Group.Index = dxFirstNavBarGroupIndex then // Highlighted Features
  begin
    R := ALinkViewInfo.Rect;
    R.Right := R.Left + 3;
    dxGPPaintCanvas.BeginPaint(Canvas.Handle, R);
    try
      dxGPPaintCanvas.FillRectangle(R, dxColorToAlphaColor($2890E5));
    finally
      dxGPPaintCanvas.EndPaint;
    end;
  end;
end;

procedure TdxNavBarModernizedAccordionViewPainter.DrawGroupCaptionButton(AGroupViewInfo: TdxNavBarGroupViewInfo);
begin
  if IsAcrylicEnabled then
    DrawAcrylicRootGroupSeparator(AGroupViewInfo.CaptionRect, AGroupViewInfo.CaptionFontColor)
  else
    cxCanvas.DrawComplexFrame(AGroupViewInfo.CaptionRect, clNone, AGroupViewInfo.CaptionFontColor, [bBottom]);
end;

{ TdxNavBarModernizedAccordionViewPainter }

class function TdxNavBarModernizedAccordionViewPainter.GetGroupViewInfoClass:
    TdxNavBarGroupViewInfoClass;
begin
  Result := TdxNavBarModernizedAccordionGroupViewInfo;
end;

class function TdxNavBarModernizedAccordionViewPainter.GetViewInfoClass:
    TdxNavBarViewInfoClass;
begin
  Result := TdxNavBarModernizedAccordionViewInfo;
end;

{ TdxNavBarModernizedAccordionViewInfo }

function TdxNavBarModernizedAccordionViewInfo.CanHasSignInGroupCaption: Boolean;
begin
  Result := False;
end;

procedure TdxNavBarModernizedAccordionViewInfo.CorrectGroupPositions;
var
  I: Integer;
begin
  for I := 1 to GroupCount - 1 do
    Groups[I].CorrectBounds(0, -NavBar.ScrollPosition);
end;

function TdxNavBarModernizedAccordionViewInfo.GetGroupCaptionHeightAddon: Integer;
begin
  Result := ScaleFactor.Apply(20);
end;

function TdxNavBarModernizedAccordionViewInfo.GetGroupCaptionSeparatorWidth: Integer;
begin
  Result := 0;
end;

function TdxNavBarModernizedAccordionViewInfo.GetGroupEdges: TPoint;
begin
  Result := Point(0, 0);
end;

function TdxNavBarModernizedAccordionViewInfo.GetGroupsArea: TRect;
begin
  Result := inherited GetGroupsArea;
  Result.Top := Groups[0].Rect.Bottom;
end;

function TdxNavBarModernizedAccordionViewInfo.GetItemCaptionOffsets: TRect;
begin
  Result := inherited GetItemCaptionOffsets;
  Result.Left := 12;
  Inc(Result.Top, 2);
  Inc(Result.Bottom, 2);
end;

function TdxNavBarModernizedAccordionViewInfo.GetScrollContentHeight: Integer;
begin
  Result := inherited GetScrollContentHeight;
  Dec(Result, Groups[0].Rect.Height);
end;

initialization
  dxUseVectorIcons := True;
  TdxVisualRefinements.ApplyLightStyle(True);
  dxNavBarViewsFactory.RegisterView(dxNavBarModernizedAccordionViewID,
    'ModernizedAccordionView', TdxNavBarModernizedAccordionViewPainter);

finalization
  dxNavBarViewsFactory.UnRegisterView(dxNavBarModernizedAccordionViewID);

end.

