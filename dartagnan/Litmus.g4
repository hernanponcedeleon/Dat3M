grammar Litmus;

@header{
package dartagnan;
import dartagnan.program.*;
import dartagnan.expression.*;
import dartagnan.program.Thread;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.List;
}
@parser::members
{
private Map<String, Location> mapLocs = new HashMap<String, Location>();
private Map<String, Map<String, Register>> mapRegs = new HashMap<String, Map<String, Register>>();
private Map<String, Map<String, Location>> mapRegLoc = new HashMap<String, Map<String, Location>>();
private Map<String, Location> mapLoc = new HashMap<String, Location>();
private Map<String, List<Thread>> mapThreads = new HashMap<String, List<Thread>>();
}

program [String name] returns [Program p]:
	{
		Program p = new Program(name);
		p.setAss(new Assert());
	}
	('PPC' | 'X86') headerComments

	'{' inits '}'

	 threadsList = threads
	{
		for(Thread t : $threadsList.lst) {
			p.add(t);
		}
		$p = p;
	}

	bottomComments

	'exists' '(' assertion[p] ')'
	;

inits : (initLocation | initRegister | initRegisterLocation)* ;

initLocation : l = location '=' DIGIT ';' {mapLocs.put($l.loc.getName(), $l.loc);};

initRegister : (LETTER)* thrd = DIGIT ':' r = registerPower '=' d = DIGIT ';'
    {
        Register regPointer = $r.reg;
        if(!mapRegs.keySet().contains($thrd.getText())) {
            mapRegs.put($thrd.getText(), new HashMap<String, Register>());
        }
        mapRegs.get($thrd.getText()).put(regPointer.getName(), regPointer);
        if(!mapThreads.keySet().contains($thrd.getText())) {
            mapThreads.put($thrd.getText(), new ArrayList<Thread>());
        }
        mapThreads.get($thrd.getText()).add(new Local(regPointer, new AConst(Integer.parseInt($d.getText()))));
    };

initRegisterLocation : (LETTER)* thrd = DIGIT ':' r = registerPower '=' l = location ';'
    {
        if(!mapRegLoc.keySet().contains($thrd.getText())) {
            mapRegLoc.put($thrd.getText(), new HashMap<String, Location>());
        }
        if(!mapLoc.keySet().contains($l.loc.getName())) {
            mapLoc.put($l.loc.getName(), $l.loc);
        }
        mapRegLoc.get($thrd.getText()).put($r.reg.getName(), mapLoc.get($l.loc.getName()));
    };


assertion [Program p] : ((
    l = location '=' value = DIGIT
    {
        Location loc = $l.loc;
        p.getAss().addPair(loc, Integer.parseInt($value.getText()));
    }
    |
    thrd = DIGIT ':' r = registerPower '=' value = DIGIT
    {
        Register regPointer = $r.reg;
        Register reg = mapRegs.get($thrd.getText()).get(regPointer.getName());
        p.getAss().addPair(reg, Integer.parseInt($value.getText()));
    }
    |
    thrd = DIGIT ':' rx = registerX86 '=' value = DIGIT
        {
            Register regPointer = $rx.reg;
            Register reg = mapRegs.get($thrd.getText()).get(regPointer.getName());
            p.getAss().addPair(reg, Integer.parseInt($value.getText()));
        }
    )
    (bop)?
    )+;

bop : '/\\';

headerComments : ~('{')*;
bottomComments : ~('exists')*;

word returns [String str]:
	w = (LETTER | DIGIT)+ {$str = $w.getText();};

location returns [Location loc]:
	l = LETTER (LETTER | DIGIT)* {$loc = new Location($l.getText());};

locationX86 returns [Location loc]:
	'[' l = location ']' {$loc = $l.loc;};

registerPower returns [Register reg]:
	r = ('r0' | 'r1' | 'r2' | 'r3' | 'r4' | 'r5' | 'r6' | 'r7' | 'r8' | 'r9' |  'r10' |  'r11' |  'r12' |  'r13' |  'r14') {$reg = new Register($r.getText());};
