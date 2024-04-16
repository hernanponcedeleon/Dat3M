; ModuleID = '/home/drc/git/Dat3M/output/ttaslock.ll'
source_filename = "/home/drc/git/libvsync/test/spinlock/ttaslock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.ttaslock_s = type { %struct.vatomic32_s }
%struct.vatomic32_s = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_cs_x = internal global i32 0, align 4, !dbg !0
@g_cs_y = internal global i32 0, align 4, !dbg !31
@.str = private unnamed_addr constant [17 x i8] c"g_cs_x == g_cs_y\00", align 1
@.str.1 = private unnamed_addr constant [34 x i8] c"./include/test/boilerplate/lock.h\00", align 1
@__PRETTY_FUNCTION__.check = private unnamed_addr constant [17 x i8] c"void check(void)\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"g_cs_x == (3 + 0 + 0)\00", align 1
@lock = dso_local global %struct.ttaslock_s zeroinitializer, align 4, !dbg !18

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !42 {
  ret void, !dbg !46
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !47 {
  ret void, !dbg !48
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !49 {
  ret void, !dbg !50
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @cs() #0 !dbg !51 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !52
  %2 = add i32 %1, 1, !dbg !52
  store i32 %2, i32* @g_cs_x, align 4, !dbg !52
  %3 = load i32, i32* @g_cs_y, align 4, !dbg !53
  %4 = add i32 %3, 1, !dbg !53
  store i32 %4, i32* @g_cs_y, align 4, !dbg !53
  ret void, !dbg !54
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @check() #0 !dbg !55 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !56
  %2 = load i32, i32* @g_cs_y, align 4, !dbg !56
  %3 = icmp eq i32 %1, %2, !dbg !56
  br i1 %3, label %5, label %4, !dbg !59

4:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([34 x i8], [34 x i8]* @.str.1, i64 0, i64 0), i32 noundef 99, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !56
  unreachable, !dbg !56

5:                                                ; preds = %0
  %6 = icmp eq i32 %1, 3, !dbg !60
  br i1 %6, label %8, label %7, !dbg !63

7:                                                ; preds = %5
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([34 x i8], [34 x i8]* @.str.1, i64 0, i64 0), i32 noundef 100, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !60
  unreachable, !dbg !60

8:                                                ; preds = %5
  ret void, !dbg !64
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !65 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !69, metadata !DIExpression()), !dbg !75
  call void @init(), !dbg !76
  call void @llvm.dbg.value(metadata i64 0, metadata !77, metadata !DIExpression()), !dbg !79
  call void @llvm.dbg.value(metadata i64 0, metadata !77, metadata !DIExpression()), !dbg !79
  %2 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !80
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef null) #6, !dbg !83
  call void @llvm.dbg.value(metadata i64 1, metadata !77, metadata !DIExpression()), !dbg !79
  call void @llvm.dbg.value(metadata i64 1, metadata !77, metadata !DIExpression()), !dbg !79
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !80
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef inttoptr (i64 1 to i8*)) #6, !dbg !83
  call void @llvm.dbg.value(metadata i64 2, metadata !77, metadata !DIExpression()), !dbg !79
  call void @llvm.dbg.value(metadata i64 2, metadata !77, metadata !DIExpression()), !dbg !79
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !80
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef inttoptr (i64 2 to i8*)) #6, !dbg !83
  call void @llvm.dbg.value(metadata i64 3, metadata !77, metadata !DIExpression()), !dbg !79
  call void @llvm.dbg.value(metadata i64 3, metadata !77, metadata !DIExpression()), !dbg !79
  call void @post(), !dbg !84
  call void @llvm.dbg.value(metadata i64 0, metadata !85, metadata !DIExpression()), !dbg !87
  call void @llvm.dbg.value(metadata i64 0, metadata !85, metadata !DIExpression()), !dbg !87
  %8 = load i64, i64* %2, align 8, !dbg !88
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !91
  call void @llvm.dbg.value(metadata i64 1, metadata !85, metadata !DIExpression()), !dbg !87
  call void @llvm.dbg.value(metadata i64 1, metadata !85, metadata !DIExpression()), !dbg !87
  %10 = load i64, i64* %4, align 8, !dbg !88
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !91
  call void @llvm.dbg.value(metadata i64 2, metadata !85, metadata !DIExpression()), !dbg !87
  call void @llvm.dbg.value(metadata i64 2, metadata !85, metadata !DIExpression()), !dbg !87
  %12 = load i64, i64* %6, align 8, !dbg !88
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !91
  call void @llvm.dbg.value(metadata i64 3, metadata !85, metadata !DIExpression()), !dbg !87
  call void @llvm.dbg.value(metadata i64 3, metadata !85, metadata !DIExpression()), !dbg !87
  call void @check(), !dbg !92
  call void @fini(), !dbg !93
  ret i32 0, !dbg !94
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @run(i8* noundef %0) #0 !dbg !95 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !98, metadata !DIExpression()), !dbg !99
  %2 = ptrtoint i8* %0 to i64, !dbg !100
  %3 = trunc i64 %2 to i32, !dbg !100
  call void @llvm.dbg.value(metadata i32 %3, metadata !101, metadata !DIExpression()), !dbg !99
  call void @verification_loop_bound(i32 noundef 2), !dbg !102
  call void @llvm.dbg.value(metadata i32 0, metadata !103, metadata !DIExpression()), !dbg !105
  br label %4, !dbg !106

