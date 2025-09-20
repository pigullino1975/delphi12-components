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

unit dxPDFSelection;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  SysUtils, Windows, Classes, Messages, Forms, Controls, StdCtrls, Graphics, Generics.Defaults, Generics.Collections,
  dxCore, dxCoreClasses, cxClasses, cxGeometry, cxGraphics, dxCoreGraphics, dxPDFCore, dxPDFBase, dxPDFTypes, dxPDFText,
  dxPDFDocument, dxPDFRecognizedObject;

const
  // HitTests bits
  hcTextHighlight = 8192;
  hcTextSelection = 16384;

type
  TdxPDFMovementDirection = (mdLeft, mdDown, mdRight, mdUp, mdNextWord, mdPreviousWord, mdLineStart,
    mdLineEnd, mdDocumentStart, mdDocumentEnd);

  { TdxPDFCustomSelection }

  TdxPDFCustomSelection = class
  strict private
    FBackColor: TdxAlphaColor;
    FFrameColor: TdxAlphaColor;
  protected
    function Contains(const APosition: TdxPDFPagePoint): Boolean; virtual;
    function GetHitCode: Integer; virtual; abstract;
    function Same(AValue: TdxPDFCustomSelection): Boolean; virtual;
  public
    constructor Create(ABackColor, AFrameColor: TdxAlphaColor); virtual;

    property BackColor: TdxAlphaColor read FBackColor;
    property FrameColor: TdxAlphaColor read FFrameColor;

    property HitCode: Integer read GetHitCode;
  end;

  { TdxPDFImageSelection }

  TdxPDFImageSelection = class(TdxPDFCustomSelection)
  strict private
    FClipRect: TdxRectF;
    FID: string;
    FImageBounds: TdxPDFPageRect;
    FViewer: TObject;
    //
    function GetBitmap: TBitmap;
    function GetBounds: TdxRectF;
    function GetClipBounds: TdxRectF;
    function GetPageIndex: Integer;
    //
    function ConvertToRotationAngle(AAngle: Integer): TcxRotationAngle;
    procedure CalculateRendererParameters(APage: TdxPDFPage; AScale: Single; out APageSize: TPoint; out AClipRect: TdxRectF);
  protected
    function Contains(const APosition: TdxPDFPagePoint): Boolean; override;
    function GetHitCode: Integer; override;
    function Same(AValue: TdxPDFCustomSelection): Boolean; override;
    //
    function GetImageBitmap: TcxBitmap;
    property PageIndex: Integer read GetPageIndex;
  public
    constructor Create(AViewer: TObject; ABackColor, AFrameColor: TdxAlphaColor; const AID: string;
      const ABounds: TdxPDFPageRect; const AClipRect: TdxRectF); reintroduce;
    //
    property Bitmap: TBitmap read GetBitmap;
    property Bounds: TdxRectF read GetBounds;
  end;

  { TdxPDFCustomHighlight }

  TdxPDFTextHighlight = class(TdxPDFCustomSelection)
  strict private
    FRects: TdxPDFIntegerObjectDictionary<TdxPDFRectFList>;
    FPages: TdxPDFPageList;
    FRanges: TdxPDFPageTextRanges;

    function GetPageRects(APageIndex: Integer): TdxPDFRectFList; overload;
    procedure AddLineRects(APageRects: TdxPDFRectFList; APageLine: TdxPDFTextLine;
      const AStartPosition, AEndPosition: TdxPDFPageTextPosition; var AContainsEndOfLine: Boolean);
    procedure AddPageRects(ARects: TdxPDFRectFList; ALines: TdxPDFTextLineList);
    procedure AddRects(APageIndex: Integer; ARects: TdxPDFRectFList);
  strict protected
    function Contains(const APosition: TdxPDFPagePoint): Boolean; override;
    function GetHitCode: Integer; override;
    function Same(AValue: TdxPDFCustomSelection): Boolean; override;

    property Pages: TdxPDFPageList read FPages;
  protected
    function Exclude(const ARange: TdxPDFPageTextRange): Boolean;

    property Ranges: TdxPDFPageTextRanges read FRanges;
    property PageRects[APageIndex: Integer]: TdxPDFRectFList read GetPageRects;
  public
    constructor Create(ABackColor, AFrameColor: TdxAlphaColor; APages: TdxPDFPageList;
      const ARanges: TdxPDFPageTextRanges); reintroduce;
    destructor Destroy; override;
  end;

  { TdxPDFTextSelection }

  TdxPDFTextSelection = class(TdxPDFTextHighlight)
  strict private
    FConverted: Boolean;
    FText: string;
    function GetText: string;
  protected
    function GetHitCode: Integer; override;
  public
    property Text: string read GetText;
  end;

  TdxPDFDocumentCaretViewData = record
    Angle: Single;
    Height: Single;
    TopLeft: TdxPointF;
  end;

  TdxPDFDocumentCaret = record
    Position: TdxPDFTextPosition;
    StartCoordinates: TdxPointF;
    ViewData: TdxPDFDocumentCaretViewData;
  end;

  { TdxPDFDocumentCaretHelper }

  TdxPDFDocumentCaretHelper = record helper for TdxPDFDocumentCaret
  public
    class function Create(const APosition: TdxPDFTextPosition; const AViewData: TdxPDFDocumentCaretViewData;
      const AStartCoordinates: TdxPointF): TdxPDFDocumentCaret; static;
    class function Invalid: TdxPDFDocumentCaret; static;
    function IsValid: Boolean;
    function Same(const AValue: TdxPDFDocumentCaret): Boolean;
  end;

  { TdxPDFDocumentCaretViewDataHelper }

  TdxPDFDocumentCaretViewDataHelper = record helper for TdxPDFDocumentCaretViewData
  public
    class function Create(const ATopLeft: TdxPointF; AHeight, AAngle: Single): TdxPDFDocumentCaretViewData; static;
    class function Invalid: TdxPDFDocumentCaretViewData; static;
    function Same(const AValue: TdxPDFDocumentCaretViewData): Boolean;
  end;

  { TdxPDFViewerClickController }

  TdxPDFViewerClickController = class
  strict private const
    DoubleClickSize: TSize = (cx: 4; cy: 4);
  strict private
    FClickCount: Integer;
    FDoubleClickTime: Integer;
    FLastButton: TMouseButton;
    FLastClickPoint: TPoint;
    FLastClickTime: Int64;
    //
    function DateTimeToMilliseconds(const ADateTime: TDateTime): Int64;
  public
    constructor Create;
    //
    procedure Click(AButton: TMouseButton; X, Y: Integer);
    //
    property ClickCount: Integer read FClickCount;
  end;

