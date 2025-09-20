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

unit dxPDFCommand;

{$I cxVer.inc}

interface

uses
  Types, SysUtils, Classes, Generics.Defaults, Generics.Collections, cxGeometry, dxGDIPlusClasses, dxPDFCore,
  dxPDFParser, dxPDFColorSpace, dxPDFBase, dxPDFTypes, dxPDFStreamFilter;

type

  { TdxPDFCustomNamedCommand }

  TdxPDFCustomNamedCommand = class(TdxPDFCustomCommand)
  protected
    FName: string;
    function GetActualName(const AContext: IdxPDFWriterContext; const AName: string): string; virtual; abstract;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFUnknownCommand }

  TdxPDFUnknownCommand = class(TdxPDFCustomNamedCommand)
  protected
    function GetActualName(const AContext: IdxPDFWriterContext; const AName: string): string; override;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); override;
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFSetTextFontCommand }

  TdxPDFSetTextFontCommand = class(TdxPDFCustomCommand)
  strict private
    FFont: TdxPDFCustomFont;
    FFontSize: Double;
    FFontName: string;

    procedure SetFont(const AValue: TdxPDFCustomFont);
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); override;
    constructor Create(AFont: TdxPDFCustomFont; AFontSize: Single; AResources: TdxPDFResources); overload;
    destructor Destroy; override;

    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;

    property Font: TdxPDFCustomFont read FFont write SetFont;
    property FontName: string read FFontName;
    property FontSize: Double read FFontSize;
  end;

  { TdxPDFBeginTextCommand }

  TdxPDFBeginTextCommand = class(TdxPDFCustomCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFEndTextCommand }

  TdxPDFEndTextCommand = class(TdxPDFCustomCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFShowTextCommand }

  TdxPDFShowTextCommand = class(TdxPDFCustomCommand)
  strict private
    FText: TBytes;
  protected
    property Text: TBytes read FText;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); overload; override;
    constructor Create(AText: TBytes); overload;

    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFShowTextOnNextLineWithSpacingCommand }

  TdxPDFShowTextOnNextLineWithSpacingCommand = class(TdxPDFShowTextCommand)
  strict private
    FCharacterSpacing: Double;
    FWordSpacing: Double;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); override;

    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFShowTextOnNextLineCommand }

  TdxPDFShowTextOnNextLine = class(TdxPDFShowTextCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
  end;

  { TdxPDFShowTextWithGlyphPositioningCommand }

  TdxPDFShowTextWithGlyphPositioningCommand = class(TdxPDFCustomCommand)
  strict private
    FText: TBytes;
    FOffsets: TDoubleDynArray;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); overload; override;
    constructor Create(const AText: TBytes; const AOffsets: TDoubleDynArray); overload;
    destructor Destroy; override;

    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFStartTextLineCommand }

  TdxPDFStartTextLineCommand = class(TdxPDFCustomCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFSetTextLeadingCommand }

  TdxPDFSetTextLeadingCommand = class(TdxPDFCustomCommand)
  strict private
    FLeading: Double;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); override;

    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFSetTextRiseCommand }

  TdxPDFSetTextRiseCommand = class(TdxPDFCustomCommand)
  strict private
    FRise: Double;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); override;

    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFSetTextHorizontalScalingCommand }

  TdxPDFSetTextHorizontalScalingCommand = class(TdxPDFCustomCommand)
  strict private
    FHorizontalScaling: Double;
  public
    constructor Create(AScaling: Double); overload;
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); override;

    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;

    property HorizontalScaling: Double read FHorizontalScaling;
  end;

  { TdxPDFSetCharWidthCommand }

  TdxPDFSetCharWidthCommand = class(TdxPDFCustomCommand)
  strict private
    FWidth: Double;
  protected
    property Width: Double read FWidth;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); override;
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFSetCacheDeviceCommand }

  TdxPDFSetCacheDeviceCommand = class(TdxPDFSetCharWidthCommand)
  strict private
    FBoundingBox: TdxRectF;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); override;

    class function GetName: string; override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;

    property BoundingBox: TdxRectF read FBoundingBox;
  end;

  { TdxPDFStartTextLineWithOffsetsCommand }

  TdxPDFStartTextLineWithOffsetsCommand = class(TdxPDFStartTextLineCommand)
  strict private
    FOffset: TdxPointF;
  protected
    property Offset: TdxPointF read FOffset;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); override;

    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFStartTextLineWithOffsetsAndLeadingCommand }

  TdxPDFStartTextLineWithOffsetsAndLeadingCommand = class(TdxPDFStartTextLineWithOffsetsCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
  end;

  { TdxPDFCustomMatrixCommand }

  TdxPDFCustomMatrixCommand = class(TdxPDFCustomCommand)
  strict private
    FMatrix: TdxPDFTransformationMatrix;
  protected
    property Matrix: TdxPDFTransformationMatrix read FMatrix;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); overload; override;
    constructor Create(const AMatrix: TdxPDFTransformationMatrix); overload;
    constructor Create(M11, M12, M21, M22, DX, DY: Single); overload;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFSetTextMatrixCommand }

  TdxPDFSetTextMatrixCommand = class(TdxPDFCustomMatrixCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
  end;

  { TdxPDFSetTextRenderingModeCommand }

  TdxPDFSetTextRenderingModeCommand = class(TdxPDFCustomCommand)
  strict private
    FMode: TdxPDFTextRenderingMode;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); override;

    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFSetColorCommand }

  TdxPDFSetColorCommand = class(TdxPDFCustomCommand)
  strict private
    FComponents: TDoubleDynArray;
  protected
    FColor: TdxPDFColor;
    procedure WriteData(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); virtual;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override; final;
    //
    property Color: TdxPDFColor read FColor;
  end;

  { TdxPDFSetColorForNonStrokingOperationsCommand }

  TdxPDFSetColorForNonStrokingOperationsCommand = class(TdxPDFSetColorCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
  end;

  { TdxPDFSetColorForStrokingOperationsCommand }

  TdxPDFSetColorForStrokingOperationsCommand = class(TdxPDFSetColorCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
  end;

  { TdxPDFSetColorAdvancedCommand }

  TdxPDFSetColorAdvancedCommand = class(TdxPDFSetColorCommand)
  strict private
    FPatternName: string;
  protected
    procedure WriteData(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); override;
  end;

  { TdxPDFSetColorAdvancedForNonStrokingOperationsCommand }

  TdxPDFSetColorAdvancedForNonStrokingOperationsCommand = class(TdxPDFSetColorAdvancedCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
  end;

  { TdxPDFSetColorAdvancedForStrokingOperationsCommand }

  TdxPDFSetColorAdvancedForStrokingOperationsCommand = class(TdxPDFSetColorAdvancedCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
  end;

  { TdxPDFSetColorSpaceCommand }

  TdxPDFSetColorSpaceCommand = class(TdxPDFCustomNamedCommand)
  strict private
    FColorSpace: TdxPDFCustomColorSpace;
    procedure SetColorSpace(const AValue: TdxPDFCustomColorSpace);
  protected
    function GetActualName(const AContext: IdxPDFWriterContext; const AName: string): string; override;
    property ColorSpace: TdxPDFCustomColorSpace read FColorSpace write SetColorSpace;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); override;
    destructor Destroy; override;
  end;

  { TdxPDFSetColorSpaceForNonStrokingOperationsCommand }

  TdxPDFSetColorSpaceForNonStrokingOperationsCommand = class(TdxPDFSetColorSpaceCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
  end;

  { TdxPDFSetColorSpaceForStrokingOperationsCommand }

  TdxPDFSetColorSpaceForStrokingOperationsCommand = class(TdxPDFSetColorSpaceCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
  end;

  { TdxPDFSetRGBColorSpaceCustomCommand }

  TdxPDFSetRGBColorSpaceCustomCommand = class(TdxPDFSetColorCommand)
  private
    function GetB: Single;
    function GetG: Single;
    function GetR: Single;
  public
    property B: Single read GetB;
    property G: Single read GetG;
    property R: Single read GetR;
  end;

  { TdxPDFSetRGBColorSpaceForStrokingOperationsCommand }

  TdxPDFSetRGBColorSpaceForStrokingOperationsCommand = class(TdxPDFSetRGBColorSpaceCustomCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
  end;

  { TdxPDFSetRGBColorSpaceForNonStrokingOperationsCommand }

  TdxPDFSetRGBColorSpaceForNonStrokingOperationsCommand = class(TdxPDFSetRGBColorSpaceCustomCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
  end;

  { TdxPDFSetCMYKColorSpaceForStrokingOperationsCommand }

  TdxPDFSetCMYKColorSpaceForStrokingOperationsCommand = class(TdxPDFSetColorCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
  end;

  { TdxPDFSetCMYKColorSpaceForNonStrokingOperationsCommand }

  TdxPDFSetCMYKColorSpaceForNonStrokingOperationsCommand = class(TdxPDFSetColorCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
  end;

  { TdxPDFSetGrayColorSpaceCommand }

  TdxPDFSetGrayColorSpaceCommand = class(TdxPDFSetColorCommand)
  strict protected
    FGray: Double;
  protected
    procedure WriteData(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); override;
  end;

  { TdxPDFSetGrayColorSpaceForNonStrokingOperationsCommand }

  TdxPDFSetGrayColorSpaceForNonStrokingOperationsCommand = class(TdxPDFSetGrayColorSpaceCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
  end;

  { TdxPDFSetGrayColorSpaceForStrokingOperationsCommand }

  TdxPDFSetGrayColorSpaceForStrokingOperationsCommand = class(TdxPDFSetGrayColorSpaceCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
  end;

  { TdxPDFSetCharacterSpacingCommand }

  TdxPDFSetCharacterSpacingCommand = class(TdxPDFCustomCommand)
  strict private
    FSpacing: Single;
  public
    constructor Create(ASpacing: Single); overload;
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); override;

    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;

    property Spacing: Single read FSpacing;
  end;

  { TdxPDFSetWordSpacingCommand }

  TdxPDFSetWordSpacingCommand = class(TdxPDFSetCharacterSpacingCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
  end;

  { TdxPDFCustomModifyClippingPathCommand }

  TdxPDFCustomModifyClippingPathCommand = class(TdxPDFCustomCommand)
  protected
    function UseNonzeroWindingRule: Boolean; virtual;
  public
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFModifyClippingPathUsingNonzeroWindingNumberRuleCommand }

  TdxPDFModifyClippingPathUsingNonzeroWindingNumberRuleCommand = class(TdxPDFCustomModifyClippingPathCommand)
  protected
    function UseNonzeroWindingRule: Boolean; override;
  public
    class function GetName: string; override;
  end;

  { TdxPDFModifyClippingPathUsingEvenOddRuleCommand }

  TdxPDFModifyClippingPathUsingEvenOddRuleCommand = class(TdxPDFCustomModifyClippingPathCommand)
  public
    class function GetName: string; override;
  end;

  { TdxPDFCustomPathCommand }

  TdxPDFCustomPathCommand = class(TdxPDFCustomCommand)
  strict private
    FPoint: TdxPointF;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); override;
    constructor Create(const APoint: TdxPointF); reintroduce; overload;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
    //
    property Point: TdxPointF read FPoint write FPoint;
  end;

  { TdxPDFAppendLineSegmentCommand }

  TdxPDFAppendLineSegmentCommand = class(TdxPDFCustomPathCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
  end;

  { TdxPDFBeginPathCommand }

  TdxPDFBeginPathCommand = class(TdxPDFCustomPathCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
  end;

  { TdxPDFClosePathCommand }

  TdxPDFClosePathCommand = class(TdxPDFCustomCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFCustomAppendBezierCurveCommand }

  TdxPDFCustomAppendBezierCurveCommand = class(TdxPDFCustomCommand)
  strict private
    FP1: TdxPointF;
    FP2: TdxPointF;
  protected
    procedure WriteData(AWriter: TdxPDFWriter); virtual;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); override;
    //
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override; final;
    //
    property P1: TdxPointF read FP1;
    property P2: TdxPointF read FP2;
  end;

  { TdxPDFAppendBezierCurveCommand }

  TdxPDFAppendBezierCurveCommand = class(TdxPDFCustomAppendBezierCurveCommand)
  strict private
    FP3: TdxPointF;
  protected
    procedure WriteData(AWriter: TdxPDFWriter); override;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); override;
    class function GetName: string; override;
    //
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    //
    property P3: TdxPointF read FP3;
  end;

  { TdxPDFAppendBezierCurveWithNextControlPointCommand }

  TdxPDFAppendBezierCurveWithNextControlPointCommand = class(TdxPDFCustomAppendBezierCurveCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
  end;

  { TdxPDFAppendBezierCurveWithPreviousControlPointCommand }

  TdxPDFAppendBezierCurveWithPreviousControlPointCommand = class(TdxPDFCustomAppendBezierCurveCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
  end;

  { TdxPDFAppendRectangleCommand }

  TdxPDFAppendRectangleCommand = class(TdxPDFCustomPathCommand)
  strict private
    FSize: TdxSizeF;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); override;
    constructor Create(X, Y, AWidth, AHeight: Single); reintroduce; overload;
    class function GetName: string; override;
    //
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
    //
    property Size: TdxSizeF read FSize;
  end;

  { TdxPDFSetLineCapStyleCommand }

  TdxPDFSetLineCapStyleCommand = class(TdxPDFCustomCommand)
  strict private
    FLineCapStyle: TdxPDFLineCapStyle;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); override;

    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFSetLineJoinStyleCommand }

  TdxPDFSetLineJoinStyleCommand = class(TdxPDFCustomCommand)
  strict private
    FLineJoinStyle: TdxPDFLineJoinStyle;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); override;

    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFSetLineStyleCommand }

  TdxPDFSetLineStyleCommand = class(TdxPDFCustomCommand)
  strict private
    FLineStyle: TdxPDFLineStyle;

    procedure SetLineStyle(const AValue: TdxPDFLineStyle);
  protected
    property LineStyle: TdxPDFLineStyle read FLineStyle write SetLineStyle;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); override;
    destructor Destroy; override;

    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFSetLineWidthCommand }

  TdxPDFSetLineWidthCommand = class(TdxPDFCustomCommand)
  strict private
    FLineWidth: Single;
  protected
    function GetEquals(ACommand: TdxPDFCustomCommand): Boolean; override;
  public
    constructor Create(AWidth: Single); overload;
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); overload; override;
    //
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
    //
    property LineWidth: Single read FLineWidth;
  end;

  { TdxPDFSetFlatnessToleranceCommand }

  TdxPDFSetFlatnessToleranceCommand = class(TdxPDFCustomCommand)
  strict private
    FFlatnessTolerance: Single;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); override;
    //
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFSetRenderingIntentCommand }

  TdxPDFSetRenderingIntentCommand = class(TdxPDFCustomCommand)
  strict private
    FRenderingIntent: TdxPDFRenderingIntent;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); override;

    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFSetMiterLimitCommand }

  TdxPDFSetMiterLimitCommand = class(TdxPDFCustomCommand)
  strict private
    FLimit: Single;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); override;

    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFSetGraphicsStateParametersCommand }

  TdxPDFSetGraphicsStateParametersCommand = class(TdxPDFCustomNamedCommand)
  strict private
    FParameters: TdxPDFGraphicsStateParameters;
    procedure SetParameters(const AValue: TdxPDFGraphicsStateParameters);
  protected
    function GetActualName(const AContext: IdxPDFWriterContext; const AName: string): string; override;
    function GetEquals(ACommand: TdxPDFCustomCommand): Boolean; override;
    property Parameters: TdxPDFGraphicsStateParameters read FParameters write SetParameters;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); overload; override;
    constructor Create(AParameters: TdxPDFGraphicsStateParameters); reintroduce; overload;
    destructor Destroy; override;

    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
  end;

  { TdxPDFSaveGraphicsStateCommand }

  TdxPDFSaveGraphicsStateCommand = class(TdxPDFCustomCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFRestoreGraphicsStateCommand }

  TdxPDFRestoreGraphicsStateCommand = class(TdxPDFCustomCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFModifyTransformationMatrixCommand }

  TdxPDFModifyTransformationMatrixCommand = class(TdxPDFCustomMatrixCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
  end;

  { TdxPDFStrokePathCommand }

  TdxPDFStrokePathCommand = class(TdxPDFCustomCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFCloseFillAndStrokePathUsingEvenOddRuleCommand }

  TdxPDFCloseFillAndStrokePathUsingEvenOddRuleCommand = class(TdxPDFCustomCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFFillAndStrokePathUsingEvenOddRuleCommand }

  TdxPDFFillAndStrokePathUsingEvenOddRuleCommand = class(TdxPDFCustomCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFFillAndStrokePathUsingNonzeroWindingNumberRuleCommand }

  TdxPDFFillAndStrokePathUsingNonzeroWindingNumberRuleCommand = class(TdxPDFCustomCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFFillPathUsingEvenOddRuleCommand }

  TdxPDFFillPathUsingEvenOddRuleCommand = class(TdxPDFCustomCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFFillPathUsingNonzeroWindingNumberRuleCommand }

  TdxPDFFillPathUsingNonzeroWindingNumberRuleCommand = class(TdxPDFCustomCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFCloseFillAndStrokePathUsingNonzeroWindingNumberRuleCommand }

  TdxPDFCloseFillAndStrokePathUsingNonzeroWindingNumberRuleCommand = class(TdxPDFCustomCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFCloseAndStrokePathCommand }

  TdxPDFCloseAndStrokePathCommand = class(TdxPDFCustomCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFEndPathWithoutFillingAndStrokingCommand }

  TdxPDFEndPathWithoutFillingAndStrokingCommand = class(TdxPDFCustomCommand)
  public
    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFPaintXObjectCommand }

  TdxPDFPaintXObjectCommand = class(TdxPDFCustomNamedCommand)
  strict private
    FResources: TdxPDFResources;
    FXObject: TdxPDFXObject;
    procedure SetXObject(const AValue: TdxPDFXObject);
  protected
    function GetActualName(const AContext: IdxPDFWriterContext; const AName: string): string; override;
    //
    property Resources: TdxPDFResources read FResources;
    property XObject: TdxPDFXObject read FXObject write SetXObject;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); override;
    destructor Destroy; override;

    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
  end;

  { TdxPDFPaintImageCommand }

  TdxPDFPaintImageCommand = class(TdxPDFPaintXObjectCommand)
  strict private
    FColorSpaceName: string;
  public
    constructor Create(AImage: TdxPDFDocumentImage; const AColorSpaceName: string);
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  end;

  { TdxPDFPaintShadingPatternCommand }

  TdxPDFPaintShadingPatternCommand = class(TdxPDFCustomNamedCommand)
  strict private
    FShading: TdxPDFCustomShading;
    procedure SetShading(const AValue: TdxPDFCustomShading);
  protected
    function GetActualName(const AContext: IdxPDFWriterContext; const AName: string): string; override;
    //
    property Shading: TdxPDFCustomShading read FShading write SetShading;
  public
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); override;
    destructor Destroy; override;

    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
  end;

  { TdxPDFCommandGroup }

  TdxPDFCommandGroup = class(TdxPDFCustomCommand)
  strict private
    FCommands: TdxPDFCommandList;
  protected
    function GetPrefix(AResources: TdxPDFResources): TStringDynArray; virtual;
    function GetSuffix: string; virtual;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
  public
    constructor Create; override;
    destructor Destroy; override;

    class function GetName: string; override;
    procedure Execute(AInterpreter: IdxPDFCommandInterpreter); override;
    function GetCommandCount: Integer; override;

    property Commands: TdxPDFCommandList read FCommands;
  end;

  { TdxPDFMarkedContentCommand }

  TdxPDFMarkedContentCommand = class(TdxPDFCommandGroup)
  strict private
    FEndToken: string;
    FProperties: TdxPDFCustomProperties;
    FTag: string;

    procedure SetProperties(const AValue: TdxPDFCustomProperties);
  protected
    function GetPrefix(AResources: TdxPDFResources): TStringDynArray; override;
    function GetSuffix: string; override;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); override;
    //
    property Properties: TdxPDFCustomProperties read FProperties write SetProperties;
    property Tag: string read FTag;
  public
    constructor Create(const ATag: string); overload;
    constructor Create(const ATag: string; AProperties: TdxPDFDictionary); overload;
    constructor Create(const ATag, APropertiesName: string; AResources: TdxPDFResources); overload;
    destructor Destroy; override;

    class function GetName: string; override;
  end;

  { TdxPDFCommandName }

  TdxPDFCommandName = class(TdxPDFBase) // for internal use
  strict private
    FName: string;
  protected
    class function GetObjectType: TdxPDFBaseType; override;
  public
    constructor Create(const AName: string);

    property Name: string read FName;
  end;

  { TdxPDFCommandStreamParser }

  TdxPDFCommandStreamParser = class(TdxPDFStructureParser)
  strict private
    FOperands: TdxPDFCommandOperandStack;
    FResources: TdxPDFResources;

    function CalculateInlineImageDataSize(AColorSpace: TdxPDFCustomColorSpace; AFilters: TdxPDFStreamFilters;
      const ASize: TSize; ABitsPerComponent: Integer): Int64;
    function CreatePaintImageCommand(ADictionary: TdxPDFDictionary): TdxPDFPaintImageCommand;
    function IsCommandNameTermination: Boolean;
    function IsCommandTermination: Boolean;
    function ReadCommand: TdxPDFBase;
    function ReadCommandGroup: TdxPDFBase;
    function ReadCommandName: TdxPDFBase;
    function ReadGroup(out AGroupName: string): TdxPDFCommandGroup;
    function ReadInlineImageBitsPerComponents(ADictionary: TdxPDFDictionary; AHasMask: Boolean): Integer;
    function ReadInlineImageColorSpace(ADictionary: TdxPDFDictionary; out AColorSpaceName: string): TdxPDFCustomColorSpace;
    function ReadInlineImageData(ADictionary: TdxPDFDictionary; AFilters: TdxPDFStreamFilters; ADataSize: Integer): TBytes;
    function ReadInlineImageHasMask(ADictionary: TdxPDFDictionary): Boolean;
    function ReadInteger(ADictionary: TdxPDFDictionary; const AKey, AAlternativeKey: string): Integer;
    function ReadMarkedContentGroup(const ATag: string; AParameterCount: Integer): TdxPDFCommandGroup;
    function ReadMarkedContentGroupWithProperties(ATag: TdxPDFBase; AParameterCount: Integer): TdxPDFCommandGroup;
    function ReadPaintImageCommand: TdxPDFPaintImageCommand;
    procedure ReadCommands(const AExpectedCommandName: string; ACommands: TdxPDFReferencedObjects);
  protected
    function TryReadKnownObject: Boolean; override;
    function ReadCompositeObject(AIsHexStrSeparatedByWhiteSpaces: Boolean = False): TdxPDFBase; override;

    function CreateCommand(const AName: string): TdxPDFCustomCommand; virtual;
    function CreateFilters(ADictionary: TdxPDFDictionary): TdxPDFStreamFilters;
    procedure Read(const AData: TBytes; ACommands: TdxPDFReferencedObjects; AResources: TdxPDFResources); overload;
  public
    //
    class procedure Parse(ARepository: TdxPDFCustomRepository; const AData: TBytes; ACommands: TdxPDFReferencedObjects;
      AResources: TdxPDFResources);
    //
    constructor Create(ARepository: TdxPDFCustomRepository); override;
    destructor Destroy; override;
  end;

