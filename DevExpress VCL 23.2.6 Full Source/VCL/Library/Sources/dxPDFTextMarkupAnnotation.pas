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

unit dxPDFTextMarkupAnnotation; // for internal use

{$I cxVer.inc}

interface

uses
  Types, SysUtils, Classes, cxGeometry, dxPDFBase, dxPDFTypes, dxPDFCore, dxPDFAnnotation, dxPDFCommandConstructor,
  dxPDFAppearanceBuilder;

type
  TdxPDFTextMarkupAnnotationType = (tmatHighlight, tmatUnderline, tmatSquiggly, tmatStrikeOut);

  { TdxPDFTextMarkupAnnotation }

  TdxPDFTextMarkupAnnotation = class(TdxPDFMarkupAnnotation) // for internal use
  strict private
    FQuadArray: TdxPDFQuadrilateralArray;
    //
    function GetQuadArray: TdxPDFQuadrilateralArray;
  protected
    function CreateAppearanceBuilder: TObject; override;
    procedure Resolve(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    function GetMarkupType: TdxPDFTextMarkupAnnotationType; virtual; abstract;
  public
    property MarkupType: TdxPDFTextMarkupAnnotationType read GetMarkupType;
    property QuadArray: TdxPDFQuadrilateralArray read GetQuadArray;
  end;

  { TdxPDFUnderlineAnnotation }

  TdxPDFUnderlineAnnotation = class(TdxPDFTextMarkupAnnotation) // for internal use
  protected
    function GetMarkupType: TdxPDFTextMarkupAnnotationType; override;
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFSquigglyAnnotation }

  TdxPDFSquigglyAnnotation = class(TdxPDFTextMarkupAnnotation) // for internal use
  protected
    function GetMarkupType: TdxPDFTextMarkupAnnotationType; override;
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFStrikeOutAnnotation }

  TdxPDFStrikeOutAnnotation = class(TdxPDFTextMarkupAnnotation) // for internal use
  protected
    function GetMarkupType: TdxPDFTextMarkupAnnotationType; override;
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFHighlightAnnotation }

  TdxPDFHighlightAnnotation = class(TdxPDFTextMarkupAnnotation) // for internal use
  protected
    function GetMarkupType: TdxPDFTextMarkupAnnotationType; override;
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFTextMarkupAnnotationAppearanceBuilder }

  TdxPDFTextMarkupAnnotationAppearanceBuilder = class(TdxPDFCustomMarkupAnnotationAppearanceBuilder) // for internal use
  strict private
    function GetAnnotation: TdxPDFTextMarkupAnnotation;
  protected
    procedure Rebuild(AConstructor: TdxPDFXFormCommandConstructor); override;
  public
    constructor Create(AAnnotation: TdxPDFTextMarkupAnnotation); reintroduce;
  end;

implementation

uses
  Math, dxPDFUtils, dxPDFCommandInterpreter, dxCore;

const
  dxThisUnitName = 'dxPDFTextMarkupAnnotation';

