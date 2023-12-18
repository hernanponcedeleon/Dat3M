; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/output/funcPtrInStaticMemory.ll'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/c/miscellaneous/funcPtrInStaticMemory.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx13.0.0"

%struct.MyPtrStruct = type { i8* (i8*)*, i8* (i8*)* }
%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }

@callCounter = dso_local global i32 0, align 4, !dbg !0
@__func__.myFunc1 = private unnamed_addr constant [8 x i8] c"myFunc1\00", align 1
@.str = private unnamed_addr constant [24 x i8] c"funcPtrInStaticMemory.c\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"arg == 1\00", align 1
@__func__.myFunc2 = private unnamed_addr constant [8 x i8] c"myFunc2\00", align 1
@.str.2 = private unnamed_addr constant [24 x i8] c"arg == 42 || arg == 123\00", align 1
@myStruct = dso_local global %struct.MyPtrStruct { i8* (i8*)* @myFunc1, i8* (i8*)* @myFunc2 }, align 8, !dbg !8
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1
@.str.3 = private unnamed_addr constant [31 x i8] c"myStruct.funcPtrOne(1) == NULL\00", align 1
@.str.4 = private unnamed_addr constant [30 x i8] c"myStruct.funcPtrTwo(42) == 42\00", align 1
@.str.5 = private unnamed_addr constant [17 x i8] c"callCounter == 2\00", align 1

; Function Attrs: noinline nounwind ssp uwtable
define dso_local i8* @myFunc1(i8* %0) #0 !dbg !29 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !30, metadata !DIExpression()), !dbg !31
  %2 = icmp eq i8* %0, inttoptr (i64 1 to i8*), !dbg !32
  %3 = xor i1 %2, true, !dbg !32
  %4 = zext i1 %3 to i32, !dbg !32
  %5 = sext i32 %4 to i64, !dbg !32
  br i1 %3, label %6, label %7, !dbg !32

6:                                                ; preds = %1
  call void @__assert_rtn(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @__func__.myFunc1, i64 0, i64 0), i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str, i64 0, i64 0), i32 18, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !32
  unreachable, !dbg !32

7:                                                ; preds = %1
  ret i8* null, !dbg !33
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(i8*, i8*, i32, i8*) #2

; Function Attrs: noinline nounwind ssp uwtable
define dso_local i8* @myFunc2(i8* %0) #0 !dbg !34 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !35, metadata !DIExpression()), !dbg !36
  %2 = icmp eq i8* %0, inttoptr (i64 42 to i8*), !dbg !37
  %3 = icmp eq i8* %0, inttoptr (i64 123 to i8*)
  %spec.select = select i1 %2, i1 true, i1 %3, !dbg !37
  %4 = xor i1 %spec.select, true, !dbg !37
  %5 = zext i1 %4 to i32, !dbg !37
  %6 = sext i32 %5 to i64, !dbg !37
  br i1 %4, label %7, label %8, !dbg !37

7:                                                ; preds = %1
  call void @__assert_rtn(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @__func__.myFunc2, i64 0, i64 0), i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str, i64 0, i64 0), i32 23, i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.2, i64 0, i64 0)) #4, !dbg !37
  unreachable, !dbg !37

8:                                                ; preds = %1
  %9 = load i32, i32* @callCounter, align 4, !dbg !38
  %10 = add nsw i32 %9, 1, !dbg !38
  store i32 %10, i32* @callCounter, align 4, !dbg !38
  ret i8* %0, !dbg !39
}

; Function Attrs: noinline nounwind ssp uwtable
define dso_local i32 @main() #0 !dbg !40 {
  %1 = alloca %struct._opaque_pthread_t*, align 8
  %2 = load i8* (i8*)*, i8* (i8*)** getelementptr inbounds (%struct.MyPtrStruct, %struct.MyPtrStruct* @myStruct, i32 0, i32 0), align 8, !dbg !43
  %3 = call i8* %2(i8* inttoptr (i64 1 to i8*)), !dbg !43
  %4 = icmp eq i8* %3, null, !dbg !43
  %5 = xor i1 %4, true, !dbg !43
  %6 = zext i1 %5 to i32, !dbg !43
  %7 = sext i32 %6 to i64, !dbg !43
  br i1 %5, label %8, label %9, !dbg !43

