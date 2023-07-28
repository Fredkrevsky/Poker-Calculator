unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, PokerLogic, System.DateUtils,
  Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    HN1: TComboBox;
    HS1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    HN2: TComboBox;
    HS2: TComboBox;
    Label3: TLabel;
    Button1: TButton;
    Label4: TLabel;
    Label5: TLabel;
    N1: TComboBox;
    S1: TComboBox;
    N2: TComboBox;
    S2: TComboBox;
    N3: TComboBox;
    S3: TComboBox;
    N4: TComboBox;
    S4: TComboBox;
    N5: TComboBox;
    S5: TComboBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Button2: TButton;
    Label17: TLabel;
    Amount: TEdit;
    Label27: TLabel;
    Edit11: TEdit;
    Label28: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    Button3: TButton;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit19: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Label38: TLabel;
    OppNum: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    type TResEdits = array[1..11] of TEdit;
    TMaskBox = array[1..10] of TCheckBox;
    TSNBox = array[1..7] of TComboBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ResEdits, OppEdits: TForm1.TResEdits;
  MaskBox: TForm1.TMaskBox;
  NBox, SBox: TForm1.TSNBox;

implementation

procedure TForm1.FormCreate(Sender: TObject);
var i, j:Byte;
begin
  ResEdits[1]:=Edit1;
  ResEdits[2]:=Edit2;
  ResEdits[3]:=Edit3;
  ResEdits[4]:=Edit4;
  ResEdits[5]:=Edit5;
  ResEdits[6]:=Edit6;
  ResEdits[7]:=Edit7;
  ResEdits[8]:=Edit8;
  ResEdits[9]:=Edit9;
  ResEdits[10]:=Edit10;
  ResEdits[11]:=Edit11;

  OppEdits[2]:=Edit13;
  OppEdits[3]:=Edit14;
  OppEdits[4]:=Edit15;
  OppEdits[5]:=Edit16;
  OppEdits[6]:=Edit17;
  OppEdits[7]:=Edit18;
  OppEdits[8]:=Edit19;
  OppEdits[9]:=Edit20;
  OppEdits[10]:=Edit21;

  MaskBox[1]:=CheckBox1;
  MaskBox[2]:=CheckBox2;
  MaskBox[3]:=CheckBox3;
  MaskBox[4]:=CheckBox4;
  MaskBox[5]:=CheckBox5;
  MaskBox[6]:=CheckBox6;
  MaskBox[7]:=CheckBox7;
  MaskBox[8]:=CheckBox8;
  MaskBox[9]:=CheckBox9;
  MaskBox[10]:=CheckBox10;

  NBox[1]:=HN1;
  NBox[2]:=HN2;
  NBox[3]:=N1;
  NBox[4]:=N2;
  NBox[5]:=N3;
  NBox[6]:=N4;
  NBox[7]:=N5;

  SBox[1]:=HS1;
  SBox[2]:=HS2;
  SBox[3]:=S1;
  SBox[4]:=S2;
  SBox[5]:=S3;
  SBox[6]:=S4;
  SBox[7]:=S5;

  for i:=1 to 4 do
  begin
    for j:=1 to 7 do
    SBox[j].Items.Add(Suits[i]);
  end;
  for i:=10 to 13 do
  begin
    for j:=1 to 7 do
    NBox[j].Items.Add(Nominals[i]);
  end;
end;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  ShowMessage(NeedToPlay(HN1.Text, HN2.Text, HS1.Text, HS2.Text));
end;

procedure TForm1.Button2Click(Sender: TObject);

  function LastField(N, S: TSNBox): Byte;
  begin
    Result:=2;
    if (S[3].Text <> '') or  (S[4].Text <> '') or (S[5].Text <> '') or
  (N[3].Text <> '') or (N[4].Text <> '') or (N[5].Text <> '') then
    Result:=5;
    if (S[6].Text <> '') or (N[6].Text <> '') then
    Result:=6;
    if (S[7].Text <> '') or (N[7].Text <> '') then
    Result:=7;
  end;

var Cards: TCards;
Probs: TProb;
ByteCards: TByteCards;
Start, Stop: TDateTime;
Mask: TMask;
i: Byte;
OppProb: TProb;
NumberOfOpponents: Byte;
begin
  if OppNum.Text = '' then
  OppNum.Text:='0';
  NumberOfOpponents:=StrToInt(OppNum.Text);

  SetLength(Cards, LastField(NBox, SBox));
  for i:=0 to Length(Cards)-1 do
  begin
    if Length(SBox[i+1].Text)>=2 then
    Cards[i].Suit:=AnsiUpperCase(SBox[i+1].Text[1])+AnsiLowerCase(Copy(SBox[i+1].Text, 2, Length(SBox[i+1].Text)-1))
    else
    Cards[i].Suit:=SBox[i+1].Text;
    Cards[i].Nominal:=AnsiUpperCase(NBox[i+1].Text);
  end;

  for i:=1 to 10 do
  Mask[i]:=MaskBox[i].Checked;

  if (PositionWithoutSuits(Cards)>0) and (StrToInt(Amount.Text)>0) then
  begin
    FillCardsWithoutSuit(Cards);
    Mask[6]:=False;
    Mask[9]:=False;
    Mask[10]:=False;
  end;

  if (PositionIsCorrect(Cards)<>0) and (StrToInt(Amount.Text)>0) then
  begin
    Start:=Now;
    ByteCards:=ConvertIntoByteArray(Cards);
    if Mask[1] then
    ResEdits[1].Text:=HighCard(ByteCards)
    else
    ResEdits[1].Text:='';
    if PositionIsCorrect(Cards)<7 then
    begin
      Probs:=GenerateProb(ByteCards, StrToInt(Amount.Text), Mask, NumberOfOpponents);
      for i:=2 to 10 do
      begin
        if Mask[i] then
        begin
          ResEdits[i].Text:=Copy(FloatToStr(Probs[0][i]), 0, 7);
          if NumberOfOpponents>0 then
          OppEdits[i].Text:=Copy(FloatToStr(Probs[1][i]), 0, 7);
        end
        else
        begin
          ResEdits[i].Text:='';
          OppEdits[i].Text:='';
        end;
      end;
    end
    else
    begin
      if NumberOfOpponents>0 then
      begin
        OppProb:=GenerateOppFull(ByteCards, StrToInt(Amount.Text), Mask, NumberOfOpponents);
        for i:=2 to 10 do
        begin
          if Mask[i] then
          OppEdits[i].Text:=Copy(FloatToStr(OppProb[0][i]), 0, 7)
          else
          OppEdits[i].Text:='';
        end;
      end;
      GenerateProbFull(ByteCards, Mask);
      for i:=2 to 10 do
      begin
        if Mask[i] then
        ResEdits[i].Text:='��'
        else
        ResEdits[i].Text:='';
      end;
    end;
    Stop:=Now;
    ResEdits[11].Text:=IntToStr(MilliSecondsBetween(Start, Stop));
  end
  else
  ShowMessage('������. ��������� ������������ �����.');
end;

procedure TForm1.Button3Click(Sender: TObject);
var i: Byte;
begin
  for i:=1 to 7 do
  begin
    SBox[i].Text:='';
    NBox[i].Text:='';
    ResEdits[i].Text:='';
  end;
  for i:=8 to 11 do
  ResEdits[i].Text:='';
end;

end.
