{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressPDFViewer                                         }
{                                                                    }
{           Copyright (c) 2015-2024 Developer Express Inc.           }
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
{   (DCU, OBJ, DLL, ETC.) ARE CONFIDENTIAL AND PROPRIETARY TRADE     }
{   SECRETS OF DEVELOPER EXPRESS INC. THE REGISTERED DEVELOPER IS    }
{   LICENSED TO DISTRIBUTE THE EXPRESSPDFVIEWER AND ALL              }
{   ACCOMPANYING VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM       }
{   ONLY.                                                            }
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

unit dxPDFPathAnnotationAppearanceBuilder;  // for internal use

{$I cxVer.inc}

interface

uses
  Types, SysUtils, Generics.Defaults, Graphics, Generics.Collections, cxGraphics, dxCoreClasses, cxGeometry,
  dxPDFBase, dxPDFTypes, dxPDFCore, dxPDFCommandInterpreter, dxPDFAnnotation, dxPDFPathAnnotation,
  dxPDFCommandConstructor, dxPDFAppearanceBuilder;

type
  { TdxPDFPathAnnotationAppearanceBuilder }

  TdxPDFPathAnnotationAppearanceBuilder = class(TdxPDFCustomMarkupAnnotationAppearanceBuilder)
  strict private
    FPathBuilder: TObject;
    //
    function GetAnnotation: TdxPDFPathAnnotation;
    function GetPathBuilder: TObject;
  protected
    function GetFormBBox: TdxPDFRectangle; override;
    procedure Rebuild(AConstructor: TdxPDFXFormCommandConstructor); override;
    //
    function CreatePathBuilder: TObject; virtual; abstract;
    function InternalGetBBox: TdxPDFRectangle; virtual; abstract;
    //
    property PathBuilder: TObject read GetPathBuilder;
  public
    constructor Create(AAnnotation: TdxPDFPathAnnotation); reintroduce;
    destructor Destroy; override;
  end;

  { TdxPDFPolygonAnnotationAppearanceBuilder }

  TdxPDFPolygonAnnotationAppearanceBuilder = class(TdxPDFPathAnnotationAppearanceBuilder)
  strict private
    function GetAnnotation: TdxPDFPolygonAnnotation;
  protected
    function CreatePathBuilder: TObject; override;
    function InternalGetBBox: TdxPDFRectangle; override;
    procedure Rebuild(AConstructor: TdxPDFXFormCommandConstructor); override;
  public
    constructor Create(AAnnotation: TdxPDFPolygonAnnotation); reintroduce;
  end;

  { TdxPDFPolyLineAnnotationAppearanceBuilder }

  TdxPDFPolyLineAnnotationAppearanceBuilder = class(TdxPDFPathAnnotationAppearanceBuilder)
  strict private
    function GetAnnotation: TdxPDFUnclosedPathAnnotation;
  protected
    function CreatePathBuilder: TObject; override;
    function InternalGetBBox: TdxPDFRectangle; override;
    procedure Rebuild(AConstructor: TdxPDFXFormCommandConstructor); override;
    //
    property Annotation: TdxPDFUnclosedPathAnnotation read GetAnnotation;
  public
    constructor Create(AAnnotation: TdxPDFUnclosedPathAnnotation); reintroduce;
  end;

implementation

uses
  Math, dxPDFUtils;

const
  dxThisUnitName = 'dxPDFPathAnnotationAppearanceBuilder';

