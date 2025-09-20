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

unit dxPDFPathAnnotation; // for internal use

{$I cxVer.inc}

interface

uses
  Types, SysUtils, Generics.Defaults, Graphics, Generics.Collections, cxGraphics, dxCoreClasses, cxGeometry,
  dxPDFBase, dxPDFTypes, dxPDFCore, dxPDFInteractiveFormField, dxPDFAnnotation, dxPDFFontUtils, dxPDFCommandConstructor,
  dxPDFCommandInterpreter;

type
  TdxPDFLineAnnotationCaptionPosition = (cpInline, cpTop); // for internal use
  TdxPDFLineAnnotationIntent = (liNone, liArrow, liDimension); // for internal use
  TdxPDFNumberFormatDisplayFormat = (dfDecimal, dfFraction, dfRound, dfTruncate); // for internal use
  TdxPDFNumberFormatLabelPosition = (lpSuffix, lpPrefix); // for internal use
  TdxPDFPolyLineAnnotationIntent = (pliNone, pliDimension); // for internal use
  TdxPDFPolygonAnnotationIntent = (piNone, piPolygonCloud, piPolygonDimension); // for internal use

  { TdxPDFNumberFormat }

  TdxPDFNumberFormat = class(TdxPDFObject) // for internal use
  strict private const
    DefaultDecimalDelimiter = '.';
    DefaultDenominator = 16;
    DefaultDigitalGroupingDelimiter = ',';
    DefaultPrecision = 100;
    DefaultPrefixSuffix = ' ';
  strict private
    FConversionFactor: Single;
    FDecimalDelimiter: string;
    FDenominator: Integer;
    FDigitalGroupingDelimiter: string;
    FDisplayFormat: TdxPDFNumberFormatDisplayFormat;
    FLabel: string;
    FLabelPosition: TdxPDFNumberFormatLabelPosition;
    FPrecision: Integer;
    FPrefix: string;
    FSuffix: string;
    FTruncateLowOrderZeros: Boolean;
    //
    procedure ReadDisplayFormat(ADictionary: TdxPDFReaderDictionary);
    procedure ReadLabelPosition(ADictionary: TdxPDFReaderDictionary);
    procedure WriteDisplayFormat(ADictionary: TdxPDFWriterDictionary);
    procedure WriteLabelPosition(ADictionary: TdxPDFWriterDictionary);
  protected
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Initialize; override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    property &Label: string read FLabel;
    property ConversionFactor: Single read FConversionFactor;
    property DisplayFormat: TdxPDFNumberFormatDisplayFormat read FDisplayFormat;
    property Precision: Integer read FPrecision;
    property Denominator: Integer read FDenominator;
    property TruncateLowOrderZeros: Boolean read FTruncateLowOrderZeros;
    property DigitalGroupingDelimiter: string read FDigitalGroupingDelimiter;
    property DecimalDelimiter: string read FDecimalDelimiter;
    property Prefix: string read FPrefix;
    property Suffix: string read FSuffix;
    property LabelPosition: TdxPDFNumberFormatLabelPosition read FLabelPosition;
  end;

  { TdxPDFRectilinearMeasure }

  TdxPDFRectilinearMeasure = class(TdxPDFObject) // for internal use
  strict private
    FAngleNumberFormats: TdxPDFObjectList;
    FAreaNumberFormats: TdxPDFObjectList;
    FDistanceNumberFormats: TdxPDFObjectList;
    FLineSlopeNumberFormats: TdxPDFObjectList;
    FOrigin: TdxPointF;
    FScaleRatio: string;
    FXAxisNumberFormats: TdxPDFObjectList;
    FYAxisNumberFormats: TdxPDFObjectList;
    FYToXFactor: Double;
    //
    function CreateNumberFormatList(ADictionary: TdxPDFReaderDictionary; const AKey: string): TdxPDFObjectList;
  protected
    procedure DestroySubClasses; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    property AngleNumberFormats: TdxPDFObjectList read FAngleNumberFormats;
    property AreaNumberFormats: TdxPDFObjectList read FAreaNumberFormats;
    property DistanceNumberFormats: TdxPDFObjectList read FDistanceNumberFormats;
    property LineSlopeNumberFormats: TdxPDFObjectList read FLineSlopeNumberFormats;
    property Origin: TdxPointF read FOrigin;
    property ScaleRatio: string read FScaleRatio;
    property XAxisNumberFormats: TdxPDFObjectList read FXAxisNumberFormats;
    property YAxisNumberFormats: TdxPDFObjectList read FYAxisNumberFormats;
    property YToXFactor: Double read FYToXFactor;
  end;

  { TdxPDFPathAnnotation }

  TdxPDFPathAnnotation = class(TdxPDFMarkupAnnotation)
  strict private
    FBorderStyle: TdxPDFAnnotationBorderStyle;
    FInteriorColor: TdxPDFColor;
    FMeasure: TdxPDFRectilinearMeasure;
    FVertices: TdxPointsF;
    //
    function GetBorderStyle: TdxPDFAnnotationBorderStyle;
    function GetInteriorColor: TdxPDFColor;
    function GetMeasure: TdxPDFRectilinearMeasure;
    function GetVertices: TdxPointsF;
    procedure SetBorderStyle(const AValue: TdxPDFAnnotationBorderStyle);
    procedure SetMeasure(const AValue: TdxPDFRectilinearMeasure);
  strict protected
    function GetVerticesKey: string; virtual;
  protected
    procedure DestroySubClasses; override;
    procedure Resolve(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    property BorderStyle: TdxPDFAnnotationBorderStyle read GetBorderStyle write SetBorderStyle;
    property InteriorColor: TdxPDFColor read GetInteriorColor;
    property Measure: TdxPDFRectilinearMeasure read GetMeasure write SetMeasure;
    property Vertices: TdxPointsF read GetVertices;
  end;

  { TdxPDFUnclosedPathAnnotation }

  TdxPDFUnclosedPathAnnotation = class(TdxPDFPathAnnotation)
  strict private
    FFinishLineEnding: TdxPDFAnnotationLineEndingStyle;
    FStartLineEnding: TdxPDFAnnotationLineEndingStyle;
    //
    function GetFinishLineEnding: TdxPDFAnnotationLineEndingStyle;
    function GetStartLineEnding: TdxPDFAnnotationLineEndingStyle;
  protected
    function CreateAppearanceBuilder: TObject; override;
    procedure Resolve(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    property StartLineEnding: TdxPDFAnnotationLineEndingStyle read GetStartLineEnding;
    property FinishLineEnding: TdxPDFAnnotationLineEndingStyle read GetFinishLineEnding;
  end;

  { TdxPDFPolygonAnnotation }

  TdxPDFPolygonAnnotation = class(TdxPDFPathAnnotation)
  strict private
    FBorderEffect: TdxPDFAnnotationBorderEffect;
    FPolygonIntent: TdxPDFPolygonAnnotationIntent;
    //
    procedure SetBorderEffect(const AValue: TdxPDFAnnotationBorderEffect);
    procedure ReadPolygonIntent(ADictionary: TdxPDFReaderDictionary);
  protected
    function CreateAppearanceBuilder: TObject; override;
    procedure DestroySubClasses; override;
    procedure Resolve(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    class function GetTypeName: string; override;
    //
    property BorderEffect: TdxPDFAnnotationBorderEffect read FBorderEffect write SetBorderEffect;
  end;

  { TdxPDFLineAnnotation }

  TdxPDFLineAnnotation = class(TdxPDFUnclosedPathAnnotation)
  strict private
    FCaptionPosition: TdxPDFLineAnnotationCaptionPosition;
    FLeaderLineExtensionsLength: Single;
    FLeaderLineOffset: Single;
    FLeaderLinesLength: Single;
    FLineIntent: TdxPDFLineAnnotationIntent;
    FCaptionOffset: TdxPointF;
    FShowCaption: Boolean;
    //
    function GetCaptionPosition: TdxPDFLineAnnotationCaptionPosition;
    function GetCaptionOffset: TdxPointF;
    function GetIntent: TdxPDFLineAnnotationIntent;
    function GetLeaderLineExtensionsLength: Single;
    function GetLeaderLineOffset: Single;
    function GetLeaderLinesLength: Single;
    function GetLineIntent: TdxPDFLineAnnotationIntent;
    function GetShowCaption: Boolean;
  protected
    function CreateAppearanceBuilder: TObject; override;
    function GetVerticesKey: string; override;
    procedure Resolve(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    class function GetTypeName: string; override;
    //
    property CaptionPosition: TdxPDFLineAnnotationCaptionPosition read GetCaptionPosition;
    property CaptionOffset: TdxPointF read GetCaptionOffset;
    property LeaderLineExtensionsLength: Single read GetLeaderLineExtensionsLength;
    property LeaderLineOffset: Single read GetLeaderLineOffset;
    property LeaderLinesLength: Single read GetLeaderLinesLength;
    property LineIntent: TdxPDFLineAnnotationIntent read GetLineIntent;
    property ShowCaption: Boolean read GetShowCaption;
  end;

  { TdxPDFPolyLineAnnotation }

  TdxPDFPolyLineAnnotation = class(TdxPDFUnclosedPathAnnotation)
  strict private
    FPolyLineIntent: TdxPDFPolyLineAnnotationIntent;
  private
    function GetPolyLineIntent: TdxPDFPolyLineAnnotationIntent;
  protected
    procedure Resolve(ADictionary: TdxPDFReaderDictionary); override;
  public
    class function GetTypeName: string; override;
    //
    property PolyLineIntent: TdxPDFPolyLineAnnotationIntent read GetPolyLineIntent;
  end;

implementation

uses
  dxPDFUtils, dxPDFPathAnnotationAppearanceBuilder, dxCore;

const
  dxThisUnitName = 'dxPDFPathAnnotation';

type
  TdxPDFObjectAccess = class(TdxPDFObject);

{ TdxPDFNumberFormat }

procedure TdxPDFNumberFormat.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  FLabel := ADictionary.GetString(TdxPDFKeywords.NumberFormatLabel);

  FConversionFactor := ADictionary.GetDouble(TdxPDFKeywords.NumberFormatConversionFactor);
  if not TdxPDFUtils.IsDoubleValid(FConversionFactor) then
    TdxPDFUtils.Abort;

  FTruncateLowOrderZeros := ADictionary.GetBoolean(TdxPDFKeywords.NumberFormatTruncateLowOrderZeros);
  FDigitalGroupingDelimiter := ADictionary.GetString(TdxPDFKeywords.NumberFormatDigitalGroupingDelimiter,
    DefaultDigitalGroupingDelimiter);
  FDecimalDelimiter := ADictionary.GetString(TdxPDFKeywords.NumberFormatDecimalDelimiter, DefaultDecimalDelimiter);
  FPrefix := ADictionary.GetString(TdxPDFKeywords.NumberFormatPrefix, DefaultPrefixSuffix);
  FSuffix := ADictionary.GetString(TdxPDFKeywords.NumberFormatSuffix, DefaultPrefixSuffix);

  ReadDisplayFormat(ADictionary);
  ReadLabelPosition(ADictionary);
end;

procedure TdxPDFNumberFormat.Initialize;
begin
  inherited Initialize;
  FPrecision := DefaultPrecision;
  FDenominator := DefaultDenominator;
end;

procedure TdxPDFNumberFormat.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.Add(TdxPDFKeywords.NumberFormatLabel, FLabel);
  ADictionary.Add(TdxPDFKeywords.NumberFormatConversionFactor, ConversionFactor);
  ADictionary.Add(TdxPDFKeywords.NumberFormatTruncateLowOrderZeros, FTruncateLowOrderZeros);
  ADictionary.Add(TdxPDFKeywords.NumberFormatDigitalGroupingDelimiter, FDigitalGroupingDelimiter, DefaultDigitalGroupingDelimiter);
  ADictionary.Add(TdxPDFKeywords.NumberFormatDecimalDelimiter, FDecimalDelimiter, DefaultDecimalDelimiter);
  ADictionary.Add(TdxPDFKeywords.NumberFormatPrefix, FPrefix, DefaultPrefixSuffix);
  ADictionary.Add(TdxPDFKeywords.NumberFormatSuffix, FSuffix, DefaultPrefixSuffix);
  WriteDisplayFormat(ADictionary);
  WriteLabelPosition(ADictionary);
end;

procedure TdxPDFNumberFormat.ReadDisplayFormat(ADictionary: TdxPDFReaderDictionary);
var
  AFormatAsString: string;
begin
  AFormatAsString := ADictionary.GetString(TdxPDFKeywords.NumberFormatDisplayFormat);
  if AFormatAsString = 'D' then
    FDisplayFormat := dfDecimal
  else

  if AFormatAsString = 'F' then
    FDisplayFormat := dfFraction
  else

  if AFormatAsString = 'R' then
    FDisplayFormat := dfRound
  else
    FDisplayFormat := dfTruncate;

  case FDisplayFormat of
    dfDecimal:
      begin
        FPrecision := ADictionary.GetInteger(TdxPDFKeywords.NumberFormatPrecision, DefaultPrecision);
        if (FPrecision <> 1) and (FPrecision mod 10 <> 0) then
          TdxPDFUtils.Abort;
      end;
    dfFraction:
      begin
        FDenominator := ADictionary.GetInteger(TdxPDFKeywords.NumberFormatPrecision, DefaultDenominator);
        if FDenominator < 0 then
          TdxPDFUtils.Abort;
      end;
  end;
end;

procedure TdxPDFNumberFormat.ReadLabelPosition(ADictionary: TdxPDFReaderDictionary);
var
  APositionAsString: string;
begin
  APositionAsString := ADictionary.GetString(TdxPDFKeywords.NumberFormatLabelPosition);
  if APositionAsString = 'S' then
    FLabelPosition := lpSuffix
  else
    FLabelPosition := lpPrefix;
end;

procedure TdxPDFNumberFormat.WriteDisplayFormat(ADictionary: TdxPDFWriterDictionary);
const
  Map: array[TdxPDFNumberFormatDisplayFormat] of string = ('D', 'F', 'R', 'T');
begin
  ADictionary.Add(TdxPDFKeywords.NumberFormatDisplayFormat, Map[FDisplayFormat]);
  case FDisplayFormat of
    dfDecimal:
      ADictionary.Add(TdxPDFKeywords.NumberFormatPrecision, FPrecision, DefaultPrecision);
    dfFraction:
      ADictionary.Add(TdxPDFKeywords.NumberFormatPrecision, FDenominator, DefaultDenominator);
  end;
end;

procedure TdxPDFNumberFormat.WriteLabelPosition(ADictionary: TdxPDFWriterDictionary);
const
  Map: array[TdxPDFNumberFormatLabelPosition] of string = ('S', 'P');
begin
  ADictionary.Add(TdxPDFKeywords.NumberFormatLabelPosition, Map[FLabelPosition]);
end;

{ TdxPDFRectilinearMeasure }

procedure TdxPDFRectilinearMeasure.DestroySubClasses;
begin
  FreeAndNil(FAngleNumberFormats);
  FreeAndNil(FAreaNumberFormats);
  FreeAndNil(FDistanceNumberFormats);
  FreeAndNil(FLineSlopeNumberFormats);
  FreeAndNil(FXAxisNumberFormats);
  FreeAndNil(FYAxisNumberFormats);
  inherited DestroySubClasses;;
end;

procedure TdxPDFRectilinearMeasure.DoRead(ADictionary: TdxPDFReaderDictionary);
var
  AArray: TdxPDFArray;
  ASubtype: string;
begin
  inherited DoRead(ADictionary);
  FScaleRatio := ADictionary.GetString(TdxPDFKeywords.RectilinearMeasureScaleRatio);
  FXAxisNumberFormats := CreateNumberFormatList(ADictionary, TdxPDFKeywords.RectilinearMeasureXAxisNumberFormats);
  FDistanceNumberFormats := CreateNumberFormatList(ADictionary, TdxPDFKeywords.RectilinearMeasureDistanceNumberFormats);
  FAreaNumberFormats := CreateNumberFormatList(ADictionary, TdxPDFKeywords.RectilinearMeasureAreaNumberFormats);

  ASubtype := ADictionary.GetString(TdxPDFKeywords.Subtype);
  if (ASubtype <> '') and (ASubtype <> 'RL') or (FScaleRatio = '') or (FXAxisNumberFormats = nil) or
    (FDistanceNumberFormats = nil) or (FAreaNumberFormats = nil) then
    Exit;

  FYAxisNumberFormats := CreateNumberFormatList(ADictionary, TdxPDFKeywords.RectilinearMeasureYAxisNumberFormats);
  if FYAxisNumberFormats = nil then
    FYAxisNumberFormats := FXAxisNumberFormats;

  FAngleNumberFormats := CreateNumberFormatList(ADictionary, TdxPDFKeywords.RectilinearMeasureAngleNumberFormats);
  FLineSlopeNumberFormats := CreateNumberFormatList(ADictionary, TdxPDFKeywords.RectilinearMeasureLineSlopeNumberFormats);

  if ADictionary.TryGetArray(TdxPDFKeywords.RectilinearMeasureOrigin, AArray) and (AArray.Count = 2) then
    FOrigin := TdxPDFUtils.ArrayToPointF(AArray, 0);
  FYToXFactor := ADictionary.GetDouble(TdxPDFKeywords.RectilinearMeasureYToXFactor);
end;

procedure TdxPDFRectilinearMeasure.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.Add(TdxPDFKeywords.RectilinearMeasureScaleRatio, FScaleRatio);
  ADictionary.Add(TdxPDFKeywords.RectilinearMeasureXAxisNumberFormats, FXAxisNumberFormats);
  ADictionary.Add(TdxPDFKeywords.RectilinearMeasureDistanceNumberFormats, FDistanceNumberFormats);
  ADictionary.Add(TdxPDFKeywords.RectilinearMeasureAreaNumberFormats, FAreaNumberFormats);
  if FXAxisNumberFormats <> FYAxisNumberFormats then
    ADictionary.Add(TdxPDFKeywords.RectilinearMeasureYAxisNumberFormats, FYAxisNumberFormats);
  ADictionary.Add(TdxPDFKeywords.RectilinearMeasureAngleNumberFormats, FAngleNumberFormats);
  ADictionary.Add(TdxPDFKeywords.RectilinearMeasureLineSlopeNumberFormats, FLineSlopeNumberFormats);
  ADictionary.Add(TdxPDFKeywords.RectilinearMeasureOrigin, FOrigin);
  ADictionary.Add(TdxPDFKeywords.RectilinearMeasureYToXFactor, FYToXFactor);
end;

function TdxPDFRectilinearMeasure.CreateNumberFormatList(ADictionary: TdxPDFReaderDictionary;
  const AKey: string): TdxPDFObjectList;
var
  AArray: TdxPDFArray;
  AFormatDictionary: TdxPDFDictionary;
  ANumberFormat: TdxPDFNumberFormat;
  I: Integer;
begin
  if not ADictionary.TryGetArray(AKey, AArray) or (AArray.Count = 0) then
    Exit(nil);

  Result := TdxPDFObjectList.Create;
  for I := 0 to AArray.Count - 1 do
    if AArray.TryGetDictionary(I, AFormatDictionary) then
    begin
      ANumberFormat := TdxPDFNumberFormat.Create;
      ANumberFormat.Read(AFormatDictionary as TdxPDFReaderDictionary);
      Result.Add(ANumberFormat);
    end
    else
      TdxPDFUtils.Abort;
end;

{ TdxPDFPathAnnotation }

procedure TdxPDFPathAnnotation.DestroySubClasses;
begin
  BorderStyle := nil;
  Measure := nil;
  inherited DestroySubClasses;
end;

procedure TdxPDFPathAnnotation.Resolve(ADictionary: TdxPDFReaderDictionary);
var
  AMeasureDictionary: TdxPDFReaderDictionary;
begin
  inherited Resolve(ADictionary);
  FVertices := Dictionary.GetPoints(GetVerticesKey);
  BorderStyle := Repository.CreateBorderStyle(Dictionary);
  FInteriorColor := Dictionary.GetColor(TdxPDFKeywords.InteriorColor);
  if Dictionary.TryGetDictionary(TdxPDFKeywords.Measure, AMeasureDictionary) then
  begin
    Measure := TdxPDFRectilinearMeasure.Create;
    TdxPDFObjectAccess(FMeasure).Read(ADictionary);
  end;
end;

procedure TdxPDFPathAnnotation.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.Add(GetVerticesKey, Vertices);
  ADictionary.AddReference(TdxPDFKeywords.AnnotationBorderStyle, FBorderStyle);
  ADictionary.Add(TdxPDFKeywords.InteriorColor, FInteriorColor);
  ADictionary.AddReference(TdxPDFKeywords.Measure, FMeasure);
end;

function TdxPDFPathAnnotation.GetVerticesKey: string;
begin
  Result := 'Vertices';
end;

function TdxPDFPathAnnotation.GetBorderStyle: TdxPDFAnnotationBorderStyle;
begin
  Ensure;
  Result := FBorderStyle;
end;

function TdxPDFPathAnnotation.GetInteriorColor: TdxPDFColor;
begin
  Ensure;
  Result := FInteriorColor;
end;

function TdxPDFPathAnnotation.GetMeasure: TdxPDFRectilinearMeasure;
begin
  Ensure;
  Result := FMeasure;
end;

function TdxPDFPathAnnotation.GetVertices: TdxPointsF;
begin
  Ensure;
  Result := FVertices;
end;

procedure TdxPDFPathAnnotation.SetBorderStyle(const AValue: TdxPDFAnnotationBorderStyle);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FBorderStyle));
end;

procedure TdxPDFPathAnnotation.SetMeasure(const AValue: TdxPDFRectilinearMeasure);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FMeasure));
end;

