{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           Express Cross Platform Library graphics classes          }
{                                                                    }
{           Copyright (c) 2000-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSCROSSPLATFORMLIBRARY AND ALL   }
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

unit cxAccessibility; // for internal use

interface

{$I cxVer.inc}

uses
  Types, Windows, ActiveX, Classes, OleServer, Messages, dxCore, dxCoreClasses, cxClasses;

(*$HPPEMIT '#include <OleIdl.h>*)

const
  cxAccessibleObjectSelfID = 0;

  SID_IcxAccessible = '{618736E0-3C3D-11CF-810C-00AA00389B71}';
  IID_IcxAccessible: TGUID = SID_IcxAccessible;

  SID_IdxRawElementProviderSimple = '{D6DD68D1-86FD-4332-8666-9ABEDEA2D24C}';
  IID_IdxRawElementProviderSimple: TGUID = '{D6DD68D1-86FD-4332-8666-9ABEDEA2D24C}';

  SID_IdxAccessibleEx = '{F8B80ADA-2C44-48D0-89BE-5FF23C9CD875}';
  IID_IdxAccessibleEx: TGUID = SID_IdxAccessibleEx;

  SID_IdxRangeValueProvider = '{36DC7AEF-33E6-4691-AFE1-2BE7274B3D33}';
  IID_IdxRangeValueProvider: TGUID = SID_IdxRangeValueProvider;

  SID_IdxRawElementProviderSimple2 = '{A0A839A9-8DA1-4A82-806A-8E0D44E79F56}';
  IID_IdxRawElementProviderSimple2: TGUID = SID_IdxRawElementProviderSimple2;

  SID_IdxRawElementProviderSimple3 = '{FCF5D820-D7EC-4613-BDF6-42A84CE7DAAF}';
  IID_IdxRawElementProviderSimple3: TGUID = SID_IdxRawElementProviderSimple3;

  SID_IdxRawElementProviderFragmentRoot = '{620CE2A5-AB8F-40A9-86CB-DE3C75599B58}';
  IID_IdxRawElementProviderFragmentRoot: TGUID = SID_IdxRawElementProviderFragmentRoot;

  SID_IdxRawElementProviderFragment = '{F7063DA8-8359-439C-9297-BBC5299A7D87}';
  IID_IdxRawElementProviderFragment: TGUID = SID_IdxRawElementProviderFragment;

  SID_IdxRawElementProviderAdviseEvents = '{A407B27B-0F6D-4427-9292-473C7BF93258}';
  IID_IdxRawElementProviderAdviseEvents: TGUID = SID_IdxRawElementProviderAdviseEvents;

  SID_IdxRawElementProviderHwndOverride = '{1D5DF27C-8947-4425-B8D9-79787BB460B8}';
  IID_IdxRawElementProviderHwndOverride: TGUID = SID_IdxRawElementProviderHwndOverride;

  SID_IdxProxyProviderWinEventSink = '{4FD82B78-A43E-46AC-9803-0A6969C7C183}';
  IID_IdxProxyProviderWinEventSink: TGUID = SID_IdxProxyProviderWinEventSink;

  SID_IdxProxyProviderWinEventHandler = '{89592AD4-F4E0-43D5-A3B6-BAD7E111B435}';
  IID_IdxProxyProviderWinEventHandler: TGUID = SID_IdxProxyProviderWinEventHandler;

  SID_IdxRawElementProviderWindowlessSite = '{0A2A93CC-BFAD-42AC-9B2E-0991FB0D3EA0}';
  IID_IdxRawElementProviderWindowlessSite: TGUID = SID_IdxRawElementProviderWindowlessSite;

  SID_IdxAccessibleHostingElementProviders = '{33AC331B-943E-4020-B295-DB37784974A3}';
  IID_IdxAccessibleHostingElementProviders: TGUID = SID_IdxAccessibleHostingElementProviders;

  SID_IdxDockProvider = '{159BC72C-4AD3-485E-9637-D7052EDF0146}';
  IID_IdxDockProvider: TGUID = SID_IdxDockProvider;

  SID_IdxExpandCollapseProvider = '{D847D3A5-CAB0-4A98-8C32-ECB45C59AD24}';
  IID_IdxExpandCollapseProvider: TGUID = SID_IdxExpandCollapseProvider;

  SID_IdxGridProvider = '{B17D6187-0907-464B-A168-0EF17A1572B1}';
  IID_IdxGridProvider: TGUID = SID_IdxGridProvider;

  SID_IdxGridItemProvider = '{D02541F1-FB81-4D64-AE32-F520F8A6DBD1}';
  IID_IdxGridItemProvider: TGUID = SID_IdxGridItemProvider;

  SID_IdxInvokeProvider = '{54FCB24B-E18E-47A2-B4D3-ECCBE77599A2}';
  IID_IdxInvokeProvider: TGUID = SID_IdxInvokeProvider;

  SID_IdxMultipleViewProvider = '{6278CAB1-B556-4A1A-B4E0-418ACC523201}';
  IID_IdxMultipleViewProvider: TGUID = SID_IdxMultipleViewProvider;

  SID_IdxScrollItemProvider = '{2360C714-4BF1-4B26-BA65-9B21316127EB}';
  IID_IdxScrollItemProvider: TGUID = SID_IdxScrollItemProvider;

  SID_IdxSelectionProvider = '{FB8B03AF-3BDF-48D4-BD36-1A65793BE168}';
  IID_IdxSelectionProvider: TGUID = SID_IdxSelectionProvider;

  SID_IdxScrollProvider = '{B38B8077-1FC3-42A5-8CAE-D40C2215055A}';
  IID_IdxScrollProvider: TGUID = SID_IdxScrollProvider;

  SID_IdxSelectionItemProvider = '{2ACAD808-B2D4-452D-A407-91FF1AD167B2}';
  IID_IdxSelectionItemProvider: TGUID = SID_IdxSelectionItemProvider;

  SID_IdxSynchronizedInputProvider = '{29DB1A06-02CE-4CF7-9B42-565D4FAB20EE}';
  IID_IdxSynchronizedInputProvider: TGUID = SID_IdxSynchronizedInputProvider;

  SID_IdxTableProvider = '{9C860395-97B3-490A-B52A-858CC22AF166}';
  IID_IdxTableProvider: TGUID = SID_IdxTableProvider;

  SID_IdxTableItemProvider = '{B9734FA6-771F-4D78-9C90-2517999349CD}';
  IID_IdxTableItemProvider: TGUID = SID_IdxTableItemProvider;

  SID_IdxToggleProvider = '{56D00BD0-C4F4-433C-A836-1A52A57E0892}';
  IID_IdxToggleProvider: TGUID = SID_IdxToggleProvider;

  SID_IdxTransformProvider = '{6829DDC4-4F91-4FFA-B86F-BD3E2987CB4C}';
  IID_IdxTransformProvider: TGUID = SID_IdxTransformProvider;

  SID_IdxValueProvider = '{C7935180-6FB3-4201-B174-7DF73ADBF64A}';
  IID_IdxValueProvider: TGUID = SID_IdxValueProvider;

  SID_IdxWindowProvider = '{987DF77B-DB06-4D77-8F8A-86A9C3BB90B9}';
  IID_IdxWindowProvider: TGUID = SID_IdxWindowProvider;

  SID_IdxLegacyIAccessibleProvider = '{E44C3566-915D-4070-99C6-047BFF5A08F5}';
  IID_IdxLegacyIAccessibleProvider: TGUID = SID_IdxLegacyIAccessibleProvider;

  SID_IdxItemContainerProvider = '{E747770B-39CE-4382-AB30-D8FB3F336F24}';
  IID_IdxItemContainerProvider: TGUID = SID_IdxItemContainerProvider;

  SID_IdxVirtualizedItemProvider = '{CB98B665-2D35-4FAC-AD35-F3C60D0C0B8B}';
  IID_IdxVirtualizedItemProvider: TGUID = SID_IdxVirtualizedItemProvider;

  SID_IdxObjectModelProvider = '{3AD86EBD-F5EF-483D-BB18-B1042A475D64}';
  IID_IdxObjectModelProvider: TGUID = SID_IdxObjectModelProvider;

  SID_IdxAnnotationProvider = '{F95C7E80-BD63-4601-9782-445EBFF011FC}';
  IID_IdxAnnotationProvider: TGUID = SID_IdxAnnotationProvider;

  SID_IdxStylesProvider = '{19B6B649-F5D7-4A6D-BDCB-129252BE588A}';
  IID_IdxStylesProvider: TGUID = SID_IdxStylesProvider;

  SID_IdxSpreadsheetProvider = '{6F6B5D35-5525-4F80-B758-85473832FFC7}';
  IID_IdxSpreadsheetProvider: TGUID = SID_IdxSpreadsheetProvider;

  SID_IdxSpreadsheetItemProvider = '{EAED4660-7B3D-4879-A2E6-365CE603F3D0}';
  IID_IdxSpreadsheetItemProvider: TGUID = SID_IdxSpreadsheetItemProvider;

  SID_IdxTransformProvider2 = '{4758742F-7AC2-460C-BC48-09FC09308A93}';
  IID_IdxTransformProvider2: TGUID = SID_IdxTransformProvider2;

  SID_IdxDragProvider = '{6AA7BBBB-7FF9-497D-904F-D20B897929D8}';
  IID_IdxDragProvider: TGUID = SID_IdxDragProvider;

  SID_IdxDropTargetProvider = '{BAE82BFD-358A-481C-85A0-D8B4D90A5D61}';
  IID_IdxDropTargetProvider: TGUID = SID_IdxDropTargetProvider;

  SID_IdxTextRangeProvider = '{5347AD7B-C355-46F8-AFF5-909033582F63}';
  IID_IdxTextRangeProvider: TGUID = SID_IdxTextRangeProvider;

  SID_IdxTextProvider = '{3589C92C-63F3-4367-99BB-ADA653B77CF2}';
  IID_IdxTextProvider: TGUID = SID_IdxTextProvider;

  SID_IdxTextProvider2 = '{0DC5E6ED-3E16-4BF1-8F9A-A979878BC195}';
  IID_IdxTextProvider2: TGUID = SID_IdxTextProvider2;

  SID_IdxTextEditProvider = '{EA3605B4-3A05-400E-B5F9-4E91B40F6176}';
  IID_IdxTextEditProvider: TGUID = SID_IdxTextEditProvider;

  SID_IdxTextRangeProvider2 = '{9BBCE42C-1921-4F18-89CA-DBA1910A0386}';
  IID_IdxTextRangeProvider2: TGUID = SID_IdxTextRangeProvider2;

  SID_IdxTextChildProvider = '{4C2DE2B9-C88F-4F88-A111-F1D336B7D1A9}';
  IID_IdxTextChildProvider: TGUID = SID_IdxTextChildProvider;

  SID_IdxCustomNavigationProvider = '{2062A28A-8C07-4B94-8E12-7037C622AEB8}';
  IID_IdxCustomNavigationProvider: TGUID = SID_IdxCustomNavigationProvider;

  SID_IdxUIAutomationPatternInstance = '{C03A7FE4-9431-409F-BED8-AE7C2299BC8D}';
  IID_IdxUIAutomationPatternInstance: TGUID = SID_IdxUIAutomationPatternInstance;

  SID_IdxUIAutomationPatternHandler = '{D97022F3-A947-465E-8B2A-AC4315FA54E8}';
  IID_IdxUIAutomationPatternHandler: TGUID = SID_IdxUIAutomationPatternHandler;

  SID_IdxUIAutomationRegistrar = '{8609C4EC-4A1A-4D88-A357-5A66E060E1CF}';
  IID_IdxUIAutomationRegistrar: TGUID = SID_IdxUIAutomationRegistrar;

  dxProviderOptions_ClientSideProvider = $00000001;
  dxProviderOptions_ServerSideProvider = $00000002;
  dxProviderOptions_NonClientAreaProvider = $00000004;
  dxProviderOptions_OverrideProvider = $00000008;
  dxProviderOptions_ProviderOwnsSetFocus = $00000010;
  dxProviderOptions_UseComThreading = $00000020;
  dxProviderOptions_RefuseNonClientSupport = $00000040;
  dxProviderOptions_HasNativeIAccessible = $00000080;
  dxProviderOptions_UseClientCoordinates = $00000100;

  dxExpandCollapseState_Collapsed = $00000000;
  dxExpandCollapseState_Expanded = $00000001;
  dxExpandCollapseState_PartiallyExpanded = $00000002;
  dxExpandCollapseState_LeafNode = $00000003;

type
  TcxAccessibilityHelper = class;

  TdxAccessiblePattern = (apInvoke, apSelection, apValue, apRangeValue);
  TdxAccessiblePatterns = set of TdxAccessiblePattern;

  TcxAccessibleSimpleChildElementID = 0..MaxInt;

  TcxAccessibleObjectProperty = (aopDefaultAction, aopDescription, aopFocus, aopLocation, aopShortcut, aopValue, aopSelect);
  TcxAccessibleObjectProperties = set of TcxAccessibleObjectProperty;

  TcxAccessibleObjectHitTest = (aohtNone, aohtSelf, aohtChild);

  TcxAccessibilityNavigationDirection = (andLeft, andUp, andRight, andDown, andPrev, andNext);

  { IcxAccessible }

  IcxAccessible = interface(IDispatch)
  [SID_IcxAccessible]
    function Get_accParent(out ppdispParent: IDispatch): HResult; stdcall;
    function Get_accChildCount(out pcountChildren: Integer): HResult; stdcall;
    function Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult; stdcall;
    function Get_accName(varChild: OleVariant; out pszName: WideString): HResult; stdcall;
    function Get_accValue(varChild: OleVariant; out pszValue: WideString): HResult; stdcall;
    function Get_accDescription(varChild: OleVariant; out pszDescription: WideString): HResult; stdcall;
    function Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult; stdcall;
    function Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult; stdcall;
    function Get_accHelp(varChild: OleVariant; out pszHelp: WideString): HResult; stdcall;
    function Get_accHelpTopic(out pszHelpFile: WideString; varChild: OleVariant; out pidTopic: Integer): HResult; stdcall;
    function Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: WideString): HResult; stdcall;
    function Get_accFocus(out pvarChild: OleVariant): HResult; stdcall;
    function Get_accSelection(out pvarChildren: OleVariant): HResult; stdcall;
    function Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: WideString): HResult; stdcall;
    function accSelect(flagsSelect: Integer; varChild: OleVariant): HResult; stdcall;
    function accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer;
      out pcyHeight: Integer; varChild: OleVariant): HResult; stdcall;
    function accNavigate(navDir: Integer; varStart: OleVariant; out pvarEndUpAt: OleVariant): HResult; stdcall;
    function accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult; stdcall;
    function accDoDefaultAction(varChild: OleVariant): HResult; stdcall;
    function Set_accName(varChild: OleVariant; const pszName: WideString): HResult; stdcall;
    function Set_accValue(varChild: OleVariant; const pszValue: WideString): HResult; stdcall;
  end;

  { IdxRawElementProviderSimple }

  IdxRawElementProviderSimple = interface(IUnknown)
    [SID_IdxRawElementProviderSimple]
    function Get_ProviderOptions(out pRetVal: TOleEnum): HResult; stdcall;
    function GetPatternProvider(patternId: Integer; out pRetVal: IUnknown): HResult; stdcall;
    function GetPropertyValue(propertyId: Integer; out pRetVal: OleVariant): HResult; stdcall;
    function Get_HostRawElementProvider(out pRetVal: IdxRawElementProviderSimple): HResult; stdcall;
  end;

  { IdxAccessibleEx }

  IdxAccessibleEx = interface(IUnknown)
    [SID_IdxAccessibleEx]
    function GetObjectForChild(idChild: Integer; out pRetVal: IdxAccessibleEx): HResult; stdcall;
    function GetIAccessiblePair(out ppAcc: IcxAccessible; out pidChild: Integer): HResult; stdcall;
    function GetRuntimeId(out pRetVal: PSafeArray): HResult; stdcall;
    function ConvertReturnedElement(const pIn: IdxRawElementProviderSimple; out ppRetValOut: IdxAccessibleEx): HResult; stdcall;
  end;

  { IcxAccessibilityHelper }

  IcxAccessibilityHelper = interface
  ['{D4890860-09B2-4648-BD9E-DFFBD140E5F1}']
    function GetHelper: TcxAccessibilityHelper;
    procedure OwnerObjectDestroyed;
  end;

  { IdxRangeValueProvider }

  IdxRangeValueProvider = interface(IUnknown)
    [SID_IdxRangeValueProvider]
    function SetValue(val: Double): HResult; stdcall;
    function Get_Value(out pRetVal: Double): HResult; stdcall;
    function Get_IsReadOnly(out pRetVal: Integer): HResult; stdcall;
    function Get_Maximum(out pRetVal: Double): HResult; stdcall;
    function Get_Minimum(out pRetVal: Double): HResult; stdcall;
    function Get_LargeChange(out pRetVal: Double): HResult; stdcall;
    function Get_SmallChange(out pRetVal: Double): HResult; stdcall;
  end;

  { IdxExpandCollapseProvider }

  IdxExpandCollapseProvider = interface(IUnknown)
    [SID_IdxExpandCollapseProvider]
    function Expand: HResult; stdcall;
    function Collapse: HResult; stdcall;
    function Get_ExpandCollapseState(out pRetVal: TOleEnum): HResult; stdcall;
  end;

  { IdxScrollItemProvider }

  IdxScrollItemProvider = interface(IUnknown)
    [SID_IdxScrollItemProvider]
    function ScrollIntoView: HResult; stdcall;
  end;

  { IdxTextRangeProvider }

  IdxTextRangeProvider = interface(IUnknown)
    [SID_IdxTextRangeProvider]
    function Clone(out pRetVal: IdxTextRangeProvider): HResult; stdcall;
    function Compare(const range: IdxTextRangeProvider; out pRetVal: Integer): HResult; stdcall;
    function CompareEndpoints(endpoint: TOleEnum; const targetRange: IdxTextRangeProvider;
      targetEndpoint: TOleEnum; out pRetVal: SYSINT): HResult; stdcall;
    function ExpandToEnclosingUnit(unit_: TOleEnum): HResult; stdcall;
    function FindAttribute(attributeId: SYSINT; val: OleVariant;
      backward: Integer; out pRetVal: IdxTextRangeProvider): HResult; stdcall;
    function FindText(const text: WideString; backward: Integer;
      ignoreCase: Integer; out pRetVal: IdxTextRangeProvider): HResult; stdcall;
    function GetAttributeValue(attributeId: SYSINT; out pRetVal: OleVariant): HResult; stdcall;
    function GetBoundingRectangles(out pRetVal: PSafeArray): HResult; stdcall;
    function GetEnclosingElement(out pRetVal: IdxRawElementProviderSimple): HResult; stdcall;
    function GetText(maxLength: SYSINT; out pRetVal: WideString): HResult; stdcall;
    function Move(unit_: TOleEnum; count: SYSINT; out pRetVal: SYSINT): HResult; stdcall;
    function MoveEndpointByUnit(endpoint: TOleEnum; unit_: TOleEnum; count: SYSINT; out pRetVal: SYSINT): HResult; stdcall;
    function MoveEndpointByRange(endpoint: TOleEnum;
      const targetRange: IdxTextRangeProvider; targetEndpoint: TOleEnum): HResult; stdcall;
    function Select: HResult; stdcall;
    function AddToSelection: HResult; stdcall;
    function RemoveFromSelection: HResult; stdcall;
    function ScrollIntoView(alignToTop: Integer): HResult; stdcall;
    function GetChildren(out pRetVal: PSafeArray): HResult; stdcall;
  end;

  { IdxTextProvider }

  TdxUiaPoint = record
    x: Double;
    y: Double;
  end;

  IdxTextProvider = interface(IUnknown)
    [SID_IdxTextProvider]
    function GetSelection(out pRetVal: PSafeArray): HResult; stdcall;
    function GetVisibleRanges(out pRetVal: PSafeArray): HResult; stdcall;
    function RangeFromChild(const childElement: IdxRawElementProviderSimple; out pRetVal: IdxTextRangeProvider): HResult; stdcall;
    function RangeFromPoint(point: TdxUiaPoint; out pRetVal: IdxTextRangeProvider): HResult; stdcall;
    function Get_DocumentRange(out pRetVal: IdxTextRangeProvider): HResult; stdcall;
    function Get_SupportedTextSelection(out pRetVal: TOleEnum): HResult; stdcall;
  end;

  { IdxTextProvider2 }

  IdxTextProvider2 = interface(IUnknown)
    [SID_IdxTextProvider2]
    function RangeFromAnnotation(const annotationElement: IdxRawElementProviderSimple;
      out pRetVal: IdxTextRangeProvider): HResult; stdcall;
    function GetCaretRange(out isActive: Integer; out pRetVal: IdxTextRangeProvider): HResult; stdcall;
  end;

  { ISelectionProvider }

  IdxSelectionProvider = interface(IUnknown)
    [SID_IdxSelectionProvider]
    function GetSelection(out pRetVal: PSafeArray): HResult; stdcall;
    function Get_CanSelectMultiple(out pRetVal: Integer): HResult; stdcall;
    function Get_IsSelectionRequired(out pRetVal: Integer): HResult; stdcall;
  end;

  { IdxSelectionItemProvider }

  IdxSelectionItemProvider = interface(IUnknown)
    [SID_IdxSelectionItemProvider]
    function Select: HResult; stdcall;
    function AddToSelection: HResult; stdcall;
    function RemoveFromSelection: HResult; stdcall;
    function Get_IsSelected(out pRetVal: Integer): HResult; stdcall;
    function Get_SelectionContainer(out pRetVal: IdxRawElementProviderSimple): HResult; stdcall;
  end;

  { IdxToggleProvider }

  IdxToggleProvider = interface(IUnknown)
    [SID_IdxToggleProvider]
    function Toggle: HResult; stdcall;
    function Get_ToggleState(out pRetVal: TOleEnum): HResult; stdcall;
  end;

  { TdxChildAccessibleExPart }

  TdxChildAccessibleExPart = class(TInterfacedObject, IdxAccessibleEx, IdxRawElementProviderSimple)
  strict private
    FIAccessibilityHelper: IcxAccessibilityHelper;
    FIndex: Integer;

    // IdxAccessibleEx
    function GetObjectForChild(idChild: Integer; out pRetVal: IdxAccessibleEx): HResult; stdcall;
    function GetIAccessiblePair(out ppAcc: IcxAccessible; out pidChild: Integer): HResult; stdcall;
    function GetRuntimeId(out pRetVal: PSafeArray): HResult; stdcall;
    function ConvertReturnedElement(const pIn: IdxRawElementProviderSimple; out ppRetValOut: IdxAccessibleEx): HResult; stdcall;

    // IdxRawElementProviderSimple
    function Get_ProviderOptions(out pRetVal: TOleEnum): HResult; stdcall;
    function GetPatternProvider(patternId: Integer; out pRetVal: IUnknown): HResult; stdcall;
    function GetPropertyValue(propertyId: Integer; out pRetVal: OleVariant): HResult; stdcall;
    function Get_HostRawElementProvider(out pRetVal: IdxRawElementProviderSimple): HResult; stdcall;
  public
    constructor Create(AOwner: IcxAccessibilityHelper; AIndex: Integer); virtual;
  end;

  { TcxAccessibilityHelper }

  TcxAccessibilityHelper = class(TInterfacedObject, IDispatch, IOleWindow, IcxAccessible, IcxAccessibilityHelper,
    IServiceProvider, IdxAccessibleEx, IdxRawElementProviderSimple)
  private
    FIsOwnerObjectLive: Boolean;
    FInternalChild: IcxAccessible;
    FLock: Boolean;

    // IDispatch
    function GetIDsOfNames(const IID: TGUID; Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
    function GetTypeInfoCount(out Count: Integer): HResult; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
    // IOleWindow
    function ContextSensitiveHelp(fEnterMode: BOOL): HResult; stdcall;
    function GetWindow(out wnd: HWnd): HResult; stdcall;
    // IcxAccessible
    function accDoDefaultAction(varChild: OleVariant): HResult; stdcall;
    function accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult; stdcall;
    function accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer;
      out pcyHeight: Integer; varChild: OleVariant): HResult; stdcall;
    function accNavigate(navDir: Integer; varStart: OleVariant; out pvarEndUpAt: OleVariant): HResult; stdcall;
    function accSelect(flagsSelect: Integer; varChild: OleVariant): HResult; stdcall;
    function Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult; stdcall;
    function Get_accChildCount(out pcountChildren: Integer): HResult; stdcall;
    function Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: WideString): HResult; stdcall;
    function Get_accDescription(varChild: OleVariant; out pszDescription: WideString): HResult; stdcall;
    function Get_accFocus(out pvarChild: OleVariant): HResult; stdcall;
    function Get_accHelp(varChild: OleVariant; out pszHelp: WideString): HResult; stdcall;
    function Get_accHelpTopic(out pszHelpFile: WideString; varChild: OleVariant; out pidTopic: Integer): HResult; stdcall;
    function Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: WideString): HResult; stdcall;
    function Get_accName(varChild: OleVariant; out pszName: WideString): HResult; stdcall;
    function Get_accParent(out ppdispParent: IDispatch): HResult; stdcall;
    function Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult; stdcall;
    function Get_accSelection(out pvarChildren: OleVariant): HResult; stdcall;
    function Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult; stdcall;
    function Get_accValue(varChild: OleVariant; out pszValue: WideString): HResult; stdcall;
    function Set_accName(varChild: OleVariant; const pszName: WideString): HResult; stdcall;
    function Set_accValue(varChild: OleVariant; const pszValue: WideString): HResult; stdcall;

    // IServiceProvider
    function QueryService(const rsid, iid: TGuid; out Obj): HResult; stdcall;

    // IdxAccessibleEx
    function GetObjectForChild(idChild: Integer; out pRetVal: IdxAccessibleEx): HResult; stdcall;
    function GetIAccessiblePair(out ppAcc: IcxAccessible; out pidChild: Integer): HResult; stdcall;
    function GetRuntimeId(out pRetVal: PSafeArray): HResult; stdcall;
    function ConvertReturnedElement(const pIn: IdxRawElementProviderSimple; out ppRetValOut: IdxAccessibleEx): HResult; stdcall;

    // IdxRawElementProviderSimple
    function Get_ProviderOptions(out pRetVal: TOleEnum): HResult; stdcall;
    function GetPatternProvider(patternId: Integer; out pRetVal: IUnknown): HResult; stdcall;
    function GetPropertyValue(propertyId: Integer; out pRetVal: OleVariant): HResult; stdcall;
    function Get_HostRawElementProvider(out pRetVal: IdxRawElementProviderSimple): HResult; stdcall;

    function CheckIsOwnerObjectLive(out AErrorCode: HResult): Boolean;
    procedure CheckSimpleChildElementToBeReturned(var AVarChild: OleVariant);
    procedure CheckStringToBeReturned(const AStr: WideString; out AResult: HResult);

    function GetSimpleChildElementID(AChildID: OleVariant;
      out ASimpleChildElementID: TcxAccessibleSimpleChildElementID; out AErrorCode: HResult): Boolean;
    function GetVisible: Boolean;
  protected
    FOwnerObject: TObject;

    procedure SetInternalChild(AHandle: HWND);

    // IcxAccessibilityHelper
    function GetHelper: TcxAccessibilityHelper;
    procedure OwnerObjectDestroyed; virtual;

    function ChildIsSimpleElement(AIndex: Integer): Boolean; virtual;
    procedure DoDefaultAction(AChildID: TcxAccessibleSimpleChildElementID); virtual;
    procedure DoSelect(AFlags: Integer; AChildID: TcxAccessibleSimpleChildElementID); virtual;
    function Focused(out AIsChildFocused: Boolean; out AFocusedChildIndex: Integer): Boolean; virtual;
    function GetChild(AIndex: Integer): TcxAccessibilityHelper; virtual;
    function GetChildCount: Integer; virtual;
    function GetChildIndex(AChild: TcxAccessibilityHelper): Integer; virtual;
    function GetDefaultActionDescription(AChildID: TcxAccessibleSimpleChildElementID): string; virtual;
    function GetDescription(AChildID: TcxAccessibleSimpleChildElementID): string; virtual;
    function GetHitTest(AScreenX, AScreenY: Integer; out AChildIndex: Integer): TcxAccessibleObjectHitTest; overload; virtual;
    function GetHitTest(AScreenX, AScreenY: Integer; out AIAccessibilityHelper: IcxAccessibilityHelper): Boolean; overload; virtual;
    procedure GetKeyboardAccessParameters(AChildID: TcxAccessibleSimpleChildElementID;
      out AShortCut: TShortCut; out ACaptionWithAccelChars: string); virtual;
    function GetName(AChildID: TcxAccessibleSimpleChildElementID): string; virtual;
    function GetOwnerObjectWindow: HWND; virtual;
    function GetParent: TcxAccessibilityHelper; virtual;
    function GetRole(AChildID: TcxAccessibleSimpleChildElementID): Integer; virtual;
    function GetSelectable: Boolean; virtual;
    function GetState(AChildID: TcxAccessibleSimpleChildElementID): Integer; virtual;
    function GetSupportedProperties(AChildID: TcxAccessibleSimpleChildElementID): TcxAccessibleObjectProperties; virtual;
    function GetValue(AChildID: TcxAccessibleSimpleChildElementID): string; virtual;
    function NavigateToChild(ACurrentChildIndex: Integer; ADirection: TcxAccessibilityNavigationDirection): Integer; virtual; // andPrev, andNext must prevent looping
    procedure SetValue(AChildID: TcxAccessibleSimpleChildElementID; const Value: string); virtual;

    function IsExtended: Boolean; virtual;
    function IsSupportedPattern(APatternID: Integer; out AProvider: IUnknown; AChildID: TcxAccessibleSimpleChildElementID = 0): Boolean; virtual;
    function GetLocalId(AChildID: TcxAccessibleSimpleChildElementID = 0): Integer; virtual;
    function GetRawElementPropertyValue(propertyId: Integer; AChildID: TcxAccessibleSimpleChildElementID = 0): OleVariant; virtual;

    function GetRootHelper: TcxAccessibilityHelper;

    property Lock: Boolean read FLock;
  public {for friend classes}
    function GetNextSelectableChildIndex(AStartIndex: Integer; AGoForward: Boolean): Integer;
    function GetScreenBounds(AChildID: TcxAccessibleSimpleChildElementID): TRect; virtual;
  public
    constructor Create(AOwnerObject: TObject); virtual;
    destructor Destroy; override;

    property Childs[AIndex: Integer]: TcxAccessibilityHelper read GetChild;
    property ChildCount: Integer read GetChildCount;
    property IsOwnerObjectLive: Boolean read FIsOwnerObjectLive;
    property OwnerObject: TObject read FOwnerObject;
    property OwnerObjectWindow: HWND read GetOwnerObjectWindow;
    property Parent: TcxAccessibilityHelper read GetParent;
    property Selectable: Boolean read GetSelectable;
    property States[AChildID: TcxAccessibleSimpleChildElementID]: Integer read GetState;
    property Role[AChildID: TcxAccessibleSimpleChildElementID]: Integer read GetRole;
    property Visible: Boolean read GetVisible;
  end;

  { TdxRangeValueProvider }

  TdxRangeValueProvider = class(TcxIUnknownObject, IdxRangeValueProvider)
  strict private
    function InternalSetValue(val: Double): HResult; stdcall;

    // IdxRangeValueProvider
    function Get_IsReadOnly(out pRetVal: Integer): HResult; stdcall;
    function Get_LargeChange(out pRetVal: Double): HResult; stdcall;
    function Get_Maximum(out pRetVal: Double): HResult; stdcall;
    function Get_Minimum(out pRetVal: Double): HResult; stdcall;
    function Get_SmallChange(out pRetVal: Double): HResult; stdcall;
    function Get_Value(out pRetVal: Double): HResult; stdcall;
    function IdxRangeValueProvider.SetValue = InternalSetValue;
  protected
    function GetIsReadOnly: Boolean; virtual;

    function GetLargeChange: Double; virtual;
    function GetMaximum: Double; virtual;
    function GetMinimum: Double; virtual;
    function GetSmallChange: Double; virtual;
    function GetValue: Double; virtual;
    procedure SetValue(AValue: Double); virtual;
  end;

  { TdxExpandCollapseProvider }

  TdxExpandCollapseProvider = class(TcxIUnknownObject, IdxExpandCollapseProvider)
  strict private
    function InternalCollapse: HResult; stdcall;
    function InternalExpand: HResult; stdcall;

    // IdxExpandCollapseProvider
    function IdxExpandCollapseProvider.Expand = InternalExpand;
    function IdxExpandCollapseProvider.Collapse = InternalCollapse;
    function Get_ExpandCollapseState(out pRetVal: TOleEnum): HResult; stdcall;
  protected
    procedure Collapse; virtual;
    procedure Expand; virtual;
    function GetExpandCollapseState: Integer; virtual;
  end;

  { TdxScrollItemProvider }

  TdxScrollItemProvider = class(TcxIUnknownObject, IdxScrollItemProvider)
  strict private
    // IdxScrollItemProvider
    function ScrollIntoView: HResult; stdcall;
  protected
    procedure DoScrollIntoView; virtual;
  end;

  { TdxSelectionItemProvider }

  TdxSelectionItemProvider = class(TcxIUnknownObject, IdxSelectionItemProvider)
  strict private
    function InternalAddToSelection: HResult; stdcall;
    function InternalRemoveFromSelection: HResult; stdcall;

    // IdxSelectionItemProvider
    function Select: HResult; stdcall;
    function IdxSelectionItemProvider.AddToSelection = InternalAddToSelection;
    function IdxSelectionItemProvider.RemoveFromSelection = InternalRemoveFromSelection;
    function Get_IsSelected(out pRetVal: Integer): HResult; stdcall;
    function Get_SelectionContainer(out pRetVal: IdxRawElementProviderSimple): HResult; stdcall;
  protected
    procedure DoSelect; virtual;
    procedure AddToSelection; virtual;
    function GetSelectionContainer: IdxRawElementProviderSimple; virtual;
    function IsSelected: Boolean; virtual;
    procedure RemoveFromSelection; virtual;
  end;

  { TdxToggleProvider }

  TdxToggleProvider = class(TcxIUnknownObject, IdxToggleProvider)
  strict private
    // IdxToggleProvider
    function Toggle: HResult; stdcall;
    function Get_ToggleState(out pRetVal: TOleEnum): HResult; stdcall;
  protected
    procedure DoToggle; virtual;
    function GetToggleState: Integer; virtual;
  end;


  TcxAccessibilityHelperClass = class of TcxAccessibilityHelper;