type
  TdxPDFTilingPatternAccess = class(TdxPDFTilingPattern);

  { TdxPDFTextMarkupAppearanceBuilderStrategy }

  TdxPDFTextMarkupAppearanceBuilderStrategy = class
  strict private const
    UnderlineFactor = 10 / 72;
    StrikeoutFactor = 0.5 - UnderlineFactor / 2;
  strict private
    FAnnotation: TdxPDFTextMarkupAnnotation;
    FConstructor: TdxPDFXFormCommandConstructor;
  protected
    procedure BeginRebuild; virtual;
    procedure EndRebuild; virtual;
    procedure RebuildQuad(const AQuad: TdxPDFQuadrilateral); virtual; abstract;
    //
    property Annotation: TdxPDFTextMarkupAnnotation read FAnnotation;
    property CommandConstructor: TdxPDFXFormCommandConstructor read FConstructor;
  public
    class function CreateStrategy(AAnnotation: TdxPDFTextMarkupAnnotation;
      AConstructor: TdxPDFXFormCommandConstructor): TdxPDFTextMarkupAppearanceBuilderStrategy; static;
    //
    constructor Create(AAnnotation: TdxPDFTextMarkupAnnotation; AConstructor: TdxPDFXFormCommandConstructor); virtual;
    procedure RebuildAppearance;
  end;

  { TdxPDFTextMarkupUnderlineAppearanceBuilderStrategy }

  TdxPDFTextMarkupUnderlineAppearanceBuilderStrategy = class(TdxPDFTextMarkupAppearanceBuilderStrategy)
  strict private const
    LineWidthFactor = 1 / 15.0;
  strict private
    FHeightFactor: Double;
  protected
    procedure BeginRebuild; override;
    procedure RebuildQuad(const AQuad: TdxPDFQuadrilateral); override;
  public
    constructor Create(AAnnotation: TdxPDFTextMarkupAnnotation; AConstructor: TdxPDFXFormCommandConstructor;
      const AHeightFactor: Double); reintroduce;
  end;

  { TdxPDFTextMarkupSquigglyAppearanceBuilderStrategy }

  TdxPDFTextMarkupSquigglyAppearanceBuilderStrategy = class(TdxPDFTextMarkupAppearanceBuilderStrategy)
  strict private const
    PatternHeight = 12;
    RadToDegFactor = 180 / PI;
    WidthToHeightFactor = 1.8;
  strict private
    FPattern: TdxPDFTilingPattern;
  protected
    procedure RebuildQuad(const AQuad: TdxPDFQuadrilateral); override;
  public
    constructor Create(AAnnotation: TdxPDFTextMarkupAnnotation; AConstructor: TdxPDFXFormCommandConstructor); override;
    destructor Destroy; override;
  end;

  { TdxPDFTextMarkupSquigglyAppearanceBuilderStrategy }

  TdxPDFTextMarkupHighlightAppearanceBuilderStrategy = class(TdxPDFTextMarkupAppearanceBuilderStrategy)
  strict private const
    BezierOffsetFactor = 0.235;
  strict private
    FGroupForm: TdxPDFXFormGroup;
    FGroupFormCommandConstructor: TdxPDFXFormCommandConstructor;
  protected
    procedure BeginRebuild; override;
    procedure EndRebuild; override;
    procedure RebuildQuad(const AQuad: TdxPDFQuadrilateral); override;
  public
    constructor Create(AAnnotation: TdxPDFTextMarkupAnnotation; AConstructor: TdxPDFXFormCommandConstructor); override;
    destructor Destroy; override;
  end;


{ TdxPDFTextMarkupAppearanceBuilderStrategy }

class function TdxPDFTextMarkupAppearanceBuilderStrategy.CreateStrategy(AAnnotation: TdxPDFTextMarkupAnnotation;
  AConstructor: TdxPDFXFormCommandConstructor): TdxPDFTextMarkupAppearanceBuilderStrategy;
begin
  if AAnnotation is TdxPDFUnderlineAnnotation then
    Result := TdxPDFTextMarkupUnderlineAppearanceBuilderStrategy.Create(AAnnotation, AConstructor, UnderlineFactor)
  else
    if AAnnotation is TdxPDFSquigglyAnnotation then
      Result:= TdxPDFTextMarkupSquigglyAppearanceBuilderStrategy.Create(AAnnotation, AConstructor)
    else
      if AAnnotation is TdxPDFStrikeOutAnnotation then
        Result := TdxPDFTextMarkupUnderlineAppearanceBuilderStrategy.Create(AAnnotation, AConstructor, StrikeoutFactor)
      else
        Result := TdxPDFTextMarkupHighlightAppearanceBuilderStrategy.Create(AAnnotation, AConstructor);
end;

constructor TdxPDFTextMarkupAppearanceBuilderStrategy.Create(AAnnotation: TdxPDFTextMarkupAnnotation;
  AConstructor: TdxPDFXFormCommandConstructor);
begin
  inherited Create;
  FAnnotation := AAnnotation;
  FConstructor := AConstructor;
end;

procedure TdxPDFTextMarkupAppearanceBuilderStrategy.BeginRebuild;
begin
  FConstructor.SaveGraphicsState;
end;

procedure TdxPDFTextMarkupAppearanceBuilderStrategy.EndRebuild;
begin
  FConstructor.RestoreGraphicsState;
end;

procedure TdxPDFTextMarkupAppearanceBuilderStrategy.RebuildAppearance;
var
  I, L: Integer;
begin
  L := Length(FAnnotation.QuadArray);
  if L = 0 then
    Exit;
  BeginRebuild;
  for I := 0 to L - 1 do
    RebuildQuad(FAnnotation.QuadArray[I]);
  EndRebuild;
end;

{ TdxPDFTextMarkupUnderlineAppearanceBuilderStrategy }

constructor TdxPDFTextMarkupUnderlineAppearanceBuilderStrategy.Create(AAnnotation: TdxPDFTextMarkupAnnotation;
  AConstructor: TdxPDFXFormCommandConstructor; const AHeightFactor: Double);
begin
  inherited Create(AAnnotation, AConstructor);
  FHeightFactor := AHeightFactor;
end;

