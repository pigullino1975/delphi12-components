{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           Model Diagram for ExpressEntityMapping Framework         }
{                                                                    }
{           Copyright (c) 2016-2024 Developer Express Inc.           }
{           ALL RIGHTS RESERVED                                      }
{                                                                    }
{   The entire contents of this file is protected by U.S. and        }
{   International Copyright Laws. Unauthorized reproduction,         }
{   reverse-engineering, and distribution of all or any portion of   }
{   the code contained in this file is strictly prohibited and may   }
{   result in severe civil and criminal penalties and will be        }
{   prosecuted to the maximum extent possible under the law.         }
{                                                                    }
{   RESTRICTIONS                                                     }
{                                                                    }
{   THIS SOURCE CODE AND ALL RESULTING INTERMEDIATE FILES            }
{   (DCU, OBJ, DLL, DPU, SO, ETC.) ARE CONFIDENTIAL AND PROPRIETARY  }
{   TRADE SECRETS OF DEVELOPER EXPRESS INC. THE REGISTERED DEVELOPER }
{   IS LICENSED TO DISTRIBUTE THE EXPRESSENTITYMAPPING FRAMEWORK     }
{   AS PART OF AN EXECUTABLE PROGRAM ONLY.                           }
{                                                                    }
{   THE SOURCE CODE CONTAINED WITHIN THIS FILE AND ALL RELATED       }
{   FILES OR ANY PORTION OF ITS CONTENTS SHALL AT NO TIME BE         }
{   COPIED, TRANSFERRED, SOLD, DISTRIBUTED, OR OTHERWISE MADE        }
{   AVAILABLE TO OTHER INDIVIDUALS WITHOUT EXPRESS WRITTEN CONSENT   }
{   AND PERMISSION FROM DEVELOPER EXPRESS INC.                       }
{                                                                    }
{   CONSULT THE END USER LICENSE AGREEMENT FOR INFORMATION ON        }
{   ADDITIONAL RESTRICTIONS.                                         }
{                                                                    }
{********************************************************************}

unit dxEMFChart;

interface

{$I cxVer.inc}

uses
  Windows, Messages, Types, UITypes, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Generics.Defaults, Generics.Collections, Vcl.ImgList,
  Math, cxLibraryConsts, dxGenerics, dxCoreGraphics, dxCore, dxGDIPlusAPI, dxLines, dxXMLDoc,
  cxControls, dxflchrt, cxGraphics, cxLookAndFeelPainters, cxClasses, cxGeometry, dxGDIPlusClasses, dxCoreClasses,
  dxEMFToolTypes, dxEMFModelObjects, dxTypeHelpers;

