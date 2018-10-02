#!/bin/sh

export LD_LIBRARY_PATH="./import/"
export DYLD_LIBRARY_PATH="./import/"

export CLASSPATH=./import/antlr-4.7-complete.jar:./import/commons-io-2.5.jar:./import/com.microsoft.z3.jar:./import/commons-cli-1.4.jar:./bin/

mkdir -p bin

java -jar import/antlr-4.7-complete.jar Model.g4 -o target/generated-sources/antlr4/dartagnan/

java -jar import/antlr-4.7-complete.jar Porthos.g4 -o target/generated-sources/antlr4/dartagnan/

java -jar import/antlr-4.7-complete.jar LitmusC.g4 -no-listener -visitor -o target/generated-sources/antlr4/dartagnan/

java -jar import/antlr-4.7-complete.jar LitmusPPC.g4 -no-listener -visitor -o target/generated-sources/antlr4/dartagnan/

java -jar import/antlr-4.7-complete.jar LitmusX86.g4 -no-listener -visitor -o target/generated-sources/antlr4/dartagnan/

javac \
src/dartagnan/Dartagnan.java \
src/dartagnan/DartagnanIdlTest.java \
src/dartagnan/asserts/AbstractAssert.java \
src/dartagnan/asserts/AbstractAssertComposite.java \
src/dartagnan/asserts/AssertBasic.java \
src/dartagnan/asserts/AssertCompositeAnd.java \
src/dartagnan/asserts/AssertCompositeOr.java \
src/dartagnan/asserts/AssertNot.java \
src/dartagnan/expression/AConst.java \
src/dartagnan/expression/AExpr.java \
src/dartagnan/expression/Atom.java \
src/dartagnan/expression/BConst.java \
src/dartagnan/expression/BExpr.java \
src/dartagnan/expression/ExprInterface.java \
src/dartagnan/expression/IntExprInterface.java \
src/dartagnan/parsers/utils/branch/BareIf.java \
src/dartagnan/parsers/utils/ParserErrorListener.java \
src/dartagnan/parsers/utils/ParsingException.java \
src/dartagnan/parsers/visitors/VisitorLitmusC.java \
src/dartagnan/parsers/visitors/VisitorLitmusPPC.java \
src/dartagnan/parsers/visitors/VisitorLitmusX86.java \
src/dartagnan/parsers/ParserInterface.java \
src/dartagnan/parsers/ParserLitmusC.java \
src/dartagnan/parsers/ParserLitmusPPC.java \
src/dartagnan/parsers/ParserLitmusX86.java \
src/dartagnan/parsers/ParserResolver.java \
src/dartagnan/program/event/filter/FilterAbstract.java \
src/dartagnan/program/event/filter/FilterBasic.java \
src/dartagnan/program/event/filter/FilterIntersection.java \
src/dartagnan/program/event/filter/FilterMinus.java \
src/dartagnan/program/event/filter/FilterUnion.java \
src/dartagnan/program/event/filter/FilterUtils.java \
src/dartagnan/program/event/linux/rcu/RCUReadLock.java \
src/dartagnan/program/event/linux/rcu/RCUReadUnlock.java \
src/dartagnan/program/event/linux/rcu/RCUSync.java \
src/dartagnan/program/event/linux/rmw/RMWAbstract.java \
src/dartagnan/program/event/linux/rmw/RMWAddUnless.java \
src/dartagnan/program/event/linux/rmw/RMWCmpXchg.java \
src/dartagnan/program/event/linux/rmw/RMWFetchOp.java \
src/dartagnan/program/event/linux/rmw/RMWOp.java \
src/dartagnan/program/event/linux/rmw/RMWOpAndTest.java \
src/dartagnan/program/event/linux/rmw/RMWOpReturn.java \
src/dartagnan/program/event/linux/rmw/RMWXchg.java \
src/dartagnan/program/event/rmw/RMWStore.java \
src/dartagnan/program/event/rmw/Xchg.java \
src/dartagnan/program/event/rmw/cond/FenceCond.java \
src/dartagnan/program/event/rmw/cond/RMWReadCond.java \
src/dartagnan/program/event/rmw/cond/RMWReadCondCmp.java \
src/dartagnan/program/event/rmw/cond/RMWReadCondUnless.java \
src/dartagnan/program/event/rmw/cond/RMWStoreCond.java \
src/dartagnan/program/event/Event.java \
src/dartagnan/program/event/Fence.java \
src/dartagnan/program/event/If.java \
src/dartagnan/program/event/Init.java \
src/dartagnan/program/event/Load.java \
src/dartagnan/program/event/Local.java \
src/dartagnan/program/event/MemEvent.java \
src/dartagnan/program/event/OptFence.java \
src/dartagnan/program/event/Read.java \
src/dartagnan/program/event/Skip.java  \
src/dartagnan/program/event/Store.java \
src/dartagnan/program/event/Write.java \
src/dartagnan/program/HighLocation.java \
src/dartagnan/program/Location.java \
src/dartagnan/program/Program.java \
src/dartagnan/program/Register.java \
src/dartagnan/program/Seq.java  \
src/dartagnan/program/Thread.java \
src/dartagnan/program/While.java \
src/dartagnan/program/utils/EventRepository.java \
src/dartagnan/utils/GraphViz.java \
src/dartagnan/utils/MapSSA.java \
src/dartagnan/utils/Pair.java \
src/dartagnan/utils/Utils.java \
src/dartagnan/wmm/axiom/Acyclic.java \
src/dartagnan/wmm/axiom/Axiom.java \
src/dartagnan/wmm/axiom/Empty.java \
src/dartagnan/wmm/axiom/Irreflexive.java \
src/dartagnan/wmm/relation/basic/BasicRelation.java \
src/dartagnan/wmm/relation/basic/RelCartesian.java \
src/dartagnan/wmm/relation/basic/RelCo.java \
src/dartagnan/wmm/relation/basic/RelCrit.java \
src/dartagnan/wmm/relation/basic/RelCtrlDirect.java \
src/dartagnan/wmm/relation/basic/RelEmpty.java \
src/dartagnan/wmm/relation/basic/RelExt.java \
src/dartagnan/wmm/relation/basic/RelFencerel.java \
src/dartagnan/wmm/relation/basic/RelId.java \
src/dartagnan/wmm/relation/basic/RelIdd.java \
src/dartagnan/wmm/relation/basic/RelInt.java \
src/dartagnan/wmm/relation/basic/RelLoc.java \
src/dartagnan/wmm/relation/basic/RelPo.java \
src/dartagnan/wmm/relation/basic/RelRf.java \
src/dartagnan/wmm/relation/basic/RelRMW.java \
src/dartagnan/wmm/relation/basic/RelSetIdentity.java \
src/dartagnan/wmm/relation/binary/BinaryRelation.java \
src/dartagnan/wmm/relation/binary/RelComposition.java \
src/dartagnan/wmm/relation/binary/RelIntersection.java \
src/dartagnan/wmm/relation/binary/RelMinus.java \
src/dartagnan/wmm/relation/binary/RelUnion.java \
src/dartagnan/wmm/relation/unary/RelInverse.java \
src/dartagnan/wmm/relation/unary/RelTrans.java \
src/dartagnan/wmm/relation/unary/RelTransRef.java \
src/dartagnan/wmm/relation/unary/UnaryRelation.java \
src/dartagnan/wmm/relation/RecursiveRelation.java \
src/dartagnan/wmm/relation/Relation.java \
src/dartagnan/wmm/utils/RecursiveGroup.java \
src/dartagnan/wmm/utils/RelationRepository.java \
src/dartagnan/wmm/utils/Tuple.java \
src/dartagnan/wmm/utils/TupleSet.java \
src/dartagnan/wmm/Encodings.java \
src/dartagnan/wmm/WmmResolver.java \
src/dartagnan/wmm/Wmm.java \
src/porthos/Porthos.java \
target/generated-sources/antlr4/dartagnan/LitmusCBaseVisitor.java \
target/generated-sources/antlr4/dartagnan/LitmusCLexer.java \
target/generated-sources/antlr4/dartagnan/LitmusCParser.java \
target/generated-sources/antlr4/dartagnan/LitmusCVisitor.java \
target/generated-sources/antlr4/dartagnan/LitmusPPCBaseVisitor.java \
target/generated-sources/antlr4/dartagnan/LitmusPPCLexer.java \
target/generated-sources/antlr4/dartagnan/LitmusPPCParser.java \
target/generated-sources/antlr4/dartagnan/LitmusPPCVisitor.java \
target/generated-sources/antlr4/dartagnan/LitmusX86BaseVisitor.java \
target/generated-sources/antlr4/dartagnan/LitmusX86Lexer.java \
target/generated-sources/antlr4/dartagnan/LitmusX86Parser.java \
target/generated-sources/antlr4/dartagnan/LitmusX86Visitor.java \
target/generated-sources/antlr4/dartagnan/ModelBaseListener.java \
target/generated-sources/antlr4/dartagnan/ModelLexer.java \
target/generated-sources/antlr4/dartagnan/ModelListener.java \
target/generated-sources/antlr4/dartagnan/ModelParser.java \
target/generated-sources/antlr4/dartagnan/PorthosBaseListener.java \
target/generated-sources/antlr4/dartagnan/PorthosLexer.java \
target/generated-sources/antlr4/dartagnan/PorthosListener.java \
target/generated-sources/antlr4/dartagnan/PorthosParser.java \
-d bin
