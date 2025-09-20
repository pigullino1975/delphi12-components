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

unit dxPDFAnnotation;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Types, SysUtils, Generics.Defaults, Generics.Collections, Classes, cxGeometry, dxPDFBase, dxPDFTypes, dxPDFCore;

const
  dxPDFAnnotationHighlightingModeIdMap: array[TdxPDFAnnotationHighlightingMode] of string = ('N', 'I', 'O', 'P', 'Y'); // for internal use

type
  TdxPDFIconScalingCircumstances = (iscAlways, iscBiggerThanAnnotationRectangle, iscSmallerThanAnnotationRectangle,
    iscNever); // for internal use
  TdxPDFIconScalingType = (istProportional, istAnamorphic); // for internal use
  TdxPDFWidgetAnnotationTextPosition = (wtpNoIcon, wtpNoCaption, wtpCaptionBelowTheIcon, wtpCaptionAboveTheIcon,
    wtpCaptionToTheRightOfTheIcon, wtpCaptionToTheLeftOfTheIcon, wtpCaptionOverlaidDirectlyOnTheIcon); // for internal use

  { TdxPDFAnnotationBorderEffect }

  TdxPDFAnnotationBorderEffect = class(TdxPDFObject) // for internal use
  strict private
    FIntensity: Double;
    FStyle: TdxPDFAnnotationBorderEffectStyle;
  protected
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    class function Parse(ADictionary: TdxPDFReaderDictionary): TdxPDFAnnotationBorderEffect; static;
    //
    property Intensity: Double read FIntensity;
    property Style: TdxPDFAnnotationBorderEffectStyle read FStyle;
  end;

  { TdxPDFIconFitParameters }

  TdxPDFIconFitParameters = record
  public
    FitToAnnotationBounds: Boolean;
    HorizontalPosition: Double;
    ScalingCircumstances: TdxPDFIconScalingCircumstances;
    ScalingType: TdxPDFIconScalingType;
    VerticalPosition: Double;
  end;

  { TdxPDFIconFit }

  TdxPDFIconFit = class(TdxPDFObject)
  strict private const
    DefaultPosition = 0.5;
  strict private
    FFitToAnnotationBounds: Boolean;
    FHorizontalPosition: Single;
    FScalingCircumstances: TdxPDFIconScalingCircumstances;
    FScalingType: TdxPDFIconScalingType;
    FVerticalPosition: Single;
    //
    procedure SetFitToAnnotationBounds(const AValue: Boolean);
    procedure SetHorizontalPosition(const AValue: Single);
    procedure SetScalingCircumstances(const AValue: TdxPDFIconScalingCircumstances);
    procedure SetScalingType(const AValue: TdxPDFIconScalingType);
    procedure SetVerticalPosition(const AValue: Single);
    //
    class function ConvertToPosition(const APosition: Single): Single; static;
    class function IconScalingCircumstancesFrom(const AValue: string): TdxPDFIconScalingCircumstances; static;
    class function IconScalingCircumstancesTo(AValue: TdxPDFIconScalingCircumstances): string; static;
    class function IconScalingTypeFrom(const AValue: string): TdxPDFIconScalingType; static;
    class function IconScalingTypeTo(AValue: TdxPDFIconScalingType): string; static;
  strict protected
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Initialize; override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    procedure AssignParameters(const AParameters: TdxPDFIconFitParameters);
    //
    property FitToAnnotationBounds: Boolean read FFitToAnnotationBounds write SetFitToAnnotationBounds;
    property HorizontalPosition: Single read FHorizontalPosition write SetHorizontalPosition;
    property ScalingCircumstances: TdxPDFIconScalingCircumstances read FScalingCircumstances write SetScalingCircumstances;
    property ScalingType: TdxPDFIconScalingType read FScalingType write SetScalingType;
    property VerticalPosition: Single read FVerticalPosition write SetVerticalPosition;
  end;

  { TdxPDFWidgetAppearanceCharacteristics }

  TdxPDFWidgetAppearanceCharacteristics = class(TdxPDFObject) // for internal use
  strict private
    FAlternateCaption: string;
    FBackgroundColor: TdxPDFColor;
    FBorderColor: TdxPDFColor;
    FCaption: string;
    FIconFit: TdxPDFIconFit;
    FRolloverCaption: string;
    FRotationAngle: Integer;
    FTextPosition: TdxPDFWidgetAnnotationTextPosition;
    //
    FAlternateIcon: TdxPDFXObject;
    FNormalIcon: TdxPDFXObject;
    FRolloverIcon: TdxPDFXObject;
    //
    function GetIconFit: TdxPDFIconFit;
    procedure SetAlternateCaption(const AValue: string);
    procedure SetAlternateIcon(const AValue: TdxPDFXObject);
    procedure SetBackgroundColor(const AValue: TdxPDFColor);
    procedure SetBorderColor(const AValue: TdxPDFColor);
    procedure SetCaption(const AValue: string);
    procedure SetIconFit(const AValue: TdxPDFIconFit);
    procedure SetNormalIcon(const AValue: TdxPDFXObject);
    procedure SetRolloverCaption(const AValue: string);
    procedure SetRolloverIcon(const AValue: TdxPDFXObject);
    procedure SetRotationAngle(const AValue: Integer);
    procedure SetTextPosition(const AValue: TdxPDFWidgetAnnotationTextPosition);
    //
    procedure EnsureIconFit;
  strict protected
    function Write(AHelper: TdxPDFWriterHelper): TdxPDFBase; override;
    procedure Changed(AChanges: TdxPDFDocumentChanges); override;
    procedure DestroySubClasses; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Initialize; override;
  protected
    OnChanged: TNotifyEvent;
  public
    procedure SetButtonCaption(const AValue: TdxPDFButtonStyle);
    //
    property AlternateCaption: string read FAlternateCaption write SetAlternateCaption;
    property AlternateIcon: TdxPDFXObject read FAlternateIcon write SetAlternateIcon;
    property BackgroundColor: TdxPDFColor read FBackgroundColor write SetBackgroundColor;
    property BorderColor: TdxPDFColor read FBorderColor write SetBorderColor;
    property Caption: string read FCaption write SetCaption;
    property IconFit: TdxPDFIconFit read GetIconFit write SetIconFit;
    property NormalIcon: TdxPDFXObject read FNormalIcon write SetNormalIcon;
    property RolloverCaption: string read FRolloverCaption write SetRolloverCaption;
    property RolloverIcon: TdxPDFXObject read FRolloverIcon write SetRolloverIcon;
    property RotationAngle: Integer read FRotationAngle write SetRotationAngle;
    property TextPosition: TdxPDFWidgetAnnotationTextPosition read FTextPosition write SetTextPosition;
  end;

  { TdxPDFActionAnnotation }

  TdxPDFActionAnnotation = class(TdxPDFCustomAnnotation)
  strict private
    FAction: TdxPDFCustomAction;
    FDestinationInfo: TdxPDFDestinationInfo;
    FInteractiveOperation: TdxPDFInteractiveOperation;
    //
    function GetDestination: TdxPDFCustomDestination;
    function GetInteractiveOperation: TdxPDFInteractiveOperation;
    procedure SetAction(const AValue: TdxPDFCustomAction);
    procedure SetDestinationInfo(const AValue: TdxPDFDestinationInfo);
  protected
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure Resolve(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    property Destination: TdxPDFCustomDestination read GetDestination;
    property DestinationInfo: TdxPDFDestinationInfo read FDestinationInfo write SetDestinationInfo;
  public
    procedure Accept(const AVisitor: IdxPDFCustomAnnotationVisitor); override;
    //
    property Action: TdxPDFCustomAction read FAction write SetAction;
    property InteractiveOperation: TdxPDFInteractiveOperation read GetInteractiveOperation;
  end;

  { TdxPDFWidgetAnnotation }

  TdxPDFWidgetAnnotation = class(TdxPDFActionAnnotation)
  strict private
    FAppearanceCharacteristics: TdxPDFWidgetAppearanceCharacteristics;
    FBorderStyle: TdxPDFAnnotationBorderStyle;
    FHighlightingMode: TdxPDFAnnotationHighlightingMode;
    FRotationAngle: Integer;
    FWriteLock: Integer;
    //
    function GetAppearanceCharacteristics: TdxPDFWidgetAppearanceCharacteristics;
    function GetAppearanceContentRectangle: TdxPDFRectangle;
    function GetBackgroundColor: TdxPDFColor;
    function GetBorderStyle: TdxPDFAnnotationBorderStyle;
    function GetBorderWidth: Single;
    function GetButtonStyle: TdxPDFButtonStyle;
    function GetField: TdxPDFInteractiveFormField;
    procedure SetAppearanceCharacteristics(const AValue: TdxPDFWidgetAppearanceCharacteristics);
    procedure SetBorderStyle(const AValue: TdxPDFAnnotationBorderStyle);
    procedure SetButtonStyle(const AValue: TdxPDFButtonStyle);
    procedure SetField(const AValue: TdxPDFInteractiveFormField);
    //
    procedure ReadAppearanceCharacteristics;
    procedure OnAppearanceChangedHandler(ASender: TObject);
  protected
    FField: TdxPDFInteractiveFormField;
    FOnChanged: TNotifyEvent;
    //
    function AppearanceNeeded(AForm: TdxPDFXForm): Boolean; override;
    function CreateAppearanceBuilder: TObject; override;
    function GetActualAppearanceName: string;
    function GetAppearanceBBox: TdxPDFRectangle; override;
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure Read(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    class function GetTypeName: string; override;
    //
    function EnsureAppearance: TdxPDFXForm; overload;
    function GetOnAppearanceName: string;
    function UseDefaultAppearance: Boolean; override;
    procedure Accept(const AVisitor: IdxPDFCustomAnnotationVisitor); override;
    //
    property AppearanceContentRectangle: TdxPDFRectangle read GetAppearanceContentRectangle;
    property AppearanceCharacteristics: TdxPDFWidgetAppearanceCharacteristics read GetAppearanceCharacteristics write
      SetAppearanceCharacteristics;
    property BackgroundColor: TdxPDFColor read GetBackgroundColor;

    property BorderStyle: TdxPDFAnnotationBorderStyle read GetBorderStyle write SetBorderStyle;
    property BorderWidth: Single read GetBorderWidth;
    property ButtonStyle: TdxPDFButtonStyle read GetButtonStyle write SetButtonStyle;
    property Field: TdxPDFInteractiveFormField read GetField write SetField;
    property HighlightingMode: TdxPDFAnnotationHighlightingMode read FHighlightingMode;
    property RotationAngle: Integer read FRotationAngle write FRotationAngle;
  end;

  { TdxPDFLinkAnnotation }

  TdxPDFLinkAnnotation = class(TdxPDFActionAnnotation)
  strict private
    function GetBounds: TdxRectF;
    function GetHint: string;
  public
    class function GetTypeName: string; override;
    procedure Accept(const AVisitor: IdxPDFCustomAnnotationVisitor); override;
    //
    property Bounds: TdxRectF read GetBounds;
    property Hint: string read GetHint;
  end;

  { TdxPDFMarkupAnnotation }

  TdxPDFMarkupAnnotation = class(TdxPDFActionAnnotation)
  strict private
    FCreationDate: TDateTime;
    FOpacity: Single;
    FInReplyTo: TdxPDFCustomAnnotation;
    FRichText: string;
    FSubject: string;
    FTitle: string;
    //
    function GetBounds: TdxRectF;
    function GetCreationDate: TDateTime;
    function GetHint: string;
    function GetIntent: string;
    function GetRichText: string;
    function GetSubject: string;
    function GetTitle: string;
  strict protected
    FIntent: string;
  protected
    procedure Initialize; override;
    procedure Resolve(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    property CreationDate: TDateTime read GetCreationDate;
    property Intent: string read GetIntent;
    property RichText: string read GetRichText;
    property Subject: string read GetSubject;
    property Title: string read GetTitle;
  public
    property Bounds: TdxRectF read GetBounds;
    property Hint: string read GetHint;
    property Opacity: Single read FOpacity;
    property InReplyTo: TdxPDFCustomAnnotation read FInReplyTo;
  end;

  { TdxPDFTextAnnotation }

  TdxPDFTextAnnotation = class(TdxPDFMarkupAnnotation)
  strict private const
    DefaultIconName = 'None';
    DefaultOpenedState = False;
  strict private
    FIconName: string;
    FIsOpened: Boolean;
    FState: string;
    FStateModel: string;
  protected
    function CreateAppearanceBuilder: TObject; override;
    procedure Initialize; override;
    procedure Resolve(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    property IsOpened: Boolean read FIsOpened;
    property State: string read FState write FState;
    property StateModel: string read FStateModel;
  public
    class function GetTypeName: string; override;
    procedure Accept(const AVisitor: IdxPDFCustomAnnotationVisitor); override;
    //
    property IconName: string read FIconName write FIconName;
  end;

  { TdxPDFFileAttachmentAnnotation }

  TdxPDFFileAttachmentAnnotation = class(TdxPDFMarkupAnnotation)
  strict private
    FDescription: string;
    FFileName: string;
    FFileSpecification: TdxPDFFileSpecification;
    FFileSystem: string;
    FIconName: string;
    //
    function GetDescription: string;
    function GetFileAttachment: TdxPDFFileAttachment;
    function GetFileSpecification: TdxPDFFileSpecification;
    function GetIconName: string;
    procedure SetFileSpecification(const AValue: TdxPDFFileSpecification);
    //
    procedure DestroyFileSpecification;
  protected
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure Initialize; override;
    procedure Resolve(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    property FileSpecification: TdxPDFFileSpecification read GetFileSpecification write SetFileSpecification;
  public
    class function GetTypeName: string; override;
    procedure Accept(const AVisitor: IdxPDFCustomAnnotationVisitor); override;
    //
    property Attachment: TdxPDFFileAttachment read GetFileAttachment;
    property Description: string read GetDescription;
    property IconName: string read GetIconName;
  end;

  { TdxPDFFreeTextAnnotation }

  TdxPDFFreeTextAnnotation = class(TdxPDFTextAnnotation)
  strict private
    FAppearanceCommands: TdxPDFCommandList;
    FBorderEffect: TdxPDFAnnotationBorderEffect;
    FBorderStyle: TdxPDFAnnotationBorderStyle;
    FDefaultStyle: string;
    FCallout: TdxPDFAnnotationCallout;
    FCalloutStartLineEndingStyle: TdxPDFAnnotationLineEndingStyle;
    FCalloutFinishLineEndingStyle: TdxPDFAnnotationLineEndingStyle;
    FFreeTextIntent: TdxPDFFreeTextAnnotationIntent;
    FPadding: TdxPDFRectangle;
    FTextJustify: TdxPDFTextJustify;
    FResources: TdxPDFResources;
    //
    function GetBorderEffect: TdxPDFAnnotationBorderEffect;
    function GetBorderStyle: TdxPDFAnnotationBorderStyle;
    function GetDefaultStyle: string;
    function GetCallout: TdxPDFAnnotationCallout;
    function GetFreeTextIntent: TdxPDFFreeTextAnnotationIntent;
    function GetPadding: TdxPDFRectangle;
    function GetTextJustify: TdxPDFTextJustify;
    procedure SetBorderEffect(const AValue: TdxPDFAnnotationBorderEffect);
    procedure SetBorderStyle(const AValue: TdxPDFAnnotationBorderStyle);
    procedure SetCallout(const AValue: TdxPDFAnnotationCallout);
  protected
    function CreateAppearanceBuilder: TObject; override;
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure Resolve(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    class function GetTypeName: string; override;
    procedure Accept(const AVisitor: IdxPDFCustomAnnotationVisitor); override;
    //
    property BorderEffect: TdxPDFAnnotationBorderEffect read GetBorderEffect write SetBorderEffect;
    property BorderStyle: TdxPDFAnnotationBorderStyle read GetBorderStyle write SetBorderStyle;
    property Callout: TdxPDFAnnotationCallout read GetCallout write SetCallout;
    property DefaultStyle: string read GetDefaultStyle;
    property FreeTextIntent: TdxPDFFreeTextAnnotationIntent read GetFreeTextIntent;
    property Padding: TdxPDFRectangle read GetPadding;
    property TextJustify: TdxPDFTextJustify read GetTextJustify;
  end;

  { TdxPDFShapeAnnotation }

  TdxPDFShapeAnnotation = class(TdxPDFMarkupAnnotation)
  strict private
    FBorderEffect: TdxPDFAnnotationBorderEffect;
    FBorderStyle: TdxPDFAnnotationBorderStyle;
    FInteriorColor: TdxPDFColor;
    FPadding: TdxPDFRectangle;
    //
    function GetBorderEffect: TdxPDFAnnotationBorderEffect;
    function GetBorderStyle: TdxPDFAnnotationBorderStyle;
    function GetInteriorColor: TdxPDFColor;
    function GetPadding: TdxPDFRectangle;
    procedure SetBorderEffect(const AValue: TdxPDFAnnotationBorderEffect);
    procedure SetBorderStyle(const AValue: TdxPDFAnnotationBorderStyle);
  protected
    procedure DestroySubClasses; override;
    procedure Resolve(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    property BorderEffect: TdxPDFAnnotationBorderEffect read GetBorderEffect write SetBorderEffect;
    property BorderStyle: TdxPDFAnnotationBorderStyle read GetBorderStyle write SetBorderStyle;
    property InteriorColor: TdxPDFColor read GetInteriorColor;
    property Padding: TdxPDFRectangle read GetPadding;
  end;

  { TdxPDFCircleAnnotation }

  TdxPDFCircleAnnotation = class(TdxPDFShapeAnnotation)
  protected
    function CreateAppearanceBuilder: TObject; override;
  public
    class function GetTypeName: string; override;
    procedure Accept(const AVisitor: IdxPDFCustomAnnotationVisitor); override;
  end;

  { TdxPDFSquareAnnotation }

  TdxPDFSquareAnnotation = class(TdxPDFShapeAnnotation)
  protected
    function CreateAppearanceBuilder: TObject; override;
  public
    class function GetTypeName: string; override;
    procedure Accept(const AVisitor: IdxPDFCustomAnnotationVisitor); override;
  end;

  { TdxPDFRedactAnnotation }

  TdxPDFRedactAnnotation = class(TdxPDFMarkupAnnotation)
  public
    class function GetTypeName: string; override;
    procedure Accept(const AVisitor: IdxPDFCustomAnnotationVisitor); override;
  end;

  { TdxPDFStampAnnotation }

  TdxPDFStampAnnotation = class(TdxPDFMarkupAnnotation)
  public
    class function GetTypeName: string; override;
    procedure Accept(const AVisitor: IdxPDFCustomAnnotationVisitor); override;
  end;

  { TdxPDFInkAnnotation }

  TdxPDFInkAnnotation = class(TdxPDFMarkupAnnotation)
  strict private
    FBorderStyle: TdxPDFAnnotationBorderStyle;
    FInks: TList<TdxPointsF>;
    //
    function GetBorderStyle: TdxPDFAnnotationBorderStyle;
    function GetInks: TList<TdxPointsF>;
    procedure SetBorderStyle(const AValue: TdxPDFAnnotationBorderStyle);
  protected
    function CreateAppearanceBuilder: TObject; override;
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure Resolve(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    class function GetTypeName: string; override;
    procedure Accept(const AVisitor: IdxPDFCustomAnnotationVisitor); override;
    //
    property BorderStyle: TdxPDFAnnotationBorderStyle read GetBorderStyle write SetBorderStyle;
    property Inks: TList<TdxPointsF> read GetInks;
  end;

  { TdxPDFCaretAnnotation }

  TdxPDFCaretAnnotation = class(TdxPDFMarkupAnnotation)
  protected
    function CreateAppearanceBuilder: TObject; override;
  public
    class function GetTypeName: string; override;
    procedure Accept(const AVisitor: IdxPDFCustomAnnotationVisitor); override;
  end;

  { TdxPDFMovieAnnotation }

  TdxPDFMovieAnnotation = class(TdxPDFCustomAnnotation)
  public
    class function GetTypeName: string; override;
    procedure Accept(const AVisitor: IdxPDFCustomAnnotationVisitor); override;
  end;

implementation

uses
  Math, dxCore, dxPDFInteractivity, dxPDFUtils, dxPDFTextMarkupAnnotation, dxPDFAppearanceBuilder,
  dxPDFPathAnnotationAppearanceBuilder, dxPDFInteractiveFormField;

const
  dxThisUnitName = 'dxPDFAnnotation';

type
  TdxPDFInteractiveFormFieldAccess = class(TdxPDFInteractiveFormField);
  TdxPDFObjectAccess = class(TdxPDFObject);
  TdxPDFURIActionAccess = class(TdxPDFURIAction);

{ TdxPDFAnnotationBorderEffect }

class function TdxPDFAnnotationBorderEffect.Parse(ADictionary: TdxPDFReaderDictionary): TdxPDFAnnotationBorderEffect;
var
  ABorderEffectDictionary: TdxPDFReaderDictionary;
begin
  if ADictionary.TryGetDictionary(TdxPDFKeywords.AnnotationBorderEffect, ABorderEffectDictionary) then
  begin
    Result := TdxPDFAnnotationBorderEffect.Create;
    Result.Read(ABorderEffectDictionary);
  end
  else
    Result := nil;
end;

procedure TdxPDFAnnotationBorderEffect.DoRead(ADictionary: TdxPDFReaderDictionary);
var
  AIntensity: Double;
begin
  inherited DoRead(ADictionary);
  if ADictionary.GetString(TdxPDFKeywords.AnnotationBorderEffectStyle) = 'C' then
    FStyle := esCloudy
  else
    FStyle := esNo;
  AIntensity := ADictionary.GetDouble(TdxPDFKeywords.AnnotationBorderEffectIntensity);
  if TdxPDFUtils.IsDoubleValid(AIntensity) then
    FIntensity := Min(Max(AIntensity, 0), 2);
end;

procedure TdxPDFAnnotationBorderEffect.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
const
  Map: array[TdxPDFAnnotationBorderEffectStyle] of string = ('S', 'C');
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.Add(TdxPDFKeywords.AnnotationBorderEffectIntensity, Intensity, 0.0);
  ADictionary.Add(TdxPDFKeywords.AnnotationBorderEffectStyle, Map[Style]);
end;

{ TdxPDFIconFit }

procedure TdxPDFIconFit.AssignParameters(const AParameters: TdxPDFIconFitParameters);
begin
  BeginUpdate;
  try
    FitToAnnotationBounds := AParameters.FitToAnnotationBounds;
    HorizontalPosition := AParameters.HorizontalPosition;
    ScalingCircumstances := AParameters.ScalingCircumstances;
    ScalingType := AParameters.ScalingType;
    VerticalPosition := AParameters.VerticalPosition;
  finally
    EndUpdate;
  end;
end;

procedure TdxPDFIconFit.DoRead(ADictionary: TdxPDFReaderDictionary);
var
  AArray: TdxPDFArray;
begin
  inherited DoRead(ADictionary);
  ScalingCircumstances := IconScalingCircumstancesFrom(ADictionary.GetString(TdxPDFKeywords.IconFitScalingCircumstances));
  ScalingType := IconScalingTypeFrom(ADictionary.GetString(TdxPDFKeywords.IconFitScalingType));
  FitToAnnotationBounds := ADictionary.GetBoolean(TdxPDFKeywords.IconFitFitToAnnotationBounds);
  if ADictionary.TryGetArray(TdxPDFKeywords.IconFitPosition, AArray) and (AArray.Count > 1) then
  begin
    HorizontalPosition := ConvertToPosition(AArray.GetSingle(0));
    VerticalPosition := ConvertToPosition(AArray.GetSingle(1));
  end;
end;

procedure TdxPDFIconFit.Initialize;
begin
  inherited Initialize;
  FHorizontalPosition := DefaultPosition;
  FVerticalPosition := DefaultPosition;
end;

procedure TdxPDFIconFit.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.Add(TdxPDFKeywords.IconFitScalingCircumstances, IconScalingCircumstancesTo(FScalingCircumstances));
  ADictionary.Add(TdxPDFKeywords.IconFitScalingType, IconScalingTypeTo(FScalingType));
  ADictionary.Add(TdxPDFKeywords.IconFitFitToAnnotationBounds, FFitToAnnotationBounds, False);
  if (HorizontalPosition <> DefaultPosition) or (VerticalPosition <> DefaultPosition) then
    ADictionary.Add(TdxPDFKeywords.IconFitPosition, TdxPDFArray.Create([FHorizontalPosition, FVerticalPosition]));
end;

procedure TdxPDFIconFit.SetFitToAnnotationBounds(const AValue: Boolean);
begin
  if FFitToAnnotationBounds <> AValue then
  begin
    FFitToAnnotationBounds := AValue;
    AppearanceChanged;
  end;
end;

procedure TdxPDFIconFit.SetHorizontalPosition(const AValue: Single);
begin
  if not SameValue(FHorizontalPosition, AValue) then
  begin
    FHorizontalPosition := AValue;
    AppearanceChanged;
  end;
end;

procedure TdxPDFIconFit.SetScalingCircumstances(const AValue: TdxPDFIconScalingCircumstances);
begin
  if FScalingCircumstances <> AValue then
  begin
    FScalingCircumstances := AValue;
    AppearanceChanged;
  end;
end;

procedure TdxPDFIconFit.SetScalingType(const AValue: TdxPDFIconScalingType);
begin
  if FScalingType <> AValue then
  begin
    FScalingType := AValue;
    AppearanceChanged;
  end;
end;

procedure TdxPDFIconFit.SetVerticalPosition(const AValue: Single);
begin
  if not SameValue(FVerticalPosition, AValue) then
  begin
    FVerticalPosition := AValue;
    AppearanceChanged;
  end;
end;

class function TdxPDFIconFit.ConvertToPosition(const APosition: Single): Single;
begin
  if (APosition < 0) or (APosition > 1) then
    TdxPDFUtils.Abort;
  Result := APosition;
end;

class function TdxPDFIconFit.IconScalingCircumstancesFrom(const AValue: string): TdxPDFIconScalingCircumstances;
begin
  if AValue = 'A' then
    Result := iscAlways
  else
    if AValue = 'B' then
      Result := iscBiggerThanAnnotationRectangle
    else
      if AValue = 'S' then
        Result := iscSmallerThanAnnotationRectangle
      else
        Result := iscNever;
end;

class function TdxPDFIconFit.IconScalingCircumstancesTo(AValue: TdxPDFIconScalingCircumstances): string;
const
  Map: array[TdxPDFIconScalingCircumstances] of string = ('Always', 'BiggerThanAnnotationRectangle',
    'SmallerThanAnnotationRectangle', 'Never');
begin
  Result := Map[AValue];
end;

class function TdxPDFIconFit.IconScalingTypeFrom(const AValue: string): TdxPDFIconScalingType;
begin
  if AValue = 'A' then
    Result := istAnamorphic
  else
    Result := istProportional;
end;

class function TdxPDFIconFit.IconScalingTypeTo(AValue: TdxPDFIconScalingType): string;
const
  Map: array[TdxPDFIconScalingType] of string = ('Proportional', 'Anamorphic');
begin
  Result := Map[AValue];
end;

{ TdxPDFWidgetAppearanceCharacteristics }

procedure TdxPDFWidgetAppearanceCharacteristics.SetButtonCaption(const AValue: TdxPDFButtonStyle);
const
  Map: array[TdxPDFButtonStyle] of string = ('l', '4', 'H', '8', 'u', 'n');
begin
  Caption := Map[AValue];
end;

procedure TdxPDFWidgetAppearanceCharacteristics.DoRead(ADictionary: TdxPDFReaderDictionary);

  function GetIcon(const AKey: string): TdxPDFXObject;
  var
    AObject: TdxPDFBase;
  begin
    if ADictionary.TryGetObject(AKey, AObject) then
      Result := Repository.GetXObject(AObject.Number)
    else
      Result := nil;
  end;

var
  AIconFitDictionary: TdxPDFReaderDictionary;
begin
  inherited DoRead(ADictionary);
  FCaption := ADictionary.GetString(TdxPDFKeywords.AppearanceCharacteristicsCaption);
  FAlternateCaption := ADictionary.GetString(TdxPDFKeywords.AppearanceCharacteristicsAlternateCaption);
  FBorderColor := ADictionary.GetColor(TdxPDFKeywords.AppearanceCharacteristicsBorderColor);
  FBackgroundColor := ADictionary.GetColor(TdxPDFKeywords.AppearanceCharacteristicsBackgroundColor);
  if ADictionary.TryGetDictionary(TdxPDFKeywords.AppearanceCharacteristicsIconFit, AIconFitDictionary) then
  begin
    EnsureIconFit;
    IconFit.Read(AIconFitDictionary);
  end;
  FRotationAngle := TdxPDFUtils.NormalizeRotate(ADictionary.GetInteger(TdxPDFKeywords.AppearanceCharacteristicsRotation, 0));
  FRolloverCaption := ADictionary.GetString(TdxPDFKeywords.AppearanceCharacteristicsRolloverCaption);
  FTextPosition := TdxPDFWidgetAnnotationTextPosition(ADictionary.GetInteger(TdxPDFKeywords.AppearanceCharacteristicsTextPosition, 0));

  NormalIcon := GetIcon(TdxPDFKeywords.AppearanceCharacteristicsNormalIcon);
  RolloverIcon := GetIcon(TdxPDFKeywords.AppearanceCharacteristicsRolloverIcon);
  AlternateIcon := GetIcon(TdxPDFKeywords.AppearanceCharacteristicsAlternateIcon);
end;

procedure TdxPDFWidgetAppearanceCharacteristics.Initialize;
begin
  inherited Initialize;
  FBackgroundColor := TdxPDFColor.Null;
  FBorderColor := TdxPDFColor.Null;
end;

function TdxPDFWidgetAppearanceCharacteristics.GetIconFit: TdxPDFIconFit;
begin
  EnsureIconFit;
  Result := FIconFit;
end;

procedure TdxPDFWidgetAppearanceCharacteristics.SetAlternateCaption(const AValue: string);
begin
  if FAlternateCaption <> AValue then
  begin
    FAlternateCaption := AValue;
    LayoutChanged;
  end;
end;

procedure TdxPDFWidgetAppearanceCharacteristics.SetIconFit(const AValue: TdxPDFIconFit);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FIconFit));
end;

procedure TdxPDFWidgetAppearanceCharacteristics.SetAlternateIcon(const AValue: TdxPDFXObject);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FAlternateIcon));
end;

procedure TdxPDFWidgetAppearanceCharacteristics.SetBackgroundColor(const AValue: TdxPDFColor);
begin
  FBackgroundColor := AValue;
  LayoutChanged;
end;

procedure TdxPDFWidgetAppearanceCharacteristics.SetBorderColor(const AValue: TdxPDFColor);
begin
  FBorderColor := AValue;
  LayoutChanged;
end;

procedure TdxPDFWidgetAppearanceCharacteristics.SetCaption(const AValue: string);
begin
  if Caption <> AValue then
  begin
    FCaption := AValue;
    LayoutChanged;
  end;
end;

procedure TdxPDFWidgetAppearanceCharacteristics.SetNormalIcon(const AValue: TdxPDFXObject);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FNormalIcon));
end;

procedure TdxPDFWidgetAppearanceCharacteristics.SetRolloverCaption(const AValue: string);
begin
  if FRolloverCaption <> AValue then
  begin
    FRolloverCaption := AValue;
    LayoutChanged;
  end;
end;

procedure TdxPDFWidgetAppearanceCharacteristics.SetRolloverIcon(const AValue: TdxPDFXObject);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FRolloverIcon));
end;

