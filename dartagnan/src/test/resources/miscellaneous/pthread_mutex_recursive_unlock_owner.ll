; ModuleID = 'pthread_mutex_recursive_unlock_owner.c'
source_filename = "pthread_mutex_recursive_unlock_owner.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }
%union.pthread_mutexattr_t = type { i32 }

@mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !0
@.str = private unnamed_addr constant [38 x i8] c"pthread_mutex_unlock(&mutex) == EPERM\00", align 1, !dbg !20
@.str.1 = private unnamed_addr constant [39 x i8] c"pthread_mutex_recursive_unlock_owner.c\00", align 1, !dbg !26
@__PRETTY_FUNCTION__.worker = private unnamed_addr constant [21 x i8] c"void *worker(void *)\00", align 1, !dbg !31
@.str.2 = private unnamed_addr constant [39 x i8] c"pthread_mutex_trylock(&mutex) == EBUSY\00", align 1, !dbg !37

; Function Attrs: noinline nounwind optnone uwtable
define dso_local ptr @worker(ptr noundef %0) #0 !dbg !78 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !82, !DIExpression(), !83)
  %3 = call i32 @pthread_mutex_unlock(ptr noundef @mutex) #4, !dbg !84
  %4 = icmp eq i32 %3, 1, !dbg !84
  br i1 %4, label %5, label %6, !dbg !84

5:                                                ; preds = %1
  br label %7, !dbg !84

6:                                                ; preds = %1
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 11, ptr noundef @__PRETTY_FUNCTION__.worker) #5, !dbg !84
  unreachable, !dbg !84

7:                                                ; preds = %5
  %8 = call i32 @pthread_mutex_trylock(ptr noundef @mutex) #4, !dbg !87
  %9 = icmp eq i32 %8, 16, !dbg !87
  br i1 %9, label %10, label %11, !dbg !87

10:                                               ; preds = %7
  br label %12, !dbg !87

11:                                               ; preds = %7
  call void @__assert_fail(ptr noundef @.str.2, ptr noundef @.str.1, i32 noundef 12, ptr noundef @__PRETTY_FUNCTION__.worker) #5, !dbg !87
  unreachable, !dbg !87

12:                                               ; preds = %10
  ret ptr null, !dbg !90
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(ptr noundef) #1

; Function Attrs: cold noreturn nounwind
declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_mutex_trylock(ptr noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !91 {
  %1 = alloca i32, align 4
  %2 = alloca %union.pthread_mutexattr_t, align 4
  %3 = alloca i64, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !94, !DIExpression(), !103)
  %4 = call i32 @pthread_mutexattr_init(ptr noundef %2) #4, !dbg !104
  %5 = call i32 @pthread_mutexattr_settype(ptr noundef %2, i32 noundef 1) #4, !dbg !105
  %6 = call i32 @pthread_mutex_init(ptr noundef @mutex, ptr noundef %2) #4, !dbg !106
  %7 = call i32 @pthread_mutex_lock(ptr noundef @mutex) #4, !dbg !107
    #dbg_declare(ptr %3, !108, !DIExpression(), !111)
  %8 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @worker, ptr noundef null) #4, !dbg !112
  %9 = load i64, ptr %3, align 8, !dbg !113
  %10 = call i32 @pthread_join(i64 noundef %9, ptr noundef null), !dbg !114
  %11 = call i32 @pthread_mutex_unlock(ptr noundef @mutex) #4, !dbg !115
  ret i32 0, !dbg !116
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

