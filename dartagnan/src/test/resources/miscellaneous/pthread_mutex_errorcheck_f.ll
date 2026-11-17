; ModuleID = 'pthread_mutex_errorcheck_f.c'
source_filename = "pthread_mutex_errorcheck_f.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }
%union.pthread_mutexattr_t = type { i32 }

@initialized = dso_local global %union.pthread_mutex_t { %struct.__pthread_mutex_s { i32 0, i32 0, i32 0, i32 0, i32 2, i16 0, i16 0, %struct.__pthread_internal_list zeroinitializer } }, align 8, !dbg !0
@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1, !dbg !21
@.str.1 = private unnamed_addr constant [29 x i8] c"pthread_mutex_errorcheck_f.c\00", align 1, !dbg !27
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1, !dbg !32

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !77 {
  %1 = alloca i32, align 4
  %2 = alloca %union.pthread_mutex_t, align 8
  %3 = alloca %union.pthread_mutexattr_t, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !81, !DIExpression(), !82)
    #dbg_declare(ptr %3, !83, !DIExpression(), !92)
  %4 = call i32 @pthread_mutexattr_init(ptr noundef %3) #3, !dbg !93
  %5 = call i32 @pthread_mutexattr_settype(ptr noundef %3, i32 noundef 2) #3, !dbg !94
  %6 = call i32 @pthread_mutex_init(ptr noundef %2, ptr noundef %3) #3, !dbg !95
  %7 = call i32 @pthread_mutex_lock(ptr noundef %2) #3, !dbg !96
  %8 = call i32 @pthread_mutex_lock(ptr noundef %2) #3, !dbg !97
  %9 = call i32 @pthread_mutex_lock(ptr noundef @initialized) #3, !dbg !98
  %10 = call i32 @pthread_mutex_lock(ptr noundef @initialized) #3, !dbg !99
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 24, ptr noundef @__PRETTY_FUNCTION__.main) #4, !dbg !100
  unreachable, !dbg !100
}

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_init(ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_settype(ptr noundef, i32 noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(ptr noundef, ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(ptr noundef) #1

; Function Attrs: cold noreturn nounwind
declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { cold noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }
attributes #4 = { cold noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!69, !70, !71, !72, !73, !74, !75}
!llvm.ident = !{!76}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "initialized", scope: !2, file: !3, line: 8, type: !38, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 21.1.8 (6ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !18, globals: !20, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "pthread_mutex_errorcheck_f.c", directory: "/tmp/rm", checksumkind: CSK_MD5, checksum: "8fda0fa51c6546066a3a517f0f99f139")
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
!20 = !{!0, !21, !27, !32}
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(scope: null, file: !3, line: 24, type: !23, isLocal: true, isDefinition: true)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 16, elements: !25)
!24 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!25 = !{!26}
!26 = !DISubrange(count: 2)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(scope: null, file: !3, line: 24, type: !29, isLocal: true, isDefinition: true)
!29 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 232, elements: !30)
!30 = !{!31}
!31 = !DISubrange(count: 29)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(scope: null, file: !3, line: 24, type: !34, isLocal: true, isDefinition: true)
!34 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 88, elements: !36)
!35 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !24)
!36 = !{!37}
!37 = !DISubrange(count: 11)
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !39, line: 72, baseType: !40)
!39 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "cbf5435bd7bfed052b1a09633f314dde")
!40 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !39, line: 67, size: 320, elements: !41)
!41 = !{!42, !63, !67}
!42 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !40, file: !39, line: 69, baseType: !43, size: 320)
!43 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !44, line: 22, size: 320, elements: !45)
!44 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "c204e8f2bbee82104b0bc5a7e66bac71")
!45 = !{!46, !48, !49, !50, !51, !52, !54, !55}
!46 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !43, file: !44, line: 24, baseType: !47, size: 32)
!47 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !43, file: !44, line: 25, baseType: !7, size: 32, offset: 32)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !43, file: !44, line: 26, baseType: !47, size: 32, offset: 64)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !43, file: !44, line: 28, baseType: !7, size: 32, offset: 96)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !43, file: !44, line: 32, baseType: !47, size: 32, offset: 128)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !43, file: !44, line: 34, baseType: !53, size: 16, offset: 160)
!53 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "__unused", scope: !43, file: !44, line: 35, baseType: !53, size: 16, offset: 176)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !43, file: !44, line: 36, baseType: !56, size: 128, offset: 192)
!56 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !57, line: 55, baseType: !58)
!57 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "52a54ef04a6aeb244335b0bf6e6e1933")
!58 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !57, line: 51, size: 128, elements: !59)
!59 = !{!60, !62}
!60 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !58, file: !57, line: 53, baseType: !61, size: 64)
!61 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !58, size: 64)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !58, file: !57, line: 54, baseType: !61, size: 64, offset: 64)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !40, file: !39, line: 70, baseType: !64, size: 320)
!64 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 320, elements: !65)
!65 = !{!66}
!66 = !DISubrange(count: 40)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !40, file: !39, line: 71, baseType: !68, size: 64)
!68 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!69 = !{i32 7, !"Dwarf Version", i32 5}
!70 = !{i32 2, !"Debug Info Version", i32 3}
!71 = !{i32 1, !"wchar_size", i32 4}
!72 = !{i32 8, !"PIC Level", i32 2}
!73 = !{i32 7, !"PIE Level", i32 2}
!74 = !{i32 7, !"uwtable", i32 2}
!75 = !{i32 7, !"frame-pointer", i32 2}
!76 = !{!"Ubuntu clang version 21.1.8 (6ubuntu1)"}
!77 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 13, type: !78, scopeLine: 14, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !80)
!78 = !DISubroutineType(types: !79)
!79 = !{!47}
!80 = !{}
!81 = !DILocalVariable(name: "mutex", scope: !77, file: !3, line: 15, type: !38)
!82 = !DILocation(line: 15, column: 21, scope: !77)
!83 = !DILocalVariable(name: "attr", scope: !77, file: !3, line: 16, type: !84)
!84 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !39, line: 36, baseType: !85)
!85 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !39, line: 32, size: 32, elements: !86)
!86 = !{!87, !91}
!87 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !85, file: !39, line: 34, baseType: !88, size: 32)
!88 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 32, elements: !89)
!89 = !{!90}
!90 = !DISubrange(count: 4)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !85, file: !39, line: 35, baseType: !47, size: 32)
!92 = !DILocation(line: 16, column: 25, scope: !77)
!93 = !DILocation(line: 17, column: 5, scope: !77)
!94 = !DILocation(line: 18, column: 5, scope: !77)
!95 = !DILocation(line: 19, column: 5, scope: !77)
!96 = !DILocation(line: 20, column: 5, scope: !77)
!97 = !DILocation(line: 21, column: 5, scope: !77)
!98 = !DILocation(line: 22, column: 5, scope: !77)
!99 = !DILocation(line: 23, column: 5, scope: !77)
!100 = !DILocation(line: 24, column: 5, scope: !101)
!101 = distinct !DILexicalBlock(scope: !102, file: !3, line: 24, column: 5)
!102 = distinct !DILexicalBlock(scope: !77, file: !3, line: 24, column: 5)