registerX86 returns [Register reg]:
	r = ('EAX' | 'EBX' | 'ECX' | 'EDX') {$reg = new Register($r.getText());};

threads returns [List<Thread> lst]:
	(mainThread = word
	{
		if(!mapRegs.keySet().contains($mainThread.str)) {
			mapRegs.put($mainThread.str, new HashMap<String, Register>());
		}
	}
	('|')*)+  ';'
	{Integer thread = 0;}
	(t1 = inst [thread.toString()] {
		if(!mapThreads.keySet().contains(thread.toString())) {
				mapThreads.put(thread.toString(), new ArrayList<Thread>());
		}
		mapThreads.get(thread.toString()).add($t1.t);
	}
	({thread ++;} '|' (t2 = inst [thread.toString()] | WS) {
		if(!mapThreads.keySet().contains(thread.toString())) {
				mapThreads.put(thread.toString(), new ArrayList<Thread>());
		}
		mapThreads.get(thread.toString()).add($t2.t);
	}
	)* ';' {thread = 0;})+
	{
		List threads = new ArrayList<Thread>();
		for(String k : mapThreads.keySet()) {
			If lastIf = null;
			Thread partialThread = null;
			Thread partialIfBody = null;
			for(Thread t : mapThreads.get(k)) {
				if(t != null) {
					if(partialThread == null && lastIf == null) {
						partialThread = t;
					}
					else if(lastIf == null){
						partialThread = new Seq(partialThread, t);
					}
					if(partialIfBody == null) {
						partialIfBody = t;
					}
					else {
						partialIfBody = new Seq(partialIfBody, t);
					}
					if(t instanceof If) {
						if(lastIf != null) {
							partialIfBody.incCondLevel();
							lastIf.setT1(partialIfBody);
						}
						partialIfBody = null;
						lastIf = (If) t;
					}
				}
			}
			if(lastIf != null && partialIfBody != null) {
				partialIfBody.setCondLevel(lastIf.getCondLevel()+1);
				lastIf.setT1(partialIfBody);
			}
			threads.add(partialThread);
		}
		$lst = threads;
	};

inst [String mainThread] returns [Thread t]:
	| t1 = localX86 [mainThread] {$t = $t1.t;}
	| t2 = loadX86 [mainThread] {$t = $t2.t;}
	| t3 = storeX86reg [mainThread] {$t = $t3.t;}
	| t4 = storeX86val [mainThread] {$t = $t4.t;}
	| t5 = mfence {$t = $t5.t;}
	| t6 = localPower [mainThread] {$t = $t6.t;}
	| t7 = loadPower [mainThread] {$t = $t7.t;}
	| t8 = storePower [mainThread] {$t = $t8.t;}
	| t9 = isync {$t = $t9.t;}
	| t10 = sync {$t = $t10.t;}
	| t11 = lwsync {$t = $t11.t;}
	| t12 = xor [mainThread] {$t = $t12.t;}
	| t13 = addi [mainThread] {$t = $t13.t;}
	| t14 = mr [mainThread] {$t = $t14.t;}
	| t15 = cmpw [mainThread] {$t = $t15.t;}
	| 'beq' 'LC' word
	| 'LC' word ':'
	;

localX86 [String mainThread] returns [Thread t]:
	'MOV' r = registerX86 ',$' d = DIGIT {
		Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
		if(!(mapThreadRegs.keySet().contains($r.reg.getName()))) {
			mapThreadRegs.put($r.reg.getName(), $r.reg);
		}
		Register pointerReg = mapThreadRegs.get($r.reg.getName());
		$t = new Local(pointerReg, new AConst(Integer.parseInt($d.getText())));
	};

