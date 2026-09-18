package com.dat3m.dartagnan.spirv.vulkan;

import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.verification.ResultStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;
import java.util.Map;

import static com.dat3m.dartagnan.verification.ResultStatus.FAIL;
import static com.dat3m.dartagnan.verification.ResultStatus.PASS;

@RunWith(Parameterized.class)
public class TerminationLivenessTest extends AbstractSpirvVulkanTest {

    private final ProgressModel.Hierarchy progressModel;

    public TerminationLivenessTest(String file, int bound, ProgressModel.Hierarchy progressModel, ResultStatus expected) {
        super("spirv/vulkan/termination/" + file, bound, expected);
        this.progressModel = progressModel;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() {

        ProgressModel.Hierarchy fairUniform = ProgressModel.uniform(ProgressModel.FAIR);
        ProgressModel.Hierarchy qfObe = ProgressModel.scoped(ProgressModel.FAIR, Map.of(
                                                Tag.Vulkan.QUEUE_FAMILY, ProgressModel.OBE));
        ProgressModel.Hierarchy qfObeSgUnfair = ProgressModel.scoped(ProgressModel.FAIR, Map.of(
                                                        Tag.Vulkan.QUEUE_FAMILY, ProgressModel.OBE,
                                                        Tag.Vulkan.SUB_GROUP, ProgressModel.UNFAIR));
        ProgressModel.Hierarchy qfObeSgObe = ProgressModel.scoped(ProgressModel.FAIR, Map.of(
                                                    Tag.Vulkan.QUEUE_FAMILY, ProgressModel.OBE,
                                                    Tag.Vulkan.SUB_GROUP, ProgressModel.OBE));
        ProgressModel.Hierarchy qfObeSgHsa = ProgressModel.scoped(ProgressModel.FAIR, Map.of(
                                                    Tag.Vulkan.QUEUE_FAMILY, ProgressModel.OBE,
                                                    Tag.Vulkan.SUB_GROUP, ProgressModel.HSA));
        ProgressModel.Hierarchy qfHsa = ProgressModel.scoped(ProgressModel.FAIR, Map.of(
                                                Tag.Vulkan.QUEUE_FAMILY, ProgressModel.HSA));
        ProgressModel.Hierarchy qfHsaSgUnfair = ProgressModel.scoped(ProgressModel.FAIR, Map.of(
                                                        Tag.Vulkan.QUEUE_FAMILY, ProgressModel.HSA,
                                                        Tag.Vulkan.SUB_GROUP, ProgressModel.UNFAIR));
        ProgressModel.Hierarchy qfHsaSgHsa = ProgressModel.scoped(ProgressModel.FAIR, Map.of(
                                                    Tag.Vulkan.QUEUE_FAMILY, ProgressModel.HSA,
                                                    Tag.Vulkan.SUB_GROUP, ProgressModel.HSA));
        ProgressModel.Hierarchy qfHsaSgObe = ProgressModel.scoped(ProgressModel.FAIR, Map.of(
                                                    Tag.Vulkan.QUEUE_FAMILY, ProgressModel.HSA,
                                                    Tag.Vulkan.SUB_GROUP, ProgressModel.OBE));

        return Arrays.asList(new Object[][]{
                {"non-uniform-barrier-1.spvasm", 1, fairUniform, PASS},
                {"non-uniform-barrier-2.spvasm", 1, fairUniform, FAIL},
                {"mp-groupID.spvasm", 1, fairUniform, PASS},
                {"mp-groupID.spvasm", 1, qfObe, FAIL},
                {"mp-groupID.spvasm", 1, qfHsa, PASS},
                {"mp-groupID.spvasm", 1, qfHsaSgUnfair, PASS},
                {"mp-atomicAdd-groupID.spvasm", 1, fairUniform, PASS},
                {"mp-atomicAdd-groupID.spvasm", 1, qfObe, PASS},
                {"mp-atomicAdd-groupID.spvasm", 1, qfObeSgUnfair, PASS},
                {"mp-atomicAdd-groupID.spvasm", 1, qfHsa, FAIL},
                {"mp-wg_obe-t_obe.spvasm", 1, qfObeSgObe, PASS},
                {"mp-wg_obe-t_obe.spvasm", 1, qfObeSgHsa, FAIL},
                {"mp-wg_obe-t_obe.spvasm", 1, qfHsa, FAIL},
                {"mp-wg_obe-t_hsa.spvasm", 1, qfObeSgHsa, PASS},
                {"mp-wg_obe-t_hsa.spvasm", 1, qfObeSgObe, PASS},
                {"mp-wg_obe-t_hsa.spvasm", 1, qfObeSgUnfair, FAIL},
                {"mp-wg_obe-t_hsa.spvasm", 1, qfHsa, FAIL},
                {"mp-wg_hsa-t_obe.spvasm", 1, qfHsaSgObe, PASS},
                {"mp-wg_hsa-t_obe.spvasm", 1, qfHsaSgHsa, FAIL},
                {"mp-wg_hsa-t_obe.spvasm", 1, qfObe, FAIL},
                {"mp-wg_hsa-t_hsa.spvasm", 1, qfHsaSgHsa, PASS},
                {"mp-wg_hsa-t_hsa.spvasm", 1, qfHsaSgObe, FAIL},
                {"mp-wg_hsa-t_hsa.spvasm", 1, qfObe, FAIL},
        });
    }

    @Override
    protected ProgressModel.Hierarchy getProgressModel() { return progressModel; }

    @Override
    protected Property getTestedProperty() { return Property.TERMINATION; }
}
