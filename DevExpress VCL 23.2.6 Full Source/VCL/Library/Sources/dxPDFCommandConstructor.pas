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

unit dxPDFCommandConstructor;

{$I cxVer.inc}

interface

uses
  Types, Classes, SysUtils, Generics.Defaults, Generics.Collections, cxGeometry, dxCore, dxCoreClasses, dxPDFBase,
  dxPDFTypes, dxPDFCore, dxPDFCommandInterpreter;

type
  { TdxPDFCommandConstructor }

  TdxPDFCommandConstructor = class // for internal use
  strict private type
    TdxPDFResourcesAccess = class(TdxPDFResources);
  strict private const
    Pattern = '/Pattern ';
    UseEvenOddRule = Byte('*');
  strict private
    FEllipticFactor: Single;
    FCurrentTransformationMatrix: TdxPDFTransformationMatrix;
    FMatrixStack: TStack<TdxPDFTransformationMatrix>;
    FResources: TdxPDFResourcesAccess;
    FWriter: TdxPDFWriter;
    function GetCommands: TBytes;
    procedure AppendBezierCurve(const P1, P2, P3: TdxPointF);
    procedure GeneratePathCommands(APath: TdxPDFGraphicsPath);
    procedure SetCurrentTransformationMatrix(const AValue: TdxPDFTransformationMatrix);
    procedure WriteAppendBezierCurveCommand;
    procedure WriteAppendLineSegmentCommand;
    procedure WriteBeginPathCommand;
    procedure WriteClosePathCommand;
    procedure WriteCloseBracket;
    procedure WriteCommand(const ACommandClass: TdxPDFCustomCommandClass);
    procedure WriteDouble(AValue: Double);
    procedure WriteIntersectClipCommand(ANonZero: Boolean);
    procedure WriteFillPathCommand(ANonZero: Boolean);
    procedure WriteFillAndStrokePathCommand(ANonZero: Boolean);
    procedure WriteHexadecimalString(const AData: TBytes);
    procedure WriteNameDelimiter;
    procedure WriteOpenBracket;
    procedure WriteOperationData(const AData: string);
    procedure WritePoint(const P: TdxPointF);
    procedure WriteSpace;
    procedure WriteString(const S: string);
    procedure WriteStrokePathCommand;
  public
    constructor Create(AResources: TdxPDFResources);
    destructor Destroy; override;

    procedure AddCommands(const AData: TBytes);
    procedure AppendEllipse(const ARect: TdxPDFRectangle);
    procedure AppendPath(APath: TdxPDFGraphicsPath);
    procedure AppendPolygon(const APoints: TdxPDFPoints);
    procedure AppendRectangle(const ARect: TdxPDFRectangle);
    procedure BeginMarkedContent;
    procedure BeginText;
    procedure ClosePath;
    procedure CloseAndStrokePath;
    procedure EndMarkedContent;
    procedure EndText;
    procedure DrawEllipse(const ARect: TdxPDFRectangle);
    procedure DrawImage(AObject: TdxPDFXObject; const ARect: TdxPDFRectangle);
    procedure DrawForm(AForm: TdxPDFXForm; const AMatrix: TdxPDFTransformationMatrix);
    procedure DrawLine(const P1, P2: TdxPointF);
    procedure DrawLines(const AValue: TdxPDFPoints);
    procedure DrawPolygon(const AValue: TdxPDFPoints);
    procedure DrawRectangle(const ARect: TdxPDFRectangle);
    procedure DrawXObject(AXObject: TdxPDFXObject; const AMatrix: TdxPDFTransformationMatrix);
    procedure IntersectClip(const ARect: TdxPDFRectangle); overload;
    procedure IntersectClip(APath: TdxPDFGraphicsPath; ANonZero: Boolean = True); overload;
    procedure IntersectClip(APaths: TdxFastList; ANonZero: Boolean); overload;
    procedure FillEllipse(const ARect: TdxPDFRectangle);
    procedure FillPath(ANonZero: Boolean); overload;
    procedure FillPath(APath: TdxPDFGraphicsPath; ANonZero: Boolean); overload;
    procedure FillPath(APaths: TdxFastList; ANonZero: Boolean); overload;
    procedure FillAndStrokePath(ANonZero: Boolean);
    procedure FillPolygon(const APoints: TdxPDFPoints; ANonZero: Boolean);
    procedure FillRectangle(const ARect: TdxPDFRectangle);
    procedure ModifyTransformationMatrix(const AMatrix: TdxPDFTransformationMatrix);
    procedure SaveGraphicsState;
    procedure SetCharacterSpacing(AValue: Single);
    procedure SetColorForNonStrokingOperations(const AColor: TdxPDFColor); overload;
    procedure SetColorForNonStrokingOperations(const AColor: TdxPDFARGBColor); overload;
    procedure SetColorForStrokingOperations(const AColor: TdxPDFColor); overload;
    procedure SetColorForStrokingOperations(const AColor: TdxPDFARGBColor); overload;
    procedure SetGraphicsStateParameters(AParameters: TdxPDFGraphicsStateParameters);
    procedure SetLineCapStyle(AValue: TdxPDFLineCapStyle);
    procedure SetLineJoinStyle(AValue: TdxPDFLineJoinStyle);
    procedure SetLineStyle(AValue: TdxPDFLineStyle);
    procedure SetLineWidth(AValue: Single);
    procedure SetMiterLimit(AValue: Single);
    procedure SetObliqueTextMatrix(X, Y: Single);
    procedure SetTextFont(AFont: TObject; AFontSize: Single); overload;
    procedure SetTextFont(const AFontName: string; AFontSize: Single); overload;
    procedure SetTextHorizontalScaling(AValue: Single);
    procedure SetTextRenderingMode(AValue: TdxPDFTextRenderingMode);
    procedure SetWordSpacing(AValue: Single);
    procedure ShowText(const AText: TBytes; AGlyphOffsets: TDoubleDynArray);
    procedure StartTextLineWithOffsets(X, Y: Single);
    procedure StrokePath;
    procedure RestoreGraphicsState;

    property Commands: TBytes read GetCommands;
    property CurrentTransformationMatrix: TdxPDFTransformationMatrix read FCurrentTransformationMatrix write
      SetCurrentTransformationMatrix;
  end;

  { TdxPDFXFormCommandConstructor }

  TdxPDFXFormCommandConstructor = class(TdxPDFCommandConstructor) // for internal use
  strict private
    FContentSquare: TdxPDFRectangle;
    FForm: TdxPDFXForm;
    //
    function GetBoundingBox: TdxPDFRectangle;
    function GetCatalog: TdxPDFCatalog;
  public
    constructor Create(AForm: TdxPDFXForm);
    //
    property BoundingBox: TdxPDFRectangle read GetBoundingBox;
    property Catalog: TdxPDFCatalog read GetCatalog;
    property ContentSquare: TdxPDFRectangle read FContentSquare;
    property Form: TdxPDFXForm read FForm;
  end;

