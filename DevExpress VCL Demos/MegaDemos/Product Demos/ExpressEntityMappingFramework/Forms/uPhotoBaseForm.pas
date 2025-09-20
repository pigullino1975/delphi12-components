unit uPhotoBaseForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uPhotoViewerForm, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  dxLayoutContainer, dxRibbonSkins, dxRibbonCustomizationForm, System.Actions, Vcl.ActnList,
  Vcl.ImgList, cxImageList, dxBar, cxClasses, dxLayoutLookAndFeels, dxRibbon, dxGallery, dxGalleryControl,
  dxLayoutControl, dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg, dxBkgnd, dxWrap, dxPrnDev, dxPSCompsProvider,
  dxPSFillPatterns, dxPSEdgePatterns, dxPSPDFExportCore, dxPSPDFExport, cxDrawTextUtils, dxPSPrVwStd, dxPSPrVwAdv,
  dxPSPrVwRibbon, dxPScxPageControlProducer, dxPScxEditorLnks, dxPScxEditorProducers, dxPScxExtEditorProducers,
  dxPSGraphicLnk, dxPSCore, dxLayoutcxEditAdapters, cxContainer, cxEdit, cxTrackBar, dxZoomTrackBar,
  dxEMF.Types, PhotoViewerClasses, uEntityEditor, System.ImageList, dxShellDialogs;

type
  { TPhotoBaseForm }

  TPhotoBaseForm = class(TPhotoViewerForm)
    rtImage: TdxRibbonTab;
    dxBarManager1Bar1: TdxBar;
    dxBarLargeButton1: TdxBarLargeButton;
    odAddFiles: TdxOpenFileDialog;
    dxBarLargeButton2: TdxBarLargeButton;
    dxBarLargeButton3: TdxBarLargeButton;
    dxBarLargeButton4: TdxBarLargeButton;
    dxBarManager1Bar2: TdxBar;
    dxBarLargeButton5: TdxBarLargeButton;
    dxBarLargeButton6: TdxBarLargeButton;
    dxBarLargeButton7: TdxBarLargeButton;
    dxBarManager1Bar3: TdxBar;
    dxBarLargeButton8: TdxBarLargeButton;
    dxBarLargeButton9: TdxBarLargeButton;
    dxBarLargeButton10: TdxBarLargeButton;
    dxBarManager1Bar4: TdxBar;
    dxBarLargeButton11: TdxBarLargeButton;
    dxBarLargeButton12: TdxBarLargeButton;
    dxBarLargeButton13: TdxBarLargeButton;
    dxBarLargeButton14: TdxBarLargeButton;
    dxBarLargeButton18: TdxBarLargeButton;
    bsiAddToAlbum: TdxBarSubItem;
    dxComponentPrinter1: TdxComponentPrinter;
    dxComponentPrinter1Link1: TdxCompositionReportLink;
    dxComponentPrinter1Link2: TcxImageReportLink;
    ztbGalleryPhotoSize: TdxZoomTrackBar;
    dxLayoutItem3: TdxLayoutItem;
    lgGalleryBaseGroup: TdxLayoutGroup;
    bpmPhotoPopupMenu: TdxBarPopupMenu;
    procedure acAddFilesExecute(Sender: TObject);
    procedure acMarkAllExecute(Sender: TObject);
    procedure acUnmarkAllExecute(Sender: TObject);
    procedure acCollageExecute(Sender: TObject);
    procedure acSlideShowExecute(Sender: TObject);
    procedure acExportExecute(Sender: TObject);
    procedure acFilmExecute(Sender: TObject);
    procedure acMailExecute(Sender: TObject);
    procedure acUploadExecute(Sender: TObject);
    procedure bsiAddToAlbumClick(Sender: TObject);
    procedure acPrintExecute(Sender: TObject);
    procedure acRemoveFromAlbumExecute(Sender: TObject);
    procedure ztbGalleryPhotoSizePropertiesChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure acViewExecute(Sender: TObject);
  strict private
    function GetSelectedPhoto: TPhoto;
    procedure AddToAlbumClick(Sender: TObject);
  protected
    function GetGalleryPhotoSize: TSize; override;
    procedure UpdateControls; override;

    function GetSelectedAlbum: TAlbum; virtual;
    procedure PopulateGallery(const ACollection: IdxEMFCollection<TAlbum>); overload;
    procedure UpdatePhotoRating(AValue: Integer);

    property SelectedAlbum: TAlbum read GetSelectedAlbum;
    property SelectedPhoto: TPhoto read GetSelectedPhoto;
  end;