{ TdxPDFUnclosedPathAnnotation }

procedure TdxPDFUnclosedPathAnnotation.Resolve(ADictionary: TdxPDFReaderDictionary);
begin
  inherited Resolve(ADictionary);
  ADictionary.TryGetLineEndingStyle(FStartLineEnding, FFinishLineEnding);
end;

function TdxPDFUnclosedPathAnnotation.GetFinishLineEnding: TdxPDFAnnotationLineEndingStyle;
begin
  Ensure;
  Result := FFinishLineEnding;
end;

function TdxPDFUnclosedPathAnnotation.GetStartLineEnding: TdxPDFAnnotationLineEndingStyle;
begin
  Ensure;
  Result := FStartLineEnding;
end;

function TdxPDFUnclosedPathAnnotation.CreateAppearanceBuilder: TObject;
begin
  Result := TdxPDFPolyLineAnnotationAppearanceBuilder.Create(Self);
end;

procedure TdxPDFUnclosedPathAnnotation.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.Add(TdxPDFKeywords.LineEnding, StartLineEnding, FinishLineEnding);
end;

{ TdxPDFPolygonAnnotation }

class function TdxPDFPolygonAnnotation.GetTypeName: string;
begin
  Result := TdxPDFKeywords.PolygonAnnotation;
