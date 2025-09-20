unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, 
  dxBar, dxRibbon, dxRibbonForm, dxRibbonSkins, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxClasses, dxRibbonBackstageView, cxBarEditItem,
  dxRibbonCustomizationForm, cxTextEdit, cxContainer, cxEdit, dxSkinsForm,
  dxStatusBar, dxRibbonStatusBar, cxLabel, dxGallery, dxGalleryControl,
  dxRibbonBackstageViewGalleryControl, dxLayoutcxEditAdapters,
  dxLayoutLookAndFeels, dxLayoutContainer, cxTrackBar, dxRatingControl,
  ExtCtrls, dxNavBarCollns, dxNavBarBase, dxNavBar, cxImage, cxGroupBox,
  dxLayoutControl, ImgList, cxImageList, System.Actions,
  ActnList, dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg, dxBkgnd, dxWrap, dxPrnDev,
  dxPSCompsProvider, dxPSFillPatterns, dxPSEdgePatterns, dxPSPDFExportCore,
  dxPSPDFExport, cxDrawTextUtils, dxPSPrVwStd, dxPSPrVwAdv, dxPSPrVwRibbon,
  dxPScxPageControlProducer, dxPScxEditorProducers, dxPScxExtEditorProducers,
  dxPSCore, dxPScxEditorLnks, dxPSGraphicLnk, dxGDIPlusClasses,
  PhotoViewerClasses, uDataModule, dxEMF.Types, dxNavBarStyles, uEntityEditor,
  Generics.Defaults, Generics.Collections, cxPC, dxDockControl, dxDockPanel,
  cxStyles, cxSchedulerStorage, cxSchedulerCustomControls,
  cxSchedulerDateNavigator, cxDateNavigator, ComCtrls, dxCore, cxDateUtils,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxCheckBox, Menus, StdCtrls,
  cxButtons, dxZoomTrackBar, DB,
  uPhotoViewerForm, dxLayoutControlAdapters, System.ImageList, uModelViewer;

