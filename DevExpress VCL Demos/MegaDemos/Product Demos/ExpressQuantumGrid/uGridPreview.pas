unit uGridPreview;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxGridFrame, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridLevel,
  cxGrid, StdCtrls, ExtCtrls, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxEdit, DB, cxDBData, cxClasses, cxLookAndFeels,
  cxLookAndFeelPainters, cxDataStorage, cxContainer, cxLabel, Menus, dxLayoutControlAdapters, cxNavigator,
  dxLayoutContainer, cxButtons, dxLayoutControl, ActnList, dxDateRanges, dxScrollbarAnnotations, dxLayoutLookAndFeels,
  System.Actions, cxGroupBox, dxPanel, cxGeometry,
  dxFramedControl;

type
  TfrmGridPreview = class(TdxGridFrame)
    GridLevel: TcxGridLevel;
    DBTableView: TcxGridDBTableView;
    DBTableViewFIRSTNAME: TcxGridDBColumn;
    DBTableViewSECONDNAME: TcxGridDBColumn;
    DBTableViewBIRTHNAME: TcxGridDBColumn;
    DBTableViewBIOGRAPHY: TcxGridDBColumn;
    DBTableViewGENDER: TcxGridDBColumn;
    DBTableViewBirthDate: TcxGridDBColumn;
  protected
    function GetDescription: string; override;
  public
    procedure ChangeVisibility(AShow: Boolean); override;
  end;

var
  frmGridPreview: TfrmGridPreview;

implementation

{$R *.dfm}

uses
  maindata, dxFrames, FrameIDs, uStrsConst;


{ TfrmGridPreview }

function TfrmGridPreview.GetDescription: string;
begin
  Result := sdxFrameAutoPreviewDescription;
end;

procedure TfrmGridPreview.ChangeVisibility(AShow: Boolean);
begin
  if AShow then
    DBTableView.DataController.DataSource := dmMain.dsMovieStars
  else
  begin
    DBTableView.DataController.DataSource := nil;
    dmMain.cdsMovieStars.Filtered := False;
    dmMain.cdsMovieStars.Filter := '';
  end;
  inherited ChangeVisibility(AShow);
end;

initialization
  dxFrameManager.RegisterFrame(GridPreviewFrameID, TfrmGridPreview,
    GridAutoPreviewFrameName, GridPreviewImageIndex, PreviewAndViewGroupIndex, -1, -1);


end.
