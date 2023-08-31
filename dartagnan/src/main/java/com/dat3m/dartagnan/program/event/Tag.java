package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Store;

import java.util.Map;
import java.util.Set;

/*
    Tags can be attached to any event.
    There are two types of tags:
        (1) Tags referencable from CAT
        (2) Tags used only internally (prefixed with a double underscore "__");
 */
public final class Tag {
    private Tag() { }

    public static final String VISIBLE          = "_";
    public static final String INIT             = "IW";
    public static final String READ             = "R";
    public static final String WRITE            = "W";
    public static final String MEMORY           = "M";
    public static final String FENCE            = "F";
    public static final String STRONG           = "STRONG"; // TODO: Maybe move to C11 or IMM?
    public static final String RMW              = "RMW";

    // ---------- Internally used tags (not referenced in CAT) ----------
    public static final String EXCL             = "__EXCL";
    public static final String ASSERTION        = "__ASS";
    // Marks the event that is reachable IFF a loop has not been fully unrolled.
    public static final String BOUND            = "__BOUND";
    // Marks jumps that somehow terminate a thread earlier than "normally"
    // This can be bound events, spinning events, assertion violations, etc.
    public static final String EARLYTERMINATION = "__EARLYTERMINATION";
    // Marks jumps that terminate a thread due to spinning behaviour, i.e. side-effect-free loop iterations
    public static final String SPINLOOP         = "__SPINLOOP";
    // Some events should not be optimized (e.g. fake dependencies) or deleted (e.g. bounds)
    public static final String NOOPT            = "__NOOPT";
    public static final String STARTLOAD        = "__STARTLOAD";

    // =============================================================================================
    // =========================================== ARMv8 ===========================================
    // =============================================================================================

    public static final class ARMv8 {
        private ARMv8() {
        }

        public static final String MO_RX        = "RX";
        public static final String MO_REL       = "L";
        public static final String MO_ACQ       = "A";
        public static final String MO_ACQ_PC    = "Q";

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
    // =========================================== RISCV ===========================================
    // =============================================================================================

    public static final class RISCV {
        private RISCV() {
        }

        public static final String MO_ACQ       = "Acq";
        public static final String MO_REL       = "Rel";
        public static final String MO_ACQ_REL   = "AcqRel";

        // Store conditional
        public static final String STCOND       = "X";

        public static String extractStoreMoFromCMo(String cMo) {
            return cMo.equals(C11.MO_SC) || cMo.equals(C11.MO_RELEASE) || cMo.equals(C11.MO_ACQUIRE_RELEASE) ? MO_REL : "";
        }

        public static String extractLoadMoFromCMo(String cMo) {
            return cMo.equals(C11.MO_SC) || cMo.equals(C11.MO_ACQUIRE) || cMo.equals(C11.MO_ACQUIRE_RELEASE) ? MO_ACQ : "";
        }

    }

    // =============================================================================================
    // ============================================ TSO ============================================
    // =============================================================================================

    public static final class TSO {
        private TSO() {
        }

        public static final String ATOM = "A";
    }

    // =============================================================================================
    // ============================================ C11 ============================================
    // =============================================================================================

    public static final class C11 {
        private C11() {
        }

        public static final String ATOMIC               = "A";
        public static final String NONATOMIC            = "NA";

        public static final String MO_RELAXED           = "RLX";
        public static final String MO_CONSUME           = "CON";
        public static final String MO_ACQUIRE           = "ACQ";
        public static final String MO_RELEASE           = "REL";
        public static final String MO_ACQUIRE_RELEASE   = "ACQ_REL";
        public static final String MO_SC                 = "SC";

        public static final String PTHREAD              = "__PTHREAD";

        public static String intToMo(int i) {
            switch (i) {
                case 0: return MO_RELAXED;
                case 1: return MO_CONSUME;
                case 2: return MO_ACQUIRE;
                case 3: return MO_RELEASE;
                case 4: return MO_ACQUIRE_RELEASE;
                case 5: return MO_SC;
                default:
                    throw new UnsupportedOperationException("The memory order is not recognized");
            }
        }

    }

    // =============================================================================================
    // =========================================== Linux ===========================================
    // =============================================================================================

    public static final class Linux {
        private Linux() { }