implementation

uses
  RTLConsts, Math, dxPDFCommand, dxPDFUtils;

const
  dxThisUnitName = 'dxPDFCommandConstructor';

type
  TdxPDFObjectAccess = class(TdxPDFObject);

{ TdxPDFCommandConstructor }

constructor TdxPDFCommandConstructor.Create(AResources: TdxPDFResources);
begin
  inherited Create;
  FWriter := TdxPDFWriter.Create(TdxPDFMemoryStream.Create, True);
  FMatrixStack := TStack<TdxPDFTransformationMatrix>.Create;
  FCurrentTransformationMatrix := TdxPDFTransformationMatrix.Create;
  FResources := TdxPDFResourcesAccess(AResources);
  FEllipticFactor := 0.5 - (1 / Sqrt(2) - 0.5) / 0.75;
end;

destructor TdxPDFCommandConstructor.Destroy;
begin
  FreeAndNil(FMatrixStack);
  FreeAndNil(FWriter);
  inherited Destroy;
end;

procedure TdxPDFCommandConstructor.AddCommands(const AData: TBytes);
begin
  if Length(AData) > 0 then
  begin
    WriteSpace;
    FWriter.WriteBytes(AData);
  end;
end;

procedure TdxPDFCommandConstructor.AppendEllipse(const ARect: TdxPDFRectangle);

  procedure AppendCurveCommand(const P11, P12, P21, P22, p31, P32: Single);
  begin
    AppendBezierCurve(dxPointF(P11, P12), dxPointF(P21, P22), dxPointF(P31, P32));
  end;

