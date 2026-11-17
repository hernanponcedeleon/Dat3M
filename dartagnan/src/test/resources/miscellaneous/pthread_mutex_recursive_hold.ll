; ModuleID = 'pthread_mutex_recursive_hold.c'
source_filename = "pthread_mutex_recursive_hold.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }
%union.pthread_mutexattr_t = type { i32 }

@recursive = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !0
@.str = private unnamed_addr constant [43 x i8] c"pthread_mutex_trylock(&recursive) == EBUSY\00", align 1, !dbg !20
@.str.1 = private unnamed_addr constant [31 x i8] c"pthread_mutex_recursive_hold.c\00", align 1, !dbg !26
@__PRETTY_FUNCTION__.other = private unnamed_addr constant [20 x i8] c"void *other(void *)\00", align 1, !dbg !31
@normal = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !47
@.str.2 = private unnamed_addr constant [2 x i8] c"0\00", align 1, !dbg !37
@__PRETTY_FUNCTION__.relock = private unnamed_addr constant [21 x i8] c"void *relock(void *)\00", align 1, !dbg !42

; Function Attrs: noinline nounwind optnone uwtable
define dso_local ptr @other(ptr noundef %0) #0 !dbg !88 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !92, !DIExpression(), !93)
  %3 = call i32 @pthread_mutex_trylock(ptr noundef @recursive) #4, !dbg !94
  %4 = icmp eq i32 %3, 16, !dbg !94
  br i1 %4, label %5, label %6, !dbg !94

5:                                                ; preds = %1
  br label %7, !dbg !94

6:                                                ; preds = %1
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 13, ptr noundef @__PRETTY_FUNCTION__.other) #5, !dbg !94
  unreachable, !dbg !94

7:                                                ; preds = %5
  ret ptr null, !dbg !97
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_trylock(ptr noundef) #1