implementation

uses
  Types, Math, dxTypeHelpers, cxFormats, cxControls, dxGDIPlusClasses, dxPDFUtils, dxPDFDocumentViewer,
  dxPDFCommandInterpreter;

const
  dxThisUnitName = 'dxPDFSelection';

type
  TdxPDFDocumentAccess = class(TdxPDFDocument);
  TdxPDFDocumentCustomViewerAccess = class(TdxPDFDocumentCustomViewer);
  TdxPDFImageAccess = class(TdxPDFImage);
  TdxPDFPagesAccess = class(TdxPDFPages);
  TdxPDFTextLineAccess = class(TdxPDFTextLine);
  TdxPDFTextWordPartAccess = class(TdxPDFTextWordPart);

  { TdxPDFImageRenderer }

  TdxPDFImageRenderer = class(TdxPDFGraphicsDevice)
  protected
    procedure BeginText; override;
    procedure ClipPaths; override;
    procedure DrawShading(AShading: TdxPDFCustomShading); override;
    procedure DrawString(const AData: TdxPDFStringData); override;
    procedure EndText; override;
    procedure InitializeClipBounds(const ATopLeft, ABottomRight: TdxPointF); override;
    procedure FillPaths(AUseNonzeroWindingRule: Boolean); override;
    procedure SetTextMatrix(const AMatrix: TdxPDFTransformationMatrix); overload; override;
    procedure StrokePaths; override;
  end;

