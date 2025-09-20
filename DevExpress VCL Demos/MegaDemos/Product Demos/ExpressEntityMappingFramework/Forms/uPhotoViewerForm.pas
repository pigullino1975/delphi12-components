unit uPhotoViewerForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxClasses,
  dxLayoutLookAndFeels, dxLayoutContainer, dxLayoutControl, dxForms, dxNavBar, dxBar, dxGalleryControl, dxCore,
  dxEMF.Types, PhotoViewerClasses, uEntityEditor, dxGallery, cxContainer, cxEdit, cxTrackBar, dxZoomTrackBar, dxStatusBar,
  Vcl.ImgList, cxImageList, System.Actions, Vcl.ActnList, dxRibbon, dxRibbonSkins,
  dxRibbonCustomizationForm, dxGDIPlusClasses, System.ImageList;

const
  MaxGalleryPhotoSize: TSize = (cx: 500; cy: 500);
  MinGalleryPhotoSize: TSize = (cx: 30; cy: 30);

type
  { TPhotoViewerForm }

  TPhotoViewerForm = class(TdxForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList;
    dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel;
    dxGalleryControl1: TdxGalleryControl;
    liGallery: TdxLayoutItem;
    dxBarManager1: TdxBarManager;
    ActionList1: TActionList;
    acAddFiles: TAction;
    acView: TAction;
    acRemove: TAction;
    acRemoveFromAlbum: TAction;
    acMarkAll: TAction;
    acUnmarkAll: TAction;
    acCollage: TAction;
    acSlideShow: TAction;
    acFilm: TAction;
    acExport: TAction;
    acMail: TAction;
    acUpload: TAction;
    acPrint: TAction;
    acAddAlbum: TAction;
    acEditAlbum: TAction;
    acRemoveAlbum: TAction;
    acAddFilter: TAction;
    acEditFilter: TAction;
    acRemoveFilter: TAction;
    acGenerateData: TAction;
    acViewModel: TAction;
    dxRibbon1: TdxRibbon;
    il16Entity: TcxImageList;
    il32Entity: TcxImageList;
    il32: TcxImageList;
    il16: TcxImageList;
    procedure FormShow(Sender: TObject);
    procedure dxGalleryControl1ItemClick(Sender: TObject; AItem: TdxGalleryControlItem);
    procedure dxGalleryControl1DblClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure dxGalleryControl1Click(Sender: TObject);
  strict private const
    DefaultGalleryPhotoSize: TSize = (cx: 250; cy: 250);
  strict private type
    TPopulateGalleryProc = reference to procedure;
  strict private
    FSelectedEntity: TPhotoViewerEntity;
    function GetDialogsLookAndFeel: TcxLookAndFeel;
    function GetGalleryGroups: TdxGalleryControlGroups;
  protected
    function GetGalleryPhotoSize: TSize; virtual;
    procedure GalleryItemDblClickHandler(AItem: TdxGalleryControlItem; AEntity: TPhotoViewerEntity); virtual;
    procedure GalleryItemClickHandler(AItem: TdxGalleryControlItem; AEntity: TPhotoViewerEntity); virtual;
    procedure UpdateControls; virtual;

    function AddGalleryGroup(AEntity: TPhotoViewerEntity; const ACaption: string): TdxGalleryControlGroup;
    function AddPhotoViewerEntity(AEntityClass: TPhotoViewerEntityClass): TPhotoViewerEntity;
    function IsGalleryEmpty: Boolean;
    procedure AddGalleryAlbum(AAlbum: TAlbum);
    procedure AddPhotoInGalleryGroup(AGroup: TdxGalleryControlGroup; APhoto: TPhoto);
    procedure EditPhotoViewerEntity(AEntity: TPhotoViewerEntity);
    procedure MsgDlg(const AText: string);
    procedure PopulateGallery<T: TCustomFilter>(const ACollection: IdxEMFCollection<T>; const AGroupName: string;
      const ASize: TSize; AClear: Boolean); overload;
    procedure PopulateGallery(AProc: TPopulateGalleryProc; const AGlyphSize: TSize; AClear: Boolean = True); overload;
    procedure PopulateGallery(AGalleryControl: TdxGalleryControl; AProc: TPopulateGalleryProc; const AGlyphSize: TSize;
      AClear: Boolean = True); overload;
    procedure PopulateGalleryFromPhotoCollection(const ACollection: IdxEMFCollection<TPhoto>);
    procedure ShowActionDialog(const AText: string);
  public
    class function GetID: Integer; virtual;

    class procedure ExecuteLongOperation(AProc: TProc; const ACaption: string = '');
    class procedure Register;
    class procedure ScaleImage(AInputImage: TdxSmartImage; const AOutputSize: TSize; out AOutputImage: TdxSmartImage);

    procedure PopulateGallery; overload; virtual;

    property DialogsLookAndFeel: TcxLookAndFeel read GetDialogsLookAndFeel;
    property GalleryGroups: TdxGalleryControlGroups read GetGalleryGroups;
    property GalleryPhotoSize: TSize read GetGalleryPhotoSize;
    property SelectedEntity: TPhotoViewerEntity read FSelectedEntity;
  end;

  TPhotoViewerFormClass = class of TPhotoViewerForm;

implementation

{$R *.dfm}

uses
  UITypes, Types, Math, Main, cxGeometry, uDataModule, dxSplashUnit;

{ TPhotoViewerForm }

class function TPhotoViewerForm.GetID: Integer;
begin
  Result := -1;
end;

class procedure TPhotoViewerForm.ExecuteLongOperation(AProc: TProc; const ACaption: string = '');
var
  S: string;
begin
  if ACaption = '' then
    S := 'Loading Data. Please Wait.'
  else
    S := ACaption;
  dxExecuteLongOperation(AProc, S, '');
end;

class procedure TPhotoViewerForm.Register;
begin
  RegisterViewerUnit(Self);
end;

class procedure TPhotoViewerForm.ScaleImage(AInputImage: TdxSmartImage; const AOutputSize: TSize; out AOutputImage: TdxSmartImage);

  procedure CleanError(const AOutputSize: TSize; var ARect: TRect);
  begin
    if cxRectWidth(ARect) - AOutputSize.cx = -1 then
      ARect.Right := ARect.Right + 1;
    if cxRectHeight(ARect) - AOutputSize.cy = -1 then
      ARect.Bottom := ARect.Bottom + 1;
  end;

var
  AGraphic: TGraphic;
  AImage: TdxSmartImage;
  ACanvas: TdxGPCanvas;
  R: TRect;
begin
  AOutputImage := TdxSmartImage.CreateSize(AOutputSize);
  AGraphic := AInputImage;
  AImage := TdxSmartImage.CreateSize(AGraphic.Width, AGraphic.Height);
  try
    AImage.Assign(AGraphic);
    R := cxGetImageRect(cxRect(AOutputSize), AImage.Size, ifmProportionalStretch);
    CleanError(AOutputSize, R);
    AImage.Resize(cxRectWidth(R), cxRectHeight(R));
    ACanvas := AOutputImage.CreateCanvas;
    try
      ACanvas.Clear(clNone);
      ACanvas.Draw(AImage, R);
    finally
      ACanvas.Free;
    end;
  finally
    AImage.Free;
  end;
end;

procedure TPhotoViewerForm.FormHide(Sender: TObject);
begin
  frmMain.dxBarManager1.Unmerge(dxBarManager1);
end;

procedure TPhotoViewerForm.FormShow(Sender: TObject);
var
  ADemoTab: TdxRibbonTab;
begin
  if Parent <> nil then
  begin
    frmMain.dxRibbon1.BeginUpdate;
    frmMain.dxBarManager1.Merge(dxBarManager1);
    ADemoTab := frmMain.dxRibbon1.Tabs.Find('Demo');
    if ADemoTab <> nil then
      ADemoTab.Index := frmMain.dxRibbon1.Tabs.Count - 1;
    frmMain.dxRibbon1.Tabs[0].Active := True;
    frmMain.dxRibbon1.EndUpdate;
    PopulateGallery;
  end;
end;

function TPhotoViewerForm.GetGalleryPhotoSize: TSize;
begin
  Result := DefaultGalleryPhotoSize;
end;

procedure TPhotoViewerForm.GalleryItemDblClickHandler(AItem: TdxGalleryControlItem; AEntity: TPhotoViewerEntity);
begin
// do nothing
end;

procedure TPhotoViewerForm.GalleryItemClickHandler(AItem: TdxGalleryControlItem; AEntity: TPhotoViewerEntity);
begin
  UpdateControls;
end;

procedure TPhotoViewerForm.PopulateGallery;
begin
  GalleryGroups.Clear;
end;

procedure TPhotoViewerForm.UpdateControls;
var
  AItem: TdxGalleryControlItem;
begin
  AItem := dxGalleryControl1.Gallery.GetCheckedItem;
  if (AItem <> nil) and (TPhotoViewerEntity(AItem.Tag) <> nil) then
    FSelectedEntity := TPhotoViewerEntity(AItem.Tag)
  else
    FSelectedEntity := nil;
end;

function TPhotoViewerForm.AddGalleryGroup(AEntity: TPhotoViewerEntity; const ACaption: string): TdxGalleryControlGroup;
begin
  Result := GalleryGroups.Add;
  Result.Caption := ACaption;
  Result.Tag := TdxNativeInt(AEntity);
end;

function TPhotoViewerForm.AddPhotoViewerEntity(AEntityClass: TPhotoViewerEntityClass): TPhotoViewerEntity;
begin
  Result := TEntityEditor.Add(DialogsLookAndFeel, AEntityClass);
end;

function TPhotoViewerForm.IsGalleryEmpty: Boolean;
begin
  Result := (GalleryGroups.Count = 0) or (GalleryGroups.Count > 0) and (GalleryGroups[0].Items.Count = 0);
end;

procedure TPhotoViewerForm.AddGalleryAlbum(AAlbum: TAlbum);
var
  AContent: TAlbumContent;
  AGroup: TdxGalleryControlGroup;
begin
  AGroup := AddGalleryGroup(AAlbum, AAlbum.Description);
  for AContent in AAlbum.Content do
    AddPhotoInGalleryGroup(AGroup, AContent.Photo);
end;

procedure TPhotoViewerForm.AddPhotoInGalleryGroup(AGroup: TdxGalleryControlGroup; APhoto: TPhoto);
var
  AItem: TdxGalleryItem;
  AScaledImage: TdxSmartImage;
begin
  AItem := AGroup.Items.Add;
  AItem.Caption := APhoto.Caption;
  AItem.Hint := APhoto.Caption;
  AItem.Tag := TdxNativeInt(APhoto);
  ScaleImage(APhoto.Image, MaxGalleryPhotoSize, AScaledImage);
  try
    AItem.Glyph.Assign(AScaledImage);
  finally
    AScaledImage.Free;
  end;
end;

procedure TPhotoViewerForm.EditPhotoViewerEntity(AEntity: TPhotoViewerEntity);
begin
  TEntityEditor.Edit(DialogsLookAndFeel, AEntity);
  DataModule1.SaveEntity(AEntity);
end;

procedure TPhotoViewerForm.MsgDlg(const AText: string);
begin
  MessageDlg(AText, mtInformation, [mbOK], 0);
end;

procedure TPhotoViewerForm.dxGalleryControl1Click(Sender: TObject);
begin
  UpdateControls;
end;

procedure TPhotoViewerForm.dxGalleryControl1DblClick(Sender: TObject);
var
  AItem: TdxGalleryControlItem;
begin
  UpdateControls;
  if SelectedEntity <> nil then
  begin
    AItem := dxGalleryControl1.Gallery.GetCheckedItem;
    if (AItem <> nil) and (TPhotoViewerEntity(AItem.Tag) <> nil) then
      GalleryItemDblClickHandler(AItem, SelectedEntity);
  end;
end;

procedure TPhotoViewerForm.dxGalleryControl1ItemClick(Sender: TObject; AItem: TdxGalleryControlItem);
begin
  UpdateControls;
  if SelectedEntity <> nil then
    GalleryItemClickHandler(AItem, SelectedEntity);
end;

procedure TPhotoViewerForm.PopulateGallery<T>(const ACollection: IdxEMFCollection<T>; const AGroupName: string;
  const ASize: TSize; AClear: Boolean);
var
  AItemSize: TSize;
begin
  AItemSize := ASize;
  PopulateGallery(
    procedure
    var
      AGroup: TdxGalleryControlGroup;
      AFilter: T;
      AItem: TdxGalleryControlItem;
      AScaledImage: TdxSmartImage;
    begin
      AGroup := AddGalleryGroup(nil, AGroupName);
      if ACollection <> nil then
        for AFilter in ACollection do
        begin
          AItem := AGroup.Items.Add;
          AItem.Caption := AFilter.Caption;
          AItem.Tag := TdxNativeInt(AFilter);
          ScaleImage(AFilter.Image, AItemSize, AScaledImage);
          try
            AFilter.Apply(AScaledImage, AItem.Glyph);
          finally
            AScaledImage.Free;
          end;
        end;
    end, AItemSize, AClear);
end;

procedure TPhotoViewerForm.PopulateGallery(AProc: TPopulateGalleryProc; const AGlyphSize: TSize; AClear: Boolean = True);
begin
  PopulateGallery(dxGalleryControl1, AProc, AGlyphSize, AClear);
end;

procedure TPhotoViewerForm.PopulateGallery(AGalleryControl: TdxGalleryControl; AProc: TPopulateGalleryProc;
  const AGlyphSize: TSize; AClear: Boolean = True);
var
  AItem: TdxGalleryControlItem;
begin
  if AClear then
    AGalleryControl.Gallery.Groups.Clear;
  AGalleryControl.BeginUpdate;
  try
    AGalleryControl.OptionsView.Item.Image.Size.Size := AGlyphSize;
    if Assigned(AProc) then
      AProc;
    AItem := AGalleryControl.Gallery.GetFirstItem;
    if AItem <> nil then
    begin
      AItem.Checked := True;
      FSelectedEntity := TObject(AItem.Tag) as TPhotoViewerEntity;
    end
    else
      FSelectedEntity := nil;
  finally
    AGalleryControl.EndUpdate;
  end;
  UpdateControls;
end;

procedure TPhotoViewerForm.PopulateGalleryFromPhotoCollection(const ACollection: IdxEMFCollection<TPhoto>);
begin
  PopulateGallery(
    procedure
    var
      AGroup: TdxGalleryControlGroup;
      APhoto: TPhoto;
    begin
      AGroup := AddGalleryGroup(nil, 'All Photos');
      if ACollection <> nil then
        for APhoto in ACollection do
          AddPhotoInGalleryGroup(AGroup, APhoto);
    end, GalleryPhotoSize);
end;

procedure TPhotoViewerForm.ShowActionDialog(const AText: string);
begin
  MsgDlg(Format('Here you can show your own %s dialog.', [AText]));
end;

function TPhotoViewerForm.GetDialogsLookAndFeel: TcxLookAndFeel;
begin
  Result := frmMain.dxBarManager1.LookAndFeel;
end;

function TPhotoViewerForm.GetGalleryGroups: TdxGalleryControlGroups;
begin
  Result := dxGalleryControl1.Gallery.Groups;
end;

end.
