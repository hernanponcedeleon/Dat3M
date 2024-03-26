package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.configuration.Arch;

import java.util.List;
import java.util.Set;

/*
    Tags can be attached to any event.
    There are two types of tags:
        (1) Tags referencable from CAT
        (2) Tags used only internally (prefixed with a double underscore "__");
 */
public final class Tag {
    public static final String VISIBLE = "_";
    public static final String INIT = "IW";
    public static final String READ = "R";
    public static final String WRITE = "W";
    public static final String MEMORY = "M";
    public static final String FENCE = "F";
    public static final String STRONG = "STRONG"; // TODO: Maybe move to C11 or IMM?
    public static final String RMW = "RMW";
    // ---------- Internally used tags (not referenced in CAT) ----------
    public static final String EXCL = "__EXCL";
    // Marks the event that is reachable IFF a loop has not been fully unrolled.
    public static final String BOUND = "__BOUND";
    // Marks jumps that somehow terminate a thread earlier than "normally"
    // This can be bound events, spinning events, assertion violations, etc.
    public static final String EARLYTERMINATION = "__EARLYTERMINATION";
    // Marks jumps that terminate a thread due to spinning behaviour, i.e. side-effect-free loop iterations
    public static final String SPINLOOP = "__SPINLOOP";
    // Some events should not be optimized (e.g. fake dependencies) or deleted (e.g. bounds)
    public static final String NOOPT = "__NOOPT";
    public static final String STARTLOAD = "__STARTLOAD";
    private Tag() {
    }

    // =============================================================================================
    // =========================================== ARMv8 ===========================================
    // =============================================================================================

    public static String getScopeTag(Event e, Arch arch) {
        return switch (arch) {
            case PTX -> PTX.getScopeTags().stream().filter(e::hasTag).findFirst().orElse("");
            case VULKAN -> Vulkan.getScopeTags().stream().filter(e::hasTag).findFirst().orElse("");
            default -> throw new UnsupportedOperationException("Scope tags not implemented for architecture " + arch);
        };
    }

    // =============================================================================================
    // =========================================== RISCV ===========================================
    // =============================================================================================

    public static final class ARMv8 {
        public static final String MO_RX = "RX";
        public static final String MO_REL = "L";
        public static final String MO_ACQ = "A";
        public static final String MO_ACQ_PC = "Q";
        private ARMv8() {
        }

        public static String extractStoreMoFromCMo(String cMo) {
            return cMo.equals(C11.MO_SC) || cMo.equals(C11.MO_RELEASE) || cMo.equals(C11.MO_ACQUIRE_RELEASE) ? MO_REL : MO_RX;
        }

        public static String extractLoadMoFromCMo(String cMo) {
            //TODO: What about MO_CONSUME loads?
            return cMo.equals(C11.MO_SC) || cMo.equals(C11.MO_ACQUIRE) || cMo.equals(C11.MO_ACQUIRE_RELEASE) ? MO_ACQ : MO_RX;
        }

        public static String extractStoreMoFromLKMo(String lkMo) {
            return lkMo.equals(Tag.Linux.MO_RELEASE) || lkMo.equals(Tag.Linux.MO_MB) ? MO_REL : "";
        }

        public static String extractLoadMoFromLKMo(String lkMo) {
            // We return "" when lkMo.equals(Tag.Linux.MO_MB) because the caller of
            // this method will use a dmb.ish barrier for the acquire part, see e.g.,
            //      https://elixir.bootlin.com/linux/v6.1/source/arch/arm64/include/asm/cmpxchg.h#L16
            return lkMo.equals(Tag.Linux.MO_ACQUIRE) ? MO_ACQ : "";
        }

    }

    // =============================================================================================
    // ============================================ TSO ============================================
    // =============================================================================================

    public static final class RISCV {
        public static final String MO_ACQ = "Acq";
        public static final String MO_REL = "Rel";
        public static final String MO_ACQ_REL = "AcqRel";
        // Store conditional
        public static final String STCOND = "X";

        private RISCV() {
        }