type
  { TdxPDFPathAnnotationAppearanceCustomBuilder }

  TdxPDFPathAnnotationAppearanceCustomBuilder = class
  strict private
    FActualVertices: TdxPointsF;
    FClosePath: Boolean;
    FPath: TdxPDFGraphicsPath;
  strict protected
    FAnnotation: TdxPDFPathAnnotation;
    //
    property ActualVertices: TdxPointsF read FActualVertices;
    property ClosePath: Boolean read FClosePath;
    property Path: TdxPDFGraphicsPath read FPath;
  public
    constructor Create(AAnnotation: TdxPDFPathAnnotation; AClosePath: Boolean);
    destructor Destroy; override;
    //
    function Build: TdxPDFGraphicsPath; virtual;
    function GetBBox: TdxPDFRectangle; virtual; abstract;
    procedure DrawLine(const P1, P2: TdxPointF); virtual; abstract;
  end;

  { TdxPDFPathAnnotationAppearanceLineBuilder }

  TdxPDFPathAnnotationAppearanceLineBuilder = class(TdxPDFPathAnnotationAppearanceCustomBuilder)
  public
    function GetBBox: TdxPDFRectangle; override;
    procedure DrawLine(const P1, P2: TdxPointF); override;
  end;

  { TdxPDFPathAnnotationAppearanceCloudyLineBuilder }

  TdxPDFPathAnnotationAppearanceCloudyLineBuilder = class(TdxPDFPathAnnotationAppearanceCustomBuilder)
  strict private
    FCCW: Boolean;
    //
    function GetAnnotation: TdxPDFPolygonAnnotation;
    function GetIntensity: Double;
  protected
    property Intensity: Double read GetIntensity;
  public
    constructor Create(AAnnotation: TdxPDFPolygonAnnotation; AClosePath: Boolean); reintroduce;
    //
    function Build: TdxPDFGraphicsPath; override;
    function GetBBox: TdxPDFRectangle; override;
    procedure DrawLine(const P1, P2: TdxPointF); override;
    //
    function GetPoints(const P1, P2: TdxPointF): TdxPointsF;
    //
    property Annotation: TdxPDFPolygonAnnotation read GetAnnotation;
  end;

  { TdxPDFAnnotationCustomCapPainter }

  TdxPDFAnnotationCustomCapPainter = class
  protected
    function CalculateTransformationMatrix(const AStartPoint, AEndPoint: TdxPointF): TdxPDFTransformationMatrix; virtual;
    function ShouldPaint(const AStartPoint, AEndPoint: TdxPointF): Boolean; virtual;
    procedure PerformDraw(AConstructor: TdxPDFCommandConstructor; const ALineTransform: TdxPDFTransformationMatrix); virtual; abstract;
  public
    function CalculateBBox(const AStartPoint, AEndPoint: TdxPointF): TdxPDFRectangle; virtual; abstract;
    procedure Draw(AConstructor: TdxPDFCommandConstructor; const AStartPoint, AEndPoint: TdxPointF);
  end;

  { TdxPDFAnnotationCircleLineCapPainter }

  TdxPDFAnnotationCircleLineCapPainter = class(TdxPDFAnnotationCustomCapPainter)
  strict private
    FBorderWidth: Double;
    FFill: Boolean;
    FRectangle: TdxPDFRectangle;
  protected
    function CalculateTransformationMatrix(const AStartPoint, AEndPoint: TdxPointF): TdxPDFTransformationMatrix; override;
    procedure PerformDraw(AConstructor: TdxPDFCommandConstructor; const ALineTransform: TdxPDFTransformationMatrix); override;
  public
    constructor Create(AAnnotation: TdxPDFUnclosedPathAnnotation);
    //
    function CalculateBBox(const AStartPoint, AEndPoint: TdxPointF): TdxPDFRectangle; override;
  end;

  { TdxPDFAnnotationPolyLineCapPainter }

  TdxPDFAnnotationPolyLineCapPainter = class abstract(TdxPDFAnnotationCustomCapPainter)
  strict private
    FFill: Boolean;
    FLineCapData: TdxPointsF;
    FPenWidth: Double;
  protected
    function GetCloseAndFillPath: Boolean; virtual;
    function ShouldPaint(const AStartPoint, AEndPoint: TdxPointF): Boolean; override;
    procedure PerformDraw(AConstructor: TdxPDFCommandConstructor; const ALineTransform: TdxPDFTransformationMatrix); override;
    //
    function CreatePathData(const APenWidth: Double): TdxPointsF; virtual; abstract;
    //
    property CloseAndFillPath: Boolean read GetCloseAndFillPath;
    property LineCapData: TdxPointsF read FLineCapData;
    property PenWidth: Double read FPenWidth;
  public
    constructor Create(AAnnotation: TdxPDFUnclosedPathAnnotation);
    //
    function CalculateBBox(const AStartPoint, AEndPoint: TdxPointF): TdxPDFRectangle; override;
  end;

  { TdxPDFAnnotationDiamondLineCapPainter }

  TdxPDFAnnotationDiamondLineCapPainter = class(TdxPDFAnnotationPolyLineCapPainter)
  protected
    function GetCloseAndFillPath: Boolean; override;
    function CalculateTransformationMatrix(const AStartPoint, AEndPoint: TdxPointF): TdxPDFTransformationMatrix; override;
    function CreatePathData(const APenWidth: Double): TdxPointsF; override;
  public
    constructor Create(AAnnotation: TdxPDFUnclosedPathAnnotation);
  end;

  { TdxPDFAnnotationButtLineCapPainter }

  TdxPDFAnnotationButtLineCapPainter = class(TdxPDFAnnotationPolyLineCapPainter)
  protected
    function CreatePathData(const APenWidth: Double): TdxPointsF; override;
  public
    constructor Create(AAnnotation: TdxPDFUnclosedPathAnnotation);
  end;

  { TdxPDFAnnotationOpenArrowLineCapPainter }

  TdxPDFAnnotationOpenArrowLineCapPainter = class(TdxPDFAnnotationPolyLineCapPainter)
  protected
    function CalculateTransformationMatrix(const AStartPoint, AEndPoint: TdxPointF): TdxPDFTransformationMatrix; override;
    function CreatePathData(const APenWidth: Double): TdxPointsF; override;
  public
    constructor Create(AAnnotation: TdxPDFUnclosedPathAnnotation);
  end;

  { TdxPDFAnnotationClosedArrowLineCapPainter }

  TdxPDFAnnotationClosedArrowLineCapPainter = class(TdxPDFAnnotationOpenArrowLineCapPainter)
  protected
    function GetCloseAndFillPath: Boolean; override;
  public
    constructor Create(AAnnotation: TdxPDFUnclosedPathAnnotation);
  end;

  { TdxPDFAnnotationReverseOpenArrowLineCapPainter }

  TdxPDFAnnotationReverseOpenArrowLineCapPainter = class(TdxPDFAnnotationPolyLineCapPainter)
  protected
    function CreatePathData(const APenWidth: Double): TdxPointsF; override;
  public
    constructor Create(AAnnotation: TdxPDFUnclosedPathAnnotation);
  end;

  { TdxPDFAnnotationReverseClosedArrowLineCapPainter }

  TdxPDFAnnotationReverseClosedArrowLineCapPainter = class(TdxPDFAnnotationReverseOpenArrowLineCapPainter)
  protected
    function GetCloseAndFillPath: Boolean; override;
  public
    constructor Create(AAnnotation: TdxPDFUnclosedPathAnnotation);
  end;

  { TdxPDFAnnotationSlashLineCapPainter }

  TdxPDFAnnotationSlashLineCapPainter = class(TdxPDFAnnotationPolyLineCapPainter)
  protected
    function CreatePathData(const APenWidth: Double): TdxPointsF; override;
  public
    constructor Create(AAnnotation: TdxPDFUnclosedPathAnnotation);
  end;

  { TdxPDFAnnotationSquareLineCapPainter }

  TdxPDFAnnotationSquareLineCapPainter = class(TdxPDFAnnotationPolyLineCapPainter)
  protected
    function GetCloseAndFillPath: Boolean; override;
    function CalculateTransformationMatrix(const AStartPoint, AEndPoint: TdxPointF): TdxPDFTransformationMatrix; override;
    function CreatePathData(const APenWidth: Double): TdxPointsF; override;
  public
    constructor Create(AAnnotation: TdxPDFUnclosedPathAnnotation);
  end;

