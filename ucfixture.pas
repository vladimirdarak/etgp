unit UCFixture;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UCAbstract, db, Forms, Controls, Dialogs,
  ZDataset, ExtCtrls, StdCtrls, ComCtrls, ZConnection, ZSqlUpdate;

const
  SQL_SELECT_ALL = 'SELECT fixture_id, fixture_name, fixture_desc FROM fixture';
  SQL_ATTR_SELECT_ALL = 'SELECT fixture_attribute_id, attribute_name, attribute_value, attribute_desc FROM fixture_attribute WHERE fixture_id = :fixture_id';
  SQL_DELETE_ALL = 'DELETE FROM fixture WHERE fixture_id = :fixture_id';
  SQL_ATTR_DELETE_ALL = 'DELETE FROM fixture_attribute WHERE fixture_id = :fixture_id';
  SQL_INSERT = 'INSERT INTO fixture (fixture_name, fixture_desc) VALUES(:fixture_name, :fixture_desc)';
  SQL_UPDATE = 'UPDATE fixture SET fixture_name = :fixture_name, fixture_desc = :fixture_desc WHERE fixture_id = :fixture_id';

type
  TCFixture = class(TCAbstract)
    private
      FForm: TForm;
      FQuery: TZQuery;
      FQueryAttr: TZquery;
      FDatasource: TDatasource;
      FDatasourceAttr: TDatasource;

      procedure OnSaveClick;
      procedure OnCancelClick;

      function GetQuery:TZQuery;
      procedure SetQuery(Query: TZQuery);
      function GetDataSource:TDatasource;
      procedure SetDataSource(Datasource: TDatasource);
      function GetForm:TForm;
      procedure SetForm(Form: TForm);
    public
      property MainQuery: TZQuery read GetQuery write SetQuery;
      property MainDatasource: TDatasource read GetDatasource write SetDatasource;
      property MainForm: TForm read GetForm write SetForm;

      constructor Create(TheOwner: TComponent; MainConnection: TZConnection);
      procedure OnAddClick(Sender: TObject); override;
      procedure OnEditClick(Sender: TObject); override;
      procedure OnDeleteClick(Sender: TObject); override;
      procedure OnAfterScroll(DataSet: TDataSet); override;
      procedure SetTab(PageControl: TPageControl); override;
  end;

implementation

uses
  UCiselnikyAddForm, UCiselnikDefaultForm, UTools;

constructor TCFixture.Create(TheOwner: TComponent; MainConnection: TZConnection);
var
  vQuery, vQueryAttr: TZQuery;
  vDataSource, vDSAttr: TDataSource;
  vUpdateQuery: TZUpdateSQL;
begin
  SetForm(TfrmCiselnikAdd.Create(TheOwner));

  vUpdateQuery := TZUpdateSQL.Create(TheOwner);
  with vUpdateQuery do
  begin
    DeleteSQL.Add(SQL_ATTR_DELETE_ALL + ';');
    DeleteSQL.Add(SQL_DELETE_ALL + ';');
    InsertSQL.Add(SQL_INSERT + ';');
    ModifySQL.Add(SQL_UPDATE + ';');
  end;

  // vytvorim TZQuery
  vQuery := TZQuery.Create(TheOwner);
  with vQuery do
  begin
    Connection := MainConnection;
    SQL.Text:=SQL_SELECT_ALL;
    UpdateObject := vUpdateQuery;

    Active := true;

    {Fields.FieldByName('fixture_id').Visible:=false;
    Fields.FieldByName('fixture_desc').Visible:=false;
    with Fields.FieldByName('fixture_name') do
    begin
      DisplayLabel:='Názov prípravku';
      DisplayWidth := 20;
    end;}
    SortedFields:='fixture_name';

    AfterScroll:=@OnAfterScroll;
  end;

  // priradim TZQuery
  SetQuery(vQuery);

  // vytvorim TDataSource
  vDataSource := TDataSource.Create(TheOwner);
  vDataSource.DataSet := MainQuery;

  // priradim TDataSource
  SetDatasource(vDataSource);


  vQueryAttr := TZQuery.Create(TheOwner);
  with vQueryAttr do
  begin
    Connection := MainConnection;
    SQL.Text:=SQL_ATTR_SELECT_ALL;

    Params.ParamByName('fixture_id').Value:=MainQuery.FieldByName('fixture_id').AsInteger;

    Active := true;

    Fields.FieldByName('fixture_attribute_id').Visible:=false;
    Fields.FieldByName('attribute_desc').Visible:=false;
  end;

  FQueryAttr := vQueryAttr;

  vDSAttr := TDataSource.Create(TheOwner);
  vDSAttr.DataSet := vQueryAttr;

  FDatasourceAttr := vDSAttr;
end;