implementation

{$R *.dfm}

uses
  IOUtils, Math, Generics.Defaults, Generics.Collections, dxCore, cxGeometry, cxImage, dxGDIPlusClasses,
  Main, uDataModule, uSlideShow, uEditor;

procedure TPhotoBaseForm.acAddFilesExecute(Sender: TObject);
var
  I: Integer;
  AAlbum: TAlbum;
  AGroup: TdxGalleryControlGroup;
  APhoto: TPhoto;
begin
  odAddFiles.Filter := GraphicFilter(TdxSmartImage);
  if odAddFiles.Execute and (odAddFiles.Files.Count > 0) then
  begin
    AAlbum := SelectedAlbum;
    for I := 0 to odAddFiles.Files.Count - 1 do
    begin
      APhoto := TPhoto.Create;
      APhoto.Caption := TPath.GetFileName(odAddFiles.Files[I]);
      APhoto.Image.LoadFromFile(odAddFiles.Files[I]);
      if AAlbum <> nil then
        AAlbum.AddPhoto(APhoto)
      else
        DataModule1.SaveEntity(APhoto);
    end;
    if AAlbum <> nil then
    begin
      DataModule1.SaveEntity(AAlbum);
      PopulateGallery(DataModule1.GetAlbum(AAlbum.ID))
    end
    else
      PopulateGalleryFromPhotoCollection(DataModule1.GetPhotoCollection);
    if GalleryGroups.Count > 0 then
    begin
      AGroup := GalleryGroups[0];
      AGroup.Items[AGroup.ItemCount - 1].Checked := True;
      dxGalleryControl1.MakeItemVisible(AGroup.Items[AGroup.ItemCount - 1]);
    end;
  end;
end;

function TPhotoBaseForm.GetGalleryPhotoSize: TSize;
begin
  Result.cx := Max(Min(ztbGalleryPhotoSize.Position, MaxGalleryPhotoSize.cx), MinGalleryPhotoSize.cx);
  Result.cy := Result.cx;
end;

procedure TPhotoBaseForm.UpdateControls;
var
  AChecked: Boolean;
begin
  inherited UpdateControls;
  AChecked := dxGalleryControl1.Gallery.GetCheckedItem <> nil;
  acView.Enabled := AChecked;
  acRemove.Enabled := AChecked;
  acRemoveFromAlbum.Enabled := AChecked;
  acCollage.Enabled := AChecked;
  acSlideShow.Enabled := AChecked;
  acFilm.Enabled := AChecked;
  acExport.Enabled := AChecked;
  acMail.Enabled := AChecked;
  acUpload.Enabled := AChecked;
  acPrint.Enabled := AChecked;
  acMarkAll.Enabled := not IsGalleryEmpty;
  acUnmarkAll.Enabled := AChecked;

  bsiAddToAlbum.Enabled := SelectedPhoto <> nil;
  acEditAlbum.Enabled := SelectedAlbum <> nil;
  acRemoveAlbum.Enabled := acEditAlbum.Enabled;
  acRemoveFromAlbum.Enabled := acEditAlbum.Enabled and AChecked;
end;

procedure TPhotoBaseForm.ztbGalleryPhotoSizePropertiesChange(Sender: TObject);
begin
  dxGalleryControl1.OptionsView.Item.Image.Size.Size := GalleryPhotoSize;
end;

procedure TPhotoBaseForm.acCollageExecute(Sender: TObject);
begin
  ShowActionDialog('collage settings');
end;

procedure TPhotoBaseForm.acExportExecute(Sender: TObject);
begin
  ShowActionDialog('export');
end;

procedure TPhotoBaseForm.acFilmExecute(Sender: TObject);
begin
  ShowActionDialog('film settings');
end;

procedure TPhotoBaseForm.acMailExecute(Sender: TObject);
begin
  MsgDlg('Here you can make preparations for e-mail');
end;

procedure TPhotoBaseForm.acMarkAllExecute(Sender: TObject);
var
  I, J: Integer;
