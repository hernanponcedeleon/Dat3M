package com.dat3m.dartagnan.spirv.vulkan;

import com.dat3m.dartagnan.verification.ResultStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

import static com.dat3m.dartagnan.verification.ResultStatus.*;

@RunWith(Parameterized.class)
public class BasicAssertionsTest extends AbstractSpirvVulkanTest {

    public BasicAssertionsTest(String file, int bound, ResultStatus expected) {
        super("spirv/vulkan/basic/" + file, bound, expected);
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"empty-exists-false.spvasm", 1, FAIL},
                {"empty-exists-true.spvasm", 1, PASS},
                {"empty-forall-false.spvasm", 1, FAIL},
                {"empty-forall-true.spvasm", 1, PASS},
                {"empty-not-exists-false.spvasm", 1, PASS},
                {"empty-not-exists-true.spvasm", 1, FAIL},
                {"init-forall.spvasm", 1, PASS},
                {"init-forall-split.spvasm", 1, PASS},
                {"init-forall-not-exists.spvasm", 1, PASS},
                {"init-forall-not-exists-fail.spvasm", 1, FAIL},
                {"uninitialized-exists.spvasm", 1, PASS},
                {"uninitialized-forall.spvasm", 1, FAIL},
                {"uninitialized-private-exists.spvasm", 1, PASS},
                {"uninitialized-private-forall.spvasm", 1, FAIL},
                {"undef-exists.spvasm", 1, PASS},
                {"undef-forall.spvasm", 1, FAIL},
                {"read-write-struct.spvasm", 1, PASS},
                {"read-write-vector.spvasm", 1, PASS},
                {"read-write.spvasm", 1, PASS},
                {"vector-init.spvasm", 1, PASS},
                {"vector.spvasm", 1, PASS},
                {"array.spvasm", 1, PASS},
                {"array-of-vector.spvasm", 1, PASS},
                {"array-of-vector1.spvasm", 1, PASS},
                {"vector-read-write.spvasm", 1, PASS},
                {"composite-construct.spvasm", 1, PASS},
                {"composite-extract.spvasm", 1, PASS},
                {"composite-initial.spvasm", 1, PASS},
                {"composite-insert.spvasm", 1, PASS},
                {"spec-id-integer.spvasm", 1, PASS},
                {"spec-id-boolean.spvasm", 1, PASS},
                {"mixed-size.spvasm", 1, PASS},
                {"ids.spvasm", 1, PASS},
                {"builtin-constant.spvasm", 1, PASS},
                {"builtin-variable.spvasm", 1, PASS},
                {"builtin-default-config.spvasm", 1, PASS},
                {"builtin-all-123.spvasm", 1, PASS},
                {"builtin-all-321.spvasm", 1, PASS},
                {"branch-cond-ff.spvasm", 1, PASS},
                {"branch-cond-ff-inverted.spvasm", 1, PASS},
                {"branch-cond-bf.spvasm", 1, UNKNOWN},
                {"branch-cond-bf.spvasm", 2, PASS},
                {"branch-cond-fb.spvasm", 1, UNKNOWN},
                {"branch-cond-fb.spvasm", 2, PASS},
                {"branch-race.spvasm", 1, PASS},
                {"branch-loop.spvasm", 2, UNKNOWN},
                {"branch-loop.spvasm", 3, PASS},
                {"branch-struct-if.spvasm", 1, PASS},
                {"branch-struct-if-inverted.spvasm", 1, PASS},
                {"branch-struct-if-else.spvasm", 1, PASS},
                {"branch-struct-if-else-inverted.spvasm", 1, PASS},
                {"loop-struct-cond.spvasm", 1, UNKNOWN},
                {"loop-struct-cond.spvasm", 2, PASS},
                {"loop-struct-cond-suffix.spvasm", 1, UNKNOWN},
                {"loop-struct-cond-suffix.spvasm", 2, PASS},
                {"loop-struct-cond-sequence.spvasm", 2, UNKNOWN},
                {"loop-struct-cond-sequence.spvasm", 3, PASS},
                {"loop-struct-cond-nested.spvasm", 2, UNKNOWN},
                {"loop-struct-cond-nested.spvasm", 3, PASS},
                {"phi.spvasm", 1, PASS},
                {"phi-unstruct-true.spvasm", 1, PASS},
                {"phi-unstruct-false.spvasm", 1, PASS},
                {"cmpxchg-const-const.spvasm", 1, PASS},
                {"cmpxchg-const-reg.spvasm", 1, PASS},
                {"cmpxchg-reg-const.spvasm", 1, PASS},
                {"cmpxchg-reg-reg.spvasm", 1, PASS},
                {"memory-scopes.spvasm", 1, PASS},
                {"rmw-extremum-true.spvasm", 1, PASS},
                {"rmw-extremum-false.spvasm", 1, FAIL},
                {"push-constants.spvasm", 1, PASS},
                {"push-constants-pod.spvasm", 1, PASS},
                {"push-constant-mixed.spvasm", 1, PASS},
                {"bitwise-scalar.spvasm", 1, PASS},
                {"bitwise-vector.spvasm", 1, PASS},
                {"bitwise-not.spvasm", 1, PASS},
                {"bitwise-count.spvasm", 1, PASS},
                {"bitwise-firstbitlow.spvasm", 1, PASS},
                {"bitwise-shift.spvasm", 1, PASS},
                {"idx-overflow.spvasm", 1, PASS},
                {"min-max.spvasm", 1, PASS}
        });
    }
}
