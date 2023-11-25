; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/output/thread_id.ll'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/c/miscellaneous/thread_id.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx13.0.0"

%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }

@childTid = dso_local global %struct._opaque_pthread_t* null, align 8, !dbg !0
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1
@.str = private unnamed_addr constant [12 x i8] c"thread_id.c\00", align 1
@.str.1 = private unnamed_addr constant [15 x i8] c"childTid == t1\00", align 1
@.str.2 = private unnamed_addr constant [35 x i8] c"__VERIFIER_tid() == pthread_self()\00", align 1

; Function Attrs: noinline nounwind ssp uwtable
define dso_local i8* @thread1(i8* %0) #0 !dbg !42 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !45, metadata !DIExpression()), !dbg !46
  %2 = call %struct._opaque_pthread_t* @pthread_self(), !dbg !47
  store %struct._opaque_pthread_t* %2, %struct._opaque_pthread_t** @childTid, align 8, !dbg !48
  ret i8* null, !dbg !49
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare %struct._opaque_pthread_t* @pthread_self() #2

; Function Attrs: noinline nounwind ssp uwtable
define dso_local i32 @main() #0 !dbg !50 {
  %1 = alloca %struct._opaque_pthread_t*, align 8
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %1, metadata !54, metadata !DIExpression()), !dbg !55
  %2 = call i32 @pthread_create(%struct._opaque_pthread_t** %1, %struct._opaque_pthread_attr_t* null, i8* (i8*)* @thread1, i8* inttoptr (i64 42 to i8*)), !dbg !56
  %3 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %1, align 8, !dbg !57
  %4 = call i32 @"\01_pthread_join"(%struct._opaque_pthread_t* %3, i8** null), !dbg !58
  %5 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** @childTid, align 8, !dbg !59
  %6 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %1, align 8, !dbg !59
  %7 = icmp eq %struct._opaque_pthread_t* %5, %6, !dbg !59
  %8 = xor i1 %7, true, !dbg !59
  %9 = zext i1 %8 to i32, !dbg !59
  %10 = sext i32 %9 to i64, !dbg !59
  br i1 %8, label %11, label %12, !dbg !59

11:                                               ; preds = %0
  call void @__assert_rtn(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @__func__.main, i64 0, i64 0), i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i64 0, i64 0), i32 27, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !59
  unreachable, !dbg !59

12:                                               ; preds = %0
  %13 = call i32 @__VERIFIER_tid(), !dbg !60
  %14 = zext i32 %13 to i64, !dbg !60
  %15 = inttoptr i64 %14 to %struct._opaque_pthread_t*, !dbg !60
  %16 = call %struct._opaque_pthread_t* @pthread_self(), !dbg !60
  %17 = icmp eq %struct._opaque_pthread_t* %15, %16, !dbg !60
  %18 = xor i1 %17, true, !dbg !60
  %19 = zext i1 %18 to i32, !dbg !60
  %20 = sext i32 %19 to i64, !dbg !60
  br i1 %18, label %21, label %22, !dbg !60

21:                                               ; preds = %12
  call void @__assert_rtn(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @__func__.main, i64 0, i64 0), i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i64 0, i64 0), i32 28, i8* getelementptr inbounds ([35 x i8], [35 x i8]* @.str.2, i64 0, i64 0)) #4, !dbg !60
  unreachable, !dbg !60

22:                                               ; preds = %12
  ret i32 0, !dbg !61
}

declare i32 @pthread_create(%struct._opaque_pthread_t**, %struct._opaque_pthread_attr_t*, i8* (i8*)*, i8*) #2

declare i32 @"\01_pthread_join"(%struct._opaque_pthread_t*, i8**) #2

; Function Attrs: cold noreturn
declare void @__assert_rtn(i8*, i8*, i32, i8*) #3