type
  TdxEMFChart = class;
  TdxEntityObject = class;
  TdxAssociationConnection = class;

  { TdxEntityObject }

  TdxEntityObject = class(TdxFcObject)
  public type
    TNodeType = (Table, &Object);
{$REGION 'internal classes'}
  protected type
    TItemViewInfo = class
    strict private
      FBounds: TRect;
      FOwner: TdxEntityObject;
      function GetChart: TdxEMFChart; inline;
      function GetIndent: TSize; inline;
    protected
      FTextBounds: TRect;
      function GetPaintBounds(const ABounds: TRect): TRect; inline;
      function GetText: string; virtual;
      procedure PrepareFont(ACanvas: TcxCanvas); virtual;
    public
      constructor Create(AOwner: TdxEntityObject);
      procedure Calculate(const ABounds: TRect); virtual;
      procedure PaintText(ACanvas: TcxCanvas); virtual;

      property Bounds: TRect read FBounds;
      property Chart: TdxEMFChart read GetChart;
      property Indent: TSize read GetIndent;
      property Owner: TdxEntityObject read FOwner;
      property Text: string read GetText;
      property TextBounds: TRect read FTextBounds;
    end;

    TTextViewInfo = class(TItemViewInfo)
    strict private
      FObject: TNamedPersistent;
      function GetImages: TCustomImageList; inline;
    protected
      function CalculateIconBounds(const ABounds: TRect): TRect;
      function GetIconLeftIndent: Integer; virtual;
      function GetSelected: Boolean;
      function GetText: string; override;
      procedure PrepareFont(ACanvas: TcxCanvas); override;
    public
      constructor Create(AOwner: TdxEntityObject; AObject: TNamedPersistent);
      function ContainsPoint(X, Y: Integer): Boolean;

      property Images: TCustomImageList read GetImages;
      property &Object: TNamedPersistent read FObject;
      property Selected: Boolean read GetSelected;
    end;

    TMemberViewInfo = class(TTextViewInfo)
    strict protected
      FIconBounds: TRect;
      procedure DrawImages(ACanvas: TcxCanvas); virtual;
      function GetIconLeftIndent: Integer; override;
    public
      procedure Calculate(const ABounds: TRect); override;
      procedure Paint(ACanvas: TcxCanvas);

      property IconBounds: TRect read FIconBounds;
    end;

    TPropertiesViewInfo = class(TItemViewInfo)
    strict private
      FItems: TObjectList<TMemberViewInfo>;
    public
      constructor Create(AOwner: TdxEntityObject);
      destructor Destroy; override;
      procedure Calculate(const ABounds: TRect; var ATop: Integer); reintroduce; virtual;
      function GetItemTop(AProperty: TNamedPersistent): Integer;
      procedure Paint(ACanvas: TcxCanvas); virtual;

      property Items: TObjectList<TMemberViewInfo> read FItems;
    end;

    TCaptionViewInfo = class(TTextViewInfo)
    strict private
      FExpandButtonBounds: TRect;
      FIconBounds: TRect;
    public
      procedure Calculate(const ABounds: TRect); override;
      procedure Paint(ACanvas: TcxCanvas);
      function PointInExpandButton(const P: TPoint): Boolean;

      property ExpandButtonBounds: TRect read FExpandButtonBounds;
      property IconBounds: TRect read FIconBounds;
    end;
{$ENDREGION}
  private
    FCaptionViewInfo: TCaptionViewInfo;
    FClientOrigin: TPoint;
    FEntity: TEntity;
    FExpanded: Boolean;
    FMinSize: TSize;
    FProperties: TList<TNamedPersistent>;
    FPropertiesViewInfo: TPropertiesViewInfo;
    FType: TNodeType;
    function GetBottom: Integer; inline;
    function GetChart: TdxEMFChart; overload;
    function GetExpandButtonSize: Integer; inline;
    function GetFocusedObject: TNamedPersistent;
    function GetImageSize: TSize; inline;
    function GetIndent: TSize; inline;
    function GetPainter: TcxCustomLookAndFeelPainter; inline;
    function GetTextLineHeight: Integer; inline;
    function GetTextOffset: Integer; inline;
    procedure SetExpanded(const Value: Boolean);
    procedure SetFocusedObject(Value: TNamedPersistent);
  protected
    procedure CalculateRealBounds; override;
    procedure CalculateCaption(const ABounds: TRect); virtual;
    procedure CalculateContent; virtual;
    function CalculateHeight: Integer; virtual;
    function CalculateWidth: Integer; virtual;
    procedure CalculateMembers(const ABounds: TRect); virtual;
    function CanProcessDblClick(const P: TPoint): Boolean;
    procedure ChangeScale(M, D: Integer); override;
    function GetCursor(P: TPoint): HCURSOR; virtual;
    function ImageHeight: Integer; inline;
    function ImageWidth: Integer; inline;
    function GetObjectAt(X, Y: Integer): TNamedPersistent;
    function GetPaintBounds(const ABounds: TRect): TRect; inline;
    procedure InitializeByEntity(AEntity: TEntity);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint(ACanvas: TcxCanvas); override;
    procedure PaintBackground(ACanvas: TcxCanvas); override;
    procedure PaintMembers(ACanvas: TcxCanvas);
    procedure ValidateSize(var AWidth, AHeight: Integer); override;
    procedure UpdateByEntity;
    procedure UpdateSize;
    procedure ZoomChanged; override;

    property CaptionViewInfo: TCaptionViewInfo read FCaptionViewInfo;
    property ExpandButtonSize: Integer read GetExpandButtonSize;
    property FocusedObject: TNamedPersistent read GetFocusedObject write SetFocusedObject;
    property ImageSize: TSize read GetImageSize;
    property Indent: TSize read GetIndent;
    property Painter: TcxCustomLookAndFeelPainter read GetPainter;
    property Properties: TList<TNamedPersistent> read FProperties;
    property PropertiesViewInfo: TPropertiesViewInfo read FPropertiesViewInfo;
    property TextLineHeight: Integer read GetTextLineHeight;
    property TextOffset: Integer read GetTextOffset;
  public
    constructor Create(AOwner: TdxEMFChart; AEntity: TEntity);
    destructor Destroy; override;

    property Bottom: Integer read GetBottom;
    property Chart: TdxEMFChart read GetChart;
    property Entity: TEntity read FEntity;
    property Expanded: Boolean read FExpanded write SetExpanded;
    property &Type: TNodeType read FType;
  end;

  { TdxEMFConnectionArrow }

  TdxEMFConnectionArrow = class(TdxFcConnectionArrow)
  strict private
    FTextBounds: TRect;
  private
    function GetConnection: TdxAssociationConnection;
    procedure CalculateTextBoundsForObjectPoint(APoint: Byte; const ASize: TSize; const P1, P2: TPoint);
  protected
    procedure CalculateTextBounds;
    function HasText: Boolean; inline;
    function IsSourceArrow: Boolean; inline;
    procedure PaintText(AGraphics: TdxGPGraphics);
    procedure Paint(AGraphics: TdxGPGraphics); override;
    procedure SetRealBounds; override;

    property Connection: TdxAssociationConnection read GetConnection;
    property TextBounds: TRect read FTextBounds;
  end;

  { TdxEMFConnection }

  TdxEMFConnection = class(TdxFcConnection)
  public type
    TConnectionType = (OneToOne, OneToMany, {ManyToMany,} Inheritance);
  strict private
    FType: TConnectionType;
    function GetArrowDest: TdxEMFConnectionArrow; inline;
    function GetArrowSource: TdxEMFConnectionArrow; inline;
    function GetChart: TdxEMFChart; inline;
    function GetObjectDest: TdxEntityObject; inline;
    function GetObjectSource: TdxEntityObject; inline;
  protected
    procedure AdjustObjectsPoints(var APointSource, APointDest: Byte); override;
    procedure CalculateTextRects; override;
    function CreateArrow: TdxFcConnectionArrow; override;
    function GetDisplayRect: TRect; override;
    function GetSourceEntity: TEntity; virtual; abstract;
    function GetDestEntity: TEntity; virtual; abstract;
    function IsSelected: Boolean; virtual;

    function Update: Boolean; virtual;

    property ObjectSource: TdxEntityObject read GetObjectSource;
    property ObjectDest: TdxEntityObject read GetObjectDest;
    property &Type: TConnectionType read FType write FType;
  public
    constructor Create(AOwner: TdxCustomFlowChart; AType: TConnectionType);
    procedure AfterConstruction; override;

    property ArrowDest: TdxEMFConnectionArrow read GetArrowDest;
    property ArrowSource: TdxEMFConnectionArrow read GetArrowSource;
    property Chart: TdxEMFChart read GetChart;
  end;

  { TdxAssociationConnection }

  TdxAssociationConnection = class(TdxEMFConnection)
  strict private
    FAssociation: TAssociation;
    FEnd1: TCustomEntityProperty;
    FEnd2: TCustomEntityProperty;
  protected
    function CanRoute: Boolean; override;
    function GetDestEntity: TEntity; override;
    function GetSourceEntity: TEntity; override;
    procedure GetStartEndPoints(out AStart, AEnd: TPoint); override;
    function IsSelected: Boolean; override;
    function Update: Boolean; override;
  public
    constructor Create(AOwner: TdxCustomFlowChart; AAssociation: TAssociation);

    property Association: TAssociation read FAssociation;
  end;

  { TdxInheritanceConnection }

  TdxInheritanceConnection = class(TdxEMFConnection)
  strict private
    FInheritance: TInheritance;
    procedure UpdateInheritanceType;
  protected
    function GetSourceEntity: TEntity; override;
    function GetDestEntity: TEntity; override;
    function IsSelected: Boolean; override;
    function Update: Boolean; override;
  public
    constructor Create(AOwner: TdxCustomFlowChart; AInheritance: TInheritance);

    property Inheritance: TInheritance read FInheritance;
  end;

  { TdxEMFChartSelection }

  TdxEMFChartSelection = class(TdxFcSelection)
  strict protected
    procedure DrawSelectionFrame(AGraphics: TdxGPGraphics; const ABounds: TRect); override;
    function ShowEndpointsMarks: Boolean; override;
  end;

  { TdxEMFChart }

  TdxEMFChartInspectedObjectChanged = procedure (Sender: TNamedPersistent) of object;

  TdxEMFChart = class(TdxFlowChart)
  protected const
    ZeroToOneText = '0..1';
    InfinityText  = #$221E;
  protected type
    TCachedImages = class
    strict private
      FOwner: TdxEMFChart;
      FSize: TSize;
    public
      constructor Create(AOwner: TdxEMFChart);
      procedure Draw(ACanvas: TcxCanvas; const AOrigin: TPoint; ANamedPersistent: TNamedPersistent);
      procedure UpdateImageSize;
    end;
  strict private
    FArrowFont: TFont;
    FCachedImages: TCachedImages;
    FExpandButtonSize: Integer;
    FImageSize: TSize;
    FIndent: TSize;
    FInfinityTextSize: TSize;
    FInspectedObject: TNamedPersistent;
    FLockSelection: Boolean;
    FRoutingStrategy: TdxDiagramRoutingStrategy;
    FTextLineHeight: Integer;
    FTextOffset: Integer;
    FZeroToOneTextSize: TSize;
    FOnInspectedObjectChanged: TdxEMFChartInspectedObjectChanged;
    function GetEntity(Index: Integer): TdxEntityObject; inline;
    function GetEntityCount: Integer; inline;
    function GetGridSize: Integer; inline;
    procedure SetInspectedObject(const Value: TNamedPersistent);
    procedure WMSetCursor(var Message: TWMSetCursor); message WM_SETCURSOR;
  protected
    procedure CalculateArrowsText;
    procedure CalculateFontRelatedSizes; override;
    function CalculateTextLineHeight: Integer;
    procedure CalculateCachedValues;
    function CanCreateNewConnectionOnDrag: Boolean; override;
    function CanDetachConnections: Boolean; override;
    function CanDragConnectionEndpoints: Boolean; override;
    function CanDragConnectionIntermediatePoints: Boolean; override;
    function CanResizeObjectsHorizontal: Boolean; override;
    function CanResizeObjectsVertical: Boolean; override;
    function CreateAssociation(AAssociation: TAssociation): TdxAssociationConnection; overload; virtual;
    function CreateEntityObject(AEntity: TEntity; ALeft, ATop: Integer): TdxEntityObject; overload; virtual;
    function CreateEntityObject(AEntity: TEntity; ALeft, ATop, AWidth, AHeight: Integer; AExpanded: Boolean): TdxEntityObject; overload; virtual;
    function CreateInheritance(AInheritance: TInheritance): TdxInheritanceConnection;
    function CreateSelection: TdxFcSelection; override;
    function FindAssociationObject(AAssociation: TAssociation): TdxAssociationConnection;
    function FindEntityObject(AEntity: TEntity): TdxEntityObject;
    function FindInheritanceObject(AInheritance: TInheritance): TdxInheritanceConnection;
    function GetAutoRouting: Boolean; override;
    procedure ImageListChanged; override;
    function InternalCreateConnection: TdxFcConnection; override;
    function InternalCreateObject: TdxFcObject; override;
    procedure Click; override;
    procedure DblClick; override;
    procedure DoInspectedObjectChanged;
    procedure FontChanged; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    function NeedAdjustObjectsPoints: Boolean; override;
    procedure RemoveAssociationFromDiagram(AAssociation: TAssociation);
    procedure RemoveInheritanceFromDiagram(AInheritance: TInheritance);
    procedure Select(Item: TdxFcItem); override;
    procedure UpdateEntity(AEntity: TEntity);
    procedure UpdatePaintScaleFactor; override;
    function UseDummyEdgesForRouting: Boolean; override;

    property ArrowFont: TFont read FArrowFont;
    property CachedImages: TCachedImages read FCachedImages;
    property ExpandButtonSize: Integer read FExpandButtonSize;
    property GridSize: Integer read GetGridSize;
    property ImageSize: TSize read FImageSize;
    property Indent: TSize read FIndent;
    property InfinityTextSize: TSize read FInfinityTextSize;
    property RoutingStrategy: TdxDiagramRoutingStrategy read FRoutingStrategy;
    property TextLineHeight: Integer read FTextLineHeight;
    property TextOffset: Integer read FTextOffset;
    property ZeroToOneTextSize: TSize read FZeroToOneTextSize;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function ContainsAssociation(AAssociation: TAssociation): Boolean;
    function ContainsEntity(AEntity: TEntity): Boolean;
    procedure CreateDiagram(AModel: TDataModel);
    procedure AddEntityToDiagram(AModel: TDataModel; AEntity: TEntity);
    procedure AddNamedPersistent(AObject: TNamedPersistent);
    procedure DeleteNamedPersistent(AObject: TNamedPersistent);
    procedure EnsureInspectedObjectVisible;
    procedure LoadFromXml(AModel: TDataModel; ARoot: TdxXMLNode);
    procedure NamedPersistentNameChanged(AObject: TNamedPersistent);
    procedure NamedPersistentPropertyChanged(AObject: TNamedPersistent);
    procedure RemoveEntityFromDiagram(AEntity: TEntity);
    procedure StoreToXml(ARoot: TdxXMLNode);

    property EntityCount: Integer read GetEntityCount;
    property Entities[Index: Integer]: TdxEntityObject read GetEntity;
    property InspectedObject: TNamedPersistent read FInspectedObject write SetInspectedObject;
  published
    property OnInspectedObjectChanged: TdxEMFChartInspectedObjectChanged read FOnInspectedObjectChanged write FOnInspectedObjectChanged;
  end;

