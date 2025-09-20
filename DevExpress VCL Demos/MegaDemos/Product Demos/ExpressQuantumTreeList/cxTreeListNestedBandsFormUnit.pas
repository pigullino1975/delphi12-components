unit cxTreeListNestedBandsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxTreeListIssueListFormUnit, cxGraphics, cxCustomData, cxStyles,
  cxTL, cxMaskEdit, cxImageComboBox, cxCalendar, cxProgressBar, cxCurrencyEdit,
  cxButtonEdit, cxTLdxBarBuiltInMenu, dxSkinsCore, 
  StdCtrls, ExtCtrls, ImgList, cxInplaceContainer, cxDBTL, cxControls, cxTLData,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxGroupBox, cxLabel, Grids,
  DBGrids, cxLookAndFeels, cxImageList, dxLayoutContainer, cxClasses, dxLayoutControl, ActnList, dxLayoutLookAndFeels,
  dxScrollbarAnnotations, System.ImageList, System.Actions, cxFilter;

type
  TfrmNestedBands = class(TfrmIssueList)
  public
    class function GetID: Integer; override;
    function HasOptions: Boolean; override;
  end;

implementation

{$R *.dfm}

uses
  cxTreeListFeaturesDemoStrConsts;

{ TfrmNestedBands }

class function TfrmNestedBands.GetID: Integer;
begin
  Result := 0;
end;

function TfrmNestedBands.HasOptions: Boolean;
begin
  Result := False;
end;

initialization
  TfrmNestedBands.Register;

end.
