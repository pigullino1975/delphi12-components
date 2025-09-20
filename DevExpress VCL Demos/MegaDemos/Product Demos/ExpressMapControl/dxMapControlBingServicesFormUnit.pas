unit dxMapControlBingServicesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Generics.Collections, ActnList, Menus, Math, Types,
  dxMapControlBaseFormUnit, cxGraphics, cxControls, cxLookAndFeels, dxCore,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxMapControlTypes, cxClasses,
  dxBar, dxMapControl, cxGroupBox, cxTextEdit, cxSplitter, cxGeometry, dxGdiPlusClasses,
  cxImage, cxMaskEdit, cxDropDownEdit, cxButtons, cxListBox, StrUtils,
  dxCoreGraphics, dxBingMapLocationDataService, dxBingMapRouteDataService,
  dxMapControlBingMapInformationProviders, dxMapControlInformationProvider,
  dxCustomMapItemLayer, dxMapItemLayer, dxMapLayer, dxMapImageTileLayer, dxMapItem,
  dxRibbonSkins, dxRibbonCustomizationForm, dxBingMapRestService,
  dxRibbon, dxMapControlBingMapImageryDataProvider, dxLayoutContainer, dxLayoutControl, dxLayoutLookAndFeels,
  dxLayoutcxEditAdapters, dxLayoutControlAdapters, System.Actions, cxCustomListBox;

