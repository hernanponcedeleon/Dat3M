; ModuleID = 'pthread_mutex_errorcheck.c'
source_filename = "pthread_mutex_errorcheck.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }
%union.pthread_mutexattr_t = type { i32 }

@initialized = dso_local global %union.pthread_mutex_t { %struct.__pthread_mutex_s { i32 0, i32 0, i32 0, i32 0, i32 2, i16 0, i16 0, %struct.__pthread_internal_list zeroinitializer } }, align 8, !dbg !0
@.str = private unnamed_addr constant [31 x i8] c"pthread_mutex_lock(mutex) == 0\00", align 1, !dbg !21
@.str.1 = private unnamed_addr constant [27 x i8] c"pthread_mutex_errorcheck.c\00", align 1, !dbg !27
@__PRETTY_FUNCTION__.check = private unnamed_addr constant [30 x i8] c"void check(pthread_mutex_t *)\00", align 1, !dbg !32
@.str.2 = private unnamed_addr constant [37 x i8] c"pthread_mutex_lock(mutex) == EDEADLK\00", align 1, !dbg !38
@.str.3 = private unnamed_addr constant [38 x i8] c"pthread_mutex_trylock(mutex) == EBUSY\00", align 1, !dbg !43
@.str.4 = private unnamed_addr constant [33 x i8] c"pthread_mutex_unlock(mutex) == 0\00", align 1, !dbg !48
@.str.5 = private unnamed_addr constant [34 x i8] c"pthread_mutex_trylock(mutex) == 0\00", align 1, !dbg !53

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @check(ptr noundef %0) #0 !dbg !97 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !102, !DIExpression(), !103)
  %3 = load ptr, ptr %2, align 8, !dbg !104
  %4 = call i32 @pthread_mutex_lock(ptr noundef %3) #3, !dbg !104
  %5 = icmp eq i32 %4, 0, !dbg !104
  br i1 %5, label %6, label %7, !dbg !104

6:                                                ; preds = %1
  br label %8, !dbg !104

7:                                                ; preds = %1
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 16, ptr noundef @__PRETTY_FUNCTION__.check) #4, !dbg !104
  unreachable, !dbg !104

8:                                                ; preds = %6
  %9 = load ptr, ptr %2, align 8, !dbg !107
  %10 = call i32 @pthread_mutex_lock(ptr noundef %9) #3, !dbg !107
  %11 = icmp eq i32 %10, 35, !dbg !107
  br i1 %11, label %12, label %13, !dbg !107

12:                                               ; preds = %8
  br label %14, !dbg !107

13:                                               ; preds = %8
  call void @__assert_fail(ptr noundef @.str.2, ptr noundef @.str.1, i32 noundef 17, ptr noundef @__PRETTY_FUNCTION__.check) #4, !dbg !107
  unreachable, !dbg !107

14:                                               ; preds = %12
  %15 = load ptr, ptr %2, align 8, !dbg !110
  %16 = call i32 @pthread_mutex_trylock(ptr noundef %15) #3, !dbg !110
  %17 = icmp eq i32 %16, 16, !dbg !110
  br i1 %17, label %18, label %19, !dbg !110

18:                                               ; preds = %14
  br label %20, !dbg !110

19:                                               ; preds = %14
  call void @__assert_fail(ptr noundef @.str.3, ptr noundef @.str.1, i32 noundef 18, ptr noundef @__PRETTY_FUNCTION__.check) #4, !dbg !110
  unreachable, !dbg !110

20:                                               ; preds = %18
  %21 = load ptr, ptr %2, align 8, !dbg !113
  %22 = call i32 @pthread_mutex_unlock(ptr noundef %21) #3, !dbg !113
  %23 = icmp eq i32 %22, 0, !dbg !113
  br i1 %23, label %24, label %25, !dbg !113

24:                                               ; preds = %20
  br label %26, !dbg !113

25:                                               ; preds = %20
  call void @__assert_fail(ptr noundef @.str.4, ptr noundef @.str.1, i32 noundef 19, ptr noundef @__PRETTY_FUNCTION__.check) #4, !dbg !113
  unreachable, !dbg !113

26:                                               ; preds = %24
  %27 = load ptr, ptr %2, align 8, !dbg !116
  %28 = call i32 @pthread_mutex_trylock(ptr noundef %27) #3, !dbg !116
  %29 = icmp eq i32 %28, 0, !dbg !116
  br i1 %29, label %30, label %31, !dbg !116

30:                                               ; preds = %26
  br label %32, !dbg !116

31:                                               ; preds = %26
  call void @__assert_fail(ptr noundef @.str.5, ptr noundef @.str.1, i32 noundef 20, ptr noundef @__PRETTY_FUNCTION__.check) #4, !dbg !116
  unreachable, !dbg !116

32:                                               ; preds = %30
  %33 = load ptr, ptr %2, align 8, !dbg !119
  %34 = call i32 @pthread_mutex_unlock(ptr noundef %33) #3, !dbg !119
  %35 = icmp eq i32 %34, 0, !dbg !119
  br i1 %35, label %36, label %37, !dbg !119

