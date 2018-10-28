package dartagnan.tests;

import com.microsoft.z3.*;
import dartagnan.Dartagnan;
import dartagnan.program.Program;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.Wmm;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.utils.Tuple;
import dartagnan.wmm.utils.TupleSet;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Collections;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class DartagnanIdlTest {

    private static String[] relations = {
            "idd^+", "ctrl",
            "hb^*", "com^*", "propbase^*", "cumul-fence^*", "pb^*",
            "ii", "ic", "ci", "cc", "rcu-fence"
    };

    private static final int STEPS = 2;
    private static final boolean WARN_ON_IMPOSSIBLE_EXECUTION = true;

    public static void main(String[] args) {
        run("litmus/PPC", "power", "cat/power.cat");
        run("litmus/C", "sc", "cat/linux-kernel.cat");
    }

    private static void run(String testsDirectoryPath, String target, String catFilePath){

        try(Stream<Path> paths = Files.walk(Paths.get(testsDirectoryPath))){
            paths
                    .filter(Files::isRegularFile)
                    .filter(f -> (f.toString().endsWith("litmus") || f.toString().endsWith("pts")))
                    .forEach(f -> {
                        try{
                            Context ctx = new Context();
                            Solver s = ctx.mkSolver(ctx.mkTactic("qfufbv"));
                            Program p = Dartagnan.parseProgram(f.toString());

                            Wmm mcm = new Wmm(catFilePath, target);

                            Program pFP = p.clone();
                            Program pIDL = p.clone();

                            pFP.unroll(STEPS);
                            pIDL.unroll(STEPS);

                            pFP.compile(target, false, true);
                            int startEId = Collections.max(pFP.getEventRepository().getEvents(EventRepository.INIT).stream().map(e -> e.getEId()).collect(Collectors.toSet())) + 1;
                            pIDL.compile(target, false, true, startEId);

                            s.add(pFP.encodeDF(ctx));
                            s.add(pIDL.encodeDF(ctx));

                            s.add(pFP.getAss().encode(ctx));
                            if(pFP.getAssFilter() != null){
                                s.add(pFP.getAssFilter().encode(ctx));
                            }

                            s.add(pIDL.getAss().encode(ctx));
                            if(pIDL.getAssFilter() != null){
                                s.add(pIDL.getAssFilter().encode(ctx));
                            }

                            s.add(pFP.encodeCF(ctx));
                            s.add(pIDL.encodeCF(ctx));

                            s.add(pFP.encodeDF_RF(ctx));
                            s.add(pIDL.encodeDF_RF(ctx));

                            s.add(pFP.encodeFinalValues(ctx));
                            s.add(pIDL.encodeFinalValues(ctx));

                            s.add(mcm.encode(pFP, ctx, false, false));
                            s.add(mcm.encode(pIDL, ctx, false, true));

                            if(WARN_ON_IMPOSSIBLE_EXECUTION){
                                if(!(s.check() == Status.SATISFIABLE)){
                                    throw new RuntimeException("Impossible execution");
                                }
                            }

                            for(String relName : relations){
                                Relation relation = mcm.getRelationRepository().getRelation(relName);
                                if(relation != null){
                                    TupleSet tupleSet = relation.getEncodeTupleSet();
                                    if(tupleSet != null){
                                        BoolExpr enc = ctx.mkFalse();
                                        for(Tuple tuple : relation.getEncodeTupleSet()){
                                            int eidFirst = tuple.getFirst().getEId();
                                            int eidSecond = tuple.getSecond().getEId();
                                            if(eidFirst < startEId){
                                                enc = ctx.mkOr(enc, ctx.mkNot(ctx.mkEq(
                                                        ctx.mkConst(mkEdgeString(relName, eidFirst, eidSecond), ctx.mkBoolSort()),
                                                        ctx.mkConst(mkEdgeString(relName, eidFirst + startEId, eidSecond + startEId), ctx.mkBoolSort())
                                                )));
                                            }
                                        }
                                        s.add(enc);
                                    }
                                }
                            }

                            if(s.check() == Status.SATISFIABLE) {
                                Model model = s.getModel();
                                StringBuilder sb = new StringBuilder();

                                for(String relName : relations){
                                    Relation relation = mcm.getRelationRepository().getRelation(relName);

                                    for(Tuple tuple : relation.getEncodeTupleSet()){
                                        int eidFirst = tuple.getFirst().getEId();
                                        int eidSecond = tuple.getSecond().getEId();

                                        if(eidFirst < startEId){
                                            Expr expr1 = model.getConstInterp(ctx.mkConst(relation + "(E" + eidFirst + ",E" + eidSecond + ")", ctx.mkBoolSort()));
                                            Expr expr2 = model.getConstInterp(ctx.mkConst(relation + "(E" + (eidFirst + startEId) + ",E" + (eidSecond + startEId) + ")", ctx.mkBoolSort()));

                                            boolean status1 = expr1 != null && expr1.isTrue();
                                            boolean status2 = expr2 != null && expr2.isTrue();

                                            if (status1 != status2) {
                                                sb.append("FP  ").append(mkEdgeString(relName, eidFirst, eidSecond)).append(": ").append(status1).append("\n");
                                                sb.append("IDL ").append(mkEdgeString(relName, eidFirst, eidSecond)).append(": ").append(status2).append("\n");
                                            }
                                        }
                                    }
                                }

                                throw new RuntimeException("Mismatched relation sets\n" + sb);
                            }

                        } catch (Exception e){
                            System.err.println(f.toString() + "Error : " + e.getMessage());
                        }
                    });

        } catch(Exception e){
            e.printStackTrace();
        }
    }

    private static String mkEdgeString(String relation, int eid1, int eid2){
        return relation + "(E" + eid1 + ",E" + eid2 + ")";
    }
}