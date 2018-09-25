package dartagnan;

import com.microsoft.z3.*;
import dartagnan.program.Program;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.Wmm;
import dartagnan.wmm.WmmResolver;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.utils.Tuple;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class DartagnanIdlTest {

    private static String[] relations = {"idd^+", "hb^*"};
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
                            System.out.println(f.toString());

                            Context ctx = new Context();
                            Solver s = ctx.mkSolver(ctx.mkTactic("qfufbv"));
                            Program p = Dartagnan.parseProgram(f.toString());

                            Wmm mcm = Dartagnan.parseCat(catFilePath);
                            Relation.EncodeCtrlPo = new WmmResolver().encodeCtrlPo(target);

                            Program pFP = p.clone();
                            Program pIDL = p.clone();

                            pFP.initialize(STEPS);
                            pIDL.initialize(STEPS);

                            pFP.compile(target, false, true);
                            int startEId = Collections.max(pFP.getEventRepository().getEvents(EventRepository.EVENT_INIT).stream().map(e -> e.getEId()).collect(Collectors.toSet())) + 1;
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

                            if(s.check() == Status.SATISFIABLE) {
                                Model model = s.getModel();

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
                                                System.out.println("FP  " + mkEdgeString(relName, eidFirst, eidSecond) + ": " + status1);
                                                System.out.println("IDL " + mkEdgeString(relName, eidFirst, eidSecond) + ": " + status2);
                                            }
                                        }
                                    }
                                }

                                throw new RuntimeException("Mismatched relation sets");
                            }

                        } catch (Exception e){
                            System.err.println(f.toString() + "Error : " + e.getMessage());
                            e.printStackTrace();
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