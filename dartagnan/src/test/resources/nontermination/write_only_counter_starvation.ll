; ModuleID = '/in/write_only_counter_starvation.c'
source_filename = "/in/write_only_counter_starvation.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.atomic_flag = type { i8 }

@lock = dso_local global %struct.atomic_flag zeroinitializer, align 1, !dbg !0
@stop = dso_local global i32 0, align 4, !dbg !7
@rounds = dso_local global i64 0, align 8, !dbg !14

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @greedy(ptr noundef %0) #0 !dbg !32 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i8, align 1
  %5 = alloca i8, align 1
  %6 = alloca i8, align 1
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !36, metadata !DIExpression()), !dbg !37
  br label %7, !dbg !38

7:                                                ; preds = %19, %1
  %8 = load atomic i32, ptr @stop seq_cst, align 4, !dbg !39
  store i32 %8, ptr %3, align 4, !dbg !39
  %9 = load i32, ptr %3, align 4, !dbg !39
  %10 = icmp ne i32 %9, 0, !dbg !40
  %11 = xor i1 %10, true, !dbg !40
  br i1 %11, label %12, label %23, !dbg !38

12:                                               ; preds = %7
  br label %13, !dbg !41

13:                                               ; preds = %18, %12
  store i8 1, ptr %4, align 1, !dbg !43
  %14 = load i8, ptr %4, align 1, !dbg !43
  %15 = atomicrmw xchg ptr @lock, i8 %14 seq_cst, align 1, !dbg !43
  store i8 %15, ptr %5, align 1, !dbg !43
  %16 = load i8, ptr %5, align 1, !dbg !43
  %17 = trunc i8 %16 to i1, !dbg !43
  br i1 %17, label %18, label %19, !dbg !41

18:                                               ; preds = %13
  br label %13, !dbg !41, !llvm.loop !44

19:                                               ; preds = %13
  %20 = load i64, ptr @rounds, align 8, !dbg !47
  %21 = add nsw i64 %20, 1, !dbg !47
  store i64 %21, ptr @rounds, align 8, !dbg !47
  store i8 0, ptr %6, align 1, !dbg !48
  %22 = load i8, ptr %6, align 1, !dbg !48
  store atomic i8 %22, ptr @lock seq_cst, align 1, !dbg !48
  br label %7, !dbg !38, !llvm.loop !49

23:                                               ; preds = %7
  ret ptr null, !dbg !51
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @waiter(ptr noundef %0) #0 !dbg !52 {
  %2 = alloca ptr, align 8
  %3 = alloca i8, align 1
  %4 = alloca i8, align 1
  %5 = alloca i32, align 4
  %6 = alloca i8, align 1
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !53, metadata !DIExpression()), !dbg !54
  br label %7, !dbg !55

7:                                                ; preds = %12, %1
  store i8 1, ptr %3, align 1, !dbg !56
  %8 = load i8, ptr %3, align 1, !dbg !56
  %9 = atomicrmw xchg ptr @lock, i8 %8 seq_cst, align 1, !dbg !56
  store i8 %9, ptr %4, align 1, !dbg !56
  %10 = load i8, ptr %4, align 1, !dbg !56
  %11 = trunc i8 %10 to i1, !dbg !56
  br i1 %11, label %12, label %13, !dbg !55

12:                                               ; preds = %7
  br label %7, !dbg !55, !llvm.loop !57

13:                                               ; preds = %7
  store i32 1, ptr %5, align 4, !dbg !59
  %14 = load i32, ptr %5, align 4, !dbg !59
  store atomic i32 %14, ptr @stop seq_cst, align 4, !dbg !59
  store i8 0, ptr %6, align 1, !dbg !60
  %15 = load i8, ptr %6, align 1, !dbg !60
  store atomic i8 %15, ptr @lock seq_cst, align 1, !dbg !60
  ret ptr null, !dbg !61
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !62 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  store i32 0, ptr %1, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !65, metadata !DIExpression()), !dbg !69
  call void @llvm.dbg.declare(metadata ptr %3, metadata !70, metadata !DIExpression()), !dbg !71
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @greedy, ptr noundef null) #3, !dbg !72
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @waiter, ptr noundef null) #3, !dbg !73
  ret i32 0, !dbg !74
}

