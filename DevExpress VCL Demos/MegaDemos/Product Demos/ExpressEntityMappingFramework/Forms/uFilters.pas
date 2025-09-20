unit uFilters;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uAlbumPhotos, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, dxLayoutContainer, dxLayoutcxEditAdapters, System.ImageList, Vcl.ImgList, cxImageList, cxClasses,
  dxLayoutLookAndFeels, cxTrackBar, dxZoomTrackBar, cxCheckBox, dxToggleSwitch, cxImage, cxLabel, dxRatingControl,
  cxGroupBox, dxGallery, dxGalleryControl, dxGDIPlusClasses, dxLayoutControl, dxEMF.Types, PhotoViewerClasses,
  uEntityEditor, dxRibbonSkins, dxRibbonCustomizationForm, dxRibbon, dxBar, System.Actions, Vcl.ActnList, uPhotoViewerForm;

type
  { TFilters }

  TFilters = class(TPhotoViewerForm)
    rtFilter: TdxRibbonTab;
    imPreview: TcxImage;
    dxLayoutItem1: TdxLayoutItem;
    bmbFilterGeneral: TdxBar;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    dxBarLargeButton3: TdxBarLargeButton;
    bpmFilterPopupMenu: TdxBarPopupMenu;
    procedure acAddFilterExecute(Sender: TObject);
    procedure acEditFilterExecute(Sender: TObject);
    procedure acRemoveFilterExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
  strict private const
    DefaultGalleryFilterPreviewSize: TSize = (cx: 100; cy: 60);
  strict private
    function GetSelectedCustomFilter(AItem: TdxGalleryControlItem): TCustomFilter;
    function GetSelectedEffect: TEffect;
    function GetSelectedFilter: TFilter;
    procedure PopulateEffectsAndFilters;
    procedure UpdateFilterPreview(AImage: TdxSmartImage);
  protected
    procedure GalleryItemDblClickHandler(AItem: TdxGalleryControlItem; AEntity: TPhotoViewerEntity); override;
    procedure GalleryItemClickHandler(AItem: TdxGalleryControlItem; AEntity: TPhotoViewerEntity); override;
    procedure UpdateControls; override;
  public
    class function GetID: Integer; override;
    procedure PopulateGallery; override;

    property SelectedEffect: TEffect read GetSelectedEffect;
    property SelectedFilter: TFilter read GetSelectedFilter;
  end;

implementation

{$R *.dfm}

uses
  dxCore, uDataModule;

{ TFilters }

class function TFilters.GetID: Integer;
begin
  Result := 3;
end;

procedure TFilters.PopulateGallery;
begin
  inherited PopulateGallery;
  PopulateEffectsAndFilters;
end;

procedure TFilters.acAddFilterExecute(Sender: TObject);
var
  AFilter: TFilter;
begin
  AFilter := AddPhotoViewerEntity(TFilter) as TFilter;
  if AFilter <> nil then
  begin
    DataModule1.SaveEntity(AFilter);
    PopulateEffectsAndFilters;
  end;
end;

procedure TFilters.acEditFilterExecute(Sender: TObject);
var
  AFilter: TFilter;
  AItem: TdxGalleryControlItem;
begin
  AItem := dxGalleryControl1.Gallery.GetCheckedItem;
  if AItem <> nil then
  begin
    AFilter := TFilter(AItem.Tag);
    EditPhotoViewerEntity(AFilter);
    if AFilter <> nil then
    begin
      DataModule1.SaveEntity(AFilter);
      PopulateEffectsAndFilters;
    end;
  end;
end;

procedure TFilters.acRemoveFilterExecute(Sender: TObject);
var
  AFilter: TFilter;
  AItem: TdxGalleryControlItem;
begin
  AItem := dxGalleryControl1.Gallery.GetCheckedItem;
  if AItem <> nil then
  begin
    AFilter := TFilter(AItem.Tag);
    DataModule1.DeleteEntity(AFilter);
    PopulateEffectsAndFilters;
  end;
end;

procedure TFilters.FormShow(Sender: TObject);
begin
  inherited;
  imPreview.Style.BorderStyle := ebsNone;
end;

procedure TFilters.GalleryItemDblClickHandler(AItem: TdxGalleryControlItem; AEntity: TPhotoViewerEntity);
var
  AFilter: TFilter;
begin
  if (SelectedEntity <> nil) and (SelectedEntity is TFilter) then
  begin
    AFilter := TFilter(SelectedEntity);
    EditPhotoViewerEntity(AFilter);
    if AItem <> nil then
    begin
      AItem.Caption := AFilter.Caption;
      AFilter.Apply(AFilter.Image, AItem.Glyph);
      UpdateFilterPreview(AItem.Glyph);
    end;
  end;
  inherited GalleryItemDblClickHandler(AItem, AEntity);
end;

procedure TFilters.GalleryItemClickHandler(AItem: TdxGalleryControlItem; AEntity: TPhotoViewerEntity);
var
  AFilter: TCustomFilter;
  AImage: TdxSmartImage;
begin
  AFilter := TCustomFilter(AItem.Tag);
  if AItem.Checked and (AFilter <> nil) then
  begin
    AImage := TdxSmartImage.Create;
    try
      AFilter.Apply(AFilter.Image, AImage);
      UpdateFilterPreview(AImage);
    finally
      AImage.Free;
    end;
    inherited GalleryItemClickHandler(AItem, AEntity);
  end;
end;

procedure TFilters.UpdateControls;
begin
  acEditFilter.Enabled := SelectedFilter <> nil;
  acRemoveFilter.Enabled := acEditFilter.Enabled;
  inherited UpdateControls;
end;

function TFilters.GetSelectedCustomFilter(AItem: TdxGalleryControlItem): TCustomFilter;
begin
  if (AItem <> nil) and (TObject(AItem.Tag) is TCustomFilter) then
    Result := TCustomFilter(AItem.Tag)
  else
    Result := nil;
end;

function TFilters.GetSelectedEffect: TEffect;
begin
  if (SelectedEntity <> nil) and (SelectedEntity is TEffect) then
    Result := TEffect(SelectedEntity)
  else
    Result := nil;
end;

function TFilters.GetSelectedFilter: TFilter;
var
  AFilter: TCustomFilter;
begin
  AFilter := GetSelectedCustomFilter(dxGalleryControl1.Gallery.GetCheckedItem);
  if (AFilter <> nil) and (AFilter is TFilter) then
    Result := TFilter(AFilter)
  else
    Result := nil;
end;

procedure TFilters.PopulateEffectsAndFilters;
begin
  PopulateGallery<TFilter>(DataModule1.GetFilterCollection, 'My Filters', DefaultGalleryFilterPreviewSize, True);
  PopulateGallery<TEffect>(DataModule1.GetEffectCollection, 'Predefined Filters', DefaultGalleryFilterPreviewSize, False);
end;

procedure TFilters.UpdateFilterPreview(AImage: TdxSmartImage);
begin
  imPreview.Picture.Assign(AImage);
end;

initialization
  TFilters.Register;

end.