procedure TdxPDFTextMarkupUnderlineAppearanceBuilderStrategy.BeginRebuild;
var
  AAnnotation: TdxPDFCustomAnnotation;
  ARect: TdxPDFRectangle;
begin
  inherited BeginRebuild;
  AAnnotation := Annotation;
  ARect := AAnnotation.Rect;
  if (ARect.Left <> 0) or (ARect.Bottom <> 0) then
    CommandConstructor.ModifyTransformationMatrix(TdxPDFTransformationMatrix.Create(1, 0, 0, 1, -ARect.Left, -ARect.Bottom));
  CommandConstructor.SetColorForStrokingOperations(AAnnotation.Color);
end;

procedure TdxPDFTextMarkupUnderlineAppearanceBuilderStrategy.RebuildQuad(const AQuad: TdxPDFQuadrilateral);
begin
  CommandConstructor.SetLineWidth(TdxPDFUtils.Min(
    TdxPDFUtils.Distance(AQuad.P3, AQuad.P1),
    TdxPDFUtils.Distance(AQuad.P4, AQuad.P2)) * LineWidthFactor);
  CommandConstructor.DrawLine(
    TdxPDFUtils.Lerp(AQuad.P3, AQuad.P1, FHeightFactor),
    TdxPDFUtils.Lerp(AQuad.P4, AQuad.P2, FHeightFactor));
end;

constructor TdxPDFTextMarkupSquigglyAppearanceBuilderStrategy.Create(AAnnotation: TdxPDFTextMarkupAnnotation;
  AConstructor: TdxPDFXFormCommandConstructor);
var
  APatternConstructor: TdxPDFCommandConstructor;
  APoints: TdxPointsF;
begin
  inherited Create(AAnnotation, AConstructor);
  FPattern := TdxPDFTilingPattern.Create(AAnnotation.Repository, TdxPDFTransformationMatrix.Create,
    TdxPDFRectangle.Create(0, 0, 10, PatternHeight), 10, 13, False);
  APatternConstructor := TdxPDFCommandConstructor.Create(FPattern.Resources);
  try
    APatternConstructor.SaveGraphicsState;
    APatternConstructor.SetLineCapStyle(lcsRound);
    APatternConstructor.SetLineJoinStyle(ljsRound);
    APatternConstructor.SetLineWidth(1);
    APatternConstructor.SetLineStyle(AAnnotation.Repository.CreateSolidLineStyle);

    SetLength(APoints, 3);
    APoints[0] := dxPointF(0, 1);
    APoints[1] := dxPointF(5, 11);
    APoints[1] := dxPointF(10, 1);
    APatternConstructor.DrawLines(APoints);

    APatternConstructor.RestoreGraphicsState;

    TdxPDFTilingPatternAccess(FPattern).ReplaceCommands(APatternConstructor.Commands);
  finally
    APatternConstructor.Free;
  end;
end;

destructor TdxPDFTextMarkupSquigglyAppearanceBuilderStrategy.Destroy;
begin
  FreeAndNil(FPattern);
  inherited Destroy;
end;

procedure TdxPDFTextMarkupSquigglyAppearanceBuilderStrategy.RebuildQuad(const AQuad: TdxPDFQuadrilateral);
var
  AAnnotation: TdxPDFTextMarkupAnnotation;
  ARect: TdxPDFRectangle;
  AColor: TdxPDFColor;
  AQuadHeight, AScaleY, AScaleX, AWidth: Double;
  AMatrixRotate, AMatrixTranslate, AFullTransform: TdxPDFTransformationMatrix;
  AForm: TdxPDFXForm;
  AFormConstructor: TdxPDFXFormCommandConstructor;