procedure TdxPDFWidgetAppearanceCharacteristics.SetRotationAngle(const AValue: Integer);
begin
  if FRotationAngle <> AValue then
  begin
    FRotationAngle := AValue;
    DataChanged;
  end;
end;

procedure TdxPDFWidgetAppearanceCharacteristics.SetTextPosition(const AValue: TdxPDFWidgetAnnotationTextPosition);
begin
  if FTextPosition <> AValue then
  begin
    FTextPosition := AValue;
    DataChanged;
  end;
end;

procedure TdxPDFWidgetAppearanceCharacteristics.EnsureIconFit;
begin
  if FIconFit = nil then
    FIconFit := TdxPDFIconFit.Create(Self);
end;

function TdxPDFWidgetAppearanceCharacteristics.Write(AHelper: TdxPDFWriterHelper): TdxPDFBase;
var
  ADictionary: TdxPDFWriterDictionary;
begin
  ADictionary := AHelper.CreateDictionary;
  ADictionary.Add(TdxPDFKeywords.AppearanceCharacteristicsAlternateCaption, FAlternateCaption);
  ADictionary.Add(TdxPDFKeywords.AppearanceCharacteristicsCaption, FCaption);
  ADictionary.Add(TdxPDFKeywords.AppearanceCharacteristicsBorderColor, FBorderColor);
  ADictionary.Add(TdxPDFKeywords.AppearanceCharacteristicsBackgroundColor, FBackgroundColor);
  ADictionary.Add(TdxPDFKeywords.AppearanceCharacteristicsRotation, FRotationAngle);
  ADictionary.Add(TdxPDFKeywords.AppearanceCharacteristicsRolloverCaption, FRolloverCaption);
  ADictionary.Add(TdxPDFKeywords.AppearanceCharacteristicsTextPosition, Ord(FTextPosition), Ord(wtpNoIcon));
  ADictionary.AddReference(TdxPDFKeywords.AppearanceCharacteristicsNormalIcon, NormalIcon);
  ADictionary.AddReference(TdxPDFKeywords.AppearanceCharacteristicsRolloverIcon, RolloverIcon);
  ADictionary.AddReference(TdxPDFKeywords.AppearanceCharacteristicsAlternateIcon, AlternateIcon);
  Result := ADictionary;