const
  cxROLE_SYSTEM_TITLEBAR = $1;
  cxROLE_SYSTEM_MENUBAR = $2;
  cxROLE_SYSTEM_SCROLLBAR = $3;
  cxROLE_SYSTEM_GRIP = $4;
  cxROLE_SYSTEM_SOUND = $5;
  cxROLE_SYSTEM_CURSOR = $6;
  cxROLE_SYSTEM_CARET = $7;
  cxROLE_SYSTEM_ALERT = $8;
  cxROLE_SYSTEM_WINDOW = $9;
  cxROLE_SYSTEM_CLIENT = $a;
  cxROLE_SYSTEM_MENUPOPUP = $b;
  cxROLE_SYSTEM_MENUITEM = $c;
  cxROLE_SYSTEM_TOOLTIP = $d;
  cxROLE_SYSTEM_APPLICATION = $e;
  cxROLE_SYSTEM_DOCUMENT = $f;
  cxROLE_SYSTEM_PANE = $10;
  cxROLE_SYSTEM_CHART = $11;
  cxROLE_SYSTEM_DIALOG = $12;
  cxROLE_SYSTEM_BORDER = $13;
  cxROLE_SYSTEM_GROUPING = $14;
  cxROLE_SYSTEM_SEPARATOR = $15;
  cxROLE_SYSTEM_TOOLBAR = $16;
  cxROLE_SYSTEM_STATUSBAR = $17;
  cxROLE_SYSTEM_TABLE = $18;
  cxROLE_SYSTEM_COLUMNHEADER = $19;
  cxROLE_SYSTEM_ROWHEADER = $1a;
  cxROLE_SYSTEM_COLUMN = $1b;
  cxROLE_SYSTEM_ROW = $1c;
  cxROLE_SYSTEM_CELL = $1d;
  cxROLE_SYSTEM_LINK = $1e;
  cxROLE_SYSTEM_HELPBALLOON = $1f;
  cxROLE_SYSTEM_CHARACTER = $20;
  cxROLE_SYSTEM_LIST = $21;
  cxROLE_SYSTEM_LISTITEM = $22;
  cxROLE_SYSTEM_OUTLINE = $23;
  cxROLE_SYSTEM_OUTLINEITEM = $24;
  cxROLE_SYSTEM_PAGETAB = $25;
  cxROLE_SYSTEM_PROPERTYPAGE = $26;
  cxROLE_SYSTEM_INDICATOR = $27;
  cxROLE_SYSTEM_GRAPHIC = $28;
  cxROLE_SYSTEM_STATICTEXT = $29;
  cxROLE_SYSTEM_TEXT = $2a;
  cxROLE_SYSTEM_PUSHBUTTON = $2b;
  cxROLE_SYSTEM_CHECKBUTTON = $2c;
  cxROLE_SYSTEM_RADIOBUTTON = $2d;
  cxROLE_SYSTEM_COMBOBOX = $2e;
  cxROLE_SYSTEM_DROPLIST = $2f;
  cxROLE_SYSTEM_PROGRESSBAR = $30;
  cxROLE_SYSTEM_DIAL = $31;
  cxROLE_SYSTEM_HOTKEYFIELD = $32;
  cxROLE_SYSTEM_SLIDER = $33;
  cxROLE_SYSTEM_SPINBUTTON = $34;
  cxROLE_SYSTEM_DIAGRAM = $35;
  cxROLE_SYSTEM_ANIMATION = $36;
  cxROLE_SYSTEM_EQUATION = $37;
  cxROLE_SYSTEM_BUTTONDROPDOWN = $38;
  cxROLE_SYSTEM_BUTTONMENU = $39;
  cxROLE_SYSTEM_BUTTONDROPDOWNGRID = $3a;
  cxROLE_SYSTEM_WHITESPACE = $3b;
  cxROLE_SYSTEM_PAGETABLIST = $3c;
  cxROLE_SYSTEM_CLOCK = $3d;
  cxROLE_SYSTEM_SPLITBUTTON = $3e;
  cxROLE_SYSTEM_IPADDRESS = $3f;
  cxROLE_SYSTEM_OUTLINEBUTTON = $40;

  cxSTATE_SYSTEM_NORMAL = $0;
  cxSTATE_SYSTEM_UNAVAILABLE = $1;
  cxSTATE_SYSTEM_SELECTED = $2;
  cxSTATE_SYSTEM_FOCUSED = $4;
  cxSTATE_SYSTEM_PRESSED = $8;
  cxSTATE_SYSTEM_CHECKED = $10;
  cxSTATE_SYSTEM_MIXED = $20;
  cxSTATE_SYSTEM_INDETERMINATE = cxSTATE_SYSTEM_MIXED;
  cxSTATE_SYSTEM_READONLY = $40;
  cxSTATE_SYSTEM_HOTTRACKED = $80;
  cxSTATE_SYSTEM_DEFAULT = $100;
  cxSTATE_SYSTEM_EXPANDED = $200;
  cxSTATE_SYSTEM_COLLAPSED = $400;
  cxSTATE_SYSTEM_BUSY = $800;
  cxSTATE_SYSTEM_FLOATING = $1000;
  cxSTATE_SYSTEM_MARQUEED = $2000;
  cxSTATE_SYSTEM_ANIMATED = $4000;
  cxSTATE_SYSTEM_INVISIBLE = $8000;
  cxSTATE_SYSTEM_OFFSCREEN = $10000;
  cxSTATE_SYSTEM_SIZEABLE = $20000;
  cxSTATE_SYSTEM_MOVEABLE = $40000;
  cxSTATE_SYSTEM_SELFVOICING = $80000;
  cxSTATE_SYSTEM_FOCUSABLE = $100000;
  cxSTATE_SYSTEM_SELECTABLE = $200000;
  cxSTATE_SYSTEM_LINKED = $400000;
  cxSTATE_SYSTEM_TRAVERSED = $800000;
  cxSTATE_SYSTEM_MULTISELECTABLE = $1000000;
  cxSTATE_SYSTEM_EXTSELECTABLE = $2000000;
  cxSTATE_SYSTEM_ALERT_LOW = $4000000;
  cxSTATE_SYSTEM_ALERT_MEDIUM = $8000000;
  cxSTATE_SYSTEM_ALERT_HIGH = $10000000;
  cxSTATE_SYSTEM_PROTECTED = $20000000;
  cxSTATE_SYSTEM_VALID = $7fffffff;
  cxSTATE_SYSTEM_HASPOPUP = $40000000;

  cxSELFLAG_TAKEFOCUS = $1 ;
  cxSELFLAG_TAKESELECTION = $2 ;
  cxSELFLAG_EXTENDSELECTION = $4 ;
  cxSELFLAG_ADDSELECTION = $8 ;
  cxSELFLAG_REMOVESELECTION = $10 ;
  cxSELFLAG_VALID = $1f ;

  dxUIA_InvokePatternId = 10000;
  dxUIA_SelectionPatternId = 10001;
  dxUIA_ValuePatternId = 10002;
  dxUIA_RangeValuePatternId = 10003;
  dxUIA_ExpandCollapsePatternId = 10005;
  dxUIA_GridPatternId = 10006;
  dxUIA_GridItemPatternId = 10007;
  dxUIA_SelectionItemPatternId = 10010;
  dxUIA_TablePatternId = 10012;
  dxUIA_TextPatternID = 10014;
  dxUIA_TogglePatternId = 10015;
  dxUIA_ScrollItemPatternId = 10017;
  dxUIA_TextPattern2Id = 10024;

  dxUIA_NamePropertyId = 30005;
  dxUIA_AutomationIdPropertyId = 30011;
  dxUIA_ClassNamePropertyId = 30012;
  dxUIA_ControlTypePropertyId = 30003;
  dxUIA_IsTogglePatternAvailablePropertyId = 30041;
  dxUIA_ToggleToggleStatePropertyId = 30086;
  UIA_ExpandCollapseExpandCollapseStatePropertyId = 30070;

  dxUIA_IsControlElementPropertyId = 30016;
  dxUIA_IsContentElementPropertyId = 30017;
  dxUIA_IsEnabledPropertyId = 30010;
  dxUIA_IsRequiredForFormPropertyId = 30025;

