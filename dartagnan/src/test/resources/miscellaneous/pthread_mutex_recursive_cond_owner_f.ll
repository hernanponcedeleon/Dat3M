; ModuleID = 'pthread_mutex_recursive_cond_owner_f.c'
source_filename = "pthread_mutex_recursive_cond_owner_f.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_cond_t = type { %struct.__pthread_cond_s }
%struct.__pthread_cond_s = type { %union.__atomic_wide_counter, %union.__atomic_wide_counter, [2 x i32], i32, i32, [2 x i32], i32, i32 }
%union.__atomic_wide_counter = type { i64 }
%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }
%union.pthread_mutexattr_t = type { i32 }

@cond = dso_local global %union.pthread_cond_t zeroinitializer, align 8, !dbg !0
@mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !18

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !94 {
  %1 = alloca i32, align 4
  %2 = alloca %union.pthread_mutexattr_t, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !98, !DIExpression(), !107)
  %3 = call i32 @pthread_mutexattr_init(ptr noundef %2) #3, !dbg !108
  %4 = call i32 @pthread_mutexattr_settype(ptr noundef %2, i32 noundef 1) #3, !dbg !109
  %5 = call i32 @pthread_mutex_init(ptr noundef @mutex, ptr noundef %2) #3, !dbg !110
  %6 = call i32 @pthread_cond_wait(ptr noundef @cond, ptr noundef @mutex), !dbg !111
  ret i32 0, !dbg !112
}

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_init(ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_settype(ptr noundef, i32 noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(ptr noundef, ptr noundef) #1

declare i32 @pthread_cond_wait(ptr noundef, ptr noundef) #2

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!86, !87, !88, !89, !90, !91, !92}
!llvm.ident = !{!93}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "cond", scope: !2, file: !3, line: 6, type: !52, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 21.1.8 (6ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "pthread_mutex_recursive_cond_owner_f.c", directory: "/tmp/rm", checksumkind: CSK_MD5, checksum: "35d556a5a305101f5f15cb2d3f8661e1")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 47, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "c665ae672368d86b0545524d35407e96")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14, !15, !16}
!9 = !DIEnumerator(name: "PTHREAD_MUTEX_TIMED_NP", value: 0)
!10 = !DIEnumerator(name: "PTHREAD_MUTEX_RECURSIVE_NP", value: 1)
!11 = !DIEnumerator(name: "PTHREAD_MUTEX_ERRORCHECK_NP", value: 2)
!12 = !DIEnumerator(name: "PTHREAD_MUTEX_ADAPTIVE_NP", value: 3)
!13 = !DIEnumerator(name: "PTHREAD_MUTEX_NORMAL", value: 0)
!14 = !DIEnumerator(name: "PTHREAD_MUTEX_RECURSIVE", value: 1)
!15 = !DIEnumerator(name: "PTHREAD_MUTEX_ERRORCHECK", value: 2)
!16 = !DIEnumerator(name: "PTHREAD_MUTEX_DEFAULT", value: 0)
!17 = !{!0, !18}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "mutex", scope: !2, file: !3, line: 5, type: !20, isLocal: false, isDefinition: true)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !21, line: 72, baseType: !22)
!21 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "cbf5435bd7bfed052b1a09633f314dde")
!22 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !21, line: 67, size: 320, elements: !23)
!23 = !{!24, !45, !50}
!24 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !22, file: !21, line: 69, baseType: !25, size: 320)
!25 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !26, line: 22, size: 320, elements: !27)
!26 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "c204e8f2bbee82104b0bc5a7e66bac71")
!27 = !{!28, !30, !31, !32, !33, !34, !36, !37}
!28 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !25, file: !26, line: 24, baseType: !29, size: 32)
!29 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!30 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !25, file: !26, line: 25, baseType: !7, size: 32, offset: 32)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !25, file: !26, line: 26, baseType: !29, size: 32, offset: 64)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !25, file: !26, line: 28, baseType: !7, size: 32, offset: 96)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !25, file: !26, line: 32, baseType: !29, size: 32, offset: 128)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !25, file: !26, line: 34, baseType: !35, size: 16, offset: 160)
!35 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "__unused", scope: !25, file: !26, line: 35, baseType: !35, size: 16, offset: 176)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !25, file: !26, line: 36, baseType: !38, size: 128, offset: 192)
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !39, line: 55, baseType: !40)
!39 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "52a54ef04a6aeb244335b0bf6e6e1933")
!40 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !39, line: 51, size: 128, elements: !41)
!41 = !{!42, !44}
!42 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !40, file: !39, line: 53, baseType: !43, size: 64)
!43 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !40, size: 64)
!44 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !40, file: !39, line: 54, baseType: !43, size: 64, offset: 64)
!45 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !22, file: !21, line: 70, baseType: !46, size: 320)
!46 = !DICompositeType(tag: DW_TAG_array_type, baseType: !47, size: 320, elements: !48)
!47 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!48 = !{!49}
!49 = !DISubrange(count: 40)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !22, file: !21, line: 71, baseType: !51, size: 64)
!51 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!52 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_cond_t", file: !21, line: 80, baseType: !53)
!53 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !21, line: 75, size: 384, elements: !54)
!54 = !{!55, !80, !84}
!55 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !53, file: !21, line: 77, baseType: !56, size: 384)
!56 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_cond_s", file: !39, line: 94, size: 384, elements: !57)
!57 = !{!58, !70, !71, !75, !76, !77, !78, !79}
!58 = !DIDerivedType(tag: DW_TAG_member, name: "__wseq", scope: !56, file: !39, line: 96, baseType: !59, size: 64)
!59 = !DIDerivedType(tag: DW_TAG_typedef, name: "__atomic_wide_counter", file: !60, line: 33, baseType: !61)
!60 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/atomic_wide_counter.h", directory: "", checksumkind: CSK_MD5, checksum: "780ffed047ca872c6f9faa4295e15bac")
!61 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !60, line: 25, size: 64, elements: !62)
!62 = !{!63, !65}
!63 = !DIDerivedType(tag: DW_TAG_member, name: "__value64", scope: !61, file: !60, line: 27, baseType: !64, size: 64)
!64 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "__value32", scope: !61, file: !60, line: 32, baseType: !66, size: 64)
!66 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !61, file: !60, line: 28, size: 64, elements: !67)
!67 = !{!68, !69}
!68 = !DIDerivedType(tag: DW_TAG_member, name: "__low", scope: !66, file: !60, line: 30, baseType: !7, size: 32)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "__high", scope: !66, file: !60, line: 31, baseType: !7, size: 32, offset: 32)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "__g1_start", scope: !56, file: !39, line: 97, baseType: !59, size: 64, offset: 64)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "__g_size", scope: !56, file: !39, line: 98, baseType: !72, size: 64, offset: 128)
!72 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 64, elements: !73)
!73 = !{!74}
!74 = !DISubrange(count: 2)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "__g1_orig_size", scope: !56, file: !39, line: 99, baseType: !7, size: 32, offset: 192)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "__wrefs", scope: !56, file: !39, line: 100, baseType: !7, size: 32, offset: 224)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "__g_signals", scope: !56, file: !39, line: 101, baseType: !72, size: 64, offset: 256)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "__unused_initialized_1", scope: !56, file: !39, line: 102, baseType: !7, size: 32, offset: 320)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "__unused_initialized_2", scope: !56, file: !39, line: 103, baseType: !7, size: 32, offset: 352)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !53, file: !21, line: 78, baseType: !81, size: 384)
!81 = !DICompositeType(tag: DW_TAG_array_type, baseType: !47, size: 384, elements: !82)
!82 = !{!83}
!83 = !DISubrange(count: 48)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !53, file: !21, line: 79, baseType: !85, size: 64)
!85 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!86 = !{i32 7, !"Dwarf Version", i32 5}
!87 = !{i32 2, !"Debug Info Version", i32 3}
!88 = !{i32 1, !"wchar_size", i32 4}
!89 = !{i32 8, !"PIC Level", i32 2}
!90 = !{i32 7, !"PIE Level", i32 2}
!91 = !{i32 7, !"uwtable", i32 2}
!92 = !{i32 7, !"frame-pointer", i32 2}
!93 = !{!"Ubuntu clang version 21.1.8 (6ubuntu1)"}
!94 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 8, type: !95, scopeLine: 9, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !97)
!95 = !DISubroutineType(types: !96)
!96 = !{!29}
!97 = !{}
!98 = !DILocalVariable(name: "attr", scope: !94, file: !3, line: 10, type: !99)
!99 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !21, line: 36, baseType: !100)
!100 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !21, line: 32, size: 32, elements: !101)
!101 = !{!102, !106}
!102 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !100, file: !21, line: 34, baseType: !103, size: 32)
!103 = !DICompositeType(tag: DW_TAG_array_type, baseType: !47, size: 32, elements: !104)
!104 = !{!105}
!105 = !DISubrange(count: 4)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !100, file: !21, line: 35, baseType: !29, size: 32)
!107 = !DILocation(line: 10, column: 25, scope: !94)
!108 = !DILocation(line: 11, column: 5, scope: !94)
!109 = !DILocation(line: 12, column: 5, scope: !94)
!110 = !DILocation(line: 13, column: 5, scope: !94)
!111 = !DILocation(line: 15, column: 5, scope: !94)
!112 = !DILocation(line: 16, column: 5, scope: !94)
