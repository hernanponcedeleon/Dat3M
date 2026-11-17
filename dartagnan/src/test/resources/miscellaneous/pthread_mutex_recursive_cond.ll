; ModuleID = 'pthread_mutex_recursive_cond.c'
source_filename = "pthread_mutex_recursive_cond.c"
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
@mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !37
@released = dso_local global i32 0, align 4, !dbg !70
@.str = private unnamed_addr constant [9 x i8] c"released\00", align 1, !dbg !20
@.str.1 = private unnamed_addr constant [31 x i8] c"pthread_mutex_recursive_cond.c\00", align 1, !dbg !26
@__PRETTY_FUNCTION__.worker = private unnamed_addr constant [21 x i8] c"void *worker(void *)\00", align 1, !dbg !31

; Function Attrs: noinline nounwind optnone uwtable
define dso_local ptr @worker(ptr noundef %0) #0 !dbg !114 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !118, !DIExpression(), !119)
  %3 = call i32 @pthread_mutex_trylock(ptr noundef @mutex) #4, !dbg !120
  %4 = icmp eq i32 %3, 0, !dbg !122
  br i1 %4, label %5, label %12, !dbg !122

5:                                                ; preds = %1
  %6 = load i32, ptr @released, align 4, !dbg !123
  %7 = icmp ne i32 %6, 0, !dbg !123
  br i1 %7, label %8, label %9, !dbg !123

8:                                                ; preds = %5
  br label %10, !dbg !123

9:                                                ; preds = %5
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 13, ptr noundef @__PRETTY_FUNCTION__.worker) #5, !dbg !123
  unreachable, !dbg !123

10:                                               ; preds = %8
  %11 = call i32 @pthread_mutex_unlock(ptr noundef @mutex) #4, !dbg !127
  br label %12, !dbg !128

12:                                               ; preds = %10, %1
  ret ptr null, !dbg !129
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_trylock(ptr noundef) #1

; Function Attrs: cold noreturn nounwind
declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(ptr noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !130 {
  %1 = alloca i32, align 4
  %2 = alloca %union.pthread_mutexattr_t, align 4
  %3 = alloca i64, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !133, !DIExpression(), !142)
  %4 = call i32 @pthread_mutexattr_init(ptr noundef %2) #4, !dbg !143
  %5 = call i32 @pthread_mutexattr_settype(ptr noundef %2, i32 noundef 1) #4, !dbg !144
  %6 = call i32 @pthread_mutex_init(ptr noundef @mutex, ptr noundef %2) #4, !dbg !145
  %7 = call i32 @pthread_mutex_lock(ptr noundef @mutex) #4, !dbg !146
  %8 = call i32 @pthread_mutex_lock(ptr noundef @mutex) #4, !dbg !147
    #dbg_declare(ptr %3, !148, !DIExpression(), !151)
  %9 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @worker, ptr noundef null) #4, !dbg !152
  %10 = call i32 @pthread_cond_wait(ptr noundef @cond, ptr noundef @mutex), !dbg !153
  store i32 1, ptr @released, align 4, !dbg !154
  %11 = call i32 @pthread_mutex_unlock(ptr noundef @mutex) #4, !dbg !155
  %12 = call i32 @pthread_mutex_unlock(ptr noundef @mutex) #4, !dbg !156
  %13 = load i64, ptr %3, align 8, !dbg !157
  %14 = call i32 @pthread_join(i64 noundef %13, ptr noundef null), !dbg !158
  ret i32 0, !dbg !159
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

declare i32 @pthread_cond_wait(ptr noundef, ptr noundef) #3