type
  TfrmBingServices = class(TdxMapControlDemoUnitForm)
    cxImage1: TcxImage;
    cxTextEdit1: TcxTextEdit;
    ActionList1: TActionList;
    actAddStartPoint: TAction;
    actAddEndPoint: TAction;
    actDeletePoint: TAction;
    actChangeStartPoint: TAction;
    actClear: TAction;
    actSetAsStartPoint: TAction;
    actSetAsEndPoint: TAction;
    actRouteFromMajorRoads: TAction;
    dxMapControl1BingMapGeoCodingDataProvider1: TdxMapControlBingMapGeoCodingDataProvider;
    dxMapControl1BingMapReverseGeoCodingDataProvider1: TdxMapControlBingMapReverseGeoCodingDataProvider;
    dxMapControl1BingMapRouteDataProvider1: TdxMapControlBingMapRouteDataProvider;
    dxMapControl1BingMapMajorRoadRouteDataProvider1: TdxMapControlBingMapMajorRoadRouteDataProvider;
    dxMapControl1ImageTileLayer1: TdxMapImageTileLayer;
    dxMapControl1ItemLayer1: TdxMapItemLayer;
    dxRibbon1: TdxRibbon;
    dxRibbon1Tab1: TdxRibbonTab;
    dxBarManager1Bar1: TdxBar;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    dxBarLargeButton3: TdxBarLargeButton;
    miManeuverPoint: TdxMapDot;
    miNewPointPointer: TdxMapDot;
    Setstartpoint1: TdxBarButton;
    Setasstartpoint1: TdxBarButton;
    Changestartpoint1: TdxBarButton;
    Addroutepoint1: TdxBarButton;
    Setasroutepoint1: TdxBarButton;
    Showroutefrommajorroads1: TdxBarButton;
    Deletepoint1: TdxBarButton;
    dxRibbonPopupMenu1: TdxRibbonPopupMenu;
    dxLayoutItem2: TdxLayoutItem;
    cxComboBox1: TcxComboBox;
    dxLayoutItem3: TdxLayoutItem;
    cxListBox1: TcxListBox;
    dxLayoutItem4: TdxLayoutItem;
    cxButton1: TcxButton;
    dxLayoutItem5: TdxLayoutItem;
    cxButton2: TcxButton;
    dxLayoutGroup1: TdxLayoutGroup;
    dxLayoutGroup2: TdxLayoutGroup;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    procedure actAddStartPointExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure dxBarLargeButton1Click(Sender: TObject);
    procedure actAddEndPointExecute(Sender: TObject);
    procedure actDeletePointExecute(Sender: TObject);
    procedure actChangeStartPointExecute(Sender: TObject);
    procedure actClearExecute(Sender: TObject);
    procedure actSetAsStartPointExecute(Sender: TObject);
    procedure actSetAsEndPointExecute(Sender: TObject);
    procedure actRouteFromMajorRoadsExecute(Sender: TObject);
    procedure dxBarPopupMenu1Popup(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
    procedure cxListBox1Click(Sender: TObject);
    procedure cxComboBox1PropertiesEditValueChanged(Sender: TObject);
    procedure dxMapControl1BingMapGeoCodingDataProvider1Response(
      Sender: TObject; AResponse: TdxBingMapLocationDataServiceResponse;
      var ADestroyResponse: Boolean);
    procedure dxMapControl1BingMapReverseGeoCodingDataProvider1Response(
      Sender: TObject; AResponse: TdxBingMapLocationDataServiceResponse;
      var ADestroyResponse: Boolean);
    procedure dxMapControl1BingMapRouteDataProvider1Response(Sender: TObject;
      AResponse: TdxBingMapRouteDataServiceResponse;
      var ADestroyResponse: Boolean);
    procedure dxMapControl1BingMapMajorRoadRouteDataProvider1Response(
      Sender: TObject; AResponse: TdxBingMapRouteDataServiceResponse;
      var ADestroyResponse: Boolean);
    procedure dxMapControl1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure dxMapControl1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cxTextEdit1PropertiesChange(Sender: TObject);
  private
    FAddedItemAddress: string;
    FCurrentCursorPos: TPoint;
    FHotPushpin: TdxMapPushpin;
    FRouteDataServiceResponse: TdxBingMapRouteDataServiceResponse;
    FRouteFromMajorRoadsDataServiceResponse: TdxBingMapRouteDataServiceResponse;
    FIsMajorRoadMode: Boolean;
    FRoutePins: TList<TdxMapPushpin>;
    FMajorRoadPins: TList<TdxMapPushpin>;
    FRoutes: TList<TdxMapPolyline>;
    FSearchText: string;
    FSearchPins: TList<TdxMapPushpin>;
    FSearchEditBackgroundColor: TdxAlphaColor;
    FWndProcLinkedObj: TcxWindowProcLinkedObject;
    function CreatePushpin: TdxMapPushpin;
    function GetCurrentCursorGeoPoint: TdxMapControlGeoPoint;
    function GetPinLetter(ANumber: Integer): string;
    function GetTravelDistanceStr(ADistanceInKilometers: Double): string;
    function GetTravelDurationStr(ATimeInSeconds: Double): string;
    procedure CalculateRoute;
    procedure CalculateRouteFromMajorRoads;
    procedure ClearMapItems<T:TdxMapItem>(AItems: TList<T>);
    function CheckResponse(AResponse: TdxBingMapResponse): Boolean;
    procedure CheckWaypointTexts(AItems: TList<TdxMapPushpin>);
    procedure ClearRoutePath;
    procedure ShowFullRoute(const ABoundingBox: TdxMapControlGeoRect);
    procedure CreateRouteLine(ARoute: TdxBingMapRouteInfo);
    procedure ClearAllPins;
    procedure ClearAllRouteInfo;
    procedure StopRouteProviders;
    procedure MapControlWndProc(var Message: TMessage);
  protected
    function GetDescription: string; override;
  public
    class function GetID: Integer; override;
    class function GetLoadingInfo: string; override;
    property CurrentCursorGeoPoint: TdxMapControlGeoPoint read GetCurrentCursorGeoPoint;
  end;

implementation

{$R *.dfm}

{ TfrmBingServices }

procedure TfrmBingServices.actAddEndPointExecute(Sender: TObject);
var
  APushpin: TdxMapPushpin;
begin
  StopRouteProviders;
  APushpin := CreatePushpin;
  APushpin.Location.GeoPoint := CurrentCursorGeoPoint;
  FRoutePins.Add(APushpin);
  CheckWaypointTexts(FRoutePins);
  dxMapControl1BingMapReverseGeoCodingDataProvider1.Search(APushpin.Location.GeoPoint);
  APushpin.Hint := FAddedItemAddress;
  CalculateRoute;
end;

procedure TfrmBingServices.actAddStartPointExecute(Sender: TObject);
var
  APushpin: TdxMapPushpin;
begin
  ClearAllRouteInfo;
  APushpin := CreatePushpin;
  APushpin.Location.GeoPoint := CurrentCursorGeoPoint;
  FRoutePins.Insert(0, APushpin);
  CheckWaypointTexts(FRoutePins);
  dxMapControl1BingMapReverseGeoCodingDataProvider1.Search(APushpin.Location.GeoPoint);
  APushpin.Hint := FAddedItemAddress;
end;

procedure TfrmBingServices.actChangeStartPointExecute(Sender: TObject);
begin
  StopRouteProviders;
  FRoutePins[0].Location.GeoPoint := CurrentCursorGeoPoint;
  dxMapControl1BingMapReverseGeoCodingDataProvider1.Search(FRoutePins[0].Location.GeoPoint);
  FRoutePins[0].Hint := FAddedItemAddress;
  CalculateRoute;
end;

procedure TfrmBingServices.actClearExecute(Sender: TObject);
begin
  ClearAllRouteInfo;
end;

procedure TfrmBingServices.actDeletePointExecute(Sender: TObject);
begin
  if FHotPushpin <> nil then
  begin
    StopRouteProviders;
    FMajorRoadPins.Remove(FHotPushpin);
    FRoutePins.Remove(FHotPushpin);
    FSearchPins.Remove(FHotPushpin);
    dxMapControl1ItemLayer1.MapItems.Remove(FHotPushpin);
    CheckWaypointTexts(FRoutePins);
    CalculateRoute;
  end;
end;

procedure TfrmBingServices.actRouteFromMajorRoadsExecute(Sender: TObject);
var
  APushpin: TdxMapPushpin;
begin
  StopRouteProviders;
  ClearAllRouteInfo;
  APushpin := CreatePushpin;
  APushpin.Location.GeoPoint := CurrentCursorGeoPoint;
  FMajorRoadPins.Add(APushpin);
  dxMapControl1BingMapReverseGeoCodingDataProvider1.Search(APushpin.Location.GeoPoint);
  APushpin.Hint := FAddedItemAddress;
  CheckWaypointTexts(FMajorRoadPins);
  CalculateRouteFromMajorRoads;
end;

procedure TfrmBingServices.actSetAsEndPointExecute(Sender: TObject);
begin
  if FHotPushpin <> nil then
  begin
    StopRouteProviders;
    FSearchPins.Remove(FHotPushpin);
    FRoutePins.Remove(FHotPushpin);
    FRoutePins.Add(FHotPushpin);
    CheckWaypointTexts(FRoutePins);
    CalculateRoute;
  end;
end;

procedure TfrmBingServices.actSetAsStartPointExecute(Sender: TObject);
begin
  if FHotPushpin <> nil then
  begin
    StopRouteProviders;
    FSearchPins.Remove(FHotPushpin);
    FMajorRoadPins.Remove(FHotPushpin);
    FRoutePins.Remove(FHotPushpin);
    FRoutePins.Insert(0, FHotPushpin);
    ClearMapItems<TdxMapPushpin>(FMajorRoadPins);
    CheckWaypointTexts(FRoutePins);
    CalculateRoute;
  end;
end;

procedure TfrmBingServices.dxBarLargeButton1Click(Sender: TObject);
var
  AOldTravelMode, ANewTravelMode: TdxBingMapTravelMode;
begin
  AOldTravelMode := dxMapControl1BingMapRouteDataProvider1.TravelMode;
  ANewTravelMode := TdxBingMapTravelMode((Sender as TComponent).Tag);
  if ANewTravelMode <> AOldTravelMode then
  begin
    dxMapControl1BingMapRouteDataProvider1.TravelMode := ANewTravelMode;
    dxMapControl1BingMapRouteDataProvider1.TimeType := bmttDeparture;
    dxMapControl1BingMapRouteDataProvider1.DateTime := Now;
    if FRoutePins.Count > 0 then
    begin
      StopRouteProviders;
      CalculateRoute;
    end;
  end;
end;

procedure TfrmBingServices.dxBarPopupMenu1Popup(Sender: TObject);
begin
  if dxMapControl1.HitTest.HitObject is TdxMapPointerViewInfo then
    FHotPushpin := TdxMapPointerViewInfo(dxMapControl1.HitTest.HitObject).Item as TdxMapPushpin
  else
    FHotPushpin := nil;
  miNewPointPointer.Location.GeoPoint := GetCurrentCursorGeoPoint;
  miNewPointPointer.Visible := FHotPushpin = nil;
  actDeletePoint.Enabled := (FHotPushpin <> nil) and (FMajorRoadPins.IndexOf(FHotPushpin) = -1);
  actAddEndPoint.Enabled := (FHotPushpin = nil) and (FRoutePins.Count > 0);
  actAddStartPoint.Visible := (FHotPushpin = nil) and (FRoutePins.Count = 0);
  actChangeStartPoint.Visible := (FHotPushpin = nil) and (FRoutePins.Count > 0);
  actSetAsEndPoint.Visible := (FHotPushpin <> nil) and (FRoutePins.Count > 0) and
   (FRoutePins[FRoutePins.Count - 1] <> FHotPushpin);
  actSetAsStartPoint.Visible := (FHotPushpin <> nil) and
   ((FRoutePins.Count = 0) or (FRoutePins[0] <> FHotPushpin));
end;

procedure TfrmBingServices.dxMapControl1BingMapGeoCodingDataProvider1Response(
  Sender: TObject; AResponse: TdxBingMapLocationDataServiceResponse;
  var ADestroyResponse: Boolean);
var
  APushpin: TdxMapPushpin;
  ALocationInfo: TdxBingMapLocationInfo;
begin
  if CheckResponse(AResponse) and (AResponse.Locations.Count > 0) then
  begin
    ALocationInfo := nil;
    for ALocationInfo in AResponse.Locations do
    begin
      APushpin := CreatePushpin;
      APushpin.Location.GeoPoint := ALocationInfo.Point;
      APushpin.Hint := ALocationInfo.GetDisplayText;
      FSearchPins.Add(APushpin);
    end;
    dxMapControl1.CenterPoint.GeoPoint := AResponse.Locations[0].Point;
    dxMapControl1.ZoomToGeoRect(ALocationInfo.BoundingBox);
  end;
end;

procedure TfrmBingServices.dxMapControl1BingMapMajorRoadRouteDataProvider1Response(
  Sender: TObject; AResponse: TdxBingMapRouteDataServiceResponse;
  var ADestroyResponse: Boolean);
var
  ARoute: TdxBingMapRouteInfo;
  APushpin: TdxMapPushpin;
  ARouteLeg: TdxBingMapRouteLeg;
  ARouteIndex: Integer;
begin
  if CheckResponse(AResponse) then
  begin
    cxListBox1.Clear;
    cxComboBox1.Properties.Items.Clear;
    FreeAndNil(FRouteFromMajorRoadsDataServiceResponse);
    FRouteFromMajorRoadsDataServiceResponse := AResponse;
    for ARouteIndex := 0 to AResponse.Routes.Count - 1 do
    begin
      ARoute := AResponse.Routes[ARouteIndex];
      CreateRouteLine(ARoute);
      cxComboBox1.Properties.Items.AddObject('Route ' + GetPinLetter(ARouteIndex + 1) + '-A', ARoute);
      if ARoute.RouteLegs.Count > 0 then
      begin
        ARouteLeg := ARoute.RouteLegs[0];
        APushpin := CreatePushpin;
        FMajorRoadPins.Add(APushpin);
        APushpin.Location.GeoPoint := ARouteLeg.ActualStart;
        if ARouteLeg.StartLocation <> nil then
          APushpin.Hint := ARouteLeg.StartLocation.GetDisplayText;
      end;
    end;
    CheckWaypointTexts(FMajorRoadPins);
    if cxComboBox1.Properties.Items.Count > 0 then
      cxComboBox1.ItemIndex := 0;
    ADestroyResponse := False;
  end;
end;

procedure TfrmBingServices.dxMapControl1BingMapReverseGeoCodingDataProvider1Response(
  Sender: TObject; AResponse: TdxBingMapLocationDataServiceResponse;
  var ADestroyResponse: Boolean);
begin
  if CheckResponse(AResponse) and (AResponse.Locations.Count > 0) then
    FAddedItemAddress := AResponse.Locations[0].GetDisplayText
  else
    FAddedItemAddress := '';
end;

procedure TfrmBingServices.dxMapControl1BingMapRouteDataProvider1Response(
  Sender: TObject; AResponse: TdxBingMapRouteDataServiceResponse;
  var ADestroyResponse: Boolean);
var
  ARoute: TdxBingMapRouteInfo;
  ARouteIndex: Integer;
  I: Integer;
begin
  if CheckResponse(AResponse) then
  begin
    cxComboBox1.Properties.Items.Clear;
    cxListBox1.Clear;
    FreeAndNil(FRouteDataServiceResponse);
    FRouteDataServiceResponse := AResponse;
    for ARouteIndex := 0 to AResponse.Routes.Count - 1 do
    begin
      ARoute := AResponse.Routes[ARouteIndex];
      CreateRouteLine(ARoute);
      cxComboBox1.Properties.Items.AddObject('Route ' + IntToStr(ARouteIndex + 1), ARoute);
      for I := 0 to ARoute.RouteLegs.Count - 1 do
        FRoutePins[I].Location.GeoPoint := ARoute.RouteLegs[I].ActualStart;
      FRoutePins.Last.Location.GeoPoint := ARoute.RouteLegs.Last.ActualEnd;
    end;
    if cxComboBox1.Properties.Items.Count > 0 then
      cxComboBox1.ItemIndex := 0;
    ADestroyResponse := False;
  end;
end;

procedure TfrmBingServices.dxMapControl1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FCurrentCursorPos := Point(X, Y);
end;

procedure TfrmBingServices.dxMapControl1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  miNewPointPointer.Visible := False;
end;

procedure TfrmBingServices.FormCreate(Sender: TObject);
begin
  (dxMapControl1ImageTileLayer1.Provider as TdxMapControlBingMapImageryDataProvider).BingKey := DXBingKey;
  FMajorRoadPins := TList<TdxMapPushpin>.Create;
  FRoutePins := TList<TdxMapPushpin>.Create;
  FSearchPins := TList<TdxMapPushpin>.Create;
  FRoutes := TList<TdxMapPolyline>.Create;
  dxMapControl1BingMapGeoCodingDataProvider1.BingKey := DXBingKey;
  dxMapControl1BingMapReverseGeoCodingDataProvider1.BingKey := DXBingKey;
  dxMapControl1BingMapRouteDataProvider1.BingKey := DXBingKey;
  dxMapControl1BingMapMajorRoadRouteDataProvider1.BingKey := DXBingKey;
  FWndProcLinkedObj := cxWindowProcController.Add(dxMapControl1, MapControlWndProc);
end;

procedure TfrmBingServices.FormDestroy(Sender: TObject);
begin
  cxWindowProcController.Remove(FWndProcLinkedObj);
  FreeAndNil(FRouteDataServiceResponse);
  FreeAndNil(FRouteFromMajorRoadsDataServiceResponse);
  FreeAndNil(FRoutes);
  FreeAndNil(FSearchPins);
  FreeAndNil(FRoutePins);
  FreeAndNil(FMajorRoadPins);
end;

class function TfrmBingServices.GetID: Integer;
begin
  Result := 3;
end;

class function TfrmBingServices.GetLoadingInfo: string;
begin
  Result := 'Bing Services Demo';
end;

function TfrmBingServices.CreatePushpin: TdxMapPushpin;
begin
  Result := dxMapControl1ItemLayer1.MapItems.Add(TdxMapPushpin) as TdxMapPushpin;
end;

function TfrmBingServices.GetCurrentCursorGeoPoint: TdxMapControlGeoPoint;
begin
  Result := dxMapControl1ImageTileLayer1.ScreenPointToGeoPoint(dxPointDouble(FCurrentCursorPos));
end;

function TfrmBingServices.GetPinLetter(ANumber: Integer): string;
begin
  Result := Chr(Ord('A') + ANumber);
end;

function TfrmBingServices.GetTravelDistanceStr(
  ADistanceInKilometers: Double): string;
begin
  Result := Format('%f km', [ADistanceInKilometers]);
end;

function TfrmBingServices.GetTravelDurationStr(ATimeInSeconds: Double): string;
var
  ATimeInt: Cardinal;
  AHour: Cardinal;
  AMinute: Word;
begin
  Result := '';
  ATimeInt := Round(ATimeInSeconds);
  AHour := ATimeInt div 3600;
  AMinute := (ATimeInt mod 3600) div 60;
  Result := IfThen(AHour > 0, IntToStr(AHour) + ' h ');
  if AMinute > 0 then
    Result := Result + IntToStr(AMinute) + ' min'
  else
    if AHour = 0 then
      Result := Result + '< 1' + ' min';
end;

procedure TfrmBingServices.MapControlWndProc(var Message: TMessage);
var
  AImage: TdxSmartImage;
  AGpImageCanvas: TdxGPCanvas;
begin
  FWndProcLinkedObj.DefaultProc(Message);
  if Message.Msg = WM_PAINT then
  begin
    if dxMapControl1.LookAndFeel.Painter.MapControlPanelBackColor <> FSearchEditBackgroundColor then
    begin
      FSearchEditBackgroundColor := dxMapControl1.LookAndFeel.Painter.MapControlPanelBackColor;
      AImage := TdxSmartImage.CreateSize(cxSize(182, 40));
      AGpImageCanvas := AImage.CreateCanvas;
      try
        AGpImageCanvas.Rectangle(AImage.ClientRect, 0, FSearchEditBackgroundColor);
      finally
        AGpImageCanvas.Free;
      end;
      cxImage1.Picture.Graphic := AImage;
    end
    else
      cxImage1.Invalidate;
  end;
end;

procedure TfrmBingServices.CalculateRoute;
var
  ARouteWaypoints: TdxBingMapRouteWaypoints;
  I: Integer;
begin
  FIsMajorRoadMode := False;
  ClearRoutePath;
  if FRoutePins.Count > 1 then
  begin
    ARouteWaypoints := TdxBingMapRouteWaypoints.Create;
    try
      for I := 0 to FRoutePins.Count - 1 do
        ARouteWaypoints.Add(FRoutePins[I].Location.GeoPoint);
      dxMapControl1BingMapRouteDataProvider1.CalculateAsync(ARouteWaypoints);
    finally
      ARouteWaypoints.Free;
    end;
  end;
end;

procedure TfrmBingServices.CalculateRouteFromMajorRoads;
var
  AWayPoint: TdxBingMapRouteWaypoint;
begin
  FIsMajorRoadMode := True;
  AWayPoint := TdxBingMapRouteWaypoint.Create(FMajorRoadPins[0].Location.GeoPoint);
  try
    dxMapControl1BingMapMajorRoadRouteDataProvider1.CalculateAsync(AWayPoint);
  finally
    AWayPoint.Free;
  end;
end;

procedure TfrmBingServices.ClearMapItems<T>(AItems: TList<T>);
var
  I: Integer;
  AMapItem: T;
begin
  for I := AItems.Count - 1 downto 0 do
  begin
    AMapItem := AItems[I];
    AItems.Delete(I);
    dxMapControl1ItemLayer1.MapItems.Remove(AMapItem);
  end;
end;

function TfrmBingServices.CheckResponse(
  AResponse: TdxBingMapResponse): Boolean;
begin
  Result := False;
  if AResponse <> nil then
    if AResponse.IsSuccess then
      Result := True
    else
      if AResponse.ErrorInfo <> nil then
        ShowMessage(AResponse.ErrorInfo.ErrorDetails);
end;

procedure TfrmBingServices.CheckWaypointTexts(AItems: TList<TdxMapPushpin>);
var
  I: Integer;
begin
  for I := 0 to AItems.Count - 1 do
    AItems[I].Text := GetPinLetter(I);
end;

procedure TfrmBingServices.ClearRoutePath;
begin
  miManeuverPoint.Visible := False;
  ClearMapItems<TdxMapPolyline>(FRoutes);
  cxListBox1.Clear;
  cxComboBox1.Properties.Items.Clear;
  FreeAndNil(FRouteDataServiceResponse);
  FreeAndNil(FRouteFromMajorRoadsDataServiceResponse);
end;

procedure TfrmBingServices.ShowFullRoute(const ABoundingBox: TdxMapControlGeoRect);
begin
  dxMapControl1.BeginUpdate;
  miManeuverPoint.Visible := False;
  dxMapControl1.ZoomToGeoRect(ABoundingBox);
  dxMapControl1.ZoomOut;
  dxMapControl1.EndUpdate;
end;

procedure TfrmBingServices.StopRouteProviders;
begin
  dxMapControl1BingMapRouteDataProvider1.CancelRequests;
  dxMapControl1BingMapMajorRoadRouteDataProvider1.CancelRequests;
end;

procedure TfrmBingServices.CreateRouteLine(ARoute: TdxBingMapRouteInfo);
var
  APolyline: TdxMapPolyline;
begin
  APolyline := dxMapControl1ItemLayer1.AddItem(TdxMapPolyline) as TdxMapPolyline;
  APolyline.GeoPoints.AddRange(ARoute.Path);
  APolyline.Style.BorderColor := $9F0000FF;
  APolyline.Style.BorderWidth := 4;
  APolyline.Hint := Format('Distance: %s, Duration: %s', [GetTravelDistanceStr(ARoute.TravelDistance),
    GetTravelDurationStr(ARoute.TravelDuration)]);
  APolyline.Tag := TdxNativeInt(ARoute);
  FRoutes.Add(APolyline);
end;

procedure TfrmBingServices.cxButton1Click(Sender: TObject);

  function MapRectUnion(const R1, R2: TdxMapControlGeoRect): TdxMapControlGeoRect;
  begin
    Result := R1;
    if (R2.Right - R2.Left <= 0) or (R2.Top - R2.Bottom <= 0) then Exit;
    if R2.Left < R1.Left then
      Result.Left := R2.Left;
    if R2.Top > R1.Top then
      Result.Top := R2.Top;
    if R2.Right > R1.Right then
      Result.Right := R2.Right;
    if R2.Bottom < R1.Bottom then
      Result.Bottom := R2.Bottom;
  end;

var
  I: Integer;
  ABoundingBox: TdxMapControlGeoRect;
begin
  cxListBox1.ItemIndex := -1;
  if (FRouteDataServiceResponse <> nil) and (FRouteDataServiceResponse.Routes.Count > 0) then
    ShowFullRoute(FRouteDataServiceResponse.Routes[0].BoundingBox)
  else
    if (FRouteFromMajorRoadsDataServiceResponse <> nil) and
      (FRouteFromMajorRoadsDataServiceResponse.Routes.Count > 0) then
    begin
      ABoundingBox := FRouteFromMajorRoadsDataServiceResponse.Routes[0].BoundingBox;
      for I := 1 to FRouteFromMajorRoadsDataServiceResponse.Routes.Count - 1 do
        ABoundingBox := MapRectUnion(ABoundingBox,
          FRouteFromMajorRoadsDataServiceResponse.Routes[I].BoundingBox);
      ShowFullRoute(ABoundingBox);
    end;
end;

procedure TfrmBingServices.cxComboBox1PropertiesEditValueChanged(
  Sender: TObject);
var
  I, J: Integer;
  ARoute: TdxBingMapRouteInfo;
  AItineraryItem: TdxBingMapItineraryItem;
begin
  if cxComboBox1.ItemIndex = -1 then
    Exit;
  ARoute := cxComboBox1.ItemObject as TdxBingMapRouteInfo;
  cxListBox1.Clear;
  if ARoute <> nil then
  begin
    for I := 0 to ARoute.RouteLegs.Count - 1 do
    begin
      for J := 0 to ARoute.RouteLegs[I].ItineraryItems.Count - 1 do
      begin
        AItineraryItem := ARoute.RouteLegs[I].ItineraryItems[J];
        cxListBox1.AddItem(AItineraryItem.Instruction.Description, AItineraryItem);
      end;
    end;
    dxMapControl1ItemLayer1.MapItems.BeginUpdate;
    for I := 0 to FRoutes.Count - 1 do
      FRoutes[I].Visible := FRoutes[I].Tag = TdxNativeInt(ARoute);
    dxMapControl1ItemLayer1.MapItems.EndUpdate;
  end;
end;

procedure TfrmBingServices.cxListBox1Click(Sender: TObject);
var
  AItineraryItem: TdxBingMapItineraryItem;
begin
  if cxListBox1.ItemIndex = -1 then
    Exit;

  AItineraryItem := cxListBox1.Items.Objects[cxListBox1.ItemIndex] as TdxBingMapItineraryItem;
  miManeuverPoint.Location.GeoPoint := AItineraryItem.ManeuverPoint;
  dxMapControl1.BeginUpdate;
  dxMapControl1.CenterPoint := miManeuverPoint.Location;
  dxMapControl1.ZoomLevel := 17;
  dxMapControl1.EndUpdate;
  miManeuverPoint.Visible := True;
end;

procedure TfrmBingServices.cxTextEdit1PropertiesChange(Sender: TObject);
begin
  if FSearchText <> cxTextEdit1.EditingText then
  begin
    FSearchText := cxTextEdit1.EditingText;
    dxMapControl1BingMapGeoCodingDataProvider1.CancelRequests;
    ClearMapItems<TdxMapPushpin>(FSearchPins);
    if FSearchText <> '' then
      dxMapControl1BingMapGeoCodingDataProvider1.SearchAsync(FSearchText);
  end;
end;

procedure TfrmBingServices.ClearAllPins;
begin
  ClearMapItems<TdxMapPushpin>(FRoutePins);
  ClearMapItems<TdxMapPushpin>(FSearchPins);
  ClearMapItems<TdxMapPushpin>(FMajorRoadPins);
end;

procedure TfrmBingServices.ClearAllRouteInfo;
begin
  ClearAllPins;
  ClearRoutePath;
end;

function TfrmBingServices.GetDescription: string;
begin
  Result := 'This demo illustrates how to create a route between points on the map using the Map Control and data from Bing Services';
end;

initialization
  TfrmBingServices.Register;

end.
