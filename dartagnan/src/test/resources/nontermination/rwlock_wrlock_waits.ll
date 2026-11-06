; ModuleID = '/in/rwlock_wrlock_waits.c'
source_filename = "/in/rwlock_wrlock_waits.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_rwlock_t = type { %struct.__pthread_rwlock_arch_t }
%struct.__pthread_rwlock_arch_t = type { i32, i32, i32, i32, i32, i32, i32, i32, i8, [7 x i8], i64, i32 }

@rw = dso_local global %union.pthread_rwlock_t zeroinitializer, align 8, !dbg !0

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @reader(ptr noundef %0) #0 !dbg !51 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !55, metadata !DIExpression()), !dbg !56
  %3 = call i32 @pthread_rwlock_rdlock(ptr noundef @rw) #3, !dbg !57
  ret ptr null, !dbg !58
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare i32 @pthread_rwlock_rdlock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @writer(ptr noundef %0) #0 !dbg !59 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !60, metadata !DIExpression()), !dbg !61
  %3 = call i32 @pthread_rwlock_wrlock(ptr noundef @rw) #3, !dbg !62
  %4 = call i32 @pthread_rwlock_unlock(ptr noundef @rw) #3, !dbg !63
  ret ptr null, !dbg !64
}

; Function Attrs: nounwind
declare i32 @pthread_rwlock_wrlock(ptr noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_rwlock_unlock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !65 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  store i32 0, ptr %1, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !68, metadata !DIExpression()), !dbg !70
  call void @llvm.dbg.declare(metadata ptr %3, metadata !71, metadata !DIExpression()), !dbg !72
  %4 = call i32 @pthread_rwlock_init(ptr noundef @rw, ptr noundef null) #3, !dbg !73
  %5 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @reader, ptr noundef null) #3, !dbg !74
  %6 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @writer, ptr noundef null) #3, !dbg !75
  ret i32 0, !dbg !76
}

; Function Attrs: nounwind
declare i32 @pthread_rwlock_init(ptr noundef, ptr noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!43, !44, !45, !46, !47, !48, !49}
!llvm.ident = !{!50}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "rw", scope: !2, file: !7, line: 4, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 18.1.3 (1ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/in/rwlock_wrlock_waits.c", directory: "/work", checksumkind: CSK_MD5, checksum: "90e81f8ff7ce2fab17e7e2b3751c4e93")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0}
!7 = !DIFile(filename: "/in/rwlock_wrlock_waits.c", directory: "", checksumkind: CSK_MD5, checksum: "90e81f8ff7ce2fab17e7e2b3751c4e93")
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_rwlock_t", file: !9, line: 91, baseType: !10)
!9 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!10 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !9, line: 86, size: 448, elements: !11)
!11 = !{!12, !36, !41}
!12 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !10, file: !9, line: 88, baseType: !13, size: 448)
!13 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_rwlock_arch_t", file: !14, line: 23, size: 448, elements: !15)
!14 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_rwlock.h", directory: "", checksumkind: CSK_MD5, checksum: "c43c4f3db67914fc938807f222075238")
!15 = !{!16, !18, !19, !20, !21, !22, !23, !25, !26, !28, !33, !35}
!16 = !DIDerivedType(tag: DW_TAG_member, name: "__readers", scope: !13, file: !14, line: 25, baseType: !17, size: 32)
!17 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!18 = !DIDerivedType(tag: DW_TAG_member, name: "__writers", scope: !13, file: !14, line: 26, baseType: !17, size: 32, offset: 32)
!19 = !DIDerivedType(tag: DW_TAG_member, name: "__wrphase_futex", scope: !13, file: !14, line: 27, baseType: !17, size: 32, offset: 64)
!20 = !DIDerivedType(tag: DW_TAG_member, name: "__writers_futex", scope: !13, file: !14, line: 28, baseType: !17, size: 32, offset: 96)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "__pad3", scope: !13, file: !14, line: 29, baseType: !17, size: 32, offset: 128)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "__pad4", scope: !13, file: !14, line: 30, baseType: !17, size: 32, offset: 160)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "__cur_writer", scope: !13, file: !14, line: 32, baseType: !24, size: 32, offset: 192)
!24 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "__shared", scope: !13, file: !14, line: 33, baseType: !24, size: 32, offset: 224)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "__rwelision", scope: !13, file: !14, line: 34, baseType: !27, size: 8, offset: 256)
!27 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "__pad1", scope: !13, file: !14, line: 39, baseType: !29, size: 56, offset: 264)
!29 = !DICompositeType(tag: DW_TAG_array_type, baseType: !30, size: 56, elements: !31)
!30 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!31 = !{!32}
!32 = !DISubrange(count: 7)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "__pad2", scope: !13, file: !14, line: 42, baseType: !34, size: 64, offset: 320)
!34 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "__flags", scope: !13, file: !14, line: 45, baseType: !17, size: 32, offset: 384)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !10, file: !9, line: 89, baseType: !37, size: 448)
!37 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 448, elements: !39)
!38 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!39 = !{!40}
!40 = !DISubrange(count: 56)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !10, file: !9, line: 90, baseType: !42, size: 64)
!42 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!43 = !{i32 7, !"Dwarf Version", i32 5}
!44 = !{i32 2, !"Debug Info Version", i32 3}
!45 = !{i32 1, !"wchar_size", i32 4}
!46 = !{i32 8, !"PIC Level", i32 2}
!47 = !{i32 7, !"PIE Level", i32 2}
!48 = !{i32 7, !"uwtable", i32 2}
!49 = !{i32 7, !"frame-pointer", i32 2}
!50 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!51 = distinct !DISubprogram(name: "reader", scope: !7, file: !7, line: 6, type: !52, scopeLine: 7, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !54)
!52 = !DISubroutineType(types: !53)
!53 = !{!5, !5}
!54 = !{}
!55 = !DILocalVariable(name: "unused", arg: 1, scope: !51, file: !7, line: 6, type: !5)
!56 = !DILocation(line: 6, column: 20, scope: !51)
!57 = !DILocation(line: 8, column: 5, scope: !51)
!58 = !DILocation(line: 9, column: 5, scope: !51)
!59 = distinct !DISubprogram(name: "writer", scope: !7, file: !7, line: 12, type: !52, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !54)
!60 = !DILocalVariable(name: "unused", arg: 1, scope: !59, file: !7, line: 12, type: !5)
!61 = !DILocation(line: 12, column: 20, scope: !59)
!62 = !DILocation(line: 14, column: 5, scope: !59)
!63 = !DILocation(line: 15, column: 5, scope: !59)
!64 = !DILocation(line: 16, column: 5, scope: !59)
!65 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 19, type: !66, scopeLine: 20, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !54)
!66 = !DISubroutineType(types: !67)
!67 = !{!24}
!68 = !DILocalVariable(name: "t1", scope: !65, file: !7, line: 21, type: !69)
!69 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !9, line: 27, baseType: !34)
!70 = !DILocation(line: 21, column: 15, scope: !65)
!71 = !DILocalVariable(name: "t2", scope: !65, file: !7, line: 21, type: !69)
!72 = !DILocation(line: 21, column: 19, scope: !65)
!73 = !DILocation(line: 22, column: 5, scope: !65)
!74 = !DILocation(line: 23, column: 5, scope: !65)
!75 = !DILocation(line: 24, column: 5, scope: !65)
!76 = !DILocation(line: 25, column: 5, scope: !65)
