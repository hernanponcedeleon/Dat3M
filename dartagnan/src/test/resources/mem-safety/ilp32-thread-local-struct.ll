; ModuleID = 'benchmarks/mem-safety/ilp32-thread-local-struct.c'
source_filename = "benchmarks/mem-safety/ilp32-thread-local-struct.c"
target datalayout = "e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

%struct.S = type { i64, i32 }

@idx = dso_local global i32 11, align 4, !dbg !0
@s = dso_local thread_local global %struct.S zeroinitializer, align 4, !dbg !8

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @worker(ptr noundef %0) #0 !dbg !26 {
  %2 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !31, metadata !DIExpression()), !dbg !32
  %3 = call align 4 ptr @llvm.threadlocal.address.p0(ptr align 4 @s), !dbg !33
  %4 = load volatile i32, ptr @idx, align 4, !dbg !34
  %5 = getelementptr inbounds i8, ptr %3, i32 %4, !dbg !35
  store i8 1, ptr %5, align 1, !dbg !36
  ret ptr null, !dbg !37
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare nonnull ptr @llvm.threadlocal.address.p0(ptr nonnull) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !38 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !41, metadata !DIExpression()), !dbg !44
  %3 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @worker, ptr noundef null), !dbg !45
  %4 = load i32, ptr %2, align 4, !dbg !46
  %5 = call i32 @pthread_join(i32 noundef %4, ptr noundef null), !dbg !47
  ret i32 0, !dbg !48
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare i32 @pthread_join(i32 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!17, !18, !19, !20, !21, !22, !23, !24}
!llvm.ident = !{!25}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "idx", scope: !2, file: !3, line: 24, type: !16, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 17.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !7, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/mem-safety/ilp32-thread-local-struct.c", directory: ".", checksumkind: CSK_MD5, checksum: "1d7bc95256bb38b0ba1c5c83e358068d")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 32)
!6 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!7 = !{!0, !8}
!8 = !DIGlobalVariableExpression(var: !9, expr: !DIExpression())
!9 = distinct !DIGlobalVariable(name: "s", scope: !2, file: !3, line: 19, type: !10, isLocal: false, isDefinition: true)
!10 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "S", file: !3, line: 14, size: 96, elements: !11)
!11 = !{!12, !14}
!12 = !DIDerivedType(tag: DW_TAG_member, name: "b", scope: !10, file: !3, line: 15, baseType: !13, size: 64)
!13 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!14 = !DIDerivedType(tag: DW_TAG_member, name: "a", scope: !10, file: !3, line: 16, baseType: !15, size: 32, offset: 64)
!15 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!16 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !15)
!17 = !{i32 1, !"NumRegisterParameters", i32 0}
!18 = !{i32 7, !"Dwarf Version", i32 5}
!19 = !{i32 2, !"Debug Info Version", i32 3}
!20 = !{i32 1, !"wchar_size", i32 4}
!21 = !{i32 8, !"PIC Level", i32 2}
!22 = !{i32 7, !"PIE Level", i32 2}
!23 = !{i32 7, !"uwtable", i32 2}
!24 = !{i32 7, !"frame-pointer", i32 2}
!25 = !{!"Homebrew clang version 17.0.6"}
!26 = distinct !DISubprogram(name: "worker", scope: !3, file: !3, line: 27, type: !27, scopeLine: 27, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !30)
!27 = !DISubroutineType(types: !28)
!28 = !{!29, !29}
!29 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 32)
!30 = !{}
!31 = !DILocalVariable(name: "arg", arg: 1, scope: !26, file: !3, line: 27, type: !29)
!32 = !DILocation(line: 27, column: 20, scope: !26)
!33 = !DILocation(line: 28, column: 15, scope: !26)
!34 = !DILocation(line: 28, column: 18, scope: !26)
!35 = !DILocation(line: 28, column: 5, scope: !26)
!36 = !DILocation(line: 28, column: 23, scope: !26)
!37 = !DILocation(line: 29, column: 5, scope: !26)
!38 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 32, type: !39, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !30)
!39 = !DISubroutineType(types: !40)
!40 = !{!15}
!41 = !DILocalVariable(name: "t", scope: !38, file: !3, line: 33, type: !42)
!42 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !3, line: 10, baseType: !43)
!43 = !DIBasicType(name: "unsigned long", size: 32, encoding: DW_ATE_unsigned)
!44 = !DILocation(line: 33, column: 15, scope: !38)
!45 = !DILocation(line: 34, column: 5, scope: !38)
!46 = !DILocation(line: 35, column: 18, scope: !38)
!47 = !DILocation(line: 35, column: 5, scope: !38)
!48 = !DILocation(line: 36, column: 5, scope: !38)