8:                                                ; preds = %0
  call void @__assert_rtn(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @__func__.main, i64 0, i64 0), i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str, i64 0, i64 0), i32 31, i8* getelementptr inbounds ([31 x i8], [31 x i8]* @.str.3, i64 0, i64 0)) #4, !dbg !43
  unreachable, !dbg !43

9:                                                ; preds = %0
  %10 = load i8* (i8*)*, i8* (i8*)** getelementptr inbounds (%struct.MyPtrStruct, %struct.MyPtrStruct* @myStruct, i32 0, i32 1), align 8, !dbg !44
  %11 = call i8* %10(i8* inttoptr (i64 42 to i8*)), !dbg !44
  %12 = icmp eq i8* %11, inttoptr (i64 42 to i8*), !dbg !44
  %13 = xor i1 %12, true, !dbg !44
  %14 = zext i1 %13 to i32, !dbg !44
  %15 = sext i32 %14 to i64, !dbg !44
  br i1 %13, label %16, label %17, !dbg !44

16:                                               ; preds = %9
  call void @__assert_rtn(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @__func__.main, i64 0, i64 0), i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str, i64 0, i64 0), i32 32, i8* getelementptr inbounds ([30 x i8], [30 x i8]* @.str.4, i64 0, i64 0)) #4, !dbg !44
  unreachable, !dbg !44

17:                                               ; preds = %9
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %1, metadata !45, metadata !DIExpression()), !dbg !70
  %18 = load i8* (i8*)*, i8* (i8*)** getelementptr inbounds (%struct.MyPtrStruct, %struct.MyPtrStruct* @myStruct, i32 0, i32 1), align 8, !dbg !71
  %19 = call i32 @pthread_create(%struct._opaque_pthread_t** %1, %struct._opaque_pthread_attr_t* null, i8* (i8*)* %18, i8* inttoptr (i64 123 to i8*)), !dbg !72
  %20 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %1, align 8, !dbg !73
  %21 = call i32 @"\01_pthread_join"(%struct._opaque_pthread_t* %20, i8** null), !dbg !74
  %22 = load i32, i32* @callCounter, align 4, !dbg !75
  %23 = icmp eq i32 %22, 2, !dbg !75
  %24 = xor i1 %23, true, !dbg !75
  %25 = zext i1 %24 to i32, !dbg !75
  %26 = sext i32 %25 to i64, !dbg !75
  br i1 %24, label %27, label %28, !dbg !75

27:                                               ; preds = %17
  call void @__assert_rtn(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @__func__.main, i64 0, i64 0), i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str, i64 0, i64 0), i32 37, i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str.5, i64 0, i64 0)) #4, !dbg !75
  unreachable, !dbg !75

28:                                               ; preds = %17
  ret i32 0, !dbg !76
}

declare i32 @pthread_create(%struct._opaque_pthread_t**, %struct._opaque_pthread_attr_t*, i8* (i8*)*, i8*) #3