{$IFDEF CXTEST}
procedure Register;
{$ENDIF}

implementation

{$IFDEF CXTEST}
procedure Register;
begin
  RegisterComponents('ExpressEntityMapping Framework', [TdxEMFChart]);
end;
{$ENDIF}

{ TdxEntityObject }

constructor TdxEntityObject.Create(AOwner: TdxEMFChart; AEntity: TEntity);
begin
  inherited Create(AOwner);
  FEntity := AEntity;
  FProperties := TList<TNamedPersistent>.Create;
  InitializeByEntity(AEntity);
  FCaptionViewInfo := TCaptionViewInfo.Create(Self, AEntity);
  FPropertiesViewInfo := TPropertiesViewInfo.Create(Self);
  FExpanded := True;
  BkColor := clInfoBk;
  ShapeType := fcsRectangle;
end;

destructor TdxEntityObject.Destroy;
begin
  FPropertiesViewInfo.Free;
  FCaptionViewInfo.Free;
  FProperties.Free;
  inherited Destroy;
end;

function TdxEntityObject.GetCursor(P: TPoint): HCURSOR;
begin
  if CaptionViewInfo.PointInExpandButton(P) or (GetObjectAt(P.X, P.Y) <> nil) then
    Result := Screen.Cursors[crDefault]
  else
    Result := Screen.Cursors[crSizeAll];
end;

function TdxEntityObject.GetExpandButtonSize: Integer;
begin
  Result := Chart.ExpandButtonSize;
end;

function TdxEntityObject.GetFocusedObject: TNamedPersistent;
begin
  Result := Chart.InspectedObject;
end;

function TdxEntityObject.GetImageSize: TSize;
begin
  Result := Chart.ImageSize;
end;

function TdxEntityObject.GetIndent: TSize;
begin
  Result := Chart.Indent;
end;

function TdxEntityObject.ImageHeight: Integer;
begin
  Result := Chart.ImageSize.cy;
end;

function TdxEntityObject.ImageWidth: Integer;
begin
  Result := Chart.ImageSize.cx;
end;

function TdxEntityObject.GetTextLineHeight: Integer;
begin
  Result := Chart.TextLineHeight;
end;

function TdxEntityObject.GetTextOffset: Integer;
begin
  Result := Chart.TextOffset;
end;

function TdxEntityObject.CalculateHeight: Integer;
var
  ALineHeight: Integer;
begin
  ALineHeight := TextLineHeight + Indent.cy;
  Result := ALineHeight;
  if Expanded then
  begin
    Inc(Result, ALineHeight * Properties.Count);
    Inc(Result, Indent.cy);
  end;
end;

function TdxEntityObject.CalculateWidth: Integer;
var
  I, AMembersWidth, AMaxItemTextWidth: Integer;
begin
  Result := ImageWidth + Indent.cx * 4 + TextLineHeight;
  cxScreenCanvas.Font := Font;
  try
    cxScreenCanvas.Font.Style := cxScreenCanvas.Font.Style + [fsBold];
    Inc(Result, cxScreenCanvas.TextWidth(CaptionViewInfo.Text));
    AMaxItemTextWidth := 0;
    for I := 0 to Properties.Count - 1 do
      AMaxItemTextWidth := Max(AMaxItemTextWidth, cxScreenCanvas.TextWidth(Properties[I].Name));
    AMembersWidth := AMaxItemTextWidth + TextOffset + Indent.cx * 2;
    Result := Max(Result, AMembersWidth);
    cxScreenCanvas.Font.Style := cxScreenCanvas.Font.Style - [fsBold];
  finally
    cxScreenCanvas.Dormant;
  end;
end;

function TdxEntityObject.CanProcessDblClick(const P: TPoint): Boolean;
begin
  Result := not CaptionViewInfo.PointInExpandButton(P);
end;

procedure TdxEntityObject.ChangeScale(M, D: Integer);
begin
  FMinSize.Init(0, 0);
  inherited ChangeScale(M, D);
end;

procedure TdxEntityObject.ValidateSize(var AWidth, AHeight: Integer);
var
  APaintGridSize: Integer;
begin
  if Chart.IsScaleChanging then
    Exit;
  APaintGridSize := Chart.ScaleFactor.Apply(Chart.GridSize);
  if FMinSize.IsZero then
  begin
    FMinSize.cy := CalculateHeight;
    FMinSize.cx := Ceil(CalculateWidth / APaintGridSize) * APaintGridSize;
  end;
  AWidth := Round(AWidth / APaintGridSize) * APaintGridSize;
  AWidth := Max(AWidth, FMinSize.cx);
  AHeight := FMinSize.cy;
end;

procedure TdxEntityObject.CalculateRealBounds;
begin
  inherited CalculateRealBounds;
  CalculateContent;
end;

procedure TdxEntityObject.CalculateCaption(const ABounds: TRect);
begin
  FCaptionViewInfo.Calculate(ABounds);
end;

procedure TdxEntityObject.CalculateContent;
var
  R: TRect;
  ALineHeight: Integer;
begin
  if CaptionViewInfo = nil then
    Exit;
  ALineHeight := TextLineHeight + Indent.cy;
  R.Init(0, 0, Width, 0);
  R.Height := ALineHeight;
  CalculateCaption(R);
  if Expanded then
  begin
    R.InitSize(0, ALineHeight, Width, ALineHeight);
    CalculateMembers(R);
  end;
end;

procedure TdxEntityObject.CalculateMembers(const ABounds: TRect);
var
  ATop: Integer;
begin
  ATop := ABounds.Top;
  PropertiesViewInfo.Calculate(ABounds, ATop);
end;

function TdxEntityObject.GetObjectAt(X, Y: Integer): TNamedPersistent;
var
  AMemberViewInfo: TMemberViewInfo;
begin
  for AMemberViewInfo in PropertiesViewInfo.Items do
    if AMemberViewInfo.ContainsPoint(X, Y) then
      Exit(AMemberViewInfo.&Object);
  Result := nil;
end;

function TdxEntityObject.GetPaintBounds(const ABounds: TRect): TRect;
begin
  Result := ABounds;
  Result.Offset(FClientOrigin);
end;

function TdxEntityObject.GetBottom: Integer;
begin
  Result := Top + Height;
end;

function TdxEntityObject.GetChart: TdxEMFChart;
begin
  Result := TdxEMFChart(inherited Owner);
end;

function TdxEntityObject.GetPainter: TcxCustomLookAndFeelPainter;
begin
  Result := Chart.LookAndFeel.Painter;
end;

procedure TdxEntityObject.InitializeByEntity(AEntity: TEntity);
var
  AItem: TNamedPersistent;
begin
  FProperties.Clear;
  for AItem in AEntity.Children do
    FProperties.Add(AItem);
end;

procedure TdxEntityObject.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  AClickedMember: TNamedPersistent;
begin
  inherited MouseDown(Button, Shift, X, Y);
  case Button of
    mbLeft, mbRight:
      begin
        if (Button = mbLeft) and CaptionViewInfo.PointInExpandButton(Point(X, Y)) then
        begin
          Expanded := not Expanded;
          if not Expanded then
            FocusedObject := Entity;
        end
        else
        begin
          AClickedMember := GetObjectAt(X, Y);
          if AClickedMember <> nil then
            FocusedObject := AClickedMember
          else
            FocusedObject := Entity;
        end;
      end;
  end;
end;

procedure TdxEntityObject.Paint(ACanvas: TcxCanvas);
begin
  ACanvas.SaveClipRegion;
  PaintBackground(ACanvas);
  FClientOrigin := ClientRect.Location;
  FCaptionViewInfo.Paint(ACanvas);
  if Expanded then
    PaintMembers(ACanvas);
  ACanvas.RestoreClipRegion;
end;

procedure TdxEntityObject.PaintBackground(ACanvas: TcxCanvas);
const
  CaptionStates: array[Boolean] of TcxButtonState = (cxbsNormal, cxbsHot);
var
  R, ACaptionBounds: TRect;
