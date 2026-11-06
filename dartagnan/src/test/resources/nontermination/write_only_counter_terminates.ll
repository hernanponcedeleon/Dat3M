; ModuleID = '/in/write_only_counter_terminates.c'
source_filename = "/in/write_only_counter_terminates.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@stop = dso_local global i32 0, align 4, !dbg !0
@rounds = dso_local global i64 0, align 8, !dbg !7

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @worker(ptr noundef %0) #0 !dbg !23 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !27, metadata !DIExpression()), !dbg !28
  br label %4, !dbg !29

4:                                                ; preds = %9, %1
  %5 = load atomic i32, ptr @stop seq_cst, align 4, !dbg !30
  store i32 %5, ptr %3, align 4, !dbg !30
  %6 = load i32, ptr %3, align 4, !dbg !30
  %7 = icmp ne i32 %6, 0, !dbg !31
  %8 = xor i1 %7, true, !dbg !31
  br i1 %8, label %9, label %12, !dbg !29

9:                                                ; preds = %4
  %10 = load i64, ptr @rounds, align 8, !dbg !32
  %11 = add nsw i64 %10, 1, !dbg !32
  store i64 %11, ptr @rounds, align 8, !dbg !32
  br label %4, !dbg !29, !llvm.loop !34

12:                                               ; preds = %4
  ret ptr null, !dbg !37
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @stopper(ptr noundef %0) #0 !dbg !38 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !39, metadata !DIExpression()), !dbg !40
  store i32 1, ptr %3, align 4, !dbg !41
  %4 = load i32, ptr %3, align 4, !dbg !41
  store atomic i32 %4, ptr @stop seq_cst, align 4, !dbg !41
  ret ptr null, !dbg !42
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !43 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  store i32 0, ptr %1, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !46, metadata !DIExpression()), !dbg !50
  call void @llvm.dbg.declare(metadata ptr %3, metadata !51, metadata !DIExpression()), !dbg !52
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @worker, ptr noundef null) #3, !dbg !53
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @stopper, ptr noundef null) #3, !dbg !54
  ret i32 0, !dbg !55
}

; Function Attrs: nounwind
declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!15, !16, !17, !18, !19, !20, !21}
!llvm.ident = !{!22}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "stop", scope: !2, file: !9, line: 5, type: !11, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 18.1.3 (1ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/in/write_only_counter_terminates.c", directory: "/work", checksumkind: CSK_MD5, checksum: "1994b6f7b54f3a31d6a8abdbec5df85a")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "rounds", scope: !2, file: !9, line: 6, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "/in/write_only_counter_terminates.c", directory: "", checksumkind: CSK_MD5, checksum: "1994b6f7b54f3a31d6a8abdbec5df85a")
!10 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!11 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !12, line: 101, baseType: !13)
!12 = !DIFile(filename: "/usr/lib/llvm-18/lib/clang/18/include/stdatomic.h", directory: "", checksumkind: CSK_MD5, checksum: "1c2aee2a953dfc5407753d1f439b6977")
!13 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !14)
!14 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!15 = !{i32 7, !"Dwarf Version", i32 5}
!16 = !{i32 2, !"Debug Info Version", i32 3}
!17 = !{i32 1, !"wchar_size", i32 4}
!18 = !{i32 8, !"PIC Level", i32 2}
!19 = !{i32 7, !"PIE Level", i32 2}
!20 = !{i32 7, !"uwtable", i32 2}
!21 = !{i32 7, !"frame-pointer", i32 2}
!22 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!23 = distinct !DISubprogram(name: "worker", scope: !9, file: !9, line: 8, type: !24, scopeLine: 9, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !26)
!24 = !DISubroutineType(types: !25)
!25 = !{!5, !5}
!26 = !{}
!27 = !DILocalVariable(name: "unused", arg: 1, scope: !23, file: !9, line: 8, type: !5)
!28 = !DILocation(line: 8, column: 20, scope: !23)
!29 = !DILocation(line: 10, column: 5, scope: !23)
!30 = !DILocation(line: 10, column: 13, scope: !23)
!31 = !DILocation(line: 10, column: 12, scope: !23)
!32 = !DILocation(line: 11, column: 15, scope: !33)
!33 = distinct !DILexicalBlock(scope: !23, file: !9, line: 10, column: 33)
!34 = distinct !{!34, !29, !35, !36}
!35 = !DILocation(line: 12, column: 5, scope: !23)
!36 = !{!"llvm.loop.mustprogress"}
!37 = !DILocation(line: 13, column: 5, scope: !23)
!38 = distinct !DISubprogram(name: "stopper", scope: !9, file: !9, line: 16, type: !24, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !26)
!39 = !DILocalVariable(name: "unused", arg: 1, scope: !38, file: !9, line: 16, type: !5)
!40 = !DILocation(line: 16, column: 21, scope: !38)
!41 = !DILocation(line: 18, column: 5, scope: !38)
!42 = !DILocation(line: 19, column: 5, scope: !38)
!43 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 22, type: !44, scopeLine: 23, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !26)
!44 = !DISubroutineType(types: !45)
!45 = !{!14}
!46 = !DILocalVariable(name: "t1", scope: !43, file: !9, line: 24, type: !47)
!47 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !48, line: 27, baseType: !49)
!48 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!49 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!50 = !DILocation(line: 24, column: 15, scope: !43)
!51 = !DILocalVariable(name: "t2", scope: !43, file: !9, line: 24, type: !47)
!52 = !DILocation(line: 24, column: 19, scope: !43)
!53 = !DILocation(line: 25, column: 5, scope: !43)
!54 = !DILocation(line: 26, column: 5, scope: !43)
!55 = !DILocation(line: 27, column: 5, scope: !43)