end;

procedure TdxPDFWidgetAppearanceCharacteristics.Changed(AChanges: TdxPDFDocumentChanges);
begin
  dxCallNotify(OnChanged, Self);
end;

procedure TdxPDFWidgetAppearanceCharacteristics.DestroySubClasses;
begin
  AlternateIcon := nil;
  RolloverIcon := nil;
  NormalIcon := nil;
  IconFit := nil;
  inherited DestroySubClasses;
end;

{ TdxPDFActionAnnotation }

procedure TdxPDFActionAnnotation.Accept(const AVisitor: IdxPDFCustomAnnotationVisitor);
begin
  AVisitor.Visit(Self);
end;

procedure TdxPDFActionAnnotation.CreateSubClasses;
begin
  inherited CreateSubClasses;
  Action := nil;
  DestinationInfo := nil;
end;

procedure TdxPDFActionAnnotation.DestroySubClasses;
begin
  DestinationInfo := nil;
  Action := nil;
  inherited DestroySubClasses;
end;

procedure TdxPDFActionAnnotation.Resolve(ADictionary: TdxPDFReaderDictionary);
begin
  inherited Resolve(ADictionary);
  if ADictionary <> nil then
  begin
    Action := ADictionary.GetAction(TdxPDFKeywords.ShortAction);
    DestinationInfo := ADictionary.GetDestinationInfo(TdxPDFKeywords.Destination);
  end;
