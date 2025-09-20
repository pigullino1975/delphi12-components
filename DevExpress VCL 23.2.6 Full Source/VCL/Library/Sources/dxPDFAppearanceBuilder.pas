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

unit dxPDFAppearanceBuilder; // for internal use

{$I cxVer.inc}

interface

uses
  Types, SysUtils, Generics.Defaults, Generics.Collections, Graphics, cxGraphics, dxCoreClasses, cxGeometry,
  dxPDFBase, dxPDFTypes, dxPDFCore, dxPDFInteractiveFormField, dxPDFAnnotation, dxPDFFontUtils, dxPDFCommandConstructor,
  dxPDFCommandInterpreter;

type
  { TdxPDFAnnotationAppearanceBuilder }

  TdxPDFAnnotationAppearanceBuilder = class // for internal use
  strict protected
    FAnnotation: TdxPDFCustomAnnotation;
  protected
    function GetFormBBox: TdxPDFRectangle; virtual;
    function GetFormMatrix: TdxPDFTransformationMatrix; virtual;
    procedure CreateSubClasses; virtual;
    procedure DestroySubClasses; virtual;
    procedure Initialize; virtual;
    procedure Rebuild(AConstructor: TdxPDFXFormCommandConstructor); virtual; abstract;
  public
    constructor Create(AAnnotation: TdxPDFCustomAnnotation); virtual;
    destructor Destroy; override;
    procedure RebuildAppearance(AForm: TdxPDFXForm);
  end;

  { TdxPDFCustomMarkupAnnotationAppearanceBuilder }

  TdxPDFCustomMarkupAnnotationAppearanceBuilder = class(TdxPDFAnnotationAppearanceBuilder) // for internal use
  strict private
    function GetAnnotation: TdxPDFMarkupAnnotation;
  protected
    procedure Rebuild(AConstructor: TdxPDFXFormCommandConstructor); override;
  public
    constructor Create(AAnnotation: TdxPDFMarkupAnnotation); reintroduce;
  end;

  { TdxPDFShapeAnnotationAppearanceBuilder }

  TdxPDFShapeAnnotationAppearanceBuilder = class(TdxPDFCustomMarkupAnnotationAppearanceBuilder)
  strict private
    function GetAnnotation: TdxPDFShapeAnnotation;
  protected
    procedure Rebuild(AConstructor: TdxPDFXFormCommandConstructor); override;
    procedure RebuildShape(AConstructor: TdxPDFXFormCommandConstructor; const ARect: TdxPDFRectangle); virtual; abstract;
  public
    constructor Create(AAnnotation: TdxPDFShapeAnnotation); reintroduce;
  end;

  { TdxPDFCircleAnnotationAppearanceBuilder }

  TdxPDFCircleAnnotationAppearanceBuilder = class(TdxPDFShapeAnnotationAppearanceBuilder)
  protected
    procedure RebuildShape(AConstructor: TdxPDFXFormCommandConstructor; const ARect: TdxPDFRectangle); override;
  public
    constructor Create(AAnnotation: TdxPDFCircleAnnotation); reintroduce;
  end;

  { TdxPDFSquareAnnotationAppearanceBuilder }

  TdxPDFSquareAnnotationAppearanceBuilder = class(TdxPDFShapeAnnotationAppearanceBuilder)
  protected
    procedure RebuildShape(AConstructor: TdxPDFXFormCommandConstructor; const ARect: TdxPDFRectangle); override;
  public
    constructor Create(AAnnotation: TdxPDFSquareAnnotation); reintroduce;
  end;

  { TdxPDFTextAnnotationAppearanceBuilder }

  TdxPDFTextAnnotationAppearanceBuilder = class(TdxPDFCustomMarkupAnnotationAppearanceBuilder)
  strict private const
    TextMarkupDefaultIcon = 'DXTextMarkupDefaultIcon';
  strict private class var
    FIconAppearanceDictionary: TdxPDFStringStringDictionary;
    class function GetIconAppearanceDictionary: TdxPDFStringStringDictionary; static;
  strict private
    FDefaultAppearanceAlpha: Single;
    FIconBox: TdxPDFRectangle;
    FStartAppearanceData: TBytes;
    //
    function GetAnnotation: TdxPDFTextAnnotation;
  protected
    class procedure Finalize;
    //
    function GetFormBBox: TdxPDFRectangle; override;
    procedure Initialize; override;
    procedure Rebuild(AConstructor: TdxPDFXFormCommandConstructor); override;
    //
    class property IconAppearanceDictionary: TdxPDFStringStringDictionary read GetIconAppearanceDictionary;
  public
    constructor Create(AAnnotation: TdxPDFTextAnnotation); reintroduce;
  end;

  { TdxPDFCaretAnnotationAppearanceBuilder }

  TdxPDFCaretAnnotationAppearanceBuilder = class(TdxPDFCustomMarkupAnnotationAppearanceBuilder)
  protected
    procedure Rebuild(AConstructor: TdxPDFXFormCommandConstructor); override;
  public
    constructor Create(AAnnotation: TdxPDFCaretAnnotation); reintroduce;
  end;

  { TdxPDFWidgetAnnotationAppearanceBuilder }

  TdxPDFWidgetAnnotationAppearanceBuilder = class(TdxPDFAnnotationAppearanceBuilder) // for internal use
  strict private
    FBackgroundColor: TdxPDFARGBColor;
    FBorderWidth: Double;
    //
    procedure DrawStyledBorder(AConstructor: TdxPDFXFormCommandConstructor; ABorderStyle: TdxPDFAnnotationBorderStyle);
  strict protected
    FField: TdxPDFInteractiveFormField;
  protected
    procedure Rebuild(AConstructor: TdxPDFXFormCommandConstructor); override;
    //
    function GetAnnotation: TdxPDFWidgetAnnotation;
    function GetBackgroundColor: TdxPDFARGBColor; virtual;
    function GetContentRectangle: TdxPDFRectangle; virtual;
    procedure DrawBeveledBorder(AConstructor: TdxPDFXFormCommandConstructor); virtual; abstract;
    procedure DrawContent(AConstructor: TdxPDFXFormCommandConstructor); virtual; abstract;
    procedure DrawInsetBorder(AConstructor: TdxPDFXFormCommandConstructor); virtual; abstract;
    procedure DrawSolidBorder(AConstructor: TdxPDFXFormCommandConstructor); virtual; abstract;
    procedure DrawUnderlineBorder(AConstructor: TdxPDFXFormCommandConstructor); virtual; abstract;
    procedure FillBackground(AConstructor: TdxPDFXFormCommandConstructor); virtual; abstract;
    //
    procedure DrawBorder(AConstructor: TdxPDFXFormCommandConstructor);
    procedure DrawRectangularBeveledBorder(AConstructor: TdxPDFXFormCommandConstructor);
    procedure DrawRectangularBorderBottomRightStroke(AConstructor: TdxPDFXFormCommandConstructor);
    procedure DrawRectangularBorderStroke(AConstructor: TdxPDFXFormCommandConstructor);
    procedure DrawRectangularBorderUpperLeftStroke(AConstructor: TdxPDFXFormCommandConstructor);
    procedure DrawRectangularInsetBorder(AConstructor: TdxPDFXFormCommandConstructor);
    procedure DrawRectangularUnderlineBorder(AConstructor: TdxPDFXFormCommandConstructor);
    procedure DrawTextCombs(AConstructor: TdxPDFXFormCommandConstructor; const AContentRect: TdxPDFRectangle; AMaxLen: Integer);
    procedure FillBackgroundEllipse(AConstructor: TdxPDFXFormCommandConstructor; const ARect: TdxPDFRectangle);
    procedure FillBackgroundRectangle(AConstructor: TdxPDFXFormCommandConstructor; const ARect: TdxPDFRectangle);
    //
    property BackgroundColor: TdxPDFARGBColor read GetBackgroundColor;
    property BorderWidth: Double read FBorderWidth;
    property ContentRectangle: TdxPDFRectangle read GetContentRectangle;
  public
    constructor Create(AWidget: TdxPDFWidgetAnnotation; AField: TdxPDFInteractiveFormField;
      const ABackgroundColor: TdxPDFARGBColor); reintroduce; virtual;
  end;

  { TdxPDFTextBasedFieldAppearanceBuilder }

  TdxPDFTextBasedFieldAppearanceBuilder = class(TdxPDFWidgetAnnotationAppearanceBuilder) // for internal use
  strict private
    FFontData: TdxPDFEditableFontData;
    FFontProvider: IdxPDFFontProvider;
    FFontSize: Double;
    function GetTextLineSpacing(AFontSize: Double): Double;
  protected
    procedure DrawBeveledBorder(AConstructor: TdxPDFXFormCommandConstructor); override;
    procedure DrawInsetBorder(AConstructor: TdxPDFXFormCommandConstructor); override;
    procedure DrawSolidBorder(AConstructor: TdxPDFXFormCommandConstructor); override;
    procedure DrawUnderlineBorder(AConstructor: TdxPDFXFormCommandConstructor); override;
    procedure FillBackground(AConstructor: TdxPDFXFormCommandConstructor); override;
    procedure Rebuild(AConstructor: TdxPDFXFormCommandConstructor); override;
    //
    function CalculateCenteredLineYOffset(const AClipRect: TdxPDFRectangle): Double;
    function GetTextWidth(const AText: string): Double; overload;
    function GetTextWidth(const AText: string; AFontSize: Double): Double; overload;
    function GetTextHeight(AFontSize: Double; ALineCount: Integer): Double;
    procedure DrawTextBoxText(AConstructor: TdxPDFXFormCommandConstructor; const AOffset: TdxPointF; const AText: string);
    procedure EndDrawTextBox(AConstructor: TdxPDFXFormCommandConstructor);
    procedure RemoveFont(AFont: TdxPDFCustomFont);
    procedure StartDrawTextBox(AConstructor: TdxPDFXFormCommandConstructor; const AForeColor: TdxPDFColor);
    function CalculateAutoFontSize: Double; virtual;
    //
    property FontData: TdxPDFEditableFontData read FFontData;
    property FontSize: Double read FFontSize;
  public
    constructor Create(AWidget: TdxPDFWidgetAnnotation; AField: TdxPDFInteractiveFormField;
      const ABackgroundColor: TdxPDFARGBColor; const AFontProvider: IdxPDFFontProvider); reintroduce;
  end;

  { TdxPDFSignatureAppearanceBuilder }

  TdxPDFSignatureAppearanceBuilder = class
  protected
    procedure DrawFormContent(AConstructor: TdxPDFXFormCommandConstructor); virtual; abstract;
  public
    procedure CreateAppearance(AForm: TdxPDFXForm); virtual;
  end;

  { TdxPDFImageSignatureAppearanceBuilder }

  TdxPDFImageSignatureAppearanceBuilder = class(TdxPDFSignatureAppearanceBuilder)
  strict private
    FContentMatrix: TdxPDFTransformationMatrix;
    FContentRect: TdxPDFRectangle;
    FFitMode: TcxImageFitMode;
    FObject: TdxPDFXObject;
    FImageSize: TSize;
  protected
    procedure DrawFormContent(AConstructor: TdxPDFXFormCommandConstructor); override;
  public
    constructor Create(AObject: TdxPDFXObject; const AImageSize: TSize; const AContentMatrix: TdxPDFTransformationMatrix;
      const AContentRect: TdxPDFRectangle; AFitMode: TcxImageFitMode);
  end;

  { TdxPDFInkAnnotationAppearanceBuilder }

  TdxPDFInkAnnotationAppearanceBuilder = class(TdxPDFCustomMarkupAnnotationAppearanceBuilder)
  strict private
    function GetAnnotation: TdxPDFInkAnnotation;
  protected
    function GetFormBBox: TdxPDFRectangle; override;
    procedure Rebuild(AConstructor: TdxPDFXFormCommandConstructor); override;
  public
    constructor Create(AAnnotation: TdxPDFInkAnnotation); reintroduce;
  end;