        public static final String NORETURN                 = "Noreturn";
        public static final String RCU_SYNC                 = "Sync-rcu";
        public static final String RCU_LOCK                 = "Rcu-lock";
        public static final String RCU_UNLOCK               = "Rcu-unlock";
        public static final String SRCU_SYNC                = "Sync-srcu";
        public static final String SRCU_LOCK                = "Srcu-lock";
        public static final String SRCU_UNLOCK              = "Srcu-unlock";
        public static final String AFTER_SRCU_READ_UNLOCK   = "After-srcu-read-unlock";
        public static final String MO_MB                    = "Mb";
        public static final String MO_RMB                   = "Rmb";
        public static final String MO_WMB                   = "Wmb";
        public static final String BARRIER                  = "Barrier";
        public static final String MO_RELAXED               = "Relaxed";
        public static final String MO_RELEASE               = "Release";
        public static final String MO_ACQUIRE               = "Acquire";
        public static final String MO_ONCE                  = "Once";
        public static final String LOCK_READ                = "LKR";
        public static final String LOCK_WRITE               = "LKW";
        public static final String UNLOCK                   = "UL";
        public static final String LOCK_FAIL                = "LF";
        public static final String READ_LOCKED              = "RL";
        public static final String READ_UNLOCKED            = "RU";
        public static final String BEFORE_ATOMIC            = "Before-atomic";
        public static final String AFTER_ATOMIC             = "After-atomic";
        public static final String AFTER_SPINLOCK           = "After-spinlock";
        public static final String AFTER_UNLOCK_LOCK        = "After-unlock-lock";

        public static String loadMO(String mo) {
            return mo.equals(MO_ACQUIRE) ? MO_ACQUIRE : MO_ONCE;
        }

        public static String storeMO(String mo) {
            return mo.equals(MO_RELEASE) ? MO_RELEASE : MO_ONCE;
        }

        // NOTE: The order below needs to be in sync with /include/lkmm.h 
        public static String intToMo(int i) {
            switch (i) {
                case 0:     return MO_RELAXED;
                case 1:     return MO_ONCE;
                case 2:     return MO_ACQUIRE;
                case 3:     return MO_RELEASE;
                case 4:     return MO_MB;
                case 5:     return MO_WMB;
                case 6:     return MO_RMB;
                case 7:     return RCU_LOCK;
                case 8:     return RCU_UNLOCK;
                case 9:     return RCU_SYNC;
                case 10:    return BEFORE_ATOMIC;
                case 11:    return AFTER_ATOMIC;
                case 12:    return AFTER_SPINLOCK;
                case 13:    return BARRIER;
                default:
                    throw new UnsupportedOperationException("The memory order is not recognized");
            }
        }

        public static String toText(String mo) {
            switch (mo) {
                case MO_RELAXED: return "_relaxed";
                case MO_ACQUIRE: return "_acquire";
                case MO_RELEASE: return "_release";
                case MO_MB:      return "";
                default:
                    throw new IllegalArgumentException("Unrecognised memory order " + mo);
            }
        }
    }

    // =============================================================================================
    // ========================================== SVCOMP ===========================================
    // =============================================================================================

    public static final class SVCOMP {
        private SVCOMP() { }

        public static final String SVCOMPATOMIC = "__A-SVCOMP";
    }

    // =============================================================================================
    // ========================================= Standard ==========================================
    // =============================================================================================

    public static final class Std {
        private Std() { }

        public static final String MALLOC = "__MALLOC";
    }

    // =============================================================================================
    // =========================================== IMM =============================================
    // =============================================================================================

    public static final class IMM {
        private IMM() { }

        public static final String CASDEPORIGIN = "__CASDEPORIGIN";

        public static String extractStoreMo(String cMo) {
            switch (cMo) {
                case C11.MO_ACQUIRE_RELEASE:    return C11.MO_RELEASE;
                case C11.MO_ACQUIRE:            return C11.MO_RELAXED;
                default:                        return cMo;
            }
        }

        public static String extractLoadMo(String cMo) {
            switch (cMo) {
                case C11.MO_ACQUIRE_RELEASE:    return C11.MO_ACQUIRE;
                case C11.MO_RELEASE:            return C11.MO_RELAXED;
                default:                        return cMo;
            }
        }
    }

    // =============================================================================================
    // ======================================== TagPropagator ======================================
    // =============================================================================================
    public static class TagPropagator {
        TagPropagator() {
        }

