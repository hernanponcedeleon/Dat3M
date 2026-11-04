package com.dat3m.dartagnan.program.processing.libraries;

import com.google.common.base.Preconditions;

/**
 * Integer-valued POSIX error codes as defined by the supported C standard libraries.
 * The numeric values differ between libraries, so each constant stores one value per {@link CLibraryVersion}.
 * Codes that a library does not define are marked with {@code NA.V}.
 *
 * Sources:
 *  - glibc (Linux): {@code asm-generic/errno-base.h} and {@code asm-generic/errno.h}
 *  - Darwin libc (macOS): {@code sys/errno.h} of the macOS SDK
 */
enum PosixErrorCode {
    //name           glibc, darwin
    SUCCESS(            0, 0),     // Success
    EPERM(              1, 1),     // Operation not permitted
    ENOENT(             2, 2),     // No such file or directory
    ESRCH(              3, 3),     // No such process
    EINTR(              4, 4),     // Interrupted system call
    EIO(                5, 5),     // Input/output error
    ENXIO(              6, 6),     // No such device or address
    E2BIG(              7, 7),     // Argument list too long
    ENOEXEC(            8, 8),     // Exec format error
    EBADF(              9, 9),     // Bad file descriptor
    ECHILD(            10, 10),    // No child processes
    EAGAIN(            11, 35),    // Resource temporarily unavailable
    ENOMEM(            12, 12),    // Cannot allocate memory
    EACCES(            13, 13),    // Permission denied
    EFAULT(            14, 14),    // Bad address
    ENOTBLK(           15, 15),    // Block device required
    EBUSY(             16, 16),    // Device or resource busy
    EEXIST(            17, 17),    // File exists
    EXDEV(             18, 18),    // Invalid cross-device link
    ENODEV(            19, 19),    // No such device
    ENOTDIR(           20, 20),    // Not a directory
    EISDIR(            21, 21),    // Is a directory
    EINVAL(            22, 22),    // Invalid argument
    ENFILE(            23, 23),    // Too many open files in system
    EMFILE(            24, 24),    // Too many open files
    ENOTTY(            25, 25),    // Inappropriate ioctl for device
    ETXTBSY(           26, 26),    // Text file busy
    EFBIG(             27, 27),    // File too large
    ENOSPC(            28, 28),    // No space left on device
    ESPIPE(            29, 29),    // Illegal seek
    EROFS(             30, 30),    // Read-only file system
    EMLINK(            31, 31),    // Too many links
    EPIPE(             32, 32),    // Broken pipe
    EDOM(              33, 33),    // Numerical argument out of domain
    ERANGE(            34, 34),    // Numerical result out of range
    EDEADLK(           35, 11),    // Resource deadlock avoided
    ENAMETOOLONG(      36, 63),    // File name too long
    ENOLCK(            37, 77),    // No locks available
    ENOSYS(            38, 78),    // Function not implemented
    ENOTEMPTY(         39, 66),    // Directory not empty
    ELOOP(             40, 62),    // Too many levels of symbolic links
    ENOMSG(            42, 91),    // No message of desired type
    EIDRM(             43, 90),    // Identifier removed
    ECHRNG(            44, NA.V),  // Channel number out of range
    EL2NSYNC(          45, NA.V),  // Level 2 not synchronized
    EL3HLT(            46, NA.V),  // Level 3 halted
    EL3RST(            47, NA.V),  // Level 3 reset
    ELNRNG(            48, NA.V),  // Link number out of range
    EUNATCH(           49, NA.V),  // Protocol driver not attached
    ENOCSI(            50, NA.V),  // No CSI structure available
    EL2HLT(            51, NA.V),  // Level 2 halted
    EBADE(             52, NA.V),  // Invalid exchange
    EBADR(             53, NA.V),  // Invalid request descriptor
    EXFULL(            54, NA.V),  // Exchange full
    ENOANO(            55, NA.V),  // No anode
    EBADRQC(           56, NA.V),  // Invalid request code
    EBADSLT(           57, NA.V),  // Invalid slot
    EBFONT(            59, NA.V),  // Bad font file format
    ENOSTR(            60, 99),    // Device not a stream
    ENODATA(           61, 96),    // No data available
    ETIME(             62, 101),   // Timer expired
    ENOSR(             63, 98),    // Out of streams resources
    ENONET(            64, NA.V),  // Machine is not on the network
    ENOPKG(            65, NA.V),  // Package not installed
    EREMOTE(           66, 71),    // Object is remote
    ENOLINK(           67, 97),    // Link has been severed
    EADV(              68, NA.V),  // Advertise error
    ESRMNT(            69, NA.V),  // Srmount error
    ECOMM(             70, NA.V),  // Communication error on send
    EPROTO(            71, 100),   // Protocol error
    EMULTIHOP(         72, 95),    // Multihop attempted
    EDOTDOT(           73, NA.V),  // RFS specific error
    EBADMSG(           74, 94),    // Bad message
    EOVERFLOW(         75, 84),    // Value too large for defined data type
    ENOTUNIQ(          76, NA.V),  // Name not unique on network
    EBADFD(            77, NA.V),  // File descriptor in bad state
    EREMCHG(           78, NA.V),  // Remote address changed
    ELIBACC(           79, NA.V),  // Can not access a needed shared library
    ELIBBAD(           80, NA.V),  // Accessing a corrupted shared library
    ELIBSCN(           81, NA.V),  // .lib section in a.out corrupted
    ELIBMAX(           82, NA.V),  // Attempting to link in too many shared libraries
    ELIBEXEC(          83, NA.V),  // Cannot exec a shared library directly
    EILSEQ(            84, 92),    // Invalid or incomplete multibyte or wide character
    ERESTART(          85, NA.V),  // Interrupted system call should be restarted
    ESTRPIPE(          86, NA.V),  // Streams pipe error
    EUSERS(            87, 68),    // Too many users
    ENOTSOCK(          88, 38),    // Socket operation on non-socket
    EDESTADDRREQ(      89, 39),    // Destination address required
    EMSGSIZE(          90, 40),    // Message too long
    EPROTOTYPE(        91, 41),    // Protocol wrong type for socket
    ENOPROTOOPT(       92, 42),    // Protocol not available
    EPROTONOSUPPORT(   93, 43),    // Protocol not supported
    ESOCKTNOSUPPORT(   94, 44),    // Socket type not supported
    EOPNOTSUPP(        95, 102),   // Operation not supported
    EPFNOSUPPORT(      96, 46),    // Protocol family not supported
    EAFNOSUPPORT(      97, 47),    // Address family not supported by protocol
    EADDRINUSE(        98, 48),    // Address already in use
    EADDRNOTAVAIL(     99, 49),    // Cannot assign requested address
    ENETDOWN(         100, 50),    // Network is down
    ENETUNREACH(      101, 51),    // Network is unreachable
    ENETRESET(        102, 52),    // Network dropped connection on reset
    ECONNABORTED(     103, 53),    // Software caused connection abort
    ECONNRESET(       104, 54),    // Connection reset by peer
    ENOBUFS(          105, 55),    // No buffer space available
    EISCONN(          106, 56),    // Transport endpoint is already connected
    ENOTCONN(         107, 57),    // Transport endpoint is not connected
    ESHUTDOWN(        108, 58),    // Cannot send after transport endpoint shutdown
    ETOOMANYREFS(     109, 59),    // Too many references: cannot splice
    ETIMEDOUT(        110, 60),    // Connection timed out
    ECONNREFUSED(     111, 61),    // Connection refused
    EHOSTDOWN(        112, 64),    // Host is down
    EHOSTUNREACH(     113, 65),    // No route to host
    EALREADY(         114, 37),    // Operation already in progress
    EINPROGRESS(      115, 36),    // Operation now in progress
    ESTALE(           116, 70),    // Stale file handle
    EUCLEAN(          117, NA.V),  // Structure needs cleaning
    ENOTNAM(          118, NA.V),  // Not a XENIX named type file
    ENAVAIL(          119, NA.V),  // No XENIX semaphores available
    EISNAM(           120, NA.V),  // Is a named type file
    EREMOTEIO(        121, NA.V),  // Remote I/O error
    EDQUOT(           122, 69),    // Disk quota exceeded
    ENOMEDIUM(        123, NA.V),  // No medium found
    EMEDIUMTYPE(      124, NA.V),  // Wrong medium type
    ECANCELED(        125, 89),    // Operation canceled
    ENOKEY(           126, NA.V),  // Required key not available
    EKEYEXPIRED(      127, NA.V),  // Key has expired
    EKEYREVOKED(      128, NA.V),  // Key has been revoked
    EKEYREJECTED(     129, NA.V),  // Key was rejected by service
    EOWNERDEAD(       130, 105),   // Owner died
    ENOTRECOVERABLE(  131, 104),   // State not recoverable
    ERFKILL(          132, NA.V),  // Operation not possible due to RF-kill
    EHWPOISON(        133, NA.V),  // Memory page has hardware error
    ENOTSUP(           95, 45),    // Operation not supported (alias of EOPNOTSUPP in glibc)
    EPROCLIM(        NA.V, 67),    // Too many processes
    EBADRPC(         NA.V, 72),    // RPC struct is bad
    ERPCMISMATCH(    NA.V, 73),    // RPC version wrong
    EPROGUNAVAIL(    NA.V, 74),    // RPC prog. not avail
    EPROGMISMATCH(   NA.V, 75),    // Program version wrong
    EPROCUNAVAIL(    NA.V, 76),    // Bad procedure for program
    EFTYPE(          NA.V, 79),    // Inappropriate file type or format
    EAUTH(           NA.V, 80),    // Authentication error
    ENEEDAUTH(       NA.V, 81),    // Need authenticator
    EPWROFF(         NA.V, 82),    // Device power is off
    EDEVERR(         NA.V, 83),    // Device error, e.g. paper out
    EBADEXEC(        NA.V, 85),    // Bad executable
    EBADARCH(        NA.V, 86),    // Bad CPU type in executable
    ESHLIBVERS(      NA.V, 87),    // Shared library version mismatch
    EBADMACHO(       NA.V, 88),    // Malformed Macho file
    ENOATTR(         NA.V, 93),    // Attribute not found
    ENOPOLICY(       NA.V, 103),   // No such policy registered
    EQFULL(          NA.V, 106),   // Interface output queue is full
    ENOTCAPABLE(     NA.V, 107);   // Capabilities insufficient

    // Marker for codes a library does not define.
    // Held in a nested class, because enum constants cannot reference the enum's own static fields.
    private static final class NA { static final int V = -1; }

    private final int valGlibc;
    private final int valDarwinLibc;

    PosixErrorCode(int valGlibc, int valDarwinLibc) {
        this.valGlibc = valGlibc;
        this.valDarwinLibc = valDarwinLibc;
    }

    boolean isDefined(CLibraryVersion clib) {
        return getRawValue(clib) != NA.V;
    }

    int getValue(CLibraryVersion clib) {
        Preconditions.checkArgument(isDefined(clib), "Error code %s is not defined in %s.", this, clib);
        return getRawValue(clib);
    }

    private int getRawValue(CLibraryVersion clib) {
        return switch (clib) {
            case GLIBC -> valGlibc;
            case DARWIN_LIBC -> valDarwinLibc;
        };
    }
}
