; ModuleID = '/in/read_counter_controls_loop.c'
source_filename = "/in/read_counter_controls_loop.c"
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

4:                                                ; preds = %13, %1
  %5 = load atomic i32, ptr @stop seq_cst, align 4, !dbg !30
  store i32 %5, ptr %3, align 4, !dbg !30
  %6 = load i32, ptr %3, align 4, !dbg !30
  %7 = icmp ne i32 %6, 0, !dbg !30
  br i1 %7, label %11, label %8, !dbg !31

8:                                                ; preds = %4
  %9 = load i64, ptr @rounds, align 8, !dbg !32
  %10 = icmp ne i64 %9, 1000000, !dbg !33
  br label %11

11:                                               ; preds = %8, %4
  %12 = phi i1 [ false, %4 ], [ %10, %8 ], !dbg !34
  br i1 %12, label %13, label %16, !dbg !29

13:                                               ; preds = %11
  %14 = load i64, ptr @rounds, align 8, !dbg !35
  %15 = add i64 %14, 1, !dbg !35
  store i64 %15, ptr @rounds, align 8, !dbg !35
  br label %4, !dbg !29, !llvm.loop !37

16:                                               ; preds = %11
  ret ptr null, !dbg !40
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !41 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  store i32 0, ptr %1, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !44, metadata !DIExpression()), !dbg !47
  %3 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @worker, ptr noundef null) #3, !dbg !48
  ret i32 0, !dbg !49
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
!3 = !DIFile(filename: "/in/read_counter_controls_loop.c", directory: "/work", checksumkind: CSK_MD5, checksum: "ee6fc0c3ea5983555b1ffa93426b4210")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "rounds", scope: !2, file: !9, line: 6, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "/in/read_counter_controls_loop.c", directory: "", checksumkind: CSK_MD5, checksum: "ee6fc0c3ea5983555b1ffa93426b4210")
!10 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
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
!31 = !DILocation(line: 10, column: 32, scope: !23)
!32 = !DILocation(line: 10, column: 35, scope: !23)
!33 = !DILocation(line: 10, column: 42, scope: !23)
!34 = !DILocation(line: 0, scope: !23)
!35 = !DILocation(line: 11, column: 15, scope: !36)
!36 = distinct !DILexicalBlock(scope: !23, file: !9, line: 10, column: 54)
!37 = distinct !{!37, !29, !38, !39}
!38 = !DILocation(line: 12, column: 5, scope: !23)
!39 = !{!"llvm.loop.mustprogress"}
!40 = !DILocation(line: 13, column: 5, scope: !23)
!41 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 16, type: !42, scopeLine: 17, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !26)
!42 = !DISubroutineType(types: !43)
!43 = !{!14}
!44 = !DILocalVariable(name: "t1", scope: !41, file: !9, line: 18, type: !45)
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !46, line: 27, baseType: !10)
!46 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!47 = !DILocation(line: 18, column: 15, scope: !41)
!48 = !DILocation(line: 19, column: 5, scope: !41)
!49 = !DILocation(line: 20, column: 5, scope: !41)
