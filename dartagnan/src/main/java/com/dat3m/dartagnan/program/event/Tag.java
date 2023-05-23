package com.dat3m.dartagnan.program.event;

public final class Tag {
    private Tag() { }

    public static final String ANY              = "_";
    public static final String INIT             = "IW";
    public static final String READ             = "R";
    public static final String WRITE            = "W";
    public static final String MEMORY           = "M";
    public static final String FENCE            = "F";
    public static final String RMW              = "RMW";
    public static final String EXCL             = "EXCL";
    public static final String STRONG           = "STRONG";
    // For SC events in RISCV and Power, addresses should match
    public static final String MATCHADDRESS     = "MATCHADDRESS";
    public static final String LOCAL            = "T";
    public static final String LABEL            = "LB";
    public static final String CMP              = "C";
    public static final String IFI              = "IFI";    // Internal jump in Ifs to goto end
    public static final String JUMP             = "J";
    public static final String VISIBLE          = "V";
    public static final String REG_WRITER       = "rW";
    public static final String REG_READER       = "rR";
    public static final String ASSERTION        = "ASS";
    // Marks the event that is reachable IFF a loop has not been fully unrolled.
    public static final String BOUND            = "BOUND";
    // Marks jumps that somehow terminate a thread earlier than "normally"
    // This can be bound events, spinning events, assertion violations, etc.
    public static final String EARLYTERMINATION = "EARLYTERMINATION";
    // Marks jumps that terminate a thread due to spinning behaviour, i.e. side-effect-free loop iterations
    public static final String SPINLOOP         = "SPINLOOP";
    // Some events should not be optimized (e.g. fake dependencies) or deleted (e.g. bounds)
    public static final String NOOPT            = "NOOPT";
    public static final String ANNOTATION       = "ANNOTATION";
    public static final String STARTLOAD        = "STARTLOAD";

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

        public static final String PTHREAD              = "PTHREAD";
        public static final String LOCK                 = "LOCK";

        public static final String MO_RELAXED           = "RLX";
        public static final String MO_CONSUME           = "CON";
        public static final String MO_ACQUIRE           = "ACQ";
        public static final String MO_RELEASE           = "REL";
        public static final String MO_ACQUIRE_RELEASE   = "ACQ_REL";
        public static final String MO_SC                 = "SC";

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

        public static final String SVCOMPATOMIC = "A-SVCOMP";
    }

    // =============================================================================================
    // ========================================= Standard ==========================================
    // =============================================================================================

    public static final class Std {
        private Std() { }

        public static final String MALLOC = "MALLOC";
    }

    // =============================================================================================
    // =========================================== IMM =============================================
    // =============================================================================================

    public static final class IMM {
        private IMM() { }

        public static final String CASDEPORIGIN = "CASDEPORIGIN";

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
    // =========================================== PTX =============================================
    // =============================================================================================
    public static final class PTX {
        public static final String PTX = "PTX";
        public static final String CTA = "CTA";
        public static final String GPU = "GPU";
        public static final String SYS = "SYS";
        public static final String WEAK = "WEAK";
        public static final String RLX = "RLX"; // RELAXED
        public static final String ACQ = "ACQ"; // ACQUIRE
        public static final String REL = "REL"; // RELEASE
        public static final String ACQ_REL = "ACQ_REL";
        public static final String SC = "SC";
        public static final String GEN = "GEN"; // GENERIC
        public static final String TEX = "TEX"; // TEXTURE
        public static final String SUR = "SUR"; // SURFACE
        public static final String CON = "CON"; // CONSTANT
        public static final String ALIAS = "ALIAS";
        private PTX() {
        }

        public static String loadMO(String mo) {
            switch (mo) {
                case ACQ_REL:
                    return ACQ;
                case RLX:
                    return RLX;
                default:
                    return "";
            }
        }

        public static String storeMO(String mo) {
            switch (mo) {
                case ACQ_REL:
                    return REL;
                case RLX:
                    return RLX;
                default:
                    return "";
            }
        }
    }
}