function TCFixture.GetForm:TForm;
begin
  result:=FForm;
end;

procedure TCFixture.SetForm(Form: TForm);
begin
  if(FForm = nil) then
    FForm := Form;
end;

function TCFixture.GetQuery:TZQuery;
begin
  result:=FQuery;
end;

procedure TCFixture.SetQuery(Query: TZQuery);
begin
  if(FQuery = nil) then
    FQuery := Query;
end;

function TCFixture.GetDatasource:TDatasource;
begin
  result:=FDatasource;
end;

procedure TCFixture.SetDatasource(Datasource: TDatasource);
begin
  if(FDatasource = nil) then
    FDatasource := Datasource;
end;

procedure TCFixture.OnAddClick(Sender: TObject);
begin
  {Pridavanie}
  if MainForm = nil then
    exit;

  if MainDatasource = nil then
    exit;

  if(MainForm is TfrmCiselnikAdd) then
  begin
    TfrmCiselnikAdd(MainForm).Caption := 'Pridať prípravok do číselníka';
    TfrmCiselnikAdd(MainForm).edtName.DataField := 'fixture_name';
    TfrmCiselnikAdd(MainForm).edtName.DataSource := MainDatasource;

    TfrmCiselnikAdd(MainForm).mDescription.DataField := 'fixture_desc';
    TfrmCiselnikAdd(MainForm).mDescription.DataSource := MainDatasource;

    MainQuery.Append;

    case MainForm.ShowModal of
      mrOK: OnSaveClick;
      mrCancel: OnCancelClick;
    end;
  end;
end;

procedure TCFixture.OnEditClick(Sender: TObject);
begin
  {Uprava}
  if MainForm = nil then
    exit;

  if(FForm is TfrmCiselnikAdd) then
  begin
    TfrmCiselnikAdd(MainForm).Caption := 'Upraviť údaje o prípravku';
    TfrmCiselnikAdd(MainForm).edtName.DataSource := MainDatasource;
    TfrmCiselnikAdd(MainForm).edtName.DataField := 'fixture_name';

    TfrmCiselnikAdd(MainForm).mDescription.DataSource := MainDatasource;
    TfrmCiselnikAdd(MainForm).mDescription.DataField := 'fixture_desc';

    MainQuery.Edit;

    case TfrmCiselnikAdd(MainForm).ShowModal of
      mrOK: OnSaveClick;
      mrCancel: OnCancelClick;
    end;
  end;
end;

procedure TCFixture.OnDeleteClick(Sender: TObject);
var vCount: Integer;
begin
  vCount := GetRecordCount(TZConnection(MainQuery.Connection), 'operation_fixture', ['fixture_id'], [MainQuery.FieldByName('fixture_id').AsInteger]);

  // overime, ci existuje TP, ktory ma zvoleny tento nastroj
  //ak existuje
  if vCount > 0 then
    //zobraz hlasku ze zaznam nieje mozne vymazat
    MessageDlg('Chyba', 'Zvolený prípravok nieje možné vymazať pretože sa používa v niektorom z technologických postupov' , mtError, [mbOk], mrOk)
  else
    {Mazanie}
    if(MessageDlg('Upozornenie', 'Naozaj chcete zvolenú položku z číselníka vymazať?', mtWarning, [mbYes, mbNo], mrNo)) = mrYes then
      MainQuery.Delete;
end;

procedure TCFixture.OnSaveClick;
begin
  MainQuery.ApplyUpdates;
  DoRefresh(MainQuery, 'fixture_id');
end;

procedure TCFixture.OnCancelClick;
begin
  MainQuery.CancelUpdates;
end;

procedure TCFixture.OnAfterScroll(DataSet: TDataSet);
begin
  FQueryAttr.Close;
  FQueryAttr.Params.ParamByName('fixture_id').Value := DataSet.FieldByName('fixture_id').AsInteger;
  FQueryAttr.Open;
end;

procedure TCFixture.SetTab(PageControl: TPageControl);
var
  vTabSheet: TTabSheet;
  vForm: TForm;
begin
  vTabSheet := TTabSheet.Create(PageControl);
  vTabSheet.Parent := PageControl;
  vTabSheet.Caption:='Prípravky';

  vForm := TfrmCiselnikFormDefault.Create(vTabSheet);
  vForm.Parent := vTabSheet;

  with TfrmCiselnikFormDefault(vForm) do
  begin
    grdList.DataSource := self.MainDatasource;
    grdAttrs.DataSource := FDatasourceAttr;

    with grdList.Columns.Add do
    begin
      FieldName := 'fixture_name';
      Width := 260;
      Title.Caption := 'Názov prípravku';
    end;

    mDesc.DataField:='fixture_desc';
    mDesc.DataSource := self.MainDatasource;
  end;

  vForm.Show;
end;

end.

