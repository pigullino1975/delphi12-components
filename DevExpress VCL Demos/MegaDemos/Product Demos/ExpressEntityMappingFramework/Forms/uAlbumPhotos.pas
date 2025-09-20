unit uAlbumPhotos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uPhotoViewerForm, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  dxLayoutContainer, cxClasses, dxLayoutLookAndFeels, dxGallery, dxGalleryControl, dxLayoutControl,
  dxLayoutcxEditAdapters, cxContainer, cxEdit, cxImage, cxLabel, dxRatingControl, cxGroupBox, dxImageSlider,
  dxEMF.Types, PhotoViewerClasses, uEntityEditor, Vcl.ImgList, cxImageList, cxCheckBox, dxToggleSwitch,
  cxTrackBar, dxZoomTrackBar, dxRibbonSkins, dxRibbonCustomizationForm, dxRibbon, dxBar, System.Actions, Vcl.ActnList,
  uPhotoBaseForm, dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg, dxBkgnd, dxWrap, dxPrnDev, dxPSCompsProvider, dxPSFillPatterns,
  dxPSEdgePatterns, dxPSPDFExportCore, dxPSPDFExport, cxDrawTextUtils, dxPSPrVwStd, dxPSPrVwAdv, dxPSPrVwRibbon,
  dxPScxPageControlProducer, dxPScxEditorLnks, dxPScxEditorProducers, dxPScxExtEditorProducers, dxPSGraphicLnk, dxPSCore,
  System.ImageList;

type
  { TAlbumPhotos }

  TAlbumPhotos = class(TPhotoBaseForm)
    cxGroupBox2: TcxGroupBox;
    rcRating: TdxRatingControl;
    lblImageFileName: TcxLabel;
    lblImageFileInfo: TcxLabel;
    liProperties: TdxLayoutItem;
    imPreview: TcxImage;
    dxLayoutItem1: TdxLayoutItem;
    lgPreview: TdxLayoutGroup;
    tsShowPreview: TdxToggleSwitch;
    dxLayoutItem2: TdxLayoutItem;
    dxLayoutSplitterItem1: TdxLayoutSplitterItem;
    dxLayoutGroup1: TdxLayoutGroup;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    rtAlbum: TdxRibbonTab;
    dxBarLargeButton15: TdxBarLargeButton;
    dxBarLargeButton16: TdxBarLargeButton;
    dxBarLargeButton17: TdxBarLargeButton;
    dxBarLargeButton19: TdxBarLargeButton;
    dxBarLargeButton20: TdxBarLargeButton;
    dxBarLargeButton21: TdxBarLargeButton;
    dxBarLargeButton22: TdxBarLargeButton;
    dxBarManager1Bar5: TdxBar;
    dxBarLargeButton23: TdxBarLargeButton;
    dxBarLargeButton24: TdxBarLargeButton;
    dxBarLargeButton25: TdxBarLargeButton;
    dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup;
    procedure FormCreate(Sender: TObject);
    procedure tsShowPreviewPropertiesChange(Sender: TObject);
    procedure acAddAlbumExecute(Sender: TObject);
    procedure acEditAlbumExecute(Sender: TObject);
    procedure acRemoveAlbumExecute(Sender: TObject);
    procedure rcRatingPropertiesChange(Sender: TObject);
  strict private type
    TGalleryAlbumForEachProc = reference to procedure (AGroup: TdxGalleryGroup; AAlbum: TAlbum);
  strict private
    FAlbumID: Integer;
    procedure SetAlbumID(const AValue: Integer);
  protected
    function GetSelectedAlbum: TAlbum; override;
    procedure UpdateControls; override;

    procedure ForGalleryAlbum(AProc: TGalleryAlbumForEachProc; AAlbum: TAlbum; out AFound: Boolean);

    procedure UpdateAlbum(AAlbum: TAlbum);
    procedure UpdatePhotoInfo(AEntity: TPhotoViewerEntity);
  public
    class function GetID: Integer; override;
    procedure PopulateGallery; override;

    property AlbumID: Integer read FAlbumID write SetAlbumID;
  end;

implementation

{$R *.dfm}

uses
  IOUtils, dxGDIPlusClasses, Main, uDataModule;

{ TAlbumContent }

class function TAlbumPhotos.GetID: Integer;
begin
  Result := 2;
end;

procedure TAlbumPhotos.PopulateGallery;
begin
  inherited PopulateGallery;
  if FAlbumID <> -MaxInt then
    PopulateGallery(DataModule1.GetAlbum(AlbumID));