type
  { TPhotoViewerUnitInfo }

  TPhotoViewerUnitInfo = class
  protected
    UnitClass: TPhotoViewerFormClass;
  public
    UnitInstance: TPhotoViewerForm;

    constructor Create(AClass: TPhotoViewerFormClass);
    destructor Destroy; override;

    procedure SetParent(AParent: TWinControl);
  end;

  { TfrmMain }

  TfrmMain = class(TdxRibbonForm)
    dxBarManager1: TdxBarManager;
    dxRibbon1: TdxRibbon;
    dxSkinController1: TdxSkinController;
    cxBarEditItem1: TcxBarEditItem;
    lcMain: TdxLayoutControl;
    lcMainGroup_Root: TdxLayoutGroup;
    dxLayoutMainLookAndFeelList1: TdxLayoutLookAndFeelList;
    dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel;
    rtDemo: TdxRibbonTab;
    bmbSkins: TdxBar;
    bmbInfo: TdxBar;
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    dxBarLargeButton3: TdxBarLargeButton;
    dxBarLargeButton4: TdxBarLargeButton;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    dxBarButton6: TdxBarButton;
    dxBarLargeButton5: TdxBarLargeButton;
    dxBarButton7: TdxBarButton;
    dxBarSubItem2: TdxBarSubItem;
    dxBarButton8: TdxBarButton;
    dxBarButton9: TdxBarButton;
    dxBarLargeButton6: TdxBarLargeButton;
    dxBarButton10: TdxBarButton;
    dxBarLargeButton7: TdxBarLargeButton;
    il16: TcxImageList;
    dxBarButton11: TdxBarButton;
    il32: TcxImageList;
    dxBarLargeButton8: TdxBarLargeButton;
    dxBarLargeButton9: TdxBarLargeButton;
    dxBarLargeButton10: TdxBarLargeButton;
    dxBarLargeButton11: TdxBarLargeButton;
    dxBarLargeButton12: TdxBarLargeButton;
    bsiAddToAlbum: TdxBarSubItem;
    dxBarLargeButton13: TdxBarLargeButton;
    dxBarLargeButton14: TdxBarLargeButton;
    dxBarLargeButton15: TdxBarLargeButton;
    dxBarLargeButton16: TdxBarLargeButton;
    dxBarButton12: TdxBarButton;
    dxBarLargeButton17: TdxBarLargeButton;
    dxBarLargeButton18: TdxBarLargeButton;
    dxBarLargeButton19: TdxBarLargeButton;
    dxBarLargeButton20: TdxBarLargeButton;
    dxBarLargeButton21: TdxBarLargeButton;
    dxBarLargeButton22: TdxBarLargeButton;
    dxBarLargeButton23: TdxBarLargeButton;
    dxBarLargeButton24: TdxBarLargeButton;
    dxComponentPrinter1: TdxComponentPrinter;
    dxComponentPrinter1Link1: TdxCompositionReportLink;
    dxComponentPrinter1Link2: TcxImageReportLink;
    dxBarLargeButton25: TdxBarLargeButton;
    dxBarLargeButton26: TdxBarLargeButton;
    dxBarLargeButton27: TdxBarLargeButton;
    dxBarLargeButton28: TdxBarLargeButton;
    dxBarLargeButton29: TdxBarLargeButton;
    dxBarLargeButton30: TdxBarLargeButton;
    NavBar: TdxNavBar;
    nbgAlbums: TdxNavBarGroup;
    nbsItemStyle: TdxNavBarStyleItem;
    nbsGroupStyle: TdxNavBarStyleItem;
    dxLayoutItem2: TdxLayoutItem;
    nbgLibrary: TdxNavBarGroup;
    dxBarButton13: TdxBarButton;
    dxBarButton14: TdxBarButton;
    nbiPhotos: TdxNavBarItem;
    nbiEffectsAndFilters: TdxNavBarItem;
    dxBarButton15: TdxBarButton;
    dxBarLargeButton31: TdxBarLargeButton;
    dxBarLargeButton32: TdxBarLargeButton;
    dxBarLargeButton33: TdxBarLargeButton;
    dxBarManager1Bar3: TdxBar;
    dxBarLargeButton34: TdxBarLargeButton;
    bbViewModel: TdxBarLargeButton;
    dxBarLargeButton36: TdxBarLargeButton;
    dxBarButton16: TdxBarButton;
    dxBarButton17: TdxBarButton;
    ActionList1: TActionList;
    dxLayoutItem1: TdxLayoutItem;
    liDescription: TdxLayoutLabeledItem;
    lagContent: TdxLayoutAutoCreatedGroup;
    acShowModel: TAction;
    pnlViewerUnitSite: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure NavBarLinkClick(Sender: TObject; ALink: TdxNavBarItemLink);
    procedure NavBarActiveGroupChanged(Sender: TObject);
    procedure acGenerateDataExecute(Sender: TObject);
    procedure acShowModelExecute(Sender: TObject);
  strict private type
    TForEachNavBarAlbumItemProc = reference to procedure (AItem: TdxNavBarItem; AAlbum: TAlbum);
  strict private
    FAlbumID: Integer;
    FLockCount: Integer;
    FPrevUnitID: Integer;
    FViewerUnit: TPhotoViewerUnitInfo;

    function GetActiveFrameID: Integer;
    function GetMainFormCaption: string;
    function GetViewerUnitCaption: string;
    procedure SetActiveFrameID(const AValue: Integer);
    procedure SetViewerUnit(const AValue: TPhotoViewerUnitInfo);

    function Locked: Boolean;
    function FindUnitByID(ID: Integer; out AUnit: TPhotoViewerUnitInfo): Boolean;
    function ForNavBarAlbum(AProc: TForEachNavBarAlbumItemProc; AAlbum: TAlbum): Boolean;
    procedure AddNavBarAlbum(AGroup: TdxNavBarGroup; AAlbum: TAlbum);
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure UpdateNavBar(const ACollection: IdxEMFCollection<TAlbum>);
    procedure UpdateNavBarAlbums;

    procedure AlbumClickHandler(Sender: TObject);
  protected
    property ActiveFrameID: Integer read GetActiveFrameID write SetActiveFrameID;
    property MainFormCaption: string read GetMainFormCaption;
    property ViewerUnitCaption: string read GetViewerUnitCaption;
  public
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;

    procedure ActivateDemo(AID: Integer);
    procedure DeleteAlbum(AAlbum: TAlbum);
    procedure UpdateAlbum(AAlbum: TAlbum);
    procedure UpdateViewModelButton(AChecked: Boolean);

    property AlbumID: Integer read FAlbumID;
    property PrevUnitID: Integer read FPrevUnitID;
    property ViewerUnit: TPhotoViewerUnitInfo read FViewerUnit write SetViewerUnit;

    procedure ModelViewerShowHandler(Sender: TObject);
    procedure ModelViewerCloseHandler(Sender: TObject; var Action: TCloseAction);
  end;

var
  frmMain: TfrmMain;

procedure RegisterViewerUnit(AClass: TPhotoViewerFormClass);

implementation

{$R *.dfm}

uses
  RTLConsts, UITypes, Types, IOUtils, Math, ShellAPI, dxCoreClasses, cxGeometry, dxGDIPlusAPI, dxEMF.DB.Criteria,
  dxDemoUtils, uSlideShow, uAlbumPhotos, dxSplashUnit;

var
  FPhotoViewerUnits: TdxFastObjectList;