var
  ABottom, ATop, ACenterY, AVerticalOffset, ABottomControlPoint, ATopControlPoint: Double;
  ALeft, ARight, ACenterX, AHorizontalOffset, ALeftControlPoint, ARightControlPoint: Double;
begin
  ALeft := ARect.Left;
  ARight := ARect.Right;
  ACenterX := (ALeft + ARight) / 2;
  AHorizontalOffset := (ARight - ALeft) * FEllipticFactor;
  ALeftControlPoint := ALeft + AHorizontalOffset;
  ARightControlPoint := ARight - AHorizontalOffset;
  ABottom := ARect.Bottom;
  ATop := ARect.Top;
  ACenterY := (ABottom + ATop) / 2;
  AVerticalOffset := (ATop - ABottom) * FEllipticFactor;
  ABottomControlPoint := ABottom + AVerticalOffset;
  ATopControlPoint := ATop - AVerticalOffset;

  WritePoint(dxPointF(ARight, ACenterY));
  WriteBeginPathCommand;

  AppendCurveCommand(ARight, ATopControlPoint, ARightControlPoint, ATop, ACenterX, ATop);
  AppendCurveCommand(ALeftControlPoint, ATop, ALeft, ATopControlPoint, ALeft, ACenterY);
  AppendCurveCommand(ALeft, ABottomControlPoint, ALeftControlPoint, ABottom, ACenterX, ABottom);
  AppendCurveCommand(ARightControlPoint, ABottom, ARight, ABottomControlPoint, ARight, ACenterY);
end;

procedure TdxPDFCommandConstructor.AppendPath(APath: TdxPDFGraphicsPath);
begin
  GeneratePathCommands(APath);
end;

procedure TdxPDFCommandConstructor.AppendPolygon(const APoints: TdxPDFPoints);
var
  I, APointCount: Integer;
begin
  APointCount := Length(APoints);
  if APointCount >= 2 then
  begin
    WritePoint(APoints[0]);
    WriteBeginPathCommand;
    for I := 1 to APointCount - 1 do
    begin
      WritePoint(APoints[I]);
      WriteAppendLineSegmentCommand;
    end;
  end;
end;

procedure TdxPDFCommandConstructor.AppendRectangle(const ARect: TdxPDFRectangle);
begin
  WriteDouble(ARect.Left);
  WriteDouble(ARect.Bottom);
  WriteDouble(ARect.Width);
  WriteDouble(ARect.Height);
  WriteCommand(TdxPDFAppendRectangleCommand);
end;

procedure TdxPDFCommandConstructor.BeginMarkedContent;
begin
  WriteOperationData('/Tx BMC');
end;

procedure TdxPDFCommandConstructor.BeginText;
begin
  WriteCommand(TdxPDFBeginTextCommand);
  WriteSpace;
end;

procedure TdxPDFCommandConstructor.ClosePath;
begin
  WriteClosePathCommand;
  WriteSpace;
end;

procedure TdxPDFCommandConstructor.CloseAndStrokePath;
begin
  WriteCommand(TdxPDFCloseAndStrokePathCommand);
end;

procedure TdxPDFCommandConstructor.EndMarkedContent;
begin
  WriteOperationData('EMC');
end;

procedure TdxPDFCommandConstructor.EndText;
begin
  WriteCommand(TdxPDFEndTextCommand);
end;

procedure TdxPDFCommandConstructor.DrawEllipse(const ARect: TdxPDFRectangle);
begin
  AppendEllipse(ARect);
  CloseAndStrokePath;
end;

procedure TdxPDFCommandConstructor.DrawImage(AObject: TdxPDFXObject; const ARect: TdxPDFRectangle);
begin
  DrawXObject(AObject, TdxPDFTransformationMatrix.Create(ARect.Width, 0, 0, Abs(ARect.Height),
    ARect.Left, ARect.Bottom));
end;

procedure TdxPDFCommandConstructor.DrawForm(AForm: TdxPDFXForm; const AMatrix: TdxPDFTransformationMatrix);
begin
  if not TdxPDFUtils.IsIntegerValid(AForm.Number) then
  begin
    AForm.Number := TdxPDFObjectAccess(AForm).Repository.MaxObjectNumber;
    TdxPDFObjectAccess(AForm).Repository.Add(AForm.Number, AForm);
  end;
  DrawXObject(AForm, AMatrix);
