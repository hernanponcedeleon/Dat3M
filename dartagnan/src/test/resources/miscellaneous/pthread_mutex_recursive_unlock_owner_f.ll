; ModuleID = 'pthread_mutex_recursive_unlock_owner_f.c'
source_filename = "pthread_mutex_recursive_unlock_owner_f.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }
%union.pthread_mutexattr_t = type { i32 }

@mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !0

; Function Attrs: noinline nounwind optnone uwtable
define dso_local ptr @worker(ptr noundef %0) #0 !dbg !60 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !64, !DIExpression(), !65)
  %3 = call i32 @pthread_mutex_unlock(ptr noundef @mutex) #3, !dbg !66
  ret ptr null, !dbg !67
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(ptr noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !68 {
  %1 = alloca i32, align 4
  %2 = alloca %union.pthread_mutexattr_t, align 4
  %3 = alloca i64, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !71, !DIExpression(), !80)
  %4 = call i32 @pthread_mutexattr_init(ptr noundef %2) #3, !dbg !81
  %5 = call i32 @pthread_mutexattr_settype(ptr noundef %2, i32 noundef 1) #3, !dbg !82
  %6 = call i32 @pthread_mutex_init(ptr noundef @mutex, ptr noundef %2) #3, !dbg !83
  %7 = call i32 @pthread_mutex_lock(ptr noundef @mutex) #3, !dbg !84
    #dbg_declare(ptr %3, !85, !DIExpression(), !88)
  %8 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @worker, ptr noundef null) #3, !dbg !89
  %9 = load i64, ptr %3, align 8, !dbg !90
  %10 = call i32 @pthread_join(i64 noundef %9, ptr noundef null), !dbg !91
  %11 = call i32 @pthread_mutex_unlock(ptr noundef @mutex) #3, !dbg !92
  ret i32 0, !dbg !93
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
declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @pthread_join(i64 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!52, !53, !54, !55, !56, !57, !58}
!llvm.ident = !{!59}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "mutex", scope: !2, file: !3, line: 5, type: !20, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 21.1.8 (6ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !17, globals: !19, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "pthread_mutex_recursive_unlock_owner_f.c", directory: "/tmp/rm", checksumkind: CSK_MD5, checksum: "8302042b66c929b3feb73e7ab363fb1d")
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
!17 = !{!18}
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!19 = !{!0}
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
!52 = !{i32 7, !"Dwarf Version", i32 5}
!53 = !{i32 2, !"Debug Info Version", i32 3}
!54 = !{i32 1, !"wchar_size", i32 4}
!55 = !{i32 8, !"PIC Level", i32 2}
!56 = !{i32 7, !"PIE Level", i32 2}
!57 = !{i32 7, !"uwtable", i32 2}
!58 = !{i32 7, !"frame-pointer", i32 2}
!59 = !{!"Ubuntu clang version 21.1.8 (6ubuntu1)"}
!60 = distinct !DISubprogram(name: "worker", scope: !3, file: !3, line: 7, type: !61, scopeLine: 8, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!61 = !DISubroutineType(types: !62)
!62 = !{!18, !18}
!63 = !{}
!64 = !DILocalVariable(name: "arg", arg: 1, scope: !60, file: !3, line: 7, type: !18)
!65 = !DILocation(line: 7, column: 20, scope: !60)
!66 = !DILocation(line: 9, column: 5, scope: !60)
!67 = !DILocation(line: 10, column: 5, scope: !60)
!68 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 13, type: !69, scopeLine: 14, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!69 = !DISubroutineType(types: !70)
!70 = !{!29}
!71 = !DILocalVariable(name: "attr", scope: !68, file: !3, line: 15, type: !72)
!72 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !21, line: 36, baseType: !73)
!73 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !21, line: 32, size: 32, elements: !74)
!74 = !{!75, !79}
!75 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !73, file: !21, line: 34, baseType: !76, size: 32)
!76 = !DICompositeType(tag: DW_TAG_array_type, baseType: !47, size: 32, elements: !77)
!77 = !{!78}
!78 = !DISubrange(count: 4)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !73, file: !21, line: 35, baseType: !29, size: 32)
!80 = !DILocation(line: 15, column: 25, scope: !68)
!81 = !DILocation(line: 16, column: 5, scope: !68)
!82 = !DILocation(line: 17, column: 5, scope: !68)
!83 = !DILocation(line: 18, column: 5, scope: !68)
!84 = !DILocation(line: 20, column: 5, scope: !68)
!85 = !DILocalVariable(name: "t", scope: !68, file: !3, line: 21, type: !86)
!86 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !21, line: 27, baseType: !87)
!87 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!88 = !DILocation(line: 21, column: 15, scope: !68)
!89 = !DILocation(line: 22, column: 5, scope: !68)
!90 = !DILocation(line: 23, column: 18, scope: !68)
!91 = !DILocation(line: 23, column: 5, scope: !68)
!92 = !DILocation(line: 24, column: 5, scope: !68)
!93 = !DILocation(line: 25, column: 5, scope: !68)
