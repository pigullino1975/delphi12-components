unit uEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uPhotoViewerForm, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  dxLayoutContainer, dxRibbonSkins, dxRibbonCustomizationForm, System.Actions, Vcl.ActnList,
  Vcl.ImgList, cxImageList, dxBar, cxClasses, dxLayoutLookAndFeels, dxRibbon, dxGalleryControl, dxLayoutControl,
  dxRibbonGallery, dxLayoutcxEditAdapters, cxContainer, cxEdit, cxImage, uEntityEditor,
  dxGDIPlusClasses, Generics.Defaults, Generics.Collections, PhotoViewerClasses, uFilters, System.ImageList;

type
  { TEditor }

  TEditor = class(TFilters)
    acSaveFile: TAction;
    acCancel: TAction;
    acClose: TAction;
    rgiFilters: TdxRibbonGalleryItem;
    dxGalleryControl2: TdxGalleryControl;
    dxLayoutItem2: TdxLayoutItem;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    dxBarLargeButton4: TdxBarLargeButton;
    dxBarLargeButton5: TdxBarLargeButton;
    dxBarManager1Bar1: TdxBar;
    dxBarLargeButton6: TdxBarLargeButton;
    procedure FormCreate(Sender: TObject);
    procedure dxGalleryControl2ItemClick(Sender: TObject; AItem: TdxGalleryControlItem);
    procedure dxBarLargeButton6Click(Sender: TObject);
  strict private const
    FilterPreviewSize: TSize = (cx: 100; cy: 60);
  strict private
    FStoredCaption: string;
    function GetSelectedPhoto: TPhoto;
    procedure ApplyFilter;
  protected
    procedure GalleryItemClickHandler(AItem: TdxGalleryControlItem; AEntity: TPhotoViewerEntity); override;
    property SelectedPhoto: TPhoto read GetSelectedPhoto;
  public
    class function GetID: Integer; override;

    procedure PopulateGallery(APhotoList: TList<TPhoto>); overload;
  end;

implementation

{$R *.dfm}

uses
  Main, dxCore, uDataModule, uPhotos;

{ TEditor }

procedure TEditor.dxBarLargeButton6Click(Sender: TObject);
begin
  frmMain.ActivateDemo(frmMain.PrevUnitID);
end;

procedure TEditor.dxGalleryControl2ItemClick(Sender: TObject; AItem: TdxGalleryControlItem);
begin
  ApplyFilter;
end;

procedure TEditor.FormCreate(Sender: TObject);
begin
  imPreview.Style.BorderStyle := ebsNone;
  FStoredCaption := Caption;
end;

class function TEditor.GetID: Integer;
begin
  Result := 4;
end;

procedure TEditor.PopulateGallery(APhotoList: TList<TPhoto>);
var
  AItemSize: TSize;
begin
  AItemSize := Size(100, 100);
  PopulateGallery(dxGalleryControl2,
    procedure
    var
      AGroup: TdxGalleryControlGroup;
      APhoto: TPhoto;
      AItem: TdxGalleryControlItem;
      AScaledImage: TdxSmartImage;
    begin
      dxGalleryControl2.OptionsView.ColumnCount := APhotoList.Count;
      AGroup := dxGalleryControl2.Gallery.Groups.Add;
      AGroup.ShowCaption := False;
      for APhoto in APhotoList do
      begin
        AItem := AGroup.Items.Add;
        AItem.Caption := APhoto.Caption;
        AItem.Tag := TdxNativeInt(APhoto);
        ScaleImage(APhoto.Image, AItemSize, AScaledImage);
        try
          AItem.Glyph.Assign(AScaledImage);
        finally
          AScaledImage.Free;
        end;
      end;
    end, Size(100, 100), True);
end;

procedure TEditor.GalleryItemClickHandler(AItem: TdxGalleryControlItem; AEntity: TPhotoViewerEntity);
begin
  ApplyFilter;
end;

function TEditor.GetSelectedPhoto: TPhoto;
var
  AItem:TdxGalleryControlItem;
begin
  AItem := dxGalleryControl2.Gallery.GetCheckedItem;
  if (AItem <> nil) and (TObject(AItem.Tag) is TPhoto) then
    Result := TPhoto(AItem.Tag)
  else
    Result := nil;
end;

procedure TEditor.ApplyFilter;
var
  AFilter: TCustomFilter;
  APhoto: TPhoto;
begin
  AFilter := SelectedFilter;
  if AFilter = nil then
    AFilter := SelectedEffect;
  APhoto := SelectedPhoto;
  if (AFilter <> nil) and (APhoto <> nil) then
    AFilter.Apply(APhoto.Image, imPreview.Picture);
  UpdateControls;
end;

initialization
  TEditor.Register;

end.
