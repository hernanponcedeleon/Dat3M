; ModuleID = 'benchmarks/miscellaneous/thread_create_tid_store.c'
source_filename = "benchmarks/miscellaneous/thread_create_tid_store.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

%struct._opaque_pthread_mutex_t = type { i64, [56 x i8] }

@worker_tid = global ptr inttoptr (i64 42 to ptr), align 8, !dbg !0
@done = global i8 0, align 1, !dbg !31
@mutex = global %struct._opaque_pthread_mutex_t zeroinitializer, align 8, !dbg !50
@__func__.cleaner = private unnamed_addr constant [8 x i8] c"cleaner\00", align 1, !dbg !34
@.str = private unnamed_addr constant [26 x i8] c"thread_create_tid_store.c\00", align 1, !dbg !40
@.str.1 = private unnamed_addr constant [12 x i8] c"status == 0\00", align 1, !dbg !45

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @worker(ptr noundef %0) #0 !dbg !69 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !73, !DIExpression(), !74)
  %3 = call i32 @pthread_mutex_lock(ptr noundef @mutex), !dbg !75
  store i8 1, ptr @done, align 1, !dbg !76
  %4 = call i32 @pthread_mutex_unlock(ptr noundef @mutex), !dbg !77
  ret ptr null, !dbg !78
}

declare i32 @pthread_mutex_lock(ptr noundef) #1

declare i32 @pthread_mutex_unlock(ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @cleaner(ptr noundef %0) #0 !dbg !79 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !80, !DIExpression(), !81)
  %4 = call i32 @pthread_mutex_lock(ptr noundef @mutex), !dbg !82
  %5 = load i8, ptr @done, align 1, !dbg !83
  %6 = icmp ne i8 %5, 0, !dbg !83
  br i1 %6, label %7, label %20, !dbg !83

7:                                                ; preds = %1
    #dbg_declare(ptr %3, !85, !DIExpression(), !88)
  %8 = load ptr, ptr @worker_tid, align 8, !dbg !89
  %9 = call i32 @"\01_pthread_join"(ptr noundef %8, ptr noundef null), !dbg !90
  store i32 %9, ptr %3, align 4, !dbg !88
  %10 = load i32, ptr %3, align 4, !dbg !91
  %11 = icmp eq i32 %10, 0, !dbg !92
  %12 = xor i1 %11, true, !dbg !93
  %13 = zext i1 %12 to i32, !dbg !93
  %14 = sext i32 %13 to i64, !dbg !93
  %15 = icmp ne i64 %14, 0, !dbg !93
  br i1 %15, label %16, label %18, !dbg !93

16:                                               ; preds = %7
  call void @__assert_rtn(ptr noundef @__func__.cleaner, ptr noundef @.str, i32 noundef 30, ptr noundef @.str.1) #3, !dbg !93
  unreachable, !dbg !93

17:                                               ; No predecessors!
  br label %19, !dbg !93

18:                                               ; preds = %7
  br label %19, !dbg !93

19:                                               ; preds = %18, %17
  br label %20, !dbg !94

20:                                               ; preds = %19, %1
  %21 = call i32 @pthread_mutex_unlock(ptr noundef @mutex), !dbg !95
  ret ptr null, !dbg !96
}

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !97 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
  %3 = call i32 @pthread_mutex_init(ptr noundef @mutex, ptr noundef null), !dbg !100
    #dbg_declare(ptr %2, !101, !DIExpression(), !102)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @cleaner, ptr noundef null), !dbg !103
  %5 = call i32 @pthread_create(ptr noundef @worker_tid, ptr noundef null, ptr noundef @worker, ptr noundef null), !dbg !104
  %6 = load ptr, ptr %2, align 8, !dbg !105
  %7 = call i32 @"\01_pthread_join"(ptr noundef %6, ptr noundef null), !dbg !106
  ret i32 0, !dbg !107
}

declare i32 @pthread_mutex_init(ptr noundef, ptr noundef) #1

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #1 = { "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #3 = { cold noreturn }