end;

procedure TdxPDFActionAnnotation.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.AddReference(TdxPDFKeywords.ShortAction, Action);
  ADictionary.Add(TdxPDFKeywords.Destination, FDestinationInfo);
end;

function TdxPDFActionAnnotation.GetDestination: TdxPDFCustomDestination;
begin
  if FDestinationInfo <> nil then
    Result := FDestinationInfo.GetDestination(Repository.Catalog, True)
  else
    Result := nil;
end;

function TdxPDFActionAnnotation.GetInteractiveOperation: TdxPDFInteractiveOperation;
begin
  if not FInteractiveOperation.IsValid then
    FInteractiveOperation := TdxPDFInteractiveOperation.Create(FAction, Destination);
  Result := FInteractiveOperation;
end;

procedure TdxPDFActionAnnotation.SetAction(const AValue: TdxPDFCustomAction);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FAction));
end;

procedure TdxPDFActionAnnotation.SetDestinationInfo(const AValue: TdxPDFDestinationInfo);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FDestinationInfo));
end;

{ TdxPDFWidgetAnnotation }

class function TdxPDFWidgetAnnotation.GetTypeName: string;
begin
  Result := 'Widget';
end;

function TdxPDFWidgetAnnotation.EnsureAppearance: TdxPDFXForm;
var
  ADownAppearanceForm: TdxPDFXForm;
  AField: TdxPDFInteractiveFormField;
