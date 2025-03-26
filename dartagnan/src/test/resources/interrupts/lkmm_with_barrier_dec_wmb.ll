; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/lkmm_with_barrier_dec_wmb.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/lkmm_with_barrier_dec_wmb.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

%struct.A = type { i32, i32 }
%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }

@cnt = global i32 0, align 4, !dbg !0
@as = global [10 x %struct.A] zeroinitializer, align 4, !dbg !31
@h = global %struct._opaque_pthread_t* null, align 8, !dbg !43

; Function Attrs: noinline nounwind ssp uwtable
define i8* @handler(i8* noundef %0) #0 !dbg !79 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !83, metadata !DIExpression()), !dbg !84
  call void @llvm.dbg.declare(metadata i32* %3, metadata !85, metadata !DIExpression()), !dbg !86
  %5 = load i8*, i8** %2, align 8, !dbg !87
  %6 = ptrtoint i8* %5 to i64, !dbg !88
  %7 = trunc i64 %6 to i32, !dbg !89
  store i32 %7, i32* %3, align 4, !dbg !86
  call void @llvm.dbg.declare(metadata i32* %4, metadata !90, metadata !DIExpression()), !dbg !91
  %8 = load i32, i32* @cnt, align 4, !dbg !92
  %9 = add nsw i32 %8, 1, !dbg !92
  store i32 %9, i32* @cnt, align 4, !dbg !92
  store i32 %8, i32* %4, align 4, !dbg !91
  call void @__LKMM_FENCE(i32 noundef 13), !dbg !93
  %10 = load i32, i32* %3, align 4, !dbg !94
  %11 = load i32, i32* %4, align 4, !dbg !95
  %12 = sext i32 %11 to i64, !dbg !96
  %13 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %12, !dbg !96
  %14 = getelementptr inbounds %struct.A, %struct.A* %13, i32 0, i32 0, !dbg !97
  store volatile i32 %10, i32* %14, align 4, !dbg !98
  %15 = load i32, i32* %3, align 4, !dbg !99
  %16 = load i32, i32* %4, align 4, !dbg !100
  %17 = sext i32 %16 to i64, !dbg !101
  %18 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %17, !dbg !101
  %19 = getelementptr inbounds %struct.A, %struct.A* %18, i32 0, i32 1, !dbg !102
  store volatile i32 %15, i32* %19, align 4, !dbg !103
  %20 = load i32, i32* %4, align 4, !dbg !104
  %21 = sext i32 %20 to i64, !dbg !105
  %22 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %21, !dbg !105
  %23 = getelementptr inbounds %struct.A, %struct.A* %22, i32 0, i32 0, !dbg !106
  %24 = load volatile i32, i32* %23, align 4, !dbg !106
  %25 = load i32, i32* %4, align 4, !dbg !107
  %26 = sext i32 %25 to i64, !dbg !108
  %27 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %26, !dbg !108
  %28 = getelementptr inbounds %struct.A, %struct.A* %27, i32 0, i32 1, !dbg !109
  %29 = load volatile i32, i32* %28, align 4, !dbg !109
  %30 = icmp eq i32 %24, %29, !dbg !110
  %31 = zext i1 %30 to i32, !dbg !110
  call void @__VERIFIER_assert(i32 noundef %31), !dbg !111
  call void @__LKMM_FENCE(i32 noundef 5), !dbg !112
  %32 = load i32, i32* @cnt, align 4, !dbg !113
  %33 = add nsw i32 %32, -1, !dbg !113
  store i32 %33, i32* @cnt, align 4, !dbg !113
  ret i8* null, !dbg !114
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__LKMM_FENCE(i32 noundef) #2