function dxPDFCreateCommand(const ACommandName: string; ACommandOperands: TdxPDFCommandOperandStack;
  AResources: TdxPDFResources): TdxPDFCustomCommand;

implementation

uses
  Variants, Math, dxCore, dxGDIPlusAPI, dxStringHelper, dxPDFFont, dxPDFUtils;

const
  dxThisUnitName = 'dxPDFCommand';

type
  TdxPDFCustomCommandAccess = class(TdxPDFCustomCommand);
  TdxPDFCustomPropertiesAccess = class(TdxPDFCustomProperties);
  TdxPDFDocumentImageAccess = class(TdxPDFDocumentImage);
  TdxPDFNumericObjectAccess = class(TdxPDFNumericObject);

  { TdxPDFCommandFactory }

  TdxPDFCommandFactory = class(TdxPDFFactory<TdxPDFCustomCommandClass>)
  public
    function CreateCommand(const ACommandName: string; AOperands: TdxPDFCommandOperandStack;
      AResources: TdxPDFResources): TdxPDFCustomCommand;
    function IsKnownCommand(const ACommandName: string): Boolean;
    procedure RegisterCommand(ACommandClass: TdxPDFCustomCommandClass);
    procedure UnregisterCommand(ACommandClass: TdxPDFCustomCommandClass);
  end;

