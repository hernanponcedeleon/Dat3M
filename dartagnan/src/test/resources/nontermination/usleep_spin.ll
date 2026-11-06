; ModuleID = '/in/usleep_spin.c'
source_filename = "/in/usleep_spin.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@flag = dso_local global i32 0, align 4, !dbg !0

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @waiter(ptr noundef %0) #0 !dbg !20 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !24, metadata !DIExpression()), !dbg !25
  br label %4, !dbg !26

4:                                                ; preds = %9, %1
  %5 = load atomic i32, ptr @flag seq_cst, align 4, !dbg !27
  store i32 %5, ptr %3, align 4, !dbg !27
  %6 = load i32, ptr %3, align 4, !dbg !27
  %7 = icmp ne i32 %6, 0, !dbg !28
  %8 = xor i1 %7, true, !dbg !28
  br i1 %8, label %9, label %11, !dbg !26

9:                                                ; preds = %4
  %10 = call i32 @usleep(i32 noundef 1), !dbg !29
  br label %4, !dbg !26, !llvm.loop !31

11:                                               ; preds = %4
  ret ptr null, !dbg !34
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @usleep(i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @setter(ptr noundef %0) #0 !dbg !35 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !36, metadata !DIExpression()), !dbg !37
  store i32 1, ptr %3, align 4, !dbg !38
  %4 = load i32, ptr %3, align 4, !dbg !38
  store atomic i32 %4, ptr @flag seq_cst, align 4, !dbg !38
  ret ptr null, !dbg !39
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !40 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  store i32 0, ptr %1, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !43, metadata !DIExpression()), !dbg !47
  call void @llvm.dbg.declare(metadata ptr %3, metadata !48, metadata !DIExpression()), !dbg !49
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @waiter, ptr noundef null) #4, !dbg !50
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @setter, ptr noundef null) #4, !dbg !51
  ret i32 0, !dbg !52
}

; Function Attrs: nounwind
declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!12, !13, !14, !15, !16, !17, !18}
!llvm.ident = !{!19}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "flag", scope: !2, file: !7, line: 6, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 18.1.3 (1ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/in/usleep_spin.c", directory: "/work", checksumkind: CSK_MD5, checksum: "19106ac74f0ffecdef9ac8459ff14223")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0}
!7 = !DIFile(filename: "/in/usleep_spin.c", directory: "", checksumkind: CSK_MD5, checksum: "19106ac74f0ffecdef9ac8459ff14223")
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !9, line: 101, baseType: !10)
!9 = !DIFile(filename: "/usr/lib/llvm-18/lib/clang/18/include/stdatomic.h", directory: "", checksumkind: CSK_MD5, checksum: "1c2aee2a953dfc5407753d1f439b6977")
!10 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !11)
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !{i32 7, !"Dwarf Version", i32 5}
!13 = !{i32 2, !"Debug Info Version", i32 3}
!14 = !{i32 1, !"wchar_size", i32 4}
!15 = !{i32 8, !"PIC Level", i32 2}
!16 = !{i32 7, !"PIE Level", i32 2}
!17 = !{i32 7, !"uwtable", i32 2}
!18 = !{i32 7, !"frame-pointer", i32 2}
!19 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!20 = distinct !DISubprogram(name: "waiter", scope: !7, file: !7, line: 8, type: !21, scopeLine: 9, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!21 = !DISubroutineType(types: !22)
!22 = !{!5, !5}
!23 = !{}
!24 = !DILocalVariable(name: "unused", arg: 1, scope: !20, file: !7, line: 8, type: !5)
!25 = !DILocation(line: 8, column: 20, scope: !20)
!26 = !DILocation(line: 10, column: 5, scope: !20)
!27 = !DILocation(line: 10, column: 13, scope: !20)
!28 = !DILocation(line: 10, column: 12, scope: !20)
!29 = !DILocation(line: 11, column: 9, scope: !30)
!30 = distinct !DILexicalBlock(scope: !20, file: !7, line: 10, column: 33)
!31 = distinct !{!31, !26, !32, !33}
!32 = !DILocation(line: 12, column: 5, scope: !20)
!33 = !{!"llvm.loop.mustprogress"}
!34 = !DILocation(line: 13, column: 5, scope: !20)
!35 = distinct !DISubprogram(name: "setter", scope: !7, file: !7, line: 16, type: !21, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!36 = !DILocalVariable(name: "unused", arg: 1, scope: !35, file: !7, line: 16, type: !5)
!37 = !DILocation(line: 16, column: 20, scope: !35)
!38 = !DILocation(line: 18, column: 5, scope: !35)
!39 = !DILocation(line: 19, column: 5, scope: !35)
!40 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 22, type: !41, scopeLine: 23, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!41 = !DISubroutineType(types: !42)
!42 = !{!11}
!43 = !DILocalVariable(name: "t1", scope: !40, file: !7, line: 24, type: !44)
!44 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !45, line: 27, baseType: !46)
!45 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!46 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!47 = !DILocation(line: 24, column: 15, scope: !40)
!48 = !DILocalVariable(name: "t2", scope: !40, file: !7, line: 24, type: !44)
!49 = !DILocation(line: 24, column: 19, scope: !40)
!50 = !DILocation(line: 25, column: 5, scope: !40)
!51 = !DILocation(line: 26, column: 5, scope: !40)
!52 = !DILocation(line: 27, column: 5, scope: !40)