function TryCreateLineCapPainter(AStyle: TdxPDFAnnotationLineEndingStyle; AAnnotation: TdxPDFUnclosedPathAnnotation;
  out APainter: TdxPDFAnnotationCustomCapPainter): Boolean;
begin
  case AStyle of
    lesOpenArrow:
      APainter := TdxPDFAnnotationOpenArrowLineCapPainter.Create(AAnnotation);
    lesClosedArrow:
      APainter := TdxPDFAnnotationClosedArrowLineCapPainter.Create(AAnnotation);
    lesROpenArrow:
      APainter := TdxPDFAnnotationReverseOpenArrowLineCapPainter.Create(AAnnotation);
    lesRClosedArrow:
      APainter := TdxPDFAnnotationReverseClosedArrowLineCapPainter.Create(AAnnotation);
    lesButt:
      APainter := TdxPDFAnnotationButtLineCapPainter.Create(AAnnotation);
    lesCircle:
      APainter := TdxPDFAnnotationCircleLineCapPainter.Create(AAnnotation);
    lesDiamond:
      APainter := TdxPDFAnnotationDiamondLineCapPainter.Create(AAnnotation);
    lesSlash:
      APainter := TdxPDFAnnotationSlashLineCapPainter.Create(AAnnotation);
    lesSquare:
      APainter := TdxPDFAnnotationSquareLineCapPainter.Create(AAnnotation);
  else
    APainter := nil;
  end;
  Result := APainter <> nil;
end;

{ TdxPDFPathAnnotationAppearanceCustomBuilder }

constructor TdxPDFPathAnnotationAppearanceCustomBuilder.Create(AAnnotation: TdxPDFPathAnnotation; AClosePath: Boolean);
begin
  inherited Create;
  FClosePath := AClosePath;
  FAnnotation := AAnnotation;
  FActualVertices := FAnnotation.Vertices;
  FPath := TdxPDFGraphicsPath.Create(ActualVertices[0]);
end;

destructor TdxPDFPathAnnotationAppearanceCustomBuilder.Destroy;
begin
  FreeAndNil(FPath);
  inherited Destroy;
end;

function TdxPDFPathAnnotationAppearanceCustomBuilder.Build: TdxPDFGraphicsPath;
var
  I: Integer;
begin
  FPath.IsClosed := FClosePath;
  for I := 1 to Length(FActualVertices) - 1 do
    DrawLine(ActualVertices[I - 1], FActualVertices[I]);
  Result := FPath;