function WMGetObjectResultFromIAccessibilityHelper(
  const AWMGetObjectMessage: TMessage; AIHelper: IcxAccessibilityHelper): LRESULT;

function CanReturnAccessibleObject(const AWMGetObjectMessage: TMessage): Boolean;
function IsAccessibilitySupported: Boolean;

procedure cxAccessibilityHelperOwnerObjectDestroyed(var AIHelper);

implementation

uses
  Math, Menus, SysUtils, cxControls, cxGeometry;

const
  dxThisUnitName = 'cxAccessibility';

const
  NAVDIR_UP = $1;
  NAVDIR_DOWN = $2;
  NAVDIR_LEFT = $3;
  NAVDIR_RIGHT = $4;
  NAVDIR_NEXT = $5;
  NAVDIR_PREVIOUS = $6;
  NAVDIR_FIRSTCHILD = $7;
  NAVDIR_LASTCHILD = $8;

  CO_E_OBJECTNOTCONNECTED = DISP_E_MEMBERNOTFOUND; // TODO

  OleaccLibraryName = 'oleacc.dll';

  UiaAppendRuntimeId = 3;

var
  FcxAccessibleObjectFromWindow: function(hwnd: THandle; dwId: DWORD; const riid: TGUID; out ppvObject): HRESULT; stdcall = nil;
  FcxLResultFromObject: function(const riid: TGUID; wParam: WPARAM; punk: IUnknown): LRESULT; stdcall = nil;
  FOleaccLibrary: HMODULE;

