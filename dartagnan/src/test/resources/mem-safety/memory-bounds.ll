; ModuleID = 'benchmarks/mem-safety/memory-bounds.c'
source_filename = "benchmarks/mem-safety/memory-bounds.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@buf = dso_local global ptr null, align 8, !dbg !0
@neighbor = dso_local global ptr null, align 8, !dbg !5

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @worker(ptr noundef %0) #0 !dbg !16 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !21, !DIExpression(), !22)
    #dbg_declare(ptr %3, !23, !DIExpression(), !25)
  store i32 0, ptr %3, align 4, !dbg !25
  br label %4, !dbg !26

4:                                                ; preds = %13, %1
  %5 = load i32, ptr %3, align 4, !dbg !27
  %6 = icmp slt i32 %5, 4, !dbg !29
  br i1 %6, label %7, label %16, !dbg !30

7:                                                ; preds = %4
  %8 = load i32, ptr %3, align 4, !dbg !31
  %9 = load ptr, ptr @buf, align 8, !dbg !33
  %10 = load i32, ptr %3, align 4, !dbg !34
  %11 = sext i32 %10 to i64, !dbg !33
  %12 = getelementptr inbounds i32, ptr %9, i64 %11, !dbg !33
  store i32 %8, ptr %12, align 4, !dbg !35
  br label %13, !dbg !36

13:                                               ; preds = %7
  %14 = load i32, ptr %3, align 4, !dbg !37
  %15 = add nsw i32 %14, 1, !dbg !37
  store i32 %15, ptr %3, align 4, !dbg !37
  br label %4, !dbg !38, !llvm.loop !39

16:                                               ; preds = %4
  ret ptr null, !dbg !42
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !43 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  store i32 0, ptr %1, align 4
  %3 = call noalias ptr @malloc(i64 noundef 16) #4, !dbg !46
  store ptr %3, ptr @buf, align 8, !dbg !47
  %4 = call noalias ptr @malloc(i64 noundef 16) #4, !dbg !48
  store ptr %4, ptr @neighbor, align 8, !dbg !49
  %5 = load ptr, ptr @buf, align 8, !dbg !50
  %6 = icmp eq ptr %5, null, !dbg !52
  br i1 %6, label %10, label %7, !dbg !53

7:                                                ; preds = %0
  %8 = load ptr, ptr @neighbor, align 8, !dbg !54
  %9 = icmp eq ptr %8, null, !dbg !55
  br i1 %9, label %10, label %11, !dbg !53

10:                                               ; preds = %7, %0
  store i32 0, ptr %1, align 4, !dbg !56
  br label %15, !dbg !56

11:                                               ; preds = %7
    #dbg_declare(ptr %2, !57, !DIExpression(), !61)
  %12 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @worker, ptr noundef null) #5, !dbg !62
  %13 = load i64, ptr %2, align 8, !dbg !63
  %14 = call i32 @pthread_join(i64 noundef %13, ptr noundef null), !dbg !64
  store i32 0, ptr %1, align 4, !dbg !65
  br label %15, !dbg !65

15:                                               ; preds = %11, %10
  %16 = load i32, ptr %1, align 4, !dbg !66
  ret i32 %16, !dbg !66
}

; Function Attrs: nounwind allocsize(0)
declare noalias ptr @malloc(i64 noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare i32 @pthread_join(i64 noundef, ptr noundef) #3

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind allocsize(0) }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!9, !10, !11, !12, !13, !14}
!llvm.ident = !{!15}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "buf", scope: !2, file: !3, line: 21, type: !7, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 23.1.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/miscellaneous/memory-bounds.c", directory: ".", checksumkind: CSK_MD5, checksum: "b51cb625d0840cacf16fab229e37ca34")
!4 = !{!0, !5}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(name: "neighbor", scope: !2, file: !3, line: 22, type: !7, isLocal: false, isDefinition: true)
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64)
!8 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!9 = !{i32 7, !"Dwarf Version", i32 5}
!10 = !{i32 2, !"Debug Info Version", i32 3}
!11 = !{i32 8, !"PIC Level", i32 2}
!12 = !{i32 7, !"PIE Level", i32 2}
!13 = !{i32 7, !"uwtable", i32 2}
!14 = !{i32 7, !"frame-pointer", i32 2}
!15 = !{!"Homebrew clang version 23.1.0"}
!16 = distinct !DISubprogram(name: "worker", scope: !3, file: !3, line: 24, type: !17, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !20)
!17 = !DISubroutineType(types: !18)
!18 = !{!19, !19}
!19 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!20 = !{}
!21 = !DILocalVariable(name: "arg", arg: 1, scope: !16, file: !3, line: 24, type: !19)
!22 = !DILocation(line: 24, column: 20, scope: !16)
!23 = !DILocalVariable(name: "i", scope: !24, file: !3, line: 25, type: !8)
!24 = distinct !DILexicalBlock(scope: !16, file: !3, line: 25, column: 5)
!25 = !DILocation(line: 25, column: 14, scope: !24)
!26 = !DILocation(line: 25, column: 10, scope: !24)
!27 = !DILocation(line: 25, column: 21, scope: !28)
!28 = distinct !DILexicalBlock(scope: !24, file: !3, line: 25, column: 5)
!29 = !DILocation(line: 25, column: 23, scope: !28)
!30 = !DILocation(line: 25, column: 5, scope: !24)
!31 = !DILocation(line: 26, column: 18, scope: !32)
!32 = distinct !DILexicalBlock(scope: !28, file: !3, line: 25, column: 37)
!33 = !DILocation(line: 26, column: 9, scope: !32)
!34 = !DILocation(line: 26, column: 13, scope: !32)
!35 = !DILocation(line: 26, column: 16, scope: !32)
!36 = !DILocation(line: 27, column: 5, scope: !32)
!37 = !DILocation(line: 25, column: 33, scope: !28)
!38 = !DILocation(line: 25, column: 5, scope: !28)
!39 = distinct !{!39, !30, !40, !41}
!40 = !DILocation(line: 27, column: 5, scope: !24)
!41 = !{!"llvm.loop.mustprogress"}
!42 = !DILocation(line: 28, column: 5, scope: !16)
!43 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 31, type: !44, scopeLine: 31, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !20)
!44 = !DISubroutineType(types: !45)
!45 = !{!8}
!46 = !DILocation(line: 32, column: 11, scope: !43)
!47 = !DILocation(line: 32, column: 9, scope: !43)
!48 = !DILocation(line: 33, column: 16, scope: !43)
!49 = !DILocation(line: 33, column: 14, scope: !43)
!50 = !DILocation(line: 34, column: 9, scope: !51)
!51 = distinct !DILexicalBlock(scope: !43, file: !3, line: 34, column: 9)
!52 = !DILocation(line: 34, column: 13, scope: !51)
!53 = !DILocation(line: 34, column: 18, scope: !51)
!54 = !DILocation(line: 34, column: 21, scope: !51)
!55 = !DILocation(line: 34, column: 30, scope: !51)
!56 = !DILocation(line: 34, column: 36, scope: !51)
!57 = !DILocalVariable(name: "t", scope: !43, file: !3, line: 35, type: !58)
!58 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !59, line: 27, baseType: !60)
!59 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!60 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!61 = !DILocation(line: 35, column: 15, scope: !43)
!62 = !DILocation(line: 36, column: 5, scope: !43)
!63 = !DILocation(line: 37, column: 18, scope: !43)
!64 = !DILocation(line: 37, column: 5, scope: !43)
!65 = !DILocation(line: 38, column: 5, scope: !43)
!66 = !DILocation(line: 39, column: 1, scope: !43)