end;

{ TdxPDFPathAnnotationAppearanceLineBuilder }

procedure TdxPDFPathAnnotationAppearanceLineBuilder.DrawLine(const P1, P2: TdxPointF);
begin
  Path.AppendLineSegment(P2);
end;

function TdxPDFPathAnnotationAppearanceLineBuilder.GetBBox: TdxPDFRectangle;
begin
  Result := TdxPDFRectangle.Create(ActualVertices);
end;

{ TdxPDFPathAnnotationAppearanceCloudyLineBuilder }

constructor TdxPDFPathAnnotationAppearanceCloudyLineBuilder.Create(AAnnotation: TdxPDFPolygonAnnotation;
  AClosePath: Boolean);
var
  I, L: Integer;
  P1, P2: TdxPointF;
  S: Double;
begin
  inherited Create(AAnnotation, AClosePath);
  S := 0;
  L := Length(ActualVertices);
  P1 := ActualVertices[0];
  P2 := ActualVertices[L - 1];

  S := S + P1.X * P2.Y - P1.Y * P2.X;

  for I := 1 to L - 1 do
  begin
    P1 := ActualVertices[I];
    P2 := ActualVertices[I - 1];
    S := S + P1.X * P2.Y - P1.Y * P2.X;
  end;
  FCCW := S > 0;
end;

function TdxPDFPathAnnotationAppearanceCloudyLineBuilder.GetAnnotation: TdxPDFPolygonAnnotation;
begin
  Result := TdxPDFPolygonAnnotation(FAnnotation);
end;

function TdxPDFPathAnnotationAppearanceCloudyLineBuilder.GetIntensity: Double;
begin
  if Annotation.BorderEffect <> nil then
    Result := Annotation.BorderEffect.Intensity
  else
    Result := 1;
  Result := Result * 5;
end;

function TdxPDFPathAnnotationAppearanceCloudyLineBuilder.Build: TdxPDFGraphicsPath;
var
  APath: TdxPDFGraphicsPath;
begin
  APath := inherited Build;
  DrawLine(Annotation.Vertices[Length(ActualVertices) - 1], ActualVertices[0]);
  Result := APath;
end;

function TdxPDFPathAnnotationAppearanceCloudyLineBuilder.GetBBox: TdxPDFRectangle;
var
  I: Integer;
begin
  Result := TdxPDFRectangle.Create(GetPoints(ActualVertices[0], ActualVertices[1]));
  for I := 2 to Length(ActualVertices) - 1 do
    Result := TdxPDFRectangle.Union(Result, TdxPDFRectangle.Create(GetPoints(ActualVertices[I - 1], ActualVertices[I])));
end;

procedure TdxPDFPathAnnotationAppearanceCloudyLineBuilder.DrawLine(const P1, P2: TdxPointF);
var
  APoints: TdxPointsF;
  I: Integer;
  K1, K2: TdxPointF;
begin
  I := 0;
  APoints := GetPoints(P1, P2);
  while I <= Length(APoints) - 3 do
  begin
    K1 := APoints[I];
    K2 := APoints[I + 1];
    Path.AppendBezierSegment(K1, K2, APoints[I + 2]);
    Inc(I, 3);
  end;
end;

function TdxPDFPathAnnotationAppearanceCloudyLineBuilder.GetPoints(const P1, P2: TdxPointF): TdxPointsF;
var
  ACount, I, J: Integer;
  AOne, AOneOrth, AP1, AP4: TdxPointF;
  K, ADistance: Double;
begin
  K := Intensity;
  ADistance := TdxPDFUtils.Distance(P1, P2);
  if ADistance <> 0 then
  begin
    ACount := Ceil(ADistance / K);
    AOne.X := (P2.X - P1.X) / ADistance;
    AOne.Y := (P2.Y - P1.Y) / ADistance;
    if FCCW then
      AOneOrth := dxPointF(-AOne.Y, AOne.X)
    else
      AOneOrth := dxPointF(AOne.Y, -AOne.X);

    SetLength(Result, (ACount - 1) * 3);
    J := 0;
    for I := 1 to ACount - 1 do
    begin
      AP1.X := P1.X + AOne.X * (I - 1) * K;
      AP1.Y := P1.Y + AOne.Y * (I - 1) * K;

      AP4.X := P1.X + AOne.X * I * K;
      AP4.Y := P1.Y + AOne.Y * I * K;

      Result[J].X := AP1.X + AOneOrth.X * K;
      Result[J].Y := AP1.Y + AOneOrth.Y * K;

      Result[J + 1].X := AP4.X + AOneOrth.X * K;
      Result[J + 1].Y := AP4.Y + AOneOrth.Y * K;

      Result[J + 2] := AP4;

      Inc(J, 3);
    end;
  end;