begin
  dxGalleryControl1.BeginUpdate;
  try
    for I := 0 to GalleryGroups.Count - 1 do
      for J := 0 to GalleryGroups[I].Items.Count - 1 do
        GalleryGroups[I].Items[J].Checked := True;
  finally
    dxGalleryControl1.EndUpdate;
  end;
end;

procedure TPhotoBaseForm.acPrintExecute(Sender: TObject);
var
  I: Integer;
  AImage: TcxImage;
  AImages: TObjectList<TcxImage>;
  AItemLink: TdxCompositionLinkItem;
  ALink: TcxImageReportLink;
  ALinks: TObjectList<TcxImageReportLink>;
  ASelectedImages: TList;
begin
  AImages := TObjectList<TcxImage>.Create;
  ALinks := TObjectList<TcxImageReportLink>.Create;
  ASelectedImages := TList.Create;
  try
    dxGalleryControl1.Gallery.GetCheckedItems(ASelectedImages);
    dxComponentPrinter1Link1.Items.Clear;
    for I := 0 to ASelectedImages.Count - 1 do
    begin
      AImage := TcxImage.Create(nil);
      AImage.Picture.Assign(TPhoto(TdxGalleryItem(ASelectedImages[I]).Tag).Image);
      AImage.Properties.FitMode := ifmNormal;
      AImages.Add(AImage);

      ALink := TcxImageReportLink.Create(nil);
      ALink.ComponentPrinter := dxComponentPrinter1;
      ALink.Component := AImage;
      ALinks.Add(ALink);

      AItemLink := dxComponentPrinter1Link1.Items.Add;
      AItemLink.ReportLink := ALink;
    end;
    dxComponentPrinter1Link1.PrinterPage.ScaleMode := smFit;
    dxComponentPrinter1Link1.PrinterPage.Orientation := poLandscape;
    dxComponentPrinter1Link1.PrinterPage.CenterOnPageH := True;
    dxComponentPrinter1Link1.PrinterPage.CenterOnPageV := True;
    dxComponentPrinter1Link1.ShrinkToPageWidth := True;

    dxComponentPrinter1Link1.Preview(True);
  finally
    ASelectedImages.Free;
    ALinks.Free;
    AImages.Free;
  end;
end;

procedure TPhotoBaseForm.acRemoveFromAlbumExecute(Sender: TObject);
var
  I: Integer;
  AList: TList;
  AAlbum: TAlbum;
  APhoto: TPhoto;
begin
  AList := TList.Create;
  try
    dxGalleryControl1.Gallery.GetCheckedItems(AList);
    if AList.Count > 0 then
    begin
      AAlbum := nil;
      for I := 0 to AList.Count - 1 do
      begin
        AAlbum := TAlbum(TdxGalleryControlItem(AList[I]).Group.Tag);
        APhoto := TPhoto(TdxGalleryControlItem(AList[I]).Tag);
        AAlbum.RemovePhoto(APhoto);
      end;
      DataModule1.SaveEntity(AAlbum);
      PopulateGallery(DataModule1.GetAlbum(AAlbum.ID));
    end;
  finally
    AList.Free;
  end;
end;

procedure TPhotoBaseForm.acSlideShowExecute(Sender: TObject);
var
  I: Integer;
  ASelectedItems: TList;
  AImageCollection: TcxImageCollection;
begin
  AImageCollection := TcxImageCollection.Create(Self);
  ASelectedItems := TList.Create;
  try
    dxGalleryControl1.Gallery.GetCheckedItems(ASelectedItems);
    for I := 0 to ASelectedItems.Count - 1 do
      AImageCollection.Items.Add.Picture.Assign(TPhoto(TdxGalleryItem(ASelectedItems[I]).Tag).Image);
    TSlideShow.DoShowEditor(AImageCollection);
  finally
    ASelectedItems.Free;
    AImageCollection.Free;
  end;
end;

procedure TPhotoBaseForm.acUnmarkAllExecute(Sender: TObject);
begin
  dxGalleryControl1.Gallery.UncheckAll;
  UpdateControls;
end;

procedure TPhotoBaseForm.acUploadExecute(Sender: TObject);
begin
  ShowActionDialog('upload settings');
end;

procedure TPhotoBaseForm.acViewExecute(Sender: TObject);
var
  I: Integer;
  ASelectedItems: TList;
  APhotoList: TList<TPhoto>;