end;

procedure TAlbumPhotos.rcRatingPropertiesChange(Sender: TObject);
begin
  UpdatePhotoRating(rcRating.EditValue);
end;

procedure TAlbumPhotos.acAddAlbumExecute(Sender: TObject);
var
  AAlbum: TAlbum;
begin
  AAlbum := AddPhotoViewerEntity(TAlbum) as TAlbum;
  if AAlbum <> nil then
  begin
    DataModule1.SaveEntity(AAlbum);
    UpdateAlbum(AAlbum);
  end;
end;

procedure TAlbumPhotos.acEditAlbumExecute(Sender: TObject);
var
  AAlbum: TAlbum;
begin
  AAlbum := SelectedAlbum;
  if AAlbum <> nil then
  begin
    EditPhotoViewerEntity(AAlbum);
    UpdateAlbum(AAlbum);
  end;
end;

procedure TAlbumPhotos.acRemoveAlbumExecute(Sender: TObject);
var
  AAlbum: TAlbum;
  AFound: Boolean;
begin
  AAlbum := SelectedAlbum;
  ForGalleryAlbum(
    procedure (AGroup: TdxGalleryGroup; AAlbum: TAlbum)
    begin
      GalleryGroups.Delete(AGroup.Index);
    end, AAlbum, AFound);
  frmMain.DeleteAlbum(SelectedAlbum);
  UpdateControls;
end;

procedure TAlbumPhotos.FormCreate(Sender: TObject);
begin
  FAlbumID := frmMain.AlbumID;
  tsShowPreview.Checked := True;
  imPreview.Style.BorderStyle := ebsNone;
  cxGroupBox2.Style.BorderStyle := ebsNone;
end;

procedure TAlbumPhotos.ForGalleryAlbum(AProc: TGalleryAlbumForEachProc; AAlbum: TAlbum; out AFound: Boolean);
var
  I: Integer;
begin
  AFound := False;
  for I := 0 to GalleryGroups.Count - 1 do
    if (TObject(GalleryGroups[I].Tag) <> nil) and (TObject(GalleryGroups[I].Tag) is TAlbum) then
    begin
      AFound := TAlbum(GalleryGroups[I].Tag).ID = AAlbum.ID;
      if AFound then
      begin
        AProc(GalleryGroups[I], AAlbum);
        Break;
      end;
    end;
end;

procedure TAlbumPhotos.UpdateAlbum(AAlbum: TAlbum);
var
  AFound: Boolean;
begin
  ForGalleryAlbum(
    procedure (AGroup: TdxGalleryGroup; AAlbum: TAlbum)
    begin
      AGroup.Caption := AAlbum.Description;
    end, AAlbum, AFound);
  frmMain.UpdateAlbum(AAlbum);
end;

procedure TAlbumPhotos.UpdatePhotoInfo(AEntity: TPhotoViewerEntity);
var
  APhoto: TPhoto;
begin
  APhoto := AEntity as TPhoto;
  imPreview.Visible := APhoto <> nil;
  cxGroupBox2.Visible := imPreview.Visible;
  if imPreview.Visible then
  begin
    imPreview.Picture.Assign(APhoto.Image);
    lblImageFileName.Caption := APhoto.Caption;
    lblImageFileInfo.Caption := APhoto.Description;
    rcRating.EditValue := APhoto.Rating;
  end
  else
  begin
    imPreview.Clear;
    lblImageFileName.Caption := '';
    lblImageFileInfo.Caption := lblImageFileName.Caption;
    rcRating.EditValue := 0;
  end;
end;

procedure TAlbumPhotos.UpdateControls;
begin
  inherited UpdateControls;
  UpdatePhotoInfo(SelectedPhoto);
  acEditAlbum.Enabled := frmMain.nbgAlbums.LinkCount > 0;
  acRemoveAlbum.Enabled := acEditAlbum.Enabled;
end;

procedure TAlbumPhotos.tsShowPreviewPropertiesChange(Sender: TObject);
begin
  lgPreview.Visible := tsShowPreview.Checked;
  dxLayoutSplitterItem1.Visible := lgPreview.Visible;
end;

function TAlbumPhotos.GetSelectedAlbum: TAlbum;
begin
  Result := DataModule1.GetAlbumByID(FAlbumID);
end;

procedure TAlbumPhotos.SetAlbumID(const AValue: Integer);
begin
  if FAlbumID <> AValue then
  begin
    FAlbumID := AValue;
    PopulateGallery;
  end;
end;

initialization
  TAlbumPhotos.Register;

end.
