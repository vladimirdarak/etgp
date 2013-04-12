unit UTemplateEditForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, DbCtrls,
  StdCtrls, Buttons;

type

  { TfrmTemplateEdit }

  TfrmTemplateEdit = class(TForm)
    btnOK: TBitBtn;
    btnClose: TBitBtn;
    mDesc: TDBMemo;
    edtName: TDBEdit;
    gbTemplate: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmTemplateEdit: TfrmTemplateEdit;

implementation

{$R *.lfm}

end.

