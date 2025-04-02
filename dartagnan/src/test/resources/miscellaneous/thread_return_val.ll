; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/thread_return_val.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/thread_return_val.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }

@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1
@.str = private unnamed_addr constant [20 x i8] c"thread_return_val.c\00", align 1
@.str.1 = private unnamed_addr constant [36 x i8] c"retVal1 == retVal2 && retVal1 == 42\00", align 1
@.str.2 = private unnamed_addr constant [14 x i8] c"retVal1 == 41\00", align 1

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread1(i8* noundef %0) #0 !dbg !15 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !20, metadata !DIExpression()), !dbg !21
  ret i8* inttoptr (i64 42 to i8*), !dbg !22
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread2(i8* noundef %0) #0 !dbg !23 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !24, metadata !DIExpression()), !dbg !25
  call void @pthread_exit(i8* noundef inttoptr (i64 42 to i8*)) #5, !dbg !26
  unreachable, !dbg !26
}

; Function Attrs: noreturn
declare void @pthread_exit(i8* noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @returnValue(i8* noundef %0) #0 !dbg !27 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !30, metadata !DIExpression()), !dbg !31
  %3 = load i8*, i8** %2, align 8, !dbg !32
  call void @pthread_exit(i8* noundef %3) #5, !dbg !33
  unreachable, !dbg !33
}

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread3(i8* noundef %0) #0 !dbg !34 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !35, metadata !DIExpression()), !dbg !36
  call void @returnValue(i8* noundef inttoptr (i64 41 to i8*)), !dbg !37
  ret i8* null, !dbg !38
}

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !39 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_t*, align 8
  %3 = alloca %struct._opaque_pthread_t*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !43, metadata !DIExpression()), !dbg !66
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %3, metadata !67, metadata !DIExpression()), !dbg !68
  call void @llvm.dbg.declare(metadata i8** %4, metadata !69, metadata !DIExpression()), !dbg !70
  call void @llvm.dbg.declare(metadata i8** %5, metadata !71, metadata !DIExpression()), !dbg !72
  %6 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %2, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread1, i8* noundef null), !dbg !73
  %7 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %3, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread2, i8* noundef null), !dbg !74
  %8 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %2, align 8, !dbg !75
  %9 = call i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef %8, i8** noundef %4), !dbg !76
  %10 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %3, align 8, !dbg !77
  %11 = call i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef %10, i8** noundef %5), !dbg !78
  %12 = load i8*, i8** %4, align 8, !dbg !79
  %13 = load i8*, i8** %5, align 8, !dbg !79
  %14 = icmp eq i8* %12, %13, !dbg !79
  br i1 %14, label %15, label %18, !dbg !79

15:                                               ; preds = %0
  %16 = load i8*, i8** %4, align 8, !dbg !79
  %17 = icmp eq i8* %16, inttoptr (i64 42 to i8*), !dbg !79
  br label %18

18:                                               ; preds = %15, %0
  %19 = phi i1 [ false, %0 ], [ %17, %15 ], !dbg !80
  %20 = xor i1 %19, true, !dbg !79
  %21 = zext i1 %20 to i32, !dbg !79
  %22 = sext i32 %21 to i64, !dbg !79
  %23 = icmp ne i64 %22, 0, !dbg !79
  br i1 %23, label %24, label %26, !dbg !79

24:                                               ; preds = %18
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @__func__.main, i64 0, i64 0), i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @.str, i64 0, i64 0), i32 noundef 43, i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @.str.1, i64 0, i64 0)) #6, !dbg !79
  unreachable, !dbg !79

25:                                               ; No predecessors!
  br label %27, !dbg !79

26:                                               ; preds = %18
  br label %27, !dbg !79

27:                                               ; preds = %26, %25
  %28 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %2, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread3, i8* noundef null), !dbg !81
  %29 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %2, align 8, !dbg !82
  %30 = call i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef %29, i8** noundef %4), !dbg !83
  %31 = load i8*, i8** %4, align 8, !dbg !84
  %32 = icmp eq i8* %31, inttoptr (i64 41 to i8*), !dbg !84
  %33 = xor i1 %32, true, !dbg !84
  %34 = zext i1 %33 to i32, !dbg !84
  %35 = sext i32 %34 to i64, !dbg !84
  %36 = icmp ne i64 %35, 0, !dbg !84
  br i1 %36, label %37, label %39, !dbg !84

37:                                               ; preds = %27
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @__func__.main, i64 0, i64 0), i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @.str, i64 0, i64 0), i32 noundef 47, i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @.str.2, i64 0, i64 0)) #6, !dbg !84
  unreachable, !dbg !84

38:                                               ; No predecessors!
  br label %40, !dbg !84

39:                                               ; preds = %27
  br label %40, !dbg !84

40:                                               ; preds = %39, %38
  %41 = load i32, i32* %1, align 4, !dbg !85
  ret i32 %41, !dbg !85
}

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef, i8** noundef) #3