begin
  AField := Field;
  if (AField <> nil) and AField.IsPushButton then
  begin
    ADownAppearanceForm := GetAppearanceForm(asDown);
    if ADownAppearanceForm <> nil then
      Exit(EnsureAppearanceForm(asDown, ADownAppearanceForm));
  end;
  Result := EnsureAppearanceForm(asNormal, GetAppearanceForm(asNormal));
end;

function TdxPDFWidgetAnnotation.AppearanceNeeded(AForm: TdxPDFXForm): Boolean;
begin
  Result := inherited AppearanceNeeded(AForm) or (Field <> nil) and (Field.Form <> nil) and Field.Form.NeedAppearances;
end;

function TdxPDFWidgetAnnotation.CreateAppearanceBuilder: TObject;
begin
  if Field <> nil then
    Result := TdxPDFInteractiveFormFieldAccess(Field).CreateAppearanceBuilder
  else
    Result := nil;
end;

procedure TdxPDFWidgetAnnotation.CreateSubClasses;
begin
  inherited CreateSubClasses;
  Action := nil;
  BorderStyle := nil;
  Field := nil;
end;

procedure TdxPDFWidgetAnnotation.DestroySubClasses;
begin
  FreeAndNil(FAppearanceCharacteristics);
  Field := nil;
  BorderStyle := nil;
  Action := nil;
  inherited DestroySubClasses;
end;

procedure TdxPDFWidgetAnnotation.Read(ADictionary: TdxPDFReaderDictionary);
var
  ANumber: Integer;
begin
  ANumber := Number;
  inherited Read(ADictionary);
  if Dictionary <> nil then
  begin
    Number := ANumber;
    FHighlightingMode := Dictionary.GetAnnotationHighlightingMode;
    ReadAppearanceCharacteristics;
    BorderStyle := Repository.CreateBorderStyle(Dictionary);
    SetField(Repository.ResolveField(Number));
    FRotationAngle := Dictionary.GetInteger(TdxPDFKeywords.ShortRotationAngle);
  end;
end;

procedure TdxPDFWidgetAnnotation.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  if FWriteLock <> 0 then
    Exit;
  Inc(FWriteLock);
  try
    inherited Write(AHelper, ADictionary);
    ADictionary.AddName(TdxPDFKeywords.AnnotationHighlightingMode, dxPDFAnnotationHighlightingModeIdMap[FHighlightingMode]);
    ADictionary.AddInline(TdxPDFKeywords.AppearanceCharacteristics, FAppearanceCharacteristics);
    ADictionary.AddInline(TdxPDFKeywords.AnnotationBorderStyle, FBorderStyle);
    ADictionary.Add(TdxPDFKeywords.ShortRotationAngle, RotationAngle);
    if Field <> nil then
      TdxPDFObjectAccess(Field).Write(AHelper, ADictionary);
  finally
    Dec(FWriteLock);
  end;
end;

function TdxPDFWidgetAnnotation.GetActualAppearanceName: string;
var
  ANames: TStringList;
begin
  Result := AppearanceName;
  if Appearance <> nil then
  begin
    ANames := Appearance.Names;
    if ANames.Count = 1 then
      Exit(ANames[0]);
    if ANames.Count > 1 then
    begin
      if ANames[0] = TdxPDFKeywords.OffStateName then
        Exit(ANames[1])
      else
        Exit(ANames[0])
    end;
  end;
  Result := TdxPDFKeywords.OffStateName;
end;

function TdxPDFWidgetAnnotation.GetAppearanceBBox: TdxPDFRectangle;
var
  ACharacteristics: TdxPDFWidgetAppearanceCharacteristics;
begin
  ACharacteristics := AppearanceCharacteristics;
  if (ACharacteristics <> nil) and ((ACharacteristics.RotationAngle = 90) or (ACharacteristics.RotationAngle = 270)) then
      Result := TdxPDFRectangle.Create(0, 0, Rect.Height, Rect.Width)
  else
    Result := inherited GetAppearanceBBox;
end;

function TdxPDFWidgetAnnotation.GetOnAppearanceName: string;
var
  ANames: TStringList;
begin
  if Appearance = nil then
    Exit(TdxPDFKeywords.OffStateName);
  ANames := Appearance.Normal.GetNames('');
  if ANames.Count = 1 then
    Result := ANames[0]
  else
    if ANames.Count > 1 then
    begin
      if ANames[0] = TdxPDFKeywords.OffStateName then
        Result := ANames[1]
      else
        Result := ANames[0];
    end;
end;

function TdxPDFWidgetAnnotation.UseDefaultAppearance: Boolean;
begin
  Result := (FField = nil) or (FField <> nil) and FField.UseDefaultAppearance;
end;

procedure TdxPDFWidgetAnnotation.Accept(const AVisitor: IdxPDFCustomAnnotationVisitor);
begin
  AVisitor.Visit(Self);
end;

function TdxPDFWidgetAnnotation.GetAppearanceCharacteristics: TdxPDFWidgetAppearanceCharacteristics;
begin
  if FAppearanceCharacteristics = nil then
  begin
    ReadAppearanceCharacteristics;
    if FAppearanceCharacteristics = nil then
      FAppearanceCharacteristics := TdxPDFWidgetAppearanceCharacteristics.Create(Self);
  end;
  Result := FAppearanceCharacteristics;
  Result.OnChanged := OnAppearanceChangedHandler;
end;

function TdxPDFWidgetAnnotation.GetAppearanceContentRectangle: TdxPDFRectangle;
var
  ABBox: TdxPDFRectangle;
  ALayoutBorderWidth, ARight, ATop: Double;
