unit uPhotoEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  uEntityEditor, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, dxLayoutControlAdapters, dxLayoutContainer, cxClasses,
  Vcl.StdCtrls, cxButtons, dxLayoutControl, dxLayoutcxEditAdapters, cxContainer,
  cxEdit, cxTextEdit, dxLayoutLookAndFeels, cxMemo, Vcl.ComCtrls, dxCore,
  cxDateUtils, cxMaskEdit, cxDropDownEdit, cxCalendar, PhotoViewerClasses,
  cxImage;

type
  { TPhotoEditor }

  TPhotoEditor = class(TEntityEditor)
    imPreview: TcxImage;
    dxLayoutItem5: TdxLayoutItem;
    procedure imPreviewPropertiesEditValueChanged(Sender: TObject);
  strict private
    function GetPhoto: TPhoto;
    property Photo: TPhoto read GetPhoto;
  protected
    procedure Initialize(AEditing: Boolean); override;
    procedure SaveEntity; override;
  end;

implementation

{$R *.dfm}

{ TAlbumEditor }

procedure TPhotoEditor.Initialize(AEditing: Boolean);
begin
  inherited Initialize(AEditing);
  imPreview.Picture.Assign(Photo.Image);
  imPreview.Style.BorderStyle := ebsNone;
end;

procedure TPhotoEditor.SaveEntity;
begin
  inherited SaveEntity;
  Photo.Image.Assign(imPreview.Picture.Graphic);
end;

function TPhotoEditor.GetPhoto: TPhoto;
begin
  Result := Entity as TPhoto;
end;

procedure TPhotoEditor.imPreviewPropertiesEditValueChanged(Sender: TObject);
begin
  if teCaption.Text = '' then
    teCaption.Text := 'IMG_' + FormatDateTime('YYMMDDHHMMSS', Now);
end;

end.