declare i32 @pthread_join(i64 noundef, ptr noundef) #3

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { cold noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }
attributes #5 = { cold noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!106, !107, !108, !109, !110, !111, !112}
!llvm.ident = !{!113}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "cond", scope: !2, file: !3, line: 7, type: !72, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 21.1.8 (6ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !17, globals: !19, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "pthread_mutex_recursive_cond.c", directory: "/tmp/rm", checksumkind: CSK_MD5, checksum: "8c81d420f5b1a708433e6e719342a6c6")
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
!19 = !{!0, !20, !26, !31, !37, !70}
!20 = !DIGlobalVariableExpression(var: !21, expr: !DIExpression())
!21 = distinct !DIGlobalVariable(scope: null, file: !3, line: 13, type: !22, isLocal: true, isDefinition: true)
!22 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 72, elements: !24)
!23 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!24 = !{!25}
!25 = !DISubrange(count: 9)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(scope: null, file: !3, line: 13, type: !28, isLocal: true, isDefinition: true)
!28 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 248, elements: !29)
!29 = !{!30}
!30 = !DISubrange(count: 31)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(scope: null, file: !3, line: 13, type: !33, isLocal: true, isDefinition: true)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 168, elements: !35)
!34 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !23)
!35 = !{!36}
!36 = !DISubrange(count: 21)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(name: "mutex", scope: !2, file: !3, line: 6, type: !39, isLocal: false, isDefinition: true)
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
!70 = !DIGlobalVariableExpression(var: !71, expr: !DIExpression())
!71 = distinct !DIGlobalVariable(name: "released", scope: !2, file: !3, line: 8, type: !48, isLocal: false, isDefinition: true)
!72 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_cond_t", file: !40, line: 80, baseType: !73)
!73 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !40, line: 75, size: 384, elements: !74)
!74 = !{!75, !100, !104}
!75 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !73, file: !40, line: 77, baseType: !76, size: 384)
!76 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_cond_s", file: !58, line: 94, size: 384, elements: !77)
!77 = !{!78, !90, !91, !95, !96, !97, !98, !99}
!78 = !DIDerivedType(tag: DW_TAG_member, name: "__wseq", scope: !76, file: !58, line: 96, baseType: !79, size: 64)
!79 = !DIDerivedType(tag: DW_TAG_typedef, name: "__atomic_wide_counter", file: !80, line: 33, baseType: !81)
!80 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/atomic_wide_counter.h", directory: "", checksumkind: CSK_MD5, checksum: "780ffed047ca872c6f9faa4295e15bac")
!81 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !80, line: 25, size: 64, elements: !82)
!82 = !{!83, !85}
!83 = !DIDerivedType(tag: DW_TAG_member, name: "__value64", scope: !81, file: !80, line: 27, baseType: !84, size: 64)
!84 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "__value32", scope: !81, file: !80, line: 32, baseType: !86, size: 64)
!86 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !81, file: !80, line: 28, size: 64, elements: !87)
!87 = !{!88, !89}
!88 = !DIDerivedType(tag: DW_TAG_member, name: "__low", scope: !86, file: !80, line: 30, baseType: !7, size: 32)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "__high", scope: !86, file: !80, line: 31, baseType: !7, size: 32, offset: 32)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "__g1_start", scope: !76, file: !58, line: 97, baseType: !79, size: 64, offset: 64)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "__g_size", scope: !76, file: !58, line: 98, baseType: !92, size: 64, offset: 128)
!92 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 64, elements: !93)
!93 = !{!94}
!94 = !DISubrange(count: 2)
!95 = !DIDerivedType(tag: DW_TAG_member, name: "__g1_orig_size", scope: !76, file: !58, line: 99, baseType: !7, size: 32, offset: 192)
!96 = !DIDerivedType(tag: DW_TAG_member, name: "__wrefs", scope: !76, file: !58, line: 100, baseType: !7, size: 32, offset: 224)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "__g_signals", scope: !76, file: !58, line: 101, baseType: !92, size: 64, offset: 256)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "__unused_initialized_1", scope: !76, file: !58, line: 102, baseType: !7, size: 32, offset: 320)
!99 = !DIDerivedType(tag: DW_TAG_member, name: "__unused_initialized_2", scope: !76, file: !58, line: 103, baseType: !7, size: 32, offset: 352)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !73, file: !40, line: 78, baseType: !101, size: 384)
!101 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 384, elements: !102)
!102 = !{!103}
!103 = !DISubrange(count: 48)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !73, file: !40, line: 79, baseType: !105, size: 64)
!105 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!106 = !{i32 7, !"Dwarf Version", i32 5}
!107 = !{i32 2, !"Debug Info Version", i32 3}
!108 = !{i32 1, !"wchar_size", i32 4}
!109 = !{i32 8, !"PIC Level", i32 2}
!110 = !{i32 7, !"PIE Level", i32 2}
!111 = !{i32 7, !"uwtable", i32 2}
!112 = !{i32 7, !"frame-pointer", i32 2}
!113 = !{!"Ubuntu clang version 21.1.8 (6ubuntu1)"}
!114 = distinct !DISubprogram(name: "worker", scope: !3, file: !3, line: 10, type: !115, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !117)
!115 = !DISubroutineType(types: !116)
!116 = !{!18, !18}
!117 = !{}
!118 = !DILocalVariable(name: "arg", arg: 1, scope: !114, file: !3, line: 10, type: !18)
!119 = !DILocation(line: 10, column: 20, scope: !114)
!120 = !DILocation(line: 12, column: 9, scope: !121)
!121 = distinct !DILexicalBlock(scope: !114, file: !3, line: 12, column: 9)
!122 = !DILocation(line: 12, column: 39, scope: !121)
!123 = !DILocation(line: 13, column: 9, scope: !124)
!124 = distinct !DILexicalBlock(scope: !125, file: !3, line: 13, column: 9)
!125 = distinct !DILexicalBlock(scope: !126, file: !3, line: 13, column: 9)
!126 = distinct !DILexicalBlock(scope: !121, file: !3, line: 12, column: 45)
!127 = !DILocation(line: 14, column: 9, scope: !126)
!128 = !DILocation(line: 15, column: 5, scope: !126)
!129 = !DILocation(line: 16, column: 5, scope: !114)
!130 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 19, type: !131, scopeLine: 20, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !117)
!131 = !DISubroutineType(types: !132)
!132 = !{!48}
!133 = !DILocalVariable(name: "attr", scope: !130, file: !3, line: 21, type: !134)
!134 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !40, line: 36, baseType: !135)
!135 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !40, line: 32, size: 32, elements: !136)
!136 = !{!137, !141}
!137 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !135, file: !40, line: 34, baseType: !138, size: 32)
!138 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 32, elements: !139)
!139 = !{!140}
!140 = !DISubrange(count: 4)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !135, file: !40, line: 35, baseType: !48, size: 32)
!142 = !DILocation(line: 21, column: 25, scope: !130)
!143 = !DILocation(line: 22, column: 5, scope: !130)
!144 = !DILocation(line: 23, column: 5, scope: !130)
!145 = !DILocation(line: 24, column: 5, scope: !130)
!146 = !DILocation(line: 26, column: 5, scope: !130)
!147 = !DILocation(line: 27, column: 5, scope: !130)
!148 = !DILocalVariable(name: "t", scope: !130, file: !3, line: 28, type: !149)
!149 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !40, line: 27, baseType: !150)
!150 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!151 = !DILocation(line: 28, column: 15, scope: !130)
!152 = !DILocation(line: 29, column: 5, scope: !130)
!153 = !DILocation(line: 30, column: 5, scope: !130)
!154 = !DILocation(line: 31, column: 14, scope: !130)
!155 = !DILocation(line: 32, column: 5, scope: !130)
!156 = !DILocation(line: 33, column: 5, scope: !130)
!157 = !DILocation(line: 34, column: 18, scope: !130)
!158 = !DILocation(line: 34, column: 5, scope: !130)
!159 = !DILocation(line: 35, column: 5, scope: !130)