end;

procedure TdxPDFCommandConstructor.DrawLine(const P1, P2: TdxPointF);
begin
  WritePoint(P1);
  WriteBeginPathCommand;
  WritePoint(P2);
  WriteAppendLineSegmentCommand;
  WriteStrokePathCommand;
end;

procedure TdxPDFCommandConstructor.DrawLines(const AValue: TdxPDFPoints);
begin
  AppendPolygon(AValue);
  WriteStrokePathCommand;
end;

procedure TdxPDFCommandConstructor.DrawPolygon(const AValue: TdxPDFPoints);
begin
  AppendPolygon(AValue);
  CloseAndStrokePath;
end;

procedure TdxPDFCommandConstructor.DrawRectangle(const ARect: TdxPDFRectangle);
begin
  AppendRectangle(ARect);
  WriteStrokePathCommand;
end;

procedure TdxPDFCommandConstructor.DrawXObject(AXObject: TdxPDFXObject; const AMatrix: TdxPDFTransformationMatrix);
begin
  SaveGraphicsState;
  ModifyTransformationMatrix(AMatrix);
  WriteNameDelimiter;
  WriteString(FResources.AddXObject(AXObject));
  WriteCommand(TdxPDFPaintXObjectCommand);
  RestoreGraphicsState;
end;

procedure TdxPDFCommandConstructor.IntersectClip(const ARect: TdxPDFRectangle);
begin
  AppendRectangle(ARect);
  WriteCommand(TdxPDFModifyClippingPathUsingNonzeroWindingNumberRuleCommand);
  WriteCommand(TdxPDFEndPathWithoutFillingAndStrokingCommand);
end;

procedure TdxPDFCommandConstructor.IntersectClip(APath: TdxPDFGraphicsPath; ANonZero: Boolean = True);
begin
  GeneratePathCommands(APath);
  WriteIntersectClipCommand(ANonZero);
end;

procedure TdxPDFCommandConstructor.IntersectClip(APaths: TdxFastList; ANonZero: Boolean);
var
  I: Integer;
begin
  for I := 0 to APaths.Count - 1 do
    GeneratePathCommands(TdxPDFGraphicsPath(APaths[I]));
  WriteIntersectClipCommand(ANonZero);
end;

procedure TdxPDFCommandConstructor.FillEllipse(const ARect: TdxPDFRectangle);
begin
  AppendEllipse(ARect);
  WriteClosePathCommand;
  WriteFillPathCommand(True);
end;

procedure TdxPDFCommandConstructor.FillPath(ANonZero: Boolean);
begin
  WriteFillPathCommand(ANonZero);
end;

procedure TdxPDFCommandConstructor.FillPath(APath: TdxPDFGraphicsPath; ANonZero: Boolean);
begin
  GeneratePathCommands(APath);
  WriteFillPathCommand(ANonZero);
end;

procedure TdxPDFCommandConstructor.FillPath(APaths: TdxFastList; ANonZero: Boolean);
var
  I: Integer;
begin
  for I := 0 to APaths.Count - 1 do
    GeneratePathCommands(TdxPDFGraphicsPath(APaths[I]));
  WriteFillPathCommand(ANonZero);
end;

procedure TdxPDFCommandConstructor.FillAndStrokePath(ANonZero: Boolean);
begin
  WriteFillAndStrokePathCommand(ANonZero);
end;

procedure TdxPDFCommandConstructor.FillPolygon(const APoints: TdxPDFPoints; ANonZero: Boolean);
begin
  AppendPolygon(APoints);
  WriteFillPathCommand(ANonZero);
end;

procedure TdxPDFCommandConstructor.FillRectangle(const ARect: TdxPDFRectangle);
begin
  AppendRectangle(ARect);
  WriteFillPathCommand(True);
end;

