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

unit dxPDFCore;

{$I cxVer.inc}

{.$DEFINE DXPDF_DONT_COMPRESS_STREAMS}

interface

uses
  System.UITypes,
  Types, SysUtils, Graphics, Windows, Classes, Controls, Generics.Defaults, Generics.Collections, dxCoreClasses,
  cxClasses, dxCoreGraphics, cxGraphics, cxGeometry, dxGDIPlusAPI, dxGDIPlusClasses, dxProtectionUtils, dxThreading,
  dxXMLDoc, dxX509Certificate, dxGenerics, dxPDFParser, dxPDFStreamFilter, dxPDFCharacterMapping, dxPDFBase,
  dxPDFTypes, dxPDFText, dxFontFile, dxPDFEncryption, dxPDFRecognizedObject, dxPDFImageUtils, dxCore;

const
  // HitTests bits
  hcAnnotationObject = 16; // for internal use
  hcAttachment = 8192;
  hcHyperlink = 8;
  hcText = 4;

  dxPDFDocumentFontCacheSize: Integer = 32; // for internal use
  dxPDFAllRecognitionObjects = [rmAnnotations, rmImages, rmText];

type
  TdxPDFBookmark = class;
  TdxPDFBookmarkList = class;
  TdxPDFCatalog = class;
  TdxPDFCommandList = class;
  TdxPDFCustomAction = class;
  TdxPDFCustomAnnotation = class;
  TdxPDFCustomColorSpace = class;
  TdxPDFCustomCommand = class;
  TdxPDFCustomCommandClass = class of TdxPDFCustomCommand;
  TdxPDFCustomDestination = class;
  TdxPDFCustomEncoding = class;
  TdxPDFCustomFont = class;
  TdxPDFCustomShading = class;
  TdxPDFCustomSoftMask = class;
  TdxPDFCustomTree = class;
  TdxPDFDocumentImage = class;
  TdxPDFDocumentImageDataStorage = class;
  TdxPDFDocumentRepository = class;
  TdxPDFFileAttachment = class;
  TdxPDFFileAttachmentList = class;
  TdxPDFFontDataStorage = class;
  TdxPDFXForm = class;
  TdxPDFGraphicsStateParameters = class;
  TdxPDFXFormGroup = class;
  TdxPDFHyperlink = class;
  TdxPDFHyperlinkList = class;
  TdxPDFInteractiveForm = class;
  TdxPDFInteractiveFormCustomFieldEditValue = class;
  TdxPDFInteractiveFormField = class;
  TdxPDFInteractiveFormFieldCollection = class;
  TdxPDFObject = class;
  TdxPDFObjectClass = class of TdxPDFObject;
  TdxPDFObjectList = class;
  TdxPDFOutline = class;
  TdxPDFOutlineItem = class;
  TdxPDFPage = class;
  TdxPDFPageData = class;
  TdxPDFPageList = class;
  TdxPDFPageTreeObject = class;
  TdxPDFPageTreeObjectList = class;
  TdxPDFReaderDictionary = class;
  TdxPDFRecognizedContent = class;
  TdxPDFResources = class;
  TdxPDFTilingPattern = class;
  TdxPDFWriterDictionary = class;
  TdxPDFWriterHelper = class;

  TdxPDFAnnotationAppearanceState = (asNormal, asRollover, asDown); // for internal use
  TdxPDFAnnotationFlags = (afNone = $000, afInvisible = $001, afHidden = $002, afPrint = $004, afNoZoom = $008,
    afNoRotate = $010, afNoView = $020, afReadOnly = $040, afLocked = $080, afToggleNoView = $100, afLockedContents = $200); // for internal use
  TdxPDFAnnotationHighlightingMode = (ahmNone, ahmInvert, ahmOutline, ahmPush, ahmToggle); // for internal use
  TdxPDFAssociatedFileRelationship = (frSource, frData, frAlternative, frSupplement, frEncryptedPayload, frUnspecified);
  {$SCOPEDENUMS ON}
  TdxPDFBorderStyle = (bsSolid, bsDot, bsDash, bsDashDot, bsDashDotDot, bsBeveled, bsInset, bsUnderline);
  {$SCOPEDENUMS OFF}
  TdxPDFButtonStyle = (bfsCircle, bfsCheck, bfsStar, bfsCross, bfsDiamond, bfsSquare);
  TdxPDFInteractiveFormFieldFlags = (ffNone = $0000000, ffReadOnly = $0000001, ffRequired = $0000002,
    ffNoExport = $0000004, ffMultiLine = $0001000, ffPassword = $0002000, ffNoToggleToOff = $0004000,
    ffRadio = $0008000, ffPushButton = $0010000, ffCombo = $0020000, ffEdit = $0040000, ffSort = $0080000,
    ffFileSelect = $0100000, ffMultiSelect = $0200000, ffDoNotSpellCheck = $0400000, ffDoNotScroll = $0800000,
    ffComb = $1000000, ffRichText = $2000000, ffRadiosInUnison = $2000000, ffCommitOnSelChange = $4000000); // for internal use
  TdxPDFDocumentChange = (dcModified, dcData, dcLayout, dcAttachments, dcOutlines, dcInteractiveLayer); // for internal use
  TdxPDFDocumentChanges = set of TdxPDFDocumentChange; // for internal use
  TdxPDFDocumentImageSMaskInDataType = (dtNone = 0, dtFromImage = 1, dtFromImagePreBlended = 2);
  TdxPDFTargetMode = (tmXYZ, tmFit, tmFitHorizontally, tmFitVertically, tmFitRectangle, tmFitBBox, tmFitBBoxHorizontally,
    tmFitBBoxVertically); // for internal use
  TdxPDFTextJustify = (tjLeftJustified, tjCentered, tjRightJustified); // for internal use
  TdxPDFTilingType = (ttConstantSpacing, ttNoDistortion, ttFasterTiling); // for internal use

  TdxPDFPageForEachAnnotationProc = reference to procedure(AAnnotation: TdxPDFCustomAnnotation); // for internal use
  TdxPDFInteractiveFormFieldEditValueChangingEvent = procedure(const AOldValue, ANewValue: string; var AAccept: Boolean) of object;

  TdxPDFDeferredObjectInfo = record // for internal use
    Key: string;
    Name: string;
    Number: Integer;
    RawObject: TdxPDFBase;
  end;

  TdxPDFExportParameters = class // for internal use
  strict private
    FDocumentState: TObject;
  public
    Angle: TcxRotationAngle;
    Annotations: TdxPDFReferencedObjects;
    Bounds: TdxRectF;
    CancelCallback: TdxTaskCancelCallback;
    ScaleFactor: Single;

    constructor Create; overload;
    constructor Create(AState: TObject); overload;
    function IsCanceled: Boolean;

    property DocumentState: TObject read FDocumentState;
  end;

  { TdxPDFFontRegistratorParameters }

  TdxPDFFontRegistratorParameters = record // for internal use
  strict private
    FIsItalic: Boolean;
    FName: string;
    FWeight: Integer;
  public
    class function Create(const AName: string; AWeight: Integer; AIsItalic: Boolean): TdxPDFFontRegistratorParameters; static;
    property IsItalic: Boolean read FIsItalic;
    property Name: string read FName;
    property Weight: Integer read FWeight;
  end;

  { TdxPDFFontDescriptorData }

  TdxPDFFontDescriptorData = record // for internal use
  strict private
    FAscent: Double;
    FBBox: TdxRectF;
    FBold: Boolean;
    FDescent: Double;
    FFontFlags: Integer;
    FItalicAngle: Double;
    FNumGlyphs: Integer;
  public
    class function Create(AFontMetrics: TdxFontFileFontMetrics; AFontFlags: Integer;
      const AItalicAngle: Double; ABold: Boolean; ANumGlyphs: Integer): TdxPDFFontDescriptorData; static;

    property Ascent: Double read FAscent;
    property BBox: TdxRectF read FBBox;
    property Bold: Boolean read FBold;
    property Descent: Double read FDescent;
    property Flags: Integer read FFontFlags;
    property ItalicAngle: Double read FItalicAngle;
    property NumGlyphs: Integer read FNumGlyphs;
  end;

  { TdxPDFDestinationInfo }

  TdxPDFDestinationInfo = class(TdxPDFReferencedObject) // for internal use
  strict private
    FDestination: TdxPDFCustomDestination;
    FName: string;
    procedure SetDestination(const AValue: TdxPDFCustomDestination);
  public
    constructor Create; overload;
    constructor Create(ADestination: TdxPDFCustomDestination); overload;
    constructor Create(const AName: string); overload;
    destructor Destroy; override;

    function GetDestination(ACatalog: TdxPDFCatalog; AInternal: Boolean): TdxPDFCustomDestination;
    function Write(AHelper: TdxPDFWriterHelper): TdxPDFBase;

    property Name: string read FName;
  end;

 { TdxPDFTarget }

  TdxPDFTarget = record // for internal use
  strict private
    FHeight: Double;
    FMode: TdxPDFTargetMode;
    FPageIndex: Integer;
    FWidth: Double;
    FX: Single;
    FY: Single;
    FZoom: Single;
  public
    class function Create(APageIndex: Integer; X, Y, AZoom: Single): TdxPDFTarget; overload; static;
    class function Create(AMode: TdxPDFTargetMode; APageIndex: Integer): TdxPDFTarget; overload; static;
    class function Create(AMode: TdxPDFTargetMode; APageIndex: Integer; const R: TdxRectF): TdxPDFTarget; overload; static;
    class function Create(AMode: TdxPDFTargetMode; APageIndex: Integer; X, Y: Single): TdxPDFTarget; overload; static;
    class function CreateEx(AMode: TdxPDFTargetMode; APageIndex: Integer; X, Y, AWidth, AHeight, AZoom: Single): TdxPDFTarget; overload; static;
    class function Invalid: TdxPDFTarget; static;
    function IsValid: Boolean;

    property Height: Double read FHeight;
    property Mode: TdxPDFTargetMode read FMode;
    property PageIndex: Integer read FPageIndex;
    property Width: Double read FWidth;
    property X: Single read FX;
    property Y: Single read FY;
    property Zoom: Single read FZoom;
  end;

  { TdxPDFInteractiveOperation }

  TdxPDFInteractiveOperation = record // for internal use
  strict private
    FAction: TdxPDFCustomAction;
    FDestination: TdxPDFCustomDestination;
    function GetTarget: TdxPDFTarget;

    property Destination: TdxPDFCustomDestination read FDestination;
  public
    class function Create(AAction: TdxPDFCustomAction): TdxPDFInteractiveOperation; overload; static;
    class function Create(AAction: TdxPDFCustomAction; ADestination: TdxPDFCustomDestination): TdxPDFInteractiveOperation; overload; static;
    class function Invalid: TdxPDFInteractiveOperation; static;
    function IsValid: Boolean;

    property Action: TdxPDFCustomAction read FAction;
    property Target: TdxPDFTarget read GetTarget;
  end;

  { IdxPDFInteractivityController }

  IdxPDFInteractivityController = interface // for internal use
  ['{12BCE71F-D47A-4354-8049-A88730C9EDF3}']
    procedure GoToFirstPage;
    procedure GoToLastPage;
    procedure GoToNextPage;
    procedure GoToPrevPage;
    procedure OpenURI(const AURI: string);
    procedure ShowDocumentPosition(const ATarget: TdxPDFTarget);
  end;

   { IdxPDFCommandInterpreter }

  IdxPDFCommandInterpreter = interface // for internal use
  ['{0F9503DE-2E5A-4785-A6CE-8FC4B2F51D75}']
    function GetActualSize: TSize;
    function GetBounds: TdxRectF;
    function GetDeviceTransformationMatrix: TdxPDFTransformationMatrix;
    function GetRotationAngle: Single;
    function GetTransformMatrix: TdxPDFTransformationMatrix;

    function CreateTilingBitmap(APattern: TdxPDFTilingPattern; const ASize, AKeySize: TSize; const AColor: TdxPDFColor): TcxBitmap32;
    function TransformSize(const AMatrix: TdxPDFTransformationMatrix; const ABoundingBox: TdxPDFRectangle): TdxSizeF;

    procedure ExecuteCommand(ACommands: TdxPDFCommandList); overload;
    procedure ExecuteCommand(const AInterpreter: IdxPDFCommandInterpreter; ACommands: TdxPDFCommandList); overload;
    procedure UnknownCommand(const AName: string);

    // Drawing
    procedure AppendPathBezierSegment(const P2, AEndPoint: TdxPointF); overload;
    procedure AppendPathBezierSegment(const P1, P2, P3: TdxPointF); overload;
    procedure AppendPathLineSegment(const AEndPoint: TdxPointF);
    procedure AppendRectangle(X, Y, AWidth, AHeight: Double);
    procedure BeginPath(const AStartPoint: TdxPointF);
    procedure Clip(AUseNonzeroWindingRule: Boolean);
    procedure ClosePath;
    procedure ClipAndClearPaths;
    procedure DrawImage(AImage: TdxPDFDocumentImage);
    procedure DrawForm(AForm: TdxPDFXForm);
    procedure DrawShading(AShading: TdxPDFCustomShading);
    procedure DrawTransparencyGroup(AForm: TdxPDFXFormGroup);
    procedure FillPaths(AUseNonzeroWindingRule: Boolean);
    procedure SetColorForNonStrokingOperations(const AColor: TdxPDFColor);
    procedure SetColorForStrokingOperations(const AColor: TdxPDFColor);
    procedure SetColorSpaceForNonStrokingOperations(AColorSpace: TdxPDFCustomColorSpace);
    procedure SetColorSpaceForStrokingOperations(AColorSpace: TdxPDFCustomColorSpace);
    procedure SetFlatnessTolerance(AValue: Double);
    procedure SetLineCapStyle(ALineCapStyle: TdxPDFLineCapStyle);
    procedure SetLineJoinStyle(ALineJoinStyle: TdxPDFLineJoinStyle);
    procedure SetLineStyle(ALineStyle: TdxPDFLineStyle);
    procedure SetLineWidth(ALineWidth: Single);
    procedure StrokePaths;
    function TransformShadingPoint(APoint: TdxPointF): TdxPointF;
    // Text
    procedure BeginText;
    procedure EndText;
    procedure SetCharacterSpacing(ASpacing: Single);
    procedure SetMiterLimit(AMiterLimit: Single);
    procedure SetTextFont(AFont: TdxPDFCustomFont; AFontSize: Double);
    procedure SetTextLeading(ALeading: Double);
    procedure SetTextHorizontalScaling(AValue: Double);
    procedure SetTextMatrix(const AOffset: TdxPointF); overload;
    procedure SetTextMatrix(const AMatrix: TdxPDFTransformationMatrix); overload;
    procedure SetTextRenderingMode(AMode: TdxPDFTextRenderingMode);
    procedure SetTextRise(AValue: Double);
    procedure SetWordSpacing(AWordSpacing: Double);
    procedure DrawString(const AData: TBytes; const AOffsets: TDoubleDynArray);
    procedure MoveToNextLine;
    // Graphics State
    procedure ApplyGraphicsStateParameters(AParameters: TdxPDFGraphicsStateParameters);
    procedure UpdateTransformationMatrix(const AMatrix: TdxPDFTransformationMatrix);
    procedure SaveGraphicsState;
    procedure SetRenderingIntent(AValue: TdxPDFRenderingIntent);
    procedure RestoreGraphicsState;

    property ActualSize: TSize read GetActualSize;
    property Bounds: TdxRectF read GetBounds;
    property DeviceTransformMatrix: TdxPDFTransformationMatrix read GetDeviceTransformationMatrix;
    property RotationAngle: Single read GetRotationAngle;
    property TransformMatrix: TdxPDFTransformationMatrix read GetTransformMatrix;
  end;

  { IdxPDFFontProvider }

  IdxPDFFontProvider = interface
  ['{8FF3FD97-6D14-4192-BAFD-A12EC41CE90F}']
    function GetMatchingFont(const AFontFamily: string; AFontStyles: TFontStyles): TObject; overload;
    function GetMatchingFont(ASetTextFontCommand: TdxPDFCustomCommand): TObject; overload;
  end;

  { IdxPDFContext }

  IdxPDFContext = interface
  ['{52B18469-3C68-4E53-A4C1-F7D9BA7BC0BA}']
  end;

  { IdxPDFWriterContext }

  IdxPDFWriterContext = interface
  ['{233FA22A-9D8F-42C8-B938-F1B87FF8F53F}']
    function AllowPageParentReference: Boolean;
    function GetDestinationName(const AName: string): string;
    function GetObjectNumber(AObject: TdxPDFObject): Integer;

    function GetUniqueName(ATree: TdxPDFCustomTree; const AName: string): string;
    procedure AddDestinationName(const AName: string);
    procedure AddReference(ADictionary: TdxPDFWriterDictionary; AObject: TdxPDFObject; const ATypeKey, AKey: string);

    function FindColorSpaceName(const AName: string): string;
    function FindFontName(const AName: string): string;
    function FindFormFieldName(const AName: string): string;
    function FindGraphicsStateParameters(const AName: string): string;
    function FindPatternName(const AName: string): string;
    function FindShadingName(const AName: string): string;
    function FindXObjectName(const AName: string): string;
  end;

  TdxPDFShadingInfo = record // for internal use
    Graphics: TdxGPCanvas;
    Interpreter: IdxPDFCommandInterpreter;
    NeedDrawBackground: Boolean;
    Shading: TdxPDFCustomShading;
    Size: TdxSizeF;
    TransformMatrix: TdxPDFTransformationMatrix;
    UseTransparency: Boolean;
  end;

  TdxPDFFontInfo = record // for internal use
  strict private
    function GetFontLineSize: Single;
  public
    FontData: TObject;
    FontSize: Single;
    property FontLineSize: Single read GetFontLineSize;
  end;

  { IdxPDFShadingPainter }

  IdxPDFShadingPainter = interface // for internal use
  ['{07E917B6-A92E-4B0D-B5ED-2DB7C94B0182}']
    procedure Draw(const AShadingInfo: TdxPDFShadingInfo);
  end;

  { IdxPDFTillingPainter }

  IdxPDFTillingPainter = interface // for internal use
  ['{07E917B6-A92E-4B0D-B5ED-2DB7C94B0182}']
    function CreateTilingBitmap(APattern: TdxPDFTilingPattern; const ASize, AKeySize: TSize; const AColor: TdxPDFColor): TcxBitmap32;
    procedure Draw(const AShadingInfo: TdxPDFShadingInfo);
  end;

  { IdxPDFCodePointMapping }

  IdxPDFCodePointMapping = interface  // for internal use
  ['{610A2970-EF02-4556-A15B-EA43DADF4128}']
    function UpdateCodePoints(const ACodePoints: TSmallIntDynArray; AUseEmbeddedFontEncoding: Boolean): Boolean;
  end;

  { TdxPDFWriterArray }

  TdxPDFWriterArray = class(TdxPDFArray) // for internal use
  strict private
    FHelper: TdxPDFWriterHelper;
  public
    constructor Create(AHelper: TdxPDFWriterHelper);
    procedure AddReference(const AData: TdxPDFBase); overload;
    procedure AddReference(const AObject: TdxPDFObject); overload;
  end;

  { TdxPDFWriterDictionary }

  TdxPDFWriterDictionary = class(TdxPDFDictionary) // for internal use
  strict private
    FHelper: TdxPDFWriterHelper;
    FStreamData: TBytes;
    FStreamDataCanEncrypt: Boolean;
  protected
    procedure Write(AWriter: TdxPDFWriter); override;
    procedure WriteStream(AWriter: TdxPDFWriter); override;
  public
    constructor Create(AHelper: TdxPDFWriterHelper);
    procedure Add(const AKey: string; AEncoding: TdxPDFCustomEncoding); overload;
    procedure Add(const AKey: string; AMask: TdxPDFCustomSoftMask); overload;
    procedure Add(const AKey: string; AObject: TdxPDFCustomColorSpace); overload;
    procedure Add(const AKey: string; AObjectList: TdxPDFObjectList); overload;
    procedure Add(const AKey: string; const AColor: TdxPDFColor); overload;
    procedure Add(const AKey: string; const ADestinationInfo: TdxPDFDestinationInfo); overload;
    procedure Add(const AKey: string; const AList: TStringList); overload;
    procedure AddInline(const AKey: string; const ATree: TdxPDFCustomTree); overload;
    procedure AddInline(const AKey: string; AObject: TdxPDFObject); overload;
    procedure AddNameOrReference(const AKey: string; AObject: TdxPDFObject);
    procedure AddReference(const AKey: string; AData: TdxPDFBase); overload;
    procedure AddReference(const AKey: string; AObject: TdxPDFObject); overload;
    procedure AddReference(const AKey: string; const AData: TBytes; ASkipIfNull: Boolean = True); overload; override;
    procedure SetAppearance(AResources: TdxPDFResources; ACommands: TdxPDFCommandList);
    procedure SetStreamData(const AData: TBytes); overload;
    procedure SetStreamData(const AData: TBytes; ACanCompress, ACanEncrypt: Boolean); overload;
    procedure SetTextJustify(AValue: TdxPDFTextJustify);
  end;

  { TdxPDFWriterHelper }

  TdxPDFWriterHelper = class // for internal use
  strict private
    FContext: IdxPDFWriterContext;
    FEncryptionInfo: IdxPDFEncryptionInfo;
    FTemporaryObjects: TcxObjectList;
    //
    function GetEncryptionInfo: IdxPDFEncryptionInfo;
    function GetEncryptMetadata: Boolean;
  strict protected
    constructor CreateWithEmptyContext;
  public
    class function WriteInlineColorSpace(AColorSpace: TdxPDFCustomColorSpace): TdxPDFBase;
    constructor Create(const AContext: IdxPDFWriterContext; const AEncryptionInfo: IdxPDFEncryptionInfo);
    destructor Destroy; override;
    //
    function CreateArray: TdxPDFWriterArray;
    function CreateDictionary: TdxPDFWriterDictionary;
    function CreateIndirectObject(AData: TdxPDFBase): TdxPDFObject;
    function CreateStream(ADictionary: TdxPDFWriterDictionary; const AData: TBytes): TdxPDFObject; overload;
    function CreateStream(const AData: TBytes): TdxPDFObject; overload;
    function GetFontName(const AName: string): string;
    function GetDestinationName(const AName: string): string;
    function GetNameOrReference(AObject: TdxPDFObject): TdxPDFBase;
    function PrepareToWrite(AColorSpace: TdxPDFCustomColorSpace): TdxPDFBase; overload;
    function RegisterIndirectObject(AObject: TdxPDFObject): Integer;
    //
    property Context: IdxPDFWriterContext read FContext;
    property EncryptMetadata: Boolean read GetEncryptMetadata;
  end;

  { TdxPDFObject }

  TdxPDFObject = class(TdxPDFBase)
  strict private
    FLockCount: Integer;
    //
  strict protected
    FParent: TdxPDFObject;
    //
    function GetRepository: TdxPDFDocumentRepository; virtual;
  protected
    function GetObject(const AName: string; ASourceDictionary: TdxPDFDictionary; out AObject: TdxPDFBase): Boolean; // for internal use
    function Write(AHelper: TdxPDFWriterHelper): TdxPDFBase; reintroduce; overload; virtual;
    procedure CreateSubClasses; virtual; // for internal use
    procedure DestroySubClasses; virtual; // for internal use
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); virtual; // for internal use
    procedure Initialize; virtual; // for internal use
    procedure Read(ADictionary: TdxPDFReaderDictionary); virtual; // for internal use
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); reintroduce; overload; virtual;
    //
    function IsLocked: Boolean;
    procedure AppearanceChanged; virtual;
    procedure BeginUpdate; virtual;
    procedure CancelUpdate;
    procedure Changed(AChanges: TdxPDFDocumentChanges); virtual;
    procedure DataChanged;
    procedure EndUpdate; virtual;
    procedure LayoutChanged; virtual;
    procedure PerformBatchOperation(AProc: TProc);
    procedure PerformWithoutChanges(AProc: TProc);
    procedure RaiseWriteNotImplementedException;
    //
    property Parent: TdxPDFObject read FParent; // for internal use
    property Repository: TdxPDFDocumentRepository read GetRepository; // for internal use
  public
    class function GetTypeName: string; virtual; // for internal use
    constructor Create(AParent: TdxPDFObject); overload; virtual; // for internal use
    constructor CreateEx(ARepository: TdxPDFDocumentRepository); overload; // for internal use
    destructor Destroy; override;
  end;

  { TdxPDFAnnotationCallout }

  TdxPDFAnnotationCallout = class(TdxPDFObject)
  strict private
    FEndPoint: TdxPointF;
    FKneePoint: TdxPointF;
    FStartPoint: TdxPointF;
  protected
    function Write(AHelper: TdxPDFWriterHelper): TdxPDFBase; override;
    procedure Read(AArray: TdxPDFArray); reintroduce;
  public
    property EndPoint: TdxPointF read FEndPoint;
    property KneePoint: TdxPointF read FKneePoint;
    property StartPoint: TdxPointF read FStartPoint;
  end;

  { TdxPDFGlyphMapper }

  TdxPDFGlyphMapper = class // for internal use
  public
    function CreateGlyphRun: TdxPDFGlyphRun; virtual; abstract;
    function GetGlyphIndex(ACh: Char): Integer; virtual; abstract;
    function MapString(const S: string; AFlags: TdxPDFGlyphMappingFlags): TdxPDFGlyphMappingResult; virtual; abstract;
  end;

  { TdxPDFFullTrustGlyphMapper }

  TdxPDFFullTrustGlyphMapper = class(TdxPDFGlyphMapper) // for internal use
  strict private
    FCMapTables: TList<TdxFontFileCMapCustomFormatRecord>;
    FFactor: Single;
    FFontFile: TdxFontFile;
    FMappedGlyphsCache: TdxPDFIntegerIntegerDictionary;

    function MapStringWithoutCTL(const AStr: string; AFlags: TdxPDFGlyphMappingFlags): TdxPDFGlyphMappingResult;
  protected
    function IsWritingOrderControl(AChar: Char): Boolean;

    property FontFile: TdxFontFile read FFontFile;
  public
    constructor Create(AFontFile: TdxFontFile);
    destructor Destroy; override;

    function CreateGlyph(AGlyphIndex: Integer; ACh: Char; AWidth, AGlyphOffset: Double): TdxPDFGlyph; virtual; abstract;
    function CreateGlyphRun(const AGlyphs: TdxPDFGlyphList): TdxPDFGlyphRun; reintroduce; overload; virtual; abstract;

    class function GetCMapEntryPriority(AEntry: TdxFontFileCMapCustomFormatRecord; AIsSymbolic: Boolean): Integer;
    function GetGlyphIndex(ACharacter: Char): Integer; override;
    function MapString(const AStr: string; AFlags: TdxPDFGlyphMappingFlags): TdxPDFGlyphMappingResult; override;
  end;

  { TdxPDFEmbeddedGlyphMapper }

  TdxPDFEmbeddedGlyphMapper = class(TdxPDFFullTrustGlyphMapper) // for internal use
  public
    function CreateGlyphRun: TdxPDFGlyphRun; overload; override;
    function CreateGlyph(AGlyphIndex: Integer; ACh: Char; AWidth, AGlyphOffset: Double): TdxPDFGlyph; override;
    function CreateGlyphRun(const AGlyphs: TdxPDFGlyphList): TdxPDFGlyphRun; overload; override;
  end;

  { TdxPDFStreamObject }

  TdxPDFStreamObject = class(TdxPDFObject) // for internal use
  strict private
    FStream: TdxPDFStream;
    //
    procedure SetStream(const AValue: TdxPDFStream);
  strict protected
    function GetData: TBytes; virtual;
    function GetUncompressedData: TBytes; virtual;
  protected
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    function UncompressData(AFilters: TObject): TBytes;
    procedure SetStreamData(const AData: TBytes);
    procedure WriteData(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); virtual;
    //
    property Stream: TdxPDFStream read FStream write SetStream;
    property UncompressedData: TBytes read GetUncompressedData;
  end;

  { TdxPDFCustomEncoding }

  TdxPDFCustomEncoding = class(TdxPDFObject) // for internal use
  strict private
    FFontFileEncoding: TdxFontFileCustomEncoding;
  protected
    function Write(AHelper: TdxPDFWriterHelper): TdxPDFBase; override;
    procedure Initialize; override;
    //
    function GetFontFileEncoding: TdxFontFileCustomEncoding; virtual;
    function GetShortName: string; virtual;
    function UseShortWrite: Boolean; virtual;
  public
    function GetStringData(const ABytes: TBytes; const AGlyphOffsets: TDoubleDynArray): TdxPDFStringCommandData; virtual; abstract;
    function IsVertical: Boolean; virtual;
    function ShouldUseEmbeddedFontEncoding: Boolean; virtual; abstract;
    //
    property FontFileEncoding: TdxFontFileCustomEncoding read FFontFileEncoding;
  end;

  { TdxPDFCustomFontDescriptor }

  TdxPDFCustomFontDescriptorClass = class of TdxPDFCustomFontDescriptor;
  TdxPDFCustomFontDescriptor = class(TdxPDFObject) // for internal use
  strict private
    FAscent: Double;
    FAvgWidth: Double;
    FCapHeight: SmallInt;
    FCharSet: string;
    FCIDSetData: TBytes;
    FDescent: Double;
    FFlags: Integer;
    FFontBBox: TdxPDFRectangle;
    FFontFamily: string;
    FFontName: string;
    FFontStretch: TdxFontFileStretch;
    FFontWeight: Integer;
    FHasData: Boolean;
    FItalicAngle: Double;
    FLeading: Double;
    FMaxWidth: Double;
    FMissingWidth: Double;
    FStemH: Double;
    FStemV: Double;
    FXHeight: SmallInt;
    //
    function GetActualAscent: Double;
    function GetActualDescent: Double;
    function GetFont: TdxPDFCustomFont;
    function GetFontBBox: TdxRectF;
    function GetHeight: Double;
    function IsFontMetricsInvalid: Boolean;
    procedure ReadFontStretch(ADictionary: TdxPDFDictionary);
    procedure ReadFontWeight(ADictionary: TdxPDFDictionary);
  strict protected
    function GetOpenTypeFontFileData(ADictionary: TdxPDFReaderDictionary; ASuppressException: Boolean): TBytes;
    function GetStream(const AKey: string; ADictionary: TdxPDFReaderDictionary): TdxPDFStream;
    function WriteOpenTypeFontData(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary; const AData: TBytes): Boolean;
    //
    property Font: TdxPDFCustomFont read GetFont;
  protected
    class function GetNormalWeight: Integer;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Initialize; override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    procedure WriteFontFile(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); virtual;
  public
    class function GetTypeName: string; override;
    constructor Create(AFont: TdxPDFCustomFont); overload;
    constructor Create(const ADescriptorData: TdxPDFFontDescriptorData); overload;
    //
    property Ascent: Double read GetActualAscent write FAscent;
    property AvgWidth: Double read FAvgWidth write FAvgWidth;
    property CapHeight: SmallInt read FCapHeight;
    property Descent: Double read GetActualDescent write FDescent;
    property Flags: Integer read FFlags;
    property FontBBox: TdxRectF read GetFontBBox;
    property FontName: string read FFontName write FFontName;
    property FontStretch: TdxFontFileStretch read FFontStretch;
    property FontWeight: Integer read FFontWeight write FFontWeight;
    property HasData: Boolean read FHasData;
    property Height: Double read GetHeight;
    property ItalicAngle: Double read FItalicAngle;
    property Leading: Double read FLeading;
    property MaxWidth: Double read FMaxWidth;
    property MissingWidth: Double read FMissingWidth;
    property XHeight: SmallInt read FXHeight;
  end;

  { TdxPDFCIDSystemInfo }

  TdxPDFCIDSystemInfo = class(TdxPDFObject)
  strict private
    FOrdering: string;
    FRegistry: string;
    FSupplement: Integer;
  protected
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Initialize; override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    class function GetTypeName: string; override;
    property Ordering: string read FOrdering;
    property Registry: string read FRegistry;
    property Supplement: Integer read FSupplement;
  end;

  { TdxPDFCustomFont }

  TdxPDFCustomFontClass = class of TdxPDFCustomFont;
  TdxPDFCustomFont = class(TdxPDFObject) // for internal use
  strict private
    FAvgGlyphWidth: SmallInt;
    FCMap: TdxPDFCharacterMapping;
    FEncoding: TdxPDFCustomEncoding;
    FListeners: TInterfaceList;
    FMetrics: TdxPDFFontMetricsMetadata;
    FName: string;
    FSubsetName: string;
    FToUnicode: TdxPDFToUnicodeMap;
    FUniqueName: string;
    //
    function GetBoldWeight: Integer;
    function GetCMap: TdxPDFCharacterMapping;
    function GetItalic: Boolean;
    function GetFontBBox: TdxRectF;
    function GetFontProgramFacade: TObject;
    function GetForceBold: Boolean;
    function GetMaxGlyphWidth: Double;
    function GetMetrics: TdxPDFFontMetricsMetadata;
    function GetPitchAndFamily: Byte;
    function GetShouldUseEmbeddedFontEncoding: Boolean;
    function GetSubsetNameLength: Integer;
    function GetSubsetPrefixLength: Integer;
    function GetSymbolic: Boolean;
    function GetWeight: Integer;
    procedure SetCMap(const AValue: TdxPDFCharacterMapping);
    procedure ReadWidths(ADictionary: TdxPDFReaderDictionary);
  strict protected
    FFontDescriptor: TdxPDFCustomFontDescriptor;
    FFontProgramFacade: TObject;
    FWidths: TDoubleDynArray;
    //
    function HasFlag(AFlag: TdxFontFileFlags): Boolean;
    procedure SetEncoding(const AValue: TdxPDFCustomEncoding);
    procedure SetFontDescriptor(const AValue: TdxPDFCustomFontDescriptor);
    procedure ReadFontName;
    procedure RecreateFontProgramFacade;
  protected
    FBaseFont: string;
    //
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Initialize; override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    function CreateFontProgramFacade: TObject; virtual;
    function CreateToUnicode(const AData: TBytes): TdxPDFToUnicodeMap;
    function CreateValidatedMetrics: TdxPDFFontMetricsMetadata; virtual;
    function GetLineSpacingForMetrics: Double; virtual;
    function GetFontDescriptorClass: TdxPDFCustomFontDescriptorClass; virtual;
    function GetFontDescriptorDictionary(ADictionary: TdxPDFReaderDictionary): TdxPDFReaderDictionary; virtual;
    function GetFontDictionary(ADictionary: TdxPDFReaderDictionary): TdxPDFReaderDictionary; virtual;
    function GetHeightFactor: Double; virtual;
    function GetWidthFactor: Double; virtual;
    function HasSizeAttributes: Boolean; virtual;
    function NeedWriteFontDescriptor: Boolean; virtual;
    procedure DoReadWidths(ADictionary: TdxPDFReaderDictionary); virtual;
    procedure ReadEncoding(ASourceObject: TdxPDFBase); virtual;
    procedure ReadFontDescriptor(ADictionary: TdxPDFReaderDictionary); virtual;
    procedure ReadToUnicode(ADictionary: TdxPDFReaderDictionary); virtual;
    procedure AddListener(AListener: IdxPDFDocumentSharedObjectListener);
    procedure RemoveListener(AListener: IdxPDFDocumentSharedObjectListener);
  public
    class function GetSubTypeName: string; virtual;
    class function GetTypeName: string; override;
    function GetCharacterWidth(ACharCode: Integer): Double; virtual; abstract;
    function IsVertical: Boolean;
    //
    property AvgGlyphWidth: SmallInt read FAvgGlyphWidth;
    property BaseFont: string read FBaseFont;
    property BoldWeight: Integer read GetBoldWeight;
    property CMap: TdxPDFCharacterMapping read GetCMap write SetCMap;
    property Encoding: TdxPDFCustomEncoding read FEncoding;
    property FontBBox: TdxRectF read GetFontBBox;
    property FontDescriptor: TdxPDFCustomFontDescriptor read FFontDescriptor;
    property FontProgramFacade: TObject read GetFontProgramFacade;
    property ForceBold: Boolean read GetForceBold;
    property HeightFactor: Double read GetHeightFactor;
    property Italic: Boolean read GetItalic;
    property MaxGlyphWidth: Double read GetMaxGlyphWidth;
    property Metrics: TdxPDFFontMetricsMetadata read GetMetrics;
    property Name: string read FName;
    property PitchAndFamily: Byte read GetPitchAndFamily;
    property ShouldUseEmbeddedFontEncoding: Boolean read GetShouldUseEmbeddedFontEncoding;
    property Symbolic: Boolean read GetSymbolic;
    property UniqueName: string read FUniqueName;
    property Weight: Integer read GetWeight;
    property WidthFactor: Double read GetWidthFactor;
    property Widths: TDoubleDynArray read FWidths;
  end;

  { TdxPDFCustomColorSpace }

  TdxPDFCustomColorSpaceClass = class of TdxPDFCustomColorSpace; // for internal use
  TdxPDFCustomColorSpace = class(TdxPDFObject) // for internal use
  strict private
    FAlternateColorSpace: TdxPDFCustomColorSpace;
    FComponentCount: Integer;
    FIsInlineWriting: Boolean;
    FName: string;
    //
    procedure SetAlternateColorSpace(const AValue: TdxPDFCustomColorSpace);
    procedure SetComponentCount(const AValue: Integer);
  protected
    function Write(AHelper: TdxPDFWriterHelper): TdxPDFBase; override;
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Initialize; override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    function GetComponentCount: Integer; virtual;
    function GetDecodedImageScanlineSource(const ADecoratingSource: IdxPDFImageScanlineSource;
      const AImage: IdxPDFDocumentImage; AWidth: Integer): IdxPDFImageScanlineSource; virtual;
    function CanRead(ASize: Integer): Boolean; virtual;
    procedure CheckComponentCount; virtual;
    procedure InternalRead(AArray: TdxPDFArray); virtual;
    procedure InternalWrite(AHelper: TdxPDFWriterHelper; AArray: TdxPDFWriterArray); virtual;
    //
    procedure BeginInlineWriting;
    procedure EndInlineWriting;
    //
    property Name: string read FName write FName;
  public
    class function GetShortTypeName: string; virtual;
    //
    function AlternateTransform(const AColor: TdxPDFColor): TdxPDFColor; virtual;
    function CreateDefaultDecodeArray(ABitsPerComponent: Integer): TdxPDFRanges; virtual;
    function Transform(const AComponents: TDoubleDynArray): TDoubleDynArray; overload; virtual;
    function Transform(const AColor: TdxPDFColor): TdxPDFColor; overload;
    function Transform(const AImage: IdxPDFDocumentImage; const AData: IdxPDFImageScanlineSource;
      const AParameters: TdxPDFImageParameters): TdxPDFScanlineTransformationResult; overload; virtual;
    function Transform(const AData: IdxPDFImageScanlineSource; AWidth: Integer): TdxPDFScanlineTransformationResult; overload; virtual;
    //
    property AlternateColorSpace: TdxPDFCustomColorSpace read FAlternateColorSpace write SetAlternateColorSpace;
    property ComponentCount: Integer read GetComponentCount write SetComponentCount;
  end;

  { TdxPDFDeferredObject }

  TdxPDFDeferredObject = class(TdxPDFObject) // for internal use
  strict private
    FInfo: TdxPDFDeferredObjectInfo;
    FResolvedObject: TdxPDFObject;
    //
    function GetRawObject: TdxPDFBase;
    function GetResolvedObject: TdxPDFObject;
    procedure SetRawObject(const AValue: TdxPDFBase);
    procedure SetResolvedObject(const AValue: TdxPDFObject);
    procedure ResolveObject;
  protected
    procedure DestroySubClasses; override;
    //
    function IsResolved: Boolean;
    property RawObject: TdxPDFBase read GetRawObject write SetRawObject;
  public
    constructor Create(AParent: TdxPDFObject; const AInfo: TdxPDFDeferredObjectInfo); reintroduce; overload;
    constructor Create(AParent, AResolvedObject: TdxPDFObject); reintroduce; overload;

    property ResolvedObject: TdxPDFObject read GetResolvedObject write SetResolvedObject;
  end;

  { TdxPDFObjectList }

  TdxPDFObjectListClass = class of TdxPDFObjectList;
  TdxPDFObjectList = class(TdxPDFObject) // for internal use
  strict private
    FInternalObjects: TdxPDFStringReferencedObjectDictionary;
    FNames: TdxPDFNamedObjectDictionary;
    //
    function GetCount: Integer;
  protected
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure Read(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    class function GetTypePrefix: string; virtual;
    function GetTypeDictionaryKey: string; virtual;
    //
    function GetObject(const AName: string): TdxPDFObject;
    function GetUniqueName: string;
    function TryGetObjectName(const AObject: TdxPDFObject; out AName: string): Boolean;
    procedure AddDeferredObject(const AKey, AName: string; ARawObject: TdxPDFBase);
    procedure Clear;
    procedure InternalAdd(const AName: string; AObject: TdxPDFObject);
    procedure ReadList(ADictionary: TdxPDFReaderDictionary);
    procedure WriteList(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
    procedure ResolveObjects;
    property InternalObjects: TdxPDFStringReferencedObjectDictionary read FInternalObjects;
  public type
    TEnumProc = reference to procedure (AObject: TdxPDFObject);
  public
    function Add(AObject: TdxPDFObject): string;
    function AddReference(ANumber: Integer): string;
    function Contains(const AName: string): Boolean;
    procedure AssignTo(AList: TdxPDFObjectList);
    procedure Enum(AProc: TEnumProc);
    //
    property Count: Integer read GetCount;
  end;

  { TdxPDFFonts }

  TdxPDFFonts = class(TdxPDFObjectList) // for internal use
  protected
    class function GetTypePrefix: string; override;
    procedure Read(ADictionary: TdxPDFReaderDictionary); override;
  public
    class function GetTypeName: string; override;
    function GetFont(const AName: string): TdxPDFCustomFont;
  end;

  { TdxPDFGraphicsStateParameters }

  TdxPDFGraphicsStateParameters = class(TdxPDFObject) // for internal use
  strict private type
    TAssignedValue = (gspFlatnessTolerance, gspFont, gspFontSize, gspLineCapStyle, gspLineJoinStyle,
      gspLineStyle, gspLineWidth, gspMiterLimit, gspNonStrokingColorAlpha, gspRenderingIntent, gspSoftMask,
      gspSmoothnessTolerance, gspStrokingColorAlpha, gspTextKnockout, gspBlendMode);
    TAssignedValues = set of TAssignedValue;
  strict private
    FAssignedValues: TAssignedValues;
    FBlendMode: TdxPDFBlendMode;
    FFlatnessTolerance: Double;
    FFont: TdxPDFCustomFont;
    FFontSize: Double;
    FIsSoftMaskChanged: Boolean;
    FLineCapStyle: TdxPDFLineCapStyle;
    FLineJoinStyle: TdxPDFLineJoinStyle;
    FLineStyle: TdxPDFLineStyle;
    FLineWidth: Double;
    FMiterLimit: Double;
    FNonStrokingColorAlpha: Double;
    FRenderingIntent: TdxPDFRenderingIntent;
    FSmoothnessTolerance: Double;
    FSoftMask: TdxPDFCustomSoftMask;
    FStrokingColorAlpha: Double;
    FTextKnockout: Boolean;
    //
    procedure SetFont(const AValue: TdxPDFCustomFont);
    procedure SetLineStyle(const AValue: TdxPDFLineStyle);
    procedure SetLineWidth(const AValue: Double);
    procedure SetSoftMask(const AValue: TdxPDFCustomSoftMask);
  protected
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Initialize; override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    property AssignedValues: TAssignedValues read FAssignedValues;
    property IsSoftMaskChanged: Boolean read FIsSoftMaskChanged;
  public
    class function GetTypeName: string; override;
    //
    constructor Create; reintroduce;
    function Equals(AObject: TObject): Boolean; override;
    procedure Assign(AParameters: TdxPDFGraphicsStateParameters; ACheckAssignedValues: Boolean = True);
    //
    property BlendMode: TdxPDFBlendMode read FBlendMode write FBlendMode;
    property Font: TdxPDFCustomFont read FFont write SetFont;
    property FontSize: Double read FFontSize write FFontSize;
    property LineCapStyle: TdxPDFLineCapStyle read FLineCapStyle write FLineCapStyle;
    property LineJoinStyle: TdxPDFLineJoinStyle read FLineJoinStyle write FLineJoinStyle;
    property LineStyle: TdxPDFLineStyle read FLineStyle write SetLineStyle;
    property LineWidth: Double read FLineWidth write SetLineWidth;
    property MiterLimit: Double read FMiterLimit write FMiterLimit;
    property NonStrokingColorAlpha: Double read FNonStrokingColorAlpha write FNonStrokingColorAlpha;
    property FlatnessTolerance: Double read FFlatnessTolerance write FFlatnessTolerance;
    property RenderingIntent: TdxPDFRenderingIntent read FRenderingIntent write FRenderingIntent;
    property SmoothnessTolerance: Double read FSmoothnessTolerance write FSmoothnessTolerance;
    property SoftMask: TdxPDFCustomSoftMask read FSoftMask write SetSoftMask;
    property StrokingColorAlpha: Double read FStrokingColorAlpha write FStrokingColorAlpha;
    property TextKnockout: Boolean read FTextKnockout write FTextKnockout;
  end;

  { TdxPDFGraphicsStateParametersList }

  TdxPDFGraphicsStateParametersList = class(TdxPDFObjectList) // for internal use
  protected
    class function GetTypePrefix: string; override;
    function GetTypeDictionaryKey: string; override;
    procedure Read(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    class function GetTypeName: string; override;
    function GetParameters(const AName: string): TdxPDFGraphicsStateParameters;
    procedure Add(const AName: string; AStateParameters: TdxPDFGraphicsStateParameters); overload;
  end;

  { TdxPDFPageContentItem }

  TdxPDFPageContentItem = class(TdxPDFStreamObject) // for internal use
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFXObject }

  TdxPDFXObject = class(TdxPDFStreamObject) // for internal use
  strict private
    FLock: TRTLCriticalSection;
  protected
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoDraw(const AInterpreter: IdxPDFCommandInterpreter); virtual;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    class function GetTypeName: string; override;
    procedure Draw(const AInterpreter: IdxPDFCommandInterpreter);
  end;

  { TdxPDFXForm }

  TdxPDFXForm = class(TdxPDFXObject) // for internal use
  strict private
    FBBox: TdxPDFRectangle;
    FCommands: TdxPDFCommandList;
    FMatrix: TdxPDFTransformationMatrix;
    FResources: TdxPDFResources;
    FStreamRef: TdxPDFStream;
    FUseOwnResources: Boolean;
    //
    function GetActualStream: TdxPDFStream;
    function GetCommands: TdxPDFCommandList;
    procedure CheckFormType(ADictionary: TdxPDFDictionary);
    procedure SetMatrix(const AValue: TdxPDFTransformationMatrix);
    procedure SetResources(const AValue: TdxPDFResources);
  protected
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoDraw(const AInterpreter: IdxPDFCommandInterpreter); override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    procedure WriteData(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    function CreateEmptyResources: TdxPDFResources;
    function TryReleaseCircularReferencesAndFree: Boolean;
    //
    property ActualStream: TdxPDFStream read GetActualStream;
  public
    class function GetTypeName: string; override;
    constructor Create(ARepository: TdxPDFDocumentRepository; const ABBox: TdxPDFRectangle); reintroduce; overload;
    function GetTransformationMatrix(const ARect: TdxPDFRectangle): TdxPDFTransformationMatrix;
    procedure EnsureResources;
    procedure ReplaceCommands(const ACommandData: TBytes);

    property BBox: TdxPDFRectangle read FBBox write FBBox;
    property Commands: TdxPDFCommandList read GetCommands;
    property Matrix: TdxPDFTransformationMatrix read FMatrix write SetMatrix;
    property Resources: TdxPDFResources read FResources write SetResources;
  end;

  { TdxPDFCustomSoftMask }

  TdxPDFCustomSoftMask = class abstract(TdxPDFObject) // for internal use
  strict private
    FTransparencyFunction: TdxPDFObject;
    FTransparencyGroup: TdxPDFXFormGroup;
    //
    procedure SetTransparencyGroup(const AValue: TdxPDFXFormGroup);
    procedure SetTransparencyFunction(const AValue: TdxPDFObject);
  protected
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    class function GetTypeName: string; override;
    function IsSame(AMask: TdxPDFCustomSoftMask): Boolean; virtual;
    //
    property TransparencyGroup: TdxPDFXFormGroup read FTransparencyGroup write SetTransparencyGroup;
    property TransparencyFunction: TdxPDFObject read FTransparencyFunction write SetTransparencyFunction;
  end;

  { TdxPDFLuminositySoftMask }

  TdxPDFLuminositySoftMask = class(TdxPDFCustomSoftMask) // for internal use
  strict private
    FBackdropColor: TdxPDFColor;
  protected
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFAlphaSoftMask }

  TdxPDFAlphaSoftMask = class(TdxPDFCustomSoftMask) // for internal use
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFEmptySoftMask }

  TdxPDFEmptySoftMask = class(TdxPDFCustomSoftMask)
  protected
    function Write(AHelper: TdxPDFWriterHelper): TdxPDFBase; override;
  public
    class function GetTypeName: string; override;
    function IsSame(AMask: TdxPDFCustomSoftMask): Boolean; override;
  end;

  { TdxPDFTransparencyGroup }

  TdxPDFTransparencyGroup = class(TdxPDFObject) // for internal use
  strict private const
    ColorSpaceKey = 'CS';
    IsolatedKey = 'I';
    KnockoutKey = 'K';
    SubtypeKey = 'S';
  strict private
    FColorSpace: TdxPDFCustomColorSpace;
    FIsolated: Boolean;
    FKnockout: Boolean;
  protected
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    class function GetTypeName: string; override;
    property ColorSpace: TdxPDFCustomColorSpace read FColorSpace;
    property Isolated: Boolean read FIsolated;
    property Knockout: Boolean read FKnockout;
  end;

  { TdxPDFXFormGroup }

  TdxPDFXFormGroup = class(TdxPDFXForm) // for internal use
  strict private
    FGroup: TdxPDFTransparencyGroup;
    //
    function GetColorSpace: TdxPDFCustomColorSpace;
  protected
    procedure DestroySubClasses; override;
    procedure DoDraw(const AInterpreter: IdxPDFCommandInterpreter); override;
    procedure Read(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    property ColorSpace: TdxPDFCustomColorSpace read GetColorSpace;
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFDocumentImage }

  TdxPDFDocumentImage = class(TdxPDFXObject, IdxPDFDocumentImage) // for internal use
  strict private
    FBitsPerComponent: Integer;
    FColorKeyMask: TdxPDFRanges;
    FColorSpace: TdxPDFCustomColorSpace;
    FComponentCount: Integer;
    FDecodeRanges: TdxPDFRanges;
    FFilters: TdxPDFStreamFilters;
    FGUID: string;
    FHasMask: Boolean;
    FID: string;
    FIntent: TdxNullableValue<TdxPDFRenderingIntent>;
    FListeners: TInterfaceList;
    FMask: TdxPDFDocumentImage;
    FMatte: TDoubleDynArray;
    FNeedInterpolate: Boolean;
    FSize: TSize;
    FSMaskInData: TdxPDFDocumentImageSMaskInDataType;
    FSoftMask: TdxPDFDocumentImage;
    FStructParent: Integer;
    //
    function GetFilters: TdxPDFStreamFilters;
    procedure SetColorSpace(const AValue: TdxPDFCustomColorSpace);
    procedure SetFilters(const AValue: TdxPDFStreamFilters);
    procedure SetHasMask(const AValue: Boolean);
    procedure SetMask(const AValue: TdxPDFDocumentImage);
    procedure SetSoftMask(const AValue: TdxPDFDocumentImage);
    //
    function GetCompressedData: TBytes;
    function GetStreamData: TBytes;
    function HasValidStencilMask: Boolean;
    procedure CalculateComponentCount(ADictionary: TdxPDFDictionary);
    procedure ReadColorSpace(ADictionary: TdxPDFReaderDictionary);
    procedure ReadDecodeRanges(ADictionary: TdxPDFDictionary);
    procedure ReadIntent(ADictionary: TdxPDFDictionary);
    procedure ReadMask(ADictionary: TdxPDFReaderDictionary);
    procedure ReadMatte(ADictionary: TdxPDFDictionary);
    procedure ReadSoftMask(ADictionary: TdxPDFReaderDictionary);
    // IUnknown
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    //IdxPDFDocumentImage
    function GetBitsPerComponent: Integer;
    function GetColorKeyMask: TdxPDFRanges;
    function GetColorSpaceComponentCount: Integer;
    function GetDecodeRanges: TdxPDFRanges;
    function GetInterpolatedScanlineSource(const AData: IdxPDFImageScanlineSource;
      const AParameters: TdxPDFImageParameters): IdxPDFImageScanlineSource;
    function GetHeight: Integer;
    function GetWidth: Integer;
    function HasSMaskInData: Boolean;
  strict protected
    function GetUncompressedData: TBytes; override;
  protected
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoDraw(const AInterpreter: IdxPDFCommandInterpreter); override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Initialize; override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    procedure WriteAsInline(AWriter: TdxPDFWriter; AResources: TdxPDFResources; const AColorSpaceName: string);
    procedure WriteData(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    procedure WriteIntent(ADictionary: TdxPDFDictionary);
    procedure WriteFilters(ADictionary: TdxPDFDictionary; AUseShortNames: Boolean; AHelper: TdxPDFWriterHelper = nil);
    //
    function ApplyMask(const AMaskScanlineSource: IdxPDFImageScanlineSource; const AParameters: TdxPDFImageParameters;
      const AMatte: TDoubleDynArray): TdxPDFImageData;
    function GetActualData(const AParameters: TdxPDFImageParameters; AInvertRGB: Boolean): TdxPDFImageData;
    function GetActualSize(const AParameters: TdxPDFImageParameters): TdxPDFImageParameters;
    function GetAsBitmap: Graphics.TBitmap;
    function GetTransformedData(const AParameters: TdxPDFImageParameters): TdxPDFScanlineTransformationResult;
    function IsMask: Boolean;
    procedure AddListener(AListener: IdxPDFDocumentSharedObjectListener);
    procedure Read(AStream: TdxPDFStream); reintroduce; overload;
    procedure RemoveListener(AListener: IdxPDFDocumentSharedObjectListener);
    procedure ReadColorKeyMask(AArray: TdxPDFArray);
    //
    property Intent: TdxNullableValue<TdxPDFRenderingIntent> read FIntent;
    property Mask: TdxPDFDocumentImage read FMask write SetMask;
    property Matte: TDoubleDynArray read FMatte write FMatte;
    //
    property StreamData: TBytes read GetStreamData; // for internal use
    property UncompressedData; // for internal use
  public
    class function GetTypeName: string; override;
    //
    constructor Create(const AImageData: TBytes; const ASize: TSize; ABitsPerComponent: Integer); reintroduce; overload; // for internal use
    constructor Create(const AImageData: TBytes; const ASize: TSize; ABitsPerComponent: Integer;
      ADictionary: TdxPDFDictionary); reintroduce; overload; // for internal use
    //
    property GUID: string read FGUID; // for internal use
    property BitsPerComponent: Integer read GetBitsPerComponent; // for internal use
    property ColorKeyMask: TdxPDFRanges read GetColorKeyMask write FColorKeyMask; // for internal use
    property ColorSpace: TdxPDFCustomColorSpace read FColorSpace write SetColorSpace; // for internal use
    property DecodeRanges: TdxPDFRanges read FDecodeRanges write FDecodeRanges; // for internal use
    property Filters: TdxPDFStreamFilters read GetFilters write SetFilters; // for internal use
    property HasMask: Boolean read FHasMask write SetHasMask; // for internal use
    property Height: Integer read GetHeight; // for internal use
    property Size: TSize read FSize; // for internal use
    property SoftMask: TdxPDFDocumentImage read FSoftMask write SetSoftMask; // for internal use
    property Width: Integer read GetWidth; // for internal use
  end;

 { TdxPDFDocumentImageDataStorage }

  TdxPDFDocumentImageDataStorage = class(TcxIUnknownObject, IdxPDFDocumentSharedObjectListener) // for internal use
  strict private
    FCache: TdxPDFImageDataCache;
    FImageList: TList<TdxPDFDocumentImage>;
    FReferences: TdxPDFUniqueReferences;
    // IdxPDFDocumentSharedObjectListener
    procedure IdxPDFDocumentSharedObjectListener.DestroyHandler = ImageDestroyHandler;
    procedure ImageDestroyHandler(Sender: TdxPDFBase);

    procedure AddReference(AImage: TdxPDFDocumentImage);
    procedure RemoveListener(AImage: TdxPDFDocumentImage);
  public
    constructor Create(ALimit: Int64);
    destructor Destroy; override;

    function GetImage(AImage: TdxPDFDocumentImage; const AImageParameters: TdxPDFImageParameters): TdxPDFImageCacheItem;
    function TryGetReference(ANumber: Integer; out AImage: TdxPDFDocumentImage): Boolean;
    procedure Add(AImage: TdxPDFDocumentImage);
    procedure Clear;
  end;

  { TdxFontFamilyInfo }

  TdxFontFamilyInfo = class
  strict private
    FAdditionalStyles: TdxPDFStringStringDictionary;
    FSystemFontName: string;
  public
    constructor Create; overload;
    constructor Create(const ASystemFontName: string); overload;
    destructor Destroy; override;

    property AdditionalStyles: TdxPDFStringStringDictionary read FAdditionalStyles;
    property SystemFontName: string read FSystemFontName;
  end;

  { TdxFontFamilyInfos }

  TdxFontFamilyInfos = class
  strict private
    FAdditionalStylePattern: TStringDynArray;
    FFamilies: TStringList;
    FInfos: TdxPDFStringObjectDictionary<TdxFontFamilyInfo>;
    FInstalledFontCollection: TdxGPInstalledFontCollection;
    FSegoeUIPresent: Boolean;
    FStylePattern: TStringDynArray;

    function GetFamilies: TStringList;
    function GetFontStyle(const AFontName: string): string;
    function Normalize(const AName: string): string;
    function MatchPattern(const S: string; const APattern: string): string; overload;
    function MatchPattern(const S: string; const APatternArray: TStringDynArray): string; overload;
    function RemovePattern(const S: string; const APatternArray: TStringDynArray): string;
    procedure AddFamilyIfNotExists(const AKey, AValue: string);
    procedure PopulateInfos;
  protected
    property Families: TStringList read GetFamilies;
  public
    constructor Create;
    destructor Destroy; override;

    function ContainsBoldStyle(const AFontStyle: string): Boolean;
    function ContainsItalicStyle(const AFontStyle: string): Boolean;
    function ExtractAdditionalStyles(const AActualStyle: string): TStringDynArray;
    function GetFontFamily(const AFontName: string): string;
    function GetNormalizedFontFamily(const AFontName: string): string;
    function GetNormalizedFontStyle(const AFontName: string): string;
    function TryGetValue(const AFamilyName: string; out AInfo: TdxFontFamilyInfo): Boolean;

    function Contains(const AFamily: string): Boolean;
  end;

  { TdxPDFGDIFontSubstitutionHelper }

  TdxPDFGDIFontSubstitutionHelper = class // for internal use
  public const
    BoldWeight = 700;
    CourierNewFontName = 'Courier New';
    NormalWeight = 400;
    TimesNewRomanFontName = 'Times New Roman';
  strict private
    FFontFamilyInfos: TdxFontFamilyInfos;
    function GetFontStyle(AFont: TdxPDFCustomFont; out AFamily: string): string;
    function GetFontWeight(AFont: TdxPDFCustomFont): Integer;
  protected
    property FontFamilyInfos: TdxFontFamilyInfos read FFontFamilyInfos;
  public
    constructor Create;
    destructor Destroy; override;
    function GetSubstituteFontParameters(AFont: TdxPDFCustomFont): TdxPDFFontRegistratorParameters; overload;
    function GetSubstituteFontParameters(AFont: TdxPDFCustomFont;
      AFontFamilyFilter: TFunc<string, Boolean>): TdxPDFFontRegistratorParameters; overload;
  end;

  { TdxPDFFontProvider }

  TdxPDFFontProvider = class(TcxIUnknownObject, IdxPDFFontProvider)
  strict private
    FCache: TObject;
    FFolderName: string;
    FSubstitutionHelper: TdxPDFGDIFontSubstitutionHelper;

    procedure CalculateFontParameters(ACommand: TdxPDFCustomCommand; out AFontName: string;
      out AFontStyles: TFontStyles; var APitchAndFamily: Byte; var AIsEmptyFontName: Boolean);

    function GetFontFamilyInfos: TdxFontFamilyInfos;
    // IdxPDFFontProvider
    function GetMatchingFont(const AFontFamily: string; AStyles: TFontStyles): TObject; overload;
    function GetMatchingFont(AFontCommand: TdxPDFCustomCommand): TObject; overload;
  public
    constructor Create(const AFolderName: string);
    destructor Destroy; override;
    //
    function CreateSubstituteFontData(AFont: TdxPDFCustomFont): TdxPDFFontRegistrationData;
    procedure Clear;
    //
    property FontFamilyInfos: TdxFontFamilyInfos read GetFontFamilyInfos;
    property SubstitutionHelper: TdxPDFGDIFontSubstitutionHelper read FSubstitutionHelper;
  end;

  { TdxPDFFontDataStorage }

  TdxPDFFontDataStorage = class(TcxIUnknownObject, IdxPDFDocumentSharedObjectListener) // for internal use
  strict private
    FDictionary: TDictionary<TdxPDFCustomFont, TdxPDFFontRegistrationData>;
    FFolderName: string;
    FFontSubstitutionHelper: TdxPDFGDIFontSubstitutionHelper;
    FLastRegisteredFont: TdxPDFCustomFont;
    FLastRegisteredFontData: TdxPDFFontRegistrationData;
    FLock: TRTLCriticalSection;
    FQueue: TList<TdxPDFCustomFont>;
    FReferences: TdxPDFUniqueReferences;
    //
    procedure InternalAdd(AFont: TdxPDFCustomFont);
    procedure RemoveListener(AFont: TdxPDFCustomFont);
    // IdxPDFDocumentSharedObjectListener
    procedure IdxPDFDocumentSharedObjectListener.DestroyHandler = FontDestroyHandler;
    procedure FontDestroyHandler(Sender: TdxPDFBase);
  protected
    function CreateFontRegistrator(AFont: TdxPDFCustomFont): TObject;
    property FontSubstitutionHelper: TdxPDFGDIFontSubstitutionHelper read FFontSubstitutionHelper;
  public
    constructor Create(const ATempFolder: string; AFontSubstitutionHelper: TdxPDFGDIFontSubstitutionHelper);
    destructor Destroy; override;

    function Add(AFont: TdxPDFCustomFont): TdxPDFFontRegistrationData;
    function TryGetValue(ANumber: Integer; out AFont: TdxPDFCustomFont): Boolean;
    procedure Clear;
    procedure Delete(AFont: TdxPDFCustomFont);
  end;

  { TdxPDFXObjects }

  TdxPDFXObjects = class(TdxPDFObjectList) // for internal use
  protected
    class function GetTypePrefix: string; override;
  public
    class function GetTypeName: string; override;
    function GetXObject(const AName: string): TdxPDFXObject;
  end;

  { TdxPDFColorSpaces }

  TdxPDFColorSpaces = class(TdxPDFObjectList) // for internal use
  protected
    class function GetTypePrefix: string; override;
    procedure Read(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    class function GetTypeName: string; override;
    function GetColorSpace(const AName: string): TdxPDFCustomColorSpace;
  end;

  { TdxPDFCustomShading }

  TdxPDFCustomShading = class(TdxPDFObject) // for internal use
  strict private
    FBackgroundColor: TdxPDFColor;
    FBoundingBox: TdxPDFRectangle;
    FColorSpace: TdxPDFCustomColorSpace;
    FFunctions: TdxPDFReferencedObjects;
    FUseAntiAliasing: Boolean;
    //
    function CreateFunctions(ARawObject: TdxPDFBase): TdxPDFReferencedObjects;
    procedure ReadBackgroundColor(ARawObject: TdxPDFArray);
    procedure ReadColorSpace(ARawObject: TdxPDFBase);
    procedure ReadFunctions(ARawObject: TdxPDFBase);
    procedure WriteFunctions(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
  protected
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    class function GetShadingType: Integer; virtual;
    function GetPainter: IdxPDFShadingPainter; virtual; abstract;
    function GetDomainDimension: Integer; virtual;
    function IsFunctionRequired: Boolean; virtual;
  public
    class function GetTypeName: string; override;
    //
    function TransformFunction(const AArguments: TDoubleDynArray): TdxPDFColor;
    //
    property BackgroundColor: TdxPDFColor read FBackgroundColor;
    property BoundingBox: TdxPDFRectangle read FBoundingBox;
    property ColorSpace: TdxPDFCustomColorSpace read FColorSpace;
    property Functions: TdxPDFReferencedObjects read FFunctions;
    property UseAntiAliasing: Boolean read FUseAntiAliasing;
  end;

  { TdxPDFShadings }

  TdxPDFShadings = class(TdxPDFObjectList) // for internal use
  protected
    class function GetTypePrefix: string; override;
    procedure Read(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    class function GetTypeName: string; override;
    function GetShading(const AName: string): TdxPDFCustomShading;
  end;

  { TdxPDFCustomPattern }

  TdxPDFCustomPattern = class(TdxPDFObject) // for internal use
  strict private
    FMatrix: TdxPDFTransformationMatrix;
  protected
    class function GetPatternType: Integer; virtual;
    //
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    class function GetTypeName: string; override;
    //
    property Matrix: TdxPDFTransformationMatrix read FMatrix;
  end;

  { TdxPDFPatterns }

  TdxPDFPatterns = class(TdxPDFObjectList) // for internal use
  protected
    class function GetTypePrefix: string; override;
    procedure Read(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    class function GetTypeName: string; override;
    function GetPattern(const AName: string): TdxPDFCustomPattern;
  end;

  { TdxPDFShadingPattern }

  TdxPDFShadingPattern = class(TdxPDFCustomPattern) // for internal use
  strict private
    FGraphicsState: TdxPDFGraphicsStateParameters;
    FShading: TdxPDFCustomShading;
    //
    procedure SetGraphicsStateParameters(const AValue: TdxPDFGraphicsStateParameters);
    procedure SetShading(const AValue: TdxPDFCustomShading);
  protected
    class function GetPatternType: Integer; override;
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    property GraphicsState: TdxPDFGraphicsStateParameters read FGraphicsState write SetGraphicsStateParameters;
    property Shading: TdxPDFCustomShading read FShading write SetShading;
  end;

  { TdxPDFTilingPattern }

  TdxPDFTilingPattern = class(TdxPDFCustomPattern) // for internal use
  strict private
    FBoundingBox: TdxPDFRectangle;
    FColored: Boolean;
    FColoredPaintType: Integer;
    FCommands: TdxPDFCommandList;
    FResources: TdxPDFResources;
    FTilingType: TdxPDFTilingType;
    FUncoloredPaintType: Integer;
    FXStep: Double;
    FYStep: Double;
  protected
    class function GetPatternType: Integer; override;
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Initialize; override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    procedure ReplaceCommands(const AData: TBytes);
  public
    constructor Create(ARepository: TdxPDFDocumentRepository; const AMatrix: TdxPDFTransformationMatrix;
      const ABoundingBox: TdxPDFRectangle; const AXStep, AYStep: Double; AColored: Boolean);
    function CreateMatrix(AWidth: Integer; AHeight: Integer): TdxPDFTransformationMatrix;
    //
    property BoundingBox: TdxPDFRectangle read FBoundingBox;
    property Colored: Boolean read FColored;
    property Commands: TdxPDFCommandList read FCommands;
    property Resources: TdxPDFResources read FResources write FResources;
    property TilingType: TdxPDFTilingType read FTilingType;
    property XStep: Double read FXStep;
    property YStep: Double read FYStep;
  end;

  { TdxPDFResources }

  TdxPDFResources = class(TdxPDFObject) // for internal use
  strict private type
    TListInitProc = reference to procedure (AList: TdxPDFObjectList);
  strict private
    FColorSpaces: TdxPDFColorSpaces;
    FDictionary: TdxPDFReaderDictionary;
    FFonts: TdxPDFFonts;
    FGraphicStatesParametersList: TdxPDFGraphicsStateParametersList;
    FLock: TRTLCriticalSection;
    FID: string;
    FPatterns: TdxPDFPatterns;
    FShadings: TdxPDFShadings;
    FXObjects: TdxPDFXObjects;
    //
    function GetColorSpaces: TdxPDFColorSpaces;
    function GetFonts: TdxPDFFonts;
    procedure GetList(var AVariable; AClass: TdxPDFObjectListClass; const AKey: string; AInitProc: TListInitProc = nil);
    function GetGraphicStatesParametersList: TdxPDFGraphicsStateParametersList;
    function GetPatterns: TdxPDFPatterns;
    function GetShadings: TdxPDFShadings;
    function GetXObjects: TdxPDFXObjects;
    procedure InitXObjects(AList: TdxPDFObjectList);
    procedure SetColorSpaces(const AValue: TdxPDFColorSpaces);
    procedure SetDictionary(const AValue: TdxPDFReaderDictionary);
    procedure SetFonts(const AValue: TdxPDFFonts);
    procedure SetGraphicStatesParametersList(const AValue: TdxPDFGraphicsStateParametersList);
    procedure SetPatterns(const AValue: TdxPDFPatterns);
    procedure SetShadings(const AValue: TdxPDFShadings);
    procedure SetXObjects(const AValue: TdxPDFXObjects);
    procedure Clear;
  protected
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Initialize; override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    function GetParentResources: TdxPDFResources; virtual;
    //
    function InternalGetColorSpace(const AName: string): TdxPDFCustomColorSpace;
    function InternalGetFont(const AName: string): TdxPDFCustomFont;
    function InternalGetGraphicsStateParameters(const AName: string): TdxPDFGraphicsStateParameters;
    function InternalGetPattern(const AName: string): TdxPDFCustomPattern;
    function InternalGetShading(const AName: string): TdxPDFCustomShading;
    function InternalGetXObject(const AName: string): TdxPDFXObject;
    function TryGetColorSpaceName(AObject: TdxPDFCustomColorSpace; out AName: string): Boolean;
    function TryGetResourceName(AResources: TdxPDFObjectList; AObject: TdxPDFCustomColorSpace; out AName: string): Boolean;
    function AddGraphicsStateParameters(AParameters: TdxPDFGraphicsStateParameters): string;
    function AddPattern(APattern: TdxPDFCustomPattern): string;
    function AddXObject(AObject: TdxPDFXObject): string;
    procedure FillWidgetAppearanceResources(AResources: TdxPDFResources);

    property ColorSpaces: TdxPDFColorSpaces read GetColorSpaces write SetColorSpaces;
    property Dictionary: TdxPDFReaderDictionary read FDictionary write SetDictionary;
    property Fonts: TdxPDFFonts read GetFonts write SetFonts;
    property GraphicStatesParametersList: TdxPDFGraphicsStateParametersList read GetGraphicStatesParametersList
      write SetGraphicStatesParametersList;
    property ID: string read FID;
    property Patterns: TdxPDFPatterns read GetPatterns write SetPatterns;
    property Shadings: TdxPDFShadings read GetShadings write SetShadings;
    property XObjects: TdxPDFXObjects read GetXObjects write SetXObjects;
  public
    class function GetTypeName: string; override;
    function AddFont(AFont: TdxPDFCustomFont): string;
    function GetColorSpace(const AName: string): TdxPDFCustomColorSpace; virtual;
    function GetFont(const AName: string): TdxPDFCustomFont; virtual;
    function GetGraphicsStateParameters(const AName: string): TdxPDFGraphicsStateParameters; virtual;
    function GetPattern(const AName: string): TdxPDFCustomPattern; virtual;
    function GetShading(const AName: string): TdxPDFCustomShading; virtual;
    function GetXObject(const AName: string): TdxPDFXObject; virtual;
    function GetProperties(const AName: string): TdxPDFCustomProperties; virtual;
    procedure Pack;
  end;

  { TdxPDFPageContents }

  TdxPDFPageContents = class(TdxPDFStreamObject) // for internal use
  strict private
    FCommands: TdxPDFCommandList;
    FContentList: TdxPDFReferencedObjects;
    //
    function GetCommandCount: Integer;
    function GetCommandsData: TBytes;
    function GetResources: TdxPDFResources;
    procedure ReadItem(AStream: TdxPDFStream);
    procedure ReadContentList(ADictionary: TdxPDFReaderDictionary; AContentObject: TdxPDFBase);
  protected
    function GetData: TBytes; override;
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure Read(ADictionary: TdxPDFReaderDictionary); override;
    procedure WriteData(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    procedure ClearCommands;
    procedure PopulateCommands(AResources: TdxPDFResources);
    procedure ReplaceCommands(const AData: TBytes);
    //
    property CommandCount: Integer read GetCommandCount;
    property Commands: TdxPDFCommandList read FCommands;
    property CommandsData: TBytes read GetCommandsData;
    property ContentList: TdxPDFReferencedObjects read FContentList;
    property Resources: TdxPDFResources read GetResources;
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFPageData }

  TdxPDFPageData = class(TdxPDFObject) // for internal use
  strict private
    FAnnotations: TdxPDFReferencedObjects;
    FAnnotationsLoaded: Boolean;
    FContents: TdxPDFPageContents;
    FDictionary: TdxPDFReaderDictionary;
    FTransparencyGroup: TdxPDFTransparencyGroup;
    //
    function GetAnnotations: TdxPDFReferencedObjects;
    function GetCommands: TdxPDFCommandList;
    function GetCommandsData: TBytes;
    function GetPage: TdxPDFPage;
    function GetResources: TdxPDFResources;
    procedure DoForEachAnnotation(AProc: TdxPDFPageForEachAnnotationProc; AWidgetOnly: Boolean);
    procedure SetContents(const AValue: TdxPDFPageContents);
    procedure ReadAnnotations;
    procedure ReadGroup(ADictionary: TdxPDFReaderDictionary);
    procedure WriteAnnotations(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
  protected
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Initialize; override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    property Contents: TdxPDFPageContents read FContents write SetContents;
    property Page: TdxPDFPage read GetPage;
    property Resources: TdxPDFResources read GetResources;
    property TransparencyGroup: TdxPDFTransparencyGroup read FTransparencyGroup;
  public
    class function GetTypeName: string; override;
    procedure ClearCommands;
    procedure ExtractCommands;
    procedure ForEachAnnotation(AProc: TdxPDFPageForEachAnnotationProc);
    procedure ForEachWidgetAnnotation(AProc: TdxPDFPageForEachAnnotationProc);
    procedure ReplaceCommands(const AData: TBytes);
    //
    property Annotations: TdxPDFReferencedObjects read GetAnnotations;
    property AnnotationsLoaded: Boolean read FAnnotationsLoaded;
    property Commands: TdxPDFCommandList read GetCommands;
    property CommandsData: TBytes read GetCommandsData;
  end;

  { TdxPDFPageTreeObject }

  TdxPDFPageTreeObject = class(TdxPDFObject) // for internal use
  strict private
    FArtBox: TdxRectF;
    FBleedBox: TdxRectF;
    FTrimBox: TdxRectF;
    FResources: TdxPDFResources;
    FUserUnit: Integer;

    function GetArtBox: TdxRectF;
    function GetBleedBox: TdxRectF;
    function GetCropBox: TdxRectF;
    function GetMediaBox: TdxRectF;
    function GetTrimBox: TdxRectF;
    function GetUserUnit: Integer;
    function GetParentNode: TdxPDFPageTreeObject;
    function GetParentNodeArtBox: TdxRectF;
    function GetParentNodeBleedBox: TdxRectF;
    function GetParentNodeMediaBox: TdxRectF;
    function GetParentNodeRotationAngle: Integer;
    function GetParentNodeTrimBox: TdxRectF;
    function GetParentNodeUserUnit: Integer;
    function GetResources: TdxPDFResources;
    function GetRotationAngle: Integer;
    function GetParentNodeResources: TdxPDFResources;
    procedure DoChanged;
    procedure SetResources(const AValue: TdxPDFResources);
  strict protected
    FCropBox: TdxRectF;
    FMediaBox: TdxRectF;
    FUseParentRotationAngle: Boolean;
  protected
    FRotationAngle: Integer;
    //
    procedure DestroySubClasses; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Initialize; override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    function GetLeafCount: Integer; virtual;
    procedure Clear; virtual;
    procedure DoAdd(ANode: TdxPDFPageTreeObject); virtual;
    procedure DoRemove(ANode: TdxPDFPageTreeObject); virtual;

    property ArtBox: TdxRectF read GetArtBox;
    property BleedBox: TdxRectF read GetBleedBox;
    property CropBox: TdxRectF read GetCropBox;
    property MediaBox: TdxRectF read GetMediaBox;
    property ParentNode: TdxPDFPageTreeObject read GetParentNode;
    property ParentNodeResources: TdxPDFResources read GetParentNodeResources;
    property TrimBox: TdxRectF read GetTrimBox;
    property UseParentRotationAngle: Boolean read FUseParentRotationAngle;
    property Resources: TdxPDFResources read GetResources write SetResources;
  public
    property RotationAngle: Integer read GetRotationAngle;
    property UserUnit: Integer read GetUserUnit;
  end;

  { TdxPDFPage }

  TdxPDFPage = class(TdxPDFPageTreeObject) // for internal use
  strict private
    FDeferredData: TdxPDFDeferredObject;
    FDisplayDuration: Double;
    FLastModified: TDateTime;
    FLock: TRTLCriticalSection;
    FID: TBytes;
    FPreferredZoomFactor: Integer;
    FThumbnailImage: TdxPDFDocumentImage;
    FRecognizedContent: TdxPDFRecognizedContent;
    FRecognizedContentLockCount: Integer;
    FStructParents: Integer;
    FOnPack: TNotifyEvent;
    //
    function GetAnnotations: TdxPDFReferencedObjects;
    function GetBounds: TdxRectF;
    function GetData: TdxPDFPageData;
    function GetDocument: TObject;
    function GetDocumentState: TObject;
    function GetNormalizedRotationAngle: Integer;
    function GetHyperlinkList: TdxPDFHyperlinkList;
    function GetRecognizedContent: TdxPDFRecognizedContent; overload;
    function GetRecognizedContent(ARecognitionObjects: TdxPDFRecognitionObjects): TdxPDFRecognizedContent; overload;
    function GetSize: TdxPointF;
    procedure SetData(const AValue: TdxPDFPageData);
    procedure SetRotationAngle(const AValue: Integer);
    procedure SetThumbnailImage(const AValue: TdxPDFDocumentImage);
    //
    procedure PackData;
    procedure RecognizeContent(AContent: TdxPDFRecognizedContent; ARecognitionObjects: TdxPDFRecognitionObjects);
  protected
    Locked: Boolean;
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Initialize; override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    function IsRecognizedContentLocked: Boolean;
    procedure LockRecognizedContent;
    procedure UnLockRecognizedContent(AReset: Boolean = False);
    //
    function ScaleFactor(const ADPI, AScaleFactor: TdxPointF): TdxPointF;
    function UserSpaceFactor(const ADPI: TdxPointF): TdxPointF;
    procedure AddAnnotation(AAnnotation: TdxPDFCustomAnnotation);
    procedure DeleteAnnotation(AAnnotation: TdxPDFCustomAnnotation);
    procedure Export(ADevice: TObject; AParameters: TdxPDFExportParameters); overload;
    procedure Export(AParameters: TdxPDFExportParameters; AStream: TStream); overload;
    procedure LockAndExecute(AProc: TProc; ATryLock: Boolean = False);
    procedure Rotate(AAngle: Integer);
    function RemoveWidgetAnnotations(AAnnotationList: TdxFastList; AFlatten: Boolean): Boolean;
    //
    property Data: TdxPDFPageData read GetData write SetData;
    property Document: TObject read GetDocument;
    property DocumentState: TObject read GetDocumentState;
    property Hyperlinks: TdxPDFHyperlinkList read GetHyperlinkList;
    property NormalizedRotationAngle: Integer read GetNormalizedRotationAngle;
    property ThumbnailImage: TdxPDFDocumentImage read FThumbnailImage write SetThumbnailImage;
  public
    class function GetTypeName: string; override;
    constructor Create(AParent: TdxPDFObject; const AInfo: TdxPDFDeferredObjectInfo); reintroduce; overload;
    constructor Create(AParent: TdxPDFPageList; const AMediaBox, ACropBox: TdxRectF; ARotationAngle: Integer); reintroduce; overload;
    destructor Destroy; override;
    //
    function CalculateRotationAngle(ARotationAngle: TcxRotationAngle): Integer;
    function CreateRecognizedContent(ARecognitionObjects: TdxPDFRecognitionObjects): TdxPDFRecognizedContent;
    function GetTopLeft(AAngle: TcxRotationAngle): TdxPointF;
    function FromUserSpace(const R: TdxRectF): TdxPDFRectangle; overload;
    function FromUserSpace(const P, ADPI, AScaleFactor: TdxPointF; const ABounds: TdxRectF;
      AAngle: TcxRotationAngle): TdxPointF; overload;
    function FromUserSpace(const R: TdxRectF; ADPI, AScaleFactor: TdxPointF; const ABounds: TdxRectF;
      AAngle: TcxRotationAngle): TdxRectF; overload;
    function ToUserSpace(const P, ADPI, AScaleFactor: TdxPointF; const ABounds: TdxRectF;
      AAngle: TcxRotationAngle): TdxPointF; overload;
    function ToUserSpace(const R: TdxRectF; const ADPI, AScaleFactor: TdxPointF; const ABounds: TdxRectF;
      AAngle: TcxRotationAngle): TdxRectF; overload;
    procedure ForEachAnnotation(AProc: TdxPDFPageForEachAnnotationProc);
    procedure Move(ANewIndex: Integer);
    procedure Pack;
    procedure PackRecognizedContent(AForce: Boolean = False);
    //
    property Annotations: TdxPDFReferencedObjects read GetAnnotations;
    property Bounds: TdxRectF read GetBounds;
    property RecognizedContent: TdxPDFRecognizedContent read GetRecognizedContent;
    property Size: TdxPointF read GetSize;
    property OnPack: TNotifyEvent read FOnPack write FOnPack;
  end;

  { TdxPDFPageTreeObjectList }

  TdxPDFPageTreeOnCreatePageNodeEvent = function(AParent: TdxPDFPageTreeObjectList;
    ADictionary: TdxPDFReaderDictionary): Integer of object; // for internal use

  TdxPDFPageTreeObjectList = class(TdxPDFPageTreeObject) // for internal use
  strict private
    FChildren: TdxFastObjectList;
    FOnCreatePageNode: TdxPDFPageTreeOnCreatePageNodeEvent;
    //
    function GetCount: Integer;
    function GetItem(AIndex: Integer): TdxPDFPageTreeObject;
  protected
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoAdd(ANode: TdxPDFPageTreeObject); override;
    procedure DoRemove(ANode: TdxPDFPageTreeObject); override;
    procedure Read(ADictionary: TdxPDFReaderDictionary); override;
    //
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TdxPDFPageTreeObject read GetItem; default;
    property OnCreatePageNode: TdxPDFPageTreeOnCreatePageNodeEvent read FOnCreatePageNode write FOnCreatePageNode;
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFPageTreeNode }

  TdxPDFPageTreeNode = class(TdxPDFPageTreeObject) // for internal use
  strict private
    FNodeList: TdxPDFPageTreeObjectList;
    FOnCreatePageNode: TdxPDFPageTreeOnCreatePageNodeEvent;
  protected
    function GetLeafCount: Integer; override;
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoAdd(ANode: TdxPDFPageTreeObject); override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure DoRemove(ANode: TdxPDFPageTreeObject); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    function CreatePageNode(AParent: TdxPDFPageTreeObjectList; ADictionary: TdxPDFReaderDictionary): Integer;
    //
    property NodeList: TdxPDFPageTreeObjectList read FNodeList;
    property OnCreatePageNode: TdxPDFPageTreeOnCreatePageNodeEvent read FOnCreatePageNode write FOnCreatePageNode;
  end;

  TdxPDFInternalPageList = class(TList<TdxPDFPage>); // for internal use

  { TdxPDFPageList }

  TdxPDFPageList = class(TdxPDFPageTreeNode) // for internal use
  strict private
    FDictionary: TdxPDFIntegerObjectDictionary<TdxPDFPage>;
    FItems: TdxPDFInternalPageList;
    FOnPageDeleting: TNotifyEvent;
    FOnPagePack: TNotifyEvent;
    //
    function CreatePage(AParent: TdxPDFPageTreeObjectList; ADictionary: TdxPDFReaderDictionary): TdxPDFPageTreeObject;
    function GetCount: Integer;
    function GetPage(AIndex: Integer): TdxPDFPage;
  protected
    procedure Clear; override;
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoRemove(ANode: TdxPDFPageTreeObject); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    function Add(APage: TdxPDFPage): Integer;
    function CreateAndAddPage(AParent: TdxPDFPageTreeObjectList; ADictionary: TdxPDFReaderDictionary): Integer;
    function Find(ANumber: Integer): TdxPDFPage;
    procedure Delete(AIndex: Integer);
    procedure Move(ACurrentIndex, ANewIndex: Integer); overload;
    procedure Move(const ACurrentIndexes: array of Integer; ANewIndex: Integer); overload;
    procedure Remove(APage: TdxPDFPage);
    //
    property Items: TdxPDFInternalPageList read FItems;
    property OnPageDeleting: TNotifyEvent read FOnPageDeleting write FOnPageDeleting;
    property OnPagePack: TNotifyEvent read FOnPagePack write FOnPagePack;
  public
    class function GetTypeName: string; override;
    function IndexOf(APage: TdxPDFPage): Integer;
    //
    property Count: Integer read GetCount;
    property Page[AIndex: Integer]: TdxPDFPage read GetPage; default;
  end;

  { TdxPDFCustomDestination }

  TdxPDFCustomDestinationClass = class of TdxPDFCustomDestination;
  TdxPDFCustomDestination = class(TdxPDFObject) // for internal use
  strict private
    FCatalog: TdxPDFCatalog;
    FPage: TdxPDFPage;
    FPageID: Integer;
    FPageIndex: Integer;
    FPageObject: TdxPDFBase;

    function GetPage: TdxPDFPage;
    function GetPageIndex: Integer;
    function GetPages: TdxPDFPageList;
    procedure SetPageObject(const AValue: TdxPDFBase);
    procedure ResolvePage;
  protected
    procedure DestroySubClasses; override;
    procedure Initialize; override;
    procedure Read(ACatalog: TdxPDFCatalog; AArray: TdxPDFArray); reintroduce;
    function Write(AHelper: TdxPDFWriterHelper): TdxPDFBase; override;

    function GetTarget: TdxPDFTarget; virtual; abstract;
    procedure ReadParameters(AArray: TdxPDFArray); virtual;
    procedure WriteParameters(AHelper: TdxPDFWriterHelper; AArray: TdxPDFWriterArray); virtual;
    procedure WriteSingleValue(AArray: TdxPDFWriterArray; const AValue: Single);

    function IsSame(ADestination: TdxPDFCustomDestination): Boolean;
    procedure ResolveInternalPage;
    procedure ClearPageReference;

    class function GetSingleValue(AArray: TdxPDFArray): Single; static;
    function CalculatePageIndex(APages: TdxPDFPageList): Integer;
    function ValidateVerticalCoordinate(ATop: Single): Single;

    property Catalog: TdxPDFCatalog read FCatalog;
    property Page: TdxPDFPage read GetPage;
    property PageID: Integer read FPageID;
    property PageIndex: Integer read GetPageIndex;
    property PageObject: TdxPDFBase read FPageObject write SetPageObject;
    property Pages: TdxPDFPageList read GetPages;
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFFileSpecificationData }

  TdxPDFFileSpecificationData = class(TdxPDFObject) // for internal use
  strict private
    FCreationDate: TDateTime;
    FData: TBytes;
    FDataStreamRef: TdxPDFStream;
    FMimeType: string;
    FModificationDate: TDateTime;
    FSize: Integer;
    //
    function GetData: TBytes;
    function GetHasModificationDate: Boolean;
    procedure DoChanged;
    procedure ResolveData;
    procedure ReadParams(ADictionary: TdxPDFReaderDictionary);
    procedure WriteParams(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
    //
    procedure SetCreationDate(const AValue: TDateTime);
    procedure SetData(const AValue: TBytes);
    procedure SetMimeType(const AValue: string);
    procedure SetModificationDate(const AValue: TDateTime);
  protected
    procedure CreateSubClasses; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    procedure Changed; reintroduce; overload;
    procedure SetParent(const AValue: TdxPDFObject);
  public
    class function GetTypeName: string; override;
    //
    property CreationDate: TDateTime read FCreationDate write SetCreationDate;
    property Data: TBytes read GetData write SetData;
    property HasModificationDate: Boolean read GetHasModificationDate;
    property MimeType: string read FMimeType write SetMimeType;
    property ModificationDate: TDateTime read FModificationDate write SetModificationDate;
    property Size: Integer read FSize;
  end;

  { TdxPDFFileSpecification }

  TdxPDFFileSpecification = class(TdxPDFObject) // for internal use
  strict private const
    AssociatedFileRelationshipNameMap: array[TdxPDFAssociatedFileRelationship] of string = (
      '', 'Data', 'Alternative', 'Supplement', 'EncryptedPayload', 'Unspecified'
    );
  strict private
    FDescription: string;
    FFileName: string;
    FFileSpecificationData: TdxPDFFileSpecificationData;
    FFileSystem: string;
    FIndex: Integer;
    FRelationship: TdxPDFAssociatedFileRelationship;
    //
    function GetCreationDate: TDateTime;
    function GetFileData: TBytes;
    function GetMimeType: string;
    function GetModificationDate: TDateTime;
    function GetHasModificationDate: Boolean;
    function GetSize: Integer;
    procedure SetAttachment(const AValue: TdxPDFFileAttachment);
    procedure SetCreationDate(const AValue: TDateTime);
    procedure SetDescription(const AValue: string);
    procedure SetMimeType(const AValue: string);
    procedure SetModificationDate(const AValue: TDateTime);
    procedure SetFileData(const AValue: TBytes);
    procedure SetFileName(const AValue: string);
    procedure SetRelationship(const AValue: TdxPDFAssociatedFileRelationship);
    //
    function WriteFileSpecificationData(AHelper: TdxPDFWriterHelper): TdxPDFBase;
    procedure ReadAssociatedFileRelationship(ADictionary: TdxPDFReaderDictionary);
    procedure ReadFileIndex(ADictionary: TdxPDFReaderDictionary);
    procedure ReadFileName(ADictionary: TdxPDFReaderDictionary);
    procedure ReadFileSpecificationData(ADictionary: TdxPDFReaderDictionary);
    procedure WriteFileIndex(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
  protected
    FAttachment: TdxPDFFileAttachment;
    //
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    procedure SetParent(const AValue: TdxPDFObject);
  public
    class function GetTypeName: string; override;
    //
    constructor Create(ARepository: TdxPDFDocumentRepository; const AFileName: string); reintroduce;
    //
    property Attachment: TdxPDFFileAttachment read FAttachment write SetAttachment;
    property CreationDate: TDateTime read GetCreationDate write SetCreationDate;
    property Description: string read FDescription write SetDescription;
    property FileData: TBytes read GetFileData write SetFileData;
    property FileName: string read FFileName write SetFileName;
    property FileSystem: string read FFileSystem;
    property HasModificationDate: Boolean read GetHasModificationDate;
    property Index: Integer read FIndex;
    property MimeType: string read GetMimeType write SetMimeType;
    property ModificationDate: TDateTime read GetModificationDate write SetModificationDate;
    property Relationship: TdxPDFAssociatedFileRelationship read FRelationship write SetRelationship;
    property Size: Integer read GetSize;
  end;

  { TdxPDFCustomAction }

  TdxPDFActionList = class(TList<TdxPDFCustomAction>); // for internal use

  TdxPDFCustomAction = class(TdxPDFObject) // for internal use
  strict private
    FNext: TdxPDFActionList;
    FNextValue: TdxPDFBase;
    //
    function GetCatalog: TdxPDFCatalog;
    function GetNext: TdxPDFActionList;
    procedure SetNextValue(const AValue: TdxPDFBase);
    procedure EnsureNextActions;
    procedure WriteNextActions(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
  protected
    procedure DestroySubClasses; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    procedure Execute(const AController: IdxPDFInteractivityController); virtual;
    //
    property Catalog: TdxPDFCatalog read GetCatalog;
    property Next: TdxPDFActionList read GetNext;
    property NextValue: TdxPDFBase read FNextValue write SetNextValue;
  end;

  { TdxPDFCustomTree }

  TdxPDFCustomTree = class // for internal use
  strict private type
  {$REGION 'private types'}
    TStringReferencedObjectDictionary = class(TdxPDFStringReferencedObjectDictionary)
    strict private
      FKeyList: TdxStringList;
      //
      function GetKeyArray: TArray<string>;
      function GetKeyList: TdxStringList;
    protected
      procedure KeyNotify(const AKey: string; AAction: TCollectionNotification); override;
    public
      destructor Destroy; override;

      property KeyArray: TArray<string> read GetKeyArray;
    end;
  {$ENDREGION}
  strict private
    FDictionary: TStringReferencedObjectDictionary;
    FRepository: TdxPDFDocumentRepository;
    //
    class function GetUniqueKey(AIsUniqueKey: TFunc<string, Boolean>): string; overload; static;
    function CreateDeferredObject(AValue: TdxPDFBase): TdxPDFDeferredObject;
    function CreateKey(AValue: TdxPDFBase): string;
    function GetCount: Integer;
    function GetKeys: TArray<string>;
    function WriteBranch(AHelper: TdxPDFWriterHelper): TdxPDFBase;
    procedure ReadBranch(AReferences: TdxPDFArray);
    procedure ReadKids(AReferences: TdxPDFArray);
    procedure ReadNode(APageObject: TdxPDFBase);
  strict protected
    function GetDeferredObjectKey: string; virtual; abstract;
    function GetNodeName: string; virtual;
    //
    procedure DoRemoveAll<T: TdxPDFObject>(ACondition: TFunc<T, Boolean>);
  protected
    function GetLeafName(const AContext: IdxPDFWriterContext; const AName: string): string; virtual;
    //
    function ContainsValue(AObject: TdxPDFBase): Boolean;
    function InternalGetValue(const AKey: string): TdxPDFObject;
    function TryGetKey(AObject: TdxPDFBase; out AKey: string): Boolean;
    function Write(AHelper: TdxPDFWriterHelper): TdxPDFBase;
    procedure AddDeferredObject(const AKey: string; ARawObject: TdxPDFBase);
    procedure AddObject(const AKey: string; AObject: TdxPDFObject);
    procedure ExtractObject(AObject: TdxPDFBase);
    procedure DeleteObject(AObject: TdxPDFBase);
    procedure Read(ADictionary: TdxPDFReaderDictionary);
    procedure RemoveObject(const AKey: string);
    //
    property Repository: TdxPDFDocumentRepository read FRepository;
  public
    class function GetUniqueKey(ADictionary: TdxPDFStringReferencedObjectDictionary): string; overload; static;
    class function GetUniqueKey(ADictionary: TdxPDFStringStringDictionary): string; overload; static;
    //
    constructor Create(ARepository: TdxPDFDocumentRepository);
    destructor Destroy; override;
    //
    function ContainsKey(const AKey: string): Boolean;
    function GetUniqueKey: string; overload;
    //
    property Keys: TArray<string> read GetKeys;
    property Count: Integer read GetCount;  // for internal use
  end;

  { TdxPDFDestinationTree }

  TdxPDFDestinationTree = class(TdxPDFCustomTree) // for internal use
  strict protected
    function GetDeferredObjectKey: string; override;
    function GetLeafName(const AContext: IdxPDFWriterContext; const AName: string): string; override;
  public
    function GetValue(const AKey: string): TdxPDFCustomDestination;
    procedure RemoveAll(ACondition: TFunc<TdxPDFCustomDestination, Boolean>);
  end;

  { TdxPDFEmbeddedFileSpecificationTree }

  TdxPDFEmbeddedFileSpecificationTree = class(TdxPDFCustomTree) // for internal use
  strict protected
    function GetDeferredObjectKey: string; override;
  public
    function GetValue(const AKey: string): TdxPDFFileSpecification;
    procedure Add(AValue: TdxPDFFileSpecification);
    procedure Extract(AValue: TdxPDFFileSpecification);
    procedure Remove(AValue: TdxPDFFileSpecification);
  end;

  TdxPDFStringFormDictionary = class(TdxPDFCustomReferencedObjectDictionary<string, TdxPDFXForm>); // for internal use

  { TdxPDFAnnotationAppearance }

  TdxPDFAnnotationAppearance = class(TdxPDFObject) // for internal use
  strict private
    FDefaultForm: TdxPDFXForm;
    FForms: TdxPDFStringFormDictionary;
    FNames: TStringList;
    //
    procedure SetDefaultForm(const AValue: TdxPDFXForm);
  protected
    function Write(AHelper: TdxPDFWriterHelper): TdxPDFBase; override;
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    procedure SetForm(const AName: string; AForm: TdxPDFXForm);
  public
    constructor Create(ARepository: TdxPDFDocumentRepository; const ABBox: TdxPDFRectangle); reintroduce; overload;
    constructor Create(ADefaultForm: TdxPDFXForm; AForms: TdxPDFStringFormDictionary); reintroduce; overload;
    //
    function GetNames(const ADefaultName: string): TStringList; // for internal use
    //
    property DefaultForm: TdxPDFXForm read FDefaultForm write SetDefaultForm;
    property Forms: TdxPDFStringFormDictionary read FForms;
  end;

  { TdxPDFAnnotationAppearances }

  TdxPDFAnnotationAppearances = class(TdxPDFObject) // for internal use
  strict private
    FForm: TdxPDFXForm;
    FDown: TdxPDFAnnotationAppearance;
    FNames: TStringList;
    FNormal: TdxPDFAnnotationAppearance;
    FRollover: TdxPDFAnnotationAppearance;
    //
    function GetNames: TStringList;
    procedure SetForm(const AValue: TdxPDFXForm);
  protected
    function Write(AHelper: TdxPDFWriterHelper): TdxPDFBase; override;
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure Read(ADictionary: TdxPDFReaderDictionary; const AParentBox: TdxPDFRectangle); reintroduce; overload;
    procedure Read(AForm: TdxPDFXForm); reintroduce; overload;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    procedure SetStateForm(AState: TdxPDFAnnotationAppearanceState; const AName: string; AForm: TdxPDFXForm);
  public
    property Down: TdxPDFAnnotationAppearance read FDown;
    property Normal: TdxPDFAnnotationAppearance read FNormal;
    property Rollover: TdxPDFAnnotationAppearance read FRollover;
    //
    property Form: TdxPDFXForm read FForm write SetForm;
    property Names: TStringList read GetNames;
  end;

  { TdxPDFAnnotationBorderStyle }

  TdxPDFAnnotationBorderStyle = class(TdxPDFObject) // for internal use
  strict private const
    BeveledStyleName = 'B';
    DashedStyleName = 'D';
    DashLength = 4;
    InsetStyleName = 'I';
    SolidStyleName = 'S';
    UnderlineStyleName = 'U';
  strict private
    FLineStyle: TdxPDFLineStyle;
    FStyleName: string;
    FWidth: Single;
    //
    function GetStyle: TdxPDFBorderStyle;
    procedure SetLineStyle(const AValue: TdxPDFLineStyle);
    procedure SetStyle(const AValue: TdxPDFBorderStyle);
    procedure SetStyleName(const AValue: string);
    procedure SetWidth(const AValue: Single);
    //
    procedure CreateDashPattern(AStyle: TdxPDFBorderStyle); overload;
    procedure CreateDashPattern(const APattern: TDoubleDynArray); overload;
  protected
    function Write(AHelper: TdxPDFWriterHelper): TdxPDFBase; override;
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Initialize; override;
  public
    property LineStyle: TdxPDFLineStyle read FLineStyle write SetLineStyle;
    property StyleName: string read FStyleName write SetStyleName;
    //
    property Style: TdxPDFBorderStyle read GetStyle write SetStyle;
    property Width: Single read FWidth write SetWidth;
  end;

  { TdxPDFAnnotationBorder }

  TdxPDFAnnotationBorder = class(TdxPDFObject) // for internal use
  strict private const
    DefaultHorizontalCornerRadius = 0;
    DefaultVerticalCornerRadius = 0;
    DefaultLineWidth = 1;
  strict private
    FHorizontalCornerRadius: Double;
    FLineStyle: TdxPDFLineStyle;
    FLineWidth: Double;
    FVerticalCornerRadius: Double;
    //
    function GetIsDefault: Boolean;
    procedure SetLineStyle(const AValue: TdxPDFLineStyle);
  protected
    function Write(AHelper: TdxPDFWriterHelper): TdxPDFBase; override;
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Initialize; override;
  public
    property HorizontalCornerRadius: Double read FHorizontalCornerRadius;
    property IsDefault: Boolean read GetIsDefault;
    property LineStyle: TdxPDFLineStyle read FLineStyle write SetLineStyle;
    property LineWidth: Double read FLineWidth;
    property VerticalCornerRadius: Double read FVerticalCornerRadius;
  end;

  { IdxPDFCustomAnnotationVisitor }

  IdxPDFCustomAnnotationVisitor = interface
  ['{611650DC-B3CD-4E64-9A3A-04C3665DD33F}']
    procedure Visit(AAnnotation: TdxPDFCustomAnnotation);
  end;

  { TdxPDFCustomAnnotation }

  TdxPDFCustomAnnotation = class(TdxPDFObject) // for internal use
  strict private
    FAppearance: TdxPDFAnnotationAppearances;
    FAppearanceRawObject: TdxPDFBase;
    FAppearanceName: string;
    FBorder: TdxPDFAnnotationBorder;
    FColor: TdxPDFColor;
    FContents: string;
    FFlags: TdxPDFAnnotationFlags;
    FDictionary: TdxPDFReaderDictionary;
    FModified: TDateTime;
    FName: string;
    FNeedFreeAppearanceRawObject: Boolean;
    FPage: TdxPDFPage;
    FResolved: Boolean;
    FStructParent: Integer;
    //
    function GetAppearance: TdxPDFAnnotationAppearances;
    function GetAppearanceName: string;
    function GetBorder: TdxPDFAnnotationBorder;
    function GetCatalog: TdxPDFCatalog;
    function GetColor: TdxPDFColor;
    function GetContents: string;
    function GetName: string;
    function GetPageIndex: Integer;
    function GetPageRect: TdxPDFPageRect;
    function GetReadOnly: Boolean;
    function GetRect: TdxPDFRectangle;
    procedure SetAppearance(const AValue: TdxPDFAnnotationAppearances);
    procedure SetAppearanceName(const AValue: string);
    procedure SetBorder(const AValue: TdxPDFAnnotationBorder);
    procedure SetColor(const AValue: TdxPDFColor);
    procedure SetContents(const AValue: string);
    procedure SetDictionary(const AValue: TdxPDFReaderDictionary);
    procedure SetName(const AValue: string);
    procedure DoSetAppearance(const AValue: TdxPDFAnnotationAppearances);
  strict protected
    FRect: TdxPDFRectangle;
  protected
    procedure DestroySubClasses; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    function AppearanceNeeded(AForm: TdxPDFXForm): Boolean; virtual;
    function CreateAppearanceBuilder: TObject; virtual;
    function GetAppearanceBBox: TdxPDFRectangle; virtual;
    function GetVisible: Boolean; virtual;
    procedure Ensure; virtual;
    procedure Resolve(ADictionary: TdxPDFReaderDictionary); virtual;
    //
    function HasFlag(AFlags: TdxPDFAnnotationFlags): Boolean;
    procedure SetAppearanceRawObject(AObject: TdxPDFBase);
    //
    property Catalog: TdxPDFCatalog read GetCatalog;
    property Contents: string read GetContents write SetContents;
    property Dictionary: TdxPDFReaderDictionary read FDictionary write SetDictionary;
    property Name: string read GetName write SetName;
    property Page: TdxPDFPage read FPage write FPage;
    property ReadOnly: Boolean read GetReadOnly;
    property Visible: Boolean read GetVisible;
  public
    class function GetTypeName: string; override;
    //
    constructor Create(APage: TdxPDFPage; const ARect: TdxPDFRectangle); overload; // for internal use
    constructor Create(APage: TdxPDFPage; const ARect: TdxPDFRectangle; AFlags: TdxPDFAnnotationFlags); overload; // for internal use
    //
    function CreateAppearanceForm(AState: TdxPDFAnnotationAppearanceState): TdxPDFXForm; overload; // for internal use
    function CreateAppearanceForm(AState: TdxPDFAnnotationAppearanceState; const AName: string): TdxPDFXForm; overload; // for internal use
    function EnsureAppearanceForm(AState: TdxPDFAnnotationAppearanceState): TdxPDFXForm; overload; // for internal use
    function EnsureAppearanceForm(AState: TdxPDFAnnotationAppearanceState; AForm: TdxPDFXForm): TdxPDFXForm; overload; // for internal use
    function GetAppearanceForm(AState: TdxPDFAnnotationAppearanceState): TdxPDFXForm; overload; // for internal use
    function GetAppearanceForm(AState: TdxPDFAnnotationAppearanceState; const AAppearanceName: string): TdxPDFXForm; overload; // for internal use
    function IsHidden: Boolean;
    function UseDefaultAppearance: Boolean; virtual;
    procedure Accept(const AVisitor: IdxPDFCustomAnnotationVisitor); virtual;
    procedure Rebuild(AForm: TdxPDFXForm);
    //
    property Appearance: TdxPDFAnnotationAppearances read GetAppearance write SetAppearance; // for internal use
    property AppearanceBBox: TdxPDFRectangle read GetAppearanceBBox; // for internal use
    property AppearanceName: string read GetAppearanceName write SetAppearanceName; // for internal use
    property Border: TdxPDFAnnotationBorder read GetBorder write SetBorder; // for internal use
    property Color: TdxPDFColor read GetColor write SetColor;
    property Flags: TdxPDFAnnotationFlags read FFlags; // for internal use
    property Modified: TDateTime read FModified write FModified; // for internal use
    property PageIndex: Integer read GetPageIndex; // for internal use
    property PageRect: TdxPDFPageRect read GetPageRect; // for internal use
    property Rect: TdxPDFRectangle read GetRect write FRect; // for internal use
  end;

  { TdxPDFFileAttachment }

  TdxPDFFileAttachment = class
  strict private
    FFileSpecification: TdxPDFFileSpecification;
    //
    function GetCreationDate: TDateTime;
    function GetData: TBytes;
    function GetDescription: string;
    function GetFileName: string;
    function GetMimeType: string;
    function GetModificationDate: TDateTime;
    function GetRelationship: TdxPDFAssociatedFileRelationship;
    function GetSize: Integer;
    procedure SetCreationDate(const AValue: TDateTime);
    procedure SetData(const AValue: TBytes);
    procedure SetDescription(const AValue: string);
    procedure SetFileName(const AValue: string);
    procedure SetModificationDate(const AValue: TDateTime);
  protected
    FOwnsSpecification: Boolean;
    //
    constructor Create(AFileSpecification: TdxPDFFileSpecification); overload;
    function GetModificationDateAsString: string;
    function GetSizeAsString: string;
    //
    property FileSpecification: TdxPDFFileSpecification read FFileSpecification;
    property MimeType: string read GetMimeType;
    property Relationship: TdxPDFAssociatedFileRelationship read GetRelationship;
  public
    constructor Create; overload;
    destructor Destroy; override;
    //
    procedure LoadFromFile(const AFileName: string);
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToFile(const AFileName: string);
    procedure SaveToStream(AStream: TStream);
    //
    property CreationDate: TDateTime read GetCreationDate write SetCreationDate;
    property Data: TBytes read GetData write SetData;
    property Description: string read GetDescription write SetDescription;
    property FileName: string read GetFileName write SetFileName;
    property ModificationDate: TDateTime read GetModificationDate write SetModificationDate;
    property Size: Integer read GetSize;
  end;

  { TdxPDFFileAttachmentList }

  TdxPDFFileAttachmentList = class(TList<TdxPDFFileAttachment>)
  strict private
    FLockCount: Integer;
    //
    function IsLocked: Boolean;
    function TryFindFileAttachmentAnnotation(AAttachment: TdxPDFFileAttachment; out AAnnotation: TdxPDFCustomAnnotation): Boolean;
    procedure DoAdd(AAttachment: TdxPDFFileAttachment);
    procedure LockAndExecute(AProc: TProc);
    //
    procedure OnAdded(AValue: TdxPDFFileAttachment);
    procedure OnExtracted(AValue: TdxPDFFileAttachment);
    procedure OnRemoved(AValue: TdxPDFFileAttachment);
  protected
    FCatalog: TdxPDFCatalog;
    //
    procedure Notify(const AValue: TdxPDFFileAttachment; AAction: TCollectionNotification); override;
    procedure Refresh;
  public
    function Add: TdxPDFFileAttachment; overload;
    function Extract(AValue: TdxPDFFileAttachment): TdxPDFFileAttachment; overload;
    function Remove(AValue: TdxPDFFileAttachment): Integer; overload;
  end;

  { TdxPDFDocumentNames }

  TdxPDFDocumentNames = class(TdxPDFObject) // for internal use
  strict private
    FEmbeddedFileSpecifications: TdxPDFEmbeddedFileSpecificationTree;
    FPageDestinations: TdxPDFDestinationTree;
  protected
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    function GetEmbeddedFileSpecification(const AName: string): TdxPDFFileSpecification;
    function GetPageDestination(const AName: string): TdxPDFCustomDestination;
    //
    property EmbeddedFileSpecifications: TdxPDFEmbeddedFileSpecificationTree read FEmbeddedFileSpecifications;
    property PageDestinations: TdxPDFDestinationTree read FPageDestinations;
  public
    procedure AddFileSpecification(AValue: TdxPDFFileSpecification);
    procedure ExtractFileSpecification(AValue: TdxPDFFileSpecification);
    procedure RemoveFileSpecification(AValue: TdxPDFFileSpecification);
  end;

  { TdxPDFInteractiveFormFieldTextState }

  TdxPDFInteractiveFormFieldTextState = class(TdxPDFObject) // for internal use
  strict private
    FCharacterSpacing: Single;
    FCommandsAsBytes: TBytes;
    FFontBold: Boolean;
    FFontColor: TColor;
    FFontCommand: TdxPDFCustomCommand;
    FFontItalic: Boolean;
    FFontName: string;
    FFontSize: Single;
    FHorizontalScaling: Single;
    FWordSpacing: Single;
    //
    function GetFontSize: Single;
    procedure SetCharacterSpacing(const AValue: Single);
    procedure SetFontBold(const AValue: Boolean);
    procedure SetFontColor(const AValue: TColor);
    procedure SetFontItalic(const AValue: Boolean);
    procedure SetFontName(const AValue: string);
    procedure SetFontSize(const AValue: Single);
    procedure SetHorizontalScaling(const AValue: Single);
    procedure SetWordSpacing(const AValue: Single);
    //
    function GetAppearanceCommandsInheritable(AFormField: TdxPDFInteractiveFormField): TdxPDFCommandList;
    procedure ConvertCommandsToBytes(AField: TdxPDFInteractiveFormField);
    procedure SetFontCommand(const AValue: TdxPDFCustomCommand);
    //
    procedure InitializeColor(AField: TdxPDFInteractiveFormField);
    procedure InitializeText(ATextState: TdxPDFInteractiveFormFieldTextState);
  protected
    procedure DestroySubClasses; override;
    procedure Initialize; override;
  public const
    DefaultFontSize = 12; // for internal use
    DefaultMinFontSize = 4; // for internal use
    DefaultMaxFontSize = 148; // for internal use
  public
    constructor Create(AField: TdxPDFInteractiveFormField); reintroduce;
    //
    property CharacterSpacing: Single read FCharacterSpacing write SetCharacterSpacing;
    property CommandsAsBytes: TBytes read FCommandsAsBytes;
    property FontBold: Boolean read FFontBold write SetFontBold;
    property FontColor: TColor read FFontColor write SetFontColor;
    property FontCommand: TdxPDFCustomCommand read FFontCommand write SetFontCommand;
    property FontItalic: Boolean read FFontItalic write SetFontItalic;
    property FontName: string read FFontName write SetFontName;
    property FontSize: Single read GetFontSize write SetFontSize;
    property HorizontalScaling: Single read FHorizontalScaling write SetHorizontalScaling;
    property WordSpacing: Single read FWordSpacing write SetWordSpacing;
  end;

  { TdxPDFInteractiveFormCustomFieldEditValue }

  TdxPDFInteractiveFormCustomFieldEditValue = class(TdxPDFObject) // for internal use
  strict private
    FDefaultValue: TStringList;
    FIgnoreReadOnly: Boolean;
    FMultiSelect: Boolean;
    FReadOnly: Boolean;
    FSorted: Boolean;
    FValue: TStringList;
    //
    function GetDefaultText: string;
    function GetDefaultValueList: TStringList;
    function GetText: string;
    function GetValueList: TStringList;
    procedure SetDefaultText(const AValue: string);
    procedure SetSorted(const AValue: Boolean);
    //
    procedure InternalSetValue(const AValue: string);
  strict protected
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    function CanChange: Boolean;
    function DoChanging(const AOldValue, ANewValue: string): Boolean;
    function GetDefaultValueKey: string; virtual;
    function GetValueKey: string; virtual;
    function ValidateValue(const AValue: string): string; virtual;
    procedure DoAdd(const AValue: string); virtual;
    procedure DoDelete(AIndex: Integer); virtual;
    procedure DoChanged;
    procedure DoClear; virtual;
    procedure DoSort; virtual;
    procedure SetMultiSelect(const AValue: Boolean); virtual;
    procedure Sort;
    //
    procedure EnableReadOnlyValidation;
    procedure DisableReadOnlyValidation;
  protected
    OnChanged: TNotifyEvent;
    OnChanging: TdxPDFInteractiveFormFieldEditValueChangingEvent;
  public
    class function PrepareValue(const AValue: string): string; static;
    //
    procedure SetExportValue(const AValue: string); virtual;
    procedure SetValue(const AValue: string);
    procedure Clear;
    //
    property DefaultText: string read GetDefaultText write SetDefaultText;
    property DefaultValueList: TStringList read GetDefaultValueList;
    property MultiSelect: Boolean read FMultiSelect write SetMultiSelect;
    property ReadOnly: Boolean read FReadOnly write FReadOnly;
    property Sorted: Boolean read FSorted write SetSorted;
    property Text: string read GetText;
    property ValueList: TStringList read GetValueList;
  end;

  { TdxPDFInteractiveFormField }

  TdxPDFInteractiveFormField = class(TdxPDFObject) // for internal use
  strict private const
    FieldNameDelimiter = '.';
  strict private
    FAlternateName: string;
    FAppearanceChanged: Boolean;
    FAppearanceCommands: TdxPDFCommandList;
    FDefaultStyle: string;
    FEditValue: TdxPDFInteractiveFormCustomFieldEditValue;
    FEditValueChanged: Boolean;
    FEditValueProvider: TdxPDFInteractiveFormField;
    FFlags: TdxPDFInteractiveFormFieldFlags;
    FForm: TdxPDFInteractiveForm;
    FHasFlags: Boolean;
    FKids: TdxPDFInteractiveFormFieldCollection;
    FKidsResolved: Boolean;
    FMappingName: string;
    FParent: TdxPDFInteractiveFormField;
    FResources: TdxPDFResources;
    FRichTextData: string;
    FTextJustify : TdxPDFTextJustify;
    FTextState: TdxPDFInteractiveFormFieldTextState;
    FWidget: TdxPDFCustomAnnotation { TdxPDFWidgetAnnotation };
    //
    function GetAlternateName: string;
    function GetEditValue: TdxPDFInteractiveFormCustomFieldEditValue;
    function GetExportable: Boolean;
    function GetExportValueList: TStringList;
    function GetFlags: TdxPDFInteractiveFormFieldFlags;
    function GetFontProvider: IdxPDFFontProvider;
    function GetFullName: string;
    function GetMultiSelect: Boolean;
    function GetName: string;
    function GetReadOnly: Boolean;
    function GetRequired: Boolean;
    function GetSorted: Boolean;
    function GetTextState: TdxPDFInteractiveFormFieldTextState;
    procedure SetAppearanceCommands(const AValue: TdxPDFCommandList);
    procedure SetExportable(const AValue: Boolean);
    procedure SetMultiSelect(const AValue: Boolean);
    procedure SetReadOnly(const AValue: Boolean);
    procedure SetResources(const AValue: TdxPDFResources);
    procedure SetRequired(const AValue: Boolean);
    procedure SetSorted(const AValue: Boolean);
    procedure SetTextJustify(const AValue: TdxPDFTextJustify);
    //
    procedure ReadKids(ADictionary: TdxPDFReaderDictionary; AWidgetNumber: Integer);
    procedure UpdateEditValueProperties;
    procedure WriteKids(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
    //
    procedure OnValueChangedHandler(ASender: TObject);
    procedure OnValueChangingHandler(const AOldValue, ANewValue: string; var AAccept: Boolean);
  strict protected
    FName: string;
    //
    function CreateEditValue: TdxPDFInteractiveFormCustomFieldEditValue; virtual;
    procedure DoBuildAppearance(ABuilder: TObject; AState: TdxPDFAnnotationAppearanceState; const AAppearanceName: string);
    procedure DoRebuildAppearance(AForce: Boolean); virtual;
    //
    property EditValueProvider: TdxPDFInteractiveFormField read FEditValueProvider;
  protected
    procedure CreateSubClasses; override;
    procedure EndUpdate; override;
    procedure DestroySubClasses; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Initialize; overload; override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    function CreateAppearanceBuilder: TObject; virtual;
    function GetFieldType: TdxPDFInteractiveFormFieldType; virtual;
    function ForceAppearanceChangeOnEditValueChanged: Boolean; virtual;
    procedure DoWrite(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); virtual;
    procedure Initialize(AForm: TdxPDFInteractiveForm; AParent: TdxPDFInteractiveFormField); reintroduce; overload; virtual;
    procedure Read(ADictionary: TdxPDFReaderDictionary; ANumber: Integer); reintroduce; virtual;
    //
    function HasAppearance(const AName: string): Boolean;
    function HasFlag(AFlags: TdxPDFInteractiveFormFieldFlags): Boolean;
    procedure CheckChanges;
    procedure SetFlag(AFlags: TdxPDFInteractiveFormFieldFlags; AValue: Boolean);
    procedure RebuildAppearance(AForce: Boolean);
    procedure PopulateAnnotationsToRemove(ARemovingAnnotations: TObjectDictionary<TdxPDFPage, TdxFastList>);
    //
    property EditValue: TdxPDFInteractiveFormCustomFieldEditValue read GetEditValue;
    property MultiSelect: Boolean read GetMultiSelect write SetMultiSelect;
    property Resources: TdxPDFResources read FResources write SetResources;
  public
    AppearanceCalculationCount: Integer;
    OnEditValueChanging: TdxPDFInteractiveFormFieldEditValueChangingEvent;
    OnEditValueChanged: TNotifyEvent;
    //
    constructor Create(AForm: TdxPDFInteractiveForm; AWidget: TdxPDFCustomAnnotation;
      const AName: string = ''); overload; virtual;
    procedure BuildAppearance(AState: TdxPDFAnnotationAppearanceState; const AAppearanceName: string);
    //
    function GetBackgroundARGBColor: TdxPDFARGBColor;
    function IsComboBox: Boolean;
    function IsComposite: Boolean;
    function IsPushButton: Boolean;
    function IsRadioButton: Boolean;
    function UseDefaultAppearance: Boolean; virtual;
    procedure AppearanceChanged(AForce: Boolean); reintroduce;
    procedure ClearEditValue;
    procedure DeleteAnnotation(AFlatten: Boolean);
    procedure SetEditValue(const AValue: string); virtual;
    procedure SetExportEditValue(const AValue: string); virtual;
    procedure ResetEditValue; virtual;
    // Appearance
    property BackgroundARGBColor: TdxPDFARGBColor read GetBackgroundARGBColor;
    //
    property AlternateName: string read GetAlternateName;
    property AppearanceCommands: TdxPDFCommandList read FAppearanceCommands write SetAppearanceCommands;
    property DefaultStyle: string read FDefaultStyle;
    property Exportable: Boolean read GetExportable write SetExportable;
    property ExportValueList: TStringList read GetExportValueList;
    property FieldType: TdxPDFInteractiveFormFieldType read GetFieldType;
    property Flags: TdxPDFInteractiveFormFieldFlags read GetFlags write FFlags;
    property FontProvider: IdxPDFFontProvider read GetFontProvider;
    property Form: TdxPDFInteractiveForm read FForm;
    property FullName: string read GetFullName;
    property Kids: TdxPDFInteractiveFormFieldCollection read FKids;
    property Name: string read GetName;
    property Parent: TdxPDFInteractiveFormField read FParent;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
    property Required: Boolean read GetRequired write SetRequired;
    property RichTextData: string read FRichTextData;
    property Sorted: Boolean read GetSorted write SetSorted;
    property TextJustify: TdxPDFTextJustify read FTextJustify write SetTextJustify;
    property TextState: TdxPDFInteractiveFormFieldTextState read GetTextState;
    property Widget: TdxPDFCustomAnnotation read FWidget;
  end;

  { TdxPDFInteractiveFormFieldCollection }

  TdxPDFInteractiveFormFieldCollection = class(TdxPDFObject) // for internal use
  strict private
    FItems: TdxPDFReferencedObjects;
    //
    function GetCount: Integer;
    function GetItem(Index: Integer): TdxPDFInteractiveFormField;
  protected
    property List: TdxPDFReferencedObjects read FItems;
  protected
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure Read(ADictionary: TdxPDFReaderDictionary; AFieldArray: TdxPDFArray;
      AForm: TdxPDFInteractiveForm; AParent: TdxPDFInteractiveFormField); reintroduce;
    function Write(AHelper: TdxPDFWriterHelper): TdxPDFBase; override;
    function Contains(const AValue: TdxPDFInteractiveFormField): Boolean;
    procedure Add(AField: TdxPDFInteractiveFormField);
    procedure AddWithAncestors(AField: TdxPDFInteractiveFormField);
    procedure Delete(AField: TdxPDFInteractiveFormField);
  public
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TdxPDFInteractiveFormField read GetItem; default;
  end;

  { TdxPDFXFAForm }

  TdxPDFXFAForm = record // for internal use
  public
    Content: string;
    //
    procedure Initialize(const AData: TBytes); overload;
    procedure Initialize(ARepository: TdxPDFDocumentRepository; AArray: TdxPDFArray); overload;
    function ToByteArray: TBytes;
  end;

  { TdxPDFInteractiveForm }

  TdxPDFInteractiveForm = class(TdxPDFObject) // for internal use
  strict private
    FDefaultAppearanceCommands: TdxPDFCommandList;
    FDefaultTextJustify: TdxPDFTextJustify;
    FFields: TdxPDFInteractiveFormFieldCollection;
    FNeedAppearances: Boolean;
    FResources: TdxPDFResources;
    FSignatureFlags: TdxPDFSignatureFlags;
    FXFAForm: TdxPDFXFAForm;
    //
    function CreateSignatureField(AInfo: TObject): TdxPDFInteractiveFormField; overload;
    procedure DeleteByName(const AFullName: string; AFlatten: Boolean); overload;
    procedure DoAdd(AField: TdxPDFInteractiveFormField);
    procedure DoDelete(AField: TdxPDFInteractiveFormField);
    procedure DoDeleteKids(AField: TdxPDFInteractiveFormField; const AFieldName: string; AFlatten: Boolean);
    //
    procedure SetResources(const AValue: TdxPDFResources);
    procedure ReadXFAForm(ADictionary: TdxPDFReaderDictionary);
    procedure ValidateRect(const ARect: TdxPDFPageRect);
  protected
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    function AddSignatureField(ASignatureInfo: TObject): TObject;
    function AddTextField(const AName: string; const ABounds: TdxPDFPageRect): TdxPDFInteractiveFormField;
    procedure Add(AField: TdxPDFInteractiveFormField);
    procedure Delete(AField: TdxPDFInteractiveFormField; AFlatten: Boolean);
    //
    function HasSignatureFields: Boolean;
    //
    property DefaultAppearanceCommands: TdxPDFCommandList read FDefaultAppearanceCommands;
    property Fields: TdxPDFInteractiveFormFieldCollection read FFields;
    property NeedAppearances: Boolean read FNeedAppearances write FNeedAppearances;
    property Resources: TdxPDFResources read FResources write SetResources;
    property SignatureFlags: TdxPDFSignatureFlags read FSignatureFlags write FSignatureFlags;
  end;

  { TdxPDFDocumentInformation }

  TdxPDFDocumentInformation = class(TdxPDFObject)
  strict private
    FApplication: string;
    FAuthor: string;
    FCreationDate: TDateTime;
    FKeywords: string;
    FModificationDate: TDateTime;
    FProducer: string;
    FSubject: string;
    FTitle: string;
    //
    procedure SetApplication(const AValue: string);
    procedure SetAuthor(const AValue: string);
    procedure SetKeywords(const AValue: string);
    procedure SetProducer(const AValue: string);
    procedure SetSubject(const AValue: string);
    procedure SetTitle(const AValue: string);
  protected
    FFileName: string;
    FFileSize: Int64;
    FVersion: TdxPDFVersion;
    //
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Initialize; override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    class function GetTypeName: string; override;
    //
    property Application: string read FApplication write SetApplication;
    property Author: string read FAuthor write SetAuthor;
    property CreationDate: TDateTime read FCreationDate;
    property Keywords: string read FKeywords write SetKeywords;
    property ModificationDate: TDateTime read FModificationDate;
    property FileName: string read FFileName;
    property FileSize: Int64 read FFileSize;
    property Producer: string read FProducer write SetProducer;
    property Subject: string read FSubject write SetSubject;
    property Version: TdxPDFVersion read FVersion;
    property Title: string read FTitle write SetTitle;
  end;

  { TdxPDFXMLPacket }

  TdxPDFXMLPacket = class(TdxXMLDocument)
  protected
    function GetFooterText: TdxXMLString; override;
    function GetHeaderText: TdxXMLString; override;
  public
    procedure AfterConstruction; override;
  end;

  { TdxPDFMetadata }

  TdxPDFMetadata = class(TdxPDFObject)
  protected
    FData: TdxPDFXMLPacket;

    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure Read(AStream: TdxPDFStream); reintroduce; virtual;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    class function GetTypeName: string; override;
    procedure Clear;
    procedure Update(AInformation: TdxPDFDocumentInformation);
  end;

  { TdxPDFOutlineItem }

  TdxPDFOutlineItem = class(TdxPDFObject)
  strict private
    FClosed: Boolean;
    FCount: Integer;
    FLast: TdxPDFOutline;
    //
    function DoCreateOutline(AFunc: TFunc<TdxPDFOutline>): TdxPDFOutline;
  strict protected
    FFirst: TdxPDFOutline;
  protected
    FOnCreateItem: TNotifyEvent;
    //
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    function CreateOutline: TdxPDFOutline; overload;
    function CreateOutline(AParent: TdxPDFOutlineItem; ABookmark: TdxPDFBookmark; APrev: TdxPDFOutline): TdxPDFOutline; overload;
    function UpdateCount: Integer;
    //
    property Closed: Boolean read FClosed write FClosed;
  public
    property Count: Integer read FCount;
    property First: TdxPDFOutline read FFirst write FFirst;
    property Last: TdxPDFOutline read FLast write FLast;
  end;

  { TdxPDFOutline }

  TdxPDFOutline = class(TdxPDFOutlineItem)
  strict private const
    Bold = 2;
    Italic = 1;
  strict private
    FAction: TdxPDFCustomAction;
    FCatalog: TdxPDFCatalog;
    FColor: TdxPDFColor;
    FDestinationInfo: TdxPDFDestinationInfo;
    FIsBold: Boolean;
    FIsItalic: Boolean;
    FNext: TdxPDFOutline;
    FParent: TdxPDFOutlineItem;
    FPrev: TdxPDFOutline;
    FTitle: string;
    //
    function GetActualDestination: TdxPDFCustomDestination;
    function GetDestination: TdxPDFCustomDestination;
    procedure SetAction(const AValue: TdxPDFCustomAction);
    procedure SetDestinationInfo(const AValue: TdxPDFDestinationInfo);
    procedure ReadColor(ADictionary: TdxPDFDictionary);
    procedure ReadFlags(ADictionary: TdxPDFDictionary);
    procedure WriteFlags(ADictionary: TdxPDFDictionary);
  protected
    class function CreateOutlineTree(AParent: TdxPDFOutlineItem; ABookmarks: TdxPDFBookmarkList): TdxPDFOutline;
    constructor Create(AParent: TdxPDFOutlineItem; APrev: TdxPDFOutline; ABookmark: TdxPDFBookmark); overload;
    //
    procedure DestroySubClasses; override;
    procedure Read(ADictionary: TdxPDFReaderDictionary; AParent: TdxPDFOutlineItem; APrev: TdxPDFOutline); reintroduce; overload;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    property DestinationInfo: TdxPDFDestinationInfo read FDestinationInfo write SetDestinationInfo;
    property Prev: TdxPDFOutline read FPrev write FPrev;
  public
    class function GetTypeName: string; override;
    function HasChildren: Boolean;
    //
    property Action: TdxPDFCustomAction read FAction write SetAction;
    property ActualDestination: TdxPDFCustomDestination read GetActualDestination;
    property Color: TdxPDFColor read FColor;
    property Destination: TdxPDFCustomDestination read GetDestination;
    property IsBold: Boolean read FIsBold;
    property IsItalic: Boolean read FIsItalic;
    property Next: TdxPDFOutline read FNext write FNext;
    property Parent: TdxPDFOutlineItem read FParent;
    property Title: string read FTitle;
  end;

  { TdxPDFOutlines }

  TdxPDFOutlines = class(TdxPDFOutlineItem)
  strict private
    FItems: TdxFastObjectList;
    //
    procedure DoDelete(AList: TdxFastList; AItem: TdxPDFOutlineItem; APage: TdxPDFPage);
    procedure OnCreateItemHandler(AItem: TObject);
  protected
    constructor CreateFrom(ABookmarks: TdxPDFBookmarkList);
    //
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure Initialize; override;
    //
    procedure Clear;
    procedure DeleteOutlines(APage: TdxPDFPage);
    procedure Delete(AValue: TdxPDFOutlineItem);
  public
    class function GetTypeName: string; override;
  end;

  { IdxPDFBookmarkParent }

  IdxPDFBookmarkParent = interface // for internal use
  ['{552FB906-553B-4336-9D84-9D5CC8ED2F3F}']
    function GetCatalog: TdxPDFCatalog;
    procedure Changed;
  end;

  { TdxPDFBookmark }

  TdxPDFBookmark = class(TcxIUnknownObject, IdxPDFBookmarkParent) // for internal use
  strict private
    FAction: TdxPDFCustomAction;
    FChildren: TdxPDFBookmarkList;
    FDestinationInfo: TdxPDFDestinationInfo;
    FIsBold: Boolean;
    FIsItalic: Boolean;
    FOperation: TdxPDFInteractiveOperation;
    FTitle: string;
    //
    function GetDestination: TdxPDFCustomDestination;
    function GetOperation: TdxPDFInteractiveOperation;
    procedure SetAction(const AValue: TdxPDFCustomAction);
    procedure SetDestinationInfo(const AValue: TdxPDFDestinationInfo);
    // IdxPDFBookmarkParent
    function GetCatalog: TdxPDFCatalog;
    procedure Changed;
  protected
    FColor: TdxPDFColor;
    FParent: IdxPDFBookmarkParent;
    property DestinationInfo: TdxPDFDestinationInfo read FDestinationInfo write SetDestinationInfo;
  public
    constructor Create; overload;
    constructor Create(ADestinationInfo: TdxPDFDestinationInfo); overload; // for internal use
    constructor Create(ADestinationInfo: TdxPDFDestinationInfo; ABookmark: TdxPDFBookmark; AAction: TdxPDFCustomAction); overload; // for internal use
    constructor Create(const AParent: IdxPDFBookmarkParent; AOutline: TdxPDFOutline); overload; // for internal use
    destructor Destroy; override;

    property Action: TdxPDFCustomAction read FAction write SetAction;
    property Children: TdxPDFBookmarkList read FChildren;  // for internal use
    property Destination: TdxPDFCustomDestination read GetDestination;
    property IsBold: Boolean read FIsBold;
    property IsItalic: Boolean read FIsItalic;
    property Operation: TdxPDFInteractiveOperation read GetOperation;
    property Parent: IdxPDFBookmarkParent read FParent;
    property Title: string read FTitle;
  end;

  { TdxPDFBookmarkList }

  TdxPDFBookmarkList = class(TcxIUnknownObject, IdxPDFBookmarkParent) // for internal use
  strict private
    FItems: TdxFastObjectList;
    FParent: IdxPDFBookmarkParent;
    //
    function GetCatalog: TdxPDFCatalog;
    function GetCount: Integer;
    function GetItem(AIndex: Integer): TdxPDFBookmark;
    procedure Changed;
    procedure DoAdd(ABookmark: TdxPDFBookmark);
  protected
    property Catalog: TdxPDFCatalog read GetCatalog;
  public
    class function CreateOutlines(ABookmarks: TdxPDFBookmarkList): TdxPDFOutlines; static;
    constructor Create; overload;
    constructor Create(const AParent: IdxPDFBookmarkParent); overload; // for internal use
    constructor Create(const AParent: IdxPDFBookmarkParent; AItem: TdxPDFOutlineItem); overload; // for internal use
    destructor Destroy; override;
    //
    procedure Add(ABookmark: TdxPDFBookmark);
    procedure Clear;
    //
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TdxPDFBookmark read GetItem; default;
  end;

  { TdxPDFCatalog }

  TdxPDFCatalog = class(TdxPDFObject, IUnknown, IdxPDFBookmarkParent) // for internal use
  strict private
    FAcroForm: TdxPDFInteractiveForm;
    FBookmarks: TdxPDFBookmarkList;
    FDictionary: TdxPDFReaderDictionary;
    FFileAttachments: TdxPDFFileAttachmentList;
    FIsBookmarksChanged: Boolean;
    FMetadata: TdxPDFMetadata;
    FNames: TdxPDFDocumentNames;
    FNeedReadNames: Boolean;
    FNeedReadOutlines: Boolean;
    FOpenAction: TdxPDFCustomAction;
    FOpenDestination: TdxPDFCustomDestination;
    FOutlines: TdxPDFOutlines;
    FPages: TdxPDFPageList;
    //
    function GetAcroForm: TdxPDFInteractiveForm;
    function GetBookmarks: TdxPDFBookmarkList;
    function GetDictionary(const AKey: string): TdxPDFReaderDictionary;
    function GetFileAttachments: TdxPDFFileAttachmentList;
    function GetNames: TdxPDFDocumentNames;
    function GetOutlines: TdxPDFOutlines;
    function IsDictionaryAvailable: Boolean;
    procedure SetAcroForm(const AValue: TdxPDFInteractiveForm);
    procedure SetPages(const AValue: TdxPDFPageList);
    //
    function CanWriteAcroForm: Boolean;
    procedure CreateFileAttachments;
    procedure DestroyFileAttachments;
    procedure EnsureOutlines;
    procedure LockChanges(AProc: TProc); overload;
    procedure PerformFor<T: TdxPDFObject>(AList: TdxPDFReferencedObjects; ACondition: TFunc<T, Boolean>; AAction: TProc<T>);
    procedure ReadAcroForm;
    procedure ReadInteractiveObjects;
    procedure ReadMetadata;
    procedure ReadNames(ADictionary: TdxPDFReaderDictionary);
    procedure ReadOutlines(ADictionary: TdxPDFReaderDictionary);
    procedure ReadPages;
    procedure WriteInteractiveObjects(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
    // IdxPDFBookmarkParent
    function GetCatalog: TdxPDFCatalog;
    procedure IdxPDFBookmarkParent.Changed = BookmarksChanged;
    procedure BookmarksChanged;
    // IUnknown
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    //
    procedure OnPageDeletingHandler(Sender: TObject);
  protected
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure Initialize; override;
    procedure Read(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    function GetEmbeddedFileSpecification(const AName: string): TdxPDFFileSpecification;
    function GetDestination(const AName: string): TdxPDFCustomDestination;
    //
    function HasPageReference(AField: TdxPDFInteractiveFormField; APage: TdxPDFPage): Boolean; overload;
    function HasPageReference(AAnnotation: TdxPDFCustomAnnotation; APage: TdxPDFPage): Boolean; overload;
    procedure DeleteAnnotations(APage: TdxPDFPage);
    procedure DeleteDestinations(APage: TdxPDFPage);
    procedure DeleteFields(APage: TdxPDFPage);
    procedure Refresh;
    //
    property OpenAction: TdxPDFCustomAction read FOpenAction;
    property OpenDestination: TdxPDFCustomDestination read FOpenDestination;
  public
    class function GetTypeName: string; override;
    constructor Create(AParent: TdxPDFObject); override;
    //
    function IsEmpty: Boolean;
    procedure EnumAnnotations(AFunc: TFunc<TdxPDFCustomAnnotation, Boolean>);
    procedure LockChanges(AFunc: TFunc<Boolean>); overload;
    procedure RemoveAttachment(AAttachment: TdxPDFFileAttachment);
    //
    property AcroForm: TdxPDFInteractiveForm read GetAcroForm write SetAcroForm;
    property Bookmarks: TdxPDFBookmarkList read GetBookmarks;
    property FileAttachments: TdxPDFFileAttachmentList read GetFileAttachments;
    property Outlines: TdxPDFOutlines read GetOutlines;
    property Metadata: TdxPDFMetadata read FMetadata;
    property Names: TdxPDFDocumentNames read GetNames;
    property Pages: TdxPDFPageList read FPages write SetPages;
  end;

  { TdxPDFCustomCommand }

  TdxPDFCustomCommand = class(TdxPDFBase) // for internal use
  strict private
    function EnsureRange(const AValue: Double): Double; overload;
    function EnsureRange(const AValue: Integer): Integer; overload;
  protected
    class function GetObjectType: TdxPDFBaseType; override;
    function GetEquals(ACommand: TdxPDFCustomCommand): Boolean; virtual;
    procedure Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources); reintroduce; virtual;

    procedure WriteCommandName(AWriter: TdxPDFWriter);
    procedure WriteOperand(AWriter: TdxPDFWriter; const AOperand: Double); overload;
    procedure WriteOperand(AWriter: TdxPDFWriter; const AOperand: Integer); overload;
    procedure WriteOperand(AWriter: TdxPDFWriter; const AOperand: TdxSizeF); overload;
    procedure WriteOperand(AWriter: TdxPDFWriter; const AOperand: TdxPointF); overload;
    procedure WriteOperand(AWriter: TdxPDFWriter; const AOperand: string); overload;
    procedure WriteUnaryCommand(AWriter: TdxPDFWriter; const AOperand: Single); overload;
    procedure WriteUnaryCommand(AWriter: TdxPDFWriter; const AOperand: Integer); overload;
    procedure WriteUnaryCommand(AWriter: TdxPDFWriter; const AOperand: string); overload;
    procedure WriteUnaryCommand(AWriter: TdxPDFWriter; const AOperand: TdxPointF); overload;
  public
    constructor Create; overload; override;
    constructor Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources); overload; virtual;

    class function GetName: string; virtual;

    function GetCommandCount: Integer; virtual;
    function Equals(AObject: TObject): Boolean; override;
    procedure Execute(ACommandInterpreter: IdxPDFCommandInterpreter); virtual; abstract;
  end;

  { TdxPDFCommandList }

  TdxPDFCommandList = class(TdxPDFReferencedObjects)
  strict private
    function GetItem(Index: TdxListIndex): TdxPDFCustomCommand; inline;
  protected
    procedure Read(const AData: TBytes; ARepository: TdxPDFCustomRepository; AResources: TdxPDFResources); overload;
    procedure Read(AStream: TdxPDFStream; ARepository: TdxPDFCustomRepository; AResources: TdxPDFResources); overload;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary; AResources: TdxPDFResources);
  public
    function GetCommandCount: Integer;
    function ToByteArray(const AContext: IdxPDFWriterContext): TBytes; overload;
    function ToByteArray(const AContext: IdxPDFWriterContext; AResources: TdxPDFResources): TBytes; overload;
    //
    property Items[Index: TdxListIndex]: TdxPDFCustomCommand read GetItem; default;
  end;

  { TdxPDFDocumentRepository }

  TdxPDFDocumentRepository = class(TdxPDFCustomRepository) // for internal use
  strict private
    FCatalog: TdxPDFCatalog;
    FDocument: TObject;
    FEncryptionInfo: TdxPDFEncryptionInfo;
    FFolderName: string;
    FFontDataStorage: TdxPDFFontDataStorage;
    FFontProvider: TdxPDFFontProvider;
    FImageDataStorage: TdxPDFDocumentImageDataStorage;
    FLock: TRTLCriticalSection;
    FObjectHolder: TdxPDFReferencedObjects;
    FParent: TdxPDFObject;
    FParser: TdxPDFDocumentParser;
    FResolvedForms: TdxFastList; // T965896
    FResolvedInteractiveFormFields: TdxPDFObjectIndex;
    FResolvedWidgets: TdxPDFObjectIndex;
    FSharedResources: TdxPDFUniqueReferences;
    FStream: TStream;
    FXReferences: TDictionary<Integer, Int64>;
    //
    function CreateObjectParser(AObjectNumber: Integer): TdxPDFStructureParser;
    function GetFontProvider: TdxPDFFontProvider;
    function GetObjectCount: Integer;
    function ResolveIndirectObject(AObject: TdxPDFIndirectObject): TdxPDFReferencedObject;
    function ResolveIndirectReference(AReference: TdxPDFReference): TdxPDFReferencedObject;
    function ResolveStreamElement(AElement: TdxPDFStreamElement): TdxPDFReferencedObject;
    procedure AfterCreateForm(AForm: TdxPDFXForm);
    procedure ReplaceObject(ANumber: Integer; AObject: TdxPDFReferencedObject);
    procedure SetFontProvider(const AValue: TdxPDFFontProvider);
  protected
    OnAddField: TNotifyEvent;
    OnDeleteField: TNotifyEvent;
    //
    function CreateFontProvider: TdxPDFFontProvider; virtual;
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    //
    function CreateAcroForm: TdxPDFInteractiveForm;
    function CreateWidgetAnnotation(APage: TdxPDFPage; const ARect: TdxPDFRectangle;
      AFlags: TdxPDFAnnotationFlags): TdxPDFCustomAnnotation;
    function IsResourcesShared(AResources: TdxPDFResources): Boolean;
    function ResolveObject(ANumber: Integer): TdxPDFReferencedObject; override;
    procedure AddChange(AChange: TdxPDFDocumentChange);
    procedure AddHoldObject(AObject: TdxPDFObject);
    procedure Changed(AChanges: TdxPDFDocumentChanges);
    procedure DeleteHoldObject(AObject: TdxPDFObject);
    procedure RemoveResolvedForm(AForm: TdxPDFXForm);
    procedure UpdateStructure;
    //
    procedure AttachmentsChanged;
    procedure OutlinesChanged;
  public
    constructor Create(ADocument: TObject; AStream: TStream);
    //
    procedure Clear; override;
    //
    function CreateAction(ARawObject: TdxPDFReaderDictionary): TdxPDFCustomAction;
    function CreateAndRead(AClass: TdxPDFObjectClass; ARawObject: TdxPDFReaderDictionary; ARawObjectKey: string = ''): TdxPDFObject; overload;
    function CreateAndRead(AClass: TdxPDFObjectClass; ARawObject: TdxPDFReaderDictionary; AParent: TdxPDFObject; ARawObjectKey: string = ''): TdxPDFObject; overload;
    function CreateAndReadAnnotation(APage: TdxPDFPage; ARawObject: TdxPDFReaderDictionary): TdxPDFCustomAnnotation;
    function CreateAnnotation(APage: TdxPDFPage; ARawObject: TdxPDFReaderDictionary): TdxPDFCustomAnnotation;
    function CreateAppearance(const ABBox: TdxPDFRectangle): TdxPDFAnnotationAppearance; overload;
    function CreateAppearance(ARawObject: TdxPDFReaderDictionary; const AAppearanceName: string): TdxPDFAnnotationAppearance; overload;
    function CreateBorderStyle: TdxPDFAnnotationBorderStyle; overload;
    function CreateBorderStyle(ARawObject: TdxPDFReaderDictionary): TdxPDFAnnotationBorderStyle; overload;
    function CreateCatalog: TdxPDFCatalog;
    function CreateCharacterMapping(const AData: TBytes): TdxPDFCharacterMapping;
    function CreateCIDSystemInfo: TdxPDFCIDSystemInfo;
    function CreateColorSpace(AClass: TdxPDFObjectClass): TdxPDFCustomColorSpace; overload;
    function CreateColorSpace(AClass: TdxPDFObjectClass; AParent: TdxPDFObject): TdxPDFCustomColorSpace; overload;
    function CreateColorSpace(ARawObject: TdxPDFBase; AResources: TdxPDFResources = nil): TdxPDFCustomColorSpace; overload;
    function CreateColorSpace(const AName: string; AResources: TdxPDFResources): TdxPDFCustomColorSpace; overload;
    function CreateDeferredObject(AParent: TdxPDFObject; AResolvedObjectClass: TdxPDFObjectClass): TdxPDFDeferredObject; overload;
    function CreateDeferredObject(AParent: TdxPDFObject; const AInfo: TdxPDFDeferredObjectInfo): TdxPDFDeferredObject; overload;
    function CreateDeferredObject(const AInfo: TdxPDFDeferredObjectInfo): TdxPDFDeferredObject; overload;
    function CreateDestination(ARawObject: TdxPDFBase): TdxPDFCustomDestination;
    function CreateDictionary: TdxPDFReaderDictionary;
    function CreateFileSpecification(ARawObject: TdxPDFReaderDictionary): TdxPDFFileSpecification;
    function CreateFont(ARawObject: TdxPDFReaderDictionary): TdxPDFCustomFont; virtual;
    function CreateForm(ARawObject: TdxPDFReaderDictionary): TdxPDFXForm; overload;
    function CreateForm(ARawObject: TdxPDFStream): TdxPDFXForm; overload;
    function CreateForm(const ABBox: TdxPDFRectangle): TdxPDFXForm; overload;
    function CreateGraphicsStateParameters: TdxPDFGraphicsStateParameters; overload;
    function CreateGraphicsStateParameters(ARawObject: TdxPDFReaderDictionary): TdxPDFGraphicsStateParameters; overload;
    function CreateLineStyle(ARawObject: TdxPDFArray): TdxPDFLineStyle;
    function CreateMetadata: TdxPDFMetadata;
    function CreateImage: TdxPDFDocumentImage; overload;
    function CreateImage(AStream: TdxPDFStream): TdxPDFDocumentImage; overload;
    function CreateImage(AParent: TdxPDFObject): TdxPDFDocumentImage; overload;
    function CreateImage(AParent: TdxPDFObject; ARawObject: TdxPDFReaderDictionary): TdxPDFDocumentImage; overload;
    function CreateImage(AImage: TdxGPImageHandle): TdxPDFXObject; overload;
    function CreateInteractiveFormFieldCollection(AParent: TdxPDFObject): TdxPDFInteractiveFormFieldCollection;
    function CreateObject(AClass: TdxPDFObjectClass): TdxPDFObject; overload;
    function CreateObject(AClass: TdxPDFObjectClass; AParent: TdxPDFObject): TdxPDFObject; overload;
    function CreateObject(const ATypeName: string): TdxPDFObject; overload;
    function CreateObject(const ATypeName: string; AParent: TdxPDFObject): TdxPDFObject; overload;
    function CreatePattern(AClass: TdxPDFObjectClass): TdxPDFCustomPattern; overload;
    function CreatePattern(ARawObject: TdxPDFBase): TdxPDFCustomPattern; overload;
    function CreateResources: TdxPDFResources; overload;
    function CreateResources(ADictionary: TdxPDFReaderDictionary): TdxPDFResources; overload;
    function CreateShading(AClass: TdxPDFObjectClass): TdxPDFCustomShading; overload;
    function CreateShading(ARawObject: TdxPDFBase): TdxPDFCustomShading; overload;
    function CreateSolidLineStyle: TdxPDFLineStyle;
    function CreateSoftMask(AClass: TdxPDFObjectClass): TdxPDFCustomSoftMask; overload;
    function CreateSoftMask(ARawObject: TdxPDFBase): TdxPDFCustomSoftMask; overload;
    function CreateXObject(ARawObject: TdxPDFStream; const ASubtype: string = ''): TdxPDFXObject;
    //
    function AddSlot(AObject: TdxPDFBase): Integer;
    function CheckPassword(AAttemptsLimit: Integer; AOnGetPasswordEvent: TdxGetPasswordEvent): Boolean;
    function GetAction(ANumber: Integer): TdxPDFCustomAction; overload;
    function GetAction(AObject: TdxPDFBase): TdxPDFCustomAction; overload;
    function GetAnnotation(ANumber: Integer; APage: TdxPDFPage): TdxPDFCustomAnnotation; overload;
    function GetAnnotation(AObject: TdxPDFBase; APage: TdxPDFPage): TdxPDFCustomAnnotation; overload;
    function GetAnnotationAppearance(AObject: TdxPDFBase; const AParentBBox: TdxPDFRectangle): TdxPDFAnnotationAppearances;
    function GetDestination(ANumber: Integer): TdxPDFCustomDestination; overload;
    function GetDictionary(ANumber: Integer): TdxPDFReaderDictionary; overload;
    function GetInteractiveFormField(AForm: TdxPDFInteractiveForm; AParent: TdxPDFInteractiveFormField;
      ANumber: Integer): TdxPDFInteractiveFormField;
    function GetForm(ANumber: Integer): TdxPDFXForm;
    function ResolveField(ANumber: Integer): TdxPDFInteractiveFormField;
    function GetPage(ANumber: Integer): TdxPDFPage;
    function GetString(ANumber: Integer): string;
    function GetXObject(ANumber: Integer): TdxPDFXObject;
    function GetWidget(ANumber: Integer): TdxPDFCustomAnnotation;
    function IsSharedResources(AResources: TdxPDFResources): Boolean;
    function IsValidReferences: Boolean;
    function TryGetAnnotation(ANumber: Integer; out AAnnotation: TdxPDFCustomAnnotation): Boolean;
    function TryGetAsDictionary(AObject: TdxPDFBase; out ARawObject: TdxPDFReaderDictionary): Boolean;
    function TryGetDictionary(ANumber: Integer; out ARawObject: TdxPDFDictionary): Boolean;
    function TryGetDictionaryObject(ANumber: Integer; out ARawObject: TdxPDFBase): Boolean;
    function TryGetForm(ANumber: Integer; out AForm: TdxPDFXForm): Boolean;
    function TryGetObject(ANumber: Integer; out ARawObject: TdxPDFBase): Boolean;
    function TryGetResolvedObject(ANumber: Integer; out AObject: TdxPDFObject): Boolean;
    function TryGetStream(ANumber: Integer; out AStream: TdxPDFStream): Boolean;
    procedure AddStreamElement(ANumber: Integer; AObject: TdxPDFReferencedObject);
    procedure PerformBatchOperation(AProc: TProc);
    procedure ReadEncryptionInfo(ADictionary: TdxPDFDictionary; const ADocumentID: TdxPDFDocumentID);
    procedure RemoveCorruptedObjects;
    procedure RemoveObject(AObject: TdxPDFObject);
    //
    property Catalog: TdxPDFCatalog read FCatalog write FCatalog;
    property Document: TObject read FDocument write FDocument;
    property EncryptionInfo: TdxPDFEncryptionInfo read FEncryptionInfo;
    property FolderName: string read FFolderName;
    property FontProvider: TdxPDFFontProvider read GetFontProvider write SetFontProvider;
    property FontDataStorage: TdxPDFFontDataStorage read FFontDataStorage;
    property ImageDataStorage: TdxPDFDocumentImageDataStorage read FImageDataStorage;
    property ObjectCount: Integer read GetObjectCount;
    property Parent: TdxPDFObject read FParent;
    property Parser: TdxPDFDocumentParser read FParser;
    property Stream: TStream read FStream;
  end;

  { TdxPDFReaderDictionary }

  TdxPDFReaderDictionary = class(TdxPDFDictionary) // for internal use
  strict private
    FRepository: TdxPDFDocumentRepository;
  protected
    procedure ResolveArrayElements(AArray: TdxPDFArray); override;
  public
    constructor Create(ARepository: TdxPDFDocumentRepository);

    function GetAction(const AKey: string): TdxPDFCustomAction;
    function GetAnnotationCallout(const AKey: string): TdxPDFAnnotationCallout;
    function GetAnnotationHighlightingMode: TdxPDFAnnotationHighlightingMode;
    function GetAppearance(AResources: TdxPDFResources): TdxPDFCommandList;
    function GetColor(const AKey: string): TdxPDFColor;
    function GetDeferredFormFieldCollection(const AKey: string): TdxPDFInteractiveFormFieldCollection;
    function GetDestinationInfo(const AKey: string): TdxPDFDestinationInfo;
    function GetDictionary(const AKey: string; const AAlternateKey: string = ''): TdxPDFReaderDictionary; overload;
    function GetObject(const AKey: string): TdxPDFBase; override;
    function GetObjectNumber(const AKey: string): Integer;
    function GetTextJustify: TdxPDFTextJustify;
    function TryGetArray(const AKey: string; out AValue: TdxPDFArray): Boolean; override;
    function TryGetDictionary(const AKey: string; out AValue: TdxPDFReaderDictionary): Boolean;
    function TryGetStreamDictionary(const AKey: string; out AValue: TdxPDFReaderDictionary): Boolean;
    function GetResources(const AKey: string): TdxPDFResources;
    procedure PopulateList(const AKey: string; AProc: TProc<string>);

    property Repository: TdxPDFDocumentRepository read FRepository;
  end;

  { TdxPDFHyperlink }

  TdxPDFHyperlink = class(TdxPDFRecognizedObject)
  strict private
    FAnnotation: TdxPDFCustomAnnotation;
    //
    function GetInteractiveOperation: TdxPDFInteractiveOperation;
  protected
    function GetHint: string;
    function GetHitCode: Integer; override; 
    procedure SetAnnotation(const AValue: TdxPDFCustomAnnotation);
    //
    property InteractiveOperation: TdxPDFInteractiveOperation read GetInteractiveOperation;
  public
    destructor Destroy; override;
    //
    property Hint: string read GetHint; 
  end;
  TdxPDFHyperlinkList = class(TdxPDFRecognizedObjectList<TdxPDFHyperlink>);

  { TdxPDFRecognizedContent }

  TdxPDFRecognizedContent = class // for internal use
  strict private
    FHyperlinks: TdxPDFHyperlinkList;
    FImages: TdxPDFImageList;
    FTextLines: TdxPDFTextLineList;
    function GetText: string;
  public
    constructor Create;
    destructor Destroy; override;

    property Hyperlinks: TdxPDFHyperlinkList read FHyperlinks; // for internal use
    property Images: TdxPDFImageList read FImages; // for internal use
    property Text: string read GetText; // for internal use
    property TextLines: TdxPDFTextLineList read FTextLines; // for internal use
  end;

  { TdxPDFGraphicsState }

  TdxPDFGraphicsState = class(TdxPDFReferencedObject) // for internal use
  strict private
    FNonStrokingColor: TdxPDFColor;
    FNonStrokingColorSpace: TdxPDFCustomColorSpace;
    FParameters: TdxPDFGraphicsStateParameters;
    FStrokingColor: TdxPDFColor;
    FStrokingColorSpace: TdxPDFCustomColorSpace;
    FTextState: TdxPDFTextState;

    FDeviceTransformMatrix: TdxPDFTransformationMatrix;
    FSoftMaskTransformMatrix: TdxPDFTransformationMatrix;
    FTransformMatrix: TdxPDFTransformationMatrix;

    procedure SetNonStrokingColorSpace(const AValue: TdxPDFCustomColorSpace);
    procedure SetStrokingColorSpace(const AValue: TdxPDFCustomColorSpace);
    procedure RecreateTextState;
    procedure RecreateParameters;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Assign(AGraphicsState: TdxPDFGraphicsState);
    procedure ApplyParameters(AParameters: TdxPDFGraphicsStateParameters; AClone: Boolean = False);
    procedure Reset;
    function Clone: TdxPDFGraphicsState;

    property DeviceTransformMatrix: TdxPDFTransformationMatrix read FDeviceTransformMatrix;
    property NonStrokingColor: TdxPDFColor read FNonStrokingColor write FNonStrokingColor;
    property NonStrokingColorSpace: TdxPDFCustomColorSpace read FNonStrokingColorSpace write SetNonStrokingColorSpace;
    property Parameters: TdxPDFGraphicsStateParameters read FParameters;
    property SoftMaskTransformMatrix: TdxPDFTransformationMatrix read FSoftMaskTransformMatrix write FSoftMaskTransformMatrix;
    property StrokingColor: TdxPDFColor read FStrokingColor write FStrokingColor;
    property StrokingColorSpace: TdxPDFCustomColorSpace read FStrokingColorSpace write SetStrokingColorSpace;
    property TextState: TdxPDFTextState read FTextState write FTextState;
    property TransformMatrix: TdxPDFTransformationMatrix read FTransformMatrix write FTransformMatrix;
  end;

  { TdxPDFTextParser }

  TdxPDFTextParser = class // for internal use
  strict private
    FContent: TdxPDFRecognizedContent;
    FFontDataStorage: TObjectDictionary<TdxPDFCustomFont, TdxPDFFontData>;
    FPageBlocks: TObjectList<TdxPDFTextBlock>;
    FPageCropBox: TdxRectF;
    FParserState: TdxPDFTextParserState;
  public
    constructor Create(const APageCropBox: TdxRectF; AContent: TdxPDFRecognizedContent);
    destructor Destroy; override;

    procedure AddBlock(const AStringData: TdxPDFStringData; AState: TdxPDFGraphicsState);
    procedure Parse;
  end;

  { TdxPDFTextUtils }

  TdxPDFTextUtils = class(TdxPDFRecognizedTextUtils)
  public
    class function ConvertToString(const ARanges: TdxPDFPageTextRanges; APages: TdxPDFPageList): string; overload;
  end;

  { TdxPDFCustomImageAppearanceInfo }

  TdxPDFCustomImageAppearanceInfo = class(TPersistent)
  strict private
    FFitMode: TcxImageFitMode;
    FImage: TdxSmartImage;
    FRotationAngle: TcxRotationAngle;
    //
    procedure SetImage(const AValue: TdxSmartImage);
  protected
    property FitMode: TcxImageFitMode read FFitMode write FFitMode;
    property Image: TdxSmartImage read FImage write SetImage;
    property RotationAngle: TcxRotationAngle read FRotationAngle write FRotationAngle;
  public
    Bounds: TdxPDFPageRect;
    //
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  end;

function dxPDFGetDocumentObjectClass(const ATypeName: string): TdxPDFObjectClass; // for internal use
function dxPDFTryGetDocumentObjectClass(const ATypeName: string; out AClass: TdxPDFObjectClass): Boolean; // for internal use
procedure dxPDFRegisterDocumentObjectClass(AClass: TdxPDFObjectClass); overload; // for internal use
procedure dxPDFRegisterDocumentObjectClass(const AName: string; AClass: TdxPDFObjectClass); overload; // for internal use
procedure dxPDFUnregisterDocumentObjectClass(AClass: TdxPDFObjectClass); overload; // for internal use
procedure dxPDFUnregisterDocumentObjectClass(const AName: string; AClass: TdxPDFObjectClass); overload; // for internal use

implementation

uses
  RTLConsts, Variants, Math, TypInfo, Character, Contnrs, IOUtils, dxDPIAwareUtils, cxDateUtils, StrUtils, cxLibraryConsts,
  dxStringHelper, dxTypeHelpers, dxHash, dxPDFDocument, dxPDFCommandInterpreter,
  dxPDFColorSpace, dxPDFFont, dxPDFFontEncoding, dxPDFCommand, dxPDFFunction, dxPDFShading, dxPDFType1Font, dxPDFDestination,
  dxPDFFontUtils, dxPDFUtils, dxPDFInteractivity, dxPDFFlateLZW, dxPDFSignature, dxPDFContext, dxPDFInteractiveFormField,
  dxPDFAnnotation, dxPDFAppearanceBuilder, dxPDFImageToXObjectConverter, dxPDFCommandConstructor, dxPDFDocumentState;

const
  dxThisUnitName = 'dxPDFCore';

type
  TdxPDFBaseAccess = class(TdxPDFBase);
  TdxPDFBaseParserAccess = class(TdxPDFBaseParser);
  TdxPDFBaseStreamAccess = class(TdxPDFBaseStream);
  TdxPDFDictionaryAccess = class(TdxPDFDictionary);
  TdxPDFDocumentAccess = class(TdxPDFDocument);
  TdxPDFDocumentStreamObjectAccess = class(TdxPDFStreamObject);
  TdxPDFImageAccess = class(TdxPDFImage);
  TdxPDFJumpActionAccess = class(TdxPDFJumpAction);
  TdxPDFLineStyleAccess = class(TdxPDFLineStyle);
  TdxPDFLinkAnnotationAccess = class(TdxPDFLinkAnnotation);
  TdxPDFMarkupAnnotationAccess = class(TdxPDFMarkupAnnotation);
  TdxPDFNumericObjectAccess = class(TdxPDFNumericObject);
  TdxPDFPagesAccess = class(TdxPDFPages);
  TdxPDFTextLineAccess = class(TdxPDFTextLine);
  TdxPDFWidgetAnnotationAccess = class(TdxPDFWidgetAnnotation);

  { TdxPDFWriterDataObject }

  TdxPDFWriterDataObject = class(TdxPDFObject) // for internal use
  strict private
    FData: TdxPDFBase;
    procedure SetData(AValue: TdxPDFBase);
  protected
    function Write(AHelper: TdxPDFWriterHelper): TdxPDFBase; override;
  public
    constructor Create(const AData: TdxPDFBase);
    destructor Destroy; override;
    //
    property Data: TdxPDFBase read FData write SetData;
  end;

  { TdxPDFObjectStreamElementInfo }

  TdxPDFObjectStreamElementInfo = record // for internal use
  private
    FNumber: Integer;
    FOffset: Integer;
  public
    class function Create(ANumber, AOffset: Integer): TdxPDFObjectStreamElementInfo; static;
    property Number: Integer read FNumber;
    property Offset: Integer read FOffset;
  end;

  { TdxPDFObjectStreamElementInfoList }

  TdxPDFObjectStreamElementInfoList = class(TList<TdxPDFObjectStreamElementInfo>); // for internal use

  { TdxPDFTextWordCharacterComparer }

  TdxPDFTextWordCharacterComparer = class(TComparer<TdxPDFTextCharacter>) // for internal use
  public
    function Compare(const Left, Right: TdxPDFTextCharacter): Integer; override;
  end;

  { TdxPDFObjectFactory }

  TdxPDFObjectFactory = class(TdxPDFFactory<TdxPDFObjectClass>)
  public
    function GetObjectClass(const AType: string): TdxPDFObjectClass;
    procedure RegisterClass(AClass: TdxPDFObjectClass); overload;
    procedure UnregisterClass(AClass: TdxPDFObjectClass); overload;
  end;

  { TdxPDFReaderObjectStream }

  TdxPDFReaderObjectStream = class(TdxPDFBase)
  strict private
    FObjects: TdxPDFReferencedObjects;
  protected
    class function GetObjectType: TdxPDFBaseType; override;
  public
    constructor Create(ANumber: Integer; AStream: TdxPDFStream);
    destructor Destroy; override;
    //
    property Objects: TdxPDFReferencedObjects read FObjects;
  end;

  { TdxPDFDocumentRepositoryParent }

  TdxPDFDocumentRepositoryParent = class(TdxPDFObject) // for internal use
  strict private
    FRepository: TdxPDFDocumentRepository;
  strict protected
    function GetRepository: TdxPDFDocumentRepository; override;
  public
    constructor Create(ARepository: TdxPDFDocumentRepository); reintroduce;
  end;

  { TdxPDFWidgetAnnotationRemover }

  TdxPDFWidgetAnnotationRemover = class
  strict private
    FAnnotationList: TdxPDFReferencedObjects;
  protected
    function DoRemove(AWidget: TdxPDFWidgetAnnotation): Boolean; virtual;
  public
    constructor Create(APage: TdxPDFPage); virtual;
    function Remove(AAnnotationList: TdxFastList): Boolean;
  end;

  { TdxPDFWidgetAnnotationFlattener }

  TdxPDFWidgetAnnotationFlattener = class(TdxPDFWidgetAnnotationRemover)
  strict private
    FConstructor: TdxPDFCommandConstructor;
    FPage: TdxPDFPage;
    FReplaceCommands: Boolean;
  protected
    function DoRemove(AWidget: TdxPDFWidgetAnnotation): Boolean; override;
  public
    constructor Create(APage: TdxPDFPage); override;
    destructor Destroy; override;
  end;

var
  dxgPDFDocumentObjectFactory: TdxPDFObjectFactory;
  dxgPDFEmptyEncoding: TdxFontFileCustomEncoding;

function HasFlag(ASourceFlags, AFlags: TdxPDFGlyphMappingFlags): Boolean;
begin
  Result := (Integer(ASourceFlags) and Integer(AFlags)) <> 0;
end;

function dxPDFIsObjectSupported(ADictionary: TdxPDFDictionary; const ATypeName: string): Boolean;
begin
  Result := dxPDFGetDocumentObjectClass(ADictionary.GetString(ATypeName)) <> nil;
end;

function dxPDFDocumentObjectFactory: TdxPDFObjectFactory;
begin
  if dxgPDFDocumentObjectFactory = nil then
    dxgPDFDocumentObjectFactory := TdxPDFObjectFactory.Create;
  Result := dxgPDFDocumentObjectFactory;
end;

function dxPDFCreateDocumentObject(AParent: TdxPDFObject; ADictionary: TdxPDFDictionary;
  const ATypeName: string; ARepository: TdxPDFDocumentRepository): TdxPDFObject;
var
  AClass: TdxPDFObjectClass;
begin
  if dxPDFTryGetDocumentObjectClass(ADictionary.GetString(ATypeName), AClass) then
    Result := ARepository.CreateObject(AClass, AParent)
  else
    Result := nil;
end;

function dxPDFGetDocumentObjectClass(const ATypeName: string): TdxPDFObjectClass;
begin
  Result := dxPDFDocumentObjectFactory.GetObjectClass(ATypeName);
end;

function dxPDFTryGetDocumentObjectClass(const ATypeName: string; out AClass: TdxPDFObjectClass): Boolean;
begin
  AClass := dxPDFGetDocumentObjectClass(ATypeName);
  Result := AClass <> nil;
end;

procedure dxPDFUnregisterDocumentObjectClass(const AName: string; AClass: TdxPDFObjectClass);
begin
  if dxgPDFDocumentObjectFactory <> nil then
    dxPDFDocumentObjectFactory.UnregisterClass(AName);
end;

procedure dxPDFUnregisterDocumentObjectClass(AClass: TdxPDFObjectClass);
begin
  dxPDFUnregisterDocumentObjectClass(AClass.GetTypeName, AClass);
end;

procedure dxPDFRegisterDocumentObjectClass(AClass: TdxPDFObjectClass);
begin
  dxPDFRegisterDocumentObjectClass(AClass.GetTypeName, AClass);
end;

procedure dxPDFRegisterDocumentObjectClass(const AName: string; AClass: TdxPDFObjectClass);
begin
  dxPDFDocumentObjectFactory.Register(AName, AClass);
end;

{ TdxPDFWriterDataObject }

constructor TdxPDFWriterDataObject.Create(const AData: TdxPDFBase);
begin
  Data := AData;
end;

destructor TdxPDFWriterDataObject.Destroy;
begin
  Data := nil;
  inherited Destroy;
end;

procedure TdxPDFWriterDataObject.SetData(AValue: TdxPDFBase);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FData));
end;

function TdxPDFWriterDataObject.Write(AHelper: TdxPDFWriterHelper): TdxPDFBase;
begin
  Result := Data;
end;

{ TdxPDFObjectStreamElementInfo }

class function TdxPDFObjectStreamElementInfo.Create(ANumber, AOffset: Integer): TdxPDFObjectStreamElementInfo;
begin
  Result.FNumber := ANumber;
  Result.FOffset := AOffset;
end;

{ TdxPDFTextWordCharacterComparer }

function TdxPDFTextWordCharacterComparer.Compare(const Left, Right: TdxPDFTextCharacter): Integer;
begin
  Result := IfThen(TdxPDFTextUtils.GetOrientedDistance(Left.Bounds.TopLeft, Right.Bounds.TopLeft, Left.Bounds.Angle) < 0, 1, -1);
end;

{ TdxPDFExportParameters }

constructor TdxPDFExportParameters.Create;
begin
  inherited Create;
end;

constructor TdxPDFExportParameters.Create(AState: TObject);
begin
  inherited Create;
  FDocumentState := AState as TdxPDFDocumentState;
  Angle := TdxPDFDocumentState(FDocumentState).RotationAngle;
end;

function TdxPDFExportParameters.IsCanceled: Boolean;
begin
  Result := Assigned(CancelCallback) and CancelCallback;
end;

{ TdxPDFObjectFactory }

function TdxPDFObjectFactory.GetObjectClass(const AType: string): TdxPDFObjectClass;
begin
  if not TryGetClass(AType, Result) then
    Result := nil;
end;

procedure TdxPDFObjectFactory.RegisterClass(AClass: TdxPDFObjectClass);
begin
  Register(AClass.GetTypeName, AClass);
end;

procedure TdxPDFObjectFactory.UnregisterClass(AClass: TdxPDFObjectClass);
begin
  UnregisterClass(AClass.GetTypeName);
end;

{ TdxPDFReaderObjectStream }

constructor TdxPDFReaderObjectStream.Create(ANumber: Integer; AStream: TdxPDFStream);

  procedure ReadObjectInfos(const AData: TBytes; AObjectCount: Integer;
    AObjectInfos: TdxPDFObjectStreamElementInfoList);
  var
    AParser: TdxPDFBaseParserAccess;
    I, AObjectNumber, AObjectOffset: Integer;
  begin
    AParser := TdxPDFBaseParserAccess(TdxPDFBaseParser.Create(AData, 0));
    try
      for I := 0 to AObjectCount - 1 do
      begin
        AParser.SkipSpaces;
        AObjectNumber := AParser.ReadInteger;
        AParser.ReadNext;
        AObjectOffset := AParser.ReadInteger;
        AParser.ReadNext;
       if TdxPDFUtils.IsIntegerValid(AObjectNumber) and TdxPDFUtils.IsIntegerValid(AObjectOffset) then
          AObjectInfos.Add(TdxPDFObjectStreamElementInfo.Create(AObjectNumber, AObjectOffset))
      end;
    finally
      AParser.Free;
    end;
  end;

  procedure ReadObjects(const AData: TBytes; AElementInfos: TdxPDFObjectStreamElementInfoList;
    AObjectsStart: Integer);
  var
    AObject: TdxPDFBase;
    AParser: TdxPDFStructureParser;
    I: Integer;
  begin
    AParser := TdxPDFStructureParser.Create(TdxPDFReaderDictionary(AStream.Dictionary).Repository);
    try
      for I := 0 to AElementInfos.Count - 1 do
      begin
        AObject := AParser.ReadObject(AData, AObjectsStart + AElementInfos[I].Offset);
        AObject.Number := AElementInfos[I].Number;
        if AObject <> nil  then
          FObjects.Add(AObject);
      end;
      FObjects.TrimExcess;
    finally
      AParser.Free;
    end;
  end;

var
  AData: TBytes;
  AObjectCount, AObjectsStart: Integer;
  AObjectInfos: TdxPDFObjectStreamElementInfoList;
begin
  inherited Create(ANumber, ANumber);
  AObjectCount := AStream.Dictionary.GetInteger(TdxPDFKeywords.Count);
  AObjectsStart := AStream.Dictionary.GetInteger('First');
  if TdxPDFUtils.IsIntegerValid(AObjectCount) or TdxPDFUtils.IsIntegerValid(AObjectsStart) and
    (AStream.Dictionary.GetString(TdxPDFKeywords.TypeKey) = TdxPDFKeywords.ObjectStream) then
  begin
    FObjects := TdxPDFReferencedObjects.Create;
    AData := AStream.UncompressedData;
    AObjectInfos := TdxPDFObjectStreamElementInfoList.Create;
    try
      ReadObjectInfos(AData, AObjectCount, AObjectInfos);
      ReadObjects(AData, AObjectInfos, AObjectsStart);
    finally
      AObjectInfos.Free;
    end;
  end;
end;

destructor TdxPDFReaderObjectStream.Destroy;
begin
  FreeAndNil(FObjects);
  inherited Destroy;
end;

class function TdxPDFReaderObjectStream.GetObjectType: TdxPDFBaseType;
begin
  Result := otObjectStream;
end;

{ TdxPDFDocumentRepositoryParent }

constructor TdxPDFDocumentRepositoryParent.Create(ARepository: TdxPDFDocumentRepository);
begin
  inherited Create(nil);
  FRepository := ARepository;
end;

function TdxPDFDocumentRepositoryParent.GetRepository: TdxPDFDocumentRepository;
begin
  Result := FRepository;
end;

{ TdxPDFWidgetAnnotationRemover }

constructor TdxPDFWidgetAnnotationRemover.Create(APage: TdxPDFPage);
begin
  inherited Create;
  FAnnotationList := APage.Annotations;
end;

function TdxPDFWidgetAnnotationRemover.Remove(AAnnotationList: TdxFastList): Boolean;
var
  AAnnotation: TdxPDFWidgetAnnotation;
  AIndex: Integer;
  AIsAnnotationRemoved: Boolean;
begin
  AIsAnnotationRemoved := False;
  AIndex := 0;
  while AIndex < FAnnotationList.Count do
  begin
    AAnnotation := Safe<TdxPDFWidgetAnnotation>.Cast(FAnnotationList[AIndex]);
    if (AAnnotation <> nil) and (AAnnotationList.IndexOf(AAnnotation) <> -1) then
    begin
      AIsAnnotationRemoved := True;
      DoRemove(AAnnotation);
    end
    else
      Inc(AIndex);
  end;
  Result := AIsAnnotationRemoved;
end;

function TdxPDFWidgetAnnotationRemover.DoRemove(AWidget: TdxPDFWidgetAnnotation): Boolean;
begin
  Result := FAnnotationList.Remove(AWidget) <> -1;
end;

{ TdxPDFWidgetAnnotationFlattener }

constructor TdxPDFWidgetAnnotationFlattener.Create(APage: TdxPDFPage);
var
  AData: TBytes;
begin
  inherited Create(APage);
  FPage := APage;
  FConstructor := TdxPDFCommandConstructor.Create(APage.Resources);
  FConstructor.SaveGraphicsState;
  AData := APage.Data.CommandsData;
  FConstructor.AddCommands(AData);
  FConstructor.RestoreGraphicsState;
end;

function TdxPDFWidgetAnnotationFlattener.DoRemove(AWidget: TdxPDFWidgetAnnotation): Boolean;
var
  AAnnotationRect: TdxPDFRectangle;
  AAppearanceForm: TdxPDFXForm;
begin
  Result := inherited DoRemove(AWidget);
  if not Result then
    Exit;
  AAnnotationRect := AWidget.Rect;
  if not AWidget.IsHidden and (AAnnotationRect.Width > 0) and (AAnnotationRect.Height > 0) then
  begin
    AAppearanceForm := AWidget.EnsureAppearance;
    if AAppearanceForm <> nil then
    begin
      FConstructor.DrawForm(AAppearanceForm, AAppearanceForm.GetTransformationMatrix(AAnnotationRect));
      FReplaceCommands := True;
    end;
  end;
end;

destructor TdxPDFWidgetAnnotationFlattener.Destroy;
begin
  if FReplaceCommands then
    FPage.Data.ReplaceCommands(FConstructor.Commands);
  FreeAndNil(FConstructor);
  inherited Destroy;
end;

{ TdxPDFCommandList }

function TdxPDFCommandList.GetCommandCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Count - 1 do
    Inc(Result, Items[I].GetCommandCount);
end;

function TdxPDFCommandList.ToByteArray(const AContext: IdxPDFWriterContext): TBytes;
var
  AResources: TdxPDFResources;
begin
  AResources := TdxPDFResources.Create(nil);
  try
    Result := ToByteArray(AContext, AResources);
  finally
    dxPDFFreeObject(AResources);
  end;
end;

function TdxPDFCommandList.ToByteArray(const AContext: IdxPDFWriterContext; AResources: TdxPDFResources): TBytes;
var
  AWriter: TdxPDFWriter;
  I: Integer;
begin
  AWriter := TdxPDFWriter.Create(TdxPDFMemoryStream.Create, True);
  try
    for I := 0 to Count - 1 do
    begin
      Items[I].Write(AWriter, AContext, AResources);
      AWriter.WriteLineFeed;
    end;
    Result := TdxPDFMemoryStream(AWriter.Stream).Data;
  finally
    AWriter.Free;
  end;
end;

procedure TdxPDFCommandList.Read(const AData: TBytes; ARepository: TdxPDFCustomRepository; AResources: TdxPDFResources);
begin
  TdxPDFCommandStreamParser.Parse(ARepository, AData, Self, AResources);
end;

procedure TdxPDFCommandList.Read(AStream: TdxPDFStream; ARepository: TdxPDFCustomRepository; AResources: TdxPDFResources);
begin
  if AStream <> nil then
    Read(AStream.UncompressedData, ARepository, AResources)
  else
    Clear;
end;

procedure TdxPDFCommandList.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary; AResources: TdxPDFResources);
begin
  ADictionary.SetStreamData(ToByteArray(AHelper.Context, AResources));
end;

function TdxPDFCommandList.GetItem(Index: TdxListIndex): TdxPDFCustomCommand;
begin
  Result := inherited Items[Index] as TdxPDFCustomCommand;
end;

{ TdxPDFFontInfo }

function TdxPDFFontInfo.GetFontLineSize: Single;
begin
  Result := FontSize / 14.0;
end;

{ TdxPDFWriterArray }

constructor TdxPDFWriterArray.Create(AHelper: TdxPDFWriterHelper);
begin
  inherited Create;
  FHelper := AHelper;
end;

procedure TdxPDFWriterArray.AddReference(const AData: TdxPDFBase);
begin
  if AData <> nil then
    AddReference(FHelper.CreateIndirectObject(AData))
  else
    Add(0);
end;

procedure TdxPDFWriterArray.AddReference(const AObject: TdxPDFObject);
begin
  if AObject <> nil then
    AddReference(FHelper.RegisterIndirectObject(AObject))
  else
    Add(0);
end;

{ TdxPDFWriterDictionary }

constructor TdxPDFWriterDictionary.Create(AHelper: TdxPDFWriterHelper);
begin
  inherited Create;
  FHelper := AHelper;
end;

procedure TdxPDFWriterDictionary.Add(const AKey: string; AObjectList: TdxPDFObjectList);
begin
  if AObjectList.Count > 0 then
    AddInline(AKey, AObjectList);
end;

procedure TdxPDFWriterDictionary.Add(const AKey: string; AObject: TdxPDFCustomColorSpace);
begin
  if AObject <> nil then
    Add(AKey, FHelper.PrepareToWrite(AObject));
end;

procedure TdxPDFWriterDictionary.Add(const AKey: string; const AColor: TdxPDFColor);
begin
{$IFDEF DEBUG}
  if AColor.Pattern <> nil then
    TdxPDFUtils.RaiseTestException;
{$ENDIF}
  if not AColor.IsNull then
    Add(AKey, AColor.Components);
end;

procedure TdxPDFWriterDictionary.Add(const AKey: string; const ADestinationInfo: TdxPDFDestinationInfo);
begin
  if ADestinationInfo <> nil then
    Add(AKey, ADestinationInfo.Write(FHelper));
end;

procedure TdxPDFWriterDictionary.Add(const AKey: string; const AList: TStringList);
var
  I: Integer;
  AArray: TdxPDFArray;
begin
  if AList.Count = 0 then
    Exit;
  AArray := FHelper.CreateArray;
  for I := 0 to AList.Count - 1 do
    AArray.Add(AList[I]);
  Add(AKey, AArray);
end;

procedure TdxPDFWriterDictionary.AddInline(const AKey: string; const ATree: TdxPDFCustomTree);
begin
  if ATree <> nil then
    Add(AKey, ATree.Write(FHelper));
end;

procedure TdxPDFWriterDictionary.Add(const AKey: string; AMask: TdxPDFCustomSoftMask);
begin
  AddNameOrReference(AKey, AMask);
end;

procedure TdxPDFWriterDictionary.Add(const AKey: string; AEncoding: TdxPDFCustomEncoding);
begin
  AddNameOrReference(AKey, AEncoding);
end;

procedure TdxPDFWriterDictionary.AddInline(const AKey: string; AObject: TdxPDFObject);
begin
  if AObject <> nil then
    Add(AKey, AObject.Write(FHelper));
end;

procedure TdxPDFWriterDictionary.AddNameOrReference(const AKey: string; AObject: TdxPDFObject);
var
  AData: TdxPDFBase;
begin
  if AObject <> nil then
  begin
    AData := FHelper.GetNameOrReference(AObject);
    if AData <> nil then
      Add(AKey, AData);
  end;
end;

procedure TdxPDFWriterDictionary.AddReference(const AKey: string; AData: TdxPDFBase);
begin
  if AData <> nil then
    AddReference(AKey, FHelper.CreateIndirectObject(AData));
end;

procedure TdxPDFWriterDictionary.AddReference(const AKey: string; AObject: TdxPDFObject);
begin
  if AObject <> nil then
    AddReference(AKey, FHelper.RegisterIndirectObject(AObject));
end;

procedure TdxPDFWriterDictionary.AddReference(const AKey: string; const AData: TBytes; ASkipIfNull: Boolean = True);
begin
  if not ASkipIfNull or (Length(AData) > 0) then
    AddReference(AKey, FHelper.CreateStream(AData));
end;

procedure TdxPDFWriterDictionary.SetAppearance(AResources: TdxPDFResources; ACommands: TdxPDFCommandList);
begin
  if ACommands <> nil then
    AddBytes(TdxPDFKeywords.DictionaryAppearance, ACommands.ToByteArray(FHelper.Context, AResources));
end;

procedure TdxPDFWriterDictionary.SetStreamData(const AData: TBytes);
begin
  SetStreamData(AData, True, True);
end;

procedure TdxPDFWriterDictionary.SetStreamData(const AData: TBytes; ACanCompress, ACanEncrypt: Boolean);
begin
{$IFNDEF DXPDF_DONT_COMPRESS_STREAMS}
  if Contains(TdxPDFKeywords.Filter) then
{$ENDIF}
    ACanCompress := False;

  if ACanCompress then
  begin
    FStreamData := TdxPDFFlateEncoder.Compress(AData);
    if Length(FStreamData) > 0 then
      AddName(TdxPDFKeywords.Filter, TdxPDFKeywords.FlateDecode);
  end
  else
    FStreamData := AData;

  Add(TdxPDFKeywords.Length, Length(FStreamData));
  FStreamDataCanEncrypt := ACanEncrypt;
end;

procedure TdxPDFWriterDictionary.SetTextJustify(AValue: TdxPDFTextJustify);
begin
  Add(TdxPDFKeywords.TextJustify, Integer(AValue));
end;

procedure TdxPDFWriterDictionary.Write(AWriter: TdxPDFWriter);
begin
  if FStreamDataCanEncrypt then
  begin
    FStreamData := AWriter.Encrypt(FStreamData);
    Add(TdxPDFKeywords.Length, Length(FStreamData));
  end;
  inherited Write(AWriter);
end;

procedure TdxPDFWriterDictionary.WriteStream(AWriter: TdxPDFWriter);
begin
  if StreamRef <> nil then
    TdxPDFUtils.RaiseTestException('StreamRef <> nil');
  WriteStreamData(AWriter, FStreamData);
end;

{ TdxPDFWriterHelper }

class function TdxPDFWriterHelper.WriteInlineColorSpace(AColorSpace: TdxPDFCustomColorSpace): TdxPDFBase;
var
  AHelper: TdxPDFWriterHelper;
begin
  AHelper := TdxPDFWriterHelper.CreateWithEmptyContext;
  AColorSpace.BeginInlineWriting;
  try
    Result := AColorSpace.Write(AHelper);
  finally
    AColorSpace.EndInlineWriting;
    AHelper.Free;
  end;
end;

constructor TdxPDFWriterHelper.Create(const AContext: IdxPDFWriterContext; const AEncryptionInfo: IdxPDFEncryptionInfo);
begin
  CreateWithEmptyContext;
  FEncryptionInfo := AEncryptionInfo;
  FContext := AContext;
  dxTestCheck(FContext <> nil, 'FContext = nil');
end;

constructor TdxPDFWriterHelper.CreateWithEmptyContext;
begin
  inherited Create;
  FTemporaryObjects := TcxObjectList.Create;
end;

destructor TdxPDFWriterHelper.Destroy;
begin
  FreeAndNil(FTemporaryObjects);
  inherited Destroy;
end;

function TdxPDFWriterHelper.CreateArray: TdxPDFWriterArray;
begin
  Result := TdxPDFWriterArray.Create(Self);
end;

function TdxPDFWriterHelper.CreateDictionary: TdxPDFWriterDictionary;
begin
  Result := TdxPDFWriterDictionary.Create(Self);
end;

function TdxPDFWriterHelper.CreateIndirectObject(AData: TdxPDFBase): TdxPDFObject;
begin
  Result := TdxPDFWriterDataObject.Create(AData);
  FTemporaryObjects.Add(Result);
end;

function TdxPDFWriterHelper.CreateStream(const AData: TBytes): TdxPDFObject;
begin
  Result := CreateStream(CreateDictionary, AData);
end;

function TdxPDFWriterHelper.GetFontName(const AName: string): string;
begin
  Result := FContext.FindFontName(AName);
end;

function TdxPDFWriterHelper.GetDestinationName(const AName: string): string;
begin
  Result := FContext.GetDestinationName(AName)
end;

function TdxPDFWriterHelper.CreateStream(ADictionary: TdxPDFWriterDictionary; const AData: TBytes): TdxPDFObject;
begin
  ADictionary.SetStreamData(AData);
  Result := CreateIndirectObject(ADictionary);
end;

function TdxPDFWriterHelper.GetNameOrReference(AObject: TdxPDFObject): TdxPDFBase;
begin
  Result := AObject.Write(Self);
  if (Result <> nil) and (Result.ObjectType <> otName) then
    Result := TdxPDFReference.Create(RegisterIndirectObject(CreateIndirectObject(Result)), 0);
end;

function TdxPDFWriterHelper.PrepareToWrite(AColorSpace: TdxPDFCustomColorSpace): TdxPDFBase;
var
  AInlineData: TdxPDFBase;
begin
  if AColorSpace = nil then
    Exit(nil);

  AInlineData := AColorSpace.Write(Self);
  try
    if (AInlineData is TdxPDFArray) and (TdxPDFArray(AInlineData).Count = 1) then
    begin
      Result := TdxPDFArray(AInlineData).Elements[0];
      TdxPDFArray(AInlineData).ElementList.Extract(Result);
      TdxPDFBaseAccess(Result).ResetReferenceCount;
    end
    else
      Result := TdxPDFReference.Create(RegisterIndirectObject(AColorSpace), 0);
  finally
    AInlineData.Free;
  end;
end;

function TdxPDFWriterHelper.RegisterIndirectObject(AObject: TdxPDFObject): Integer;
begin
  if AObject <> nil then
    Result := FContext.GetObjectNumber(AObject)
  else
    Result := -1;
end;

function TdxPDFWriterHelper.GetEncryptionInfo: IdxPDFEncryptionInfo;
begin
  Result := FEncryptionInfo;
end;

function TdxPDFWriterHelper.GetEncryptMetadata: Boolean;
var
  AEncryptionInfo: IdxPDFEncryptionInfo;
begin
  AEncryptionInfo := GetEncryptionInfo;
  Result := (AEncryptionInfo <> nil) and AEncryptionInfo.EncryptMetadata;
end;

{ TdxPDFObject }

constructor TdxPDFObject.Create(AParent: TdxPDFObject);
begin
  inherited Create;
  FParent := AParent;
  CreateSubClasses;
  PerformWithoutChanges(Initialize);
end;

constructor TdxPDFObject.CreateEx(ARepository: TdxPDFDocumentRepository);
var
  AParent: TdxPDFObject;
begin
  if ARepository <> nil then
    AParent := ARepository.Parent
  else
    AParent := nil;
  Create(AParent);
end;

destructor TdxPDFObject.Destroy;
begin
  DestroySubClasses;
  inherited Destroy;
end;

class function TdxPDFObject.GetTypeName: string;
begin
  Result := '';
end;

function TdxPDFObject.GetObject(const AName: string; ASourceDictionary: TdxPDFDictionary; out AObject: TdxPDFBase): Boolean;
begin
  AObject := ASourceDictionary.GetObject(AName);
  Result := AObject <> nil;
  if Result and TdxPDFUtils.IsIntegerValid((AObject as TdxPDFBase).Number) then
    AObject := Repository.GetObject((AObject as TdxPDFBase).Number) as TdxPDFBase;
end;

function TdxPDFObject.Write(AHelper: TdxPDFWriterHelper): TdxPDFBase;
var
  ADictionary: TdxPDFWriterDictionary;
begin
  ADictionary := AHelper.CreateDictionary;
  Write(AHelper, ADictionary);
  Result := ADictionary;
end;

procedure TdxPDFObject.CreateSubClasses;
begin
  // do nothing
end;

procedure TdxPDFObject.DestroySubClasses;
begin
  // do nothing
end;

procedure TdxPDFObject.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  // do nothing
end;

procedure TdxPDFObject.Initialize;
begin
  // do nothing
end;

procedure TdxPDFObject.Read(ADictionary: TdxPDFReaderDictionary);
begin
  if ADictionary <> nil then
  begin
    Number := ADictionary.Number;
    PerformWithoutChanges(
      procedure
      begin
        DoRead(ADictionary);
      end);
  end;
end;

procedure TdxPDFObject.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  ADictionary.AddName(TdxPDFKeywords.TypeKey, GetTypeName);
end;

function TdxPDFObject.IsLocked: Boolean;
begin
  Result := FLockCount <> 0;
end;

procedure TdxPDFObject.AppearanceChanged;
begin
  Changed([dcModified, dcInteractiveLayer]);
end;

procedure TdxPDFObject.BeginUpdate;
begin
  Inc(FLockCount);
end;

procedure TdxPDFObject.CancelUpdate;
begin
  Dec(FLockCount);
end;

procedure TdxPDFObject.Changed(AChanges: TdxPDFDocumentChanges);
begin
  if not IsLocked then
  begin
    if Parent <> nil then
      Parent.Changed(AChanges)
    else
      if Repository <> nil then
        Repository.Changed(AChanges);
  end;
end;

procedure TdxPDFObject.DataChanged;
begin
  Changed([dcModified, dcData]);
end;

procedure TdxPDFObject.EndUpdate;
begin
  CancelUpdate;
  LayoutChanged;
end;

procedure TdxPDFObject.LayoutChanged;
begin
  Changed([dcModified, dcLayout]);
end;

procedure TdxPDFObject.PerformBatchOperation(AProc: TProc);
var
  ARepository: TdxPDFDocumentRepository;
begin
  if not Assigned(AProc) then
    Exit;
  ARepository := Repository;
  if ARepository <> nil then
    ARepository.PerformBatchOperation(AProc)
  else
  begin
    BeginUpdate;
    try
      AProc;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TdxPDFObject.PerformWithoutChanges(AProc: TProc);
begin
  if not Assigned(AProc) then
    Exit;
  BeginUpdate;
  try
    AProc;
  finally
    CancelUpdate;
  end;
end;

procedure TdxPDFObject.RaiseWriteNotImplementedException;
begin
  raise EdxPDFException.Create(ClassName + '.Write is not supported. Use overload method instead');
end;

function TdxPDFObject.GetRepository: TdxPDFDocumentRepository;
begin
  if Parent <> nil then
    Result := Parent.Repository
  else
    Result := nil;
end;

{ TdxPDFAnnotationCallout }

function TdxPDFAnnotationCallout.Write(AHelper: TdxPDFWriterHelper): TdxPDFBase;
var
  AArray: TdxPDFWriterArray;
begin
  AArray := AHelper.CreateArray;
  AArray.Add(FStartPoint.X);
  AArray.Add(FStartPoint.Y);
  AArray.Add(FKneePoint.X);
  AArray.Add(FKneePoint.Y);
  AArray.Add(FEndPoint.X);
  AArray.Add(FEndPoint.Y);
  Result := AArray;
end;

procedure TdxPDFAnnotationCallout.Read(AArray: TdxPDFArray);
begin
  case AArray.Count of
    4:
      begin
        FStartPoint := TdxPDFUtils.ArrayToPointF(AArray, 0);
        FEndPoint := TdxPDFUtils.ArrayToPointF(AArray, 2);
      end;
    6:
      begin
        FStartPoint := TdxPDFUtils.ArrayToPointF(AArray, 0);
        FKneePoint := TdxPDFUtils.ArrayToPointF(AArray, 2);
        FEndPoint := TdxPDFUtils.ArrayToPointF(AArray, 4);
      end;
  end;
end;

{ TdxPDFPageData }

class function TdxPDFPageData.GetTypeName: string;
begin
  Result := TdxPDFKeywords.Page;
end;

procedure TdxPDFPageData.ClearCommands;
begin
  FContents.ClearCommands;
end;

procedure TdxPDFPageData.ExtractCommands;
begin
  if FContents.CommandCount = 0 then
    FContents.PopulateCommands(Resources);
end;

procedure TdxPDFPageData.ForEachAnnotation(AProc: TdxPDFPageForEachAnnotationProc);
begin
  DoForEachAnnotation(AProc, False);
end;

procedure TdxPDFPageData.ForEachWidgetAnnotation(AProc: TdxPDFPageForEachAnnotationProc);
begin
  DoForEachAnnotation(AProc, True);
end;

procedure TdxPDFPageData.ReplaceCommands(const AData: TBytes);
begin
  FContents.ReplaceCommands(AData);
end;

procedure TdxPDFPageData.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FAnnotations := TdxPDFReferencedObjects.Create;
  FContents := Repository.CreateObject(TdxPDFPageContents, Self) as TdxPDFPageContents;
end;

procedure TdxPDFPageData.DestroySubClasses;

  procedure DestroyAnnotations;
  var
    AObject: TdxPDFReferencedObject;
  begin
    for AObject in FAnnotations do
      Repository.RemoveObject(AObject as TdxPDFObject);
    FreeAndNil(FAnnotations);
  end;

begin
  Contents := nil;
  FreeAndNil(FTransparencyGroup);
  DestroyAnnotations;
  inherited DestroySubClasses;
end;

procedure TdxPDFPageData.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  FDictionary := ADictionary;
  Contents.Read(ADictionary);
  ReadGroup(FDictionary.GetDictionary(TdxPDFKeywords.Group));
end;

procedure TdxPDFPageData.Initialize;
begin
  inherited Initialize;
  FAnnotationsLoaded := False;
end;

procedure TdxPDFPageData.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  ExtractCommands;
  inherited Write(AHelper, ADictionary);
  ADictionary.AddReference(TdxPDFKeywords.Contents, Contents);
  ADictionary.AddReference(TdxPDFKeywords.Group, TransparencyGroup);
  WriteAnnotations(AHelper, ADictionary);
end;

function TdxPDFPageData.GetAnnotations: TdxPDFReferencedObjects;
begin
  if not FAnnotationsLoaded then
  begin
    FAnnotationsLoaded := True;
    ReadAnnotations;
  end;
  Result := FAnnotations;
end;

function TdxPDFPageData.GetCommands: TdxPDFCommandList;
begin
  Result := Contents.Commands;
end;

function TdxPDFPageData.GetCommandsData: TBytes;
begin
  Result := FContents.CommandsData;
end;

function TdxPDFPageData.GetPage: TdxPDFPage;
begin
  Result := Parent as TdxPDFPage;
end;

function TdxPDFPageData.GetResources: TdxPDFResources;
begin
  Result := Page.Resources;
end;

procedure TdxPDFPageData.DoForEachAnnotation(AProc: TdxPDFPageForEachAnnotationProc; AWidgetOnly: Boolean);
var
  AObject: TdxPDFReferencedObject;
begin
  if not Assigned(AProc) then
    Exit;
  for AObject in Annotations do
    if not AWidgetOnly or AWidgetOnly and (AObject is TdxPDFWidgetAnnotation) then
      AProc(AObject as TdxPDFCustomAnnotation);
end;

procedure TdxPDFPageData.SetContents(const AValue: TdxPDFPageContents);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FContents));
end;

procedure TdxPDFPageData.ReadAnnotations;
var
  I: Integer;
  AAnnotation: TdxPDFCustomAnnotation;
  AArray: TdxPDFArray;
  AObject: TdxPDFBase;
begin
  if FDictionary <> nil then
  begin
    AArray := FDictionary.GetArray(TdxPDFKeywords.Annotations);
    if AArray <> nil then
    begin
      FAnnotations.Capacity := FAnnotations.Count + AArray.Count;
      for AObject in AArray.ElementList do
      begin
        AAnnotation := FDictionary.Repository.GetAnnotation(AObject, Page);
        if AAnnotation <> nil then
        begin
          AAnnotation.Page := Page;
          FAnnotations.Add(AAnnotation);
        end;
      end;
      for I := 0 to FAnnotations.Count - 1 do
        TdxPDFCustomAnnotation(FAnnotations[I]).Ensure;
    end;
  end;
end;

procedure TdxPDFPageData.ReadGroup(ADictionary: TdxPDFReaderDictionary);
begin
  if ADictionary <> nil then
    FTransparencyGroup := Repository.CreateAndRead(TdxPDFTransparencyGroup, ADictionary) as TdxPDFTransparencyGroup;
end;

procedure TdxPDFPageData.WriteAnnotations(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
var
  AAnnotation: TdxPDFCustomAnnotation;
  AAnnotationArray: TdxPDFWriterArray;
  AAnnotations: TdxPDFReferencedObjects;
  I: Integer;
begin
  AAnnotations := Annotations;
  if AAnnotations.Count > 0 then
  begin
    AAnnotationArray := AHelper.CreateArray;
    for I := 0 to AAnnotations.Count - 1 do
    begin
      AAnnotation := AAnnotations[I] as TdxPDFCustomAnnotation;
      if AAnnotation is TdxPDFWidgetAnnotation then
        AAnnotationArray.AddReference(TdxPDFWidgetAnnotation(AAnnotation).Field)
      else
        AAnnotationArray.AddReference(AAnnotation);
    end;
    ADictionary.Add(TdxPDFKeywords.Annotations, AAnnotationArray);
  end;
end;

{ TdxPDFPage }

class function TdxPDFPage.GetTypeName: string;
begin
  Result := 'FakePage';
end;

constructor TdxPDFPage.Create(AParent: TdxPDFObject; const AInfo: TdxPDFDeferredObjectInfo);
begin
  inherited Create(AParent);
  FDeferredData := Repository.CreateDeferredObject(Self, AInfo);
end;

constructor TdxPDFPage.Create(AParent: TdxPDFPageList; const AMediaBox, ACropBox: TdxRectF; ARotationAngle: Integer);
begin
  inherited Create(AParent);
  FMediaBox := AMediaBox;
  FCropBox := ACropBox;
  FRotationAngle := ARotationAngle;
  FDeferredData := Repository.CreateDeferredObject(Self, TdxPDFPageData);
end;

destructor TdxPDFPage.Destroy;
begin
  PackData;
  Pack;
  FreeAndNil(FDeferredData);
  inherited Destroy;
end;

function TdxPDFPage.CalculateRotationAngle(ARotationAngle: TcxRotationAngle): Integer;
begin
  Result := TdxPDFUtils.NormalizeRotate(RotationAngle - TdxPDFUtils.ConvertToIntEx(ARotationAngle));
end;

function TdxPDFPage.CreateRecognizedContent(ARecognitionObjects: TdxPDFRecognitionObjects): TdxPDFRecognizedContent;
begin
  Result := TdxPDFRecognizedContent.Create;
  RecognizeContent(Result, ARecognitionObjects);
end;

function TdxPDFPage.GetTopLeft(AAngle: TcxRotationAngle): TdxPointF;
var
  ACropBox: TdxRectF;
begin
  ACropBox := CropBox;
  case CalculateRotationAngle(AAngle) of
    90:
      Result := dxPointF(ACropBox.Left, ACropBox.Bottom);
    180:
      Result := ACropBox.BottomRight;
    270:
      Result := dxPointF(ACropBox.Right, ACropBox.Top);
  else
    Result := ACropBox.TopLeft;
  end;
end;

function TdxPDFPage.FromUserSpace(const R: TdxRectF): TdxPDFRectangle;
var
  APageHeight: Single;
begin
  APageHeight := Size.Y;
  Result := TdxPDFRectangle.Create(R.Left, APageHeight - R.Top, R.Right, APageHeight - R.Bottom);
end;

function TdxPDFPage.FromUserSpace(const P, ADPI, AScaleFactor: TdxPointF; const ABounds: TdxRectF;
  AAngle: TcxRotationAngle): TdxPointF;

  function Convert(const P, ADPI: TdxPointF; AAngle: TcxRotationAngle): TdxPointF;
  var
    AUserScapeFactor: TdxPointF;
  begin
    AUserScapeFactor := UserSpaceFactor(ADPI);
    case CalculateRotationAngle(AAngle) of
      90:
        begin
          Result.X := P.Y / AUserScapeFactor.Y;
          Result.Y := P.X / AUserScapeFactor.X;
        end;
      180:
        begin
          Result.X := Abs(Bounds.Width) - P.X / AUserScapeFactor.X;
          Result.Y := P.Y / AUserScapeFactor.Y;
        end;
      270:
        begin
          Result.X := Abs(Bounds.Width)  - P.Y / AUserScapeFactor.Y;
          Result.Y := Abs(Bounds.Height) -  P.X / AUserScapeFactor.X;
        end;
    else
       Result.X := P.X / AUserScapeFactor.X;
       Result.Y := Abs(Bounds.Height) - P.Y / AUserScapeFactor.Y;
    end;
  end;

var
  AMousePoint, AUserScapeFactor: TdxPointF;
begin
  AMousePoint := P;
  AUserScapeFactor := UserSpaceFactor(ADPI);
  AMousePoint.X := (AMousePoint.X - ABounds.Left) / (AScaleFactor.X);
  AMousePoint.Y := (AMousePoint.Y - ABounds.Top) / (AScaleFactor.Y);
  Result := Convert(AMousePoint, ADPI, AAngle);
end;

function TdxPDFPage.FromUserSpace(const R: TdxRectF; ADPI, AScaleFactor: TdxPointF;
  const ABounds: TdxRectF; AAngle: TcxRotationAngle): TdxRectF;
begin
  Result.TopLeft := FromUserSpace(R.TopLeft, ADPI, AScaleFactor, ABounds, AAngle);
  Result.BottomRight := FromUserSpace(R.BottomRight, ADPI, AScaleFactor, ABounds, AAngle);
end;

function TdxPDFPage.ToUserSpace(const R: TdxRectF; const ADPI, AScaleFactor: TdxPointF; const ABounds: TdxRectF;
  AAngle: TcxRotationAngle): TdxRectF;
begin
  Result.TopLeft := ToUserSpace(R.TopLeft, ADPI, AScaleFactor, ABounds, AAngle);
  Result.BottomRight := ToUserSpace(R.BottomRight, ADPI, AScaleFactor, ABounds, AAngle);
  Result := cxRectAdjustF(Result);
end;

procedure TdxPDFPage.ForEachAnnotation(AProc: TdxPDFPageForEachAnnotationProc);
begin
  Data.ForEachAnnotation(AProc);
end;

procedure TdxPDFPage.Move(ANewIndex: Integer);
begin
  Repository.Catalog.Pages.Move(Repository.Catalog.Pages.IndexOf(Self), ANewIndex);
end;

procedure TdxPDFPage.Pack;
begin
  PackRecognizedContent;
end;

procedure TdxPDFPage.PackRecognizedContent(AForce: Boolean = False);
begin
  if AForce then
    UnLockRecognizedContent(AForce);
  LockAndExecute(
    procedure
    begin
      if not IsRecognizedContentLocked then
        FreeAndNil(FRecognizedContent);
    end);
end;

function TdxPDFPage.ToUserSpace(const P, ADPI, AScaleFactor: TdxPointF; const ABounds: TdxRectF;
  AAngle: TcxRotationAngle): TdxPointF;
var
  ARealScaleFactor, AUserScapeFactor: TdxPointF;
begin
  AUserScapeFactor := UserSpaceFactor(ADPI);
  ARealScaleFactor.X := AUserScapeFactor.X * AScaleFactor.X;
  ARealScaleFactor.Y := AUserScapeFactor.Y * AScaleFactor.y;
  case CalculateRotationAngle(AAngle) of
    90:
      begin
        Result.X := P.Y * ARealScaleFactor.X;
        Result.Y := P.X * ARealScaleFactor.Y;
      end;
    180:
      begin
        Result.X := (Abs(Bounds.Width) - P.X) * ARealScaleFactor.X;
        Result.Y := P.Y * ARealScaleFactor.Y;
      end;
    270:
      begin
        Result.X := (Abs(Bounds.Height) - P.Y) * ARealScaleFactor.X;
        Result.Y := (Abs(Bounds.Width) - P.X) * ARealScaleFactor.Y;
      end;
  else
     Result.X := P.X * ARealScaleFactor.X;
     Result.Y := (Abs(Bounds.Height) - P.Y) * ARealScaleFactor.Y;
  end;

  Result := cxPointOffset(Result, ABounds.TopLeft);
end;

procedure TdxPDFPage.CreateSubClasses;
begin
  inherited CreateSubClasses;
  InitializeCriticalSectionAndSpinCount(FLock, 1024);
end;

procedure TdxPDFPage.DestroySubClasses;
begin
  ThumbnailImage := nil;
  DeleteCriticalSection(FLock);
  inherited DestroySubClasses;
end;

procedure TdxPDFPage.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  if ADictionary.GetString(TdxPDFKeywords.TypeKey) <> TdxPDFPageData.GetTypeName then
    TdxPDFUtils.Abort;
  FLastModified := ADictionary.GetDate(TdxPDFKeywords.LastModified);
  FDisplayDuration := ADictionary.GetDouble(TdxPDFKeywords.DisplayDuration, -1);
  FStructParents := ADictionary.GetInteger(TdxPDFKeywords.StructParents);
  FPreferredZoomFactor := ADictionary.GetInteger(TdxPDFKeywords.PreferredZoom);
  FID := ADictionary.GetBytes(TdxPDFKeywords.ID);
end;

procedure TdxPDFPage.Initialize;
begin
  inherited Initialize;
  FDisplayDuration := -1;
end;

procedure TdxPDFPage.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
var
  ACropBox: TdxRectF;
begin
  inherited Write(AHelper, ADictionary);
  ACropBox := CropBox;
  ADictionary.AddDate(TdxPDFKeywords.LastModified, FLastModified);
  ADictionary.Add(TdxPDFKeywords.BleedBox, BleedBox, ACropBox);
  ADictionary.Add(TdxPDFKeywords.TrimBox, TrimBox, ACropBox);
  ADictionary.Add(TdxPDFKeywords.ArtBox, ArtBox, ACropBox);
  ADictionary.Add(TdxPDFKeywords.DisplayDuration, FDisplayDuration, -1);
  ADictionary.AddReference(TdxPDFKeywords.Resources, Resources);
  ADictionary.Add(TdxPDFKeywords.StructParents, FStructParents, 0);
  ADictionary.Add(TdxPDFKeywords.PreferredZoom, FPreferredZoomFactor);
  ADictionary.Add(TdxPDFKeywords.ID, FID);
  ADictionary.Add(TdxPDFKeywords.UserUnit, UserUnit, 1);
  Data.Write(AHelper, ADictionary);
end;

function TdxPDFPage.IsRecognizedContentLocked: Boolean;
begin
  Result := FRecognizedContentLockCount > 0;
end;

procedure TdxPDFPage.LockRecognizedContent;
begin
  Inc(FRecognizedContentLockCount);
end;

procedure TdxPDFPage.UnLockRecognizedContent(AReset: Boolean = False);
begin
  if AReset then
    FRecognizedContentLockCount := 0
  else
    Dec(FRecognizedContentLockCount);
end;

function TdxPDFPage.ScaleFactor(const ADPI, AScaleFactor: TdxPointF): TdxPointF;
var
  ASpaceFactor: TdxPointF;
begin
  ASpaceFactor := UserSpaceFactor(ADPI);
  Result.X := ASpaceFactor.X * AScaleFactor.X;
  Result.Y := ASpaceFactor.Y * AScaleFactor.Y;
end;

function TdxPDFPage.UserSpaceFactor(const ADPI: TdxPointF): TdxPointF;
begin
  Result := dxPointF(ADPI.X / 72 * UserUnit, ADPI.Y / 72 * UserUnit);
end;

procedure TdxPDFPage.AddAnnotation(AAnnotation: TdxPDFCustomAnnotation);
begin
  Data.Annotations.Add(AAnnotation);
end;

procedure TdxPDFPage.DeleteAnnotation(AAnnotation: TdxPDFCustomAnnotation);
begin
  Data.Annotations.Remove(AAnnotation);
end;

procedure TdxPDFPage.Export(ADevice: TObject; AParameters: TdxPDFExportParameters);
begin
  LockAndExecute(
    procedure
    begin
      (ADevice as TdxPDFCustomCommandInterpreter).ExportAndPack(Self, AParameters);
    end);
end;

procedure TdxPDFPage.Export(AParameters: TdxPDFExportParameters; AStream: TStream);
var
  ABitmap: TcxBitmap;
  ADevice: TdxPDFGraphicsDevice;
  ARenderParameters: TdxPDFRenderParameters;
begin
  ARenderParameters := AParameters as TdxPDFRenderParameters;
  if not ARenderParameters.IsCanceled then
  begin
    ABitmap := TcxBitmap.CreateSize(ARenderParameters.Rect);
    try
      ABitmap.PixelFormat := pf24bit;
      ARenderParameters.Canvas := ABitmap.Canvas;
      ARenderParameters.Canvas.Lock;
      ADevice := TdxPDFGraphicsDevice.Create;
      try
        ADevice.Export(Self, ARenderParameters);
        ABitmap.SaveToStream(AStream);
      finally
        ARenderParameters.Canvas.Unlock;
        ADevice.Free;
      end;
    finally
      ABitmap.Free;
    end;
  end;
end;

procedure TdxPDFPage.LockAndExecute(AProc: TProc; ATryLock: Boolean = False);
var
  ALocked: Boolean;
begin
  ALocked := True;
  if ATryLock then
    ALocked := TryEnterCriticalSection(FLock)
  else
    EnterCriticalSection(FLock);
  if ALocked then
    try
      Locked := True;
      AProc;
    finally
      LeaveCriticalSection(FLock);
      Locked := False;
    end;
end;

procedure TdxPDFPage.Rotate(AAngle: Integer);
begin
  SetRotationAngle(AAngle);
end;

function TdxPDFPage.RemoveWidgetAnnotations(AAnnotationList: TdxFastList; AFlatten: Boolean): Boolean;
var
  ARemover: TdxPDFWidgetAnnotationRemover;
begin
  if AFlatten then
    ARemover := TdxPDFWidgetAnnotationFlattener.Create(Self)
  else
    ARemover := TdxPDFWidgetAnnotationRemover.Create(Self);
  try
    Result := ARemover.Remove(AAnnotationList);
  finally
    ARemover.Free;
  end;
end;

function TdxPDFPage.GetAnnotations: TdxPDFReferencedObjects;
begin
  Result := Data.Annotations;
end;

function TdxPDFPage.GetBounds: TdxRectF;
begin
  if TdxPDFUtils.IsRectEmpty(CropBox) then
    Result := MediaBox
  else
    Result := CropBox;
end;

function TdxPDFPage.GetData: TdxPDFPageData;
begin
  Result := FDeferredData.ResolvedObject as TdxPDFPageData
end;

function TdxPDFPage.GetDocument: TObject;
begin
  Result := Repository.Document as TdxPDFDocument;
end;

function TdxPDFPage.GetDocumentState: TObject;
begin
  Result := TdxPDFDocumentAccess(Document).State;
end;

function TdxPDFPage.GetNormalizedRotationAngle: Integer;
begin
  Result := TdxPDFUtils.NormalizeRotate(RotationAngle);
end;

function TdxPDFPage.GetHyperlinkList: TdxPDFHyperlinkList;
begin
  RecognizedContent.Hyperlinks.Clear;
  ForEachAnnotation(
    procedure(AAnnotation: TdxPDFCustomAnnotation)
    var
      AHyperlink: TdxPDFHyperlink;
    begin
      if AAnnotation is TdxPDFLinkAnnotation then
      begin
        AHyperlink := TdxPDFHyperlink.Create;
        AHyperlink.SetAnnotation(AAnnotation);
        RecognizedContent.Hyperlinks.Add(AHyperlink);
      end;
    end);
  Result := RecognizedContent.Hyperlinks;
end;

function TdxPDFPage.GetRecognizedContent: TdxPDFRecognizedContent;
begin
  Result := GetRecognizedContent(dxPDFAllRecognitionObjects);
end;

function TdxPDFPage.GetRecognizedContent(ARecognitionObjects: TdxPDFRecognitionObjects): TdxPDFRecognizedContent;
begin
  if FRecognizedContent = nil then
    FRecognizedContent := CreateRecognizedContent(ARecognitionObjects);
  Result := FRecognizedContent;
end;

function TdxPDFPage.GetSize: TdxPointF;
var
  ABounds: TdxRectF;
begin
  ABounds := Bounds;
  if (NormalizedRotationAngle = 90) or (NormalizedRotationAngle = 270) then
    Result := dxPointF(Abs(ABounds.Height), Abs(ABounds.Width))
  else
    Result := dxPointF(Abs(ABounds.Width), Abs(ABounds.Height));
end;

procedure TdxPDFPage.SetData(const AValue: TdxPDFPageData);
begin
  FDeferredData.ResolvedObject := nil;
end;

procedure TdxPDFPage.SetRotationAngle(const AValue: Integer);
var
  AActualAngle, ACurrentAngle: Integer;
begin
  ACurrentAngle := RotationAngle;
  AActualAngle := ACurrentAngle + AValue;
  FUseParentRotationAngle := ACurrentAngle = AActualAngle;
  if not UseParentRotationAngle then
  begin
    FRotationAngle := AActualAngle mod 360;
    LayoutChanged;
  end;
end;

procedure TdxPDFPage.SetThumbnailImage(const AValue: TdxPDFDocumentImage);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FThumbnailImage));
end;

procedure TdxPDFPage.PackData;
begin
  LockAndExecute(
    procedure
    begin
      if FDeferredData.IsResolved then
        Data := nil;
      if Resources <> nil then
        Resources.Pack;
    end);
end;

procedure TdxPDFPage.RecognizeContent(AContent: TdxPDFRecognizedContent; ARecognitionObjects: TdxPDFRecognitionObjects);

  function CreateRenderParameters: TdxPDFRenderParameters;
  begin
    Result := TdxPDFRenderParameters.Create(GetDocumentState);
    Result.Angle := ra0;
    Result.ScaleFactor := cxGetCurrentDPI / 72;
  end;

var
  AParameters: TdxPDFRenderParameters;
  ARecognizer: TdxPDFDocumentContentRecognizer;
begin
  if AContent <> nil then
  begin
    AParameters := CreateRenderParameters;
    ARecognizer := TdxPDFDocumentContentRecognizer.Create(AContent, ARecognitionObjects);
    try
      LockAndExecute(
        procedure
        begin
          ARecognizer.ExportAndPack(Self, AParameters);
        end, True);
    finally
      ARecognizer.Free;
      AParameters.Free;
    end;
  end;
end;

{ TdxPDFInteractiveFormFieldTextState }

procedure TdxPDFInteractiveFormFieldTextState.DestroySubClasses;
begin
  FontCommand := nil;
  inherited DestroySubClasses;
end;

procedure TdxPDFInteractiveFormFieldTextState.Initialize;
begin
  inherited Initialize;
  FHorizontalScaling := 100;
end;

constructor TdxPDFInteractiveFormFieldTextState.Create(AField: TdxPDFInteractiveFormField);
begin
  inherited Create(AField);
  ConvertCommandsToBytes(AField);
  InitializeColor(AField);
  InitializeText(Self);
end;

procedure TdxPDFInteractiveFormFieldTextState.ConvertCommandsToBytes(AField: TdxPDFInteractiveFormField);
var
  AAppearanceCommand: TdxPDFCustomCommand;
  ACommands: TdxPDFCommandList;
  ACommandsToFillList: TdxPDFCommandList;
  I: Integer;
begin
  ACommands := GetAppearanceCommandsInheritable(AField);
  if ACommands <> nil then
  begin
    ACommandsToFillList := TdxPDFCommandList.Create;
    try
      for I := 0 to ACommands.Count - 1 do
      begin
        AAppearanceCommand := ACommands[I];
        if AAppearanceCommand is TdxPDFSetWordSpacingCommand then
          FWordSpacing := TdxPDFSetWordSpacingCommand(AAppearanceCommand).Spacing
        else if AAppearanceCommand is TdxPDFSetCharacterSpacingCommand then
          FCharacterSpacing := TdxPDFSetCharacterSpacingCommand(AAppearanceCommand).Spacing
        else if AAppearanceCommand is TdxPDFSetTextHorizontalScalingCommand then
          FHorizontalScaling := TdxPDFSetTextHorizontalScalingCommand(AAppearanceCommand).HorizontalScaling
        else if AAppearanceCommand is TdxPDFSetTextFontCommand then
          FontCommand := TdxPDFSetTextFontCommand(AAppearanceCommand)
        else
          ACommandsToFillList.Add(AAppearanceCommand);
      end;
      FCommandsAsBytes := ACommandsToFillList.ToByteArray(dxPDFDefaultWriterContext);
    finally
      ACommandsToFillList.Free;
    end;
  end;
end;

procedure TdxPDFInteractiveFormFieldTextState.SetFontCommand(const AValue: TdxPDFCustomCommand);
begin
  dxPDFChangeValue(AValue as TdxPDFSetTextFontCommand, TdxPDFReferencedObject(FFontCommand));
end;

procedure TdxPDFInteractiveFormFieldTextState.InitializeColor(AField: TdxPDFInteractiveFormField);
var
  ASetColorCommand: TdxPDFSetColorCommand;
  I: Integer;
  K: Double;
begin
  if AField.AppearanceCommands <> nil then
    for I := 0 to AField.AppearanceCommands.Count - 1 do
      if Safe.Cast(AField.AppearanceCommands[I], TdxPDFSetColorCommand, ASetColorCommand) then
      begin
        if ASetColorCommand is TdxPDFSetCMYKColorSpaceForNonStrokingOperationsCommand then
        begin
          K := 1 - ASetColorCommand.Color.Components[3];
          FFontColor :=
            TdxPDFColor.Create((1 - ASetColorCommand.Color.Components[0]) * K,
              (1 - ASetColorCommand.Color.Components[1]) * K,(1 - ASetColorCommand.Color.Components[2]) * K).ToColor;
        end
        else
          FFontColor := ASetColorCommand.Color.ToColor;
      end;
end;

procedure TdxPDFInteractiveFormFieldTextState.InitializeText(ATextState: TdxPDFInteractiveFormFieldTextState);

  function TryGetSetTextFontCommand(ACommand: TdxPDFCustomCommand; out ASetTextFontCommand: TdxPDFSetTextFontCommand): Boolean;
  begin
    Result := Safe.Cast(ACommand, TdxPDFSetTextFontCommand, ASetTextFontCommand) and (ASetTextFontCommand.Font <> nil);
  end;

var
  AFont: TdxPDFCustomFont;
  ASetTextFontCommand: TdxPDFSetTextFontCommand;
begin
  if ATextState <> nil then
  begin
    if TryGetSetTextFontCommand(ATextState.FontCommand, ASetTextFontCommand) then
    begin
      AFont := ASetTextFontCommand.Font;
      FFontName := AFont.Name;
      FFontItalic := AFont.Italic;
      FFontBold := AFont.ForceBold;
    end;
    FFontSize := IfThen(SameValue(ATextState.FontSize, 0), TdxPDFInteractiveFormFieldTextState.DefaultFontSize, ATextState.FontSize);
    FCharacterSpacing := ATextState.CharacterSpacing;
    FWordSpacing := ATextState.WordSpacing;
    FHorizontalScaling := ATextState.HorizontalScaling;
  end
  else
    FFontSize := TdxPDFInteractiveFormFieldTextState.DefaultFontSize;
end;

function TdxPDFInteractiveFormFieldTextState.GetFontSize: Single;
begin
  if FFontCommand = nil then
    Result := DefaultFontSize
  else
    Result := (FFontCommand as TdxPDFSetTextFontCommand).FontSize;
end;

procedure TdxPDFInteractiveFormFieldTextState.SetCharacterSpacing(const AValue: Single);
begin
  if FCharacterSpacing <> AValue then
  begin
    FCharacterSpacing := AValue;
    LayoutChanged;
  end;
end;

procedure TdxPDFInteractiveFormFieldTextState.SetFontBold(const AValue: Boolean);
begin
  if FFontBold <> AValue then
  begin
    FFontBold := AValue;
    LayoutChanged;
  end;
end;

procedure TdxPDFInteractiveFormFieldTextState.SetFontColor(const AValue: TColor);
begin
  if FFontColor <> AValue then
  begin
    FFontColor := AValue;
    LayoutChanged;
  end;
end;

procedure TdxPDFInteractiveFormFieldTextState.SetFontItalic(const AValue: Boolean);
begin
  if FFontItalic <> AValue then
  begin
    FFontItalic := AValue;
    LayoutChanged;
  end;
end;

procedure TdxPDFInteractiveFormFieldTextState.SetFontName(const AValue: string);
begin
  if FFontName <> AValue then
  begin
    FFontName := AValue;
    LayoutChanged;
  end;
end;

procedure TdxPDFInteractiveFormFieldTextState.SetFontSize(const AValue: Single);
begin
  if FFontSize <> AValue then
  begin
    FFontSize := AValue;
    LayoutChanged;
  end;
end;

procedure TdxPDFInteractiveFormFieldTextState.SetHorizontalScaling(const AValue: Single);
begin
  if FHorizontalScaling <> AValue then
  begin
    FHorizontalScaling := AValue;
    LayoutChanged;
  end;
end;

procedure TdxPDFInteractiveFormFieldTextState.SetWordSpacing(const AValue: Single);
begin
  if FWordSpacing <> AValue then
  begin
    FWordSpacing := AValue;
    LayoutChanged;
  end;
end;

function TdxPDFInteractiveFormFieldTextState.GetAppearanceCommandsInheritable(
  AFormField: TdxPDFInteractiveFormField): TdxPDFCommandList;
begin
  if AFormField = nil then
    Result := nil
  else if AFormField.AppearanceCommands <> nil then
    Result := AFormField.AppearanceCommands
  else if (AFormField.Parent = nil) and (AFormField.Form <> nil) then
    Result := AFormField.Form.DefaultAppearanceCommands
  else
    Result := GetAppearanceCommandsInheritable(AFormField.Parent);
end;

{ TdxPDFInteractiveFormCustomFieldEditValue }

procedure TdxPDFInteractiveFormCustomFieldEditValue.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FDefaultValue := TStringList.Create;
  FValue := TStringList.Create;
end;

procedure TdxPDFInteractiveFormCustomFieldEditValue.DestroySubClasses;
begin
  FreeAndNil(FValue);
  FreeAndNil(FDefaultValue);
  inherited DestroySubClasses;
end;

procedure TdxPDFInteractiveFormCustomFieldEditValue.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  DefaultText := ADictionary.GetTextString(GetDefaultValueKey, DefaultText);
  SetExportValue(ADictionary.GetTextString(GetValueKey));
end;

procedure TdxPDFInteractiveFormCustomFieldEditValue.Write(AHelper: TdxPDFWriterHelper;
  ADictionary: TdxPDFWriterDictionary);

  procedure WriteValue(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary; const AKey: string;
    AValues: TStringList);
  begin
    if AValues.Count > 0 then
      if (AValues.Count = 1) and not MultiSelect then
        ADictionary.Add(AKey, AValues[0])
      else
        ADictionary.Add(AKey, AValues);
  end;

begin
  WriteValue(AHelper, ADictionary, TdxPDFKeywords.ShortValue, ValueList);
  WriteValue(AHelper, ADictionary, TdxPDFKeywords.ShortDefaultValue, DefaultValueList);
end;


function TdxPDFInteractiveFormCustomFieldEditValue.CanChange: Boolean;
begin
  Result := FIgnoreReadOnly or not ReadOnly;
end;

function TdxPDFInteractiveFormCustomFieldEditValue.DoChanging(const AOldValue, ANewValue: string): Boolean;
var
  AAccept: Boolean;
begin
  AAccept := True;
  if not IsLocked and Assigned(OnChanging) then
    OnChanging(AOldValue, ANewValue, AAccept);
  Result := AAccept;
end;

function TdxPDFInteractiveFormCustomFieldEditValue.GetDefaultValueKey: string;
begin
  Result := TdxPDFKeywords.ShortDefaultValue;
end;

function TdxPDFInteractiveFormCustomFieldEditValue.GetValueKey: string;
begin
  Result := TdxPDFKeywords.ShortValue;
end;

function TdxPDFInteractiveFormCustomFieldEditValue.ValidateValue(const AValue: string): string;
begin
  Result := AValue;
end;

procedure TdxPDFInteractiveFormCustomFieldEditValue.DoAdd(const AValue: string);
begin
  FValue.Add(AValue);
end;

procedure TdxPDFInteractiveFormCustomFieldEditValue.DoDelete(AIndex: Integer);
begin
  if InRange(AIndex, 0, FValue.Count - 1) then
    FValue.Delete(AIndex);
end;

procedure TdxPDFInteractiveFormCustomFieldEditValue.DoClear;
begin
  FValue.Clear;
end;

procedure TdxPDFInteractiveFormCustomFieldEditValue.DoSort;
begin
  // do nothing
end;

procedure TdxPDFInteractiveFormCustomFieldEditValue.SetMultiSelect(const AValue: Boolean);
begin
  FMultiSelect := AValue;
end;

procedure TdxPDFInteractiveFormCustomFieldEditValue.Sort;
begin
  if not Sorted then
    Exit;
  DoSort;
end;

procedure TdxPDFInteractiveFormCustomFieldEditValue.EnableReadOnlyValidation;
begin
  FIgnoreReadOnly := False;
end;

procedure TdxPDFInteractiveFormCustomFieldEditValue.DisableReadOnlyValidation;
begin
  FIgnoreReadOnly := True;
end;

class function TdxPDFInteractiveFormCustomFieldEditValue.PrepareValue(const AValue: string): string;
begin
  Result := Trim(AValue);
end;

procedure TdxPDFInteractiveFormCustomFieldEditValue.SetExportValue(const AValue: string);
begin
  DisableReadOnlyValidation;
  try
    InternalSetValue(AValue);
  finally
    EnableReadOnlyValidation;
  end;
end;

procedure TdxPDFInteractiveFormCustomFieldEditValue.SetValue(const AValue: string);
begin
  InternalSetValue(AValue);
end;

procedure TdxPDFInteractiveFormCustomFieldEditValue.Clear;
begin
  if CanChange then
  begin
    DoClear;
    DoChanged;
  end;
end;

function TdxPDFInteractiveFormCustomFieldEditValue.GetDefaultText: string;
begin
  Result := PrepareValue(FDefaultValue.Text);
end;

function TdxPDFInteractiveFormCustomFieldEditValue.GetDefaultValueList: TStringList;
begin
  Result := FDefaultValue;
end;

function TdxPDFInteractiveFormCustomFieldEditValue.GetText: string;
begin
  Result := PrepareValue(FValue.Text);
end;

function TdxPDFInteractiveFormCustomFieldEditValue.GetValueList: TStringList;
begin
  Result := FValue;
end;

procedure TdxPDFInteractiveFormCustomFieldEditValue.SetDefaultText(const AValue: string);
begin
  FDefaultValue.Text := PrepareValue(AValue);
end;

procedure TdxPDFInteractiveFormCustomFieldEditValue.SetSorted(const AValue: Boolean);
begin
  if FSorted <> AValue then
  begin
    FSorted := AValue;
    Sort;
    DoChanged;
  end;
end;

procedure TdxPDFInteractiveFormCustomFieldEditValue.InternalSetValue(const AValue: string);
var
  AActualValue: string;
  AValueList: TStringList;
  I: Integer;
begin
  AActualValue := ValidateValue(PrepareValue(AValue));
  if (Text = AActualValue) or not CanChange or not DoChanging(AActualValue, Text) then
    Exit;
  AValueList := TStringList.Create;
  try
    DoClear;
    AValueList.Text := AActualValue;
    for I := 0 to AValueList.Count -1 do
      DoAdd(AValueList[I]);
  finally
    AValueList.Free;
  end;
  DoChanged;
end;

procedure TdxPDFInteractiveFormCustomFieldEditValue.DoChanged;
begin
  if not IsLocked and Assigned(OnChanged) then
    OnChanged(Self);
end;

{ TdxPDFInteractiveFormField }

constructor TdxPDFInteractiveFormField.Create(AForm: TdxPDFInteractiveForm; AWidget: TdxPDFCustomAnnotation;
  const AName: string = '');
begin
  CreateEx(AWidget.Repository);
  FName := AName;
  FForm := AForm;
  FWidget := AWidget as TdxPDFWidgetAnnotation;
  TdxPDFWidgetAnnotation(FWidget).Field := Self;
  FForm.Add(Self);
end;

function TdxPDFInteractiveFormField.HasAppearance(const AName: string): Boolean;
begin
  Result := (Widget <> nil) and (Widget is TdxPDFWidgetAnnotation) and (Widget.Appearance <> nil) and
    (Widget.Appearance.Normal <> nil) and (Widget.Appearance.Normal.GetNames('').IndexOf(AName) <> -1);
end;

function TdxPDFInteractiveFormField.HasFlag(AFlags: TdxPDFInteractiveFormFieldFlags): Boolean;
begin
  Result := (Integer(Flags) and Integer(AFlags)) <> 0;
end;

procedure TdxPDFInteractiveFormField.CheckChanges;
begin
  if (FEditValueProvider.FEditValueChanged or FEditValueProvider.FAppearanceChanged) and not IsLocked then
  begin
    FEditValueProvider.FAppearanceChanged := False;
    FEditValueProvider.FEditValueChanged := False;
    FEditValueProvider.AppearanceChanged(ForceAppearanceChangeOnEditValueChanged);
    dxCallNotify(OnEditValueChanged, Self);
  end;
end;

procedure TdxPDFInteractiveFormField.BuildAppearance(AState: TdxPDFAnnotationAppearanceState; const AAppearanceName: string);
var
  ABuilder: TObject;
begin
  if Safe.Cast(CreateAppearanceBuilder, TdxPDFAnnotationAppearanceBuilder, ABuilder) then
    try
      DoBuildAppearance(ABuilder, AState, AAppearanceName);
    finally
      ABuilder.Free;
    end;
end;

procedure TdxPDFInteractiveFormField.RebuildAppearance(AForce: Boolean);

  function TryFindFont(out AFont: TdxPDFCustomFont): Boolean;
  var
    AFontData: TdxPDFEditableFontData;
    AFontStyles: TFontStyles;
  begin
    AFontStyles := [];
    if TextState.FontBold then
      Include(AFontStyles, TFontStyle.fsBold);
    if TextState.FontItalic then
      Include(AFontStyles, TFontStyle.fsItalic);
    AFontData := FontProvider.GetMatchingFont(TextState.FontName, AFontStyles) as TdxPDFEditableFontData;
    Result := AFontData <> nil;
    if Result then
      AFont := AFontData.Font;
  end;

var
  I: Integer;
begin
  if IsLocked then
  begin
    FEditValueProvider.FAppearanceChanged := True;
    Exit;
  end;
  if Form <> nil then
    Form.NeedAppearances := False;
  if Widget <> nil then
  begin
    DoRebuildAppearance(AForce);
    Inc(AppearanceCalculationCount);
  end;
  if  Kids <> nil then
    for I := 0 to FKids.Count - 1 do
      TdxPDFInteractiveFormField(FKids[I]).RebuildAppearance(AForce);
end;

procedure TdxPDFInteractiveFormField.PopulateAnnotationsToRemove(
  ARemovingAnnotations: TObjectDictionary<TdxPDFPage, TdxFastList>);
var
  APage: TdxPDFPage;
  AAnnotations: TdxFastList;
  AKid: TdxPDFInteractiveFormField;
  I: Integer;
begin
  if FWidget <> nil then
  begin
    APage := FWidget.Page;
    if APage <> nil then
    begin
      if not ARemovingAnnotations.TryGetValue(APage, AAnnotations) then
      begin
        AAnnotations := TdxFastList.Create;
        ARemovingAnnotations.Add(APage, AAnnotations);
      end;
      if AAnnotations.IndexOf(FWidget) = -1 then
        AAnnotations.Add(FWidget);
    end;
  end;
  if FKids <> nil then
    for I := 0 to FKids.Count - 1 do
    begin
      AKid := FKids[I] as TdxPDFInteractiveFormField;
      AKid.PopulateAnnotationsToRemove(ARemovingAnnotations);
    end;
end;

procedure TdxPDFInteractiveFormField.CreateSubClasses;
begin
  inherited CreateSubClasses;
  Resources := nil;
  FEditValue := CreateEditValue;
  FEditValue.OnChanging := OnValueChangingHandler;
  FEditValue.OnChanged := OnValueChangedHandler;
end;

procedure TdxPDFInteractiveFormField.EndUpdate;
begin
  CancelUpdate;
  CheckChanges;
end;

procedure TdxPDFInteractiveFormField.DestroySubClasses;
begin
  Resources := nil;
  FWidget := nil;
  FParent := nil;
  FreeAndNil(FAppearanceCommands);
  FreeAndNil(FKids);
  FreeAndNil(FTextState);
  FreeAndNil(FEditValue);
  inherited DestroySubClasses;
end;

procedure TdxPDFInteractiveFormField.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  FName := ADictionary.GetTextString(TdxPDFKeywords.Text);
  FAlternateName := ADictionary.GetTextString(TdxPDFKeywords.TextAlternate);
  FMappingName := ADictionary.GetTextString(TdxPDFKeywords.TextMapping);
  FHasFlags := ADictionary.Contains(TdxPDFKeywords.FieldFlags);
  if FHasFlags then
    FFlags := TdxPDFInteractiveFormFieldFlags(ADictionary.GetInteger(TdxPDFKeywords.FieldFlags));
  FTextJustify := ADictionary.GetTextJustify;
  FDefaultStyle := ADictionary.GetTextString(TdxPDFKeywords.DefaultStyle);
  FRichTextData := ADictionary.GetTextString(TdxPDFKeywords.RichTextData);

  UpdateEditValueProperties;
  EditValue.Read(ADictionary);
end;

procedure TdxPDFInteractiveFormField.Initialize;
begin
  inherited Initialize;
  FEditValueProvider := Self;
  UpdateEditValueProperties;
end;

procedure TdxPDFInteractiveFormField.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  ADictionary.AddName(TdxPDFKeywords.TypeKey, TdxPDFKeywords.Annotation);
  ADictionary.AddName(TdxPDFKeywords.FieldType, GetTypeName);
  ADictionary.AddReference(TdxPDFKeywords.Parent, Parent);
  DoWrite(AHelper, ADictionary);
  WriteKids(AHelper, ADictionary);
  ADictionary.SetAppearance(Resources, AppearanceCommands);
end;

function TdxPDFInteractiveFormField.CreateAppearanceBuilder: TObject;
begin
  Result := nil;
end;

function TdxPDFInteractiveFormField.GetFieldType: TdxPDFInteractiveFormFieldType;
begin
  Result := ftNode;
end;

function TdxPDFInteractiveFormField.ForceAppearanceChangeOnEditValueChanged: Boolean;
begin
  Result := False;
end;

function TdxPDFInteractiveFormField.UseDefaultAppearance: Boolean;
begin
  Result := True;
end;

procedure TdxPDFInteractiveFormField.AppearanceChanged(AForce: Boolean);
begin
  RebuildAppearance(AForce);
  inherited AppearanceChanged;
end;

procedure TdxPDFInteractiveFormField.DoWrite(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  ADictionary.Add(TdxPDFKeywords.Text, AHelper.Context.FindFormFieldName(Name));
  ADictionary.Add(TdxPDFKeywords.TextAlternate, FAlternateName);
  ADictionary.Add(TdxPDFKeywords.TextMapping, FMappingName);
  ADictionary.Add(TdxPDFKeywords.FieldFlags, Ord(Flags));
  ADictionary.SetTextJustify(FTextJustify);
  ADictionary.Add(TdxPDFKeywords.DefaultStyle, FDefaultStyle);
  ADictionary.Add(TdxPDFKeywords.RichTextData, FRichTextData);
  EditValue.Write(AHelper, ADictionary);
end;

procedure TdxPDFInteractiveFormField.Initialize(AForm: TdxPDFInteractiveForm; AParent: TdxPDFInteractiveFormField);
begin
  FForm := AForm;
  FParent := AParent;
end;

procedure TdxPDFInteractiveFormField.Read(ADictionary: TdxPDFReaderDictionary; ANumber: Integer);
begin
  inherited Read(ADictionary);
  if ADictionary <> nil then
  begin
    if not FKidsResolved then
      ReadKids(ADictionary, ANumber);
    if (FName = '') and (FParent <> nil) then
      FEditValueProvider := FParent;
    if Form <> nil then
      Resources := Form.Resources
    else
      Resources := Repository.CreateResources;
    FAppearanceCommands := ADictionary.GetAppearance(Resources);
  end;
end;

procedure TdxPDFInteractiveFormField.SetFlag(AFlags: TdxPDFInteractiveFormFieldFlags; AValue: Boolean);
begin
  if AValue then
    FFlags := TdxPDFInteractiveFormFieldFlags(Integer(FFlags) or Integer(AFlags))
  else
    FFlags := TdxPDFInteractiveFormFieldFlags(Integer(FFlags) and not Integer(AFlags));
  FHasFlags := True;
end;

function TdxPDFInteractiveFormField.CreateEditValue: TdxPDFInteractiveFormCustomFieldEditValue;
begin
  Result := TdxPDFInteractiveFormCustomFieldEditValue.Create(Self);
end;

procedure TdxPDFInteractiveFormField.DoBuildAppearance(ABuilder: TObject; AState: TdxPDFAnnotationAppearanceState;
  const AAppearanceName: string);
var
  AForm: TdxPDFXForm;
begin
  AForm := Widget.GetAppearanceForm(AState, AAppearanceName);
  if AForm = nil then
    AForm := Widget.CreateAppearanceForm(AState, AAppearanceName);
  if FForm <> nil then
    FForm.Resources.FillWidgetAppearanceResources(AForm.CreateEmptyResources);
  TdxPDFAnnotationAppearanceBuilder(ABuilder).RebuildAppearance(AForm);
end;

procedure TdxPDFInteractiveFormField.DoRebuildAppearance(AForce: Boolean);
begin
  BuildAppearance(asNormal, '');
end;

function TdxPDFInteractiveFormField.GetBackgroundARGBColor: TdxPDFARGBColor;
begin
  Result := TdxPDFARGBColor.Create(TdxPDFWidgetAnnotation(Widget).AppearanceCharacteristics.BackgroundColor);
end;

function TdxPDFInteractiveFormField.IsComboBox: Boolean;
begin
  Result := HasFlag(ffCombo);
end;

function TdxPDFInteractiveFormField.IsComposite: Boolean;
begin
  Result := HasFlag(ffComb);
end;

function TdxPDFInteractiveFormField.IsPushButton: Boolean;
begin
  Result := HasFlag(ffPushButton);
end;

function TdxPDFInteractiveFormField.IsRadioButton: Boolean;
begin
  Result := HasFlag(ffRadio);
end;

procedure TdxPDFInteractiveFormField.ClearEditValue;
begin
  EditValue.Clear;
  CheckChanges;
end;

procedure TdxPDFInteractiveFormField.DeleteAnnotation(AFlatten: Boolean);
var
  APair: TPair<TdxPDFPage, TdxFastList>;
  ARemovingAnnotations: TObjectDictionary<TdxPDFPage, TdxFastList>;
begin
  EditValueProvider.Form.Fields.List.Remove(Self);
  ARemovingAnnotations := TObjectDictionary<TdxPDFPage, TdxFastList>.Create([doOwnsValues]);
  try
    PopulateAnnotationsToRemove(ARemovingAnnotations);
    for APair in ARemovingAnnotations do
      APair.Key.RemoveWidgetAnnotations(APair.Value, AFlatten);
  finally
    ARemovingAnnotations.Free;
  end;
end;

procedure TdxPDFInteractiveFormField.SetEditValue(const AValue: string);
begin
  EditValue.SetValue(AValue);
  CheckChanges;
end;

procedure TdxPDFInteractiveFormField.SetExportEditValue(const AValue: string);
begin
  EditValue.SetExportValue(AValue);
  CheckChanges;
end;

procedure TdxPDFInteractiveFormField.ResetEditValue;
begin
  SetExportEditValue(EditValue.DefaultText);
  CheckChanges;
end;

function TdxPDFInteractiveFormField.GetAlternateName: string;
begin
  Result := FEditValueProvider.FAlternateName;
end;

function TdxPDFInteractiveFormField.GetEditValue: TdxPDFInteractiveFormCustomFieldEditValue;
begin
  Result := FEditValueProvider.FEditValue;
end;

function TdxPDFInteractiveFormField.GetExportable: Boolean;
begin
  Result := not HasFlag(ffNoExport);
end;

function TdxPDFInteractiveFormField.GetExportValueList: TStringList;
begin
  Result := EditValue.ValueList;
end;

function TdxPDFInteractiveFormField.GetFlags: TdxPDFInteractiveFormFieldFlags;
begin
  if FHasFlags then
    Result := FFlags
  else
    if FParent <> nil then
      Result := Parent.Flags
    else
      Result := ffNone;
end;

function TdxPDFInteractiveFormField.GetFontProvider: IdxPDFFontProvider;
begin
  Result := Repository.FontProvider;
end;

function TdxPDFInteractiveFormField.GetFullName: string;
const
  FieldNameDelimiter = '.';
var
  AParentName: string;
begin
  if FParent = nil then
    Exit(FName);

  AParentName := Parent.FullName;
  if AParentName = '' then
    Result := FName
  else
    if FName = '' then
      Result := AParentName
    else
      Result := AParentName + FieldNameDelimiter + FName;
end;

function TdxPDFInteractiveFormField.GetMultiSelect: Boolean;
begin
  Result := HasFlag(ffMultiSelect);
end;

function TdxPDFInteractiveFormField.GetName: string;
begin
  Result := FName;
end;

function TdxPDFInteractiveFormField.GetReadOnly: Boolean;
begin
  Result := HasFlag(ffReadOnly);
end;

function TdxPDFInteractiveFormField.GetRequired: Boolean;
begin
  Result := HasFlag(ffRequired);
end;

function TdxPDFInteractiveFormField.GetSorted: Boolean;
begin
  Result := HasFlag(ffSort)
end;

function TdxPDFInteractiveFormField.GetTextState: TdxPDFInteractiveFormFieldTextState;
begin
  if FTextState = nil then
    FTextState := TdxPDFInteractiveFormFieldTextState.Create(Self);
  Result := FTextState;
end;

procedure TdxPDFInteractiveFormField.SetAppearanceCommands(const AValue: TdxPDFCommandList);
begin
  FreeAndNil(FAppearanceCommands);
  FAppearanceCommands := AValue;
  FreeAndNil(FTextState);
end;

procedure TdxPDFInteractiveFormField.SetExportable(const AValue: Boolean);
begin
  SetFlag(ffNoExport, not AValue);
end;

procedure TdxPDFInteractiveFormField.SetMultiSelect(const AValue: Boolean);
begin
  SetFlag(ffMultiSelect, AValue);
  EditValue.MultiSelect := MultiSelect;
end;

procedure TdxPDFInteractiveFormField.SetReadOnly(const AValue: Boolean);
begin
  SetFlag(ffReadOnly, AValue);
  EditValue.ReadOnly := ReadOnly;
end;

procedure TdxPDFInteractiveFormField.SetResources(const AValue: TdxPDFResources);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FResources));
end;

procedure TdxPDFInteractiveFormField.SetRequired(const AValue: Boolean);
begin
  SetFlag(ffRequired, AValue);
end;

procedure TdxPDFInteractiveFormField.SetSorted(const AValue: Boolean);
begin
  SetFlag(ffSort, AValue);
  EditValue.Sorted := Sorted;
  CheckChanges;
end;

procedure TdxPDFInteractiveFormField.SetTextJustify(const AValue: TdxPDFTextJustify);
begin
  if FTextJustify <> AValue then
  begin
    FTextJustify := AValue;
    AppearanceChanged(True);
  end;
end;

procedure TdxPDFInteractiveFormField.ReadKids(ADictionary: TdxPDFReaderDictionary; AWidgetNumber: Integer);

  function GetPage(ADictionary: TdxPDFReaderDictionary): TdxPDFPage;
  var
    ANumber: Integer;
  begin
    if ADictionary.TryGetReference('P', ANumber) then
      Result := Repository.GetPage(ANumber)
    else
      Result := nil;
  end;

var
  AKidArray: TdxPDFArray;
  AWidget: TdxPDFWidgetAnnotation;
begin
  AKidArray := ADictionary.GetArray(TdxPDFKeywords.Kids);
  if AKidArray = nil then
  begin
    AWidget := Repository.GetWidget(AWidgetNumber) as TdxPDFWidgetAnnotation;
    if AWidget = nil then
      AWidget := Repository.GetAnnotation(AWidgetNumber, GetPage(ADictionary)) as TdxPDFWidgetAnnotation;
    if AWidget <> nil then
      AWidget.Field := Self;
    FWidget := AWidget;
  end
  else
  begin
    FKids := Repository.CreateInteractiveFormFieldCollection(Self);
    FKids.Read(ADictionary, AKidArray, FForm, Self);
    FKidsResolved := True;
  end;
end;

procedure TdxPDFInteractiveFormField.UpdateEditValueProperties;
begin
  EditValue.MultiSelect := MultiSelect;
  EditValue.ReadOnly := ReadOnly;
  EditValue.Sorted := Sorted;
end;

procedure TdxPDFInteractiveFormField.WriteKids(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  if Widget <> nil then
    Widget.Write(AHelper, ADictionary)
  else
    if Kids <> nil then
      ADictionary.AddInline(TdxPDFKeywords.Kids, Kids);
end;

procedure TdxPDFInteractiveFormField.OnValueChangedHandler(ASender: TObject);
begin
  FEditValueProvider.FEditValueChanged := True;
end;

procedure TdxPDFInteractiveFormField.OnValueChangingHandler(const AOldValue, ANewValue: string; var AAccept: Boolean);
begin
  if not FEditValueProvider.IsLocked and Assigned(OnEditValueChanging) then
    OnEditValueChanging(AOldValue, ANewValue, AAccept);
end;

{ TdxPDFInteractiveFormFieldCollection }

procedure TdxPDFInteractiveFormFieldCollection.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FItems := TdxPDFReferencedObjects.Create;
end;

procedure TdxPDFInteractiveFormFieldCollection.DestroySubClasses;
begin
  FreeAndNil(FItems);
  inherited DestroySubClasses;
end;

procedure TdxPDFInteractiveFormFieldCollection.Read(ADictionary: TdxPDFReaderDictionary;
  AFieldArray: TdxPDFArray; AForm: TdxPDFInteractiveForm; AParent: TdxPDFInteractiveFormField);
var
  I: Integer;
begin
  FItems.Clear;
  inherited Read(ADictionary);
  if AFieldArray <> nil then
    for I := 0 to AFieldArray.Count - 1 do
      Add(Repository.GetInteractiveFormField(AForm, AParent, AFieldArray.ElementList[I].Number));
end;

function TdxPDFInteractiveFormFieldCollection.Write(AHelper: TdxPDFWriterHelper): TdxPDFBase;
var
  AArray: TdxPDFWriterArray;
  I: Integer;
begin
  AArray := AHelper.CreateArray;
  for I := 0 to Count - 1 do
    AArray.AddReference(Items[I]);
  Result := AArray;
end;

function TdxPDFInteractiveFormFieldCollection.Contains(const AValue: TdxPDFInteractiveFormField): Boolean;
begin
  Result := FItems.Contains(AValue);
end;

procedure TdxPDFInteractiveFormFieldCollection.Add(AField: TdxPDFInteractiveFormField);
begin
  if AField <> nil then
    FItems.Add(AField);
end;

procedure TdxPDFInteractiveFormFieldCollection.AddWithAncestors(AField: TdxPDFInteractiveFormField);
begin
  if AField <> nil then
    if AField.Parent = nil then
    begin
      if not FItems.Contains(AField) then
        Add(AField);
    end
    else
      if not AField.Parent.Kids.Contains(AField) then
      begin
        AField.Parent.Kids.Add(AField);
        AddWithAncestors(AField.Parent);
      end;
end;

procedure TdxPDFInteractiveFormFieldCollection.Delete(AField: TdxPDFInteractiveFormField);
begin
  FItems.Remove(AField);
end;

function TdxPDFInteractiveFormFieldCollection.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TdxPDFInteractiveFormFieldCollection.GetItem(Index: Integer): TdxPDFInteractiveFormField;
begin
  Result := FItems[Index] as TdxPDFInteractiveFormField;
end;

{ TdxPDFXFAForm }

procedure TdxPDFXFAForm.Initialize(const AData: TBytes);
begin
  Content := Content + TdxPDFUtils.ConvertToUTF8String(AData);
end;

procedure TdxPDFXFAForm.Initialize(ARepository: TdxPDFDocumentRepository; AArray: TdxPDFArray);
var
  AStream: TdxPDFStream;
  I, AIndex: Integer;
begin
  if AArray <> nil then
  begin
    if (AArray.Count mod 2 <> 0) then
      TdxPDFUtils.RaiseException;
    Content := '';
    AIndex := 0;
    for I := 0 to (AArray.Count div 2) - 1 do
    begin
      if not (AArray[AIndex] is TdxPDFString) then
        TdxPDFUtils.RaiseException;
      Inc(AIndex);
      if AArray[AIndex].ObjectType <> otIndirectReference then
        TdxPDFUtils.RaiseException;
      AStream := ARepository.GetStream(AArray[AIndex].Number);
      Inc(AIndex);
      if AStream = nil then
        TdxPDFUtils.RaiseException;
      if I > 0 then
        Content := Content + '\n';
      Initialize(AStream.UncompressedData);
    end;
  end;
end;

function TdxPDFXFAForm.ToByteArray: TBytes;
begin
  Result := TEncoding.UTF8.GetBytes(Content);
end;

{ TdxPDFInteractiveForm }

procedure TdxPDFInteractiveForm.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FFields := Repository.CreateInteractiveFormFieldCollection(Self);
  Resources := TdxPDFResources.CreateEx(Repository);
end;

procedure TdxPDFInteractiveForm.DestroySubClasses;
begin
  FreeAndNil(FFields);
  FreeAndNil(FDefaultAppearanceCommands);
  Resources := nil;
  inherited DestroySubClasses;
end;

procedure TdxPDFInteractiveForm.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  Resources := ADictionary.GetResources(TdxPDFKeywords.DictionaryResources);
  FNeedAppearances := ADictionary.GetBoolean(TdxPDFKeywords.NeedAppearances);
  FSignatureFlags := ADictionary.GetSignatureFlags(TdxPDFKeywords.SigFlags);
  FDefaultAppearanceCommands := ADictionary.GetAppearance(Resources);
  FDefaultTextJustify := ADictionary.GetTextJustify;
  ReadXFAForm(ADictionary);
  FFields.Read(ADictionary, ADictionary.GetArray(TdxPDFKeywords.Fields), Self, nil);
end;

procedure TdxPDFInteractiveForm.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.AddReference(TdxPDFKeywords.DictionaryResources, Resources);
  ADictionary.Add(TdxPDFKeywords.NeedAppearances, NeedAppearances);
  ADictionary.Add(TdxPDFKeywords.SigFlags, FSignatureFlags);
  ADictionary.SetAppearance(Resources, DefaultAppearanceCommands);
  ADictionary.SetTextJustify(FDefaultTextJustify);
  ADictionary.AddInline(TdxPDFKeywords.Fields, Fields);
  ADictionary.AddReference(TdxPDFKeywords.XFA, FXFAForm.ToByteArray);
end;

function TdxPDFInteractiveForm.AddSignatureField(ASignatureInfo: TObject): TObject;
begin
  Result := CreateSignatureField(ASignatureInfo as TdxPDFSignatureFieldInfo) as TdxPDFInteractiveFormSignatureField;
end;

function TdxPDFInteractiveForm.AddTextField(const AName: string; const ABounds: TdxPDFPageRect): TdxPDFInteractiveFormField;
var
  AWidget: TdxPDFWidgetAnnotation;
  AWidgetFlags: TdxPDFAnnotationFlags;
  AWidgetPage: TdxPDFPage;
  AWidgetRect: TdxPDFRectangle;
begin
  ValidateRect(ABounds);
  AWidgetPage := Repository.Catalog.Pages[ABounds.PageIndex];
  AWidgetRect := AWidgetPage.FromUserSpace(ABounds.Rect);
  AWidgetFlags := TdxPDFAnnotationFlags.afNone;
  AWidget := Repository.CreateWidgetAnnotation(AWidgetPage, AWidgetRect, AWidgetFlags) as TdxPDFWidgetAnnotation;

  Result := TdxPDFInteractiveFormTextField.Create(Self, AWidget, AName);
end;

function TdxPDFInteractiveForm.CreateSignatureField(AInfo: TObject): TdxPDFInteractiveFormField;

  procedure ValidateAppearanceInfo(AAppearanceInfo: TdxPDFSignatureFieldAppearanceInfo);
  begin
    if not AAppearanceInfo.Image.Empty then
      ValidateRect(AAppearanceInfo.Bounds);
  end;

var
  ASignature: TdxPDFSignature;
  AWidget: TdxPDFWidgetAnnotation;
  AWidgetFlags: TdxPDFAnnotationFlags;
  AWidgetPage: TdxPDFPage;
  AWidgetRect: TdxPDFRectangle;
  ASignatureFieldInfo: TdxPDFSignatureFieldInfo;
begin
  ASignatureFieldInfo := AInfo as TdxPDFSignatureFieldInfo;
  ValidateAppearanceInfo(ASignatureFieldInfo.Appearance);
  ASignature := TdxPDFSignature.Create(Repository, ASignatureFieldInfo);
  if (ASignature.Appearance <> nil) and not ASignatureFieldInfo.Appearance.Image.Empty then
  begin
    AWidgetPage := Repository.Catalog.Pages[ASignature.Appearance.PageIndex];
    AWidgetRect := ASignature.Appearance.Bounds;
  end
  else
  begin
    AWidgetPage := Repository.Catalog.Pages[0];
    AWidgetRect := TdxPDFRectangle.Null;
  end;
  AWidgetFlags := TdxPDFAnnotationFlags(Integer(afPrint) or Integer(afLocked));
  AWidget := Repository.CreateWidgetAnnotation(AWidgetPage, AWidgetRect, AWidgetFlags) as TdxPDFWidgetAnnotation;
  AWidget.RotationAngle := TdxPDFUtils.ConvertToIntEx(TdxPDFSignatureFieldInfo(AInfo).Appearance.RotationAngle);

  Result := TdxPDFInteractiveFormSignatureField.Create(Self, AWidget, ASignature);
  NeedAppearances := False;
end;

procedure TdxPDFInteractiveForm.DoDeleteKids(AField: TdxPDFInteractiveFormField; const AFieldName: string; AFlatten: Boolean);
var
  AKid: TdxPDFInteractiveFormField;
  AKidName: string;
  ANames: TStringDynArray;
  I: Integer;
begin
  if (AField.Kids = nil) or (AField.Kids.Count = 0) then
    Exit;
  ANames := TdxPDFUtils.SplitFieldName(AFieldName);
  AKidName := ANames[0];
  for I := 0 to AField.Kids.Count - 1 do
  begin
    AKid := AField.Kids[I] as TdxPDFInteractiveFormField;
    if AKid.Name = AKidName then
    begin
      if Length(ANames) > 1 then
      begin
        DoDeleteKids(AKid, ANames[1], AFlatten);
        Exit;
      end;
      AKid.DeleteAnnotation(AFlatten);
    end;
  end;
end;

procedure TdxPDFInteractiveForm.DeleteByName(const AFullName: string; AFlatten: Boolean);
var
  AField: TdxPDFInteractiveFormField;
  AFieldName: string;
  AFound: Boolean;
  ANames: TStringDynArray;
  I: Integer;
begin
  if AFullName = '' then
    Exit;
  ANames := TdxPDFUtils.SplitFieldName(AFullName);
  AFieldName := ANames[0];
  for I := 0 to FFields.Count - 1 do
  begin
    AField := FFields[I];
    AFound := AField.Name = AFieldName;
    if AFound then
    begin
      if Length(ANames) = 1 then
        AField.DeleteAnnotation(AFlatten)
      else
        DoDeleteKids(AField, ANames[1], AFlatten);
      DoDelete(AField);
      Break;
    end;
  end;
end;

procedure TdxPDFInteractiveForm.DoAdd(AField: TdxPDFInteractiveFormField);
begin
  FFields.AddWithAncestors(AField);
  dxCallNotify(Repository.OnAddField, AField);
end;

procedure TdxPDFInteractiveForm.DoDelete(AField: TdxPDFInteractiveFormField);
begin
  FFields.Delete(AField);
  dxCallNotify(Repository.OnDeleteField, AField);
  Repository.DeleteHoldObject(AField.Form);
end;

procedure TdxPDFInteractiveForm.SetResources(const AValue: TdxPDFResources);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FResources));
end;

procedure TdxPDFInteractiveForm.ReadXFAForm(ADictionary: TdxPDFReaderDictionary);
var
  AArray: TdxPDFArray;
  AStream: TdxPDFStream;
begin
  if ADictionary.TryGetArray(TdxPDFKeywords.XFA, AArray) then
    FXFAForm.Initialize(Repository, AArray)
  else
    if ADictionary.TryGetStream(TdxPDFKeywords.XFA, AStream) then
      FXFAForm.Initialize(AStream.UncompressedData);
end;

procedure TdxPDFInteractiveForm.ValidateRect(const ARect: TdxPDFPageRect);
var
  APages: TdxPDFPageList;
begin
  APages := Repository.Catalog.Pages;
  if not InRange(ARect.PageIndex, 0, APages.Count - 1) then
    TdxPDFUtils.RaiseException(Format('The page index should be in the range from 0 to %d.', [APages.Count - 1]));
end;

function TdxPDFInteractiveForm.HasSignatureFields: Boolean;
begin
  Result := sfSignaturesExist in SignatureFlags;
end;

procedure TdxPDFInteractiveForm.Add(AField: TdxPDFInteractiveFormField);
begin
  DoAdd(AField);
end;

procedure TdxPDFInteractiveForm.Delete(AField: TdxPDFInteractiveFormField; AFlatten: Boolean);
begin
  DeleteByName(AField.FullName, AFlatten);
end;

{ TdxPDFXMLPacket }

procedure TdxPDFXMLPacket.AfterConstruction;
begin
  inherited AfterConstruction;
  AutoIndent := True;
end;

function TdxPDFXMLPacket.GetFooterText: TdxXMLString;
begin
  Result := #13#10'<?xpacket end="w"?>';
end;

function TdxPDFXMLPacket.GetHeaderText: TdxXMLString;
begin
  Result := '<?xpacket begin="'#$EF#$BB#$BF'" id="W5M0MpCehiHzreSzNTczkc9d"?>'#13#10;
end;

{ TdxPDFMetadata }

class function TdxPDFMetadata.GetTypeName: string;
begin
  Result := TdxPDFKeywords.Metadata;
end;

procedure TdxPDFMetadata.Clear;
begin
  FData.Root.Clear;
end;

procedure TdxPDFMetadata.Update(AInformation: TdxPDFDocumentInformation);

  function AddDescription(ANode: TdxXMLNode): TdxXMLNode;
  begin
    Result := ANode.AddChild('rdf:Description');
    Result.Attributes.Add('rdf:about', '');
  end;

  procedure AddLocalizedText(ANode: TdxXMLNode; const AName, APrefix: TdxXMLString; const AValue: string);
  begin
    if AValue <> '' then
    begin
      ANode := ANode.AddChild(AName).AddChild('rdf:' + APrefix).AddChild('rdf:li');
      if APrefix = 'Alt' then
        ANode.Attributes.Add('xml:lang', 'x-default');
      ANode.TextAsString := AValue;
    end;
  end;

  procedure AddText(ANode: TdxXMLNode; const AName: TdxXMLString; const AValue: string);
  begin
    if AValue <> '' then
      ANode.AddChild(AName).TextAsString := AValue;
  end;

  procedure AddDate(ANode: TdxXMLNode; const AName: TdxXMLString; const AValue: TDateTime);
  begin
    if AValue <> NullDate then
      AddText(ANode, AName, TdxXMLDateTime.Create(AValue, True).ToString);
  end;

  procedure AddInformation(ANode: TdxXMLNode; AInformation: TdxPDFDocumentInformation);
  begin
    ANode := AddDescription(ANode);
    ANode.Attributes.Add('xmlns:dc', 'http://purl.org/dc/elements/1.1/');
    ANode.Attributes.Add('xmlns:pdf', 'http://ns.adobe.com/pdf/1.3/');
    ANode.Attributes.Add('xmlns:xmp', 'http://ns.adobe.com/xap/1.0/');

    AddDate(ANode, 'xmp:CreateDate', AInformation.CreationDate);
    AddText(ANode, 'xmp:CreatorTool', AInformation.Application);
    AddDate(ANode, 'xmp:ModifyDate', AInformation.ModificationDate);
    AddText(ANode, 'pdf:Producer', AInformation.Producer);
    AddText(ANode, 'pdf:Keywords', AInformation.Keywords);
    AddLocalizedText(ANode, 'dc:creator', 'Seq', AInformation.Author);
    AddLocalizedText(ANode, 'dc:description', 'Alt', AInformation.Subject);
    AddLocalizedText(ANode, 'dc:title', 'Alt', AInformation.Title);
    AddText(ANode, 'dc:format', 'application/pdf');
  end;

  procedure AddConformance(ANode: TdxXMLNode);
  begin
    ANode := AddDescription(ANode);
    ANode.Attributes.Add('xmlns:pdfaid', 'http://www.aiim.org/pdfa/ns/id/');
    ANode.Attributes.Add('pdfaid:conformance', 'A');
    ANode.Attributes.Add('pdfaid:part', 1);
  end;

var
  ANode: TdxXMLNode;
begin
  Clear;

  ANode := FData.Root.AddChild('x:xmpmeta');
  ANode.Attributes.Add('xmlns:x', 'adobe:ns:meta/');
  ANode.Attributes.Add('x:xmptk', 'XMP Core 5.5.0');

  ANode := ANode.AddChild('rdf:RDF');
  ANode.Attributes.Add('xmlns:rdf', 'http://www.w3.org/1999/02/22-rdf-syntax-ns#');

  AddInformation(ANode, AInformation);
//  AddConformance(ANode);
end;

procedure TdxPDFMetadata.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FData := TdxPDFXMLPacket.Create;
end;

procedure TdxPDFMetadata.DestroySubClasses;
begin
  FreeAndNil(FData);
  inherited DestroySubClasses;
end;

procedure TdxPDFMetadata.Read(AStream: TdxPDFStream);
var
  ABytesStream: TBytesStream;
  AIsEncrypted: Boolean;
begin
  Clear;
  if AStream <> nil then
  begin
    AIsEncrypted := (AStream.EncryptionInfo <> nil) and AStream.EncryptionInfo.EncryptMetadata;
    ABytesStream := TBytesStream.Create(AStream.UncompressData(AIsEncrypted));
    try
      FData.LoadFromStream(ABytesStream);
    finally
      ABytesStream.Free;
    end;
  end;
end;

procedure TdxPDFMetadata.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
var
  ABytesStream: TBytesStream;
  AData: TBytes;
begin
  inherited Write(AHelper, ADictionary);

  ABytesStream := TBytesStream.Create;
  try
    FData.SaveToStream(ABytesStream);
    AData := ABytesStream.Bytes;
    SetLength(AData, ABytesStream.Size);

    ADictionary.AddName(TdxPDFKeywords.Subtype, 'XML');
    ADictionary.SetStreamData(AData, False, AHelper.EncryptMetadata);
  finally
    ABytesStream.Free;
  end;
end;

{ TdxPDFOutlineItem }

function TdxPDFOutlineItem.CreateOutline: TdxPDFOutline;
begin
  Result := DoCreateOutline(
    function: TdxPDFOutline
    begin
      Result := TdxPDFOutline.CreateEx(Repository);
    end);
end;

function TdxPDFOutlineItem.CreateOutline(AParent: TdxPDFOutlineItem; ABookmark: TdxPDFBookmark; APrev: TdxPDFOutline): TdxPDFOutline;
begin
  Result := DoCreateOutline(
    function: TdxPDFOutline
    begin
      Result := TdxPDFOutline.Create(AParent, APrev, ABookmark);
    end);
end;

function TdxPDFOutlineItem.UpdateCount: Integer;
var
  AOutline: TdxPDFOutline;
begin
  FCount := 0;
  AOutline := FFirst;
  while AOutline <> nil do
  begin
    Inc(FCount);
    if not AOutline.Closed then
      Inc(FCount, AOutline.UpdateCount);
    AOutline := AOutline.Next;
  end;
  Result := FCount;
end;

function TdxPDFOutlineItem.DoCreateOutline(AFunc: TFunc<TdxPDFOutline>): TdxPDFOutline;
begin
  Result := AFunc;
  Result.FOnCreateItem := FOnCreateItem;
  dxCallNotify(FOnCreateItem, Result);
end;

procedure TdxPDFOutlineItem.DoRead(ADictionary: TdxPDFReaderDictionary);
var
  ANext: TdxPDFOutline;
  ANextDictionary: TdxPDFReaderDictionary;
  AOutlineDictionary: TdxPDFReaderDictionary;
  AOutlineObject: TdxPDFBase;
begin
  inherited DoRead(ADictionary);
  if ADictionary.TryGetObject(TdxPDFKeywords.OutlineFirst, AOutlineObject) then
  begin
    AOutlineDictionary := Repository.GetDictionary(AOutlineObject.Number);
    if (AOutlineDictionary <> nil) and (AOutlineDictionary <> ADictionary) then
    begin
      FFirst := CreateOutline;
      FFirst.Read(AOutlineDictionary, Self, nil);
      FLast := FFirst;
      ANextDictionary := AOutlineDictionary.GetDictionary(TdxPDFKeywords.OutlineNext);
      while ANextDictionary <> nil do
      begin
        ANext := CreateOutline;
        ANext.Read(ANextDictionary, Self, FLast);
        FLast.Next := ANext;
        FLast := ANext;
        ANextDictionary := ANextDictionary.GetDictionary(TdxPDFKeywords.OutlineNext);
      end;
      FClosed := ADictionary.GetInteger(TdxPDFKeywords.OutlineCount, 0) <= 0;
      UpdateCount;
    end;
  end;
end;

procedure TdxPDFOutlineItem.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
var
  AScan: TdxPDFOutline;
begin
  UpdateCount;
  ADictionary.Add(TdxPDFKeywords.OutlineCount, Count, 0);
  ADictionary.AddReference(TdxPDFKeywords.OutlineFirst, First);
  ADictionary.AddReference(TdxPDFKeywords.OutlineLast, Last);

  AScan := First;
  while AScan <> nil do
  begin
    AHelper.RegisterIndirectObject(AScan);
    AScan := AScan.Next;
  end;
end;

{ TdxPDFOutline }

function TdxPDFOutline.GetActualDestination: TdxPDFCustomDestination;
var
  ADestination: TdxPDFCustomDestination;
begin
  ADestination := Destination;
  if ADestination <> nil then
    Result := ADestination
  else
  begin
    if FAction is TdxPDFGoToAction then
      Result := TdxPDFGoToAction(FAction).Destination
    else
      Result := nil
  end;
end;

function TdxPDFOutline.GetDestination: TdxPDFCustomDestination;
begin
  if DestinationInfo <> nil then
    Result := DestinationInfo.GetDestination(FCatalog, True)
  else
    Result := nil;
end;

procedure TdxPDFOutline.SetAction(const AValue: TdxPDFCustomAction);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FAction));
end;

procedure TdxPDFOutline.SetDestinationInfo(const AValue: TdxPDFDestinationInfo);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FDestinationInfo));
end;

procedure TdxPDFOutline.ReadColor(ADictionary: TdxPDFDictionary);
var
  AComponents: TDoubleDynArray;
begin
  AComponents := ADictionary.GetDoubleArray(TdxPDFKeywords.OutlineColor);
  if Length(AComponents) = 0 then
    FColor := TdxPDFColor.Null
  else
    FColor := TdxPDFColor.Create(AComponents);
end;

procedure TdxPDFOutline.ReadFlags(ADictionary: TdxPDFDictionary);
var
  AFlags: Integer;
begin
  AFlags := ADictionary.GetInteger(TdxPDFKeywords.OutlineFlags, 0);
  FIsItalic := (AFlags and Italic) > 0;
  FIsBold := (AFlags and Bold) > 0;
end;

procedure TdxPDFOutline.WriteFlags(ADictionary: TdxPDFDictionary);
var
  AFlags: Integer;
begin
  AFlags := 0;
  if FIsItalic then
    AFlags := AFlags or Italic;
  if FIsBold then
    AFlags := AFlags or Bold;
  if AFlags <> 0 then
    ADictionary.Add(TdxPDFKeywords.OutlineFlags, AFlags);
end;

class function TdxPDFOutline.CreateOutlineTree(AParent: TdxPDFOutlineItem; ABookmarks: TdxPDFBookmarkList): TdxPDFOutline;
var
  I: Integer;
  ALast, ANext: TdxPDFOutline;
begin
  if ABookmarks.Count = 0 then
    Exit(nil);
  Result := AParent.CreateOutline(AParent, ABookmarks[0], nil);
  ALast := Result;
  for I := 1 to ABookmarks.Count - 1 do
  begin
    ANext := AParent.CreateOutline(AParent, ABookmarks[I], ALast);
    ALast.Next := ANext;
    ALast := ANext;
  end;
  AParent.Last := ALast;
end;

class function TdxPDFOutline.GetTypeName: string;
begin
  Result := TdxPDFKeywords.Outline;
end;

constructor TdxPDFOutline.Create(AParent: TdxPDFOutlineItem; APrev: TdxPDFOutline; ABookmark: TdxPDFBookmark);
begin
  inherited CreateEx(AParent.Repository);
  Action := ABookmark.Action;
  DestinationInfo := ABookmark.DestinationInfo;
  FParent := AParent;
  if FParent <> nil then
    FOnCreateItem := AParent.FOnCreateItem;
  FPrev := APrev;
  FColor := ABookmark.FColor;
  FIsBold := ABookmark.IsBold;
  FIsItalic := ABookmark.IsItalic;
  FTitle := ABookmark.Title;
  First := CreateOutlineTree(Self, ABookmark.Children);
  UpdateCount;
end;

function TdxPDFOutline.HasChildren: Boolean;
begin
  Result := First <> nil;
end;

procedure TdxPDFOutline.DestroySubClasses;
begin
  DestinationInfo := nil;
  Action := nil;
  inherited DestroySubClasses;
end;

procedure TdxPDFOutline.Read(ADictionary: TdxPDFReaderDictionary; AParent: TdxPDFOutlineItem; APrev: TdxPDFOutline);
begin
  Read(ADictionary);
  if ADictionary <> nil then
  begin
    Number := ADictionary.Number;
    FParent := AParent;
    FCatalog := Repository.Catalog;
    FTitle := ADictionary.GetTextString(TdxPDFKeywords.OutlineTitle);
    Action := ADictionary.GetAction(TdxPDFKeywords.OutlineAction);
    DestinationInfo := ADictionary.GetDestinationInfo(TdxPDFKeywords.OutlineDestination);
    if (APrev = nil) and (ADictionary.GetDictionary(TdxPDFKeywords.OutlinePrev) <> nil) then
      TdxPDFUtils.RaiseException;
    FPrev := APrev;
    ReadColor(ADictionary);
    ReadFlags(ADictionary);
  end;
end;

procedure TdxPDFOutline.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.Add(TdxPDFKeywords.OutlineTitle, FTitle);
  ADictionary.AddReference(TdxPDFKeywords.Parent, FParent);
  ADictionary.AddReference(TdxPDFKeywords.OutlineAction, FAction);
  ADictionary.AddReference(TdxPDFKeywords.OutlinePrev, Prev);
  ADictionary.AddReference(TdxPDFKeywords.OutlineNext, Next);
  ADictionary.Add(TdxPDFKeywords.OutlineDestination, FDestinationInfo);
  ADictionary.Add(TdxPDFKeywords.OutlineColor, FColor);
  WriteFlags(ADictionary);
end;

{ TdxPDFOutlines }

class function TdxPDFOutlines.GetTypeName: string;
begin
  Result := TdxPDFKeywords.Outlines;
end;

constructor TdxPDFOutlines.CreateFrom(ABookmarks: TdxPDFBookmarkList);
begin
  CreateEx(ABookmarks.Catalog.Repository);
  First := TdxPDFOutline.CreateOutlineTree(Self, ABookmarks);
  UpdateCount;
end;

procedure TdxPDFOutlines.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FItems := TdxFastObjectList.Create;
end;

procedure TdxPDFOutlines.DestroySubClasses;
begin
  FreeAndNil(FItems);
  inherited DestroySubClasses;
end;

procedure TdxPDFOutlines.Initialize;
begin
  inherited Initialize;
  FOnCreateItem := OnCreateItemHandler;
end;

procedure TdxPDFOutlines.Clear;
begin
  FItems.Clear;
end;

procedure TdxPDFOutlines.DeleteOutlines(APage: TdxPDFPage);
var
  AList: TdxFastList;
  I: Integer;
begin
  AList := TdxFastList.Create;
  try
    DoDelete(AList, Repository.Catalog.Outlines, APage);
    for I := 0 to AList.Count - 1 do
      Delete(TObject(AList[I]) as TdxPDFOutlineItem);
    if AList.Count > 0 then
      Repository.OutlinesChanged;
  finally
    AList.Free;
  end;
end;

procedure TdxPDFOutlines.Delete(AValue: TdxPDFOutlineItem);
begin
  FItems.Remove(AValue);
end;

procedure TdxPDFOutlines.DoDelete(AList: TdxFastList; AItem: TdxPDFOutlineItem; APage: TdxPDFPage);
var
  ADestination: TdxPDFCustomDestination;
  AOutline, APrevious, ANext: TdxPDFOutline;
begin
  if AItem = nil then
    Exit;
  AOutline := AItem.First;
  while AOutline <> nil do
  begin
    ADestination := AOutline.Destination;
    if (ADestination = nil) and (AOutline.Action <> nil) and (AOutline.Action is TdxPDFGoToAction) then
      ADestination := TdxPDFGoToAction(AOutline.Action).Destination;
    if (ADestination <> nil) and (ADestination.Page = APage) then
    begin
      if AList.IndexOf(AOutline) = -1 then
        AList.Add(AOutline);
      APrevious := AOutline.Prev;
      ANext := AOutline.Next;
      if APrevious <> nil then
        APrevious.Next := ANext;
      if ANext <> nil then
        ANext.Prev := APrevious;
      if AItem.First = AOutline then
        AItem.First := ANext;
      if AItem.Last = AOutline then
        AItem.Last := APrevious;
    end;
    DoDelete(AList, AOutline, APage);
    AOutline := AOutline.Next;
  end;
  AItem.UpdateCount;
end;

procedure TdxPDFOutlines.OnCreateItemHandler(AItem: TObject);
begin
  dxTestCheck(FItems.IndexOf(AItem) = -1, 'FItems.IndexOf(AItem) <> -1');
  FItems.Add(AItem as TdxPDFOutlineItem);
end;

{ TdxPDFBookmark }

constructor TdxPDFBookmark.Create;
begin
  inherited Create;
  FChildren := TdxPDFBookmarkList.Create(Self);
end;

constructor TdxPDFBookmark.Create(ADestinationInfo: TdxPDFDestinationInfo);
begin
  Create;
  DestinationInfo := ADestinationInfo;
end;

constructor TdxPDFBookmark.Create(ADestinationInfo: TdxPDFDestinationInfo; ABookmark: TdxPDFBookmark;
  AAction: TdxPDFCustomAction);
begin
  Create(ADestinationInfo);
  Action := AAction;
  FColor := ABookmark.FColor;
  FIsBold := ABookmark.IsBold;
  FIsItalic := ABookmark.IsItalic;
  FIsItalic := ABookmark.IsItalic;
  FTitle := ABookmark.Title;
end;

constructor TdxPDFBookmark.Create(const AParent: IdxPDFBookmarkParent; AOutline: TdxPDFOutline);
begin
  Create(AOutline.DestinationInfo);
  FParent := AParent;
  Action := AOutline.Action;
  FColor := AOutline.Color;
  FIsBold := AOutline.IsBold;
  FIsItalic := AOutline.IsItalic;
  FIsItalic := AOutline.IsItalic;
  FTitle := AOutline.Title;
  FreeAndNil(FChildren);
  FChildren := TdxPDFBookmarkList.Create(Self, AOutline);
end;

destructor TdxPDFBookmark.Destroy;
begin
  Action := nil;
  DestinationInfo := nil;
  FreeAndNil(FChildren);
  inherited Destroy;
end;

function TdxPDFBookmark.GetCatalog: TdxPDFCatalog;
begin
  if Parent <> nil then
    Result := Parent.GetCatalog
  else
    Result := nil;
end;

procedure TdxPDFBookmark.Changed;
begin
  if Parent <> nil then
    Parent.Changed;
end;

function TdxPDFBookmark.GetDestination: TdxPDFCustomDestination;
begin
  if FDestinationInfo <> nil then
    Result := FDestinationInfo.GetDestination(GetCatalog, True)
  else
    Result := nil
end;

function TdxPDFBookmark.GetOperation: TdxPDFInteractiveOperation;
begin
  if not FOperation.IsValid then
    FOperation := TdxPDFInteractiveOperation.Create(FAction, FDestinationInfo.GetDestination(GetCatalog, True));
  Result := FOperation;
end;

procedure TdxPDFBookmark.SetAction(const AValue: TdxPDFCustomAction);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FAction));
end;

procedure TdxPDFBookmark.SetDestinationInfo(const AValue: TdxPDFDestinationInfo);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FDestinationInfo));
end;

{ TdxPDFBookmarkList }

class function TdxPDFBookmarkList.CreateOutlines(ABookmarks: TdxPDFBookmarkList): TdxPDFOutlines;
begin
  if (ABookmarks <> nil) and (ABookmarks.Count > 0) then
    Result := TdxPDFOutlines.CreateFrom(ABookmarks)
  else
    Result := nil;
end;

constructor TdxPDFBookmarkList.Create;
begin
  inherited Create;
  FItems := TdxFastObjectList.Create;
end;

constructor TdxPDFBookmarkList.Create(const AParent: IdxPDFBookmarkParent);
begin
  Create;
  FParent := AParent;
end;

constructor TdxPDFBookmarkList.Create(const AParent: IdxPDFBookmarkParent; AItem: TdxPDFOutlineItem);
var
  ACatalog: TdxPDFCatalog;
  AOutline: TdxPDFOutline;
begin
  Create(AParent);
  if AItem <> nil then
  begin
    ACatalog := GetCatalog;
    if ACatalog <> nil then
      ACatalog.BeginUpdate;
    try
      try
        AOutline := AItem.First;
        while AOutline <> nil do
        begin
          FItems.Add(TdxPDFBookmark.Create(AParent, AOutline));
          AOutline := AOutline.Next;
        end;
      except
        on EdxPDFException do;
        on EdxPDFAbortException do;
        else
          raise;
      end;
    finally
      if ACatalog <> nil then
        ACatalog.CancelUpdate;
    end;
  end;
end;

destructor TdxPDFBookmarkList.Destroy;
begin
  FreeAndNil(FItems);
  inherited Destroy;
end;

procedure TdxPDFBookmarkList.Add(ABookmark: TdxPDFBookmark);
begin
  DoAdd(ABookmark);
end;

procedure TdxPDFBookmarkList.Clear;
begin
  FItems.Clear;
  Changed;
end;

procedure TdxPDFBookmarkList.DoAdd(ABookmark: TdxPDFBookmark);
var
  ACatalog: TdxPDFCatalog;
  ADestination: TdxPDFCustomDestination;
begin
  dxTestCheck(FParent <> nil, 'FParent = nil');
  ADestination := ABookmark.Destination;
  ACatalog := GetCatalog;
  if (ACatalog <> nil) and (ADestination <> nil) and (ADestination.Page <> nil) and (ACatalog <> ADestination.Page.Repository.Catalog) then
    TdxPDFUtils.RaiseException('The bookmark destination can''''t be linked to the page in a different document.');
  ABookmark.FParent := FParent;
  FItems.Add(ABookmark);
  Changed;
end;

function TdxPDFBookmarkList.GetCatalog: TdxPDFCatalog;
begin
  Result := FParent.GetCatalog;
end;

function TdxPDFBookmarkList.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TdxPDFBookmarkList.GetItem(AIndex: Integer): TdxPDFBookmark;
begin
  Result := FItems[AIndex] as TdxPDFBookmark;
end;

procedure TdxPDFBookmarkList.Changed;
begin
  if FParent <> nil then
    FParent.Changed;
end;

{ TdxPDFCatalog }

class function TdxPDFCatalog.GetTypeName: string;
begin
  Result := TdxPDFKeywords.Catalog;
end;

constructor TdxPDFCatalog.Create(AParent: TdxPDFObject);
begin
  inherited Create(AParent);
  Repository.Catalog := Self;
end;

procedure TdxPDFCatalog.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FPages := TdxPDFPageList.Create(Self);
  FPages.OnPageDeleting := OnPageDeletingHandler;
  FMetadata := Repository.CreateMetadata;
end;

procedure TdxPDFCatalog.DestroySubClasses;
begin
  FreeAndNil(FMetadata);
  FreeAndNil(FOutlines);
  FreeAndNil(FBookmarks);
  DestroyFileAttachments;
  FreeAndNil(FOpenDestination);
  FreeAndNil(FOpenAction);
  FreeAndNil(FNames);
  FreeAndNil(FPages);
  AcroForm := nil;
  inherited DestroySubClasses;
end;

procedure TdxPDFCatalog.Initialize;
begin
  inherited Initialize;
  FNeedReadNames := True;
  FNeedReadOutlines := True;
  FAcroForm := nil;
  FNames := nil;
  FOpenAction := nil;
  FOpenDestination := nil;
end;

procedure TdxPDFCatalog.Read(ADictionary: TdxPDFReaderDictionary);
begin
  inherited Read(ADictionary);
  if ADictionary <> nil then
  begin
    FDictionary := ADictionary;
    ReadPages;
    ReadInteractiveObjects;
    ReadMetadata;
  end
  else
    TdxPDFUtils.Abort;
end;

procedure TdxPDFCatalog.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.AddReference(TdxPDFKeywords.Pages, Pages);
  ADictionary.AddReference(TdxPDFKeywords.Outlines, Outlines);
  ADictionary.AddReference(TdxPDFKeywords.Metadata, Metadata);
  ADictionary.AddInline(TdxPDFKeywords.Names, Names);
  WriteInteractiveObjects(AHelper, ADictionary);
end;

function TdxPDFCatalog.GetEmbeddedFileSpecification(const AName: string): TdxPDFFileSpecification;
begin
  if Names <> nil then
    Result := Names.GetEmbeddedFileSpecification(AName)
  else
    Result := nil;
end;

function TdxPDFCatalog.GetDestination(const AName: string): TdxPDFCustomDestination;
begin
  if Names <> nil then
    Result := Names.GetPageDestination(AName)
  else
    Result := nil;
end;

function TdxPDFCatalog.HasPageReference(AField: TdxPDFInteractiveFormField; APage: TdxPDFPage): Boolean;
begin
  if AField.Kids <> nil then
    PerformFor<TdxPDFInteractiveFormField>(AField.Kids.List,
      function(AObject: TdxPDFInteractiveFormField): Boolean
      begin
        Result := HasPageReference(AObject, APage);
      end, nil);
  Result := HasPageReference(AField.Widget, APage) or (AField.Kids <> nil) and (AField.Kids.Count = 0);
end;

function TdxPDFCatalog.HasPageReference(AAnnotation: TdxPDFCustomAnnotation; APage: TdxPDFPage): Boolean;
begin
  Result := (AAnnotation <> nil) and (AAnnotation.Page = APage);
end;

procedure TdxPDFCatalog.DeleteAnnotations(APage: TdxPDFPage);
var
  I: Integer;
begin
  for I := 0 to Pages.Count - 1 do
    PerformFor<TdxPDFCustomAnnotation>(Pages[I].Annotations,
      function(AObject: TdxPDFCustomAnnotation): Boolean
      var
        AAction: TdxPDFGoToAction;
        ADestination: TdxPDFCustomDestination;
      begin
        if AObject is TdxPDFLinkAnnotation then
        begin
          if Safe.Cast(TdxPDFLinkAnnotation(AObject).Action, TdxPDFGoToAction, AAction) then
          begin
            if (AAction.Destination <> nil) and (AAction.Destination.Page = APage) then
              Exit(True);
          end;
          ADestination := TdxPDFLinkAnnotationAccess(AObject).Destination;
          if (ADestination <> nil) and (ADestination.Page = APage) then
            Exit(True);
        end;
        Result := AObject.Page = APage;
        if Result and (AObject is TdxPDFFileAttachmentAnnotation )then
        begin
          RemoveAttachment(TdxPDFFileAttachmentAnnotation(AObject).Attachment);
          Result := False;
        end;
      end, nil);
end;

procedure TdxPDFCatalog.DeleteDestinations(APage: TdxPDFPage);
begin
  Names.PageDestinations.RemoveAll(
    function(AObject: TdxPDFCustomDestination): Boolean
    begin
      Result := AObject.Page = APage;
    end);
end;

procedure TdxPDFCatalog.DeleteFields(APage: TdxPDFPage);
begin
  PerformFor<TdxPDFInteractiveFormField>(Repository.Catalog.AcroForm.Fields.List,
    function(AField: TdxPDFInteractiveFormField): Boolean
    begin
      Result := HasPageReference(AField, APage) or HasPageReference(AField.Widget, APage);
    end,
    procedure(AFieldToDelete: TdxPDFInteractiveFormField)
    begin
      AcroForm.Delete(AFieldToDelete, False);
    end);
end;

procedure TdxPDFCatalog.Refresh;
begin
  if FIsBookmarksChanged then
    FreeAndNil(FOutlines);
  FileAttachments.Refresh;
  TdxPDFDocumentAccess(Repository.Document).UpdateForm;
end;

procedure TdxPDFCatalog.RemoveAttachment(AAttachment: TdxPDFFileAttachment);
begin
  if FFileAttachments <> nil then
    FFileAttachments.Remove(AAttachment);
end;

function TdxPDFCatalog.IsEmpty: Boolean;
begin
  Result := FPages.Count = 0;
end;

procedure TdxPDFCatalog.EnumAnnotations(AFunc: TFunc<TdxPDFCustomAnnotation, Boolean>);
var
  AAnnotation: TdxPDFCustomAnnotation;
  AAnnotations: TdxPDFReferencedObjects;
  I, J: Integer;
begin
  for I := 0 to Pages.Count - 1 do
  begin
    AAnnotations := Pages[I].Annotations;
    for J := 0 to AAnnotations.Count - 1 do
    begin
      AAnnotation := AAnnotations[J] as TdxPDFCustomAnnotation;
      if AFunc(AAnnotation) then
        Break;
    end
  end;
end;

procedure TdxPDFCatalog.LockChanges(AFunc: TFunc<Boolean>);
var
  AChanged: Boolean;
begin
  AChanged := False;
  BeginUpdate;
  try
    AChanged := AFunc;
  finally
    if AChanged then
      EndUpdate
    else
      CancelUpdate;
  end;
end;

procedure TdxPDFCatalog.SetAcroForm(const AValue: TdxPDFInteractiveForm);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FAcroForm));
end;

procedure TdxPDFCatalog.SetPages(const AValue: TdxPDFPageList);
begin
  FreeAndNil(FPages);
  FPages := AValue;
end;

function TdxPDFCatalog.CanWriteAcroForm: Boolean;
begin
  Result := (AcroForm.Fields <> nil) and (AcroForm.Fields.Count > 0);
end;

procedure TdxPDFCatalog.CreateFileAttachments;
begin
  FFileAttachments := TdxPDFFileAttachmentList.Create;
  FFileAttachments.FCatalog := Self;
  FFileAttachments.Refresh;
end;

procedure TdxPDFCatalog.DestroyFileAttachments;
begin
  if FFileAttachments <> nil then
  begin
    FFileAttachments.FCatalog := nil;
    FreeAndNil(FFileAttachments);
  end;
end;

procedure TdxPDFCatalog.EnsureOutlines;
begin
  ReadOutlines(GetDictionary(TdxPDFKeywords.Outlines));
end;

procedure TdxPDFCatalog.LockChanges(AProc: TProc);
begin
  BeginUpdate;
  try
    AProc;
  finally
    CancelUpdate;
  end;
end;

procedure TdxPDFCatalog.PerformFor<T>(AList: TdxPDFReferencedObjects; ACondition: TFunc<T, Boolean>; AAction: TProc<T>);
var
  AObject: T;
  I: Integer;
begin
  if (AList = nil) or not Assigned(ACondition) then
    Exit;
  for I := AList.Count - 1 downto 0 do
  begin
    AObject := T(AList[I]);
    if ACondition(AObject) then
    begin
      if not Assigned(AAction)  then
        AList.Delete(I)
      else
        AAction(AObject);
    end;
  end;
end;

procedure TdxPDFCatalog.ReadAcroForm;
var
  ADictionary: TdxPDFReaderDictionary;
begin
  if FDictionary.TryGetDictionary(TdxPDFKeywords.AcroForm, ADictionary) then
    AcroForm.Read(ADictionary);
end;

function TdxPDFCatalog.GetAcroForm: TdxPDFInteractiveForm;
begin
  if FAcroForm = nil then
    SetAcroForm(Repository.CreateAcroForm);
  Result := FAcroForm;
end;

function TdxPDFCatalog.GetBookmarks: TdxPDFBookmarkList;
begin
  if FBookmarks = nil then
    FBookmarks := TdxPDFBookmarkList.Create(Self, Outlines);
  Result := FBookmarks;
end;

function TdxPDFCatalog.GetDictionary(const AKey: string): TdxPDFReaderDictionary;
begin
  if IsDictionaryAvailable then
    Result := FDictionary.GetDictionary(AKey)
  else
    Result := nil;
end;

function TdxPDFCatalog.GetFileAttachments: TdxPDFFileAttachmentList;
begin
  if FFileAttachments = nil then
    CreateFileAttachments;
  Result := FFileAttachments;
end;

function TdxPDFCatalog.GetNames: TdxPDFDocumentNames;
begin
  ReadNames(GetDictionary(TdxPDFKeywords.Names));
  Result := FNames;
end;

function TdxPDFCatalog.GetOutlines: TdxPDFOutlines;
begin
  if FIsBookmarksChanged then
  begin
    FreeAndNil(FOutlines);
    FOutlines := TdxPDFBookmarkList.CreateOutlines(Bookmarks);
    FIsBookmarksChanged := False;
  end;
  EnsureOutlines;
  Result := FOutlines;
end;

function TdxPDFCatalog.IsDictionaryAvailable: Boolean;
begin
  Result := FDictionary <> nil;
end;

procedure TdxPDFCatalog.ReadInteractiveObjects;
var
  AObject: TdxPDFBase;
begin
  AObject := FDictionary.GetObject(TdxPDFKeywords.OpenAction);
  if AObject <> nil then
  begin
    if AObject.ObjectType <> otArray then
      FOpenAction := FDictionary.GetAction(TdxPDFKeywords.OpenAction)
    else
    begin
      FOpenDestination := Repository.CreateDestination(AObject);
      if FOpenDestination <> nil then
        FOpenDestination.ResolveInternalPage;
    end;
  end;
  ReadAcroForm;
end;

procedure TdxPDFCatalog.ReadMetadata;
var
  AStream: TdxPDFStream;
begin
  if FDictionary.TryGetStream(TdxPDFKeywords.Metadata, AStream) then
    FMetadata.Read(AStream);
end;

procedure TdxPDFCatalog.ReadNames(ADictionary: TdxPDFReaderDictionary);
begin
  if FNeedReadNames then
  begin
    FNames := Repository.CreateAndRead(TdxPDFDocumentNames, ADictionary) as TdxPDFDocumentNames;
    FNeedReadNames := False;
  end;
end;

procedure TdxPDFCatalog.ReadOutlines(ADictionary: TdxPDFReaderDictionary);
begin
  if FNeedReadOutlines then
  begin
    FOutlines := Repository.CreateAndRead(TdxPDFOutlines, ADictionary) as TdxPDFOutlines;
    FNeedReadOutlines := False;
  end;
end;

procedure TdxPDFCatalog.ReadPages;
var
  ADictionary: TdxPDFReaderDictionary;
begin
  ADictionary := GetDictionary(TdxPDFKeywords.Pages);
  if ADictionary <> nil then
    LockChanges(
      procedure
      begin
        Pages.Clear;
        Pages.Read(ADictionary);
      end)
  else
    TdxPDFUtils.Abort;
end;

procedure TdxPDFCatalog.WriteInteractiveObjects(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  if OpenAction <> nil then
    ADictionary.AddReference(TdxPDFKeywords.OpenAction, OpenAction)
  else
    if OpenDestination <> nil then
      ADictionary.AddInline(TdxPDFKeywords.OpenAction, OpenDestination);

  if CanWriteAcroForm then
    ADictionary.AddReference(TdxPDFKeywords.AcroForm, AcroForm);
end;

function TdxPDFCatalog.GetCatalog: TdxPDFCatalog;
begin
  Result := Self;
end;

procedure TdxPDFCatalog.BookmarksChanged;
begin
  FIsBookmarksChanged := True;
end;

function TdxPDFCatalog.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := S_OK
  else
    Result := E_NOINTERFACE;
end;

function TdxPDFCatalog._AddRef: Integer;
begin
  Result := -1;
end;

function TdxPDFCatalog._Release: Integer;
begin
  Result := -1;
end;

procedure TdxPDFCatalog.OnPageDeletingHandler(Sender: TObject);
var
  APage: TdxPDFPage absolute Sender;
begin
  PerformBatchOperation(
    procedure
    begin
      DeleteDestinations(APage);
      Outlines.DeleteOutlines(APage);
      DeleteAnnotations(APage);
      DeleteFields(APage);
      if (FOpenDestination <> nil) and (FOpenDestination.Page = APage) then
        FOpenDestination.ClearPageReference;
    end);
end;

{ TdxPDFCustomFont }

class function TdxPDFFonts.GetTypeName: string;
begin
  Result := TdxPDFKeywords.Font;
end;

function TdxPDFFonts.GetFont(const AName: string): TdxPDFCustomFont;
begin
  Result := GetObject(AName) as TdxPDFCustomFont;
end;

class function TdxPDFFonts.GetTypePrefix: string;
begin
  Result := 'FNT';
end;

procedure TdxPDFFonts.Read(ADictionary: TdxPDFReaderDictionary);
begin
  ReadList(ADictionary);
end;

{ TdxPDFGraphicsStateParametersList }

class function TdxPDFGraphicsStateParametersList.GetTypeName: string;
begin
  Result := TdxPDFKeywords.ExtGState;
end;

function TdxPDFGraphicsStateParametersList.GetParameters(const AName: string): TdxPDFGraphicsStateParameters;
begin
  Result := GetObject(AName) as TdxPDFGraphicsStateParameters;
end;

procedure TdxPDFGraphicsStateParametersList.Add(const AName: string; AStateParameters: TdxPDFGraphicsStateParameters);
begin
  InternalAdd(AName, AStateParameters);
end;

class function TdxPDFGraphicsStateParametersList.GetTypePrefix: string;
begin
  Result := 'P';
end;

function TdxPDFGraphicsStateParametersList.GetTypeDictionaryKey: string;
begin
  Result := TdxPDFKeywords.TypeKey;
end;

procedure TdxPDFGraphicsStateParametersList.Read(ADictionary: TdxPDFReaderDictionary);
begin
  ReadList(ADictionary);
end;

procedure TdxPDFGraphicsStateParametersList.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  WriteList(AHelper, ADictionary);
end;

{ TdxPDFPageContentItem }

class function TdxPDFPageContentItem.GetTypeName: string;
begin
  Result := '';
end;

{ TdxPDFXObject }

class function TdxPDFXObject.GetTypeName: string;
begin
  Result := TdxPDFKeywords.XObject;
end;

procedure TdxPDFXObject.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  ADictionary.AddName(TdxPDFKeywords.TypeKey, TdxPDFKeywords.XObject);
  ADictionary.AddName(TdxPDFKeywords.Subtype, GetTypeName);
  WriteData(AHelper, ADictionary);
end;

procedure TdxPDFXObject.Draw(const AInterpreter: IdxPDFCommandInterpreter);
begin
  EnterCriticalSection(FLock);
  try
    DoDraw(AInterpreter);
  finally
    LeaveCriticalSection(FLock);
  end;
end;

procedure TdxPDFXObject.CreateSubClasses;
begin
  inherited CreateSubClasses;
  InitializeCriticalSectionAndSpinCount(FLock, 1024);
end;

procedure TdxPDFXObject.DestroySubClasses;
begin
  DeleteCriticalSection(FLock);
  inherited DestroySubClasses;
end;

procedure TdxPDFXObject.DoDraw(const AInterpreter: IdxPDFCommandInterpreter);
begin
// do nothing
end;

{ TdxPDFXForm }

class function TdxPDFXForm.GetTypeName: string;
begin
  Result := TdxPDFKeywords.Form;
end;

constructor TdxPDFXForm.Create(ARepository: TdxPDFDocumentRepository; const ABBox: TdxPDFRectangle);
begin
  CreateEx(ARepository);
  FBBox := ABBox;
  FMatrix := TdxPDFTransformationMatrix.Create;
  Stream := TdxPDFStream.Create(nil);
  EnsureResources;
end;

function TdxPDFXForm.GetCommands: TdxPDFCommandList;
begin
  if FCommands = nil then
  begin
    FCommands := TdxPDFCommandList.Create;
    FCommands.Read(ActualStream, Repository, Resources);
  end;
  Result := FCommands;
end;

function TdxPDFXForm.GetTransformationMatrix(const ARect: TdxPDFRectangle): TdxPDFTransformationMatrix;
var
  ABoundingBox: TdxPDFRectangle;
  I: Integer;
  ALeft, ARight, ATop, ABottom, AXMin, AXMax, AYMin, AYMax, X, Y, AScaleX, AScaleY: Double;
  ABottomLeft, APoint, AOffset: TdxPointF;
  APoints: TdxPDFPoints;
begin
  ABoundingBox := BBox;
  ALeft := ABoundingBox.Left;
  ARight := ABoundingBox.Right;
  ATop := ABoundingBox.Top;
  ABottom := ABoundingBox.Bottom;
  ABottomLeft := FMatrix.Transform(dxPointF(ALeft, ABottom));
  AXMin := ABottomLeft.X;
  AXMax := ABottomLeft.X;
  AYMin := ABottomLeft.Y;
  AYMax := ABottomLeft.Y;
  SetLength(APoints, 3);
  APoints[0] := FMatrix.Transform(dxPointF(ALeft, ATop));
  APoints[1] := FMatrix.Transform(dxPointF(ARight, ATop));
  APoints[2] := FMatrix.Transform(dxPointF(ARight, ABottom));

  for I := Low(APoints) to High(APoints) do
  begin
    APoint := APoints[I];
    X := APoint.X;
    AXMin := TdxPDFUtils.Min(AXMin, X);
    AXMax := TdxPDFUtils.Max(AXMax, X);
    Y := APoint.Y;
    AYMin := TdxPDFUtils.Min(AYMin, Y);
    AYMax := TdxPDFUtils.Max(AYMax, Y);
  end;

  if (AXMax - AXMin) <> 0 then
  begin
    AScaleX := ARect.Width / (AXMax - AXMin);
    AOffset.X := ARect.Left - AXMin * AScaleX;
  end
  else
  begin
    AScaleX := 1;
    AOffset.X := 0;
  end;

  if (AYMax - AYMin) <> 0 then
  begin
    AScaleY := Abs(ARect.Height) / (AYMax - AYMin);
    AOffset.Y := ARect.Bottom - AYMin * AScaleY;
  end
  else
  begin
    AScaleY := 1;
    AOffset.Y := 0;
  end;

  Result := TdxPDFTransformationMatrix.Create(AScaleX, 0, 0, AScaleY, AOffset.X, AOffset.Y);
end;

procedure TdxPDFXForm.EnsureResources;
begin
  if Resources = nil then
  begin
    Resources := Repository.CreateResources;
    FUseOwnResources := True;
  end;
end;

procedure TdxPDFXForm.ReplaceCommands(const ACommandData: TBytes);
begin
  FreeAndNil(FCommands);
  SetStreamData(ACommandData);
end;

procedure TdxPDFXForm.DoDraw(const AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.DrawForm(Self);
end;

procedure TdxPDFXForm.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  FStreamRef := ADictionary.StreamRef;
  if ADictionary.Contains(TdxPDFKeywords.BBox) then
    FBBox := ADictionary.GetRectangleEx(TdxPDFKeywords.BBox)
  else
    FBBox := TdxPDFRectangle.Create(0, 0, 0, 0);

  CheckFormType(ADictionary);
  FMatrix := ADictionary.GetMatrix(TdxPDFKeywords.Matrix);
  Resources := Repository.CreateResources(ADictionary);
end;

procedure TdxPDFXForm.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FCommands := nil;
  Resources := nil;
end;

procedure TdxPDFXForm.DestroySubClasses;
begin
  Repository.RemoveResolvedForm(Self);
  Resources := nil;
  FreeAndNil(FCommands);
  inherited DestroySubClasses;
end;

procedure TdxPDFXForm.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.Add(TdxPDFKeywords.BBox, BBox, False);
  ADictionary.Add(TdxPDFKeywords.FormType, 1);
  ADictionary.Add(TdxPDFKeywords.Matrix, FMatrix);
  ADictionary.AddReference(TdxPDFKeywords.Resources, Resources);
end;

procedure TdxPDFXForm.WriteData(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  Commands.Write(AHelper, ADictionary, Resources);
end;

function TdxPDFXForm.CreateEmptyResources: TdxPDFResources;
begin
  Resources := Repository.CreateResources;
  Repository.AddHoldObject(Resources);
  Result := Resources;
end;

function TdxPDFXForm.TryReleaseCircularReferencesAndFree: Boolean;
var
  AData: TBytes;
begin
  Reference;
  SetLength(AData, 0);
  ReplaceCommands(AData);
  Result := CanFree;
  Release;
end;

procedure TdxPDFXForm.CheckFormType(ADictionary: TdxPDFDictionary);
var
  AFormType: Integer;
begin
  AFormType := ADictionary.GetInteger(TdxPDFKeywords.FormType);
  if (TdxPDFUtils.IsIntegerValid(AFormType) and (AFormType <> 1)) then
    TdxPDFUtils.RaiseTestException;
end;

function TdxPDFXForm.GetActualStream: TdxPDFStream;
begin
  if Stream <> nil then
    Result := Stream
  else
    Result := FStreamRef;
end;

procedure TdxPDFXForm.SetMatrix(const AValue: TdxPDFTransformationMatrix);
begin
  FMatrix := AValue;
end;

procedure TdxPDFXForm.SetResources(const AValue: TdxPDFResources);
begin
  if AValue <> FResources then
  begin
    if FUseOwnResources then
      dxPDFChangeValue(AValue, TdxPDFReferencedObject(FResources))
    else
      FResources := AValue;
  end;
end;

{ TdxPDFCustomSoftMask }

class function TdxPDFCustomSoftMask.GetTypeName: string;
begin
  Result := TdxPDFKeywords.Mask;
end;

function TdxPDFCustomSoftMask.IsSame(AMask: TdxPDFCustomSoftMask): Boolean;
begin
  Result := False;
end;

procedure TdxPDFCustomSoftMask.CreateSubClasses;
begin
  inherited CreateSubClasses;
  TransparencyGroup := nil;
  TransparencyFunction := nil;
end;

procedure TdxPDFCustomSoftMask.DestroySubClasses;
begin
  TransparencyFunction := nil;
  TransparencyGroup := nil;
  inherited DestroySubClasses;
end;

procedure TdxPDFCustomSoftMask.DoRead(ADictionary: TdxPDFReaderDictionary);
var
  AObject: TdxPDFBase;
begin
  inherited DoRead(ADictionary);

  AObject := ADictionary.GetObject(TdxPDFKeywords.GroupType);
  if AObject is TdxPDFStream then
    AObject := Repository.CreateXObject(AObject as TdxPDFStream, TdxPDFXFormGroup.GetTypeName);
  if AObject is TdxPDFXFormGroup then
    TransparencyGroup := AObject as TdxPDFXFormGroup;

  if ADictionary.TryGetObject(TdxPDFKeywords.TransferFunction, AObject) then
    TransparencyFunction := TdxPDFCustomFunction.Parse(Repository, AObject)
  else
    TransparencyFunction := TdxPDFIdentityFunction.CreateEx(Repository);
end;

procedure TdxPDFCustomSoftMask.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  ADictionary.AddName(TdxPDFKeywords.TypeKey, TdxPDFKeywords.Mask);
  ADictionary.AddName(TdxPDFKeywords.MaskStyle, GetTypeName);
  if (TransparencyGroup <> nil) then
    ADictionary.AddReference(TdxPDFKeywords.GroupType, TransparencyGroup);
  if (TransparencyFunction <> nil) and not (TransparencyFunction is TdxPDFIdentityFunction) then
    ADictionary.AddReference(TdxPDFKeywords.TransferFunction, TransparencyFunction);
end;

procedure TdxPDFCustomSoftMask.SetTransparencyGroup(const AValue: TdxPDFXFormGroup);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FTransparencyGroup));
end;

procedure TdxPDFCustomSoftMask.SetTransparencyFunction(const AValue: TdxPDFObject);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FTransparencyFunction));
end;

{ TdxPDFLuminositySoftMask }

class function TdxPDFLuminositySoftMask.GetTypeName: string;
begin
  Result := 'Luminosity';
end;

procedure TdxPDFLuminositySoftMask.DoRead(ADictionary: TdxPDFReaderDictionary);
var
  AColorArray: TdxPDFArray;
begin
  inherited DoRead(ADictionary);
  AColorArray := ADictionary.GetArray(TdxPDFKeywords.BackdropColor);
  if (AColorArray <> nil) and (AColorArray.Count = TransparencyGroup.ColorSpace.ComponentCount) then
    FBackdropColor := TdxPDFColor.Create(AColorArray)
  else
    FBackdropColor := TdxPDFColor.Null;
end;

procedure TdxPDFLuminositySoftMask.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.Add(TdxPDFKeywords.BackdropColor, FBackdropColor);
end;

{ TdxPDFAlphaSoftMask }

class function TdxPDFAlphaSoftMask.GetTypeName: string;
begin
  Result := 'Alpha';
end;

{ TdxPDFEmptySoftMask }

class function TdxPDFEmptySoftMask.GetTypeName: string;
begin
  Result := 'None';
end;

function TdxPDFEmptySoftMask.IsSame(AMask: TdxPDFCustomSoftMask): Boolean;
begin
  Result := AMask = Self;
end;

function TdxPDFEmptySoftMask.Write(AHelper: TdxPDFWriterHelper): TdxPDFBase;
begin
  Result := TdxPDFName.Create(GetTypeName);
end;

{ TdxPDFTransparencyGroup }

class function TdxPDFTransparencyGroup.GetTypeName: string;
begin
  Result := TdxPDFKeywords.Group;
end;

procedure TdxPDFTransparencyGroup.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FColorSpace := nil;
end;

procedure TdxPDFTransparencyGroup.DestroySubClasses;
begin
  FreeAndNil(FColorSpace);
  inherited DestroySubClasses;
end;

procedure TdxPDFTransparencyGroup.DoRead(ADictionary: TdxPDFReaderDictionary);
var
  AObject: TdxPDFBase;
  AType, ASubtype: string;
begin
  inherited DoRead(ADictionary);
  AType := ADictionary.GetString(TdxPDFKeywords.TypeKey);
  ASubtype := ADictionary.GetString(SubtypeKey);
  if (AType <> '') and (AType <> TdxPDFKeywords.Group) or (ASubtype <> '') and (ASubtype <> TdxPDFKeywords.Transparency) then
    TdxPDFUtils.RaiseTestException;
  if ADictionary.TryGetObject(ColorSpaceKey, AObject) then
    FColorSpace := Repository.CreateColorSpace(AObject);
  FIsolated := ADictionary.GetBoolean(IsolatedKey);
  FKnockout := ADictionary.GetBoolean(KnockoutKey);
end;

procedure TdxPDFTransparencyGroup.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.AddName(TdxPDFKeywords.TypeKey, TdxPDFKeywords.Group);
  ADictionary.AddName(SubtypeKey, TdxPDFKeywords.Transparency);
  ADictionary.AddReference(ColorSpaceKey, ColorSpace);
  ADictionary.Add(IsolatedKey, FIsolated);
  ADictionary.Add(KnockoutKey, FKnockout);
end;

{ TdxPDFXFormGroup }

class function TdxPDFXFormGroup.GetTypeName: string;
begin
  Result := TdxPDFKeywords.Group;
end;

procedure TdxPDFXFormGroup.DestroySubClasses;
begin
  FreeAndNil(FGroup);
  inherited DestroySubClasses;
end;

procedure TdxPDFXFormGroup.DoDraw(const AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.DrawTransparencyGroup(Self);
end;

procedure TdxPDFXFormGroup.Read(ADictionary: TdxPDFReaderDictionary);
begin
  inherited Read(ADictionary);
  FGroup := Repository.CreateAndRead(TdxPDFTransparencyGroup, ADictionary, TdxPDFKeywords.Group) as TdxPDFTransparencyGroup;
end;

procedure TdxPDFXFormGroup.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.AddName(TdxPDFKeywords.SubType, TdxPDFXForm.GetTypeName);
  ADictionary.AddReference(TdxPDFKeywords.Group, FGroup);
end;

function TdxPDFXFormGroup.GetColorSpace: TdxPDFCustomColorSpace;
begin
  if FGroup <> nil then
    Result := FGroup.ColorSpace
  else
    Result := nil;
end;

{ TdxPDFDocumentImage }

class function TdxPDFDocumentImage.GetTypeName: string;
begin
  Result := 'Image';
end;

constructor TdxPDFDocumentImage.Create(const AImageData: TBytes; const ASize: TSize; ABitsPerComponent: Integer);
begin
  inherited Create(nil);
  Stream := TdxPDFStream.Create(AImageData);
  FSize := ASize;
  FBitsPerComponent := ABitsPerComponent;
end;

constructor TdxPDFDocumentImage.Create(const AImageData: TBytes; const ASize: TSize; ABitsPerComponent: Integer;
  ADictionary: TdxPDFDictionary);
begin
  Create(AImageData, ASize, ABitsPerComponent);
  ReadDecodeRanges(ADictionary);
  ReadIntent(ADictionary);
end;

function TdxPDFDocumentImage.GetTransformedData(const AParameters: TdxPDFImageParameters): TdxPDFScanlineTransformationResult;
var
  AComponentCount: Integer;
  AData: TBytes;
  AFilters: TdxPDFStreamFilters;
  ALastFilterIndex: Integer;
  AScanlineSource: IdxPDFImageScanlineSource;
  ATransformationResult: TdxPDFScanlineTransformationResult;
  I: Integer;
begin
  AFilters := Filters;
  if (AFilters = nil) then
    Exit(TdxPDFScanlineTransformationResult.Null);
  ALastFilterIndex := AFilters.Count - 1;
  if ALastFilterIndex >= 0 then
  begin
    AData := Stream.DecryptedData;
    for I := 0 to ALastFilterIndex - 1 do
      AData := AFilters[I].Decode(AData);
    AComponentCount := 1;
    if ColorSpace <> nil then
      AComponentCount := ColorSpace.ComponentCount;
    ATransformationResult := AFilters[ALastFilterIndex].CreateScanlineSource(Self, AComponentCount, AData);
    if FColorSpace = nil then
    begin
      Exit(
        TdxPDFScanlineTransformationResult.Create(
          GetInterpolatedScanlineSource(ATransformationResult.ScanlineSource, AParameters),
          ATransformationResult.PixelFormat));
    end;
    AScanlineSource := ATransformationResult.ScanlineSource;
  end
  else
    AScanlineSource := TdxPDFCommonImageScanlineSource.CreateImageScanlineSource(GetCompressedData, Self, FColorSpace.ComponentCount);

  Result := FColorSpace.Transform(Self, AScanlineSource, AParameters);
end;

function TdxPDFDocumentImage.IsMask: Boolean;
begin
  Result := FHasMask;
end;

procedure TdxPDFDocumentImage.AddListener(AListener: IdxPDFDocumentSharedObjectListener);
begin
  if FListeners.IndexOf(AListener) = -1 then
    FListeners.Add(AListener);
end;

procedure TdxPDFDocumentImage.Read(AStream: TdxPDFStream);
var
  ADictionary: TdxPDFReaderDictionary;
begin
  ADictionary := AStream.Dictionary as TdxPDFReaderDictionary;
  if ADictionary <> nil then
  begin
    Stream := AStream;
    DoRead(ADictionary);
  end;
end;

procedure TdxPDFDocumentImage.RemoveListener(AListener: IdxPDFDocumentSharedObjectListener);
begin
  FListeners.Remove(AListener);
end;

procedure TdxPDFDocumentImage.ReadColorKeyMask(AArray: TdxPDFArray);
var
  I, AIndex, AMin, AMax, AMaxMaskValue: Integer;
  AMaxSourceObject, AMinSourceObject: TdxPDFBase;
begin
  AMaxMaskValue := (1 shl FBitsPerComponent) - 1;
  AIndex := 0;
  SetLength(FColorKeyMask, 0);
  for I := 0 to FComponentCount - 1 do
  begin
    AMinSourceObject := AArray[AIndex];
    AMaxSourceObject := AArray[AIndex + 1];
    Inc(AIndex, 2);
    if (AMinSourceObject.ObjectType <> otInteger) or (AMaxSourceObject.ObjectType <> otInteger) then
      TdxPDFUtils.RaiseTestException;
    AMin := TdxPDFInteger(AMinSourceObject).Value;
    AMin := IfThen(AMin < 0, Integer(AMin = 0), AMin);
    AMax := TdxPDFInteger(AMaxSourceObject).Value;
    AMax := IfThen(AMax > AMaxMaskValue, AMaxMaskValue, AMax);
    TdxPDFUtils.AddRange(TdxPDFRange.Create(Min(AMin, AMax), Max(AMin, AMax)), FColorKeyMask);
  end;
end;

function TdxPDFDocumentImage.GetUncompressedData: TBytes;
begin
  if Filters.Count > 0 then
    Result := UncompressData(Filters)
  else
    Result := inherited GetUncompressedData;
end;

procedure TdxPDFDocumentImage.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FFilters := nil;
  FColorSpace := nil;
  FMask := nil;
  FSoftMask := nil;
  FListeners := TInterfaceList.Create;
end;

procedure TdxPDFDocumentImage.DestroySubClasses;
var
  I: Integer;
begin
  for I := 0 to FListeners.Count - 1 do
    (FListeners[I] as IdxPDFDocumentSharedObjectListener).DestroyHandler(Self);
  FreeAndNil(FListeners);
  ColorSpace := nil;
  Mask := nil;
  SoftMask := nil;
  FreeAndNil(FFilters);
  inherited DestroySubClasses;
end;

procedure TdxPDFDocumentImage.DoDraw(const AInterpreter: IdxPDFCommandInterpreter);
begin
  AInterpreter.DrawImage(Self)
end;

procedure TdxPDFDocumentImage.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  FBitsPerComponent := ADictionary.GetInteger(TdxPDFKeywords.BitsPerComponent);
  FSize.cx := ADictionary.GetInteger(TdxPDFKeywords.Width, 0);
  FSize.cy := ADictionary.GetInteger(TdxPDFKeywords.Height, 0);
  FID := ADictionary.GetString(TdxPDFKeywords.ID);
  FHasMask := ADictionary.GetBoolean(TdxPDFKeywords.ImageMask);
  ReadIntent(ADictionary);
  FNeedInterpolate := ADictionary.GetBoolean(TdxPDFKeywords.Interpolate);
  FStructParent := ADictionary.GetInteger(TdxPDFKeywords.StructParent);
  FSMaskInData := TdxPDFDocumentImageSMaskInDataType(ADictionary.GetInteger(TdxPDFKeywords.SMaskInData, 0));

  ReadColorSpace(ADictionary);
  ReadDecodeRanges(ADictionary);
  ReadMatte(ADictionary);
  CalculateComponentCount(ADictionary);
  ReadSoftMask(ADictionary);
  ReadMask(ADictionary);
end;

procedure TdxPDFDocumentImage.Initialize;
begin
  inherited Initialize;
  FGUID := TdxPDFUtils.GenerateGUID;
  FBitsPerComponent := 1;
end;

procedure TdxPDFDocumentImage.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);

  ADictionary.Add(TdxPDFKeywords.Height, Height);
  ADictionary.Add(TdxPDFKeywords.Width, Width);
  ADictionary.Add(TdxPDFKeywords.BitsPerComponent, FBitsPerComponent);

  if IsMask then
    ADictionary.Add(TdxPDFKeywords.ImageMask, True)
  else
  begin
    ADictionary.Add(TdxPDFKeywords.ColorSpace, ColorSpace);
    if FMask <> nil then
      ADictionary.AddReference(TdxPDFKeywords.Mask, FMask)
    else
      if Length(FColorKeyMask) > 0 then
        ADictionary.Add(TdxPDFKeywords.Mask, FColorKeyMask);
  end;

  ADictionary.Add(TdxPDFKeywords.Decode, FDecodeRanges);
  ADictionary.Add(TdxPDFKeywords.Matte, FMatte);
  ADictionary.AddReference(TdxPDFKeywords.SoftMask, SoftMask);
  ADictionary.Add(TdxPDFKeywords.Interpolate, FNeedInterpolate);
  WriteIntent(ADictionary);
  if FSMaskInData <> dtNone then
    ADictionary.Add(TdxPDFKeywords.SMaskInData, Ord(FSMaskInData));
end;

procedure TdxPDFDocumentImage.WriteAsInline(AWriter: TdxPDFWriter; AResources: TdxPDFResources;
  const AColorSpaceName: string);
var
  AActualColorSpaceName: string;
  AColorSpaceObject: TdxPDFBase;
  ADictionary: TDxPDFDictionary;
begin
  AWriter.WriteSpace;
  AWriter.WriteString(TdxPDFKeywords.InlineImageBegin, True);
  AWriter.WriteSpace;

  if ColorSpace <> nil then
  begin
    AWriter.WriteName(TdxPDFKeywords.ShortColorSpace);
    AWriter.WriteSpace;
    if AColorSpaceName <> '' then
    begin
      if not AResources.TryGetColorSpaceName(ColorSpace, AActualColorSpaceName) then
        AActualColorSpaceName := ColorSpace.GetShortTypeName;
      AColorSpaceObject := TdxPDFName.Create(ColorSpace.GetShortTypeName);
    end
    else
      AColorSpaceObject := TdxPDFWriterHelper.WriteInlineColorSpace(ColorSpace);
    TdxPDFBaseAccess(AColorSpaceObject).Write(AWriter);
    AColorSpaceObject.Free;
    AWriter.WriteSpace;
  end;

  ADictionary := TdxPDFDictionary.Create;
  try
    ADictionary.Add(TdxPDFKeywords.ShortWidth, Width);
    ADictionary.Add(TdxPDFKeywords.ShortHeight, Height);
    ADictionary.Add(TdxPDFKeywords.ShortBitsPerComponent, BitsPerComponent);
    ADictionary.Add(TdxPDFKeywords.ShortDecode, DecodeRanges);
    ADictionary.Add(TdxPDFKeywords.ShortImageMask, IsMask);
    WriteIntent(ADictionary);
    ADictionary.Add(TdxPDFKeywords.ShortInterpolate, FNeedInterpolate);
    WriteFilters(ADictionary, True);

    TdxPDFDictionaryAccess(ADictionary).WriteContent(AWriter);
  finally
    ADictionary.Free;
  end;

  AWriter.WriteSpace;
  AWriter.WriteString(TdxPDFKeywords.InlineImageData);
  AWriter.WriteSpace;
  AWriter.WriteBytes(GetData);
  AWriter.WriteString(TdxPDFKeywords.InlineImageEnd);
end;

procedure TdxPDFDocumentImage.WriteData(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  WriteFilters(ADictionary, False, AHelper); // before inherited
  inherited WriteData(AHelper, ADictionary);
end;

procedure TdxPDFDocumentImage.WriteIntent(ADictionary: TdxPDFDictionary);
begin
  if Intent.HasValue then
    ADictionary.AddName(TdxPDFKeywords.Intent, Intent);
end;

procedure TdxPDFDocumentImage.WriteFilters(
  ADictionary: TdxPDFDictionary; AUseShortNames: Boolean; AHelper: TdxPDFWriterHelper = nil);

  function GetNameKey: string;
  begin
    if AUseShortNames then
      Result := TdxPDFKeywords.ShortFilter
    else
      Result := TdxPDFKeywords.Filter;
  end;

  function GetParamsKey: string;
  begin
    if AUseShortNames then
      Result := TdxPDFKeywords.ShortDecodeParameters
    else
      Result := TdxPDFKeywords.DecodeParameters;
  end;

  function CreateDictionary: TdxPDFDictionary;
  begin
    if AHelper <> nil then
      Result := AHelper.CreateDictionary
    else
      Result := TdxPDFDictionary.Create;
  end;

var
  AFilter: TdxPDFCustomStreamFilter;
  AFilterParams: TdxPDFDictionary;
  ANames: TdxPDFArray;
  AParams: TdxPDFArray;
  I: Integer;
begin
  if (Filters = nil) or (Filters.Count = 0) then
    Exit;

  ANames := TdxPDFArray.Create;
  AParams := TdxPDFArray.Create;

  for I := 0 to Filters.Count - 1 do
  begin
    AFilter := Filters[I];
    AFilterParams := CreateDictionary;
    AFilter.Write(AFilterParams);
    AParams.Add(AFilterParams);
    if AUseShortNames then
      ANames.AddName(AFilter.GetShortName)
    else
      ANames.AddName(AFilter.GetName);
  end;

  if ANames.Count > 1 then
  begin
    ADictionary.Add(GetNameKey, ANames);
    ADictionary.Add(GetParamsKey, AParams);
  end
  else
  try
    if ANames.Count = 1 then
    begin
      ADictionary.Add(GetNameKey, ANames[0]);
      if TdxPDFDictionary(AParams[0]).Count > 0 then
        ADictionary.Add(GetParamsKey, AParams[0]);
    end;
  finally
    AParams.Free;
    ANames.Free;
  end;
end;

function TdxPDFDocumentImage.ApplyMask(
  const AMaskScanlineSource: IdxPDFImageScanlineSource;
  const AParameters: TdxPDFImageParameters;
  const AMatte: TDoubleDynArray): TdxPDFImageData;
var
  AActualMatte: TDoubleDynArray;
  AScanlineSource: IdxPDFImageScanlineSource;
  ATransformedData: TdxPDFScanlineTransformationResult;
  ATransparentSource: TdxPDFImageDataSource;
begin
  ATransformedData := GetTransformedData(AParameters);
  AScanlineSource := ATransformedData.ScanlineSource;
  if ATransformedData.PixelFormat = pfGray8bit then
    AScanlineSource := TdxPDFGrayToRGBImageScanlineSource.Create(AScanlineSource, AParameters.Size.cx);
  if (FColorSpace <> nil) and (Length(AMatte) > 0) then
    AActualMatte := FColorSpace.AlternateTransform(TdxPDFColor.Create(AMatte)).Components
  else
    AActualMatte := AMatte;

  if Length(AActualMatte) = AScanlineSource.ComponentCount then
  begin
    ATransparentSource := TdxPDFImageDataSource(TdxPDFTransparentMatteImageDataSource.Create(
      AScanlineSource, AMaskScanlineSource, AParameters.Size.cx, AActualMatte));
  end
  else
    ATransparentSource := TdxPDFTransparentImageDataSource.Create(AScanlineSource, AMaskScanlineSource, AParameters.Size.cx);

  Result := TdxPDFImageData.Create(ATransparentSource, AParameters.Size, AParameters.Size.cx * 4, pfArgb32bpp, nil);
end;

function TdxPDFDocumentImage.GetActualData(const AParameters: TdxPDFImageParameters; AInvertRGB: Boolean): TdxPDFImageData;
var
  ATransformationResult: TdxPDFScanlineTransformationResult;
  AComponentCount, ATemp, ARemain, AStride: Integer;
  I: Byte;
  AImageScanlineSource: IdxPDFImageScanlineSource;
  APalette: TdxAlphaColorDynArray;
  AImageDataSource: TdxPDFImageDataSource;
  ASize: TSize;
begin
  if SoftMask <> nil then
    Exit(ApplyMask(SoftMask.GetTransformedData(AParameters).ScanlineSource, AParameters, SoftMask.Matte));
  if HasValidStencilMask then
    Exit(ApplyMask(TdxPDFInvertedImageScanlineSource.Create(FMask.GetTransformedData(AParameters).ScanlineSource),
      AParameters, nil));
  ATransformationResult := GetTransformedData(AParameters);
  if ATransformationResult.IsNull then
    Exit(TdxPDFImageData.Create(nil, cxNullSize, 0, pfUnknown, nil));
  ASize := AParameters.Size;
  if ATransformationResult.ScanlineSource.HasAlpha then
  begin
    AImageScanlineSource := ATransformationResult.ScanlineSource;
    if ATransformationResult.PixelFormat = pfGray8bit then
      AImageScanlineSource := TdxPDFGrayToRGBImageScanlineSource.Create(AImageScanlineSource, ASize.cx);
    Exit(TdxPDFImageData.Create(TdxPDFColorKeyMaskedImageDataSource.Create(AImageScanlineSource, ASize.cx), ASize,
      ASize.cx * 4, pfArgb32bpp, nil));
  end;
  if ATransformationResult.PixelFormat = pfGray8bit then
  begin
    AComponentCount := 1;
    SetLength(APalette, 256);
    for I := 0 to 256 - 1 do
      APalette[I] := dxMakeAlphaColor(I, I, I);
  end
  else
  begin
    AComponentCount := 3;
    APalette := nil;
  end;
  ATemp := ASize.cx * AComponentCount;
  ARemain := ATemp mod 4;
  AStride := IfThen(ARemain > 0, ATemp + 4 - ARemain, ATemp);
  if AInvertRGB then
    AImageDataSource := TdxPDFBGRImageDataSource.Create(ATransformationResult.ScanlineSource, ASize.cx, AStride, AComponentCount)
  else
    AImageDataSource := TdxPDFRGBImageDataSource.Create(ATransformationResult.ScanlineSource, ASize.cx, AStride, AComponentCount);
  Result := TdxPDFImageData.Create(AImageDataSource, ASize, AStride, ATransformationResult.PixelFormat, APalette);
end;

function TdxPDFDocumentImage.GetActualSize(const AParameters: TdxPDFImageParameters): TdxPDFImageParameters;
var
  AActualSize, AMaskSize: TSize;
begin
  AActualSize.cx := Min(FSize.cx, AParameters.Size.cx);
  AActualSize.cy := Min(FSize.cy, AParameters.Size.cy);
  if cxSizeIsEqual(FSize, AActualSize) then
  begin
    if HasValidStencilMask then
      AMaskSize := FMask.Size
    else
      if SoftMask <> nil then
        AMaskSize := SoftMask.Size
      else
        AMaskSize := cxNullSize;
    if (AMaskSize.cx > FSize.cx) or (AMaskSize.cy > FSize.cy) then
      Exit(TdxPDFImageParameters.Create(AMaskSize, AParameters.ShouldInterpolate));
  end;
  if FSize.cx * FSize.cy <= 300 * 300 then
    Result := TdxPDFImageParameters.Create(FSize, AParameters.ShouldInterpolate)
  else
    Result := TdxPDFImageParameters.Create(AActualSize, AParameters.ShouldInterpolate);
end;

function TdxPDFDocumentImage.GetAsBitmap: Graphics.TBitmap;
var
  AImageData: TdxPDFImageData;
  ABitmap: Graphics.TBitmap;
begin
  AImageData := GetActualData(TdxPDFImageParameters.Create(Size, True), True);
  TdxPDFRenderingInterpreter.CreateBitmap(AImageData, IsMask,
    procedure(AHandle: GpBitmap)
    var
      ATempImage: TdxSmartImage;
    begin
      ATempImage := TdxSmartImage.Create;
      try
        ATempImage.Handle := AHandle;
        ABitmap := ATempImage.GetAsBitmap;
      finally
        ATempImage.Free;
      end;
    end);
  Result := ABitmap;
end;

function TdxPDFDocumentImage.GetFilters: TdxPDFStreamFilters;
begin
  if (FFilters = nil) and (Stream <> nil) then
    FFilters := dxPDFCreateFilterList(Stream.Dictionary);
  Result := FFilters;
end;

procedure TdxPDFDocumentImage.SetColorSpace(const AValue: TdxPDFCustomColorSpace);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FColorSpace));
end;

procedure TdxPDFDocumentImage.SetFilters(const AValue: TdxPDFStreamFilters);
begin
  if FFilters <> AValue then
  begin
    FreeAndNil(FFilters);
    FFilters := AValue;
  end;
end;

procedure TdxPDFDocumentImage.SetHasMask(const AValue: Boolean);
begin
  if FHasMask <> AValue then
  begin
    FHasMask := AValue;
    if HasMask then
    begin
      if FColorSpace = nil then
        ColorSpace := TdxPDFGrayDeviceColorSpace.Create
      else
        if not (ColorSpace is TdxPDFCustomDeviceColorSpace) then
          TdxPDFUtils.RaiseTestException('Create inline image');
    end
    else
      if FColorSpace = nil then
        TdxPDFUtils.RaiseTestException('Create inline image');
  end;
end;

procedure TdxPDFDocumentImage.SetMask(const AValue: TdxPDFDocumentImage);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FMask));
end;

procedure TdxPDFDocumentImage.SetSoftMask(const AValue: TdxPDFDocumentImage);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FSoftMask));
end;

function TdxPDFDocumentImage.GetCompressedData: TBytes;
begin
  Result := Stream.Data;
end;

function TdxPDFDocumentImage.GetStreamData: TBytes;
begin
  Result := GetData;
end;

procedure TdxPDFDocumentImage.CalculateComponentCount(ADictionary: TdxPDFDictionary);
begin
  if not HasMask then
  begin
    if not ADictionary.Contains(TdxPDFKeywords.ColorSpace) or (ColorSpace = nil) or not TdxPDFUtils.IsIntegerValid(FBitsPerComponent) then
      FComponentCount := 0
    else
      FComponentCount := ColorSpace.ComponentCount;
  end
  else
    FComponentCount := 1;
end;

procedure TdxPDFDocumentImage.ReadColorSpace(ADictionary: TdxPDFReaderDictionary);
var
  AObject: TdxPDFBase;
begin
  if HasMask then
  begin
    FBitsPerComponent := IfThen(TdxPDFUtils.IsIntegerValid(FBitsPerComponent), FBitsPerComponent, 1);
    if ADictionary.TryGetObject(TdxPDFKeywords.ColorSpace, AObject) then
    begin
      ColorSpace := Repository.CreateColorSpace(AObject);
      if not (ColorSpace is TdxPDFGrayDeviceColorSpace) then
        TdxPDFUtils.RaiseTestException('TdxPDFDocumentImage.ReadColorSpace');
    end
    else
      ColorSpace := TdxPDFGrayDeviceColorSpace.Create;
  end
  else
    if ADictionary.TryGetObject(TdxPDFKeywords.ColorSpace, AObject) then
      ColorSpace := Repository.CreateColorSpace(AObject);
end;

procedure TdxPDFDocumentImage.ReadDecodeRanges(ADictionary: TdxPDFDictionary);
var
  AArray: TdxPDFArray;
  AComponentCount, I, AIndex: Integer;
begin
  SetLength(FDecodeRanges, 0);
  AArray := ADictionary.GetArray(TdxPDFKeywords.Decode, TdxPDFKeywords.ShortDecode);
  if AArray = nil then
  begin
    if FColorSpace <> nil then
      FDecodeRanges := FColorSpace.CreateDefaultDecodeArray(FBitsPerComponent)
    else
      TdxPDFUtils.AddRange(TdxPDFRange.Create(0, 1), FDecodeRanges);
  end
  else
  begin
    if FColorSpace <> nil then
      AComponentCount := FColorSpace.ComponentCount
    else
      AComponentCount := 1;

    if AArray.Count < AComponentCount * 2 then
      TdxPDFUtils.RaiseTestException;

    AIndex := 0;
    for I := 0 to AComponentCount - 1 do
    begin
      TdxPDFUtils.AddRange(
        TdxPDFRange.Create(
          TdxPDFUtils.ConvertToDouble(AArray[AIndex]),
          TdxPDFUtils.ConvertToDouble(AArray[AIndex + 1])),
        FDecodeRanges);
      Inc(AIndex, 2);
    end;
  end;
end;

procedure TdxPDFDocumentImage.ReadIntent(ADictionary: TdxPDFDictionary);
begin
  if ADictionary.Contains(TdxPDFKeywords.Intent) then
    FIntent := ADictionary.GetRenderingIntent(TdxPDFKeywords.Intent);
end;

procedure TdxPDFDocumentImage.ReadMask(ADictionary: TdxPDFReaderDictionary);
var
  AArray: TdxPDFArray;
  ARawObject: TdxPDFBase;
begin
  if not HasMask and ADictionary.TryGetObject(TdxPDFKeywords.Mask, ARawObject) then
    if ARawObject.ObjectType = otArray then
    begin
      AArray := ARawObject as TdxPDFArray;
      if (FBitsPerComponent = 0) or (FComponentCount = 0) or (AArray.Count <> FComponentCount * 2) then
        TdxPDFUtils.RaiseTestException;
      ReadColorKeyMask(AArray);
    end
    else
    begin
      ARawObject := Repository.ResolveReference(ARawObject);
      if not (ARawObject is TdxPDFNull) then
        Mask := Repository.CreateImage(ARawObject as TdxPDFStream);
    end;
end;

procedure TdxPDFDocumentImage.ReadMatte(ADictionary: TdxPDFDictionary);
var
  I: Integer;
  AArray: TdxPDFArray;
begin
  AArray := ADictionary.GetArray(TdxPDFKeywords.Matte);
  if not HasMask and (AArray <> nil) then
  begin
    SetLength(FMatte, AArray.Count);
    for I := 0 to AArray.Count - 1 do
      FMatte[I] := TdxPDFUtils.ConvertToDouble(AArray[I]);
  end;
end;

procedure TdxPDFDocumentImage.ReadSoftMask(ADictionary: TdxPDFReaderDictionary);
var
  ASoftMaskObject: TdxPDFBase;
  AStream: TdxPDFStream;
begin
  if ADictionary.TryGetObject(TdxPDFKeywords.SoftMask, ASoftMaskObject) then
  begin
    case ASoftMaskObject.ObjectType of
      otIndirectReference:
        AStream := Repository.GetStream((ASoftMaskObject as TdxPDFReference).Number);
      otStream:
        AStream := ASoftMaskObject as TdxPDFStream;
    else
      AStream := nil;
    end;
    if AStream <> nil then
    begin
      SoftMask := Repository.CreateImage(AStream);
      if (SoftMask = nil) or (FComponentCount = 0) or (SoftMask.ColorSpace = nil) or not
        (SoftMask.ColorSpace is TdxPDFGrayDeviceColorSpace) or (SoftMask.Matte <> nil) and
        (Length(SoftMask.Matte) <> FComponentCount) then
        TdxPDFUtils.RaiseTestException(ClassName + ': Error reading soft mask');
    end;
  end;
end;

function TdxPDFDocumentImage.HasValidStencilMask: Boolean;
begin
   Result := (FMask <> nil) and (FMask.BitsPerComponent = 1) and ((FMask.ColorSpace = nil) or
     (FMask.ColorSpace.ComponentCount = 1));
end;

function TdxPDFDocumentImage.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := S_OK
  else
    Result := E_NOINTERFACE;
end;

function TdxPDFDocumentImage._AddRef: Integer;
begin
  Result := -1;
end;

function TdxPDFDocumentImage._Release: Integer;
begin
  Result := -1;
end;

function TdxPDFDocumentImage.GetBitsPerComponent: Integer;
begin
  Result := FBitsPerComponent;
end;

function TdxPDFDocumentImage.GetColorKeyMask: TdxPDFRanges;
begin
  Result := FColorKeyMask;
end;

function TdxPDFDocumentImage.GetColorSpaceComponentCount: Integer;
begin
  if ColorSpace <> nil then
    Result := ColorSpace.ComponentCount
  else
    Result := 0;
end;
function TdxPDFDocumentImage.GetDecodeRanges: TdxPDFRanges;
begin
  Result := FDecodeRanges;
end;

function TdxPDFDocumentImage.GetInterpolatedScanlineSource(const AData: IdxPDFImageScanlineSource;
  const AParameters: TdxPDFImageParameters): IdxPDFImageScanlineSource;
begin
  if not cxSizeIsEqual(Size, AParameters.Size) then
    Result := dxPDFImageScanlineSourceFactory.CreateInterpolator(AData,
      AParameters.Size.cx, AParameters.Size.cy, Size.cx, Size.cy, AParameters.ShouldInterpolate)
  else
    Result := AData;
end;

function TdxPDFDocumentImage.GetHeight: Integer;
begin
  Result := FSize.cy;
end;

function TdxPDFDocumentImage.GetWidth: Integer;
begin
  Result := FSize.cx;
end;

function TdxPDFDocumentImage.HasSMaskInData: Boolean;
begin
  Result := FSMaskInData <> dtNone;
end;

{ TdxPDFCustomEncoding }

function TdxPDFCustomEncoding.Write(AHelper: TdxPDFWriterHelper): TdxPDFBase;
var
  AShortEncodingName: string;
begin
  if UseShortWrite then
  begin
    AShortEncodingName := GetShortName;
    if AShortEncodingName <> '' then
      Result := TdxPDFName.Create(AShortEncodingName)
    else
      Result := nil;
  end
  else
    Result := inherited Write(AHelper);
end;

procedure TdxPDFCustomEncoding.Initialize;
begin
  inherited Initialize;
  FFontFileEncoding := GetFontFileEncoding;
end;

function TdxPDFCustomEncoding.GetFontFileEncoding: TdxFontFileCustomEncoding;
begin
  Result := dxgPDFEmptyEncoding;
end;

function TdxPDFCustomEncoding.GetShortName: string;
begin
  Result := GetFontFileEncoding.GetName;
end;

function TdxPDFCustomEncoding.UseShortWrite: Boolean;
begin
  Result := False;
end;

function TdxPDFCustomEncoding.IsVertical: Boolean;
begin
  Result := False;
end;

{ TdxPDFCustomFontDescriptor }

class function TdxPDFCustomFontDescriptor.GetTypeName: string;
begin
  Result := TdxPDFKeywords.FontDescriptor;
end;

constructor TdxPDFCustomFontDescriptor.Create(AFont: TdxPDFCustomFont);
begin
  inherited Create(AFont);
end;

constructor TdxPDFCustomFontDescriptor.Create(const ADescriptorData: TdxPDFFontDescriptorData);
begin
  inherited Create;
  FAscent := Round(ADescriptorData.Ascent);
  FCapHeight := 500;
  FDescent := Round(-ADescriptorData.Descent);
  FFlags := ADescriptorData.Flags;
  FFontStretch := fsNormal;
  FFontWeight := IfThen(ADescriptorData.Bold, TdxPDFGDIFontSubstitutionHelper.BoldWeight, GetNormalWeight);
  FItalicAngle := ADescriptorData.ItalicAngle;
  FFontBBox := TdxPDFRectangle.Create(
    ADescriptorData.BBox.Left, ADescriptorData.BBox.Top,
    ADescriptorData.BBox.Right, ADescriptorData.BBox.Bottom);
end;

class function TdxPDFCustomFontDescriptor.GetNormalWeight: Integer;
begin
  Result := TdxPDFGDIFontSubstitutionHelper.NormalWeight;
end;

procedure TdxPDFCustomFontDescriptor.DoRead(ADictionary: TdxPDFReaderDictionary);
var
  AFont: TdxPDFCustomFont;
  AStream: TdxPDFStream;
begin
  FHasData := True;
  inherited DoRead(ADictionary);
  ReadFontStretch(ADictionary);
  FAscent := Abs(ADictionary.GetDouble(TdxPDFKeywords.FontDescriptorAscent, 0));
  FDescent := -Abs(ADictionary.GetDouble(TdxPDFKeywords.FontDescriptorDescent, 0));
  FAvgWidth := ADictionary.GetDouble(TdxPDFKeywords.FontDescriptorAvgWidth, 0);
  FCapHeight := ADictionary.GetSmallInt(TdxPDFKeywords.FontDescriptorCapHeight, 0);
  FCharSet := ADictionary.GetString(TdxPDFKeywords.FontDescriptorCharSet);
  FFlags := ADictionary.GetInteger(TdxPDFKeywords.FontDescriptorFlags, 0);
  FFontBBox := ADictionary.GetRectangleEx(TdxPDFKeywords.FontDescriptorBBox);
  FFontFamily := ADictionary.GetString(TdxPDFKeywords.FontDescriptorFamily);
  FFontName := ADictionary.GetString(TdxPDFKeywords.FontName);
  FItalicAngle := ADictionary.GetDouble(TdxPDFKeywords.FontDescriptorItalicAngle, 0);
  FLeading := ADictionary.GetDouble(TdxPDFKeywords.FontDescriptorLeading, 0);
  FMaxWidth := ADictionary.GetDouble(TdxPDFKeywords.FontDescriptorMaxWidth, 0);
  FMissingWidth := ADictionary.GetDouble(TdxPDFKeywords.FontDescriptorMissingWidth, 0);
  FStemH := ADictionary.GetDouble(TdxPDFKeywords.FontDescriptorStemH, 0);
  FStemV := ADictionary.GetDouble(TdxPDFKeywords.FontDescriptorStemV, 0);
  FXHeight := ADictionary.GetSmallInt(TdxPDFKeywords.FontDescriptorXHeight, 0);
  ReadFontWeight(ADictionary);

  AFont := Font;
  if FontName = '' then
    FontName := AFont.BaseFont;
  if FontWeight = 0 then
    FontWeight := 400;
  if Ascent < 0 then
    Ascent := -Ascent;
  if Descent > 0 then
    Descent := -Descent;
  if ADictionary.TryGetStream(TdxPDFKeywords.FontDescriptorCIDSet, AStream) then
    FCIDSetData := AStream.UncompressedData;
end;

procedure TdxPDFCustomFontDescriptor.Initialize;
begin
  inherited Initialize;
  FFontStretch := fsNormal;
  FFontWeight := GetNormalWeight;
end;

procedure TdxPDFCustomFontDescriptor.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.AddName(TdxPDFKeywords.FontName, FontName, False);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorCharSet, FCharSet);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorAvgWidth, AvgWidth, 0);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFlags, FFlags);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFamily, FFontFamily);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorItalicAngle, ItalicAngle);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorLeading, FLeading, 0);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorMaxWidth, MaxWidth, 0);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorMissingWidth, MissingWidth, 0);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemH, FStemH, 0);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorXHeight, XHeight, 0);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorWeight, FFontWeight, GetNormalWeight);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorBBox, FFontBBox, False);

  if FFontStretch <> fsNormal then
    ADictionary.AddName(TdxPDFKeywords.FontStretch, TdxFontStretchToStringMap[FFontStretch]);

  if Font.HasSizeAttributes then
  begin
    ADictionary.Add(TdxPDFKeywords.FontDescriptorAscent, Ascent);
    ADictionary.Add(TdxPDFKeywords.FontDescriptorDescent, Descent);
    ADictionary.Add(TdxPDFKeywords.FontDescriptorCapHeight, CapHeight);
    ADictionary.Add(TdxPDFKeywords.FontDescriptorStemV, FStemV);
  end;
  ADictionary.AddReference(TdxPDFKeywords.FontDescriptorCIDSet, FCIDSetData);
  WriteFontFile(AHelper, ADictionary);
end;

procedure TdxPDFCustomFontDescriptor.WriteFontFile(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  // do nothing
end;

function TdxPDFCustomFontDescriptor.GetOpenTypeFontFileData(
  ADictionary: TdxPDFReaderDictionary; ASuppressException: Boolean): TBytes;
var
  AStream: TdxPDFStream;
begin
  SetLength(Result, 0);
  AStream := GetStream(TdxPDFKeywords.FontFile3, ADictionary);
  if AStream = nil then
    Exit(nil);
  if AStream.Dictionary.GetString(TdxPDFKeywords.Subtype) = TdxPDFKeywords.OpenTypeFont then
    Result := AStream.UncompressedData
  else
    if not ASuppressException then
      TdxPDFUtils.RaiseTestException('TdxPDFType1Font.ReadOpenTypeFontFileData');
end;

function TdxPDFCustomFontDescriptor.GetStream(const AKey: string; ADictionary: TdxPDFReaderDictionary): TdxPDFStream;
var
  AObject: TdxPDFBase;
begin
  Result := nil;
  AObject := ADictionary.GetObject(AKey);
  if AObject <> nil then
    case AObject.ObjectType of
      otStream:
        Result := TdxPDFStream(AObject);
      otIndirectReference:
        Result := Repository.GetStream(AObject.Number);
    end;
end;

function TdxPDFCustomFontDescriptor.WriteOpenTypeFontData(
  AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary; const AData: TBytes): Boolean;
var
  AFontDictionary: TdxPDFWriterDictionary;
begin
  Result := Length(AData) > 0;
  if Result then
  begin
    AFontDictionary := AHelper.CreateDictionary;
    AFontDictionary.AddName(TdxPDFKeywords.Subtype, TdxPDFKeywords.OpenTypeFont);
    AFontDictionary.SetStreamData(AData);
    ADictionary.AddReference(TdxPDFKeywords.FontFile3, AFontDictionary);
  end;
end;

function TdxPDFCustomFontDescriptor.GetActualAscent: Double;
begin
  if IsFontMetricsInvalid then
    Result := Max(0, FFontBBox.Top)
  else
    Result := FAscent;
end;

function TdxPDFCustomFontDescriptor.GetActualDescent: Double;
begin
  if IsFontMetricsInvalid then
    Result := Math.Min(0, FFontBBox.Bottom)
  else
    Result := FDescent;
end;

function TdxPDFCustomFontDescriptor.GetFont: TdxPDFCustomFont;
begin
  Result := Parent as TdxPDFCustomFont;
end;

function TdxPDFCustomFontDescriptor.GetFontBBox: TdxRectF;
begin
  Result := FFontBBox.ToRectF;
end;

function TdxPDFCustomFontDescriptor.GetHeight: Double;
var
  AHeight: Double;
begin
  if not FFontBBox.IsNull then
  begin
    AHeight := FFontBBox.Height;
    if AHeight <> 0 then
      Exit(AHeight);
  end;
  Result := FAscent - FDescent;
end;

function TdxPDFCustomFontDescriptor.IsFontMetricsInvalid: Boolean;
begin
  Result := ((FAscent = 0) or (FDescent >= 0)) and not FFontBBox.IsNull;
end;

procedure TdxPDFCustomFontDescriptor.ReadFontStretch(ADictionary: TdxPDFDictionary);
var
  I: TdxFontFileStretch;
  AFontStretch: string;
begin
  FFontStretch := fsNormal;
  AFontStretch := ADictionary.GetString(TdxPDFKeywords.FontStretch);
  if AFontStretch <> '' then
    for I := Low(TdxFontFileStretch) to High(TdxFontFileStretch) do
      if TdxFontStretchToStringMap[I] = AFontStretch then
      begin
        FFontStretch := I;
        Break;
      end;
end;

procedure TdxPDFCustomFontDescriptor.ReadFontWeight(ADictionary: TdxPDFDictionary);
var
  AObject: TdxPDFBase;
  AName: string;
begin
  AObject := ADictionary.GetObject(TdxPDFKeywords.FontDescriptorWeight);
  if AObject <> nil then
    case AObject.ObjectType of
      otInteger:
        FFontWeight := TdxPDFInteger(AObject).Value;
      otName, otString:
        begin
          AName := TdxPDFString(AObject).Value;
          if AName = TdxPDFKeywords.Italic then
            FFlags := Integer(FFlags) or Integer(TdxFontFileFlags.ffItalic)
          else
            if AName = TdxPDFKeywords.Bold then
              FFontWeight := TdxPDFGDIFontSubstitutionHelper.BoldWeight;
        end;
    end;
end;

{ TdxPDFCIDSystemInfo }

class function TdxPDFCIDSystemInfo.GetTypeName: string;
begin
  Result := TdxPDFKeywords.CIDSystemInfo;
end;

procedure TdxPDFCIDSystemInfo.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  FRegistry := ADictionary.GetString(TdxPDFKeywords.Registry, FRegistry);
  FOrdering := ADictionary.GetString(TdxPDFKeywords.Ordering, FOrdering);
  FSupplement := ADictionary.GetInteger(TdxPDFKeywords.Supplement, FSupplement);
end;

procedure TdxPDFCIDSystemInfo.Initialize;
begin
  inherited Initialize;
  FRegistry := 'Adobe';
  FOrdering := TdxPDfKeywords.Identity;
end;

procedure TdxPDFCIDSystemInfo.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  ADictionary.Add(TdxPDFKeywords.Registry, Registry);
  ADictionary.Add(TdxPDFKeywords.Ordering, Ordering);
  ADictionary.Add(TdxPDFKeywords.Supplement, Supplement);
end;

{ TdxPDFCustomFont }

procedure TdxPDFCustomFont.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FFontDescriptor := GetFontDescriptorClass.Create(Self);
  FListeners := TInterfaceList.Create;
end;

procedure TdxPDFCustomFont.DestroySubClasses;
var
  I: Integer;
begin
  for I := 0 to FListeners.Count - 1 do
    (FListeners[I] as IdxPDFDocumentSharedObjectListener).DestroyHandler(Self);
  FreeAndNil(FListeners);
  FreeAndNil(FCMap);
  FreeAndNil(FToUnicode);
  SetEncoding(nil);
  SetFontDescriptor(nil);
  FreeAndNil(FFontProgramFacade);
  inherited DestroySubClasses;
end;

procedure TdxPDFCustomFont.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  FBaseFont := ADictionary.GetString(TdxPDFKeywords.BaseFont);
  ReadFontName;
  ReadEncoding(ADictionary.GetObject(TdxPDFKeywords.Encoding));
  ReadWidths(GetFontDictionary(ADictionary));
  ReadToUnicode(ADictionary);
  ReadFontDescriptor(GetFontDescriptorDictionary(ADictionary));
end;

procedure TdxPDFCustomFont.Initialize;
begin
  inherited Initialize;
  FUniqueName := TdxPDFUtils.GenerateGUID;
  FMetrics := TdxPDFFontMetricsMetadata.Create;
end;

procedure TdxPDFCustomFont.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.AddName(TdxPDFKeywords.Subtype, GetSubTypeName);
  ADictionary.AddName(TdxPDFKeywords.BaseFont, FBaseFont, False);
  ADictionary.Add(TdxPDFKeywords.Encoding, Encoding);
  if NeedWriteFontDescriptor then
    ADictionary.AddReference(TdxPDFKeywords.FontDescriptor, FontDescriptor);
  if FToUnicode <> nil then
    ADictionary.AddReference(TdxPDFKeywords.ToUnicode, FToUnicode.Data);
end;

class function TdxPDFCustomFont.GetSubTypeName: string;
begin
  Result := '';
end;

class function TdxPDFCustomFont.GetTypeName: string;
begin
  Result := TdxPDFKeywords.Font;
end;

function TdxPDFCustomFont.IsVertical: Boolean;
begin
  if Encoding <> nil then
    Result := Encoding.IsVertical
  else
    Result := False;
end;

function TdxPDFCustomFont.GetFontDictionary(ADictionary: TdxPDFReaderDictionary): TdxPDFReaderDictionary;
begin
  Result := ADictionary;
end;

function TdxPDFCustomFont.GetFontDescriptorDictionary(ADictionary: TdxPDFReaderDictionary): TdxPDFReaderDictionary;
begin
  Result := ADictionary.GetDictionary(TdxPDFKeywords.FontDescriptor);
end;

function TdxPDFCustomFont.CreateFontProgramFacade: TObject;
begin
  Result := nil;
end;

function TdxPDFCustomFont.CreateToUnicode(const AData: TBytes): TdxPDFToUnicodeMap;
begin
  Result := TdxPDFToUnicodeMap.Create(AData);
end;

function TdxPDFCustomFont.GetLineSpacingForMetrics: Double;
begin
  Result := 0;
end;

function TdxPDFCustomFont.CreateValidatedMetrics: TdxPDFFontMetricsMetadata;
var
  AAscent, ADescent: Double;
  AFontProgramFacade: TdxPDFFontProgramFacade;
begin
  AAscent := 0;
  ADescent := 0;
  AFontProgramFacade := FontProgramFacade as TdxPDFFontProgramFacade;
  if (FontDescriptor <> nil) and TdxPDFUtils.IsDoubleValid(AFontProgramFacade.Top) and
    TdxPDFUtils.IsDoubleValid(AFontProgramFacade.Bottom) then
  begin
    AAscent := AFontProgramFacade.Top;
    ADescent := AFontProgramFacade.Bottom;
  end;
  if (FontDescriptor <> nil) and ((AAscent = 0) or (ADescent = 0)) then
  begin
    AAscent := FontDescriptor.Ascent;
    ADescent := FontDescriptor.Descent;
    if AAscent - ADescent > 2048 then
    begin
      AAscent := AAscent / 2048.0 * 1000;
      ADescent := ADescent / 2048.0 * 1000;
    end;
  end;
  if not AFontProgramFacade.FontBBox.IsNull and ((AAscent = 0) or (ADescent = 0)) then
  begin
    AAscent := AFontProgramFacade.FontBBox.Top;
    ADescent := AFontProgramFacade.FontBBox.Bottom;
  end;
  if (FontDescriptor <> nil) and ((AAscent = 0) or (ADescent = 0)) then
  begin
    AAscent := FontDescriptor.Ascent;
    ADescent := FontDescriptor.Descent;
  end;
  Result := TdxPDFFontMetricsMetadata.Create(AAscent, ADescent, 1000, GetLineSpacingForMetrics);
end;

function TdxPDFCustomFont.GetFontDescriptorClass: TdxPDFCustomFontDescriptorClass;
begin
  Result := TdxPDFCustomFontDescriptor;
end;

function TdxPDFCustomFont.GetHeightFactor: Double;
begin
  Result := GetWidthFactor;
end;

function TdxPDFCustomFont.GetWidthFactor: Double;
begin
  Result := 0.001;
end;

function TdxPDFCustomFont.HasSizeAttributes: Boolean;
begin
  Result := True;
end;

function TdxPDFCustomFont.NeedWriteFontDescriptor: Boolean;
begin
  Result := (FontDescriptor <> nil) and FontDescriptor.HasData;
end;

procedure TdxPDFCustomFont.DoReadWidths(ADictionary: TdxPDFReaderDictionary);
begin
  // do nothing
end;

procedure TdxPDFCustomFont.ReadEncoding(ASourceObject: TdxPDFBase);
begin
  SetEncoding(nil);
end;

procedure TdxPDFCustomFont.ReadFontDescriptor(ADictionary: TdxPDFReaderDictionary);
begin
  if ADictionary <> nil then
    FontDescriptor.Read(ADictionary);
end;

procedure TdxPDFCustomFont.ReadToUnicode(ADictionary: TdxPDFReaderDictionary);

  procedure InternalRead(AStream: TdxPDFStream);
  begin
    FToUnicode := CreateToUnicode(AStream.UncompressedData);
  end;

var
  AObject: TdxPDFBase;
begin
  AObject := ADictionary.GetObject(TdxPDFKeywords.ToUnicode);
  if (AObject <> nil) and (AObject.ObjectType <> otName) then
    case AObject.ObjectType of
      otStream:
        InternalRead(TdxPDFStream(AObject));
      otIndirectReference:
        InternalRead(Repository.GetStream(AObject.Number));
    end;
end;

procedure TdxPDFCustomFont.ReadWidths(ADictionary: TdxPDFReaderDictionary);

  function GetAvgGlyphWidth: SmallInt;
  var
    ASum, AWidth: Double;
    ACount: Integer;
  begin
    ASum := 0.0;
    ACount := 0;
    for AWidth in FWidths do
      if AWidth <> 0 then
      begin
        ASum := ASum + AWidth;
        Inc(ACount);
      end;
    if ACount <> 0 then
      Result := Ceil(ASum / ACount)
    else
      Result := 0;
  end;

begin
  DoReadWidths(ADictionary);
  FAvgGlyphWidth := GetAvgGlyphWidth;
end;

procedure TdxPDFCustomFont.AddListener(AListener: IdxPDFDocumentSharedObjectListener);
begin
  if FListeners.IndexOf(AListener) = -1 then
    FListeners.Add(AListener);
end;

procedure TdxPDFCustomFont.RemoveListener(AListener: IdxPDFDocumentSharedObjectListener);
begin
  FListeners.Remove(AListener);
end;

function TdxPDFCustomFont.GetBoldWeight: Integer;
begin
  Result := TdxPDFGDIFontSubstitutionHelper.BoldWeight;
end;

function TdxPDFCustomFont.GetCMap: TdxPDFCharacterMapping;
begin
  if (FCMap = nil) and (FToUnicode <> nil) then
    try
      FCMap := Repository.CreateCharacterMapping(FToUnicode.Data);
    except
    end;
  Result := FCMap;
end;

function TdxPDFCustomFont.GetItalic: Boolean;
begin
  Result := (FontDescriptor <> nil) and (FontDescriptor.ItalicAngle <> 0);
end;

function TdxPDFCustomFont.GetFontBBox: TdxRectF;
begin
  Result := FFontDescriptor.FontBBox;
end;

function TdxPDFCustomFont.GetFontProgramFacade: TObject;
begin
  if FFontProgramFacade = nil then
    RecreateFontProgramFacade;
  Result := FFontProgramFacade;
end;

function TdxPDFCustomFont.GetForceBold: Boolean;
begin
  Result := (FontDescriptor <> nil) and HasFlag(ffForceBold);
end;

function TdxPDFCustomFont.GetMaxGlyphWidth: Double;
begin
  if Length(FWidths) > 0 then
    Result := MaxValue(FWidths)
  else
    Result := 0;
end;

function TdxPDFCustomFont.GetMetrics: TdxPDFFontMetricsMetadata;
begin
  if FMetrics.IsNull then
    FMetrics := CreateValidatedMetrics;
  Result := FMetrics;
end;

function TdxPDFCustomFont.GetPitchAndFamily: Byte;
begin
  Result := VARIABLE_PITCH;
  if FontDescriptor <> nil then
    if HasFlag(ffFixedPitch) then
      Result := FIXED_PITCH;
  if (Integer(FontDescriptor.Flags) and Integer(ffSerif)) > 0 then
    Result := Result or FF_ROMAN;
  if (Integer(FontDescriptor.Flags) and Integer(ffScript)) > 0 then
    Result := Result or FF_SCRIPT;
end;

function TdxPDFCustomFont.GetShouldUseEmbeddedFontEncoding: Boolean;
begin
  Result := (FEncoding <> nil) and FEncoding.ShouldUseEmbeddedFontEncoding;
end;

function TdxPDFCustomFont.GetSubsetNameLength: Integer;
begin
  Result := 6;
end;

function TdxPDFCustomFont.GetSubsetPrefixLength: Integer;
begin
  Result := GetSubsetNameLength + 1;
end;

function TdxPDFCustomFont.GetSymbolic: Boolean;
begin
  Result := HasFlag(ffSymbolic);
end;

function TdxPDFCustomFont.GetWeight: Integer;
begin
  if FontDescriptor = nil then
    Result := TdxPDFCustomFontDescriptor.GetNormalWeight
  else
    if ForceBold then
      Result := TdxPDFGDIFontSubstitutionHelper.BoldWeight
    else
      Result := FontDescriptor.FontWeight;
end;

procedure TdxPDFCustomFont.SetCMap(const AValue: TdxPDFCharacterMapping);
begin
  if FCMap <> nil then
    FreeAndNil(FCMap);
  FCMap := AValue;
  FreeAndNil(FToUnicode);
  FToUnicode := CreateToUnicode(FCMap.Data);
end;

function TdxPDFCustomFont.HasFlag(AFlag: TdxFontFileFlags): Boolean;
begin
  Result := (FontDescriptor <> nil) and ((Integer(FontDescriptor.Flags) and Integer(AFlag)) = Integer(AFlag));
end;

procedure TdxPDFCustomFont.SetEncoding(const AValue: TdxPDFCustomEncoding);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FEncoding));
end;

procedure TdxPDFCustomFont.SetFontDescriptor(const AValue: TdxPDFCustomFontDescriptor);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FFontDescriptor));
end;

procedure TdxPDFCustomFont.ReadFontName;
var
  I, ASubsetPrefixLength, ASubsetNameLength: Integer;
begin
  ASubsetPrefixLength := GetSubsetPrefixLength;
  ASubsetNameLength := GetSubsetNameLength;
  if (Length(BaseFont) >= ASubsetPrefixLength) and (BaseFont[ASubsetNameLength + 1] = '+') then
  begin
    FSubsetName := Copy(BaseFont, 1, ASubsetNameLength);
    for I := 1 to Length(FSubsetName) do
      if FSubsetName[I] <> UpperCase(FSubsetName[I]) then
      begin
        FSubsetName := '';
        Break;
      end;
  end;
  if FSubsetName = '' then
    FName := BaseFont
  else
    FName := Copy(BaseFont, ASubsetPrefixLength + 1, MaxInt);
end;

procedure TdxPDFCustomFont.RecreateFontProgramFacade;
begin
  FreeAndNil(FFontProgramFacade);
  FFontProgramFacade := CreateFontProgramFacade;
end;

{ TdxPDFCustomColorSpace }

procedure TdxPDFCustomColorSpace.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  RaiseWriteNotImplementedException;
end;

procedure TdxPDFCustomColorSpace.InternalRead(AArray: TdxPDFArray);
begin
  // do nothing
end;

procedure TdxPDFCustomColorSpace.InternalWrite(AHelper: TdxPDFWriterHelper; AArray: TdxPDFWriterArray);
begin
  if FIsInlineWriting then
    AArray.AddName(GetShortTypeName)
  else
    AArray.AddName(GetTypeName);
end;

procedure TdxPDFCustomColorSpace.BeginInlineWriting;
begin
  FIsInlineWriting := True;
end;

procedure TdxPDFCustomColorSpace.EndInlineWriting;
begin
  FIsInlineWriting := False;
end;

function TdxPDFCustomColorSpace.Write(AHelper: TdxPDFWriterHelper): TdxPDFBase;
var
  AArray: TdxPDFWriterArray;
begin
  AArray := AHelper.CreateArray;
  InternalWrite(AHelper, AArray);
  Result := AArray;
end;

procedure TdxPDFCustomColorSpace.CreateSubClasses;
begin
  inherited CreateSubClasses;
  AlternateColorSpace := nil;
end;

procedure TdxPDFCustomColorSpace.DestroySubClasses;
begin
  AlternateColorSpace := nil;
  inherited DestroySubClasses;
end;

procedure TdxPDFCustomColorSpace.DoRead(ADictionary: TdxPDFReaderDictionary);
var
  AArray: TdxPDFArray;
begin
  inherited DoRead(ADictionary);
  if ADictionary.TryGetArray(Name, AArray) and CanRead(AArray.Count) then
    InternalRead(AArray)
end;

procedure TdxPDFCustomColorSpace.Initialize;
begin
  inherited Initialize;
  FComponentCount := GetComponentCount;
end;

function TdxPDFCustomColorSpace.GetComponentCount: Integer;
begin
  Result := FComponentCount;
end;

function TdxPDFCustomColorSpace.GetDecodedImageScanlineSource(const ADecoratingSource: IdxPDFImageScanlineSource;
  const AImage: IdxPDFDocumentImage; AWidth: Integer): IdxPDFImageScanlineSource;
var
  ADecodeArray, ADefaultDecodeArray: TdxPDFRanges;
  ASize, I: Integer;
begin
  ADecodeArray := AImage.GetDecodeRanges;
  if ADecodeArray <> nil then
  begin
    ADefaultDecodeArray := CreateDefaultDecodeArray(AImage.GetBitsPerComponent);
    ASize := Length(ADefaultDecodeArray);
    if ASize = Length(ADecodeArray) then
      for I := 0 to ASize - 1 do
        if ADefaultDecodeArray[I] <> ADecodeArray[I] then
          Exit(TdxPDFDecodeImageScanlineSource.Create(ADecodeArray, AWidth, ADecoratingSource));
  end;
  Result := ADecoratingSource;
end;

function TdxPDFCustomColorSpace.CanRead(ASize: Integer): Boolean;
begin
  Result := True;
end;

procedure TdxPDFCustomColorSpace.CheckComponentCount;
begin
  if not (ComponentCount in [1, 3, 4]) then
    TdxPDFUtils.RaiseTestException('Invalid color space component count');
end;

class function TdxPDFCustomColorSpace.GetShortTypeName: string;
begin
  Result := GetTypeName;
end;

function TdxPDFCustomColorSpace.AlternateTransform(const AColor: TdxPDFColor): TdxPDFColor;
begin
  Result := Transform(AColor);
end;

function TdxPDFCustomColorSpace.CreateDefaultDecodeArray(ABitsPerComponent: Integer): TdxPDFRanges;
var
  I: Integer;
begin
  SetLength(Result, ComponentCount);
  for I := 0 to ComponentCount - 1 do
    Result[I] := TdxPDFRange.Create(0, 1);
end;

function TdxPDFCustomColorSpace.Transform(const AComponents: TDoubleDynArray): TDoubleDynArray;
begin
  Result := AComponents;
end;

function TdxPDFCustomColorSpace.Transform(const AColor: TdxPDFColor): TdxPDFColor;
begin
  Result := TdxPDFColor.Create(AColor.Pattern, Transform(AColor.Components));
end;

function TdxPDFCustomColorSpace.Transform(const AImage: IdxPDFDocumentImage; const AData: IdxPDFImageScanlineSource;
  const AParameters: TdxPDFImageParameters): TdxPDFScanlineTransformationResult;
var
  ATransformationResult: TdxPDFScanlineTransformationResult;
begin
  if (AParameters.Size.cx > AImage.GetWidth) and (AParameters.Size.cy > AImage.GetHeight) then
  begin
    ATransformationResult := Transform(GetDecodedImageScanlineSource(AData, AImage, AImage.GetWidth), AImage.GetWidth);
    Result := TdxPDFScanlineTransformationResult.Create(
       AImage.GetInterpolatedScanlineSource(ATransformationResult.ScanlineSource, AParameters), ATransformationResult.PixelFormat);
  end
  else
    Result := Transform(GetDecodedImageScanlineSource(AImage.GetInterpolatedScanlineSource(AData, AParameters), AImage,
      AParameters.Size.cx), AParameters.Size.cx);
  dxTestCheck(not Result.IsNull, 'ColorSpace transformation result is null');
end;

function TdxPDFCustomColorSpace.Transform(const AData: IdxPDFImageScanlineSource;
  AWidth: Integer): TdxPDFScanlineTransformationResult;
begin
  Result := TdxPDFScanlineTransformationResult.Null;
end;

procedure TdxPDFCustomColorSpace.SetAlternateColorSpace(const AValue: TdxPDFCustomColorSpace);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FAlternateColorSpace));
end;

procedure TdxPDFCustomColorSpace.SetComponentCount(const AValue: Integer);
begin
  if FComponentCount <> AValue then
  begin
    FComponentCount := AValue;
    CheckComponentCount;
  end;
end;

{ TdxPDFDeferredObject }

constructor TdxPDFDeferredObject.Create(AParent: TdxPDFObject; const AInfo: TdxPDFDeferredObjectInfo);
begin
  inherited Create(AParent);
  RawObject := AInfo.RawObject;
  FInfo.Name := AInfo.Name;
  FInfo.Key := AInfo.Key;
  FInfo.Number := AInfo.Number;
end;

constructor TdxPDFDeferredObject.Create(AParent, AResolvedObject: TdxPDFObject);
begin
  inherited Create(AParent);
  ResolvedObject := AResolvedObject;
  FInfo.Number := FResolvedObject.Number;
  FInfo.Key := FResolvedObject.GetTypeName;
end;

procedure TdxPDFDeferredObject.DestroySubClasses;
begin
  ResolvedObject := nil;
  RawObject := nil;
  inherited DestroySubClasses;
end;

function TdxPDFDeferredObject.IsResolved: Boolean;
begin
  Result := FResolvedObject <> nil;
end;

procedure TdxPDFDeferredObject.ResolveObject;
var
  ADictionary, APrevDictionary: TdxPDFReaderDictionary;
  AObject: TdxPDFObject;
begin
  if RawObject is TdxPDFObject then
  begin
    ResolvedObject := RawObject as TdxPDFObject;
    Exit;
  end;
  if Repository.TryGetResolvedObject(FInfo.Number, AObject) then
  begin
    ResolvedObject := AObject;
    Exit;
  end;

  if FInfo.Key = TdxPDFCustomDestination.GetTypeName then
    ResolvedObject := Repository.CreateDestination(RawObject)
  else
    if Repository.TryGetAsDictionary(RawObject, ADictionary) then
    begin
      APrevDictionary := ADictionary;
      ADictionary.Number := FInfo.Number;
      if FInfo.Key = TdxPDFColorSpaces.GetTypeName then
        ResolvedObject := Repository.CreateColorSpace(ADictionary.GetObject(FInfo.Name))
      else
        if FInfo.Key = TdxPDFPatterns.GetTypeName then
          ResolvedObject := Repository.CreatePattern(ADictionary.GetObject(FInfo.Name))
       else
         if FInfo.Key = TdxPDFShadings.GetTypeName then
           ResolvedObject := Repository.CreateShading(ADictionary.GetObject(FInfo.Name))
         else
           if FInfo.Key = TdxPDFCustomFont.GetTypeName then
           begin
             ADictionary := ADictionary.GetDictionary(FInfo.Name);
             if ADictionary = nil then
               ADictionary := APrevDictionary;
             ADictionary.Number := FInfo.Number;
             ResolvedObject := Repository.CreateFont(ADictionary);
           end
           else
             if FInfo.Key = TdxPDFFileSpecification.GetTypeName then
               ResolvedObject := Repository.CreateFileSpecification(ADictionary)
             else
               if FInfo.Key = TdxPDFGraphicsStateParametersList.GetTypeName then
                 ResolvedObject := Repository.CreateGraphicsStateParameters(ADictionary.GetDictionary(FInfo.Name))
               else
                 if ADictionary.GetString(FInfo.Key) = TdxPDFXForm.GetTypeName then
                   ResolvedObject := Repository.CreateForm(ADictionary)
                 else
                   if ADictionary.GetString(FInfo.Key) = TdxPDFDocumentImage.GetTypeName then
                     ResolvedObject := Repository.CreateImage(Parent, ADictionary)
                   else
                   begin
                     ResolvedObject := Repository.CreateObject(ADictionary.GetString(FInfo.Key), Parent);
                     if IsResolved then
                       ResolvedObject.Read(ADictionary);
                   end;
    end;
end;

function TdxPDFDeferredObject.GetRawObject: TdxPDFBase;
begin
  Result := FInfo.RawObject;
end;

function TdxPDFDeferredObject.GetResolvedObject: TdxPDFObject;
begin
  if FResolvedObject = nil then
    ResolveObject;
  Result := FResolvedObject;
end;

procedure TdxPDFDeferredObject.SetRawObject(const AValue: TdxPDFBase);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FInfo.RawObject));
end;

procedure TdxPDFDeferredObject.SetResolvedObject(const AValue: TdxPDFObject);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FResolvedObject));
end;

{ TdxPDFGraphicsStateParameters }

class function TdxPDFGraphicsStateParameters.GetTypeName: string;
begin
  Result := TdxPDFKeywords.ExtGState;
end;

constructor TdxPDFGraphicsStateParameters.Create;
begin
  inherited Create(nil);
end;

function TdxPDFGraphicsStateParameters.Equals(AObject: TObject): Boolean;

  function AreEquals(const V1, V2: Double): Boolean;
  begin
    Result := SameValue(V1, V2, 0.0004);
  end;

var
  AParameters: TdxPDFGraphicsStateParameters;
begin
  Result := inherited Equals(AObject);
  if Result then
  begin
    AParameters := TdxPDFGraphicsStateParameters(AObject);
    Result := (AParameters.FBlendMode = FBlendMode) and AreEquals(AParameters.FFlatnessTolerance, FFlatnessTolerance) and
      AreEquals(AParameters.FFontSize, FFontSize) and (AParameters.FLineCapStyle = FLineCapStyle) and
      (AParameters.FLineJoinStyle = FLineJoinStyle) and AreEquals(AParameters.FLineWidth, FLineWidth) and
      AreEquals(AParameters.FMiterLimit, FMiterLimit) and AreEquals(AParameters.FNonStrokingColorAlpha, FNonStrokingColorAlpha) and
      (AParameters.FRenderingIntent = FRenderingIntent) and AreEquals(AParameters.FSmoothnessTolerance, FSmoothnessTolerance) and
      AreEquals(AParameters.FStrokingColorAlpha, FStrokingColorAlpha) and (AParameters.FTextKnockout = FTextKnockout);
  end;
end;

procedure TdxPDFGraphicsStateParameters.Assign(AParameters: TdxPDFGraphicsStateParameters; ACheckAssignedValues: Boolean = True);
begin
  if not ACheckAssignedValues or (gspStrokingColorAlpha in AParameters.AssignedValues) then
    StrokingColorAlpha := AParameters.StrokingColorAlpha;
  if not ACheckAssignedValues or (gspNonStrokingColorAlpha in AParameters.AssignedValues) then
    NonStrokingColorAlpha := AParameters.NonStrokingColorAlpha;
  if not ACheckAssignedValues or (gspLineCapStyle in AParameters.AssignedValues) then
    LineCapStyle := AParameters.LineCapStyle;
  if not ACheckAssignedValues or (gspLineJoinStyle in AParameters.AssignedValues) then
    LineJoinStyle := AParameters.LineJoinStyle;
  if not ACheckAssignedValues or (gspLineStyle in AParameters.AssignedValues) then
    LineStyle := AParameters.LineStyle;
  if not ACheckAssignedValues or (gspLineWidth in AParameters.AssignedValues) then
    LineWidth := AParameters.LineWidth;
  if not ACheckAssignedValues or (gspMiterLimit in AParameters.AssignedValues) then
    MiterLimit := AParameters.MiterLimit;
  if not ACheckAssignedValues or (gspSmoothnessTolerance in AParameters.AssignedValues) then
    SmoothnessTolerance := AParameters.SmoothnessTolerance;
  if not ACheckAssignedValues or (gspTextKnockout in AParameters.AssignedValues) then
    TextKnockout := AParameters.TextKnockout;
  if not ACheckAssignedValues or (gspRenderingIntent in AParameters.AssignedValues) then
    RenderingIntent := AParameters.RenderingIntent;
  FIsSoftMaskChanged := not ACheckAssignedValues or (gspSoftMask in AParameters.AssignedValues) and not
    SoftMask.IsSame(AParameters.SoftMask);
  if FIsSoftMaskChanged then
    SoftMask := AParameters.SoftMask;
  if not ACheckAssignedValues or (gspBlendMode in AParameters.AssignedValues) then
    BlendMode := AParameters.BlendMode;
end;

procedure TdxPDFGraphicsStateParameters.SetFont(const AValue: TdxPDFCustomFont);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FFont));
end;

procedure TdxPDFGraphicsStateParameters.SetLineStyle(const AValue: TdxPDFLineStyle);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FLineStyle));
end;

procedure TdxPDFGraphicsStateParameters.SetLineWidth(const AValue: Double);
begin
  FLineWidth := AValue;
  Include(FAssignedValues, gspLineWidth);
end;

procedure TdxPDFGraphicsStateParameters.SetSoftMask(const AValue: TdxPDFCustomSoftMask);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FSoftMask));
end;

procedure TdxPDFGraphicsStateParameters.CreateSubClasses;
begin
  inherited CreateSubClasses;
  LineStyle := nil;
  SoftMask := TdxPDFEmptySoftMask.Create;
end;

procedure TdxPDFGraphicsStateParameters.DestroySubClasses;
begin
  SoftMask := nil;
  LineStyle := nil;
  inherited DestroySubClasses;
end;

procedure TdxPDFGraphicsStateParameters.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  FAssignedValues := [];

  if ADictionary.Contains(TdxPDFKeyWords.LineCap) then
  begin
    LineCapStyle := TdxPDFLineCapStyle(ADictionary.GetInteger(TdxPDFKeyWords.LineCap));
    Include(FAssignedValues, gspLineCapStyle);
  end;
  if ADictionary.Contains(TdxPDFKeyWords.LineJoinStyle) then
  begin
    LineJoinStyle := TdxPDFLineJoinStyle(ADictionary.GetInteger(TdxPDFKeyWords.LineJoinStyle));
    Include(FAssignedValues, gspLineJoinStyle);
  end;
  if ADictionary.Contains(TdxPDFKeyWords.LineStyle) then
  begin
    LineStyle := TdxPDFLineStyle.Create(ADictionary.GetArray(TdxPDFKeyWords.LineStyle));
    Include(FAssignedValues, gspLineStyle);
  end;
  if ADictionary.Contains(TdxPDFKeyWords.LineWidth) then
  begin
    LineWidth := ADictionary.GetInteger(TdxPDFKeyWords.LineWidth);
    Include(FAssignedValues, gspLineWidth);
  end;
  if ADictionary.Contains(TdxPDFKeyWords.FlatnessTolerance) then
  begin
    FlatnessTolerance := ADictionary.GetDouble(TdxPDFKeyWords.FlatnessTolerance);
    Include(FAssignedValues, gspFlatnessTolerance);
  end;
  if ADictionary.Contains(TdxPDFKeyWords.SmoothnessTolerance) then
  begin
    SmoothnessTolerance := ADictionary.GetDouble(TdxPDFKeyWords.SmoothnessTolerance);
    Include(FAssignedValues, gspSmoothnessTolerance);
  end;
  if ADictionary.Contains(TdxPDFKeyWords.StrokingColorAlpha) then
  begin
    StrokingColorAlpha := ADictionary.GetDouble(TdxPDFKeyWords.StrokingColorAlpha);
    Include(FAssignedValues, gspStrokingColorAlpha);
  end;
  if ADictionary.Contains(TdxPDFKeyWords.NonStrokingColorAlpha) then
  begin
    NonStrokingColorAlpha := ADictionary.GetDouble(TdxPDFKeyWords.NonStrokingColorAlpha);
    Include(FAssignedValues, gspNonStrokingColorAlpha);
  end;
  if ADictionary.Contains(TdxPDFKeyWords.MiterLimit) then
  begin
    MiterLimit := ADictionary.GetInteger(TdxPDFKeyWords.MiterLimit);
    Include(FAssignedValues, gspMiterLimit);
  end;
  if ADictionary.Contains(TdxPDFKeyWords.TextKnockout) then
  begin
    TextKnockout := ADictionary.GetBoolean(TdxPDFKeyWords.TextKnockout);
    Include(FAssignedValues, gspTextKnockout);
  end;
  if ADictionary.Contains(TdxPDFKeyWords.BlendMode) then
  begin
    BlendMode := TdxPDFBlendModeDictionary.ToValue(ADictionary.GetString(TdxPDFKeyWords.BlendMode));
    Include(FAssignedValues, gspBlendMode);
  end;
  if ADictionary.Contains(TdxPDFKeyWords.SoftMask) then
  begin
    SoftMask := Repository.CreateSoftMask(ADictionary.GetObject(TdxPDFKeyWords.SoftMask));
    Include(FAssignedValues, gspSoftMask);
  end;
end;

procedure TdxPDFGraphicsStateParameters.Initialize;
begin
  inherited Initialize;
  FFlatnessTolerance := 1.0;
  FLineWidth := 1;
  FLineCapStyle := lcsButt;
  FMiterLimit := 10.0;
  FNonStrokingColorAlpha := 1.0;
  FTextKnockout := True;
  FStrokingColorAlpha := 1.0;
  FSmoothnessTolerance := 0.0;
  FRenderingIntent := riRelativeColorimetric;
  FBlendMode := bmNormal;
end;

procedure TdxPDFGraphicsStateParameters.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);

  if gspLineCapStyle in AssignedValues then
    ADictionary.Add(TdxPDFKeyWords.LineCap, Ord(LineCapStyle));
  if gspLineJoinStyle in AssignedValues then
    ADictionary.Add(TdxPDFKeyWords.LineJoinStyle, Ord(LineJoinStyle));
  if gspLineStyle in AssignedValues then
    ADictionary.Add(TdxPDFKeyWords.LineStyle, TdxPDFLineStyleAccess(LineStyle).Write);
  if gspLineWidth in AssignedValues then
    ADictionary.Add(TdxPDFKeyWords.LineWidth, LineWidth);
  if gspFlatnessTolerance in AssignedValues then
    ADictionary.Add(TdxPDFKeyWords.FlatnessTolerance, FlatnessTolerance);
  if gspSmoothnessTolerance in AssignedValues then
    ADictionary.Add(TdxPDFKeyWords.SmoothnessTolerance, SmoothnessTolerance);
  if gspStrokingColorAlpha in AssignedValues then
    ADictionary.Add(TdxPDFKeyWords.StrokingColorAlpha, StrokingColorAlpha);
  if gspNonStrokingColorAlpha in AssignedValues then
    ADictionary.Add(TdxPDFKeyWords.NonStrokingColorAlpha, NonStrokingColorAlpha);
  if gspMiterLimit in AssignedValues then
    ADictionary.Add(TdxPDFKeyWords.MiterLimit, MiterLimit);
  if gspTextKnockout in AssignedValues then
    ADictionary.Add(TdxPDFKeyWords.TextKnockout, TextKnockout);
  if gspBlendMode in AssignedValues then
    ADictionary.AddName(TdxPDFKeyWords.BlendMode, TdxPDFBlendModeDictionary.ToString(BlendMode));
  if gspSoftMask in AssignedValues then
    ADictionary.Add(TdxPDFKeyWords.SoftMask, SoftMask);
end;

{ TdxPDFObjectList }

function TdxPDFObjectList.Add(AObject: TdxPDFObject): string;
begin
  Result := '';
  if not FNames.ContainsValue(AObject.Number) then
  begin
    Result := FNames.GetNewResourceName(InternalObjects);
    InternalAdd(Result, AObject);
  end;
end;

function TdxPDFObjectList.AddReference(ANumber: Integer): string;
var
  ARawObject: TdxPDFBase;
begin
  Result := FNames.GetNewResourceName(InternalObjects);

  ARawObject := Repository.GetObject(ANumber) as TdxPDFBase;
  if ARawObject <> nil then
    AddDeferredObject(GetTypeDictionaryKey, Result, ARawObject)
  else
    TdxPDFUtils.RaiseException;
end;

function TdxPDFObjectList.Contains(const AName: string): Boolean;
begin
  Result := InternalObjects.ContainsKey(AName);
end;

procedure TdxPDFObjectList.AssignTo(AList: TdxPDFObjectList);
var
  APair: TPair<string, TdxPDFReferencedObject>;
begin
  if AList = nil then
    Exit;
  for APair in InternalObjects do
    AList.InternalObjects.Add(APair.Key, APair.Value);

end;

procedure TdxPDFObjectList.Enum(AProc: TEnumProc);
var
  AKey: string;
  AObject: TdxPDFObject;
begin
  for AKey in InternalObjects.Keys do
  begin
    AObject := GetObject(AKey);
    if AObject <> nil then
      AProc(AObject);
  end;
end;

procedure TdxPDFObjectList.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FInternalObjects := TdxPDFStringReferencedObjectDictionary.Create;
  FNames := TdxPDFNamedObjectDictionary.Create(GetTypeName, GetTypePrefix);
end;

procedure TdxPDFObjectList.DestroySubClasses;
begin
  FreeAndNil(FNames);
  FreeAndNil(FInternalObjects);
  inherited DestroySubClasses;
end;

procedure TdxPDFObjectList.Read(ADictionary: TdxPDFReaderDictionary);
begin
  inherited Read(ADictionary);
  Clear;
  if ADictionary = nil then
    Exit;
  ADictionary.EnumKeys(
    procedure(const AKey: string)
    var
      ANumber: Integer;
      AObject, AShareObject: TdxPDFBase;
    begin
      ANumber := ADictionary.GetObjectNumber(AKey);
      if TdxPDFUtils.IsIntegerValid(ANumber) then
      begin
        AObject := ADictionary.GetObject(AKey);
        if AObject is TdxPDFObject then
          InternalAdd(AKey, TdxPDFObject(AObject))
        else
          if AObject <> nil then
          begin
            AShareObject := AObject;
            AShareObject.Number := ANumber;
            AObject := Repository.GetDictionary(AObject.Number);
            if (AObject = nil) and (AShareObject.ObjectType = otDictionary) then
            begin
              if dxPDFIsObjectSupported(AShareObject as TdxPDFDictionary, GetTypeDictionaryKey) then
                AddDeferredObject(GetTypeDictionaryKey, AKey, AShareObject);
            end
            else
              if AObject <> nil then
              begin
                AObject.Number := ANumber;
                AddDeferredObject(GetTypeDictionaryKey, AKey, AObject);
              end;
          end;
      end;
    end);
end;

procedure TdxPDFObjectList.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  WriteList(AHelper, ADictionary);
end;

function TdxPDFObjectList.GetUniqueName: string;
begin
  Result := FNames.GetNewResourceName(InternalObjects);
end;

function TdxPDFObjectList.GetObject(const AName: string): TdxPDFObject;
var
  AResult: TdxPDFReferencedObject;
begin
  if InternalObjects.TryGetValue(AName, AResult) then
  begin
    if AResult is TdxPDFDeferredObject then
      Result := TdxPDFDeferredObject(AResult).ResolvedObject
    else
      Result := AResult as TdxPDFObject;
  end
  else
    Result := nil;
end;

function TdxPDFObjectList.TryGetObjectName(const AObject: TdxPDFObject; out AName: string): Boolean;
var
  APair: TPair<string, TdxPDFReferencedObject>;
begin
  Result := False;
  for APair in InternalObjects do
  begin
    Result := AObject = APair.Value;
    if Result then
    begin
      AName := APair.Key;
      Break;
    end;
  end;
end;

class function TdxPDFObjectList.GetTypePrefix: string;
begin
  Result:= 'ResourcePrefix';
end;

function TdxPDFObjectList.GetTypeDictionaryKey: string;
begin
  Result := TdxPDFKeywords.Subtype;
end;

function TdxPDFObjectList.GetCount: Integer;
begin
  Result := InternalObjects.Count;
end;

procedure TdxPDFObjectList.AddDeferredObject(const AKey, AName: string; ARawObject: TdxPDFBase);
var
  AInfo: TdxPDFDeferredObjectInfo;
begin
  AInfo.Name := AName;
  AInfo.Key := AKey;
  AInfo.Number := ARawObject.Number;
  AInfo.RawObject := ARawObject;
  InternalAdd(AName, Repository.CreateDeferredObject(Parent, AInfo));
end;

procedure TdxPDFObjectList.Clear;
begin
  InternalObjects.Clear;
end;

procedure TdxPDFObjectList.InternalAdd(const AName: string; AObject: TdxPDFObject);
begin
  InternalObjects.Add(AName, AObject);
end;

procedure TdxPDFObjectList.ReadList(ADictionary: TdxPDFReaderDictionary);
var
  AInfo: TdxPDFDeferredObjectInfo;
begin
  if ADictionary = nil then
    Exit;
  AInfo.Key := GetTypeName;
  AInfo.RawObject := ADictionary;
  ADictionary.EnumKeys(
    procedure(const AKey: string)
    begin
      AInfo.Name := AKey;
      AInfo.Number := (ADictionary.Value[AKey] as TdxPDFBase).Number;
      InternalAdd(AKey, Repository.CreateDeferredObject(Parent, AInfo));
    end);
end;

procedure TdxPDFObjectList.WriteList(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
var
  AKey: string;
  AObject: TdxPDFObject;
begin
  for AKey in InternalObjects.Keys do
  begin
    AObject := GetObject(AKey);
    if AObject <> nil then
      AHelper.Context.AddReference(ADictionary, AObject, GetTypeName, AKey);
  end;
end;

procedure TdxPDFObjectList.ResolveObjects;
var
  AObject: TdxPDFReferencedObject;
begin
  for AObject in InternalObjects.Values do
    if AObject is TdxPDFDeferredObject then
      TdxPDFDeferredObject(AObject).ResolvedObject;
end;

{ TdxPDFDocumentImageDataStorage }

constructor TdxPDFDocumentImageDataStorage.Create(ALimit: Int64);
begin
  inherited Create;
  FCache := TdxPDFImageDataCache.Create(ALimit * 1024 * 1024);
  FImageList := TList<TdxPDFDocumentImage>.Create;
  FReferences := TdxPDFUniqueReferences.Create;
end;

destructor TdxPDFDocumentImageDataStorage.Destroy;
begin
  Clear;
  FreeAndNil(FCache);
  FreeAndNil(FImageList);
  FreeAndNil(FReferences);
  inherited Destroy;
end;

procedure TdxPDFDocumentImageDataStorage.Clear;
var
  AImage: TdxPDFDocumentImage;
begin
  FCache.Clear;
  for AImage in FImageList do
    RemoveListener(AImage);
  FImageList.Clear;
  FReferences.Clear;
end;

function TdxPDFDocumentImageDataStorage.GetImage(AImage: TdxPDFDocumentImage;
  const AImageParameters: TdxPDFImageParameters): TdxPDFImageCacheItem;
begin
  Result := FCache.GetImage(AImage, AImageParameters);
end;

procedure TdxPDFDocumentImageDataStorage.Add(AImage: TdxPDFDocumentImage);
begin
  AImage.AddListener(Self);
  FImageList.Add(AImage);
  AddReference(AImage);
end;

function TdxPDFDocumentImageDataStorage.TryGetReference(ANumber: Integer; out AImage: TdxPDFDocumentImage): Boolean;
var
  AObject: TdxPDFBase;
begin
  AImage := nil;
  Result := FReferences.TryGetValue(ANumber, AObject);
  if Result then
    AImage := AObject as TdxPDFDocumentImage;
end;

procedure TdxPDFDocumentImageDataStorage.AddReference(AImage: TdxPDFDocumentImage);
begin
  if not FReferences.ContainsKey(AImage.GUID, AImage.Number) then
    FReferences.Add(AImage.GUID, AImage.Number, AImage);
end;

procedure TdxPDFDocumentImageDataStorage.RemoveListener(AImage: TdxPDFDocumentImage);
begin
  AImage.RemoveListener(Self);
end;

procedure TdxPDFDocumentImageDataStorage.ImageDestroyHandler(Sender: TdxPDFBase);
var
  AImage: TdxPDFDocumentImage;
begin
  AImage := Sender as TdxPDFDocumentImage;
  FCache.RemoveItem(AImage);
  FImageList.Remove(AImage);
end;

{ TdxFontFamilyInfo }

constructor TdxFontFamilyInfo.Create;
begin
  inherited Create;
  FAdditionalStyles := TdxPDFStringStringDictionary.Create;
end;

constructor TdxFontFamilyInfo.Create(const ASystemFontName: string);
begin
  Create;
  FSystemFontName := ASystemFontName;
end;

destructor TdxFontFamilyInfo.Destroy;
begin
  FreeAndNil(FAdditionalStyles);
  inherited Destroy;
end;

{ TdxFontFamilyInfos }

constructor TdxFontFamilyInfos.Create;
begin
  inherited Create;
  FFamilies := nil;
  FInstalledFontCollection := TdxGPInstalledFontCollection.Create;
  FInfos := TdxPDFStringObjectDictionary<TdxFontFamilyInfo>.Create([doOwnsValues]);
  FStylePattern := TdxPDFUtils.Split('semibold|semilight|demi|light|black|bold|italic|oblique|md|sb|bd|it|scn|mt', '|');
  FAdditionalStylePattern := TdxPDFUtils.Split('semibold|semilight|demibold|demi|light|black|md|bd|italic|sb|scn', '|');
  PopulateInfos;
end;

destructor TdxFontFamilyInfos.Destroy;
begin
  FreeAndNil(FInfos);
  FreeAndNil(FInstalledFontCollection);
  FreeAndNil(FFamilies);
  inherited Destroy;
end;

function TdxFontFamilyInfos.Contains(const AFamily: string): Boolean;
begin
  Result := Families.IndexOf(AFamily) > -1;
end;

function TdxFontFamilyInfos.Normalize(const AName: string): string;
begin
  Result := StringReplace(AName, ' ', '', [rfReplaceAll]);
  Result := StringReplace(Result, '-', '', [rfReplaceAll]);
  Result := LowerCase(StringReplace(Result, ',', '', [rfReplaceAll]));
end;

function TdxFontFamilyInfos.MatchPattern(const S: string; const APattern: string): string;
begin
  Result := MatchPattern(S, TdxPDFUtils.Split(APattern, '|'));
end;

function TdxFontFamilyInfos.MatchPattern(const S: string; const APatternArray: TStringDynArray): string;
var
  ATemp, APattern: string;
begin
  Result := '';
  ATemp := LowerCase(S);
  for APattern in APatternArray do
    if Pos(APattern, ATemp) > 0 then
    begin
      ATemp := StringReplace(ATemp, APattern, '', [rfReplaceAll]);
      Result := Result + APattern;
    end;
end;

function TdxFontFamilyInfos.RemovePattern(const S: string; const APatternArray: TStringDynArray): string;
var
  I, L: Integer;
  APattern: string;
begin
  Result := S;
  for APattern in APatternArray do
    Result := StringReplace(Result, APattern, '', [rfReplaceAll, rfIgnoreCase]);
  L := Length(Result);
  for I := L downto 1 do
    if not CharInSet(Result[I], [' ', '-', ',']) then
    begin
      if I <> L then
        Result := Copy(Result, 1, I);
      Break;
    end;
end;

function TdxFontFamilyInfos.GetFontFamily(const AFontName: string): string;
begin
  Result := RemovePattern(AFontName, FStylePattern);
  Result := StringReplace(Result, ',', '', [rfReplaceAll]);
end;

function TdxFontFamilyInfos.GetFamilies: TStringList;
var
  AGPFamily: TdxGPFontFamily;
begin
  if FFamilies = nil then
  begin
    FFamilies := TStringList.Create;
    for AGPFamily in FInstalledFontCollection.Families do
      FFamilies.Add(AGPFamily.Name);
  end;
  Result := FFamilies;
end;

function TdxFontFamilyInfos.GetFontStyle(const AFontName: string): string;
begin
  Result := MatchPattern(AFontName, FStylePattern);
end;

function TdxFontFamilyInfos.ContainsBoldStyle(const AFontStyle: string): Boolean;
begin
  Result := (AFontStyle <> '') and (MatchPattern(AFontStyle, 'demibold|demi|black|bold|bd') <> '');
end;

function TdxFontFamilyInfos.ContainsItalicStyle(const AFontStyle: string): Boolean;
begin
  Result := (AFontStyle <> '') and (MatchPattern(AFontStyle, 'italic|oblique|it') <> '');
end;

function TdxFontFamilyInfos.ExtractAdditionalStyles(const AActualStyle: string): TStringDynArray;
var
  AResult: TStringBuilder;
  ATemp, APattern: string;
begin
  AResult := TdxStringBuilderManager.Get;
  try
    ATemp := LowerCase(AActualStyle);
    for APattern in FAdditionalStylePattern do
    begin
      if Pos(APattern, ATemp) > 0 then
      begin
        ATemp := StringReplace(ATemp, APattern, '', [rfReplaceAll]);
        AResult.Append('|');
        AResult.Append(APattern);
      end;
    end;
    Result := TdxPDFUtils.Split(AResult.ToString, '|');
  finally
    TdxStringBuilderManager.Release(AResult);
  end;
end;

function TdxFontFamilyInfos.GetNormalizedFontFamily(const AFontName: string): string;
begin
  Result := Normalize(GetFontFamily(AFontName));
end;

function TdxFontFamilyInfos.GetNormalizedFontStyle(const AFontName: string): string;
begin
  Result := Normalize(GetFontStyle(AFontName));
end;

function TdxFontFamilyInfos.TryGetValue(const AFamilyName: string; out AInfo: TdxFontFamilyInfo): Boolean;
begin
  Result := FInfos.TryGetValue(AFamilyName, AInfo);
end;

procedure TdxFontFamilyInfos.AddFamilyIfNotExists(const AKey, AValue: string);
var
  ANormalized: string;
begin
  ANormalized := GetNormalizedFontFamily(AKey);
  if not FInfos.ContainsKey(ANormalized) then
    FInfos.Add(ANormalized, TdxFontFamilyInfo.Create(AValue));
end;

procedure TdxFontFamilyInfos.PopulateInfos;
var
  AGPFamily: TdxGPFontFamily;
  AFamilyName, AActualFamily, AActualStyle: string;
  AInfo: TdxFontFamilyInfo;
begin
  for AGPFamily in FInstalledFontCollection.Families do
  begin
    AFamilyName := AGPFamily.Name;
    AActualFamily := GetNormalizedFontFamily(AFamilyName);
    AActualStyle := GetNormalizedFontStyle(AFamilyName);
    if not FInfos.TryGetValue(AActualFamily, AInfo) then
    begin
      AInfo := TdxFontFamilyInfo.Create(AFamilyName);
      FInfos.Add(AActualFamily, AInfo);
    end;
    if AActualStyle <> '' then
      AInfo.AdditionalStyles.AddOrSetValue(AActualStyle, AFamilyName);
    if TdxStringHelper.Contains(AFamilyName, 'Segoe UI') then
      FSegoeUIPresent := True;
  end;
  AddFamilyIfNotExists(TdxPDFKeywords.CourierFontName, TdxPDFKeywords.CourierNewFontName2);
  AddFamilyIfNotExists(TdxPDFKeywords.CourierNewFontName, TdxPDFKeywords.CourierNewFontName2);
  AddFamilyIfNotExists('CourierNewPS', TdxPDFKeywords.CourierNewFontName2);
  AddFamilyIfNotExists('CourierNewPS' + TdxPDFKeywords.FontMTSuffix, TdxPDFKeywords.CourierNewFontName2);

  AddFamilyIfNotExists(TdxPDFKeywords.TimesRomanFontName, TdxPDFKeywords.TimesNewRomanFontName2);
  AddFamilyIfNotExists('Times', TdxPDFKeywords.TimesNewRomanFontName2);
  AddFamilyIfNotExists('TimesNewRomanPS', TdxPDFKeywords.TimesNewRomanFontName2);
  AddFamilyIfNotExists('TimesNewRomanPS' + TdxPDFKeywords.FontMTSuffix, TdxPDFKeywords.TimesNewRomanFontName2);

  AddFamilyIfNotExists(TdxPDFKeywords.ArialFontName + TdxPDFKeywords.FontMTSuffix, TdxPDFKeywords.ArialFontName);

  AddFamilyIfNotExists('TallPaul', 'Gabriola');
  AddFamilyIfNotExists('CenturyGothic', 'Century Gothic');
  AddFamilyIfNotExists('GothicText', 'MS Gothic');
  AddFamilyIfNotExists('Flama', 'Tahoma');
  AddFamilyIfNotExists('FlamaBook', 'Tahoma');

  AddFamilyIfNotExists(TdxPDFKeywords.HelveticaFontName, TdxPDFKeywords.ArialFontName);

  AFamilyName := Normalize(TdxPDFKeywords.SymbolFontName);
  if FSegoeUIPresent then
    FInfos.AddOrSetValue(AFamilyName, TdxFontFamilyInfo.Create('Segoe UI'))
  else
    FInfos.AddOrSetValue(AFamilyName, TdxFontFamilyInfo.Create(TdxPDFKeywords.ArialUnicodeMS));
  AddFamilyIfNotExists(TdxPDFKeywords.ZapfDingbatsFontName, 'MS Gothic');
end;

{ TdxPDFGDIFontSubstitutionHelper }

constructor TdxPDFGDIFontSubstitutionHelper.Create;
begin
  inherited Create;
  FFontFamilyInfos := TdxFontFamilyInfos.Create;
end;

destructor TdxPDFGDIFontSubstitutionHelper.Destroy;
begin
  FreeAndNil(FFontFamilyInfos);
  inherited Destroy;
end;

function TdxPDFGDIFontSubstitutionHelper.GetSubstituteFontParameters(AFont: TdxPDFCustomFont): TdxPDFFontRegistratorParameters;
begin
  Result := GetSubstituteFontParameters(AFont, nil);
end;

function TdxPDFGDIFontSubstitutionHelper.GetSubstituteFontParameters(AFont: TdxPDFCustomFont;
  AFontFamilyFilter: TFunc<string, Boolean>): TdxPDFFontRegistratorParameters;
var
  AActualFamily, AActualStyle, AActualName, AAdditionalStyle: string;
  AFontWeight: Integer;
  AAdditionalStyleFound, AIsItalic: Boolean;
  AInfo: TdxFontFamilyInfo;
begin
  AActualStyle := GetFontStyle(AFont, AActualFamily);
  AActualName := AFont.Name;
  AAdditionalStyleFound := False;
  if FontFamilyInfos.TryGetValue(AActualFamily, AInfo) then
  begin
    if not Assigned(AFontFamilyFilter) or AFontFamilyFilter(AActualFamily) then
    begin
      for AAdditionalStyle in FontFamilyInfos.ExtractAdditionalStyles(AActualStyle) do
        if AInfo.AdditionalStyles.TryGetValue(AAdditionalStyle, AActualName) then
        begin
          AAdditionalStyleFound := True;
          Break;
        end;
      if not AAdditionalStyleFound then
        AActualName := AInfo.SystemFontName;
    end
    else
      AActualName := FontFamilyInfos.GetFontFamily(AFont.Name);
  end
  else
    AActualName := FontFamilyInfos.GetFontFamily(AFont.Name);
  if not AAdditionalStyleFound and FontFamilyInfos.ContainsBoldStyle(AActualStyle) or
    (AActualStyle <> '') and AFont.ForceBold then
    AFontWeight := BoldWeight
  else
    AFontWeight := GetFontWeight(AFont);
  AIsItalic := False;
  if not AAdditionalStyleFound then
    AIsItalic := FontFamilyInfos.ContainsItalicStyle(AActualStyle);
  Result := TdxPDFFontRegistratorParameters.Create(AActualName, AFontWeight, AIsItalic);
end;

function TdxPDFGDIFontSubstitutionHelper.GetFontStyle(AFont: TdxPDFCustomFont; out AFamily: string): string;
var
  I: Integer;
  AFontNames: TStringList;
begin
  Result := '';
  AFontNames := TStringList.Create;
  try
    AFontNames.Add(AFont.Name);
    AFontNames.Add(AFont.BaseFont);
    if AFont.FontDescriptor <> nil then
      AFontNames.Add(AFont.FontDescriptor.FontName);
    AFamily := FontFamilyInfos.GetNormalizedFontFamily(AFont.Name);
    for I := 0 to AFontNames.Count - 1 do
    begin
      if AFontNames[I] <> '' then
        Result := FontFamilyInfos.GetNormalizedFontStyle(AFontNames[I]);
      if Result <> '' then
        Break;
    end;
  finally
    AFontNames.Free;
  end;
end;

function TdxPDFGDIFontSubstitutionHelper.GetFontWeight(AFont: TdxPDFCustomFont): Integer;
begin
  if (AFont <> nil) and (AFont.FontDescriptor <> nil) then
    Result := AFont.FontDescriptor.FontWeight
  else
    Result := NormalWeight;
end;

{ TdxPDFFontDataStorage }

constructor TdxPDFFontDataStorage.Create(const ATempFolder: string; AFontSubstitutionHelper: TdxPDFGDIFontSubstitutionHelper);
begin
  inherited Create;
  FFolderName := ATempFolder;
  FDictionary := TDictionary<TdxPDFCustomFont, TdxPDFFontRegistrationData>.Create;
  FReferences := TdxPDFUniqueReferences.Create;
  InitializeCriticalSectionAndSpinCount(FLock, 1024);
  FQueue := TList<TdxPDFCustomFont>.Create;
  FFontSubstitutionHelper := AFontSubstitutionHelper;
end;

function TdxPDFFontDataStorage.CreateFontRegistrator(AFont: TdxPDFCustomFont): TObject;
begin
  Result := TdxPDFFontCustomRegistrator.CreateRegistrator(FFontSubstitutionHelper, AFont, FFolderName);
end;

destructor TdxPDFFontDataStorage.Destroy;
begin
  Clear;
  FreeAndNil(FQueue);
  FreeAndNil(FReferences);
  FreeAndNil(FDictionary);
  DeleteCriticalSection(FLock);
  inherited Destroy;
end;

function TdxPDFFontDataStorage.Add(AFont: TdxPDFCustomFont): TdxPDFFontRegistrationData;
var
  ARegistrator: TdxPDFFontCustomRegistrator;
begin
  EnterCriticalSection(FLock);
  try
    if AFont = FLastRegisteredFont then
      Result := FLastRegisteredFontData
    else
    begin
      FLastRegisteredFont := AFont;
      if FReferences.ContainsKey(AFont.UniqueName, AFont.Number) and FDictionary.TryGetValue(AFont, FLastRegisteredFontData) then
        Exit(FLastRegisteredFontData);
      FLastRegisteredFont := AFont;
      ARegistrator := CreateFontRegistrator(AFont) as TdxPDFFontCustomRegistrator;
      if ARegistrator <> nil then
      begin
        FLastRegisteredFontData := ARegistrator.Register;
        if FLastRegisteredFontData.Registrator = nil then
          ARegistrator.Free;
      end
      else
        FLastRegisteredFontData := TdxPDFFontRegistrationData.Create(AFont.Name, AFont.Weight, AFont.Italic,
          AFont.PitchAndFamily, False, nil, AFont is TdxPDFType3Font);
      InternalAdd(AFont);
      Result := FLastRegisteredFontData;
    end;
  finally
    LeaveCriticalSection(FLock);
  end;
end;

function TdxPDFFontDataStorage.TryGetValue(ANumber: Integer; out AFont: TdxPDFCustomFont): Boolean;
var
  AObject: TdxPDFBase;
begin
  AFont := nil;
  Result :=  FReferences.TryGetValue(ANumber, AObject);
  if Result then
    AFont := AObject as TdxPDFCustomFont;
end;

procedure TdxPDFFontDataStorage.Clear;
var
  AData: TdxPDFFontRegistrationData;
  AFont: TdxPDFCustomFont;
begin
  FQueue.Clear;
  for AFont in FDictionary.Keys do
    RemoveListener(AFont);
  for AData in FDictionary.Values do
    if AData.Registrator <> nil then
      AData.Registrator.Free;
  FDictionary.Clear;
  FReferences.Clear;
end;

procedure TdxPDFFontDataStorage.Delete(AFont: TdxPDFCustomFont);
var
  ARegistrationData: TdxPDFFontRegistrationData;
  ARegistrator: TdxPDFFontCustomRegistrator;
begin
  if FDictionary.TryGetValue(AFont, ARegistrationData) then
  begin
    if FLastRegisteredFont = AFont then
      FLastRegisteredFont := nil;
    FDictionary.Remove(AFont);
    FReferences.Remove(AFont.UniqueName);
    FQueue.Remove(AFont);
    ARegistrator := ARegistrationData.Registrator as TdxPDFFontCustomRegistrator;
    if ARegistrator <> nil then
      ARegistrator.Free;
  end;
end;

procedure TdxPDFFontDataStorage.InternalAdd(AFont: TdxPDFCustomFont);
var
  I: Integer;
begin
  if FQueue.Count > dxPDFDocumentFontCacheSize then
    for I := 0 to FQueue.Count - 1 do
      Delete(FQueue[0]);
  FReferences.Add(AFont.UniqueName, AFont.Number, AFont);
  FDictionary.Add(AFont, FLastRegisteredFontData);
  FQueue.Add(AFont);
  AFont.AddListener(Self);
end;

procedure TdxPDFFontDataStorage.RemoveListener(AFont: TdxPDFCustomFont);
begin
  AFont.RemoveListener(Self);
end;

procedure TdxPDFFontDataStorage.FontDestroyHandler(Sender: TdxPDFBase);
begin
  Delete(Sender as TdxPDFCustomFont);
end;

{ TdxPDFXObjects }

class function TdxPDFXObjects.GetTypeName: string;
begin
  Result := TdxPDFKeywords.XObject;
end;

class function TdxPDFXObjects.GetTypePrefix: string;
begin
  Result := 'O';
end;

function TdxPDFXObjects.GetXObject(const AName: string): TdxPDFXObject;
begin
  Result := GetObject(AName) as TdxPDFXObject;
end;

{ TdxPDFColorSpaces }

class function TdxPDFColorSpaces.GetTypeName: string;
begin
  Result := TdxPDFKeywords.ColorSpace;
end;

function TdxPDFColorSpaces.GetColorSpace(const AName: string): TdxPDFCustomColorSpace;
begin
  Result := GetObject(AName) as TdxPDFCustomColorSpace;
  if Result = nil then
    Result := Repository.CreateColorSpace(AName, nil);
end;

class function TdxPDFColorSpaces.GetTypePrefix: string;
begin
  Result := 'CS';
end;

procedure TdxPDFColorSpaces.Read(ADictionary: TdxPDFReaderDictionary);
begin
  ReadList(ADictionary);
end;

procedure TdxPDFColorSpaces.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  WriteList(AHelper, ADictionary);
end;

{ TdxPDFCustomShading }

class function TdxPDFCustomShading.GetTypeName: string;
begin
  Result := 'ShadingItem';
end;

function TdxPDFCustomShading.TransformFunction(const AArguments: TDoubleDynArray): TdxPDFColor;
var
  AIndex: Integer;
  AComponents, AColorComponents: TDoubleDynArray;
begin
  if (FFunctions = nil) or (FFunctions.Count = 0) then
    Result := TdxPDFColor.Create(FColorSpace.Transform(AArguments))
  else
  begin
    if FFunctions.Count = 1 then
      AColorComponents := (FFunctions[0] as TdxPDFCustomFunction).CreateTransformedComponents(AArguments)
    else
    begin
      SetLength(AColorComponents, FFunctions.Count);
      SetLength(AComponents, 1);
      AComponents[0] := 0;
      for AIndex := 0 to FFunctions.Count - 1 do
        TdxPDFUtils.AddData((FFunctions[AIndex] as TdxPDFCustomFunction).CreateTransformedComponents(AComponents), AColorComponents);
    end;
    Result := TdxPDFColor.Create(FColorSpace.Transform(AColorComponents));
  end;
end;

procedure TdxPDFCustomShading.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FColorSpace := nil;
  FBackgroundColor := TdxPDFColor.Null;
  FFunctions := nil;
end;

procedure TdxPDFCustomShading.DestroySubClasses;
begin
  FreeAndNil(FColorSpace);
  FreeAndNil(FFunctions);
  inherited DestroySubClasses;
end;

procedure TdxPDFCustomShading.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  if ADictionary.Contains(TdxPDFKeywords.ColorSpace) then
  begin
    ReadColorSpace(ADictionary.GetObject(TdxPDFKeywords.ColorSpace));
    ReadBackgroundColor(ADictionary.GetArray(TdxPDFKeywords.Background));
    ReadFunctions(ADictionary.GetObject(TdxPDFKeywords.Function));
    FBoundingBox := ADictionary.GetRectangleEx(TdxPDFKeywords.BBox);
    FUseAntiAliasing := ADictionary.GetBoolean(TdxPDFKeywords.AntiAlias, False);
  end;
end;

procedure TdxPDFCustomShading.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  ADictionary.Add(TdxPDFKeywords.ShadingType, GetShadingType);
  ADictionary.Add(TdxPDFKeywords.ColorSpace, ColorSpace);
  ADictionary.Add(TdxPDFKeywords.Background, BackgroundColor);
  ADictionary.Add(TdxPDFKeywords.BBox, BoundingBox);
  ADictionary.Add(TdxPDFKeywords.AntiAlias, UseAntiAliasing);
  WriteFunctions(AHelper, ADictionary);
end;

class function TdxPDFCustomShading.GetShadingType: Integer;
begin
  Result := -1;
end;

function TdxPDFCustomShading.GetDomainDimension: Integer;
begin
  Result := 1;
end;

function TdxPDFCustomShading.IsFunctionRequired: Boolean;
begin
  Result := True;
end;

function TdxPDFCustomShading.CreateFunctions(ARawObject: TdxPDFBase): TdxPDFReferencedObjects;
var
  ATempObject: TdxPDFBase;
begin
  Result := TdxPDFReferencedObjects.Create;
  if ARawObject.ObjectType = otArray then
    for ATempObject in TdxPDFArray(ARawObject).ElementList do
      Result.Add(TdxPDFCustomFunction.Parse(Repository, ATempObject))
  else
    Result.Add(TdxPDFCustomFunction.Parse(Repository, ARawObject));
end;

procedure TdxPDFCustomShading.ReadBackgroundColor(ARawObject: TdxPDFArray);
begin
  if ARawObject <> nil then
  begin
    FBackgroundColor := TdxPDFColor.Create(ARawObject);
    if Length(FBackgroundColor.Components) <> ARawObject.Count then
      TdxPDFUtils.RaiseTestException('Incorrect background color component count');
  end;
end;

procedure TdxPDFCustomShading.ReadColorSpace(ARawObject: TdxPDFBase);
begin
  FColorSpace := Repository.CreateColorSpace(ARawObject);
  if FColorSpace is TdxPDFPatternColorSpace then
    TdxPDFUtils.RaiseTestException;
end;

procedure TdxPDFCustomShading.ReadFunctions(ARawObject: TdxPDFBase);
begin
  if ARawObject <> nil then
  begin
    FreeAndNil(FFunctions);
    FFunctions := CreateFunctions(Repository.ResolveReference(ARawObject));
  end
  else
  begin
    if IsFunctionRequired then
      TdxPDFUtils.Abort;
  end;
end;

procedure TdxPDFCustomShading.WriteFunctions(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
var
  AArray: TdxPDFWriterArray;
  I: Integer;
begin
  if FFunctions.Count > 1 then
  begin
    AArray := AHelper.CreateArray;
    for I := 0 to FFunctions.Count - 1 do
      AArray.AddReference(FFunctions[I] as TdxPDFCustomFunction);
  end
  else
    if FFunctions.Count = 1 then
      ADictionary.AddReference(TdxPDFKeywords.Function, FFunctions[0] as TdxPDFCustomFunction);
end;

{ TdxPDFShadings }

class function TdxPDFShadings.GetTypeName: string;
begin
  Result := TdxPDFKeywords.Shading;
end;

function TdxPDFShadings.GetShading(const AName: string): TdxPDFCustomShading;
begin
  Result := GetObject(AName) as TdxPDFCustomShading;
end;

class function TdxPDFShadings.GetTypePrefix: string;
begin
  Result := 'S';
end;

procedure TdxPDFShadings.Read(ADictionary: TdxPDFReaderDictionary);
begin
  ReadList(ADictionary);
end;

procedure TdxPDFShadings.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  WriteList(AHelper, ADictionary);
end;

{ TdxPDFCustomPattern }

class function TdxPDFCustomPattern.GetTypeName: string;
begin
  Result := TdxPDFKeywords.Pattern;
end;

class function TdxPDFCustomPattern.GetPatternType: Integer;
begin
  Result := -MaxInt;
end;

procedure TdxPDFCustomPattern.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  FMatrix := ADictionary.GetMatrix(TdxPDFKeywords.Matrix);
end;

procedure TdxPDFCustomPattern.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  ADictionary.Add(TdxPDFKeywords.PatternType, GetPatternType);
  ADictionary.Add(TdxPDFKeywords.Matrix, Matrix);
end;

{ TdxPDFPatterns }

class function TdxPDFPatterns.GetTypeName: string;
begin
  Result := TdxPDFKeywords.Pattern;
end;

function TdxPDFPatterns.GetPattern(const AName: string): TdxPDFCustomPattern;
begin
  Result := GetObject(AName) as TdxPDFCustomPattern;
end;

procedure TdxPDFPatterns.Read(ADictionary: TdxPDFReaderDictionary);
begin
  ReadList(ADictionary);
end;

procedure TdxPDFPatterns.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  WriteList(AHelper, ADictionary);
end;

class function TdxPDFPatterns.GetTypePrefix: string;
begin
  Result := 'Ptrn';
end;

{ TdxPDFShadingPattern }

class function TdxPDFShadingPattern.GetPatternType: Integer;
begin
  Result := 2;
end;

procedure TdxPDFShadingPattern.CreateSubClasses;
begin
  Shading := nil;
  GraphicsState := nil;
  inherited CreateSubClasses;
end;

procedure TdxPDFShadingPattern.DestroySubClasses;
begin
  GraphicsState := nil;
  Shading := nil;
  inherited DestroySubClasses;
end;

procedure TdxPDFShadingPattern.DoRead(ADictionary: TdxPDFReaderDictionary);
var
  AObject: TdxPDFBase;
begin
  if ADictionary.TryGetObject(TdxPDFKeywords.Shading, AObject) then
    Shading := Repository.CreateShading(AObject);
  GraphicsState := Repository.CreateGraphicsStateParameters;
  GraphicsState.Read(ADictionary.GetDictionary(TdxPDFKeywords.ExtGState));
  inherited DoRead(ADictionary);
end;

procedure TdxPDFShadingPattern.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.AddInline(TdxPDFKeywords.Shading, Shading);
  if GraphicsState.AssignedValues <> [] then
    ADictionary.AddInline(TdxPDFKeywords.ExtGState, GraphicsState);
end;

procedure TdxPDFShadingPattern.SetGraphicsStateParameters(const AValue: TdxPDFGraphicsStateParameters);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FGraphicsState));
end;

procedure TdxPDFShadingPattern.SetShading(const AValue: TdxPDFCustomShading);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FShading));
end;

{ TdxPDFTilingPattern }

constructor TdxPDFTilingPattern.Create(ARepository: TdxPDFDocumentRepository;
  const AMatrix: TdxPDFTransformationMatrix; const ABoundingBox: TdxPDFRectangle; const AXStep, AYStep: Double;
  AColored: Boolean);
begin
  inherited CreateEx(ARepository);
end;

function TdxPDFTilingPattern.CreateMatrix(AWidth: Integer; AHeight: Integer): TdxPDFTransformationMatrix;
var
  AFactorX, AFactorY: Double;
begin
  AFactorX := AWidth / Abs(FBoundingBox.Width);
  AFactorY := AHeight / Abs(FBoundingBox.Height);
  Result := TdxPDFTransformationMatrix.Create;
  Result.Assign(AFactorX, 0, 0, AFactorY, -FBoundingBox.Left * AFactorX, -FBoundingBox.Bottom * AFactorY);
end;

class function TdxPDFTilingPattern.GetPatternType: Integer;
begin
  Result := 1;
end;

procedure TdxPDFTilingPattern.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FCommands := nil;
  FColoredPaintType := 1;
  FUncoloredPaintType := 2;
  FColored := True;
  Resources := nil;
end;

procedure TdxPDFTilingPattern.DestroySubClasses;
begin
  Resources := nil;
  FreeAndNil(FCommands);
  inherited DestroySubClasses;
end;

procedure TdxPDFTilingPattern.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  FColored := ADictionary.GetInteger(TdxPDFKeywords.PaintType, 1) = 1;
  FTilingType := TdxPDFTilingType(ADictionary.GetInteger(TdxPDFKeywords.TilingType, 0));
  FBoundingBox := ADictionary.GetRectangleEx(TdxPDFKeywords.BBox);
  Resources := Repository.CreateResources(ADictionary);

  FXStep := ADictionary.GetDouble(TdxPDFKeywords.XStep, 1);
  FYStep := ADictionary.GetDouble(TdxPDFKeywords.YStep, 1);

  FCommands := TdxPDFCommandList.Create;
  FCommands.Read(ADictionary.StreamRef, Repository, Resources);
end;

procedure TdxPDFTilingPattern.Initialize;
begin
  inherited Initialize;
  FColoredPaintType := 1;
  FUncoloredPaintType := 2;
end;

procedure TdxPDFTilingPattern.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.Add(TdxPDFKeywords.TilingType, Ord(FTilingType));
  ADictionary.Add(TdxPDFKeywords.PaintType, 1 + Ord(FColored = False));
  ADictionary.Add(TdxPDFKeywords.BBox, FBoundingBox);
  ADictionary.Add(TdxPDFKeywords.XStep, FXStep);
  ADictionary.Add(TdxPDFKeywords.YStep, FYStep);
  ADictionary.AddReference(TdxPDFKeywords.Resources, Resources);
  Commands.Write(AHelper, ADictionary, Resources);
end;

procedure TdxPDFTilingPattern.ReplaceCommands(const AData: TBytes);
begin
  FreeAndNil(FCommands);
  FCommands := TdxPDFCommandList.Create;
  FCommands.Read(AData, Repository, Resources);
end;

{ TdxPDFFullTrustGlyphMapper }

constructor TdxPDFFullTrustGlyphMapper.Create(AFontFile: TdxFontFile);
var
  AIsSymbolic: Boolean;
  AComparison: TComparison<TdxFontFileCMapCustomFormatRecord>;
begin
  inherited Create;
  FFontFile := AFontFile;
  FMappedGlyphsCache := TdxPDFIntegerIntegerDictionary.Create;

  if FFontFile.HheaTable = nil then
    FFactor := 1000 / 2048
  else
    FFactor := 1000.0 / AFontFile.HeadTable.UnitsPerEm;

  FCMapTables := TList<TdxFontFileCMapCustomFormatRecord>.Create;
  if AFontFile.CMapTable <> nil then
  begin
    FCMapTables.AddRange(AFontFile.CMapTable.CMapTables);
    AIsSymbolic := (AFontFile.OS2Table <> nil) and AFontFile.OS2Table.IsSymbolic;
    AComparison :=
      function(const Left, Right: TdxFontFileCMapCustomFormatRecord): Integer
      begin
        Result := GetCMapEntryPriority(Left, AIsSymbolic) - GetCMapEntryPriority(Right, AIsSymbolic);
      end;
    FCMapTables.Sort(TComparer<TdxFontFileCMapCustomFormatRecord>.Construct(AComparison));
  end;
end;

destructor TdxPDFFullTrustGlyphMapper.Destroy;
begin
  FreeAndNil(FCMapTables);
  FreeAndNil(FMappedGlyphsCache);
  inherited Destroy;
end;

class function TdxPDFFullTrustGlyphMapper.GetCMapEntryPriority(AEntry: TdxFontFileCMapCustomFormatRecord;
  AIsSymbolic: Boolean): Integer;
begin
  case AEntry.PlatformId of
    TdxFontFilePlatformID.Microsoft:
      Result := 0;
    TdxFontFilePlatformID.ISO:
      Result := 100;
  else
    Result := 200;
  end;
  case AEntry.EncodingId of
    TdxFontFileEncodingID.UGL:
      Inc(Result, IfThen(AIsSymbolic, 10, 0));
    TdxFontFileEncodingID.Undefined:
      Inc(Result, IfThen(AIsSymbolic, 0, 10));
  else
    Inc(Result, 20);
  end;
  if not (AEntry is TdxFontFileCMapSegmentMappingRecord) then
    Inc(Result, 1);
end;

function TdxPDFFullTrustGlyphMapper.GetGlyphIndex(ACharacter: Char): Integer;
var
  ACMap: TdxFontFileCMapCustomFormatRecord;
begin
  Result := 0;
  if not FMappedGlyphsCache.TryGetValue(Integer(ACharacter), Result) then
  begin
    for ACMap in FCMapTables do
    begin
      Result := ACMap.MapCode(ACharacter);
      if Result <> TdxFontFileCMapCustomFormatRecord.NotdefGlyphIndex then
        Break;
    end;
    FMappedGlyphsCache.Add(Integer(ACharacter), Result);
  end;
end;

function TdxPDFFullTrustGlyphMapper.MapString(const AStr: string; AFlags: TdxPDFGlyphMappingFlags): TdxPDFGlyphMappingResult;
begin
  Result := MapStringWithoutCTL(AStr, AFlags);
end;

function TdxPDFFullTrustGlyphMapper.IsWritingOrderControl(AChar: Char): Boolean;
begin
  Result := False;
end;

function TdxPDFFullTrustGlyphMapper.MapStringWithoutCTL(const AStr: string;
  AFlags: TdxPDFGlyphMappingFlags): TdxPDFGlyphMappingResult;
var
  AActualText: string;
  ABuilder: TStringBuilder;
  ACh: Char;
  ACodes: TBytes;
  AGlyph: TdxPDFGlyph;
  AGlyphIndices: TdxIntegerList;
  AGlyphOffset: Double;
  AGlyphs: TdxPDFGlyphList;
  AKern: TdxFontFileKernTable;
  AKerningShouldBeUsed: Boolean;
  ALength, I, AVal: Integer;
  AResult: TdxPDFIntegerStringDictionary;
begin
  ALength := Length(AStr);
  AGlyphIndices := TdxIntegerList.Create;
  try
    ABuilder := TdxStringBuilderManager.Get(ALength);
    try
      if FCMapTables <> nil then
        for I := 1 to ALength do
        begin
          ACh := AStr[I];
          if not IsWritingOrderControl(ACh) then
          begin
            AGlyphIndices.Add(GetGlyphIndex(ACh));
            ABuilder.Append(ACh);
          end;
        end;
      AResult := TdxPDFIntegerStringDictionary.Create(ALength);
      AGlyphs := TdxPDFGlyphList.Create;
      ALength := AGlyphIndices.Count;
      SetLength(ACodes, ALength * 2);

      AKern := FFontFile.KernTable;
      AKerningShouldBeUsed := HasFlag(AFlags, mfUseKerning) and (AKern <> nil) and (AGlyphIndices <> nil);
      AActualText := ABuilder.ToString;
    finally
      TdxStringBuilderManager.Release(ABuilder);
    end;

    for I := 0 to ALength - 1 do
    begin
      ACh := AActualText[I + 1];
      if AGlyphIndices = nil then
        AVal := Integer(ACh)
      else
        AVal := AGlyphIndices[I];
      AGlyphOffset := 0;
      if AKerningShouldBeUsed and (I > 0) then
        AGlyphOffset := -AKern.GetKerning(AGlyphIndices[I - 1], AVal) * FFactor;
      AGlyph := CreateGlyph(AVal, ACh, FFontFile.GetCharacterWidth(AVal), AGlyphOffset);
      if not AResult.ContainsKey(AGlyph.Index) then
        AResult.Add(AGlyph.Index, ACh);
      AGlyphs.Add(AGlyph);
    end;
    Result := TdxPDFGlyphMappingResult.Create(CreateGlyphRun(AGlyphs), AResult);
  finally
    AGlyphIndices.Free;
  end;
end;

{ TdxPDFEmbeddedGlyphMapper }

function TdxPDFEmbeddedGlyphMapper.CreateGlyphRun: TdxPDFGlyphRun;
begin
  Result := TdxPDFCompositeFontGlyphRun.Create;
end;

function TdxPDFEmbeddedGlyphMapper.CreateGlyph(AGlyphIndex: Integer; ACh: Char; AWidth, AGlyphOffset: Double): TdxPDFGlyph;
begin
  Result := TdxPDFGlyph.Create(AGlyphIndex, AWidth, AGlyphOffset);
end;

function TdxPDFEmbeddedGlyphMapper.CreateGlyphRun(const AGlyphs: TdxPDFGlyphList): TdxPDFGlyphRun;
begin
  Result := TdxPDFCompositeFontGlyphRun2.Create(AGlyphs);
end;

{ TdxPDFFontProvider }

constructor TdxPDFFontProvider.Create(const AFolderName: string);
begin
  inherited Create;
  FFolderName := AFolderName;
  FSubstitutionHelper := TdxPDFGDIFontSubstitutionHelper.Create;
  FCache := TdxPDFGDIEditableFontDataCache.Create(FontFamilyInfos);
end;

function TdxPDFFontProvider.CreateSubstituteFontData(AFont: TdxPDFCustomFont): TdxPDFFontRegistrationData;
var
  AFontRegistrator: TdxPDFFontCustomRegistrator;
begin
  AFontRegistrator := TdxPDFFontCustomRegistrator.CreateRegistrator(SubstitutionHelper, AFont, FFolderName);
  try
    Result := AFontRegistrator.CreateSubstituteFontData;
  finally
    AFontRegistrator.Free;
  end;
end;

destructor TdxPDFFontProvider.Destroy;
begin
  FreeAndNil(FCache);
  FreeAndNil(FSubstitutionHelper);
  inherited;
end;

procedure TdxPDFFontProvider.CalculateFontParameters(ACommand: TdxPDFCustomCommand; out AFontName: string;
  out AFontStyles: TFontStyles; var APitchAndFamily: Byte; var AIsEmptyFontName: Boolean);
var
  ARegistrationData: TdxPDFFontRegistrationData;
begin
  AFontStyles := [];
  if (ACommand is TdxPDFSetTextFontCommand) and (TdxPDFSetTextFontCommand(ACommand).Font <> nil) then
  begin
    ARegistrationData := CreateSubstituteFontData(TdxPDFSetTextFontCommand(ACommand).Font);
    if ARegistrationData.Weight > 400 then
      Include(AFontStyles, fsBold);
    if ARegistrationData.Italic then
      Include(AFontStyles, fsItalic);
    AFontName := ARegistrationData.Name;
    APitchAndFamily := ARegistrationData.PitchAndFamily;
  end
  else
    AFontName := TdxPDFSetTextFontCommand(ACommand).FontName;
  AIsEmptyFontName := AFontName = '';
  if AIsEmptyFontName then
    AFontName := TdxPDFKeywords.TimesNewRomanFontName2;
end;

procedure TdxPDFFontProvider.Clear;
begin
  (FCache as TdxPDFGDIEditableFontDataCache).Clear;
end;

function TdxPDFFontProvider.GetFontFamilyInfos: TdxFontFamilyInfos;
begin
  Result := FSubstitutionHelper.FontFamilyInfos;
end;

function TdxPDFFontProvider.GetMatchingFont(const AFontFamily: string; AStyles: TFontStyles): TObject;
begin
  Result := (FCache as TdxPDFGDIEditableFontDataCache).SearchFontData(AFontFamily,
    TdxGPFontStyle(dxFontStylesToGpFontStyles(AStyles)));
end;

function TdxPDFFontProvider.GetMatchingFont(AFontCommand: TdxPDFCustomCommand): TObject;
var
  AFontName: string;
  AFontStyles: TFontStyles;
  AIsEmptyFontName: Boolean;
  APitchAndFamily: Byte;
begin
  if AFontCommand <> nil then
  begin
    AIsEmptyFontName := False;
    APitchAndFamily := DEFAULT_PITCH;
    CalculateFontParameters(AFontCommand, AFontName, AFontStyles, APitchAndFamily, AIsEmptyFontName);
    Result := GetMatchingFont(AFontName, AFontStyles);
    if (Result = nil) and not AIsEmptyFontName then
      if TdxStringHelper.Contains(AFontName, TdxPDFKeywords.TimesNewRomanFontName2) or
        TdxStringHelper.Contains(AFontName, TdxPDFKeywords.TimesNewRomanFontName) then
        Result := GetMatchingFont(TdxPDFKeywords.TimesNewRomanFontName, AFontStyles)
      else
        if TdxStringHelper.Contains(AFontName, TdxPDFKeywords.CourierFontName) then
          Result := GetMatchingFont(TdxPDFKeywords.CourierFontName, AFontStyles)
        else
          if TdxStringHelper.Contains(AFontName, TdxPDFKeywords.ArialFontName) then
            Result := GetMatchingFont(TdxPDFKeywords.ArialFontName, AFontStyles)
          else
            if APitchAndFamily = FF_ROMAN then
              Result := GetMatchingFont(TdxPDFKeywords.TimesNewRomanFontName2, AFontStyles)
            else
              if APitchAndFamily = FIXED_PITCH then
                Result := GetMatchingFont(TdxPDFKeywords.CourierNewFontName2, AFontStyles)
              else
                Result := GetMatchingFont(TdxPDFKeywords.ArialFontName, AFontStyles);
  end
  else
    Result := GetMatchingFont(TdxPDFKeywords.TimesNewRomanFontName2, []);
end;

{ TdxPDFStreamObject }

procedure TdxPDFStreamObject.CreateSubClasses;
begin
  inherited CreateSubClasses;
  Stream := nil;
end;

procedure TdxPDFStreamObject.DestroySubClasses;
begin
  Stream := nil;
  inherited DestroySubClasses;
end;

procedure TdxPDFStreamObject.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  WriteData(AHelper, ADictionary);
end;

procedure TdxPDFStreamObject.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  if Stream = nil then
    Stream := Repository.GetStream(ADictionary.Number);
end;

function TdxPDFStreamObject.UncompressData(AFilters: TObject): TBytes;
begin
  Result := Stream.UncompressData(AFilters, True);
end;

procedure TdxPDFStreamObject.SetStreamData(const AData: TBytes);
begin
  if Stream = nil then
    Stream := TdxPDFStream.Create(AData)
  else
    TdxPDFBaseStreamAccess(Stream).SetData(AData);
end;

procedure TdxPDFStreamObject.WriteData(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  ADictionary.SetStreamData(GetData);
end;

function TdxPDFStreamObject.GetData: TBytes;
begin
  if Stream <> nil then
    Result := Stream.DecryptedData
  else
    SetLength(Result, 0);
end;

function TdxPDFStreamObject.GetUncompressedData: TBytes;
begin
  if Stream <> nil then
    Result := Stream.UncompressedData
  else
    SetLength(Result, 0);
end;

procedure TdxPDFStreamObject.SetStream(const AValue: TdxPDFStream);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FStream));
end;

{ TdxPDFResources }

class function TdxPDFResources.GetTypeName: string;
begin
  Result := TdxPDFKeywords.Resources;
end;

function TdxPDFResources.AddFont(AFont: TdxPDFCustomFont): string;
begin
  Result := Fonts.Add(AFont);
end;

function TdxPDFResources.GetColorSpace(const AName: string): TdxPDFCustomColorSpace;
var
  AParentResources: TdxPDFResources;
begin
  Result := InternalGetColorSpace(AName);
  if Result = nil then
  begin
    AParentResources := GetParentResources;
    if AParentResources <> nil then
      Result := AParentResources.GetColorSpace(AName);
  end;
end;

function TdxPDFResources.GetFont(const AName: string): TdxPDFCustomFont;
var
  AParentResources: TdxPDFResources;
begin
  Result := InternalGetFont(AName);
  if Result = nil then
  begin
    AParentResources := GetParentResources;
    if AParentResources <> nil then
      Result := AParentResources.GetFont(AName);
  end;
end;

function TdxPDFResources.GetGraphicsStateParameters(const AName: string): TdxPDFGraphicsStateParameters;
var
  AParentResources: TdxPDFResources;
begin
  Result := InternalGetGraphicsStateParameters(AName);
  if Result = nil then
  begin
    AParentResources := GetParentResources;
    if AParentResources <> nil then
      Result := AParentResources.GetGraphicsStateParameters(AName);
  end;
end;

function TdxPDFResources.GetPattern(const AName: string): TdxPDFCustomPattern;
var
  AParentResources: TdxPDFResources;
begin
  Result := InternalGetPattern(AName);
  if Result = nil then
  begin
    AParentResources := GetParentResources;
    if AParentResources <> nil then
      Result := AParentResources.GetPattern(AName);
  end;
end;

function TdxPDFResources.GetShading(const AName: string): TdxPDFCustomShading;
var
  AParentResources: TdxPDFResources;
begin
  Result := InternalGetShading(AName);
  if Result = nil then
  begin
    AParentResources := GetParentResources;
    if AParentResources <> nil then
      Result := AParentResources.GetShading(AName);
  end;
end;

function TdxPDFResources.GetXObject(const AName: string): TdxPDFXObject;
var
  AParentResources: TdxPDFResources;
begin
  Result := InternalGetXObject(AName);
  if Result = nil then
  begin
    AParentResources := GetParentResources;
    if AParentResources <> nil then
      Result := AParentResources.GetXObject(AName);
  end;
end;

function TdxPDFResources.GetProperties(const AName: string): TdxPDFCustomProperties;
begin
  Result := nil;
end;

procedure TdxPDFResources.Pack;
begin
  if (ReferenceCount = 1) or Repository.IsResourcesShared(Self) and (ReferenceCount <= 2) then
    Clear;
end;

procedure TdxPDFResources.CreateSubClasses;
begin
  inherited CreateSubClasses;
  InitializeCriticalSectionAndSpinCount(FLock, 1024);
end;

procedure TdxPDFResources.DestroySubClasses;
begin
  Clear;
  Dictionary := nil;
  DeleteCriticalSection(FLock);
  inherited DestroySubClasses;
end;

procedure TdxPDFResources.Initialize;
begin
  inherited Initialize;
  FID := TdxPDFUtils.GenerateGUID;
end;

procedure TdxPDFResources.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  Dictionary := ADictionary;
end;

procedure TdxPDFResources.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
var
  AArray: TdxPDFArray;
begin
  inherited Write(AHelper, ADictionary);

  AArray := TdxPDFArray.Create;
  AArray.AddName('PDF');
  AArray.AddName('Text');
  AArray.AddName('ImageB');
  AArray.AddName('ImageC');
  AArray.AddName('ImageI');
  ADictionary.Add('ProcSet', AArray);

  ADictionary.Add(TdxPDFColorSpaces.GetTypeName, ColorSpaces);
  ADictionary.Add(TdxPDFFonts.GetTypeName, Fonts);
  ADictionary.Add(TdxPDFGraphicsStateParametersList.GetTypeName, GraphicStatesParametersList);
  ADictionary.Add(TdxPDFPatterns.GetTypeName, Patterns);
  ADictionary.Add(TdxPDFShadings.GetTypeName, Shadings);
  ADictionary.Add(TdxPDFXObjects.GetTypeName, XObjects);
end;

function TdxPDFResources.GetParentResources: TdxPDFResources;
begin
  if Parent is TdxPDFPageData then
    Result := TdxPDFPageData(Parent).Resources
  else
    if Parent is TdxPDFPageList then
      Result := TdxPDFPageList(Parent).Resources
    else
      Result := nil;
end;

function TdxPDFResources.InternalGetColorSpace(const AName: string): TdxPDFCustomColorSpace;
begin
  Result := ColorSpaces.GetColorSpace(AName);
end;

function TdxPDFResources.InternalGetFont(const AName: string): TdxPDFCustomFont;
begin
  Result := Fonts.GetFont(AName);
end;

function TdxPDFResources.InternalGetGraphicsStateParameters(const AName: string): TdxPDFGraphicsStateParameters;
begin
  Result := GraphicStatesParametersList.GetParameters(AName) as TdxPDFGraphicsStateParameters;
end;

function TdxPDFResources.InternalGetPattern(const AName: string): TdxPDFCustomPattern;
begin
  Result := Patterns.GetPattern(AName);
end;

function TdxPDFResources.InternalGetShading(const AName: string): TdxPDFCustomShading;
begin
  Result := Shadings.GetShading(AName);
end;

function TdxPDFResources.InternalGetXObject(const AName: string): TdxPDFXObject;
begin
  Result := XObjects.GetXObject(AName);
end;

function TdxPDFResources.TryGetColorSpaceName(AObject: TdxPDFCustomColorSpace; out AName: string): Boolean;
begin
  Result := TryGetResourceName(FColorSpaces, AObject, AName);
end;

function TdxPDFResources.TryGetResourceName(AResources: TdxPDFObjectList; AObject: TdxPDFCustomColorSpace;
  out AName: string): Boolean;
begin
  Result := (AResources <> nil) and AResources.TryGetObjectName(AObject, AName);
end;

function TdxPDFResources.AddGraphicsStateParameters(AParameters: TdxPDFGraphicsStateParameters): string;
begin
  Result := GraphicStatesParametersList.Add(AParameters);
end;

function TdxPDFResources.AddPattern(APattern: TdxPDFCustomPattern): string;
begin
  Result := Patterns.Add(APattern);
end;

function TdxPDFResources.AddXObject(AObject: TdxPDFXObject): string;
begin
  Result := XObjects.Add(AObject);
end;

procedure TdxPDFResources.FillWidgetAppearanceResources(AResources: TdxPDFResources);
begin
  PerformWithoutChanges(
    procedure
    begin
      GraphicStatesParametersList.AssignTo(AResources.GraphicStatesParametersList);
      ColorSpaces.AssignTo(AResources.ColorSpaces);
      Patterns.AssignTo(AResources.Patterns);
      Shadings.AssignTo(AResources.Shadings);
      XObjects.AssignTo(AResources.XObjects);
    end);
end;

function TdxPDFResources.GetColorSpaces: TdxPDFColorSpaces;
begin
  GetList(FColorSpaces, TdxPDFColorSpaces, TdxPDFKeywords.ColorSpace);
  Result := FColorSpaces;
end;

function TdxPDFResources.GetFonts: TdxPDFFonts;
begin
  GetList(FFonts, TdxPDFFonts, TdxPDFKeywords.Font);
  Result := FFonts;
end;

procedure TdxPDFResources.GetList(var AVariable; AClass: TdxPDFObjectListClass; const AKey: string; AInitProc: TListInitProc = nil);
begin
  if TdxPDFObjectList(AVariable) = nil then
  begin
    EnterCriticalSection(FLock);
    try
      if TdxPDFObjectList(AVariable) = nil then
      begin
        TdxPDFObjectList(AVariable) := AClass.Create(Self);
        if Dictionary <> nil then
          TdxPDFObjectList(AVariable).Read(Dictionary.GetDictionary(AKey));
        if Assigned(AInitProc) then
          AInitProc(TdxPDFObjectList(AVariable));
      end;
    finally
      LeaveCriticalSection(FLock);
    end;
  end;
end;

function TdxPDFResources.GetGraphicStatesParametersList: TdxPDFGraphicsStateParametersList;
begin
  GetList(FGraphicStatesParametersList, TdxPDFGraphicsStateParametersList, TdxPDFKeywords.ExtGState);
  Result := FGraphicStatesParametersList;
end;

function TdxPDFResources.GetPatterns: TdxPDFPatterns;
begin
  GetList(FPatterns, TdxPDFPatterns, TdxPDFKeywords.Pattern);
  Result := FPatterns;
end;

function TdxPDFResources.GetShadings: TdxPDFShadings;
begin
  GetList(FShadings, TdxPDFShadings, TdxPDFKeywords.Shading);
  Result := FShadings;
end;

function TdxPDFResources.GetXObjects: TdxPDFXObjects;
begin
  GetList(FXObjects, TdxPDFXObjects, TdxPDFKeywords.XObject, InitXObjects);
  Result := FXObjects;
end;

procedure TdxPDFResources.InitXObjects(AList: TdxPDFObjectList);
begin
  AList.Enum(
    procedure (AObject: TdxPDFObject)
    begin
      if AObject is TdxPDFXForm then
      begin
        if TdxPDFXForm(AObject).Resources = nil then
          TdxPDFXForm(AObject).Resources := Self;
      end;
    end);
end;

procedure TdxPDFResources.SetColorSpaces(const AValue: TdxPDFColorSpaces);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FColorSpaces));
end;

procedure TdxPDFResources.SetDictionary(const AValue: TdxPDFReaderDictionary);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FDictionary));
end;

procedure TdxPDFResources.SetFonts(const AValue: TdxPDFFonts);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FFonts));
end;

procedure TdxPDFResources.SetGraphicStatesParametersList(const AValue: TdxPDFGraphicsStateParametersList);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FGraphicStatesParametersList));
end;

procedure TdxPDFResources.SetPatterns(const AValue: TdxPDFPatterns);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FPatterns));
end;

procedure TdxPDFResources.SetShadings(const AValue: TdxPDFShadings);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FShadings));
end;

procedure TdxPDFResources.SetXObjects(const AValue: TdxPDFXObjects);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FXObjects));
end;

procedure TdxPDFResources.Clear;
begin
  Patterns := nil;
  Shadings := nil;
  XObjects := nil;
  GraphicStatesParametersList := nil;
  Fonts := nil;
  ColorSpaces := nil;
end;

{ TdxPDFPageContents }

class function TdxPDFPageContents.GetTypeName: string;
begin
  Result := TdxPDFKeywords.Contents;
end;

function TdxPDFPageContents.GetData: TBytes;
var
  I: Integer;
begin
  SetLength(Result, 0);
  for I := 0 to ContentList.Count - 1 do
  begin
    TdxPDFUtils.AddData((ContentList[I] as TdxPDFStreamObject).Stream.UncompressedData, Result);
    TdxPDFUtils.AddByte(TdxPDFDefinedSymbols.Space, Result);
  end;
end;

procedure TdxPDFPageContents.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FCommands := TdxPDFCommandList.Create;
  FContentList := TdxPDFReferencedObjects.Create;
end;

procedure TdxPDFPageContents.DestroySubClasses;
begin
  FreeAndNil(FContentList);
  FreeAndNil(FCommands);
  inherited DestroySubClasses;
end;

procedure TdxPDFPageContents.Read(ADictionary: TdxPDFReaderDictionary);
begin
  inherited Read(ADictionary);
  ReadContentList(ADictionary, ADictionary.GetObject(TdxPDFKeywords.Contents));
end;

procedure TdxPDFPageContents.WriteData(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  ADictionary.SetStreamData(Commands.ToByteArray(AHelper.Context, Resources));
end;

procedure TdxPDFPageContents.ClearCommands;
begin
  Commands.Clear;
  ContentList.Clear;
end;

procedure TdxPDFPageContents.PopulateCommands(AResources: TdxPDFResources);
begin
  Commands.Read(CommandsData, Repository, AResources);
end;

procedure TdxPDFPageContents.ReplaceCommands(const AData: TBytes);
var
  AContentItem: TdxPDFPageContentItem;
begin
  ClearCommands;
  AContentItem := TdxPDFPageContentItem.Create(Self);
  AContentItem.SetStreamData(AData);
  ContentList.Add(AContentItem);
end;

function TdxPDFPageContents.GetCommandCount: Integer;
begin
  Result := Commands.GetCommandCount;
end;

function TdxPDFPageContents.GetCommandsData: TBytes;
begin
  Result := GetData;
end;

function TdxPDFPageContents.GetResources: TdxPDFResources;
begin
  Result := (Parent as TdxPDFPageData).Resources;
end;

procedure TdxPDFPageContents.ReadItem(AStream: TdxPDFStream);
var
  AContentItem: TdxPDFPageContentItem;
begin
  AContentItem := TdxPDFPageContentItem.Create(Self);
  AStream.Dictionary.Number := AStream.Number;
  AContentItem.Read(AStream.Dictionary as TdxPDFReaderDictionary);
  TdxPDFDocumentStreamObjectAccess(AContentItem).Stream := AStream;
  ContentList.Add(AContentItem);
end;

procedure TdxPDFPageContents.ReadContentList(ADictionary: TdxPDFReaderDictionary;
  AContentObject: TdxPDFBase);
var
  I: Integer;
  AStream: TdxPDFBase;
begin
  if (AContentObject <> nil) and not ((AContentObject.ObjectType = otDictionary) and
    (TdxPDFDictionary(AContentObject).Count = 0)) then
    case AContentObject.ObjectType of
      otIndirectReference, otDictionary, otStream:
        if GetObject(TdxPDFKeywords.Contents, ADictionary, AStream) then
          if AStream.ObjectType = otStream then
            ReadItem(AStream as TdxPDFStream)
          else
            ReadContentList(ADictionary, AStream);
      otArray:
        for I := 0 to (AContentObject as TdxPDFArray).Count - 1 do
        begin
          AStream := Repository.GetStream((TdxPDFArray(AContentObject)[I] as TdxPDFBase).Number);
          if AStream <> nil then
          begin
            AStream.Number := (TdxPDFArray(AContentObject)[I] as TdxPDFBase).Number;
            if AStream <> nil then
              ReadItem(TdxPDFStream(AStream));
          end;
        end;
    end;
end;

{ TdxPDFPageTreeObject }

procedure TdxPDFPageTreeObject.DestroySubClasses;
begin
  Resources := nil;
  inherited DestroySubClasses;
end;

procedure TdxPDFPageTreeObject.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
var
  AParentNode: TdxPDFPageTreeObject;
begin
  inherited Write(AHelper, ADictionary);

  AParentNode := ParentNode;
  if AParentNode = nil then
  begin
    ADictionary.Add(TdxPDFKeywords.MediaBox, MediaBox);
    ADictionary.Add(TdxPDFKeywords.CropBox, CropBox, MediaBox);
    ADictionary.Add(TdxPDFKeywords.Rotate, RotationAngle, 0);
  end
  else
  begin
    if AHelper.Context.AllowPageParentReference then
    begin
      ADictionary.Add(TdxPDFKeywords.MediaBox, MediaBox, GetParentNodeMediaBox);
      ADictionary.Add(TdxPDFKeywords.CropBox, CropBox, AParentNode.CropBox);
      ADictionary.Add(TdxPDFKeywords.Rotate, RotationAngle, AParentNode.RotationAngle);
      if AParentNode is TdxPDFPageTreeObjectList then
        ADictionary.AddReference(TdxPDFKeywords.Parent, Repository.Catalog.Pages);
    end
    else
    begin
      ADictionary.Add(TdxPDFKeywords.MediaBox, MediaBox);
      ADictionary.Add(TdxPDFKeywords.CropBox, CropBox);
      ADictionary.Add(TdxPDFKeywords.Rotate, RotationAngle);
    end;
  end;
end;

procedure TdxPDFPageTreeObject.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  FArtBox := ADictionary.GetRectangle(TdxPDFKeywords.ArtBox, FArtBox);
  FBleedBox := ADictionary.GetRectangle(TdxPDFKeywords.BleedBox, FBleedBox);
  FCropBox := ADictionary.GetRectangle(TdxPDFKeywords.CropBox, FCropBox);
  FMediaBox := ADictionary.GetRectangle(TdxPDFKeywords.MediaBox, FMediaBox);
  FTrimBox := ADictionary.GetRectangle(TdxPDFKeywords.TrimBox, FTrimBox);
  FUserUnit := ADictionary.GetInteger(TdxPDFKeywords.UserUnit, 1);
  if ADictionary.Contains(TdxPDFKeywords.Rotate) then
  begin
    FRotationAngle := ADictionary.GetInteger(TdxPDFKeywords.Rotate);
    FUseParentRotationAngle := False;
  end;
  Resources := Repository.CreateResources(ADictionary);
end;

procedure TdxPDFPageTreeObject.Initialize;
begin
  inherited Initialize;
  FUseParentRotationAngle := True;
end;

function TdxPDFPageTreeObject.GetLeafCount: Integer;
begin
  Result := 1;
end;

procedure TdxPDFPageTreeObject.Clear;
begin
  DestroySubClasses;
  CreateSubClasses;
  DoChanged;
end;

procedure TdxPDFPageTreeObject.DoAdd(ANode: TdxPDFPageTreeObject);
begin
  DoChanged;
end;

procedure TdxPDFPageTreeObject.DoRemove(ANode: TdxPDFPageTreeObject);
begin
  DoChanged;
end;

function TdxPDFPageTreeObject.GetArtBox: TdxRectF;
begin
  Result := FArtBox;
  if TdxPDFUtils.IsRectEmpty(FArtBox) then
    Result := GetParentNodeArtBox;
  if TdxPDFUtils.IsRectEmpty(Result) then
    Result := CropBox;
end;

function TdxPDFPageTreeObject.GetBleedBox: TdxRectF;
begin
  if TdxPDFUtils.IsRectEmpty(FBleedBox) then
    Result := GetParentNodeBleedBox
  else
    Result := FBleedBox;

  if TdxPDFUtils.IsRectEmpty(Result) then
    Result := CropBox;
end;

function TdxPDFPageTreeObject.GetCropBox: TdxRectF;
begin
  if TdxPDFUtils.IsRectEmpty(FCropBox) then
    Result := MediaBox
  else
    Result := FCropBox;
end;

function TdxPDFPageTreeObject.GetMediaBox: TdxRectF;
begin
  if TdxPDFUtils.IsRectEmpty(FMediaBox) then
    Result := GetParentNodeMediaBox
  else
    Result := FMediaBox;
end;

function TdxPDFPageTreeObject.GetTrimBox: TdxRectF;
begin
  if TdxPDFUtils.IsRectEmpty(FTrimBox) then
    Result := GetParentNodeTrimBox
  else
    Result := FTrimBox;
end;

function TdxPDFPageTreeObject.GetUserUnit: Integer;
begin
  if FUserUnit = 0 then
    Result := GetParentNodeUserUnit
  else
    Result := FUserUnit;
end;

function TdxPDFPageTreeObject.GetParentNode: TdxPDFPageTreeObject;
begin
  if Parent is TdxPDFPageTreeObject then
    Result := TdxPDFPageTreeObject(Parent)
  else
    Result := nil;
end;

function TdxPDFPageTreeObject.GetParentNodeArtBox: TdxRectF;
begin
  if ParentNode <> nil then
    Result := ParentNode.ArtBox
  else
    Result := dxNullRectF;
end;

function TdxPDFPageTreeObject.GetParentNodeBleedBox: TdxRectF;
begin
  if GetParentNode <> nil then
    Result := GetParentNode.BleedBox
  else
    Result := dxNullRectF;
end;

function TdxPDFPageTreeObject.GetParentNodeMediaBox: TdxRectF;
begin
  if ParentNode <> nil then
    Result := ParentNode.MediaBox
  else
    Result := dxNullRectF;
end;

function TdxPDFPageTreeObject.GetParentNodeRotationAngle: Integer;
begin
  if ParentNode <> nil then
    Result := ParentNode.RotationAngle
  else
    Result := 0;
end;

function TdxPDFPageTreeObject.GetParentNodeTrimBox: TdxRectF;
begin
  if ParentNode <> nil then
    Result := ParentNode.TrimBox
  else
    Result := dxNullRectF;
end;

function TdxPDFPageTreeObject.GetParentNodeUserUnit: Integer;
begin
  if ParentNode <> nil then
    Result := ParentNode.UserUnit
  else
    Result := 1;
end;

function TdxPDFPageTreeObject.GetResources: TdxPDFResources;
begin
  if FResources <> nil then
    Result := FResources
  else
    Result := GetParentNodeResources;
end;

function TdxPDFPageTreeObject.GetRotationAngle: Integer;
begin
  if UseParentRotationAngle then
    Result := GetParentNodeRotationAngle
  else
    Result := FRotationAngle;
end;

function TdxPDFPageTreeObject.GetParentNodeResources: TdxPDFResources;
begin
  if Parent is TdxPDFPageTreeObject then
    Result := TdxPDFPageTreeObject(Parent).Resources
  else
    Result := nil;
end;

procedure TdxPDFPageTreeObject.DoChanged;
begin
  LayoutChanged;
end;

procedure TdxPDFPageTreeObject.SetResources(const AValue: TdxPDFResources);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FResources));
end;

{ TdxPDFPageTreeObjectList }

class function TdxPDFPageTreeObjectList.GetTypeName: string;
begin
  Result := TdxPDFPageList.GetTypeName;
end;

procedure TdxPDFPageTreeObjectList.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FChildren := TdxFastObjectList.Create;
end;

procedure TdxPDFPageTreeObjectList.DestroySubClasses;
begin
  FreeAndNil(FChildren);
  inherited DestroySubClasses;
end;

procedure TdxPDFPageTreeObjectList.DoAdd(ANode: TdxPDFPageTreeObject);
begin
  FChildren.Add(ANode);
  inherited DoAdd(ANode);
end;

procedure TdxPDFPageTreeObjectList.DoRemove(ANode: TdxPDFPageTreeObject);
begin
  if FChildren.Remove(ANode) > -1 then
    inherited DoRemove(ANode);
end;

procedure TdxPDFPageTreeObjectList.Read(ADictionary: TdxPDFReaderDictionary);

  procedure AddNode(ANodeDictionary: TdxPDFReaderDictionary; ANumber: Integer);
  var
    ANode: TdxPDFPageTreeObject;
    ANodeType: string;
  begin
    if ANodeDictionary <> nil then
    begin
      ANodeDictionary.Number := ANumber;
      ANodeType := ANodeDictionary.GetString(TdxPDFKeywords.TypeKey);
      if ANodeType = TdxPDFKeywords.Pages then
      begin
        ANode := TdxPDFPageTreeNode.Create(Self);
        TdxPDFPageTreeNode(ANode).OnCreatePageNode := OnCreatePageNode;
        ANode.Read(ANodeDictionary);
        DoAdd(ANode);
      end
      else
        if Assigned(OnCreatePageNode) then
          OnCreatePageNode(Self, ANodeDictionary);
    end;
  end;

var
  I: Integer;
  ANodeDictionary: TdxPDFReaderDictionary;
  AType: string;
  AKidReferences: TdxPDFArray;
begin
  if ADictionary <> nil then
  begin
    DoRead(ADictionary);
    AType := ADictionary.GetString(TdxPDFKeywords.TypeKey);
    AKidReferences := ADictionary.GetArray(TdxPDFKeywords.Kids);
    if ((AType = TdxPDFKeywords.Pages) or (AType = '')) and (AKidReferences <> nil) then
      for I := 0 to AKidReferences.Count - 1 do
      begin
        ANodeDictionary := Repository.GetDictionary(AKidReferences[I].Number);
        AddNode(ANodeDictionary, AKidReferences[I].Number);
      end
    else
      if AType = TdxPDFKeywords.Page then
        AddNode(ADictionary, ADictionary.Number);
  end;
end;

function TdxPDFPageTreeObjectList.getCount: Integer;
begin
  Result := FChildren.Count;
end;

function TdxPDFPageTreeObjectList.GetItem(AIndex: Integer): TdxPDFPageTreeObject;
begin
  Result := TdxPDFPageTreeObject(FChildren[AIndex]);
end;

{ TdxPDFPageTreeNode }

function TdxPDFPageTreeNode.GetLeafCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to FNodeList.Count - 1 do
    Inc(Result, FNodeList[I].GetLeafCount);
end;

procedure TdxPDFPageTreeNode.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FNodeList := TdxPDFPageTreeObjectList.Create(Self);
  FNodeList.OnCreatePageNode := CreatePageNode;
end;

procedure TdxPDFPageTreeNode.DestroySubClasses;
begin
  FreeAndNil(FNodeList);
  inherited DestroySubClasses;
end;

procedure TdxPDFPageTreeNode.DoAdd(ANode: TdxPDFPageTreeObject);
begin
  FNodeList.DoAdd(ANode);
end;

procedure TdxPDFPageTreeNode.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  FNodeList.Read(ADictionary);
end;

procedure TdxPDFPageTreeNode.DoRemove(ANode: TdxPDFPageTreeObject);
begin
  FNodeList.DoRemove(ANode);
end;

procedure TdxPDFPageTreeNode.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
end;

function TdxPDFPageTreeNode.CreatePageNode(AParent: TdxPDFPageTreeObjectList; ADictionary: TdxPDFReaderDictionary): Integer;
begin
  if Assigned(OnCreatePageNode) then
    Result := OnCreatePageNode(AParent, ADictionary)
  else
    Result := -1;
end;

{ TdxPDFPageList }

class function TdxPDFPageList.GetTypeName: string;
begin
  Result := TdxPDFKeywords.Pages;
end;

procedure TdxPDFPageList.Clear;
begin
  inherited Clear;
  FDictionary.Clear;
end;

procedure TdxPDFPageList.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FItems := TdxPDFInternalPageList.Create;
  OnCreatePageNode := CreateAndAddPage;
  FDictionary := TdxPDFIntegerObjectDictionary<TdxPDFPage>.Create;
end;

procedure TdxPDFPageList.DestroySubClasses;
begin
  FreeAndNil(FDictionary);
  FreeAndNil(FItems);
  inherited DestroySubClasses;
end;

procedure TdxPDFPageList.DoRemove(ANode: TdxPDFPageTreeObject);
begin
  ANode.ParentNode.DoRemove(ANode);
  inherited DoRemove(ANode);
end;

procedure TdxPDFPageList.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
var
  AArray: TdxPDFWriterArray;
  APageIndex: Integer;
  APageNode: TdxPDFPageTreeObject;
begin
  inherited Write(AHelper, ADictionary);

  AArray := AHelper.CreateArray;
  for APageIndex := 0 to Items.Count - 1 do
  begin
    APageNode := Items[APageIndex];
    if APageNode.GetLeafCount > 0 then
      AArray.AddReference(APageNode);
  end;
  if AArray.Count > 0 then
  begin
    ADictionary.AddName(TdxPDFKeywords.TypeKey, TdxPDFKeywords.Pages);
    ADictionary.Add(TdxPDFKeywords.Kids, AArray);
  end
  else
    AArray.Free;

  ADictionary.Add(TdxPDFKeywords.CountFull, GetLeafCount);
end;

function TdxPDFPageList.Add(APage: TdxPDFPage): Integer;
begin
  Result := FItems.Add(APage);
  FDictionary.Add(APage.Number, APage);
  DoAdd(APage);
end;

function TdxPDFPageList.CreateAndAddPage(AParent: TdxPDFPageTreeObjectList;
  ADictionary: TdxPDFReaderDictionary): Integer;
begin
  Result := Add(CreatePage(AParent, ADictionary) as TdxPDFPage);
end;

function TdxPDFPageList.Find(ANumber: Integer): TdxPDFPage;
begin
  if not FDictionary.TryGetValue(ANumber, Result) then
    Result := nil;
end;

function TdxPDFPageList.IndexOf(APage: TdxPDFPage): Integer;
begin
  Result := FItems.IndexOf(APage);
end;

procedure TdxPDFPageList.Delete(AIndex: Integer);
begin
  Remove(Items[AIndex]);
end;

procedure TdxPDFPageList.Move(ACurrentIndex, ANewIndex: Integer);
begin
  ACurrentIndex := Max(0, ACurrentIndex);
  ANewIndex := Max(0, Min(ANewIndex, Count - 1));
  if ACurrentIndex <> ANewIndex then
  begin
    Items.Move(ACurrentIndex, ANewIndex);
    LayoutChanged;
  end;
end;

procedure TdxPDFPageList.Move(const ACurrentIndexes: array of Integer; ANewIndex: Integer);

  procedure AddAndMove(APage: TdxPDFPage);
  begin
    Items.Add(APage);
    Move(Items.Count - 1, ANewIndex);
  end;

var
  I, ALength: Integer;
  ASourceItems: TdxPDFInternalPageList;
begin
  ALength := Length(ACurrentIndexes);
  if ALength = 0 then
    Exit;
  ASourceItems := TdxPDFInternalPageList.Create;
  try
    ASourceItems.AddRange(Items);
    for I := 0 to ALength - 1 do
      Items.Remove(ASourceItems[ACurrentIndexes[I]]);

    if ANewIndex < ASourceItems.Count - 1 then
      for I := ALength - 1 downto 0 do
        AddAndMove(ASourceItems[ACurrentIndexes[I]])
    else
      for I := 0 to ALength - 1 do
        AddAndMove(ASourceItems[ACurrentIndexes[I]]);
    LayoutChanged;
  finally
    ASourceItems.Free;
  end;
end;

procedure TdxPDFPageList.Remove(APage: TdxPDFPage);
begin
  PerformBatchOperation(
    procedure
    begin
      dxCallNotify(OnPageDeleting, APage);
      FItems.Remove(APage);
      FDictionary.Remove(APage.Number);
      DoRemove(APage);
      TdxPDFDocumentAccess(Repository.Document).UpdateForm;
    end);
end;

function TdxPDFPageList.CreatePage(AParent: TdxPDFPageTreeObjectList; ADictionary: TdxPDFReaderDictionary): TdxPDFPageTreeObject;
var
  AInfo: TdxPDFDeferredObjectInfo;
  APage: TdxPDFPage;
begin
  AInfo.Name := GetTypeName;
  AInfo.Key := TdxPDFKeywords.TypeKey;
  AInfo.Number := ADictionary.Number;
  AInfo.RawObject := ADictionary;
  APage := TdxPDFPage.Create(AParent, AInfo);
  try
    APage.OnPack := OnPagePack;
    APage.Read(ADictionary);
    Result := APage;
  except
    FreeAndNil(APage);
    raise;
  end;
end;

function TdxPDFPageList.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TdxPDFPageList.GetPage(AIndex: Integer): TdxPDFPage;
begin
  Result := FItems[AIndex] as TdxPDFPage;
end;

{ TdxPDFFileSpecificationData }

procedure TdxPDFFileSpecificationData.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FCreationDate := NullDate;
  FModificationDate := FCreationDate;
end;

class function TdxPDFFileSpecificationData.GetTypeName: string;
begin
  Result := TdxPDFKeywords.EmbeddedFile;
end;

procedure TdxPDFFileSpecificationData.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  SetLength(FData, 0);
  FDataStreamRef := ADictionary.StreamRef;
  FMimeType := ADictionary.GetString(TdxPDFKeywords.Subtype);
  ReadParams(ADictionary.GetDictionary(TdxPDFKeywords.FileParameters));
end;

procedure TdxPDFFileSpecificationData.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.AddName(TdxPDFKeywords.Subtype, FMimeType);
  ADictionary.SetStreamData(GetData);
  WriteParams(AHelper, ADictionary);
end;

procedure TdxPDFFileSpecificationData.SetParent(const AValue: TdxPDFObject);
begin
  FParent := AValue;
end;

function TdxPDFFileSpecificationData.GetData: TBytes;
begin
  if Length(FData) = 0 then
    ResolveData;
  Result := FData;
end;

function TdxPDFFileSpecificationData.GetHasModificationDate: Boolean;
begin
  Result := FModificationDate <> NullDate;
end;

procedure TdxPDFFileSpecificationData.DoChanged;
begin
  Changed([dcModified, dcAttachments]);
end;

procedure TdxPDFFileSpecificationData.Changed;
begin
  FModificationDate := Now;
  DoChanged;
end;

procedure TdxPDFFileSpecificationData.ResolveData;
begin
  if FDataStreamRef <> nil then
    FData := FDataStreamRef.UncompressedData;
end;

procedure TdxPDFFileSpecificationData.ReadParams(ADictionary: TdxPDFReaderDictionary);
begin
  if ADictionary <> nil then
  begin
    FSize := ADictionary.GetInteger(TdxPDFKeywords.FileSize, 0);
    FCreationDate := ADictionary.GetDate(TdxPDFKeywords.FileCreationDate);
    FModificationDate := ADictionary.GetDate(TdxPDFKeywords.FileModificationDate);
  end;
end;

procedure TdxPDFFileSpecificationData.WriteParams(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
var
  AParams: TdxPDFWriterDictionary;
begin
  AParams := AHelper.CreateDictionary;
  if FSize > 0 then
    AParams.Add(TdxPDFKeywords.FileSize, FSize);
  if FCreationDate > 0 then
    AParams.AddDate(TdxPDFKeywords.FileCreationDate, FCreationDate);
  if FModificationDate > 0 then
    AParams.AddDate(TdxPDFKeywords.FileModificationDate, FModificationDate);
  if AParams.Count > 0 then
    ADictionary.Add(TdxPDFKeywords.FileParameters, AParams)
  else
    AParams.Free;
end;

procedure TdxPDFFileSpecificationData.SetCreationDate(const AValue: TDateTime);
begin
  if FCreationDate <> AValue then
  begin
    FCreationDate := AValue;
    Changed;
  end;
end;

procedure TdxPDFFileSpecificationData.SetData(const AValue: TBytes);
begin
  if FData <> AValue then
  begin
    FData := AValue;
    Changed;
  end;
end;

procedure TdxPDFFileSpecificationData.SetMimeType(const AValue: string);
begin
  if FMimeType <> AValue then
  begin
    FMimeType := AValue;
    Changed;
  end;
end;

procedure TdxPDFFileSpecificationData.SetModificationDate(const AValue: TDateTime);
begin
  if FModificationDate <> AValue then
  begin
    FModificationDate := AValue;
    DoChanged;
  end;
end;

{ TdxPDFCustomDestination }

class function TdxPDFCustomDestination.GetTypeName: string;
begin
  Result := 'CustomDestination';
end;

procedure TdxPDFCustomDestination.ClearPageReference;
begin
  PageObject := nil;
  FPageIndex := -1;
  FPage := nil;
end;

procedure TdxPDFCustomDestination.DestroySubClasses;
begin
  PageObject := nil;
  inherited DestroySubClasses;
end;

procedure TdxPDFCustomDestination.Initialize;
begin
  inherited Initialize;
  FPage := nil;
  PageObject := nil;
  FPageIndex := -1;
end;

procedure TdxPDFCustomDestination.Read(ACatalog: TdxPDFCatalog; AArray: TdxPDFArray);
begin
  if AArray <> nil then
  begin
    FCatalog := ACatalog;
    Number := AArray.Number;
    if AArray.Count < 1 then
      TdxPDFUtils.RaiseException;
    ReadParameters(AArray);
  end;
end;

function TdxPDFCustomDestination.Write(AHelper: TdxPDFWriterHelper): TdxPDFBase;
var
  AArray: TdxPDFWriterArray;
begin
  AArray := AHelper.CreateArray;
  WriteParameters(AHelper, AArray);
  Result := AArray;
end;

procedure TdxPDFCustomDestination.ReadParameters(AArray: TdxPDFArray);
begin
  PageObject := AArray[0];
end;

procedure TdxPDFCustomDestination.WriteParameters(AHelper: TdxPDFWriterHelper; AArray: TdxPDFWriterArray);
begin
  AArray.AddReference(Page);
  AArray.AddName(GetTypeName);
end;

procedure TdxPDFCustomDestination.WriteSingleValue(AArray: TdxPDFWriterArray; const AValue: Single);
begin
  if SameValue(AValue, dxPDFInvalidValue) then
    AArray.AddNull
  else
    AArray.Add(AValue);
end;


function TdxPDFCustomDestination.IsSame(ADestination: TdxPDFCustomDestination): Boolean;
begin
  Result := (FPage = ADestination.Page) and (FPageIndex = ADestination.PageIndex);
end;

procedure TdxPDFCustomDestination.ResolveInternalPage;
begin
  ResolvePage;
  if (FPage = nil) and (Catalog <> nil) and (FPageIndex >= 0) and (FPageIndex < Catalog.Pages.Count) then
  begin
    FPage := Catalog.Pages[FPageIndex];
    FPageIndex := -1;
  end;
end;

class function TdxPDFCustomDestination.GetSingleValue(AArray: TdxPDFArray): Single;
begin
  // Lengths 3 and 5 are considered as correct at the moment.
  // Other lengths will be investigated when received.
  case AArray.Count of
    2:
      Result := dxPDFInvalidValue;
    3, 5:
      Result := TdxPDFUtils.ConvertToSingle(AArray[2]);
  else
    TdxPDFUtils.RaiseException;
    Result := dxPDFInvalidValue;
  end;
end;

function TdxPDFCustomDestination.CalculatePageIndex(APages: TdxPDFPageList): Integer;
begin
  if Page = nil then
    Result := FPageIndex
  else
    Result := APages.IndexOf(FPage);
end;

function TdxPDFCustomDestination.ValidateVerticalCoordinate(ATop: Single): Single;
begin
  Result := ATop;
  if TdxPDFUtils.IsDoubleValid(ATop) and (FPage <> nil) then
    Result := TdxPDFUtils.Min(ATop, Abs(FPage.CropBox.Height));
end;

function TdxPDFCustomDestination.GetPage: TdxPDFPage;
begin
  ResolvePage;
  Result := FPage;
end;

function TdxPDFCustomDestination.GetPageIndex: Integer;
begin
  ResolvePage;
  if FPageIndex >= 0 then
    Result := FPageIndex
  else
    Result := CalculatePageIndex(FCatalog.Pages);
end;

function TdxPDFCustomDestination.GetPages: TdxPDFPageList;
begin
  if FCatalog <> nil then
    Result := FCatalog.Pages
  else
    Result := nil;
end;

procedure TdxPDFCustomDestination.SetPageObject(const AValue: TdxPDFBase);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FPageObject));
end;

procedure TdxPDFCustomDestination.ResolvePage;
begin
  if FPageObject <> nil then
  begin
    if TdxPDFUtils.IsReference(FPageObject) then
      FPage := Catalog.Pages.Find(FPageObject.Number)
    else
      if FPageObject.ObjectType = otInteger then
        FPageIndex := TdxPDFInteger(FPageObject).Value;
    PageObject := nil;
  end;
end;

{ TdxPDFFileSpecification }

class function TdxPDFFileSpecification.GetTypeName: string;
begin
  Result := TdxPDFKeywords.FileSpec;
end;

constructor TdxPDFFileSpecification.Create(ARepository: TdxPDFDocumentRepository; const AFileName: string);
begin
  inherited CreateEx(ARepository);
  FFileName := AFileName;
end;

procedure TdxPDFFileSpecification.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FFileSpecificationData := TdxPDFFileSpecificationData.CreateEx(Repository);
  FAttachment := TdxPDFFileAttachment.Create(Self);
end;

procedure TdxPDFFileSpecification.DestroySubClasses;
begin
  FreeAndNil(FAttachment);
  FreeAndNil(FFileSpecificationData);
  inherited DestroySubClasses;
end;

procedure TdxPDFFileSpecification.DoRead(ADictionary: TdxPDFReaderDictionary);
var
  AType: string;
begin
  inherited DoRead(ADictionary);
  AType := ADictionary.GetString(TdxPDFKeywords.TypeKey);
  if (AType <> '') and ((AType = TdxPDFKeywords.FileSpec) or (AType = GetTypeName) or (AType <> TdxPDFKeywords.FileName)) then
  begin
    FDescription := ADictionary.GetTextString(TdxPDFKeywords.FileDescription);
    FFileSystem := ADictionary.GetString(TdxPDFKeywords.FileSystem);
    ReadFileName(ADictionary);
    ReadFileSpecificationData(ADictionary.GetDictionary(TdxPDFKeywords.EmbeddedFileReference));
    ReadFileIndex(ADictionary.GetDictionary(TdxPDFKeywords.CollectionItem));
    ReadAssociatedFileRelationship(ADictionary);
  end;
end;

procedure TdxPDFFileSpecification.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited;
  ADictionary.Add(TdxPDFKeywords.FileDescription, FDescription);
  ADictionary.Add(TdxPDFKeywords.FileSystem, FFileSystem);
  ADictionary.Add(TdxPDFKeywords.FileName, FFileName);
  ADictionary.Add(TdxPDFKeywords.AssociatedFileRelationship, AssociatedFileRelationshipNameMap[FRelationship]);
  ADictionary.Add(TdxPDFKeywords.EmbeddedFileReference, WriteFileSpecificationData(AHelper));
  WriteFileIndex(AHelper, ADictionary);
end;

procedure TdxPDFFileSpecification.SetParent(const AValue: TdxPDFObject);
begin
  FParent := AValue;
  FFileSpecificationData.SetParent(AValue);
  FAttachment.FOwnsSpecification := Parent = nil;
end;

procedure TdxPDFFileSpecification.SetRelationship(const AValue: TdxPDFAssociatedFileRelationship);
begin
  if FRelationship <> AValue then
  begin
    FRelationship := AValue;
    FFileSpecificationData.Changed;
  end;
end;

function TdxPDFFileSpecification.GetMimeType: string;
begin
  Result := FFileSpecificationData.MimeType;
end;

procedure TdxPDFFileSpecification.SetMimeType(const AValue: string);
begin
  FFileSpecificationData.MimeType := AValue;
end;

function TdxPDFFileSpecification.GetCreationDate: TDateTime;
begin
  Result := FFileSpecificationData.CreationDate;
end;

procedure TdxPDFFileSpecification.SetCreationDate(const AValue: TDateTime);
begin
  FFileSpecificationData.CreationDate := AValue;
end;

procedure TdxPDFFileSpecification.SetDescription(const AValue: string);
begin
  if FDescription = AValue then
  begin
    FDescription := AValue;
    FFileSpecificationData.Changed;
  end;
end;

function TdxPDFFileSpecification.GetModificationDate: TDateTime;
begin
  Result := FFileSpecificationData.ModificationDate;
end;

function TdxPDFFileSpecification.GetHasModificationDate: Boolean;
begin
  Result := FFileSpecificationData.HasModificationDate;
end;

procedure TdxPDFFileSpecification.SetModificationDate(const AValue: TDateTime);
begin
  FFileSpecificationData.ModificationDate := AValue;
end;

function TdxPDFFileSpecification.GetFileData: TBytes;
begin
  Result := FFileSpecificationData.Data;
end;

procedure TdxPDFFileSpecification.SetFileData(const AValue: TBytes);
begin
  FFileSpecificationData.Data := AValue;
end;

procedure TdxPDFFileSpecification.SetFileName(const AValue: string);
begin
  if FFileName <> AValue then
  begin
    FFileName := AValue;
    FFileSpecificationData.Changed;
  end;
end;

function TdxPDFFileSpecification.GetSize: Integer;
begin
  if TdxPDFUtils.IsIntegerValid(FFileSpecificationData.Size) then
    Result := FFileSpecificationData.Size
  else
    Result := 0;
end;

procedure TdxPDFFileSpecification.SetAttachment(const AValue: TdxPDFFileAttachment);
begin
  FreeAndNil(FAttachment);
  FAttachment := AValue;
end;

function TdxPDFFileSpecification.WriteFileSpecificationData(AHelper: TdxPDFWriterHelper): TdxPDFBase;
var
  ADictionary: TdxPDFWriterDictionary;
begin
  ADictionary := AHelper.CreateDictionary;
  ADictionary.AddReference(TdxPDFKeywords.FileData, FFileSpecificationData);
  Result := ADictionary;
end;

procedure TdxPDFFileSpecification.ReadAssociatedFileRelationship(ADictionary: TdxPDFReaderDictionary);
var
  I: TdxPDFAssociatedFileRelationship;
  S: string;
begin
  FRelationship := frSource;
  S := ADictionary.GetString(TdxPDFKeywords.AssociatedFileRelationship);
  for I := Low(TdxPDFAssociatedFileRelationship) to High(TdxPDFAssociatedFileRelationship) do
    if AssociatedFileRelationshipNameMap[I] = S then
    begin
      FRelationship := I;
      Break;
    end;
end;

procedure TdxPDFFileSpecification.ReadFileIndex(ADictionary: TdxPDFReaderDictionary);
begin
  if ADictionary <> nil then
    FIndex := ADictionary.GetInteger(TdxPDFKeywords.FileIndex, 0);
end;

procedure TdxPDFFileSpecification.ReadFileName(ADictionary: TdxPDFReaderDictionary);
begin
  if not ((ADictionary <> nil) and (ADictionary.TryGetTextString('UF', FFileName) or
    ADictionary.TryGetTextString('F', FFileName) or ADictionary.TryGetTextString('DOS', FFileName) or
    ADictionary.TryGetTextString('Mac', FFileName) or ADictionary.TryGetTextString('Unix', FFileName))) then
    FFileName := '';
end;

procedure TdxPDFFileSpecification.ReadFileSpecificationData(ADictionary: TdxPDFReaderDictionary);
var
  AEmbeddedStreamDictionary: TdxPDFReaderDictionary;
begin
  if ADictionary <> nil then
  begin
    if ADictionary.TryGetStreamDictionary('F', AEmbeddedStreamDictionary) or
       ADictionary.TryGetStreamDictionary('DOS', AEmbeddedStreamDictionary) or
       ADictionary.TryGetStreamDictionary('Unix', AEmbeddedStreamDictionary)
    then
      FFileSpecificationData.Read(AEmbeddedStreamDictionary);
  end;
end;

procedure TdxPDFFileSpecification.WriteFileIndex(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
var
  AData: TdxPDFWriterDictionary;
begin
  if FIndex > 0 then
  begin
    AData := AHelper.CreateDictionary;
    AData.Add(TdxPDFKeywords.FileIndex, FIndex);
    ADictionary.AddReference(TdxPDFKeywords.CollectionItem, AData);
  end;
end;

{ TdxPDFCustomAction }

function TdxPDFCustomAction.GetCatalog: TdxPDFCatalog;
begin
  Result := Repository.Catalog;
end;

function TdxPDFCustomAction.GetNext: TdxPDFActionList;
begin
  EnsureNextActions;
  Result := FNext;
end;

procedure TdxPDFCustomAction.SetNextValue(const AValue: TdxPDFBase);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FNextValue));
end;

procedure TdxPDFCustomAction.EnsureNextActions;
var
  AActionArray: TdxPDFArray;
  I: Integer;
begin
  if (FNext = nil) and (FNextValue <> nil) then
  begin
    FNext := TdxPDFActionList.Create;
    case FNextValue.ObjectType of
      otIndirectReference:
        AActionArray := Repository.GetArray(FNextValue.Number);
      otArray:
        AActionArray := TdxPDFArray(FNextValue);
    else
      AActionArray := nil;
    end;

    if AActionArray <> nil then
    begin
      for I := 0 to AActionArray.Count - 1 do
        FNext.Add(Repository.GetAction(AActionArray[I]));
    end
    else
      FNext.Add(Repository.GetAction(FNextValue));
  end;
end;

procedure TdxPDFCustomAction.DestroySubClasses;
begin
  NextValue := nil;
  FreeAndNil(FNext);
  inherited DestroySubClasses;
end;

procedure TdxPDFCustomAction.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  NextValue := ADictionary.GetObject(TdxPDFKeywords.ActionNext);
end;

procedure TdxPDFCustomAction.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  ADictionary.AddName(TdxPDFKeywords.TypeKey, TdxPDFKeywords.Action);
  ADictionary.AddName(TdxPDFKeywords.ActionType, GetTypeName);
  WriteNextActions(AHelper, ADictionary);
end;

procedure TdxPDFCustomAction.Execute(const AController: IdxPDFInteractivityController);
begin
  // do nothing
end;

procedure TdxPDFCustomAction.WriteNextActions(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
var
  AArray: TdxPDFWriterArray;
  I: Integer;
begin
  if Next <> nil then
  begin
    AArray := AHelper.CreateArray;
    for I := 0 to Next.Count - 1 do
      AArray.AddReference(Next[I]);
    ADictionary.AddReference(TdxPDFKeywords.ActionNext, AArray);
  end;
end;

{ TdxPDFCustomTree }

class function TdxPDFCustomTree.GetUniqueKey(ADictionary: TdxPDFStringReferencedObjectDictionary): string;
begin
  Result := GetUniqueKey(
    function(AKey: string): Boolean
    begin
      Result := not ADictionary.ContainsKey(AKey);
    end);
end;

class function TdxPDFCustomTree.GetUniqueKey(ADictionary: TdxPDFStringStringDictionary): string;
begin
  Result := GetUniqueKey(
    function(AKey: string): Boolean
    begin
      Result := not ADictionary.ContainsKey(AKey);
    end);
end;

constructor TdxPDFCustomTree.Create;
begin
  inherited Create;
  FRepository := ARepository;
  FDictionary := TStringReferencedObjectDictionary.Create;
end;

destructor TdxPDFCustomTree.Destroy;
begin
  FreeAndNil(FDictionary);
  inherited Destroy;
end;

function TdxPDFCustomTree.ContainsKey(const AKey: string): Boolean;
begin
  Result := FDictionary.ContainsKey(AKey);
end;

function TdxPDFCustomTree.GetUniqueKey: string;
begin
  Result := GetUniqueKey(FDictionary);
end;

function TdxPDFCustomTree.GetNodeName: string;
begin
  Result := TdxPDFKeywords.Names;
end;

procedure TdxPDFCustomTree.DoRemoveAll<T>(ACondition: TFunc<T, Boolean>);
var
  AKey: string;
  AObject: T;
begin
  if not Assigned(ACondition) then
    Exit;
  for AKey in Keys do
  begin
    AObject := Safe<T>.Cast(InternalGetValue(AKey));
    if (AObject <> nil) and ACondition(AObject) then
      RemoveObject(AKey);
  end;
end;

function TdxPDFCustomTree.GetLeafName(const AContext: IdxPDFWriterContext; const AName: string): string;
begin
  Result := AContext.GetUniqueName(Self, AName);
end;

function TdxPDFCustomTree.ContainsValue(AObject: TdxPDFBase): Boolean;
var
  AKey: string;
begin
  Result := FDictionary.ContainsValue(AObject) or TryGetKey(AObject, AKey);
end;

function TdxPDFCustomTree.InternalGetValue(const AKey: string): TdxPDFObject;
var
  AObject: TdxPDFReferencedObject;
begin
  if FDictionary.TryGetValue(AKey, AObject) then
  begin
    if AObject is TdxPDFDeferredObject then
      Result := TdxPDFDeferredObject(AObject).ResolvedObject
    else
      Result := AObject as TdxPDFObject;
  end
  else
    Result := nil;
end;

function TdxPDFCustomTree.TryGetKey(AObject: TdxPDFBase; out AKey: string): Boolean;
var
  ACurrentKey: string;
begin
  Result := False;
  for ACurrentKey in FDictionary.Keys do
    if InternalGetValue(ACurrentKey) = AObject then
    begin
      AKey := ACurrentKey;
      Exit(True);
    end;
end;

function TdxPDFCustomTree.Write(AHelper: TdxPDFWriterHelper): TdxPDFBase;
begin
  if Count > 0 then
    Result := WriteBranch(AHelper)
  else
    Result := nil;
end;

procedure TdxPDFCustomTree.AddDeferredObject(const AKey: string; ARawObject: TdxPDFBase);
begin
  if not ContainsKey(AKey) and (AKey <> '') then
    FDictionary.Add(AKey, CreateDeferredObject(ARawObject))
end;

procedure TdxPDFCustomTree.AddObject(const AKey: string; AObject: TdxPDFObject);
begin
  FDictionary.Add(AKey, AObject);
end;

procedure TdxPDFCustomTree.ExtractObject(AObject: TdxPDFBase);
var
  AKey: string;
begin
  if TryGetKey(AObject, AKey) then
    FDictionary.Extract(AKey);
end;

procedure TdxPDFCustomTree.DeleteObject(AObject: TdxPDFBase);
var
  AKey: string;
begin
  if TryGetKey(AObject, AKey) then
    FDictionary.Remove(AKey);
end;

procedure TdxPDFCustomTree.Read(ADictionary: TdxPDFReaderDictionary);
var
  ANodeObject: TdxPDFBase;
begin
  if ADictionary <> nil then
  begin
    ANodeObject := ADictionary.GetObject(GetNodeName);
    if ANodeObject = nil then
      ReadNode(ADictionary)
    else
      case ANodeObject.ObjectType of
        otArray:
          ReadBranch(TdxPDFArray(ANodeObject));
        otDictionary:
          ReadNode(ANodeObject);
      end;
  end;
end;

procedure TdxPDFCustomTree.RemoveObject(const AKey: string);
begin
  FDictionary.Remove(AKey);
end;

function TdxPDFCustomTree.CreateKey(AValue: TdxPDFBase): string;
begin
  if AValue is TdxPDFString then
    Result := TdxPDFString(AValue).Value
  else
    Result := '';
end;

function TdxPDFCustomTree.GetCount: Integer;
begin
  Result := FDictionary.Count;
end;

function TdxPDFCustomTree.GetKeys: TArray<string>;
begin
  Result := FDictionary.KeyArray;
end;

function TdxPDFCustomTree.WriteBranch(AHelper: TdxPDFWriterHelper): TdxPDFBase;
var
  ADictionary: TdxPDFWriterDictionary;
  AKey: string;
  ANames: TdxPDFWriterArray;
begin
  ANames := AHelper.CreateArray;
  for AKey in FDictionary.Keys do
  begin
    ANames.Add(GetLeafName(AHelper.Context, AKey));
    ANames.AddReference(InternalGetValue(AKey));
  end;
  ADictionary := AHelper.CreateDictionary;
  ADictionary.Add(GetNodeName, ANames);
  Result := ADictionary;
end;

class function TdxPDFCustomTree.GetUniqueKey(AIsUniqueKey: TFunc<string, Boolean>): string;
begin
  Result := TdxPDFUtils.GenerateGUID;
  while not AIsUniqueKey(Result) do
    Result := TdxPDFUtils.GenerateGUID;
end;

function TdxPDFCustomTree.CreateDeferredObject(AValue: TdxPDFBase): TdxPDFDeferredObject;
var
  AInfo: TdxPDFDeferredObjectInfo;
begin
  AInfo.Name := '';
  AInfo.Key := GetDeferredObjectKey;
  AInfo.Number := AValue.Number;
  AInfo.RawObject := AValue;
  Result := Repository.CreateDeferredObject(AInfo);
end;

procedure TdxPDFCustomTree.ReadBranch(AReferences: TdxPDFArray);
var
  I, AIndex: Integer;
begin
  AIndex := 0;
  for I := 0 to AReferences.Count div 2 - 1 do
  begin
    AddDeferredObject(CreateKey(Repository.ResolveReference(AReferences[AIndex])), AReferences[AIndex + 1]);
    Inc(AIndex, 2);
  end;
end;

procedure TdxPDFCustomTree.ReadKids(AReferences: TdxPDFArray);
var
  ADictionary: TdxPDFDictionary;
  AValue: TdxPDFBase;
  I: Integer;
begin
  for I := 0 to AReferences.Count - 1 do
  begin
    AValue := AReferences[I];
    case AValue.ObjectType of
      otIndirectReference:
        ADictionary := Repository.GetDictionary(AValue.Number);
      otDictionary:
        ADictionary := AValue as TdxPDFDictionary;
    else
      ADictionary := nil;
      TdxPDFUtils.Abort;
    end;
    ReadNode(ADictionary);
  end;
end;

procedure TdxPDFCustomTree.ReadNode(APageObject: TdxPDFBase);
var
  ADictionary: TdxPDFReaderDictionary;
  AKids: TdxPDFArray;
begin
  if APageObject <> nil then
    case APageObject.ObjectType of
      otArray:
        ReadBranch(TdxPDFArray(APageObject));
      otDictionary:
        begin
          ADictionary := APageObject as TdxPDFReaderDictionary;
          if ADictionary.Count > 0 then
          begin
            AKids := ADictionary.GetArray(TdxPDFKeywords.Kids);
            if AKids <> nil then
              ReadKids(AKids)
            else
              Read(ADictionary);
          end;
        end;
    end;
end;

{ TdxPDFCustomTree.TStringReferencedObjectDictionary }

destructor TdxPDFCustomTree.TStringReferencedObjectDictionary.Destroy;
begin
  FreeAndNil(FKeyList);
  inherited Destroy;
end;

procedure TdxPDFCustomTree.TStringReferencedObjectDictionary.KeyNotify(const AKey: string; AAction: TCollectionNotification);
begin
  case AAction of
    cnAdded:
      GetKeyList.Add(AKey);
    cnRemoved:
      if FKeyList <> nil then
        FKeyList.Remove(AKey);
  else // cnExtracted
    if FKeyList <> nil then
      FKeyList.Remove(AKey);
  end;
end;

function TdxPDFCustomTree.TStringReferencedObjectDictionary.GetKeyArray: TArray<string>;
var
  AKeyList: TdxStringList;
  I: Integer;
begin
  AKeyList := GetKeyList;
  SetLength(Result, AKeyList.Count);
  for I := 0 to AKeyList.Count - 1 do
    Result[I] := AKeyList[I];
end;

function TdxPDFCustomTree.TStringReferencedObjectDictionary.GetKeyList: TdxStringList;
begin
  if FKeyList = nil then
    FKeyList := TdxStringList.Create;
  Result := FKeyList;
end;

{ TdxPDFDestinationTree }

function TdxPDFDestinationTree.GetValue(const AKey: string): TdxPDFCustomDestination;
begin
  Result := InternalGetValue(AKey) as TdxPDFCustomDestination;
end;

procedure TdxPDFDestinationTree.RemoveAll(ACondition: TFunc<TdxPDFCustomDestination, Boolean>);
begin
  DoRemoveAll<TdxPDFCustomDestination>(ACondition);
end;

function TdxPDFDestinationTree.GetDeferredObjectKey: string;
begin
  Result := TdxPDFCustomDestination.GetTypeName;
end;

function TdxPDFDestinationTree.GetLeafName(const AContext: IdxPDFWriterContext; const AName: string): string;
begin
  Result := AContext.GetDestinationName(AName);
end;

{ TdxPDFEmbeddedFileSpecificationTree }

function TdxPDFEmbeddedFileSpecificationTree.GetValue(const AKey: string): TdxPDFFileSpecification;
begin
  Result := InternalGetValue(AKey) as TdxPDFFileSpecification;
end;

procedure TdxPDFEmbeddedFileSpecificationTree.Add(AValue: TdxPDFFileSpecification);
var
  AKey: string;
begin
  AKey := AValue.FileName;
  if (AKey = '') or ContainsKey(AKey) then
    AKey := GetUniqueKey;
  AddObject(AKey, AValue);
  Repository.AttachmentsChanged;
end;

procedure TdxPDFEmbeddedFileSpecificationTree.Extract(AValue: TdxPDFFileSpecification);
begin
  ExtractObject(AValue);
  Repository.AttachmentsChanged;
end;

procedure TdxPDFEmbeddedFileSpecificationTree.Remove(AValue: TdxPDFFileSpecification);
begin
  DeleteObject(AValue);
  Repository.AttachmentsChanged;
end;

function TdxPDFEmbeddedFileSpecificationTree.GetDeferredObjectKey: string;
begin
  Result := TdxPDFFileSpecification.GetTypeName;
end;

{ TdxPDFAnnotationAppearance }

constructor TdxPDFAnnotationAppearance.Create(ARepository: TdxPDFDocumentRepository; const ABBox: TdxPDFRectangle);
begin
  inherited CreateEx(ARepository);
  FDefaultForm := TdxPDFXForm.Create(Repository, ABBox);
end;

constructor TdxPDFAnnotationAppearance.Create(ADefaultForm: TdxPDFXForm; AForms: TdxPDFStringFormDictionary);
begin
  inherited Create(nil);
  FForms := AForms;
  DefaultForm := ADefaultForm;
end;

procedure TdxPDFAnnotationAppearance.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FNames := TStringList.Create;
end;

procedure TdxPDFAnnotationAppearance.DestroySubClasses;
var
  APair: TPair<string, TdxPDFXForm>;
begin
  if FForms <> nil then
    for APair in FForms do
      if APair.Value = FDefaultForm then
      begin
        if APair.Value <> nil then
          APair.Value.Release;
        FForms.ExtractPair(APair.Key);
        DefaultForm := nil;
      end;
  DefaultForm := nil;
  FreeAndNil(FNames);
  FreeAndNil(FForms);
  inherited DestroySubClasses;
end;

function TdxPDFAnnotationAppearance.Write(AHelper: TdxPDFWriterHelper): TdxPDFBase;
var
  ADictionary: TdxPDFWriterDictionary;
  APair: TPair<string, TdxPDFXForm>;
begin
  ADictionary := AHelper.CreateDictionary;
  if FForms = nil then
  begin
    if FDefaultForm <> nil then
      FDefaultForm.Write(AHelper, ADictionary)
  end
  else
    for APair in FForms do
      ADictionary.AddReference(APair.Key, APair.Value);
  Result := ADictionary;
end;

procedure TdxPDFAnnotationAppearance.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  RaiseWriteNotImplementedException;
end;

function TdxPDFAnnotationAppearance.GetNames(const ADefaultName: string): TStringList;
var
  AKey: string;
begin
  FNames.Clear;
  if FForms = nil then
    FNames.Add(ADefaultName)
  else
    for AKey in FForms.Keys do
      FNames.Add(AKey);
  Result := FNames;
end;

procedure TdxPDFAnnotationAppearance.SetForm(const AName: string; AForm: TdxPDFXForm);
begin
  if AName = '' then
    DefaultForm := AForm
  else
  begin
    if FForms = nil then
      FForms := TdxPDFStringFormDictionary.Create;
    FForms.Add(AName, AForm);
  end;
end;

procedure TdxPDFAnnotationAppearance.SetDefaultForm(const AValue: TdxPDFXForm);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FDefaultForm));
end;

{ TdxPDFAnnotationAppearances }

function TdxPDFAnnotationAppearances.Write(AHelper: TdxPDFWriterHelper): TdxPDFBase;
var
  ADictionary: TdxPDFWriterDictionary;
begin
  ADictionary := AHelper.CreateDictionary;
  ADictionary.AddReference(TdxPDFKeywords.AnnotationAppearanceNormal, FNormal);
  ADictionary.AddReference(TdxPDFKeywords.AnnotationAppearanceRollover, FRollover);
  ADictionary.AddReference(TdxPDFKeywords.AnnotationAppearanceDown, FDown);
  Result := ADictionary;
end;

procedure TdxPDFAnnotationAppearances.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FNames := TStringList.Create;
end;

procedure TdxPDFAnnotationAppearances.DestroySubClasses;
begin
  FreeAndNil(FNames);
  Form := nil;
  FreeAndNil(FRollover);
  FreeAndNil(FNormal);
  FreeAndNil(FDown);
  inherited DestroySubClasses;
end;

procedure TdxPDFAnnotationAppearances.Read(ADictionary: TdxPDFReaderDictionary; const AParentBox: TdxPDFRectangle);
begin
  inherited Read(ADictionary);
  FNormal := Repository.CreateAppearance(ADictionary, TdxPDFKeywords.AnnotationAppearanceNormal);
  if (FNormal = nil) and not AParentBox.IsNull then
    FNormal := Repository.CreateAppearance(AParentBox);
  FRollover := Repository.CreateAppearance(ADictionary, TdxPDFKeywords.AnnotationAppearanceRollover);
  FDown := Repository.CreateAppearance(ADictionary, TdxPDFKeywords.AnnotationAppearanceDown);
end;

procedure TdxPDFAnnotationAppearances.Read(AForm: TdxPDFXForm);
begin
  Form := AForm;
end;

procedure TdxPDFAnnotationAppearances.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  RaiseWriteNotImplementedException;
end;

procedure TdxPDFAnnotationAppearances.SetStateForm(AState: TdxPDFAnnotationAppearanceState; const AName: string; AForm: TdxPDFXForm);
begin
  case AState of
    asDown:
      begin
        if FDown = nil then
          FDown := TdxPDFAnnotationAppearance.Create;
        FDown.SetForm(AName, AForm);
      end;
    asRollover:
      begin
        if FRollover = nil then
          FRollover := TdxPDFAnnotationAppearance.Create;
        FRollover.SetForm(AName, AForm);
      end;
  else
    if FNormal = nil then
      FNormal := TdxPDFAnnotationAppearance.CreateEx(Repository);
    FNormal.SetForm(AName, AForm);
  end;
end;

function TdxPDFAnnotationAppearances.GetNames: TStringList;
begin
  FNames.Clear;
  FNames.AddStrings(FNormal.GetNames(TdxPDFKeywords.AnnotationAppearanceNormal));
  if FRollover <> nil then
    FNames.AddStrings(FRollover.GetNames(TdxPDFKeywords.AnnotationAppearanceRollover));
  if FDown <> nil then
    FNames.AddStrings(FDown.GetNames(TdxPDFKeywords.AnnotationAppearanceDown));
  Result := FNames;
end;

procedure TdxPDFAnnotationAppearances.SetForm(const AValue: TdxPDFXForm);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FForm));
end;

{ TdxPDFAnnotationBorderStyle }

function TdxPDFAnnotationBorderStyle.Write(AHelper: TdxPDFWriterHelper): TdxPDFBase;
var
  ADictionary: TdxPDFWriterDictionary;
begin
  ADictionary := AHelper.CreateDictionary;
  ADictionary.Add(TdxPDFKeywords.BorderStyleWidth, FWidth);
  ADictionary.Add(TdxPDFKeywords.BorderStyleName, FStyleName);
  if LineStyle <> nil then
    ADictionary.Add(TdxPDFKeyWords.LineStyle, TdxPDFLineStyleAccess(LineStyle).Write);
  Result := ADictionary;
end;

procedure TdxPDFAnnotationBorderStyle.CreateSubClasses;
begin
  inherited CreateSubClasses;
  LineStyle := nil;
end;

procedure TdxPDFAnnotationBorderStyle.DestroySubClasses;
begin
  LineStyle := nil;
  inherited DestroySubClasses;
end;

procedure TdxPDFAnnotationBorderStyle.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  FStyleName := ADictionary.GetString(TdxPDFKeywords.BorderStyleName, SolidStyleName);
  FWidth := ADictionary.GetDouble(TdxPDFKeywords.BorderStyleWidth, 1);
  LineStyle := Repository.CreateLineStyle(ADictionary.GetArray(TdxPDFKeyWords.LineStyle));
end;

procedure TdxPDFAnnotationBorderStyle.Initialize;
begin
  inherited Initialize;
  FWidth := 1;
  LineStyle := Repository.CreateSolidLineStyle;
  StyleName := SolidStyleName;
end;

function TdxPDFAnnotationBorderStyle.GetStyle: TdxPDFBorderStyle;
begin
  if StyleName = BeveledStyleName then
    Exit(TdxPDFBorderStyle.bsBeveled);

  if StyleName = InsetStyleName then
    Exit(TdxPDFBorderStyle.bsInset);

  if StyleName = UnderlineStyleName then
    Exit(TdxPDFBorderStyle.bsUnderline);

  if StyleName = DashedStyleName then
      case Length(LineStyle.Pattern) of
        2:
          if LineStyle.Pattern[0] = Width then
            Result := TdxPDFBorderStyle.bsDot
          else
            Result := TdxPDFBorderStyle.bsDash;
        4:
          Result := TdxPDFBorderStyle.bsDashDot;
        6:
          Result := TdxPDFBorderStyle.bsDashDotDot;
      else
        Result:= TdxPDFBorderStyle.bsDash;
      end
  else
    Result := TdxPDFBorderStyle.bsSolid;
end;

procedure TdxPDFAnnotationBorderStyle.SetLineStyle(const AValue: TdxPDFLineStyle);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FLineStyle));
end;

procedure TdxPDFAnnotationBorderStyle.SetStyle(const AValue: TdxPDFBorderStyle);
begin
  if Style <> AValue then
  begin
    case AValue of
      TdxPDFBorderStyle.bsSolid:
        StyleName := SolidStyleName;
      TdxPDFBorderStyle.bsUnderline:
        StyleName := UnderlineStyleName;
      TdxPDFBorderStyle.bsInset:
        StyleName := InsetStyleName;
      TdxPDFBorderStyle.bsBeveled:
        StyleName := BeveledStyleName;
    else
      CreateDashPattern(AValue);
    end;
  end;
end;

procedure TdxPDFAnnotationBorderStyle.SetStyleName(const AValue: string);
begin
  if FStyleName <> AValue then
  begin
    FStyleName := AValue;
    LayoutChanged;
  end;
end;

procedure TdxPDFAnnotationBorderStyle.SetWidth(const AValue: Single);
begin
  if not SameValue(FWidth, AValue) then
  begin
    FWidth := AValue;
    CreateDashPattern(Style);
    LayoutChanged;
  end;
end;

procedure TdxPDFAnnotationBorderStyle.CreateDashPattern(AStyle: TdxPDFBorderStyle);
var
  APattern: TDoubleDynArray;
begin
  case AStyle of
    TdxPDFBorderStyle.bsDash:
      begin
        SetLength(APattern, 2);
        APattern[0] := Width * DashLength;
        APattern[1] := Width;
      end;
    TdxPDFBorderStyle.bsDot:
      begin
        SetLength(APattern, 2);
        APattern[0] := Width;
        APattern[1] := Width;
      end;
    TdxPDFBorderStyle.bsDashDot:
      begin
        SetLength(APattern, 4);
        APattern[0] := Width * DashLength;
        APattern[1] := Width;
        APattern[2] := Width;
        APattern[3] := Width;
      end;
  else // bsDashDotDot
    SetLength(APattern, 6);
    APattern[0] := Width * DashLength;
    APattern[1] := Width;
    APattern[2] := Width;
    APattern[3] := Width;
    APattern[4] := Width;
    APattern[5] := Width;
  end;
  CreateDashPattern(APattern);
end;

procedure TdxPDFAnnotationBorderStyle.CreateDashPattern(const APattern: TDoubleDynArray);
begin
  PerformBatchOperation(
    procedure
    begin
      StyleName := TdxPDFAnnotationBorderStyle.DashedStyleName;
      LineStyle := TdxPDFLineStyle.Create(APattern, 0);
    end);
end;

{ TdxPDFAnnotationBorder }

function TdxPDFAnnotationBorder.Write(AHelper: TdxPDFWriterHelper): TdxPDFBase;
var
  AArray: TdxPDFWriterArray;
begin
  AArray := AHelper.CreateArray;
  AArray.Add(FHorizontalCornerRadius);
  AArray.Add(FVerticalCornerRadius);
  AArray.Add(LineWidth);
  if (LineStyle <> nil) and LineStyle.IsDashed then
    AArray.Add(TdxPDFLineStyleAccess(LineStyle).WritePattern);
  Result := AArray;
end;

procedure TdxPDFAnnotationBorder.CreateSubClasses;
begin
  inherited CreateSubClasses;
  LineStyle := Repository.CreateSolidLineStyle;
end;

procedure TdxPDFAnnotationBorder.DestroySubClasses;
begin
  LineStyle := nil;
  inherited DestroySubClasses;
end;

procedure TdxPDFAnnotationBorder.DoRead(ADictionary: TdxPDFReaderDictionary);
var
  AArray, ALineStyleArray: TdxPDFArray;
  AValue: TdxPDFBase;
begin
  inherited DoRead(ADictionary);
  if ADictionary.TryGetArray(TdxPDFKeywords.Border, AArray) and (AArray.Count >= 3) then
  begin
    FHorizontalCornerRadius := TdxPDFUtils.ConvertToDouble(AArray[0]);
    FVerticalCornerRadius := TdxPDFUtils.ConvertToDouble(AArray[1]);
    FLineWidth := TdxPDFUtils.ConvertToDouble(AArray[2]);
    if (FHorizontalCornerRadius < 0) or (FVerticalCornerRadius < 0) or (FLineWidth < 0) then
      TdxPDFUtils.Abort;
    if AArray.Count = 4 then
    begin
      AValue := AArray[3] as TdxPDFBase;
      ALineStyleArray := nil;
      try
        if AValue.ObjectType <> otArray then
        begin
          ALineStyleArray := TdxPDFArray.Create;
          if AValue.ObjectType in [otInteger, otDouble] then
            ALineStyleArray.Add(AValue);
        end
        else
        begin
          ALineStyleArray := TdxPDFArray(AValue);
          ALineStyleArray.Reference;
        end;
        LineStyle := Repository.CreateLineStyle(ALineStyleArray)
      finally
        dxPDFFreeObject(ALineStyleArray);
      end;
    end
    else
      LineStyle := Repository.CreateSolidLineStyle;
  end;
end;

procedure TdxPDFAnnotationBorder.Initialize;
begin
  inherited Initialize;
  FLineWidth := DefaultLineWidth;
  FHorizontalCornerRadius := DefaultHorizontalCornerRadius;
  FVerticalCornerRadius := DefaultVerticalCornerRadius;
end;

function TdxPDFAnnotationBorder.GetIsDefault: Boolean;
begin
  Result := not LineStyle.IsDashed and SameValue(HorizontalCornerRadius, DefaultHorizontalCornerRadius) and
    SameValue(LineWidth, DefaultLineWidth) and SameValue(VerticalCornerRadius, DefaultVerticalCornerRadius);
end;

procedure TdxPDFAnnotationBorder.SetLineStyle(const AValue: TdxPDFLineStyle);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FLineStyle));
end;

{ TdxPDFCustomAnnotation }

class function TdxPDFCustomAnnotation.GetTypeName: string;
begin
  Result := TdxPDFKeywords.Annotation;
end;

constructor TdxPDFCustomAnnotation.Create(APage: TdxPDFPage; const ARect: TdxPDFRectangle);
begin
  Create(APage, ARect, afNone);
end;

constructor TdxPDFCustomAnnotation.Create(APage: TdxPDFPage; const ARect: TdxPDFRectangle; AFlags: TdxPDFAnnotationFlags);
begin
  inherited CreateEx(APage.Repository);
  FPage := APage;
  FRect := ARect;
  FFlags := AFlags;
end;

function TdxPDFCustomAnnotation.CreateAppearanceForm(AState: TdxPDFAnnotationAppearanceState): TdxPDFXForm;
begin
  Result := CreateAppearanceForm(AState, '');
end;

function TdxPDFCustomAnnotation.CreateAppearanceForm(AState: TdxPDFAnnotationAppearanceState;
  const AName: string): TdxPDFXForm;
begin
  Ensure;
  Result := TdxPDFXForm.Create(Repository, TdxPDFRectangle.Create(0, 0, Rect.Width, Rect.Height));
  if Appearance = nil then
    FAppearance := TdxPDFAnnotationAppearances.CreateEx(Repository);
  FAppearance.SetStateForm(AState, AName, Result);
end;

function TdxPDFCustomAnnotation.EnsureAppearanceForm(AState: TdxPDFAnnotationAppearanceState): TdxPDFXForm;
var
  AActualState: TdxPDFAnnotationAppearanceState;
  AForm: TdxPDFXForm;
begin
  AForm := GetAppearanceForm(AState);
  if (AForm = nil) and (AState <> asNormal) then
    AActualState := asNormal
  else
    AActualState := AState;
  Result := EnsureAppearanceForm(AActualState, AForm)
end;

function TdxPDFCustomAnnotation.EnsureAppearanceForm(AState: TdxPDFAnnotationAppearanceState; AForm: TdxPDFXForm): TdxPDFXForm;

  function IsAppearanceNeeded: Boolean;
  begin
    try
      Result := AppearanceNeeded(AForm);
    except
      Result := True;
    end;
  end;

begin
  Result := AForm;
  if not IsAppearanceNeeded then
    Exit;
  if Result = nil then
    Result := CreateAppearanceForm(AState);
  Rebuild(Result);
end;

function TdxPDFCustomAnnotation.GetAppearanceForm(AState: TdxPDFAnnotationAppearanceState): TdxPDFXForm;
begin
  Result := GetAppearanceForm(AState, AppearanceName);
end;

function TdxPDFCustomAnnotation.GetAppearanceForm(AState: TdxPDFAnnotationAppearanceState;
  const AAppearanceName: string): TdxPDFXForm;
var
  AAnnotationAppearanceState: TdxPDFAnnotationAppearance;
  AForm: TdxPDFXForm;
begin
  Ensure;
  if Appearance <> nil then
  begin
    case AState of
      asDown:
        AAnnotationAppearanceState := FAppearance.Down;
      asRollover:
        AAnnotationAppearanceState := FAppearance.Rollover;
    else
      AAnnotationAppearanceState := FAppearance.Normal;
    end;
    if AAnnotationAppearanceState <> nil then
    begin
      AForm := nil;
      if (AAppearanceName <> '') and (AAnnotationAppearanceState.Forms <> nil) and
        not AAnnotationAppearanceState.Forms.TryGetValue(AAppearanceName, AForm) then
          AForm := nil;
      if (AForm = nil) and UseDefaultAppearance then
        AForm := AAnnotationAppearanceState.DefaultForm;
      Exit(AForm);
    end;
  end;
  Result := nil;
end;

function TdxPDFCustomAnnotation.IsHidden: Boolean;
begin
  Result := HasFlag(afHidden);
end;

function TdxPDFCustomAnnotation.UseDefaultAppearance: Boolean;
begin
  Result := True;
end;

procedure TdxPDFCustomAnnotation.Accept(const AVisitor: IdxPDFCustomAnnotationVisitor);
begin
  AVisitor.Visit(Self);
end;

procedure TdxPDFCustomAnnotation.Rebuild(AForm: TdxPDFXForm);
var
  ABuilder: TdxPDFAnnotationAppearanceBuilder;
begin
  if AForm = nil then
    Exit;
  if Safe.Cast(CreateAppearanceBuilder, TdxPDFAnnotationAppearanceBuilder, ABuilder) then
    try
      ABuilder.RebuildAppearance(AForm);
    finally
      ABuilder.Free;
    end;
end;

procedure TdxPDFCustomAnnotation.DestroySubClasses;
begin
  FResolved := True;
  Border := nil;
  Color := TdxPDFColor.Null;
  Appearance := nil;
  Dictionary := nil;
  if FNeedFreeAppearanceRawObject then
    dxPDFFreeObject(FAppearanceRawObject);
  inherited DestroySubClasses;
end;

procedure TdxPDFCustomAnnotation.DoRead(ADictionary: TdxPDFReaderDictionary);
var
  AObject: TdxPDFBase;
begin
  Dictionary := ADictionary;
  if Dictionary.TryGetObject(TdxPDFKeywords.AnnotationAppearance, AObject) then
    FAppearanceRawObject := AObject;
  inherited DoRead(ADictionary);
end;

procedure TdxPDFCustomAnnotation.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  Ensure;
  ADictionary.AddName(TdxPDFKeywords.TypeKey, TdxPDFKeywords.Annotation);
  ADictionary.AddName(TdxPDFKeywords.Subtype, GetTypeName);
  ADictionary.AddReference(TdxPDFKeywords.ShortPage, FPage);
  ADictionary.Add(TdxPDFKeywords.Rect, FRect, False);
  ADictionary.Add(TdxPDFKeywords.Contents, FContents);
  ADictionary.Add(TdxPDFKeywords.AnnotationName, Name);
  ADictionary.AddDate(TdxPDFKeywords.Modified, FModified);
  if FFlags <> afNone then
    ADictionary.Add(TdxPDFKeywords.AnnotationFlags, Ord(FFlags));
  ADictionary.AddName(TdxPDFKeywords.AnnotationAppearanceName, FAppearanceName, False);
  ADictionary.AddInline(TdxPDFKeywords.AnnotationAppearance, Appearance);
  if (FBorder <> nil) and not FBorder.IsDefault then
    ADictionary.AddInline(TdxPDFKeywords.Border, FBorder);
  ADictionary.Add(TdxPDFKeywords.AnnotationColor, FColor);
  ADictionary.Add(TdxPDFKeywords.StructParent, FStructParent, 0);
end;

function TdxPDFCustomAnnotation.AppearanceNeeded(AForm: TdxPDFXForm): Boolean;
begin
  Result := (AForm = nil) or (AForm.Commands.Count = 0);
end;

function TdxPDFCustomAnnotation.CreateAppearanceBuilder: TObject;
begin
  Result := nil;
end;

function TdxPDFCustomAnnotation.GetAppearanceBBox: TdxPDFRectangle;
begin
  Result := TdxPDFRectangle.Create(0, 0, Rect.Width, Rect.Height);
end;

function TdxPDFCustomAnnotation.GetVisible: Boolean;
begin
  Result := not HasFlag(TdxPDFAnnotationFlags.afNoView) and not HasFlag(TdxPDFAnnotationFlags.afHidden) and
    (Rect.Width <> 0) and (Rect.Height <> 0);
end;

function TdxPDFCustomAnnotation.GetRect: TdxPDFRectangle;
begin
  Ensure;
  Result := FRect;
end;

procedure TdxPDFCustomAnnotation.SetAppearance(const AValue: TdxPDFAnnotationAppearances);
begin
  DoSetAppearance(AValue);
end;

function TdxPDFCustomAnnotation.GetContents: string;
begin
  Ensure;
  Result := FContents;
end;

function TdxPDFCustomAnnotation.GetName: string;
begin
  Ensure;
  Result := FName;
end;

function TdxPDFCustomAnnotation.GetPageRect: TdxPDFPageRect;
begin
  Result := TdxPDFPageRect.Create(PageIndex, Rect.ToRectF);
end;

function TdxPDFCustomAnnotation.GetReadOnly: Boolean;
begin
  Result := HasFlag(afReadOnly);
end;

function TdxPDFCustomAnnotation.GetPageIndex: Integer;
begin
  Result := Catalog.Pages.IndexOf(Page);
end;

function TdxPDFCustomAnnotation.GetAppearance: TdxPDFAnnotationAppearances;
begin
  if FAppearance = nil then
    DoSetAppearance(Repository.GetAnnotationAppearance(FAppearanceRawObject, FRect));
  Result := FAppearance;
end;

function TdxPDFCustomAnnotation.GetColor: TdxPDFColor;
begin
  Ensure;
  Result := FColor;
end;

procedure TdxPDFCustomAnnotation.SetColor(const AValue: TdxPDFColor);
begin
  Ensure;
  FColor := AValue;
end;

procedure TdxPDFCustomAnnotation.SetContents(const AValue: string);
begin
  Ensure;
  FContents := AValue;
end;

procedure TdxPDFCustomAnnotation.SetDictionary(const AValue: TdxPDFReaderDictionary);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FDictionary));
end;

procedure TdxPDFCustomAnnotation.SetName(const AValue: string);
begin
  Ensure;
  FName := AValue;
end;

procedure TdxPDFCustomAnnotation.DoSetAppearance(const AValue: TdxPDFAnnotationAppearances);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FAppearance));
end;

function TdxPDFCustomAnnotation.GetAppearanceName: string;
begin
  Ensure;
  Result := FAppearanceName;
end;

function TdxPDFCustomAnnotation.GetBorder: TdxPDFAnnotationBorder;
begin
  Ensure;
  Result := FBorder;
end;

function TdxPDFCustomAnnotation.GetCatalog: TdxPDFCatalog;
begin
  Result := Repository.Catalog;
end;

procedure TdxPDFCustomAnnotation.SetAppearanceName(const AValue: string);
begin
  Ensure;
  FAppearanceName := AValue;
end;

procedure TdxPDFCustomAnnotation.SetBorder(const AValue: TdxPDFAnnotationBorder);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FBorder));
end;

procedure TdxPDFCustomAnnotation.Ensure;
begin
  if not FResolved and (FDictionary <> nil) then
  begin
    FResolved := True;
    Resolve(FDictionary);
  end;
end;

procedure TdxPDFCustomAnnotation.Resolve(ADictionary: TdxPDFReaderDictionary);
begin
  FRect := ADictionary.GetRectangleEx(TdxPDFKeywords.Rect);
  FContents := ADictionary.GetTextString(TdxPDFKeywords.Contents);
  FName := ADictionary.GetTextString(TdxPDFKeywords.AnnotationName);
  FModified := ADictionary.GetDate(TdxPDFKeywords.Modified);
  FFlags := TdxPDFAnnotationFlags(ADictionary.GetInteger(TdxPDFKeywords.AnnotationFlags, 0));
  FAppearanceName := ADictionary.GetString(TdxPDFKeywords.AnnotationAppearanceName);
  FStructParent := ADictionary.GetInteger(TdxPDFKeywords.StructParent);
  FColor := ADictionary.GetColor(TdxPDFKeywords.AnnotationColor);
  FBorder := Repository.CreateAndRead(TdxPDFAnnotationBorder, ADictionary) as TdxPDFAnnotationBorder;
  FBorder.Reference;
end;

function TdxPDFCustomAnnotation.HasFlag(AFlags: TdxPDFAnnotationFlags): Boolean;
begin
  Result := (Integer(FFlags) and Integer(AFlags)) <> 0;
end;

procedure TdxPDFCustomAnnotation.SetAppearanceRawObject(AObject: TdxPDFBase);
begin
  if FAppearanceRawObject <> AObject then
  begin
    FreeAndNil(FAppearance);
    FAppearanceRawObject := AObject;
    FNeedFreeAppearanceRawObject := True;
  end;
end;

{ TdxPDFFileAttachment }

constructor TdxPDFFileAttachment.Create;
begin
  Create(TdxPDFFileSpecification.Create(nil, ''));
  FOwnsSpecification := True;
end;

destructor TdxPDFFileAttachment.Destroy;
begin
  if FOwnsSpecification then
  begin
    FFileSpecification.FAttachment := nil;
    FreeAndNil(FFileSpecification);
  end;
  inherited Destroy;
end;

procedure TdxPDFFileAttachment.LoadFromFile(const AFileName: string);
var
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    FileName := TPath.GetFileName(AFileName);
    LoadFromStream(AStream);
  finally
    AStream.Free;
  end;
end;

procedure TdxPDFFileAttachment.LoadFromStream(AStream: TStream);
var
  ABuffer: TMemoryStream;
  AData: TBytes;
  APosition: Int64;
begin
  APosition := AStream.Position;
  ABuffer := TMemoryStream.Create;
  try
    SetLength(AData, AStream.Size);
    AStream.ReadBuffer(AData[0], AStream.Size);
    FileSpecification.FileData := AData;
  finally
    ABuffer.Free;
    AStream.Position := APosition;
  end;
end;

procedure TdxPDFFileAttachment.SaveToFile(const AFileName: string);
var
  AStream: TMemoryStream;
begin
  AStream := TMemoryStream.Create;
  try
    SaveToStream(AStream);
    AStream.SaveToFile(AFileName);
  finally
    AStream.Free;
  end;
end;

procedure TdxPDFFileAttachment.SaveToStream(AStream: TStream);
begin
  AStream.WriteBuffer(Data[0], Length(Data));
end;

constructor TdxPDFFileAttachment.Create(AFileSpecification: TdxPDFFileSpecification);
begin
  inherited Create;
  FFileSpecification := AFileSpecification;
  FFileSpecification.Attachment := Self;
end;

function TdxPDFFileAttachment.GetCreationDate: TDateTime;
begin
  Result := FFileSpecification.CreationDate;
end;

function TdxPDFFileAttachment.GetModificationDate: TDateTime;
begin
  Result := FFileSpecification.ModificationDate;
end;

function TdxPDFFileAttachment.GetMimeType: string;
begin
  Result := FFileSpecification.MimeType;
end;

function TdxPDFFileAttachment.GetData: TBytes;
begin
  Result := FFileSpecification.FileData;
end;

function TdxPDFFileAttachment.GetSize: Integer;
begin
  Result := FFileSpecification.Size;
end;

procedure TdxPDFFileAttachment.SetCreationDate(const AValue: TDateTime);
begin
  FileSpecification.CreationDate := AValue;
end;

procedure TdxPDFFileAttachment.SetData(const AValue: TBytes);
begin
  FileSpecification.FileData := AValue;
end;

procedure TdxPDFFileAttachment.SetDescription(const AValue: string);
begin
  FileSpecification.Description := AValue;
end;

procedure TdxPDFFileAttachment.SetFileName(const AValue: string);
begin
  FileSpecification.FileName := AValue;
end;

procedure TdxPDFFileAttachment.SetModificationDate(const AValue: TDateTime);
begin
  FileSpecification.ModificationDate := AValue;
end;

function TdxPDFFileAttachment.GetFileName: string;
begin
  Result := FileSpecification.FileName;
end;

function TdxPDFFileAttachment.GetRelationship: TdxPDFAssociatedFileRelationship;
begin
  Result := FileSpecification.Relationship;
end;

function TdxPDFFileAttachment.GetDescription: string;
begin
  Result := FileSpecification.Description;
end;

function TdxPDFFileAttachment.GetModificationDateAsString: string;
begin
  if FileSpecification.HasModificationDate then
    Result := DateTimeToStr(ModificationDate)
  else
    Result := '';
end;

function TdxPDFFileAttachment.GetSizeAsString: string;
begin
  if Size > 0 then
    Result := TdxPDFUtils.FormatFileSize(Size)
  else
    Result := '';
end;

{ TdxPDFFileAttachmentList }

function TdxPDFFileAttachmentList.IsLocked: Boolean;
begin
  Result := FLockCount <> 0;
end;

function TdxPDFFileAttachmentList.TryFindFileAttachmentAnnotation(AAttachment: TdxPDFFileAttachment;
  out AAnnotation: TdxPDFCustomAnnotation): Boolean;
var
  AResult: TdxPDFCustomAnnotation;
begin
  if FCatalog = nil then
    Exit(False);
  FCatalog.EnumAnnotations(
    function(AObject: TdxPDFCustomAnnotation): Boolean
    begin
      Result := (AObject is TdxPDFFileAttachmentAnnotation) and
        (TdxPDFFileAttachmentAnnotation(AObject).Attachment = AAttachment);
      if Result then
        AResult := AObject;
    end);
  AAnnotation := AResult;
  Result := AAnnotation <> nil;
end;

procedure TdxPDFFileAttachmentList.DoAdd(AAttachment: TdxPDFFileAttachment);
begin
  if not Contains(AAttachment) then
    Add(AAttachment);
end;

procedure TdxPDFFileAttachmentList.LockAndExecute(AProc: TProc);
begin
  if not Assigned(AProc) then
    Exit;
  Inc(FLockCount);
  try
    AProc;
  finally
    Dec(FLockCount);
  end;
end;

function TdxPDFFileAttachmentList.Add: TdxPDFFileAttachment;
begin
  Result := TdxPDFFileAttachment.Create;
  inherited Add(Result);
end;

function TdxPDFFileAttachmentList.Extract(AValue: TdxPDFFileAttachment): TdxPDFFileAttachment;
begin
  Result := inherited Extract(AValue);
end;

function TdxPDFFileAttachmentList.Remove(AValue: TdxPDFFileAttachment): Integer;
begin
  Result := inherited Remove(AValue);
end;

procedure TdxPDFFileAttachmentList.Notify(const AValue: TdxPDFFileAttachment; AAction: TCollectionNotification);
begin
  inherited Notify(AValue, AAction);
  if (FCatalog = nil) or IsLocked then
    Exit;
  case AAction of
    cnAdded: OnAdded(AValue);
    cnRemoved: OnRemoved(AValue)
  else
    OnExtracted(AValue);
  end;
end;

procedure TdxPDFFileAttachmentList.Refresh;
begin
  if FCatalog = nil then
    Exit;
  FCatalog.BeginUpdate;
  try
    LockAndExecute(
      procedure
      var
       AKey: string;
       ASpecification: TdxPDFFileSpecification;
      begin
        if FCatalog.Names <> nil then
          for AKey in FCatalog.Names.EmbeddedFileSpecifications.Keys do
          begin
            ASpecification := FCatalog.Names.EmbeddedFileSpecifications.GetValue(AKey);
            if ASpecification <> nil then
              DoAdd(ASpecification.Attachment);
          end;

        FCatalog.EnumAnnotations(
          function(AAnnotation: TdxPDFCustomAnnotation): Boolean
          begin
            Result := False;
            if AAnnotation is TdxPDFFileAttachmentAnnotation then
              DoAdd(TdxPDFFileAttachmentAnnotation(AAnnotation).Attachment);
          end);
      end);
  finally
    FCatalog.CancelUpdate;
  end;
end;

procedure TdxPDFFileAttachmentList.OnAdded(AValue: TdxPDFFileAttachment);
begin
  FCatalog.Names.AddFileSpecification(AValue.FileSpecification);
end;

procedure TdxPDFFileAttachmentList.OnExtracted(AValue: TdxPDFFileAttachment);
begin
  LockAndExecute(
    procedure
    var
      AAnnotation: TdxPDFCustomAnnotation;
    begin
      if FCatalog.Names.EmbeddedFileSpecifications.ContainsValue(AValue.FileSpecification) then
        FCatalog.Names.ExtractFileSpecification(AValue.FileSpecification)
      else
        if TryFindFileAttachmentAnnotation(AValue, AAnnotation) then
        begin
          Extract(AValue);
          AAnnotation.Page.Annotations.Extract(AAnnotation);
        end;
    end);
end;

procedure TdxPDFFileAttachmentList.OnRemoved(AValue: TdxPDFFileAttachment);
begin
  LockAndExecute(
    procedure
    var
      AAnnotation: TdxPDFCustomAnnotation;
    begin
      if FCatalog.Names.EmbeddedFileSpecifications.ContainsValue(AValue.FileSpecification) then
        FCatalog.Names.RemoveFileSpecification(AValue.FileSpecification)
      else
        if TryFindFileAttachmentAnnotation(AValue, AAnnotation) then
        begin
          Remove(AValue);
          AAnnotation.Page.Annotations.Remove(AAnnotation);
        end;
    end);
end;

{ TdxPDFDocumentNames }

procedure TdxPDFDocumentNames.AddFileSpecification(AValue: TdxPDFFileSpecification);
begin
  AValue.SetParent(Parent);
  EmbeddedFileSpecifications.Add(AValue);
end;

procedure TdxPDFDocumentNames.ExtractFileSpecification(AValue: TdxPDFFileSpecification);
begin
  AValue.SetParent(nil);
  EmbeddedFileSpecifications.Extract(AValue);
end;

procedure TdxPDFDocumentNames.RemoveFileSpecification(AValue: TdxPDFFileSpecification);
begin
  EmbeddedFileSpecifications.Remove(AValue);
end;

procedure TdxPDFDocumentNames.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FPageDestinations := TdxPDFDestinationTree.Create(Repository);
  FEmbeddedFileSpecifications := TdxPDFEmbeddedFileSpecificationTree.Create(Repository);
end;

procedure TdxPDFDocumentNames.DestroySubClasses;
begin
  FreeAndNil(FEmbeddedFileSpecifications);
  FreeAndNil(FPageDestinations);
  inherited DestroySubClasses;
end;

procedure TdxPDFDocumentNames.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  FPageDestinations.Read(ADictionary.GetDictionary(TdxPDFKeywords.Destinations));
  FEmbeddedFileSpecifications.Read(ADictionary.GetDictionary(TdxPDFKeywords.EmbeddedFiles));
end;

procedure TdxPDFDocumentNames.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited;
  ADictionary.AddInline(TdxPDFKeywords.Destinations, FPageDestinations);
  ADictionary.AddInline(TdxPDFKeywords.EmbeddedFiles, FEmbeddedFileSpecifications);
end;

function TdxPDFDocumentNames.GetEmbeddedFileSpecification(const AName: string): TdxPDFFileSpecification;
begin
  Result := FEmbeddedFileSpecifications.GetValue(AName);
end;

function TdxPDFDocumentNames.GetPageDestination(const AName: string): TdxPDFCustomDestination;
begin
  Result := FPageDestinations.GetValue(AName);
end;

{ TdxPDFDocumentInformation }

class function TdxPDFDocumentInformation.GetTypeName: string;
begin
  Result := TdxPDFKeywords.DocumentInfo;
end;

procedure TdxPDFDocumentInformation.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  FAuthor := ADictionary.GetTextString(TdxPDFKeywords.Author);
  FCreationDate := ADictionary.GetDate(TdxPDFKeywords.CreationDate);
  FApplication := ADictionary.GetTextString(TdxPDFKeywords.Creator);
  FKeywords := ADictionary.GetTextString(TdxPDFKeywords.Keywords);
  FModificationDate := ADictionary.GetDate(TdxPDFKeywords.ModDate);
  FProducer := ADictionary.GetTextString(TdxPDFKeywords.Producer);
  FSubject := ADictionary.GetTextString(TdxPDFKeywords.Subject);
  FTitle := ADictionary.GetTextString(TdxPDFKeywords.Title);
end;

procedure TdxPDFDocumentInformation.Initialize;
begin
  inherited Initialize;
  FVersion := v1_7;
end;

procedure TdxPDFDocumentInformation.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
var
  ADate: TDateTime;
begin
  ADate := Now;
  FCreationDate := ADate;
  FModificationDate := ADate;

  ADictionary.Add(TdxPDFKeywords.Author, FAuthor);
  ADictionary.Add(TdxPDFKeywords.Creator, FApplication);
  ADictionary.Add(TdxPDFKeywords.Keywords, FKeywords);
  ADictionary.Add(TdxPDFKeywords.Producer, FProducer);
  ADictionary.Add(TdxPDFKeywords.Subject, FSubject);
  ADictionary.Add(TdxPDFKeywords.Title, FTitle);
  ADictionary.AddDate(TdxPDFKeywords.CreationDate, FCreationDate);
  ADictionary.AddDate(TdxPDFKeywords.ModDate, FModificationDate);
end;

procedure TdxPDFDocumentInformation.SetApplication(const AValue: string);
begin
  if FApplication <> AValue then
  begin
    FApplication := AValue;
    DataChanged;
  end;
end;

procedure TdxPDFDocumentInformation.SetAuthor(const AValue: string);
begin
  if FAuthor <> AValue then
  begin
    FAuthor := AValue;
    DataChanged;
  end;
end;

procedure TdxPDFDocumentInformation.SetKeywords(const AValue: string);
begin
  if FKeywords <> AValue then
  begin
    FKeywords := AValue;
    DataChanged;
  end;
end;

procedure TdxPDFDocumentInformation.SetProducer(const AValue: string);
begin
  if FProducer <> AValue then
  begin
    FProducer := AValue;
    DataChanged;
  end;
end;

procedure TdxPDFDocumentInformation.SetSubject(const AValue: string);
begin
  if FSubject <> AValue then
  begin
    FSubject := AValue;
    DataChanged;
  end;
end;

procedure TdxPDFDocumentInformation.SetTitle(const AValue: string);
begin
  if FTitle <> AValue then
  begin
    FTitle := AValue;
    DataChanged;
  end;
end;

{ TdxPDFCustomCommand }

constructor TdxPDFCustomCommand.Create;
begin
  inherited Create;
end;

constructor TdxPDFCustomCommand.Create(AOperands: TdxPDFCommandOperandStack; AResources: TdxPDFResources);
begin
  Create;
end;

function TdxPDFCustomCommand.EnsureRange(const AValue: Double): Double;
begin
  Result := Max(Min(AValue, MaxInt), MinInt);
end;

function TdxPDFCustomCommand.EnsureRange(const AValue: Integer): Integer;
begin
  Result := Max(Min(AValue, MaxInt), MinInt);
end;

class function TdxPDFCustomCommand.GetObjectType: TdxPDFBaseType;
begin
  Result := otCommand;
end;

function TdxPDFCustomCommand.GetEquals(ACommand: TdxPDFCustomCommand): Boolean;
begin
  Result := True;
end;

procedure TdxPDFCustomCommand.Write(AWriter: TdxPDFWriter; const AContext: IdxPDFWriterContext; AResources: TdxPDFResources);
begin
  TdxPDFUtils.RaiseException(ClassName + '.Write is not implemented');
end;

procedure TdxPDFCustomCommand.WriteCommandName(AWriter: TdxPDFWriter);
begin
  AWriter.WriteSpace;
  AWriter.WriteString(GetName);
end;

procedure TdxPDFCustomCommand.WriteOperand(AWriter: TdxPDFWriter; const AOperand: Double);
begin
  AWriter.WriteSpace;
  AWriter.WriteDouble(EnsureRange(AOperand));
end;

procedure TdxPDFCustomCommand.WriteOperand(AWriter: TdxPDFWriter; const AOperand: Integer);
begin
  AWriter.WriteSpace;
  AWriter.WriteInteger(EnsureRange(AOperand));
end;

procedure TdxPDFCustomCommand.WriteOperand(AWriter: TdxPDFWriter; const AOperand: TdxSizeF);
begin
  WriteOperand(AWriter, AOperand.cx);
  WriteOperand(AWriter, AOperand.cy);
end;

procedure TdxPDFCustomCommand.WriteOperand(AWriter: TdxPDFWriter; const AOperand: TdxPointF);
begin
  WriteOperand(AWriter, AOperand.X);
  WriteOperand(AWriter, AOperand.Y);
end;

procedure TdxPDFCustomCommand.WriteOperand(AWriter: TdxPDFWriter; const AOperand: string);
begin
  AWriter.WriteSpace;
  AWriter.WriteString(AOperand);
end;

procedure TdxPDFCustomCommand.WriteUnaryCommand(AWriter: TdxPDFWriter; const AOperand: Single);
begin
  WriteOperand(AWriter, AOperand);
  WriteCommandName(AWriter);
end;

procedure TdxPDFCustomCommand.WriteUnaryCommand(AWriter: TdxPDFWriter; const AOperand: Integer);
begin
  WriteOperand(AWriter, AOperand);
  WriteCommandName(AWriter);
end;

procedure TdxPDFCustomCommand.WriteUnaryCommand(AWriter: TdxPDFWriter; const AOperand: string);
begin
  WriteOperand(AWriter, AOperand);
  WriteCommandName(AWriter);
end;

procedure TdxPDFCustomCommand.WriteUnaryCommand(AWriter: TdxPDFWriter; const AOperand: TdxPointF);
begin
  WriteOperand(AWriter, AOperand);
  WriteCommandName(AWriter);
end;

class function TdxPDFCustomCommand.GetName: string;
begin
  Result := '';
end;

function TdxPDFCustomCommand.GetCommandCount: Integer;
begin
  Result := 1;
end;

function TdxPDFCustomCommand.Equals(AObject: TObject): Boolean;
var
  ACommand: TdxPDFCustomCommand;
begin
  Result := Safe.Cast(AObject, ClassType, ACommand) and GetEquals(ACommand);
end;

{ TdxPDFDocumentRepository }

constructor TdxPDFDocumentRepository.Create(ADocument: TObject; AStream: TStream);
begin
  FStream := AStream;
  inherited Create;
  FDocument := ADocument;
end;

procedure TdxPDFDocumentRepository.Clear;
var
  AForm: TdxPDFXForm;
begin
  inherited Clear;
  FResolvedInteractiveFormFields.Clear;
  FResolvedWidgets.Clear;
  FFontDataStorage.Clear;
  FFontProvider.Clear;
  FSharedResources.Clear;
  FObjectHolder.Clear;
  while FResolvedForms.Count > 0 do
  begin
    AForm := TdxPDFXForm(FResolvedForms[0]);
    if not AForm.TryReleaseCircularReferencesAndFree then
      AForm.Free;
  end;
  dxTestCheck(FResolvedForms.Count = 0, 'FResolvedForms.Count <> 0');
end;

function TdxPDFDocumentRepository.CreateAction(ARawObject: TdxPDFReaderDictionary): TdxPDFCustomAction;
var
  AActionType, AType: string;
  AClass: TdxPDFObjectClass;
begin
  Result := nil;
  if ARawObject <> nil then
  begin
    AActionType := ARawObject.GetString(TdxPDFKeywords.ActionType);
    AType := ARawObject.GetString(TdxPDFKeywords.TypeKey);
    if (AType <> '') and (AType <> TdxPDFKeywords.Action) and (AType <> 'A') then
      TdxPDFUtils.RaiseException;
    if dxPDFTryGetDocumentObjectClass(AActionType, AClass) then
      Result := CreateAndRead(AClass, ARawObject) as TdxPDFCustomAction;
  end;
end;

function TdxPDFDocumentRepository.CreateAndRead(AClass: TdxPDFObjectClass;
  ARawObject: TdxPDFReaderDictionary; ARawObjectKey: string = ''): TdxPDFObject;
begin
  Result := CreateAndRead(AClass, ARawObject, nil, ARawObjectKey);
end;

function TdxPDFDocumentRepository.CreateAndRead(AClass: TdxPDFObjectClass; ARawObject: TdxPDFReaderDictionary;
  AParent: TdxPDFObject; ARawObjectKey: string = ''): TdxPDFObject;
var
  ADictionary: TdxPDFReaderDictionary;
begin
  if AParent = nil then
    Result := AClass.CreateEx(Self)
  else
    Result := AClass.Create(AParent);
  if ARawObjectKey = '' then
    ADictionary := ARawObject
  else
    ADictionary := ARawObject.GetDictionary(ARawObjectKey);
  if ADictionary <> nil then
    Result.Read(ADictionary);
end;

function TdxPDFDocumentRepository.CreateAndReadAnnotation(APage: TdxPDFPage; ARawObject: TdxPDFReaderDictionary): TdxPDFCustomAnnotation;
begin
  Result := CreateAnnotation(APage, ARawObject);
  if Result <> nil then
    Result.Read(ARawObject);
end;

function TdxPDFDocumentRepository.CreateAnnotation(APage: TdxPDFPage; ARawObject: TdxPDFReaderDictionary): TdxPDFCustomAnnotation;
var
  ATypeName: string;
begin
  if ARawObject <> nil then
  begin
    ATypeName := ARawObject.GetString(TdxPDFKeywords.Subtype);
    if ATypeName = '' then
      ATypeName := ARawObject.GetString(TdxPDFKeywords.TypeKey);
    Result := CreateObject(ATypeName) as TdxPDFCustomAnnotation;
    if Result <> nil then
      Result.Page := APage;
  end
  else
    Result := nil;
end;

function TdxPDFDocumentRepository.CreateAppearance(const ABBox: TdxPDFRectangle): TdxPDFAnnotationAppearance;
begin
  Result := TdxPDFAnnotationAppearance.Create(Self, ABBox);
end;

function TdxPDFDocumentRepository.CreateAppearance(ARawObject: TdxPDFReaderDictionary;
  const AAppearanceName: string): TdxPDFAnnotationAppearance;
var
  AAppearanceSubDictionary: TdxPDFReaderDictionary;
  ADefaultForm: TdxPDFXForm;
  AForms: TdxPDFStringFormDictionary;
  AValue: TdxPDFBase;
begin
  Result := nil;
  AValue := ARawObject.GetObject(AAppearanceName);
  if AValue <> nil then
  begin
    AForms := nil;
    ADefaultForm := nil;
    if AValue is TdxPDFXForm then
      ADefaultForm := TdxPDFXForm(AValue);
    case AValue.ObjectType of
      otStream:
        begin
          ADefaultForm := GetForm(AValue.Number);
          if ADefaultForm = nil then
            Exit(nil);
        end;
      otDictionary:
        begin
          ADefaultForm := nil;
          AForms := TdxPDFStringFormDictionary.Create;
          AAppearanceSubDictionary := TdxPDFReaderDictionary(AValue);
          AAppearanceSubDictionary.EnumKeys(
            procedure(const AKey: string)
            var
              AForm: TdxPDFXForm;
              AObject: TdxPDFBase;
            begin
              if AAppearanceSubDictionary.TryGetObject(AKey, AObject) then
              begin
                AForm := GetForm(AObject.Number);
                AForms.Add(AKey, AForm);
                if (AKey = 'On') or (ADefaultForm = nil) and (AKey <> TdxPDFKeywords.OffStateName) then
                  ADefaultForm := AForm;
              end
              else
                AForms.Add(AKey, nil);
            end);
        end;
    end;
    Result := TdxPDFAnnotationAppearance.Create(ADefaultForm, AForms);
  end;
end;

function TdxPDFDocumentRepository.CreateBorderStyle: TdxPDFAnnotationBorderStyle;
begin
  Result := TdxPDFAnnotationBorderStyle.CreateEx(Self);
end;

function TdxPDFDocumentRepository.CreateBorderStyle(ARawObject: TdxPDFReaderDictionary): TdxPDFAnnotationBorderStyle;
var
  ADictionary: TdxPDFReaderDictionary;
begin
  if (ARawObject <> nil) and ARawObject.TryGetDictionary(TdxPDFKeywords.AnnotationBorderStyle, ADictionary) then
    Result := CreateAndRead(TdxPDFAnnotationBorderStyle, ADictionary) as TdxPDFAnnotationBorderStyle
  else
    Result := nil;
end;

function TdxPDFDocumentRepository.CreateCatalog: TdxPDFCatalog;
begin
  Result := CreateObject(TdxPDFCatalog) as TdxPDFCatalog;
end;

function TdxPDFDocumentRepository.CreateCharacterMapping(const AData: TBytes): TdxPDFCharacterMapping;
var
  AParser: TdxPDFCMapStreamParser;
begin
  AParser := TdxPDFCMapStreamParser.Create(Self);
  try
    try
      Result := AParser.Read(AData);
    except
      Result := nil;
    end;
  finally
    AParser.Free;
  end;
end;

function TdxPDFDocumentRepository.CreateCIDSystemInfo: TdxPDFCIDSystemInfo;
begin
  Result := TdxPDFCIDSystemInfo.CreateEx(Self);
end;

function TdxPDFDocumentRepository.CreateColorSpace(AClass: TdxPDFObjectClass): TdxPDFCustomColorSpace;
begin
  Result := CreateColorSpace(AClass, Parent);
end;

function TdxPDFDocumentRepository.CreateColorSpace(AClass: TdxPDFObjectClass; AParent: TdxPDFObject): TdxPDFCustomColorSpace;
begin
  Result := CreateObject(AClass, AParent) as TdxPDFCustomColorSpace;
end;

function TdxPDFDocumentRepository.CreateColorSpace(ARawObject: TdxPDFBase; AResources: TdxPDFResources = nil): TdxPDFCustomColorSpace;
var
  AArray: TdxPDFArray;
  AAttributesDictionary: TdxPDFDictionary;
  AName: TdxPDFName;
  AObjectClass: TdxPDFObjectClass;
  AParameters: TdxPDFBase;
  AReference: TdxPDFReference;
  ATempName: string;
begin
  Result := nil;
  case ARawObject.ObjectType of
    otIndirectReference:
      begin
        AReference := ARawObject as TdxPDFReference;
        if TryGetObject(AReference.Number, AParameters) then
          Result := CreateColorSpace(AParameters, AResources)
        else
          Result := nil;
      end;
    otString, otName:
      Result := CreateColorSpace(TdxPDFName(ARawObject).Value, AResources);
  else
    begin
      AArray := ARawObject as TdxPDFArray;
      if AArray[0].ObjectType = otName then
      begin
        AName := AArray[0] as TdxPDFName;
        AObjectClass := dxPDFGetDocumentObjectClass(AName.Value);
        if AArray.Count = 5 then
        begin
          if AArray[4].ObjectType <> otDictionary then
          begin
            AAttributesDictionary := GetDictionary((AArray[4] as TdxPDFReference).Number);
            if AAttributesDictionary = nil then
              TdxPDFUtils.RaiseTestException;
          end
          else
            AAttributesDictionary := AArray[4] as TdxPDFDictionary;
          ATempName := AAttributesDictionary.GetString(TdxPDFKeywords.Subtype);
          if ATempName = '' then
            AObjectClass := TdxPDFDeviceNColorSpace
          else
            AObjectClass := dxPDFGetDocumentObjectClass(ATempName);
        end;
        if AObjectClass <> nil then
        begin
          Result := CreateColorSpace(AObjectClass);
          Result.InternalRead(AArray);
        end
        else
          TdxPDFUtils.RaiseTestException('Unknown color space:' + AName.Value);
      end
      else
        TdxPDFUtils.RaiseTestException;
    end;
  end;
end;

function TdxPDFDocumentRepository.CreateColorSpace(const AName: string; AResources: TdxPDFResources): TdxPDFCustomColorSpace;
var
  AClass: TdxPDFObjectClass;
begin
  Result := nil;
  if dxPDFTryGetDocumentObjectClass(AName, AClass) then
    Result := CreateColorSpace(AClass)
  else
    if AResources <> nil then
      Result := AResources.GetColorSpace(AName);
end;

function TdxPDFDocumentRepository.CreateDeferredObject(AParent: TdxPDFObject;
  AResolvedObjectClass: TdxPDFObjectClass): TdxPDFDeferredObject;
begin
  Result := TdxPDFDeferredObject.Create(AParent, AResolvedObjectClass.Create(AParent));
end;

function TdxPDFDocumentRepository.CreateDeferredObject(AParent: TdxPDFObject;
  const AInfo: TdxPDFDeferredObjectInfo): TdxPDFDeferredObject;
begin
  Result := TdxPDFDeferredObject.Create(AParent, AInfo);
end;

function TdxPDFDocumentRepository.CreateDeferredObject(const AInfo: TdxPDFDeferredObjectInfo): TdxPDFDeferredObject;
begin
  Result := CreateDeferredObject(Parent, AInfo);
end;

function TdxPDFDocumentRepository.CreateDestination(ARawObject: TdxPDFBase): TdxPDFCustomDestination;

  function GetClassName(AArray: TdxPDFArray): string;
  begin
    if AArray.Count < 1 then
      Result := ''
    else
    begin
      Result := TdxPDFKeywords.XYZDestination;
      if (AArray.Count > 1) and (AArray[1] is TdxPDFString) then
        Result := TdxPDFString(AArray[1]).Value;
    end;
  end;

var
  AArray: TdxPDFArray;
  AClass: TdxPDFObjectClass;
  ADictionary: TdxPDFReaderDictionary;
begin
  Result := nil;
  if ARawObject <> nil then
  begin
    case ARawObject.ObjectType of
      otDictionary:
        AArray := TdxPDFDictionary(ARawObject).GetArray('D');
      otArray:
        AArray := TdxPDFArray(ARawObject);
      otIndirectReference:
        begin
          if Catalog <> nil then
          begin
            AArray := GetArray(ARawObject.Number);
            if AArray = nil then
            begin
              ADictionary := GetDictionary(ARawObject.Number);
              if ADictionary <> nil then
                Result := CreateDestination(ADictionary.GetObject('D'));
            end
            else
              Result := CreateDestination(AArray);
          end;
          AArray := nil;
        end;
    else
      AArray := nil;
    end;
    if (AArray <> nil) and dxPDFTryGetDocumentObjectClass(GetClassName(AArray), AClass) then
    begin
      Result := CreateObject(AClass) as TdxPDFCustomDestination;
      Result.Read(Catalog, AArray);
    end;
  end;
end;

function TdxPDFDocumentRepository.CreateDictionary: TdxPDFReaderDictionary;
begin
  Result := TdxPDFReaderDictionary.Create(Self);
end;

function TdxPDFDocumentRepository.CreateFileSpecification(ARawObject: TdxPDFReaderDictionary): TdxPDFFileSpecification;
begin
  if ARawObject <> nil then
  begin
    Result := TdxPDFFileSpecification.Create(Self, '');
    Result.Read(ARawObject);
  end
  else
    Result := nil;
end;

function TdxPDFDocumentRepository.CreateFont(ARawObject: TdxPDFReaderDictionary): TdxPDFCustomFont;
var
  AClass: TdxPDFCustomFontClass;
  AFontDictionary: TdxPDFReaderDictionary;
  AHasBaseFontName, AHasSubtypeName: Boolean;
  AType, ASubtype, ABaseFont: string;
begin
  EnterCriticalSection(FLock);
  try
    Result := nil;
    if (ARawObject <> nil) and not FontDataStorage.TryGetValue(ARawObject.Number, Result) then
    begin
      AType := ARawObject.GetString(TdxPDFKeywords.TypeKey);

      AHasSubtypeName := ARawObject.Contains(TdxPDFKeywords.Subtype);
      if AHasSubtypeName then
        ASubtype := ARawObject.GetString(TdxPDFKeywords.Subtype);

      AHasBaseFontName := ARawObject.Contains(TdxPDFKeywords.BaseFont);
      if AHasBaseFontName then
        ABaseFont := ARawObject.GetString(TdxPDFKeywords.BaseFont);

      AClass := nil;
      if AHasSubtypeName or AHasBaseFontName then
      begin
        if (ASubtype = TdxPDFType3Font.GetSubTypeName) or AHasBaseFontName then
        begin
          if (ASubtype = TdxPDFType0Font.GetSubTypeName) and AHasSubtypeName then
          begin
            AFontDictionary := TdxPDFType0Font.GetDictionary(ARawObject);
            if AFontDictionary <> nil then
              ASubtype := AFontDictionary.GetString(TdxPDFKeywords.Subtype)
            else
              ASubtype := '';
          end;
          if not dxPDFFontFactory.TryGetClass(ASubtype, AClass) then
            AClass := TdxPDFUnknownFont;
        end
        else
          TdxPDFUtils.RaiseTestException;
      end;

      if AClass <> nil then
      begin
        Result := CreateObject(AClass) as TdxPDFCustomFont;
        Result.FBaseFont := ABaseFont;
        Result.Read(ARawObject);
        FontDataStorage.Add(Result);
      end;
    end;
  finally
    LeaveCriticalSection(FLock);
  end;
end;

function TdxPDFDocumentRepository.CreateForm(ARawObject: TdxPDFReaderDictionary): TdxPDFXForm;
var
  AClass: TdxPDFObjectClass;
begin
  EnterCriticalSection(FLock);
  try
    if ARawObject.Contains(TdxPDFXFormGroup.GetTypeName) then
      AClass := TdxPDFXFormGroup
    else
      AClass := TdxPDFXForm;
    Result := CreateAndRead(AClass, ARawObject) as TdxPDFXForm;
    AfterCreateForm(Result);
  finally
    LeaveCriticalSection(FLock);
  end;
end;

function TdxPDFDocumentRepository.CreateForm(ARawObject: TdxPDFStream): TdxPDFXForm;
begin
  ARawObject.Dictionary.StreamRef := ARawObject;
  Result := CreateForm(ARawObject.Dictionary as TdxPDFReaderDictionary);
end;

function TdxPDFDocumentRepository.CreateForm(const ABBox: TdxPDFRectangle): TdxPDFXForm;
begin
  Result := TdxPDFXForm.Create(Self, ABBox);
  AfterCreateForm(Result);
end;

function TdxPDFDocumentRepository.CreateGraphicsStateParameters: TdxPDFGraphicsStateParameters;
begin
  Result := CreateObject(TdxPDFGraphicsStateParameters) as TdxPDFGraphicsStateParameters;
end;

function TdxPDFDocumentRepository.CreateGraphicsStateParameters(ARawObject: TdxPDFReaderDictionary): TdxPDFGraphicsStateParameters;
begin
  Result := CreateGraphicsStateParameters;
  Result.Read(ARawObject);
end;

function TdxPDFDocumentRepository.CreateLineStyle(ARawObject: TdxPDFArray): TdxPDFLineStyle;
begin
  if (ARawObject = nil) or (ARawObject.Count <> 2) or (ARawObject.Count = 2) and (ARawObject[0].ObjectType <> otArray) then
    Result := CreateSolidLineStyle
  else
    Result := TdxPDFLineStyle.Create(ARawObject);
end;

function TdxPDFDocumentRepository.CreateMetadata: TdxPDFMetadata;
begin
  Result := CreateObject(TdxPDFMetadata) as TdxPDFMetadata;
end;

function TdxPDFDocumentRepository.CreateImage: TdxPDFDocumentImage;
begin
  Result := CreateImage(Parent);
end;

function TdxPDFDocumentRepository.CreateImage(AStream: TdxPDFStream): TdxPDFDocumentImage;
begin
  Result := CreateImage;
  Result.Read(AStream);
end;

function TdxPDFDocumentRepository.CreateImage(AImage: TdxGPImageHandle): TdxPDFXObject;
begin
  Result := TdxPDFImageToXObjectConverter.Convert(AImage);
  AddSlot(Result);
end;

function TdxPDFDocumentRepository.CreateImage(AParent: TdxPDFObject): TdxPDFDocumentImage;
begin
  Result := CreateObject(TdxPDFDocumentImage, AParent) as TdxPDFDocumentImage;
end;

function TdxPDFDocumentRepository.CreateImage(AParent: TdxPDFObject; ARawObject: TdxPDFReaderDictionary): TdxPDFDocumentImage;
begin
  EnterCriticalSection(FLock);
  try
    if (ARawObject <> nil) and not FImageDataStorage.TryGetReference(ARawObject.Number, Result) then
    begin
      Result := CreateImage(AParent);
      Result.Read(ARawObject);
      FImageDataStorage.Add(Result);
    end;
  finally
    LeaveCriticalSection(FLock);
  end;
end;

function TdxPDFDocumentRepository.CreateInteractiveFormFieldCollection(AParent: TdxPDFObject): TdxPDFInteractiveFormFieldCollection;
begin
  Result := CreateObject(TdxPDFInteractiveFormFieldCollection, AParent) as TdxPDFInteractiveFormFieldCollection;
end;

function TdxPDFDocumentRepository.CreateObject(AClass: TdxPDFObjectClass): TdxPDFObject;
begin
  Result := CreateObject(AClass, Parent);
end;

function TdxPDFDocumentRepository.CreatePattern(AClass: TdxPDFObjectClass): TdxPDFCustomPattern;
begin
  Result := CreateObject(AClass) as TdxPDFCustomPattern;
end;

function TdxPDFDocumentRepository.CreatePattern(ARawObject: TdxPDFBase): TdxPDFCustomPattern;
begin
  Result := nil;
  if ARawObject = nil then
    Exit;
  case ARawObject.ObjectType of
    otDictionary:
      begin
        Result := CreatePattern(TdxPDFShadingPattern);
        Result.Read(ARawObject as TdxPDFReaderDictionary);
      end;
    otStream:
      begin
        Result := CreatePattern(TdxPDFTilingPattern);
        (ARawObject as TdxPDFStream).Dictionary.StreamRef := TdxPDFStream(ARawObject);
        TdxPDFStream(ARawObject).Dictionary.Number := ARawObject.Number;
        Result.Read(TdxPDFStream(ARawObject).Dictionary as TdxPDFReaderDictionary);
      end;
  else
    TdxPDFUtils.RaiseTestException('Incorrect pattern source object');
  end;
end;

function TdxPDFDocumentRepository.CreateResources: TdxPDFResources;
begin
  Result := CreateObject(TdxPDFResources) as TdxPDFResources;
end;

function TdxPDFDocumentRepository.CreateResources(ADictionary: TdxPDFReaderDictionary): TdxPDFResources;

  function InternalRead(ANumber: Integer; ADictionary: TdxPDFReaderDictionary): TdxPDFResources;
  var
    AObject: TdxPDFBase;
    ATempResources: TdxPDFResources;
  begin
    if not TdxPDFUtils.IsIntegerValid(ANumber) or not FSharedResources.TryGetValue(ANumber, AObject) then
    begin
      ATempResources := CreateResources;
      ATempResources.Read(ADictionary);
      FSharedResources.Add(ATempResources.ID, ANumber, ATempResources)
    end
    else
      ATempResources := AObject as TdxPDFResources;
    Result := ATempResources;
  end;

var
  ANumber: Integer;
  AResourcesDictionary: TdxPDFReaderDictionary;
begin
  Result := nil;
  AResourcesDictionary := ADictionary.GetDictionary(TdxPDFKeywords.Resources);
  if AResourcesDictionary <> nil then
  begin
    ANumber := AResourcesDictionary.Number;
    if not TdxPDFUtils.IsIntegerValid(ANumber) then
    begin
      ANumber := ADictionary.Number;
      if not TdxPDFUtils.IsIntegerValid(ANumber) and (ADictionary.StreamRef <> nil) then
        ANumber := ADictionary.StreamRef.Number;
    end;
    Result := InternalRead(ANumber, AResourcesDictionary);
  end;
end;

function TdxPDFDocumentRepository.CreateShading(AClass: TdxPDFObjectClass): TdxPDFCustomShading;
begin
  Result := CreateObject(AClass) as TdxPDFCustomShading;
end;

function TdxPDFDocumentRepository.CreateShading(ARawObject: TdxPDFBase): TdxPDFCustomShading;
var
  AType: Integer;
  ADictionary: TdxPDFDictionary;
begin
  case ARawObject.ObjectType of
    otDictionary: ADictionary := ARawObject as TdxPDFDictionary;
    otStream: ADictionary := TdxPDFStream(ARawObject).Dictionary;
    otIndirectReference: ADictionary := GetDictionary(TdxPDFReference(ARawObject).Number);
  else
    ADictionary := nil;
  end;

  if ADictionary <> nil then
  begin
    AType := ADictionary.GetInteger(TdxPDFKeywords.ShadingType);
    if not TdxPDFUtils.IsIntegerValid(AType) then
      TdxPDFUtils.RaiseTestException('Incorrect shading type');
    case AType of
      1: Result := CreateShading(TdxPDFFunctionBasedShading);
      2: Result := CreateShading(TdxPDFAxialShading);
      3: Result := CreateShading(TdxPDFRadialShading)
    else
      Result := nil;
    end;
    if Result <> nil then
      Result.Read(ADictionary as TdxPDFReaderDictionary);
  end
  else
    Result := nil;
end;

function TdxPDFDocumentRepository.CreateSolidLineStyle: TdxPDFLineStyle;
begin
  Result := TdxPDFLineStyle.Create;
end;

function TdxPDFDocumentRepository.CreateSoftMask(AClass: TdxPDFObjectClass): TdxPDFCustomSoftMask;
begin
  Result := CreateObject(AClass) as TdxPDFCustomSoftMask;
end;

function TdxPDFDocumentRepository.CreateSoftMask(ARawObject: TdxPDFBase): TdxPDFCustomSoftMask;
var
  ADictionary: TdxPDFReaderDictionary;
  AType, ASoftMaskType: string;
begin
  Result := nil;
  if ARawObject <> nil then
  begin
    case ARawObject.ObjectType of
      otIndirectReference:
        Result := CreateSoftMask(GetObject(ARawObject.Number) as TdxPDFBase);
      otName:
        begin
          AType := TdxPDFString(ARawObject).Value;
          if AType <> TdxPDFEmptySoftMask.GetTypeName then
            TdxPDFUtils.RaiseTestException;
          Result := CreateSoftMask(TdxPDFEmptySoftMask);
        end;
      otDictionary:
        begin
          ADictionary := TdxPDFReaderDictionary(ARawObject);
          AType := ADictionary.GetString(TdxPDFKeywords.TypeKey);
          ASoftMaskType := ADictionary.GetString(TdxPDFKeywords.MaskStyle);
          if ASoftMaskType = TdxPDFLuminositySoftMask.GetTypeName then
            Result := CreateSoftMask(TdxPDFLuminositySoftMask)
          else
            if ASoftMaskType = TdxPDFAlphaSoftMask.GetTypeName then
              Result := CreateSoftMask(TdxPDFAlphaSoftMask);
          if Result <> nil then
            Result.Read(ADictionary);
        end;
    else
      Result := nil;
    end;
  end;
end;

function TdxPDFDocumentRepository.CreateXObject(ARawObject: TdxPDFStream; const ASubtype: string = ''): TdxPDFXObject;
var
  ADefaultSubtype, AType: string;
begin
  AType := ARawObject.Dictionary.GetString(TdxPDFKeywords.TypeKey);
  ADefaultSubtype := ARawObject.Dictionary.GetString(TdxPDFKeywords.Subtype);
  if ADefaultSubtype = '' then
    ADefaultSubtype := ASubtype;

  if ((AType <> '') and (AType <> TdxPDFKeywords.XObject) and (AType <> TdxPDFKeywords.XObject2)) or (ASubType = '') then
    TdxPDFUtils.RaiseTestException;

  if ADefaultSubtype = TdxPDFDocumentImage.GetTypeName then
    Result := CreateImage(ARawObject)
  else
    if ADefaultSubtype = TdxPDFXForm.GetTypeName then
      Result := CreateForm(ARawObject)
    else
      Result := nil;
end;

function TdxPDFDocumentRepository.AddSlot(AObject: TdxPDFBase): Integer;
begin
  Result := MaxObjectNumber + 1;
  AObject.Number := Result;
  Add(AObject.Number, AObject);
end;

function TdxPDFDocumentRepository.CheckPassword(AAttemptsLimit: Integer; AOnGetPasswordEvent: TdxGetPasswordEvent): Boolean;
begin
  Result := FEncryptionInfo.CheckPassword(AAttemptsLimit, AOnGetPasswordEvent);
end;

function TdxPDFDocumentRepository.GetAction(ANumber: Integer): TdxPDFCustomAction;
var
  AObject: TdxPDFReferencedObject;
begin
  AObject := GetObject(ANumber);
  if (AObject <> nil) and (AObject is TdxPDFCustomAction) then
    Result := TdxPDFCustomAction(AObject)
  else
    if AObject is TdxPDFReaderDictionary then
    begin
      Result := CreateAction(TdxPDFReaderDictionary(AObject));
      ReplaceObject(ANumber, Result);
    end
    else
      Result := nil;
end;

function TdxPDFDocumentRepository.GetAction(AObject: TdxPDFBase): TdxPDFCustomAction;
begin
  Result := GetAction(AObject.Number);
end;

function TdxPDFDocumentRepository.GetAnnotation(ANumber: Integer; APage: TdxPDFPage): TdxPDFCustomAnnotation;
var
  ADictionary: TdxPDFReaderDictionary;
begin
  if not TryGetAnnotation(ANumber, Result) then
  begin
    ADictionary := GetDictionary(ANumber);
    Result := CreateAnnotation(APage, ADictionary);
    if Result <> nil then
    begin
      Result.Number := ANumber;
      ADictionary.Reference;
      ReplaceObject(Result.Number, Result);
      Result.Read(ADictionary);
      dxPDFFreeObject(ADictionary);
    end;
  end;
end;

function TdxPDFDocumentRepository.GetAnnotation(AObject: TdxPDFBase; APage: TdxPDFPage): TdxPDFCustomAnnotation;
begin
  Result := nil;
  if AObject <> nil then
  begin
    if TdxPDFUtils.IsIntegerValid(AObject.Number) then
      Result := GetAnnotation(AObject.Number, APage)
    else
      if AObject is TdxPDFReaderDictionary then
      begin
        Result := CreateAndReadAnnotation(APage, TdxPDFReaderDictionary(AObject));
        AddHoldObject(Result);
      end;
  end;
end;

function TdxPDFDocumentRepository.GetAnnotationAppearance(AObject: TdxPDFBase;
  const AParentBBox: TdxPDFRectangle): TdxPDFAnnotationAppearances;
var
  AResolvedObject: TdxPDFBase;
begin
  Result := nil;
  if AObject <> nil then
    case AObject.ObjectType of
      otDictionary:
        begin
          Result := TdxPDFAnnotationAppearances.CreateEx(Self);
          Result.Read(TdxPDFReaderDictionary(AObject), AParentBBox);
        end;
      otStream:
        Result := TdxPDFAnnotationAppearances.Create(CreateForm(TdxPDFStream(AObject)));
      otIndirectReference:
        begin
          AResolvedObject := GetObject(AObject.Number) as TdxPDFBase;
          if not(AResolvedObject is TdxPDFAnnotationAppearances) then
          begin
            if AResolvedObject.ObjectType = otStream then
            begin
              Result := TdxPDFAnnotationAppearances.CreateEx(Self);
              Result.Read(GetForm(AResolvedObject.Number));
            end
            else
              Result := GetAnnotationAppearance(AResolvedObject, AParentBBox);
          end
          else
            Result := TdxPDFAnnotationAppearances(AResolvedObject);
        end
    end;
end;

function TdxPDFDocumentRepository.GetDestination(ANumber: Integer): TdxPDFCustomDestination;
var
  AAction: TdxPDFJumpAction;
  AActionType, AType: string;
  ADictionary: TdxPDFDictionary;
begin
  ADictionary := GetDictionary(ANumber);
  if ADictionary <> nil then
  begin
    AActionType := ADictionary.GetString(TdxPDFKeywords.ActionType);
    AType := ADictionary.GetString(TdxPDFKeywords.TypeKey);
    if (AActionType <> '') and ((AType = '') or (AType = TdxPDFKeywords.Action) or (AType = 'A')) then
    begin
      AAction := GetAction(ANumber) as TdxPDFJumpAction;
      if AAction <> nil then
      begin
        ReplaceObject(ANumber, AAction);
        Exit(TdxPDFJumpActionAccess(AAction).Destination);
      end;
    end;
  end;
  Result := CreateDestination(GetObject(ANumber) as TdxPDFBase);
  ReplaceObject(ANumber, Result);
end;

function TdxPDFDocumentRepository.GetDictionary(ANumber: Integer): TdxPDFReaderDictionary;
begin
  Result := inherited GetDictionary(ANumber) as TdxPDFReaderDictionary;
end;

function TdxPDFDocumentRepository.GetInteractiveFormField(AForm: TdxPDFInteractiveForm;
  AParent: TdxPDFInteractiveFormField; ANumber: Integer): TdxPDFInteractiveFormField;

  procedure RegisterField(AField: TdxPDFInteractiveFormField);
  begin
    FResolvedInteractiveFormFields.Add(ANumber, AField);
  end;

  function CreateFormField(ARawObject: TdxPDFReaderDictionary;
    AParentField: TdxPDFInteractiveFormField; ANumber: Integer): TdxPDFInteractiveFormField;
  var
    ATypeName: string;
  begin
    Result := nil;
    if ARawObject <> nil then
    begin
      ATypeName := ARawObject.GetString(TdxPDFKeywords.FieldType);
      if (ATypeName = '') and (AParentField <> nil) then
        ATypeName := AParentField.GetTypeName;
      if ATypeName = '' then
      begin
        if ARawObject.Contains(TdxPDFKeywords.Kids) then
          Result := CreateObject(TdxPDFInteractiveFormField) as TdxPDFInteractiveFormField;
      end
      else
        Result := CreateObject(ATypeName) as TdxPDFInteractiveFormField
    end;
  end;

  function CreateAndReadFormField(ADictionary: TdxPDFReaderDictionary): TdxPDFInteractiveFormField;
  begin
    Result := CreateFormField(ADictionary, AParent, ANumber);
    if Result <> nil then
    begin
      AddHoldObject(Result);
      Result.Initialize(AForm, AParent);
      RegisterField(Result); 
      Result.Read(ADictionary, ANumber);
      dxCallNotify(OnAddField, Result);
    end;
  end;

var
  ADictionary: TdxPDFReaderDictionary;
  AWidget: TdxPDFWidgetAnnotation;
begin
  Result := nil;
  if TdxPDFUtils.IsIntegerValid(ANumber) and not FResolvedInteractiveFormFields.TryGetValue(ANumber, TObject(Result)) then
  begin
    ADictionary := GetDictionary(ANumber);
    if ADictionary <> nil then
      Exit(CreateAndReadFormField(ADictionary));

    AWidget := GetWidget(ANumber) as TdxPDFWidgetAnnotation;
    if AWidget <> nil then
    begin
      if TdxPDFWidgetAnnotationAccess(AWidget).FField <> nil then
      begin
        Result := AWidget.Field;
        RegisterField(Result);
      end
      else
        Result := CreateAndReadFormField(TdxPDFWidgetAnnotationAccess(AWidget).Dictionary);
    end;
  end;
end;

function TdxPDFDocumentRepository.GetForm(ANumber: Integer): TdxPDFXForm;
var
  AObjectType: string;
  AStream: TdxPDFStream;
begin
  Result := nil;
  if TryGetForm(ANumber, Result) then
     Exit;
  AStream := GetStream(ANumber);
  if AStream <> nil then
  begin
    AObjectType := AStream.Dictionary.GetString(TdxPDFKeywords.TypeKey);
    if (AObjectType = '') or (AObjectType = TdxPDFKeywords.XObject) then
    begin
      Result := CreateForm(AStream);
      Result.Number := ANumber;
    end;
  end;
end;

function TdxPDFDocumentRepository.ResolveField(ANumber: Integer): TdxPDFInteractiveFormField;
var
  ADictionary: TdxPDFReaderDictionary;
  AObject: TdxPDFReferencedObject;
  AParentNumber: Integer;
begin
  Result := nil;
  AObject := GetObject(ANumber);
  if AObject is TdxPDFCustomAnnotation then
    ADictionary := TdxPDFCustomAnnotation(AObject).Dictionary
  else
    ADictionary := GetDictionary(ANumber);

  if ADictionary <> nil then
  begin
    if ADictionary.TryGetReference(TdxPDFKeywords.Parent, AParentNumber) and TdxPDFUtils.IsIntegerValid(AParentNumber) then
      Result := GetInteractiveFormField(Catalog.AcroForm, ResolveField(AParentNumber), ANumber)
    else
      Result := GetInteractiveFormField(Catalog.AcroForm, nil, ANumber);
  end;
end;

function TdxPDFDocumentRepository.GetPage(ANumber: Integer): TdxPDFPage;
begin
  Result := Catalog.Pages.Find(ANumber);
end;

function TdxPDFDocumentRepository.GetString(ANumber: Integer): string;
var
  AObject: TdxPDFBase;
begin
  AObject := GetObject(ANumber) as TdxPDFBase;
  if AObject is TdxPDFString then
    Result := TdxPDFString(AObject).Value
  else
    Result := '';
end;

function TdxPDFDocumentRepository.GetXObject(ANumber: Integer): TdxPDFXObject;
begin
  Result := Safe<TdxPDFXObject>.Cast(ResolveObject(ANumber));
end;

function TdxPDFDocumentRepository.GetWidget(ANumber: Integer): TdxPDFCustomAnnotation;

  function CheckIsPageWidgetsLoaded(APageData: TdxPDFPageData): Boolean;
  begin
    Result := not APageData.AnnotationsLoaded;
    if Result then
    begin
      APageData.ForEachWidgetAnnotation(
        procedure(AAnnotation: TdxPDFCustomAnnotation)
        begin
          FResolvedWidgets.AddOrSetValue(TdxPDFWidgetAnnotation(AAnnotation).Number, AAnnotation);
        end);
    end;
  end;

  function FindWidget(ANumber: Integer): TdxPDFCustomAnnotation;
  var
    AHasChanges: Boolean;
    AObject: TObject;
    I: Integer;
  begin
    AObject := GetObject(ANumber);
    if AObject is TdxPDFWidgetAnnotation then
      Exit(TdxPDFWidgetAnnotation(AObject));

    AHasChanges := False;
    for I := 0 to Catalog.Pages.Count - 1 do
      AHasChanges := CheckIsPageWidgetsLoaded(Catalog.Pages[I].Data) or AHasChanges;
    if not (AHasChanges and FResolvedWidgets.TryGetValue(ANumber, TObject(Result))) then
      Result := nil;
  end;

begin
  if not FResolvedWidgets.TryGetValue(ANumber, TObject(Result)) then
  begin
    Result := FindWidget(ANumber);
    FResolvedWidgets.AddOrSetValue(ANumber, Result);
  end;
end;

function TdxPDFDocumentRepository.IsSharedResources(AResources: TdxPDFResources): Boolean;
begin
  Result := (AResources <> nil) and FSharedResources.ContainsKey(AResources.ID, AResources.Number);
end;

function TdxPDFDocumentRepository.IsValidReferences: Boolean;
var
  AKey: Integer;
  AReference: TdxPDFReference;
begin
  Result := True;
  for AKey in References.Keys do
    if References[AKey] is TdxPDFReference then
    begin
      AReference := TdxPDFReference(References[AKey]);
      if AReference.IsSlot and (AReference.Offset <> 0) and not FParser.IsValidReference(AReference) then
      begin
        Remove(AKey);
        Result := False;
      end;
    end;
end;

function TdxPDFDocumentRepository.TryGetAnnotation(ANumber: Integer; out AAnnotation: TdxPDFCustomAnnotation): Boolean;
var
  AObject: TdxPDFReferencedObject;
begin
  AObject := GetObject(ANumber);
  Result := AObject is TdxPDFCustomAnnotation;
  if Result then
    AAnnotation := TdxPDFCustomAnnotation(AObject)
  else
    AAnnotation := nil;
end;

function TdxPDFDocumentRepository.TryGetAsDictionary(AObject: TdxPDFBase;
  out ARawObject: TdxPDFReaderDictionary): Boolean;
begin
  ARawObject := nil;
  if AObject = nil then
    Exit(False);
  case AObject.ObjectType of
    otDictionary:
       ARawObject := AObject as TdxPDFReaderDictionary;
    otIndirectReference:
       ARawObject := GetDictionary(AObject.Number);
    otStream:
       ARawObject := TdxPDFStream(AObject).Dictionary as TdxPDFReaderDictionary;
  else
    ARawObject := nil;
  end;
  Result := ARawObject <> nil;
end;

function TdxPDFDocumentRepository.TryGetDictionary(ANumber: Integer; out ARawObject: TdxPDFDictionary): Boolean;
begin
  ARawObject := GetDictionary(ANumber);
  Result := ARawObject <> nil;
end;

function TdxPDFDocumentRepository.TryGetDictionaryObject(ANumber: Integer; out ARawObject: TdxPDFBase): Boolean;
var
  ADictionary: TdxPDFDictionary;
begin
  Result := TryGetDictionary(ANumber, ADictionary);
  ARawObject := ADictionary;
end;

function TdxPDFDocumentRepository.TryGetForm(ANumber: Integer; out AForm: TdxPDFXForm): Boolean;
var
  AObject: TdxPDFBase;
begin
  Result := TryGetObject(ANumber, AObject);
  if Result then
  begin
    AForm := Safe<TdxPDFXForm>.Cast(AObject);
    Result := AForm <> nil;
  end;
end;

function TdxPDFDocumentRepository.TryGetObject(ANumber: Integer; out ARawObject: TdxPDFBase): Boolean;
begin
  ARawObject := GetObject(ANumber) as TdxPDFBase;
  Result := ARawObject <> nil;
end;

function TdxPDFDocumentRepository.TryGetResolvedObject(ANumber: Integer; out AObject: TdxPDFObject): Boolean;
var
  ARawObject: TdxPDFBase;
begin
  Result := TryGetObject(ANumber, ARawObject) and (ARawObject is TdxPDFObject);
  if Result then
    AObject := TdxPDFObject(ARawObject)
  else
    AObject := nil;
end;

function TdxPDFDocumentRepository.TryGetStream(ANumber: Integer; out AStream: TdxPDFStream): Boolean;
var
  AObject: TdxPDFBase;
begin
  Result := TryGetObject(ANumber, AObject) and Safe.Cast(AObject, TdxPDFStream, AStream);
end;

procedure TdxPDFDocumentRepository.AddStreamElement(ANumber: Integer; AObject: TdxPDFReferencedObject);
begin
  TryAdd(ANumber, AObject, False);
end;

procedure TdxPDFDocumentRepository.PerformBatchOperation(AProc: TProc);
begin
  if not Assigned(AProc) then
    Exit;
  TdxPDFDocumentAccess(FDocument).BeginUpdate;
  try
    AProc;
  finally
    TdxPDFDocumentAccess(FDocument).EndUpdate;
  end;
end;

procedure TdxPDFDocumentRepository.ReadEncryptionInfo(ADictionary: TdxPDFDictionary; const ADocumentID: TdxPDFDocumentID);
begin
  FreeAndNil(FEncryptionInfo);
  FEncryptionInfo := TdxPDFEncryptionInfo.Create(ADocumentID, ADictionary);
end;

procedure TdxPDFDocumentRepository.RemoveCorruptedObjects;
var
  AKey: Integer;
  AList: TdxIntegerList;
  AValue: TdxPDFReferencedObject;
  I: Integer;
begin
  AList := TdxIntegerList.Create;
  try
    AList.AddRange(References.Keys);
    for I := 0 to AList.Count - 1 do
    begin
      AKey := AList.Items[I];
      if References.TryGetValue(AKey, AValue) and not (AValue is TdxPDFStreamElement) then
        Remove(AKey);
    end;
  finally
    AList.Free;
  end;
end;

procedure TdxPDFDocumentRepository.RemoveObject(AObject: TdxPDFObject);
begin
  Remove(AObject.Number);
  DeleteHoldObject(AObject);
end;

function TdxPDFDocumentRepository.ResolveObject(ANumber: Integer): TdxPDFReferencedObject;
begin
  EnterCriticalSection(FLock);
  try
    if not References.TryGetValue(ANumber, Result) then
      if not References.TryGetValue(ANumber, Result) then
        Exit(nil);
    if Result is TdxPDFBase then
      case TdxPDFBase(Result).ObjectType of
        otIndirectObject:
          Result := ResolveIndirectObject(TdxPDFIndirectObject(Result));
        otIndirectReference:
          Result := ResolveIndirectReference(TdxPDFReference(Result));
        otStreamElement:
          Result := ResolveStreamElement(TdxPDFStreamElement(Result));
      end;
  finally
    LeaveCriticalSection(FLock);
  end;
end;

procedure TdxPDFDocumentRepository.AddChange(AChange: TdxPDFDocumentChange);
begin
  TdxPDFDocumentAccess(FDocument).AddChange(AChange);
end;

procedure TdxPDFDocumentRepository.AddHoldObject(AObject: TdxPDFObject);
begin
  FObjectHolder.Add(AObject);
end;

procedure TdxPDFDocumentRepository.Changed(AChanges: TdxPDFDocumentChanges);
begin
  TdxPDFDocumentAccess(FDocument).Changes := AChanges;
end;

procedure TdxPDFDocumentRepository.DeleteHoldObject(AObject: TdxPDFObject);
begin
  FObjectHolder.Remove(AObject);
end;

procedure TdxPDFDocumentRepository.RemoveResolvedForm(AForm: TdxPDFXForm);
begin
  FResolvedForms.Remove(AForm);
end;

procedure TdxPDFDocumentRepository.UpdateStructure;
begin
  Catalog.Refresh;
end;

procedure TdxPDFDocumentRepository.AttachmentsChanged;
begin
  Changed([dcModified, dcAttachments]);
end;

procedure TdxPDFDocumentRepository.OutlinesChanged;
begin
  Changed([dcModified, dcOutlines]);
end;

function TdxPDFDocumentRepository.CreateFontProvider: TdxPDFFontProvider;
begin
  Result := TdxPDFFontProvider.Create(FFolderName);
end;

procedure TdxPDFDocumentRepository.CreateSubClasses;

  function GetTempFolderPath: string;
  begin
    if sdxPDFTempFolder = '' then
      Result := TPath.GetTempPath
    else
      Result := sdxPDFTempFolder;
  end;

begin
  inherited CreateSubClasses;
  InitializeCriticalSectionAndSpinCount(FLock, 1024);
  FParser := TdxPDFDocumentParser.Create(Self, FStream);
  FEncryptionInfo := nil;
  FSharedResources := TdxPDFUniqueReferences.Create;
  FFolderName := GetTempFolderPath + dxGenerateID + TPath.DirectorySeparatorChar;
  FFontProvider := CreateFontProvider;
  FFontDataStorage := TdxPDFFontDataStorage.Create(FFolderName, FFontProvider.SubstitutionHelper);
  FImageDataStorage := TdxPDFDocumentImageDataStorage.Create(300);
  FObjectHolder := TdxPDFReferencedObjects.Create;
  FResolvedInteractiveFormFields := TdxPDFObjectIndex.Create(1024);
  FResolvedWidgets := TdxPDFObjectIndex.Create(1024);
  FXReferences := TDictionary<Integer, Int64>.Create;
  FResolvedForms := TdxFastList.Create;
  FParent := TdxPDFDocumentRepositoryParent.Create(Self);
end;

procedure TdxPDFDocumentRepository.DestroySubClasses;
begin
  FreeAndNil(FParent);
  FreeAndNil(FXReferences);
  FreeAndNil(FResolvedWidgets);
  FreeAndNil(FResolvedInteractiveFormFields);
  FreeAndNil(FImageDataStorage);
  FreeAndNil(FFontDataStorage);
  FreeAndNil(FEncryptionInfo);
  FreeAndNil(FStream);
  FreeAndNil(FFontProvider);
  FreeAndNil(FSharedResources);
  FreeAndNil(FParser);
  if DirectoryExists(FFolderName) then
    RemoveDir(FFolderName);
  FreeAndNil(FObjectHolder);
  FreeAndNil(FResolvedForms);
  DeleteCriticalSection(FLock);
  inherited DestroySubClasses;
end;

function TdxPDFDocumentRepository.IsResourcesShared(AResources: TdxPDFResources): Boolean;
begin
  Result := FSharedResources.ContainsValue(AResources);
end;

function TdxPDFDocumentRepository.CreateAcroForm: TdxPDFInteractiveForm;
begin
  Result := TdxPDFInteractiveForm.Create(Parent);
  AddHoldObject(Result);
end;

function TdxPDFDocumentRepository.CreateWidgetAnnotation(APage: TdxPDFPage; const ARect: TdxPDFRectangle;
  AFlags: TdxPDFAnnotationFlags): TdxPDFCustomAnnotation;
begin
  Result := TdxPDFWidgetAnnotation.Create(APage, ARect, AFlags);
  APage.AddAnnotation(Result);
  AddHoldObject(Result);
end;

function TdxPDFDocumentRepository.CreateObject(AClass: TdxPDFObjectClass; AParent: TdxPDFObject): TdxPDFObject;
begin
  Result := AClass.Create(AParent);
end;

function TdxPDFDocumentRepository.CreateObject(const ATypeName: string): TdxPDFObject;
begin
  Result := CreateObject(ATypeName, Parent);
end;

function TdxPDFDocumentRepository.CreateObject(const ATypeName: string; AParent: TdxPDFObject): TdxPDFObject;
var
  AClass: TdxPDFObjectClass;
begin
  if dxPDFTryGetDocumentObjectClass(ATypeName, AClass) then
    Result := CreateObject(AClass, AParent)
  else
    Result := nil;
end;

function TdxPDFDocumentRepository.CreateObjectParser(AObjectNumber: Integer): TdxPDFStructureParser;
begin
  if EncryptionInfo <> nil then
    Result := TdxPDFEncryptedStructureParser.Create(Self, AObjectNumber)
  else
    Result := TdxPDFStructureParser.Create(Self);
end;

function TdxPDFDocumentRepository.GetFontProvider: TdxPDFFontProvider;
begin
  Result := FFontProvider;
end;

function TdxPDFDocumentRepository.GetObjectCount: Integer;
begin
  Result := References.Count;
end;

function TdxPDFDocumentRepository.ResolveIndirectObject(AObject: TdxPDFIndirectObject): TdxPDFReferencedObject;
var
  AParser: TdxPDFStructureParser;
begin
  AParser := CreateObjectParser(AObject.Number);
  try
    Result := nil;
    try
      Result := AParser.ReadObject(AObject.Data);
      ReplaceObject(AObject.Number, Result);
    except
      dxPDFFreeObject(Result);
      raise;
    end;
  finally
    AParser.Free;
  end;
end;

function TdxPDFDocumentRepository.ResolveIndirectReference(AReference: TdxPDFReference): TdxPDFReferencedObject;

  procedure FindAndUpdateInvalidReference(AReference: TdxPDFReference);
  var
    AOffset: Int64;
    ASlot: TdxPDFReference;
  begin
    if Parser.TryFindObjectOffset(AReference.Number, AReference.Generation, AOffset) then
    begin
      ASlot := Parser.ReadObjectSlot(AOffset);
      try
        FXReferences.AddOrSetValue(ASlot.Number, ASlot.Offset);
      finally
       ASlot.Free;
      end;
    end;
  end;

  function InternalReadObject(AOffset: Int64): TdxPDFReferencedObject;
  var
    AObject: TdxPDFIndirectObject;
  begin
    AObject := FParser.ReadIndirectObject(AOffset);
    try
      Result := ResolveIndirectObject(AObject as TdxPDFIndirectObject);
    finally
      FreeAndNil(AObject);
    end;
  end;

var
  AOffset: Int64;
begin
  if AReference.IsFree then
    Exit(nil);
  if Parser.IsValidReference(AReference) then
    Result := InternalReadObject(AReference.Offset)
  else
  begin
    FindAndUpdateInvalidReference(AReference);
    if FXReferences.TryGetValue(AReference.Number, AOffset) then
      Result := InternalReadObject(AOffset)
    else
      Result := nil;
  end;
end;

function TdxPDFDocumentRepository.ResolveStreamElement(AElement: TdxPDFStreamElement): TdxPDFReferencedObject;
var
  AStream: TdxPDFStream;
begin
  Result := GetObject(AElement.Number);
  if Result is TdxPDFBase then
  begin
    if TdxPDFBase(Result).ObjectType <> otObjectStream then
    begin
      if TdxPDFBase(Result).ObjectType = otStream then
        AStream := Result as TdxPDFStream
      else
        AStream := GetStream(AElement.Number);
      TdxPDFBase(AStream).Number := AElement.Number;
      Result := TdxPDFReaderObjectStream.Create(AElement.Number, AStream);
      Replace(AElement.Number, Result);
    end;
    if TdxPDFBase(Result).ObjectType <> otStream then
      Result := TdxPDFReaderObjectStream(Result).Objects[AElement.Index] as TdxPDFBase
    else
      Result := AElement;
  end;
end;

procedure TdxPDFDocumentRepository.SetFontProvider(const AValue: TdxPDFFontProvider);
begin
  FreeAndNil(FFontProvider);
  FFontProvider := AValue;
end;

procedure TdxPDFDocumentRepository.AfterCreateForm(AForm: TdxPDFXForm);
begin
  FResolvedForms.Add(AForm);
  ReplaceObject(AForm.Number, AForm);
end;

procedure TdxPDFDocumentRepository.ReplaceObject(ANumber: Integer; AObject: TdxPDFReferencedObject);
begin
  if not TdxPDFUtils.IsIntegerValid(ANumber) or (AObject = nil) then
    Exit;
  Replace(ANumber, AObject);
  TdxPDFBase(AObject).Number := ANumber;
end;

{ TdxPDFReaderDictionary }

constructor TdxPDFReaderDictionary.Create(ARepository: TdxPDFDocumentRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TdxPDFReaderDictionary.GetAction(const AKey: string): TdxPDFCustomAction;
var
  AObject: TdxPDFBase;
  ADictionary: TdxPDFReaderDictionary;
begin
  Result := nil;
  if TryGetObject(AKey, AObject) then
  begin
    case AObject.ObjectType of
      otIndirectReference:
        ADictionary := Safe<TdxPDFReaderDictionary>.Cast(Repository.GetObject(AObject.Number));
      otDictionary:
        ADictionary := AObject as TdxPDFReaderDictionary;
    else
      ADictionary := nil;
    end;
    if ADictionary <> nil then
      Result := Repository.CreateAction(ADictionary);
  end;
end;

function TdxPDFReaderDictionary.GetAnnotationCallout(const AKey: string): TdxPDFAnnotationCallout;
var
  AArray: TdxPDFArray;
begin
  if TryGetArray(AKey, AArray) then
  begin
    Result := TdxPDFAnnotationCallout.CreateEx(Repository);
    Result.Read(AArray);
  end
  else
    Result := nil;
end;

function TdxPDFReaderDictionary.GetAnnotationHighlightingMode: TdxPDFAnnotationHighlightingMode;
var
  AName: string;
  AMode: TdxPDFAnnotationHighlightingMode;
begin
  AName := GetString(TdxPDFKeywords.AnnotationHighlightingMode);
  for AMode := Low(TdxPDFAnnotationHighlightingMode) to High(TdxPDFAnnotationHighlightingMode) do
  begin
    if dxPDFAnnotationHighlightingModeIdMap[AMode] = AName then
      Exit(AMode);
  end;
  Result := ahmNone;
end;

function TdxPDFReaderDictionary.GetAppearance(AResources: TdxPDFResources): TdxPDFCommandList;
var
  AData: TBytes;
begin
  AData := GetBytes(TdxPDFKeywords.DictionaryAppearance);
  if (Length(AData) > 0) and (AResources <> nil) then
  begin
    Result := TdxPDFCommandList.Create;
    TdxPDFCommandStreamParser.Parse(Repository, AData, Result, AResources);
  end
  else
    Result := nil;
end;

function TdxPDFReaderDictionary.GetColor(const AKey: string): TdxPDFColor;
var
  AArray: TdxPDFArray;
begin
  AArray := GetArray(AKey);
  if (AArray <> nil) and (AArray.Count in [1, 3, 4]) then
    Result := TdxPDFColor.Create(AArray)
  else
    Result := TdxPDFColor.Null;
end;

function TdxPDFReaderDictionary.GetDeferredFormFieldCollection(const AKey: string): TdxPDFInteractiveFormFieldCollection;
begin
  Result := nil;
end;

function TdxPDFReaderDictionary.GetDestinationInfo(const AKey: string): TdxPDFDestinationInfo;
var
  ANumber: Integer;
  AObject: TdxPDFBase;
begin
  Result := nil;
  if TryGetObject(AKey, AObject) then
    case AObject.ObjectType of
      otIndirectReference:
        begin
          ANumber := AObject.Number;
          AObject := Repository.GetDestination(ANumber);
          if AObject <> nil then
            Result := TdxPDFDestinationInfo.Create(AObject as TdxPDFCustomDestination)
          else
            Result := TdxPDFDestinationInfo.Create(Repository.GetString(ANumber))
        end;
      otString, otName:
        Result := TdxPDFDestinationInfo.Create(TdxPDFString(AObject).Value);
      otArray:
        Result := TdxPDFDestinationInfo.Create(Repository.CreateDestination(TdxPDFArray(AObject)));
    else
      Result := nil;
    end;
end;

function TdxPDFReaderDictionary.GetDictionary(const AKey: string;
  const AAlternateKey: string = ''): TdxPDFReaderDictionary;
begin
  Result := inherited GetDictionary(AKey) as TdxPDFReaderDictionary;
  if (Result = nil) and (AAlternateKey <> '') then
    Result := GetDictionary(AAlternateKey);
end;

function TdxPDFReaderDictionary.GetObject(const AKey: string): TdxPDFBase;
begin
  Result := inherited GetObject(AKey);
  if FRepository <> nil then
    Result := FRepository.ResolveReference(Result);
end;

function TdxPDFReaderDictionary.GetObjectNumber(const AKey: string): Integer;
begin
  if Contains(AKey) then
  begin
    Result := inherited GetObject(AKey).Number;
    if Result = 0 then
      Result := dxPDFInvalidValue;
  end
  else
    Result := dxPDFInvalidValue;
end;

function TdxPDFReaderDictionary.GetTextJustify: TdxPDFTextJustify;
begin
  Result := TdxPDFTextJustify(GetInteger('Q', 0));
end;

function TdxPDFReaderDictionary.TryGetArray(const AKey: string; out AValue: TdxPDFArray): Boolean;
var
  ATemp: TdxPDFBase;
begin
  Result := inherited TryGetArray(AKey, AValue);
  if not Result and TryGetObject(AKey, ATemp) then
    Result := Safe.Cast(Repository.ResolveObject(ATemp.Number), TdxPDFArray, AValue);
end;

procedure TdxPDFReaderDictionary.PopulateList(const AKey: string; AProc: TProc<string>);
var
  AValue, AElement: TdxPDFBase;
begin
  if not Assigned(AProc) then
    Exit;
  if not TryGetObject(AKey, AValue) then
    Exit;
  if AValue.ObjectType = otString then
    AProc((AValue as TdxPDFString).Text)
  else
    if AValue.ObjectType = otArray then
      for AElement in TdxPDFArray(AValue).ElementList do
        AProc((AElement as TdxPDFString).Text);
end;

procedure TdxPDFReaderDictionary.ResolveArrayElements(AArray: TdxPDFArray);
var
  I: Integer;
begin
  if (AArray <> nil) then
  begin
    for I := 0 to AArray.Count - 1 do
      if AArray[I] is TdxPDFReference then
        AArray[I] := FRepository.ResolveReference(AArray[I]);
  end;
end;

function TdxPDFReaderDictionary.TryGetDictionary(const AKey: string; out AValue: TdxPDFReaderDictionary): Boolean;
begin
  AValue := GetDictionary(AKey);
  Result := AValue <> nil;
end;

function TdxPDFReaderDictionary.TryGetStreamDictionary(const AKey: string; out AValue: TdxPDFReaderDictionary): Boolean;
var
  AStream: TdxPDFStream;
begin
  Result := TryGetStream(AKey, AStream);
  if Result then
  begin
    AValue := AStream.Dictionary as TdxPDFReaderDictionary;
    AValue.StreamRef := AStream;
  end
  else
    Result := TryGetDictionary(AKey, AValue);
end;

function TdxPDFReaderDictionary.GetResources(const AKey: string): TdxPDFResources;
var
  ADictionary: TdxPDFReaderDictionary;
  AObject: TdxPDFBase;
begin
  Result := Repository.CreateResources;
  if TryGetObject(AKey, AObject) then
  begin
    ADictionary := Repository.GetDictionary(AObject.Number);
    if (ADictionary = nil) and (AObject.ObjectType = otDictionary) then
      ADictionary := AObject as TdxPDFReaderDictionary;
    Result.Read(ADictionary);
  end;
end;

{ TdxPDFHyperlink }

destructor TdxPDFHyperlink.Destroy;
begin
  SetAnnotation(nil);
  inherited Destroy;
end;

function TdxPDFHyperlink.GetHint: string;
begin
  Result := TdxPDFLinkAnnotation(FAnnotation).Hint;
end;

function TdxPDFHyperlink.GetHitCode: Integer;
begin
  Result := hcHyperlink;
end;

procedure TdxPDFHyperlink.SetAnnotation(const AValue: TdxPDFCustomAnnotation);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FAnnotation));
end;

function TdxPDFHyperlink.GetInteractiveOperation: TdxPDFInteractiveOperation;
begin
  Result := (FAnnotation as TdxPDFActionAnnotation).InteractiveOperation;
end;

{ TdxPDFRecognizedContent }

constructor TdxPDFRecognizedContent.Create;
begin
  inherited Create;
  FHyperlinks := TdxPDFHyperlinkList.Create;
  FImages := TdxPDFImageList.Create;
  FTextLines := TdxPDFTextLineList.Create;
end;

destructor TdxPDFRecognizedContent.Destroy;
begin
  FreeAndNil(FTextLines);
  FreeAndNil(FImages);
  FreeAndNil(FHyperlinks);
  inherited Destroy;
end;

function TdxPDFRecognizedContent.GetText: string;
var
  ARange: TdxPDFPageTextRange;
begin
  ARange := TdxPDFPageTextRange.Create(0);
  Result := TdxPDFTextUtils.ConvertToString(ARange.StartPosition, ARange.EndPosition, FTextLines);
end;

{ TdxPDFGraphicsState }

constructor TdxPDFGraphicsState.Create;
var
  AComponents: TDoubleDynArray;
begin
  inherited Create;
  RecreateParameters;
  RecreateTextState;
  FDeviceTransformMatrix := TdxPDFTransformationMatrix.Create;
  FTransformMatrix := TdxPDFTransformationMatrix.Create;
  SetLength(AComponents, 1);
  AComponents[0] := 0;
  StrokingColor := TdxPDFColor.Create(AComponents);
  NonStrokingColor := TdxPDFColor.Create(AComponents);
  StrokingColorSpace := TdxPDFGrayDeviceColorSpace.Create;
  NonStrokingColorSpace := TdxPDFGrayDeviceColorSpace.Create;
end;

destructor TdxPDFGraphicsState.Destroy;
begin
  NonStrokingColorSpace := nil;
  StrokingColorSpace := nil;
  FreeAndNil(FTextState);
  FreeAndNil(FParameters);
  inherited Destroy;
end;

procedure TdxPDFGraphicsState.Assign(AGraphicsState: TdxPDFGraphicsState);
begin
  if AGraphicsState <> nil then
  begin
    ApplyParameters(AGraphicsState.Parameters);
    StrokingColor := AGraphicsState.StrokingColor;
    StrokingColorSpace := AGraphicsState.StrokingColorSpace;
    NonStrokingColor := AGraphicsState.NonStrokingColor;
    NonStrokingColorSpace := AGraphicsState.NonStrokingColorSpace;
    TextState.Assign(AGraphicsState.TextState);
    TransformMatrix.Assign(AGraphicsState.TransformMatrix);
  end;
end;

procedure TdxPDFGraphicsState.Reset;
begin
  TransformMatrix.Reset;
  RecreateParameters;
  RecreateTextState;
end;

procedure TdxPDFGraphicsState.ApplyParameters(AParameters: TdxPDFGraphicsStateParameters; AClone: Boolean = False);
begin
  if AParameters <> nil then
  begin
    Parameters.Assign(AParameters, not AClone);
    if Parameters.IsSoftMaskChanged then
      SoftMaskTransformMatrix := TransformMatrix;
    if AParameters.Font <> nil then
    begin
      TextState.Font := AParameters.Font;
      TextState.FontSize := AParameters.FontSize;
    end;
  end;
end;

function TdxPDFGraphicsState.Clone: TdxPDFGraphicsState;
begin
  Result := TdxPDFGraphicsState.Create;
  Result.ApplyParameters(Parameters, True);
  Result.StrokingColor := StrokingColor;
  Result.StrokingColorSpace := StrokingColorSpace;
  Result.NonStrokingColor := NonStrokingColor;
  Result.NonStrokingColorSpace := NonStrokingColorSpace;
  Result.TextState.Assign(TextState);
  Result.TransformMatrix.Assign(TransformMatrix);
end;

procedure TdxPDFGraphicsState.RecreateTextState;
begin
  FreeAndNil(FTextState);
  FTextState := TdxPDFTextState.Create;
end;

procedure TdxPDFGraphicsState.RecreateParameters;
begin
  FreeAndNil(FParameters);
  FParameters := TdxPDFGraphicsStateParameters.Create;
end;

procedure TdxPDFGraphicsState.SetNonStrokingColorSpace(const AValue: TdxPDFCustomColorSpace);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FNonStrokingColorSpace));
end;

procedure TdxPDFGraphicsState.SetStrokingColorSpace(const AValue: TdxPDFCustomColorSpace);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FStrokingColorSpace));
end;

{ TdxPDFFontRegistratorParameters }

class function TdxPDFFontRegistratorParameters.Create(const AName: string; AWeight: Integer;
  AIsItalic: Boolean): TdxPDFFontRegistratorParameters;
begin
  Result.FIsItalic := AIsItalic;
  Result.FName := AName;
  Result.FWeight := AWeight;
end;

{ TdxPDFFontDescriptorData }

class function TdxPDFFontDescriptorData.Create(
  AFontMetrics: TdxFontFileFontMetrics; AFontFlags: Integer;
  const AItalicAngle: Double; ABold: Boolean; ANumGlyphs: Integer): TdxPDFFontDescriptorData;
begin
  Result.FAscent := AFontMetrics.EmAscent;
  Result.FBBox := AFontMetrics.EmBBox;
  Result.FBold := ABold;
  Result.FDescent := AFontMetrics.EmDescent;
  Result.FFontFlags := AFontFlags;
  Result.FItalicAngle := AItalicAngle;
  Result.FNumGlyphs := ANumGlyphs;
end;

{ TdxPDFDestinationInfo }

constructor TdxPDFDestinationInfo.Create;
begin
  inherited Create;
  FName := '';
end;

constructor TdxPDFDestinationInfo.Create(ADestination: TdxPDFCustomDestination);
begin
  Create;
  SetDestination(ADestination);
end;

constructor TdxPDFDestinationInfo.Create(const AName: string);
begin
  Create;
  FName := AName;
end;

destructor TdxPDFDestinationInfo.Destroy;
begin
  SetDestination(nil);
  inherited Destroy;
end;

function TdxPDFDestinationInfo.GetDestination(ACatalog: TdxPDFCatalog; AInternal: Boolean): TdxPDFCustomDestination;
begin
  if (ACatalog <> nil) and (FDestination = nil) and (FName <> '') then
    SetDestination(ACatalog.GetDestination(FName));
  if AInternal and (FDestination <> nil) then
    FDestination.ResolveInternalPage;
  Result := FDestination;
end;

function TdxPDFDestinationInfo.Write(AHelper: TdxPDFWriterHelper): TdxPDFBase;
begin
  if FDestination <> nil then
    Result := FDestination.Write(AHelper)
  else
    if FName <> '' then
    begin
      AHelper.Context.AddDestinationName(FName);
      Result := TdxPDFString.Create(AHelper.Context.GetDestinationName(FName));
    end
    else
      Result := nil;
end;

procedure TdxPDFDestinationInfo.SetDestination(const AValue: TdxPDFCustomDestination);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FDestination));
end;

{ TdxPDFTarget }

class function TdxPDFTarget.Create(AMode: TdxPDFTargetMode; APageIndex: Integer; X, Y: Single): TdxPDFTarget;
begin
  Result := CreateEx(AMode, APageIndex, X, Y, 0, 0, dxPDFInvalidValue);
end;

class function TdxPDFTarget.Create(AMode: TdxPDFTargetMode; APageIndex: Integer): TdxPDFTarget;
begin
  Result := CreateEx(AMode, APageIndex, dxPDFInvalidValue, dxPDFInvalidValue, 0, 0, dxPDFInvalidValue);
end;

class function TdxPDFTarget.Create(AMode: TdxPDFTargetMode; APageIndex: Integer; const R: TdxRectF): TdxPDFTarget;
begin
  Result := Invalid;
  Result.FMode := AMode;
  Result.FPageIndex := APageIndex;
  Result.FX := R.Left;
  Result.FY := R.Top;
  Result.FWidth := R.Width;
  Result.FHeight := R.Height;
  Result.FZoom := dxPDFInvalidValue;
end;

class function TdxPDFTarget.Create(APageIndex: Integer; X, Y, AZoom: Single): TdxPDFTarget;
begin
  Result := CreateEx(tmXYZ, APageIndex, X, Y, 0, 0, AZoom);
end;

class function TdxPDFTarget.CreateEx(AMode: TdxPDFTargetMode; APageIndex: Integer;
  X, Y, AWidth, AHeight, AZoom: Single): TdxPDFTarget;
begin
  Result := Invalid;
  Result.FMode := AMode;
  Result.FPageIndex := APageIndex;
  Result.FX := X;
  Result.FY := Y;
  Result.FWidth := AWidth;
  Result.FHeight := AHeight;
  Result.FZoom := AZoom;
end;

class function TdxPDFTarget.Invalid: TdxPDFTarget;
begin
  Result.FPageIndex := dxPDFInvalidValue;
  Result.FMode := tmXYZ;
  Result.FHeight := dxPDFInvalidValue;
  Result.FWidth := dxPDFInvalidValue;
  Result.FX := dxPDFInvalidValue;
  Result.FY := dxPDFInvalidValue;
  Result.FZoom := dxPDFInvalidValue;
end;

function TdxPDFTarget.IsValid: Boolean;
begin
  Result := TdxPDFUtils.IsIntegerValid(FPageIndex);
end;

{ TdxPDFInteractiveOperation }

class function TdxPDFInteractiveOperation.Create(AAction: TdxPDFCustomAction): TdxPDFInteractiveOperation;
begin
  Result := Invalid;
  Result.FAction := AAction;
end;

class function TdxPDFInteractiveOperation.Create(AAction: TdxPDFCustomAction;
  ADestination: TdxPDFCustomDestination): TdxPDFInteractiveOperation;
begin
  Result.FAction := AAction;
  Result.FDestination := ADestination;
end;

class function TdxPDFInteractiveOperation.Invalid: TdxPDFInteractiveOperation;
begin
  Result.FAction := nil;
  Result.FDestination := nil;
end;

function TdxPDFInteractiveOperation.IsValid: Boolean;
begin
  Result := (FDestination <> nil) or (FAction <> nil);
end;

function TdxPDFInteractiveOperation.GetTarget: TdxPDFTarget;
var
  AGoToAction: TdxPDFGoToAction;
begin
  if Destination <> nil then
    Result := Destination.GetTarget
  else
    if Safe.Cast(Action, TdxPDFGoToAction, AGoToAction) and (AGoToAction.Destination <> nil) then
      Result := AGoToAction.Destination.GetTarget
    else
      Result := TdxPDFTarget.Invalid;
end;

{ TdxPDFTextParser }

constructor TdxPDFTextParser.Create(const APageCropBox: TdxRectF; AContent: TdxPDFRecognizedContent);
begin
  inherited Create;
  FPageBlocks := TObjectList<TdxPDFTextBlock>.Create;
  FFontDataStorage := TObjectDictionary<TdxPDFCustomFont, TdxPDFFontData>.Create([doOwnsValues]);
  FPageCropBox := cxRectAdjustF(APageCropBox);
  FContent := AContent;
end;

destructor TdxPDFTextParser.Destroy;
begin
  FreeAndNil(FFontDataStorage);
  FreeAndNil(FPageBlocks);
  inherited Destroy;
end;

procedure TdxPDFTextParser.AddBlock(const AStringData: TdxPDFStringData; AState: TdxPDFGraphicsState);
var
  AFontData: TdxPDFFontData;
  AFont: TdxPDFCustomFont;
begin
  AFont := AState.TextState.Font as TdxPDFCustomFont;
  if (Length(AStringData.CharCodes) > 0) and (Length(AStringData.Advances) > 0) then
  begin
    if not FFontDataStorage.TryGetValue(AFont, AFontData) then
    begin
      AFontData := TdxPDFFontData.CreateFontData(AFont);
      FFontDataStorage.Add(AFont, AFontData);
    end;
    FPageBlocks.Add(TdxPDFTextBlock.Create(AStringData, AFontData, AState));
  end;
end;

procedure TdxPDFTextParser.Parse;
var
  ABuilder: TdxPDFPageTextLineBuilder;
begin
  if (FPageBlocks <> nil) and (FPageBlocks.Count >= 1) then
  begin
    FParserState := TdxPDFTextParserState.Create(FPageBlocks, dxRectF(0, 0, FPageCropBox.Width, FPageCropBox.Height));
    try
      ABuilder := TdxPDFPageTextLineBuilder.Create(FParserState);
      try
        ABuilder.Populate(FContent.TextLines);
      finally
        ABuilder.Free;
      end;
    finally
      FParserState.Free;
    end;
  end;
end;

{ TdxPDFTextUtils }

class function TdxPDFTextUtils.ConvertToString(const ARanges: TdxPDFPageTextRanges; APages: TdxPDFPageList): string;
var
  I, ALength: Integer;
  APage: TdxPDFPage;
  ARange: TdxPDFPageTextRange;
  ATextBuilder: TdxBiDiStringBuilder;
begin
  ATextBuilder := TdxBiDiStringBuilder.Create;
  try
    ALength := Length(ARanges);
    for I := 0 to ALength - 1 do
    begin
      ARange := ARanges[I];
      APage := APages[ARange.PageIndex];
      Append(ATextBuilder, ARange.StartPosition, ARange.EndPosition, APage.RecognizedContent.TextLines);
      if (I <> ALength - 1) and (ARange.PageIndex = (ARanges[I + 1]).PageIndex) and not ATextBuilder.Empty and
        not ATextBuilder.EndsWithNewLine then
        ATextBuilder.AppendLine;
    end;
    Result := ATextBuilder.EndCurrentLineAndGetString;
  finally
    ATextBuilder.Free;
  end;
end;

{ TdxPDFCustomImageAppearanceInfo }

constructor TdxPDFCustomImageAppearanceInfo.Create;
begin
  inherited Create;
  FImage := TdxSmartImage.Create;
  Bounds.Invalid;
end;

destructor TdxPDFCustomImageAppearanceInfo.Destroy;
begin
  FreeAndNil(FImage);
  inherited Destroy;
end;

procedure TdxPDFCustomImageAppearanceInfo.Assign(Source: TPersistent);
begin
  if Source is TdxPDFSignatureFieldAppearanceInfo then
  begin
    Image.Assign(TdxPDFSignatureFieldAppearanceInfo(Source).Image);
    RotationAngle := TdxPDFSignatureFieldAppearanceInfo(Source).RotationAngle;
    FitMode := TdxPDFSignatureFieldAppearanceInfo(Source).FitMode;
    Bounds := TdxPDFSignatureFieldAppearanceInfo(Source).Bounds;
  end;
end;

procedure TdxPDFCustomImageAppearanceInfo.SetImage(const AValue: TdxSmartImage);
begin
  FImage.Assign(AValue);
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxPDFRegisterDocumentObjectClass(TdxPDFCatalog);
  dxPDFRegisterDocumentObjectClass(TdxPDFColorSpaces);
  dxPDFRegisterDocumentObjectClass(TdxPDFDocumentImage);
  dxPDFRegisterDocumentObjectClass(TdxPDFXForm);
  dxPDFRegisterDocumentObjectClass(TdxPDFDocumentInformation);
  dxPDFRegisterDocumentObjectClass(TdxPDFFonts);
  dxPDFRegisterDocumentObjectClass(TdxPDFGraphicsStateParameters);
  dxPDFRegisterDocumentObjectClass(TdxPDFPageData);
  dxPDFRegisterDocumentObjectClass(TdxPDFPageContents);
  dxPDFRegisterDocumentObjectClass(TdxPDFPageList);
  dxPDFRegisterDocumentObjectClass(TdxPDFResources);
  dxPDFRegisterDocumentObjectClass(TdxPDFXObjects);
  dxPDFRegisterDocumentObjectClass(TdxPDFFileSpecification);

  dxgPDFEmptyEncoding := TdxFontFileCustomEncoding.Create;

  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  FreeAndNil(dxgPDFEmptyEncoding);

  dxPDFUnregisterDocumentObjectClass(TdxPDFFileSpecification);
  dxPDFUnregisterDocumentObjectClass(TdxPDFXObjects);
  dxPDFUnregisterDocumentObjectClass(TdxPDFResources);
  dxPDFUnregisterDocumentObjectClass(TdxPDFPageList);
  dxPDFUnregisterDocumentObjectClass(TdxPDFPageContents);
  dxPDFUnregisterDocumentObjectClass(TdxPDFPageData);
  dxPDFUnregisterDocumentObjectClass(TdxPDFGraphicsStateParameters);

  dxPDFUnregisterDocumentObjectClass(TdxPDFFonts);
  dxPDFUnregisterDocumentObjectClass(TdxPDFXForm);
  dxPDFUnregisterDocumentObjectClass(TdxPDFDocumentImage);
  dxPDFUnregisterDocumentObjectClass(TdxPDFDocumentInformation);
  dxPDFUnregisterDocumentObjectClass(TdxPDFColorSpaces);
  dxPDFUnregisterDocumentObjectClass(TdxPDFCatalog);

  FreeAndNil(dxgPDFDocumentObjectFactory);

  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