{ TdxPDFCustomSelection }

constructor TdxPDFCustomSelection.Create(ABackColor, AFrameColor: TdxAlphaColor);
begin
  inherited Create;
  FBackColor := ABackColor;
  FFrameColor := AFrameColor;
end;

function TdxPDFCustomSelection.Contains(const APosition: TdxPDFPagePoint): Boolean;
begin
  Result := False;
end;

function TdxPDFCustomSelection.Same(AValue: TdxPDFCustomSelection): Boolean;
begin
  Result := (AValue <> nil) and (HitCode = AValue.HitCode);
end;

{ TdxPDFImageSelection }

constructor TdxPDFImageSelection.Create(AViewer: TObject; ABackColor, AFrameColor: TdxAlphaColor;
  const AID: string; const ABounds: TdxPDFPageRect; const AClipRect: TdxRectF);
begin
  inherited Create(ABackColor, AFrameColor);
  FViewer := AViewer as TdxPDFDocumentCustomViewer;
  FID := AID;
  FImageBounds := ABounds;
  FClipRect := AClipRect;
end;

function TdxPDFImageSelection.Contains(const APosition: TdxPDFPagePoint): Boolean;
var
  R: TdxRectF;
begin
  R := cxRectAdjustF(Bounds);
  Result := (FImageBounds.PageIndex = APosition.PageIndex) and TdxPDFUtils.PtInRect(R, APosition.Point);
end;

function TdxPDFImageSelection.GetHitCode: Integer;
begin
  Result := hcImage;
end;

function TdxPDFImageSelection.Same(AValue: TdxPDFCustomSelection): Boolean;
var
  ASelection: TdxPDFImageSelection;
begin
  Result := inherited Same(AValue);
  if Result  then
  begin
    ASelection := AValue as TdxPDFImageSelection;
    Result := (AValue <> nil) and
      TdxPDFUtils.RectIsEqual(FImageBounds.Rect, ASelection.FImageBounds.Rect, 0.0001) and
      (FImageBounds.PageIndex = ASelection.FImageBounds.PageIndex) and
      TdxPDFUtils.RectIsEqual(Bounds, ASelection.Bounds, 0.0001);
  end;
end;

function TdxPDFImageSelection.GetImageBitmap: TcxBitmap;
const
  Precision = 0.1;
var
  AOriginalPageBitmap: TcxBitmap;
  ARenderer: TdxPDFImageRenderer;
  AParameters: TdxPDFRenderParameters;
  ADocument: TdxPDFDocument;
  APage: TdxPDFPage;
  APageSize: TPoint;
  AImageBounds: TdxPDFPageRect;
  AClipRect: TdxRectF;
  AScale: Single;
begin
  AImageBounds := FImageBounds;
  AScale := Bitmap.Width / AImageBounds.Rect.Width;
  ADocument := TdxPDFDocumentCustomViewerAccess(FViewer).Document;
  APage := TdxPDFPagesAccess(ADocument.Pages).List[AImageBounds.PageIndex];
  CalculateRendererParameters(APage, AScale, APageSize, AClipRect);
  AOriginalPageBitmap := TcxBitmap.CreateSize(APageSize.X, APageSize.Y);
  AParameters := TdxPDFRenderParameters.Create(TdxPDFDocumentAccess(ADocument).State);
  try
    AParameters.Angle := ConvertToRotationAngle(APage.RotationAngle);
    AParameters.Canvas := AOriginalPageBitmap.Canvas;
    AParameters.Rect := AOriginalPageBitmap.ClientRect;
    AParameters.ScaleFactor := AScale;
    AParameters.CancelCallback := nil;
    ARenderer := TdxPDFImageRenderer.Create;
    try
      ARenderer.ExportAndPack(APage, AParameters);
    finally
      ARenderer.Free;
    end;
    Result := TcxBitmap.CreateSize(AClipRect.DeflateToTRect);
    Result.Canvas.CopyRect(Result.ClientRect, AOriginalPageBitmap.Canvas, AClipRect.DeflateToTRect);
  finally
    AParameters.Free;
    AOriginalPageBitmap.Free;
  end;