procedure TdxPDFCommandConstructor.ModifyTransformationMatrix(const AMatrix: TdxPDFTransformationMatrix);
begin
  CurrentTransformationMatrix := TdxPDFTransformationMatrix.Multiply(AMatrix, CurrentTransformationMatrix);
  WriteDouble(AMatrix.A);
  WriteDouble(AMatrix.B);
  WriteDouble(AMatrix.C);
  WriteDouble(AMatrix.D);
  WriteDouble(AMatrix.E);
  WriteDouble(AMatrix.F);
  WriteCommand(TdxPDFModifyTransformationMatrixCommand);
end;

procedure TdxPDFCommandConstructor.SaveGraphicsState;
begin
  FMatrixStack.Push(FCurrentTransformationMatrix);
  WriteCommand(TdxPDFSaveGraphicsStateCommand);
end;

procedure TdxPDFCommandConstructor.SetCharacterSpacing(AValue: Single);
begin
  WriteDouble(AValue);
  WriteCommand(TdxPDFSetCharacterSpacingCommand);
end;

procedure TdxPDFCommandConstructor.SetColorForNonStrokingOperations(const AColor: TdxPDFColor);
var
  AComponent: Double;
  AComponents: TDoubleDynArray;
begin
  if not AColor.IsNull then
    if AColor.Pattern = nil then
    begin
      AComponents := AColor.Components;
      case Length(AComponents) of
        1:
          begin
            WriteDouble(AComponents[0]);
            WriteCommand(TdxPDFSetGrayColorSpaceForNonStrokingOperationsCommand);
          end;
        4:
          begin
            WriteDouble(AComponents[0]);
            WriteDouble(AComponents[1]);
            WriteDouble(AComponents[2]);
            WriteDouble(AComponents[3]);
            WriteCommand(TdxPDFSetCMYKColorSpaceForNonStrokingOperationsCommand);
          end;
      else
        WriteDouble(AComponents[0]);
        WriteDouble(AComponents[1]);
        WriteDouble(AComponents[2]);
        WriteCommand(TdxPDFSetRGBColorSpaceForNonStrokingOperationsCommand);
      end;
    end
    else
    begin
      WriteOperationData(Pattern + TdxPDFSetColorSpaceForNonStrokingOperationsCommand.GetName);
      for AComponent in AColor.Components do
        WriteDouble(AComponent);
      WriteSpace;
      if AColor.Pattern <> nil then
      begin
        WriteNameDelimiter;
        WriteString(FResources.AddPattern(AColor.Pattern as TdxPDFCustomPattern));
      end;
      WriteCommand(TdxPDFSetColorAdvancedForNonStrokingOperationsCommand);
    end;
end;

procedure TdxPDFCommandConstructor.SetColorForNonStrokingOperations(const AColor: TdxPDFARGBColor);
var
  AGraphicsStateParameters: TdxPDFGraphicsStateParameters;
begin
  if AColor.Alpha <> 1 then
  begin
    AGraphicsStateParameters := TdxPDFGraphicsStateParameters.Create;
    AGraphicsStateParameters.NonStrokingColorAlpha := AColor.Alpha;
    SetGraphicsStateParameters(AGraphicsStateParameters);
  end;
  SetColorForNonStrokingOperations(AColor.ToPDFColor);
end;

procedure TdxPDFCommandConstructor.SetColorForStrokingOperations(const AColor: TdxPDFColor);
var
  AComponent: Double;
  AComponents: TDoubleDynArray;
begin
  if not AColor.IsNull then
    if AColor.Pattern = nil then
    begin
      AComponents := AColor.Components;
      case Length(AComponents) of
        1:
          begin
            WriteDouble(AComponents[0]);
            WriteCommand(TdxPDFSetGrayColorSpaceForStrokingOperationsCommand);
          end;
        4:
          begin
            WriteDouble(AComponents[0]);
            WriteDouble(AComponents[1]);
            WriteDouble(AComponents[2]);
            WriteDouble(AComponents[3]);
            WriteCommand(TdxPDFSetCMYKColorSpaceForStrokingOperationsCommand);
          end;
      else
        WriteDouble(AComponents[0]);
        WriteDouble(AComponents[1]);
        WriteDouble(AComponents[2]);
        WriteCommand(TdxPDFSetRGBColorSpaceForStrokingOperationsCommand);
      end;
    end
    else
    begin
      WriteOperationData(Pattern + TdxPDFSetColorSpaceForStrokingOperationsCommand.GetName);
      for AComponent in AColor.Components do
        WriteDouble(AComponent);
      WriteSpace;
      if AColor.Pattern <> nil then
      begin
        WriteNameDelimiter;
        WriteString(FResources.AddPattern(AColor.Pattern as TdxPDFCustomPattern));
      end;
      WriteCommand(TdxPDFSetColorAdvancedForStrokingOperationsCommand);
    end;