declare i32 @__VERIFIER_tid() #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind ssp uwtable "disable-tail-calls"="false" "frame-pointer"="non-leaf" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-a12" "target-features"="+aes,+crc,+crypto,+fp-armv8,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.3a,+zcm,+zcz" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "disable-tail-calls"="false" "frame-pointer"="non-leaf" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-a12" "target-features"="+aes,+crc,+crypto,+fp-armv8,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.3a,+zcm,+zcz" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-a12" "target-features"="+aes,+crc,+crypto,+fp-armv8,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.3a,+zcm,+zcz" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!33, !34, !35, !36, !37, !38, !39, !40}
!llvm.ident = !{!41}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "childTid", scope: !2, file: !8, line: 12, type: !9, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 12.0.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !7, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/c/miscellaneous/thread_id.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{}
!5 = !{!6}
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!7 = !{!0}
!8 = !DIFile(filename: "benchmarks/c/miscellaneous/thread_id.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!9 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !10, line: 31, baseType: !11)
!10 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!11 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !12, line: 118, baseType: !13)
!12 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!13 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!14 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !12, line: 103, size: 65536, elements: !15)
!15 = !{!16, !18, !28}
!16 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !14, file: !12, line: 104, baseType: !17, size: 64)
!17 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!18 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !14, file: !12, line: 105, baseType: !19, size: 64, offset: 64)
!19 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64)
!20 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !12, line: 57, size: 192, elements: !21)
!21 = !{!22, !26, !27}
!22 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !20, file: !12, line: 58, baseType: !23, size: 64)
!23 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !24, size: 64)
!24 = !DISubroutineType(types: !25)
!25 = !{null, !6}
!26 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !20, file: !12, line: 59, baseType: !6, size: 64, offset: 64)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !20, file: !12, line: 60, baseType: !19, size: 64, offset: 128)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !14, file: !12, line: 106, baseType: !29, size: 65408, offset: 128)
!29 = !DICompositeType(tag: DW_TAG_array_type, baseType: !30, size: 65408, elements: !31)
!30 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!31 = !{!32}
!32 = !DISubrange(count: 8176)
!33 = !{i32 7, !"Dwarf Version", i32 4}
!34 = !{i32 2, !"Debug Info Version", i32 3}
!35 = !{i32 1, !"wchar_size", i32 4}
!36 = !{i32 1, !"branch-target-enforcement", i32 0}
!37 = !{i32 1, !"sign-return-address", i32 0}
!38 = !{i32 1, !"sign-return-address-all", i32 0}
!39 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!40 = !{i32 7, !"PIC Level", i32 2}
!41 = !{!"Homebrew clang version 12.0.1"}
!42 = distinct !DISubprogram(name: "thread1", scope: !8, file: !8, line: 14, type: !43, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!43 = !DISubroutineType(types: !44)
!44 = !{!6, !6}
!45 = !DILocalVariable(name: "arg", arg: 1, scope: !42, file: !8, line: 14, type: !6)
!46 = !DILocation(line: 0, scope: !42)
!47 = !DILocation(line: 16, column: 16, scope: !42)
!48 = !DILocation(line: 16, column: 14, scope: !42)
!49 = !DILocation(line: 17, column: 5, scope: !42)
!50 = distinct !DISubprogram(name: "main", scope: !8, file: !8, line: 20, type: !51, scopeLine: 21, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!51 = !DISubroutineType(types: !52)
!52 = !{!53}
!53 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!54 = !DILocalVariable(name: "t1", scope: !50, file: !8, line: 22, type: !9)
!55 = !DILocation(line: 22, column: 15, scope: !50)
!56 = !DILocation(line: 23, column: 5, scope: !50)
!57 = !DILocation(line: 24, column: 18, scope: !50)
!58 = !DILocation(line: 24, column: 5, scope: !50)
!59 = !DILocation(line: 27, column: 5, scope: !50)
!60 = !DILocation(line: 28, column: 5, scope: !50)
!61 = !DILocation(line: 29, column: 1, scope: !50)