        public static String extractStoreMoFromCMo(String cMo) {
            return cMo.equals(C11.MO_SC) || cMo.equals(C11.MO_RELEASE) || cMo.equals(C11.MO_ACQUIRE_RELEASE) ? MO_REL : "";
        }

        public static String extractLoadMoFromCMo(String cMo) {
            return cMo.equals(C11.MO_SC) || cMo.equals(C11.MO_ACQUIRE) || cMo.equals(C11.MO_ACQUIRE_RELEASE) ? MO_ACQ : "";
        }

    }

    // =============================================================================================
    // ============================================ C11 ============================================
    // =============================================================================================

    public static final class TSO {
        public static final String ATOM = "A";

        private TSO() {
        }
    }

    // =============================================================================================
    // =========================================== Linux ===========================================
    // =============================================================================================

    public static final class C11 {
        public static final String ATOMIC = "A";
        public static final String NONATOMIC = "NA";
        public static final String MO_RELAXED = "RLX";
        public static final String MO_CONSUME = "CON";
        public static final String MO_ACQUIRE = "ACQ";
        public static final String MO_RELEASE = "REL";
        public static final String MO_ACQUIRE_RELEASE = "ACQ_REL";
        public static final String MO_SC = "SC";
        private C11() {
        }

        public static String intToMo(int i) {
            switch (i) {
                case 0:
                    return MO_RELAXED;
                case 1:
                    return MO_CONSUME;
                case 2:
                    return MO_ACQUIRE;
                case 3:
                    return MO_RELEASE;
                case 4:
                    return MO_ACQUIRE_RELEASE;
                case 5:
                    return MO_SC;
                default:
                    throw new UnsupportedOperationException("The memory order is not recognized");
            }
        }

        public static String loadMO(String mo) {
            return switch (mo) {
                case MO_ACQUIRE         -> MO_ACQUIRE;
                case MO_ACQUIRE_RELEASE -> MO_ACQUIRE;
                case MO_SC              -> MO_SC;
                default                 -> MO_RELAXED;
            };
        }

        public static String storeMO(String mo) {
            return switch (mo) {
                case MO_RELEASE         -> MO_RELEASE;
                case MO_ACQUIRE_RELEASE -> MO_RELEASE;
                case MO_SC              -> MO_SC;
                default                 -> MO_RELAXED;
            };
        }
    }

    // =============================================================================================
    // ========================================== SVCOMP ===========================================
    // =============================================================================================

    public static final class Linux {
        public static final String NORETURN = "Noreturn";
        public static final String RCU_SYNC = "Sync-rcu";
        public static final String RCU_LOCK = "Rcu-lock";
        public static final String RCU_UNLOCK = "Rcu-unlock";
        public static final String SRCU_SYNC = "Sync-srcu";
        public static final String SRCU_LOCK = "Srcu-lock";
        public static final String SRCU_UNLOCK = "Srcu-unlock";
        public static final String AFTER_SRCU_READ_UNLOCK = "After-srcu-read-unlock";
        public static final String MO_MB = "Mb";
        public static final String MO_RMB = "Rmb";
        public static final String MO_WMB = "Wmb";
        public static final String BARRIER = "Barrier";
        public static final String MO_RELAXED = "Relaxed";
        public static final String MO_RELEASE = "Release";
        public static final String MO_ACQUIRE = "Acquire";
        public static final String MO_ONCE = "Once";
        public static final String LOCK_READ = "LKR";
        public static final String LOCK_WRITE = "LKW";
        public static final String UNLOCK = "UL";
        public static final String LOCK_FAIL = "LF";
        public static final String READ_LOCKED = "RL";
        public static final String READ_UNLOCKED = "RU";
        public static final String BEFORE_ATOMIC = "Before-atomic";
        public static final String AFTER_ATOMIC = "After-atomic";
        public static final String AFTER_SPINLOCK = "After-spinlock";
        public static final String AFTER_UNLOCK_LOCK = "After-unlock-lock";
        private Linux() {
        }

        public static String loadMO(String mo) {
            return mo.equals(MO_ACQUIRE) ? MO_ACQUIRE : MO_ONCE;
        }

        public static String storeMO(String mo) {
            return mo.equals(MO_RELEASE) ? MO_RELEASE : MO_ONCE;
        }

