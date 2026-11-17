; ModuleID = 'pthread_mutex_errorcheck_f.c'
source_filename = "pthread_mutex_errorcheck_f.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

%struct._opaque_pthread_mutex_t = type { i64, [56 x i8] }
%struct._opaque_pthread_mutexattr_t = type { i64, [8 x i8] }

@initialized = global %struct._opaque_pthread_mutex_t { i64 850045857, [56 x i8] zeroinitializer }, align 8, !dbg !0
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !5
@.str = private unnamed_addr constant [29 x i8] c"pthread_mutex_errorcheck_f.c\00", align 1, !dbg !12
@.str.1 = private unnamed_addr constant [2 x i8] c"0\00", align 1, !dbg !17

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 !dbg !41 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_mutex_t, align 8
  %3 = alloca %struct._opaque_pthread_mutexattr_t, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !46, !DIExpression(), !47)
    #dbg_declare(ptr %3, !48, !DIExpression(), !59)
  %4 = call i32 @pthread_mutexattr_init(ptr noundef %3), !dbg !60
  %5 = call i32 @pthread_mutexattr_settype(ptr noundef %3, i32 noundef 1), !dbg !61
  %6 = call i32 @pthread_mutex_init(ptr noundef %2, ptr noundef %3), !dbg !62
  %7 = call i32 @pthread_mutex_lock(ptr noundef %2), !dbg !63
  %8 = call i32 @pthread_mutex_lock(ptr noundef %2), !dbg !64
  %9 = call i32 @pthread_mutex_lock(ptr noundef @initialized), !dbg !65
  %10 = call i32 @pthread_mutex_lock(ptr noundef @initialized), !dbg !66
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 24, ptr noundef @.str.1) #3, !dbg !67
  unreachable, !dbg !67
}

declare i32 @pthread_mutexattr_init(ptr noundef) #1

declare i32 @pthread_mutexattr_settype(ptr noundef, i32 noundef) #1

declare i32 @pthread_mutex_init(ptr noundef, ptr noundef) #1

declare i32 @pthread_mutex_lock(ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #1 = { "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #3 = { cold noreturn }

!llvm.module.flags = !{!34, !35, !36, !37, !38, !39}
!llvm.dbg.cu = !{!2}
!llvm.ident = !{!40}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "initialized", scope: !2, file: !3, line: 10, type: !22, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 23.1.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk", sdk: "MacOSX26.sdk")
!3 = !DIFile(filename: "pthread_mutex_errorcheck_f.c", directory: "/Users/hponcedeleon/git/Dat3M/benchmarks/miscellaneous", checksumkind: CSK_MD5, checksum: "8fda0fa51c6546066a3a517f0f99f139")
!4 = !{!0, !5, !12, !17}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(scope: null, file: !3, line: 24, type: !7, isLocal: true, isDefinition: true)
!7 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 40, elements: !10)
!8 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !9)
!9 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!10 = !{!11}
!11 = !DISubrange(count: 5)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(scope: null, file: !3, line: 24, type: !14, isLocal: true, isDefinition: true)
!14 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 232, elements: !15)
!15 = !{!16}
!16 = !DISubrange(count: 29)
!17 = !DIGlobalVariableExpression(var: !18, expr: !DIExpression())
!18 = distinct !DIGlobalVariable(scope: null, file: !3, line: 24, type: !19, isLocal: true, isDefinition: true)
!19 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 16, elements: !20)
!20 = !{!21}
!21 = !DISubrange(count: 2)
!22 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !23, line: 31, baseType: !24)
!23 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_mutex_t.h", directory: "", checksumkind: CSK_MD5, checksum: "583a89b25a16f85ebbdf32f8d9f237ec")
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_mutex_t", file: !25, line: 113, baseType: !26)
!25 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!26 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_mutex_t", file: !25, line: 78, size: 512, elements: !27)
!27 = !{!28, !30}
!28 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !26, file: !25, line: 79, baseType: !29, size: 64)
!29 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!30 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !26, file: !25, line: 80, baseType: !31, size: 448, offset: 64)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 448, elements: !32)
!32 = !{!33}
!33 = !DISubrange(count: 56)
!34 = !{i32 2, !"SDK Version", [2 x i32] [i32 26, i32 5]}
!35 = !{i32 7, !"Dwarf Version", i32 5}
!36 = !{i32 2, !"Debug Info Version", i32 3}
!37 = !{i32 8, !"PIC Level", i32 2}
!38 = !{i32 7, !"uwtable", i32 1}
!39 = !{i32 7, !"frame-pointer", i32 4}
!40 = !{!"Homebrew clang version 23.1.0"}
!41 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 13, type: !42, scopeLine: 14, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!42 = !DISubroutineType(types: !43)
!43 = !{!44}
!44 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!45 = !{}
!46 = !DILocalVariable(name: "mutex", scope: !41, file: !3, line: 15, type: !22)
!47 = !DILocation(line: 15, column: 21, scope: !41)
!48 = !DILocalVariable(name: "attr", scope: !41, file: !3, line: 16, type: !49)
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !50, line: 31, baseType: !51)
!50 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_mutexattr_t.h", directory: "", checksumkind: CSK_MD5, checksum: "785eb3f812f7ebee764058667d4b4693")
!51 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_mutexattr_t", file: !25, line: 114, baseType: !52)
!52 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_mutexattr_t", file: !25, line: 83, size: 128, elements: !53)
!53 = !{!54, !55}
!54 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !52, file: !25, line: 84, baseType: !29, size: 64)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !52, file: !25, line: 85, baseType: !56, size: 64, offset: 64)
!56 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 64, elements: !57)
!57 = !{!58}
!58 = !DISubrange(count: 8)
!59 = !DILocation(line: 16, column: 25, scope: !41)
!60 = !DILocation(line: 17, column: 5, scope: !41)
!61 = !DILocation(line: 18, column: 5, scope: !41)
!62 = !DILocation(line: 19, column: 5, scope: !41)
!63 = !DILocation(line: 20, column: 5, scope: !41)
!64 = !DILocation(line: 21, column: 5, scope: !41)
!65 = !DILocation(line: 22, column: 5, scope: !41)
!66 = !DILocation(line: 23, column: 5, scope: !41)
!67 = !DILocation(line: 24, column: 5, scope: !41)