; Function Attrs: cold noreturn
declare void @__assert_rtn(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #4

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #3 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #4 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #5 = { noreturn }
attributes #6 = { cold noreturn }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!4, !5, !6, !7, !8, !9, !10, !11, !12, !13}
!llvm.ident = !{!14}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!1 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/thread_return_val.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!2 = !{!3}
!3 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!4 = !{i32 7, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = !{i32 1, !"branch-target-enforcement", i32 0}
!8 = !{i32 1, !"sign-return-address", i32 0}
!9 = !{i32 1, !"sign-return-address-all", i32 0}
!10 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!11 = !{i32 7, !"PIC Level", i32 2}
!12 = !{i32 7, !"uwtable", i32 1}
!13 = !{i32 7, !"frame-pointer", i32 1}
!14 = !{!"Homebrew clang version 14.0.6"}
!15 = distinct !DISubprogram(name: "thread1", scope: !16, file: !16, line: 12, type: !17, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !19)
!16 = !DIFile(filename: "benchmarks/miscellaneous/thread_return_val.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!17 = !DISubroutineType(types: !18)
!18 = !{!3, !3}
!19 = !{}
!20 = !DILocalVariable(name: "arg", arg: 1, scope: !15, file: !16, line: 12, type: !3)
!21 = !DILocation(line: 12, column: 21, scope: !15)
!22 = !DILocation(line: 14, column: 5, scope: !15)
!23 = distinct !DISubprogram(name: "thread2", scope: !16, file: !16, line: 17, type: !17, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !19)
!24 = !DILocalVariable(name: "arg", arg: 1, scope: !23, file: !16, line: 17, type: !3)
!25 = !DILocation(line: 17, column: 21, scope: !23)
!26 = !DILocation(line: 19, column: 5, scope: !23)
!27 = distinct !DISubprogram(name: "returnValue", scope: !16, file: !16, line: 23, type: !28, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !19)
!28 = !DISubroutineType(types: !29)
!29 = !{null, !3}
!30 = !DILocalVariable(name: "arg", arg: 1, scope: !27, file: !16, line: 23, type: !3)
!31 = !DILocation(line: 23, column: 24, scope: !27)
!32 = !DILocation(line: 24, column: 18, scope: !27)
!33 = !DILocation(line: 24, column: 5, scope: !27)
!34 = distinct !DISubprogram(name: "thread3", scope: !16, file: !16, line: 27, type: !17, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !19)
!35 = !DILocalVariable(name: "arg", arg: 1, scope: !34, file: !16, line: 27, type: !3)
!36 = !DILocation(line: 27, column: 21, scope: !34)
!37 = !DILocation(line: 29, column: 5, scope: !34)
!38 = !DILocation(line: 30, column: 5, scope: !34)
!39 = distinct !DISubprogram(name: "main", scope: !16, file: !16, line: 33, type: !40, scopeLine: 34, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !19)
!40 = !DISubroutineType(types: !41)
!41 = !{!42}
!42 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!43 = !DILocalVariable(name: "t1", scope: !39, file: !16, line: 35, type: !44)
!44 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !45, line: 31, baseType: !46)
!45 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !47, line: 118, baseType: !48)
!47 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!48 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !49, size: 64)
!49 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !47, line: 103, size: 65536, elements: !50)
!50 = !{!51, !53, !61}
!51 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !49, file: !47, line: 104, baseType: !52, size: 64)
!52 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !49, file: !47, line: 105, baseType: !54, size: 64, offset: 64)
!54 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !55, size: 64)
!55 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !47, line: 57, size: 192, elements: !56)
!56 = !{!57, !59, !60}
!57 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !55, file: !47, line: 58, baseType: !58, size: 64)
!58 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !28, size: 64)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !55, file: !47, line: 59, baseType: !3, size: 64, offset: 64)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !55, file: !47, line: 60, baseType: !54, size: 64, offset: 128)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !49, file: !47, line: 106, baseType: !62, size: 65408, offset: 128)
!62 = !DICompositeType(tag: DW_TAG_array_type, baseType: !63, size: 65408, elements: !64)
!63 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!64 = !{!65}
!65 = !DISubrange(count: 8176)
!66 = !DILocation(line: 35, column: 15, scope: !39)
!67 = !DILocalVariable(name: "t2", scope: !39, file: !16, line: 35, type: !44)
!68 = !DILocation(line: 35, column: 19, scope: !39)
!69 = !DILocalVariable(name: "retVal1", scope: !39, file: !16, line: 36, type: !3)
!70 = !DILocation(line: 36, column: 11, scope: !39)
!71 = !DILocalVariable(name: "retVal2", scope: !39, file: !16, line: 36, type: !3)
!72 = !DILocation(line: 36, column: 21, scope: !39)
!73 = !DILocation(line: 38, column: 5, scope: !39)
!74 = !DILocation(line: 39, column: 5, scope: !39)
!75 = !DILocation(line: 41, column: 18, scope: !39)
!76 = !DILocation(line: 41, column: 5, scope: !39)
!77 = !DILocation(line: 42, column: 18, scope: !39)
!78 = !DILocation(line: 42, column: 5, scope: !39)
!79 = !DILocation(line: 43, column: 5, scope: !39)
!80 = !DILocation(line: 0, scope: !39)
!81 = !DILocation(line: 45, column: 5, scope: !39)
!82 = !DILocation(line: 46, column: 18, scope: !39)
!83 = !DILocation(line: 46, column: 5, scope: !39)
!84 = !DILocation(line: 47, column: 5, scope: !39)
!85 = !DILocation(line: 48, column: 1, scope: !39)