end;

procedure TdxPDFCommandConstructor.SetColorForStrokingOperations(const AColor: TdxPDFARGBColor);
begin
  WriteDouble(AColor.Red);
  WriteDouble(AColor.Green);
  WriteDouble(AColor.Blue);
  WriteCommand(TdxPDFSetRGBColorSpaceForStrokingOperationsCommand);
end;

procedure TdxPDFCommandConstructor.SetGraphicsStateParameters(AParameters: TdxPDFGraphicsStateParameters);
begin
  WriteNameDelimiter;
  FWriter.WriteString(FResources.AddGraphicsStateParameters(AParameters));
  WriteCommand(TdxPDFSetGraphicsStateParametersCommand);
end;

procedure TdxPDFCommandConstructor.SetLineCapStyle(AValue: TdxPDFLineCapStyle);
begin
  WriteSpace;
  WriteString(IntToStr(Integer(AValue)));
  WriteCommand(TdxPDFSetLineCapStyleCommand);
end;

procedure TdxPDFCommandConstructor.SetLineJoinStyle(AValue: TdxPDFLineJoinStyle);
begin
  WriteSpace;
  FWriter.WriteByte(Byte(AValue));
  WriteCommand(TdxPDFSetLineJoinStyleCommand);
end;

procedure TdxPDFCommandConstructor.SetLineStyle(AValue: TdxPDFLineStyle);
var
  I: Integer;
begin
  if AValue <> nil then
  begin
    WriteSpace;
    WriteOpenBracket;
    if Length(AValue.Pattern) > 0 then
      for I := Low(AValue.Pattern) to High(AValue.Pattern) do
        WriteDouble(AValue.Pattern[I]);
    WriteCloseBracket;
    WriteDouble(AValue.Phase);
    WriteCommand(TdxPDFSetLineStyleCommand);
  end;
end;

procedure TdxPDFCommandConstructor.SetLineWidth(AValue: Single);
begin
  WriteDouble(AValue);
  WriteCommand(TdxPDFSetLineWidthCommand);
end;

procedure TdxPDFCommandConstructor.SetMiterLimit(AValue: Single);
begin
  WriteDouble(AValue);
  WriteCommand(TdxPDFSetMiterLimitCommand);
end;

procedure TdxPDFCommandConstructor.SetObliqueTextMatrix(X, Y: Single);
begin
  WriteOperationData('1 0 0.333 1');
  WriteDouble(X);
  WriteDouble(Y);
  WriteCommand(TdxPDFSetTextMatrixCommand);
end;

procedure TdxPDFCommandConstructor.SetTextFont(AFont: TObject; AFontSize: Single);
begin
  SetTextFont(FResources.AddFont(AFont as TdxPDFCustomFont), AFontSize);
end;

procedure TdxPDFCommandConstructor.SetTextFont(const AFontName: string; AFontSize: Single);
begin
  WriteNameDelimiter;
  WriteString(AFontName);
  WriteDouble(AFontSize);
  WriteCommand(TdxPDFSetTextFontCommand);
end;

procedure TdxPDFCommandConstructor.SetTextHorizontalScaling(AValue: Single);
begin
  WriteDouble(AValue);
  WriteCommand(TdxPDFSetTextHorizontalScalingCommand);
end;

procedure TdxPDFCommandConstructor.SetTextRenderingMode(AValue: TdxPDFTextRenderingMode);
begin
  WriteSpace;
  WriteString(IntToStr(Integer(AValue)));
  WriteCommand(TdxPDFSetTextRenderingModeCommand);
end;

procedure TdxPDFCommandConstructor.SetWordSpacing(AValue: Single);
begin
  WriteDouble(AValue);
  WriteCommand(TdxPDFSetWordSpacingCommand);
end;

procedure TdxPDFCommandConstructor.ShowText(const AText: TBytes; AGlyphOffsets: TDoubleDynArray);

  procedure WriteGlyphOffset(AOffset: Double);
  begin
    if AOffset <> 0 then
    begin
      WriteSpace;
      WriteDouble(AOffset);
    end;
  end;

