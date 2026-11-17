; ModuleID = 'pthread_mutex_recursive_f.c'
source_filename = "pthread_mutex_recursive_f.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }
%union.pthread_mutexattr_t = type { i32 }

@mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !0
@counter = dso_local global i32 0, align 4, !dbg !37
@.str = private unnamed_addr constant [13 x i8] c"counter == 4\00", align 1, !dbg !20
@.str.1 = private unnamed_addr constant [28 x i8] c"pthread_mutex_recursive_f.c\00", align 1, !dbg !26
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1, !dbg !31

; Function Attrs: noinline nounwind optnone uwtable
define dso_local ptr @worker(ptr noundef %0) #0 !dbg !78 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !82, !DIExpression(), !83)
  %3 = call i32 @pthread_mutex_lock(ptr noundef @mutex) #4, !dbg !84
  %4 = call i32 @pthread_mutex_lock(ptr noundef @mutex) #4, !dbg !85
  %5 = load i32, ptr @counter, align 4, !dbg !86
  %6 = add nsw i32 %5, 1, !dbg !86
  store i32 %6, ptr @counter, align 4, !dbg !86
  %7 = call i32 @pthread_mutex_unlock(ptr noundef @mutex) #4, !dbg !87
  %8 = call i32 @pthread_mutex_unlock(ptr noundef @mutex) #4, !dbg !88
  %9 = load i32, ptr @counter, align 4, !dbg !89
  %10 = add nsw i32 %9, 1, !dbg !89
  store i32 %10, ptr @counter, align 4, !dbg !89
  ret ptr null, !dbg !90
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(ptr noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !91 {
  %1 = alloca i32, align 4
  %2 = alloca %union.pthread_mutexattr_t, align 4
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !94, !DIExpression(), !103)
  %5 = call i32 @pthread_mutexattr_init(ptr noundef %2) #4, !dbg !104
  %6 = call i32 @pthread_mutexattr_settype(ptr noundef %2, i32 noundef 1) #4, !dbg !105
  %7 = call i32 @pthread_mutex_init(ptr noundef @mutex, ptr noundef %2) #4, !dbg !106
    #dbg_declare(ptr %3, !107, !DIExpression(), !110)
    #dbg_declare(ptr %4, !111, !DIExpression(), !112)
  %8 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @worker, ptr noundef null) #4, !dbg !113
  %9 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @worker, ptr noundef null) #4, !dbg !114
  %10 = load i64, ptr %3, align 8, !dbg !115
  %11 = call i32 @pthread_join(i64 noundef %10, ptr noundef null), !dbg !116
  %12 = load i64, ptr %4, align 8, !dbg !117
  %13 = call i32 @pthread_join(i64 noundef %12, ptr noundef null), !dbg !118
  %14 = load i32, ptr @counter, align 4, !dbg !119
  %15 = icmp eq i32 %14, 4, !dbg !119
  br i1 %15, label %16, label %17, !dbg !119

16:                                               ; preds = %0
  br label %18, !dbg !119

17:                                               ; preds = %0
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 32, ptr noundef @__PRETTY_FUNCTION__.main) #5, !dbg !119
  unreachable, !dbg !119