begin
  R := DisplayRect;
  ACaptionBounds := R;
  ACaptionBounds.Height := MulDiv(TextLineHeight + Indent.cy, Owner.RealZoom, 100);
  Painter.LayoutViewDrawRecordCaption(ACanvas, ACaptionBounds, TRect.Null, cxgpTop, CaptionStates[Selected]);
  R.Top := ACaptionBounds.Bottom;
  Painter.LayoutViewDrawRecordContent(ACanvas, R, cxgpTop, CaptionStates[Selected],  [bLeft, bRight, bBottom]);
end;

procedure TdxEntityObject.PaintMembers(ACanvas: TcxCanvas);
begin
  PropertiesViewInfo.Paint(ACanvas);
end;

procedure TdxEntityObject.SetExpanded(const Value: Boolean);
begin
  if Value <> Expanded then
  begin
    FExpanded := Value;
    UpdateSize;
  end;
end;

procedure TdxEntityObject.SetFocusedObject(Value: TNamedPersistent);
begin
  if Value <> FocusedObject then
  begin
    Chart.InspectedObject := Value;
    Chart.Invalidate;
  end;
end;

procedure TdxEntityObject.UpdateByEntity;
begin
  InitializeByEntity(Entity);
  UpdateSize;
  Chart.NeedRepaintObject(Self);
  Chart.InvalidateRouting;
end;

procedure TdxEntityObject.UpdateSize;
begin
  Chart.BeginUpdate;
  try
    FMinSize.Init(0, 0);
    CalculateRealBounds;
    SetBounds(Left, Top, Width, Height);
  finally
    Chart.EndUpdate;
  end;
end;

procedure TdxEntityObject.ZoomChanged;
begin
  inherited ZoomChanged;
  UpdateSize;
end;

{ TdxEntityObject.TItemViewInfo }

constructor TdxEntityObject.TItemViewInfo.Create(AOwner: TdxEntityObject);
begin
  FOwner := AOwner;
end;

procedure TdxEntityObject.TItemViewInfo.Calculate(const ABounds: TRect);
begin
  FBounds := ABounds;
end;

procedure TdxEntityObject.TItemViewInfo.PaintText(ACanvas: TcxCanvas);
begin
  PrepareFont(ACanvas);
  ACanvas.Brush.Style := bsClear;
  ACanvas.DrawTexT(Text, GetPaintBounds(TextBounds), taLeftJustify, vaCenter, False, True);
  ACanvas.Brush.Style := bsSolid;
end;

procedure TdxEntityObject.TItemViewInfo.PrepareFont(ACanvas: TcxCanvas);
begin
  ACanvas.Font := Owner.RealFont;
end;

function TdxEntityObject.TItemViewInfo.GetIndent: TSize;
begin
  Result := Owner.Indent;
end;

function TdxEntityObject.TItemViewInfo.GetPaintBounds(const ABounds: TRect): TRect;
begin
  Result := cxRectScale(ABounds, Chart.RealZoom, 100);
  Result := Owner.GetPaintBounds(Result);
end;

function TdxEntityObject.TItemViewInfo.GetChart: TdxEMFChart;
begin
  Result := Owner.Chart;
end;

function TdxEntityObject.TItemViewInfo.GetText: string;
begin
  Result := '';
end;

{ TdxEntityObject.TTextViewInfo }

constructor TdxEntityObject.TTextViewInfo.Create(AOwner: TdxEntityObject; AObject: TNamedPersistent);
begin
  inherited Create(AOwner);
  FObject := AObject;
end;

function TdxEntityObject.TTextViewInfo.CalculateIconBounds(const ABounds: TRect): TRect;
begin
  Result.InitSize(GetIconLeftIndent, 0, Owner.ImageWidth, Owner.ImageHeight);
  Result.Offset(ABounds.Left, ABounds.Top + (ABounds.Height - Result.Height) div 2);
end;

function TdxEntityObject.TTextViewInfo.ContainsPoint(X, Y: Integer): Boolean;
begin
  Result := GetPaintBounds(Bounds).Contains(X, Y);
end;

procedure TdxEntityObject.TTextViewInfo.PrepareFont(ACanvas: TcxCanvas);
begin
  inherited PrepareFont(ACanvas);
  if Selected then
    ACanvas.Font.Style := ACanvas.Font.Style + [fsBold];
end;

function TdxEntityObject.TTextViewInfo.GetIconLeftIndent: Integer;
begin
  Result := Indent.cx;
end;

function TdxEntityObject.TTextViewInfo.GetImages: TCustomImageList;
begin
  Result := Chart.Images;
end;

function TdxEntityObject.TTextViewInfo.GetSelected: Boolean;
begin
  Result := Owner.FocusedObject = &Object;
end;

function TdxEntityObject.TTextViewInfo.GetText: string;
begin
  Result := FObject.Name;
end;

{ TdxEntityObject.TCaptionViewInfo }

procedure TdxEntityObject.TCaptionViewInfo.Calculate(const ABounds: TRect);
var
  AButtonGap: Integer;
begin
  inherited Calculate(ABounds);
  FIconBounds := CalculateIconBounds(ABounds);
  AButtonGap := Indent.cy div 2;
  FExpandButtonBounds.Top := ABounds.Top + AButtonGap;
  FExpandButtonBounds.Bottom := ABounds.Bottom - AButtonGap - 1;
  FExpandButtonBounds.Right := ABounds.Right - AButtonGap - 1;
  FExpandButtonBounds.Left := FExpandButtonBounds.Right - FExpandButtonBounds.Height;
  FTextBounds := ABounds;
  FTextBounds.Left := FIconBounds.Right + Indent.cx;
  FTextBounds.Right := FExpandButtonBounds.Left - Indent.cx;
end;

procedure TdxEntityObject.TCaptionViewInfo.Paint(ACanvas: TcxCanvas);
begin
  Chart.CachedImages.Draw(ACanvas, GetPaintBounds(IconBounds).TopLeft, &Object);
  PaintText(ACanvas);
  Owner.Painter.DrawScaledExpandButtonEx(ACanvas, GetPaintBounds(ExpandButtonBounds), cxbsNormal, Owner.Expanded, Chart.PaintScaleFactor);
end;

function TdxEntityObject.TCaptionViewInfo.PointInExpandButton(const P: TPoint): Boolean;
begin
  Result := GetPaintBounds(ExpandButtonBounds).Contains(P.X, P.Y);
end;

{ TdxEntityObject.TMemberViewInfo }

procedure TdxEntityObject.TMemberViewInfo.Calculate(const ABounds: TRect);
begin
  inherited Calculate(ABounds);
  FIconBounds := CalculateIconBounds(ABounds);
  FTextBounds := ABounds;
  Inc(FTextBounds.Left, Owner.TextOffset);
  Dec(FTextBounds.Right, Indent.cx);
end;

procedure TdxEntityObject.TMemberViewInfo.DrawImages(ACanvas: TcxCanvas);
begin
  Chart.CachedImages.Draw(ACanvas, GetPaintBounds(FIconBounds).TopLeft, &Object);
end;

function TdxEntityObject.TMemberViewInfo.GetIconLeftIndent: Integer;
begin
  Result := inherited GetIconLeftIndent;
  Inc(Result, Owner.ImageWidth);
end;

procedure TdxEntityObject.TMemberViewInfo.Paint(ACanvas: TcxCanvas);
var
  R: TRect;
begin
  if Selected then
  begin
    R := Bounds;
    R.Inflate(-Indent.cx div 2, -Indent.cx div 3);
    Owner.Painter.LayoutViewDrawItem(ACanvas, GetPaintBounds(R), cxbsHot, cxBordersAll);
  end;
  DrawImages(ACanvas);
  PaintText(ACanvas);
end;

{ TdxEntityObject.TPropertiesViewInfo }

constructor TdxEntityObject.TPropertiesViewInfo.Create(AOwner: TdxEntityObject);
begin
  inherited Create(AOwner);
  FItems := TObjectList<TMemberViewInfo>.Create;
end;

destructor TdxEntityObject.TPropertiesViewInfo.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

function TdxEntityObject.TPropertiesViewInfo.GetItemTop(AProperty: TNamedPersistent): Integer;
var
  I, ATextLineHeight: Integer;
begin
  ATextLineHeight := Owner.TextLineHeight + Owner.Indent.cy;
  Result := ATextLineHeight + Owner.TextLineHeight div 2 + Owner.Indent.cy;
  for I := 0 to Items.Count - 1 do
  begin
    if Items[I].&Object = AProperty then
      Break;
    Inc(Result, ATextLineHeight);
  end;
  Result := MulDiv(Result, Chart.RealZoom, 100);
  Inc(Result, Owner.RealTop);
end;

procedure TdxEntityObject.TPropertiesViewInfo.Paint(ACanvas: TcxCanvas);
var
  I: Integer;