function WMGetObjectResultFromIAccessibilityHelper(const AWMGetObjectMessage: TMessage; AIHelper: IcxAccessibilityHelper): LRESULT;
begin
  if AIHelper <> nil then
    Result := FcxLResultFromObject(IID_IcxAccessible, AWMGetObjectMessage.WParam, AIHelper as IcxAccessible)
  else
    Result := E_NOINTERFACE;
end;

function CanReturnAccessibleObject(const AWMGetObjectMessage: TMessage): Boolean;
begin
  Result := IsAccessibilitySupported;
end;

function IsAccessibilitySupported: Boolean;
begin
  Result := Assigned(FcxLResultFromObject);
end;

function cxGetAccessibleObjectFromWindow(hwnd: THandle; dwId: DWORD;
  const riid: TGUID; out ppvObject): HRESULT;
begin
  Result := FcxAccessibleObjectFromWindow(hwnd, dwId, riid, ppvObject);
end;

procedure cxAccessibilityHelperOwnerObjectDestroyed(var AIHelper);
var
  AIHelperInterface: IInterface absolute AIHelper;
  AIAccessibilityHelper: IcxAccessibilityHelper;
begin
  if Supports(AIHelperInterface, IcxAccessibilityHelper, AIAccessibilityHelper) then
  begin
    AIAccessibilityHelper.OwnerObjectDestroyed;
    AIHelperInterface := nil;
  end;
