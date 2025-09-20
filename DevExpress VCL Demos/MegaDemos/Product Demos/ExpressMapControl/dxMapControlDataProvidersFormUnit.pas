unit dxMapControlDataProvidersFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxMapControlBaseFormUnit, dxCore, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxMapControlTypes,
  StdCtrls, ExtCtrls, cxGroupBox, cxClasses,
  dxMapControl,dxMapLayer, dxMapImageTileLayer, dxCustomMapItemLayer, dxMapItemLayer,
  dxMapItem, dxMapControlBingMapImageryDataProvider, dxMapControlOpenStreetMapImageryDataProvider,
  dxRibbonSkins, dxRibbon, dxBar, ImgList, dxRibbonCustomizationForm, dxLayoutContainer, dxLayoutControl, cxImageList,
  dxLayoutLookAndFeels, dxLayoutControlAdapters;

type
  TfrmDataProviders = class(TdxMapControlDemoUnitForm)
    dxMapControl1ImageTileLayer1: TdxMapImageTileLayer;
    dxMapControl1ItemLayer1: TdxMapItemLayer;
    dxMapControl1ItemLayer1CustomElement1: TdxMapCustomElement;
    dxRibbon1Tab1: TdxRibbonTab;
    dxRibbon1: TdxRibbon;
    dxBarManager1Bar1: TdxBar;
    dxBarButton1: TdxBarButton;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    dxBarLargeButton3: TdxBarLargeButton;
    dxBarLargeButton4: TdxBarLargeButton;
    ilSmallBarIcons: TcxImageList;
    ilLargeBarIcons: TcxImageList;
    procedure FormCreate(Sender: TObject);
    procedure dxBarLargeButton3Click(Sender: TObject);
  private
    FMapKind: TdxBingMapKind;
    FProviderId: Integer;
    procedure UpdateMapKind;
    procedure UpdateProvider;
  protected
    function GetDescription: string; override;
  public
    class function GetID: Integer; override;
    class function GetLoadingInfo: string; override;
  end;

implementation

{$R *.dfm}

{ TdxMapControlDemoUnitForm1 }

procedure TfrmDataProviders.dxBarLargeButton3Click(Sender: TObject);
begin
  if (Sender as TComponent).Tag > 0 then
  begin
    FProviderId := 1;
    FMapKind := TdxBingMapKind((Sender as TComponent).Tag - 1);
  end
  else
    FProviderId := 0;
  UpdateProvider;
end;

procedure TfrmDataProviders.FormCreate(Sender: TObject);
begin
  inherited;
  dxMapControl1.BeginUpdate;
  dxMapControl1.CenterPoint := dxMapControl1ItemLayer1CustomElement1.Location;
  dxMapControl1.ZoomLevel := 10;
  dxMapControl1ItemLayer1CustomElement1.Selected := True;
  FProviderId := 1;
  FMapKind := bmkHybrid;
  UpdateProvider;
  dxMapControl1.EndUpdate;
end;

function TfrmDataProviders.GetDescription: string;
begin
  Result := 'This demo illustrates the Map Control displaying maps from different providers. You can use the Provide Demo Options group in the Ribbon UI to switch between "Open Street Map", "Bing Road", "Bing Area", and "Bing Hybrid" maps.';
end;

class function TfrmDataProviders.GetID: Integer;
begin
  Result := 0;
end;

class function TfrmDataProviders.GetLoadingInfo: string;
begin
  Result := 'Data Providers Demo';
end;

procedure TfrmDataProviders.UpdateMapKind;
begin
  if dxMapControl1ImageTileLayer1.Provider is TdxMapControlBingMapImageryDataProvider then
    TdxMapControlBingMapImageryDataProvider(dxMapControl1ImageTileLayer1.Provider).Kind := FMapKind;
end;

procedure TfrmDataProviders.UpdateProvider;
begin
  dxMapControl1.BeginUpdate;
  if FProviderId = 1 then
  begin
    dxMapControl1ImageTileLayer1.ProviderClass := TdxMapControlBingMapImageryDataProvider;
    (dxMapControl1ImageTileLayer1.Provider as TdxMapControlBingMapImageryDataProvider).BingKey := DXBingKey;
    UpdateMapKind;
  end
  else
    dxMapControl1ImageTileLayer1.ProviderClass := TdxMapControlOpenStreetMapImageryDataProvider;
  dxMapControl1ImageTileLayer1.Provider.MaxParallelConnectionCount := 30;
  dxMapControl1.EndUpdate;
end;

initialization
  TfrmDataProviders.Register;

end.