4:                                                ; preds = %.critedge7, %1
  %.02 = phi i32 [ 0, %1 ], [ %18, %.critedge7 ], !dbg !105
  call void @llvm.dbg.value(metadata i32 %.02, metadata !103, metadata !DIExpression()), !dbg !105
  switch i32 %.02, label %.critedge5 [
    i32 0, label %.critedge
    i32 1, label %5
  ], !dbg !107

5:                                                ; preds = %4
  %6 = add i32 %3, 1, !dbg !109
  %7 = icmp ult i32 %6, 1, !dbg !109
  br i1 %7, label %.critedge, label %.critedge5, !dbg !110

.critedge:                                        ; preds = %4, %5
  call void @verification_loop_bound(i32 noundef 2), !dbg !111
  call void @llvm.dbg.value(metadata i32 0, metadata !113, metadata !DIExpression()), !dbg !115
  br label %8, !dbg !116

8:                                                ; preds = %.critedge3, %.critedge
  %.01 = phi i32 [ 0, %.critedge ], [ %12, %.critedge3 ], !dbg !115
  call void @llvm.dbg.value(metadata i32 %.01, metadata !113, metadata !DIExpression()), !dbg !115
  switch i32 %.01, label %.critedge6 [
    i32 0, label %.critedge3
    i32 1, label %9
  ], !dbg !117

9:                                                ; preds = %8
  %10 = add i32 %3, 1, !dbg !119
  %11 = icmp ult i32 %10, 1, !dbg !119
  br i1 %11, label %.critedge3, label %.critedge6, !dbg !120

.critedge3:                                       ; preds = %8, %9
  call void @acquire(i32 noundef %3), !dbg !121
  call void @cs(), !dbg !123
  %12 = add nuw nsw i32 %.01, 1, !dbg !124
  call void @llvm.dbg.value(metadata i32 %12, metadata !113, metadata !DIExpression()), !dbg !115
  br label %8, !dbg !125, !llvm.loop !126

.critedge6:                                       ; preds = %8, %9
  call void @verification_loop_bound(i32 noundef 2), !dbg !129
  call void @llvm.dbg.value(metadata i32 0, metadata !130, metadata !DIExpression()), !dbg !132
  br label %13, !dbg !133

