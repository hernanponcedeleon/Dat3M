// Define a grammar called model
grammar Model;
@header{
package dartagnan;
import dartagnan.wmm.*;
}
@parser::members
{
private Wmm wmm = new Wmm();
}
mcm returns [Wmm value]:
MCMNAME? (ax1=axiom {wmm.addAxiom($ax1.value);} | r1=reldef {wmm.addRel($r1.value);})+ {$value = wmm;}
;

axiom returns [Axiom value]: 'acyclic' m1=fancyrel  {$value =  new Acyclic($m1.value);} ('as' NAME)?| 'irreflexive' m1=fancyrel {$value =  new Irreflexive($m1.value);}('as' NAME)?;

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
;



base returns [Relation value]: 
PO {$value=new BasicRelation("po");}
| POLOC {$value=new BasicRelation("poloc");}
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
| ISH {wmm.addFence("ish"); $value=new BasicRelation("ish");}
| CD {$value=new BasicRelation("cd");}
| STHD {$value=new BasicRelation("sthd");}
| SLOC {$value=new BasicRelation("sloc");}
| MFENCE {wmm.addFence("mfence"); $value=new BasicRelation("mfence");}
| CTRLISYNC {wmm.addFence("isync"); $value=new BasicRelation("ctrlisync");}
| LWSYNC {wmm.addFence("lwsync"); $value=new BasicRelation("lwsync");}
| ISYNC {wmm.addFence("isync"); $value=new BasicRelation("isync");}
| SYNC {wmm.addFence("sync"); $value=new BasicRelation("sync");}
| CTRLDIREKT {$value=new BasicRelation("ctrlDirect");}
| CTRLISB {wmm.addFence("isb"); $value=new BasicRelation("ctrlisb");}
| CTRL {$value=new BasicRelation("ctrl");}
| ISB {wmm.addFence("isb"); $value=new BasicRelation("isb");}
| ADDR {$value=new EmptyRel();}
| DATA {$value=new RelInterSect(new RelLocTrans(new BasicRelation("idd")), new BasicRelation("RW"));}
| n=NAME {$value=new RelDummy($n.text);}
| EMPTY {$value=new EmptyRel();}
| RW {$value=new BasicRelation("RW");}
| WR {$value=new BasicRelation("WR");}
| RR {$value=new BasicRelation("RR");}
| WW {$value=new BasicRelation("WW");}
| RM {$value=new BasicRelation("RM");}
| WM {$value=new BasicRelation("WM");}
| MR {$value=new BasicRelation("MR");}
| MW {$value=new BasicRelation("MW");}
| MM {$value=new BasicRelation("MM");}
| IR {$value=new BasicRelation("IR");}
| IW {$value=new BasicRelation("IW");}
| IM {$value=new BasicRelation("IM");}
| ID {$value=new BasicRelation("id");}
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
RW : 'R*W' ;
WR : 'W*R' ;
RR : 'R*R' ;
WW : 'W*W' ;
RM : 'R*M' ;
WM : 'W*M' ;
MR : 'M*R' ;
MW : 'M*W' ;
MM : 'M*M' ;
IR : 'I*R' ;
IW : 'I*W' ;
IM : 'I*M' ;
EMPTY : '0' ;

NAME : [a-z0-9\-]+ ;        // match lower-case identifiers
MCMNAME : [A-Za-z0-9]+ ;        // match lower-case identifiers
WS : [ \t\n\r]+ -> skip ; // skip spaces, tabs, newlines
ENDE : EOF -> skip ;
ML_COMMENT  : '(*' .*? '*)' -> skip ;
INCLUDE  : 'include "' .*? '"' -> skip ; //skip include refs
MODELNAME  : '"' .*? '"' -> skip ; //skip names
