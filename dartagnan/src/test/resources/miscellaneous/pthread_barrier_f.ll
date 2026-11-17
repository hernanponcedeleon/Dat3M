; ModuleID = 'pthread_barrier_f.c'
source_filename = "pthread_barrier_f.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_barrier_t = type { i64, [24 x i8] }

@barrier = dso_local global %union.pthread_barrier_t zeroinitializer, align 8, !dbg !0
@.str = private unnamed_addr constant [64 x i8] c"pthread_barrier_wait(&barrier) != PTHREAD_BARRIER_SERIAL_THREAD\00", align 1, !dbg !7
@.str.1 = private unnamed_addr constant [20 x i8] c"pthread_barrier_f.c\00", align 1, !dbg !13
@__PRETTY_FUNCTION__.worker = private unnamed_addr constant [21 x i8] c"void *worker(void *)\00", align 1, !dbg !18

; Function Attrs: noinline nounwind optnone uwtable
define dso_local ptr @worker(ptr noundef %0) #0 !dbg !42 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !46, !DIExpression(), !47)
  %3 = call i32 @pthread_barrier_wait(ptr noundef @barrier) #4, !dbg !48
  %4 = icmp ne i32 %3, -1, !dbg !48
  br i1 %4, label %5, label %6, !dbg !48

5:                                                ; preds = %1
  br label %7, !dbg !48

6:                                                ; preds = %1
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 10, ptr noundef @__PRETTY_FUNCTION__.worker) #5, !dbg !48
  unreachable, !dbg !48

7:                                                ; preds = %5
  ret ptr null, !dbg !51
}

; Function Attrs: nounwind
declare i32 @pthread_barrier_wait(ptr noundef) #1

; Function Attrs: cold noreturn nounwind
declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !52 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !56, !DIExpression(), !59)
    #dbg_declare(ptr %3, !60, !DIExpression(), !61)
  %4 = call i32 @pthread_barrier_init(ptr noundef @barrier, ptr noundef null, i32 noundef 2) #4, !dbg !62
  %5 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @worker, ptr noundef null) #4, !dbg !63
  %6 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @worker, ptr noundef null) #4, !dbg !64
  %7 = load i64, ptr %2, align 8, !dbg !65
  %8 = call i32 @pthread_join(i64 noundef %7, ptr noundef null), !dbg !66
  %9 = load i64, ptr %3, align 8, !dbg !67
  %10 = call i32 @pthread_join(i64 noundef %9, ptr noundef null), !dbg !68
  ret i32 0, !dbg !69
}

; Function Attrs: nounwind
declare i32 @pthread_barrier_init(ptr noundef, ptr noundef, i32 noundef) #1

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
!llvm.module.flags = !{!34, !35, !36, !37, !38, !39, !40}
!llvm.ident = !{!41}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "barrier", scope: !2, file: !3, line: 6, type: !24, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 21.1.8 (6ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "pthread_barrier_f.c", directory: "/tmp/ll", checksumkind: CSK_MD5, checksum: "763c6412c76b7ee968682e605e58850f")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!7, !13, !18, !0}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !3, line: 10, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 512, elements: !11)
!10 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!11 = !{!12}
!12 = !DISubrange(count: 64)
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(scope: null, file: !3, line: 10, type: !15, isLocal: true, isDefinition: true)
!15 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 160, elements: !16)
!16 = !{!17}
!17 = !DISubrange(count: 20)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(scope: null, file: !3, line: 10, type: !20, isLocal: true, isDefinition: true)
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
!48 = !DILocation(line: 10, column: 5, scope: !49)
!49 = distinct !DILexicalBlock(scope: !50, file: !3, line: 10, column: 5)
!50 = distinct !DILexicalBlock(scope: !42, file: !3, line: 10, column: 5)
!51 = !DILocation(line: 11, column: 5, scope: !42)
!52 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 14, type: !53, scopeLine: 15, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!53 = !DISubroutineType(types: !54)
!54 = !{!55}
!55 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!56 = !DILocalVariable(name: "t0", scope: !52, file: !3, line: 16, type: !57)
!57 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !25, line: 27, baseType: !58)
!58 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!59 = !DILocation(line: 16, column: 15, scope: !52)
!60 = !DILocalVariable(name: "t1", scope: !52, file: !3, line: 16, type: !57)
!61 = !DILocation(line: 16, column: 19, scope: !52)
!62 = !DILocation(line: 17, column: 5, scope: !52)
!63 = !DILocation(line: 18, column: 5, scope: !52)
!64 = !DILocation(line: 19, column: 5, scope: !52)
!65 = !DILocation(line: 20, column: 18, scope: !52)
!66 = !DILocation(line: 20, column: 5, scope: !52)
!67 = !DILocation(line: 21, column: 18, scope: !52)
!68 = !DILocation(line: 21, column: 5, scope: !52)
!69 = !DILocation(line: 22, column: 5, scope: !52)
