; ModuleID = 'benchmarks/mem-safety/memory-bounds-const-address.c'
source_filename = "benchmarks/mem-safety/memory-bounds-const-address.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !15 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !19, !DIExpression(), !20)
  store ptr inttoptr (i64 4096 to ptr), ptr %2, align 8, !dbg !20
  %3 = load ptr, ptr %2, align 8, !dbg !21
  store i32 1, ptr %3, align 4, !dbg !22
  ret i32 0, !dbg !23
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!8, !9, !10, !11, !12, !13}
!llvm.ident = !{!14}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "Homebrew clang version 23.1.3", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "benchmarks/mem-safety/memory-bounds-const-address.c", directory: ".", checksumkind: CSK_MD5, checksum: "5f8e189cac049d538db7c29a9fb5a1ef")
!2 = !{!3, !5}
!3 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!4 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!5 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !6, line: 34, baseType: !7)
!6 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_types/_uintptr_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e70ae655dd1b9d4ae0b1dcc073f5b7e4")
!7 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!8 = !{i32 7, !"Dwarf Version", i32 5}
!9 = !{i32 2, !"Debug Info Version", i32 3}
!10 = !{i32 8, !"PIC Level", i32 2}
!11 = !{i32 7, !"PIE Level", i32 2}
!12 = !{i32 7, !"uwtable", i32 2}
!13 = !{i32 7, !"frame-pointer", i32 2}
!14 = !{!"Homebrew clang version 23.1.3"}
!15 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 11, type: !16, scopeLine: 11, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !18)
!16 = !DISubroutineType(types: !17)
!17 = !{!4}
!18 = !{}
!19 = !DILocalVariable(name: "p", scope: !15, file: !1, line: 12, type: !3)
!20 = !DILocation(line: 12, column: 10, scope: !15)
!21 = !DILocation(line: 13, column: 6, scope: !15)
!22 = !DILocation(line: 13, column: 8, scope: !15)
!23 = !DILocation(line: 14, column: 5, scope: !15)