declare void @__VERIFIER_assert(i32 noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define i8* @run(i8* noundef %0) #0 !dbg !115 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !116, metadata !DIExpression()), !dbg !117
  call void @__VERIFIER_make_interrupt_handler(), !dbg !118
  %5 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef @h, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @handler, i8* noundef null), !dbg !119
  call void @llvm.dbg.declare(metadata i32* %3, metadata !120, metadata !DIExpression()), !dbg !121
  %6 = load i8*, i8** %2, align 8, !dbg !122
  %7 = ptrtoint i8* %6 to i64, !dbg !123
  %8 = trunc i64 %7 to i32, !dbg !124
  store i32 %8, i32* %3, align 4, !dbg !121
  call void @llvm.dbg.declare(metadata i32* %4, metadata !125, metadata !DIExpression()), !dbg !126
  %9 = load i32, i32* @cnt, align 4, !dbg !127
  %10 = add nsw i32 %9, 1, !dbg !127
  store i32 %10, i32* @cnt, align 4, !dbg !127
  store i32 %9, i32* %4, align 4, !dbg !126
  call void @__LKMM_FENCE(i32 noundef 13), !dbg !128
  %11 = load i32, i32* %3, align 4, !dbg !129
  %12 = load i32, i32* %4, align 4, !dbg !130
  %13 = sext i32 %12 to i64, !dbg !131
  %14 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %13, !dbg !131
  %15 = getelementptr inbounds %struct.A, %struct.A* %14, i32 0, i32 0, !dbg !132
  store volatile i32 %11, i32* %15, align 4, !dbg !133
  %16 = load i32, i32* %3, align 4, !dbg !134
  %17 = load i32, i32* %4, align 4, !dbg !135
  %18 = sext i32 %17 to i64, !dbg !136
  %19 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %18, !dbg !136
  %20 = getelementptr inbounds %struct.A, %struct.A* %19, i32 0, i32 1, !dbg !137
  store volatile i32 %16, i32* %20, align 4, !dbg !138
  %21 = load i32, i32* %4, align 4, !dbg !139
  %22 = sext i32 %21 to i64, !dbg !140
  %23 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %22, !dbg !140
  %24 = getelementptr inbounds %struct.A, %struct.A* %23, i32 0, i32 0, !dbg !141
  %25 = load volatile i32, i32* %24, align 4, !dbg !141
  %26 = load i32, i32* %4, align 4, !dbg !142
  %27 = sext i32 %26 to i64, !dbg !143
  %28 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %27, !dbg !143
  %29 = getelementptr inbounds %struct.A, %struct.A* %28, i32 0, i32 1, !dbg !144
  %30 = load volatile i32, i32* %29, align 4, !dbg !144
  %31 = icmp eq i32 %25, %30, !dbg !145
  %32 = zext i1 %31 to i32, !dbg !145
  call void @__VERIFIER_assert(i32 noundef %32), !dbg !146
  call void @__LKMM_FENCE(i32 noundef 5), !dbg !147
  %33 = load i32, i32* @cnt, align 4, !dbg !148
  %34 = add nsw i32 %33, -1, !dbg !148
  store i32 %34, i32* @cnt, align 4, !dbg !148
  %35 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** @h, align 8, !dbg !149
  %36 = call i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef %35, i8** noundef null), !dbg !150
  ret i8* null, !dbg !151
}

declare void @__VERIFIER_make_interrupt_handler() #2

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

