; ModuleID = 'pthread_barrier_f.c'
source_filename = "pthread_barrier_f.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_barrier_t = type { i64, [24 x i8] }

@data = dso_local global [2 x i32] zeroinitializer, align 4, !dbg !0
@.str = private unnamed_addr constant [17 x i8] c"data[1 - i] == 1\00", align 1, !dbg !11
@.str.1 = private unnamed_addr constant [20 x i8] c"pthread_barrier_f.c\00", align 1, !dbg !17
@__PRETTY_FUNCTION__.worker = private unnamed_addr constant [21 x i8] c"void *worker(void *)\00", align 1, !dbg !22
@barrier = dso_local global %union.pthread_barrier_t zeroinitializer, align 8, !dbg !28

; Function Attrs: noinline nounwind optnone uwtable
define dso_local ptr @worker(ptr noundef %0) #0 !dbg !50 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !54, !DIExpression(), !55)
    #dbg_declare(ptr %3, !56, !DIExpression(), !57)
  %4 = load ptr, ptr %2, align 8, !dbg !58
  %5 = ptrtoint ptr %4 to i64, !dbg !59
  %6 = trunc i64 %5 to i32, !dbg !60
  store i32 %6, ptr %3, align 4, !dbg !57
  %7 = load i32, ptr %3, align 4, !dbg !61
  %8 = sext i32 %7 to i64, !dbg !62
  %9 = getelementptr inbounds [2 x i32], ptr @data, i64 0, i64 %8, !dbg !62
  store i32 1, ptr %9, align 4, !dbg !63
  %10 = load i32, ptr %3, align 4, !dbg !64
  %11 = sub nsw i32 1, %10, !dbg !64
  %12 = sext i32 %11 to i64, !dbg !64
  %13 = getelementptr inbounds [2 x i32], ptr @data, i64 0, i64 %12, !dbg !64
  %14 = load i32, ptr %13, align 4, !dbg !64
  %15 = icmp eq i32 %14, 1, !dbg !64
  br i1 %15, label %16, label %17, !dbg !64

16:                                               ; preds = %1
  br label %18, !dbg !64

17:                                               ; preds = %1
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 14, ptr noundef @__PRETTY_FUNCTION__.worker) #4, !dbg !64
  unreachable, !dbg !64

18:                                               ; preds = %16
  %19 = call i32 @pthread_barrier_wait(ptr noundef @barrier) #5, !dbg !67
  ret ptr null, !dbg !68
}

; Function Attrs: cold noreturn nounwind
declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_barrier_wait(ptr noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !69 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !72, !DIExpression(), !75)
    #dbg_declare(ptr %3, !76, !DIExpression(), !77)
  %4 = call i32 @pthread_barrier_init(ptr noundef @barrier, ptr noundef null, i32 noundef 2) #5, !dbg !78
  %5 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @worker, ptr noundef null) #5, !dbg !79
  %6 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @worker, ptr noundef inttoptr (i64 1 to ptr)) #5, !dbg !80
  %7 = load i64, ptr %2, align 8, !dbg !81
  %8 = call i32 @pthread_join(i64 noundef %7, ptr noundef null), !dbg !82
  %9 = load i64, ptr %3, align 8, !dbg !83
  %10 = call i32 @pthread_join(i64 noundef %9, ptr noundef null), !dbg !84
  ret i32 0, !dbg !85
}