end;

function TdxPDFImageSelection.GetBitmap: TBitmap;
var
  AImages: TdxPDFImageList;
  I: Integer;
begin
  Result := nil;
  AImages := TdxPDFDocumentCustomViewerAccess(FViewer).Document.PageInfo[FImageBounds.PageIndex].Images;
  for I := 0 to AImages.Count - 1 do
    if TdxPDFImageAccess(AImages[I]).GUID = FID then
    begin
      Result := AImages[I].Bitmap;
      Break;
    end;
end;

function TdxPDFImageSelection.GetBounds: TdxRectF;
begin
  if FClipRect <> dxNullRectF then
    Result := GetClipBounds
  else
    Result := FImageBounds.Rect;
end;

function TdxPDFImageSelection.GetClipBounds: TdxRectF;
begin
  if not TdxPDFUtils.Intersects(Result, FImageBounds.Rect, FClipRect) and (Result.Width > 0) and
    (Result.Height > 0) then
    Result := dxRectF(Result.Left, Result.Top, Result.Left + 1, Result.Bottom + 1);
end;

function TdxPDFImageSelection.GetPageIndex: Integer;
begin
  Result := FImageBounds.PageIndex;
end;

function TdxPDFImageSelection.ConvertToRotationAngle(AAngle: Integer): TcxRotationAngle;
begin
  Result := TdxPDFUtils.ConvertToRotationAngle(AAngle);
end;

procedure TdxPDFImageSelection.CalculateRendererParameters(APage: TdxPDFPage; AScale: Single;
  out APageSize: TPoint; out AClipRect: TdxRectF);
var
  R: TdxRectF;
  ATempPageSize: TPoint;
begin
  APageSize.X := Round(APage.Size.X * AScale);
  APageSize.Y := Round(APage.Size.Y * AScale);

  ATempPageSize := APageSize;
  if (APage.RotationAngle = 90) or (APage.RotationAngle = 270) then
    ATempPageSize := dxPointF(ATempPageSize.Y, ATempPageSize.X);

  AClipRect.Left := Bounds.Left * AScale;
  AClipRect.Right := Bounds.Right * AScale;
  AClipRect.Top := ATempPageSize.Y - Bounds.Bottom * AScale;
  AClipRect.Height := Bounds.Height * AScale;

  R := cxRectUnion(AClipRect, TdxRectF.CreateSize(0, 0, APageSize.X, APageSize.Y));

  if (APage.RotationAngle = 90) or (APage.RotationAngle = 270) then
    APageSize := dxPointF(R.Height, R.Width)
  else
    APageSize := dxPointF(R.Width, R.Height);
end;

{ TdxPDFTextHighlight }

constructor TdxPDFTextHighlight.Create(ABackColor, AFrameColor: TdxAlphaColor; APages: TdxPDFPageList;
  const ARanges: TdxPDFPageTextRanges);
begin
  inherited Create(ABackColor, AFrameColor);
  FRects := TdxPDFIntegerObjectDictionary<TdxPDFRectFList>.Create([doOwnsValues]);
  FPages := APages;
  FRanges := ARanges;
end;

destructor TdxPDFTextHighlight.Destroy;
begin
  FreeAndNil(FRects);
  SetLength(FRanges, 0);
  inherited Destroy;
end;

function TdxPDFTextHighlight.Exclude(const ARange: TdxPDFPageTextRange): Boolean;
var
  I: Integer;
  AUpdatedRanges: TdxPDFPageTextRanges;
