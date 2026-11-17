; ModuleID = 'pthread_mutex_recursive_static_f.c'
source_filename = "pthread_mutex_recursive_static_f.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

%struct._opaque_pthread_mutex_t = type { i64, [56 x i8] }

@recursive = global %struct._opaque_pthread_mutex_t { i64 850045858, [56 x i8] zeroinitializer }, align 8, !dbg !0
@normal = global %struct._opaque_pthread_mutex_t { i64 850045863, [56 x i8] zeroinitializer }, align 8, !dbg !5
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !20
@.str = private unnamed_addr constant [35 x i8] c"pthread_mutex_recursive_static_f.c\00", align 1, !dbg !26
@.str.1 = private unnamed_addr constant [2 x i8] c"0\00", align 1, !dbg !31

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 !dbg !43 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  %2 = call i32 @pthread_mutex_lock(ptr noundef @normal), !dbg !47
  %3 = call i32 @pthread_mutex_unlock(ptr noundef @normal), !dbg !48
  %4 = call i32 @pthread_mutex_lock(ptr noundef @recursive), !dbg !49
  %5 = call i32 @pthread_mutex_lock(ptr noundef @recursive), !dbg !50
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 20, ptr noundef @.str.1) #3, !dbg !51
  unreachable, !dbg !51
}

declare i32 @pthread_mutex_lock(ptr noundef) #1

declare i32 @pthread_mutex_unlock(ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #1 = { "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #3 = { cold noreturn }

!llvm.module.flags = !{!36, !37, !38, !39, !40, !41}
!llvm.dbg.cu = !{!2}
!llvm.ident = !{!42}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "recursive", scope: !2, file: !3, line: 10, type: !7, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 23.1.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk", sdk: "MacOSX26.sdk")
!3 = !DIFile(filename: "pthread_mutex_recursive_static_f.c", directory: "/Users/hponcedeleon/git/Dat3M/benchmarks/miscellaneous", checksumkind: CSK_MD5, checksum: "60a6255faa3e5e6c9e7ca87a05293011")
!4 = !{!0, !5, !20, !26, !31}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(name: "normal", scope: !2, file: !3, line: 12, type: !7, isLocal: false, isDefinition: true)
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !8, line: 31, baseType: !9)
!8 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_mutex_t.h", directory: "", checksumkind: CSK_MD5, checksum: "583a89b25a16f85ebbdf32f8d9f237ec")
!9 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_mutex_t", file: !10, line: 113, baseType: !11)
!10 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!11 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_mutex_t", file: !10, line: 78, size: 512, elements: !12)
!12 = !{!13, !15}
!13 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !11, file: !10, line: 79, baseType: !14, size: 64)
!14 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!15 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !11, file: !10, line: 80, baseType: !16, size: 448, offset: 64)
!16 = !DICompositeType(tag: DW_TAG_array_type, baseType: !17, size: 448, elements: !18)
!17 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!18 = !{!19}
!19 = !DISubrange(count: 56)
!20 = !DIGlobalVariableExpression(var: !21, expr: !DIExpression())
!21 = distinct !DIGlobalVariable(scope: null, file: !3, line: 20, type: !22, isLocal: true, isDefinition: true)
!22 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 40, elements: !24)
!23 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !17)
!24 = !{!25}
!25 = !DISubrange(count: 5)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(scope: null, file: !3, line: 20, type: !28, isLocal: true, isDefinition: true)
!28 = !DICompositeType(tag: DW_TAG_array_type, baseType: !17, size: 280, elements: !29)
!29 = !{!30}
!30 = !DISubrange(count: 35)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(scope: null, file: !3, line: 20, type: !33, isLocal: true, isDefinition: true)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !17, size: 16, elements: !34)
!34 = !{!35}
!35 = !DISubrange(count: 2)
!36 = !{i32 2, !"SDK Version", [2 x i32] [i32 26, i32 5]}
!37 = !{i32 7, !"Dwarf Version", i32 5}
!38 = !{i32 2, !"Debug Info Version", i32 3}
!39 = !{i32 8, !"PIC Level", i32 2}
!40 = !{i32 7, !"uwtable", i32 1}
!41 = !{i32 7, !"frame-pointer", i32 4}
!42 = !{!"Homebrew clang version 23.1.0"}
!43 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 14, type: !44, scopeLine: 15, spFlags: DISPFlagDefinition, unit: !2)
!44 = !DISubroutineType(types: !45)
!45 = !{!46}
!46 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!47 = !DILocation(line: 16, column: 5, scope: !43)
!48 = !DILocation(line: 17, column: 5, scope: !43)
!49 = !DILocation(line: 18, column: 5, scope: !43)
!50 = !DILocation(line: 19, column: 5, scope: !43)
!51 = !DILocation(line: 20, column: 5, scope: !43)