var
  dxgPDFCommandFactory: TdxPDFCommandFactory;
 
function dxPDFCommandFactory: TdxPDFCommandFactory;
begin
  if dxgPDFCommandFactory = nil then
    dxgPDFCommandFactory := TdxPDFCommandFactory.Create;
  Result := dxgPDFCommandFactory;
end;

function dxPDFCreateCommand(const ACommandName: string; ACommandOperands: TdxPDFCommandOperandStack;
  AResources: TdxPDFResources): TdxPDFCustomCommand;
begin
  Result := dxPDFCommandFactory.CreateCommand(ACommandName, ACommandOperands, AResources);
end;

{ TdxPDFCommandFactory }

function TdxPDFCommandFactory.CreateCommand(const ACommandName: string; AOperands: TdxPDFCommandOperandStack;
  AResources: TdxPDFResources): TdxPDFCustomCommand;
var
  ACommandClass: TdxPDFCustomCommandClass;
begin
  if ACommandName = '' then
    Exit(nil);
  if not TryGetClass(ACommandName, ACommandClass) then
  begin
    ACommandClass := TdxPDFUnknownCommand;
    AOperands.Push(TdxPDFString.Create(ACommandName));
  end;
  Result := ACommandClass.Create(AOperands, AResources);
end;

function TdxPDFCommandFactory.IsKnownCommand(const ACommandName: string): Boolean;
begin
  Result := ContainsKey(ACommandName);
end;

procedure TdxPDFCommandFactory.RegisterCommand(ACommandClass: TdxPDFCustomCommandClass);
begin
  Register(ACommandClass.GetName, ACommandClass);
end;

procedure TdxPDFCommandFactory.UnregisterCommand(ACommandClass: TdxPDFCustomCommandClass);
begin
  UnregisterClass(ACommandClass.GetName);
end;

{ TdxPDFCustomNamedCommand }

constructor TdxPDFCustomNamedCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
begin
  inherited Create(AOperands, AResources);
  FName := AOperands.PopAsString;
end;

procedure TdxPDFCustomNamedCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  AWriter.WriteSpace;
  AWriter.WriteName(GetActualName(AContext, FName));
  WriteCommandName(AWriter);
end;

{ TdxPDFUnknownCommand }

constructor TdxPDFUnknownCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
begin
  inherited Create(AOperands, AResources);
  AOperands.Clear;
end;

class function TdxPDFUnknownCommand.GetName: string;
begin
  Result := '';
end;

procedure TdxPDFUnknownCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.UnknownCommand(FName);
end;

procedure TdxPDFUnknownCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  // do nothing
end;

function TdxPDFUnknownCommand.GetActualName(const AContext: IdxPDFWriterContext; const AName: string): string;
begin
  Result := AName;
end;

{ TdxPDFSetTextFontCommand }

constructor TdxPDFSetTextFontCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
var
  AFontSize: Single;
begin
  AFontSize := AOperands.PopAsSingle;
  FFontName := AOperands.PopAsString;
  Create(AResources.GetFont(FFontName), AFontSize, AResources);
end;

constructor TdxPDFSetTextFontCommand.Create(AFont: TdxPDFCustomFont; AFontSize: Single; AResources: TdxPDFResources);
begin
  inherited Create;
  FFontSize := AFontSize;
  if (AFont <> nil) and (AFont.BaseFont <> '') and (FFontName = '') then
    FFontName := AFont.BaseFont;
  Font := AFont;
end;

destructor TdxPDFSetTextFontCommand.Destroy;
begin
  Font := nil;
  inherited Destroy;
end;

class function TdxPDFSetTextFontCommand.GetName: string;
begin
  Result := 'Tf';
end;

procedure TdxPDFSetTextFontCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  if Font <> nil then
    AInterpreter.SetTextFont(Font, FFontSize);
end;

procedure TdxPDFSetTextFontCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  AWriter.WriteSpace;
  AWriter.WriteName(AContext.FindFontName(FFontName));
  WriteUnaryCommand(AWriter, FFontSize);
end;

procedure TdxPDFSetTextFontCommand.SetFont(const AValue: TdxPDFCustomFont);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FFont));
end;

{ TdxPDFBeginTextCommand }

class function TdxPDFBeginTextCommand.GetName: string;
begin
  Result := 'BT';
end;

procedure TdxPDFBeginTextCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.BeginText;
end;

procedure TdxPDFBeginTextCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources);
begin
  AWriter.WriteSpace;
  AWriter.WriteString(GetName);
end;

{ TdxPDFEndTextCommand }

class function TdxPDFEndTextCommand.GetName: string;
begin
  Result := 'ET';
end;

procedure TdxPDFEndTextCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.EndText;
end;

procedure TdxPDFEndTextCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  AWriter.WriteSpace;
  AWriter.WriteString(GetName);
end;

{ TdxPDFShowTextWithGlyphPositioningCommand }

constructor TdxPDFShowTextWithGlyphPositioningCommand.Create(
  AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
var
  AArray: TdxPDFArray;
  AOffset: Double;
  AString: TdxPDFString;
  I, K: Integer;
begin
  inherited Create;
  SetLength(FOffsets, 0);
  AArray := AOperands.PopAsArray;
  try
    if AArray <> nil then
    begin
      AOffset := 0;
      for I := 0 to AArray.Count - 1 do
      begin
        case AArray[I].ObjectType of
          otInteger, otDouble:
            AOffset := AOffset + TdxPDFNumericObjectAccess(AArray[I]).InternalValue;

          otString:
            begin
              AString := TdxPDFString(AArray[I]);
              if AString.Value <> '' then
              begin
                TdxPDFUtils.AddData(TdxPDFUtils.StrToByteArray(AString.Value), FText);
                TdxPDFUtils.AddValue(AOffset, FOffsets);
                for K := 1 to Length(AString.Value) - 1 do
                  TdxPDFUtils.AddValue(0, FOffsets);
              end;
              AOffset := 0;
            end;
        end;
      end;
      TdxPDFUtils.AddValue(AOffset, FOffsets);
    end;
  finally
    dxPDFFreeObject(AArray);
  end;
end;

constructor TdxPDFShowTextWithGlyphPositioningCommand.Create(const AText: TBytes; const AOffsets: TDoubleDynArray);
begin
  inherited Create;
  FText := AText;
  TdxPDFUtils.AddData(AOffsets, FOffsets);
end;

destructor TdxPDFShowTextWithGlyphPositioningCommand.Destroy;
begin
  SetLength(FText, 0);
  inherited Destroy;
end;

class function TdxPDFShowTextWithGlyphPositioningCommand.GetName: string;
begin
  Result := 'TJ';
end;

procedure TdxPDFShowTextWithGlyphPositioningCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.DrawString(FText, FOffsets);
end;

procedure TdxPDFShowTextWithGlyphPositioningCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);

  procedure WriteOffset(AValue: Single);
  begin
    if AValue <> 0 then
      AWriter.WriteDouble(AValue);
  end;

  procedure WriteTextPart(const AText: TBytes);
  begin
    AWriter.WriteHexadecimalString(AText);
  end;

  function GetTextPart(var APosition, ALength: Integer): TBytes;
  begin
    SetLength(Result, 0);
    repeat
      TdxPDFUtils.AddByte(FText[APosition], Result);
      Inc(APosition);
      if APosition = ALength then
        Break;
      if FOffsets[APosition] <> 0 then
        Break;
    until False;
  end;

var
  ALength: Integer;
  APosition: Integer;
begin
  AWriter.WriteSpace;
  AWriter.WriteOpenBracket;
  try
    APosition := 0;

    ALength := Length(FText);
    while APosition < ALength do
    begin
      WriteOffset(FOffsets[APosition]);
      WriteTextPart(GetTextPart(APosition, ALength));
    end;

    if APosition < Length(FOffsets) then
      WriteOffset(FOffsets[APosition]);
  finally
    AWriter.WriteCloseBracket;
  end;
  WriteCommandName(AWriter);
end;

{ TdxPDFStartTextLineCommand }

procedure TdxPDFStartTextLineCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.MoveToNextLine;
end;

procedure TdxPDFStartTextLineCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  WriteCommandName(AWriter);
end;

class function TdxPDFStartTextLineCommand.GetName: string;
begin
  Result := 'T*';
end;

{ TdxPDFSetTextLeadingCommand }

constructor TdxPDFSetTextLeadingCommand.Create(AOperands: TdxPDFCommandOperandStack;
  AResources: TdxPDFResources);
begin
  inherited Create;
  FLeading := AOperands.PopAsSingle;
end;

class function TdxPDFSetTextLeadingCommand.GetName: string;
begin
  Result := 'TL';
end;

procedure TdxPDFSetTextLeadingCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetTextLeading(FLeading);
end;

procedure TdxPDFSetTextLeadingCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  WriteUnaryCommand(AWriter, FLeading);
end;

{ TdxPDFSetTextRiseCommand }

constructor TdxPDFSetTextRiseCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
begin
  inherited Create;
  FRise := AOperands.PopAsSingle;
end;

class function TdxPDFSetTextRiseCommand.GetName: string;
begin
  Result := 'Ts';
end;

procedure TdxPDFSetTextRiseCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetTextRise(FRise);
end;

procedure TdxPDFSetTextRiseCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  WriteUnaryCommand(AWriter, FRise);
end;

{ TdxPDFSetTextHorizontalScalingCommand }

constructor TdxPDFSetTextHorizontalScalingCommand.Create(AScaling: Double);
begin
  inherited Create;
  FHorizontalScaling := AScaling;
end;

constructor TdxPDFSetTextHorizontalScalingCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
begin
  inherited Create(AOperands, AResources);
  FHorizontalScaling := AOperands.PopAsSingle;
end;

procedure TdxPDFSetTextHorizontalScalingCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetTextHorizontalScaling(FHorizontalScaling);
end;

procedure TdxPDFSetTextHorizontalScalingCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  WriteUnaryCommand(AWriter, FHorizontalScaling);
end;

class function TdxPDFSetTextHorizontalScalingCommand.GetName: string;
begin
  Result := 'Tz';
end;

{ TdxPDFSetCharWidthCommand }

constructor TdxPDFSetCharWidthCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
begin
  inherited Create(AOperands, AResources);
  AOperands.PopAsSingle;
  FWidth := AOperands.PopAsSingle;
end;

class function TdxPDFSetCharWidthCommand.GetName: string;
begin
  Result := 'd0';
end;

procedure TdxPDFSetCharWidthCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
// do nothing
end;

procedure TdxPDFSetCharWidthCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  WriteOperand(AWriter, FWidth);
  WriteOperand(AWriter, 0);
  WriteCommandName(AWriter);
end;

{ TdxPDFSetCacheDeviceCommand }

constructor TdxPDFSetCacheDeviceCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
begin
  FBoundingBox.Top := AOperands.PopAsSingle;
  FBoundingBox.Right := AOperands.PopAsSingle;
  FBoundingBox.Bottom := AOperands.PopAsSingle;
  FBoundingBox.Left := AOperands.PopAsSingle;
  inherited Create(AOperands, AResources);
end;

class function TdxPDFSetCacheDeviceCommand.GetName: string;
begin
  Result := 'd1';
end;

procedure TdxPDFSetCacheDeviceCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  WriteOperand(AWriter, Width);
  WriteOperand(AWriter, 0);
  WriteOperand(AWriter, BoundingBox.Left);
  WriteOperand(AWriter, BoundingBox.Bottom);
  WriteOperand(AWriter, BoundingBox.Right);
  WriteOperand(AWriter, BoundingBox.Top);
  WriteCommandName(AWriter);