!llvm.module.flags = !{!62, !63, !64, !65, !66, !67}
!llvm.dbg.cu = !{!2}
!llvm.ident = !{!68}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "worker_tid", scope: !2, file: !3, line: 12, type: !5, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 23.1.3", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !30, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.2.sdk", sdk: "MacOSX15.2.sdk")
!3 = !DIFile(filename: "benchmarks/miscellaneous/thread_create_tid_store.c", directory: ".", checksumkind: CSK_MD5, checksum: "f93bd97d723bd7b3001427776a132670")
!4 = !{!5, !22}
!5 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !6, line: 31, baseType: !7)
!6 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !8, line: 118, baseType: !9)
!8 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!9 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!10 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !8, line: 103, size: 65536, elements: !11)
!11 = !{!12, !14, !25}
!12 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !10, file: !8, line: 104, baseType: !13, size: 64)
!13 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!14 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !10, file: !8, line: 105, baseType: !15, size: 64, offset: 64)
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !16, size: 64)
!16 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !8, line: 57, size: 192, elements: !17)
!17 = !{!18, !23, !24}
!18 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !16, file: !8, line: 58, baseType: !19, size: 64)
!19 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64)
!20 = !DISubroutineType(types: !21)
!21 = !{null, !22}
!22 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !16, file: !8, line: 59, baseType: !22, size: 64, offset: 64)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !16, file: !8, line: 60, baseType: !15, size: 64, offset: 128)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !10, file: !8, line: 106, baseType: !26, size: 65408, offset: 128)
!26 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 65408, elements: !28)
!27 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!28 = !{!29}
!29 = !DISubrange(count: 8176)
!30 = !{!0, !31, !34, !40, !45, !50}
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(name: "done", scope: !2, file: !3, line: 13, type: !33, isLocal: false, isDefinition: true)
!33 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(scope: null, file: !3, line: 30, type: !36, isLocal: true, isDefinition: true)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !37, size: 64, elements: !38)
!37 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !27)
!38 = !{!39}
!39 = !DISubrange(count: 8)
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(scope: null, file: !3, line: 30, type: !42, isLocal: true, isDefinition: true)
!42 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 208, elements: !43)
!43 = !{!44}
!44 = !DISubrange(count: 26)
!45 = !DIGlobalVariableExpression(var: !46, expr: !DIExpression())
!46 = distinct !DIGlobalVariable(scope: null, file: !3, line: 30, type: !47, isLocal: true, isDefinition: true)
!47 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 96, elements: !48)
!48 = !{!49}
!49 = !DISubrange(count: 12)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "mutex", scope: !2, file: !3, line: 14, type: !52, isLocal: false, isDefinition: true)
!52 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !53, line: 31, baseType: !54)
!53 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_pthread/_pthread_mutex_t.h", directory: "", checksumkind: CSK_MD5, checksum: "583a89b25a16f85ebbdf32f8d9f237ec")
!54 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_mutex_t", file: !8, line: 113, baseType: !55)
!55 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_mutex_t", file: !8, line: 78, size: 512, elements: !56)
!56 = !{!57, !58}
!57 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !55, file: !8, line: 79, baseType: !13, size: 64)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !55, file: !8, line: 80, baseType: !59, size: 448, offset: 64)
!59 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 448, elements: !60)
!60 = !{!61}
!61 = !DISubrange(count: 56)
!62 = !{i32 2, !"SDK Version", [2 x i32] [i32 15, i32 2]}
!63 = !{i32 7, !"Dwarf Version", i32 5}
!64 = !{i32 2, !"Debug Info Version", i32 3}
!65 = !{i32 8, !"PIC Level", i32 2}
!66 = !{i32 7, !"uwtable", i32 1}
!67 = !{i32 7, !"frame-pointer", i32 4}
!68 = !{!"Homebrew clang version 23.1.3"}
!69 = distinct !DISubprogram(name: "worker", scope: !3, file: !3, line: 16, type: !70, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !72)
!70 = !DISubroutineType(types: !71)
!71 = !{!22, !22}
!72 = !{}
!73 = !DILocalVariable(name: "arg", arg: 1, scope: !69, file: !3, line: 16, type: !22)
!74 = !DILocation(line: 16, column: 20, scope: !69)
!75 = !DILocation(line: 18, column: 5, scope: !69)
!76 = !DILocation(line: 19, column: 10, scope: !69)
!77 = !DILocation(line: 20, column: 5, scope: !69)
!78 = !DILocation(line: 21, column: 5, scope: !69)
!79 = distinct !DISubprogram(name: "cleaner", scope: !3, file: !3, line: 24, type: !70, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !72)
!80 = !DILocalVariable(name: "arg", arg: 1, scope: !79, file: !3, line: 24, type: !22)
!81 = !DILocation(line: 24, column: 21, scope: !79)
!82 = !DILocation(line: 26, column: 5, scope: !79)
!83 = !DILocation(line: 27, column: 9, scope: !84)
!84 = distinct !DILexicalBlock(scope: !79, file: !3, line: 27, column: 9)
!85 = !DILocalVariable(name: "status", scope: !86, file: !3, line: 29, type: !87)
!86 = distinct !DILexicalBlock(scope: !84, file: !3, line: 27, column: 15)
!87 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!88 = !DILocation(line: 29, column: 13, scope: !86)
!89 = !DILocation(line: 29, column: 35, scope: !86)
!90 = !DILocation(line: 29, column: 22, scope: !86)
!91 = !DILocation(line: 30, column: 16, scope: !86)
!92 = !DILocation(line: 30, column: 23, scope: !86)
!93 = !DILocation(line: 30, column: 9, scope: !86)
!94 = !DILocation(line: 31, column: 5, scope: !86)
!95 = !DILocation(line: 32, column: 5, scope: !79)
!96 = !DILocation(line: 33, column: 5, scope: !79)
!97 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 36, type: !98, scopeLine: 37, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !72)
!98 = !DISubroutineType(types: !99)
!99 = !{!87}
!100 = !DILocation(line: 39, column: 5, scope: !97)
!101 = !DILocalVariable(name: "cleaner_tid", scope: !97, file: !3, line: 40, type: !5)
!102 = !DILocation(line: 40, column: 15, scope: !97)
!103 = !DILocation(line: 41, column: 5, scope: !97)
!104 = !DILocation(line: 42, column: 5, scope: !97)
!105 = !DILocation(line: 43, column: 18, scope: !97)
!106 = !DILocation(line: 43, column: 5, scope: !97)
!107 = !DILocation(line: 44, column: 5, scope: !97)