end;

function TdxPDFPolygonAnnotation.CreateAppearanceBuilder: TObject;
begin
  Result := TdxPDFPolygonAnnotationAppearanceBuilder.Create(Self);
end;

procedure TdxPDFPolygonAnnotation.DestroySubClasses;
begin
  FreeAndNil(FBorderEffect);
  inherited DestroySubClasses;
end;

procedure TdxPDFPolygonAnnotation.SetBorderEffect(const AValue: TdxPDFAnnotationBorderEffect);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FBorderEffect));
end;

procedure TdxPDFPolygonAnnotation.ReadPolygonIntent(ADictionary: TdxPDFReaderDictionary);
var
  AValueAsString: string;
begin
  AValueAsString := ADictionary.GetString(FIntent);
  if AValueAsString = 'PolygonCloud' then
    FPolygonIntent := piPolygonCloud
  else
    if AValueAsString = 'PolygonDimension' then
      FPolygonIntent := piPolygonDimension
    else
      FPolygonIntent := piNone;
end;

procedure TdxPDFPolygonAnnotation.Resolve(ADictionary: TdxPDFReaderDictionary);
begin
  inherited Resolve(ADictionary);
  BorderEffect := TdxPDFAnnotationBorderEffect.Parse(ADictionary);
  ReadPolygonIntent(ADictionary);