implementation

uses
  Math, dxTypeHelpers, dxStringHelper, dxPDFCharacterMapping, dxFontFile, dxPDFCommand, dxPDFUtils, dxCore;

const
  dxThisUnitName = 'dxPDFAppearanceBuilder';

type
  TdxPDFObjectAccess = class(TdxPDFObject);
  TdxPDFResourcesAccess = class(TdxPDFResources);

{ TdxPDFAnnotationAppearanceBuilder }

constructor TdxPDFAnnotationAppearanceBuilder.Create(AAnnotation: TdxPDFCustomAnnotation);
begin
  inherited Create;
  FAnnotation := AAnnotation;
  CreateSubClasses;
  Initialize;
end;

destructor TdxPDFAnnotationAppearanceBuilder.Destroy;
begin
  DestroySubClasses;
  inherited Destroy;
end;

procedure TdxPDFAnnotationAppearanceBuilder.RebuildAppearance(AForm: TdxPDFXForm);
var
  AConstructor: TdxPDFXFormCommandConstructor;
begin
  AConstructor := TdxPDFXFormCommandConstructor.Create(AForm);
  try
    AForm.BBox := GetFormBBox;
    AForm.Matrix := GetFormMatrix;
    Rebuild(AConstructor);
    AForm.ReplaceCommands(AConstructor.Commands);
  finally
    AConstructor.Free;
  end;
end;

function TdxPDFAnnotationAppearanceBuilder.GetFormBBox: TdxPDFRectangle;
begin
  Result := FAnnotation.AppearanceBBox;
end;

function TdxPDFAnnotationAppearanceBuilder.GetFormMatrix: TdxPDFTransformationMatrix;
begin
  Result := TdxPDFTransformationMatrix.Create;
end;

procedure TdxPDFAnnotationAppearanceBuilder.CreateSubClasses;
begin
  // do nothing
end;

procedure TdxPDFAnnotationAppearanceBuilder.DestroySubClasses;
begin
  // do nothing
end;

procedure TdxPDFAnnotationAppearanceBuilder.Initialize;
begin
  // do nothing
end;

{ TdxPDFShapeAnnotationAppearanceBuilder }

constructor TdxPDFShapeAnnotationAppearanceBuilder.Create(AAnnotation: TdxPDFShapeAnnotation);
begin
  inherited Create(AAnnotation);
end;

procedure TdxPDFShapeAnnotationAppearanceBuilder.Rebuild(AConstructor: TdxPDFXFormCommandConstructor);
var
  AAnnotation: TdxPDFShapeAnnotation;
  ABorderStyle: TdxPDFAnnotationBorderStyle;
  AHasBorder, AHasInterior: Boolean;
  ALeft, ABottom, ARight, ATop, ABorderWidth, ABorderOffset: Double;
  ARect, APadding: TdxPDFRectangle;
begin
  inherited Rebuild(AConstructor);
  AAnnotation := GetAnnotation;

  if AAnnotation.Color.IsNull then
    AHasBorder := False
  else
  begin
    AHasBorder := True;
    AConstructor.SetColorForStrokingOperations(AAnnotation.Color);
  end;

  if AAnnotation.InteriorColor.IsNull then
    AHasInterior := False
  else
  begin
    AHasInterior := True;
    AConstructor.SetColorForNonStrokingOperations(AAnnotation.InteriorColor);
  end;

  ARect := AAnnotation.Rect;
  ALeft := 0.5;
  ABottom := 0.5;
  ARight := ARect.Width - 0.5;
  ATop := ARect.Height - 0.5;
  APadding := AAnnotation.Padding;
  if not APadding.IsNull then
  begin
    ALeft := ALeft + APadding.Left;
    ABottom := ABottom + APadding.Bottom;
    ARight :=  ARight + APadding.Right;
    ATop := ATop + APadding.Top;
  end;

  if (ARight > ALeft) and (ATop > ABottom) then
  begin
    if AHasBorder then
    begin
      ABorderStyle := AAnnotation.BorderStyle;
      if ABorderStyle <> nil then
      begin
        ABorderWidth := ABorderStyle.Width;
        AConstructor.SetLineWidth(ABorderWidth);
        if ABorderStyle.StyleName = 'D' then
          AConstructor.SetLineStyle(ABorderStyle.LineStyle);
        if (ABorderWidth < ARect.Width) and (ABorderWidth < ARect.Height) then
        begin
          ABorderOffset := ABorderWidth / 2;
          if ABorderOffset > 0 then
          begin
            ALeft := ALeft + ABorderOffset;
            ABottom := ALeft + ABorderOffset;
            ARight := ARight + ABorderOffset;
            ATop := ATop + ABorderOffset;
          end;
        end
        else
        begin
          ALeft := (ALeft + ARight) / 2;
          ARight := ALeft;
          ABottom := (ABottom + ATop) / 2;
          ATop := ABottom;
        end;
      end;
    end;
    RebuildShape(AConstructor, TdxPDFRectangle.Create(ALeft, ABottom, ARight, ATop));
    if AHasBorder then
    begin
      if AHasInterior then
        AConstructor.FillAndStrokePath(True)
      else
        AConstructor.StrokePath;
    end
    else
      if AHasInterior then
        AConstructor.FillPath(True);
  end;
end;

function TdxPDFShapeAnnotationAppearanceBuilder.GetAnnotation: TdxPDFShapeAnnotation;
begin
  Result := FAnnotation as TdxPDFShapeAnnotation;
end;

{ TdxPDFCircleAnnotationAppearanceBuilder }

constructor TdxPDFCircleAnnotationAppearanceBuilder.Create(AAnnotation: TdxPDFCircleAnnotation);
begin
  inherited Create(AAnnotation);
end;

procedure TdxPDFCircleAnnotationAppearanceBuilder.RebuildShape(AConstructor: TdxPDFXFormCommandConstructor;
  const ARect: TdxPDFRectangle);
begin
  AConstructor.AppendEllipse(ARect);
  AConstructor.ClosePath;
end;

{ TdxPDFSquareAnnotationAppearanceBuilder }

constructor TdxPDFSquareAnnotationAppearanceBuilder.Create(AAnnotation: TdxPDFSquareAnnotation);
begin
  inherited Create(AAnnotation);
end;

procedure TdxPDFSquareAnnotationAppearanceBuilder.RebuildShape(AConstructor: TdxPDFXFormCommandConstructor;
  const ARect: TdxPDFRectangle);
begin
  AConstructor.AppendRectangle(ARect);
end;

{ TdxPDFCustomMarkupAnnotationAppearanceBuilder }

constructor TdxPDFCustomMarkupAnnotationAppearanceBuilder.Create(AAnnotation: TdxPDFMarkupAnnotation);
begin
  inherited Create(AAnnotation);