; Function Attrs: nounwind
declare i32 @pthread_barrier_init(ptr noundef, ptr noundef, i32 noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare i32 @pthread_join(i64 noundef, ptr noundef) #3

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { cold noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { cold noreturn nounwind }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!42, !43, !44, !45, !46, !47, !48}
!llvm.ident = !{!49}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !3, line: 8, type: !39, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 21.1.8 (6ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !10, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "pthread_barrier_f.c", directory: "/tmp/ll", checksumkind: CSK_MD5, checksum: "f2a8421c6f9326afa7703c324a2fa907")
!4 = !{!5, !6, !9}
!5 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !7, line: 80, baseType: !8)
!7 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "271af118c99df098fe315fa3d1c635c4")
!8 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!9 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!10 = !{!11, !17, !22, !28, !0}
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(scope: null, file: !3, line: 14, type: !13, isLocal: true, isDefinition: true)
!13 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 136, elements: !15)
!14 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!15 = !{!16}
!16 = !DISubrange(count: 17)
!17 = !DIGlobalVariableExpression(var: !18, expr: !DIExpression())
!18 = distinct !DIGlobalVariable(scope: null, file: !3, line: 14, type: !19, isLocal: true, isDefinition: true)
!19 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 160, elements: !20)
!20 = !{!21}
!21 = !DISubrange(count: 20)
!22 = !DIGlobalVariableExpression(var: !23, expr: !DIExpression())
!23 = distinct !DIGlobalVariable(scope: null, file: !3, line: 14, type: !24, isLocal: true, isDefinition: true)
!24 = !DICompositeType(tag: DW_TAG_array_type, baseType: !25, size: 168, elements: !26)
!25 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !14)
!26 = !{!27}
!27 = !DISubrange(count: 21)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(name: "barrier", scope: !2, file: !3, line: 7, type: !30, isLocal: false, isDefinition: true)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_barrier_t", file: !31, line: 112, baseType: !32)
!31 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "cbf5435bd7bfed052b1a09633f314dde")
!32 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !31, line: 108, size: 256, elements: !33)
!33 = !{!34, !38}
!34 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !32, file: !31, line: 110, baseType: !35, size: 256)
!35 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 256, elements: !36)
!36 = !{!37}
!37 = !DISubrange(count: 32)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !32, file: !31, line: 111, baseType: !8, size: 64)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 64, elements: !40)
!40 = !{!41}
!41 = !DISubrange(count: 2)
!42 = !{i32 7, !"Dwarf Version", i32 5}
!43 = !{i32 2, !"Debug Info Version", i32 3}
!44 = !{i32 1, !"wchar_size", i32 4}
!45 = !{i32 8, !"PIC Level", i32 2}
!46 = !{i32 7, !"PIE Level", i32 2}
!47 = !{i32 7, !"uwtable", i32 2}
!48 = !{i32 7, !"frame-pointer", i32 2}
!49 = !{!"Ubuntu clang version 21.1.8 (6ubuntu1)"}
!50 = distinct !DISubprogram(name: "worker", scope: !3, file: !3, line: 10, type: !51, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !53)
!51 = !DISubroutineType(types: !52)
!52 = !{!9, !9}
!53 = !{}
!54 = !DILocalVariable(name: "arg", arg: 1, scope: !50, file: !3, line: 10, type: !9)
!55 = !DILocation(line: 10, column: 20, scope: !50)
!56 = !DILocalVariable(name: "i", scope: !50, file: !3, line: 12, type: !5)
!57 = !DILocation(line: 12, column: 9, scope: !50)
!58 = !DILocation(line: 12, column: 28, scope: !50)
!59 = !DILocation(line: 12, column: 18, scope: !50)
!60 = !DILocation(line: 12, column: 13, scope: !50)
!61 = !DILocation(line: 13, column: 10, scope: !50)
!62 = !DILocation(line: 13, column: 5, scope: !50)
!63 = !DILocation(line: 13, column: 13, scope: !50)
!64 = !DILocation(line: 14, column: 5, scope: !65)
!65 = distinct !DILexicalBlock(scope: !66, file: !3, line: 14, column: 5)
!66 = distinct !DILexicalBlock(scope: !50, file: !3, line: 14, column: 5)
!67 = !DILocation(line: 15, column: 5, scope: !50)
!68 = !DILocation(line: 16, column: 5, scope: !50)
!69 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 19, type: !70, scopeLine: 20, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !53)
!70 = !DISubroutineType(types: !71)
!71 = !{!5}
!72 = !DILocalVariable(name: "t0", scope: !69, file: !3, line: 21, type: !73)
!73 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !31, line: 27, baseType: !74)
!74 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!75 = !DILocation(line: 21, column: 15, scope: !69)
!76 = !DILocalVariable(name: "t1", scope: !69, file: !3, line: 21, type: !73)
!77 = !DILocation(line: 21, column: 19, scope: !69)
!78 = !DILocation(line: 22, column: 5, scope: !69)
!79 = !DILocation(line: 23, column: 5, scope: !69)
!80 = !DILocation(line: 24, column: 5, scope: !69)
!81 = !DILocation(line: 25, column: 18, scope: !69)
!82 = !DILocation(line: 25, column: 5, scope: !69)
!83 = !DILocation(line: 26, column: 18, scope: !69)
!84 = !DILocation(line: 26, column: 5, scope: !69)
!85 = !DILocation(line: 27, column: 5, scope: !69)
