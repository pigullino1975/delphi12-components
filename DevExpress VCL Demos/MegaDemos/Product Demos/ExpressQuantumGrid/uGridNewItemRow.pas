unit uGridNewItemRow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uGridCustomSummaries, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxControls, cxGridCustomView, cxGrid,
  ExtCtrls, StdCtrls, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxEdit, DB, cxDBData, cxClasses, cxLookAndFeels, cxLookAndFeelPainters,
  cxDataStorage, cxSpinEdit, cxContainer, cxLabel, Menus, cxNavigator, dxLayoutControlAdapters, dxLayoutContainer,
  cxButtons, dxLayoutControl, ActnList, dxDateRanges, dxScrollbarAnnotations, dxLayoutLookAndFeels, System.Actions,
  cxGroupBox, dxPanel, cxGeometry, dxFramedControl;

type
  TfrmNewItemRowGrid = class(TfrmCustomGridSummaries)
  protected
    function GetDescription: string; override;
  end;

implementation

{$R *.dfm}
uses
  dxFrames, FrameIDs, uStrsConst;

function TfrmNewItemRowGrid.GetDescription: string;
begin
  Result := sdxFrameNewItemRowDescription;
end;

initialization
  dxFrameManager.RegisterFrame(GridNewItemRowFrameID, TfrmNewItemRowGrid,
    GridNewItemRowFrameName, GridNewItemRowImageIndex, TableBandedTableGroupIndex, -1, -1);

end.