        // NOTE: The order below needs to be in sync with /include/lkmm.h
        public static String intToMo(int i) {
            return switch (i) {
                case 0 -> MO_RELAXED;
                case 1 -> MO_ONCE;
                case 2 -> MO_ACQUIRE;
                case 3 -> MO_RELEASE;
                case 4 -> MO_MB;
                case 5 -> MO_WMB;
                case 6 -> MO_RMB;
                case 7 -> RCU_LOCK;
                case 8 -> RCU_UNLOCK;
                case 9 -> RCU_SYNC;
                case 10 -> BEFORE_ATOMIC;
                case 11 -> AFTER_ATOMIC;
                case 12 -> AFTER_SPINLOCK;
                case 13 -> BARRIER;
                case 14 -> AFTER_UNLOCK_LOCK;
                default -> throw new UnsupportedOperationException("The memory order is not recognized");
            };
        }

        public static String toText(String mo) {
            return switch (mo) {
                case MO_RELAXED -> "_relaxed";
                case MO_ACQUIRE -> "_acquire";
                case MO_RELEASE -> "_release";
                case MO_MB -> "";
                default -> throw new IllegalArgumentException("Unrecognised memory order " + mo);
            };
        }
    }

    // =============================================================================================
    // =========================================== IMM =============================================
    // =============================================================================================

    public static final class SVCOMP {
        public static final String SVCOMPATOMIC = "__A-SVCOMP";

        private SVCOMP() {
        }
    }

    public static final class IMM {
        public static final String CASDEPORIGIN = "__CASDEPORIGIN";

        private IMM() {
        }

        public static String extractStoreMo(String cMo) {
            switch (cMo) {
                case C11.MO_ACQUIRE_RELEASE:
                    return C11.MO_RELEASE;
                case C11.MO_ACQUIRE:
                    return C11.MO_RELAXED;
                default:
                    return cMo;
            }
        }

        public static String extractLoadMo(String cMo) {
            switch (cMo) {
                case C11.MO_ACQUIRE_RELEASE:
                    return C11.MO_ACQUIRE;
                case C11.MO_RELEASE:
                    return C11.MO_RELAXED;
                default:
                    return cMo;
            }
        }
    }

    // =============================================================================================
    // =========================================== PTX =============================================
    // =============================================================================================
    public static final class PTX {
        // Scopes
        public static final String CTA = "CTA";
        public static final String GPU = "GPU";
        public static final String SYS = "SYS";
        // Memory orders
        public static final String WEAK = "WEAK";
        public static final String RLX = "RLX"; // RELAXED
        public static final String ACQ = "ACQ"; // ACQUIRE
        public static final String REL = "REL"; // RELEASE
        public static final String ACQ_REL = "ACQ_REL";
        public static final String SC = "SC";
        // Proxies
        public static final String GEN = "GEN"; // GENERIC
        public static final String TEX = "TEX"; // TEXTURE
        public static final String SUR = "SUR"; // SURFACE
        public static final String CON = "CON"; // CONSTANT
        // Virtual memory
        public static final String ALIAS = "ALIAS";
        // Barrier Mode
        public static final String ARRIVE = "__ARRIVE";

        public static String loadMO(String mo) {
            return switch (mo) {
                case ACQ, ACQ_REL -> ACQ;
                // REL -> RLX to preserve morally-strong in RMW
                case REL, RLX -> RLX;
                default -> "";
            };
        }

        public static String storeMO(String mo) {
            return switch (mo) {
                case REL, ACQ_REL -> REL;
                // ACQ -> RLX to preserve morally-strong in RMW
                case ACQ, RLX -> RLX;
                default -> "";
            };
        }

        public static List<String> getScopeTags() {
            return List.of(CTA, GPU, SYS);
        }
    }