end;

{ TdxChildAccessibleExPart }

constructor TdxChildAccessibleExPart.Create(AOwner: IcxAccessibilityHelper; AIndex: Integer);
begin
  FIAccessibilityHelper := AOwner;
  FIndex := AIndex;
end;

// IdxAccessibleEx
function TdxChildAccessibleExPart.GetObjectForChild(idChild: Integer; out pRetVal: IdxAccessibleEx): HResult;
begin
  pRetVal := nil;
  Result := S_OK;
end;

function TdxChildAccessibleExPart.GetIAccessiblePair(out ppAcc: IcxAccessible; out pidChild: Integer): HResult;
begin
  pidChild := FIndex;
  Result := FIAccessibilityHelper.QueryInterface(IID_IcxAccessible, ppAcc);
end;

function TdxChildAccessibleExPart.GetRuntimeId(out pRetVal: PSafeArray): HResult;
begin
  Result := S_OK;
end;

function TdxChildAccessibleExPart.ConvertReturnedElement(const pIn: IdxRawElementProviderSimple; out ppRetValOut: IdxAccessibleEx): HResult;
begin
  ppRetValOut := IdxAccessibleEx(Self);
  Result := S_OK;
end;

function TdxChildAccessibleExPart.Get_ProviderOptions(out pRetVal: TOleEnum): HResult;
begin
  Result := S_OK;
end;

function TdxChildAccessibleExPart.GetPatternProvider(patternId: Integer; out pRetVal: IUnknown): HResult;
begin
  Result := S_FALSE;
  pRetVal := nil;
  if FIAccessibilityHelper.GetHelper.IsOwnerObjectLive and
    FIAccessibilityHelper.GetHelper.IsSupportedPattern(patternId, pRetVal, FIndex) then
      Result := S_OK;
end;

function TdxChildAccessibleExPart.GetPropertyValue(propertyId: Integer; out pRetVal: OleVariant): HResult;
begin
  pRetVal := FIAccessibilityHelper.GetHelper.GetRawElementPropertyValue(propertyId, FIndex);
  Result := S_OK;
end;

function TdxChildAccessibleExPart.Get_HostRawElementProvider(out pRetVal: IdxRawElementProviderSimple): HResult;
begin
  Result := S_OK;
end;

{ TcxAccessibilityHelper }

constructor TcxAccessibilityHelper.Create(AOwnerObject: TObject);
begin
  inherited Create;
  FIsOwnerObjectLive := True;
  FOwnerObject := AOwnerObject;
end;

destructor TcxAccessibilityHelper.Destroy;
begin
  FInternalChild := nil;
  inherited;
end;

function TcxAccessibilityHelper.GetNextSelectableChildIndex(AStartIndex: Integer; AGoForward: Boolean): Integer;
var
  ACount, AStep, I: Integer;
begin
  Result := -1;

  ACount := ChildCount;
  if AStartIndex < 0 then
    if AGoForward then
      AStartIndex := -1
    else
      AStartIndex := ACount
  else
    if AStartIndex >= ACount then
      raise EdxException.Create('');
  I := AStartIndex;

  if AGoForward then
    AStep := 1
  else
    AStep := -1;

  repeat
    Inc(I, AStep);
    if (I < 0) or (I = ACount) then
      Break;
    if Childs[I].Selectable then
      Result := I;
  until Result <> -1;
end;

// IcxAccessibilityHelper
function TcxAccessibilityHelper.GetHelper: TcxAccessibilityHelper;
begin
  Result := Self;
end;

procedure TcxAccessibilityHelper.OwnerObjectDestroyed;
begin
  FIsOwnerObjectLive := False;
end;

function TcxAccessibilityHelper.ChildIsSimpleElement(AIndex: Integer): Boolean;
begin
  raise EdxException.Create('');
end;

procedure TcxAccessibilityHelper.DoDefaultAction(AChildID: TcxAccessibleSimpleChildElementID);
begin
// do nothing
end;

procedure TcxAccessibilityHelper.DoSelect(AFlags: Integer; AChildID: TcxAccessibleSimpleChildElementID);
begin
// do nothing
end;

function TcxAccessibilityHelper.Focused(out AIsChildFocused: Boolean; out AFocusedChildIndex: Integer): Boolean;
var
  I: Integer;
begin
  Result := cxSTATE_SYSTEM_FOCUSED and GetState(0) > 0;
  AFocusedChildIndex := CHILDID_SELF;
  AIsChildFocused := False;
  for I := 0 to ChildCount - 1 do
  begin
    if (not ChildIsSimpleElement(I) and GetChild(I).Focused(AIsChildFocused, AFocusedChildIndex)) or
      (ChildIsSimpleElement(I) and (cxSTATE_SYSTEM_FOCUSED and GetState(I + 1) > 0)) then
    begin
      AIsChildFocused := True;
      AFocusedChildIndex := I;
      Result := True;
      Break;
    end;
  end;
end;

function TcxAccessibilityHelper.GetChild(AIndex: Integer): TcxAccessibilityHelper;
begin
  Result := nil;