begin
  APhotoList := TList<TPhoto>.Create;
  ASelectedItems := TList.Create;
  try
    dxGalleryControl1.Gallery.GetCheckedItems(ASelectedItems);
    for I := 0 to ASelectedItems.Count - 1 do
      APhotoList.Add(TPhoto(TdxGalleryItem(ASelectedItems[I]).Tag));
    frmMain.ActivateDemo(TEditor.GetID);
    TEditor(frmMain.ViewerUnit.UnitInstance).PopulateGallery(APhotoList);
  finally
    ASelectedItems.Free;
    APhotoList.Free;
  end;
end;

procedure TPhotoBaseForm.bsiAddToAlbumClick(Sender: TObject);

  procedure AddItem(AAlbum: TAlbum; const ACaption: string);
  var
    AItem: TdxBarButton;
  begin
    AItem := bsiAddToAlbum.ItemLinks.AddItem(TdxBarButton).Item as TdxBarButton;
    AItem.Caption := ACaption;
    AItem.Tag := TdxNativeInt(AAlbum);
    AItem.OnClick := AddToAlbumClick;
  end;

var
  AAlbum: TAlbum;
  ACollection: IdxEMFCollection<TAlbum>;
begin
  dxBarManager1.BeginUpdate;
  try
    while bsiAddToAlbum.ItemLinks.Count > 0 do
      bsiAddToAlbum.ItemLinks[0].Item.Free;
  finally
    dxBarManager1.EndUpdate;
  end;
  if not IsGalleryEmpty then
  begin
    ACollection := DataModule1.GetAlbumCollection;
    for AAlbum in ACollection do
      if AAlbum <> SelectedAlbum then
        AddItem(AAlbum, AAlbum.Caption);
  end;
  AddItem(nil, 'Add Album...');
end;

procedure TPhotoBaseForm.FormCreate(Sender: TObject);
begin
  inherited;
  dxBarManager1.LookAndFeel.NativeStyle := False;
  ztbGalleryPhotoSize.Properties.BeginUpdate;
  ztbGalleryPhotoSize.Properties.Max := MaxGalleryPhotoSize.cx;
  ztbGalleryPhotoSize.Properties.Min := MinGalleryPhotoSize.cx;
  ztbGalleryPhotoSize.Properties.EndUpdate;
  ztbGalleryPhotoSize.Position := 100;
end;

function TPhotoBaseForm.GetSelectedAlbum: TAlbum;
begin
  Result := nil;
end;

procedure TPhotoBaseForm.PopulateGallery(const ACollection: IdxEMFCollection<TAlbum>);
begin
  PopulateGallery(
    procedure
    var
      AAlbum: TAlbum;
    begin
      for AAlbum in ACollection do
        AddGalleryAlbum(AAlbum);
    end, GalleryPhotoSize);
end;

procedure TPhotoBaseForm.UpdatePhotoRating(AValue: Integer);
begin
  if SelectedPhoto <> nil then
  begin
    SelectedPhoto.Rating := AValue;
    DataModule1.SaveEntity(SelectedPhoto);
  end;
end;

function TPhotoBaseForm.GetSelectedPhoto: TPhoto;
begin
  if SelectedEntity is TPhoto then
    Result := TPhoto(SelectedEntity)
  else
    Result := nil;
end;

procedure TPhotoBaseForm.AddToAlbumClick(Sender: TObject);

  procedure DoAdd(AAlbum: TAlbum);
  var
    I: Integer;
    AList: TList;
  begin
    AList := TList.Create;
    try
      dxGalleryControl1.Gallery.GetCheckedItems(AList);
      if AList.Count > 0 then
      begin
        for I := 0 to AList.Count - 1 do
          AAlbum.AddPhoto(TPhoto(TdxGalleryControlItem(AList[I]).Tag));
        DataModule1.SaveEntity(AAlbum);
      end;
    finally
      AList.Free;
    end;
  end;

var
  AAlbum: TAlbum;
begin
  if Sender is TdxBarItem then
  begin
    AAlbum := TAlbum(TdxBarItem(Sender).Tag);
    if AAlbum <> nil then
      DoAdd(AAlbum)
    else
    begin
      AAlbum := AddPhotoViewerEntity(TAlbum) as TAlbum;
      if AAlbum <> nil then
      begin
        DoAdd(AAlbum);
        frmMain.UpdateAlbum(AAlbum);
      end;
    end;
  end;
end;

end.