    // =============================================================================================
    // ========================================= Vulkan ============================================
    // =============================================================================================
    public static final class Vulkan {
        public static final String CBAR = "CBAR";
        public static final String AVDEVICE = "AVDEVICE";
        public static final String VISDEVICE = "VISDEVICE";
        // Scopes
        public static final String SUB_GROUP = "SG";
        public static final String WORK_GROUP = "WG";
        public static final String QUEUE_FAMILY = "QF";
        public static final String DEVICE = "DV";
        public static final String NON_PRIVATE = "NONPRIV";
        // Memory orders
        public static final String ATOM = "ATOM";
        public static final String ACQUIRE = "ACQ";
        public static final String RELEASE = "REL";
        public static final String ACQ_REL = "ACQ_REL";
        public static final String VISIBLE = "VIS";
        public static final String AVAILABLE = "AV";
        public static final String SEM_VISIBLE = "SEMVIS";
        public static final String SEM_AVAILABLE = "SEMAV";
        // StorageClass
        public static final String SC0 = "SC0";
        public static final String SC1 = "SC1";
        // StorageClass Semantics
        public static final String SEMSC0 = "SEMSC0";
        public static final String SEMSC1 = "SEMSC1";

        public static List<String> getScopeTags() {
            return List.of(SUB_GROUP, WORK_GROUP, QUEUE_FAMILY, DEVICE);
        }

        public static String loadMO(String mo) {
            return switch (mo) {
                case ACQ_REL, ACQUIRE -> ACQUIRE;
                default -> "";
            };
        }

        public static String storeMO(String mo) {
            return switch (mo) {
                case ACQ_REL, RELEASE -> RELEASE;
                default -> "";
            };
        }
    }

    // =============================================================================================
    // ========================================= Spir-V ============================================
    // =============================================================================================
    public static final class Spirv {
        // Barriers
        public static final String CONTROL = "SPV_CONTROL";

        // Memory order
        public static final String RELAXED = "SPV_RELAXED";
        public static final String ACQUIRE = "SPV_ACQUIRE";
        public static final String RELEASE = "SPV_RELEASE";
        public static final String ACQ_REL = "SPV_ACQ_REL";
        public static final String SEQ_CST = "SPV_SEQ_CST";

        // Scope
        public static final String CROSS_DEVICE = "SPV_CROSS_DEVICE";
        public static final String DEVICE = "SPV_DEVICE";
        public static final String WORKGROUP = "SPV_WORKGROUP";
        public static final String SUBGROUP = "SPV_SUBGROUP";
        public static final String INVOCATION = "SPV_INVOCATION";
        public static final String QUEUE_FAMILY = "SPV_QUEUE_FAMILY";
        public static final String SHADER_CALL = "SPV_SHADER_CALL";

        // Memory access (non-atomic)
        public static final String MEM_VOLATILE = "SPV_MEM_VOLATILE";
        public static final String MEM_NON_TEMPORAL = "SPV_MEM_NON_TEMPORAL";
        public static final String MEM_NON_PRIVATE = "SPV_MEM_NON_PRIVATE";
        public static final String MEM_AVAILABLE = "SPV_MEM_AVAILABLE";
        public static final String MEM_VISIBLE = "SPV_MEM_VISIBLE";

        // Memory semantics (atomic)
        public static final String SEM_AVAILABLE = "SPV_SEM_AVAILABLE";
        public static final String SEM_VISIBLE = "SPV_SEM_VISIBLE";
        public static final String SEM_VOLATILE = "SPV_SEM_VOLATILE";

        // Memory semantics storage class (atomic)
        public static final String SEM_UNIFORM = "SPV_SEM_UNIFORM";
        public static final String SEM_SUBGROUP = "SPV_SEM_SUBGROUP";
        public static final String SEM_WORKGROUP = "SPV_SEM_WORKGROUP";
        public static final String SEM_CROSS_WORKGROUP = "SPV_SEM_CROSS_WORKGROUP";
        public static final String SEM_ATOMIC_COUNTER = "SPV_SEM_ATOMIC_COUNTER";
        public static final String SEM_IMAGE = "SPV_SEM_IMAGE";
        public static final String SEM_OUTPUT = "SPV_SEM_OUTPUT";
        private static final Set<String> scopeTags = Set.of(
                INVOCATION,
                SUBGROUP,
                WORKGROUP,
                DEVICE,
                CROSS_DEVICE,
                QUEUE_FAMILY,
                SHADER_CALL
        );
        private static final Set<String> moTags = Set.of(
                RELAXED,
                ACQUIRE,
                RELEASE,
                ACQ_REL,
                SEQ_CST
        );

