; ModuleID = 'pthread_mutex_recursive_double_unlock_f.c'
source_filename = "pthread_mutex_recursive_double_unlock_f.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }
%union.pthread_mutexattr_t = type { i32 }

@mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !0

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !58 {
  %1 = alloca i32, align 4
  %2 = alloca %union.pthread_mutexattr_t, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !62, !DIExpression(), !71)
  %3 = call i32 @pthread_mutexattr_init(ptr noundef %2) #2, !dbg !72
  %4 = call i32 @pthread_mutexattr_settype(ptr noundef %2, i32 noundef 1) #2, !dbg !73
  %5 = call i32 @pthread_mutex_init(ptr noundef @mutex, ptr noundef %2) #2, !dbg !74
  %6 = call i32 @pthread_mutex_lock(ptr noundef @mutex) #2, !dbg !75
  %7 = call i32 @pthread_mutex_unlock(ptr noundef @mutex) #2, !dbg !76
  %8 = call i32 @pthread_mutex_unlock(ptr noundef @mutex) #2, !dbg !77
  ret i32 0, !dbg !78
}

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_init(ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_settype(ptr noundef, i32 noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(ptr noundef, ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(ptr noundef) #1

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!50, !51, !52, !53, !54, !55, !56}
!llvm.ident = !{!57}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "mutex", scope: !2, file: !3, line: 5, type: !18, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 21.1.8 (6ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "pthread_mutex_recursive_double_unlock_f.c", directory: "/tmp/rm", checksumkind: CSK_MD5, checksum: "c3e2cd7f167818170462375fcac07e57")
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
!17 = !{!0}
!18 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !19, line: 72, baseType: !20)
!19 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "cbf5435bd7bfed052b1a09633f314dde")
!20 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !19, line: 67, size: 320, elements: !21)
!21 = !{!22, !43, !48}
!22 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !20, file: !19, line: 69, baseType: !23, size: 320)
!23 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !24, line: 22, size: 320, elements: !25)
!24 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "c204e8f2bbee82104b0bc5a7e66bac71")
!25 = !{!26, !28, !29, !30, !31, !32, !34, !35}
!26 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !23, file: !24, line: 24, baseType: !27, size: 32)
!27 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !23, file: !24, line: 25, baseType: !7, size: 32, offset: 32)
!29 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !23, file: !24, line: 26, baseType: !27, size: 32, offset: 64)
!30 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !23, file: !24, line: 28, baseType: !7, size: 32, offset: 96)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !23, file: !24, line: 32, baseType: !27, size: 32, offset: 128)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !23, file: !24, line: 34, baseType: !33, size: 16, offset: 160)
!33 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "__unused", scope: !23, file: !24, line: 35, baseType: !33, size: 16, offset: 176)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !23, file: !24, line: 36, baseType: !36, size: 128, offset: 192)
!36 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !37, line: 55, baseType: !38)
!37 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "52a54ef04a6aeb244335b0bf6e6e1933")
!38 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !37, line: 51, size: 128, elements: !39)
!39 = !{!40, !42}
!40 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !38, file: !37, line: 53, baseType: !41, size: 64)
!41 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !38, size: 64)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !38, file: !37, line: 54, baseType: !41, size: 64, offset: 64)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !20, file: !19, line: 70, baseType: !44, size: 320)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !45, size: 320, elements: !46)
!45 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!46 = !{!47}
!47 = !DISubrange(count: 40)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !20, file: !19, line: 71, baseType: !49, size: 64)
!49 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!50 = !{i32 7, !"Dwarf Version", i32 5}
!51 = !{i32 2, !"Debug Info Version", i32 3}
!52 = !{i32 1, !"wchar_size", i32 4}
!53 = !{i32 8, !"PIC Level", i32 2}
!54 = !{i32 7, !"PIE Level", i32 2}
!55 = !{i32 7, !"uwtable", i32 2}
!56 = !{i32 7, !"frame-pointer", i32 2}
!57 = !{!"Ubuntu clang version 21.1.8 (6ubuntu1)"}
!58 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 7, type: !59, scopeLine: 8, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !61)
!59 = !DISubroutineType(types: !60)
!60 = !{!27}
!61 = !{}
!62 = !DILocalVariable(name: "attr", scope: !58, file: !3, line: 9, type: !63)
!63 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !19, line: 36, baseType: !64)
!64 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !19, line: 32, size: 32, elements: !65)
!65 = !{!66, !70}
!66 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !64, file: !19, line: 34, baseType: !67, size: 32)
!67 = !DICompositeType(tag: DW_TAG_array_type, baseType: !45, size: 32, elements: !68)
!68 = !{!69}
!69 = !DISubrange(count: 4)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !64, file: !19, line: 35, baseType: !27, size: 32)
!71 = !DILocation(line: 9, column: 25, scope: !58)
!72 = !DILocation(line: 10, column: 5, scope: !58)
!73 = !DILocation(line: 11, column: 5, scope: !58)
!74 = !DILocation(line: 12, column: 5, scope: !58)
!75 = !DILocation(line: 14, column: 5, scope: !58)
!76 = !DILocation(line: 15, column: 5, scope: !58)
!77 = !DILocation(line: 16, column: 5, scope: !58)
!78 = !DILocation(line: 17, column: 5, scope: !58)
