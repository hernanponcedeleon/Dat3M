; ModuleID = '/in/rwlock_terminates.c'
source_filename = "/in/rwlock_terminates.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_rwlock_t = type { %struct.__pthread_rwlock_arch_t }
%struct.__pthread_rwlock_arch_t = type { i32, i32, i32, i32, i32, i32, i32, i32, i8, [7 x i8], i64, i32 }

@rw = dso_local global %union.pthread_rwlock_t zeroinitializer, align 8, !dbg !0
@value = dso_local global i32 0, align 4, !dbg !7

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @reader(ptr noundef %0) #0 !dbg !53 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !57, metadata !DIExpression()), !dbg !58
  %3 = call i32 @pthread_rwlock_rdlock(ptr noundef @rw) #3, !dbg !59
  %4 = load i32, ptr @value, align 4, !dbg !60
  %5 = call i32 @pthread_rwlock_unlock(ptr noundef @rw) #3, !dbg !61
  ret ptr null, !dbg !62
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare i32 @pthread_rwlock_rdlock(ptr noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_rwlock_unlock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @writer(ptr noundef %0) #0 !dbg !63 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !64, metadata !DIExpression()), !dbg !65
  %3 = call i32 @pthread_rwlock_wrlock(ptr noundef @rw) #3, !dbg !66
  store i32 1, ptr @value, align 4, !dbg !67
  %4 = call i32 @pthread_rwlock_unlock(ptr noundef @rw) #3, !dbg !68
  ret ptr null, !dbg !69
}