function PhotoViewerUnits: TdxFastObjectList;
begin
  if FPhotoViewerUnits = nil then
    FPhotoViewerUnits := TdxFastObjectList.Create;
  Result := FPhotoViewerUnits;
end;

procedure RegisterViewerUnit(AClass: TPhotoViewerFormClass);
var
  AInfo: TPhotoViewerUnitInfo;
begin
  AInfo := TPhotoViewerUnitInfo.Create(AClass);
  AInfo.SetParent(nil);
  PhotoViewerUnits.Add(AInfo);
end;

{ TPhotoViewerUnitInfo }

constructor TPhotoViewerUnitInfo.Create(AClass: TPhotoViewerFormClass);
begin
  inherited Create;
  UnitClass := AClass;
end;

destructor TPhotoViewerUnitInfo.Destroy;
begin
  SetParent(nil);
  inherited Destroy;
end;

procedure TPhotoViewerUnitInfo.SetParent(AParent: TWinControl);
begin
  if (AParent <> nil) and (UnitInstance = nil) then
  begin
    UnitInstance := UnitClass.Create(nil);
    UnitInstance.Visible := False;
  end;
  if AParent = nil then
    FreeAndNil(UnitInstance)
  else
    if UnitInstance <> nil then
    begin
      UnitInstance.Parent := AParent;
      UnitInstance.SendToBack;
      UnitInstance.Visible := True;
      UnitInstance.BringToFront;
      UnitInstance.Update;
    end;
end;

{ TfrmMain }

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  RootLookAndFeel.AddChangeListener(Self);
end;

destructor TfrmMain.Destroy;
begin
  ViewerUnit.SetParent(nil);
  RootLookAndFeel.RemoveChangeListener(Self);
  inherited Destroy;
end;

procedure TfrmMain.UpdateAlbum(AAlbum: TAlbum);
begin
  if not ForNavBarAlbum(
    procedure (AItem: TdxNavBarItem; AAlbum: TAlbum)
    begin
      AItem.Caption := AAlbum.Caption;
    end, AAlbum) then
    AddNavBarAlbum(nbgAlbums, AAlbum);
end;

procedure TfrmMain.UpdateViewModelButton(AChecked: Boolean);
begin
  acShowModel.Checked := AChecked;
end;

procedure TfrmMain.acShowModelExecute(Sender: TObject);
begin
  if FModelViewer.Visible then
    FModelViewer.Close
  else
    FModelViewer.Show;
end;

procedure TfrmMain.ActivateDemo(AID: Integer);
begin
  TPhotoViewerForm.ExecuteLongOperation(
    procedure
    begin
      ActiveFrameID := AID;
    end);
end;

procedure TfrmMain.DeleteAlbum(AAlbum: TAlbum);
begin
  if AAlbum <> nil then
  begin
    ForNavBarAlbum(
      procedure (AItem: TdxNavBarItem; AAlbum: TAlbum)
      begin
        NavBar.Items.Remove(AItem);
      end, AAlbum);
    DataModule1.DeleteEntity(AAlbum);
    if nbgAlbums.LinkCount > 0 then
    begin
      NavBarLinkClick(NavBar, nbgAlbums.Links[0]);
      AlbumClickHandler(nbgAlbums.Links[0].Item);
    end;
  end;
end;

procedure TfrmMain.acGenerateDataExecute(Sender: TObject);
begin
  DataModule1.RestoreOriginalContent(True);
  ViewerUnit := nil;
  UpdateNavBarAlbums;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FLockCount := 0;
  FPrevUnitID := -MaxInt;
  DisableAero := True;
  dxSkinController1.NativeStyle := False;
  dxSkinController1.SkinName := sdxFirstSelectedSkinName;
  CreateSkinsMenuItems(dxBarManager1, bmbSkins, dxSkinController1, dxRibbon1, True);
  CreateHelpMenuItems(dxBarManager1, dxRibbon1, bmbInfo, True);
  Caption := MainFormCaption;
  UpdateNavBarAlbums;
  dxSkinController1.ScrollMode := scmSmooth;
end;

procedure TfrmMain.NavBarActiveGroupChanged(Sender: TObject);
begin
  if NavBar.ActiveGroup.LinkCount > 0 then
    NavBarLinkClick(NavBar, NavBar.ActiveGroup.Links[0]);
end;

procedure TfrmMain.NavBarLinkClick(Sender: TObject; ALink: TdxNavBarItemLink);
begin
  ALink.Selected := True;
  ActivateDemo(ALink.Item.Tag);
end;

procedure TfrmMain.UpdateNavBarAlbums;
begin
  BeginUpdate;
  UpdateNavBar(DataModule1.GetAlbumCollection);
  EndUpdate;
  NavBarActiveGroupChanged(NavBar);
end;

procedure TfrmMain.UpdateNavBar(const ACollection: IdxEMFCollection<TAlbum>);
var
  AAlbum: TAlbum;