end;

{ TdxPDFStartTextLineWithOffsetsCommand }

constructor TdxPDFStartTextLineWithOffsetsCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
begin
  inherited Create(AOperands, AResources);
  FOffset.Y := AOperands.PopAsSingle;
  FOffset.X := AOperands.PopAsSingle;
end;

procedure TdxPDFStartTextLineWithOffsetsCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetTextMatrix(Offset);
end;

procedure TdxPDFStartTextLineWithOffsetsCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  WriteUnaryCommand(AWriter, FOffset);
end;

class function TdxPDFStartTextLineWithOffsetsCommand.GetName: string;
begin
  Result := 'Td';
end;

{ TdxPDFStartTextLineWithOffsetsAndLeadingCommand }

class function TdxPDFStartTextLineWithOffsetsAndLeadingCommand.GetName: string;
begin
  Result := 'TD';
end;

procedure TdxPDFStartTextLineWithOffsetsAndLeadingCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetTextLeading(-Offset.Y);
  AInterpreter.SetTextMatrix(Offset);
end;

{ TdxPDFCustomMatrixCommand }

constructor TdxPDFCustomMatrixCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
var
  A, B, C, D, E, F: Double;
begin
  inherited Create(AOperands, AResources);
  F := AOperands.PopAsSingle;
  E := AOperands.PopAsSingle;
  D := AOperands.PopAsSingle;
  C := AOperands.PopAsSingle;
  B := AOperands.PopAsSingle;
  A := AOperands.PopAsSingle;
  FMatrix := TdxPDFTransformationMatrix.Create(A, B, C, D, E, F);
end;

constructor TdxPDFCustomMatrixCommand.Create(const AMatrix: TdxPDFTransformationMatrix);
begin
  inherited Create;
  FMatrix := TdxPDFTransformationMatrix.Create(AMatrix);
end;

constructor TdxPDFCustomMatrixCommand.Create(M11, M12, M21, M22, DX, DY: Single);
begin
  inherited Create;
  FMatrix := TdxPDFTransformationMatrix.Create(M11, M12, M21, M22, DX, DY);
end;

procedure TdxPDFCustomMatrixCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  if not Matrix.IsNull then
    Matrix.Write(AWriter);
  WriteCommandName(AWriter);
end;

{ TdxPDFSetTextMatrixCommand }

class function TdxPDFSetTextMatrixCommand.GetName: string;
begin
  Result := 'Tm';
end;

procedure TdxPDFSetTextMatrixCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetTextMatrix(Matrix);
end;

{ TdxPDFSetTextRenderingModeCommand }

constructor TdxPDFSetTextRenderingModeCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
begin
  inherited Create(AOperands, AResources);
  FMode := TdxPDFTextRenderingMode(AOperands.PopAsInteger);
end;

class function TdxPDFSetTextRenderingModeCommand.GetName: string;
begin
  Result := 'Tr';
end;

procedure TdxPDFSetTextRenderingModeCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetTextRenderingMode(FMode);
end;

procedure TdxPDFSetTextRenderingModeCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  WriteUnaryCommand(AWriter, Integer(FMode));
end;

{ TdxPDFShowTextCommand }

constructor TdxPDFShowTextCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
begin
  inherited Create(AOperands, AResources);
  FText := AOperands.PopAsBytes;
  if Length(FText) = 0 then
    FText := nil;
end;

constructor TdxPDFShowTextCommand.Create(AText: TBytes);
begin
  inherited Create;
  FText := AText;
end;

class function TdxPDFShowTextCommand.GetName: string;
begin
  Result := 'Tj';
end;

procedure TdxPDFShowTextCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.DrawString(FText, nil);
end;

procedure TdxPDFShowTextCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  AWriter.WriteSpace;
  AWriter.WriteHexadecimalString(FText);
  WriteCommandName(AWriter);
end;

{ TdxPDFShowTextOnNextLineWithSpacingCommand }

constructor TdxPDFShowTextOnNextLineWithSpacingCommand.Create(AOperands: TdxPDFCommandOperandStack;
  AResources: TdxPDFResources);
begin
  inherited Create(AOperands, AResources);
  FCharacterSpacing := AOperands.PopAsSingle;
  FWordSpacing := AOperands.PopAsSingle;
end;

class function TdxPDFShowTextOnNextLineWithSpacingCommand.GetName: string;
begin
  Result := '"';
end;

procedure TdxPDFShowTextOnNextLineWithSpacingCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetWordSpacing(FWordSpacing);
  AInterpreter.SetCharacterSpacing(FCharacterSpacing);
  AInterpreter.MoveToNextLine;
  AInterpreter.DrawString(Text, nil);
end;

procedure TdxPDFShowTextOnNextLineWithSpacingCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  AWriter.WriteSpace;
  AWriter.WriteDouble(FWordSpacing);
  AWriter.WriteSpace;
  AWriter.WriteDouble(FCharacterSpacing);
  inherited Write(AWriter, AContext, AResources);
end;

{ TdxPDFShowTextOnNextLine }