begin
  SetLength(AUpdatedRanges, 0);
  for I := Low(Ranges) to High(Ranges) do
    if not TdxPDFPageTextRange.Same(Ranges[I], ARange) then
      TdxPDFTextUtils.AddRange(Ranges[I], AUpdatedRanges);
  Result := Length(AUpdatedRanges) < Length(Ranges);
  if Result then
  begin
    FRanges := AUpdatedRanges;
    FReeAndNil(FRects);
  end;
end;

function TdxPDFTextHighlight.Contains(const APosition: TdxPDFPagePoint): Boolean;
var
  I: Integer;
  ARects: TdxPDFRectFList;
begin
  ARects := PageRects[APosition.PageIndex];
  Result := (ARects <> nil) and (ARects.Count > 0);
  if Result then
    for I := 0 to ARects.Count - 1 do
    begin
      Result := TdxPDFUtils.PtInRect(ARects[I], APosition.Point);
      if Result then
        Break;
    end;
end;

function TdxPDFTextHighlight.GetHitCode: Integer;
begin
  Result := hcTextHighlight;
end;

function TdxPDFTextHighlight.Same(AValue: TdxPDFCustomSelection): Boolean;
var
  I: Integer;
  ATextSelection: TdxPDFTextSelection;
begin
  Result := AValue is TdxPDFTextSelection;
  if Result then
  begin
    ATextSelection := TdxPDFTextSelection(AValue);
    Result := inherited Same(ATextSelection) and (Length(Ranges) = Length(ATextSelection.Ranges));
    if Result then
      for I := 0 to Length(Ranges) - 1 do
      begin
        Result := TdxPDFPageTextRange.Same(Ranges[I], ATextSelection.Ranges[I]);
        if not Result then
          Break;
      end;
  end;
end;

function TdxPDFTextHighlight.GetPageRects(APageIndex: Integer): TdxPDFRectFList;
var
  I: Integer;
  AContentsEndOfLine: Boolean;
  ACurrentLine: TdxPDFTextLine;
  APage: TdxPDFPage;
  ARange: TdxPDFPageTextRange;
  ARects: TdxPDFRectFList;
begin
  if not FRects.TryGetValue(APageIndex, Result) then
  begin
    for I := Low(FRanges) to High(FRanges) do
    begin
      ARange := FRanges[I];
      if ARange.PageIndex = APageIndex then
      begin
        APage := FPages[ARange.PageIndex];
        if APage.RecognizedContent <> nil then
        begin
          ARects := TdxPDFRectFList.Create;
          if (ARange.StartPosition.WordIndex = 0) and (ARange.EndPosition.WordIndex = 0) or ARange.WholePage then
            AddPageRects(ARects, APage.RecognizedContent.TextLines)
          else
            for ACurrentLine in APage.RecognizedContent.TextLines do
            begin
              AddLineRects(ARects, ACurrentLine, ARange.StartPosition, ARange.EndPosition, AContentsEndOfLine);
              if AContentsEndOfLine then
                Break;
            end;
          AddRects(ARange.PageIndex, ARects);
        end;
      end;
    end;
    if not FRects.TryGetValue(APageIndex, Result) then
      Result := nil;
  end;
end;

procedure TdxPDFTextHighlight.AddLineRects(APageRects: TdxPDFRectFList; APageLine: TdxPDFTextLine;
  const AStartPosition, AEndPosition: TdxPDFPageTextPosition; var AContainsEndOfLine: Boolean);
var
  AFirstPartIndex: Integer;
  AHighlights: TList<TdxPDFOrientedRect>;
  ALastPart: TdxPDFTextWordPart;
  ALine: TdxPDFTextLineAccess;
  R: TdxPDFOrientedRect;
  AStart, AEnd: TdxPDFPageTextPosition;