begin
  NavBar.BeginUpdate;
  try
    nbgAlbums.ClearLinks;
    while not nbgAlbums.LinkCount > 0 do
      nbgAlbums.Links[0].Item.Free;
    for AAlbum in ACollection do
      AddNavBarAlbum(nbgAlbums, AAlbum);
  finally
    NavBar.EndUpdate;
  end;
end;

procedure TfrmMain.AddNavBarAlbum(AGroup: TdxNavBarGroup; AAlbum: TAlbum);
var
  AItem: TdxNavBarItem;
begin
  AItem := NavBar.Items.Add;
  AItem.Caption := AAlbum.Caption;
  AItem.Tag := TdxNativeInt(AAlbum);
  AItem.CustomStyles.Item := nbsItemStyle;
  AItem.CustomStyles.ItemDisabled := nbsItemStyle;
  AItem.CustomStyles.ItemHotTracked := nbsItemStyle;
  AItem.CustomStyles.ItemPressed := nbsItemStyle;
  AItem.OnClick := AlbumClickHandler;
  AGroup.InsertLink(AItem, nbgAlbums.LinkCount).Selected := True;
  AlbumClickHandler(AItem);
end;

procedure TfrmMain.BeginUpdate;
begin
  Inc(FLockCount);
end;


procedure TfrmMain.EndUpdate;
begin
  Dec(FLockCount);
end;

function TfrmMain.ForNavBarAlbum(AProc: TForEachNavBarAlbumItemProc; AAlbum: TAlbum): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to NavBar.Items.Count - 1 do
  begin
    Result := (TObject(NavBar.Items[I].Tag) <> nil) and (TAlbum(NavBar.Items[I].Tag) = AAlbum);
    if Result then
    begin
      AProc(NavBar.Items[I], AAlbum);
      Break;
    end;
  end;
end;

function TfrmMain.GetActiveFrameID: Integer;
begin
  if ViewerUnit <> nil then
    Result := ViewerUnit.UnitClass.GetID
  else
    Result := -MaxInt;
end;

function TfrmMain.GetMainFormCaption: string;
begin
  Result := 'Photo Viewer';
end;

function TfrmMain.GetViewerUnitCaption: string;
begin
  if ViewerUnit <> nil then
    Result := ViewerUnit.UnitInstance.Caption
  else
    Result := '';
end;

procedure TfrmMain.SetActiveFrameID(const AValue: Integer);
var
  AUnit: TPhotoViewerUnitInfo;
begin
  if (ActiveFrameID <> AValue) and FindUnitByID(AValue, AUnit) then
    ViewerUnit := AUnit;
end;

procedure TfrmMain.SetViewerUnit(const AValue: TPhotoViewerUnitInfo);
var
  APrevUnit: TPhotoViewerUnitInfo;
begin
  if ViewerUnit = AValue then
    Exit;
  APrevUnit := FViewerUnit;
  FViewerUnit := AValue;
  if APrevUnit <> nil then
  begin
    FPrevUnitID := APrevUnit.UnitClass.GetID;
    APrevUnit.SetParent(nil);
  end;
  if ViewerUnit <> nil then
    ViewerUnit.SetParent(pnlViewerUnitSite);
  Caption := MainFormCaption + ' - ' + ViewerUnitCaption;
end;

function TfrmMain.Locked: Boolean;
begin
  Result := FLockCount <> 0;
end;

procedure TfrmMain.ModelViewerCloseHandler(Sender: TObject; var Action: TCloseAction);
begin
  UpdateViewModelButton(False);
end;

procedure TfrmMain.ModelViewerShowHandler(Sender: TObject);
begin
  UpdateViewModelButton(True);
end;

function TfrmMain.FindUnitByID(ID: Integer; out AUnit: TPhotoViewerUnitInfo): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 0 to FPhotoViewerUnits.Count - 1 do
  begin
    AUnit := TPhotoViewerUnitInfo(FPhotoViewerUnits[I]);
    if ID = AUnit.UnitClass.GetID then
      Exit;
  end;
  Result := False;
end;

procedure TfrmMain.AlbumClickHandler(Sender: TObject);
var
  AItem: TdxNavBarItem;
begin
  if not Locked then
  begin
    AItem := Sender as TdxNavBarItem;
    if AItem <> nil then
    begin
      FAlbumID := TAlbum(AItem.Tag).ID;
      if ActiveFrameID <> TAlbumPhotos.GetID then
        ActivateDemo(TAlbumPhotos.GetID)
      else
        TAlbumPhotos(ViewerUnit.UnitInstance).AlbumID := FAlbumID;
    end;
  end;
end;

initialization
  dxMegaDemoProductIndex := dxEMFIndex;

finalization
  FPhotoViewerUnits.Free;

end.