end;

procedure TdxPDFCustomMarkupAnnotationAppearanceBuilder.Rebuild(AConstructor: TdxPDFXFormCommandConstructor);
var
  AAnnotation: TdxPDFMarkupAnnotation;
  AParameters: TdxPDFGraphicsStateParameters;
begin
  AAnnotation := GetAnnotation;
  if not SameValue(AAnnotation.Opacity, 1.0) then
  begin
    AParameters := TdxPDFGraphicsStateParameters.Create;
    AParameters.NonStrokingColorAlpha := AAnnotation.Opacity;
    AParameters.StrokingColorAlpha := AAnnotation.Opacity;
    AConstructor.SetGraphicsStateParameters(AParameters);
  end;
end;

function TdxPDFCustomMarkupAnnotationAppearanceBuilder.GetAnnotation: TdxPDFMarkupAnnotation;
begin
  Result := TdxPDFMarkupAnnotation(FAnnotation);
end;

{ TdxPDFTextAnnotationAppearanceBuilder }

constructor TdxPDFTextAnnotationAppearanceBuilder.Create(AAnnotation: TdxPDFTextAnnotation);
begin
  inherited Create(AAnnotation);
end;

class function TdxPDFTextAnnotationAppearanceBuilder.GetIconAppearanceDictionary: TdxPDFStringStringDictionary;
begin
  if FIconAppearanceDictionary = nil then
  begin
    FIconAppearanceDictionary := TdxPDFStringStringDictionary.Create;
    FIconAppearanceDictionary.Add('Check',
      '3.2112 0.7184 m 0 3.2864 l 1.2096 4.7984 l 2.8392 3.4952 l 6.1152 8 l 7.68 6.86 l h f* ' +
      'Q q 0 0.32 7.68 7.68 re W n 0.0039216 0.0039216 0.0039216 rg /%s gs 6.2208 7.3304 m 7.0104 6.7544 l 3.12 1.4072 l '+
      '0.6744 3.3608 l 1.284 4.124 l 2.5392 3.1208 l 2.9304 2.8064 l 3.2256 3.2 l 6.2208 7.3304 l 6.1152 8 ' +
      'm 2.8392 3.4952 l 1.2 4.7984 l 0 3.2864 l 3.2112 0.7184 l 7.68 6.8624 l 6.1152 8 l h f Q');
    FIconAppearanceDictionary.Add('Comment',
      '7.2 8 m 0.48 8 l 0.2149 8 -0.00000000000000003246391 7.7851 0 7.52 c 0 2.24 ' +
      'l 0.00000000000000003246391 1.9749 0.2149 1.76 0.48 1.76 c 0.96 1.76 l 0.96 0.32 l 2.4 1.76 l 7.2 1.76 ' +
      'l 7.4651 1.76 7.68 1.9749 7.68 2.24 c 7.68 7.52 l 7.68 7.7851 7.4651 8 7.2 8 c h f Q q 0 0.32 7.68 7.68 re ' +
      'W n 0.0039216 0.0039216 0.0039216 rg /%s gs 7.2 7.52 m 7.2 2.24 l 2.2008 2.24 l 1.44 1.4792 l 1.44 2.24 ' +
      'l 0.48 2.24 l 0.48 7.52 l 7.2 7.52 l 7.2 8 m 0.48 8 l 0.2149 8 -0.00000000000000003246391 7.7851 0 7.52 ' +
      'c 0 2.24 l 0.00000000000000003246391 1.9749 0.2149 1.76 0.48 1.76 c 0.96 1.76 l 0.96 0.32 l 2.4 1.76 ' +
      'l 7.2 1.76 l 7.4651 1.76 7.68 1.9749 7.68 2.24 c 7.68 7.52 l 7.68 7.7851 7.4651 8 7.2 8 c h f Q q 0 0.32 7.68 7.68 ' +
      're W n 0.0039216 0.0039216 0.0039216 rg /%s gs 1.44 6.08 m 5.76 6.08 l 5.76 5.6 l 1.44 5.6 l h f* ' +
      'Q q 0 0.32 7.68 7.68 re W n 0.0039216 0.0039216 0.0039216 rg /%s gs 1.44 5.12 m 4.8 5.12 l 4.8 4.64 l 1.44 4.64 l ' +
      'h f* Q q 0 0.32 7.68 7.68 re W n 0.0039216 0.0039216 0.0039216 rg /%s gs 1.44 4.16 m 5.76 4.16 l 5.76 3.68 l 1.44 3.68 l h f* Q');
    FIconAppearanceDictionary.Add('CrossHairs',
      '3.84 8 m 1.7192 8 -0.0000000000000002597113 6.2808 0 4.16 c 0.0000000000000002597113 2.0392 1.7192 0.32 3.84 0.32 ' +
      'c 5.9608 0.32 7.68 2.0392 7.68 4.16 c 7.68 6.2808 5.9608 8 3.84 8 c h 5.76 3.68 m 4.32 3.68 l 4.32 2.24 ' +
      'l 3.36 2.24 l 3.36 3.68 l 1.92 3.68 l 1.92 4.64 l 3.36 4.64 l 3.36 6.08 l 4.32 6.08 l 4.32 4.64 l 5.76 4.64 l h ' +
      'f Q q 0 0.32 7.68 7.68 re W n 0.0039216 0.0039216 0.0039216 rg /%s gs 3.84 7.52 m 5.6957 7.52 7.2 6.0157 7.2 4.16 ' +
      'c 7.2 2.3043 5.6957 0.8 3.84 0.8 c 1.9843 0.8 0.48 2.3043 0.48 4.16 c 0.48 6.0157 1.9843 7.52 3.84 7.52 ' +
      'c 2.88 5.12 m 1.44 5.12 l 1.44 3.2 l 2.88 3.2 l 2.88 1.76 l 4.8 1.76 l 4.8 3.2 l 6.24 3.2 l 6.24 5.12 ' +
      'l 4.8 5.12 l 4.8 6.56 l 2.88 6.56 l 2.88 5.12 l 3.84 8 m 1.7192 8 -0.0000000000000002597113 6.2808 0 4.16 ' +
      'c 0.0000000000000002597113 2.0392 1.7192 0.32 3.84 0.32 c 5.9608 0.32 7.68 2.0392 7.68 4.16 ' +
      'c 7.68 6.2808 5.9608 8 3.84 8 c h 1.92 3.68 m 1.92 4.64 l 3.36 4.64 l 3.36 6.08 l 4.32 6.08 l 4.32 4.64 ' +
      'l 5.76 4.64 l 5.76 3.68 l 4.32 3.68 l 4.32 2.24 l 3.36 2.24 l 3.36 3.68 l h f Q');
    FIconAppearanceDictionary.Add('Cross',
      '7.68 1.784 m 5.304 4.16 l 7.68 6.536 l 6.216 8 l 3.84 5.624 l 1.464 8 l 0 6.536 l 2.376 4.16 l 0 1.784 ' +
      'l 1.464 0.32 l 3.84 2.696 l 6.216 0.32 l h f* Q q 0 0.32 7.68 7.68 re W n 0.0039216 0.0039216 0.0039216 rg /%s ' +
      'gs 6.216 7.3208 m 7.0008 6.536 l 4.9656 4.4984 l 4.6272 4.16 l 4.9656 3.8216 l 7.0008 1.784 l 6.216 0.9992 ' +
      'l 4.1784 3.0344 l 3.84 3.3728 l 3.5016 3.0344 l 1.464 0.9992 l 0.6792 1.784 l 2.7144 3.8216 l 3.0528 4.16 ' +
      'l 2.7144 4.4984 l 0.6792 6.536 l 1.464 7.3208 l 3.5016 5.2856 l 3.84 4.9448 l 4.1784 5.2856 l 6.216 7.3208 ' +
      'l 6.216 8 m 3.84 5.624 l 1.464 8 l 0 6.536 l 2.376 4.16 l 0 1.784 l 1.464 0.32 l 3.84 2.696 l 6.216 0.32 ' +
      'l 7.68 1.784 l 5.304 4.16 l 7.68 6.536 l 6.216 8 l h f Q');
    FIconAppearanceDictionary.Add('Circle',
      '3.84 8 m 1.7192 8 -0.0000000000000002597113 6.2808 0 4.16 c 0.0000000000000002597113 2.0392 1.7192 0.32 3.84 0.32 ' +
      'c 5.9608 0.32 7.68 2.0392 7.68 4.16 c 7.68 6.2808 5.9608 8 3.84 8 c h 3.84 2.24 m 2.7796 2.24 1.92 3.0996 1.92 4.16 ' +
      'c 1.92 5.2204 2.7796 6.08 3.84 6.08 c 4.9004 6.08 5.76 5.2204 5.76 4.16 c 5.76 3.0996 4.9004 2.24 3.84 2.24 c ' +
      'h f Q q 0 0.32 7.68 7.68 re W n 0.0039216 0.0039216 0.0039216 rg /%s gs 3.84 7.52 m 5.6957 7.52 7.2 6.0157 7.2 4.16 ' +
      'c 7.2 2.3043 5.6957 0.8 3.84 0.8 c 1.9843 0.8 0.48 2.3043 0.48 4.16 c 0.48 6.0157 1.9843 7.52 3.84 7.52 ' +
      'c 3.84 1.76 m 5.1655 1.76 6.24 2.8345 6.24 4.16 c 6.24 5.4855 5.1655 6.56 3.84 6.56 ' +
      'c 2.5145 6.56 1.44 5.4855 1.44 4.16 c 1.44 2.8345 2.5145 1.76 3.84 1.76 c 3.84 8 ' +
      'm 1.7192 8 -0.0000000000000002597113 6.2808 0 4.16 c 0.0000000000000002597113 2.0392 1.7192 0.32 3.84 0.32 ' +
      'c 5.9608 0.32 7.68 2.0392 7.68 4.16 c 7.68 6.2808 5.9608 8 3.84 8 c h 3.84 2.24 m 2.7796 2.24 1.92 3.0996 1.92 4.16 ' +
      'c 1.92 5.2204 2.7796 6.08 3.84 6.08 c 4.9004 6.08 5.76 5.2204 5.76 4.16 c 5.76 3.0996 4.9004 2.24 3.84 2.24 c h f Q');
    FIconAppearanceDictionary.Add('Help',
      '3.84 8 m 1.7192 8 -0.0000000000000002597113 6.2808 0 4.16 c 0.0000000000000002597113 2.0392 1.7192 0.32 3.84 0.32 c' +
      ' 5.9608 0.32 7.68 2.0392 7.68 4.16 c 7.68 6.2808 5.9608 8 3.84 8 c h 3.7224 2.192 m ' +
      '3.4416 2.192 3.264 2.2904 3.264 2.6048 c 3.264 2.9192 3.4416 3.0248 3.7224 3.0248 c ' +
      '4.0032 3.0248 4.1832 2.9192 4.1832 2.6048 c 4.1832 2.2904 4.0032 2.192 3.7224 2.192 c h 4.0584 3.2984 m ' +
      '3.4176 3.2984 l 3.0672 4.2584 4.4208 4.3616 4.4208 5.0672 c 4.4208 5.3816 4.1808 5.48 3.8592 5.48 c ' +
      '3.7077 5.4785 3.5579 5.4484 3.4176 5.3912 c 3.4109 5.2342 3.376 5.0798 3.3144 4.9352 c 2.7912 4.9352 l ' +
      '2.6845 5.1912 2.633 5.4668 2.64 5.744 c 3.0174 5.968 3.4491 6.0842 3.888 6.08 c 4.6584 6.08 5.28 5.7272 5.28 5.0072 c ' +
      '5.28 4.0424 3.9912 3.9656 4.0584 3.2984 c h f Q q 0 0.32 7.68 7.68 re W n 0.0039216 0.0039216 0.0039216 rg /%s ' +
      'gs 3.84 7.52 m 5.6957 7.52 7.2 6.0157 7.2 4.16 c 7.2 2.3043 5.6957 0.8 3.84 0.8 c ' +
      '1.9843 0.8 0.48 2.3043 0.48 4.16 c 0.48 6.0157 1.9843 7.52 3.84 7.52 c 2.4912 4.4552 m 3.264 4.4552 l ' +
      '2.9063 4.1318 2.7834 3.6221 2.9544 3.1712 c 2.8374 3.006 2.7776 2.8071 2.784 2.6048 c ' +
      '2.7699 2.3558 2.8659 2.1132 3.0466 1.9413 c 3.2273 1.7694 3.4744 1.6855 3.7224 1.712 c ' +
      '3.9706 1.6856 4.2179 1.7694 4.3989 1.9412 c 4.5799 2.113 4.6765 2.3556 4.6632 2.6048 c ' +
      '4.6652 2.7613 4.6298 2.9159 4.56 3.056 c 4.5312 3.3416 l 4.6242 3.4407 4.7299 3.5271 4.8456 3.5984 c ' +
      '5.2128 3.8528 5.76 4.2392 5.76 5.0072 c 5.76 5.936 5.0064 6.56 3.888 6.56 c 3.3542 6.5616 2.8303 6.4163 2.3736 6.14 c ' +
      '2.1792 6.0104 l 2.16 5.7776 l 2.1459 5.4163 2.2123 5.0564 2.3544 4.724 c 2.4864 4.4552 l 3.84 8 m ' +
      '1.7192 8 -0.0000000000000002597113 6.2808 0 4.16 c 0.0000000000000002597113 2.0392 1.7192 0.32 3.84 0.32 c ' +
      '5.9608 0.32 7.68 2.0392 7.68 4.16 c 7.68 6.2808 5.9608 8 3.84 8 c h 2.7912 4.9352 m ' +
      '2.6845 5.1912 2.633 5.4668 2.64 5.744 c 3.0174 5.968 3.4491 6.0842 3.888 6.08 c ' +
      '4.6584 6.08 5.28 5.7272 5.28 5.0072 c 5.28 4.0472 3.9912 3.9656 4.0584 3.2984 c 3.4176 3.2984 l ' +
      '3.0672 4.2584 4.4208 4.3616 4.4208 5.0672 c 4.4208 5.3816 4.1808 5.48 3.8592 5.48 c ' +
      '3.7077 5.4785 3.5579 5.4484 3.4176 5.3912 c 3.4109 5.2342 3.376 5.0798 3.3144 4.9352 c h 3.7224 2.192 m ' +
      '3.4416 2.192 3.264 2.2904 3.264 2.6048 c 3.264 2.9192 3.4416 3.0248 3.7224 3.0248 c ' +
      '4.0032 3.0248 4.1832 2.9192 4.1832 2.6048 c 4.1832 2.2904 4.0032 2.192 3.7224 2.192 c h f Q');
    FIconAppearanceDictionary.Add('Insert',
      '3.84 8 m 7.68 0.8 l 0 0.8 l h f* Q q 0 0.32 7.68 7.68 re W n 0.0039216 0.0039216 0.0039216 rg /%s gs 3.84 6.98 m ' +
      '6.8808 1.28 l 0.7992 1.28 l 3.84 6.98 l 3.84 8 m 0 0.8 l 7.68 0.8 l 3.84 8 l h f Q');
    FIconAppearanceDictionary.Add('Key',
      '3.84 8 m 2.8393 7.9973 1.9715 7.3076 1.743 6.3334 c 1.5144 5.3591 1.9849 4.3555 2.88 3.908 c 2.88 3.2 l ' +
      '3.36 2.72 l 2.88 2.24 l 3.36 1.76 l 2.88 1.28 l 3.84 0.32 l 4.8 1.28 l 4.8 3.908 l ' +
      '5.6951 4.3555 6.1656 5.3591 5.937 6.3334 c 5.7085 7.3076 4.8407 7.9973 3.84 8 c h 3.84 5.36 m ' +
      '3.5749 5.36 3.36 5.5749 3.36 5.84 c 3.36 6.1051 3.5749 6.32 3.84 6.32 c 4.1051 6.32 4.32 6.1051 4.32 5.84 c ' +
      '4.32 5.5749 4.1051 5.36 3.84 5.36 c h f Q q 0 0.32 7.68 7.68 re W n 0.0039216 0.0039216 0.0039216 rg /%s ' +
      'gs 3.84 7.52 m 4.618 7.5175 5.2926 6.9811 5.4702 6.2236 c 5.6479 5.4661 5.2822 4.6858 4.5864 4.3376 c ' +
      '4.32 4.2056 l 4.32 1.4792 l 3.84 0.9992 l 3.5496 1.28 l 4.0296 1.76 l 3.5496 2.24 l 4.0296 2.72 l 3.36 3.3992 l ' +
      '3.36 4.2056 l 3.0936 4.3376 l 2.3978 4.6858 2.0321 5.4661 2.2098 6.2236 c 2.3874 6.9811 3.062 7.5175 3.84 7.52 c ' +
      '3.84 4.88 m 4.3702 4.88 4.8 5.3098 4.8 5.84 c 4.8 6.3702 4.3702 6.8 3.84 6.8 c 3.3098 6.8 2.88 6.3702 2.88 5.84 c ' +
      '2.88 5.3098 3.3098 4.88 3.84 4.88 c 3.84 8 m 2.8393 7.9973 1.9715 7.3076 1.743 6.3334 c ' +
      '1.5144 5.3591 1.9849 4.3555 2.88 3.908 c 2.88 3.2 l 3.36 2.72 l 2.88 2.24 l 3.36 1.76 l 2.88 1.28 l ' +
      '3.84 0.32 l 4.8 1.28 l 4.8 3.908 l 5.6951 4.3555 6.1656 5.3591 5.937 6.3334 c 5.7085 7.3076 4.8407 7.9973 3.84 8 c ' +
      'h 3.84 5.36 m 3.5749 5.36 3.36 5.5749 3.36 5.84 c 3.36 6.1051 3.5749 6.32 3.84 6.32 c ' +
      '4.1051 6.32 4.32 6.1051 4.32 5.84 c 4.32 5.5749 4.1051 5.36 3.84 5.36 c h f Q');
    FIconAppearanceDictionary.Add('NewParagraph',
      '3.84 8 m 6.24 3.2 l 1.44 3.2 l h f* Q q 0 0.32 7.68 7.68 re W n 0.0039216 0.0039216 0.0039216 rg /%s gs ' +
      '3.84 6.9272 m 5.4624 3.68 l 2.2176 3.68 l 3.84 6.9272 l 3.84 8 m 1.44 3.2 l 6.24 3.2 l 3.84 8 l h f Q q ' +
      '0 0.32 7.68 7.68 re W n 0.0039216 0.0039216 0.0039216 rg /%s gs 3.4008 2.72 m 3.84 2.72 l 3.84 0.8 l ' +
      '3.192 0.8 l 2.5248 2.1536 l 2.5248 2.1536 l 2.5392 1.94 2.5464 1.7768 2.5464 1.6736 c 2.5464 0.8 l ' +
      '2.1 0.8 l 2.1 2.72 l 2.7456 2.72 l 3.4104 1.3856 l 3.4104 1.3856 l 3.3984 1.58 3.3936 1.7336 3.3936 1.8512 c ' +
      'h 5.76 2.1104 m 5.7716 1.9263 5.7064 1.7456 5.58 1.6112 c 5.4382 1.488 5.2539 1.4252 5.0664 1.436 c ' +
      '4.56 1.436 l 4.56 0.8 l 4.08 0.8 l 4.08 2.72 l 5.0688 2.72 l 5.256 2.7337 5.4417 2.6772 5.5896 2.5616 c ' +
      '5.7088 2.4428 5.771 2.2783 5.76 2.1104 c h 5.2608 2.1104 m 5.2608 2.24 5.1912 2.3048 5.0544 2.3048 c ' +
      '4.56 2.3048 l 4.56 1.8656 l 5.0088 1.8656 l 5.0735 1.8621 5.1366 1.8863 5.1824 1.932 c ' +
      '5.2281 1.9778 5.2523 2.0409 5.2488 2.1056 c h f Q');
    FIconAppearanceDictionary.Add('Paragraph',
      '6.24 8 m 2.88 8 l 1.8192 8 0.96 6.9248 0.96 5.6 c 0.96 4.4816 1.572 3.5456 2.4 3.2792 c 2.4 0.32 l ' +
      '3.84 0.32 l 3.84 6.56 l 4.32 6.56 l 4.32 0.32 l 5.76 0.32 l 5.76 6.56 l 6.24 6.56 l h f Q q ' +
      '0 0.32 7.68 7.68 re W n 0.0039216 0.0039216 0.0039216 rg /%s gs 5.76 7.52 m 5.76 7.04 l 5.28 7.04 l ' +
      '5.28 0.8 l 4.8 0.8 l 4.8 7.04 l 3.36 7.04 l 3.36 0.8 l 2.88 0.8 l 2.88 3.6272 l 2.5464 3.7352 l ' +
      '1.9056 3.9416 1.44 4.7264 1.44 5.6 c 1.44 6.6584 2.0856 7.52 2.88 7.52 c 5.76 7.52 l 6.24 8 m 2.88 8 l ' +
      '1.8192 8 0.96 6.9248 0.96 5.6 c 0.96 4.4816 1.572 3.5456 2.4 3.2792 c 2.4 0.32 l 3.84 0.32 l 3.84 6.56 l ' +
      '4.32 6.56 l 4.32 0.32 l 5.76 0.32 l 5.76 6.56 l 6.24 6.56 l 6.24 8 l h f Q');
    FIconAppearanceDictionary.Add('RightArrow',
      '3.84 8 m 1.7192 8 -0.0000000000000002597113 6.2808 0 4.16 c 0.0000000000000002597113 2.0392 1.7192 0.32 3.84 0.32 c ' +
      '5.9608 0.32 7.68 2.0392 7.68 4.16 c 7.68 6.2808 5.9608 8 3.84 8 c h 4.32 2.72 m 4.32 3.68 l 1.92 3.68 l ' +
      '1.92 4.64 l 4.32 4.64 l 4.32 5.6 l 5.76 4.16 l h f Q q 0 0.32 7.68 7.68 re W n ' +
      '0.0039216 0.0039216 0.0039216 rg /%s gs 3.84 7.52 m 5.6957 7.52 7.2 6.0157 7.2 4.16 c ' +
      '7.2 2.3043 5.6957 0.8 3.84 0.8 c 1.9843 0.8 0.48 2.3043 0.48 4.16 c 0.48 6.0157 1.9843 7.52 3.84 7.52 c ' +
      '3.84 5.12 m 1.44 5.12 l 1.44 3.2 l 3.84 3.2 l 3.84 1.5608 l 4.6584 2.3816 l 6.0984 3.8216 l 6.4392 4.16 l ' +
      '6.0984 4.4984 l 4.6584 5.9384 l 3.84 6.7592 l 3.84 5.12 l 3.84 8 m 1.7192 8 -0.0000000000000002597113 6.2808 0 4.16 c ' +
      '0.0000000000000002597113 2.0392 1.7192 0.32 3.84 0.32 c 5.9608 0.32 7.68 2.0392 7.68 4.16 c ' +
      '7.68 6.2808 5.9608 8 3.84 8 c h 1.92 3.68 m 1.92 4.64 l 4.32 4.64 l 4.32 5.6 l 5.76 4.16 l 4.32 2.72 l ' +
      '4.32 3.68 l h f Q');
    FIconAppearanceDictionary.Add('RightPointer',
      '7.68 4.16 m 0.48 0.32 l 1.92 4.16 l 0.48 8 l h f* Q q 0 0.32 7.68 7.68 re W n 0.0039216 0.0039216 0.0039216 rg /%s ' +
      'gs 1.3752 6.9776 m 6.66 4.16 l 1.38 1.3424 l 2.3736 3.9824 l 2.4384 4.1504 l 2.3736 4.3184 l 1.38 6.9584 l ' +
      '0.48 8 m 1.92 4.16 l 0.48 0.32 l 7.68 4.16 l 0.48 8 l h f Q');
    FIconAppearanceDictionary.Add('Star',
      '3.84 2.144 m 1.7904 0.7184 l 1.6954 0.65142 1.5684 0.65239 1.4744 0.7208 c ' +
      '1.3805 0.78922 1.3406 0.90987 1.3752 1.0208 c 2.0952 3.4208 l 0.108 4.9184 l ' +
      '0.024244 4.9907 -0.0077573 5.1062 0.026908 5.2113 c 0.061574 5.3163 0.15609 5.3902 0.2664 5.3984 c ' +
      '2.7624 5.4488 l 3.5832 7.8176 l 3.6206 7.9276 3.7238 8.0016 3.84 8.0016 c ' +
      '3.9562 8.0016 4.0594 7.9276 4.0968 7.8176 c 4.9176 5.4584 l 7.4136 5.408 l ' +
      '7.5239 5.3998 7.6184 5.3259 7.6531 5.2209 c 7.6878 5.1158 7.6558 5.0003 7.572 4.928 c 5.5824 3.4208 l ' +
      '6.3024 1.0208 l 6.337 0.90987 6.2971 0.78922 6.2032 0.7208 c 6.1092 0.65239 5.9822 0.65142 5.8872 0.7184 c ' +
      'h f Q q 0 0.32 7.68 7.68 re W n 0.0039216 0.0039216 0.0039216 rg /%s gs 3.84 7.0952 m 4.464 5.3024 l ' +
      '4.572 4.9856 l 4.908 4.9856 l 6.8064 4.9472 l 5.292 3.8 l 5.0256 3.5984 l 5.124 3.2792 l 5.6736 1.4624 l ' +
      '4.1136 2.5472 l 3.84 2.72 l 3.5664 2.5304 l 2.0064 1.4456 l 2.556 3.2624 l 2.6544 3.5816 l 2.4 3.7928 l ' +
      '0.8736 4.94 l 2.772 4.9784 l 3.108 4.9784 l 3.216 5.2952 l 3.84 7.0952 l 3.84 8 m ' +
      '3.7238 8.0017 3.6198 7.9279 3.5832 7.8176 c 2.7624 5.4584 l 0.2664 5.408 l ' +
      '0.15609 5.3998 0.061574 5.3259 0.026908 5.2209 c -0.0077573 5.1158 0.024244 5.0003 0.108 4.928 c ' +
      '2.0976 3.4208 l 1.3776 1.0208 l 1.3525 0.93796 1.3682 0.84816 1.4197 0.77864 c ' +
      '1.4713 0.70912 1.5527 0.66809 1.6392 0.668 c 1.6943 0.66924 1.7477 0.68678 1.7928 0.7184 c 3.84 2.144 l ' +
      '5.8896 0.7184 l 5.9347 0.68678 5.9881 0.66924 6.0432 0.668 c 6.1297 0.66809 6.2111 0.70912 6.2627 0.77864 c ' +
      '6.3142 0.84816 6.3299 0.93796 6.3048 1.0208 c 5.5848 3.4208 l 7.5744 4.928 l ' +
      '7.6582 5.0003 7.6902 5.1158 7.6555 5.2209 c 7.6208 5.3259 7.5263 5.3998 7.416 5.408 c 4.92 5.4584 l ' +
      '4.0968 7.8176 l 4.0602 7.9279 3.9562 8.0017 3.84 8 c h f Q');
    FIconAppearanceDictionary.Add('UpArrow',
      '3.852 8 m 7.2 3.68 l 5.28 3.68 l 5.28 0.32 l 2.4 0.32 l 2.4 3.68 l 0.48 3.68 l h f* Q q 0 0.32 7.68 7.68 re ' +
      'W n 0.0039216 0.0039216 0.0039216 rg /%s gs 3.84 7.2176 m 6.2208 4.16 l 4.8 4.16 l 4.8 0.8 l 2.88 0.8 l ' +
      '2.88 4.16 l 1.464 4.16 l 3.84 7.2176 l 3.84 8 m 0.48 3.68 l 2.4 3.68 l 2.4 0.32 l 5.28 0.32 l 5.28 3.68 l ' +
      '7.2 3.68 l 3.852 8 l h f Q');
    FIconAppearanceDictionary.Add('UpLeftArrow',
      '0.48 7.52 m 6.24 6.56 l 4.8 5.12 l 7.68 2.24 l 5.76 0.32 l 2.88 3.2 l 1.44 1.76 l h f* Q q 0 0.32 7.68 7.68 re ' +
      'W n 0.0039216 0.0039216 0.0039216 rg /%s gs 1.0632 6.9368 m 5.2416 6.2408 l 4.4616 5.4584 l 4.1208 5.12 l ' +
      '4.4616 4.7816 l 7.0008 2.24 l 5.76 0.9992 l 3.2184 3.5384 l 2.88 3.8792 l 2.5416 3.5384 l 1.7592 2.7584 l ' +
      '1.0632 6.9368 l 0.48 7.52 m 1.44 1.76 l 2.88 3.2 l 5.76 0.32 l 7.68 2.24 l 4.8 5.12 l 6.24 6.56 l 0.48 7.52 l h f Q');
    FIconAppearanceDictionary.Add(TextMarkupDefaultIcon,
      '0.48 8 m 7.2 8 l 7.2 0.32 l 0.48 0.32 l h f* Q q 0 0.32 7.68 7.68 re W n 0.0039216 0.0039216 0.0039216 rg /%s ' +
      'gs 6.72 7.52 m 6.72 0.8 l 0.96 0.8 l 0.96 7.52 l 6.72 7.52 l 6.72 8 m 0.96 8 l 0.6949 8 0.48 7.7851 0.48 7.52 c ' +
      '0.48 0.8 l 0.48 0.5349 0.6949 0.32 0.96 0.32 c 6.72 0.32 l 6.9851 0.32 7.2 0.5349 7.2 0.8 c 7.2 7.52 l ' +
      '7.2 7.7851 6.9851 8 6.72 8 c h f Q q 0 0.32 7.68 7.68 re W n 0.0039216 0.0039216 0.0039216 rg /%s ' +
      'gs 1.92 6.08 m 5.76 6.08 l 5.76 5.6 l 1.92 5.6 l h f* Q q 0 0.32 7.68 7.68 re W n ' +
      '0.0039216 0.0039216 0.0039216 rg /%s gs 1.92 5.12 m 5.76 5.12 l 5.76 4.64 l 1.92 4.64 l h f* Q q ' +
      '0 0.32 7.68 7.68 re W n 0.0039216 0.0039216 0.0039216 rg /%s gs 1.92 4.16 m 5.76 4.16 l 5.76 3.68 l ' +
      '1.92 3.68 l h f* Q q 0 0.32 7.68 7.68 re W n 0.0039216 0.0039216 0.0039216 rg /%s gs 1.92 3.2 m 5.76 3.2 l ' +
      '5.76 2.72 l 1.92 2.72 l h f* Q');

  end;
  Result := FIconAppearanceDictionary;