; Function Attrs: cold noreturn nounwind
declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local ptr @relock(ptr noundef %0) #0 !dbg !98 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !99, !DIExpression(), !100)
  %3 = call i32 @pthread_mutex_lock(ptr noundef @normal) #4, !dbg !101
  %4 = call i32 @pthread_mutex_lock(ptr noundef @normal) #4, !dbg !102
  call void @__assert_fail(ptr noundef @.str.2, ptr noundef @.str.1, i32 noundef 21, ptr noundef @__PRETTY_FUNCTION__.relock) #5, !dbg !103
  unreachable, !dbg !103
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(ptr noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !106 {
  %1 = alloca i32, align 4
  %2 = alloca %union.pthread_mutexattr_t, align 4
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !109, !DIExpression(), !118)
  %5 = call i32 @pthread_mutexattr_init(ptr noundef %2) #4, !dbg !119
  %6 = call i32 @pthread_mutexattr_settype(ptr noundef %2, i32 noundef 1) #4, !dbg !120
  %7 = call i32 @pthread_mutex_init(ptr noundef @recursive, ptr noundef %2) #4, !dbg !121
  %8 = call i32 @pthread_mutex_init(ptr noundef @normal, ptr noundef null) #4, !dbg !122
  %9 = call i32 @pthread_mutex_lock(ptr noundef @recursive) #4, !dbg !123
  %10 = call i32 @pthread_mutex_lock(ptr noundef @recursive) #4, !dbg !124
  %11 = call i32 @pthread_mutex_unlock(ptr noundef @recursive) #4, !dbg !125
    #dbg_declare(ptr %3, !126, !DIExpression(), !129)
    #dbg_declare(ptr %4, !130, !DIExpression(), !131)
  %12 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @other, ptr noundef null) #4, !dbg !132
  %13 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @relock, ptr noundef null) #4, !dbg !133
  %14 = load i64, ptr %3, align 8, !dbg !134
  %15 = call i32 @pthread_join(i64 noundef %14, ptr noundef null), !dbg !135
  %16 = call i32 @pthread_mutex_unlock(ptr noundef @recursive) #4, !dbg !136
  ret i32 0, !dbg !137
}

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_init(ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_settype(ptr noundef, i32 noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(ptr noundef, ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(ptr noundef) #1

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
!llvm.module.flags = !{!80, !81, !82, !83, !84, !85, !86}
!llvm.ident = !{!87}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "recursive", scope: !2, file: !3, line: 8, type: !49, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 21.1.8 (6ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !17, globals: !19, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "pthread_mutex_recursive_hold.c", directory: "/tmp/rm", checksumkind: CSK_MD5, checksum: "ef6a637bb0d3aa80864443bdae71ded0")
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
!19 = !{!20, !26, !31, !37, !42, !0, !47}
!20 = !DIGlobalVariableExpression(var: !21, expr: !DIExpression())
!21 = distinct !DIGlobalVariable(scope: null, file: !3, line: 13, type: !22, isLocal: true, isDefinition: true)
!22 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 344, elements: !24)
!23 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!24 = !{!25}
!25 = !DISubrange(count: 43)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(scope: null, file: !3, line: 13, type: !28, isLocal: true, isDefinition: true)
!28 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 248, elements: !29)
!29 = !{!30}
!30 = !DISubrange(count: 31)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(scope: null, file: !3, line: 13, type: !33, isLocal: true, isDefinition: true)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 160, elements: !35)
!34 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !23)
!35 = !{!36}
!36 = !DISubrange(count: 20)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(scope: null, file: !3, line: 21, type: !39, isLocal: true, isDefinition: true)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 16, elements: !40)
!40 = !{!41}
!41 = !DISubrange(count: 2)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(scope: null, file: !3, line: 21, type: !44, isLocal: true, isDefinition: true)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 168, elements: !45)
!45 = !{!46}
!46 = !DISubrange(count: 21)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(name: "normal", scope: !2, file: !3, line: 9, type: !49, isLocal: false, isDefinition: true)
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !50, line: 72, baseType: !51)
!50 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "cbf5435bd7bfed052b1a09633f314dde")
!51 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !50, line: 67, size: 320, elements: !52)
!52 = !{!53, !74, !78}
!53 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !51, file: !50, line: 69, baseType: !54, size: 320)
!54 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !55, line: 22, size: 320, elements: !56)
!55 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "c204e8f2bbee82104b0bc5a7e66bac71")
!56 = !{!57, !59, !60, !61, !62, !63, !65, !66}
!57 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !54, file: !55, line: 24, baseType: !58, size: 32)
!58 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !54, file: !55, line: 25, baseType: !7, size: 32, offset: 32)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !54, file: !55, line: 26, baseType: !58, size: 32, offset: 64)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !54, file: !55, line: 28, baseType: !7, size: 32, offset: 96)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !54, file: !55, line: 32, baseType: !58, size: 32, offset: 128)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !54, file: !55, line: 34, baseType: !64, size: 16, offset: 160)
!64 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "__unused", scope: !54, file: !55, line: 35, baseType: !64, size: 16, offset: 176)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !54, file: !55, line: 36, baseType: !67, size: 128, offset: 192)
!67 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !68, line: 55, baseType: !69)
!68 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "52a54ef04a6aeb244335b0bf6e6e1933")
!69 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !68, line: 51, size: 128, elements: !70)
!70 = !{!71, !73}
!71 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !69, file: !68, line: 53, baseType: !72, size: 64)
!72 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !69, size: 64)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !69, file: !68, line: 54, baseType: !72, size: 64, offset: 64)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !51, file: !50, line: 70, baseType: !75, size: 320)
!75 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 320, elements: !76)
!76 = !{!77}
!77 = !DISubrange(count: 40)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !51, file: !50, line: 71, baseType: !79, size: 64)
!79 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!80 = !{i32 7, !"Dwarf Version", i32 5}
!81 = !{i32 2, !"Debug Info Version", i32 3}
!82 = !{i32 1, !"wchar_size", i32 4}
!83 = !{i32 8, !"PIC Level", i32 2}
!84 = !{i32 7, !"PIE Level", i32 2}
!85 = !{i32 7, !"uwtable", i32 2}
!86 = !{i32 7, !"frame-pointer", i32 2}
!87 = !{!"Ubuntu clang version 21.1.8 (6ubuntu1)"}
!88 = distinct !DISubprogram(name: "other", scope: !3, file: !3, line: 11, type: !89, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !91)
!89 = !DISubroutineType(types: !90)
!90 = !{!18, !18}
!91 = !{}
!92 = !DILocalVariable(name: "arg", arg: 1, scope: !88, file: !3, line: 11, type: !18)
!93 = !DILocation(line: 11, column: 19, scope: !88)
!94 = !DILocation(line: 13, column: 5, scope: !95)
!95 = distinct !DILexicalBlock(scope: !96, file: !3, line: 13, column: 5)
!96 = distinct !DILexicalBlock(scope: !88, file: !3, line: 13, column: 5)
!97 = !DILocation(line: 14, column: 5, scope: !88)
!98 = distinct !DISubprogram(name: "relock", scope: !3, file: !3, line: 17, type: !89, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !91)
!99 = !DILocalVariable(name: "arg", arg: 1, scope: !98, file: !3, line: 17, type: !18)
!100 = !DILocation(line: 17, column: 20, scope: !98)
!101 = !DILocation(line: 19, column: 5, scope: !98)
!102 = !DILocation(line: 20, column: 5, scope: !98)
!103 = !DILocation(line: 21, column: 5, scope: !104)
!104 = distinct !DILexicalBlock(scope: !105, file: !3, line: 21, column: 5)
!105 = distinct !DILexicalBlock(scope: !98, file: !3, line: 21, column: 5)
!106 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 25, type: !107, scopeLine: 26, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !91)
!107 = !DISubroutineType(types: !108)
!108 = !{!58}
!109 = !DILocalVariable(name: "attr", scope: !106, file: !3, line: 27, type: !110)
!110 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !50, line: 36, baseType: !111)
!111 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !50, line: 32, size: 32, elements: !112)
!112 = !{!113, !117}
!113 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !111, file: !50, line: 34, baseType: !114, size: 32)
!114 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 32, elements: !115)
!115 = !{!116}
!116 = !DISubrange(count: 4)
!117 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !111, file: !50, line: 35, baseType: !58, size: 32)
!118 = !DILocation(line: 27, column: 25, scope: !106)
!119 = !DILocation(line: 28, column: 5, scope: !106)
!120 = !DILocation(line: 29, column: 5, scope: !106)
!121 = !DILocation(line: 30, column: 5, scope: !106)
!122 = !DILocation(line: 31, column: 5, scope: !106)
!123 = !DILocation(line: 33, column: 5, scope: !106)
!124 = !DILocation(line: 34, column: 5, scope: !106)
!125 = !DILocation(line: 35, column: 5, scope: !106)
!126 = !DILocalVariable(name: "t0", scope: !106, file: !3, line: 37, type: !127)
!127 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !50, line: 27, baseType: !128)
!128 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!129 = !DILocation(line: 37, column: 15, scope: !106)
!130 = !DILocalVariable(name: "t1", scope: !106, file: !3, line: 37, type: !127)
!131 = !DILocation(line: 37, column: 19, scope: !106)
!132 = !DILocation(line: 38, column: 5, scope: !106)
!133 = !DILocation(line: 39, column: 5, scope: !106)
!134 = !DILocation(line: 40, column: 18, scope: !106)
!135 = !DILocation(line: 40, column: 5, scope: !106)
!136 = !DILocation(line: 41, column: 5, scope: !106)
!137 = !DILocation(line: 42, column: 5, scope: !106)