var
  ALength, APosition: Integer;
  AStr: TBytes;
begin
  ALength := Length(AText);
  if ALength > 0 then
  begin
    WriteSpace;
    if Length(AGlyphOffsets) = 0 then
    begin
      WriteHexadecimalString(AText);
      WriteCommand(TdxPDFShowTextCommand);
    end
    else
    begin
      WriteOpenBracket;
      APosition := 0;
      while APosition < ALength do
      begin
        WriteGlyphOffset(AGlyphOffsets[APosition]);
        WriteSpace;
        SetLength(AStr, 1);
        AStr[0] := AText[APosition];
        Inc(APosition);
        while (APosition < ALength) and (AGlyphOffsets[APosition] = 0) do
        begin
          TdxPDFUtils.AddByte(AText[APosition], AStr);
          Inc(APosition);
        end;
        WriteHexadecimalString(AStr);
      end;
      WriteGlyphOffset(AGlyphOffsets[Length(AGlyphOffsets) - 1]);
      WriteCloseBracket;
      WriteCommand(TdxPDFShowTextWithGlyphPositioningCommand);
    end;
  end;
end;

procedure TdxPDFCommandConstructor.StartTextLineWithOffsets(X, Y: Single);
begin
  WriteDouble(X);
  WriteDouble(Y);
  WriteCommand(TdxPDFStartTextLineWithOffsetsCommand);
end;

procedure TdxPDFCommandConstructor.StrokePath;
begin
  WriteStrokePathCommand;
end;

procedure TdxPDFCommandConstructor.RestoreGraphicsState;
begin
  if FMatrixStack.Count > 0 then
    CurrentTransformationMatrix := FMatrixStack.Extract;
  WriteCommand(TdxPDFRestoreGraphicsStateCommand);
end;

function TdxPDFCommandConstructor.GetCommands: TBytes;
begin
  Result := (FWriter.Stream as TdxPDFMemoryStream).Data;
end;

procedure TdxPDFCommandConstructor.AppendBezierCurve(const P1, P2, P3: TdxPointF);
begin
  WritePoint(P1);
  WritePoint(P2);
  WritePoint(P3);
  WriteAppendBezierCurveCommand;
end;

procedure TdxPDFCommandConstructor.GeneratePathCommands(APath: TdxPDFGraphicsPath);
var
  ABezierSegment: TdxPDFBezierGraphicsPathSegment;
  ASegment: TdxPDFGraphicsPathSegment;
  I: Integer;
begin
  WritePoint(APath.StartPoint);
  WriteBeginPathCommand;
  for I := 0 to APath.SegmentCount - 1 do
  begin
    ASegment := APath.Segments[I];
    if ASegment is TdxPDFBezierGraphicsPathSegment then
    begin
      ABezierSegment := TdxPDFBezierGraphicsPathSegment(ASegment);
      WritePoint(ABezierSegment.ControlPoint1);
      WritePoint(ABezierSegment.ControlPoint2);
      WritePoint(ABezierSegment.EndPoint);
      WriteAppendBezierCurveCommand;
    end
    else
    begin
      if ASegment is TdxPDFLineGraphicsPathSegment then
      begin
        WritePoint(TdxPDFLineGraphicsPathSegment(ASegment).EndPoint);
        WriteAppendLineSegmentCommand;
      end;
    end;
  end;
  if APath.IsClosed then
    WriteClosePathCommand;
end;

procedure TdxPDFCommandConstructor.SetCurrentTransformationMatrix(const AValue: TdxPDFTransformationMatrix);
begin
  if not FCurrentTransformationMatrix.IsNull then
    FCurrentTransformationMatrix := AValue;
end;

procedure TdxPDFCommandConstructor.WriteAppendBezierCurveCommand;
begin
  WriteCommand(TdxPDFAppendBezierCurveCommand);
end;

procedure TdxPDFCommandConstructor.WriteAppendLineSegmentCommand;
begin
  WriteCommand(TdxPDFAppendLineSegmentCommand);
end;

procedure TdxPDFCommandConstructor.WriteBeginPathCommand;
begin
  WriteCommand(TdxPDFBeginPathCommand);