end;

procedure TdxPDFPolygonAnnotation.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.Add(TdxPDFKeywords.TypeKey, FBorderEffect);
end;

{ TdxPDFLineAnnotation }

class function TdxPDFLineAnnotation.GetTypeName: string;
begin
  Result := TdxPDFKeywords.LineAnnotation;
end;

function TdxPDFLineAnnotation.CreateAppearanceBuilder: TObject;
begin
  Result := TdxPDFPolyLineAnnotationAppearanceBuilder.Create(Self);
end;

function TdxPDFLineAnnotation.GetVerticesKey: string;
begin
  Result := 'L';
end;

procedure TdxPDFLineAnnotation.Resolve(ADictionary: TdxPDFReaderDictionary);

  procedure ReadCaptionPosition;
  var
    AValueAsString: string;
  begin
    AValueAsString := ADictionary.GetString(TdxPDFKeywords.LineAnnotationCaptionPosition);
    if AValueAsString = 'Top' then
      FCaptionPosition := cpTop
    else
      FCaptionPosition := cpInline;
  end;

var
  AArray: TdxPDFArray;
  AValue: Single;
begin
  inherited Resolve(ADictionary);
  FLeaderLinesLength := ADictionary.GetDouble(TdxPDFKeywords.LineAnnotationLeaderLinesLength);
  FLeaderLineExtensionsLength := ADictionary.GetDouble(TdxPDFKeywords.LineAnnotationLeaderLineExtensionsLength);
  FShowCaption := ADictionary.GetBoolean(TdxPDFKeywords.LineAnnotationShowCaption);
  FLineIntent := GetIntent;
  FLeaderLineOffset := ADictionary.GetDouble(TdxPDFKeywords.LineAnnotationLeaderLineOffset);
  ReadCaptionPosition;
  if ADictionary.TryGetArray(TdxPDFKeywords.LineAnnotationCaptionOffsets, AArray) then
  begin
    if AArray.TryGetSingle(0, AValue) then
      FCaptionOffset.X := AValue;
    if AArray.TryGetSingle(1, AValue) then
      FCaptionOffset.Y := AValue;
  end;
