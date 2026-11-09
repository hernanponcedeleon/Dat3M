; ModuleID = 'benchmarks/miscellaneous/ilp32-ubsan.c'
source_filename = "benchmarks/miscellaneous/ilp32-ubsan.c"
target datalayout = "e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-i128:128-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@.src = private unnamed_addr constant [39 x i8] c"benchmarks/miscellaneous/ilp32-ubsan.c\00", align 1
@0 = private unnamed_addr global { { ptr, i32, i32 } } { { ptr, i32, i32 } { ptr @.src, i32 16, i32 51 } }
@1 = private unnamed_addr constant { i16, i16, [12 x i8] } { i16 0, i16 13, [12 x i8] c"'long long'\00" }
@2 = private unnamed_addr global { { ptr, i32, i32 }, ptr } { { ptr, i32, i32 } { ptr @.src, i32 23, i32 21 }, ptr @1 }

; Function Attrs: noinline nounwind uwtable
define dso_local void @assume_abort_if_not(i32 noundef %0) #0 !dbg !11 !func_sanitize !16 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
    #dbg_declare(ptr %2, !17, !DIExpression(), !18)
  %3 = load i32, ptr %2, align 4, !dbg !19
  %4 = icmp ne i32 %3, 0, !dbg !19
  br i1 %4, label %8, label %5, !dbg !21

5:                                                ; preds = %1
  call void @abort() #6, !dbg !22
  br i1 false, label %7, label %6, !dbg !22, !prof !24, !nosanitize !15

6:                                                ; preds = %5
  call void @__ubsan_handle_builtin_unreachable(ptr @0) #7, !dbg !22, !nosanitize !15
  unreachable, !dbg !22, !nosanitize !15

7:                                                ; preds = %5
  unreachable, !dbg !22

8:                                                ; preds = %1
  ret void, !dbg !25
}

; Function Attrs: nounwind
declare void @abort() #1

; Function Attrs: noreturn nounwind uwtable
declare void @__ubsan_handle_builtin_unreachable(ptr) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !26 !func_sanitize !29 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !30, !DIExpression(), !32)
  %6 = call i64 @__VERIFIER_nondet_longlong(), !dbg !33
  store i64 %6, ptr %2, align 8, !dbg !32
  %7 = load i64, ptr %2, align 8, !dbg !34
  %8 = icmp slt i64 %7, 9223372036854775807, !dbg !35
  %9 = zext i1 %8 to i32, !dbg !35
  call void @assume_abort_if_not(i32 noundef %9), !dbg !36
    #dbg_declare(ptr %3, !37, !DIExpression(), !38)
  %10 = load i64, ptr %2, align 8, !dbg !39
  %11 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %10, i64 1), !dbg !40, !nosanitize !15
  %12 = extractvalue { i64, i1 } %11, 0, !dbg !40, !nosanitize !15
  %13 = extractvalue { i64, i1 } %11, 1, !dbg !40, !nosanitize !15
  %14 = xor i1 %13, true, !dbg !40, !nosanitize !15
  br i1 %14, label %18, label %15, !dbg !40, !prof !24, !nosanitize !15

15:                                               ; preds = %0
  store i64 %10, ptr %4, align 8, !dbg !40, !nosanitize !15
  %16 = ptrtoint ptr %4 to i32, !dbg !40, !nosanitize !15
  store i64 1, ptr %5, align 8, !dbg !40, !nosanitize !15
  %17 = ptrtoint ptr %5 to i32, !dbg !40, !nosanitize !15
  call void @__ubsan_handle_add_overflow(ptr @2, i32 %16, i32 %17) #8, !dbg !40, !nosanitize !15
  br label %18, !dbg !40, !nosanitize !15

18:                                               ; preds = %15, %0
  store i64 %12, ptr %3, align 8, !dbg !38
  %19 = load i64, ptr %3, align 8, !dbg !41
  %20 = load i64, ptr %2, align 8, !dbg !42
  %21 = icmp sgt i64 %19, %20, !dbg !43
  %22 = zext i1 %21 to i32, !dbg !43
  ret i32 %22, !dbg !44
}

declare i64 @__VERIFIER_nondet_longlong() #3

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare { i64, i1 } @llvm.sadd.with.overflow.i64(i64, i64) #4

; Function Attrs: uwtable
declare void @__ubsan_handle_add_overflow(ptr, i32, i32) #5

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { noreturn nounwind uwtable }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) }
attributes #5 = { uwtable }
attributes #6 = { nounwind }
attributes #7 = { nomerge noreturn nounwind }
attributes #8 = { nomerge nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7, !8, !9}
!llvm.ident = !{!10}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "Homebrew clang version 22.1.8", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "benchmarks/miscellaneous/ilp32-ubsan.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "9242fca185c986a396b8d2c63544c24b")
!2 = !{i32 1, !"NumRegisterParameters", i32 0}
!3 = !{i32 7, !"Dwarf Version", i32 5}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{i32 8, !"PIC Level", i32 2}
!7 = !{i32 7, !"PIE Level", i32 2}
!8 = !{i32 7, !"uwtable", i32 2}
!9 = !{i32 7, !"frame-pointer", i32 2}
!10 = !{!"Homebrew clang version 22.1.8"}
!11 = distinct !DISubprogram(name: "assume_abort_if_not", scope: !1, file: !1, line: 16, type: !12, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !15)
!12 = !DISubroutineType(types: !13)
!13 = !{null, !14}
!14 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!15 = !{}
!16 = !{i32 -1056584962, i32 -1988405058}
!17 = !DILocalVariable(name: "cond", arg: 1, scope: !11, file: !1, line: 16, type: !14)
!18 = !DILocation(line: 16, column: 30, scope: !11)
!19 = !DILocation(line: 16, column: 43, scope: !20)
!20 = distinct !DILexicalBlock(scope: !11, file: !1, line: 16, column: 42)
!21 = !DILocation(line: 16, column: 42, scope: !20)
!22 = !DILocation(line: 16, column: 51, scope: !23)
!23 = distinct !DILexicalBlock(scope: !20, file: !1, line: 16, column: 49)
!24 = !{!"branch_weights", i32 1048575, i32 1}
!25 = !DILocation(line: 16, column: 62, scope: !11)
!26 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 18, type: !27, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !15)
!27 = !DISubroutineType(types: !28)
!28 = !{!14}
!29 = !{i32 -1056584962, i32 901845932}
!30 = !DILocalVariable(name: "a", scope: !26, file: !1, line: 19, type: !31)
!31 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!32 = !DILocation(line: 19, column: 15, scope: !26)
!33 = !DILocation(line: 19, column: 19, scope: !26)
!34 = !DILocation(line: 21, column: 25, scope: !26)
!35 = !DILocation(line: 21, column: 27, scope: !26)
!36 = !DILocation(line: 21, column: 5, scope: !26)
!37 = !DILocalVariable(name: "b", scope: !26, file: !1, line: 23, type: !31)
!38 = !DILocation(line: 23, column: 15, scope: !26)
!39 = !DILocation(line: 23, column: 19, scope: !26)
!40 = !DILocation(line: 23, column: 21, scope: !26)
!41 = !DILocation(line: 24, column: 12, scope: !26)
!42 = !DILocation(line: 24, column: 16, scope: !26)
!43 = !DILocation(line: 24, column: 14, scope: !26)
!44 = !DILocation(line: 24, column: 5, scope: !26)
