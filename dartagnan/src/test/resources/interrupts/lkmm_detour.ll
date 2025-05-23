; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/lkmm_detour.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/lkmm_detour.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }

@y = global i32 0, align 4, !dbg !0
@h = global %struct._opaque_pthread_t* null, align 8, !dbg !34
@x = global i32 0, align 4, !dbg !26
@a = global i32 0, align 4, !dbg !30
@b = global i32 0, align 4, !dbg !32

; Function Attrs: noinline nounwind ssp uwtable
define i8* @handler(i8* noundef %0) #0 !dbg !71 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !75, metadata !DIExpression()), !dbg !76
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @y to i8*), i32 noundef 3, i32 noundef 1), !dbg !77
  ret i8* null, !dbg !78
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__LKMM_STORE(i8* noundef, i32 noundef, i32 noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread_1(i8* noundef %0) #0 !dbg !79 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !80, metadata !DIExpression()), !dbg !81
  call void @__VERIFIER_make_interrupt_handler(), !dbg !82
  %3 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef @h, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @handler, i8* noundef null), !dbg !83
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @x to i8*), i32 noundef 1, i32 noundef 1), !dbg !84
  %4 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @y to i8*), i32 noundef 1), !dbg !85
  store i32 %4, i32* @a, align 4, !dbg !86
  %5 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** @h, align 8, !dbg !87
  %6 = call i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef %5, i8** noundef null), !dbg !88
  ret i8* null, !dbg !89
}

declare void @__VERIFIER_make_interrupt_handler() #2

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

declare i32 @__LKMM_LOAD(i8* noundef, i32 noundef) #2

declare i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef, i8** noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread_2(i8* noundef %0) #0 !dbg !90 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !91, metadata !DIExpression()), !dbg !92
  %3 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @x to i8*), i32 noundef 1), !dbg !93
  store i32 %3, i32* @b, align 4, !dbg !94
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @y to i8*), i32 noundef 2, i32 noundef 3), !dbg !95
  ret i8* null, !dbg !96
}

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !97 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_t*, align 8
  %3 = alloca %struct._opaque_pthread_t*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !100, metadata !DIExpression()), !dbg !101
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %3, metadata !102, metadata !DIExpression()), !dbg !103
  %4 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %2, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_1, i8* noundef null), !dbg !104
  %5 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %3, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_2, i8* noundef null), !dbg !105
  %6 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %2, align 8, !dbg !106
  %7 = call i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef %6, i8** noundef null), !dbg !107
  %8 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %3, align 8, !dbg !108
  %9 = call i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef %8, i8** noundef null), !dbg !109
  %10 = load i32, i32* @b, align 4, !dbg !110
  %11 = icmp eq i32 %10, 1, !dbg !111
  br i1 %11, label %12, label %18, !dbg !112

12:                                               ; preds = %0
  %13 = load i32, i32* @a, align 4, !dbg !113
  %14 = icmp eq i32 %13, 3, !dbg !114
  br i1 %14, label %15, label %18, !dbg !115

15:                                               ; preds = %12
  %16 = load i32, i32* @y, align 4, !dbg !116
  %17 = icmp eq i32 %16, 3, !dbg !117
  br label %18

18:                                               ; preds = %15, %12, %0
  %19 = phi i1 [ false, %12 ], [ false, %0 ], [ %17, %15 ], !dbg !118
  %20 = xor i1 %19, true, !dbg !119
  %21 = zext i1 %20 to i32, !dbg !119
  call void @__VERIFIER_assert(i32 noundef %21), !dbg !120
  ret i32 0, !dbg !121
}