13:                                               ; preds = %.critedge4, %.critedge6
  %.0 = phi i32 [ 0, %.critedge6 ], [ %17, %.critedge4 ], !dbg !132
  call void @llvm.dbg.value(metadata i32 %.0, metadata !130, metadata !DIExpression()), !dbg !132
  switch i32 %.0, label %.critedge7 [
    i32 0, label %.critedge4
    i32 1, label %14
  ], !dbg !134

14:                                               ; preds = %13
  %15 = add i32 %3, 1, !dbg !136
  %16 = icmp ult i32 %15, 1, !dbg !136
  br i1 %16, label %.critedge4, label %.critedge7, !dbg !137

.critedge4:                                       ; preds = %13, %14
  call void @release(i32 noundef %3), !dbg !138
  %17 = add nuw nsw i32 %.0, 1, !dbg !140
  call void @llvm.dbg.value(metadata i32 %17, metadata !130, metadata !DIExpression()), !dbg !132
  br label %13, !dbg !141, !llvm.loop !142

.critedge7:                                       ; preds = %13, %14
  %18 = add nuw nsw i32 %.02, 1, !dbg !144
  call void @llvm.dbg.value(metadata i32 %18, metadata !103, metadata !DIExpression()), !dbg !105
  br label %4, !dbg !145, !llvm.loop !146

.critedge5:                                       ; preds = %4, %5
  ret i8* null, !dbg !148
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @acquire(i32 noundef %0) #0 !dbg !149 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !152, metadata !DIExpression()), !dbg !153
  call void @ttaslock_acquire(%struct.ttaslock_s* noundef @lock), !dbg !154
  ret void, !dbg !155
}

; Function Attrs: noinline nounwind uwtable
define internal void @ttaslock_acquire(%struct.ttaslock_s* noundef %0) #0 !dbg !156 {
  call void @llvm.dbg.value(metadata %struct.ttaslock_s* %0, metadata !160, metadata !DIExpression()), !dbg !161
  br label %2, !dbg !162

2:                                                ; preds = %2, %1
  %3 = getelementptr inbounds %struct.ttaslock_s, %struct.ttaslock_s* %0, i32 0, i32 0, !dbg !163
  %4 = call i32 @vatomic32_await_eq_rlx(%struct.vatomic32_s* noundef %3, i32 noundef 0), !dbg !165
  %5 = call i32 @vatomic32_xchg_acq(%struct.vatomic32_s* noundef %3, i32 noundef 1), !dbg !166
  %6 = icmp ne i32 %5, 0, !dbg !166
  br i1 %6, label %2, label %7, !dbg !168, !llvm.loop !169

7:                                                ; preds = %2
  ret void, !dbg !171
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @release(i32 noundef %0) #0 !dbg !173 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !174, metadata !DIExpression()), !dbg !175
  call void @ttaslock_release(%struct.ttaslock_s* noundef @lock), !dbg !176
  ret void, !dbg !177
}

; Function Attrs: noinline nounwind uwtable
define internal void @ttaslock_release(%struct.ttaslock_s* noundef %0) #0 !dbg !178 {
  call void @llvm.dbg.value(metadata %struct.ttaslock_s* %0, metadata !179, metadata !DIExpression()), !dbg !180
  %2 = getelementptr inbounds %struct.ttaslock_s, %struct.ttaslock_s* %0, i32 0, i32 0, !dbg !181
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %2, i32 noundef 0), !dbg !182
  ret void, !dbg !183
}

; Function Attrs: noinline nounwind uwtable
define internal void @verification_loop_bound(i32 noundef %0) #0 !dbg !184 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !186, metadata !DIExpression()), !dbg !187
  ret void, !dbg !188
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_eq_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !189 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !194, metadata !DIExpression()), !dbg !195
  call void @llvm.dbg.value(metadata i32 %1, metadata !196, metadata !DIExpression()), !dbg !195
  call void @llvm.dbg.value(metadata i32 %1, metadata !197, metadata !DIExpression()), !dbg !195
  call void @llvm.dbg.value(metadata i32 0, metadata !198, metadata !DIExpression()), !dbg !195
  br label %3, !dbg !199