begin
  for I := 0 to Items.Count - 1 do
    Items[I].Paint(ACanvas);
end;

procedure TdxEntityObject.TPropertiesViewInfo.Calculate(const ABounds: TRect; var ATop: Integer);
var
  I, ATextLineHeight: Integer;
  AItemBounds: TRect;
  AItemViewInfo: TMemberViewInfo;
begin
  Items.Clear;
  ATextLineHeight := Owner.TextLineHeight + Owner.Indent.cy;
  AItemBounds := ABounds;
  AItemBounds.Top := ATop;
  AItemBounds.Height := ATextLineHeight;
  for I := 0 to Owner.Properties.Count - 1 do
  begin
    AItemViewInfo := TMemberViewInfo.Create(Owner, Owner.Properties[I]);
    AItemViewInfo.Calculate(AItemBounds);
    Items.Add(AItemViewInfo);
    AItemBounds.Offset(0, ATextLineHeight);
  end;
  ATop := AItemBounds.Top;
end;

{ TdxEMFConnectionArrow }

procedure TdxEMFConnectionArrow.CalculateTextBounds;
var
  ASize: TSize;
  ASourcePoint, ADestPoint: TPoint;
begin
  FTextBounds.Empty;
  if not HasText then
    Exit;
  ASourcePoint := Connection.RealPoints[0];
  ADestPoint := Connection.RealPoints[Connection.RealCount - 1];
  if IsSourceArrow then
  begin
    ASize := Connection.Chart.ZeroToOneTextSize;
    CalculateTextBoundsForObjectPoint(Connection.PointSource, ASize, ASourcePoint, ADestPoint);
  end
  else
  begin
    if Connection.&Type = OneToMany then
      ASize := Connection.Chart.InfinityTextSize
    else
      ASize := Connection.Chart.ZeroToOneTextSize;
    CalculateTextBoundsForObjectPoint(Connection.PointDest, ASize, ADestPoint, ASourcePoint);
  end;
end;

procedure TdxEMFConnectionArrow.CalculateTextBoundsForObjectPoint(APoint: Byte; const ASize: TSize;
  const P1, P2: TPoint);
var
  ABounds: TRect;
begin
  ABounds := DisplayRect(False);
  FTextBounds := TRect.CreateSize(ASize);
  case APoint of
    1..3:  // top
      begin
        FTextBounds.Y := ABounds.Top - ASize.cy;
        FTextBounds.X := ABounds.Left - ASize.cx;
      end;
    5..7:  // right
      begin
        FTextBounds.X := ABounds.Right;
        FTextBounds.Y := ABounds.Top - ASize.cy;
      end;
    9..11: // bottom
      begin
        FTextBounds.Y := ABounds.Bottom;
        FTextBounds.X := ABounds.Left - ASize.cx;
      end;
    13..15: // left
      begin
        FTextBounds.X := ABounds.Left - ASize.cx;
        FTextBounds.Y := ABounds.Top - ASize.cy;
      end;
  end;
end;

function TdxEMFConnectionArrow.GetConnection: TdxAssociationConnection;
begin
  Result := TdxAssociationConnection(Owner);
end;

function TdxEMFConnectionArrow.HasText: Boolean;
begin
  Result := Connection.&Type <> Inheritance;
end;

function TdxEMFConnectionArrow.IsSourceArrow: Boolean;
begin
  Result := Connection.ArrowSource = Self;
end;

procedure TdxEMFConnectionArrow.PaintText(AGraphics: TdxGPGraphics);
var
  ADC: HDC;
  AFont: HFONT;
  AText: string;
  AOldMode: Cardinal;
begin
  if (Connection.&Type = OneToMany) and not IsSourceArrow then
    AText := TdxEMFChart.InfinityText
  else
    AText := TdxEMFChart.ZeroToOneText;
  ADC := AGraphics.GetHDC;
  try
    AFont := SelectObject(ADC, Connection.RealFont.Handle);
    AOldMode := SetBkMode(ADC, TRANSPARENT);
    TextOut(ADC, FTextBounds.Left, FTextBounds.Top, PChar(AText), Length(AText));
    SetBkMode(ADC, AOldMode);
    SelectObject(ADC, AFont);
  finally
    AGraphics.ReleaseHDC(ADC);
  end;
end;

procedure TdxEMFConnectionArrow.Paint(AGraphics: TdxGPGraphics);
begin
  inherited Paint(AGraphics);
  if HasText then
  begin
    CalculateTextBounds;
    PaintText(AGraphics);
  end;
end;

procedure TdxEMFConnectionArrow.SetRealBounds;
begin
  inherited SetRealBounds;
  CalculateTextBounds;
end;

{ TdxEMFConnection }

constructor TdxEMFConnection.Create(AOwner: TdxCustomFlowChart; AType: TConnectionType);
begin
  inherited Create(AOwner);
  FType := AType;
end;

procedure TdxEMFConnection.AfterConstruction;
begin
  inherited AfterConstruction;
  ArrowDest.Size := fcasMedium;
  ArrowSource.Size := fcasMedium;
end;

procedure TdxEMFConnection.CalculateTextRects;
begin
  inherited CalculateTextRects;
  FDisplayRect.Union(ArrowSource.TextBounds);
  FDisplayRect.Union(ArrowDest.TextBounds);
end;

function TdxEMFConnection.CreateArrow: TdxFcConnectionArrow;
begin
  Result := TdxEMFConnectionArrow.Create(Self);
end;

procedure TdxEMFConnection.AdjustObjectsPoints(var APointSource, APointDest: Byte);
var
  ActualPoints: TArray<Byte>;
  AMinSquareDistance, ASquareDistance: Int64;
  I, J, ASourcePointIndex, ADestPointIndex: Integer;
begin
  if &Type = TConnectionType.Inheritance then
    ActualPoints := TArray<Byte>.Create(1, 2, 3, 9, 10, 11)
  else
    ActualPoints := TArray<Byte>.Create(5, 6, 7, 13, 14, 15);
  ASourcePointIndex := -1;
  ADestPointIndex := -1;
  AMinSquareDistance := MaxInt64;
  for I := Low(ActualPoints) to High(ActualPoints) do
    for J := Low(ActualPoints) to High(ActualPoints) do
    begin
      ASquareDistance :=
        Sqr(ObjectSource.LinkedPoints[ActualPoints[I]].X - ObjectDest.LinkedPoints[ActualPoints[J]].X) +
        Sqr(ObjectSource.LinkedPoints[ActualPoints[I]].Y - ObjectDest.LinkedPoints[ActualPoints[J]].Y);
      if ASquareDistance < AMinSquareDistance then
      begin
        AMinSquareDistance := ASquareDistance;
        ASourcePointIndex := ActualPoints[I];
        ADestPointIndex := ActualPoints[J];
      end;
    end;
  APointSource := ASourcePointIndex;
  APointDest := ADestPointIndex;
end;

function TdxEMFConnection.GetArrowDest: TdxEMFConnectionArrow;
begin
  Result := TdxEMFConnectionArrow(inherited ArrowDest);
end;

function TdxEMFConnection.GetArrowSource: TdxEMFConnectionArrow;
begin
  Result := TdxEMFConnectionArrow(inherited ArrowSource);
end;

function TdxEMFConnection.GetChart: TdxEMFChart;
begin
  Result := TdxEMFChart(Owner);
end;

function TdxEMFConnection.GetDisplayRect: TRect;
begin
  Result := inherited GetDisplayRect;
  if &Type <> Inheritance then
  begin
    Result.Union(ArrowSource.TextBounds);
    Result.Union(ArrowDest.TextBounds);
  end;
end;

function TdxEMFConnection.GetObjectDest: TdxEntityObject;
begin
  Result := TdxEntityObject(inherited ObjectDest);
end;

function TdxEMFConnection.GetObjectSource: TdxEntityObject;
begin
  Result := TdxEntityObject(inherited ObjectSource);
end;

function TdxEMFConnection.IsSelected: Boolean;
begin
  Result := Selected;
end;

function TdxEMFConnection.Update: Boolean;
var
  AObject: TdxEntityObject;
  ASource, ADest: TEntity;
begin
  Chart.NeedRepaintObject(Self);
  ASource := GetSourceEntity;
  if ObjectSource.Entity <> ASource then
  begin
    AObject := Chart.FindEntityObject(ASource);
    if AObject = nil then
      Exit(False);
    SetObjectSource(AObject, 0);
  end;

  ADest := GetDestEntity;
  if ObjectDest.Entity <> ADest then
  begin
    AObject := Chart.FindEntityObject(ADest);
    if AObject = nil then
      Exit(False);
    SetObjectDest(AObject, 0);
  end;
  if ADest = ASource then
    Exit(False);
  SetObjectPoints;
  Changed;
  Chart.NeedRepaintObject(Self);
  Result := True;
