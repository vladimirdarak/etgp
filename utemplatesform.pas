unit UTemplatesForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DBGrids, ComCtrls, ExtCtrls, PairSplitter, ZDataset, ZSqlUpdate, ZSequence,
  Grids;

type

  { TfrmTemplates }

  TfrmTemplates = class(TForm)
    btnClose: TButton;
    dsOperatioNames: TDatasource;
    gbTemplates: TGroupBox;
    dsTemplates: TDatasource;
    dsTemplateOperations: TDatasource;
    grdFixtures: TDBGrid;
    grdOperations: TDBGrid;
    grdTemplates: TDBGrid;
    grdTools: TDBGrid;
    gbOperations: TGroupBox;
    ilTemplateActions: TImageList;
    ilOperationActions: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    PairSplitter1: TPairSplitter;
    PairSplitter2: TPairSplitter;
    PairSplitter3: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    PairSplitterSide3: TPairSplitterSide;
    PairSplitterSide4: TPairSplitterSide;
    PairSplitterSide5: TPairSplitterSide;
    PairSplitterSide6: TPairSplitterSide;
    pnlDialogActions: TPanel;
    qryTemplateOperations: TZQuery;
    qryTemplateOperationsmachine_id: TLongintField;
    qryTemplateOperationsmachine_name: TStringField;
    qryTemplateOperationsoperation_desc: TMemoField;
    qryTemplateOperationsoperation_id: TLongintField;
    qryTemplateOperationsoperation_name: TStringField;
    qryTemplateOperationsoperation_name_id: TLongintField;
    qryTemplateOperationsoperation_number: TLongintField;
    qryTemplateOperationsoperation_time: TFloatField;
    qryTemplateOperationstechnological_process_id: TLongintField;
    qryTemplateOperationstemplate_id: TLongintField;
    qryTemplatestemplate_desc: TMemoField;
    qryTemplatestemplate_id: TLongintField;
    qryTemplatestemplate_name: TStringField;
    qryTemplates: TZQuery;
    tbOperationActions: TToolBar;
    tbOperationFixtureActions: TToolBar;
    tbTemplateActions: TToolBar;
    btnTemplateAdd: TToolButton;
    btnTemplateDelete: TToolButton;
    btnTemplateEdit: TToolButton;
    btnOperationAdd: TToolButton;
    btnOperationEdit: TToolButton;
    btnOperationDelete: TToolButton;
    tbOperationToolActions: TToolBar;
    btnToolAdd: TToolButton;
    btnToolDelete: TToolButton;
    btnFixtureAdd: TToolButton;
    btnFixtureDelete: TToolButton;
    updTemplates: TZUpdateSQL;
    updTemplateOperations: TZUpdateSQL;
    procedure btnCloseClick(Sender: TObject);
    procedure btnFixtureDeleteClick(Sender: TObject);
    procedure btnOperationAddClick(Sender: TObject);
    procedure btnOperationDeleteClick(Sender: TObject);
    procedure btnOperationEditClick(Sender: TObject);
    procedure btnTemplateAddClick(Sender: TObject);
    procedure btnTemplateDeleteClick(Sender: TObject);
    procedure btnToolAddClick(Sender: TObject);
    procedure btnToolDeleteClick(Sender: TObject);
    procedure dsTemplateOperationsDataChange(Sender: TObject; Field: TField);
    procedure dsTemplatesDataChange(Sender: TObject; Field: TField);
    procedure FormCreate(Sender: TObject);
    procedure grdFixturesPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure grdOperationsPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure grdTemplatesPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure DBGridOnGetText(Sender: TField; var aText: string; DisplayText: Boolean);
    procedure grdToolsPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure qryTemplateOperationsAfterOpen(DataSet: TDataSet);
    procedure qryTemplateOperationsAfterRefresh(DataSet: TDataSet);
    procedure qryTemplateOperationsAfterScroll(DataSet: TDataSet);
    procedure qryTemplateOperationsBeforeRefresh(DataSet: TDataSet);
    procedure qryTemplatesAfterApplyUpdates(Sender: TObject);
    procedure qryTemplatesAfterRefresh(DataSet: TDataSet);
    procedure qryTemplatesAfterScroll(DataSet: TDataSet);
    procedure btnTemplateEditClick(Sender: TObject);
    procedure qryTemplatesBeforeApplyUpdates(Sender: TObject);
    procedure btnFixtureAddClick(Sender: TObject);
    procedure updTemplatesAfterInsertSQL(Sender: TObject);
    procedure updTemplatesAfterModifySQL(Sender: TObject);
    procedure updTemplatesBeforeInsertSQL(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure ShowTemplateEditForm(IsNew: boolean);
    procedure ShowTemplatesForm;
    procedure TemplateSave;
    procedure TemplateDiscard;
    procedure TemplateDelete;
    procedure UpdateActions;

    procedure ShowOperationEditForm(IsNew: boolean);
    procedure ShowOperationToolEditForm(IsNew: boolean);
    procedure ShowOperationFixtureEditForm(IsNew: boolean);
    procedure OperationSave;
    procedure OperationDiscard;
    procedure OperationDelete;
    procedure OperationToolSave;
    procedure OperationToolDiscard;
    procedure OperationToolDelete;
    procedure OperationFixtureSave;
    procedure OperationFixtureDiscard;
    procedure OperationFixtureDelete;
  end;

var
  frmTemplates: TfrmTemplates;

implementation

uses
  UTools, UMainForm, UTemplateEditForm, UOperationEditForm,
  UOperationToolEditForm, UOperationFixtureEditForm;

{$R *.lfm}

{ TfrmTemplates }

procedure TfrmTemplates.btnCloseClick(Sender: TObject);
begin

end;

procedure TfrmTemplates.btnFixtureDeleteClick(Sender: TObject);
begin
  OperationFixtureDelete;
end;

procedure TfrmTemplates.btnOperationAddClick(Sender: TObject);
begin
  ShowOperationEditForm(true);
end;

procedure TfrmTemplates.btnOperationDeleteClick(Sender: TObject);
begin
  OperationDelete;
end;

procedure TfrmTemplates.btnOperationEditClick(Sender: TObject);
begin
  ShowOperationEditForm(false);
end;

procedure TfrmTemplates.btnTemplateAddClick(Sender: TObject);
begin
  ShowTemplateEditForm(true);
end;

procedure TfrmTemplates.btnTemplateDeleteClick(Sender: TObject);
begin
  TemplateDelete;
end;

procedure TfrmTemplates.btnToolAddClick(Sender: TObject);
begin
  ShowOperationToolEditForm(true);
end;

procedure TfrmTemplates.btnToolDeleteClick(Sender: TObject);
begin
  OperationToolDelete;
end;

procedure TfrmTemplates.dsTemplateOperationsDataChange(Sender: TObject;
  Field: TField);
begin

end;

procedure TfrmTemplates.dsTemplatesDataChange(Sender: TObject; Field: TField);
begin

end;

procedure TfrmTemplates.FormCreate(Sender: TObject);
begin

end;

procedure TfrmTemplates.grdFixturesPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
  UTools.DBGridPrepareCanvas(Sender, DataCol, Column, 1);
end;

procedure TfrmTemplates.grdOperationsPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
  UTools.DBGridPrepareCanvas(Sender, DataCol, Column, 4);
end;

procedure TfrmTemplates.grdTemplatesPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
  UTools.DBGridPrepareCanvas(Sender, DataCol, Column, 1);
end;

procedure TfrmTemplates.DBGridOnGetText(Sender: TField; var aText: string; DisplayText: Boolean);
begin
  if (DisplayText) then
		aText := Sender.AsString;
end;

procedure TfrmTemplates.grdToolsPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
  UTools.DBGridPrepareCanvas(Sender, DataCol, Column, 1);
end;

procedure TfrmTemplates.qryTemplateOperationsAfterOpen(DataSet: TDataSet);
begin
  with frmMain do
  begin
    qryTools.Close;
    qryTools.Params.ParamByName('operation_id').Value := DataSet.FieldByName('operation_id').AsInteger;
    qryTools.Open;

    qryFixtures.Close;
    qryFixtures.Params.ParamByName('operation_id').Value := DataSet.FieldByName('operation_id').AsInteger;
    qryFixtures.Open;
  end;

  frmTemplates.UpdateActions;
end;

procedure TfrmTemplates.qryTemplateOperationsAfterRefresh(DataSet: TDataSet);
begin

end;

procedure TfrmTemplates.qryTemplateOperationsAfterScroll(DataSet: TDataSet);
begin
  //ShowMessage(DataSet.FieldByName('operation_id').AsString);
  with frmMain do
  begin
    qryTools.Close;
    qryTools.Params.ParamByName('operation_id').Value := DataSet.FieldByName('operation_id').AsInteger;
    qryTools.Open;

    qryFixtures.Close;
    qryFixtures.Params.ParamByName('operation_id').Value := DataSet.FieldByName('operation_id').AsInteger;
    qryFixtures.Open;
  end;

  frmTemplates.UpdateActions;
end;

procedure TfrmTemplates.qryTemplateOperationsBeforeRefresh(DataSet: TDataSet);
begin

end;

{procedure TfrmTemplates.UpdateActions;
begin
  with frmTemplates do
  begin
    btnTemplateEdit.Enabled:=(qryTemplates.RecordCount > 0);
    btnTemplateDelete.Enabled:=(qryTemplates.RecordCount > 0);

    btnOperationAdd.Enabled:=(qryTemplates.RecordCount > 0);

    //if qryOperations.Active then
    if qryTemplateOperations.Active then
    begin
      btnOperationEdit.Enabled:=(qryTemplateOperations.RecordCount > 0);
      btnOperationDelete.Enabled:=(qryTemplateOperations.RecordCount > 0);

      btnToolAdd.Enabled:=(qryTemplateOperations.RecordCount > 0);
      btnFixtureAdd.Enabled:=(frmMain.qryOperations.RecordCount > 0);
    end;

    if qryTools.Active then
    begin
      btnToolDelete.Enabled:=(qryTools.RecordCount > 0);
    end;

    if qryFixtures.Active then
    begin
      btnFixtureDelete.Enabled:=(qryFixtures.RecordCount > 0);
    end;
  end;
end;  }

procedure TfrmTemplates.qryTemplatesAfterApplyUpdates(Sender: TObject);
begin

end;

procedure TfrmTemplates.qryTemplatesAfterRefresh(DataSet: TDataSet);
begin

end;

procedure TfrmTemplates.qryTemplatesAfterScroll(DataSet: TDataSet);
begin
  qryTemplateOperations.Close;
  qryTemplateOperations.Params.ParamByName('template_id').Value := DataSet.FieldByName('template_id').AsInteger;
  qryTemplateOperations.Open;
  //ShowMessage('test');
  //showmessage('idem refresh');
  DoRefresh(qryTemplateOperations, 'operation_id');

  frmTemplates.UpdateActions;
end;

procedure TfrmTemplates.btnTemplateEditClick(Sender: TObject);
begin
  ShowTemplateEditForm(false);
end;

procedure TfrmTemplates.qryTemplatesBeforeApplyUpdates(Sender: TObject);
begin

end;

procedure TfrmTemplates.btnFixtureAddClick(Sender: TObject);
begin
  ShowOperationFixtureEditForm(true);
end;

procedure TfrmTemplates.updTemplatesAfterInsertSQL(Sender: TObject);
begin

end;

procedure TfrmTemplates.updTemplatesAfterModifySQL(Sender: TObject);
begin

end;

procedure TfrmTemplates.updTemplatesBeforeInsertSQL(Sender: TObject);
begin

end;

procedure TfrmTemplates.ShowTemplateEditForm(IsNew: boolean);
begin
  with frmTemplateEdit do
  begin
    Caption := 'Upraviť šablónu';

    if(IsNew) then
    begin
      Caption := 'Pridať šablónu';
      frmTemplates.qryTemplates.Append;
    end else
      frmTemplates.qryTemplates.Edit;

    case ShowModal of
      mrOK: TemplateSave;
      mrCancel: TemplateDiscard;
    end;

    UpdateActions;
  end;
end;

procedure TfrmTemplates.ShowTemplatesForm;
begin
  with frmTemplates do
  begin
    qryTemplates.Active:=false;
    qryTemplateOperations.Active:=false;

    qryTemplates.Active:=true;
    qryTemplateOperations.Active:=true;

    qryTemplates.First;
    qryTemplateOperations.first;

    with frmMain do
    begin
      qryTools.Active:=false;
      qryFixtures.Active:=false;

      qryTools.Active:=true;
      qryFixtures.Active:=true;
      qryTools.First;
      qryFixtures.First;
    end;

    UpdateActions;

    case ShowModal of
      mrClose: Close;
    end;
  end;
end;

procedure TfrmTemplates.TemplateSave;
begin
  frmTemplates.qryTemplates.ApplyUpdates;
  DoRefresh(frmTemplates.qryTemplates, 'template_id');
end;

procedure TfrmTemplates.TemplateDiscard;
begin
  frmTemplates.qryTemplates.CancelUpdates;
end;

procedure TfrmTemplates.TemplateDelete;
begin
  if MessageDlg('Varovanie', 'Budú odstránené všetky operácie patriace do danej šablóny. Naozaj chcete zvolenú šablónu zmazať?', mtWarning, [mbYes, mbNo], mrNo) = mrYes then
    frmTemplates.qryTemplates.Delete;

  UpdateActions;
end;

procedure TfrmTemplates.UpdateActions;
begin
  with frmTemplates do
  begin
    btnTemplateEdit.Enabled:=(qryTemplates.RecordCount > 0);
    btnTemplateDelete.Enabled:=(qryTemplates.RecordCount > 0);

    btnOperationAdd.Enabled:=(qryTemplates.RecordCount > 0);

    //if qryOperations.Active then
    if qryTemplateOperations.Active then
    begin
      btnOperationEdit.Enabled:=(qryTemplateOperations.RecordCount > 0);
      btnOperationDelete.Enabled:=(qryTemplateOperations.RecordCount > 0);

      btnToolAdd.Enabled:=(qryTemplateOperations.RecordCount > 0);
      btnFixtureAdd.Enabled:=(qryTemplateOperations.RecordCount > 0);
    end;

    with frmMain do
    begin
      if qryTools.Active then
      begin
        btnToolDelete.Enabled:=(qryTools.RecordCount > 0);
      end;

      if qryFixtures.Active then
      begin
        btnFixtureDelete.Enabled:=(qryFixtures.RecordCount > 0);
      end;
    end;
  end;
end;

procedure TfrmTemplates.ShowOperationEditForm(IsNew: boolean);
begin
  with frmOperationEdit do
  begin
    Caption := 'Uložiť operáciu';

    if IsNew then
    begin
      Caption := 'Vložiť novú operáciu';

      frmTemplates.qryTemplateOperations.Append;
    end else
      frmTemplates.qryTemplateOperations.Edit;

    case ShowModal of
      mrOk: OperationSave;
      mrCancel: OperationDiscard;
    end;
  end;
end;

procedure TfrmTemplates.ShowOperationToolEditForm(IsNew: boolean);
begin
  with frmOperationTool do
  begin
    Caption := 'Pridať operáciu';

    qryTool.Active:=false;
    qryTool.Active:=true;

    frmMain.qryTools.Append;

    if IsNew and (qryTool.RecordCount > 0) then
    begin
      cbToolName.ItemIndex:= 0;
      cbToolName.DataSource.DataSet['tool_id'] := cbToolName.KeyValue;
    end;

    case ShowModal of
      mrOk: OperationToolSave;
      mrCancel: OperationToolDiscard;
    end;
  end;
end;

procedure TfrmTemplates.ShowOperationFixtureEditForm(IsNew: boolean);
begin
  with frmOperationFixtureEdit do
  begin
    Caption := 'Pridať prípravok';

    qryFixture.Active:=false;
    qryFixture.Active:=true;

    frmMain.qryFixtures.Append;

    if IsNew and (qryFixture.RecordCount > 0) then
    begin
      cbFixtureName.ItemIndex:= 0;
      cbFixtureName.DataSource.DataSet['fixture_id'] := cbFixtureName.KeyValue;
    end;

    case ShowModal of
      mrOk: OperationFixtureSave;
      mrCancel: OperationFixtureDiscard;
    end;
  end;
end;

procedure TfrmTemplates.OperationSave;
begin
  qryTemplateOperations['template_id'] := frmTemplates.qryTemplates['template_id'];
  qryTemplateOperations.ApplyUpdates;

  DoRefresh(qryTemplateOperations, 'operation_id');

  UpdateActions;
end;

procedure TfrmTemplates.OperationDiscard;
begin
  //frmTemplates.qryOperations.CancelUpdates;
  qryTemplateOperations.CancelUpdates;
end;

procedure TfrmTemplates.OperationDelete;
begin
  if MessageDlg('Varovanie', 'Budú odstránené všetky nástroje a prípravky patriace do zvolenej operácie. Naozaj chcete zvolenú operáciu zmazať?', mtWarning, [mbYes, mbNo], mrNo) = mrYes then
    //frmTemplates.qryOperations.Delete;
    qryTemplateOperations.Delete;

  UpdateActions;
end;

procedure TfrmTemplates.OperationToolSave;
begin
  frmMain.qryTools['operation_id'] := qryTemplateOperations['operation_id'];
  frmMain.qryTools.ApplyUpdates;

  DoRefresh(frmMain.qryTools, 'operation_tool_id');

  UpdateActions;
end;

procedure TfrmTemplates.OperationToolDiscard;
begin
  frmMain.qryTools.CancelUpdates;
end;

procedure TfrmTemplates.OperationToolDelete;
begin
  if MessageDlg('Varovanie', 'Naozaj chcete zvolený nástroj zmazať?', mtWarning, [mbYes, mbNo], mrNo) = mrYes then
    frmMain.qryTools.Delete;

  UpdateActions;
end;

procedure TfrmTemplates.OperationFixtureSave;
begin
  frmMain.qryFixtures['operation_id'] := qryTemplateOperations['operation_id'];
  frmMain.qryFixtures.ApplyUpdates;

  DoRefresh(frmMain.qryFixtures, 'operation_fixture_id');

  UpdateActions;
end;

procedure TfrmTemplates.OperationFixtureDiscard;
begin
  frmMain.qryFixtures.CancelUpdates;
end;

procedure TfrmTemplates.OperationFixtureDelete;
begin
  if MessageDlg('Varovanie', 'Naozaj chcete zvolený prípravok zmazať?', mtWarning, [mbYes, mbNo], mrNo) = mrYes then
    frmMain.qryFixtures.Delete;

  UpdateActions;
end;

end.