3:                                                ; preds = %3, %2
  %.0 = phi i32 [ %1, %2 ], [ %4, %3 ], !dbg !195
  call void @llvm.dbg.value(metadata i32 %.0, metadata !197, metadata !DIExpression()), !dbg !195
  %4 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0), !dbg !199
  call void @llvm.dbg.value(metadata i32 %4, metadata !198, metadata !DIExpression()), !dbg !195
  %5 = icmp ne i32 %4, %1, !dbg !199
  br i1 %5, label %3, label %6, !dbg !199, !llvm.loop !200

6:                                                ; preds = %3
  ret i32 %.0, !dbg !202
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_xchg_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !203 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !205, metadata !DIExpression()), !dbg !206
  call void @llvm.dbg.value(metadata i32 %1, metadata !207, metadata !DIExpression()), !dbg !206
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !208, !srcloc !209
  %3 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !210
  %4 = atomicrmw xchg i32* %3, i32 %1 acquire, align 4, !dbg !211
  call void @llvm.dbg.value(metadata i32 %4, metadata !212, metadata !DIExpression()), !dbg !206
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !213, !srcloc !214
  ret i32 %4, !dbg !215
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !216 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !219, metadata !DIExpression()), !dbg !220
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !221, !srcloc !222
  %2 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !223
  %3 = load atomic i32, i32* %2 monotonic, align 4, !dbg !224
  call void @llvm.dbg.value(metadata i32 %3, metadata !225, metadata !DIExpression()), !dbg !220
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !226, !srcloc !227
  ret i32 %3, !dbg !228
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !229 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !232, metadata !DIExpression()), !dbg !233
  call void @llvm.dbg.value(metadata i32 %1, metadata !234, metadata !DIExpression()), !dbg !233
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !235, !srcloc !236
  %3 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !237
  store atomic i32 %1, i32* %3 release, align 4, !dbg !238
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !239, !srcloc !240
  ret void, !dbg !241
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!34, !35, !36, !37, !38, !39, !40}
!llvm.ident = !{!41}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !33, line: 87, type: !11, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/drc/git/libvsync/test/spinlock/ttaslock.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "1b791379c07284f97e96a8cbdfc1ce38")
!4 = !{!5, !6, !11}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuintptr_t", file: !7, line: 36, baseType: !8)
!7 = !DIFile(filename: "./include/vsync/vtypes.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "6ac6784bf37e03e28013e7eed706797e")
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !9, line: 90, baseType: !10)
!9 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a48e64edacc5b19f56c99745232c963c")
!10 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!11 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !7, line: 34, baseType: !12)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !13, line: 26, baseType: !14)
!13 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!14 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !15, line: 42, baseType: !16)
!15 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!16 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!17 = !{!18, !0, !31}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !20, line: 8, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "test/spinlock/ttaslock.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "1b791379c07284f97e96a8cbdfc1ce38")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "ttaslock_t", file: !22, line: 24, baseType: !23)
!22 = !DIFile(filename: "./include/vsync/spinlock/ttaslock.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "5905941ef861b172fa64b088b3382019")
!23 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ttaslock_s", file: !22, line: 22, size: 32, elements: !24)
!24 = !{!25}
!25 = !DIDerivedType(tag: DW_TAG_member, name: "state", scope: !23, file: !22, line: 23, baseType: !26, size: 32, align: 32)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !27, line: 62, baseType: !28)
!27 = !DIFile(filename: "./include/vsync/atomic/core.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "1cc0657a82f0605ef67642f178a77e1c")
!28 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !27, line: 60, size: 32, align: 32, elements: !29)
!29 = !{!30}
!30 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !28, file: !27, line: 61, baseType: !11, size: 32)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(name: "g_cs_y", scope: !2, file: !33, line: 88, type: !11, isLocal: true, isDefinition: true)
!33 = !DIFile(filename: "./include/test/boilerplate/lock.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "c9c29de1465ea379ec6432998a180648")
!34 = !{i32 7, !"Dwarf Version", i32 5}
!35 = !{i32 2, !"Debug Info Version", i32 3}
!36 = !{i32 1, !"wchar_size", i32 4}
!37 = !{i32 7, !"PIC Level", i32 2}
!38 = !{i32 7, !"PIE Level", i32 2}
!39 = !{i32 7, !"uwtable", i32 1}
!40 = !{i32 7, !"frame-pointer", i32 2}
!41 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!42 = distinct !DISubprogram(name: "init", scope: !33, file: !33, line: 55, type: !43, scopeLine: 56, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!43 = !DISubroutineType(types: !44)
!44 = !{null}
!45 = !{}
!46 = !DILocation(line: 57, column: 1, scope: !42)
!47 = distinct !DISubprogram(name: "post", scope: !33, file: !33, line: 64, type: !43, scopeLine: 65, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!48 = !DILocation(line: 66, column: 1, scope: !47)
!49 = distinct !DISubprogram(name: "fini", scope: !33, file: !33, line: 73, type: !43, scopeLine: 74, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!50 = !DILocation(line: 75, column: 1, scope: !49)
!51 = distinct !DISubprogram(name: "cs", scope: !33, file: !33, line: 91, type: !43, scopeLine: 92, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!52 = !DILocation(line: 93, column: 8, scope: !51)
!53 = !DILocation(line: 94, column: 8, scope: !51)
!54 = !DILocation(line: 95, column: 1, scope: !51)
!55 = distinct !DISubprogram(name: "check", scope: !33, file: !33, line: 97, type: !43, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!56 = !DILocation(line: 99, column: 2, scope: !57)
!57 = distinct !DILexicalBlock(scope: !58, file: !33, line: 99, column: 2)
!58 = distinct !DILexicalBlock(scope: !55, file: !33, line: 99, column: 2)
!59 = !DILocation(line: 99, column: 2, scope: !58)
!60 = !DILocation(line: 100, column: 2, scope: !61)
!61 = distinct !DILexicalBlock(scope: !62, file: !33, line: 100, column: 2)
!62 = distinct !DILexicalBlock(scope: !55, file: !33, line: 100, column: 2)
!63 = !DILocation(line: 100, column: 2, scope: !62)
!64 = !DILocation(line: 101, column: 1, scope: !55)
!65 = distinct !DISubprogram(name: "main", scope: !33, file: !33, line: 136, type: !66, scopeLine: 137, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!66 = !DISubroutineType(types: !67)
!67 = !{!68}
!68 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!69 = !DILocalVariable(name: "t", scope: !65, file: !33, line: 138, type: !70)
!70 = !DICompositeType(tag: DW_TAG_array_type, baseType: !71, size: 192, elements: !73)
!71 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !72, line: 27, baseType: !10)
!72 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!73 = !{!74}
!74 = !DISubrange(count: 3)
!75 = !DILocation(line: 138, column: 12, scope: !65)
!76 = !DILocation(line: 146, column: 2, scope: !65)
!77 = !DILocalVariable(name: "i", scope: !78, file: !33, line: 148, type: !6)
!78 = distinct !DILexicalBlock(scope: !65, file: !33, line: 148, column: 2)
!79 = !DILocation(line: 0, scope: !78)
!80 = !DILocation(line: 149, column: 25, scope: !81)
!81 = distinct !DILexicalBlock(scope: !82, file: !33, line: 148, column: 44)
!82 = distinct !DILexicalBlock(scope: !78, file: !33, line: 148, column: 2)
!83 = !DILocation(line: 149, column: 9, scope: !81)
!84 = !DILocation(line: 152, column: 2, scope: !65)
!85 = !DILocalVariable(name: "i", scope: !86, file: !33, line: 154, type: !6)
!86 = distinct !DILexicalBlock(scope: !65, file: !33, line: 154, column: 2)
!87 = !DILocation(line: 0, scope: !86)
!88 = !DILocation(line: 155, column: 22, scope: !89)
!89 = distinct !DILexicalBlock(scope: !90, file: !33, line: 154, column: 44)
!90 = distinct !DILexicalBlock(scope: !86, file: !33, line: 154, column: 2)
!91 = !DILocation(line: 155, column: 9, scope: !89)
!92 = !DILocation(line: 163, column: 2, scope: !65)
!93 = !DILocation(line: 164, column: 2, scope: !65)
!94 = !DILocation(line: 166, column: 2, scope: !65)
!95 = distinct !DISubprogram(name: "run", scope: !33, file: !33, line: 111, type: !96, scopeLine: 112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!96 = !DISubroutineType(types: !97)
!97 = !{!5, !5}
!98 = !DILocalVariable(name: "arg", arg: 1, scope: !95, file: !33, line: 111, type: !5)
!99 = !DILocation(line: 0, scope: !95)
!100 = !DILocation(line: 113, column: 18, scope: !95)
!101 = !DILocalVariable(name: "tid", scope: !95, file: !33, line: 113, type: !11)
!102 = !DILocation(line: 117, column: 2, scope: !95)
!103 = !DILocalVariable(name: "i", scope: !104, file: !33, line: 118, type: !68)
!104 = distinct !DILexicalBlock(scope: !95, file: !33, line: 118, column: 2)
!105 = !DILocation(line: 0, scope: !104)
!106 = !DILocation(line: 118, column: 7, scope: !104)
!107 = !DILocation(line: 118, column: 25, scope: !108)
!108 = distinct !DILexicalBlock(scope: !104, file: !33, line: 118, column: 2)
!109 = !DILocation(line: 118, column: 28, scope: !108)
!110 = !DILocation(line: 118, column: 2, scope: !104)
!111 = !DILocation(line: 122, column: 3, scope: !112)
!112 = distinct !DILexicalBlock(scope: !108, file: !33, line: 118, column: 60)
!113 = !DILocalVariable(name: "j", scope: !114, file: !33, line: 123, type: !68)
!114 = distinct !DILexicalBlock(scope: !112, file: !33, line: 123, column: 3)
!115 = !DILocation(line: 0, scope: !114)
!116 = !DILocation(line: 123, column: 8, scope: !114)
!117 = !DILocation(line: 123, column: 26, scope: !118)
!118 = distinct !DILexicalBlock(scope: !114, file: !33, line: 123, column: 3)
!119 = !DILocation(line: 123, column: 29, scope: !118)
!120 = !DILocation(line: 123, column: 3, scope: !114)
!121 = !DILocation(line: 124, column: 4, scope: !122)
!122 = distinct !DILexicalBlock(scope: !118, file: !33, line: 123, column: 61)
!123 = !DILocation(line: 125, column: 4, scope: !122)
!124 = !DILocation(line: 123, column: 57, scope: !118)
!125 = !DILocation(line: 123, column: 3, scope: !118)
!126 = distinct !{!126, !120, !127, !128}
!127 = !DILocation(line: 126, column: 3, scope: !114)
!128 = !{!"llvm.loop.mustprogress"}
!129 = !DILocation(line: 127, column: 3, scope: !112)
!130 = !DILocalVariable(name: "j", scope: !131, file: !33, line: 128, type: !68)
!131 = distinct !DILexicalBlock(scope: !112, file: !33, line: 128, column: 3)
!132 = !DILocation(line: 0, scope: !131)
!133 = !DILocation(line: 128, column: 8, scope: !131)
!134 = !DILocation(line: 128, column: 26, scope: !135)
!135 = distinct !DILexicalBlock(scope: !131, file: !33, line: 128, column: 3)
!136 = !DILocation(line: 128, column: 29, scope: !135)
!137 = !DILocation(line: 128, column: 3, scope: !131)
!138 = !DILocation(line: 129, column: 4, scope: !139)
!139 = distinct !DILexicalBlock(scope: !135, file: !33, line: 128, column: 61)
!140 = !DILocation(line: 128, column: 57, scope: !135)
!141 = !DILocation(line: 128, column: 3, scope: !135)
!142 = distinct !{!142, !137, !143, !128}
!143 = !DILocation(line: 130, column: 3, scope: !131)
!144 = !DILocation(line: 118, column: 56, scope: !108)
!145 = !DILocation(line: 118, column: 2, scope: !108)
!146 = distinct !{!146, !110, !147, !128}
!147 = !DILocation(line: 131, column: 2, scope: !104)
!148 = !DILocation(line: 132, column: 2, scope: !95)
!149 = distinct !DISubprogram(name: "acquire", scope: !20, file: !20, line: 11, type: !150, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!150 = !DISubroutineType(types: !151)
!151 = !{null, !11}
!152 = !DILocalVariable(name: "tid", arg: 1, scope: !149, file: !20, line: 11, type: !11)
!153 = !DILocation(line: 0, scope: !149)
!154 = !DILocation(line: 14, column: 2, scope: !149)
!155 = !DILocation(line: 15, column: 1, scope: !149)
!156 = distinct !DISubprogram(name: "ttaslock_acquire", scope: !22, file: !22, line: 50, type: !157, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!157 = !DISubroutineType(types: !158)
!158 = !{null, !159}
!159 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64)
!160 = !DILocalVariable(name: "l", arg: 1, scope: !156, file: !22, line: 50, type: !159)
!161 = !DILocation(line: 0, scope: !156)
!162 = !DILocation(line: 52, column: 2, scope: !156)
!163 = !DILocation(line: 53, column: 30, scope: !164)
!164 = distinct !DILexicalBlock(scope: !156, file: !22, line: 52, column: 15)
!165 = !DILocation(line: 53, column: 3, scope: !164)
!166 = !DILocation(line: 54, column: 8, scope: !167)
!167 = distinct !DILexicalBlock(scope: !164, file: !22, line: 54, column: 7)
!168 = !DILocation(line: 54, column: 7, scope: !164)
!169 = distinct !{!169, !162, !170}
!170 = !DILocation(line: 57, column: 2, scope: !156)
!171 = !DILocation(line: 55, column: 4, scope: !172)
!172 = distinct !DILexicalBlock(scope: !167, file: !22, line: 54, column: 42)
!173 = distinct !DISubprogram(name: "release", scope: !20, file: !20, line: 18, type: !150, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!174 = !DILocalVariable(name: "tid", arg: 1, scope: !173, file: !20, line: 18, type: !11)
!175 = !DILocation(line: 0, scope: !173)
!176 = !DILocation(line: 22, column: 2, scope: !173)
!177 = !DILocation(line: 23, column: 1, scope: !173)
!178 = distinct !DISubprogram(name: "ttaslock_release", scope: !22, file: !22, line: 77, type: !157, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!179 = !DILocalVariable(name: "l", arg: 1, scope: !178, file: !22, line: 77, type: !159)
!180 = !DILocation(line: 0, scope: !178)
!181 = !DILocation(line: 79, column: 26, scope: !178)
!182 = !DILocation(line: 79, column: 2, scope: !178)
!183 = !DILocation(line: 80, column: 1, scope: !178)
!184 = distinct !DISubprogram(name: "verification_loop_bound", scope: !185, file: !185, line: 80, type: !150, scopeLine: 81, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!185 = !DIFile(filename: "./include/vsync/common/verify.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "3a0b94d9e7ec6d94ef39ae9297c4bc2a")
!186 = !DILocalVariable(name: "bound", arg: 1, scope: !184, file: !185, line: 80, type: !11)
!187 = !DILocation(line: 0, scope: !184)
!188 = !DILocation(line: 83, column: 1, scope: !184)
!189 = distinct !DISubprogram(name: "vatomic32_await_eq_rlx", scope: !190, file: !190, line: 4406, type: !191, scopeLine: 4407, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!190 = !DIFile(filename: "./include/vsync/atomic/internal/fallback.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "bfc5d50ad810da3af0d582a48b47498f")
!191 = !DISubroutineType(types: !192)
!192 = !{!11, !193, !11}
!193 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !26, size: 64)
!194 = !DILocalVariable(name: "a", arg: 1, scope: !189, file: !190, line: 4406, type: !193)
!195 = !DILocation(line: 0, scope: !189)
!196 = !DILocalVariable(name: "c", arg: 2, scope: !189, file: !190, line: 4406, type: !11)
!197 = !DILocalVariable(name: "ret", scope: !189, file: !190, line: 4408, type: !11)
!198 = !DILocalVariable(name: "o", scope: !189, file: !190, line: 4409, type: !11)
!199 = !DILocation(line: 4410, column: 2, scope: !189)
!200 = distinct !{!200, !199, !201, !128}
!201 = !DILocation(line: 4413, column: 2, scope: !189)
!202 = !DILocation(line: 4414, column: 2, scope: !189)
!203 = distinct !DISubprogram(name: "vatomic32_xchg_acq", scope: !204, file: !204, line: 720, type: !191, scopeLine: 721, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!204 = !DIFile(filename: "./include/vsync/atomic/internal/builtins.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "31d9a9647b315cadb2f817a7c8e98ecf")
!205 = !DILocalVariable(name: "a", arg: 1, scope: !203, file: !204, line: 720, type: !193)
!206 = !DILocation(line: 0, scope: !203)
!207 = !DILocalVariable(name: "v", arg: 2, scope: !203, file: !204, line: 720, type: !11)
!208 = !DILocation(line: 722, column: 2, scope: !203)
!209 = !{i64 2147854106}
!210 = !DILocation(line: 724, column: 7, scope: !203)
!211 = !DILocation(line: 723, column: 29, scope: !203)
!212 = !DILocalVariable(name: "tmp", scope: !203, file: !204, line: 723, type: !11)
!213 = !DILocation(line: 725, column: 2, scope: !203)
!214 = !{i64 2147854152}
!215 = !DILocation(line: 726, column: 2, scope: !203)
!216 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !204, file: !204, line: 193, type: !217, scopeLine: 194, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!217 = !DISubroutineType(types: !218)
!218 = !{!11, !193}
!219 = !DILocalVariable(name: "a", arg: 1, scope: !216, file: !204, line: 193, type: !193)
!220 = !DILocation(line: 0, scope: !216)
!221 = !DILocation(line: 195, column: 2, scope: !216)
!222 = !{i64 2147850998}
!223 = !DILocation(line: 197, column: 7, scope: !216)
!224 = !DILocation(line: 196, column: 29, scope: !216)
!225 = !DILocalVariable(name: "tmp", scope: !216, file: !204, line: 196, type: !11)
!226 = !DILocation(line: 198, column: 2, scope: !216)
!227 = !{i64 2147851044}
!228 = !DILocation(line: 199, column: 2, scope: !216)
!229 = distinct !DISubprogram(name: "vatomic32_write_rel", scope: !204, file: !204, line: 438, type: !230, scopeLine: 439, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!230 = !DISubroutineType(types: !231)
!231 = !{null, !193, !11}
!232 = !DILocalVariable(name: "a", arg: 1, scope: !229, file: !204, line: 438, type: !193)
!233 = !DILocation(line: 0, scope: !229)
!234 = !DILocalVariable(name: "v", arg: 2, scope: !229, file: !204, line: 438, type: !11)
!235 = !DILocation(line: 440, column: 2, scope: !229)
!236 = !{i64 2147852426}
!237 = !DILocation(line: 441, column: 23, scope: !229)
!238 = !DILocation(line: 441, column: 2, scope: !229)
!239 = !DILocation(line: 442, column: 2, scope: !229)
!240 = !{i64 2147852472}
!241 = !DILocation(line: 443, column: 1, scope: !229)