begin
  ABBox := AppearanceBBox;
  ALayoutBorderWidth := BorderWidth;
  ARight := ABBox.Width - ALayoutBorderWidth;
  ATop := Abs(ABBox.Height) - ALayoutBorderWidth;
  Result := TdxPDFRectangle.Create(ALayoutBorderWidth, ALayoutBorderWidth,
    IfThen(ARight > ALayoutBorderWidth, ARight, ALayoutBorderWidth + 1),
    IfThen(ATop > ALayoutBorderWidth, ATop, ALayoutBorderWidth + 1));
end;

function TdxPDFWidgetAnnotation.GetBackgroundColor: TdxPDFColor;
begin
  if AppearanceCharacteristics = nil then
    Result := TdxPDFColor.Null
  else
    Result := AppearanceCharacteristics.BackgroundColor;
end;

function TdxPDFWidgetAnnotation.GetBorderStyle: TdxPDFAnnotationBorderStyle;
begin
  if FBorderStyle = nil then
    FBorderStyle := Repository.CreateBorderStyle;
  Result := FBorderStyle;
end;

function TdxPDFWidgetAnnotation.GetBorderWidth: Single;
begin
  if BorderStyle <> nil then
    Result := BorderStyle.Width
  else
    if Border <> nil then
      Result := Border.LineWidth
    else
      Result := 0;
end;

function TdxPDFWidgetAnnotation.GetButtonStyle: TdxPDFButtonStyle;
var
  ACaption: string;
begin
  if AppearanceCharacteristics = nil then
    Exit(bfsCircle);

  ACaption := AppearanceCharacteristics.Caption;
  if ACaption = '4' then
    Result := bfsCheck
  else

  if ACaption = 'l' then
    Result := bfsCircle
  else

  if ACaption = 'H' then
    Result := bfsStar
  else

  if ACaption = '8' then
    Result := bfsCross
  else

  if ACaption = 'u' then
    Result := bfsDiamond
  else
    Result := bfsSquare
end;

function TdxPDFWidgetAnnotation.GetField: TdxPDFInteractiveFormField;
begin
  if FField = nil then
    FField := Repository.ResolveField(Number);
  Result := FField;
end;

procedure TdxPDFWidgetAnnotation.SetAppearanceCharacteristics(const AValue: TdxPDFWidgetAppearanceCharacteristics);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FAppearanceCharacteristics));
end;

procedure TdxPDFWidgetAnnotation.SetBorderStyle(const AValue: TdxPDFAnnotationBorderStyle);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FBorderStyle));
end;

procedure TdxPDFWidgetAnnotation.SetButtonStyle(const AValue: TdxPDFButtonStyle);
begin
  AppearanceCharacteristics.SetButtonCaption(AValue);
end;

procedure TdxPDFWidgetAnnotation.SetField(const AValue: TdxPDFInteractiveFormField);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FField));
  if FField <> nil then
    FParent := FField;
end;

procedure TdxPDFWidgetAnnotation.ReadAppearanceCharacteristics;
var
  ADictionary: TdxPDFReaderDictionary;
begin
  if (Dictionary <> nil) and Dictionary.TryGetDictionary(TdxPDFKeywords.AppearanceCharacteristics, ADictionary) then
    AppearanceCharacteristics := Repository.CreateAndRead(TdxPDFWidgetAppearanceCharacteristics,
      ADictionary, Self) as TdxPDFWidgetAppearanceCharacteristics;
end;

procedure TdxPDFWidgetAnnotation.OnAppearanceChangedHandler(ASender: TObject);
begin
  if FField <> nil then
    FField.AppearanceChanged(True);
end;

{ TdxPDFLinkAnnotation }

class function TdxPDFLinkAnnotation.GetTypeName: string;
begin
  Result := 'Link';
end;

procedure TdxPDFLinkAnnotation.Accept(const AVisitor: IdxPDFCustomAnnotationVisitor);
begin
  AVisitor.Visit(Self);
end;

function TdxPDFLinkAnnotation.GetBounds: TdxRectF;
begin
  Result := Rect.ToRectF;
end;

function TdxPDFLinkAnnotation.GetHint: string;
begin
  if (Action <> nil) and (Action is TdxPDFURIAction) then
    Result := TdxPDFURIActionAccess(Action).URI
  else
    Result := '';
end;

{ TdxPDFMarkupAnnotation }

procedure TdxPDFMarkupAnnotation.Initialize;
begin
  inherited Initialize;
  FInReplyTo := nil;
  FOpacity := 1;
end;

procedure TdxPDFMarkupAnnotation.Resolve(ADictionary: TdxPDFReaderDictionary);
begin
  inherited Resolve(ADictionary);
  FCreationDate := ADictionary.GetDate(TdxPDFKeywords.MarkupAnnotationCreationDate);
  FIntent := ADictionary.GetString(TdxPDFKeywords.MarkupAnnotationIntent);
  FOpacity := ADictionary.GetDouble(TdxPDFKeywords.MarkupAnnotationOpacity, FOpacity);
  FRichText := ADictionary.GetTextString(TdxPDFKeywords.MarkupAnnotationRichText);
  FSubject := ADictionary.GetTextString(TdxPDFKeywords.MarkupAnnotationSubject);
  FTitle := ADictionary.GetTextString(TdxPDFKeywords.MarkupAnnotationTitle);
end;

procedure TdxPDFMarkupAnnotation.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.AddDate(TdxPDFKeywords.MarkupAnnotationCreationDate, CreationDate);
  ADictionary.Add(TdxPDFKeywords.MarkupAnnotationTitle, Title);
  ADictionary.Add(TdxPDFKeywords.MarkupAnnotationSubject, Subject);
  ADictionary.Add(TdxPDFKeywords.MarkupAnnotationOpacity, Opacity);
  ADictionary.Add(TdxPDFKeywords.MarkupAnnotationRichText, RichText);
  ADictionary.Add(TdxPDFKeywords.MarkupAnnotationIntent, Intent);
end;

function TdxPDFMarkupAnnotation.GetBounds: TdxRectF;
begin
  Result := Rect.ToRectF;
end;

function TdxPDFMarkupAnnotation.GetCreationDate: TDateTime;
begin
  Ensure;
  Result := FCreationDate;
end;

function TdxPDFMarkupAnnotation.GetHint: string;
begin
  if Length(Contents) > 0 then
    Result := Title + dxCRLF + Contents
  else
    Result := '';
end;

function TdxPDFMarkupAnnotation.GetIntent: string;
begin
  Ensure;
  Result := FIntent;
end;

function TdxPDFMarkupAnnotation.GetRichText: string;
begin
  Ensure;
  Result := FRichText;
end;

function TdxPDFMarkupAnnotation.GetSubject: string;
begin
  Ensure;
  Result := FSubject;
end;

function TdxPDFMarkupAnnotation.GetTitle: string;
begin
  Ensure;
  Result := FTitle;
end;

{ TdxPDFTextAnnotation }

class function TdxPDFTextAnnotation.GetTypeName: string;
begin
  Result := TdxPDFKeywords.TextAnnotation;
end;

procedure TdxPDFTextAnnotation.Accept(const AVisitor: IdxPDFCustomAnnotationVisitor);
begin
  AVisitor.Visit(Self);
end;

function TdxPDFTextAnnotation.CreateAppearanceBuilder: TObject;
begin
  Result := TdxPDFTextAnnotationAppearanceBuilder.Create(Self);
end;

procedure TdxPDFTextAnnotation.Initialize;
begin
  inherited Initialize;
  FIconName := DefaultIconName;
end;

procedure TdxPDFTextAnnotation.Resolve(ADictionary: TdxPDFReaderDictionary);
begin
  inherited Resolve(ADictionary);
  FIsOpened := ADictionary.GetBoolean(TdxPDFKeywords.IsOpen, DefaultOpenedState);
  FIconName := ADictionary.GetString(TdxPDFKeywords.Name, DefaultIconName);
  FState := ADictionary.GetTextString(TdxPDFKeywords.State);
  FStateModel := ADictionary.GetTextString(TdxPDFKeywords.StateModel);
end;

procedure TdxPDFTextAnnotation.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.AddName(TdxPDFKeywords.Name, IconName);
  ADictionary.Add(TdxPDFKeywords.IsOpen, IsOpened, DefaultOpenedState);
  ADictionary.Add(TdxPDFKeywords.State, State);
  ADictionary.Add(TdxPDFKeywords.StateModel, StateModel);
end;

{ TdxPDFFileAttachmentAnnotation }

class function TdxPDFFileAttachmentAnnotation.GetTypeName: string;
begin
  Result := 'FileAttachment';
end;

procedure TdxPDFFileAttachmentAnnotation.Accept(const AVisitor: IdxPDFCustomAnnotationVisitor);
begin
  AVisitor.Visit(Self);
end;