begin
  AContainsEndOfLine := False;
  ALine := TdxPDFTextLineAccess(APageLine);
  if ALine.WordPartList.Count > 0 then
  begin
    AHighlights := nil;
    AContainsEndOfLine := ALine.PositionInLine(AEndPosition.WordIndex, AEndPosition.Offset);
    AFirstPartIndex := ALine.WordPartList[0].WordIndex;
    AEnd.WordIndex := IfThen(AContainsEndOfLine, AEndPosition.WordIndex - AFirstPartIndex, 0);
    AEnd.Offset := IfThen(AContainsEndOfLine, AEndPosition.Offset -
      TdxPDFTextWordPartAccess(ALine.WordPartList[AEnd.WordIndex]).WrapOffset, 0);
    if ALine.PositionInLine(AStartPosition.WordIndex, AStartPosition.Offset) then
    begin
      AStart.WordIndex := AStartPosition.WordIndex - AFirstPartIndex;
      AStart.Offset := AStartPosition.Offset - TdxPDFTextWordPartAccess(ALine.WordPartList[AStart.WordIndex]).WrapOffset;
      if AContainsEndOfLine then
        AHighlights := ALine.GetHighlights(AStart.WordIndex, AStart.Offset, AEnd.WordIndex, AEnd.Offset, True)
      else
        AHighlights := ALine.GetHighlights(AStart.WordIndex, AStart.Offset, True);
    end
    else
      if AContainsEndOfLine then
        AHighlights := ALine.GetHighlights(0, 0, AEnd.WordIndex, AEnd.Offset, True)
      else
      begin
        ALastPart := ALine.WordPartList.Last;
        if ((AStartPosition.WordIndex = 0) or (AStartPosition.WordIndex <= AFirstPartIndex)) and
          ((AEndPosition.WordIndex = 0) or (ALastPart.WordIndex - 1 <= AEndPosition.WordIndex)) then
          AHighlights := ALine.GetHighlights(0, 0, ALastPart.WordIndex - AFirstPartIndex,
            TdxPDFTextWordPartAccess(ALastPart).Characters.Count, True);
      end;
    if AHighlights <> nil then
    begin
      for R in AHighlights do
        if R.Width > 0 then
          APageRects.Add(R.RotatedRect);
      AHighlights.Free;
    end;
  end;
end;

procedure TdxPDFTextHighlight.AddPageRects(ARects: TdxPDFRectFList; ALines: TdxPDFTextLineList);
var
  ALine: TdxPDFTextLine;
begin
  for ALine in ALines do
    ARects.Add(TdxPDFTextLineAccess(ALine).Bounds.Rect);
end;

procedure TdxPDFTextHighlight.AddRects(APageIndex: Integer; ARects: TdxPDFRectFList);
var
  APageRects: TdxPDFRectFList;
begin
  if FRects.TryGetValue(APageIndex, APageRects) then
  begin
    APageRects.AddRange(ARects);
    ARects.Free;
  end
  else
    FRects.Add(APageIndex, ARects);
end;

{ TdxPDFTextSelection }

function TdxPDFTextSelection.GetHitCode: Integer;
begin
  Result := hcTextSelection;
end;

function TdxPDFTextSelection.GetText: string;
begin
  if not FConverted then
  begin
    FText := TdxPDFTextUtils.ConvertToString(Ranges, Pages);
    FConverted := True;
  end;
  Result := FText;
end;

{ TdxPDFDocumentCaretHelper }

class function TdxPDFDocumentCaretHelper.Create(const APosition: TdxPDFTextPosition;
  const AViewData: TdxPDFDocumentCaretViewData; const AStartCoordinates: TdxPointF): TdxPDFDocumentCaret;
begin
  Result.Position := APosition;
  Result.StartCoordinates := AStartCoordinates;
  Result.ViewData := AViewData;
end;

class function TdxPDFDocumentCaretHelper.Invalid: TdxPDFDocumentCaret;
begin
  Result.Position := TdxPDFTextPosition.Invalid;
  Result.StartCoordinates := dxNullPointF;
  Result.ViewData := TdxPDFDocumentCaretViewData.Invalid;