localPower [String mainThread] returns [Thread t]:
	'li' r = registerPower ',' d = DIGIT {
		Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
		if(!(mapThreadRegs.keySet().contains($r.reg.getName()))) {
			mapThreadRegs.put($r.reg.getName(), $r.reg);
		}
		Register pointerReg = mapThreadRegs.get($r.reg.getName());
		$t = new Local(pointerReg, new AConst(Integer.parseInt($d.getText())));
	};

xor [String mainThread] returns [Thread t]:
	'xor' r1 = registerPower ',' r2 = registerPower ',' r3 = registerPower {
		Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
		if(!(mapThreadRegs.keySet().contains($r1.reg.getName()))) {
			mapThreadRegs.put($r1.reg.getName(), $r1.reg);
		}
		if(!(mapThreadRegs.keySet().contains($r2.reg.getName()))) {
			mapThreadRegs.put($r2.reg.getName(), $r2.reg);
		}
		if(!(mapThreadRegs.keySet().contains($r3.reg.getName()))) {
			mapThreadRegs.put($r3.reg.getName(), $r3.reg);
		}
		Register pointerReg1 = mapThreadRegs.get($r1.reg.getName());
		Register pointerReg2 = mapThreadRegs.get($r2.reg.getName());
		Register pointerReg3 = mapThreadRegs.get($r3.reg.getName());
		$t = new Local(pointerReg1, new AExpr(pointerReg2, "xor", pointerReg3));
	};

// TODO: Add negative digits
addi [String mainThread] returns [Thread t]:
	'addi' r1 = registerPower ',' r2 = registerPower ',' d = DIGIT {
		Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
		if(!(mapThreadRegs.keySet().contains($r1.reg.getName()))) {
			mapThreadRegs.put($r1.reg.getName(), $r1.reg);
		}
		if(!(mapThreadRegs.keySet().contains($r2.reg.getName()))) {
			mapThreadRegs.put($r2.reg.getName(), $r2.reg);
		}
		Register pointerReg1 = mapThreadRegs.get($r1.reg.getName());
		Register pointerReg2 = mapThreadRegs.get($r2.reg.getName());
		$t = new Local(pointerReg1, new AExpr(pointerReg2, "+", new AConst(Integer.parseInt($d.getText()))));
	};

mr [String mainThread] returns [Thread t]:
	'mr' r1 = registerPower ',' r2 = registerPower {
		Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
		if(!(mapThreadRegs.keySet().contains($r1.reg.getName()))) {
			mapThreadRegs.put($r1.reg.getName(), $r1.reg);
		}
		if(!(mapThreadRegs.keySet().contains($r2.reg.getName()))) {
			mapThreadRegs.put($r2.reg.getName(), $r2.reg);
		}
		Register pointerReg1 = mapThreadRegs.get($r1.reg.getName());
		Register pointerReg2 = mapThreadRegs.get($r2.reg.getName());
		$t = new Local(pointerReg1, pointerReg2);
	};

loadX86 [String mainThread] returns [Thread t]:
	'MOV' r = registerX86 ',' l = locationX86 {
		Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
		if(!(mapThreadRegs.keySet().contains($r.reg.getName()))) {
			mapThreadRegs.put($r.reg.getName(), $r.reg);
		}
		if(!(mapLocs.keySet().contains($l.loc.getName()))) {
			//System.out.println(String.format("Location %s must be initialized", $l.loc.getName()));
			mapLocs.put($l.loc.getName(), $l.loc);
		}
		Register pointerReg = mapThreadRegs.get($r.reg.getName());
		Location pointerLoc = mapLocs.get($l.loc.getName());
		//$t = new Load(pointerReg, pointerLoc);
		$t = new Read(pointerReg, pointerLoc, "_rx");
	};

loadPower [String mainThread] returns [Thread t]:
	'lwz' r = registerPower ',' s = DIGIT ('(' | ',') rl = registerPower (')')* {
		Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
		if(!(mapThreadRegs.keySet().contains($r.reg.getName()))) {
			mapThreadRegs.put($r.reg.getName(), $r.reg);
		}
		if(!(mapRegLoc.get(mainThread).keySet().contains($rl.reg.getName()))) {
			System.out.println(String.format("Register %s must be initialized to a location", $rl.reg.getName()));
		}
		Register pointerReg = mapThreadRegs.get($r.reg.getName());
		Location pointerLoc = mapRegLoc.get(mainThread).get($rl.reg.getName());
		//$t = new Load(pointerReg, pointerLoc);
		$t = new Read(pointerReg, pointerLoc, "_rx");
	};