procedure TdxPDFFileAttachmentAnnotation.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FileSpecification := nil;
end;

procedure TdxPDFFileAttachmentAnnotation.DestroySubClasses;
begin
  DestroyFileSpecification;
  inherited DestroySubClasses;
end;

procedure TdxPDFFileAttachmentAnnotation.Initialize;
begin
  inherited Initialize;
  FIconName := 'PushPin';
end;

procedure TdxPDFFileAttachmentAnnotation.Resolve(ADictionary: TdxPDFReaderDictionary);
begin
  inherited Resolve(ADictionary);
  FFileSystem := ADictionary.GetString(TdxPDFKeywords.FileSystem);
  FFileName := ADictionary.GetString('UF');
  if FFileName = '' then
    FFileName := ADictionary.GetString('F');
  if FFileName = '' then
    FFileName := ADictionary.GetString('DOS');
  if FFileName = '' then
    FFileName := ADictionary.GetString('Mac');
  if FFileName = '' then
    FFileName := ADictionary.GetString('Unix');
  FileSpecification := Repository.CreateFileSpecification(ADictionary.GetDictionary(TdxPDFKeywords.FileSystem));
  FDescription := ADictionary.GetString(TdxPDFKeywords.FileAttachmentAnnotationDesc);
  FIconName := ADictionary.GetString(TdxPDFKeywords.FileAttachmentAnnotationName, FIconName);
end;

procedure TdxPDFFileAttachmentAnnotation.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.AddName(TdxPDFKeywords.FileSystem, TdxPDFKeywords.FileSpec);
  ADictionary.AddReference(TdxPDFKeywords.FileSystem, FileSpecification);
  ADictionary.Add(TdxPDFKeywords.FileAttachmentAnnotationName, IconName);
  ADictionary.Add(TdxPDFKeywords.FileAttachmentAnnotationDesc, Description);
end;

function TdxPDFFileAttachmentAnnotation.GetDescription: string;
begin
  Ensure;
  Result := FDescription;
end;

function TdxPDFFileAttachmentAnnotation.GetFileAttachment: TdxPDFFileAttachment;
begin
  Result := FileSpecification.Attachment;
end;

function TdxPDFFileAttachmentAnnotation.GetFileSpecification: TdxPDFFileSpecification;
begin
  Ensure;
  Result := FFileSpecification;
end;

function TdxPDFFileAttachmentAnnotation.GetIconName: string;
begin
  Ensure;
  Result := FIconName;
end;

procedure TdxPDFFileAttachmentAnnotation.DestroyFileSpecification;
var
  ACatalog: TdxPDFCatalog;
begin
  if FFileSpecification <> nil then
  begin
    ACatalog := Catalog;
    if ACatalog <> nil then
      ACatalog.RemoveAttachment(FFileSpecification.Attachment);
    FileSpecification := nil;
  end;
end;

procedure TdxPDFFileAttachmentAnnotation.SetFileSpecification(const AValue: TdxPDFFileSpecification);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FFileSpecification));
end;

{ TdxPDFFreeTextAnnotation }

class function TdxPDFFreeTextAnnotation.GetTypeName: string;
begin
  Result := TdxPDFKeywords.FreeTextAnnotation;
end;

procedure TdxPDFFreeTextAnnotation.Accept(const AVisitor: IdxPDFCustomAnnotationVisitor);
begin
  AVisitor.Visit(Self);
end;

function TdxPDFFreeTextAnnotation.CreateAppearanceBuilder: TObject;
begin
  Result := nil;
end;

procedure TdxPDFFreeTextAnnotation.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FResources := Repository.CreateResources;
end;

procedure TdxPDFFreeTextAnnotation.DestroySubClasses;
begin
  BorderStyle := nil;
  BorderEffect := nil;
  Callout := nil;
  FreeAndNil(FAppearanceCommands);
  FreeAndNil(FResources);
  inherited DestroySubClasses;
end;

procedure TdxPDFFreeTextAnnotation.Resolve(ADictionary: TdxPDFReaderDictionary);

  procedure ReadFreeTextIntent;
  begin
    if FIntent = 'FreeTextCallout' then
      FFreeTextIntent := aiFreeTextCallout
    else
      if (FIntent = 'FreeTextTypewriter') or (FIntent = 'FreeTextTypeWriter') then
        FFreeTextIntent := aiFreeTextTypeWriter
    else
      FFreeTextIntent := aiFreeText;
  end;

begin
  inherited Resolve(ADictionary);
  FAppearanceCommands := ADictionary.GetAppearance(FResources);
  FTextJustify := ADictionary.GetTextJustify;
  FDefaultStyle := ADictionary.GetString(TdxPDFKeywords.FreeTextAnnotationDefaultStyle);
  Callout := ADictionary.GetAnnotationCallout(TdxPDFKeywords.AnnotationCallout);
  BorderEffect := TdxPDFAnnotationBorderEffect.Parse(ADictionary);
  BorderStyle := Repository.CreateBorderStyle(ADictionary);
  FPadding := ADictionary.GetPadding(FRect);
  ReadFreeTextIntent;
  ADictionary.TryGetLineEndingStyle(FCalloutStartLineEndingStyle, FCalloutFinishLineEndingStyle);
end;

procedure TdxPDFFreeTextAnnotation.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.SetAppearance(FResources, FAppearanceCommands);
  ADictionary.SetTextJustify(FTextJustify);
  ADictionary.Add(TdxPDFKeywords.FreeTextAnnotationDefaultStyle, FDefaultStyle);
  ADictionary.AddReference(TdxPDFKeywords.AnnotationCallout, FBorderEffect);
  ADictionary.AddReference(TdxPDFKeywords.AnnotationCallout, FCallout);
  ADictionary.Add(TdxPDFKeywords.Padding, FPadding);
  ADictionary.AddReference(TdxPDFKeywords.AnnotationBorderStyle, FBorderStyle);
  ADictionary.Add(TdxPDFKeywords.LineEnding, FCalloutStartLineEndingStyle, FCalloutFinishLineEndingStyle);
end;

function TdxPDFFreeTextAnnotation.GetBorderEffect: TdxPDFAnnotationBorderEffect;
begin
  Ensure;
  Result := FBorderEffect;
end;

function TdxPDFFreeTextAnnotation.GetBorderStyle: TdxPDFAnnotationBorderStyle;
begin
  Ensure;
  Result := FBorderStyle;
end;

function TdxPDFFreeTextAnnotation.GetDefaultStyle: string;
begin
  Ensure;
  Result := FDefaultStyle;
end;

function TdxPDFFreeTextAnnotation.GetCallout: TdxPDFAnnotationCallout;
begin
  Ensure;
  Result := FCallout;
end;

function TdxPDFFreeTextAnnotation.GetFreeTextIntent: TdxPDFFreeTextAnnotationIntent;
begin
  Ensure;
  Result := FFreeTextIntent;
end;

function TdxPDFFreeTextAnnotation.GetPadding: TdxPDFRectangle;
begin
  Ensure;
  Result := FPadding
end;

function TdxPDFFreeTextAnnotation.GetTextJustify: TdxPDFTextJustify;
begin
  Ensure;
  Result := FTextJustify;
end;

procedure TdxPDFFreeTextAnnotation.SetBorderEffect(const AValue: TdxPDFAnnotationBorderEffect);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FBorderEffect));
end;

procedure TdxPDFFreeTextAnnotation.SetBorderStyle(const AValue: TdxPDFAnnotationBorderStyle);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FBorderStyle));
end;

procedure TdxPDFFreeTextAnnotation.SetCallout(const AValue: TdxPDFAnnotationCallout);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FCallout));
end;

{ TdxPDFShapeAnnotation }

procedure TdxPDFShapeAnnotation.DestroySubClasses;
begin
  BorderEffect := nil;
  BorderStyle := nil;
  inherited DestroySubClasses;
end;

procedure TdxPDFShapeAnnotation.Resolve(ADictionary: TdxPDFReaderDictionary);
begin
  inherited Resolve(ADictionary);
  BorderStyle := Repository.CreateBorderStyle(ADictionary);
  FInteriorColor := ADictionary.GetColor(TdxPDFKeywords.InteriorColor);
  BorderEffect := TdxPDFAnnotationBorderEffect.Parse(ADictionary);
  FPadding := ADictionary.GetPadding(ADictionary.GetRectangleEx(TdxPDFKeywords.Rect));
end;

procedure TdxPDFShapeAnnotation.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.AddReference(TdxPDFKeywords.AnnotationBorderStyle, BorderStyle);
  ADictionary.AddReference(TdxPDFKeywords.AnnotationBorderEffect, BorderEffect);
  ADictionary.Add(TdxPDFKeywords.InteriorColor, InteriorColor);
  ADictionary.Add(TdxPDFKeywords.Padding, Padding);