end;

function TdxPDFTextAnnotationAppearanceBuilder.GetFormBBox: TdxPDFRectangle;
begin
  Result := TdxPDFRectangle.Inflate(FIconBox, -0.25);
end;

class procedure TdxPDFTextAnnotationAppearanceBuilder.Finalize;
begin
  FreeAndNil(FIconAppearanceDictionary);
end;

procedure TdxPDFTextAnnotationAppearanceBuilder.Initialize;
begin
  inherited Initialize;
  FDefaultAppearanceAlpha := 0.349;
  FIconBox := TdxPDFRectangle.Create(-0.25, 0.25, 7.75, 8.25);
  FStartAppearanceData := TEncoding.UTF8.GetBytes('q 0 0.32 7.68 7.68 re W n ');
end;

procedure TdxPDFTextAnnotationAppearanceBuilder.Rebuild(AConstructor: TdxPDFXFormCommandConstructor);

  function GetAnnotationColor: TdxPDFColor;
  var
    AComponents: TDoubleDynArray;
  begin
    if FAnnotation.Color.IsNull then
    begin
      SetLength(AComponents, 1);
      AComponents[0] := 1;
      Result := TdxPDFColor.Create(AComponents);
    end
    else
      Result := FAnnotation.Color;
  end;

var
  AAnnotation: TdxPDFTextAnnotation;
  AGraphicsStateParameters: TdxPDFGraphicsStateParameters;
  AIconCommand: string;
  AOpacityResourceName: string;