declare i32 @"\01_pthread_join"(%struct._opaque_pthread_t*, i8**) #3

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind ssp uwtable "disable-tail-calls"="false" "frame-pointer"="non-leaf" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-a12" "target-features"="+aes,+crc,+crypto,+fp-armv8,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.3a,+zcm,+zcz" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-a12" "target-features"="+aes,+crc,+crypto,+fp-armv8,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.3a,+zcm,+zcz" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { "disable-tail-calls"="false" "frame-pointer"="non-leaf" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-a12" "target-features"="+aes,+crc,+crypto,+fp-armv8,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.3a,+zcm,+zcz" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!20, !21, !22, !23, !24, !25, !26, !27}
!llvm.ident = !{!28}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "callCounter", scope: !2, file: !10, line: 15, type: !19, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 12.0.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !7, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/c/miscellaneous/funcPtrInStaticMemory.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{}
!5 = !{!6}
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!7 = !{!0, !8}
!8 = !DIGlobalVariableExpression(var: !9, expr: !DIExpression())
!9 = distinct !DIGlobalVariable(name: "myStruct", scope: !2, file: !10, line: 28, type: !11, isLocal: false, isDefinition: true)
!10 = !DIFile(filename: "benchmarks/c/miscellaneous/funcPtrInStaticMemory.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!11 = !DIDerivedType(tag: DW_TAG_typedef, name: "MyPtrStruct", file: !10, line: 13, baseType: !12)
!12 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !10, line: 10, size: 128, elements: !13)
!13 = !{!14, !18}
!14 = !DIDerivedType(tag: DW_TAG_member, name: "funcPtrOne", scope: !12, file: !10, line: 11, baseType: !15, size: 64)
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !16, size: 64)
!16 = !DISubroutineType(types: !17)
!17 = !{!6, !6}
!18 = !DIDerivedType(tag: DW_TAG_member, name: "funcPtrTwo", scope: !12, file: !10, line: 12, baseType: !15, size: 64, offset: 64)
!19 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!20 = !{i32 7, !"Dwarf Version", i32 4}
!21 = !{i32 2, !"Debug Info Version", i32 3}
!22 = !{i32 1, !"wchar_size", i32 4}
!23 = !{i32 1, !"branch-target-enforcement", i32 0}
!24 = !{i32 1, !"sign-return-address", i32 0}
!25 = !{i32 1, !"sign-return-address-all", i32 0}
!26 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!27 = !{i32 7, !"PIC Level", i32 2}
!28 = !{!"Homebrew clang version 12.0.1"}
!29 = distinct !DISubprogram(name: "myFunc1", scope: !10, file: !10, line: 17, type: !16, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!30 = !DILocalVariable(name: "arg", arg: 1, scope: !29, file: !10, line: 17, type: !6)
!31 = !DILocation(line: 0, scope: !29)
!32 = !DILocation(line: 18, column: 5, scope: !29)
!33 = !DILocation(line: 19, column: 5, scope: !29)
!34 = distinct !DISubprogram(name: "myFunc2", scope: !10, file: !10, line: 22, type: !16, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!35 = !DILocalVariable(name: "arg", arg: 1, scope: !34, file: !10, line: 22, type: !6)
!36 = !DILocation(line: 0, scope: !34)
!37 = !DILocation(line: 23, column: 5, scope: !34)
!38 = !DILocation(line: 24, column: 16, scope: !34)
!39 = !DILocation(line: 25, column: 5, scope: !34)
!40 = distinct !DISubprogram(name: "main", scope: !10, file: !10, line: 30, type: !41, scopeLine: 30, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!41 = !DISubroutineType(types: !42)
!42 = !{!19}
!43 = !DILocation(line: 31, column: 4, scope: !40)
!44 = !DILocation(line: 32, column: 4, scope: !40)
!45 = !DILocalVariable(name: "t", scope: !40, file: !10, line: 34, type: !46)
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !47, line: 31, baseType: !48)
!47 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !49, line: 118, baseType: !50)
!49 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!50 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !51, size: 64)
!51 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !49, line: 103, size: 65536, elements: !52)
!52 = !{!53, !55, !65}
!53 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !51, file: !49, line: 104, baseType: !54, size: 64)
!54 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !51, file: !49, line: 105, baseType: !56, size: 64, offset: 64)
!56 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !57, size: 64)
!57 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !49, line: 57, size: 192, elements: !58)
!58 = !{!59, !63, !64}
!59 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !57, file: !49, line: 58, baseType: !60, size: 64)
!60 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !61, size: 64)
!61 = !DISubroutineType(types: !62)
!62 = !{null, !6}
!63 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !57, file: !49, line: 59, baseType: !6, size: 64, offset: 64)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !57, file: !49, line: 60, baseType: !56, size: 64, offset: 128)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !51, file: !49, line: 106, baseType: !66, size: 65408, offset: 128)
!66 = !DICompositeType(tag: DW_TAG_array_type, baseType: !67, size: 65408, elements: !68)
!67 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!68 = !{!69}
!69 = !DISubrange(count: 8176)
!70 = !DILocation(line: 34, column: 14, scope: !40)
!71 = !DILocation(line: 35, column: 38, scope: !40)
!72 = !DILocation(line: 35, column: 4, scope: !40)
!73 = !DILocation(line: 36, column: 17, scope: !40)
!74 = !DILocation(line: 36, column: 4, scope: !40)
!75 = !DILocation(line: 37, column: 4, scope: !40)
!76 = !DILocation(line: 38, column: 1, scope: !40)