end;

{ TdxPDFAnnotationCustomCapPainter }

procedure TdxPDFAnnotationCustomCapPainter.Draw(AConstructor: TdxPDFCommandConstructor;
  const AStartPoint, AEndPoint: TdxPointF);
begin
  if ShouldPaint(AStartPoint, AEndPoint) then
    PerformDraw(AConstructor, CalculateTransformationMatrix(AStartPoint, AEndPoint));
end;

function TdxPDFAnnotationCustomCapPainter.CalculateTransformationMatrix(
  const AStartPoint, AEndPoint: TdxPointF): TdxPDFTransformationMatrix;
var
  ADX, ADY, ADistance: Single;
begin
  ADX := AEndPoint.X - AStartPoint.X;
  ADY := AEndPoint.Y - AStartPoint.Y;
  ADistance := Sqrt(ADx * ADx + ADy * ADy);

  if ADistance <> 0 then
  begin
    ADX := ADX / ADistance;
    ADY := ADY / ADistance;
    Result := TdxPDFTransformationMatrix.Create(ADX, ADY, -ADY, ADX, AStartPoint.X, AStartPoint.Y);
  end
  else
    Result := TdxPDFTransformationMatrix.Create(1, 0, 0, 1, AStartPoint.X, AStartPoint.Y);
end;

function TdxPDFAnnotationCustomCapPainter.ShouldPaint(const AStartPoint, AEndPoint: TdxPointF): Boolean;
begin
  Result := AStartPoint <> AEndPoint;
end;

{ TdxPDFAnnotationDiamondLineCapPainter }

constructor TdxPDFAnnotationDiamondLineCapPainter.Create(AAnnotation: TdxPDFUnclosedPathAnnotation);
begin
  inherited Create(AAnnotation);
end;

function TdxPDFAnnotationDiamondLineCapPainter.GetCloseAndFillPath: Boolean;
begin
  Result := True;
end;

function TdxPDFAnnotationDiamondLineCapPainter.CalculateTransformationMatrix(const AStartPoint, AEndPoint: TdxPointF): TdxPDFTransformationMatrix;
var
  AMatrix: TdxPDFTransformationMatrix;
begin
  AMatrix := inherited CalculateTransformationMatrix(AStartPoint, AEndPoint);
  Result := TdxPDFTransformationMatrix.Create(1, 0, 0, 1, AStartPoint.X + AMatrix.A * PenWidth, AStartPoint.Y + AMatrix.B * PenWidth);
end;

function TdxPDFAnnotationDiamondLineCapPainter.CreatePathData(const APenWidth: Double): TdxPointsF;
var
  W: Double;
begin
  W := APenWidth * 3;
  SetLength(Result, 4);
  Result[0] := dxPointF(0, -W);
  Result[1] := dxPointF(W, 0);
  Result[2] := dxPointF(0, W);
  Result[3] := dxPointF(-W, 0);
end;

{ TdxPDFAnnotationButtLineCapPainter }

constructor TdxPDFAnnotationButtLineCapPainter.Create(AAnnotation: TdxPDFUnclosedPathAnnotation);
begin
  inherited Create(AAnnotation);
end;

function TdxPDFAnnotationButtLineCapPainter.CreatePathData(const APenWidth: Double): TdxPointsF;
var
  W: Double;
begin
  W := APenWidth * 3;
  SetLength(Result, 2);
  Result[0] := dxPointF(0, -W);
  Result[1] := dxPointF(0, W);
end;

{ TdxPDFAnnotationOpenArrowLineCapPainter }

constructor TdxPDFAnnotationOpenArrowLineCapPainter.Create(AAnnotation: TdxPDFUnclosedPathAnnotation);
begin
  inherited Create(AAnnotation);
end;

function TdxPDFAnnotationOpenArrowLineCapPainter.CalculateTransformationMatrix(const AStartPoint, AEndPoint: TdxPointF): TdxPDFTransformationMatrix;
var
  AMatrix: TdxPDFTransformationMatrix;
begin
  AMatrix := inherited CalculateTransformationMatrix(AStartPoint, AEndPoint);
  Result := TdxPDFTransformationMatrix.Translate(AMatrix, dxPointF(AMatrix.A * PenWidth, AMatrix.B * PenWidth));
end;

function TdxPDFAnnotationOpenArrowLineCapPainter.CreatePathData(const APenWidth: Double): TdxPointsF;
var
  L, W: Double;
begin
  L := APenWidth * 7;
  W := APenWidth * 4;
  SetLength(Result, 3);
  Result[0] := dxPointF(L, -W);
  Result[1] := dxPointF(0, 0);
  Result[2] := dxPointF(L, W);
end;

{ TdxPDFAnnotationCircleLineCapPainter }