begin
  inherited Rebuild(AConstructor);
  AAnnotation := GetAnnotation;

  AConstructor.AddCommands(FStartAppearanceData);

  AGraphicsStateParameters := TdxPDFGraphicsStateParameters.Create;
  AGraphicsStateParameters.NonStrokingColorAlpha := FDefaultAppearanceAlpha;
  AOpacityResourceName := TdxPDFResourcesAccess(AConstructor.Form.Resources).AddGraphicsStateParameters(
    AGraphicsStateParameters);

  AConstructor.SetColorForNonStrokingOperations(GetAnnotationColor);
  if IconAppearanceDictionary.TryGetValue(AAnnotation.IconName, AIconCommand) or
    IconAppearanceDictionary.TryGetValue(TextMarkupDefaultIcon, AIconCommand) then
  begin
    AIconCommand := StringReplace(AIconCommand, '%s', AOpacityResourceName, [rfReplaceAll]);
    AConstructor.AddCommands(TEncoding.UTF8.GetBytes(AIconCommand));
  end;
end;

function TdxPDFTextAnnotationAppearanceBuilder.GetAnnotation: TdxPDFTextAnnotation;
begin
  Result := TdxPDFTextAnnotation(FAnnotation);
end;

{ TdxPDFCaretAnnotationAppearanceBuilder }