; Function Attrs: nounwind
declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!24, !25, !26, !27, !28, !29, !30}
!llvm.ident = !{!31}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !9, line: 6, type: !17, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 18.1.3 (1ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/in/write_only_counter_starvation.c", directory: "/work", checksumkind: CSK_MD5, checksum: "2858b367764da314e734a128b0801d90")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7, !14}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "stop", scope: !2, file: !9, line: 7, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "/in/write_only_counter_starvation.c", directory: "", checksumkind: CSK_MD5, checksum: "2858b367764da314e734a128b0801d90")
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !11, line: 101, baseType: !12)
!11 = !DIFile(filename: "/usr/lib/llvm-18/lib/clang/18/include/stdatomic.h", directory: "", checksumkind: CSK_MD5, checksum: "1c2aee2a953dfc5407753d1f439b6977")
!12 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !13)
!13 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(name: "rounds", scope: !2, file: !9, line: 8, type: !16, isLocal: false, isDefinition: true)
!16 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_flag", file: !11, line: 167, baseType: !18)
!18 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "atomic_flag", file: !11, line: 167, size: 8, elements: !19)
!19 = !{!20}
!20 = !DIDerivedType(tag: DW_TAG_member, name: "_Value", scope: !18, file: !11, line: 167, baseType: !21, size: 8)
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_bool", file: !11, line: 94, baseType: !22)
!22 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !23)
!23 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!24 = !{i32 7, !"Dwarf Version", i32 5}
!25 = !{i32 2, !"Debug Info Version", i32 3}
!26 = !{i32 1, !"wchar_size", i32 4}
!27 = !{i32 8, !"PIC Level", i32 2}
!28 = !{i32 7, !"PIE Level", i32 2}
!29 = !{i32 7, !"uwtable", i32 2}
!30 = !{i32 7, !"frame-pointer", i32 2}
!31 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!32 = distinct !DISubprogram(name: "greedy", scope: !9, file: !9, line: 10, type: !33, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !35)
!33 = !DISubroutineType(types: !34)
!34 = !{!5, !5}
!35 = !{}
!36 = !DILocalVariable(name: "unused", arg: 1, scope: !32, file: !9, line: 10, type: !5)
!37 = !DILocation(line: 10, column: 20, scope: !32)
!38 = !DILocation(line: 12, column: 5, scope: !32)
!39 = !DILocation(line: 12, column: 13, scope: !32)
!40 = !DILocation(line: 12, column: 12, scope: !32)
!41 = !DILocation(line: 13, column: 9, scope: !42)
!42 = distinct !DILexicalBlock(scope: !32, file: !9, line: 12, column: 33)
!43 = !DILocation(line: 13, column: 16, scope: !42)
!44 = distinct !{!44, !41, !45, !46}
!45 = !DILocation(line: 13, column: 50, scope: !42)
!46 = !{!"llvm.loop.mustprogress"}
!47 = !DILocation(line: 14, column: 15, scope: !42)
!48 = !DILocation(line: 15, column: 9, scope: !42)
!49 = distinct !{!49, !38, !50, !46}
!50 = !DILocation(line: 16, column: 5, scope: !32)
!51 = !DILocation(line: 17, column: 5, scope: !32)
!52 = distinct !DISubprogram(name: "waiter", scope: !9, file: !9, line: 20, type: !33, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !35)
!53 = !DILocalVariable(name: "unused", arg: 1, scope: !52, file: !9, line: 20, type: !5)
!54 = !DILocation(line: 20, column: 20, scope: !52)
!55 = !DILocation(line: 22, column: 5, scope: !52)
!56 = !DILocation(line: 22, column: 12, scope: !52)
!57 = distinct !{!57, !55, !58, !46}
!58 = !DILocation(line: 22, column: 46, scope: !52)
!59 = !DILocation(line: 23, column: 5, scope: !52)
!60 = !DILocation(line: 24, column: 5, scope: !52)
!61 = !DILocation(line: 25, column: 5, scope: !52)
!62 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 28, type: !63, scopeLine: 29, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !35)
!63 = !DISubroutineType(types: !64)
!64 = !{!13}
!65 = !DILocalVariable(name: "t1", scope: !62, file: !9, line: 30, type: !66)
!66 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !67, line: 27, baseType: !68)
!67 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!68 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!69 = !DILocation(line: 30, column: 15, scope: !62)
!70 = !DILocalVariable(name: "t2", scope: !62, file: !9, line: 30, type: !66)
!71 = !DILocation(line: 30, column: 19, scope: !62)
!72 = !DILocation(line: 31, column: 5, scope: !62)
!73 = !DILocation(line: 32, column: 5, scope: !62)
!74 = !DILocation(line: 33, column: 5, scope: !62)