end;

procedure TdxPDFLineAnnotation.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.Add(TdxPDFKeywords.LineAnnotationLeaderLinesLength, FLeaderLinesLength);
  ADictionary.Add(TdxPDFKeywords.LineAnnotationLeaderLineExtensionsLength, FLeaderLineExtensionsLength);
  ADictionary.Add(TdxPDFKeywords.LineAnnotationShowCaption, FShowCaption);
  ADictionary.Add(TdxPDFKeywords.LineAnnotationLeaderLineOffset, FLeaderLineOffset);
  if FCaptionPosition <> cpInline then
    ADictionary.Add(TdxPDFKeywords.LineAnnotationCaptionPosition, 'Top');
  ADictionary.Add(TdxPDFKeywords.LineAnnotationCaptionOffsets, TdxPDFArray.Create([FCaptionOffset.X, FCaptionOffset.X]));
end;

function TdxPDFLineAnnotation.GetCaptionPosition: TdxPDFLineAnnotationCaptionPosition;
begin
  Ensure;
  Result := FCaptionPosition;
end;

function TdxPDFLineAnnotation.GetCaptionOffset: TdxPointF;
begin
  Ensure;
  Result := FCaptionOffset;
end;

function TdxPDFLineAnnotation.GetIntent: TdxPDFLineAnnotationIntent;
begin
  if FIntent = 'LineArrow' then
    Result := liArrow
  else
    if FIntent = 'LineDimension' then
      Result := liDimension
    else
      Result := liNone;
