unit uPhotos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uPhotoViewerForm, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxClasses, dxLayoutLookAndFeels, dxLayoutContainer, dxLayoutControl, dxGalleryControl, cxContainer, cxEdit,
  cxTrackBar, dxZoomTrackBar, dxStatusBar, dxGallery, cxStyles, cxSchedulerStorage, cxSchedulerCustomControls,
  cxSchedulerDateNavigator, cxCheckBox, cxDateNavigator, cxLabel, dxRatingControl, cxGroupBox, cxImage, Vcl.ExtCtrls,
  dxNavBarCollns, dxNavBarBase, dxNavBar, uEntityEditor, System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList,
  cxImageList, dxBar, dxRibbonSkins, dxRibbonCustomizationForm, dxRibbon, uPhotoBaseForm, dxPSGlbl, dxPSUtl, dxPSEngn,
  dxPrnPg, dxBkgnd, dxWrap, dxPrnDev, dxPSCompsProvider, dxPSFillPatterns, dxPSEdgePatterns, dxPSPDFExportCore,
  dxPSPDFExport, cxDrawTextUtils, dxPSPrVwStd, dxPSPrVwAdv, dxPSPrVwRibbon, dxPScxPageControlProducer, dxPScxEditorLnks,
  dxPScxEditorProducers, dxPScxExtEditorProducers, dxPSGraphicLnk, dxPSCore, dxLayoutcxEditAdapters, dxRangeTrackBar,
  cxTextEdit, dxTokenEdit, dxSkinsForm;

type
  { TPhotos }

  TPhotos = class(TPhotoBaseForm)
    dxNavBar1: TdxNavBar;
    dxNavBar1Group2: TdxNavBarGroup;
    nbgFilter: TdxNavBarGroup;
    dxNavBar1Group2Control: TdxNavBarGroupControl;
    imPreview: TcxImage;
    cxGroupBox2: TcxGroupBox;
    rcRating: TdxRatingControl;
    lblImageFileName: TcxLabel;
    lblImageFileInfo: TcxLabel;
    dxLayoutItem1: TdxLayoutItem;
    nbgFilterControl: TdxNavBarGroupControl;
    dxNavBar2: TdxNavBar;
    dxNavBar2Group1: TdxNavBarGroup;
    nbgPhotoFilterAlbum: TdxNavBarGroup;
    nbgPhotoFilterDate: TdxNavBarGroup;
    nbgPhotoFilterRating: TdxNavBarGroup;
    nbgPhotoFilterAlbumControl: TdxNavBarGroupControl;
    teAlbums: TdxTokenEdit;
    nbgPhotoFilterDateControl: TdxNavBarGroupControl;
    dnDateFilter: TcxDateNavigator;
    nbgPhotoFilterRatingControl: TdxNavBarGroupControl;
    rtbRating: TdxRangeTrackBar;
    cbApplyFilter: TcxCheckBox;
    dxLayoutEmptySpaceItem1: TdxLayoutEmptySpaceItem;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    procedure FormCreate(Sender: TObject);
    procedure rcRatingPropertiesChange(Sender: TObject);
    procedure cbApplyFilterPropertiesChange(Sender: TObject);
    procedure teAlbumsPropertiesEditValueChanged(Sender: TObject);
    procedure dnDateFilterSelectionChanged(Sender: TObject; const AStart, AFinish: TDateTime);
    procedure rtbRatingPropertiesChange(Sender: TObject);
  strict private
    procedure DoApplyFilter;
    procedure UpdatePhotoInfo(AEntity: TPhotoViewerEntity);
  protected
    procedure ApplyFilter(AForce: Boolean = False);
    procedure UpdateControls; override;
  public
    class function GetID: Integer; override;
    procedure PopulateGallery; override;
  end;

implementation

{$R *.dfm}

uses
  DateUtils, cxGeometry, uDataModule, PhotoViewerClasses, dxEMF.Types;

{ TPhotos }

class function TPhotos.GetID: Integer;
begin
  Result := 1;
end;

procedure TPhotos.PopulateGallery;
begin
  inherited PopulateGallery;
  PopulateGalleryFromPhotoCollection(DataModule1.GetPhotoCollection);
end;

procedure TPhotos.rcRatingPropertiesChange(Sender: TObject);
begin
  UpdatePhotoRating(rcRating.EditValue);
end;

procedure TPhotos.rtbRatingPropertiesChange(Sender: TObject);
begin
  ApplyFilter;
end;

procedure TPhotos.teAlbumsPropertiesEditValueChanged(Sender: TObject);
begin
  ApplyFilter;
end;

procedure TPhotos.cbApplyFilterPropertiesChange(Sender: TObject);
begin
  ApplyFilter(True);
end;

procedure TPhotos.dnDateFilterSelectionChanged(Sender: TObject; const AStart, AFinish: TDateTime);
begin
  ApplyFilter;
end;

procedure TPhotos.FormCreate(Sender: TObject);
var
  I: Integer;
  AStartDate: TDateTime;
  AAlbum: TAlbum;
  AToken: TdxTokenEditToken;
begin
  inherited;
  imPreview.Style.BorderStyle := ebsNone;
  cxGroupBox2.Style.BorderStyle := ebsNone;
  AStartDate := IncDay(Now, -5);
  for I := 0 to 9 do
    dnDateFilter.SelectedDays.Add(IncDay(AStartDate, I));
  teAlbums.Properties.BeginUpdate;
  try
    for AAlbum in DataModule1.GetAlbumCollection do
    begin
      AToken := teAlbums.Properties.Tokens.Add;
      AToken.Text := AAlbum.Caption;
      AToken.Tag := AAlbum.ID;
      if teAlbums.Properties.Tokens.Count < 3 then
        teAlbums.Text := teAlbums.Text + teAlbums.Properties.EditValueDelimiter + AToken.Text;
    end;
  finally
    teAlbums.Properties.EndUpdate;
  end;
end;

procedure TPhotos.DoApplyFilter;
begin
  ExecuteLongOperation(
    procedure

      function GetAlbumIDs: TArray<Integer>;
      var
        I: Integer;
        ATokens: TStrings;
      begin
        ATokens := teAlbums.Properties.EditValueToTokens(teAlbums.EditValue);
        if ATokens <> nil then
        begin
          SetLength(Result, ATokens.Count);
          for I := 0 to ATokens.Count - 1 do
            Result[I] := (ATokens.Objects[I] as TdxTokenEditToken).Tag;
          ATokens.Free;
        end;
      end;

    begin
      if cbApplyFilter.Checked then
        PopulateGalleryFromPhotoCollection(
          DataModule1.GetPhotoCollection(GetAlbumIDs, rtbRating.Range.Min, rtbRating.Range.Max, dnDateFilter.SelectedDays))
      else
        PopulateGalleryFromPhotoCollection(DataModule1.GetPhotoCollection);
      UpdatePhotoInfo(SelectedPhoto);
    end);
end;

procedure TPhotos.UpdatePhotoInfo(AEntity: TPhotoViewerEntity);
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
  end;
end;

procedure TPhotos.UpdateControls;
begin
  inherited UpdateControls;
  UpdatePhotoInfo(SelectedPhoto);
end;

procedure TPhotos.ApplyFilter(AForce: Boolean = False);
begin
  if cbApplyFilter.Checked or AForce then
    DoApplyFilter;
end;

initialization
  TPhotos.Register;

end.
