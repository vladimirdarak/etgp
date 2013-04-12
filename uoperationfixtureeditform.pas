unit UOperationFixtureEditForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DbCtrls, Buttons, ZDataset;

type

  { TfrmOperationFixtureEdit }

  TfrmOperationFixtureEdit = class(TForm)
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    cbFixtureName: TDBLookupComboBox;
    mDesc: TDBMemo;
    dsFixture: TDatasource;
    gbOperationTool: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    qryFixturefixture_desc: TMemoField;
    qryFixturefixture_id: TLongintField;
    qryFixturefixture_name: TStringField;
    qryTooltool_description1: TMemoField;
    qryTooltool_id1: TLongintField;
    qryTooltool_name1: TStringField;
    qryFixture: TZQuery;
    procedure FormShow(Sender: TObject);
    procedure qryFixtureAfterScroll(DataSet: TDataSet);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmOperationFixtureEdit: TfrmOperationFixtureEdit;

implementation

{$R *.lfm}

{ TfrmOperationFixtureEdit }

procedure TfrmOperationFixtureEdit.FormShow(Sender: TObject);
begin

end;

procedure TfrmOperationFixtureEdit.qryFixtureAfterScroll(DataSet: TDataSet);
begin

end;

end.