end;

{ TdxAssociationConnection }

constructor TdxAssociationConnection.Create(AOwner: TdxCustomFlowChart; AAssociation: TAssociation);
var
  AType: TConnectionType;
begin
  case AAssociation.&Type of
    TAssociationType.OneToOne: AType := TConnectionType.OneToOne;
  else
    AType := TConnectionType.OneToMany;
  end;
  inherited Create(AOwner, AType);
  FAssociation := AAssociation;
  Color := $333333;
  ArrowSource.Color := clWhite;
  ArrowSource.ArrowType := fcaEllipse;
  ArrowDest.Color := Color;
  ArrowDest.ArrowType := fcaClosedASMEarrow;
  FEnd1 := AAssociation.End1.EntityProperty;
  FEnd2 := AAssociation.End2.EntityProperty;
end;

function TdxAssociationConnection.CanRoute: Boolean;
begin
  Result := inherited CanRoute and (ObjectSource <> nil) and (ObjectDest <> nil);
end;

function TdxAssociationConnection.GetDestEntity: TEntity;
begin
  Result := Association.Entity2;
end;

function TdxAssociationConnection.GetSourceEntity: TEntity;
begin
  Result := Association.Entity1;
end;

procedure TdxAssociationConnection.GetStartEndPoints(out AStart, AEnd: TPoint);
begin
  AStart := RealPoints[0];
  if ObjectSource.Expanded then
    AStart.Y := ObjectSource.PropertiesViewInfo.GetItemTop(Association.End1.EntityProperty);

  AEnd := RealPoints[1];
  if ObjectDest.Expanded then
    AEnd.Y := ObjectDest.PropertiesViewInfo.GetItemTop(Association.End2.EntityProperty);
end;

function TdxAssociationConnection.IsSelected: Boolean;
begin
  Result := Selected or (Chart.InspectedObject = Association);
end;

function TdxAssociationConnection.Update: Boolean;
begin
  case Association.&Type of
    TAssociationType.OneToOne: &Type := TConnectionType.OneToOne;
  else
    &Type := TConnectionType.OneToMany;
  end;
  Result := inherited Update;
end;

{ TdxInheritanceConnection }

constructor TdxInheritanceConnection.Create(AOwner: TdxCustomFlowChart; AInheritance: TInheritance);
begin
  inherited Create(AOwner, TConnectionType.Inheritance);
  FInheritance := AInheritance;
  ArrowSource.ArrowType := fcaClosedASMEarrow;
  ArrowDest.ArrowType := fcaRectangle;
  UpdateInheritanceType;
end;

function TdxInheritanceConnection.GetDestEntity: TEntity;
begin
  Result := Inheritance.DerivedEntity;
end;

function TdxInheritanceConnection.GetSourceEntity: TEntity;
begin
  Result := Inheritance.BaseEntity;
end;

function TdxInheritanceConnection.IsSelected: Boolean;
begin
  Result := Selected or (Chart.InspectedObject = Inheritance);
end;

function TdxInheritanceConnection.Update: Boolean;
begin
  UpdateInheritanceType;
  Result := inherited Update;
end;

procedure TdxInheritanceConnection.UpdateInheritanceType;
begin
  if FInheritance.&Type = TMapInheritanceType.None then
  begin
    PenStyle := psDot;
    Color := $004000;
  end
  else
  begin
    Color := $757E58;
    PenStyle := psSolid;
  end;
  ArrowSource.Color := Color;
  ArrowDest.Color := Color;
end;

{ TdxEMFChartSelection }

procedure TdxEMFChartSelection.DrawSelectionFrame(AGraphics: TdxGPGraphics; const ABounds: TRect);
begin
  AGraphics.Rectangle(ABounds.ToRectF, TdxAlphaColors.DodgerBlue, TdxAlphaColors.Transparent, TdxEMFChart(Owner).ScaleFactor.ApplyF(2));
end;

function TdxEMFChartSelection.ShowEndpointsMarks: Boolean;
begin
  Result := False;
end;

{ TdxEMFChart }

constructor TdxEMFChart.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Antialiasing := True;
  Options := [fcoCanDrag, fcoCanSelect, //#fcoDynamicSizing, fcoDynamicMoving,
    fcoPreventAddingElbowConnections, fcoAlignWithGrid, fcoAutoRouteConnections, fcoSnapToGuides];
  FCachedImages := TCachedImages.Create(Self);
  FArrowFont := TFont.Create;
  FArrowFont.Name := 'Segoe UI';
  GridLineOptions.ShowLines := True;
  Color := clWhite;
end;

destructor TdxEMFChart.Destroy;
begin
  FreeAndNil(FCachedImages);
  FreeAndNil(FArrowFont);
  inherited Destroy;
end;

procedure TdxEMFChart.DblClick;
begin
  if (htOnObject in HitTestResult) and not (ObjectAt as TdxEntityObject).CanProcessDblClick(GetMouseCursorClientPos) then
    Exit;
  inherited DblClick;
end;

function TdxEMFChart.ContainsAssociation(AAssociation: TAssociation): Boolean;
begin
  Result := FindAssociationObject(AAssociation) <> nil;
end;

function TdxEMFChart.ContainsEntity(AEntity: TEntity): Boolean;
begin
  Result := FindEntityObject(AEntity) <> nil;
end;

procedure TdxEMFChart.CreateDiagram(AModel: TDataModel);
var
  I: Integer;
begin
  BeginUpdate;
  try
    Clear;
    CalculateCachedValues;
    for I := 0 to AModel.Entities.Count - 1 do
      CreateEntityObject(AModel.Entities[I], 0, 0);
    for I := 0 to AModel.Associations.Count - 1 do
      CreateAssociation(AModel.Associations[I]);
    for I := 0 to AModel.Inheritances.Count - 1 do
      CreateInheritance(AModel.Inheritances[I]);
    ApplyLayeredLayout;
  finally
    EndUpdate;
  end;
end;

procedure TdxEMFChart.AddEntityToDiagram(AModel: TDataModel; AEntity: TEntity);
var
  I, AMaxBottom: Integer;
  AAssociation: TAssociation;
  AChartEntity: TdxEntityObject;
  AInheritance: TInheritance;
begin
  if (AEntity = nil) or ContainsEntity(AEntity) then
    Exit;
  BeginUpdate;
  try
    AMaxBottom := 0;
    for I := 0 to EntityCount - 1 do
      AMaxBottom := Max(AMaxBottom, Entities[I].Bottom);
    AChartEntity := CreateEntityObject(AEntity, GridSize * 5, AMaxBottom + GridSize * 5);
    for I := 0 to AModel.Associations.Count - 1 do
    begin
      AAssociation := AModel.Associations[I];
      if (AAssociation.Entity1 = AEntity) or (AAssociation.Entity2 = AEntity) then
        CreateAssociation(AAssociation);
    end;
    for I := 0 to AModel.Inheritances.Count - 1 do
    begin
      AInheritance := AModel.Inheritances[I];
      if (AInheritance.BaseEntity = AEntity) or (AInheritance.DerivedEntity = AEntity) then
        CreateInheritance(AInheritance);
    end;
    AChartEntity.Selected := True;
  finally
    EndUpdate;
  end;
  AChartEntity.MakeVisible;
end;

procedure TdxEMFChart.AddNamedPersistent(AObject: TNamedPersistent);
begin
  if AObject.ClassType = TAssociation then
    CreateAssociation(TAssociation(AObject))
  else if AObject.ClassType = TInheritance then
    CreateInheritance(TInheritance(AObject))
  else if (AObject.ClassType = TEntityProperty) or (AObject.ClassType = TEntityRelationshipProperty) then
    UpdateEntity(TEntity(AObject.Parent));
end;

procedure TdxEMFChart.RemoveEntityFromDiagram(AEntity: TEntity);
var
  I: Integer;
  AChartEntity: TdxEntityObject;
  AConnection: TdxFcConnection;
begin
  if AEntity = nil then
    Exit;
  AChartEntity := FindEntityObject(AEntity);
  if AChartEntity = nil then
    Exit;
  BeginUpdate;
  try
    InspectedObject := nil;
    for I := ConnectionCount - 1 downto 0 do
    begin
      AConnection := Connections[I];
      if (AConnection.ObjectSource = AChartEntity) or (AConnection.ObjectDest = AChartEntity) then
        DeleteConnection(AConnection);
    end;
    DeleteObject(AChartEntity);
  finally
    EndUpdate;
  end;
end;

