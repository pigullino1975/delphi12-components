unit cxTreeListBiolifeFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, System.Actions, System.ImageList, ImgList, UITypes,
  cxDBTreeListBaseFormUnit, cxGraphics, cxCustomData, cxStyles, cxTL,
  cxTLdxBarBuiltInMenu, dxSkinsCore,
  cxControls, cxInplaceContainer, cxTLData, cxDBTL, cxTreeListDataModule,
  cxMaskEdit, cxCheckBox, cxCalendar, cxMemo, cxImage, cxBlobEdit,
  cxLookAndFeelPainters, StdCtrls,  cxContainer, cxEdit, cxGroupBox, cxLookAndFeels, dxLayoutContainer,
  cxClasses, dxLayoutControl, ActnList, dxLayoutLookAndFeels, cxImageList, dxScrollbarAnnotations, cxFilter;

type
  TfrmBiolife = class(TcxDBTreeListDemoUnitForm)
    clnCategory: TcxDBTreeListColumn;
    tlDBcxDBTreeListColumn2: TcxDBTreeListColumn;
    clnLength: TcxDBTreeListColumn;
    clnMark: TcxDBTreeListColumn;
    clnSpeciesName: TcxDBTreeListColumn;
    clnSpeciesNo: TcxDBTreeListColumn;
    ImageList: TcxImageList;
    procedure tlDBGetNodeImageIndex(Sender: TcxCustomTreeList;
      ANode: TcxTreeListNode; AIndexType: TcxTreeListImageIndexType;
      var AIndex: TImageIndex);
  private
    procedure SetupImages;
  public
    function HasOptions: Boolean; override;
    procedure FrameActivated; override;
  end;

implementation

{$R *.dfm}

uses
  Math;

{ TfrmBiolife }

function TfrmBiolife.HasOptions: Boolean;
begin
  Result := False;
end;

procedure TfrmBiolife.FrameActivated;
begin
  inherited FrameActivated;
  SetupImages;
end;

procedure TfrmBiolife.SetupImages;
begin
  TreeList.OptionsView.DynamicFocusedStateImages := False;
  TreeList.Images := ImageList;
end;

procedure TfrmBiolife.tlDBGetNodeImageIndex(Sender: TcxCustomTreeList;
  ANode: TcxTreeListNode; AIndexType: TcxTreeListImageIndexType;
  var AIndex: TImageIndex);
begin
  AIndex := 0;
  if AIndexType = tlitImageIndex then
    AIndex := IfThen(ANode.Focused, 1, 0);
end;

end.
