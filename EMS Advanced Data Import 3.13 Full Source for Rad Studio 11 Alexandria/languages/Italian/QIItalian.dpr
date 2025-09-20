
{******************************************************************************}
{  Now Quick Import can use several languages in one project. By default, it   }
{  works with resources that are linked into .BPL file. If you need            }
{  multi-language support in your project, make several language DLLs          }
{  and switch to particular language by this code:                             }
{                                                                              }
{  uses QImport3;                                                              }
{                                                                              }
{  QImportLocale.LoadDll('QIEnglish.dll'); // load English resources           }
{  ...                                                                         }
{  QImportLocale.UnloadDll; // unload resource DLL and use default resources   }
{                                                                              }
{  To make the DLL, run MakeDll.bat file in this folder, or MakeAll.bat file   }
{  in the LANGUAGES folder to make DLLs for all languages.                     }
{******************************************************************************}


library QIItalian;

{$R QIResStr.res}

begin
end.