end;

function TdxPDFShapeAnnotation.GetBorderEffect: TdxPDFAnnotationBorderEffect;
begin
  Ensure;
  Result := FBorderEffect;
end;

function TdxPDFShapeAnnotation.GetBorderStyle: TdxPDFAnnotationBorderStyle;
begin
  Ensure;
  Result := FBorderStyle;
end;

function TdxPDFShapeAnnotation.GetInteriorColor: TdxPDFColor;
begin
  Ensure;
  Result := FInteriorColor;
end;

function TdxPDFShapeAnnotation.GetPadding: TdxPDFRectangle;
begin
  Ensure;
  Result := FPadding;
end;

procedure TdxPDFShapeAnnotation.SetBorderEffect(const AValue: TdxPDFAnnotationBorderEffect);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FBorderEffect));
end;

procedure TdxPDFShapeAnnotation.SetBorderStyle(const AValue: TdxPDFAnnotationBorderStyle);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FBorderStyle));
end;

{ TdxPDFCircleAnnotation }

class function TdxPDFCircleAnnotation.GetTypeName: string;
begin
  Result := TdxPDFKeywords.CircleAnnotation;
end;

procedure TdxPDFCircleAnnotation.Accept(const AVisitor: IdxPDFCustomAnnotationVisitor);
begin
  AVisitor.Visit(Self);
end;

function TdxPDFCircleAnnotation.CreateAppearanceBuilder: TObject;
begin
  Result := TdxPDFCircleAnnotationAppearanceBuilder.Create(Self);
end;

{ TdxPDFSquareAnnotation }

class function TdxPDFSquareAnnotation.GetTypeName: string;
begin
  Result := TdxPDFKeywords.SquareAnnotation;
end;

procedure TdxPDFSquareAnnotation.Accept(const AVisitor: IdxPDFCustomAnnotationVisitor);
begin
  AVisitor.Visit(Self);
end;

function TdxPDFSquareAnnotation.CreateAppearanceBuilder: TObject;
begin
  Result := TdxPDFSquareAnnotationAppearanceBuilder.Create(Self);
end;

{ TdxPDFRedactAnnotation }

class function TdxPDFRedactAnnotation.GetTypeName: string;
begin
  Result := TdxPDFKeywords.RedactAnnotation;
end;

procedure TdxPDFRedactAnnotation.Accept(const AVisitor: IdxPDFCustomAnnotationVisitor);
begin
  AVisitor.Visit(Self);
end;

{ TdxPDFStampAnnotation }

class function TdxPDFStampAnnotation.GetTypeName: string;
begin
  Result := TdxPDFKeywords.StampAnnotation;
end;

procedure TdxPDFStampAnnotation.Accept(const AVisitor: IdxPDFCustomAnnotationVisitor);
begin
  AVisitor.Visit(Self);
end;

{ TdxPDFInkAnnotation }

class function TdxPDFInkAnnotation.GetTypeName: string;
begin
  Result := TdxPDFKeywords.InkAnnotation;
end;

procedure TdxPDFInkAnnotation.Accept(const AVisitor: IdxPDFCustomAnnotationVisitor);
begin
  AVisitor.Visit(Self);
end;

function TdxPDFInkAnnotation.CreateAppearanceBuilder: TObject;
begin
  Result := TdxPDFInkAnnotationAppearanceBuilder.Create(Self);
end;

procedure TdxPDFInkAnnotation.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FInks := TList<TdxPointsF>.Create;
end;

procedure TdxPDFInkAnnotation.DestroySubClasses;
begin
  BorderStyle := nil;
  FreeAndNil(FInks);
  inherited DestroySubClasses;
end;

procedure TdxPDFInkAnnotation.Resolve(ADictionary: TdxPDFReaderDictionary);
var
  AArray, AElement: TdxPDFArray;
  I: Integer;
begin
  inherited Resolve(ADictionary);
  BorderStyle := Repository.CreateBorderStyle(ADictionary);

  if ADictionary.TryGetArray(TdxPDFKeywords.InkList, AArray) then
    for I := 0 to AArray.Count - 1 do
      if AArray.TryGetArray(I, AElement) then
        Finks.Add(TdxPDFUtils.ArrayToPoints(AElement))
      else
        TdxPDFUtils.Abort;
end;

procedure TdxPDFInkAnnotation.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
var
  AArray, AElement: TdxPDFArray;
  I, J: Integer;
  APointArray: TdxPointsF;
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.AddReference(TdxPDFKeywords.AnnotationBorderStyle, BorderStyle);

  if FInks.Count > 0 then
  begin
    AArray := AHelper.CreateArray;
    for I := 0 to FInks.Count - 1 do
    begin
      APointArray := FInks[I];
      AElement := TdxPDFArray.Create;
      for J := 0 to Length(APointArray) - 1 do
        AElement.Add(APointArray[J]);
      AArray.Add(AElement);
    end;
    ADictionary.Add(TdxPDFKeywords.InkList, AArray);
  end;
end;

function TdxPDFInkAnnotation.GetBorderStyle: TdxPDFAnnotationBorderStyle;
begin
  Ensure;
  Result := FBorderStyle;
end;

function TdxPDFInkAnnotation.GetInks: TList<TdxPointsF>;
begin
  Ensure;
  Result := FInks;
end;

procedure TdxPDFInkAnnotation.SetBorderStyle(const AValue: TdxPDFAnnotationBorderStyle);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FBorderStyle));
end;

{ TdxPDFCaretAnnotation }

class function TdxPDFCaretAnnotation.GetTypeName: string;
begin
  Result := TdxPDFKeywords.CaretAnnotation;
end;

procedure TdxPDFCaretAnnotation.Accept(const AVisitor: IdxPDFCustomAnnotationVisitor);
begin
  AVisitor.Visit(Self);
end;

function TdxPDFCaretAnnotation.CreateAppearanceBuilder: TObject;
begin
  Result := TdxPDFCaretAnnotationAppearanceBuilder.Create(Self);
end;

{ TdxPDFMovieAnnotation }

class function TdxPDFMovieAnnotation.GetTypeName: string;
begin
  Result := TdxPDFKeywords.Movie;
end;

procedure TdxPDFMovieAnnotation.Accept(const AVisitor: IdxPDFCustomAnnotationVisitor);
begin
  AVisitor.Visit(Self);
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxPDFRegisterDocumentObjectClass(TdxPDFLinkAnnotation);
  dxPDFRegisterDocumentObjectClass(TdxPDFWidgetAnnotation);
  dxPDFRegisterDocumentObjectClass(TdxPDFFileAttachmentAnnotation);
  dxPDFRegisterDocumentObjectClass(TdxPDFCircleAnnotation);
  dxPDFRegisterDocumentObjectClass(TdxPDFSquareAnnotation);
  dxPDFRegisterDocumentObjectClass(TdxPDFFreeTextAnnotation);
  dxPDFRegisterDocumentObjectClass(TdxPDFRedactAnnotation);
  dxPDFRegisterDocumentObjectClass(TdxPDFTextAnnotation);
  dxPDFRegisterDocumentObjectClass(TdxPDFStampAnnotation);
  dxPDFRegisterDocumentObjectClass(TdxPDFInkAnnotation);
  dxPDFRegisterDocumentObjectClass(TdxPDFCaretAnnotation);
  dxPDFRegisterDocumentObjectClass(TdxPDFMovieAnnotation);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxPDFUnregisterDocumentObjectClass(TdxPDFMovieAnnotation);
  dxPDFUnregisterDocumentObjectClass(TdxPDFStampAnnotation);
  dxPDFUnregisterDocumentObjectClass(TdxPDFInkAnnotation);
  dxPDFUnregisterDocumentObjectClass(TdxPDFCaretAnnotation);
  dxPDFUnregisterDocumentObjectClass(TdxPDFTextAnnotation);
  dxPDFUnregisterDocumentObjectClass(TdxPDFRedactAnnotation);
  dxPDFUnregisterDocumentObjectClass(TdxPDFFreeTextAnnotation);
  dxPDFUnregisterDocumentObjectClass(TdxPDFSquareAnnotation);
  dxPDFUnregisterDocumentObjectClass(TdxPDFCircleAnnotation);
  dxPDFUnregisterDocumentObjectClass(TdxPDFFileAttachmentAnnotation);
  dxPDFUnregisterDocumentObjectClass(TdxPDFWidgetAnnotation);
  dxPDFUnregisterDocumentObjectClass(TdxPDFLinkAnnotation);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