constructor TdxPDFCaretAnnotationAppearanceBuilder.Create(AAnnotation: TdxPDFCaretAnnotation);
begin
  inherited Create(AAnnotation);
end;

procedure TdxPDFCaretAnnotationAppearanceBuilder.Rebuild(AConstructor: TdxPDFXFormCommandConstructor);
var
  AContentRect: TdxPDFRectangle;
  APath: TdxPDFGraphicsPath;
begin
  inherited Rebuild(AConstructor);
  AConstructor.SetColorForStrokingOperations(FAnnotation.Color);
  AConstructor.SetLineWidth(FAnnotation.Border.LineWidth);
  AConstructor.SetColorForNonStrokingOperations(FAnnotation.Color);

  AContentRect := TdxPDFRectangle.Create(0, 0, FAnnotation.Rect.Width, FAnnotation.Rect.Height);
  APath := TdxPDFGraphicsPath.Create(dxNullPointF);
  try
    APath.AppendBezierSegment(dxPointF(AContentRect.Width / 2, 0), dxPointF(AContentRect.Width / 2, AContentRect.Height / 2),
      dxPointF(AContentRect.Width / 2, AContentRect.Height));
    APath.AppendBezierSegment(dxPointF(AContentRect.Width / 2, AContentRect.Height / 2), dxPointF(AContentRect.Width / 2, 0),
      dxPointF(AContentRect.Width, 0));
    APath.IsClosed := True;
    AConstructor.FillPath(APath, True);
    AConstructor.StrokePath;
  finally
    APath.Free;
  end;
end;

{ TdxPDFWidgetAnnotationAppearanceBuilder }

constructor TdxPDFWidgetAnnotationAppearanceBuilder.Create(AWidget: TdxPDFWidgetAnnotation;
  AField: TdxPDFInteractiveFormField; const ABackgroundColor: TdxPDFARGBColor);
begin
  inherited Create(AWidget);
  FField := AField;
  FBorderWidth := AWidget.BorderWidth;
  FBackgroundColor := ABackgroundColor;
end;

procedure TdxPDFWidgetAnnotationAppearanceBuilder.Rebuild(AConstructor: TdxPDFXFormCommandConstructor);
var
  AContentRect: TdxPDFRectangle;
begin
  AContentRect := GetContentRectangle;
  AConstructor.SaveGraphicsState;
  FillBackground(AConstructor);
  DrawBorder(AConstructor);
  AConstructor.RestoreGraphicsState;
  AConstructor.BeginMarkedContent;
  AConstructor.SaveGraphicsState;
  AConstructor.IntersectClip(AContentRect);
  DrawContent(AConstructor);
  AConstructor.RestoreGraphicsState;
  AConstructor.EndMarkedContent;
end;

function TdxPDFWidgetAnnotationAppearanceBuilder.GetAnnotation: TdxPDFWidgetAnnotation;
begin
  Result := TdxPDFWidgetAnnotation(FAnnotation);
end;

function TdxPDFWidgetAnnotationAppearanceBuilder.GetBackgroundColor: TdxPDFARGBColor;
begin
  if not FBackgroundColor.IsNull then
    Result := FBackgroundColor
  else
    Result := TdxPDFARGBColor.Create(GetAnnotation.BackgroundColor);
end;

function TdxPDFWidgetAnnotationAppearanceBuilder.GetContentRectangle: TdxPDFRectangle;
begin
  Result := TdxPDFWidgetAnnotation(FAnnotation).AppearanceContentRectangle;