procedure TdxEMFChart.DeleteNamedPersistent(AObject: TNamedPersistent);
begin
  if (AObject = nil) or IsDestroying then
    Exit;
  if AObject.ClassType = TEntity then
    RemoveEntityFromDiagram(TEntity(AObject))
  else if AObject.ClassType = TAssociation then
    RemoveAssociationFromDiagram(TAssociation(AObject))
  else if AObject.ClassType = TInheritance then
    RemoveInheritanceFromDiagram(TInheritance(AObject))
  else if (AObject.ClassType = TEntityRelationshipProperty) or (AObject.ClassType = TEntityProperty)  then
    UpdateEntity(TEntity(AObject.Parent));
end;

procedure TdxEMFChart.EnsureInspectedObjectVisible;
var
  AEntityObject: TdxEntityObject;
  AAssociation: TdxAssociationConnection;
  AInheritance: TdxInheritanceConnection;
begin
  if InspectedObject = nil then
    Exit;

  if InspectedObject.ClassType = TEntity then
    AEntityObject := FindEntityObject(TEntity(InspectedObject))
  else
    if (InspectedObject.ClassType = TEntityProperty) or (InspectedObject.ClassType = TEntityRelationshipProperty) then
      AEntityObject := FindEntityObject(TEntity(TNamedPersistent(InspectedObject).Parent))
    else
    begin
      if InspectedObject.ClassType = TAssociation then
      begin
        AAssociation := FindAssociationObject(TAssociation(InspectedObject));
        if AAssociation <> nil then
          AAssociation.Selected := True;
      end
      else
        if InspectedObject.ClassType = TInheritance then
        begin
          AInheritance := FindInheritanceObject(TInheritance(InspectedObject));
          if AInheritance <> nil then
            AInheritance.Selected := True;
        end;
      AEntityObject := nil;
    end;

  if AEntityObject <> nil then
  begin
    BeginUpdate;
    try
      ClearSelection;
      AEntityObject.Selected := True;
      AEntityObject.MakeVisible;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TdxEMFChart.CalculateArrowsText;
begin
  FArrowFont.Size := Max(MulDiv(Font.Size, RealZoom, 100), 1);
  FZeroToOneTextSize := cxTextExtent(FArrowFont, ZeroToOneText);
  FInfinityTextSize := cxTextExtent(FArrowFont, InfinityText);
end;

procedure TdxEMFChart.CalculateFontRelatedSizes;
begin
  CalculateCachedValues;
end;

function TdxEMFChart.CalculateTextLineHeight: Integer;
begin
  Result := cxTextHeight(Font) + 2 * Indent.cy;
  if Images <> nil then
    Result := Max(Result, Images.Height + Indent.cy);
end;

function TdxEMFChart.CanCreateNewConnectionOnDrag: Boolean;
begin
  Result := False;
end;

function TdxEMFChart.CanDetachConnections: Boolean;
begin
  Result := False;
end;

function TdxEMFChart.CanDragConnectionEndpoints: Boolean;
begin
  Result := False;
end;

function TdxEMFChart.CanDragConnectionIntermediatePoints: Boolean;
begin
  Result := False;
end;

function TdxEMFChart.CanResizeObjectsHorizontal: Boolean;
begin
  Result := True;
end;

function TdxEMFChart.CanResizeObjectsVertical: Boolean;
begin
  Result := False;
end;

procedure TdxEMFChart.CalculateCachedValues;
begin
  FCachedImages.UpdateImageSize;
  CalculateArrowsText;
  FIndent := cxTextExtent(Font, '0');
  FIndent.Init(FIndent.cx, FIndent.cy div 3);
  if Images = nil then
    FImageSize.Init(16, 16)
  else
    FImageSize.Init(Images.Width, Images.Height);
  FImageSize := ScaleFactor.Apply(FImageSize);
  FTextOffset := FImageSize.cx * 2 + FIndent.cx * 2;
  FTextLineHeight := CalculateTextLineHeight;
  FExpandButtonSize := LookAndFeelPainter.ExpandButtonSize;
end;

procedure TdxEMFChart.Click;
begin
  inherited Click;;
  FLockSelection := True;
  try
    EnsureInspectedObjectVisible;
  finally
    FLockSelection := False;
  end;
end;

procedure TdxEMFChart.DoInspectedObjectChanged;
begin
  if Assigned(FOnInspectedObjectChanged) then
    FOnInspectedObjectChanged(FInspectedObject);
end;

procedure TdxEMFChart.FontChanged;
var
  I: Integer;
begin
  BeginUpdate;
  try
    inherited FontChanged;
    CalculateFontRelatedSizes;
    for I := 0 to EntityCount - 1 do
      Entities[I].UpdateSize;
  finally
    EndUpdate;
  end;
end;

procedure TdxEMFChart.NamedPersistentNameChanged(AObject: TNamedPersistent);
begin
  if AObject.ClassType = TEntity then
    UpdateEntity(TEntity(AObject))
  else if (AObject.ClassType = TEntityProperty) or (AObject.ClassType = TEntityRelationshipProperty)then
    UpdateEntity(TEntity(AObject.Parent));
end;

procedure TdxEMFChart.NamedPersistentPropertyChanged(AObject: TNamedPersistent);
var
  AAssociation: TdxAssociationConnection;
  AInheritance: TdxInheritanceConnection;
begin
  if AObject.ClassType = TEntity then
    UpdateEntity(TEntity(AObject))
  else if AObject.ClassType = TAssociation then
  begin
    AAssociation := FindAssociationObject(TAssociation(AObject));
    if AAssociation <> nil then
      if not AAssociation.Update then
        DeleteConnection(AAssociation);
    InvalidateRouting;
  end
  else if AObject.ClassType = TInheritance then
  begin
    AInheritance := FindInheritanceObject(TInheritance(AObject));
    if AInheritance <> nil then
      if not AInheritance.Update then
        DeleteConnection(AInheritance);
  end
  else if AObject.ClassType = TEntityProperty then
    UpdateEntity(TEntity(AObject.Parent));
end;

function TdxEMFChart.NeedAdjustObjectsPoints: Boolean;
begin
  Result := True;
end;

procedure TdxEMFChart.RemoveAssociationFromDiagram(AAssociation: TAssociation);
var
  AAssociationObject: TdxAssociationConnection;
begin
  if AAssociation = nil then
    Exit;
  AAssociationObject := FindAssociationObject(AAssociation);
  if AAssociationObject = nil then
    Exit;

  DeleteConnection(AAssociationObject);
  UpdateEntity(AAssociation.Entity1);
  UpdateEntity(AAssociation.Entity2);
end;

procedure TdxEMFChart.RemoveInheritanceFromDiagram(AInheritance: TInheritance);
var
  AInheritanceObject: TdxInheritanceConnection;
begin
  AInheritanceObject := FindInheritanceObject(AInheritance);
  if AInheritance <> nil then
    DeleteConnection(AInheritanceObject);
end;

function TdxEMFChart.GetEntity(Index: Integer): TdxEntityObject;
begin
  Result := TdxEntityObject(Objects[Index]);
end;

function TdxEMFChart.GetEntityCount: Integer;
begin
  Result := ObjectCount;
end;

function TdxEMFChart.GetGridSize: Integer;
begin
  Result := GridLineOptions.MinorLineStep;
end;

function TdxEMFChart.CreateEntityObject(AEntity: TEntity; ALeft, ATop, AWidth, AHeight: Integer; AExpanded: Boolean): TdxEntityObject;
begin
  Result := TdxEntityObject.Create(Self, AEntity);
  Result.FExpanded := AExpanded;
  Result.SetBounds(ALeft, ATop, AWidth, AHeight);
end;

function TdxEMFChart.CreateEntityObject(AEntity: TEntity; ALeft, ATop: Integer): TdxEntityObject;
begin
  Result := TdxEntityObject.Create(Self, AEntity);
  Result.SetBounds(ALeft, ATop, 0, 0);
end;

function TdxEMFChart.CreateAssociation(AAssociation: TAssociation): TdxAssociationConnection;
var
  ASourceObject, ADestinationObject: TdxEntityObject;
begin
  if AAssociation.Entity1 = AAssociation.Entity2 then
    Exit(nil);

  ASourceObject := FindEntityObject(AAssociation.Entity1);
  if ASourceObject = nil then
    Exit(nil);

  ADestinationObject := FindEntityObject(AAssociation.Entity2);
  if ADestinationObject = nil then
    Exit(nil);

  BeginUpdate;
  try
    Result := TdxAssociationConnection.Create(Self, AAssociation);
    Result.SetObjectSource(ASourceObject, 0);
    Result.SetObjectDest(ADestinationObject, 0);
  finally
    EndUpdate;
  end;
end;

function TdxEMFChart.CreateInheritance(AInheritance: TInheritance): TdxInheritanceConnection;
var
  ASourceObject, ADestinationObject: TdxEntityObject;