constructor TdxPDFAnnotationCircleLineCapPainter.Create(AAnnotation: TdxPDFUnclosedPathAnnotation);
var
  ASize: Double;
begin
  inherited Create;
  FFill := not AAnnotation.InteriorColor.IsNull;

  if AAnnotation.BorderStyle <> nil then
    FBorderWidth := AAnnotation.BorderStyle.Width
  else
    FBorderWidth := 1;

  ASize := FBorderWidth * 3;
  FRectangle := TdxPDFRectangle.Create(-ASize, -ASize, ASize, ASize);
end;

function TdxPDFAnnotationCircleLineCapPainter.CalculateBBox(const AStartPoint, AEndPoint: TdxPointF): TdxPDFRectangle;
begin
  Result := CalculateTransformationMatrix(AStartPoint, AEndPoint).TransformBoundingBox(FRectangle);
end;

function TdxPDFAnnotationCircleLineCapPainter.CalculateTransformationMatrix(
  const AStartPoint, AEndPoint: TdxPointF): TdxPDFTransformationMatrix;
var
  M: TdxPDFTransformationMatrix;
begin
  M := inherited CalculateTransformationMatrix(AStartPoint, AEndPoint);
  Result := TdxPDFTransformationMatrix.Translate(M, dxPointF(M.A * FBorderWidth, M.B * FBorderWidth));
end;

procedure TdxPDFAnnotationCircleLineCapPainter.PerformDraw(AConstructor: TdxPDFCommandConstructor;
  const ALineTransform: TdxPDFTransformationMatrix);
begin
  AConstructor.SaveGraphicsState;
  AConstructor.ModifyTransformationMatrix(ALineTransform);
  AConstructor.AppendEllipse(FRectangle);
  AConstructor.ClosePath;
  if FFill then
    AConstructor.FillAndStrokePath(True)
  else
    AConstructor.StrokePath;
  AConstructor.RestoreGraphicsState;
end;

{ TdxPDFAnnotationPolyLineCapPainter }

constructor TdxPDFAnnotationPolyLineCapPainter.Create(AAnnotation: TdxPDFUnclosedPathAnnotation);
begin
  inherited Create;
  FFill := not AAnnotation.InteriorColor.IsNull;

  if AAnnotation.BorderStyle <> nil then
    FPenWidth := AAnnotation.BorderStyle.Width
  else
    FPenWidth := 1;

  FLineCapData := CreatePathData(FPenWidth);
end;

function TdxPDFAnnotationPolyLineCapPainter.GetCloseAndFillPath: Boolean;
begin
  Result := False;
end;

function TdxPDFAnnotationPolyLineCapPainter.ShouldPaint(const AStartPoint, AEndPoint: TdxPointF): Boolean;
begin
  Result := True;
end;

procedure TdxPDFAnnotationPolyLineCapPainter.PerformDraw(AConstructor: TdxPDFCommandConstructor;
  const ALineTransform: TdxPDFTransformationMatrix);
begin
  if CloseAndFillPath then
  begin
    AConstructor.AppendPolygon(ALineTransform.TransformPoints(FLineCapData));
    AConstructor.ClosePath;
    if FFill then
      AConstructor.FillAndStrokePath(True)
    else
      AConstructor.StrokePath;
  end
  else
    AConstructor.DrawLines(ALineTransform.TransformPoints(LineCapData));
end;

function TdxPDFAnnotationPolyLineCapPainter.CalculateBBox(const AStartPoint, AEndPoint: TdxPointF): TdxPDFRectangle;
begin
  Result := TdxPDFRectangle.Create(CalculateTransformationMatrix(AStartPoint, AEndPoint).TransformPoints(FLineCapData));
end;

{ TdxPDFAnnotationClosedArrowLineCapPainter }

constructor TdxPDFAnnotationClosedArrowLineCapPainter.Create(AAnnotation: TdxPDFUnclosedPathAnnotation);
begin
  inherited Create(AAnnotation);
end;

function TdxPDFAnnotationClosedArrowLineCapPainter.GetCloseAndFillPath: Boolean;
begin
  Result := True;
end;

{ TdxPDFAnnotationReverseOpenArrowLineCapPainter }

constructor TdxPDFAnnotationReverseOpenArrowLineCapPainter.Create(AAnnotation: TdxPDFUnclosedPathAnnotation);
begin
  inherited Create(AAnnotation);
end;

function TdxPDFAnnotationReverseOpenArrowLineCapPainter.CreatePathData(const APenWidth: Double): TdxPointsF;
var
  L, W: Double;
begin
  L := APenWidth * 7;
  W := APenWidth * 4;
  SetLength(Result, 3);
  Result[0] := dxPointF(-L, -W);
  Result[1] := dxPointF(0, 0);
  Result[2] := dxPointF(-L, W);
end;