begin
  AAnnotation := Annotation;
  ARect := AAnnotation.Rect;
  AColor := AAnnotation.Color;
  AQuadHeight := TdxPDFUtils.Distance(AQuad.P2, AQuad.P4);

  AScaleY := AQuadHeight / 72.0;
  AScaleX := WidthToHeightFactor * AScaleY;

  AWidth := TdxPDFUtils.Distance(AQuad.P3, AQuad.P4) / AScaleX;

  AMatrixRotate := TdxPDFTransformationMatrix.CreateRotate(Math.ArcTan2(AQuad.P4.Y - AQuad.P3.Y, AQuad.P4.X - AQuad.P3.X) * RadToDegFactor);
  AMatrixTranslate := TdxPDFTransformationMatrix.Create(1, 0, 0, 1, AQuad.P3.X - ARect.Left, AQuad.P3.Y - ARect.Bottom + 1.285 * AScaleY);
  AFullTransform := TdxPDFTransformationMatrix.Multiply(TdxPDFTransformationMatrix.CreateScale(AScaleX, AScaleY), AMatrixRotate);
  AFullTransform := TdxPDFTransformationMatrix.Multiply(AFullTransform, AMatrixTranslate);

  AForm := TdxPDFXForm.Create(AAnnotation.Repository, TdxPDFRectangle.Create(-0.5, -0.5, AWidth + 0.5, PatternHeight + 0.5));
  AForm.Matrix := TdxPDFTransformationMatrix.Create(1, 0, 0, 1, 0.5, 0.5);
  AFormConstructor := TdxPDFXFormCommandConstructor.Create(AForm);
  try
    AFormConstructor.SaveGraphicsState;
    if AColor.IsNull then
      AFormConstructor.SetColorForNonStrokingOperations(TdxPDFColor.Create(FPattern, nil))
    else
      AFormConstructor.SetColorForNonStrokingOperations(TdxPDFColor.Create(FPattern, AColor.Components));
    AFormConstructor.FillRectangle(TdxPDFRectangle.Create(0, 0, AWidth, PatternHeight));
    AFormConstructor.RestoreGraphicsState;
    AForm.ReplaceCommands(AFormConstructor.Commands);
  finally
    AFormConstructor.Free;
  end;
  CommandConstructor.DrawForm(AForm, AFullTransform);
end;

{ TdxPDFTextMarkupHighlightAppearanceBuilderStrategy }

constructor TdxPDFTextMarkupHighlightAppearanceBuilderStrategy.Create(AAnnotation: TdxPDFTextMarkupAnnotation; AConstructor: TdxPDFXFormCommandConstructor);
begin
  inherited Create(AAnnotation, AConstructor);
  FGroupForm := TdxPDFXFormGroup.Create(AAnnotation.Repository, AConstructor.BoundingBox);
  FGroupFormCommandConstructor := TdxPDFXFormCommandConstructor.Create(FGroupForm);
end;

destructor TdxPDFTextMarkupHighlightAppearanceBuilderStrategy.Destroy;
begin
  FreeAndNil(FGroupFormCommandConstructor);
  inherited Destroy;
end;

procedure TdxPDFTextMarkupHighlightAppearanceBuilderStrategy.BeginRebuild;
var
  ARect: TdxPDFRectangle;
begin
  inherited BeginRebuild;
  CommandConstructor.SetGraphicsStateParameters(TdxPDFGraphicsStateParameters.Create);
  ARect := Annotation.Rect;
  FGroupFormCommandConstructor.SetColorForNonStrokingOperations(Annotation.Color);
  FGroupFormCommandConstructor.ModifyTransformationMatrix(TdxPDFTransformationMatrix.Create(1, 0, 0, 1, -ARect.Left, -ARect.Bottom));
end;

procedure TdxPDFTextMarkupHighlightAppearanceBuilderStrategy.EndRebuild;
begin
  FGroupForm.ReplaceCommands(FGroupFormCommandConstructor.Commands);
  CommandConstructor.DrawForm(FGroupForm, TdxPDFTransformationMatrix.Create);
  inherited EndRebuild;
end;

procedure TdxPDFTextMarkupHighlightAppearanceBuilderStrategy.RebuildQuad(const AQuad: TdxPDFQuadrilateral);
var
  AP1, AP2, AP3, AP4, AInitialPoint, AActualPoint: TdxPointF;
  APath: TdxPDFGraphicsPath;
  Y, X: Double;
begin
  AP1 := AQuad.P1;
  AP2 := AQuad.P2;
  AP3 := AQuad.P3;
  AP4 := AQuad.P4;
  APath := TdxPDFGraphicsPath.Create(AP1);
  try
    Y := -(AP1.X - AP3.X) * BezierOffsetFactor;
    X := (AP1.Y - AP3.Y) * BezierOffsetFactor;
    AInitialPoint := TdxPDFUtils.Lerp(AP1, AP3, BezierOffsetFactor);
    AActualPoint := dxPointF(AInitialPoint.X - X, AInitialPoint.Y - Y);
    AInitialPoint := TdxPDFUtils.Lerp(AP3, AP1, BezierOffsetFactor);

    APath.AppendBezierSegment(AActualPoint, dxPointF(AInitialPoint.X - X, AInitialPoint.Y - Y), AP3);
    APath.AppendLineSegment(AP4);

    Y := -(AP2.X - AP4.X) * BezierOffsetFactor;
    X := (AP2.Y - AP4.Y) * BezierOffsetFactor;
    AInitialPoint := TdxPDFUtils.Lerp(AP4, AP2, BezierOffsetFactor);
    AActualPoint := dxPointF(AInitialPoint.X + X, AInitialPoint.Y + Y);
    AInitialPoint := TdxPDFUtils.Lerp(AP2, AP4, BezierOffsetFactor);
    APath.AppendBezierSegment(AActualPoint, dxPointF(AInitialPoint.X + X, AInitialPoint.Y + Y), AP2);
    APath.IsClosed := True;

    FGroupFormCommandConstructor.FillPath(APath, True);
  finally
    APath.Free;
  end;
