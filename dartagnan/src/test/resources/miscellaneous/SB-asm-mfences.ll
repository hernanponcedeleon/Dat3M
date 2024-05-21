; ModuleID = '/home/ponce/git/Dat3M/output/SB-asm-mfences.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/SB-asm-mfences.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !14
@a = dso_local global i32 0, align 4, !dbg !8
@b = dso_local global i32 0, align 4, !dbg !12
@.str = private unnamed_addr constant [20 x i8] c"!(a == 0 && b == 0)\00", align 1
@.str.1 = private unnamed_addr constant [66 x i8] c"/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/SB-asm-mfences.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_1(i8* %0) #0 !dbg !20 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !23, metadata !DIExpression()), !dbg !24
  store i32 1, i32* @x, align 4, !dbg !25
  call void asm sideeffect "mfence", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !26, !srcloc !27
  %2 = load i32, i32* @y, align 4, !dbg !28
  store i32 %2, i32* @a, align 4, !dbg !29
  ret i8* null, !dbg !30
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_2(i8* %0) #0 !dbg !31 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !32, metadata !DIExpression()), !dbg !33
  store i32 1, i32* @y, align 4, !dbg !34
  call void asm sideeffect "mfence", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !35, !srcloc !36
  %2 = load i32, i32* @x, align 4, !dbg !37
  store i32 %2, i32* @b, align 4, !dbg !38
  ret i8* null, !dbg !39
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !40 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !43, metadata !DIExpression()), !dbg !47
  call void @llvm.dbg.declare(metadata i64* %2, metadata !48, metadata !DIExpression()), !dbg !49
  %3 = call i32 @pthread_create(i64* %1, %union.pthread_attr_t* null, i8* (i8*)* @thread_1, i8* null) #5, !dbg !50
  %4 = call i32 @pthread_create(i64* %2, %union.pthread_attr_t* null, i8* (i8*)* @thread_2, i8* null) #5, !dbg !51
  %5 = load i64, i64* %1, align 8, !dbg !52
  %6 = call i32 @pthread_join(i64 %5, i8** null), !dbg !53
  %7 = load i64, i64* %2, align 8, !dbg !54
  %8 = call i32 @pthread_join(i64 %7, i8** null), !dbg !55
  %9 = load i32, i32* @a, align 4, !dbg !56
  %10 = icmp eq i32 %9, 0, !dbg !56
  %11 = load i32, i32* @b, align 4, !dbg !56
  %12 = icmp eq i32 %11, 0, !dbg !56
  %or.cond = select i1 %10, i1 %12, i1 false, !dbg !56
  br i1 %or.cond, label %13, label %14, !dbg !56

13:                                               ; preds = %0
  call void @__assert_fail(i8* getelementptr inbounds ([20 x i8], [20 x i8]* @.str, i64 0, i64 0), i8* getelementptr inbounds ([66 x i8], [66 x i8]* @.str.1, i64 0, i64 0), i32 34, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !56
  unreachable, !dbg !56

14:                                               ; preds = %0
  ret i32 0, !dbg !59
}

; Function Attrs: nounwind
declare dso_local i32 @pthread_create(i64*, %union.pthread_attr_t*, i8* (i8*)*, i8*) #2

declare dso_local i32 @pthread_join(i64, i8**) #3

; Function Attrs: noreturn nounwind
declare dso_local void @__assert_fail(i8*, i8*, i32, i8*) #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noreturn nounwind "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!16, !17, !18}
!llvm.ident = !{!19}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !10, line: 6, type: !11, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 12.0.0-3ubuntu1~20.04.5", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !7, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/SB-asm-mfences.c", directory: "/home/ponce/git/Dat3M")
!4 = !{}
!5 = !{!6}
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!7 = !{!8, !12, !0, !14}
!8 = !DIGlobalVariableExpression(var: !9, expr: !DIExpression())
!9 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !10, line: 6, type: !11, isLocal: false, isDefinition: true)
!10 = !DIFile(filename: "benchmarks/c/miscellaneous/SB-asm-mfences.c", directory: "/home/ponce/git/Dat3M")
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !10, line: 6, type: !11, isLocal: false, isDefinition: true)
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !10, line: 6, type: !11, isLocal: false, isDefinition: true)
!16 = !{i32 7, !"Dwarf Version", i32 4}
!17 = !{i32 2, !"Debug Info Version", i32 3}
!18 = !{i32 1, !"wchar_size", i32 4}
!19 = !{!"Ubuntu clang version 12.0.0-3ubuntu1~20.04.5"}
!20 = distinct !DISubprogram(name: "thread_1", scope: !10, file: !10, line: 8, type: !21, scopeLine: 9, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!21 = !DISubroutineType(types: !22)
!22 = !{!6, !6}
!23 = !DILocalVariable(name: "unused", arg: 1, scope: !20, file: !10, line: 8, type: !6)
!24 = !DILocation(line: 0, scope: !20)
!25 = !DILocation(line: 10, column: 7, scope: !20)
!26 = !DILocation(line: 11, column: 5, scope: !20)
!27 = !{i32 164}
!28 = !DILocation(line: 12, column: 9, scope: !20)
!29 = !DILocation(line: 12, column: 7, scope: !20)
!30 = !DILocation(line: 13, column: 5, scope: !20)
!31 = distinct !DISubprogram(name: "thread_2", scope: !10, file: !10, line: 16, type: !21, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!32 = !DILocalVariable(name: "unused", arg: 1, scope: !31, file: !10, line: 16, type: !6)
!33 = !DILocation(line: 0, scope: !31)
!34 = !DILocation(line: 18, column: 7, scope: !31)
!35 = !DILocation(line: 19, column: 5, scope: !31)
!36 = !{i32 279}
!37 = !DILocation(line: 20, column: 9, scope: !31)
!38 = !DILocation(line: 20, column: 7, scope: !31)
!39 = !DILocation(line: 21, column: 5, scope: !31)
!40 = distinct !DISubprogram(name: "main", scope: !10, file: !10, line: 24, type: !41, scopeLine: 25, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!41 = !DISubroutineType(types: !42)
!42 = !{!11}
!43 = !DILocalVariable(name: "t1", scope: !40, file: !10, line: 26, type: !44)
!44 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !45, line: 27, baseType: !46)
!45 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "")
!46 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!47 = !DILocation(line: 26, column: 12, scope: !40)
!48 = !DILocalVariable(name: "t2", scope: !40, file: !10, line: 26, type: !44)
!49 = !DILocation(line: 26, column: 16, scope: !40)
!50 = !DILocation(line: 28, column: 2, scope: !40)
!51 = !DILocation(line: 29, column: 2, scope: !40)
!52 = !DILocation(line: 31, column: 15, scope: !40)
!53 = !DILocation(line: 31, column: 2, scope: !40)
!54 = !DILocation(line: 32, column: 15, scope: !40)
!55 = !DILocation(line: 32, column: 2, scope: !40)
!56 = !DILocation(line: 34, column: 2, scope: !57)
!57 = distinct !DILexicalBlock(scope: !58, file: !10, line: 34, column: 2)
!58 = distinct !DILexicalBlock(scope: !40, file: !10, line: 34, column: 2)
!59 = !DILocation(line: 36, column: 2, scope: !40)