declare void @__VERIFIER_assert(i32 noundef) #2

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!60, !61, !62, !63, !64, !65, !66, !67, !68, !69}
!llvm.ident = !{!70}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !28, line: 7, type: !29, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !25, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/lkmm_detour.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
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
!23 = !{!24}
!24 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!25 = !{!26, !0, !30, !32, !34}
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !28, line: 7, type: !29, isLocal: false, isDefinition: true)
!28 = !DIFile(filename: "benchmarks/interrupts/lkmm_detour.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!29 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !28, line: 7, type: !29, isLocal: false, isDefinition: true)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !28, line: 7, type: !29, isLocal: false, isDefinition: true)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(name: "h", scope: !2, file: !28, line: 9, type: !36, isLocal: false, isDefinition: true)
!36 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !37, line: 31, baseType: !38)
!37 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !39, line: 118, baseType: !40)
!39 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!40 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !41, size: 64)
!41 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !39, line: 103, size: 65536, elements: !42)
!42 = !{!43, !45, !55}
!43 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !41, file: !39, line: 104, baseType: !44, size: 64)
!44 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!45 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !41, file: !39, line: 105, baseType: !46, size: 64, offset: 64)
!46 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !47, size: 64)
!47 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !39, line: 57, size: 192, elements: !48)
!48 = !{!49, !53, !54}
!49 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !47, file: !39, line: 58, baseType: !50, size: 64)
!50 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !51, size: 64)
!51 = !DISubroutineType(types: !52)
!52 = !{null, !24}
!53 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !47, file: !39, line: 59, baseType: !24, size: 64, offset: 64)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !47, file: !39, line: 60, baseType: !46, size: 64, offset: 128)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !41, file: !39, line: 106, baseType: !56, size: 65408, offset: 128)
!56 = !DICompositeType(tag: DW_TAG_array_type, baseType: !57, size: 65408, elements: !58)
!57 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!58 = !{!59}
!59 = !DISubrange(count: 8176)
!60 = !{i32 7, !"Dwarf Version", i32 4}
!61 = !{i32 2, !"Debug Info Version", i32 3}
!62 = !{i32 1, !"wchar_size", i32 4}
!63 = !{i32 1, !"branch-target-enforcement", i32 0}
!64 = !{i32 1, !"sign-return-address", i32 0}
!65 = !{i32 1, !"sign-return-address-all", i32 0}
!66 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!67 = !{i32 7, !"PIC Level", i32 2}
!68 = !{i32 7, !"uwtable", i32 1}
!69 = !{i32 7, !"frame-pointer", i32 1}
!70 = !{!"Homebrew clang version 14.0.6"}
!71 = distinct !DISubprogram(name: "handler", scope: !28, file: !28, line: 10, type: !72, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !74)
!72 = !DISubroutineType(types: !73)
!73 = !{!24, !24}
!74 = !{}
!75 = !DILocalVariable(name: "arg", arg: 1, scope: !71, file: !28, line: 10, type: !24)
!76 = !DILocation(line: 10, column: 21, scope: !71)
!77 = !DILocation(line: 12, column: 5, scope: !71)
!78 = !DILocation(line: 13, column: 5, scope: !71)
!79 = distinct !DISubprogram(name: "thread_1", scope: !28, file: !28, line: 16, type: !72, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !74)
!80 = !DILocalVariable(name: "arg", arg: 1, scope: !79, file: !28, line: 16, type: !24)
!81 = !DILocation(line: 16, column: 22, scope: !79)
!82 = !DILocation(line: 18, column: 5, scope: !79)
!83 = !DILocation(line: 19, column: 5, scope: !79)
!84 = !DILocation(line: 21, column: 5, scope: !79)
!85 = !DILocation(line: 22, column: 9, scope: !79)
!86 = !DILocation(line: 22, column: 7, scope: !79)
!87 = !DILocation(line: 24, column: 18, scope: !79)
!88 = !DILocation(line: 24, column: 5, scope: !79)
!89 = !DILocation(line: 26, column: 5, scope: !79)
!90 = distinct !DISubprogram(name: "thread_2", scope: !28, file: !28, line: 29, type: !72, scopeLine: 30, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !74)
!91 = !DILocalVariable(name: "arg", arg: 1, scope: !90, file: !28, line: 29, type: !24)
!92 = !DILocation(line: 29, column: 22, scope: !90)
!93 = !DILocation(line: 31, column: 9, scope: !90)
!94 = !DILocation(line: 31, column: 7, scope: !90)
!95 = !DILocation(line: 32, column: 5, scope: !90)
!96 = !DILocation(line: 33, column: 5, scope: !90)
!97 = distinct !DISubprogram(name: "main", scope: !28, file: !28, line: 36, type: !98, scopeLine: 37, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !74)
!98 = !DISubroutineType(types: !99)
!99 = !{!29}
!100 = !DILocalVariable(name: "t1", scope: !97, file: !28, line: 38, type: !36)
!101 = !DILocation(line: 38, column: 15, scope: !97)
!102 = !DILocalVariable(name: "t2", scope: !97, file: !28, line: 38, type: !36)
!103 = !DILocation(line: 38, column: 19, scope: !97)
!104 = !DILocation(line: 40, column: 5, scope: !97)
!105 = !DILocation(line: 41, column: 5, scope: !97)
!106 = !DILocation(line: 42, column: 18, scope: !97)
!107 = !DILocation(line: 42, column: 5, scope: !97)
!108 = !DILocation(line: 43, column: 18, scope: !97)
!109 = !DILocation(line: 43, column: 5, scope: !97)
!110 = !DILocation(line: 45, column: 25, scope: !97)
!111 = !DILocation(line: 45, column: 27, scope: !97)
!112 = !DILocation(line: 45, column: 32, scope: !97)
!113 = !DILocation(line: 45, column: 35, scope: !97)
!114 = !DILocation(line: 45, column: 37, scope: !97)
!115 = !DILocation(line: 45, column: 42, scope: !97)
!116 = !DILocation(line: 45, column: 45, scope: !97)
!117 = !DILocation(line: 45, column: 47, scope: !97)
!118 = !DILocation(line: 0, scope: !97)
!119 = !DILocation(line: 45, column: 23, scope: !97)
!120 = !DILocation(line: 45, column: 5, scope: !97)
!121 = !DILocation(line: 47, column: 5, scope: !97)