declare i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef, i8** noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !152 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_t*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !155, metadata !DIExpression()), !dbg !156
  %3 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %2, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef inttoptr (i64 1 to i8*)), !dbg !157
  ret i32 0, !dbg !158
}

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!68, !69, !70, !71, !72, !73, !74, !75, !76, !77}
!llvm.ident = !{!78}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "cnt", scope: !2, file: !33, line: 13, type: !39, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !30, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/lkmm_with_barrier_dec_wmb.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 3, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "include/lkmm.h", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14, !15, !16, !17, !18, !19, !20, !21, !22}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0)
!10 = !DIEnumerator(name: "memory_order_once", value: 1)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2)
!12 = !DIEnumerator(name: "memory_order_release", value: 3)
!13 = !DIEnumerator(name: "mb", value: 4)
!14 = !DIEnumerator(name: "wmb", value: 5)
!15 = !DIEnumerator(name: "rmb", value: 6)
!16 = !DIEnumerator(name: "rcu_lock", value: 7)
!17 = !DIEnumerator(name: "rcu_unlock", value: 8)
!18 = !DIEnumerator(name: "rcu_sync", value: 9)
!19 = !DIEnumerator(name: "before_atomic", value: 10)
!20 = !DIEnumerator(name: "after_atomic", value: 11)
!21 = !DIEnumerator(name: "after_spinlock", value: 12)
!22 = !DIEnumerator(name: "barrier", value: 13)
!23 = !{!24, !29}
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !25, line: 32, baseType: !26)
!25 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_types/_intptr_t.h", directory: "")
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_intptr_t", file: !27, line: 27, baseType: !28)
!27 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/arm/_types.h", directory: "")
!28 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!29 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!30 = !{!0, !31, !43}
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(name: "as", scope: !2, file: !33, line: 12, type: !34, isLocal: false, isDefinition: true)
!33 = !DIFile(filename: "benchmarks/interrupts/lkmm_with_barrier_dec_wmb.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!34 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 640, elements: !41)
!35 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "A", file: !33, line: 11, size: 64, elements: !36)
!36 = !{!37, !40}
!37 = !DIDerivedType(tag: DW_TAG_member, name: "a", scope: !35, file: !33, line: 11, baseType: !38, size: 32)
!38 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !39)
!39 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!40 = !DIDerivedType(tag: DW_TAG_member, name: "b", scope: !35, file: !33, line: 11, baseType: !38, size: 32, offset: 32)
!41 = !{!42}
!42 = !DISubrange(count: 10)
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(name: "h", scope: !2, file: !33, line: 15, type: !45, isLocal: false, isDefinition: true)
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !46, line: 31, baseType: !47)
!46 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!47 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !48, line: 118, baseType: !49)
!48 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!49 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !50, size: 64)
!50 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !48, line: 103, size: 65536, elements: !51)
!51 = !{!52, !53, !63}
!52 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !50, file: !48, line: 104, baseType: !28, size: 64)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !50, file: !48, line: 105, baseType: !54, size: 64, offset: 64)
!54 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !55, size: 64)
!55 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !48, line: 57, size: 192, elements: !56)
!56 = !{!57, !61, !62}
!57 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !55, file: !48, line: 58, baseType: !58, size: 64)
!58 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !59, size: 64)
!59 = !DISubroutineType(types: !60)
!60 = !{null, !29}
!61 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !55, file: !48, line: 59, baseType: !29, size: 64, offset: 64)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !55, file: !48, line: 60, baseType: !54, size: 64, offset: 128)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !50, file: !48, line: 106, baseType: !64, size: 65408, offset: 128)
!64 = !DICompositeType(tag: DW_TAG_array_type, baseType: !65, size: 65408, elements: !66)
!65 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!66 = !{!67}
!67 = !DISubrange(count: 8176)
!68 = !{i32 7, !"Dwarf Version", i32 4}
!69 = !{i32 2, !"Debug Info Version", i32 3}
!70 = !{i32 1, !"wchar_size", i32 4}
!71 = !{i32 1, !"branch-target-enforcement", i32 0}
!72 = !{i32 1, !"sign-return-address", i32 0}
!73 = !{i32 1, !"sign-return-address-all", i32 0}
!74 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!75 = !{i32 7, !"PIC Level", i32 2}
!76 = !{i32 7, !"uwtable", i32 1}
!77 = !{i32 7, !"frame-pointer", i32 1}
!78 = !{!"Homebrew clang version 14.0.6"}
!79 = distinct !DISubprogram(name: "handler", scope: !33, file: !33, line: 16, type: !80, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !82)
!80 = !DISubroutineType(types: !81)
!81 = !{!29, !29}
!82 = !{}
!83 = !DILocalVariable(name: "arg", arg: 1, scope: !79, file: !33, line: 16, type: !29)
!84 = !DILocation(line: 16, column: 21, scope: !79)
!85 = !DILocalVariable(name: "tindex", scope: !79, file: !33, line: 18, type: !39)
!86 = !DILocation(line: 18, column: 9, scope: !79)
!87 = !DILocation(line: 18, column: 30, scope: !79)
!88 = !DILocation(line: 18, column: 19, scope: !79)
!89 = !DILocation(line: 18, column: 18, scope: !79)
!90 = !DILocalVariable(name: "i", scope: !79, file: !33, line: 19, type: !39)
!91 = !DILocation(line: 19, column: 9, scope: !79)
!92 = !DILocation(line: 19, column: 16, scope: !79)
!93 = !DILocation(line: 20, column: 5, scope: !79)
!94 = !DILocation(line: 21, column: 15, scope: !79)
!95 = !DILocation(line: 21, column: 8, scope: !79)
!96 = !DILocation(line: 21, column: 5, scope: !79)
!97 = !DILocation(line: 21, column: 11, scope: !79)
!98 = !DILocation(line: 21, column: 13, scope: !79)
!99 = !DILocation(line: 22, column: 15, scope: !79)
!100 = !DILocation(line: 22, column: 8, scope: !79)
!101 = !DILocation(line: 22, column: 5, scope: !79)
!102 = !DILocation(line: 22, column: 11, scope: !79)
!103 = !DILocation(line: 22, column: 13, scope: !79)
!104 = !DILocation(line: 23, column: 26, scope: !79)
!105 = !DILocation(line: 23, column: 23, scope: !79)
!106 = !DILocation(line: 23, column: 29, scope: !79)
!107 = !DILocation(line: 23, column: 37, scope: !79)
!108 = !DILocation(line: 23, column: 34, scope: !79)
!109 = !DILocation(line: 23, column: 40, scope: !79)
!110 = !DILocation(line: 23, column: 31, scope: !79)
!111 = !DILocation(line: 23, column: 5, scope: !79)
!112 = !DILocation(line: 25, column: 5, scope: !79)
!113 = !DILocation(line: 26, column: 8, scope: !79)
!114 = !DILocation(line: 28, column: 5, scope: !79)
!115 = distinct !DISubprogram(name: "run", scope: !33, file: !33, line: 31, type: !80, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !82)
!116 = !DILocalVariable(name: "arg", arg: 1, scope: !115, file: !33, line: 31, type: !29)
!117 = !DILocation(line: 31, column: 17, scope: !115)
!118 = !DILocation(line: 33, column: 5, scope: !115)
!119 = !DILocation(line: 34, column: 5, scope: !115)
!120 = !DILocalVariable(name: "tindex", scope: !115, file: !33, line: 36, type: !39)
!121 = !DILocation(line: 36, column: 9, scope: !115)
!122 = !DILocation(line: 36, column: 30, scope: !115)
!123 = !DILocation(line: 36, column: 19, scope: !115)
!124 = !DILocation(line: 36, column: 18, scope: !115)
!125 = !DILocalVariable(name: "i", scope: !115, file: !33, line: 37, type: !39)
!126 = !DILocation(line: 37, column: 9, scope: !115)
!127 = !DILocation(line: 37, column: 16, scope: !115)
!128 = !DILocation(line: 38, column: 5, scope: !115)
!129 = !DILocation(line: 39, column: 15, scope: !115)
!130 = !DILocation(line: 39, column: 8, scope: !115)
!131 = !DILocation(line: 39, column: 5, scope: !115)
!132 = !DILocation(line: 39, column: 11, scope: !115)
!133 = !DILocation(line: 39, column: 13, scope: !115)
!134 = !DILocation(line: 40, column: 15, scope: !115)
!135 = !DILocation(line: 40, column: 8, scope: !115)
!136 = !DILocation(line: 40, column: 5, scope: !115)
!137 = !DILocation(line: 40, column: 11, scope: !115)
!138 = !DILocation(line: 40, column: 13, scope: !115)
!139 = !DILocation(line: 41, column: 26, scope: !115)
!140 = !DILocation(line: 41, column: 23, scope: !115)
!141 = !DILocation(line: 41, column: 29, scope: !115)
!142 = !DILocation(line: 41, column: 37, scope: !115)
!143 = !DILocation(line: 41, column: 34, scope: !115)
!144 = !DILocation(line: 41, column: 40, scope: !115)
!145 = !DILocation(line: 41, column: 31, scope: !115)
!146 = !DILocation(line: 41, column: 5, scope: !115)
!147 = !DILocation(line: 43, column: 5, scope: !115)
!148 = !DILocation(line: 44, column: 8, scope: !115)
!149 = !DILocation(line: 46, column: 18, scope: !115)
!150 = !DILocation(line: 46, column: 5, scope: !115)
!151 = !DILocation(line: 48, column: 5, scope: !115)
!152 = distinct !DISubprogram(name: "main", scope: !33, file: !33, line: 51, type: !153, scopeLine: 52, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !82)
!153 = !DISubroutineType(types: !154)
!154 = !{!39}
!155 = !DILocalVariable(name: "t", scope: !152, file: !33, line: 53, type: !45)
!156 = !DILocation(line: 53, column: 15, scope: !152)
!157 = !DILocation(line: 54, column: 5, scope: !152)
!158 = !DILocation(line: 56, column: 5, scope: !152)