        Map<String, String> getGeneralTags() {
            return null;
        }

        Map<String, String> getStTags() {
            return null;
        }

        Map<String, String> getLdTags() {
            return null;
        }
    }

    // =============================================================================================
    // =========================================== PTX =============================================
    // =============================================================================================
    public static final class PTX extends TagPropagator {
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
        public static final Map<String, String> generalTagMap = Map.of(CTA, CTA, GPU, GPU, SYS, SYS, GEN, GEN, TEX, TEX, SUR, SUR, CON, CON);
        public static final Map<String, String> stTagMap = Map.of(ACQ_REL, REL, RLX, RLX);
        public static final Map<String, String> ldTagMap = Map.of(ACQ_REL, ACQ, RLX, RLX);

        private PTX() {
        }

        public static Set<String> getScopeTags() {
            return Set.of(CTA, GPU, SYS);
        }

        @Override
        public Map<String, String> getGeneralTags() {
            return generalTagMap;
        }

        @Override
        public Map<String, String> getStTags() {
            return stTagMap;
        }

        @Override
        public Map<String, String> getLdTags() {
            return ldTagMap;
        }
    }

    // =============================================================================================
    // ========================================= Vulkan ============================================
    // =============================================================================================
    public static final class Vulkan extends TagPropagator {
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
        public static final String SEM_AVAILABLE = "SEMAVA";
        // StorageClass
        public static final String SC0 = "SC0";
        public static final String SC1 = "SC1";
        // StorageClass Semantics
        public static final String SEMSC0 = "SEMSC0";
        public static final String SEMSC1 = "SEMSC1";
        public static final String SEMSC01 = "SEMSC01";
        public static final Map<String, String> generalTagMap = Map.of(SUB_GROUP, SUB_GROUP, WORK_GROUP, WORK_GROUP, QUEUE_FAMILY, QUEUE_FAMILY, DEVICE, DEVICE, ATOM, ATOM, SC0, SC0, SC1, SC1, SEMSC0, SEMSC0, SEMSC1, SEMSC1);
        public static final Map<String, String> stTagMap = Map.of(ACQ_REL, RELEASE, RELEASE, RELEASE, AVAILABLE, AVAILABLE, SEM_AVAILABLE, SEM_AVAILABLE);
        public static final Map<String, String> ldTagMap = Map.of(ACQ_REL, ACQUIRE, ACQUIRE, ACQUIRE, VISIBLE, VISIBLE, SEM_VISIBLE, SEM_VISIBLE);

        public static Set<String> getScopeTags() {
            return Set.of(SUB_GROUP, WORK_GROUP, QUEUE_FAMILY, DEVICE);
        }

        private Vulkan() {
        }
        @Override
        public Map<String, String> getGeneralTags() {
            return generalTagMap;
        }

        @Override
        public Map<String, String> getStTags() {
            return stTagMap;
        }

        @Override
        public Map<String, String> getLdTags() {
            return ldTagMap;
        }
    }

    public static void propagateTags(Arch arch, Event source, Event target) {
        TagPropagator tagPropragator;
        switch (arch) {
            case PTX -> tagPropragator = new PTX();
            case VULKAN -> tagPropragator = new Vulkan();
            default -> throw new UnsupportedOperationException("Tag propagation not implemented for architecture " + arch);
        }
        for (String tag : tagPropragator.getGeneralTags().keySet()) {
            if (source.hasTag(tag)) {
                target.addTags(tagPropragator.getGeneralTags().get(tag));
            }
        }
        if (target instanceof Load) {
            for (String tag : tagPropragator.getLdTags().keySet()) {
                if (source.hasTag(tag)) {
                    target.addTags(tagPropragator.getLdTags().get(tag));
                }
            }
        } else if (target instanceof Store) {
            for (String tag : tagPropragator.getStTags().keySet()) {
                if (source.hasTag(tag)) {
                    target.addTags(tagPropragator.getStTags().get(tag));
                }
            }
        }
    }

    public static String getScopeTag(Event e, Arch arch) {
        return switch (arch) {
            case PTX -> PTX.getScopeTags().stream().filter(e::hasTag).findFirst().orElse("");
            case VULKAN -> Vulkan.getScopeTags().stream().filter(e::hasTag).findFirst().orElse("");
            default -> throw new UnsupportedOperationException("Scope tags not implemented for architecture " + arch);
        };

    }
}