end;

procedure TdxPDFWidgetAnnotationAppearanceBuilder.DrawBorder(AConstructor: TdxPDFXFormCommandConstructor);
var
  AAnnotation: TdxPDFWidgetAnnotation;
  AAppearanceCharacteristics: TdxPDFWidgetAppearanceCharacteristics;
begin
  AAnnotation := GetAnnotation;

  AAppearanceCharacteristics := AAnnotation.AppearanceCharacteristics;
  if (AAppearanceCharacteristics <> nil) and not AAppearanceCharacteristics.BorderColor.IsNull then
  begin
    AConstructor.SetColorForStrokingOperations(AAppearanceCharacteristics.BorderColor);
    if AAnnotation.BorderStyle = nil then
    begin
      if FAnnotation.Border <> nil then
      begin
        AConstructor.SetLineWidth(FAnnotation.Border.LineWidth);
        AConstructor.SetLineStyle(FAnnotation.Border.LineStyle);
        DrawSolidBorder(AConstructor);
      end;
    end
    else
      DrawStyledBorder(AConstructor, AAnnotation.BorderStyle);
  end;
end;

procedure TdxPDFWidgetAnnotationAppearanceBuilder.DrawRectangularBeveledBorder(AConstructor: TdxPDFXFormCommandConstructor);
var
  AComponents: TDoubleDynArray;
begin
  SetLength(AComponents, 1);
  AComponents[0] := 1.0;
  AConstructor.SetColorForNonStrokingOperations(TdxPDFColor.Create(AComponents));
  DrawRectangularBorderUpperLeftStroke(AConstructor);
  AComponents[0] := 0.5;
  AConstructor.SetColorForNonStrokingOperations(TdxPDFColor.Create(AComponents));
  DrawRectangularBorderBottomRightStroke(AConstructor);
end;

procedure TdxPDFWidgetAnnotationAppearanceBuilder.DrawRectangularBorderBottomRightStroke(
  AConstructor: TdxPDFXFormCommandConstructor);
var
  AAnnotationRect: TdxPDFRectangle;
  AAnnotationHeight, ARight, ALeft, ADoubleBorderWidth: Double;
  APoints: TdxPDFPoints;
begin
  AAnnotationRect := AConstructor.BoundingBox;
  AAnnotationHeight := AAnnotationRect.Height;
  ARight := AAnnotationRect.Width - FBorderWidth;
  ALeft := ARight - FBorderWidth;
  ADoubleBorderWidth := 2 * FBorderWidth;
  SetLength(APoints, 7);
  APoints[0] := TdxPointF.Create(FBorderWidth, FBorderWidth);
  APoints[1] := TdxPointF.Create(ARight, FBorderWidth);
  APoints[2] := TdxPointF.Create(ARight, AAnnotationHeight - FBorderWidth);
  APoints[3] := TdxPointF.Create(ALeft, AAnnotationHeight - ADoubleBorderWidth);
  APoints[4] := TdxPointF.Create(ALeft, ADoubleBorderWidth);
  APoints[5] := TdxPointF.Create(ADoubleBorderWidth, ADoubleBorderWidth);
  APoints[6] := TdxPointF.Create(FBorderWidth, FBorderWidth);
  AConstructor.FillPolygon(APoints, True);
end;

procedure TdxPDFWidgetAnnotationAppearanceBuilder.DrawRectangularBorderStroke(AConstructor: TdxPDFXFormCommandConstructor);
var
  AHalfBorderWidth, W, H: Double;
  R: TdxPDFRectangle;
begin
  AHalfBorderWidth := FBorderWidth / 2;
  W := AConstructor.BoundingBox.Width - AHalfBorderWidth;
  H := AConstructor.BoundingBox.Height - AHalfBorderWidth;
  R := TdxPDFRectangle.Create(TdxPDFUtils.Min(AHalfBorderWidth, W), TdxPDFUtils.Min(AHalfBorderWidth, H),
    TdxPDFUtils.Max(AHalfBorderWidth, W), TdxPDFUtils.Max(AHalfBorderWidth, H));
  AConstructor.AppendRectangle(R);
  AConstructor.CloseAndStrokePath;
end;

procedure TdxPDFWidgetAnnotationAppearanceBuilder.DrawRectangularBorderUpperLeftStroke(
  AConstructor: TdxPDFXFormCommandConstructor);
var
  AAnnotationRect: TdxPDFRectangle;
  AAnnotationWidth, ATop, ABottom, ADoubleBorderWidth: Double;
  APoints: TdxPDFPoints;
begin
  AAnnotationRect := AConstructor.BoundingBox;
  AAnnotationWidth := AAnnotationRect.Width;
  ATop := AAnnotationRect.Height - FBorderWidth;
  ABottom := ATop - FBorderWidth;
  ADoubleBorderWidth := 2 * FBorderWidth;
  SetLength(APoints, 7);
  APoints[0] := TdxPointF.Create(FBorderWidth, FBorderWidth);
  APoints[1] := TdxPointF.Create(FBorderWidth, ATop);
  APoints[2] := TdxPointF.Create(AAnnotationWidth - FBorderWidth, ATop);
  APoints[3] := TdxPointF.Create(AAnnotationWidth - ADoubleBorderWidth, ABottom);
  APoints[4] := TdxPointF.Create(ADoubleBorderWidth, ABottom);
  APoints[5] := TdxPointF.Create(ADoubleBorderWidth, ADoubleBorderWidth);
  APoints[6] := TdxPointF.Create(FBorderWidth, FBorderWidth);
  AConstructor.FillPolygon(APoints, True);
end;

procedure TdxPDFWidgetAnnotationAppearanceBuilder.DrawRectangularInsetBorder(AConstructor: TdxPDFXFormCommandConstructor);
var
  AComponents: TDoubleDynArray;
begin
  SetLength(AComponents, 1);
  AComponents[0] := 0.5;
  AConstructor.SetColorForNonStrokingOperations(TdxPDFColor.Create(AComponents));
  DrawRectangularBorderUpperLeftStroke(AConstructor);
  AComponents[0] := 0.75;
  AConstructor.SetColorForNonStrokingOperations(TdxPDFColor.Create(AComponents));
  DrawRectangularBorderBottomRightStroke(AConstructor);
end;

procedure TdxPDFWidgetAnnotationAppearanceBuilder.DrawRectangularUnderlineBorder(AConstructor: TdxPDFXFormCommandConstructor);
var
  AHalfBorderWidth: Double;
  APoints: TdxPDFPoints;
begin
  AHalfBorderWidth := BorderWidth / 2;
  SetLength(APoints, 2);
  APoints[0] := TdxPointF.Create(0, AHalfBorderWidth);
  APoints[1] := TdxPointF.Create(AConstructor.BoundingBox.Width, AHalfBorderWidth);
  AConstructor.DrawLines(APoints);
end;

procedure TdxPDFWidgetAnnotationAppearanceBuilder.DrawTextCombs(AConstructor: TdxPDFXFormCommandConstructor;
  const AContentRect: TdxPDFRectangle; AMaxLen: Integer);
var
  I: Integer;
  AHalfBorderWidth, AStep, ATop, ABottom, X: Double;
begin
  if AMaxLen <> 0 then
  begin
    AHalfBorderWidth := FBorderWidth / 2;
    AStep := AContentRect.Width / AMaxLen;
    ATop := AContentRect.Top;
    ABottom := AContentRect.Bottom;
    for I := 1 to AMaxLen - 1 do
    begin
      X := I * AStep + AHalfBorderWidth;
      AConstructor.DrawLine(TdxPointF.Create(X, ATop), TdxPointF.Create(X, ABottom));
    end;
  end;
end;

procedure TdxPDFWidgetAnnotationAppearanceBuilder.FillBackgroundRectangle(AConstructor: TdxPDFXFormCommandConstructor;
  const ARect: TdxPDFRectangle);
begin
  if not BackgroundColor.IsNull then
  begin
    AConstructor.SetColorForNonStrokingOperations(BackgroundColor);
    AConstructor.FillRectangle(ARect);
  end;
end;

procedure TdxPDFWidgetAnnotationAppearanceBuilder.FillBackgroundEllipse(AConstructor: TdxPDFXFormCommandConstructor;
  const ARect: TdxPDFRectangle);
begin
  if not BackgroundColor.IsNull then
  begin
    AConstructor.SetColorForNonStrokingOperations(BackgroundColor);
    AConstructor.FillEllipse(ARect);
  end;
end;

procedure TdxPDFWidgetAnnotationAppearanceBuilder.DrawStyledBorder(AConstructor: TdxPDFXFormCommandConstructor;
  ABorderStyle: TdxPDFAnnotationBorderStyle);
begin
  AConstructor.SetLineWidth(ABorderStyle.Width);
  if ABorderStyle.StyleName = 'D' then
  begin
    AConstructor.SetLineStyle(ABorderStyle.LineStyle);
    DrawSolidBorder(AConstructor);
  end
  else
    if ABorderStyle.StyleName = 'B' then
    begin
      DrawSolidBorder(AConstructor);
      DrawBeveledBorder(AConstructor);
    end
    else
      if ABorderStyle.StyleName = 'I' then
      begin
        DrawSolidBorder(AConstructor);
        DrawInsetBorder(AConstructor);
      end
      else
        if ABorderStyle.StyleName = 'U' then
          DrawUnderlineBorder(AConstructor)
        else
          DrawSolidBorder(AConstructor);