        // TODO:  "AVDEVICE", "VISDEVICE", "SC0", "SC1"
        public static String toVulkan(String tag) {
            return switch (tag) {
                // Barriers
                case CONTROL -> Vulkan.CBAR;

                // Memory order
                case RELAXED -> null; // ignore
                case ACQUIRE -> Vulkan.ACQUIRE;
                case RELEASE -> Vulkan.RELEASE;
                case ACQ_REL -> Vulkan.ACQ_REL;
                case SEQ_CST -> throw new IllegalArgumentException(
                        String.format("Non-Vulkan memory order '%s'", SEQ_CST));

                // Scope
                case INVOCATION -> null; // ignore
                case SUBGROUP -> Vulkan.SUB_GROUP;
                case WORKGROUP -> Vulkan.WORK_GROUP;
                case DEVICE -> Vulkan.DEVICE;
                case CROSS_DEVICE -> Vulkan.DEVICE; // TODO: exists in the tests
                //throw new UnsupportedOperationException(
                //String.format("Unsupported Vulkan scope '%s'", CROSS_DEVICE));
                case QUEUE_FAMILY -> Vulkan.QUEUE_FAMILY;
                // TODO: The cat file has shader but defined using the device scope ..
                case SHADER_CALL -> throw new UnsupportedOperationException(
                        String.format("Unsupported Vulkan scope '%s'", SHADER_CALL));

                // Memory access (non-atomic)
                case MEM_VOLATILE -> null; // ignore
                case MEM_NON_TEMPORAL -> null; // ignore
                case MEM_NON_PRIVATE -> Vulkan.NON_PRIVATE;
                case MEM_AVAILABLE -> Vulkan.AVAILABLE;
                case MEM_VISIBLE -> Vulkan.VISIBLE;

                // Memory semantics
                case SEM_VOLATILE -> null; // ignore
                case SEM_AVAILABLE -> Vulkan.SEM_AVAILABLE;
                case SEM_VISIBLE -> Vulkan.SEM_VISIBLE;

                // Memory semantics (storage class)
                case SEM_UNIFORM -> Vulkan.SEMSC0;
                case SEM_SUBGROUP -> throw new UnsupportedOperationException(
                        String.format("Unsupported Vulkan storage class semantics '%s'", SEM_SUBGROUP));
                case SEM_WORKGROUP -> Vulkan.SEMSC1;
                case SEM_CROSS_WORKGROUP -> throw new UnsupportedOperationException(
                        String.format("Unsupported Vulkan storage class semantics '%s'", SEM_CROSS_WORKGROUP));
                case SEM_ATOMIC_COUNTER -> throw new UnsupportedOperationException(
                        String.format("Unsupported Vulkan storage class semantics '%s'", SEM_ATOMIC_COUNTER));
                case SEM_IMAGE -> throw new UnsupportedOperationException(
                        String.format("Unsupported Vulkan storage class semantics '%s'", SEM_IMAGE));
                case SEM_OUTPUT -> throw new UnsupportedOperationException(
                        String.format("Unsupported Vulkan storage class semantics '%s'", SEM_OUTPUT));

                default -> null;
            };
        }

        public static boolean isSpirvTag(String tag) {
            return tag != null && tag.startsWith("SPV_");
        }

        public static String getMoTag(Set<String> tags) {
            return filterOne("memory order", tags, moTags);
        }

        public static String getScopeTag(Set<String> tags) {
            return filterOne("scope", tags, scopeTags);
        }

        private static String filterOne(String type, Set<String> tags, Set<String> filter) {
            List<String> filtered = tags.stream().filter(filter::contains).toList();
            if (filtered.isEmpty()) {
                throw new IllegalArgumentException("Cannot find a tag for " + type);
            }
            if (filtered.size() > 1) {
                throw new IllegalArgumentException("Multiple tags for " + type);
            }
            return filtered.get(0);
        }
    }
}