declare i32 @pthread_join(i64 noundef, ptr noundef) #3

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { cold noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }
attributes #5 = { cold noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!70, !71, !72, !73, !74, !75, !76}
!llvm.ident = !{!77}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "mutex", scope: !2, file: !3, line: 7, type: !39, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 21.1.8 (6ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !17, globals: !19, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "pthread_mutex_recursive_unlock_owner.c", directory: "/tmp/rm", checksumkind: CSK_MD5, checksum: "364d2222edbdd8a1a944dd1d2257d150")
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
!19 = !{!20, !26, !31, !37, !0}
!20 = !DIGlobalVariableExpression(var: !21, expr: !DIExpression())
!21 = distinct !DIGlobalVariable(scope: null, file: !3, line: 11, type: !22, isLocal: true, isDefinition: true)
!22 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 304, elements: !24)
!23 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!24 = !{!25}
!25 = !DISubrange(count: 38)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(scope: null, file: !3, line: 11, type: !28, isLocal: true, isDefinition: true)
!28 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 312, elements: !29)
!29 = !{!30}
!30 = !DISubrange(count: 39)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(scope: null, file: !3, line: 11, type: !33, isLocal: true, isDefinition: true)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 168, elements: !35)
!34 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !23)
!35 = !{!36}
!36 = !DISubrange(count: 21)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(scope: null, file: !3, line: 12, type: !28, isLocal: true, isDefinition: true)
!39 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !40, line: 72, baseType: !41)
!40 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "cbf5435bd7bfed052b1a09633f314dde")
!41 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !40, line: 67, size: 320, elements: !42)
!42 = !{!43, !64, !68}
!43 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !41, file: !40, line: 69, baseType: !44, size: 320)
!44 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !45, line: 22, size: 320, elements: !46)
!45 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "c204e8f2bbee82104b0bc5a7e66bac71")
!46 = !{!47, !49, !50, !51, !52, !53, !55, !56}
!47 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !44, file: !45, line: 24, baseType: !48, size: 32)
!48 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !44, file: !45, line: 25, baseType: !7, size: 32, offset: 32)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !44, file: !45, line: 26, baseType: !48, size: 32, offset: 64)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !44, file: !45, line: 28, baseType: !7, size: 32, offset: 96)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !44, file: !45, line: 32, baseType: !48, size: 32, offset: 128)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !44, file: !45, line: 34, baseType: !54, size: 16, offset: 160)
!54 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "__unused", scope: !44, file: !45, line: 35, baseType: !54, size: 16, offset: 176)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !44, file: !45, line: 36, baseType: !57, size: 128, offset: 192)
!57 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !58, line: 55, baseType: !59)
!58 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "52a54ef04a6aeb244335b0bf6e6e1933")
!59 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !58, line: 51, size: 128, elements: !60)
!60 = !{!61, !63}
!61 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !59, file: !58, line: 53, baseType: !62, size: 64)
!62 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !59, size: 64)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !59, file: !58, line: 54, baseType: !62, size: 64, offset: 64)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !41, file: !40, line: 70, baseType: !65, size: 320)
!65 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 320, elements: !66)
!66 = !{!67}
!67 = !DISubrange(count: 40)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !41, file: !40, line: 71, baseType: !69, size: 64)
!69 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!70 = !{i32 7, !"Dwarf Version", i32 5}
!71 = !{i32 2, !"Debug Info Version", i32 3}
!72 = !{i32 1, !"wchar_size", i32 4}
!73 = !{i32 8, !"PIC Level", i32 2}
!74 = !{i32 7, !"PIE Level", i32 2}
!75 = !{i32 7, !"uwtable", i32 2}
!76 = !{i32 7, !"frame-pointer", i32 2}
!77 = !{!"Ubuntu clang version 21.1.8 (6ubuntu1)"}
!78 = distinct !DISubprogram(name: "worker", scope: !3, file: !3, line: 9, type: !79, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !81)
!79 = !DISubroutineType(types: !80)
!80 = !{!18, !18}
!81 = !{}
!82 = !DILocalVariable(name: "arg", arg: 1, scope: !78, file: !3, line: 9, type: !18)
!83 = !DILocation(line: 9, column: 20, scope: !78)
!84 = !DILocation(line: 11, column: 5, scope: !85)
!85 = distinct !DILexicalBlock(scope: !86, file: !3, line: 11, column: 5)
!86 = distinct !DILexicalBlock(scope: !78, file: !3, line: 11, column: 5)
!87 = !DILocation(line: 12, column: 5, scope: !88)
!88 = distinct !DILexicalBlock(scope: !89, file: !3, line: 12, column: 5)
!89 = distinct !DILexicalBlock(scope: !78, file: !3, line: 12, column: 5)
!90 = !DILocation(line: 13, column: 5, scope: !78)
!91 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 16, type: !92, scopeLine: 17, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !81)
!92 = !DISubroutineType(types: !93)
!93 = !{!48}
!94 = !DILocalVariable(name: "attr", scope: !91, file: !3, line: 18, type: !95)
!95 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !40, line: 36, baseType: !96)
!96 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !40, line: 32, size: 32, elements: !97)
!97 = !{!98, !102}
!98 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !96, file: !40, line: 34, baseType: !99, size: 32)
!99 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 32, elements: !100)
!100 = !{!101}
!101 = !DISubrange(count: 4)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !96, file: !40, line: 35, baseType: !48, size: 32)
!103 = !DILocation(line: 18, column: 25, scope: !91)
!104 = !DILocation(line: 19, column: 5, scope: !91)
!105 = !DILocation(line: 20, column: 5, scope: !91)
!106 = !DILocation(line: 21, column: 5, scope: !91)
!107 = !DILocation(line: 23, column: 5, scope: !91)
!108 = !DILocalVariable(name: "t", scope: !91, file: !3, line: 24, type: !109)
!109 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !40, line: 27, baseType: !110)
!110 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!111 = !DILocation(line: 24, column: 15, scope: !91)
!112 = !DILocation(line: 25, column: 5, scope: !91)
!113 = !DILocation(line: 26, column: 18, scope: !91)
!114 = !DILocation(line: 26, column: 5, scope: !91)
!115 = !DILocation(line: 27, column: 5, scope: !91)
!116 = !DILocation(line: 28, column: 5, scope: !91)
