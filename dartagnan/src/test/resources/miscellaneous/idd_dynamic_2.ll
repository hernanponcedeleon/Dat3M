; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/idd_dynamic.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/idd_dynamic.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }

@x = global i32 0, align 4, !dbg !0
@y = global i32 0, align 4, !dbg !18
@z = global i32 0, align 4, !dbg !24
@__func__.thread_1 = private unnamed_addr constant [9 x i8] c"thread_1\00", align 1
@.str = private unnamed_addr constant [14 x i8] c"idd_dynamic.c\00", align 1
@.str.1 = private unnamed_addr constant [8 x i8] c"u != 42\00", align 1

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread_1(i8* noundef %0) #0 !dbg !37 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !41, metadata !DIExpression()), !dbg !42
  call void @llvm.dbg.declare(metadata i32* %3, metadata !43, metadata !DIExpression()), !dbg !44
  %10 = load atomic i32, i32* @x monotonic, align 4, !dbg !45
  store i32 %10, i32* %4, align 4, !dbg !45
  %11 = load i32, i32* %4, align 4, !dbg !45
  store i32 %11, i32* %3, align 4, !dbg !44
  call void @llvm.dbg.declare(metadata i32* %5, metadata !46, metadata !DIExpression()), !dbg !47
  %12 = load atomic i32, i32* @y monotonic, align 4, !dbg !48
  store i32 %12, i32* %6, align 4, !dbg !48
  %13 = load i32, i32* %6, align 4, !dbg !48
  store i32 %13, i32* %5, align 4, !dbg !47
  call void @llvm.dbg.declare(metadata i32* %7, metadata !49, metadata !DIExpression()), !dbg !50
  %14 = load i32, i32* %5, align 4, !dbg !51
  store i32 %14, i32* %7, align 4, !dbg !50
  %15 = load i32, i32* %3, align 4, !dbg !52
  %16 = icmp eq i32 %15, 0, !dbg !54
  br i1 %16, label %17, label %19, !dbg !55

17:                                               ; preds = %1
  store i32 4, i32* %8, align 4, !dbg !56
  %18 = load i32, i32* %8, align 4, !dbg !56
  store atomic i32 %18, i32* @z monotonic, align 4, !dbg !56
  store i32 42, i32* %5, align 4, !dbg !58
  br label %19, !dbg !59

19:                                               ; preds = %17, %1
  %20 = load i32, i32* %5, align 4, !dbg !60
  store i32 %20, i32* %9, align 4, !dbg !61
  %21 = load i32, i32* %9, align 4, !dbg !61
  store atomic i32 %21, i32* @x monotonic, align 4, !dbg !61
  %22 = load i32, i32* %7, align 4, !dbg !62
  %23 = icmp ne i32 %22, 42, !dbg !62
  %24 = xor i1 %23, true, !dbg !62
  %25 = zext i1 %24 to i32, !dbg !62
  %26 = sext i32 %25 to i64, !dbg !62
  %27 = icmp ne i64 %26, 0, !dbg !62
  br i1 %27, label %28, label %30, !dbg !62

28:                                               ; preds = %19
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @__func__.thread_1, i64 0, i64 0), i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @.str, i64 0, i64 0), i32 noundef 21, i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !62
  unreachable, !dbg !62

29:                                               ; No predecessors!
  br label %31, !dbg !62

30:                                               ; preds = %19
  br label %31, !dbg !62