storeX86reg [String mainThread] returns [Thread t]:
    'MOV' l = locationX86 ',' r = registerX86 {
        if(!(mapLocs.keySet().contains($l.loc.getName()))) {
            System.out.println(String.format("Location %s must be initialized", $l.loc.getName()));
        }
        Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
        if(!(mapThreadRegs.keySet().contains($r.reg.getName()))) {
            System.out.println(String.format("Register %s must be initialized", $r.reg.getName()));
        }
        Register pointerReg = mapThreadRegs.get($r.reg.getName());
        Location pointerLoc = mapLocs.get($l.loc.getName());
            //$t = new Store(pointerLoc, pointerReg);
            $t = new Write(pointerLoc, pointerReg, "_rx");
        };

storeX86val [String mainThread] returns [Thread t]:
    'MOV' l = locationX86 ',$' value = DIGIT {
    	    if(!(mapLocs.keySet().contains($l.loc.getName()))) {
        		System.out.println(String.format("Location %s must be initialized", $l.loc.getName()));
        	}
        	Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
        	Location pointerLoc = mapLocs.get($l.loc.getName());
        	AConst val = new AConst(Integer.parseInt($value.getText()));
        	$t = new Write(pointerLoc, val, "_rx");
    	};

storePower [String mainThread] returns [Thread t]:
	'stw' r = registerPower ',' s = DIGIT ('(' | ',') rl = registerPower (')')* {
		if(!(mapRegLoc.get(mainThread).keySet().contains($rl.reg.getName()))) {
			System.out.println(String.format("Register %s must be initialized to a location", $rl.reg.getName()));
		}
		Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
		if(!(mapThreadRegs.keySet().contains($r.reg.getName()))) {
			System.out.println(String.format("Register %s must be initialized", $r.reg.getName()));
		}
		Register pointerReg = mapThreadRegs.get($r.reg.getName());
		Location pointerLoc = mapRegLoc.get(mainThread).get($rl.reg.getName());
		//$t = new Store(pointerLoc, pointerReg);
		$t = new Write(pointerLoc, pointerReg, "_rx");
	};

cmpw [String mainThread] returns [Thread t]:
	'cmpw' r1 = registerPower ',' r2 = registerPower {
		Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
		Register pointerReg1 = mapThreadRegs.get($r1.reg.getName());
		Register pointerReg2 = mapThreadRegs.get($r2.reg.getName());
		$t = new If(new Atom(pointerReg1, "==", pointerReg2), new Skip(), new Skip());
	};

mfence returns [Thread t]:
	'MFENCE' {$t = new Mfence();};

lwsync returns [Thread t]:
	LWSYNC {$t = new Lwsync();};

sync returns [Thread t]:
	SYNC {$t = new Sync();};

isync returns [Thread t]:
	ISYNC {$t = new Isync();};

ARCH : X86 | POWER;
X86 : 'x86' | 'X86';
POWER : 'PPC' | 'ppc';

LETTER : 'a'..'z' | 'A'..'Z';
DIGIT : [0-9]+;
MONIO : '~';
SYMBOL : '!' | '\\' | '@' | '#' | '€' | '%' | '&' | '/' | '(' | ')' | '[' | ']' | '$' | '=' | '|' | '?'
		| '+' | '`' | '´' | '^' | '¨' | '*' | ',' | ';' | '.' | ':' | '-' | '_' | '>' | '<' | '"' | '\'';
WS : [ \t\r\n]+ -> skip;

LWSYNC : 'lwsync';
SYNC : 'sync';
ISYNC : 'isync';