end;

function TdxPDFDocumentCaretHelper.IsValid: Boolean;
begin
  Result := (Position.IsValid) and (ViewData.Height > 0);
end;

function TdxPDFDocumentCaretHelper.Same(const AValue: TdxPDFDocumentCaret): Boolean;
begin
  Result := Position.Same(AValue.Position) and cxPointIsEqual(StartCoordinates, AValue.StartCoordinates) and
    ViewData.Same(AValue.ViewData);
end;

{ TdxPDFDocumentCaretViewDataHelper }

class function TdxPDFDocumentCaretViewDataHelper.Create(const ATopLeft: TdxPointF;
  AHeight, AAngle: Single): TdxPDFDocumentCaretViewData;
begin
  Result.Angle := AAngle;
  Result.Height := AHeight;
  Result.TopLeft := ATopLeft;
end;

class function TdxPDFDocumentCaretViewDataHelper.Invalid: TdxPDFDocumentCaretViewData;
begin
  Result.Angle := -1;
  Result.Height := -1;
  Result.TopLeft := dxNullPointF;
end;

function TdxPDFDocumentCaretViewDataHelper.Same(const AValue: TdxPDFDocumentCaretViewData): Boolean;
begin
  Result := (Angle = AValue.Angle) and cxPointIsEqual(TopLeft, AValue.TopLeft) and (Height = AValue.Height);
end;

{ TdxPDFViewerClickController }

constructor TdxPDFViewerClickController.Create;
begin
  inherited Create;
  FLastClickTime := DateTimeToMilliseconds(Now);
  FDoubleClickTime := GetDblClickInterval;
end;

function TdxPDFViewerClickController.DateTimeToMilliseconds(const ADateTime: TDateTime): Int64;
var
  ATimeStamp: TTimeStamp;
begin
  ATimeStamp := DateTimeToTimeStamp(ADateTime);
  Result := (ATimeStamp.Date * MSecsPerDay) + ATimeStamp.Time;
end;

procedure TdxPDFViewerClickController.Click(AButton: TMouseButton; X, Y: Integer);
var
  ANow: Int64;
begin
  ANow := DateTimeToMilliseconds(Now);
  if (ANow - FLastClickTime) > FDoubleClickTime then
    FClickCount := 0;
  FLastClickTime := ANow;
  FClickCount := IfThen(AButton <> FLastButton, 1, FClickCount + 1);
  if (Abs(FLastClickPoint.X - X) > DoubleClickSize.cx) or (Abs(FLastClickPoint.Y - Y) > DoubleClickSize.cy) or (FClickCount = 5) then
    FClickCount := 1;
  FLastButton := AButton;
  FLastClickPoint := cxPoint(X, Y);
end;

{ TdxPDFImageRenderer }

procedure TdxPDFImageRenderer.BeginText;
begin
// do nothing
end;

procedure TdxPDFImageRenderer.ClipPaths;
begin
// do nothing
end;

procedure TdxPDFImageRenderer.DrawShading(AShading: TdxPDFCustomShading);
begin
// do nothing
end;

procedure TdxPDFImageRenderer.DrawString(const AData: TdxPDFStringData);
begin
// do nothing
end;

procedure TdxPDFImageRenderer.EndText;
begin
// do nothing
end;

procedure TdxPDFImageRenderer.InitializeClipBounds(const ATopLeft, ABottomRight: TdxPointF);
begin
  FPageClippingRect := GetRenderParameters.Rect;
end;

procedure TdxPDFImageRenderer.FillPaths(AUseNonzeroWindingRule: Boolean);
begin
// do nothing
end;

procedure TdxPDFImageRenderer.SetTextMatrix(const AMatrix: TdxPDFTransformationMatrix);
begin
// do nothing
end;

procedure TdxPDFImageRenderer.StrokePaths;
begin
// do nothing
end;

end.