36:                                               ; preds = %32
  br label %38, !dbg !119

37:                                               ; preds = %32
  call void @__assert_fail(ptr noundef @.str.4, ptr noundef @.str.1, i32 noundef 21, ptr noundef @__PRETTY_FUNCTION__.check) #4, !dbg !119
  unreachable, !dbg !119

38:                                               ; preds = %36
  ret void, !dbg !122
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(ptr noundef) #1

; Function Attrs: cold noreturn nounwind
declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_mutex_trylock(ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(ptr noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !123 {
  %1 = alloca i32, align 4
  %2 = alloca %union.pthread_mutex_t, align 8
  %3 = alloca %union.pthread_mutexattr_t, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !126, !DIExpression(), !127)
    #dbg_declare(ptr %3, !128, !DIExpression(), !137)
  %4 = call i32 @pthread_mutexattr_init(ptr noundef %3) #3, !dbg !138
  %5 = call i32 @pthread_mutexattr_settype(ptr noundef %3, i32 noundef 2) #3, !dbg !139
  %6 = call i32 @pthread_mutex_init(ptr noundef %2, ptr noundef %3) #3, !dbg !140
  call void @check(ptr noundef %2), !dbg !141
  call void @check(ptr noundef @initialized), !dbg !142
  ret i32 0, !dbg !143
}

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_init(ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_settype(ptr noundef, i32 noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(ptr noundef, ptr noundef) #1

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { cold noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }
attributes #4 = { cold noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!89, !90, !91, !92, !93, !94, !95}
!llvm.ident = !{!96}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "initialized", scope: !2, file: !3, line: 9, type: !58, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 21.1.8 (6ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !18, globals: !20, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "pthread_mutex_errorcheck.c", directory: "/tmp/rm", checksumkind: CSK_MD5, checksum: "8a54720aa4f93fb0b1f5dc2a39286995")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 47, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "c665ae672368d86b0545524d35407e96")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14, !15, !16, !17}
!9 = !DIEnumerator(name: "PTHREAD_MUTEX_TIMED_NP", value: 0)
!10 = !DIEnumerator(name: "PTHREAD_MUTEX_RECURSIVE_NP", value: 1)
!11 = !DIEnumerator(name: "PTHREAD_MUTEX_ERRORCHECK_NP", value: 2)
!12 = !DIEnumerator(name: "PTHREAD_MUTEX_ADAPTIVE_NP", value: 3)
!13 = !DIEnumerator(name: "PTHREAD_MUTEX_NORMAL", value: 0)
!14 = !DIEnumerator(name: "PTHREAD_MUTEX_RECURSIVE", value: 1)
!15 = !DIEnumerator(name: "PTHREAD_MUTEX_ERRORCHECK", value: 2)
!16 = !DIEnumerator(name: "PTHREAD_MUTEX_DEFAULT", value: 0)
!17 = !DIEnumerator(name: "PTHREAD_MUTEX_FAST_NP", value: 0)
!18 = !{!19}
!19 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!20 = !{!0, !21, !27, !32, !38, !43, !48, !53}
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(scope: null, file: !3, line: 16, type: !23, isLocal: true, isDefinition: true)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 248, elements: !25)
!24 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!25 = !{!26}
!26 = !DISubrange(count: 31)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(scope: null, file: !3, line: 16, type: !29, isLocal: true, isDefinition: true)
!29 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 216, elements: !30)
!30 = !{!31}
!31 = !DISubrange(count: 27)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(scope: null, file: !3, line: 16, type: !34, isLocal: true, isDefinition: true)
!34 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 240, elements: !36)
!35 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !24)
!36 = !{!37}
!37 = !DISubrange(count: 30)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(scope: null, file: !3, line: 17, type: !40, isLocal: true, isDefinition: true)
!40 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 296, elements: !41)
!41 = !{!42}
!42 = !DISubrange(count: 37)
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(scope: null, file: !3, line: 18, type: !45, isLocal: true, isDefinition: true)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 304, elements: !46)
!46 = !{!47}
!47 = !DISubrange(count: 38)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(scope: null, file: !3, line: 19, type: !50, isLocal: true, isDefinition: true)
!50 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 264, elements: !51)
!51 = !{!52}
!52 = !DISubrange(count: 33)
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(scope: null, file: !3, line: 20, type: !55, isLocal: true, isDefinition: true)
!55 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 272, elements: !56)
!56 = !{!57}
!57 = !DISubrange(count: 34)
!58 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !59, line: 72, baseType: !60)
!59 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "cbf5435bd7bfed052b1a09633f314dde")
!60 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !59, line: 67, size: 320, elements: !61)
!61 = !{!62, !83, !87}
!62 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !60, file: !59, line: 69, baseType: !63, size: 320)
!63 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !64, line: 22, size: 320, elements: !65)
!64 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "c204e8f2bbee82104b0bc5a7e66bac71")
!65 = !{!66, !68, !69, !70, !71, !72, !74, !75}
!66 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !63, file: !64, line: 24, baseType: !67, size: 32)
!67 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !63, file: !64, line: 25, baseType: !7, size: 32, offset: 32)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !63, file: !64, line: 26, baseType: !67, size: 32, offset: 64)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !63, file: !64, line: 28, baseType: !7, size: 32, offset: 96)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !63, file: !64, line: 32, baseType: !67, size: 32, offset: 128)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !63, file: !64, line: 34, baseType: !73, size: 16, offset: 160)
!73 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "__unused", scope: !63, file: !64, line: 35, baseType: !73, size: 16, offset: 176)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !63, file: !64, line: 36, baseType: !76, size: 128, offset: 192)
!76 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !77, line: 55, baseType: !78)
!77 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "52a54ef04a6aeb244335b0bf6e6e1933")
!78 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !77, line: 51, size: 128, elements: !79)
!79 = !{!80, !82}
!80 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !78, file: !77, line: 53, baseType: !81, size: 64)
!81 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !78, size: 64)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !78, file: !77, line: 54, baseType: !81, size: 64, offset: 64)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !60, file: !59, line: 70, baseType: !84, size: 320)
!84 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 320, elements: !85)
!85 = !{!86}
!86 = !DISubrange(count: 40)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !60, file: !59, line: 71, baseType: !88, size: 64)
!88 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!89 = !{i32 7, !"Dwarf Version", i32 5}
!90 = !{i32 2, !"Debug Info Version", i32 3}
!91 = !{i32 1, !"wchar_size", i32 4}
!92 = !{i32 8, !"PIC Level", i32 2}
!93 = !{i32 7, !"PIE Level", i32 2}
!94 = !{i32 7, !"uwtable", i32 2}
!95 = !{i32 7, !"frame-pointer", i32 2}
!96 = !{!"Ubuntu clang version 21.1.8 (6ubuntu1)"}
!97 = distinct !DISubprogram(name: "check", scope: !3, file: !3, line: 14, type: !98, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !101)
!98 = !DISubroutineType(types: !99)
!99 = !{null, !100}
!100 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !58, size: 64)
!101 = !{}
!102 = !DILocalVariable(name: "mutex", arg: 1, scope: !97, file: !3, line: 14, type: !100)
!103 = !DILocation(line: 14, column: 29, scope: !97)
!104 = !DILocation(line: 16, column: 5, scope: !105)
!105 = distinct !DILexicalBlock(scope: !106, file: !3, line: 16, column: 5)
!106 = distinct !DILexicalBlock(scope: !97, file: !3, line: 16, column: 5)
!107 = !DILocation(line: 17, column: 5, scope: !108)
!108 = distinct !DILexicalBlock(scope: !109, file: !3, line: 17, column: 5)
!109 = distinct !DILexicalBlock(scope: !97, file: !3, line: 17, column: 5)
!110 = !DILocation(line: 18, column: 5, scope: !111)
!111 = distinct !DILexicalBlock(scope: !112, file: !3, line: 18, column: 5)
!112 = distinct !DILexicalBlock(scope: !97, file: !3, line: 18, column: 5)
!113 = !DILocation(line: 19, column: 5, scope: !114)
!114 = distinct !DILexicalBlock(scope: !115, file: !3, line: 19, column: 5)
!115 = distinct !DILexicalBlock(scope: !97, file: !3, line: 19, column: 5)
!116 = !DILocation(line: 20, column: 5, scope: !117)
!117 = distinct !DILexicalBlock(scope: !118, file: !3, line: 20, column: 5)
!118 = distinct !DILexicalBlock(scope: !97, file: !3, line: 20, column: 5)
!119 = !DILocation(line: 21, column: 5, scope: !120)
!120 = distinct !DILexicalBlock(scope: !121, file: !3, line: 21, column: 5)
!121 = distinct !DILexicalBlock(scope: !97, file: !3, line: 21, column: 5)
!122 = !DILocation(line: 22, column: 1, scope: !97)
!123 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 24, type: !124, scopeLine: 25, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !101)
!124 = !DISubroutineType(types: !125)
!125 = !{!67}
!126 = !DILocalVariable(name: "mutex", scope: !123, file: !3, line: 26, type: !58)
!127 = !DILocation(line: 26, column: 21, scope: !123)
!128 = !DILocalVariable(name: "attr", scope: !123, file: !3, line: 27, type: !129)
!129 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !59, line: 36, baseType: !130)
!130 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !59, line: 32, size: 32, elements: !131)
!131 = !{!132, !136}
!132 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !130, file: !59, line: 34, baseType: !133, size: 32)
!133 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 32, elements: !134)
!134 = !{!135}
!135 = !DISubrange(count: 4)
!136 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !130, file: !59, line: 35, baseType: !67, size: 32)
!137 = !DILocation(line: 27, column: 25, scope: !123)
!138 = !DILocation(line: 28, column: 5, scope: !123)
!139 = !DILocation(line: 29, column: 5, scope: !123)
!140 = !DILocation(line: 30, column: 5, scope: !123)
!141 = !DILocation(line: 31, column: 5, scope: !123)
!142 = !DILocation(line: 32, column: 5, scope: !123)
!143 = !DILocation(line: 33, column: 5, scope: !123)