18:                                               ; preds = %16
  ret i32 0, !dbg !122
}

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_init(ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_settype(ptr noundef, i32 noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(ptr noundef, ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @pthread_join(i64 noundef, ptr noundef) #2

; Function Attrs: cold noreturn nounwind
declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #3

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { cold noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }
attributes #5 = { cold noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!70, !71, !72, !73, !74, !75, !76}
!llvm.ident = !{!77}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "mutex", scope: !2, file: !3, line: 6, type: !40, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 21.1.8 (6ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !17, globals: !19, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "pthread_mutex_recursive_f.c", directory: "/tmp/rm", checksumkind: CSK_MD5, checksum: "910d7f8e7a035a075d7b227947c26210")
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
!19 = !{!20, !26, !31, !0, !37}
!20 = !DIGlobalVariableExpression(var: !21, expr: !DIExpression())
!21 = distinct !DIGlobalVariable(scope: null, file: !3, line: 32, type: !22, isLocal: true, isDefinition: true)
!22 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 104, elements: !24)
!23 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!24 = !{!25}
!25 = !DISubrange(count: 13)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(scope: null, file: !3, line: 32, type: !28, isLocal: true, isDefinition: true)
!28 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 224, elements: !29)
!29 = !{!30}
!30 = !DISubrange(count: 28)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(scope: null, file: !3, line: 32, type: !33, isLocal: true, isDefinition: true)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 88, elements: !35)
!34 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !23)
!35 = !{!36}
!36 = !DISubrange(count: 11)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(name: "counter", scope: !2, file: !3, line: 7, type: !39, isLocal: false, isDefinition: true)
!39 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!40 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !41, line: 72, baseType: !42)
!41 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "cbf5435bd7bfed052b1a09633f314dde")
!42 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !41, line: 67, size: 320, elements: !43)
!43 = !{!44, !64, !68}
!44 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !42, file: !41, line: 69, baseType: !45, size: 320)
!45 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !46, line: 22, size: 320, elements: !47)
!46 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "c204e8f2bbee82104b0bc5a7e66bac71")
!47 = !{!48, !49, !50, !51, !52, !53, !55, !56}
!48 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !45, file: !46, line: 24, baseType: !39, size: 32)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !45, file: !46, line: 25, baseType: !7, size: 32, offset: 32)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !45, file: !46, line: 26, baseType: !39, size: 32, offset: 64)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !45, file: !46, line: 28, baseType: !7, size: 32, offset: 96)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !45, file: !46, line: 32, baseType: !39, size: 32, offset: 128)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !45, file: !46, line: 34, baseType: !54, size: 16, offset: 160)
!54 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "__unused", scope: !45, file: !46, line: 35, baseType: !54, size: 16, offset: 176)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !45, file: !46, line: 36, baseType: !57, size: 128, offset: 192)
!57 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !58, line: 55, baseType: !59)
!58 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "52a54ef04a6aeb244335b0bf6e6e1933")
!59 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !58, line: 51, size: 128, elements: !60)
!60 = !{!61, !63}
!61 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !59, file: !58, line: 53, baseType: !62, size: 64)
!62 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !59, size: 64)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !59, file: !58, line: 54, baseType: !62, size: 64, offset: 64)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !42, file: !41, line: 70, baseType: !65, size: 320)
!65 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 320, elements: !66)
!66 = !{!67}
!67 = !DISubrange(count: 40)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !42, file: !41, line: 71, baseType: !69, size: 64)
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
!84 = !DILocation(line: 11, column: 5, scope: !78)
!85 = !DILocation(line: 12, column: 5, scope: !78)
!86 = !DILocation(line: 13, column: 12, scope: !78)
!87 = !DILocation(line: 14, column: 5, scope: !78)
!88 = !DILocation(line: 15, column: 5, scope: !78)
!89 = !DILocation(line: 16, column: 12, scope: !78)
!90 = !DILocation(line: 17, column: 5, scope: !78)
!91 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 20, type: !92, scopeLine: 21, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !81)
!92 = !DISubroutineType(types: !93)
!93 = !{!39}
!94 = !DILocalVariable(name: "attr", scope: !91, file: !3, line: 22, type: !95)
!95 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !41, line: 36, baseType: !96)
!96 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !41, line: 32, size: 32, elements: !97)
!97 = !{!98, !102}
!98 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !96, file: !41, line: 34, baseType: !99, size: 32)
!99 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 32, elements: !100)
!100 = !{!101}
!101 = !DISubrange(count: 4)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !96, file: !41, line: 35, baseType: !39, size: 32)
!103 = !DILocation(line: 22, column: 25, scope: !91)
!104 = !DILocation(line: 23, column: 5, scope: !91)
!105 = !DILocation(line: 24, column: 5, scope: !91)
!106 = !DILocation(line: 25, column: 5, scope: !91)
!107 = !DILocalVariable(name: "t0", scope: !91, file: !3, line: 27, type: !108)
!108 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !41, line: 27, baseType: !109)
!109 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!110 = !DILocation(line: 27, column: 15, scope: !91)
!111 = !DILocalVariable(name: "t1", scope: !91, file: !3, line: 27, type: !108)
!112 = !DILocation(line: 27, column: 19, scope: !91)
!113 = !DILocation(line: 28, column: 5, scope: !91)
!114 = !DILocation(line: 29, column: 5, scope: !91)
!115 = !DILocation(line: 30, column: 18, scope: !91)
!116 = !DILocation(line: 30, column: 5, scope: !91)
!117 = !DILocation(line: 31, column: 18, scope: !91)
!118 = !DILocation(line: 31, column: 5, scope: !91)
!119 = !DILocation(line: 32, column: 5, scope: !120)
!120 = distinct !DILexicalBlock(scope: !121, file: !3, line: 32, column: 5)
!121 = distinct !DILexicalBlock(scope: !91, file: !3, line: 32, column: 5)
!122 = !DILocation(line: 33, column: 5, scope: !91)