end;

procedure TdxPDFCommandConstructor.WriteClosePathCommand;
begin
  WriteCommand(TdxPDFClosePathCommand);
end;

procedure TdxPDFCommandConstructor.WriteCloseBracket;
begin
  FWriter.WriteCloseBracket;
end;

procedure TdxPDFCommandConstructor.WriteCommand(const ACommandClass: TdxPDFCustomCommandClass);
begin
  WriteOperationData(ACommandClass.GetName);
end;

procedure TdxPDFCommandConstructor.WriteDouble(AValue: Double);
begin
  FWriter.WriteSpace;
  FWriter.WriteDouble(AValue);
end;

procedure TdxPDFCommandConstructor.WriteIntersectClipCommand(ANonZero: Boolean);
begin
  if ANonZero then
    WriteCommand(TdxPDFModifyClippingPathUsingNonzeroWindingNumberRuleCommand)
  else
    WriteCommand(TdxPDFModifyClippingPathUsingEvenOddRuleCommand);
  WriteCommand(TdxPDFEndPathWithoutFillingAndStrokingCommand);
end;

procedure TdxPDFCommandConstructor.WriteFillPathCommand(ANonZero: Boolean);
begin
  if ANonZero then
    WriteCommand(TdxPDFFillPathUsingNonzeroWindingNumberRuleCommand)
  else
    WriteCommand(TdxPDFFillPathUsingEvenOddRuleCommand);
end;

procedure TdxPDFCommandConstructor.WriteFillAndStrokePathCommand(ANonZero: Boolean);
begin
  if ANonZero then
    WriteCommand(TdxPDFFillAndStrokePathUsingNonzeroWindingNumberRuleCommand)
  else
    WriteCommand(TdxPDFFillAndStrokePathUsingEvenOddRuleCommand);
end;

procedure TdxPDFCommandConstructor.WriteHexadecimalString(const AData: TBytes);
begin
  FWriter.WriteHexadecimalString(AData);
end;

procedure TdxPDFCommandConstructor.WriteNameDelimiter;
begin
  FWriter.WriteByte(Byte('/'));
end;

procedure TdxPDFCommandConstructor.WriteOpenBracket;
begin
  FWriter.WriteOpenBracket;
end;

procedure TdxPDFCommandConstructor.WriteOperationData(const AData: string);
begin
  WriteString(' ' + AData);
end;

procedure TdxPDFCommandConstructor.WritePoint(const P: TdxPointF);
begin
  WriteDouble(P.X);
  WriteDouble(P.Y);
end;

procedure TdxPDFCommandConstructor.WriteSpace;
begin
  FWriter.WriteSpace;
end;

procedure TdxPDFCommandConstructor.WriteString(const S: string);
begin
  FWriter.WriteString(S);
end;

procedure TdxPDFCommandConstructor.WriteStrokePathCommand;
begin
  WriteCommand(TdxPDFStrokePathCommand);
end;

{ TdxPDFXFormCommandConstructor }

constructor TdxPDFXFormCommandConstructor.Create(AForm: TdxPDFXForm);
var
  ABoundingBox: TdxPDFRectangle;
  ACenter: TdxPointF;
  AHalfDimension: Double;
begin
  AForm.EnsureResources;
  inherited Create(AForm.Resources);
  FForm := AForm;
  ABoundingBox := AForm.BBox;
  AHalfDimension := TdxPDFUtils.Min(ABoundingBox.Width, Abs(ABoundingBox.Height)) / 2;
  ACenter.X := (ABoundingBox.Left + ABoundingBox.Right) / 2;
  ACenter.Y := (ABoundingBox.Bottom + ABoundingBox.Top) / 2;
  FContentSquare := TdxPDFRectangle.Create(
    ACenter.X - AHalfDimension, ACenter.Y - AHalfDimension,
    ACenter.X + AHalfDimension, ACenter.Y + AHalfDimension);
end;

function TdxPDFXFormCommandConstructor.GetBoundingBox: TdxPDFRectangle;
begin
  Result := FForm.BBox;
end;

function TdxPDFXFormCommandConstructor.GetCatalog: TdxPDFCatalog;
begin
  Result := TdxPDFObjectAccess(FForm).Repository.Catalog;
end;

end.
