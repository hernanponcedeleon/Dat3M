#!/bin/sh

export LD_LIBRARY_PATH="./import/"
export DYLD_LIBRARY_PATH="./import/"

export CLASSPATH=./import/antlr-4.7-complete.jar:./import/commons-io-2.5.jar:./import/com.microsoft.z3.jar:./import/commons-cli-1.4.jar:./bin/

mkdir -p bin

java -jar import/antlr-4.7-complete.jar Model.g4 -o target/generated-sources/antlr4/dartagnan/

java -jar import/antlr-4.7-complete.jar Porthos.g4 -o target/generated-sources/antlr4/dartagnan/

java -jar import/antlr-4.7-complete.jar LitmusPPC.g4 -no-listener -visitor -o target/generated-sources/antlr4/dartagnan/

java -jar import/antlr-4.7-complete.jar LitmusX86.g4 -no-listener -visitor -o target/generated-sources/antlr4/dartagnan/

javac \
src/dartagnan/Dartagnan.java \
src/dartagnan/asserts/AbstractAssert.java \
src/dartagnan/asserts/AbstractAssertComposite.java \
src/dartagnan/asserts/AssertCompositeAnd.java \
src/dartagnan/asserts/AssertCompositeOr.java \
src/dartagnan/asserts/AssertLocation.java \
src/dartagnan/asserts/AssertNot.java \
src/dartagnan/asserts/AssertRegister.java \
src/dartagnan/expression/AConst.java \
src/dartagnan/expression/AExpr.java \
src/dartagnan/expression/Atom.java \
src/dartagnan/expression/BConst.java \
src/dartagnan/expression/BExpr.java \
src/dartagnan/parsers/utils/branch/BareIf.java \
src/dartagnan/parsers/utils/ParserErrorListener.java \
src/dartagnan/parsers/utils/ParsingException.java \
src/dartagnan/parsers/utils/Utils.java \
src/dartagnan/parsers/visitors/VisitorLitmusPPC.java \
src/dartagnan/parsers/visitors/VisitorLitmusX86.java \
src/dartagnan/parsers/ParserInterface.java \
src/dartagnan/parsers/ParserLitmusPPC.java \
src/dartagnan/parsers/ParserLitmusX86.java \
src/dartagnan/parsers/ParserResolver.java \
src/dartagnan/program/Event.java \
src/dartagnan/program/Fence.java \
src/dartagnan/program/HighLocation.java \
src/dartagnan/program/If.java \
src/dartagnan/program/Init.java \
src/dartagnan/program/Load.java \
src/dartagnan/program/Local.java \
src/dartagnan/program/Location.java \
src/dartagnan/program/MemEvent.java \
src/dartagnan/program/OptFence.java \
src/dartagnan/program/Program.java \
src/dartagnan/program/Read.java \
src/dartagnan/program/Register.java \
src/dartagnan/program/Seq.java  \
src/dartagnan/program/Skip.java  \
src/dartagnan/program/Store.java \
src/dartagnan/program/Thread.java \
src/dartagnan/program/While.java \
src/dartagnan/program/Write.java \
src/dartagnan/utils/Encodings.java \
src/dartagnan/utils/GraphViz.java \
src/dartagnan/utils/LastModMap.java \
src/dartagnan/utils/MapSSA.java \
src/dartagnan/utils/Pair.java \
src/dartagnan/utils/PredicateUtils.java \
src/dartagnan/utils/Utils.java \
src/dartagnan/wmm/Acyclic.java \
src/dartagnan/wmm/Alpha.java \
src/dartagnan/wmm/ARM.java \
src/dartagnan/wmm/Axiom.java \
src/dartagnan/wmm/BasicRelation.java \
src/dartagnan/wmm/BinaryRelation.java \
src/dartagnan/wmm/Consistent.java \
src/dartagnan/wmm/Domain.java \
src/dartagnan/wmm/Empty.java \
src/dartagnan/wmm/EmptyRel.java \
src/dartagnan/wmm/Encodings.java \
src/dartagnan/wmm/EncodingsCAT.java \
src/dartagnan/wmm/Irreflexive.java \
src/dartagnan/wmm/Power.java \
src/dartagnan/wmm/PSO.java \
src/dartagnan/wmm/Relation.java \
src/dartagnan/wmm/RelComposition.java \
src/dartagnan/wmm/RelDummy.java \
src/dartagnan/wmm/RelInterSect.java \
src/dartagnan/wmm/RelInverse.java \
src/dartagnan/wmm/RelLocTrans.java \
src/dartagnan/wmm/RelMinus.java \
src/dartagnan/wmm/RelTrans.java \
src/dartagnan/wmm/RelTransRef.java \
src/dartagnan/wmm/RelUnion.java \
src/dartagnan/wmm/RMO.java \
src/dartagnan/wmm/SC.java \
src/dartagnan/wmm/TSO.java \
src/dartagnan/wmm/UnaryRelation.java \
src/dartagnan/wmm/Wmm.java \
src/porthos/Porthos.java \
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