end;

function TcxAccessibilityHelper.GetChildCount: Integer;
begin
  Result := 0;
end;

function TcxAccessibilityHelper.GetChildIndex(AChild: TcxAccessibilityHelper): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to GetChildCount - 1 do
    if not ChildIsSimpleElement(I) and (GetChild(I) = AChild) then
      Result := I;
end;

function TcxAccessibilityHelper.GetDefaultActionDescription(AChildID: TcxAccessibleSimpleChildElementID): string;
begin
  Result := '';
end;

function TcxAccessibilityHelper.GetDescription(AChildID: TcxAccessibleSimpleChildElementID): string;
begin
  Result := '';
end;

function TcxAccessibilityHelper.GetHitTest(AScreenX, AScreenY: Integer;
  out AChildIndex: Integer): TcxAccessibleObjectHitTest;
var
  I: Integer;
begin
  Result := aohtNone;
  if cxRectPtIn(GetScreenBounds(cxAccessibleObjectSelfID), Point(AScreenX, AScreenY)) then
    Result := aohtSelf;
  for I := 0 to GetChildCount - 1 do
    if (not ChildIsSimpleElement(I) and cxRectPtIn(GetChild(I).GetScreenBounds(cxAccessibleObjectSelfID), Point(AScreenX, AScreenY))) or
      (ChildIsSimpleElement(I) and cxRectPtIn(GetScreenBounds(I + 1), Point(AScreenX, AScreenY))) then
    begin
      AChildIndex := I;
      Result := aohtChild;
      Break;
    end;
end;

function TcxAccessibilityHelper.GetHitTest(AScreenX, AScreenY: Integer; out AIAccessibilityHelper: IcxAccessibilityHelper): Boolean;
begin
  AIAccessibilityHelper := nil;
  Result := False;
end;

procedure TcxAccessibilityHelper.GetKeyboardAccessParameters(
  AChildID: TcxAccessibleSimpleChildElementID; out AShortCut: TShortCut;
  out ACaptionWithAccelChars: string);
begin
  AShortCut := 0;
  ACaptionWithAccelChars := '';
end;

function TcxAccessibilityHelper.GetName(AChildID: TcxAccessibleSimpleChildElementID): string;
begin
  Result := '';
end;

function TcxAccessibilityHelper.GetOwnerObjectWindow: HWND;
begin
  Result := 0;
end;

function TcxAccessibilityHelper.GetParent: TcxAccessibilityHelper;
begin
  Result := nil;
end;

function TcxAccessibilityHelper.GetRole(AChildID: TcxAccessibleSimpleChildElementID): Integer;
begin
  Result := 0;
end;

function TcxAccessibilityHelper.GetScreenBounds(
  AChildID: TcxAccessibleSimpleChildElementID): TRect;
begin
  Result := Rect(0, 0, 0, 0);
end;

function TcxAccessibilityHelper.GetSelectable: Boolean;
begin
  Result := False;
end;

function TcxAccessibilityHelper.GetState(AChildID: TcxAccessibleSimpleChildElementID): Integer;
begin
  Result := cxSTATE_SYSTEM_NORMAL;
end;

function TcxAccessibilityHelper.GetSupportedProperties(AChildID: TcxAccessibleSimpleChildElementID): TcxAccessibleObjectProperties;
begin
  Result := [];
end;

function TcxAccessibilityHelper.GetValue(AChildID: TcxAccessibleSimpleChildElementID): string;
begin
  raise EdxException.Create('');
end;

function TcxAccessibilityHelper.NavigateToChild(
  ACurrentChildIndex: Integer; ADirection: TcxAccessibilityNavigationDirection): Integer;
begin
  case ADirection of
    andUp:
      Result := Max(0, ACurrentChildIndex - 1);
    andDown:
      Result := Min(ACurrentChildIndex + 1, GetChildCount - 1);
  else
    Result := ACurrentChildIndex;
  end;
end;

procedure TcxAccessibilityHelper.SetValue(AChildID: TcxAccessibleSimpleChildElementID; const Value: string);
begin
// do nothing
end;

function TcxAccessibilityHelper.IsExtended: Boolean;
begin
  Result := False;
end;

function TcxAccessibilityHelper.IsSupportedPattern(APatternID: Integer; out AProvider: IUnknown;
  AChildID: TcxAccessibleSimpleChildElementID = 0): Boolean;
begin
  AProvider := nil;
  Result := False;
end;

function TcxAccessibilityHelper.GetLocalId(AChildID: TcxAccessibleSimpleChildElementID = 0): Integer;
begin
  Result := AChildID;
end;

function TcxAccessibilityHelper.GetRawElementPropertyValue(
  propertyId: Integer; AChildID: TcxAccessibleSimpleChildElementID = 0): OleVariant;
begin
  TVarData(Result).VType := VT_EMPTY;
  if (propertyId = dxUIA_IsContentElementPropertyId) and (AChildId = 0) and (ChildCount > 0) then
  begin
    TVarData(Result).VType := VT_BOOL;
    Result := True;
  end;
end;

function TcxAccessibilityHelper.GetRootHelper: TcxAccessibilityHelper;
var
  AParent: TcxAccessibilityHelper;
begin
  Result := Self;
  repeat
    AParent := Result.Parent;
    if AParent <> nil then
      Result := AParent;
  until (AParent = nil);
end;

// IDispatch
function TcxAccessibilityHelper.GetIDsOfNames(const IID: TGUID; Names: Pointer;
  NameCount, LocaleID: Integer; DispIDs: Pointer): HResult;
begin
  Result := E_NOTIMPL;
end;

function TcxAccessibilityHelper.GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult;
begin
  Result := E_NOTIMPL;
end;

function TcxAccessibilityHelper.GetTypeInfoCount(out Count: Integer): HResult;
begin
  Result := E_NOTIMPL;
end;

function TcxAccessibilityHelper.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult;
begin
  Result := E_NOTIMPL;
end;

// IOleWindow
function TcxAccessibilityHelper.ContextSensitiveHelp(fEnterMode: BOOL): HResult;
begin
  Result := S_OK;
end;

function TcxAccessibilityHelper.GetWindow(out wnd: HWnd): HResult;
begin
  if CheckIsOwnerObjectLive(Result) then
  begin
    wnd := GetOwnerObjectWindow;
    Result := S_OK; // TODO
  end;
end;

// IcxAccessible
function TcxAccessibilityHelper.accDoDefaultAction(varChild: OleVariant): HResult;
var
  ASimpleChildElementID: TcxAccessibleSimpleChildElementID;
begin
  if GetSimpleChildElementID(varChild, ASimpleChildElementID, Result) then
    if aopDefaultAction in GetSupportedProperties(ASimpleChildElementID) then
    begin
      DoDefaultAction(ASimpleChildElementID);
      Result := S_OK;
    end
    else
      Result := S_FALSE;
end;

function TcxAccessibilityHelper.accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult;
var
  AChildIndex: Integer;
  AIAccessibilityHelper: IcxAccessibilityHelper;
begin
  VariantInit(pvarChild);
  if CheckIsOwnerObjectLive(Result) then
    if aopLocation in GetSupportedProperties(cxAccessibleObjectSelfID) then
    begin
      if GetHitTest(xLeft, yTop, AIAccessibilityHelper) then
      begin
        pvarChild := AIAccessibilityHelper as IDispatch;
        TVarData(pvarChild).VType := VT_DISPATCH;
        Result := S_OK;
      end
      else
      begin
        case GetHitTest(xLeft, yTop, AChildIndex) of
          aohtSelf:
            begin
              TVarData(pvarChild).VType := VT_I4;
              pvarChild := CHILDID_SELF;
            end;
          aohtChild:
            begin
              TVarData(pvarChild).VType := VT_I4;
              pvarChild := AChildIndex + 1;
              if AChildIndex < GetChildCount then
                CheckSimpleChildElementToBeReturned(pvarChild);
            end;
        end;
        if TVarData(pvarChild).VType <> VT_EMPTY then
          Result := S_OK
        else
          if FInternalChild <> nil then
            Result := FInternalChild.accHitTest(xLeft, yTop, pvarChild)
          else
            Result := S_FALSE;
      end;
    end
    else
      Result := DISP_E_MEMBERNOTFOUND;
end;

function TcxAccessibilityHelper.accLocation(out pxLeft: Integer;
  out pyTop: Integer; out pcxWidth: Integer; out pcyHeight: Integer; varChild: OleVariant): HResult;
var
  ASimpleChildElementID: TcxAccessibleSimpleChildElementID;
begin
  if GetSimpleChildElementID(varChild, ASimpleChildElementID, Result) then
    if aopLocation in GetSupportedProperties(ASimpleChildElementID) then
      with GetScreenBounds(ASimpleChildElementID) do
      begin
        pxLeft := Left;
        pyTop := Top;
        pcxWidth := Right - Left;
        pcyHeight := Bottom - Top;
        Result := S_OK;
      end
    else
      Result := S_FALSE;
end;