{ TdxPDFAnnotationReverseClosedArrowLineCapPainter }

constructor TdxPDFAnnotationReverseClosedArrowLineCapPainter.Create(AAnnotation: TdxPDFUnclosedPathAnnotation);
begin
  inherited Create(AAnnotation);
end;

function TdxPDFAnnotationReverseClosedArrowLineCapPainter.GetCloseAndFillPath: Boolean;
begin
  Result := True;
end;

{ TdxPDFAnnotationSlashLineCapPainter }

constructor TdxPDFAnnotationSlashLineCapPainter.Create(AAnnotation: TdxPDFUnclosedPathAnnotation);
begin
  inherited Create(AAnnotation);
end;

function TdxPDFAnnotationSlashLineCapPainter.CreatePathData(const APenWidth: Double): TdxPointsF;
var
  W: Double;
begin
  W := APenWidth * 7.5;
  SetLength(Result, 2);
  Result[0] := dxPointF(-W / 1.6, -W);
  Result[1] := dxPointF(W / 1.6, W);
end;

{ TdxPDFAnnotationSquareLineCapPainter }

constructor TdxPDFAnnotationSquareLineCapPainter.Create(AAnnotation: TdxPDFUnclosedPathAnnotation);
begin
  inherited Create(AAnnotation);
end;

function TdxPDFAnnotationSquareLineCapPainter.GetCloseAndFillPath: Boolean;
begin
  Result := True;
end;

function TdxPDFAnnotationSquareLineCapPainter.CalculateTransformationMatrix(const AStartPoint, AEndPoint: TdxPointF): TdxPDFTransformationMatrix;
var
  AMatrix: TdxPDFTransformationMatrix;
begin
  AMatrix := inherited CalculateTransformationMatrix(AStartPoint, AEndPoint);
  Result := TdxPDFTransformationMatrix.Create(1, 0, 0, 1, AStartPoint.X + AMatrix.A * PenWidth, AStartPoint.Y + AMatrix.B * PenWidth);
end;

function TdxPDFAnnotationSquareLineCapPainter.CreatePathData(const APenWidth: Double): TdxPointsF;
var
  W: Double;
begin
  W := APenWidth * 3;
  SetLength(Result, 4);
  Result[0] := dxPointF(-W, -W);
  Result[1] := dxPointF(W, -W);
  Result[2] := dxPointF(W, W);
  Result[3] := dxPointF(-W, W);
end;

{ TdxPDFPathAnnotationAppearanceBuilder }

constructor TdxPDFPathAnnotationAppearanceBuilder.Create(AAnnotation: TdxPDFPathAnnotation);
begin
  inherited Create(AAnnotation);
end;

destructor TdxPDFPathAnnotationAppearanceBuilder.Destroy;
begin
  FreeAndNil(FPathBuilder);
  inherited Destroy;
end;

function TdxPDFPathAnnotationAppearanceBuilder.GetAnnotation: TdxPDFPathAnnotation;
begin
  Result := TdxPDFPathAnnotation(FAnnotation);
end;

function TdxPDFPathAnnotationAppearanceBuilder.GetPathBuilder: TObject;
begin
  if FPathBuilder = nil then
    FPathBuilder := CreatePathBuilder;
  Result := FPathBuilder;
end;

function TdxPDFPathAnnotationAppearanceBuilder.GetFormBBox: TdxPDFRectangle;
var
  AAnnotation: TdxPDFPathAnnotation;
  ABorderWidth: Single;
  ARect: TdxPDFRectangle;
begin
  AAnnotation := GetAnnotation;
  if AAnnotation.BorderStyle <> nil then
    ABorderWidth := AAnnotation.BorderStyle.Width
  else
    ABorderWidth := 1;
  ARect := InternalGetBBox;
  ARect := TdxPDFRectangle.Inflate(ARect, -ABorderWidth);
  AAnnotation.Rect := TdxPDFRectangle.Inflate(ARect, -3);
  Result := AAnnotation.Rect;
end;

procedure TdxPDFPathAnnotationAppearanceBuilder.Rebuild(AConstructor: TdxPDFXFormCommandConstructor);
var
  AAnnotation: TdxPDFPathAnnotation;
begin
  inherited Rebuild(AConstructor);
  AAnnotation := GetAnnotation;
  AConstructor.SetColorForStrokingOperations(AAnnotation.Color);
  if AAnnotation.BorderStyle <> nil then
  begin
    AConstructor.SetLineWidth(AAnnotation.BorderStyle.Width);
    AConstructor.SetLineStyle(AAnnotation.BorderStyle.LineStyle);
  end
  else
    AConstructor.SetLineWidth(1);
  if not AAnnotation.InteriorColor.IsNull then
    AConstructor.SetColorForNonStrokingOperations(AAnnotation.InteriorColor);
  AConstructor.AppendPath(TdxPDFPathAnnotationAppearanceCustomBuilder(PathBuilder).Build);