end;

function TdxPDFLineAnnotation.GetLeaderLineExtensionsLength: Single;
begin
  Ensure;
  Result := FLeaderLineExtensionsLength;
end;

function TdxPDFLineAnnotation.GetLeaderLineOffset: Single;
begin
  Ensure;
  Result := FLeaderLineOffset;
end;

function TdxPDFLineAnnotation.GetLeaderLinesLength: Single;
begin
  Ensure;
  Result := FLeaderLinesLength;
end;

function TdxPDFLineAnnotation.GetLineIntent: TdxPDFLineAnnotationIntent;
begin
  Ensure;
  Result := FLineIntent;
end;

function TdxPDFLineAnnotation.GetShowCaption: Boolean;
begin
  Ensure;
  Result := FShowCaption;
end;

{ TdxPDFPolyLineAnnotation }

class function TdxPDFPolyLineAnnotation.GetTypeName: string;
begin
  Result := TdxPDFKeywords.PolyLineAnnotation;
end;

procedure TdxPDFPolyLineAnnotation.Resolve(ADictionary: TdxPDFReaderDictionary);
begin
  inherited Resolve(ADictionary);
  if FIntent = 'PolyLineDimension' then
    FPolyLineIntent := pliDimension
  else
    FPolyLineIntent := pliNone;
end;

function TdxPDFPolyLineAnnotation.GetPolyLineIntent: TdxPDFPolyLineAnnotationIntent;
begin
  Ensure;
  Result := FPolyLineIntent;
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxPDFRegisterDocumentObjectClass(TdxPDFLineAnnotation);
  dxPDFRegisterDocumentObjectClass(TdxPDFPolyLineAnnotation);
  dxPDFRegisterDocumentObjectClass(TdxPDFPolygonAnnotation);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxPDFUnregisterDocumentObjectClass(TdxPDFPolygonAnnotation);
  dxPDFUnregisterDocumentObjectClass(TdxPDFPolyLineAnnotation);
  dxPDFUnregisterDocumentObjectClass(TdxPDFLineAnnotation);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