class function TdxPDFShowTextOnNextLine.GetName: string;
begin
  Result := '''';
end;

procedure TdxPDFShowTextOnNextLine.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.MoveToNextLine;
  AInterpreter.DrawString(Text, nil);
end;

{ TdxPDFSetColorCommand }

constructor TdxPDFSetColorCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
var
  I: Integer;
begin
  inherited Create(AOperands, AResources);
  SetLength(FComponents, AOperands.Count);
  for I := 0 to  AOperands.Count - 1 do
    FComponents[Length(FComponents) - 1 - I] := AOperands.PopAsSingle;
  FColor := TdxPDFColor.Create(FComponents);
end;

procedure TdxPDFSetColorCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  WriteData(AWriter, AContext, AResources);
  WriteCommandName(AWriter);
end;

procedure TdxPDFSetColorCommand.WriteData(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
var
  I: Integer;
begin
  for I := Low(FComponents) to High(FComponents) do
  begin
    AWriter.WriteSpace;
    AWriter.WriteDouble(FComponents[I]);
  end;
end;

{ TdxPDFSetColorForNonStrokingOperationsCommand }

class function TdxPDFSetColorForNonStrokingOperationsCommand.GetName: string;
begin
  Result := 'sc';
end;

procedure TdxPDFSetColorForNonStrokingOperationsCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetColorForNonStrokingOperations(FColor);
end;

{ TdxPDFSetColorForStrokingOperationsCommand }

class function TdxPDFSetColorForStrokingOperationsCommand.GetName: string;
begin
  Result := 'SC';
end;

procedure TdxPDFSetColorForStrokingOperationsCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetColorForStrokingOperations(FColor);
end;

{ TdxPDFSetColorAdvancedCommand }

constructor TdxPDFSetColorAdvancedCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
begin
  FPatternName := AOperands.TryPopLastName;
  inherited Create(AOperands, AResources);
  if FPatternName <> '' then
    FColor.Pattern := AResources.GetPattern(FPatternName);
end;

procedure TdxPDFSetColorAdvancedCommand.WriteData(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  inherited WriteData(AWriter, AContext, AResources);
  if FPatternName <> '' then
  begin
    AWriter.WriteSpace;
    AWriter.WriteName(AContext.FindPatternName(FPatternName));
  end;
end;

{ TdxPDFSetColorAdvancedForNonStrokingOperationsCommand }

class function TdxPDFSetColorAdvancedForNonStrokingOperationsCommand.GetName: string;
begin
  Result := 'scn';
end;

procedure TdxPDFSetColorAdvancedForNonStrokingOperationsCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetColorForNonStrokingOperations(FColor);
end;

{ TdxPDFSetColorAdvancedForStrokingOperationsCommand }

class function TdxPDFSetColorAdvancedForStrokingOperationsCommand.GetName: string;
begin
  Result := 'SCN';
end;

procedure TdxPDFSetColorAdvancedForStrokingOperationsCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetColorForStrokingOperations(FColor);
end;

{ TdxPDFSetColorSpaceCommand }

constructor TdxPDFSetColorSpaceCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
begin
  inherited Create(AOperands, AResources);
  ColorSpace := AResources.GetColorSpace(FName);
end;

destructor TdxPDFSetColorSpaceCommand.Destroy;
begin
  ColorSpace := nil;
  inherited Destroy;
end;

procedure TdxPDFSetColorSpaceCommand.SetColorSpace(const AValue: TdxPDFCustomColorSpace);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FColorSpace));
end;

function TdxPDFSetColorSpaceCommand.GetActualName(const AContext: IdxPDFWriterContext; const AName: string): string;
begin
  Result := AContext.FindColorSpaceName(AName);
end;

{ TdxPDFSetColorSpaceForNonStrokingOperationsCommand }

class function TdxPDFSetColorSpaceForNonStrokingOperationsCommand.GetName: string;
begin
  Result := 'cs';
end;

procedure TdxPDFSetColorSpaceForNonStrokingOperationsCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetColorSpaceForNonStrokingOperations(ColorSpace);
end;

{ TdxPDFSetColorSpaceForStrokingOperationsCommand }

class function TdxPDFSetColorSpaceForStrokingOperationsCommand.GetName: string;
begin
  Result := 'CS';
end;

procedure TdxPDFSetColorSpaceForStrokingOperationsCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetColorSpaceForStrokingOperations(ColorSpace);
end;

{ TdxPDFSetRGBColorSpaceCustomCommand }

function TdxPDFSetRGBColorSpaceCustomCommand.GetB: Single;
begin
  Result := FColor.Components[2];
end;

function TdxPDFSetRGBColorSpaceCustomCommand.GetG: Single;
begin
  Result := FColor.Components[1];
end;

function TdxPDFSetRGBColorSpaceCustomCommand.GetR: Single;
begin
  Result := FColor.Components[0];
end;

{ TdxPDFSetRGBColorSpaceForStrokingOperationsCommand }

class function TdxPDFSetRGBColorSpaceForStrokingOperationsCommand.GetName: string;
begin
  Result := 'RG';
end;

procedure TdxPDFSetRGBColorSpaceForStrokingOperationsCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetColorSpaceForStrokingOperations(TdxPDFRGBDeviceColorSpace.Create);
  AInterpreter.SetColorForStrokingOperations(FColor);
end;

{ TdxPDFSetRGBColorSpaceForNonStrokingOperationsCommand }

procedure TdxPDFSetRGBColorSpaceForNonStrokingOperationsCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetColorSpaceForNonStrokingOperations(TdxPDFRGBDeviceColorSpace.Create);
  AInterpreter.SetColorForNonStrokingOperations(FColor);
end;

class function TdxPDFSetRGBColorSpaceForNonStrokingOperationsCommand.GetName: string;
begin
  Result := 'rg';
end;

{ TdxPDFSetCMYKColorSpaceForNonStrokingOperationsCommand }

procedure TdxPDFSetCMYKColorSpaceForNonStrokingOperationsCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetColorSpaceForNonStrokingOperations(TdxPDFCMYKDeviceColorSpace.Create);
  AInterpreter.SetColorForNonStrokingOperations(FColor);
end;

class function TdxPDFSetCMYKColorSpaceForNonStrokingOperationsCommand.GetName: string;
begin
  Result := 'k';
end;

{ TdxPDFSetCMYKColorSpaceForStrokingOperationsCommand }

procedure TdxPDFSetCMYKColorSpaceForStrokingOperationsCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetColorSpaceForStrokingOperations(TdxPDFCMYKDeviceColorSpace.Create);
  AInterpreter.SetColorForStrokingOperations(FColor);
end;

class function TdxPDFSetCMYKColorSpaceForStrokingOperationsCommand.GetName: string;
begin
  Result := 'K';
end;

{ TdxPDFSetGrayColorSpaceCommand }

constructor TdxPDFSetGrayColorSpaceCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
var
  AComponents: TDoubleDynArray;
begin
  inherited Create;
  FGray := AOperands.PopAsSingle;
  if (FGray > 1) and (FGray < 0) then
    FGray := Min(Max(FGray, 0), 1);
  SetLength(AComponents, 1);
  AComponents[0] := FGray;
  FColor := TdxPDFColor.Create(AComponents);
end;

procedure TdxPDFSetGrayColorSpaceCommand.WriteData(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  WriteOperand(AWriter, FGray);
end;

{ TdxPDFSetGrayColorSpaceForNonStrokingOperationsCommand }

class function TdxPDFSetGrayColorSpaceForNonStrokingOperationsCommand.GetName: string;
begin
  Result := 'g';
end;

procedure TdxPDFSetGrayColorSpaceForNonStrokingOperationsCommand.Execute(
  AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetColorSpaceForNonStrokingOperations(TdxPDFGrayDeviceColorSpace.Create);
  AInterpreter.SetColorForNonStrokingOperations(FColor);
end;

{ TdxPDFSetGrayColorSpaceForStrokingOperationsCommand }

class function TdxPDFSetGrayColorSpaceForStrokingOperationsCommand.GetName: string;
begin
  Result := 'G';
end;

procedure TdxPDFSetGrayColorSpaceForStrokingOperationsCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetColorSpaceForStrokingOperations(TdxPDFGrayDeviceColorSpace.Create);
	AInterpreter.SetColorForStrokingOperations(FColor);
end;

{ TdxPDFSetCharacterSpacingCommand }

constructor TdxPDFSetCharacterSpacingCommand.Create(ASpacing: Single);
begin
  inherited Create;
  FSpacing := ASpacing;
end;

constructor TdxPDFSetCharacterSpacingCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
begin
  inherited Create(AOperands, AResources);
  FSpacing := AOperands.PopAsSingle;
end;

class function TdxPDFSetCharacterSpacingCommand.GetName: string;
begin
  Result := 'Tc';
end;

procedure TdxPDFSetCharacterSpacingCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetCharacterSpacing(FSpacing);
end;

procedure TdxPDFSetCharacterSpacingCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  WriteUnaryCommand(AWriter, Spacing);
end;

{ TdxPDFSetWordSpacingCommand }

class function TdxPDFSetWordSpacingCommand.GetName: string;
begin
  Result := 'Tw';
end;

procedure TdxPDFSetWordSpacingCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetWordSpacing(Spacing);
end;

{ TdxPDFCustomModifyClippingPathCommand }

procedure TdxPDFCustomModifyClippingPathCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.Clip(UseNonzeroWindingRule);
end;

procedure TdxPDFCustomModifyClippingPathCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  WriteCommandName(AWriter);
end;

function TdxPDFCustomModifyClippingPathCommand.UseNonzeroWindingRule: Boolean;
begin
  Result := False;
end;

{ TdxPDFModifyClippingPathUsingNonzeroWindingNumberRuleCommand }

class function TdxPDFModifyClippingPathUsingNonzeroWindingNumberRuleCommand.GetName: string;
begin
  Result := 'W';
end;

function TdxPDFModifyClippingPathUsingNonzeroWindingNumberRuleCommand.UseNonzeroWindingRule: Boolean;
begin
  Result := True;
end;

{ TdxPDFModifyClippingPathUsingEvenOddRuleCommand }

class function TdxPDFModifyClippingPathUsingEvenOddRuleCommand.GetName: string;
begin
  Result := 'W*';
end;

{ TdxPDFCustomPathCommand }

constructor TdxPDFCustomPathCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
begin
  inherited Create(AOperands, AResources);
  FPoint.Y := AOperands.PopAsSingle;
  FPoint.X := AOperands.PopAsSingle;
end;

constructor TdxPDFCustomPathCommand.Create(const APoint: TdxPointF);
begin
  inherited Create;
  FPoint := APoint;
end;

procedure TdxPDFCustomPathCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  WriteUnaryCommand(AWriter, Point);
end;

{ TdxPDFAppendLineSegmentCommand }

class function TdxPDFAppendLineSegmentCommand.GetName: string;
begin
  Result := 'l';
end;

procedure TdxPDFAppendLineSegmentCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.AppendPathLineSegment(Point);
end;

{ TdxPDFBeginPathCommand }

class function TdxPDFBeginPathCommand.GetName: string;
begin
  Result := 'm';
end;

procedure TdxPDFBeginPathCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.BeginPath(Point);
end;

{ TdxPDFClosePathCommand }

class function TdxPDFClosePathCommand.GetName: string;
begin
  Result := 'h';
end;

procedure TdxPDFClosePathCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.ClosePath;
end;

procedure TdxPDFClosePathCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  WriteCommandName(AWriter);
end;

{ TdxPDFCustomAppendBezierCurveCommand }

constructor TdxPDFCustomAppendBezierCurveCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
begin
  inherited Create;
  FP2.Y := AOperands.PopAsSingle;
  FP2.X := AOperands.PopAsSingle;
  FP1.Y := AOperands.PopAsSingle;
  FP1.X := AOperands.PopAsSingle;
end;

procedure TdxPDFCustomAppendBezierCurveCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  WriteData(AWriter);
  WriteCommandName(AWriter);
end;

procedure TdxPDFCustomAppendBezierCurveCommand.WriteData(AWriter: TdxPDFWriter);
begin
  WriteOperand(AWriter, P1);
  WriteOperand(AWriter, P2);
end;

{ TdxPDFAppendBezierCurveCommand }

constructor TdxPDFAppendBezierCurveCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
begin
  FP3.Y := AOperands.PopAsSingle;
  FP3.X := AOperands.PopAsSingle;
  inherited Create(AOperands, AResources);
end;

procedure TdxPDFAppendBezierCurveCommand.WriteData(AWriter: TdxPDFWriter);
begin
  inherited WriteData(AWriter);
  WriteOperand(AWriter, P3);
end;

class function TdxPDFAppendBezierCurveCommand.GetName: string;
begin
  Result := 'c';
end;

procedure TdxPDFAppendBezierCurveCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.AppendPathBezierSegment(P1, P2, P3);
end;

{ TdxPDFAppendBezierCurveWithNextControlPointCommand }

class function TdxPDFAppendBezierCurveWithNextControlPointCommand.GetName: string;
begin
  Result := 'y';
end;

procedure TdxPDFAppendBezierCurveWithNextControlPointCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.AppendPathBezierSegment(P1, P2, P2);
end;

{ TdxPDFAppendBezierCurveWithPreviousControlPointCommand }

class function TdxPDFAppendBezierCurveWithPreviousControlPointCommand.GetName: string;
begin
  Result := 'v';
end;

procedure TdxPDFAppendBezierCurveWithPreviousControlPointCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.AppendPathBezierSegment(P1, P2);
end;

{ TdxPDFAppendRectangleCommand }

constructor TdxPDFAppendRectangleCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
begin
  FSize.cy := AOperands.PopAsSingle;
  FSize.cx := AOperands.PopAsSingle;
  inherited Create(AOperands, AResources);
end;

constructor TdxPDFAppendRectangleCommand.Create(X, Y, AWidth, AHeight: Single);
begin
  inherited Create;
  FSize.cy := AHeight;
  FSize.cx := AWidth;
  Point := dxPointF(X, Y);
end;

class function TdxPDFAppendRectangleCommand.GetName: string;
begin
  Result := 're';
end;

procedure TdxPDFAppendRectangleCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.AppendRectangle(Point.X, Point.Y, FSize.cx, FSize.cy);
end;

procedure TdxPDFAppendRectangleCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  WriteOperand(AWriter, Point.X);
  WriteOperand(AWriter, Point.Y);
  WriteOperand(AWriter, FSize);
  WriteCommandName(AWriter);
end;

{ TdxPDFSetLineCapStyleCommand }

constructor TdxPDFSetLineCapStyleCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
begin
  inherited Create(AOperands, AResources);
  FLineCapStyle := TdxPDFLineCapStyle(AOperands.PopAsInteger);
end;

class function TdxPDFSetLineCapStyleCommand.GetName: string;
begin
  Result := 'J';
end;

procedure TdxPDFSetLineCapStyleCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetLineCapStyle(FLineCapStyle);
end;

procedure TdxPDFSetLineCapStyleCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  WriteUnaryCommand(AWriter, Integer(FLineCapStyle));
end;

{ TdxPDFSetLineJoinStyleCommand }

constructor TdxPDFSetLineJoinStyleCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
begin
  inherited Create(AOperands, AResources);
  FLineJoinStyle := TdxPDFLineJoinStyle(AOperands.PopAsInteger);
end;

class function TdxPDFSetLineJoinStyleCommand.GetName: string;
begin
  Result := 'j';
end;

procedure TdxPDFSetLineJoinStyleCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetLineJoinStyle(FLineJoinStyle);
end;

procedure TdxPDFSetLineJoinStyleCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  WriteUnaryCommand(AWriter, Integer(FLineJoinStyle));
end;

{ TdxPDFSetLineStyleCommand }

constructor TdxPDFSetLineStyleCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
var
  ADash, APhase: TdxPDFReferencedObject;
begin
  inherited Create;
  APhase := AOperands.PopAsObject;
  ADash := AOperands.PopAsObject;
  try
    LineStyle := TdxPDFLineStyle.Create(ADash, APhase);
  finally
    ADash.Free;
    APhase.Free;
  end;
end;

destructor TdxPDFSetLineStyleCommand.Destroy;
begin
  LineStyle := nil;
  inherited Destroy;
end;

class function TdxPDFSetLineStyleCommand.GetName: string;
begin
  Result := 'd';
end;

procedure TdxPDFSetLineStyleCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetLineStyle(LineStyle);
end;

procedure TdxPDFSetLineStyleCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
var
  I: Integer;
begin
  if LineStyle <> nil then
  begin
    AWriter.WriteSpace;
    AWriter.WriteOpenBracket;
    for I := Low(LineStyle.Pattern) to High(LineStyle.Pattern) do
      WriteOperand(AWriter, LineStyle.Pattern[I]);
    AWriter.WriteCloseBracket;
    WriteOperand(AWriter, LineStyle.Phase);
    WriteCommandName(AWriter);
  end;
end;

procedure TdxPDFSetLineStyleCommand.SetLineStyle(const AValue: TdxPDFLineStyle);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FLineStyle));
end;

{ TdxPDFSetLineWidthCommand }

constructor TdxPDFSetLineWidthCommand.Create(AWidth: Single);
begin
  FLineWidth := AWidth;
end;

constructor TdxPDFSetLineWidthCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
begin
  inherited Create(AOperands, AResources);
  Create(AOperands.PopAsSingle);
end;

class function TdxPDFSetLineWidthCommand.GetName: string;
begin
  Result := 'w';
end;

procedure TdxPDFSetLineWidthCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetLineWidth(FLineWidth);
end;

procedure TdxPDFSetLineWidthCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  WriteUnaryCommand(AWriter, FLineWidth);
end;

function TdxPDFSetLineWidthCommand.GetEquals(ACommand: TdxPDFCustomCommand): Boolean;
begin
  Result := TdxPDFSetLineWidthCommand(ACommand).FLineWidth = FLineWidth;
end;

{ TdxPDFSetFlatnessToleranceCommand }

constructor TdxPDFSetFlatnessToleranceCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
begin
  inherited Create(AOperands, AResources);
  FFlatnessTolerance := Min(Max(AOperands.PopAsSingle, 0), 100);
end;

class function TdxPDFSetFlatnessToleranceCommand.GetName: string;
begin
  Result := 'i';
end;

procedure TdxPDFSetFlatnessToleranceCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetFlatnessTolerance(FFlatnessTolerance);
end;

procedure TdxPDFSetFlatnessToleranceCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  WriteUnaryCommand(AWriter, FFlatnessTolerance);
end;

{ TdxPDFSetRenderingIntentCommand }

constructor TdxPDFSetRenderingIntentCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
begin
  inherited Create(AOperands, AResources);
  FRenderingIntent := TdxPDFUtils.ConvertToRenderingIntent(AOperands.PopAsString);
end;

class function TdxPDFSetRenderingIntentCommand.GetName: string;
begin
  Result := 'ri';
end;

procedure TdxPDFSetRenderingIntentCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetRenderingIntent(FRenderingIntent);
end;

procedure TdxPDFSetRenderingIntentCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  AWriter.WriteSpace;
  AWriter.WriteName(TdxPDFUtils.ConvertToStr(FRenderingIntent));
  WriteCommandName(AWriter);
end;

{ TdxPDFSetMiterLimitCommand }

constructor TdxPDFSetMiterLimitCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
begin
  inherited Create;
  FLimit := AOperands.PopAsSingle;
end;

class function TdxPDFSetMiterLimitCommand.GetName: string;
begin
  Result := 'M';
end;

procedure TdxPDFSetMiterLimitCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SetMiterLimit(FLimit);
end;

procedure TdxPDFSetMiterLimitCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  WriteUnaryCommand(AWriter, FLimit);
end;

{ TdxPDFSetGraphicsStateParametersCommand }

constructor TdxPDFSetGraphicsStateParametersCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
begin
  inherited Create(AOperands, AResources);
  Parameters := AResources.GetGraphicsStateParameters(FName);
end;

constructor TdxPDFSetGraphicsStateParametersCommand.Create(AParameters: TdxPDFGraphicsStateParameters);
begin
  inherited Create;
  FName := '';
  Parameters := AParameters;
end;

destructor TdxPDFSetGraphicsStateParametersCommand.Destroy;
begin
  Parameters := nil;
  inherited Destroy;
end;

class function TdxPDFSetGraphicsStateParametersCommand.GetName: string;
begin
  Result := 'gs';
end;

procedure TdxPDFSetGraphicsStateParametersCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  if Parameters <> nil then
    AInterpreter.ApplyGraphicsStateParameters(Parameters);
end;

function TdxPDFSetGraphicsStateParametersCommand.GetActualName(const AContext: IdxPDFWriterContext;
  const AName: string): string;
begin
  Result := AContext.FindGraphicsStateParameters(AName);
end;

function TdxPDFSetGraphicsStateParametersCommand.GetEquals(ACommand: TdxPDFCustomCommand): Boolean;
begin
  Result := FParameters.Equals(TdxPDFSetGraphicsStateParametersCommand(ACommand).FParameters);
end;

procedure TdxPDFSetGraphicsStateParametersCommand.SetParameters(const AValue: TdxPDFGraphicsStateParameters);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FParameters));
end;

{ TdxPDFSaveGraphicsStateCommand }

procedure TdxPDFSaveGraphicsStateCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.SaveGraphicsState;
end;

procedure TdxPDFSaveGraphicsStateCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  WriteCommandName(AWriter);
end;

class function TdxPDFSaveGraphicsStateCommand.GetName: string;
begin
  Result := 'q';
end;

{ TdxPDFRestoreGraphicsStateCommand }

procedure TdxPDFRestoreGraphicsStateCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.RestoreGraphicsState;
end;

procedure TdxPDFRestoreGraphicsStateCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  WriteCommandName(AWriter);
end;

class function TdxPDFRestoreGraphicsStateCommand.GetName: string;
begin
  Result := 'Q';
end;

{ TdxPDFModifyTransformationMatrixCommand }

procedure TdxPDFModifyTransformationMatrixCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.UpdateTransformationMatrix(Matrix);
end;

class function TdxPDFModifyTransformationMatrixCommand.GetName: string;
begin
  Result := 'cm';
end;

{ TdxPDFStrokePathCommand }

class function TdxPDFStrokePathCommand.GetName: string;
begin
  Result := 'S';
end;

procedure TdxPDFStrokePathCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.StrokePaths;
  AInterpreter.ClipAndClearPaths;
end;

procedure TdxPDFStrokePathCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  WriteCommandName(AWriter);
end;

{ TdxPDFFillAndStrokePathUsingEvenOddRuleCommand }

class function TdxPDFFillAndStrokePathUsingEvenOddRuleCommand.GetName: string;
begin
  Result := 'B*';
end;

procedure TdxPDFFillAndStrokePathUsingEvenOddRuleCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  WriteCommandName(AWriter);
end;

procedure TdxPDFFillAndStrokePathUsingEvenOddRuleCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.FillPaths(False);
  AInterpreter.StrokePaths;
  AInterpreter.ClipAndClearPaths;
end;

{ TdxPDFFillAndStrokePathUsingNonzeroWindingNumberRuleCommand }

class function TdxPDFFillAndStrokePathUsingNonzeroWindingNumberRuleCommand.GetName: string;
begin
  Result := 'B';
end;

procedure TdxPDFFillAndStrokePathUsingNonzeroWindingNumberRuleCommand.Write(AWriter: TdxPDFWriter;
  const AContext: IdxPDFWriterContext; AResources: TdxPDFResources);
begin
  WriteCommandName(AWriter);
end;

procedure TdxPDFFillAndStrokePathUsingNonzeroWindingNumberRuleCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.FillPaths(False);
  AInterpreter.StrokePaths;
  AInterpreter.ClipAndClearPaths;
end;

{ TdxPDFFillPathUsingEvenOddRuleCommand }

class function TdxPDFFillPathUsingEvenOddRuleCommand.GetName: string;
begin
  Result := 'f*';
end;

procedure TdxPDFFillPathUsingEvenOddRuleCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  WriteCommandName(AWriter);
end;

procedure TdxPDFFillPathUsingEvenOddRuleCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.FillPaths(False);
  AInterpreter.ClipAndClearPaths;
end;

{ TdxPDFFillPathUsingNonzeroWindingNumberRuleCommand }

class function TdxPDFFillPathUsingNonzeroWindingNumberRuleCommand.GetName: string;
begin
  Result := 'f';
end;

procedure TdxPDFFillPathUsingNonzeroWindingNumberRuleCommand.Write(AWriter: TdxPDFWriter;
  const AContext: IdxPDFWriterContext; AResources: TdxPDFResources);
begin
  WriteCommandName(AWriter);
end;

procedure TdxPDFFillPathUsingNonzeroWindingNumberRuleCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.FillPaths(True);
  AInterpreter.ClipAndClearPaths;
end;

{ TdxPDFCloseFillAndStrokePathUsingEvenOddRuleCommand }

class function TdxPDFCloseFillAndStrokePathUsingEvenOddRuleCommand.GetName: string;
begin
  Result := 'b*';
end;

procedure TdxPDFCloseFillAndStrokePathUsingEvenOddRuleCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.ClosePath;
  AInterpreter.FillPaths(False);
  AInterpreter.StrokePaths;
  AInterpreter.ClipAndClearPaths;
end;

procedure TdxPDFCloseFillAndStrokePathUsingEvenOddRuleCommand.Write(AWriter: TdxPDFWriter;
  const AContext: IdxPDFWriterContext; AResources: TdxPDFResources);
begin
  WriteCommandName(AWriter);
end;

{ TdxPDFCloseFillAndStrokePathUsingNonzeroWindingNumberRuleCommand }

class function TdxPDFCloseFillAndStrokePathUsingNonzeroWindingNumberRuleCommand.GetName: string;
begin
  Result := 'b';
end;

procedure TdxPDFCloseFillAndStrokePathUsingNonzeroWindingNumberRuleCommand.Write(
  AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources);
begin
  WriteCommandName(AWriter);
end;

procedure TdxPDFCloseFillAndStrokePathUsingNonzeroWindingNumberRuleCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.ClosePath;
  AInterpreter.FillPaths(True);
  AInterpreter.StrokePaths;
  AInterpreter.ClipAndClearPaths;
end;

{ TdxPDFCloseAndStrokePathCommand }

class function TdxPDFCloseAndStrokePathCommand.GetName: string;
begin
  Result := 's';
end;

procedure TdxPDFCloseAndStrokePathCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.ClosePath;
  AInterpreter.StrokePaths;
  AInterpreter.ClipAndClearPaths;
end;

procedure TdxPDFCloseAndStrokePathCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  WriteCommandName(AWriter);
end;

{ TdxPDFEndPathWithoutFillingAndStrokingCommand }

class function TdxPDFEndPathWithoutFillingAndStrokingCommand.GetName: string;
begin
  Result := 'n';
end;

procedure TdxPDFEndPathWithoutFillingAndStrokingCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.ClipAndClearPaths;
end;

procedure TdxPDFEndPathWithoutFillingAndStrokingCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  WriteCommandName(AWriter);
end;

{ TdxPDFPaintXObjectCommand }

constructor TdxPDFPaintXObjectCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
begin
  inherited Create(AOperands, AResources);
  FResources := AResources;
  XObject := Resources.GetXObject(FName);
end;

destructor TdxPDFPaintXObjectCommand.Destroy;
begin
  FResources := nil;
  XObject := nil;
  inherited Destroy;
end;

procedure TdxPDFPaintXObjectCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  if XObject <> nil then
    XObject.Draw(AInterpreter)
end;

class function TdxPDFPaintXObjectCommand.GetName: string;
begin
  Result := 'Do';
end;

function TdxPDFPaintXObjectCommand.GetActualName(const AContext: IdxPDFWriterContext; const AName: string): string;
begin
  Result := AContext.FindXObjectName(AName);
end;

procedure TdxPDFPaintXObjectCommand.SetXObject(const AValue: TdxPDFXObject);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FXObject));
end;

{ TdxPDFPaintImageCommand }

constructor TdxPDFPaintImageCommand.Create(AImage: TdxPDFDocumentImage; const AColorSpaceName: string);
begin
  inherited Create;
  XObject := AImage;
  FColorSpaceName := AColorSpaceName;
end;

procedure TdxPDFPaintImageCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  TdxPDFDocumentImageAccess(XObject).WriteAsInline(AWriter, AResources, FColorSpaceName);
end;

{ TdxPDFCommandGroup }

constructor TdxPDFCommandGroup.Create;
begin
  inherited Create;
  FCommands := TdxPDFCommandList.Create;
end;

destructor TdxPDFCommandGroup.Destroy;
begin
  FreeAndNil(FCommands);
  inherited Destroy;
end;

class function TdxPDFCommandGroup.GetName: string;
begin
  Result := 'Command Group'
end;

procedure TdxPDFCommandGroup.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.ExecuteCommand(FCommands);
end;

function TdxPDFCommandGroup.GetCommandCount: Integer;
begin
  Result := Commands.GetCommandCount;
end;

procedure TdxPDFCommandGroup.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
var
  APrefix: string;
  I: Integer;
begin
  for APrefix in GetPrefix(AResources) do
    WriteOperand(AWriter, APrefix);
  for I := 0 to FCommands.Count - 1 do
    TdxPDFCustomCommandAccess(FCommands[I]).Write(AWriter, AContext, AResources);
  WriteOperand(AWriter, GetSuffix);
end;

function TdxPDFCommandGroup.GetPrefix(AResources: TdxPDFResources): TStringDynArray;
begin
  SetLength(Result, 0);
end;

function TdxPDFCommandGroup.GetSuffix: string;
begin
  Result := '';
end;

{ TdxPDFPaintShadingPatternCommand }

constructor TdxPDFPaintShadingPatternCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
begin
  inherited Create(AOperands, AResources);
  Shading := AResources.GetShading(FName);
end;

destructor TdxPDFPaintShadingPatternCommand.Destroy;
begin
  Shading := nil;
  inherited Destroy;
end;

class function TdxPDFPaintShadingPatternCommand.GetName: string;
begin
  Result := 'sh';
end;

procedure TdxPDFPaintShadingPatternCommand.Execute(AInterpreter: IdxPDFCommandInterpreter);
begin
  if Shading <> nil then
    AInterpreter.DrawShading(Shading);
end;

function TdxPDFPaintShadingPatternCommand.GetActualName(const AContext: IdxPDFWriterContext;
  const AName: string): string;
begin
  Result := AContext.FindShadingName(AName);
end;

procedure TdxPDFPaintShadingPatternCommand.SetShading(const AValue: TdxPDFCustomShading);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FShading));
end;

{ TdxPDFMarkedContentCommand }

constructor TdxPDFMarkedContentCommand.Create(const ATag: string);
begin
  inherited Create;
  FEndToken := 'EMC';
  FTag := ATag;
end;

constructor TdxPDFMarkedContentCommand.Create(const ATag: string; AProperties: TdxPDFDictionary);
begin
  Create(ATag);
  Properties := TdxPDFCustomProperties.Create(AProperties);
end;

constructor TdxPDFMarkedContentCommand.Create(const ATag, APropertiesName: string; AResources: TdxPDFResources);
begin
  Create(ATag);
  Properties := AResources.GetProperties(APropertiesName);
end;

destructor TdxPDFMarkedContentCommand.Destroy;
begin
  Properties := nil;
  inherited Destroy;
end;

class function TdxPDFMarkedContentCommand.GetName: string;
begin
  Result := 'Marked Content';
end;

function TdxPDFMarkedContentCommand.GetPrefix(AResources: TdxPDFResources): TStringDynArray;
begin
  SetLength(Result, 1);
  if Properties <> nil then
    Result[0] := 'BDC'
  else
    Result[0] := 'BMC';
end;

function TdxPDFMarkedContentCommand.GetSuffix: string;
begin
  Result := 'EMC';
end;

procedure TdxPDFMarkedContentCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext;
  AResources: TdxPDFResources);
begin
  if (FTag <> '') or (Properties = nil) then
  begin
    AWriter.WriteSpace;
    AWriter.WriteName(FTag);
    AWriter.WriteSpace;
  end;
  if Properties <> nil then
    TdxPDFCustomPropertiesAccess(Properties).Write(AWriter);
  inherited Write(AWriter, AContext, AResources);
end;

procedure TdxPDFMarkedContentCommand.SetProperties(const AValue: TdxPDFCustomProperties);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FProperties));
end;

{ TdxPDFCommandName }

constructor TdxPDFCommandName.Create(const AName: string);
begin
  inherited Create;
  FName := AName;
end;

class function TdxPDFCommandName.GetObjectType: TdxPDFBaseType;
begin
  Result := otCommandName;
end;

{ TdxPDFCommandStreamParser }

class procedure TdxPDFCommandStreamParser.Parse(ARepository: TdxPDFCustomRepository;
  const AData: TBytes; ACommands: TdxPDFReferencedObjects; AResources: TdxPDFResources);
var
  AParser: TdxPDFCommandStreamParser;
begin
  if Length(AData) > 0 then
  begin
    AParser := TdxPDFCommandStreamParser.Create(ARepository);
    try
      AParser.Read(AData, ACommands, AResources);
    finally
      AParser.Free;
    end;
  end;
end;

constructor TdxPDFCommandStreamParser.Create(ARepository: TdxPDFCustomRepository);
begin
  inherited Create(ARepository);
  FOperands := TdxPDFCommandOperandStack.Create;
end;

destructor TdxPDFCommandStreamParser.Destroy;
begin
  FreeAndNil(FOperands);
  inherited Destroy;
end;

function TdxPDFCommandStreamParser.TryReadKnownObject: Boolean;
var
  APosition: Int64;
  AObject: TdxPDFBase;
  ACommandName: TdxPDFCommandName;
begin
  APosition := CurrentPosition;
  try
    AObject := DoReadObject;
    try
      Result := (AObject = nil) or Safe.Cast(AObject, TdxPDFCommandName, ACommandName) and
        dxgPDFCommandFactory.IsKnownCommand(ACommandName.Name) or (AObject is TdxPDFCustomCommand);
    finally
      dxPDFFreeObject(AObject);
    end;
  finally
    CurrentPosition := APosition;
  end;
end;

function TdxPDFCommandStreamParser.ReadCompositeObject(AIsHexStrSeparatedByWhiteSpaces: Boolean = False): TdxPDFBase;
begin
  Result := DoReadDictionaryOrStream;
  if Result = nil then
    Result := ReadCommand;
end;

function TdxPDFCommandStreamParser.CreateCommand(const AName: string): TdxPDFCustomCommand;
begin
  Result := dxPDFCreateCommand(AName, FOperands, FResources);
end;

procedure TdxPDFCommandStreamParser.Read(const AData: TBytes; ACommands: TdxPDFReferencedObjects; AResources: TdxPDFResources);
begin
  Data := AData;
  FResources := AResources;
  try
    ReadCommands('', ACommands);
  except
    FOperands.Clear;
  end;
end;

function TdxPDFCommandStreamParser.CalculateInlineImageDataSize(AColorSpace: TdxPDFCustomColorSpace;
  AFilters: TdxPDFStreamFilters; const ASize: TSize; ABitsPerComponent: Integer): Int64;

  function GetImageDataSize(AComponentCount, ABitsPerComponent: Integer): Integer;
  var
    ADataSize: Integer;
  begin
    Result := ASize.cx * AComponentCount * ABitsPerComponent;
    ADataSize := Result div 8;
    if Result mod 8 > 0 then
      Inc(ADataSize);
    Result := ADataSize;
  end;

var
  AComponentCount: Integer;
begin
  if AFilters.Count = 0 then
  begin
    if AColorSpace = nil then
      AComponentCount := 1
    else
      AComponentCount := AColorSpace.ComponentCount;
    Result := GetImageDataSize(AComponentCount, ABitsPerComponent);
  end
  else
    Result := dxPDFInvalidValue;
end;

function TdxPDFCommandStreamParser.CreatePaintImageCommand(ADictionary: TdxPDFDictionary): TdxPDFPaintImageCommand;
var
  ABitsPerComponent, ADataSize: Integer;
  AColorSpace: TdxPDFCustomColorSpace;
  AColorSpaceName: string;
  AData: TBytes;
  AFilters: TdxPDFStreamFilters;
  AHasMask: Boolean;
  AImage: TdxPDFDocumentImage;
  AImageSize: TSize;
begin
  AImageSize.cx := ADictionary.GetInteger(TdxPDFKeywords.ShortWidths, TdxPDFKeywords.Width);
  AImageSize.cy := ADictionary.GetInteger(TdxPDFKeywords.ShortHeight, TdxPDFKeywords.Height);
  AFilters := CreateFilters(ADictionary);
  AColorSpace := ReadInlineImageColorSpace(ADictionary, AColorSpaceName);
  AHasMask := ReadInlineImageHasMask(ADictionary);
  ABitsPerComponent := ReadInlineImageBitsPerComponents(ADictionary, AHasMask);
  ADataSize := CalculateInlineImageDataSize(AColorSpace, AFilters, AImageSize, ABitsPerComponent);
  AData := ReadInlineImageData(ADictionary, AFilters, ADataSize * AImageSize.cy);
  AImage := TdxPDFDocumentImage.Create(AData, AImageSize, ABitsPerComponent, ADictionary);
  AImage.Filters := AFilters;
  AImage.ColorSpace := AColorSpace;
  AImage.HasMask := AHasMask;

  (ADictionary as TdxPDFReaderDictionary).Repository.ImageDataStorage.Add(AImage);
  Result := TdxPDFPaintImageCommand.Create(AImage, AColorSpaceName);
end;

function TdxPDFCommandStreamParser.CreateFilters(ADictionary: TdxPDFDictionary): TdxPDFStreamFilters;

  function GetStreamFilters(ADictionary: TdxPDFDictionary; const AKey, ADecodeParamsKey: string): TdxPDFStreamFilters;
  var
    I: Integer;
    AFilterList: TdxPDFArray;
    AFilterName: TdxPDFName;
    AFilterParameters: TdxPDFDictionary;
    AParameterArray: TdxPDFArray;
    AValue: TdxPDFBase;
  begin
    Result := nil;
    AValue := ADictionary.GetObject(AKey);
    if AValue <> nil then
    begin
      AValue := Repository.ResolveReference(AValue);
      Result := TdxPDFStreamFilters.Create;
      if AValue.ObjectType <> otArray then
        Result.Add(TdxPDFStreamFilterFactory.Create(TdxPDFName(AValue).Value, ADictionary.GetDictionary(ADecodeParamsKey)))
      else
      begin
        AParameterArray := ADictionary.GetArray(ADecodeParamsKey);
        AFilterList := TdxPDFArray(AValue);

        if (AParameterArray <> nil) and (AFilterList.Count = AParameterArray.Count) then
          for I := 0 to AFilterList.Count - 1 do
          begin
            AFilterName := AFilterList[I] as TdxPDFName;
            if AParameterArray[I].ObjectType <> otNull then
            begin
              AFilterParameters := Repository.ResolveReference(AParameterArray[I]) as TdxPDFDictionary;
              Result.Add(TdxPDFStreamFilterFactory.Create(AFilterName.Value, AFilterParameters));
            end;
          end
        else
          if AFilterList <> nil then
            for I := 0 to AFilterList.Count - 1 do
              Result.Add(TdxPDFStreamFilterFactory.Create((AFilterList[I] as TdxPDFName).Value, nil));
      end;
    end;
  end;

begin
  Result := GetStreamFilters(ADictionary, TdxPDFKeywords.ShortFilter, TdxPDFKeywords.ShortDecodeParameters);
  if Result = nil then
  begin
    Result := GetStreamFilters(ADictionary, TdxPDFKeywords.Filter, TdxPDFKeywords.DecodeParameters);
    if Result = nil then
      Result := TdxPDFStreamFilters.Create;
  end;
end;

function TdxPDFCommandStreamParser.IsCommandNameTermination: Boolean;
begin
  Result := IsWhiteSpace or (Current in [TdxPDFDefinedSymbols.StartObject, TdxPDFDefinedSymbols.StartArray,
    TdxPDFDefinedSymbols.EndArray, TdxPDFDefinedSymbols.StartString, TdxPDFDefinedSymbols.NameIdentifier,
    TdxPDFDefinedSymbols.Comment, TdxPDFDefinedSymbols.EndObject])
end;

function TdxPDFCommandStreamParser.IsCommandTermination: Boolean;
begin
  Result := ReadNext or not IsCommandNameTermination;
  if not Result then
    TdxPDFUtils.Abort;
end;

function TdxPDFCommandStreamParser.ReadCommand: TdxPDFBase;
begin
  if Current = Byte('B') then
  begin
    Result := ReadCommandGroup;
    if Result = nil then
      Result := ReadCommandName;
  end
  else
    Result := ReadCommandName;
end;

function TdxPDFCommandStreamParser.ReadCommandGroup: TdxPDFBase;
var
  AGroup: TdxPDFCommandGroup;
  AGroupName: string;
begin
  Result := nil;
  if ReadNext then
  begin
    case Current of
      Byte('T'):
        if IsCommandTermination then
          Result := TdxPDFBeginTextCommand.Create(FOperands, FResources);
      Byte('M'), Byte('D'), Byte('X'):
        begin
          AGroup := ReadGroup(AGroupName);
          if (AGroup <> nil) and IsCommandTermination then
          begin
            ReadCommands(AGroupName, AGroup.Commands);
            Result := AGroup;
          end;
        end;
      Byte('I'):
        if IsCommandTermination then
          Result := ReadPaintImageCommand;
    else
      if not ReadPrev then
        TdxPDFUtils.Abort;
    end;
  end;
end;

function TdxPDFCommandStreamParser.ReadCommandName: TdxPDFBase;
var
  ACommandName: string;
  ABuilder: TStringBuilder;
begin
  ACommandName := '';
  if IsCommandNameTermination then
    ReadNext
  else
  begin
    ABuilder := TdxStringBuilderManager.Get;
    try
      while not IsCommandNameTermination do
      begin
        ABuilder.Append(Char(Current));
        if not ReadNext then
          Break;
      end;
      ACommandName := ABuilder.ToString;
    finally
      TdxStringBuilderManager.Release(ABuilder);
    end;
  end;
  Result := TdxPDFCommandName.Create(ACommandName);
end;

function TdxPDFCommandStreamParser.ReadGroup(out AGroupName: string): TdxPDFCommandGroup;
var
  AOperandCount: Integer;
  APreviousSymbol: Byte;
begin
  AGroupName := '';
  if Current = Byte('X') then
  begin
    Result := TdxPDFCommandGroup.Create;
    AGroupName := 'EX';
  end
  else
  begin
    Result := nil;
    APreviousSymbol := Current;
    if ReadNext and (Current = Byte('C')) and (FOperands.Count > 0) then
    begin
      AGroupName := 'EMC';
      AOperandCount := FOperands.Count;
      if APreviousSymbol = Byte('D') then
        Result := ReadMarkedContentGroupWithProperties(FOperands.PopAsObject, AOperandCount)
      else
        Result := ReadMarkedContentGroup(FOperands.PopAsString, AOperandCount);
    end
    else
      TdxPDFUtils.Abort;
  end;
end;

function TdxPDFCommandStreamParser.ReadInlineImageBitsPerComponents(ADictionary: TdxPDFDictionary;
  AHasMask: Boolean): Integer;
begin
  if AHasMask then
  begin
    Result := 1;
    if (ADictionary.Contains(TdxPDFKeywords.ShortBitsPerComponent) or ADictionary.Contains(TdxPDFKeywords.BitsPerComponent)) and
      (ReadInteger(ADictionary, TdxPDFKeywords.ShortBitsPerComponent, TdxPDFKeywords.BitsPerComponent) <> Result) then
      TdxPDFUtils.Abort;
  end
  else
    Result := ReadInteger(ADictionary, TdxPDFKeywords.ShortBitsPerComponent, TdxPDFKeywords.BitsPerComponent);
end;

function TdxPDFCommandStreamParser.ReadInlineImageColorSpace(ADictionary: TdxPDFDictionary; out AColorSpaceName: string): TdxPDFCustomColorSpace;
var
  AObject: TdxPDFBase;
  AUsingShortColorSpaceName: Boolean;
begin
  AColorSpaceName := '';
  AUsingShortColorSpaceName := ADictionary.TryGetObject(TdxPDFKeywords.ShortColorSpace, AObject);
  if AUsingShortColorSpaceName or ADictionary.TryGetObject(TdxPDFKeywords.ColorSpace, AObject) then
    begin
      if AUsingShortColorSpaceName and (AObject.ObjectType = otName) then
        AColorSpaceName := TdxPDFName(AObject).Value;
      Result := (Repository as TdxPDFDocumentRepository).CreateColorSpace(AObject, FResources)
    end
  else
    Result := nil;
end;

function TdxPDFCommandStreamParser.ReadInlineImageData(
  ADictionary: TdxPDFDictionary; AFilters: TdxPDFStreamFilters; ADataSize: Integer): TBytes;
var
  AEndImageToken: TdxPDFTokenDescription;
begin
  SetLength(Result, 0);
  AEndImageToken := TdxPDFTokenDescription.Create(TdxPDFUtils.StrToByteArray(TdxPDFKeywords.InlineImageEnd));
  try
    if AFilters.Count = 0 then
      Result := DoReadData(ADataSize, AEndImageToken)
    else
      if ReadNext then
        Result := DoReadData(AEndImageToken, False, AFilters[0].EODToken, False)
  finally
    AEndImageToken.Free;
  end;
end;

function TdxPDFCommandStreamParser.ReadInlineImageHasMask(ADictionary: TdxPDFDictionary): Boolean;
var
  AValue: Boolean;
begin
  if ADictionary.TryGetBoolean(TdxPDFKeywords.ImageMask, AValue) or
    ADictionary.TryGetBoolean(TdxPDFKeywords.ShortImageMask, AValue) then
    Result := AValue
  else
    Result := False;
end;

function TdxPDFCommandStreamParser.ReadInteger(ADictionary: TdxPDFDictionary; const AKey, AAlternativeKey: string): Integer;
begin
  Result := ADictionary.GetInteger(AKey);
  if not TdxPDFUtils.IsIntegerValid(Result) then
  begin
    Result := ADictionary.GetInteger(AAlternativeKey);
    if not TdxPDFUtils.IsIntegerValid(Result) then
      TdxPDFUtils.RaiseTestException('TdxPDFCommandStreamParser.ReadInteger');
  end;
end;

function TdxPDFCommandStreamParser.ReadMarkedContentGroup(const ATag: string; AParameterCount: Integer): TdxPDFCommandGroup;
begin
  if AParameterCount = 1 then
    Result := TdxPDFMarkedContentCommand.Create(ATag)
  else
    Result := nil;
end;

function TdxPDFCommandStreamParser.ReadMarkedContentGroupWithProperties(ATag: TdxPDFBase; AParameterCount: Integer): TdxPDFCommandGroup;
var
  AObject: TdxPDFBase;
begin
  Result := nil;
  if (AParameterCount = 2) and (ATag <> nil) then
  begin
    AObject := FOperands.PopAsObject;
    try
      case ATag.ObjectType of
        otDictionary:
          Result := TdxPDFMarkedContentCommand.Create((AObject as TdxPDFName).Value, ATag as TdxPDFDictionary);
        otName:
          Result := TdxPDFMarkedContentCommand.Create(TdxPDFName(ATag).Value, TdxPDFString(AObject).Value, FResources);
      else
        Result := nil;
      end;
    finally
      dxPDFFreeObject(AObject);
      ATag.Free;
    end;
  end
end;

function TdxPDFCommandStreamParser.ReadPaintImageCommand: TdxPDFPaintImageCommand;

  procedure AddDictionaryValue(ADictionary: TdxPDFDictionary; const AName: string);
  var
    AValue: TdxPDFBase;
  begin
    if SkipSpaces then
    begin
      AValue := DoReadObject;
      if (AName <> '') and (AValue <> nil) then
        ADictionary.Add(AName, AValue)
    end
    else
      TdxPDFUtils.Abort;
  end;

var
  ADictionary: TdxPDFDictionary;
  AIsImageCreated: Boolean;
  AObject: TdxPDFBase;
begin
  Result := nil;
  AIsImageCreated := False;
  ADictionary := CreateDictionary;
  try
    while not AIsImageCreated and SkipSpaces do
    begin
      AObject := DoReadObject;
      case AObject.ObjectType of
        otName:
          AddDictionaryValue(ADictionary, TdxPDFName(AObject).Value);
        otCommandName:
          if TdxPDFCommandName(AObject).Name = TdxPDFKeywords.ID then
          begin
            Result := CreatePaintImageCommand(ADictionary);
            AIsImageCreated := True;
          end;
      end;
      dxPDFFreeObject(AObject);
    end;
  finally
    dxPDFFreeObject(ADictionary);
  end;
end;

procedure TdxPDFCommandStreamParser.ReadCommands(const AExpectedCommandName: string; ACommands: TdxPDFReferencedObjects);
var
  AObject: TdxPDFBase;
  AFinished: Boolean;
  ACommandName: string;
  ACommand: TdxPDFCustomCommand;
begin
  AFinished := False;
  while SkipSpaces and not AFinished do
  begin
    AObject := nil;
    try
      AObject := DoReadObject;
    except
      dxPDFFreeObject(AObject);
      raise;
    end;
    if AObject <> nil then
      case AObject.ObjectType of
        otCommand:
          ACommands.Add(AObject);
        otCommandName:
          begin
            ACommandName := TdxPDFCommandName(AObject).Name;
            if ACommandName <> AExpectedCommandName then
            begin
              ACommand := CreateCommand(ACommandName);
              if ACommand <> nil then
                ACommands.Add(ACommand);
            end
            else
              AFinished := True;
            dxPDFFreeObject(AObject);
          end
      else
        FOperands.Push(AObject);
      end
  end;
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxPDFCommandFactory.RegisterCommand(TdxPDFBeginTextCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFEndTextCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetColorSpaceForStrokingOperationsCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetColorSpaceForNonStrokingOperationsCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetColorAdvancedForStrokingOperationsCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetColorAdvancedForNonStrokingOperationsCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetColorForNonStrokingOperationsCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetColorForStrokingOperationsCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetRGBColorSpaceForStrokingOperationsCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetRGBColorSpaceForNonStrokingOperationsCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetGrayColorSpaceForNonStrokingOperationsCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetGrayColorSpaceForStrokingOperationsCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetCMYKColorSpaceForStrokingOperationsCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetCMYKColorSpaceForNonStrokingOperationsCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetTextFontCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetTextHorizontalScalingCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetTextLeadingCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetTextMatrixCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetTextRenderingModeCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetTextRiseCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFShowTextCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFShowTextOnNextLine);
  dxPDFCommandFactory.RegisterCommand(TdxPDFShowTextWithGlyphPositioningCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFPaintXObjectCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetCharacterSpacingCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetWordSpacingCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFAppendLineSegmentCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetLineCapStyleCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetLineStyleCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetLineWidthCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetLineJoinStyleCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetFlatnessToleranceCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetMiterLimitCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetRenderingIntentCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFStartTextLineCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFStartTextLineWithOffsetsCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFStartTextLineWithOffsetsAndLeadingCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFRestoreGraphicsStateCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSaveGraphicsStateCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFModifyTransformationMatrixCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFEndPathWithoutFillingAndStrokingCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFCloseAndStrokePathCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFCloseFillAndStrokePathUsingEvenOddRuleCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFCloseFillAndStrokePathUsingNonzeroWindingNumberRuleCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFFillAndStrokePathUsingEvenOddRuleCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFFillAndStrokePathUsingNonzeroWindingNumberRuleCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFFillPathUsingEvenOddRuleCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFFillPathUsingNonzeroWindingNumberRuleCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFStrokePathCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFBeginPathCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFClosePathCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFAppendRectangleCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFAppendBezierCurveCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFAppendBezierCurveWithNextControlPointCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFAppendBezierCurveWithPreviousControlPointCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFModifyClippingPathUsingNonzeroWindingNumberRuleCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFModifyClippingPathUsingEvenOddRuleCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetGraphicsStateParametersCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFPaintShadingPatternCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetCharWidthCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFSetCacheDeviceCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFShowTextOnNextLineWithSpacingCommand);
  dxPDFCommandFactory.RegisterCommand(TdxPDFUnknownCommand);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxPDFCommandFactory.UnregisterCommand(TdxPDFUnknownCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFShowTextOnNextLineWithSpacingCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetCacheDeviceCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetCharWidthCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFPaintShadingPatternCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetGraphicsStateParametersCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFModifyClippingPathUsingEvenOddRuleCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFModifyClippingPathUsingNonzeroWindingNumberRuleCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFAppendBezierCurveWithPreviousControlPointCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFAppendBezierCurveWithNextControlPointCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFAppendBezierCurveCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFAppendRectangleCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFClosePathCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFBeginPathCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFStrokePathCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFFillPathUsingNonzeroWindingNumberRuleCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFFillPathUsingEvenOddRuleCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFFillAndStrokePathUsingNonzeroWindingNumberRuleCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFFillAndStrokePathUsingEvenOddRuleCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFCloseFillAndStrokePathUsingNonzeroWindingNumberRuleCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFCloseFillAndStrokePathUsingEvenOddRuleCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFCloseAndStrokePathCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFEndPathWithoutFillingAndStrokingCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFModifyTransformationMatrixCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSaveGraphicsStateCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFRestoreGraphicsStateCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFStartTextLineWithOffsetsAndLeadingCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFStartTextLineWithOffsetsCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFStartTextLineCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetFlatnessToleranceCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetRenderingIntentCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetMiterLimitCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetLineWidthCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetLineJoinStyleCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetLineStyleCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetLineCapStyleCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFAppendLineSegmentCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetWordSpacingCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetCharacterSpacingCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFPaintXObjectCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFShowTextWithGlyphPositioningCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFShowTextOnNextLine);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFShowTextCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetTextRenderingModeCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetTextRiseCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetTextMatrixCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetTextLeadingCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetTextHorizontalScalingCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetTextFontCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetCMYKColorSpaceForNonStrokingOperationsCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetCMYKColorSpaceForStrokingOperationsCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetGrayColorSpaceForStrokingOperationsCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetGrayColorSpaceForNonStrokingOperationsCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetRGBColorSpaceForNonStrokingOperationsCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetRGBColorSpaceForStrokingOperationsCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetColorForStrokingOperationsCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetColorForNonStrokingOperationsCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetColorAdvancedForNonStrokingOperationsCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetColorAdvancedForStrokingOperationsCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetColorSpaceForNonStrokingOperationsCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFSetColorSpaceForStrokingOperationsCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFEndTextCommand);
  dxPDFCommandFactory.UnregisterCommand(TdxPDFBeginTextCommand);
  FreeAndNil(dxgPDFCommandFactory);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
