#define TOTAL_DATA_LEN 59
#define NUMBER_OF_FIELDS 5
#define N_BitFIELDS 9
const char* Bit_fields[] = {
"BitPand3"
,"Bit1and2"
,"BitW"
,"BitFault"
,"eBit"
,"fBit"
,"WarmSummary"
,"ManipMotStat1"
,"ManipMotStat2"
};

const unsigned int Bit_fieldsmap[] = {
39
,40
,41
,42
,44
,49
,50
,51
,52
};

#define N_BitDialogFIELDS 8
const char* BitDialog_fields[] = {
"LaserDist"
,"Tilt"
,"RWSpeedCmd"
,"LWSpeedCmd"
,"HVer"
,"expnum_2"
,"expnum_3"
,"LedsOn"
};

const unsigned int BitDialog_fieldsmap[] = {
13
,22
,34
,35
,43
,45
,46
,53
};

#define N_ManipFIELDS 7
const char* Manip_fields[] = {
"Y"
,"X"
,"Tht"
,"LD"
,"RD"
,"Mbit"
,"ManStat"
};

const unsigned int Manip_fieldsmap[] = {
17
,18
,19
,20
,21
,47
,48
};

#define N_NavDescFIELDS 15
const char* NavDesc_fields[] = {
"Heading"
,"Roll"
,"Pitch"
,"TotalMsgCounter"
,"DevAge"
,"QrX"
,"QrY"
,"PosX"
,"PosY"
,"PosZ"
,"Unused1"
,"DevAz"
,"DevOffset"
,"Unused2"
,"QrAz"
};

const unsigned int NavDesc_fieldsmap[] = {
14
,15
,16
,27
,28
,29
,30
,31
,32
,33
,54
,55
,56
,57
,58
};

#define N_baseFIELDS 20
const char* base_fields[] = {
"V36"
,"VBat54"
,"Volts24"
,"Volts12"
,"Current1"
,"Current2"
,"Current3"
,"Current4"
,"Current5"
,"NeckDiff"
,"ROuterPos"
,"LOuterPos"
,"NOuterPos"
,"cmdrsteerRadSec"
,"cmdlsteerRadSec"
,"cmdneckRadSec"
,"TimeElapseMsec"
,"REnc"
,"LEnc"
,"NEnc"
};

const unsigned int base_fieldsmap[] = {
0
,1
,2
,3
,4
,5
,6
,7
,8
,9
,10
,11
,12
,23
,24
,25
,26
,36
,37
,38
};

const int unsigned str_len[5]={9,8,7,15,20};
const char** str_ptr[5]={Bit_fields,BitDialog_fields,Manip_fields,NavDesc_fields,base_fields};
const int unsigned* map_ptr[5]={Bit_fieldsmap,BitDialog_fieldsmap,Manip_fieldsmap,NavDesc_fieldsmap,base_fieldsmap};
const char* struct_names[5] = {"Bit","BitDialog","Manip","NavDesc","base"};

int FieldTypes[59]={
1, // V36 of  base
1, // VBat54 of  base
1, // Volts24 of  base
1, // Volts12 of  base
1, // Current1 of  base
1, // Current2 of  base
1, // Current3 of  base
1, // Current4 of  base
1, // Current5 of  base
1, // NeckDiff of  base
1, // ROuterPos of  base
1, // LOuterPos of  base
1, // NOuterPos of  base
1, // LaserDist of  BitDialog
1, // Heading of  NavDesc
1, // Roll of  NavDesc
1, // Pitch of  NavDesc
1, // Y of  Manip
1, // X of  Manip
1, // Tht of  Manip
1, // LD of  Manip
1, // RD of  Manip
1, // Tilt of  BitDialog
1, // cmdrsteerRadSec of  base
1, // cmdlsteerRadSec of  base
1, // cmdneckRadSec of  base
0, // TimeElapseMsec of  base
0, // TotalMsgCounter of  NavDesc
0, // DevAge of  NavDesc
0, // QrX of  NavDesc
0, // QrY of  NavDesc
0, // PosX of  NavDesc
0, // PosY of  NavDesc
0, // PosZ of  NavDesc
0, // RWSpeedCmd of  BitDialog
0, // LWSpeedCmd of  BitDialog
0, // REnc of  base
0, // LEnc of  base
0, // NEnc of  base
0, // BitPand3 of  Bit
0, // Bit1and2 of  Bit
0, // BitW of  Bit
0, // BitFault of  Bit
0, // HVer of  BitDialog
0, // eBit of  Bit
0, // expnum_2 of  BitDialog
0, // expnum_3 of  BitDialog
0, // Mbit of  Manip
0, // ManStat of  Manip
0, // fBit of  Bit
0, // WarmSummary of  Bit
0, // ManipMotStat1 of  Bit
0, // ManipMotStat2 of  Bit
0, // LedsOn of  BitDialog
0, // Unused1 of  NavDesc
0, // DevAz of  NavDesc
0, // DevOffset of  NavDesc
0, // Unused2 of  NavDesc
0 // QrAz of  NavDesc
};
