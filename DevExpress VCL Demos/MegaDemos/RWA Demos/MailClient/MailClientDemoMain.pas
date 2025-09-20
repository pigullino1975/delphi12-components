unit MailClientDemoMain;

{$I cxVer.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Forms, Controls, Dialogs, ExtCtrls, DB, ComCtrls, Menus,
  StdCtrls, ImgList, cxGeometry, dxBar, dxRibbon, dxRibbonForm, dxRibbonSkins, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxClasses, cxDBData, dxRibbonBackstageView, dxSkinsCore, dxSkinsdxNavBarPainter, dxCore,
  dxSkinsdxBarPainter, cxCustomData, cxStyles, cxTL, cxTextEdit, cxTLdxBarBuiltInMenu, cxContainer, cxEdit, cxGroupBox,
  cxInplaceContainer, dxNavBarCollns, dxNavBarBase, dxNavBar, dxStatusBar, dxRibbonStatusBar, dxSkinsForm, dxScreenTip,
  dxRibbonGallery, dxBarExtItems, dxZoomTrackBar, cxTrackBar, cxSchedulerStorage, cxSchedulerCustomControls,
  cxSchedulerDateNavigator, cxDateNavigator, cxTreeView, cxButtons, cxScheduler, dxSkinChooserGallery, dxSkinsdxRibbonPainter,
  MailClientDemoBase, MailClientDemoMails, MailClientDemoContacts, MailClientDemoCalendar, 
  MailClientDemoTasks, cxMaskEdit, cxDropDownEdit, cxSplitter, dxAlertWindow, cxSchedulerUtils, cxRadioGroup, cxLabel,
  dxLayoutControlAdapters, dxLayoutContainer, dxLayoutControl, dxLayoutLookAndFeels, cxFilter, cxData, cxDataStorage,
  cxNavigator, cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridLevel, cxGridCustomView, cxGrid,
  cxImageComboBox, dxCustomHint, cxHint, cxMemo, cxRichEdit, dxNavBarStyles, ActnList, fmMailUnit, cxImage,
  dxGDIPlusClasses, dxSkinscxPCPainter, dxGallery, dxGalleryControl, dxRibbonBackstageViewGalleryControl, cxDBTL,
  cxTLData, MailClientDemoData, dxRibbonCustomizationForm, dxSkinsDefaultPainters, dxNavBarOfficeNavigationBar, cxPC,
  dxDockControl, dxDockPanel, MailClientDateNavigator, dxBarBuiltInMenu, dxLayoutcxEditAdapters, dxPSCore, dxPSPrVw,
  cxSpinEdit, MainClientDemoPrinting, cxImageList, dxUIAdorners, dxOfficeSearchBox, cxBarEditItem,
  cxLocalization, dxShellDialogs, dxScrollbarAnnotations, System.Actions,
  cxFontNameComboBox, dxFramedControl, dxPanel;

type
  TfmMailClientDemoMain = class(TdxRibbonForm, IdxLocalizerListener, IcxLookAndFeelNotificationListener)
    aclMain: TActionList;
    actPageSetup: TAction;
    actPrintPreview: TAction;
    actQATAboveRibbon: TAction;
    actQATBelowRibbon: TAction;
    bbTouchMode: TdxBarLargeButton;
    bExit: TdxBarButton;
    bmMain: TdxBarManager;
    bNavigationCalendar: TdxBarButton;
    bNavigationContacts: TdxBarButton;
    bNavigationMail: TdxBarButton;
    bNavigationTasks: TdxBarButton;
    btnToday: TcxButton;
    bvgcExport: TdxRibbonBackstageViewGalleryControl;
    bvgcLocationsGroup1: TdxRibbonBackstageViewGalleryGroup;
    bvgcOpen: TdxRibbonBackstageViewGalleryControl;
    bvgcOpenCalendar: TdxRibbonBackstageViewGalleryItem;
    bvtsExport: TdxRibbonBackstageViewTabSheet;
    bvtsInfo: TdxRibbonBackstageViewTabSheet;
    bvtsOpen: TdxRibbonBackstageViewTabSheet;
    bvtsPrint: TdxRibbonBackstageViewTabSheet;
    cxButton2: TcxButton;
    cxGroupBox1: TcxGroupBox;
    cxGroupBox5: TcxGroupBox;
    cxHintStyleController1: TcxHintStyleController;
    dnScheduler: TcxDateNavigator;
    dsHelper: TDataSource;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutLookAndFeelList3: TdxLayoutLookAndFeelList;
    dxLayoutSkinLookAndFeel1: TdxLayoutSkinLookAndFeel;
    dxRibbon1: TdxRibbon;
    dxRibbon1Tab6: TdxRibbonTab;
    dxRibbonStatusBar1: TdxRibbonStatusBar;
    dxRibbonStatusBar1Container3: TdxStatusBarContainerControl;
    Frame11: TFrame1;
    gbHelpContent: TcxGroupBox;
    ilNavBarLarge: TcxImageList;
    ilNavBarSmall: TcxImageList;
    ilTreeList: TcxImageList;
    ItemsCountInfo: TdxBarStatic;
    lbAppButton: TdxBarLargeButton;
    lblClientCenter: TcxLabel;
    lblDownloads: TcxLabel;
    lblDXonWeb: TcxLabel;
    lblGettingStarted: TcxLabel;
    lblKnowledgeBase: TcxLabel;
    lblProducts: TcxLabel;
    lblSupportCenter: TcxLabel;
    lbQuickAccessToolbarAbove: TdxBarLargeButton;
    lbQuickAccessToolbarBelow: TdxBarLargeButton;
    lbQuickAccessToolbarVisible: TdxBarLargeButton;
    lbRibbonForm: TdxBarLargeButton;
    lbViewNormal: TdxBarLargeButton;
    lbViewReading: TdxBarLargeButton;
    liCalendar: TdxLayoutItem;
    odCalendar: TdxOpenFileDialog;
    RibbonBackstageView: TdxRibbonBackstageView;
    rtAppointment: TdxRibbonTab;
    rtFrame: TdxRibbonTab;
    screpNavBar: TdxScreenTipRepository;
    siNavigation: TdxBarSubItem;
    SkinController: TdxSkinController;
    stTaskEmployees: TdxScreenTip;
    tbColorSchemes: TdxBar;
    tbItemsCount: TdxBar;
    tbQuickAccess: TdxBar;
    tbQuickAccessToolbarLayout: TdxBar;
    tbRibbonOptions: TdxBar;
    tbStatusBarView: TdxBar;
    tbViewNavigation: TdxBar;
    ztbContent: TdxZoomTrackBar;
    amMails: TdxUIAdornerManager;
    bdgVCLInbox: TdxBadge;
    bdgAnnouncements: TdxBadge;
    bdgGrid: TdxBadge;
    bdgServerMode: TdxBadge;
    bdgTileControl: TdxBadge;
    bdgMrBrooksInbox: TdxBadge;
    tbTabAreaSearchToolbar: TdxBar;
    beiOfficeSearchBox: TcxBarEditItem;
    tbSearchOptions: TdxBar;
    lbRecursiveSearch: TdxBarLargeButton;
    lbShowPaths: TdxBarLargeButton;
    dxLayoutControl2: TdxLayoutControl;
    dxLayoutControl2Group_Root: TdxLayoutGroup;
    dxLayoutImageItem1: TdxLayoutImageItem;
    liInfo: TdxLayoutLabeledItem;
    dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList;
    dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel;
    liSupport: TdxLayoutLabeledItem;
    dxLayoutCxLookAndFeel2: TdxLayoutCxLookAndFeel;
    dxLayoutItem3: TdxLayoutItem;
    cxImageList1: TcxImageList;
    dxLayoutItem6: TdxLayoutItem;
    dxLayoutItem4: TdxLayoutItem;
    dxLayoutItem5: TdxLayoutItem;
    dxLayoutItem7: TdxLayoutItem;
    dxLayoutItem8: TdxLayoutItem;
    dxLayoutItem9: TdxLayoutItem;
    liLinks: TdxLayoutLabeledItem;
    dxLayoutEmptySpaceItem1: TdxLayoutEmptySpaceItem;
    dxLayoutControl3Group_Root: TdxLayoutGroup;
    dxLayoutControl3: TdxLayoutControl;
    liOpen: TdxLayoutLabeledItem;
    dxLayoutItem10: TdxLayoutItem;
    dxLayoutControl4Group_Root: TdxLayoutGroup;
    dxLayoutControl4: TdxLayoutControl;
    liPrint: TdxLayoutLabeledItem;
    dxLayoutControl5Group_Root: TdxLayoutGroup;
    dxLayoutControl5: TdxLayoutControl;
    liExport: TdxLayoutLabeledItem;
    dxLayoutItem11: TdxLayoutItem;
    liPrintReport: TdxLayoutItem;
    bliFormCorners: TdxBarListItem;
    dxNavBar1: TdxNavBar;
    nbgrMail: TdxNavBarGroup;
    nbgrCalendar: TdxNavBarGroup;
    nbgrContacts: TdxNavBarGroup;
    nbgrTasks: TdxNavBarGroup;
    nbgrMailControl: TdxNavBarGroupControl;
    tlMail: TcxDBTreeList;
    tlMailNameColumn: TcxDBTreeListColumn;
    tlMailUnreadCountColumn: TcxDBTreeListColumn;
    tlMailBoxKindColumn: TcxDBTreeListColumn;
    tlMailBoxNumberColumn: TcxDBTreeListColumn;
    nbgrCalendarControl: TdxNavBarGroupControl;
    tlCalendar: TcxTreeList;
    tlCalendarColumn1: TcxTreeListColumn;
    nbgrContactsControl: TdxNavBarGroupControl;
    gbFramesDisplay: TdxPanel;
    cxStyleRepository1: TcxStyleRepository;
    stTreeListBackground: TcxStyle;

    procedure actPageSetupExecute(Sender: TObject);
    procedure actPrintPreviewExecute(Sender: TObject);
    procedure actQATBelowRibbonExecute(Sender: TObject);
    procedure actQATBelowRibbonUpdate(Sender: TObject);
    procedure bbTouchModeClick(Sender: TObject);
    procedure bExitClick(Sender: TObject);
    procedure bNavigationMailClick(Sender: TObject);
    procedure btnTodayClick(Sender: TObject);
    procedure bvgcExportItemClick(Sender: TObject; AItem: TdxRibbonBackstageViewGalleryItem);
    procedure bvgcOpenItemClick(Sender: TObject; AItem: TdxRibbonBackstageViewGalleryItem);
    procedure cxButton1Click(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
    procedure cxHintStyleController1ShowHint(Sender: TObject; var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
    procedure cxTreeList1StylesGetContentStyle(Sender: TcxCustomTreeList; AColumn: TcxTreeListColumn; ANode: TcxTreeListNode; var AStyle: TcxStyle);
    procedure dnSchedulerCustomDrawBackground(Sender: TObject; ACanvas: TcxCanvas; const ABounds: TRect; var AViewParams: TcxViewParams; var ADone: Boolean);
    procedure dnSchedulerCustomDrawDayNumber(Sender: TObject; ACanvas: TcxCanvas; AViewInfo: TcxSchedulerDateNavigatorDayNumberViewInfo; var ADone: Boolean);
    procedure dnSchedulerSelectionChanged(Sender: TObject; const AStart, AFinish: TDateTime);
    procedure dsHelperDataChange(Sender: TObject; Field: TField);
    procedure dxNavBar1ActiveGroupChanged(Sender: TObject);
    procedure dxNavBar1GetLinkHint(Sender: TObject; ALink: TdxNavBarItemLink; var AHint: String);
    procedure dxNavBar1NavigationPaneCollapsed(Sender: TObject);
    procedure dxNavBar1NavigationPaneExpanded(Sender: TObject);
    procedure dxNavBarOfficeNavigationBar1QueryPeekFormContent(ASender: TObject; ANavigationItem: IdxNavigationItem; var AControl: TWinControl);
    procedure dxZoomTrackBar1PropertiesChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbAppButtonClick(Sender: TObject);
    procedure lblClientCenterClick(Sender: TObject);
    procedure lblDownloadsClick(Sender: TObject);
    procedure lblDXonWebClick(Sender: TObject);
    procedure lblGettingStartedClick(Sender: TObject);
    procedure lblKnowledgeBaseClick(Sender: TObject);
    procedure lblProductsClick(Sender: TObject);
    procedure lblSupportCenterClick(Sender: TObject);
    procedure lbQuickAccessToolbarVisibleClick(Sender: TObject);
    procedure lbRibbonFormClick(Sender: TObject);
    procedure lbViewNormalClick(Sender: TObject);
    procedure lbViewReadingClick(Sender: TObject);
    procedure RibbonBackstageViewCloseUp(Sender: TObject);
    procedure RibbonBackstageViewPopup(Sender: TObject);
    procedure tlCalendarClick(Sender: TObject);
    procedure tlMailCustomDrawDataCell(Sender: TcxCustomTreeList; ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);
    procedure tlMailFocusedNodeChanged(Sender: TcxCustomTreeList; APrevFocusedNode, AFocusedNode: TcxTreeListNode);
    procedure tlMailLayoutChanged(Sender: TObject);
    procedure tlMailTopRecordIndexChanged(Sender: TObject);
    procedure lbRecursiveSearchClick(Sender: TObject);
    procedure lbShowPathsClick(Sender: TObject);
    procedure bliFormCornersClick(Sender: TObject);
    procedure gbFramesDisplayDragBorder(ASender: TdxFramedControl;
      ABorder: TcxBorder; var ADone: Boolean);
  private
    FMailFormsManager: TdxMailFormsManager;
    FNavBarHintLink: TdxNavBarItemLink;
    FPrintingFrame: TfrmPrinting;
    FSkinSelector: TdxRibbonSkinSelector;

    procedure SkinSelectorSkinChanged(Sender: TObject; const AArgs: TdxRibbonSkinSelectorSkinChangedArgs);
    procedure SkinSelectorPalletteChanged(Sender: TObject; const AArgs: TdxRibbonSkinSelectorPaletteChangedArgs);

    function GetLookAndFeel: TdxCustomLayoutLookAndFeel;

    function CanShowNodeUnreadCount(ANode: TcxDBTreeListNode; out ACount: Integer): Boolean;
    procedure CheckContentZoomPosition;
    procedure CheckSize;
    procedure CreateBackstageViewExportCalleryGroup;
    function GetActiveFrame: TMailClientDemoBaseFrame;
    procedure SetEventDialogsStyle;
    procedure UpdateContentZoomState(Sender: TObject);
    procedure UpdateGlyphs(AGlyphs: TcxImageCollection; AImages: TcxImageList);
    procedure UpdateIcons;
    procedure UpdateItemCountInfo;
    procedure UpdateMailBadge(ABadge: TdxBadge);
    procedure UpdateMailBadges;
    procedure WMFocusMailMessage(var AMessage: TMessage); message WM_FOCUSMAILMESSAGE;
  protected
   { IcxLookAndFeelNotificationListener }
    function GetObject: TObject;
    procedure MasterLookAndFeelChanged(Sender: TcxLookAndFeel; AChangedValues: TcxLookAndFeelValues);
    procedure MasterLookAndFeelDestroying(Sender: TcxLookAndFeel);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure OpenFrame(AFrameID: Integer);
    function SetNodeCaption(ARootNode: TcxTreeListNode;
      const ASeekID, ACount: Integer; const ACaption: string): Boolean;

    function HasSkinPalette: Boolean;
    procedure Translate;
    procedure TranslationChanged;

    property ActiveFrame: TMailClientDemoBaseFrame read GetActiveFrame;
    property LookAndFeel: TdxCustomLayoutLookAndFeel read GetLookAndFeel;
    property MailFormsManager: TdxMailFormsManager read FMailFormsManager;
    property ScaleFactor;
  end;

const
  ReminderNone = 'None';

var
  fmMailClientDemoMain: TfmMailClientDemoMain;

implementation

uses
  Math, ShellAPI, Types,
  dxSkinInfo,
  DBClient, dxNavBarSkinBasedViews,
  dxmdaset,
  cxSchedulerCustomResourceView, cxSchedulerDayView, cxSchedulerTimeGridView,
  cxSchedulerICalendar, cxSchedulerStrs, cxSchedulerDialogs, dxDemoUtils,
  cxGridDBDataDefinitions, dxMailClientDemoUtils, MailClientDemoBaseGrid, cxDateUtils,
  cxSchedulerEditorFormManager, dxPrnDev, dxPrnDlg, dxPSUtl, dxPSGlbl,
  LocalizationStrs, dxBarStrs;

{$R *.dfm}

type
  TcxTreeListAccess = class(TcxTreeList);
  TCustomdxBarSubItemAccess = class(TCustomdxBarSubItem);
  TdxLayoutSplitterItemAccess = class(TdxLayoutSplitterItem);
  TMailClientDemoFrameManagerAccess = class(TMailClientDemoFrameManager);
  TcxControlAccess = class(TcxControl);

constructor TfmMailClientDemoMain.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMailFormsManager := TdxMailFormsManager.Create;
  DisableAero := True;
//  TdxLayoutSplitterItemAccess(dxLayoutSplitterItem1).DirectAccess := True;
  TdxRibbonSearchToolbarController.TryCreateWithExistingToolbar(dxRibbon1, True);
end;

destructor TfmMailClientDemoMain.Destroy;
begin
  TdxRibbonSearchToolbarController.Finalize;
  inherited Destroy;
end;

procedure TfmMailClientDemoMain.FormCreate(Sender: TObject);
begin
  CheckSize;
  RootLookAndFeel.AddChangeListener(Self);
  CreateBackstageViewExportCalleryGroup;
  tlMail.Root.Expand(True);
  cxGroupBox5.Parent := nil;
//  dxNavBarOfficeNavigationBar1.ItemProvider := dxNavBar1;
  bliFormCorners.ItemIndex := Ord(SkinController.FormCorners);
  TMailClientDemoFrameManagerAccess(dxMailClientDemoFrameManager).CreateFrame(nbgrCalendar.Index);

  FPrintingFrame := TfrmPrinting.Create(Self);
  FPrintingFrame.Align := alClient;
  FPrintingFrame.AlignWithMargins := True;
  FPrintingFrame.Margins.Left := ScaleFactor.Apply(40);
  FPrintingFrame.Margins.Top := ScaleFactor.Apply(8);
  FPrintingFrame.Margins.Bottom := ScaleFactor.Apply(26);
  FPrintingFrame.Margins.Right := ScaleFactor.Apply(40);
  liPrintReport.Control := FPrintingFrame;
  Translate;
  SkinController.ScrollMode := scmSmooth;

  FSkinSelector := CreateSkinSelector(tbColorSchemes);
  FSkinSelector.Links[0].Index := 0;
  FSkinSelector.OnSkinChanged := SkinSelectorSkinChanged;
  FSkinSelector.OnPaletteChanged := SkinSelectorPalletteChanged;

end;

procedure TfmMailClientDemoMain.SkinSelectorSkinChanged(Sender: TObject; const AArgs: TdxRibbonSkinSelectorSkinChangedArgs);
begin
  SetEventDialogsStyle;
  MailFormsManager.SetColorSchemeToRibbons(dxRibbon1.ColorSchemeName);
  stTreeListBackground.Color := TcxControlAccess(tlMail).LookAndFeelPainter.GridLikeControlContentColor;
end;

procedure TfmMailClientDemoMain.SkinSelectorPalletteChanged(Sender: TObject; const AArgs: TdxRibbonSkinSelectorPaletteChangedArgs);
begin
  stTreeListBackground.Color := TcxControlAccess(tlMail).LookAndFeelPainter.GridLikeControlContentColor;
end;

procedure TfmMailClientDemoMain.FormShow(Sender: TObject);
begin
  rtAppointment.Context := dxRibbon1.Contexts[0];
  lbViewNormal.Down := not dxNavBar1.OptionsBehavior.NavigationPane.Collapsed;
  bbTouchMode.Down := SkinController.TouchMode;
  dxNavBar1ActiveGroupChanged(Self);
  if Height > Monitor.Height - 150 then
  begin
    Height := Monitor.Height - 150;
    Top := 0;
  end;
end;

procedure TfmMailClientDemoMain.gbFramesDisplayDragBorder(
  ASender: TdxFramedControl; ABorder: TcxBorder; var ADone: Boolean);
begin
  dxNavBar1.Width := gbFramesDisplay.Left;
end;

procedure TfmMailClientDemoMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  MailFormsManager.TryCloseItems;
  CanClose := MailFormsManager.IsEmpty;
end;

procedure TfmMailClientDemoMain.FormDestroy(Sender: TObject);
begin
  RootLookAndFeel.RemoveChangeListener(Self);
  FreeAndNil(FMailFormsManager);
end;

procedure TfmMailClientDemoMain.dnSchedulerCustomDrawBackground(Sender: TObject; ACanvas: TcxCanvas;
  const ABounds: TRect; var AViewParams: TcxViewParams; var ADone: Boolean);
begin
  ACanvas.FillRect(ABounds, dnScheduler.LookAndFeel.Painter.DefaultContentColor);
  ADone := True;
end;

procedure TfmMailClientDemoMain.dnSchedulerCustomDrawDayNumber(Sender: TObject;
  ACanvas: TcxCanvas; AViewInfo: TcxSchedulerDateNavigatorDayNumberViewInfo; var ADone: Boolean);
begin
  if dxDayOfWeek(AViewInfo.Date) in [dSunday, dSaturday] then
    ACanvas.Font.Color := clRed;
end;

procedure TfmMailClientDemoMain.dnSchedulerSelectionChanged(Sender: TObject;
  const AStart, AFinish: TDateTime);
begin
  dxNavBar1.ActiveGroup := nbgrCalendar;
end;

procedure TfmMailClientDemoMain.dsHelperDataChange(Sender: TObject;
  Field: TField);
begin
  UpdateItemCountInfo;
end;

procedure TfmMailClientDemoMain.dxNavBar1ActiveGroupChanged(Sender: TObject);
begin
  dxMailClientDemoFrameManager.ShowFrame(dxNavBar1.ActiveGroupIndex, gbFramesDisplay);
  ActiveFrame.OnUpdateContentZoomState := UpdateContentZoomState;
  dsHelper.DataSet := ActiveFrame.DataSet;
  Caption := ActiveFrame.Caption;
  CheckContentZoomPosition;
  UpdateIcons;
end;

function TfmMailClientDemoMain.GetLookAndFeel: TdxCustomLayoutLookAndFeel;
begin
  Result := dxLayoutSkinLookAndFeel1;
end;

function TfmMailClientDemoMain.CanShowNodeUnreadCount(ANode: TcxDBTreeListNode; out ACount: Integer): Boolean;
begin
  ACount := StrToIntDef(VarToStr(ANode.Values[tlMailUnreadCountColumn.ItemIndex]), 0);
  Result := (ACount > 0) and (ANode.Values[tlMailBoxKindColumn.ItemIndex] <> bkRoot);
end;

procedure TfmMailClientDemoMain.CheckContentZoomPosition;
begin
  ztbContent.Enabled := ActiveFrame.IsContentZoomSupport;
  if ztbContent.Enabled then
    ztbContent.Position := ActiveFrame.ContentZoomPosition
  else
    ztbContent.Position := 100;
end;

procedure TfmMailClientDemoMain.CheckSize;
begin
  SetBounds(Left, Top, Min(Width, Screen.Width - ScaleFactor.Apply(20)), Min(Height, Screen.Height - ScaleFactor.Apply(20)));
end;

procedure TfmMailClientDemoMain.CreateBackstageViewExportCalleryGroup;

  function GetSupportedExportName(AIndex: TSupportedExportType): string;
  begin
    Result := RemoveAccelChars(cxGetResourceString(SupportedExportNames[AIndex]));
  end;

var
  AGroup: TdxRibbonBackstageViewGalleryGroup;
  AItem: TdxRibbonBackstageViewGalleryItem;
  I: TSupportedExportType;
begin
  AGroup := bvgcExport.Gallery.Groups.Add;
  for I := Low(TSupportedExportType) to High(TSupportedExportType) do
  begin
    AItem := AGroup.Items.Add;
    AItem.Caption := GetSupportedExportName(I);
    AItem.Description := cxGetResourceString(SupportedExportDescriptions[I]);
    AItem.Tag := Integer(I);
    AItem.ImageIndex := 49 + Byte(I);
  end;
end;

function TfmMailClientDemoMain.GetActiveFrame: TMailClientDemoBaseFrame;
begin
  Result := dxMailClientDemoFrameManager.ActiveFrame;
end;

procedure TfmMailClientDemoMain.SetEventDialogsStyle;
var
  ACheckString: string;
begin
  ACheckString := Copy(SkinController.SkinName, 1, 10);
  if ACheckString = 'Office2007' then
    cxSchedulerEditorManager.CurrentEditorFormStyle := 'Ribbon'
  else if ACheckString = 'Office2010' then
    cxSchedulerEditorManager.CurrentEditorFormStyle := 'Ribbon2010'
  else if ACheckString = 'Office2013' then
    cxSchedulerEditorManager.CurrentEditorFormStyle := 'Ribbon2013'
  else
    cxSchedulerEditorManager.CurrentEditorFormStyle := 'Standard';
end;

procedure TfmMailClientDemoMain.UpdateContentZoomState(Sender: TObject);
begin
  CheckContentZoomPosition;
end;

procedure TfmMailClientDemoMain.UpdateGlyphs(AGlyphs: TcxImageCollection; AImages: TcxImageList);

   procedure AssignGlyph(ABar: TdxBar; AImageIndex: Integer);
   var
     AImage: TdxSmartImage;
   begin
     AImage := TdxSmartImage.Create;
     try
       AImages.GetImage(AImageIndex, AImage);
       ABar.Glyph.Assign(AImage);
     finally
       AImage.Free;
     end;
   end;

begin
//  dxRibbon1.ApplicationButton.Glyph.Assign(AGlyphs.Items[0].Picture.Graphic);
//  dxRibbon1.ApplicationButton.Glyph.SourceWidth := 26;
//  dxRibbon1.ApplicationButton.Glyph.SourceHeight := 16;
  //
  AssignGlyph(tbViewNavigation, 57);
  AssignGlyph(tbRibbonOptions, 87);
  AssignGlyph(tbColorSchemes, 64);
  AssignGlyph(tbItemsCount, 85);
  AssignGlyph(tbQuickAccess, 87);
  AssignGlyph(tbQuickAccessToolbarLayout, 84);
  AssignGlyph(tbStatusBarView, 82);
  AssignGlyph(tbTabAreaSearchToolbar, 83);
  AssignGlyph(tbSearchOptions, 83);
end;

procedure TfmMailClientDemoMain.UpdateIcons;
var
  AIsVectorSkin: Boolean;
  AGlyphs: TcxImageCollection;
  ALargeImages, ASmallImages: TcxImageList;
begin
  AIsVectorSkin := (RootLookAndFeel.ActiveStyle = lfsSkin) and (RootLookAndFeel.SkinPainter <> nil) and HasSkinPalette;
  ALargeImages := DM.ilToolbarsLarge;
  ASmallImages := DM.ilToolbarsSmallSVG;
  AGlyphs := dm.icImages;
  if AIsVectorSkin then
  begin
    ALargeImages := DM.ilToolbarsLargeSVG;
    ASmallImages := DM.ilToolbarsSmallSVG;
    AGlyphs := dm.icImagesSVG;
  end;
  if ActiveFrame <> nil then
  begin
    ActiveFrame.bmFrame.LargeImages := ALargeImages;
    ActiveFrame.bmFrame.Images := ASmallImages;
  end;
  FPrintingFrame.Images := ALargeImages;
  bmMain.LargeImages := ALargeImages;
  bvgcExport.Images := bmMain.LargeImages;
  bmMain.Images := ASmallImages;
  UpdateGlyphs(AGlyphs, ASmallImages);
end;

procedure TfmMailClientDemoMain.UpdateItemCountInfo;
begin
  if ActiveFrame <> nil then
    ItemsCountInfo.Caption := ActiveFrame.GetItemCountInfo
  else
    ItemsCountInfo.Caption := '';
end;

procedure TfmMailClientDemoMain.UpdateMailBadge(ABadge: TdxBadge);
const
  ARightIndent = 5;
var
  AX, AY: Integer;
  ARect: TRect;
  ACount: Integer;
  ANode: TcxDBTreeListNode;
begin
  ANode := tlMail.FindNodeByKeyValue(ABadge.Tag);
  if ANode = nil then
    Exit;
  ABadge.Visible := CanShowNodeUnreadCount(ANode, ACount) and ANode.IsVisible;
  if ABadge.Visible then
  begin
    ABadge.Text := IntToStr(ACount);
    ARect := ANode.DisplayRect(True);
    AX := ARect.Right - cxHalfCoordinate(ABadge.Size.Width) - ARightIndent;
    AY := ARect.Top + cxHalfCoordinate(ARect.Bottom - ARect.Top);
    ABadge.Offset.Point := Point(AX, AY);
  end;
end;

procedure TfmMailClientDemoMain.UpdateMailBadges;
var
  I: Integer;
begin
  for I := 0 to amMails.Badges.Count - 1 do
    UpdateMailBadge(amMails.Badges[I]);
end;

procedure TfmMailClientDemoMain.WMFocusMailMessage(var AMessage: TMessage);
begin
  inherited;
  OpenFrame(IDMails);
  ActiveFrame.Perform(AMessage.Msg, AMessage.WParam, AMessage.LParam);
end;

procedure TfmMailClientDemoMain.bNavigationMailClick(Sender: TObject);
begin
  dxNavBar1.ActiveGroupIndex := TdxBarButton(Sender).Tag;
end;

procedure TfmMailClientDemoMain.btnTodayClick(Sender: TObject);
begin
  dnScheduler.InnerDateNavigator.GoToDate(Date, vmDay);
end;

procedure TfmMailClientDemoMain.bvgcExportItemClick(Sender: TObject; AItem: TdxRibbonBackstageViewGalleryItem);
begin
  ActiveFrame.ExportTo(TSupportedExportType(AItem.Tag));
end;

procedure TfmMailClientDemoMain.bvgcOpenItemClick(Sender: TObject; AItem: TdxRibbonBackstageViewGalleryItem);
begin
  odCalendar.InitialDir := GetProgramPath;
  if odCalendar.Execute then
  begin
    ShowHourglassCursor;
    try
      cxSchedulerICalendarImport(DM.SchedulerUnboundStorage, odCalendar.FileName);
      OpenFrame(IDCalendar);
    finally
      HideHourglassCursor;
    end;
  end;
end;

procedure TfmMailClientDemoMain.lbViewNormalClick(Sender: TObject);
begin
  dxNavBar1.OptionsBehavior.NavigationPane.Collapsed := False;
end;

procedure TfmMailClientDemoMain.lbViewReadingClick(Sender: TObject);
begin
  dxNavBar1.OptionsBehavior.NavigationPane.Collapsed := True;
end;

procedure TfmMailClientDemoMain.cxButton1Click(Sender: TObject);
begin
  liCalendar.Visible := False;
end;

procedure TfmMailClientDemoMain.cxButton2Click(Sender: TObject);
begin
  liCalendar.Visible := True;
//  dxNavBarOfficeNavigationBar1.HidePeekForm;
end;

procedure TfmMailClientDemoMain.cxHintStyleController1ShowHint(Sender: TObject;
  var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
begin
  if (HintInfo.HintControl = dxNavBar1) then
    screpNavBar.ShowDescription := FNavBarHintLink <> nil;
  FNavBarHintLink := nil;
end;

procedure TfmMailClientDemoMain.cxTreeList1StylesGetContentStyle(
  Sender: TcxCustomTreeList; AColumn: TcxTreeListColumn;
  ANode: TcxTreeListNode; var AStyle: TcxStyle);
begin
  if Pos('[', ANode.Texts[0]) > 0 then
    AStyle := DM.stUnreadStyle;
end;

procedure TfmMailClientDemoMain.lbRibbonFormClick(Sender: TObject);
begin
  dxRibbon1.SupportNonClientDrawing := not dxRibbon1.SupportNonClientDrawing;
  lbAppButton.Enabled := dxRibbon1.SupportNonClientDrawing;
end;

procedure TfmMailClientDemoMain.lbAppButtonClick(Sender: TObject);
begin
  dxRibbon1.ApplicationButton.Visible := not dxRibbon1.ApplicationButton.Visible;
end;

procedure TfmMailClientDemoMain.lbQuickAccessToolbarVisibleClick(Sender: TObject);
begin
  dxRibbon1.QuickAccessToolbar.Visible := not dxRibbon1.QuickAccessToolbar.Visible;
  lbQuickAccessToolbarAbove.Enabled := dxRibbon1.QuickAccessToolbar.Visible;
  lbQuickAccessToolbarBelow.Enabled := dxRibbon1.QuickAccessToolbar.Visible;
end;

procedure TfmMailClientDemoMain.OpenFrame(AFrameID: Integer);
begin
  RibbonBackstageView.Visible := False;
  dxNavBar1.ActiveGroupIndex := AFrameID;
end;

function TfmMailClientDemoMain.SetNodeCaption(ARootNode: TcxTreeListNode;
  const ASeekID, ACount: Integer; const ACaption: string): Boolean;
var
  I: Integer;
begin
  Result := Integer(ARootNode.Data) = ASeekID;
  if Result then
    if ACount = 0 then
      ARootNode.Texts[0] := ACaption
    else
      ARootNode.Texts[0] := Format('%s[%d]', [ACaption, ACount])
  else
    for I := 0 to ARootNode.Count - 1 do
    begin
      Result := SetNodeCaption(ARootNode.Items[I], ASeekID, ACount, ACaption);
      if Result then
        Break;
    end
end;

procedure TfmMailClientDemoMain.dxNavBar1GetLinkHint(Sender: TObject; ALink: TdxNavBarItemLink; var AHint: String);
var
  AFrame: TMailClientDemoBaseFrame;
begin
  AFrame := ActiveFrame;
  if AFrame is TMailClientDemoTasksFrame then
  begin
    TMailClientDemoTasksFrame(AFrame).GetLinkHint(Sender, ALink, stTaskEmployees, AHint);
    if AHint <> '' then
      FNavBarHintLink := ALink;
  end;
end;

procedure TfmMailClientDemoMain.actPageSetupExecute(Sender: TObject);
begin
  ActiveFrame.ComponentPrinter.PageSetup;
end;

procedure TfmMailClientDemoMain.tlCalendarClick(Sender: TObject);
var
  I: Integer;
begin
  DM.SchedulerUnboundStorage.BeginUpdate;
  try
    for I := 0 to DM.SchedulerUnboundStorage.ResourceCount - 1 do
      with DM.SchedulerUnboundStorage.Resources.ResourceItems[I] do
        Visible := tlCalendar.Root.Items[I div 2].Items[I mod 2].Checked;
  finally
    DM.SchedulerUnboundStorage.EndUpdate;
  end;
end;

procedure TfmMailClientDemoMain.tlMailCustomDrawDataCell(
  Sender: TcxCustomTreeList; ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);
var
  ACount: Integer;
begin
  if CanShowNodeUnreadCount(AViewInfo.Node as TcxDBTreeListNode, ACount) then
    ACanvas.Font.Style := [fsBold];
end;

procedure TfmMailClientDemoMain.tlMailFocusedNodeChanged(
  Sender: TcxCustomTreeList; APrevFocusedNode, AFocusedNode: TcxTreeListNode);

  function GetFilter(AParentNode: TcxDBTreeListNode): string;
  var
    I: Integer;
    ANode: TcxDBTreeListNode;
  begin
    Result := VarToStr(AParentNode.KeyValue);
    for I := 0 to AParentNode.Count - 1 do
    begin
      ANode := AParentNode.Items[I] as TcxDBTreeListNode;
      Result := Format('%s, %s', [Result, GetFilter(ANode)]);
      if AParentNode.ParentKeyValue = 0 then
        Break;
    end;
  end;

var
  AFilter: string;
  ADataSet: TDataSet;
begin
  if ActiveFrame = nil then
    Exit;
  ActiveFrame.BeginFiltering;
  try
    ADataSet := DM.clMails;
    ADataSet.DisableControls;
    try
      AFilter := Format('BoxID in (%s)', [GetFilter(AFocusedNode as TcxDBTreeListNode)]);
      if AFilter <> ADataSet.Filter then
      begin
        ADataSet.Filter := AFilter;
        ADataSet.Filtered := True;
      end;
    finally
      ADataSet.EnableControls;
    end;
  finally
    ActiveFrame.EndFiltering;
  end;
end;

procedure TfmMailClientDemoMain.tlMailLayoutChanged(Sender: TObject);
begin
  UpdateMailBadges;
end;

procedure TfmMailClientDemoMain.tlMailTopRecordIndexChanged(Sender: TObject);
begin
  UpdateMailBadges;
end;

function TfmMailClientDemoMain.HasSkinPalette: Boolean;
var
  AData: TdxSkinInfo;
begin
  Result := RootLookAndFeel.Painter.GetPainterData(AData) and (AData.Skin.ColorPalettes.Count > 1);
end;

procedure TfmMailClientDemoMain.Translate;

  procedure UpdateNavBarGroupLocale(ANavBarGroup: TdxNavBarGroup; const AStr: string);
  begin
    ANavBarGroup.Caption := AStr;
    ANavBarGroup.Hint := AStr;
  end;

begin
  UpdateNavBarGroupLocale(nbgrCalendar, cxGetResourceString(@sMainMenuCalendarCaption));
  UpdateNavBarGroupLocale(nbgrContacts, cxGetResourceString(@sContactsColumn));
  UpdateNavBarGroupLocale(nbgrMail, cxGetResourceString(@sMainMenuMailCaption));
  UpdateNavBarGroupLocale(nbgrTasks, cxGetResourceString(@sMainMenuTasksCaption));
  bNavigationCalendar.Caption := cxGetResourceString(@sMainMenuCalendarCaption);
  bNavigationContacts.Caption := cxGetResourceString(@sContactsColumn);
  bNavigationMail.Caption := cxGetResourceString(@sMainMenuMailCaption);
  bNavigationTasks.Caption := cxGetResourceString(@sMainMenuTasksCaption);
  siNavigation.Caption := cxGetResourceString(@sNavigation);
  dxRibbon1Tab6.Groups[0].Caption := cxGetResourceString(@sNavigation);
  dxRibbon1Tab6.Caption := cxGetResourceString(@sViewButton);
  bvtsInfo.Caption := cxGetResourceString(@sInfo);
  bvtsOpen.Caption := cxGetResourceString(@sOpen);
  bvtsExport.Caption := cxGetResourceString(@sExport);
  bvtsPrint.Caption := cxGetResourceString(@sPrintButton);
  bExit.Caption := cxGetResourceString(@sExit);
  lbViewNormal.Caption := cxGetResourceString(@sNormal);
  lbViewReading.Caption := cxGetResourceString(@sReading);
  tlMailNameColumn.DataBinding.FieldName := cxGetResourceString(@sMailBoxesFieldName);
  UpdateItemCountInfo;
  DM.Translate;
  liInfo.CaptionOptions.Text := cxGetResourceString(@sInfo);
  liSupport.CaptionOptions.Text := cxGetResourceString(@sSupport);
  liLinks.CaptionOptions.Text := cxGetResourceString(@sLinks);
  liOpen.CaptionOptions.Text := cxGetResourceString(@sOpen);
  liPrint.CaptionOptions.Text := cxGetResourceString(@sPrintButton);
  liExport.CaptionOptions.Text := cxGetResourceString(@sExport);
  btnToday.Caption := cxGetResourceString(@dxSBAR_DATETODAY);
  tlCalendar.Root.Items[0].Texts[0] := cxGetResourceString(@sTaskCategoryOffice);
  tlCalendar.Root.Items[0].Items[0].Texts[0] := cxGetResourceString(@sDevelopment);
  tlCalendar.Root.Items[0].Items[1].Texts[0] := cxGetResourceString(@sWebinars);
  tlCalendar.Root.Items[1].Texts[0] := cxGetResourceString(@scxEventLabel2);
  tlCalendar.Root.Items[1].Items[0].Texts[0] := cxGetResourceString(@scxEventLabel7);
  tlCalendar.Root.Items[1].Items[1].Texts[0] := cxGetResourceString(@sFamily);
  TdxOfficeSearchBoxProperties(beiOfficeSearchBox.Properties).Nullstring := cxGetResourceString(@sOfficeSearchBoxNullString);
  FPrintingFrame.Translate;
end;

procedure TfmMailClientDemoMain.TranslationChanged;
begin
  Translate;
end;

function TfmMailClientDemoMain.GetObject: TObject;
begin
  Result := Self;
end;

procedure TfmMailClientDemoMain.MasterLookAndFeelChanged(Sender: TcxLookAndFeel; AChangedValues: TcxLookAndFeelValues);
begin
  UpdateIcons;
end;

procedure TfmMailClientDemoMain.MasterLookAndFeelDestroying(Sender: TcxLookAndFeel);
begin
end;

procedure TfmMailClientDemoMain.lbRecursiveSearchClick(Sender: TObject);
begin
  if lbRecursiveSearch.Down then
    (beiOfficeSearchBox.Properties as TdxOfficeSearchBoxProperties).RecursiveSearch := bTrue
  else
    (beiOfficeSearchBox.Properties as TdxOfficeSearchBoxProperties).RecursiveSearch := bFalse;
end;

procedure TfmMailClientDemoMain.lbShowPathsClick(Sender: TObject);
begin
  (beiOfficeSearchBox.Properties as TdxOfficeSearchBoxProperties).ShowResultPaths := lbShowPaths.Down;
end;

procedure TfmMailClientDemoMain.actPrintPreviewExecute(Sender: TObject);
begin
  ActiveFrame.ComponentPrinter.Preview;
end;

procedure TfmMailClientDemoMain.actQATBelowRibbonExecute(Sender: TObject);
begin
  if TAction(Sender).Tag <> 0 then
    dxRibbon1.QuickAccessToolbar.Position := qtpBelowRibbon
  else
    dxRibbon1.QuickAccessToolbar.Position := qtpAboveRibbon;
end;

procedure TfmMailClientDemoMain.actQATBelowRibbonUpdate(Sender: TObject);
begin
  actQATAboveRibbon.Checked := dxRibbon1.QuickAccessToolbar.Position = qtpAboveRibbon;
  actQATBelowRibbon.Checked := dxRibbon1.QuickAccessToolbar.Position = qtpBelowRibbon;
end;

procedure TfmMailClientDemoMain.dxNavBar1NavigationPaneCollapsed(Sender: TObject);
begin
  lbViewReading.Down := dxNavBar1.OptionsBehavior.NavigationPane.Collapsed;
end;

procedure TfmMailClientDemoMain.dxNavBar1NavigationPaneExpanded(Sender: TObject);
begin
  lbViewNormal.Down := not dxNavBar1.OptionsBehavior.NavigationPane.Collapsed;
end;

procedure TfmMailClientDemoMain.dxNavBarOfficeNavigationBar1QueryPeekFormContent(
  ASender: TObject; ANavigationItem: IdxNavigationItem;
  var AControl: TWinControl);
begin
  if ANavigationItem.Text = nbgrCalendar.Caption then
    AControl := cxGroupBox5;
end;

procedure TfmMailClientDemoMain.RibbonBackstageViewCloseUp(Sender: TObject);
begin
  FPrintingFrame.Initialize(nil, dxRibbon1);
  amMails.Badges.Active := True;
  ActiveFrame.Perform(WM_BACKSTAGEVISIBILITYCHANGED, Integer(False), 0);
end;

procedure TfmMailClientDemoMain.RibbonBackstageViewPopup(Sender: TObject);
begin
  FPrintingFrame.Initialize(ActiveFrame.ComponentPrinter, dxRibbon1);
  if not RibbonBackstageView.IsLoading and bvtsPrint.Active then
    bvtsInfo.Active := True;
  amMails.Badges.Active := False;
  ActiveFrame.Perform(WM_BACKSTAGEVISIBILITYCHANGED, Integer(True), 0);
end;

procedure TfmMailClientDemoMain.dxZoomTrackBar1PropertiesChange(Sender: TObject);
begin
  ActiveFrame.ContentZoomPosition := TdxZoomTrackBar(Sender).Position;
end;

procedure TfmMailClientDemoMain.lblGettingStartedClick(Sender: TObject);
begin
  ShellExecute(0, 'OPEN', PChar('https://www.devexpress.com/go/VCL_Get_Started.aspx'), nil, nil, SW_SHOW);
end;

procedure TfmMailClientDemoMain.lblSupportCenterClick(Sender: TObject);
begin
  Browse(spSupport);
end;

procedure TfmMailClientDemoMain.lblKnowledgeBaseClick(Sender: TObject);
begin
  ShellExecute(0, 'OPEN', PChar('http://search.devexpress.com/'), nil, nil, SW_SHOW);
end;

procedure TfmMailClientDemoMain.lblDXonWebClick(Sender: TObject);
begin
  Browse(spStart);
end;

procedure TfmMailClientDemoMain.lblProductsClick(Sender: TObject);
begin
  Browse(spProducts);
end;

procedure TfmMailClientDemoMain.lblDownloadsClick(Sender: TObject);
begin
  Browse(spDownloads);
end;

procedure TfmMailClientDemoMain.lblClientCenterClick(Sender: TObject);
begin
  Browse(spMyDX);
end;

procedure TfmMailClientDemoMain.bbTouchModeClick(Sender: TObject);
begin
  tlCalendar.HandleNeeded; //#required for ViewInfo calculation
  SkinController.TouchMode := bbTouchMode.Down;
  with TcxTreeListAccess(tlCalendar) do
    Height := ViewInfo.DefaultRowHeight * AbsoluteCount;
end;

procedure TfmMailClientDemoMain.bExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMailClientDemoMain.bliFormCornersClick(Sender: TObject);
begin
  SkinController.FormCorners := TdxFormCorners(bliFormCorners.ItemIndex);
end;

initialization
  TdxVisualRefinements.ApplyLightStyle(True);
  TdxVisualRefinements.Padding := TRect.Create(2, 2, 2, 2);
end.


