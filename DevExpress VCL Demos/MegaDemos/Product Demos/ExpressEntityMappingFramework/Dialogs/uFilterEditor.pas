unit uFilterEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  uEntityEditor, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, dxLayoutControlAdapters, dxLayoutContainer, cxClasses,
  Vcl.StdCtrls, cxButtons, dxLayoutControl, dxLayoutcxEditAdapters, cxContainer,
  cxEdit, cxTextEdit, dxLayoutLookAndFeels, cxMemo, Vcl.ComCtrls, dxCore,
  cxDateUtils, cxMaskEdit, cxDropDownEdit, cxCalendar, PhotoViewerClasses,
  cxTrackBar, cxImage, dxGDIPlusClasses;

type
  { TFilterEditor }

  TFilterEditor = class(TEntityEditor)
    tbBrightness: TcxTrackBar;
    tbContrast: TcxTrackBar;
    dxLayoutItem5: TdxLayoutItem;
    dxLayoutItem6: TdxLayoutItem;
    tbR: TcxTrackBar;
    tbG: TcxTrackBar;
    tbB: TcxTrackBar;
    dxLayoutItem7: TdxLayoutItem;
    dxLayoutItem8: TdxLayoutItem;
    dxLayoutItem9: TdxLayoutItem;
    dxLayoutGroup1: TdxLayoutGroup;
    dxLayoutGroup2: TdxLayoutGroup;
    imPreview: TcxImage;
    dxLayoutItem10: TdxLayoutItem;
    dxLayoutGroup3: TdxLayoutGroup;
    dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup;
    dxLayoutGroup4: TdxLayoutGroup;
    procedure tbRPropertiesChange(Sender: TObject);
    procedure tbBPropertiesChange(Sender: TObject);
    procedure tbGPropertiesChange(Sender: TObject);
    procedure tbBrightnessPropertiesChange(Sender: TObject);
    procedure tbContrastPropertiesChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure imPreviewPropertiesEditValueChanged(Sender: TObject);
  strict private
    FSourceImage: TdxSmartImage;

    function GetFilter: TFilter;
    function CreateActualFilter: TFilter;
    procedure AplpyFilter(AForce: Boolean = False);

    property Filter: TFilter read GetFilter;
  protected
    procedure Initialize(AEditing: Boolean); override;
    procedure SaveEntity; override;
  end;

implementation

{$R *.dfm}

{ TFilterEditor }

procedure TFilterEditor.Initialize(AEditing: Boolean);
begin
  inherited Initialize(AEditing);
  FSourceImage := TdxSmartImage.Create;
  BeginUpdate;
  try
    teCaption.Text := Filter.Caption;
    tbBrightness.EditValue := Filter.Brightness;
    tbContrast.EditValue := Filter.Contrast;
    tbR.EditValue := Filter.R;
    tbG.EditValue := Filter.G;
    tbB.EditValue := Filter.B;
    if not Filter.Image.Empty then
      FSourceImage.Assign(Filter.Image)
    else
      FSourceImage.Assign(imPreview.Picture.Graphic);
  finally
    EndUpdate;
  end;
  AplpyFilter;
end;

procedure TFilterEditor.SaveEntity;
begin
  Filter.Caption := teCaption.Text;
  Filter.Brightness := tbBrightness.EditValue;
  Filter.Contrast := tbContrast.EditValue;
  Filter.Image.Assign(FSourceImage);
  Filter.Color := RGB(tbR.EditValue, tbG.EditValue, tbB.EditValue);
  inherited SaveEntity;
end;

procedure TFilterEditor.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FSourceImage);
end;

function TFilterEditor.GetFilter: TFilter;
begin
  Result := Entity as TFilter;
end;

procedure TFilterEditor.imPreviewPropertiesEditValueChanged(Sender: TObject);
begin
  if not Locked then
  begin
    BeginUpdate;
    try
      FSourceImage.Assign(imPreview.Picture.Graphic);
      AplpyFilter(True);
    finally
      EndUpdate;
    end;
  end;
end;

function TFilterEditor.CreateActualFilter: TFilter;
begin
  Result := TFilter.Create;
  Result.Caption := teCaption.Text;
  Result.Brightness := tbBrightness.EditValue;
  Result.Contrast := tbContrast.EditValue;
  Result.Image.Assign(imPreview.Picture.Graphic);
  Result.Color := RGB(tbR.EditValue, tbG.EditValue, tbB.EditValue);
end;

procedure TFilterEditor.AplpyFilter(AForce: Boolean = False);
var
  AFilter: TFilter;
begin
  if not Locked or AForce then
  begin
    BeginUpdate;
    AFilter := CreateActualFilter;
    try
      AFilter.Apply(FSourceImage, imPreview.Picture);
    finally
      AFilter.Free;
      EndUpdate;
    end;
  end;
end;

procedure TFilterEditor.tbRPropertiesChange(Sender: TObject);
begin
  AplpyFilter;
end;

procedure TFilterEditor.tbGPropertiesChange(Sender: TObject);
begin
  AplpyFilter;
end;

procedure TFilterEditor.tbBPropertiesChange(Sender: TObject);
begin
  AplpyFilter;
end;

procedure TFilterEditor.tbBrightnessPropertiesChange(Sender: TObject);
begin
  AplpyFilter;
end;

procedure TFilterEditor.tbContrastPropertiesChange(Sender: TObject);
begin
  AplpyFilter;
end;

end.
