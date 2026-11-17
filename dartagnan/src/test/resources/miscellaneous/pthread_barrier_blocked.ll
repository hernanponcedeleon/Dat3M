; ModuleID = 'pthread_barrier_blocked.c'
source_filename = "pthread_barrier_blocked.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_barrier_t = type { i64, [24 x i8] }

@barrier = dso_local global %union.pthread_barrier_t zeroinitializer, align 8, !dbg !0
@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1, !dbg !7
@.str.1 = private unnamed_addr constant [26 x i8] c"pthread_barrier_blocked.c\00", align 1, !dbg !13
@__PRETTY_FUNCTION__.worker = private unnamed_addr constant [21 x i8] c"void *worker(void *)\00", align 1, !dbg !18

; Function Attrs: noinline nounwind optnone uwtable
define dso_local ptr @worker(ptr noundef %0) #0 !dbg !42 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !46, !DIExpression(), !47)
  %3 = call i32 @pthread_barrier_wait(ptr noundef @barrier) #3, !dbg !48
  %4 = call i32 @pthread_barrier_wait(ptr noundef @barrier) #3, !dbg !49
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 12, ptr noundef @__PRETTY_FUNCTION__.worker) #4, !dbg !50
  unreachable, !dbg !50
}

; Function Attrs: nounwind
declare i32 @pthread_barrier_wait(ptr noundef) #1

; Function Attrs: cold noreturn nounwind
declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !53 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !57, !DIExpression(), !60)
  %3 = call i32 @pthread_barrier_init(ptr noundef @barrier, ptr noundef null, i32 noundef 2) #3, !dbg !61
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @worker, ptr noundef null) #3, !dbg !62
  %5 = call i32 @pthread_barrier_wait(ptr noundef @barrier) #3, !dbg !63
  ret i32 0, !dbg !64
}

; Function Attrs: nounwind
declare i32 @pthread_barrier_init(ptr noundef, ptr noundef, i32 noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { cold noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }
attributes #4 = { cold noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!34, !35, !36, !37, !38, !39, !40}
!llvm.ident = !{!41}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "barrier", scope: !2, file: !3, line: 6, type: !24, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 21.1.8 (6ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "pthread_barrier_blocked.c", directory: "/tmp/ll", checksumkind: CSK_MD5, checksum: "bef3e72e0f64073192700cd8e002cbf7")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!7, !13, !18, !0}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !3, line: 12, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 16, elements: !11)
!10 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!11 = !{!12}
!12 = !DISubrange(count: 2)
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(scope: null, file: !3, line: 12, type: !15, isLocal: true, isDefinition: true)
!15 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 208, elements: !16)
!16 = !{!17}
!17 = !DISubrange(count: 26)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(scope: null, file: !3, line: 12, type: !20, isLocal: true, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 168, elements: !22)
!21 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !10)
!22 = !{!23}
!23 = !DISubrange(count: 21)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_barrier_t", file: !25, line: 112, baseType: !26)
!25 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "cbf5435bd7bfed052b1a09633f314dde")
!26 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !25, line: 108, size: 256, elements: !27)
!27 = !{!28, !32}
!28 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !26, file: !25, line: 110, baseType: !29, size: 256)
!29 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 256, elements: !30)
!30 = !{!31}
!31 = !DISubrange(count: 32)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !26, file: !25, line: 111, baseType: !33, size: 64)
!33 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!34 = !{i32 7, !"Dwarf Version", i32 5}
!35 = !{i32 2, !"Debug Info Version", i32 3}
!36 = !{i32 1, !"wchar_size", i32 4}
!37 = !{i32 8, !"PIC Level", i32 2}
!38 = !{i32 7, !"PIE Level", i32 2}
!39 = !{i32 7, !"uwtable", i32 2}
!40 = !{i32 7, !"frame-pointer", i32 2}
!41 = !{!"Ubuntu clang version 21.1.8 (6ubuntu1)"}
!42 = distinct !DISubprogram(name: "worker", scope: !3, file: !3, line: 8, type: !43, scopeLine: 9, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!43 = !DISubroutineType(types: !44)
!44 = !{!5, !5}
!45 = !{}
!46 = !DILocalVariable(name: "arg", arg: 1, scope: !42, file: !3, line: 8, type: !5)
!47 = !DILocation(line: 8, column: 20, scope: !42)
!48 = !DILocation(line: 10, column: 5, scope: !42)
!49 = !DILocation(line: 11, column: 5, scope: !42)
!50 = !DILocation(line: 12, column: 5, scope: !51)
!51 = distinct !DILexicalBlock(scope: !52, file: !3, line: 12, column: 5)
!52 = distinct !DILexicalBlock(scope: !42, file: !3, line: 12, column: 5)
!53 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 16, type: !54, scopeLine: 17, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!54 = !DISubroutineType(types: !55)
!55 = !{!56}
!56 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!57 = !DILocalVariable(name: "t", scope: !53, file: !3, line: 18, type: !58)
!58 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !25, line: 27, baseType: !59)
!59 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!60 = !DILocation(line: 18, column: 15, scope: !53)
!61 = !DILocation(line: 19, column: 5, scope: !53)
!62 = !DILocation(line: 20, column: 5, scope: !53)
!63 = !DILocation(line: 21, column: 5, scope: !53)
!64 = !DILocation(line: 22, column: 5, scope: !53)