31:                                               ; preds = %30, %29
  ret i8* null, !dbg !63
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread_2(i8* noundef %0) #0 !dbg !64 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !65, metadata !DIExpression()), !dbg !66
  call void @llvm.dbg.declare(metadata i32* %3, metadata !67, metadata !DIExpression()), !dbg !68
  %6 = load atomic i32, i32* @x monotonic, align 4, !dbg !69
  store i32 %6, i32* %4, align 4, !dbg !69
  %7 = load i32, i32* %4, align 4, !dbg !69
  store i32 %7, i32* %3, align 4, !dbg !68
  %8 = load i32, i32* %3, align 4, !dbg !70
  store i32 %8, i32* %5, align 4, !dbg !71
  %9 = load i32, i32* %5, align 4, !dbg !71
  store atomic i32 %9, i32* @y monotonic, align 4, !dbg !71
  ret i8* null, !dbg !72
}

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !73 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_t*, align 8
  %3 = alloca %struct._opaque_pthread_t*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !76, metadata !DIExpression()), !dbg !101
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %3, metadata !102, metadata !DIExpression()), !dbg !103
  %4 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %2, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_1, i8* noundef null), !dbg !104
  %5 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %3, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_2, i8* noundef null), !dbg !105
  %6 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %2, align 8, !dbg !106
  %7 = call i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef %6, i8** noundef null), !dbg !107
  %8 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %3, align 8, !dbg !108
  %9 = call i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef %8, i8** noundef null), !dbg !109
  ret i32 0, !dbg !110
}

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef, i8** noundef) #3

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #3 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #4 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!26, !27, !28, !29, !30, !31, !32, !33, !34, !35}
!llvm.ident = !{!36}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !20, line: 9, type: !21, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/idd_dynamic.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 56, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/opt/homebrew/Cellar/llvm@14/14.0.6/lib/clang/14.0.6/include/stdatomic.h", directory: "")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0)
!10 = !DIEnumerator(name: "memory_order_consume", value: 1)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2)
!12 = !DIEnumerator(name: "memory_order_release", value: 3)
!13 = !DIEnumerator(name: "memory_order_acq_rel", value: 4)
!14 = !DIEnumerator(name: "memory_order_seq_cst", value: 5)
!15 = !{!16}
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!17 = !{!0, !18, !24}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !20, line: 9, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "benchmarks/miscellaneous/idd_dynamic.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !22)
!22 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !23)
!23 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !20, line: 9, type: !21, isLocal: false, isDefinition: true)
!26 = !{i32 7, !"Dwarf Version", i32 4}
!27 = !{i32 2, !"Debug Info Version", i32 3}
!28 = !{i32 1, !"wchar_size", i32 4}
!29 = !{i32 1, !"branch-target-enforcement", i32 0}
!30 = !{i32 1, !"sign-return-address", i32 0}
!31 = !{i32 1, !"sign-return-address-all", i32 0}
!32 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!33 = !{i32 7, !"PIC Level", i32 2}
!34 = !{i32 7, !"uwtable", i32 1}
!35 = !{i32 7, !"frame-pointer", i32 1}
!36 = !{!"Homebrew clang version 14.0.6"}
!37 = distinct !DISubprogram(name: "thread_1", scope: !20, file: !20, line: 11, type: !38, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !40)
!38 = !DISubroutineType(types: !39)
!39 = !{!16, !16}
!40 = !{}
!41 = !DILocalVariable(name: "unused", arg: 1, scope: !37, file: !20, line: 11, type: !16)
!42 = !DILocation(line: 11, column: 22, scope: !37)
!43 = !DILocalVariable(name: "r", scope: !37, file: !20, line: 13, type: !23)
!44 = !DILocation(line: 13, column: 6, scope: !37)
!45 = !DILocation(line: 13, column: 10, scope: !37)
!46 = !DILocalVariable(name: "s", scope: !37, file: !20, line: 14, type: !23)
!47 = !DILocation(line: 14, column: 6, scope: !37)
!48 = !DILocation(line: 14, column: 10, scope: !37)
!49 = !DILocalVariable(name: "u", scope: !37, file: !20, line: 15, type: !23)
!50 = !DILocation(line: 15, column: 6, scope: !37)
!51 = !DILocation(line: 15, column: 10, scope: !37)
!52 = !DILocation(line: 16, column: 6, scope: !53)
!53 = distinct !DILexicalBlock(scope: !37, file: !20, line: 16, column: 6)
!54 = !DILocation(line: 16, column: 8, scope: !53)
!55 = !DILocation(line: 16, column: 6, scope: !37)
!56 = !DILocation(line: 17, column: 3, scope: !57)
!57 = distinct !DILexicalBlock(scope: !53, file: !20, line: 16, column: 14)
!58 = !DILocation(line: 18, column: 5, scope: !57)
!59 = !DILocation(line: 19, column: 2, scope: !57)
!60 = !DILocation(line: 20, column: 28, scope: !37)
!61 = !DILocation(line: 20, column: 2, scope: !37)
!62 = !DILocation(line: 21, column: 2, scope: !37)
!63 = !DILocation(line: 22, column: 2, scope: !37)
!64 = distinct !DISubprogram(name: "thread_2", scope: !20, file: !20, line: 25, type: !38, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !40)
!65 = !DILocalVariable(name: "unused", arg: 1, scope: !64, file: !20, line: 25, type: !16)
!66 = !DILocation(line: 25, column: 22, scope: !64)
!67 = !DILocalVariable(name: "a", scope: !64, file: !20, line: 27, type: !23)
!68 = !DILocation(line: 27, column: 6, scope: !64)
!69 = !DILocation(line: 27, column: 10, scope: !64)
!70 = !DILocation(line: 28, column: 28, scope: !64)
!71 = !DILocation(line: 28, column: 2, scope: !64)
!72 = !DILocation(line: 29, column: 2, scope: !64)
!73 = distinct !DISubprogram(name: "main", scope: !20, file: !20, line: 32, type: !74, scopeLine: 33, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !40)
!74 = !DISubroutineType(types: !75)
!75 = !{!23}
!76 = !DILocalVariable(name: "t1", scope: !73, file: !20, line: 34, type: !77)
!77 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !78, line: 31, baseType: !79)
!78 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!79 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !80, line: 118, baseType: !81)
!80 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!81 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !82, size: 64)
!82 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !80, line: 103, size: 65536, elements: !83)
!83 = !{!84, !86, !96}
!84 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !82, file: !80, line: 104, baseType: !85, size: 64)
!85 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !82, file: !80, line: 105, baseType: !87, size: 64, offset: 64)
!87 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !88, size: 64)
!88 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !80, line: 57, size: 192, elements: !89)
!89 = !{!90, !94, !95}
!90 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !88, file: !80, line: 58, baseType: !91, size: 64)
!91 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !92, size: 64)
!92 = !DISubroutineType(types: !93)
!93 = !{null, !16}
!94 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !88, file: !80, line: 59, baseType: !16, size: 64, offset: 64)
!95 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !88, file: !80, line: 60, baseType: !87, size: 64, offset: 128)
!96 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !82, file: !80, line: 106, baseType: !97, size: 65408, offset: 128)
!97 = !DICompositeType(tag: DW_TAG_array_type, baseType: !98, size: 65408, elements: !99)
!98 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!99 = !{!100}
!100 = !DISubrange(count: 8176)
!101 = !DILocation(line: 34, column: 12, scope: !73)
!102 = !DILocalVariable(name: "t2", scope: !73, file: !20, line: 34, type: !77)
!103 = !DILocation(line: 34, column: 16, scope: !73)
!104 = !DILocation(line: 36, column: 2, scope: !73)
!105 = !DILocation(line: 37, column: 2, scope: !73)
!106 = !DILocation(line: 39, column: 15, scope: !73)
!107 = !DILocation(line: 39, column: 2, scope: !73)
!108 = !DILocation(line: 40, column: 15, scope: !73)
!109 = !DILocation(line: 40, column: 2, scope: !73)
!110 = !DILocation(line: 42, column: 2, scope: !73)
