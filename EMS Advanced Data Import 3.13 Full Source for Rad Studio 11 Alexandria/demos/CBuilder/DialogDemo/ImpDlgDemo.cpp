//---------------------------------------------------------------------------

#include <tchar.h>
#include <vcl.h>
#pragma hdrstop
USERES("ImpDlgDemo.res");
USEFORM("ImpDlgF.cpp", fmImpDlg);
//---------------------------------------------------------------------------
int WINAPI _tWinMain(HINSTANCE, HINSTANCE, LPTSTR, int)
{
        try
        {
                 Application->Initialize();
                 Application->CreateForm(__classid(TfmImpDlg), &fmImpDlg);
                 Application->Run();
        }
        catch (Exception &exception)
        {
                 Application->ShowException(&exception);
        }
        return 0;
}
//---------------------------------------------------------------------------