function TcxAccessibilityHelper.accNavigate(navDir: Integer; varStart: OleVariant; out pvarEndUpAt: OleVariant): HResult;

  procedure NavigateToFirstOrLastChild;
  var
    AChildCount: Integer;
  begin
    if varStart <> CHILDID_SELF then
      Result := E_INVALIDARG
    else
      if not (aopLocation in GetSupportedProperties(cxAccessibleObjectSelfID)) then
        Result := DISP_E_MEMBERNOTFOUND
      else
      begin
        AChildCount := GetChildCount;
        if AChildCount = 0 then
          Result := S_FALSE
        else
        begin
          TVarData(pvarEndUpAt).VType := VT_I4;
          if navDir = NAVDIR_FIRSTCHILD then
            pvarEndUpAt := 1
          else
            pvarEndUpAt := AChildCount;
          Result := S_OK;
        end;
      end;
  end;

  procedure NavigateToNeighboringChildViaParent;
  var
    AParent: TcxAccessibilityHelper;
    AStartChildID: OleVariant;
  begin
    Result := S_FALSE;
    AParent := GetParent; // TODO get_accParent
    if (AParent <> nil) and AParent.CheckIsOwnerObjectLive(Result) and
      (aopLocation in AParent.GetSupportedProperties(cxAccessibleObjectSelfID)) then
    begin
      TVarData(AStartChildID).VType := VT_I4;
      AStartChildID := AParent.GetChildIndex(Self) + 1;
      if (AParent as IcxAccessible).accNavigate(navDir, AStartChildID, pvarEndUpAt) = S_OK then
        Result := S_OK;
    end;
  end;

  procedure NavigateToNeighboringChild;

    function GetNavigationDirection: TcxAccessibilityNavigationDirection;
    begin
      case navDir of
        NAVDIR_DOWN: Result := andDown;
        NAVDIR_LEFT: Result := andLeft;
        NAVDIR_NEXT: Result := andNext;
        NAVDIR_PREVIOUS: Result := andPrev;
        NAVDIR_RIGHT: Result := andRight;
      else
        Result := andUp;
      end;
    end;

  var
    AChildIndex: Integer;
  begin
    if varStart > GetChildCount then
      Result := E_INVALIDARG
    else
      if not (aopLocation in GetSupportedProperties(cxAccessibleObjectSelfID)) then
        Result := DISP_E_MEMBERNOTFOUND
      else
      begin
        AChildIndex := NavigateToChild(varStart - 1, GetNavigationDirection);
        if AChildIndex <> varStart - 1 then
        begin
          TVarData(pvarEndUpAt).VType := VT_I4;
          pvarEndUpAt := AChildIndex + 1;
          Result := S_OK;
        end
        else
          Result := S_FALSE;
      end;
  end;

begin
  VariantInit(pvarEndUpAt);
  if not CheckIsOwnerObjectLive(Result) then
    Exit;
  if (navDir = NAVDIR_FIRSTCHILD) or (navDir = NAVDIR_LASTCHILD) then
    NavigateToFirstOrLastChild
  else
    if varStart = CHILDID_SELF then
      NavigateToNeighboringChildViaParent
    else
      NavigateToNeighboringChild;
end;

function TcxAccessibilityHelper.accSelect(flagsSelect: Integer; varChild: OleVariant): HResult;
var
  ASimpleChildElementID: TcxAccessibleSimpleChildElementID;
begin
  if GetSimpleChildElementID(varChild, ASimpleChildElementID, Result) then
    if aopSelect in GetSupportedProperties(cxAccessibleObjectSelfID) then
    begin
      DoSelect(flagsSelect, ASimpleChildElementID);
      Result := S_OK;
    end
    else
      Result := S_FALSE;
end;

function TcxAccessibilityHelper.Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult;
begin
  if not CheckIsOwnerObjectLive(Result) then
    Exit;
  if (FInternalChild <> nil) and (varChild = 1) then
  begin
    ppdispChild := FInternalChild;
    Result := S_OK;
  end
  else
  begin
    if FInternalChild <> nil then
      varChild := varChild - 1;
    if (TVarData(varChild).VType = VT_EMPTY) or (varChild > GetChildCount) or (varChild < 1) then
      Result := E_INVALIDARG
    else
    begin
      if ChildIsSimpleElement(varChild - 1) then
        Result := S_FALSE
      else
      begin
        ppdispChild := GetChild(varChild - 1);
        Result := S_OK;
      end;
    end;
  end;
end;

function TcxAccessibilityHelper.Get_accChildCount(out pcountChildren: Integer): HResult;
begin
  if CheckIsOwnerObjectLive(Result) then
  begin
    pcountChildren := GetChildCount;
    if FInternalChild <> nil then
      pcountChildren :=  pcountChildren + 1;
    Result := S_OK;
  end;
end;

function TcxAccessibilityHelper.Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: WideString): HResult;
var
  ASimpleChildElementID: TcxAccessibleSimpleChildElementID;
begin
  if GetSimpleChildElementID(varChild, ASimpleChildElementID, Result) then
    if aopDefaultAction in GetSupportedProperties(ASimpleChildElementID) then
    begin
      pszDefaultAction := GetDefaultActionDescription(ASimpleChildElementID);
//      CheckStringToBeReturned(pszDefaultAction, Result);
      Result := S_OK;
    end
    else
      Result := S_FALSE;
end;

function TcxAccessibilityHelper.Get_accDescription(varChild: OleVariant; out pszDescription: WideString): HResult;
var
  ASimpleChildElementID: TcxAccessibleSimpleChildElementID;
begin
  if GetSimpleChildElementID(varChild, ASimpleChildElementID, Result) then
    if aopDescription in GetSupportedProperties(ASimpleChildElementID) then
    begin
      pszDescription := GetDescription(ASimpleChildElementID);
      CheckStringToBeReturned(pszDescription, Result);
    end
    else
      Result := S_FALSE;
end;

function TcxAccessibilityHelper.Get_accFocus(out pvarChild: OleVariant): HResult;
var
  AFocusedChildIndex: Integer;
  AIsChildFocused: Boolean;
begin
  VariantInit(pvarChild);
  if CheckIsOwnerObjectLive(Result) then
    if aopFocus in GetSupportedProperties(cxAccessibleObjectSelfID) then
    begin
      if not Focused(AIsChildFocused, AFocusedChildIndex) then
        Result := S_FALSE
      else
      begin
        TVarData(pvarChild).VType := VT_I4;
        if not AIsChildFocused then
          pvarChild := CHILDID_SELF
        else
          pvarChild := AFocusedChildIndex + 1;
        CheckSimpleChildElementToBeReturned(pvarChild);
        Result := S_OK;
      end;
    end
    else
      Result := S_FALSE;
end;

function TcxAccessibilityHelper.Get_accHelp(varChild: OleVariant; out pszHelp: WideString): HResult;
begin
  Result := S_FALSE;
end;

function TcxAccessibilityHelper.Get_accHelpTopic(out pszHelpFile: WideString;
  varChild: OleVariant; out pidTopic: Integer): HResult;
begin
  Result := S_FALSE;
end;

function TcxAccessibilityHelper.Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: WideString): HResult;
var
  ACaption: string;
  AShortCut: TShortCut;
  ASimpleChildElementID: TcxAccessibleSimpleChildElementID;
begin
  if GetSimpleChildElementID(varChild, ASimpleChildElementID, Result) then
    if aopShortcut in GetSupportedProperties(ASimpleChildElementID) then
    begin
      GetKeyboardAccessParameters(ASimpleChildElementID, AShortCut, ACaption);
      if AShortCut > 0 then
        pszKeyboardShortcut := ShortCutToText(AShortCut)
      else
        if GetHotKey(ACaption) <> '' then
          pszKeyboardShortcut := 'Alt+' + UpperCase(GetHotKey(ACaption));
      CheckStringToBeReturned(pszKeyboardShortcut, Result);
    end
    else
      Result := S_FALSE;
end;

function TcxAccessibilityHelper.Get_accName(varChild: OleVariant; out pszName: WideString): HResult;
var
  ASimpleChildElementID: TcxAccessibleSimpleChildElementID;
begin
  if GetSimpleChildElementID(varChild, ASimpleChildElementID, Result) then
  begin
    pszName := GetName(ASimpleChildElementID);
    CheckStringToBeReturned(pszName, Result);
  end;
end;

function TcxAccessibilityHelper.Get_accParent(out ppdispParent: IDispatch): HResult;
var
  AParentWnd: HWND;
begin
  if CheckIsOwnerObjectLive(Result) then
  begin
    ppdispParent := GetParent;
    if (ppdispParent = nil) and (GetOwnerObjectWindow <> 0) then
    begin
      if IsChildClassWindow(GetOwnerObjectWindow) then
        AParentWnd := Windows.GetParent(GetOwnerObjectWindow)
      else
        AParentWnd := GetDesktopWindow;
      if cxGetAccessibleObjectFromWindow(AParentWnd, OBJID_CLIENT, IID_IcxAccessible, ppdispParent) <> S_OK then
        ppdispParent := nil;
    end;
    if ppdispParent <> nil then
      Result := S_OK
    else
      Result := S_FALSE;
  end;
end;

function TcxAccessibilityHelper.Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult;
var
  ASimpleChildElementID: TcxAccessibleSimpleChildElementID;
begin
  if GetSimpleChildElementID(varChild, ASimpleChildElementID, Result) then
  begin
    TVarData(pvarRole).VType := VT_I4;
    pvarRole := GetRole(ASimpleChildElementID);
    Result := S_OK;
  end;
end;

function TcxAccessibilityHelper.Get_accSelection(out pvarChildren: OleVariant): HResult;
begin
  Result := S_FALSE;
end;

function TcxAccessibilityHelper.Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult;
var
  ASimpleChildElementID: TcxAccessibleSimpleChildElementID;
begin
  if GetSimpleChildElementID(varChild, ASimpleChildElementID, Result) then
  begin
    TVarData(pvarState).VType := VT_I4;
    pvarState := GetState(ASimpleChildElementID);
    Result := S_OK;
  end;
end;

function TcxAccessibilityHelper.Get_accValue(varChild: OleVariant; out pszValue: WideString): HResult;
var
  ASimpleChildElementID: TcxAccessibleSimpleChildElementID;
begin
  if GetSimpleChildElementID(varChild, ASimpleChildElementID, Result) then
    if aopValue in GetSupportedProperties(ASimpleChildElementID) then
    begin
      pszValue := GetValue(ASimpleChildElementID);
      Result := S_OK;
    end
    else
      Result := S_FALSE;
end;

function TcxAccessibilityHelper.Set_accName(varChild: OleVariant; const pszName: WideString): HResult;
begin
  Result := E_NOTIMPL;
end;

function TcxAccessibilityHelper.Set_accValue(varChild: OleVariant; const pszValue: WideString): HResult;
var
  ASimpleChildElementID: TcxAccessibleSimpleChildElementID;
begin
  if GetSimpleChildElementID(varChild, ASimpleChildElementID, Result) then
    if aopValue in GetSupportedProperties(ASimpleChildElementID) then
    begin
      SetValue(ASimpleChildElementID, pszValue);
      Result := S_OK;
    end
    else
      Result := S_FALSE;
end;

// IServiceProvider
function TcxAccessibilityHelper.QueryService(const rsid, iid: TGuid; out Obj): HResult;
begin
  if not Assigned(@Obj) then
    Result := E_INVALIDARG
  else
  begin
    Pointer(Obj) := nil;
    if IsExtended and IsEqualGUID(rsid, IID_IdxAccessibleEx) then
      Result := QueryInterface(iid, Obj)
    else
      Result := E_NOINTERFACE;
  end;