end;

{ TdxPDFTextMarkupAnnotationAppearanceBuilder }

constructor TdxPDFTextMarkupAnnotationAppearanceBuilder.Create(AAnnotation: TdxPDFTextMarkupAnnotation);
begin
  inherited Create(AAnnotation);
end;

function TdxPDFTextMarkupAnnotationAppearanceBuilder.GetAnnotation: TdxPDFTextMarkupAnnotation;
begin
  Result := FAnnotation as TdxPDFTextMarkupAnnotation;
end;

procedure TdxPDFTextMarkupAnnotationAppearanceBuilder.Rebuild(AConstructor: TdxPDFXFormCommandConstructor);
var
  AStrategy: TdxPDFTextMarkupAppearanceBuilderStrategy;
begin
  inherited Rebuild(AConstructor);
  AStrategy := TdxPDFTextMarkupAppearanceBuilderStrategy.CreateStrategy(GetAnnotation, AConstructor);
  try
    AStrategy.RebuildAppearance;
  finally
    AStrategy.Free;
  end;
end;

{ TdxPDFTextMarkupAnnotation }

function TdxPDFTextMarkupAnnotation.GetQuadArray: TdxPDFQuadrilateralArray;
begin
  Ensure;
  Result := FQuadArray;
end;

function TdxPDFTextMarkupAnnotation.CreateAppearanceBuilder: TObject;
begin
  Result := TdxPDFTextMarkupAnnotationAppearanceBuilder.Create(Self);
end;

procedure TdxPDFTextMarkupAnnotation.Resolve(ADictionary: TdxPDFReaderDictionary);
begin
  inherited Resolve(ADictionary);
  FQuadArray := ADictionary.GetQuadrilateralArray;
end;

procedure TdxPDFTextMarkupAnnotation.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.AddQuadrilateralArray(QuadArray);
end;

{ TdxPDFUnderlineAnnotation }

class function TdxPDFUnderlineAnnotation.GetTypeName: string;
begin
  Result := TdxPDFKeywords.UnderlineAnnotation;
end;

function TdxPDFUnderlineAnnotation.GetMarkupType: TdxPDFTextMarkupAnnotationType;
begin
  Result := tmatUnderline;
end;

{ TdxPDFSquigglyAnnotation }

class function TdxPDFSquigglyAnnotation.GetTypeName: string;
begin
  Result := TdxPDFKeywords.SquigglyAnnotation;
end;

function TdxPDFSquigglyAnnotation.GetMarkupType: TdxPDFTextMarkupAnnotationType;
begin
  Result := tmatSquiggly;
end;

{ TdxPDFStrikeOutAnnotation }

class function TdxPDFStrikeOutAnnotation.GetTypeName: string;
begin
  Result := TdxPDFKeywords.StrikeOutAnnotation;
end;

function TdxPDFStrikeOutAnnotation.GetMarkupType: TdxPDFTextMarkupAnnotationType;
begin
  Result := tmatStrikeOut;
end;

{ TdxPDFHighlightAnnotation }

class function TdxPDFHighlightAnnotation.GetTypeName: string;
begin
  Result := TdxPDFKeywords.HighlightAnnotation;
end;

function TdxPDFHighlightAnnotation.GetMarkupType: TdxPDFTextMarkupAnnotationType;
begin
  Result := tmatHighlight;
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxPDFRegisterDocumentObjectClass(TdxPDFUnderlineAnnotation);
  dxPDFRegisterDocumentObjectClass(TdxPDFSquigglyAnnotation);
  dxPDFRegisterDocumentObjectClass(TdxPDFStrikeOutAnnotation);
  dxPDFRegisterDocumentObjectClass(TdxPDFHighlightAnnotation);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxPDFUnregisterDocumentObjectClass(TdxPDFUnderlineAnnotation);
  dxPDFUnregisterDocumentObjectClass(TdxPDFSquigglyAnnotation);
  dxPDFUnregisterDocumentObjectClass(TdxPDFStrikeOutAnnotation);
  dxPDFUnregisterDocumentObjectClass(TdxPDFHighlightAnnotation);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
