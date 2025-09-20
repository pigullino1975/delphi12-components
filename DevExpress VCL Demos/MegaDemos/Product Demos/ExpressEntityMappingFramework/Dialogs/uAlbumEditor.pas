unit uAlbumEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  uEntityEditor, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, dxLayoutControlAdapters, dxLayoutContainer, cxClasses,
  Vcl.StdCtrls, cxButtons, dxLayoutControl, dxLayoutcxEditAdapters, cxContainer,
  cxEdit, cxTextEdit, dxLayoutLookAndFeels, cxMemo, Vcl.ComCtrls, dxCore,
  cxDateUtils, cxMaskEdit, cxDropDownEdit, cxCalendar, PhotoViewerClasses;

type
  { TAlbumEditor }

  TAlbumEditor = class(TEntityEditor)
    mComment: TcxMemo;
    dxLayoutItem5: TdxLayoutItem;
  strict private
    function GetAlbum: TAlbum;
    property Album: TAlbum read GetAlbum;
  protected
    procedure Initialize(AEditing: Boolean); override;
    procedure SaveEntity; override;
  end;

implementation

{$R *.dfm}

{ TAlbumEditor }

procedure TAlbumEditor.Initialize(AEditing: Boolean);
begin
  inherited Initialize(AEditing);
  mComment.Text := Album.Comment;
end;

procedure TAlbumEditor.SaveEntity;
begin
  inherited SaveEntity;
  Album.Comment := mComment.Text;
end;

function TAlbumEditor.GetAlbum: TAlbum;
begin
  Result := Entity as TAlbum;
end;

end.
