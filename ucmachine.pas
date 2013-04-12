unit UCMachine;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UCAbstract, db, Forms, Controls, Dialogs,
  ZDataset, ExtCtrls, StdCtrls, ComCtrls, ZConnection, ZSqlUpdate;

const
  SQL_SELECT_ALL = 'SELECT machine_id, machine_name, machine_desc FROM machine';
  SQL_ATTR_SELECT_ALL = 'SELECT machine_attribute_id, attribute_name, attribute_value, attribute_desc FROM machine_attribute WHERE machine_id = :machine_id';
  SQL_DELETE_ALL = 'DELETE FROM machine WHERE machine_id = :machine_id';
  SQL_ATTR_DELETE_ALL = 'DELETE FROM machine_attribute WHERE machine_id = :machine_id';
  SQL_INSERT = 'INSERT INTO machine (machine_name, machine_desc) VALUES(:machine_name, :machine_desc)';
  SQL_UPDATE = 'UPDATE machine SET machine_name = :machine_name, machine_desc = :machine_desc WHERE machine_id = :machine_id';

type
  TCMachine = class(TCAbstract)
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

constructor TCMachine.Create(TheOwner: TComponent; MainConnection: TZConnection);
var
  vQuery, vQueryAttr: TZQuery;
  vDataSource, vDSAttr: TDataSource;
  vUpdateQuery: TZUpdateSQL;
begin
  //FForm := TfrmCiselnikAdd.Create(TheOwner);
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

    {Fields.FieldByName('machine_id').Visible:=false;
    Fields.FieldByName('machine_desc').Visible:=false;
    with Fields.FieldByName('machine_name') do
    begin
      DisplayLabel:='Názov stroja';
      DisplayWidth := 20;
    end;}


    SortedFields:='machine_name';

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

    Params.ParamByName('machine_id').Value:=MainQuery.FieldByName('machine_id').AsInteger;

    Active := true;

    Fields.FieldByName('machine_attribute_id').Visible:=false;
    Fields.FieldByName('attribute_desc').Visible:=false;
  end;

  FQueryAttr := vQueryAttr;

  vDSAttr := TDataSource.Create(TheOwner);
  vDSAttr.DataSet := vQueryAttr;

  FDatasourceAttr := vDSAttr;
end;

function TCMachine.GetForm:TForm;
begin
  result:=FForm;
end;

procedure TCMachine.SetForm(Form: TForm);
begin
  if(FForm = nil) then
    FForm := Form;
end;

function TCMachine.GetQuery:TZQuery;
begin
  result:=FQuery;
end;

procedure TCMachine.SetQuery(Query: TZQuery);
begin
  if(FQuery = nil) then
    FQuery := Query;
end;

function TCMachine.GetDatasource:TDatasource;
begin
  result:=FDatasource;
end;

procedure TCMachine.SetDatasource(Datasource: TDatasource);
begin
  if(FDatasource = nil) then
    FDatasource := Datasource;
end;

procedure TCMachine.OnAddClick(Sender: TObject);
begin
  {Pridavanie}
  if MainForm = nil then
    exit;

  if MainDatasource = nil then
    exit;

  if(MainForm is TfrmCiselnikAdd) then
  begin
    TfrmCiselnikAdd(MainForm).Caption := 'Pridať stroj do číselníka';
    TfrmCiselnikAdd(MainForm).edtName.DataSource := MainDatasource;
    TfrmCiselnikAdd(MainForm).edtName.DataField := 'machine_name';

    TfrmCiselnikAdd(MainForm).mDescription.DataSource := MainDatasource;
    TfrmCiselnikAdd(MainForm).mDescription.DataField := 'machine_desc';

    MainQuery.Append;

    case MainForm.ShowModal of
      mrOK: OnSaveClick;
      mrCancel: OnCancelClick;
    end;
  end;
end;

procedure TCMachine.OnEditClick(Sender: TObject);
begin
  {Uprava}
  if MainForm = nil then
    exit;

  if(FForm is TfrmCiselnikAdd) then
  begin
    TfrmCiselnikAdd(MainForm).Caption := 'Upraviť údaje o stroji';
    TfrmCiselnikAdd(MainForm).edtName.DataSource := MainDatasource;
    TfrmCiselnikAdd(MainForm).edtName.DataField := 'machine_name';

    TfrmCiselnikAdd(MainForm).mDescription.DataSource := MainDatasource;
    TfrmCiselnikAdd(MainForm).mDescription.DataField := 'machine_desc';

    MainQuery.Edit;

    case TfrmCiselnikAdd(MainForm).ShowModal of
      mrOK: OnSaveClick;
      mrCancel: OnCancelClick;
    end;
  end;
end;

procedure TCMachine.OnDeleteClick(Sender: TObject);
var
  vCount: Integer;
begin
  vCount := GetRecordCount(TZConnection(MainQuery.Connection), 'operation', ['machine_id'], [MainQuery.FieldByName('machine_id').AsInteger]);

  // overime, ci existuje TP, ktory ma zvoleny tento nastroj
  //ak existuje
  if vCount > 0 then
    //zobraz hlasku ze zaznam nieje mozne vymazat
    MessageDlg('Chyba', Plural('Zvolený stroj nieje možné vymazať pretože je priradený %s', ['technologickému postupu', 'technologických postupoch', 'technologických postupoch'], vCount), mtError, [mbOk], mrOk)
  else
    {Mazanie}
    if(MessageDlg('Upozornenie', 'Naozaj chcete zvolenú položku z číselníka vymazať?', mtWarning, [mbYes, mbNo], mrNo)) = mrYes then
      MainQuery.Delete;
end;

procedure TCMachine.OnSaveClick;
begin
  MainQuery.ApplyUpdates;
  DoRefresh(MainQuery, 'machine_id');
end;

procedure TCMachine.OnCancelClick;
begin
  MainQuery.CancelUpdates;
end;

procedure TCMachine.OnAfterScroll(DataSet: TDataSet);
begin
  FQueryAttr.Close;
  FQueryAttr.Params.ParamByName('machine_id').Value := DataSet.FieldByName('machine_id').AsInteger;
  FQueryAttr.Open;
end;

procedure TCMachine.SetTab(PageControl: TPageControl);
var
  vTabSheet: TTabSheet;
  vForm: TForm;
begin
  vTabSheet := TTabSheet.Create(PageControl);
  vTabSheet.Parent := PageControl;
  vTabSheet.Caption:='Stroje';

  vForm := TfrmCiselnikFormDefault.Create(vTabSheet);
  vForm.Parent := vTabSheet;
  with TfrmCiselnikFormDefault(vForm) do
  begin
    grdList.DataSource := self.MainDatasource;
    grdList.Columns.Clear;
    with grdList.Columns.Add do
    begin
      FieldName := 'machine_name';
      Width := 260;
      Title.Caption := 'Názov stroja';
    end;

    grdAttrs.DataSource := FDatasourceAttr;
    mDesc.DataField:='machine_desc';
    mDesc.DataSource := self.MainDatasource;
  end;

  vForm.Show;
end;

end.