end;

{ TdxPDFPolygonAnnotationAppearanceBuilder }

constructor TdxPDFPolygonAnnotationAppearanceBuilder.Create(AAnnotation: TdxPDFPolygonAnnotation);
begin
  inherited Create(AAnnotation);
end;

function TdxPDFPolygonAnnotationAppearanceBuilder.InternalGetBBox: TdxPDFRectangle;
var
  ABuilder: TdxPDFPathAnnotationAppearanceCustomBuilder;
begin
  ABuilder := CreatePathBuilder as TdxPDFPathAnnotationAppearanceCustomBuilder;
  try
    Result := ABuilder.GetBBox;
  finally
    ABuilder.Free;
  end;
end;

function TdxPDFPolygonAnnotationAppearanceBuilder.CreatePathBuilder: TObject;
var
  AAnnotation: TdxPDFPolygonAnnotation;
begin
  AAnnotation := GetAnnotation;
  if (AAnnotation.BorderEffect <> nil) and (AAnnotation.BorderEffect.Style = esCloudy) then
    Result := TdxPDFPathAnnotationAppearanceCloudyLineBuilder.Create(AAnnotation, True)
  else
    Result := TdxPDFPathAnnotationAppearanceLineBuilder.Create(AAnnotation, True);
end;

procedure TdxPDFPolygonAnnotationAppearanceBuilder.Rebuild(AConstructor: TdxPDFXFormCommandConstructor);
begin
  inherited Rebuild(AConstructor);
  if not GetAnnotation.InteriorColor.IsNull then
    AConstructor.FillAndStrokePath(True)
  else
    AConstructor.StrokePath;
end;

function TdxPDFPolygonAnnotationAppearanceBuilder.GetAnnotation: TdxPDFPolygonAnnotation;
begin
  Result := TdxPDFPolygonAnnotation(FAnnotation);
end;

{ TdxPDFPolyLineAnnotationAppearanceBuilder }

constructor TdxPDFPolyLineAnnotationAppearanceBuilder.Create(AAnnotation: TdxPDFUnclosedPathAnnotation);
begin
  inherited Create(AAnnotation);
end;

function TdxPDFPolyLineAnnotationAppearanceBuilder.GetAnnotation: TdxPDFUnclosedPathAnnotation;
begin
  Result := TdxPDFUnclosedPathAnnotation(FAnnotation);
end;

function TdxPDFPolyLineAnnotationAppearanceBuilder.CreatePathBuilder: TObject;
begin
  Result := TdxPDFPathAnnotationAppearanceLineBuilder.Create(Annotation, False);
end;

function TdxPDFPolyLineAnnotationAppearanceBuilder.InternalGetBBox: TdxPDFRectangle;

  function DoGetBBox(AStyle: TdxPDFAnnotationLineEndingStyle; const ARect: TdxPDFRectangle; const P1, P2: TdxPointF): TdxPDFRectangle;
  var
    APainter: TdxPDFAnnotationCustomCapPainter;
  begin
    Result := ARect;
    if TryCreateLineCapPainter(AStyle, Annotation, APainter) then
      try
        Result := TdxPDFRectangle.Union(Result, APainter.CalculateBBox(P1, P2));
      finally
        FreeAndNil(APainter);
      end;
  end;

var
  AVertices: TdxPointsF;
  L: Integer;
begin
  AVertices := Annotation.Vertices;
  L := Length(Annotation.Vertices);
  Result := DoGetBBox(Annotation.StartLineEnding, TdxPDFRectangle.Create(AVertices), AVertices[0], AVertices[1]);
  Result := DoGetBBox(Annotation.FinishLineEnding, Result, AVertices[L - 1], AVertices[L - 2]);
end;

procedure TdxPDFPolyLineAnnotationAppearanceBuilder.Rebuild(AConstructor: TdxPDFXFormCommandConstructor);

  procedure DoDraw(AStyle: TdxPDFAnnotationLineEndingStyle; const P1, P2: TdxPointF);
  var
    APainter: TdxPDFAnnotationCustomCapPainter;
  begin
    if TryCreateLineCapPainter(AStyle, Annotation, APainter) then
      try
        APainter.Draw(AConstructor, P1, P2);
      finally
        FreeAndNil(APainter);
      end;
  end;

var
  AVertices: TdxPointsF;
  L: Integer;
begin
  inherited Rebuild(AConstructor);
  AConstructor.StrokePath;
  AVertices := Annotation.Vertices;
  L := Length(AVertices);
  DoDraw(Annotation.StartLineEnding, AVertices[0], AVertices[1]);
  DoDraw(Annotation.FinishLineEnding, AVertices[L - 1], AVertices[L - 2]);
end;

end.