; Function Attrs: nounwind
declare i32 @pthread_rwlock_wrlock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !70 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store i32 0, ptr %1, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !73, metadata !DIExpression()), !dbg !75
  call void @llvm.dbg.declare(metadata ptr %3, metadata !76, metadata !DIExpression()), !dbg !77
  call void @llvm.dbg.declare(metadata ptr %4, metadata !78, metadata !DIExpression()), !dbg !79
  %5 = call i32 @pthread_rwlock_init(ptr noundef @rw, ptr noundef null) #3, !dbg !80
  %6 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @reader, ptr noundef null) #3, !dbg !81
  %7 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @reader, ptr noundef null) #3, !dbg !82
  %8 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @writer, ptr noundef null) #3, !dbg !83
  ret i32 0, !dbg !84
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
!llvm.module.flags = !{!45, !46, !47, !48, !49, !50, !51}
!llvm.ident = !{!52}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "rw", scope: !2, file: !9, line: 4, type: !11, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 18.1.3 (1ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/in/rwlock_terminates.c", directory: "/work", checksumkind: CSK_MD5, checksum: "268c9baa302d9f1b19b2dd9f64042880")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "value", scope: !2, file: !9, line: 5, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "/in/rwlock_terminates.c", directory: "", checksumkind: CSK_MD5, checksum: "268c9baa302d9f1b19b2dd9f64042880")
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_rwlock_t", file: !12, line: 91, baseType: !13)
!12 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!13 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !12, line: 86, size: 448, elements: !14)
!14 = !{!15, !38, !43}
!15 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !13, file: !12, line: 88, baseType: !16, size: 448)
!16 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_rwlock_arch_t", file: !17, line: 23, size: 448, elements: !18)
!17 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_rwlock.h", directory: "", checksumkind: CSK_MD5, checksum: "c43c4f3db67914fc938807f222075238")
!18 = !{!19, !21, !22, !23, !24, !25, !26, !27, !28, !30, !35, !37}
!19 = !DIDerivedType(tag: DW_TAG_member, name: "__readers", scope: !16, file: !17, line: 25, baseType: !20, size: 32)
!20 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "__writers", scope: !16, file: !17, line: 26, baseType: !20, size: 32, offset: 32)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "__wrphase_futex", scope: !16, file: !17, line: 27, baseType: !20, size: 32, offset: 64)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "__writers_futex", scope: !16, file: !17, line: 28, baseType: !20, size: 32, offset: 96)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "__pad3", scope: !16, file: !17, line: 29, baseType: !20, size: 32, offset: 128)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "__pad4", scope: !16, file: !17, line: 30, baseType: !20, size: 32, offset: 160)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "__cur_writer", scope: !16, file: !17, line: 32, baseType: !10, size: 32, offset: 192)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "__shared", scope: !16, file: !17, line: 33, baseType: !10, size: 32, offset: 224)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "__rwelision", scope: !16, file: !17, line: 34, baseType: !29, size: 8, offset: 256)
!29 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!30 = !DIDerivedType(tag: DW_TAG_member, name: "__pad1", scope: !16, file: !17, line: 39, baseType: !31, size: 56, offset: 264)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !32, size: 56, elements: !33)
!32 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!33 = !{!34}
!34 = !DISubrange(count: 7)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "__pad2", scope: !16, file: !17, line: 42, baseType: !36, size: 64, offset: 320)
!36 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "__flags", scope: !16, file: !17, line: 45, baseType: !20, size: 32, offset: 384)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !13, file: !12, line: 89, baseType: !39, size: 448)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !40, size: 448, elements: !41)
!40 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!41 = !{!42}
!42 = !DISubrange(count: 56)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !13, file: !12, line: 90, baseType: !44, size: 64)
!44 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!45 = !{i32 7, !"Dwarf Version", i32 5}
!46 = !{i32 2, !"Debug Info Version", i32 3}
!47 = !{i32 1, !"wchar_size", i32 4}
!48 = !{i32 8, !"PIC Level", i32 2}
!49 = !{i32 7, !"PIE Level", i32 2}
!50 = !{i32 7, !"uwtable", i32 2}
!51 = !{i32 7, !"frame-pointer", i32 2}
!52 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!53 = distinct !DISubprogram(name: "reader", scope: !9, file: !9, line: 7, type: !54, scopeLine: 8, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !56)
!54 = !DISubroutineType(types: !55)
!55 = !{!5, !5}
!56 = !{}
!57 = !DILocalVariable(name: "unused", arg: 1, scope: !53, file: !9, line: 7, type: !5)
!58 = !DILocation(line: 7, column: 20, scope: !53)
!59 = !DILocation(line: 9, column: 5, scope: !53)
!60 = !DILocation(line: 10, column: 11, scope: !53)
!61 = !DILocation(line: 11, column: 5, scope: !53)
!62 = !DILocation(line: 12, column: 5, scope: !53)
!63 = distinct !DISubprogram(name: "writer", scope: !9, file: !9, line: 15, type: !54, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !56)
!64 = !DILocalVariable(name: "unused", arg: 1, scope: !63, file: !9, line: 15, type: !5)
!65 = !DILocation(line: 15, column: 20, scope: !63)
!66 = !DILocation(line: 17, column: 5, scope: !63)
!67 = !DILocation(line: 18, column: 11, scope: !63)
!68 = !DILocation(line: 19, column: 5, scope: !63)
!69 = !DILocation(line: 20, column: 5, scope: !63)
!70 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 23, type: !71, scopeLine: 24, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !56)
!71 = !DISubroutineType(types: !72)
!72 = !{!10}
!73 = !DILocalVariable(name: "t1", scope: !70, file: !9, line: 25, type: !74)
!74 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !12, line: 27, baseType: !36)
!75 = !DILocation(line: 25, column: 15, scope: !70)
!76 = !DILocalVariable(name: "t2", scope: !70, file: !9, line: 25, type: !74)
!77 = !DILocation(line: 25, column: 19, scope: !70)
!78 = !DILocalVariable(name: "t3", scope: !70, file: !9, line: 25, type: !74)
!79 = !DILocation(line: 25, column: 23, scope: !70)
!80 = !DILocation(line: 26, column: 5, scope: !70)
!81 = !DILocation(line: 27, column: 5, scope: !70)
!82 = !DILocation(line: 28, column: 5, scope: !70)
!83 = !DILocation(line: 29, column: 5, scope: !70)
!84 = !DILocation(line: 30, column: 5, scope: !70)
