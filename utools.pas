unit UTools;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, IniFiles, Forms, db, UMainForm, ZDataset,
  Dialogs, DBGrids, Graphics;

const
  C_ERROR_DB_ACCESS_DENIED = 100;
  C_ERROR_DB_PASSWORD      = 101;
  C_ERROR_DB_CONNECTION    = 102;

type
  TEventHandlers = class
    procedure DBGridOnGetText(Sender: TField; var aText: string; DisplayText: Boolean);
  end;

function EnDeCode(const Value: string): string;
function TryDBConnection(Connection: TZConnection):boolean;
procedure SetConnectionParams(Connection: TZConnection; Params: TConnectionParams);
procedure DoRefresh(DataSet :TDataSet; KeyFieldName :String);
procedure DoReactivate(DataSet: TDataSet);
function getSystemUsername: String;
function Plural(const Text: String; const Plurals: array of const; Count: Integer): string;
function GetRecordCount(DbConnection: TZConnection; const TableName: string; const WhereItems: array of const; const WhereValues: array of Variant): integer;
procedure DBGridPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; DataColIndex: Integer);

var EvHandler:TEventHandlers;

implementation

function getSystemUsername: string;
var
  username: String;
begin
  {$ifdef windows}
  username := GetEnvironmentVariable('USERNAME');
  {$endif}
  {$ifdef unix}
  username := GetEnvironmentVariable('USER');
  {$endif}

  result := username;
end;

procedure DoRefresh(DataSet :TDataSet; KeyFieldName :String);
var
AValue :String; {for debugging}
begin
  if NOT(DataSet.Active) then
    DataSet.Open;
    if (DataSet.Active) and NOT(DataSet.IsEmpty) then
    begin
      if (Length(KeyFieldName) < 1) then
        KeyFieldName := DataSet.Fields[0].FieldName; {if no field name is
      passed, use first field}
      AValue := DataSet.FieldByName(KeyFieldName).AsString;

      DataSet.DisableControls;
      try
        DataSet.Close;
        DataSet.Open;

        DataSet.Locate(KeyFieldName,AValue,[]);
      finally { wrap up }
        DataSet.EnableControls;
      end; { try/finally }
    end;
end;

procedure DoReactivate(DataSet: TDataSet);
begin
  {DataSet.Active:=false;
  DataSet.Active:=true;}

  DataSet.Close;
  DataSet.Open;
end;

function EnDeCode(const Value: string): string;
var
  CharIndex: Integer;
  ReturnValue: string;
begin
  ReturnValue := '';
  for CharIndex := 1 to Length(Value) do
  begin
    ReturnValue := ReturnValue + chr(NOT(ord(Value[CharIndex])));
  end;
  Result := ReturnValue;
end;

function TryDBConnection(Connection: TZConnection):boolean;
begin
  Result := True;
  try
    try
      Connection.Connect;
    except
      on E : Exception do
        Result := False;
    end;
  finally
    Connection.Disconnect;
  end;
end;

procedure SetConnectionParams(Connection: TZConnection; Params: TConnectionParams);
begin
  with Connection do
  begin
    {$IFDEF linux}
    //Connection.LibraryLocation:=ExtractFilePath(Application.ExeName) + DirectorySeparator + C_PG_LIBRARY_NAME;
    {$ENDIF}

    {$IFDEF win32}
    //Connection.LibraryLocation:='';
    {$ENDIF}

    Database := Params.Database;
    HostName := Params.Host;
    User := Params.User;
    Port := Params.Port;
    Password := Params.Password;
  end;
end;

function Plural(const Text: String; const Plurals: array of const; Count: Integer): string;
var
  i, id: Integer;
begin
  result := '';

  if (Count < 2) then
    id := 0
  else if (Count >= 2) And (Count < 5) then
    id := 1
  else
    id := 2;

  for i:=Low(Plurals) to High(Plurals) do
  begin
    if i = id then
    begin
      result := Format(Text, [IntToStr(Count) + ' ' + String(Plurals[i].VAnsiString)]);
      break;
    end;
  end;
end;

function GetRecordCount(DbConnection: TZConnection; const TableName: string; const WhereItems: array of const; const WhereValues: array of Variant): integer;
var
  vTgps: TZQuery;
  vCount: Integer;
  i: Integer;
begin
  result := 0;

  if(Length(WhereItems) <> Length(WhereValues)) then
    exit;

  vTgps := TZQuery.Create(nil);

  with vTgps do
  begin
    Connection := DbConnection;
    SQL.Clear;
    SQL.Add('SELECT COUNT(*) AS cnt FROM ' + TableName);
    if Length(WhereItems) > 0 then
    begin
      SQL.Add('WHERE ');
      for i := Low(WhereItems) to High(WhereItems) do
      begin
        //ShowMessage('= :' + String(WhereValues[i]));
        SQL.Add(String(WhereItems[i].VString) + '= :' + String(WhereItems[i].VString));
        ParamByName(String(WhereItems[i].VString)).Value := WhereValues[i];
      end;
    end;
    //SQL.Text:='FROM technological_process WHERE company_id = :company_id';
    //ParamByName('company_id').Value:=frmMain.qryCompanies.FieldByName('company_id').AsInteger;
  end;

  try
    vTgps.Open;
    vCount := vTgps.FieldByName('cnt').AsInteger;
  finally
    vTgps.Close;
    vTgps.Free;
  end;

  result := vCount;
end;

procedure TEventHandlers.DBGridOnGetText(Sender: TField; var aText: string; DisplayText: Boolean);
begin
  if (DisplayText) then
		aText := Sender.AsString;
end;

procedure DBGridPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; DataColIndex: Integer);
var
  MyTextStyle: TTextStyle;
begin
  if (DataCol = DataColIndex) then
  begin
    // The next is not neccesary but you can use it to adjust your text appearance.
    // you can change colors, font, size, as well other parameters.
    MyTextStyle := TDBGrid(Sender).Canvas.TextStyle;
    MyTextStyle.SingleLine := False;
    MyTextStyle.Wordbreak  := False;
    TDBGrid(Sender).Canvas.TextStyle := MyTextStyle;

    // Here how to show any text:
    // just assign an event procedure to OnGetText of the Field.
    Column.Field.OnGetText := @EvHandler.DBGridOnGetText;
  end;
end;

end.

