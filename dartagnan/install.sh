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
src/dartagnan/parsers/utils/Utils.java \
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
src/dartagnan/program/event/lock/RCULock.java \
src/dartagnan/program/event/lock/RCUUnlock.java \
src/dartagnan/program/event/rmw/AbstractRMW.java \
src/dartagnan/program/event/rmw/RMWStore.java \
src/dartagnan/program/event/rmw/RMWStoreIf.java \
src/dartagnan/program/event/rmw/RMWStoreUnless.java \
src/dartagnan/program/event/rmw/Xchg.java \
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
src/dartagnan/utils/Encodings.java \
src/dartagnan/utils/GraphViz.java \
src/dartagnan/utils/LastModMap.java \
src/dartagnan/utils/MapSSA.java \
src/dartagnan/utils/Pair.java \
src/dartagnan/utils/PredicateUtils.java \
src/dartagnan/utils/Utils.java \
src/dartagnan/wmm/axiom/Acyclic.java \
src/dartagnan/wmm/arch/Alpha.java \
src/dartagnan/wmm/arch/ARM.java \
src/dartagnan/wmm/axiom/Axiom.java \
src/dartagnan/wmm/relation/BasicRelation.java \
src/dartagnan/wmm/relation/BinaryRelation.java \
src/dartagnan/wmm/Domain.java \
src/dartagnan/wmm/axiom/Empty.java \
src/dartagnan/wmm/relation/EmptyRel.java \
src/dartagnan/wmm/Encodings.java \
src/dartagnan/wmm/EncodingsCAT.java \
src/dartagnan/wmm/axiom/Irreflexive.java \
src/dartagnan/wmm/arch/Power.java \
src/dartagnan/wmm/arch/PSO.java \
src/dartagnan/wmm/relation/Relation.java \
src/dartagnan/wmm/relation/RelCartesian.java \
src/dartagnan/wmm/relation/RelComposition.java \
src/dartagnan/wmm/relation/RelDummy.java \
src/dartagnan/wmm/relation/RelFencerel.java \
src/dartagnan/wmm/relation/RelInterSect.java \
src/dartagnan/wmm/relation/RelInverse.java \
src/dartagnan/wmm/relation/RelMinus.java \
src/dartagnan/wmm/relation/RelRMW.java \
src/dartagnan/wmm/relation/RelSetIdentity.java \
src/dartagnan/wmm/relation/RelTrans.java \
src/dartagnan/wmm/relation/RelTransRef.java \
src/dartagnan/wmm/relation/RelUnion.java \
src/dartagnan/wmm/arch/RMO.java \
src/dartagnan/wmm/arch/SC.java \
src/dartagnan/wmm/arch/TSO.java \
src/dartagnan/wmm/relation/UnaryRelation.java \
src/dartagnan/wmm/WmmInterface.java \
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
