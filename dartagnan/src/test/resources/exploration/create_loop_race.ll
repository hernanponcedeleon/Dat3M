; ModuleID = 'benchmarks/exploration/create_loop_race.c'
source_filename = "benchmarks/exploration/create_loop_race.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

@counter = global i32 0, align 4, !dbg !0
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !7
@.str = private unnamed_addr constant [19 x i8] c"create_loop_race.c\00", align 1, !dbg !14
@.str.1 = private unnamed_addr constant [13 x i8] c"counter == N\00", align 1, !dbg !19

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @worker(ptr noundef %0) #0 !dbg !32 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !36, !DIExpression(), !37)
  %3 = load i32, ptr @counter, align 4, !dbg !38
  %4 = add nsw i32 %3, 1, !dbg !39
  store i32 %4, ptr @counter, align 4, !dbg !40
  ret ptr null, !dbg !41
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 !dbg !42 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x ptr], align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !45, !DIExpression(), !72)
    #dbg_declare(ptr %3, !73, !DIExpression(), !75)
  store i32 0, ptr %3, align 4, !dbg !75
  br label %5, !dbg !76

5:                                                ; preds = %13, %0
  %6 = load i32, ptr %3, align 4, !dbg !77
  %7 = icmp slt i32 %6, 3, !dbg !79
  br i1 %7, label %8, label %16, !dbg !80

8:                                                ; preds = %5
  %9 = load i32, ptr %3, align 4, !dbg !81
  %10 = sext i32 %9 to i64, !dbg !83
  %11 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %10, !dbg !83
  %12 = call i32 @pthread_create(ptr noundef %11, ptr noundef null, ptr noundef @worker, ptr noundef null), !dbg !84
  br label %13, !dbg !85

13:                                               ; preds = %8
  %14 = load i32, ptr %3, align 4, !dbg !86
  %15 = add nsw i32 %14, 1, !dbg !86
  store i32 %15, ptr %3, align 4, !dbg !86
  br label %5, !dbg !87, !llvm.loop !88

16:                                               ; preds = %5
    #dbg_declare(ptr %4, !91, !DIExpression(), !93)
  store i32 0, ptr %4, align 4, !dbg !93
  br label %17, !dbg !94

17:                                               ; preds = %26, %16
  %18 = load i32, ptr %4, align 4, !dbg !95
  %19 = icmp slt i32 %18, 3, !dbg !97
  br i1 %19, label %20, label %29, !dbg !98

20:                                               ; preds = %17
  %21 = load i32, ptr %4, align 4, !dbg !99
  %22 = sext i32 %21 to i64, !dbg !101
  %23 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %22, !dbg !101
  %24 = load ptr, ptr %23, align 8, !dbg !101
  %25 = call i32 @"\01_pthread_join"(ptr noundef %24, ptr noundef null), !dbg !102
  br label %26, !dbg !103

26:                                               ; preds = %20
  %27 = load i32, ptr %4, align 4, !dbg !104
  %28 = add nsw i32 %27, 1, !dbg !104
  store i32 %28, ptr %4, align 4, !dbg !104
  br label %17, !dbg !105, !llvm.loop !106

29:                                               ; preds = %17
  %30 = load i32, ptr @counter, align 4, !dbg !108
  %31 = icmp eq i32 %30, 3, !dbg !109
  %32 = xor i1 %31, true, !dbg !110
  %33 = zext i1 %32 to i32, !dbg !110
  %34 = sext i32 %33 to i64, !dbg !110
  %35 = icmp ne i64 %34, 0, !dbg !110
  br i1 %35, label %36, label %38, !dbg !110

36:                                               ; preds = %29
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 25, ptr noundef @.str.1) #3, !dbg !110
  unreachable, !dbg !110

37:                                               ; No predecessors!
  br label %39, !dbg !110

38:                                               ; preds = %29
  br label %39, !dbg !110

39:                                               ; preds = %38, %37
  ret i32 0, !dbg !111
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #1 = { "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #3 = { cold noreturn }

