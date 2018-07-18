// Define a grammar called model
grammar Model;
@header{
package dartagnan;
import dartagnan.wmm.axiom.*;
import dartagnan.wmm.relation.*;
import dartagnan.wmm.Wmm;
}
@parser::members
{
private Wmm wmm = new Wmm();
}
mcm returns [Wmm value]:
MCMNAME? (ax1=axiom {wmm.addAxiom($ax1.value);} | r1=reldef {wmm.addRel($r1.value);})+ {$value = wmm;}
;

axiom returns [Axiom value]
 : (negate = TILDE)? 'acyclic' m1=fancyrel  {$value =  new Acyclic($m1.value, $negate != null);} ('as' NAME)?
 | (negate = TILDE)? 'irreflexive' m1=fancyrel {$value =  new Irreflexive($m1.value, $negate != null);}('as' NAME)?
 | (negate = TILDE)? 'empty' m1=fancyrel {$value =  new Empty($m1.value, $negate != null);}('as' NAME)?;

reldef returns [Relation value]:
('let' | 'and') ('rec')? n=NAME '=' m1=fancyrel {$value =$m1.value; $value.setName($n.text);};

fancyrel returns [Relation value]:
m1=relation {$value =$m1.value;} ('|' m2=relation {$value =new RelUnion($value, $m2.value);} )*
| m1=relation {$value =$m1.value;} ('&' m2=relation {$value =new RelInterSect($value, $m2.value);} )*
| m1=relation {$value =$m1.value;} (';' m2=relation {$value =new RelComposition($value, $m2.value);} )*;
relation returns [Relation value]: 
b1=base {$value =$b1.value;} 
| '(' ( m1=relation '|' {$value =$m1.value;}) ( m2=relation '|' {$value =new RelUnion($value, $m2.value);} )* m3=relation ')'{$value =new RelUnion($value, $m3.value);} 
| '(' m1=relation '\\' m2=relation ')' {$value =new RelMinus($m1.value, $m2.value);}
| '(' m1=relation '&' m2=relation ')' {$value =new RelInterSect($m1.value, $m2.value);}
| '(' ( m1=relation ';' {$value =$m1.value;}) ( m2=relation ';' {$value =new RelComposition($value, $m2.value);} )* m3=relation ')'{$value =new RelComposition($value, $m3.value);} 
| m1=relation'+' {$value =new RelTrans($m1.value);}
| m1=relation'*' {$value =new RelTransRef($m1.value);}
| '(' m1=relation ')' {$value =$m1.value;}
;


base returns [Relation value]: 
PO {$value=new BasicRelation("po");}
| POLOC {$value=new BasicRelation("po-loc");}
| RFE {$value=new BasicRelation("rfe");}
| RFI {$value=new BasicRelation("rfi");}
| RF {$value=new BasicRelation("rf");}
| FR {$value=new BasicRelation("fr");}
| FRI {$value=new BasicRelation("fri");}
| FRE {$value=new BasicRelation("fre");}
| CO {$value=new BasicRelation("co");}
| COE {$value=new BasicRelation("coe");}
| COI {$value=new BasicRelation("coi");}
| AD {$value=new BasicRelation("po");}
| IDD {$value=new BasicRelation("idd");}
| CD {$value=new BasicRelation("cd");}
| STHD {$value=new BasicRelation("sthd");}
| SLOC {$value=new BasicRelation("sloc");}
| CTRLISYNC {wmm.addFenceRelation(new RelFencerel("Isync", "isync")); $value=new BasicRelation("ctrlisync");}
| CTRLISB {wmm.addFenceRelation(new RelFencerel("Isb", "isb")); $value=new BasicRelation("ctrlisb");}
| MFENCE {$value=new RelFencerel("Mfence", "mfence"); wmm.addFenceRelation((RelFencerel)$value);}
| LWSYNC {$value=new RelFencerel("Lwsync", "lwsync"); wmm.addFenceRelation((RelFencerel)$value);}
| LWSYNC {$value=new RelFencerel("Isync", "isync"); wmm.addFenceRelation((RelFencerel)$value);}
| LWSYNC {$value=new RelFencerel("Sync", "sync"); wmm.addFenceRelation((RelFencerel)$value);}
| ISB {$value=new RelFencerel("Isb", "isb"); wmm.addFenceRelation((RelFencerel)$value);}
| ISH {$value=new RelFencerel("Ish", "ish"); wmm.addFenceRelation((RelFencerel)$value);}
| CTRLDIREKT {$value=new BasicRelation("ctrlDirect");}
| CTRL {$value=new BasicRelation("ctrl");}
| ADDR {$value=new EmptyRel();}
| DATA {$value=new RelInterSect(new RelLocTrans(new BasicRelation("idd")), new BasicRelation("RW"));}
| n=NAME {$value=new RelDummy($n.text);}
| EMPTY {$value=new EmptyRel();}
| ID {$value=new BasicRelation("id");}
| 'R' '*' 'W' {$value=new BasicRelation("RW");}
| 'W' '*' 'R' {$value=new BasicRelation("WR");}
| 'R' '*' 'R' {$value=new BasicRelation("RR");}
| 'W' '*' 'W' {$value=new BasicRelation("WW");}
| 'R' '*' 'M' {$value=new BasicRelation("RM");}
| 'W' '*' 'M' {$value=new BasicRelation("WM");}
| 'M' '*' 'R' {$value=new BasicRelation("MR");}
| 'M' '*' 'W' {$value=new BasicRelation("MW");}
| 'M' '*' 'M' {$value=new BasicRelation("MM");}
| 'I' '*' 'R' {$value=new BasicRelation("IR");}
| 'I' '*' 'W' {$value=new BasicRelation("IW");}
| 'I' '*' 'M' {$value=new BasicRelation("IM");}
| 'A' '*' 'M' {$value=new BasicRelation("AM");}
| 'M' '*' 'A' {$value=new BasicRelation("MA");}
;

PO : 'po' ;
POLOC : 'po-loc' ;
RFE : 'rfe' ;
RFI : 'rfi' ;
RF : 'rf' ;
FR : 'fr' ;
FRE : 'fre' ;
FRI : 'fri' ;
CO : 'co' ;
COE : 'coe' ;
COI : 'coi' ;
AD : 'ad' ;
IDD : 'idd' ;
ISH : 'ish' ;
CD : 'cd' ;
STHD : 'sthd' ;
SLOC : 'sloc' ;
MFENCE : 'mfence' ;
LWSYNC : 'lwsync' ;
CTRLISYNC : 'ctrlisync' ;
ISYNC : 'isync' ;
SYNC : 'sync' ;
CTRLDIREKT : 'ctrlDirect';
CTRLISB : 'ctrlisb';
CTRL : 'ctrl';
ISB : 'isb' ;
ADDR : 'addr' ;
DATA : 'data' ;
ID : 'id' ;
EMPTY : '0' ;

TILDE : '~';

NAME : [a-z0-9\-]+ ;        // match lower-case identifiers
MCMNAME : [A-Za-z0-9]+ ;        // match lower-case identifiers
WS : [ \t\n\r]+ -> skip ; // skip spaces, tabs, newlines
ENDE : EOF -> skip ;
ML_COMMENT  : '(*' .*? '*)' -> skip ;
INCLUDE  : 'include "' .*? '"' -> skip ; //skip include refs
MODELNAME  : '"' .*? '"' -> skip ; //skip names