end;

{ TdxPDFTextBasedFieldAppearanceBuilder }

constructor TdxPDFTextBasedFieldAppearanceBuilder.Create(AWidget: TdxPDFWidgetAnnotation;
  AField: TdxPDFInteractiveFormField; const ABackgroundColor: TdxPDFARGBColor; const AFontProvider: IdxPDFFontProvider);
begin
  inherited Create(AWidget, AField, ABackgroundColor);
  FFontProvider := AFontProvider;
  if FFontProvider <> nil then
  begin
    FFontData := FFontProvider.GetMatchingFont(FField.TextState.FontCommand) as TdxPDFEditableFontData;
    FFontSize := FField.TextState.FontSize;
    if FFontSize = 0 then
      FFontSize := CalculateAutoFontSize;
  end;
end;

function TdxPDFTextBasedFieldAppearanceBuilder.CalculateAutoFontSize: Double;
begin
  Result := TdxPDFInteractiveFormFieldTextState.DefaultFontSize;
end;

procedure TdxPDFTextBasedFieldAppearanceBuilder.DrawBeveledBorder(AConstructor: TdxPDFXFormCommandConstructor);
begin
  DrawRectangularBeveledBorder(AConstructor);
end;

procedure TdxPDFTextBasedFieldAppearanceBuilder.DrawInsetBorder(AConstructor: TdxPDFXFormCommandConstructor);
begin
  DrawRectangularInsetBorder(AConstructor);
end;

procedure TdxPDFTextBasedFieldAppearanceBuilder.DrawSolidBorder(AConstructor: TdxPDFXFormCommandConstructor);
begin
  DrawRectangularBorderStroke(AConstructor);
end;

procedure TdxPDFTextBasedFieldAppearanceBuilder.DrawUnderlineBorder(AConstructor: TdxPDFXFormCommandConstructor);
begin
  DrawRectangularUnderlineBorder(AConstructor);
end;

procedure TdxPDFTextBasedFieldAppearanceBuilder.FillBackground(AConstructor: TdxPDFXFormCommandConstructor);
begin
  FillBackgroundRectangle(AConstructor, AConstructor.BoundingBox);
end;

procedure TdxPDFTextBasedFieldAppearanceBuilder.Rebuild(AConstructor: TdxPDFXFormCommandConstructor);
begin
  if FFontData <> nil then
    inherited Rebuild(AConstructor);
end;

function TdxPDFTextBasedFieldAppearanceBuilder.CalculateCenteredLineYOffset(const AClipRect: TdxPDFRectangle): Double;
begin
  Result := AClipRect.Bottom + (AClipRect.Height - FFontData.Metrics.GetLineSpacing(FFontSize)) / 2 +
    FFontData.Metrics.GetDescent(FFontSize);
end;

function TdxPDFTextBasedFieldAppearanceBuilder.GetTextWidth(const AText: string): Double;
begin
  Result := GetTextWidth(AText, FFontSize);
end;

function TdxPDFTextBasedFieldAppearanceBuilder.GetTextWidth(const AText: string; AFontSize: Double): Double;
begin
  Result := FFontData.GetTextWidth(AText, AFontSize, FField.TextState);
end;

function TdxPDFTextBasedFieldAppearanceBuilder.GetTextLineSpacing(AFontSize: Double): Double;
begin
  Result := FFontData.Metrics.GetLineSpacing(AFontSize);
end;

function TdxPDFTextBasedFieldAppearanceBuilder.GetTextHeight(AFontSize: Double; ALineCount: Integer): Double;
begin
  Result := GetTextLineSpacing(AFontSize) * Max(ALineCount, 1);
end;

procedure TdxPDFTextBasedFieldAppearanceBuilder.DrawTextBoxText(AConstructor: TdxPDFXFormCommandConstructor;
  const AOffset: TdxPointF; const AText: string);
var
  ARun: TdxPDFGlyphRun;
begin
  ARun := FFontData.ProcessString(AText, TdxPDFGlyphMappingFlags.mfNone, True);
  try
    AConstructor.StartTextLineWithOffsets(AOffset.X, AOffset.Y);
    AConstructor.ShowText(ARun.TextData, ARun.GlyphOffsets);
    FFontData.UpdateFont;
  finally
    ARun.Free;
  end;
end;

procedure TdxPDFTextBasedFieldAppearanceBuilder.EndDrawTextBox(AConstructor: TdxPDFXFormCommandConstructor);
begin
  AConstructor.EndText;
end;

procedure TdxPDFTextBasedFieldAppearanceBuilder.RemoveFont(AFont: TdxPDFCustomFont);
begin
  TdxPDFObjectAccess(FField).Repository.FontDataStorage.Delete(AFont);
end;

procedure TdxPDFTextBasedFieldAppearanceBuilder.StartDrawTextBox(AConstructor: TdxPDFXFormCommandConstructor;
  const AForeColor: TdxPDFColor);
begin
  RemoveFont(FFontData.Font);
  AConstructor.BeginText;
  if AForeColor.IsNull then
    AConstructor.AddCommands(FField.TextState.CommandsAsBytes)
  else
    AConstructor.SetColorForNonStrokingOperations(AForeColor);
  AConstructor.SetTextFont(FFontData.Font, FFontSize);
end;

{ TdxPDFSignatureAppearanceBuilder }

procedure TdxPDFSignatureAppearanceBuilder.CreateAppearance(AForm: TdxPDFXForm);
var
  AConstructor: TdxPDFCommandConstructor;
  AFormConstructor: TdxPDFXFormCommandConstructor;
  ARepository: TdxPDFDocumentRepository;
  ASubForm: TdxPDFXForm;
begin
  AConstructor := TdxPDFCommandConstructor.Create(AForm.Resources);
  try
    ARepository := TdxPDFObjectAccess(AForm).Repository;
    ASubForm := TdxPDFXForm.Create(ARepository, AForm.BBox);
    ARepository.AddSlot(ASubForm);

    AFormConstructor := TdxPDFXFormCommandConstructor.Create(ASubForm);
    try
      DrawFormContent(AFormConstructor);
      ASubForm.ReplaceCommands(AFormConstructor.Commands);
    finally
      AFormConstructor.Free;
    end;

    AConstructor.DrawForm(ASubForm, TdxPDFTransformationMatrix.Create);
    AForm.ReplaceCommands(AConstructor.Commands);
  finally
    AConstructor.Free;
  end;
end;

{ TdxPDFImageSignatureAppearanceBuilder }

constructor TdxPDFImageSignatureAppearanceBuilder.Create(AObject: TdxPDFXObject; const AImageSize: TSize;
  const AContentMatrix: TdxPDFTransformationMatrix; const AContentRect: TdxPDFRectangle; AFitMode: TcxImageFitMode);
begin
  inherited Create;
  FObject := AObject;
  FImageSize := AImageSize;
  FContentMatrix := AContentMatrix;
  FContentRect := AContentRect;
  FFitMode := AFitMode;
end;

procedure TdxPDFImageSignatureAppearanceBuilder.DrawFormContent(AConstructor: TdxPDFXFormCommandConstructor);
var
  ARect: TRect;
begin
  if not FContentMatrix.IsIdentity then
    AConstructor.ModifyTransformationMatrix(FContentMatrix);
  ARect := cxRectF(FContentRect.Left, FContentRect.Top, FContentRect.Right, FContentRect.Bottom).DeflateToTRect;
  ARect.NormalizeRect;
  ARect := cxGetImageRect(ARect, FImageSize, FFitMode);
  AConstructor.DrawImage(FObject, TdxPDFRectangle.Create(ARect.Left, ARect.Top, ARect.Right, ARect.Bottom));
end;

{ TdxPDFInkAnnotationAppearanceBuilder }

constructor TdxPDFInkAnnotationAppearanceBuilder.Create(AAnnotation: TdxPDFInkAnnotation);
begin
  inherited Create(AAnnotation);
end;

function TdxPDFInkAnnotationAppearanceBuilder.GetFormBBox: TdxPDFRectangle;
begin
  Result := FAnnotation.Rect;
end;

procedure TdxPDFInkAnnotationAppearanceBuilder.Rebuild(AConstructor: TdxPDFXFormCommandConstructor);
var
  AAnnotation: TdxPDFInkAnnotation;
  I: Integer;
begin
  inherited Rebuild(AConstructor);
  AAnnotation := GetAnnotation;
  AConstructor.SetColorForStrokingOperations(AAnnotation.Color);
  if AAnnotation.BorderStyle <> nil then
  begin
    AConstructor.SetLineWidth(AAnnotation.BorderStyle.Width);
    AConstructor.SetLineStyle(AAnnotation.BorderStyle.LineStyle);
  end;
  for I := 0 to AAnnotation.Inks.Count - 1 do
    AConstructor.DrawLines(AAnnotation.Inks[I]);
end;

function TdxPDFInkAnnotationAppearanceBuilder.GetAnnotation: TdxPDFInkAnnotation;
begin
  Result := TdxPDFInkAnnotation(FAnnotation);
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxPDFTextAnnotationAppearanceBuilder.IconAppearanceDictionary;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxPDFTextAnnotationAppearanceBuilder.Finalize;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