!llvm.module.flags = !{!25, !26, !27, !28, !29, !30}
!llvm.dbg.cu = !{!2}
!llvm.ident = !{!31}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "counter", scope: !2, file: !3, line: 10, type: !24, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 23.1.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk", sdk: "MacOSX26.sdk")
!3 = !DIFile(filename: "benchmarks/exploration/create_loop_race.c", directory: "/Users/hponcedeleon/git/agent-4/Dat3M", checksumkind: CSK_MD5, checksum: "f89af4f2ffb9cf09ff2c85878e249159")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!7, !14, !19, !0}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !3, line: 25, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 40, elements: !12)
!10 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !11)
!11 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!12 = !{!13}
!13 = !DISubrange(count: 5)
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(scope: null, file: !3, line: 25, type: !16, isLocal: true, isDefinition: true)
!16 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 152, elements: !17)
!17 = !{!18}
!18 = !DISubrange(count: 19)
!19 = !DIGlobalVariableExpression(var: !20, expr: !DIExpression())
!20 = distinct !DIGlobalVariable(scope: null, file: !3, line: 25, type: !21, isLocal: true, isDefinition: true)
!21 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 104, elements: !22)
!22 = !{!23}
!23 = !DISubrange(count: 13)
!24 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!25 = !{i32 2, !"SDK Version", [2 x i32] [i32 26, i32 5]}
!26 = !{i32 7, !"Dwarf Version", i32 5}
!27 = !{i32 2, !"Debug Info Version", i32 3}
!28 = !{i32 8, !"PIC Level", i32 2}
!29 = !{i32 7, !"uwtable", i32 1}
!30 = !{i32 7, !"frame-pointer", i32 4}
!31 = !{!"Homebrew clang version 23.1.0"}
!32 = distinct !DISubprogram(name: "worker", scope: !3, file: !3, line: 12, type: !33, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !35)
!33 = !DISubroutineType(types: !34)
!34 = !{!5, !5}
!35 = !{}
!36 = !DILocalVariable(name: "arg", arg: 1, scope: !32, file: !3, line: 12, type: !5)
!37 = !DILocation(line: 12, column: 20, scope: !32)
!38 = !DILocation(line: 13, column: 15, scope: !32)
!39 = !DILocation(line: 13, column: 23, scope: !32)
!40 = !DILocation(line: 13, column: 13, scope: !32)
!41 = !DILocation(line: 14, column: 5, scope: !32)
!42 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 17, type: !43, scopeLine: 17, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !35)
!43 = !DISubroutineType(types: !44)
!44 = !{!24}
!45 = !DILocalVariable(name: "t", scope: !42, file: !3, line: 18, type: !46)
!46 = !DICompositeType(tag: DW_TAG_array_type, baseType: !47, size: 192, elements: !70)
!47 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !48, line: 31, baseType: !49)
!48 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !50, line: 118, baseType: !51)
!50 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!51 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !52, size: 64)
!52 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !50, line: 103, size: 65536, elements: !53)
!53 = !{!54, !56, !66}
!54 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !52, file: !50, line: 104, baseType: !55, size: 64)
!55 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !52, file: !50, line: 105, baseType: !57, size: 64, offset: 64)
!57 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !58, size: 64)
!58 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !50, line: 57, size: 192, elements: !59)
!59 = !{!60, !64, !65}
!60 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !58, file: !50, line: 58, baseType: !61, size: 64)
!61 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !62, size: 64)
!62 = !DISubroutineType(types: !63)
!63 = !{null, !5}
!64 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !58, file: !50, line: 59, baseType: !5, size: 64, offset: 64)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !58, file: !50, line: 60, baseType: !57, size: 64, offset: 128)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !52, file: !50, line: 106, baseType: !67, size: 65408, offset: 128)
!67 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 65408, elements: !68)
!68 = !{!69}
!69 = !DISubrange(count: 8176)
!70 = !{!71}
!71 = !DISubrange(count: 3)
!72 = !DILocation(line: 18, column: 15, scope: !42)
!73 = !DILocalVariable(name: "i", scope: !74, file: !3, line: 19, type: !24)
!74 = distinct !DILexicalBlock(scope: !42, file: !3, line: 19, column: 5)
!75 = !DILocation(line: 19, column: 14, scope: !74)
!76 = !DILocation(line: 19, column: 10, scope: !74)
!77 = !DILocation(line: 19, column: 21, scope: !78)
!78 = distinct !DILexicalBlock(scope: !74, file: !3, line: 19, column: 5)
!79 = !DILocation(line: 19, column: 23, scope: !78)
!80 = !DILocation(line: 19, column: 5, scope: !74)
!81 = !DILocation(line: 20, column: 27, scope: !82)
!82 = distinct !DILexicalBlock(scope: !78, file: !3, line: 19, column: 33)
!83 = !DILocation(line: 20, column: 25, scope: !82)
!84 = !DILocation(line: 20, column: 9, scope: !82)
!85 = !DILocation(line: 21, column: 5, scope: !82)
!86 = !DILocation(line: 19, column: 29, scope: !78)
!87 = !DILocation(line: 19, column: 5, scope: !78)
!88 = distinct !{!88, !80, !89, !90}
!89 = !DILocation(line: 21, column: 5, scope: !74)
!90 = !{!"llvm.loop.mustprogress"}
!91 = !DILocalVariable(name: "i", scope: !92, file: !3, line: 22, type: !24)
!92 = distinct !DILexicalBlock(scope: !42, file: !3, line: 22, column: 5)
!93 = !DILocation(line: 22, column: 14, scope: !92)
!94 = !DILocation(line: 22, column: 10, scope: !92)
!95 = !DILocation(line: 22, column: 21, scope: !96)
!96 = distinct !DILexicalBlock(scope: !92, file: !3, line: 22, column: 5)
!97 = !DILocation(line: 22, column: 23, scope: !96)
!98 = !DILocation(line: 22, column: 5, scope: !92)
!99 = !DILocation(line: 23, column: 24, scope: !100)
!100 = distinct !DILexicalBlock(scope: !96, file: !3, line: 22, column: 33)
!101 = !DILocation(line: 23, column: 22, scope: !100)
!102 = !DILocation(line: 23, column: 9, scope: !100)
!103 = !DILocation(line: 24, column: 5, scope: !100)
!104 = !DILocation(line: 22, column: 29, scope: !96)
!105 = !DILocation(line: 22, column: 5, scope: !96)
!106 = distinct !{!106, !98, !107, !90}
!107 = !DILocation(line: 24, column: 5, scope: !92)
!108 = !DILocation(line: 25, column: 12, scope: !42)
!109 = !DILocation(line: 25, column: 20, scope: !42)
!110 = !DILocation(line: 25, column: 5, scope: !42)
!111 = !DILocation(line: 26, column: 5, scope: !42)