begin
  ASourceObject := FindEntityObject(AInheritance.BaseEntity);
  if ASourceObject = nil then
    Exit(nil);

  ADestinationObject := FindEntityObject(AInheritance.DerivedEntity);
  if ADestinationObject = nil then
    Exit(nil);

  Result := TdxInheritanceConnection.Create(Self, AInheritance);
  Result.SetObjectSource(ASourceObject, 0);
  Result.SetObjectDest(ADestinationObject, 0);
end;

function TdxEMFChart.CreateSelection: TdxFcSelection;
begin
  Result := TdxEMFChartSelection.Create(Self);
end;

//#function TdxEMFChart.CreatePainter: TdxFlowChartPainter;
//#begin
//#  Result := TdxEMFChartPainter.Create;
//#end;

function TdxEMFChart.FindAssociationObject(AAssociation: TAssociation): TdxAssociationConnection;
var
  I: Integer;
begin
  for I := 0 to ConnectionCount - 1 do
  begin
    Result := Safe<TdxAssociationConnection>.Cast(Connections[I]);
    if (Result <> nil) and (Result.Association = AAssociation) then
      Exit;
  end;
  Result := nil;
end;

function TdxEMFChart.FindEntityObject(AEntity: TEntity): TdxEntityObject;
var
  I: Integer;
begin
  for I := 0 to EntityCount - 1 do
    if Entities[I].Entity = AEntity then
      Exit(Entities[I]);
  Result := nil;
end;

function TdxEMFChart.FindInheritanceObject(AInheritance: TInheritance): TdxInheritanceConnection;
var
  I: Integer;
begin
  for I := 0 to ConnectionCount - 1 do
  begin
    Result := Safe<TdxInheritanceConnection>.Cast(Connections[I]);
    if (Result <> nil) and (Result.Inheritance = AInheritance) then
      Exit;
  end;
  Result := nil;
end;

function TdxEMFChart.GetAutoRouting: Boolean;
begin
  Result := True;
end;

procedure TdxEMFChart.ImageListChanged;
begin
  CalculateCachedValues;
  inherited ImageListChanged;
end;

function TdxEMFChart.InternalCreateConnection: TdxFcConnection;
begin
  Result := nil;
end;

function TdxEMFChart.InternalCreateObject: TdxFcObject;
begin
  Result := nil;
end;

procedure TdxEMFChart.LoadFromXml(AModel: TDataModel; ARoot: TdxXMLNode);
var
  I, ALeft, ATop, AWidth, AHeight: Integer;
  AExpanded: Boolean;
  AEntityNode, AEntitiesNode: TdxXMLNode;
  AEntity: TEntity;
  AName: string;
begin
  FInspectedObject := nil;
  BeginUpdate;
  try
    Clear;
    CalculateCachedValues;
    AEntitiesNode := ARoot.FindChild('Entities');
    if AEntitiesNode <> nil then
    begin
      AEntityNode := AEntitiesNode.First;
      while AEntityNode <> nil do
      begin
        AName := string(AEntityNode.Attributes.GetValue('Name'));
        AEntity := AModel.FindEntityByName(AName);
        if AEntity <> nil then
        begin
          ALeft := ScaleFactor.Apply(AEntityNode.Attributes.GetValueAsInteger('Left'));
          ATop := ScaleFactor.Apply(AEntityNode.Attributes.GetValueAsInteger('Top'));
          AWidth := ScaleFactor.Apply(AEntityNode.Attributes.GetValueAsInteger('Width'));
          AHeight := ScaleFactor.Apply(AEntityNode.Attributes.GetValueAsInteger('Height'));
          AExpanded := AEntityNode.Attributes.GetValueAsBoolean('Expanded', True);
          CreateEntityObject(AEntity, ALeft, ATop, AWidth, AHeight, AExpanded);
        end;
        AEntityNode := AEntityNode.Next;
      end;
    end;
    for I := 0 to AModel.Associations.Count - 1 do
      CreateAssociation(AModel.Associations[I]);
    for I := 0 to AModel.Inheritances.Count - 1 do
      CreateInheritance(AModel.Inheritances[I]);
    AlignObjectsWithGrid;
  finally
    EndUpdate;
  end;
end;

procedure TdxEMFChart.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbRight) and (Shift * [ssCtrl, ssAlt] = []) then
  begin
    SetFocus;
    HitTest(X, Y);
    ProcessMouseDown(Button, Shift, X, Y);
  end;
  inherited MouseDown(Button, Shift, X, Y);
  if HitTestResult = [htNowhere] then
    InspectedObject := nil;
end;

procedure TdxEMFChart.StoreToXml(ARoot: TdxXMLNode);
var
  I: Integer;
  AEntityObject: TdxEntityObject;
  AEntityNode, AEntitiesNode: TdxXMLNode;
begin
  AEntitiesNode := ARoot.AddChild('Entities');
  for I := 0 to EntityCount - 1 do
  begin
    AEntityObject := Entities[I];
    AEntityNode := AEntitiesNode.AddChild('Item');
    AEntityNode.SetAttribute('Name', AEntityObject.Entity.Name);
    AEntityNode.SetAttribute('Expanded', AEntityObject.Expanded);

    AEntityNode.SetAttribute('Left', ScaleFactor.Revert(AEntityObject.Left));
    AEntityNode.SetAttribute('Top', ScaleFactor.Revert(AEntityObject.Top));
    AEntityNode.SetAttribute('Width', ScaleFactor.Revert(AEntityObject.Width));
    AEntityNode.SetAttribute('Height', ScaleFactor.Revert(AEntityObject.Height));
  end;
end;

procedure TdxEMFChart.Select(Item: TdxFcItem);
begin
  inherited Select(Item);
  if (Item <> nil) and not FLockSelection and Item.Selected then
  begin
    if (Item.ClassType = TdxAssociationConnection) then
      InspectedObject := TdxAssociationConnection(Item).Association
    else if (Item.ClassType = TdxInheritanceConnection) then
      InspectedObject := TdxInheritanceConnection(Item).Inheritance
    else if (Item.ClassType = TdxEntityObject) then
      InspectedObject := TdxEntityObject(Item).Entity;
  end;
end;

procedure TdxEMFChart.UpdateEntity(AEntity: TEntity);
var
  AEntityObject: TdxEntityObject;
begin
  if AEntity = nil then
    Exit;
  AEntityObject := FindEntityObject(AEntity);
  if AEntityObject <> nil then
    AEntityObject.UpdateByEntity;
end;

procedure TdxEMFChart.SetInspectedObject(const Value: TNamedPersistent);
begin
  if FInspectedObject <> Value then
  begin
    FInspectedObject := Value;
    FLockSelection := True;
    try
      DoInspectedObjectChanged;
      if not Focused then
        EnsureInspectedObjectVisible;
    finally
      FLockSelection := False;
      Invalidate; //# for update "selected" elements inside entities
    end;
  end;
end;

procedure TdxEMFChart.UpdatePaintScaleFactor;
begin
  inherited UpdatePaintScaleFactor;
  CalculateCachedValues;
  CalculateArrowsText;
end;

function TdxEMFChart.UseDummyEdgesForRouting: Boolean;
begin
  Result := False;
end;

procedure TdxEMFChart.WMSetCursor(var Message: TWMSetCursor);
begin
  inherited;
  if htOnObject in HitTestResult then
    SetCursor((ObjectAt as TdxEntityObject).GetCursor(GetMouseCursorClientPos));
end;

{ TdxEMFChart.TCachedImages }

constructor TdxEMFChart.TCachedImages.Create(AOwner: TdxEMFChart);
begin
  FOwner := AOwner;
end;

procedure TdxEMFChart.TCachedImages.Draw(ACanvas: TcxCanvas; const AOrigin: TPoint; ANamedPersistent: TNamedPersistent);
var
  ABounds: TRect;
  AOverlayImageIndex: Integer;
begin
  if FOwner.Images = nil then
    Exit;
  ABounds.InitSize(FSize);
  ABounds.Offset(AOrigin);
  TdxImageDrawer.DrawImage(ACanvas, ABounds, nil, FOwner.Images, ANamedPersistent.GetImageIndex, ifmStretch);
  AOverlayImageIndex := ANamedPersistent.GetOverlayImageIndex;
  if AOverlayImageIndex >= 0 then
    TdxImageDrawer.DrawImage(ACanvas, ABounds, nil, FOwner.Images, AOverlayImageIndex, ifmStretch);
end;

procedure TdxEMFChart.TCachedImages.UpdateImageSize;
var
  AWidth, AHeight: Integer;
begin
  if FOwner.Images <> nil then
  begin
    AWidth := FOwner.Images.Width;
    AHeight := FOwner.Images.Height;
  end
  else
  begin
    AWidth := 16;
    AHeight := 16;
  end;
  FSize.cx := FOwner.PaintScaleFactor.Apply(AWidth);
  FSize.cy := FOwner.PaintScaleFactor.Apply(AHeight);
end;

end.