end;

// IdxAccessibleEx

function TcxAccessibilityHelper.GetObjectForChild(idChild: Integer; out pRetVal: IdxAccessibleEx): HResult;
begin
  if CheckIsOwnerObjectLive(Result) then
  begin
    pRetVal := nil;
    if (ChildCount > 0) and ChildIsSimpleElement(idChild - 1) then
      pRetVal := TdxChildAccessibleExPart.Create(Self, idChild);
    Result := S_OK;
  end;
end;

function TcxAccessibilityHelper.GetIAccessiblePair(out ppAcc: IcxAccessible; out pidChild: Integer): HResult;
begin
  ppAcc := IcxAccessible(Self);
  ppAcc._AddRef();
  pidChild := CHILDID_SELF;
  Result := S_OK;
end;

function TcxAccessibilityHelper.GetRuntimeId(out pRetVal: PSafeArray): HResult;
var
  rId: array[0..1] of Integer;
  psa: PSafeArray;
  I: Integer;
begin
  if not CheckIsOwnerObjectLive(Result) then
    Exit;
  rId[0] := UiaAppendRuntimeId;
  rId[1] := GetLocalId;
  psa := SafeArrayCreateVector(VT_I4, 0, 2);
  for I := 0 to 1 do
    SafeArrayPutElement(psa, I, (rId[I]));
  pRetVal := psa;
  Result := S_OK;
end;

function TcxAccessibilityHelper.ConvertReturnedElement(const pIn: IdxRawElementProviderSimple; out ppRetValOut: IdxAccessibleEx): HResult;
begin
  ppRetValOut := Self;
  Result := S_OK;
end;

// IdxRawElementProviderSimple

function TcxAccessibilityHelper.Get_ProviderOptions(out pRetVal: TOleEnum): HResult;
begin
  if CheckIsOwnerObjectLive(Result) then
    pRetVal:= dxProviderOptions_ServerSideProvider;
  Result := S_OK;
end;

function TcxAccessibilityHelper.GetPatternProvider(patternId: Integer; out pRetVal: IUnknown): HResult;
begin
  Result := S_FALSE;
  pRetVal := nil;
  if CheckIsOwnerObjectLive(Result) and IsOwnerObjectLive and IsSupportedPattern(patternId, pRetVal) then
    Result := S_OK;
end;

function TcxAccessibilityHelper.GetPropertyValue(propertyId: Integer; out pRetVal: OleVariant): HResult;
begin
  if CheckIsOwnerObjectLive(Result) then
    pRetVal := GetRawElementPropertyValue(propertyId);
  Result := S_OK;
end;

function TcxAccessibilityHelper.Get_HostRawElementProvider(out pRetVal: IdxRawElementProviderSimple): HResult;
begin
  Result := S_OK;
end;

function TcxAccessibilityHelper.CheckIsOwnerObjectLive(out AErrorCode: HResult): Boolean;
begin
  Result := FIsOwnerObjectLive;
  if not Result then
    AErrorCode := CO_E_OBJECTNOTCONNECTED;
end;

procedure TcxAccessibilityHelper.CheckSimpleChildElementToBeReturned(var AVarChild: OleVariant);
var
  AChild: TcxAccessibilityHelper;
begin
  if (AVarChild <> CHILDID_SELF) and not ChildIsSimpleElement(AVarChild - 1) then
  begin
    AChild := GetChild(AVarChild - 1);
    VariantInit(AVarChild);
    AVarChild := AChild as IDispatch;
    TVarData(AVarChild).VType := VT_DISPATCH;
  end;
end;

procedure TcxAccessibilityHelper.CheckStringToBeReturned(const AStr: WideString; out AResult: HResult);
begin
  if Length(AStr) <> 0 then
    AResult := S_OK
  else
    AResult := S_FALSE;
end;

function TcxAccessibilityHelper.GetSimpleChildElementID(AChildID: OleVariant;
  out ASimpleChildElementID: TcxAccessibleSimpleChildElementID; out AErrorCode: HResult): Boolean;
begin
  Result := CheckIsOwnerObjectLive(AErrorCode);
  if not Result then
    Exit;
  if AChildID = CHILDID_SELF then
    ASimpleChildElementID := cxAccessibleObjectSelfID
  else
    if AChildID > GetChildCount then
    begin
      AErrorCode := E_INVALIDARG;
      Result := False;
    end
    else
      ASimpleChildElementID := AChildID;
end;

procedure TcxAccessibilityHelper.SetInternalChild(AHandle: HWND);
begin
  FLock := True;
  try
    cxGetAccessibleObjectFromWindow(AHandle, OBJID_CLIENT, IID_IcxAccessible, FInternalChild);
  finally
    FLock := False;
  end;
end;

function TcxAccessibilityHelper.GetVisible: Boolean;
begin
  Result := States[cxAccessibleObjectSelfID] and cxSTATE_SYSTEM_INVISIBLE = 0;
end;

{ TdxRangeValueProvider }

function TdxRangeValueProvider.GetIsReadOnly: Boolean;
begin
  Result := False;
end;

function TdxRangeValueProvider.GetLargeChange: Double;
begin

  Result := 0;
end;

function TdxRangeValueProvider.GetMaximum: Double;
begin
  Result := 0;
end;

function TdxRangeValueProvider.GetMinimum: Double;
begin
  Result := 0;
end;

function TdxRangeValueProvider.GetSmallChange: Double;
begin
  Result := 0;
end;

function TdxRangeValueProvider.GetValue: Double;
begin
  Result := 0;
end;

procedure TdxRangeValueProvider.SetValue(AValue: Double);
begin
  // do nothing
end;

function TdxRangeValueProvider.InternalSetValue(val: Double): HResult;
begin
  SetValue(val);
  Result := S_OK;
end;

// IdxRangeValueProvider
function TdxRangeValueProvider.Get_IsReadOnly(out pRetVal: Integer): HResult;
begin
  pRetVal := Integer(GetIsReadOnly);
  Result := S_OK;
end;

function TdxRangeValueProvider.Get_LargeChange(out pRetVal: Double): HResult;
begin

  pRetVal := GetLargeChange;
  Result := S_OK;
end;

function TdxRangeValueProvider.Get_Maximum(out pRetVal: Double): HResult;
begin
  pRetVal := GetMaximum;
  Result := S_OK;
end;

function TdxRangeValueProvider.Get_Minimum(out pRetVal: Double): HResult;
begin
  pRetVal := GetMinimum;
  Result := S_OK;
end;

function TdxRangeValueProvider.Get_SmallChange(out pRetVal: Double): HResult;
begin
  pRetVal := GetSmallChange;
  Result := S_OK;
end;

function TdxRangeValueProvider.Get_Value(out pRetVal: Double): HResult;
begin
  pRetVal := GetValue;
  Result := S_OK;
end;

{ TdxExpandCollapseProvider }

procedure TdxExpandCollapseProvider.Collapse;
begin
  // do nothing
end;

procedure TdxExpandCollapseProvider.Expand;
begin
  // do nothing
end;

function TdxExpandCollapseProvider.GetExpandCollapseState: Integer;
begin
  Result := dxExpandCollapseState_Collapsed;
end;

function TdxExpandCollapseProvider.InternalCollapse: HResult;
begin
  Collapse;
  Result := S_OK;
end;

function TdxExpandCollapseProvider.InternalExpand: HResult;
begin
  Expand;
  Result := S_OK;
end;

function TdxExpandCollapseProvider.Get_ExpandCollapseState(out pRetVal: TOleEnum): HResult;
begin
  pRetVal := GetExpandCollapseState;
  Result := S_OK;
end;

{ TdxScrollItemProvider }

procedure TdxScrollItemProvider.DoScrollIntoView;
begin
  // do nothing
end;

function TdxScrollItemProvider.ScrollIntoView: HResult;
begin
  DoScrollIntoView;
  Result := S_OK
end;

{ TdxSelectionItemProvider }

procedure TdxSelectionItemProvider.DoSelect;
begin
  // do nothing;
end;

procedure TdxSelectionItemProvider.AddToSelection;
begin
  // do nothing
end;

function TdxSelectionItemProvider.GetSelectionContainer: IdxRawElementProviderSimple;
begin
  Result := nil
end;

function TdxSelectionItemProvider.IsSelected: Boolean;
begin
  Result := False;
end;

procedure TdxSelectionItemProvider.RemoveFromSelection;
begin
  // do nothing
end;

function TdxSelectionItemProvider.InternalAddToSelection: HResult;
begin
  AddToSelection;
  Result := S_OK;
end;

function TdxSelectionItemProvider.InternalRemoveFromSelection: HResult;
begin
  RemoveFromSelection;
  Result := S_OK;
end;

function TdxSelectionItemProvider.Select: HResult;
begin
  DoSelect;
  Result := S_OK;
end;

function TdxSelectionItemProvider.Get_IsSelected(out pRetVal: Integer): HResult;
begin
  pRetVal := Integer(IsSelected);
  Result := S_OK;
end;

function TdxSelectionItemProvider.Get_SelectionContainer(out pRetVal: IdxRawElementProviderSimple): HResult;
begin
  pRetVal := GetSelectionContainer;
  Result := S_OK;
end;

{ TdxToggleProvider }
procedure TdxToggleProvider.DoToggle;
begin
  // do nothing
end;

function TdxToggleProvider.GetToggleState: Integer;
begin
  Result := 0;
end;

function TdxToggleProvider.Toggle: HResult;
begin
  DoToggle;
  Result := S_OK;
end;

function TdxToggleProvider.Get_ToggleState(out pRetVal: TOleEnum): HResult;
begin
  pRetVal := GetToggleState;
  Result := S_OK;
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  FOleaccLibrary := LoadLibrary(OleaccLibraryName);
  if FOleaccLibrary <> 0 then
  begin
    FcxAccessibleObjectFromWindow := GetProcAddress(FOleaccLibrary, 'AccessibleObjectFromWindow');
    FcxLResultFromObject := GetProcAddress(FOleaccLibrary, 'LresultFromObject');
  end;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  if FOleaccLibrary <> 0 then
    FreeLibrary(FOleaccLibrary);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
