; ModuleID = '/home/drc/git/Dat3M/output/caslock.ll'
source_filename = "/home/drc/git/libvsync/test/spinlock/caslock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.caslock_s = type { %struct.vatomic32_s }
%struct.vatomic32_s = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_cs_x = internal global i32 0, align 4, !dbg !0
@g_cs_y = internal global i32 0, align 4, !dbg !31
@.str = private unnamed_addr constant [17 x i8] c"g_cs_x == g_cs_y\00", align 1
@.str.1 = private unnamed_addr constant [34 x i8] c"./include/test/boilerplate/lock.h\00", align 1
@__PRETTY_FUNCTION__.check = private unnamed_addr constant [17 x i8] c"void check(void)\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"g_cs_x == (3 + 1 + 0)\00", align 1
@lock = dso_local global %struct.caslock_s zeroinitializer, align 4, !dbg !18

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
  %6 = icmp eq i32 %1, 4, !dbg !60
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
  call void @verification_loop_bound(i32 noundef 3), !dbg !102
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
  %7 = icmp ult i32 %6, 2, !dbg !109
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
  %2 = icmp eq i32 %0, 2, !dbg !154
  br i1 %2, label %3, label %6, !dbg !156

3:                                                ; preds = %3, %1
  %4 = call zeroext i1 @caslock_tryacquire(%struct.caslock_s* noundef @lock), !dbg !157
  %5 = xor i1 %4, true, !dbg !157
  br i1 %5, label %3, label %7, !dbg !157, !llvm.loop !158

6:                                                ; preds = %1
  call void @caslock_acquire(%struct.caslock_s* noundef @lock), !dbg !160
  br label %7

7:                                                ; preds = %3, %6
  ret void, !dbg !161
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @caslock_tryacquire(%struct.caslock_s* noundef %0) #0 !dbg !162 {
  call void @llvm.dbg.value(metadata %struct.caslock_s* %0, metadata !168, metadata !DIExpression()), !dbg !169
  %2 = getelementptr inbounds %struct.caslock_s, %struct.caslock_s* %0, i32 0, i32 0, !dbg !170
  %3 = call i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %2, i32 noundef 0, i32 noundef 1), !dbg !171
  %4 = icmp eq i32 %3, 0, !dbg !172
  ret i1 %4, !dbg !173
}

; Function Attrs: noinline nounwind uwtable
define internal void @caslock_acquire(%struct.caslock_s* noundef %0) #0 !dbg !174 {
  call void @llvm.dbg.value(metadata %struct.caslock_s* %0, metadata !177, metadata !DIExpression()), !dbg !178
  %2 = getelementptr inbounds %struct.caslock_s, %struct.caslock_s* %0, i32 0, i32 0, !dbg !179
  %3 = call i32 @vatomic32_await_eq_set_acq(%struct.vatomic32_s* noundef %2, i32 noundef 0, i32 noundef 1), !dbg !180
  ret void, !dbg !181
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @release(i32 noundef %0) #0 !dbg !182 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !183, metadata !DIExpression()), !dbg !184
  call void @caslock_release(%struct.caslock_s* noundef @lock), !dbg !185
  ret void, !dbg !186
}

; Function Attrs: noinline nounwind uwtable
define internal void @caslock_release(%struct.caslock_s* noundef %0) #0 !dbg !187 {
  call void @llvm.dbg.value(metadata %struct.caslock_s* %0, metadata !188, metadata !DIExpression()), !dbg !189
  %2 = getelementptr inbounds %struct.caslock_s, %struct.caslock_s* %0, i32 0, i32 0, !dbg !190
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %2, i32 noundef 0), !dbg !191
  ret void, !dbg !192
}

; Function Attrs: noinline nounwind uwtable
define internal void @verification_loop_bound(i32 noundef %0) #0 !dbg !193 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !195, metadata !DIExpression()), !dbg !196
  ret void, !dbg !197
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !198 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !203, metadata !DIExpression()), !dbg !204
  call void @llvm.dbg.value(metadata i32 %1, metadata !205, metadata !DIExpression()), !dbg !204
  call void @llvm.dbg.value(metadata i32 %2, metadata !206, metadata !DIExpression()), !dbg !204
  call void @llvm.dbg.value(metadata i32 %1, metadata !207, metadata !DIExpression()), !dbg !204
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !208, !srcloc !209
  %4 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !210
  %5 = cmpxchg i32* %4, i32 %1, i32 %2 acquire acquire, align 4, !dbg !211
  %6 = extractvalue { i32, i1 } %5, 0, !dbg !211
  %7 = extractvalue { i32, i1 } %5, 1, !dbg !211
  %spec.select = select i1 %7, i32 %1, i32 %6, !dbg !211
  call void @llvm.dbg.value(metadata i32 %spec.select, metadata !207, metadata !DIExpression()), !dbg !204
  %8 = zext i1 %7 to i8, !dbg !211
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !212, !srcloc !213
  ret i32 %spec.select, !dbg !214
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_eq_set_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !215 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !217, metadata !DIExpression()), !dbg !218
  call void @llvm.dbg.value(metadata i32 %1, metadata !219, metadata !DIExpression()), !dbg !218
  call void @llvm.dbg.value(metadata i32 %2, metadata !220, metadata !DIExpression()), !dbg !218
  br label %4, !dbg !221

4:                                                ; preds = %4, %3
  %5 = call i32 @vatomic32_await_eq_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1), !dbg !222
  %6 = call i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2), !dbg !224
  %7 = icmp ne i32 %6, %1, !dbg !225
  br i1 %7, label %4, label %8, !dbg !226, !llvm.loop !227

8:                                                ; preds = %4
  ret i32 %1, !dbg !229
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_eq_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !230 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !233, metadata !DIExpression()), !dbg !234
  call void @llvm.dbg.value(metadata i32 %1, metadata !235, metadata !DIExpression()), !dbg !234
  call void @llvm.dbg.value(metadata i32 %1, metadata !236, metadata !DIExpression()), !dbg !234
  call void @llvm.dbg.value(metadata i32 0, metadata !237, metadata !DIExpression()), !dbg !234
  br label %3, !dbg !238

3:                                                ; preds = %3, %2
  %.0 = phi i32 [ %1, %2 ], [ %4, %3 ], !dbg !234
  call void @llvm.dbg.value(metadata i32 %.0, metadata !236, metadata !DIExpression()), !dbg !234
  %4 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0), !dbg !238
  call void @llvm.dbg.value(metadata i32 %4, metadata !237, metadata !DIExpression()), !dbg !234
  %5 = icmp ne i32 %4, %1, !dbg !238
  br i1 %5, label %3, label %6, !dbg !238, !llvm.loop !239

6:                                                ; preds = %3
  ret i32 %.0, !dbg !241
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !242 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !245, metadata !DIExpression()), !dbg !246
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !247, !srcloc !248
  %2 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !249
  %3 = load atomic i32, i32* %2 monotonic, align 4, !dbg !250
  call void @llvm.dbg.value(metadata i32 %3, metadata !251, metadata !DIExpression()), !dbg !246
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !252, !srcloc !253
  ret i32 %3, !dbg !254
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !255 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !258, metadata !DIExpression()), !dbg !259
  call void @llvm.dbg.value(metadata i32 %1, metadata !260, metadata !DIExpression()), !dbg !259
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !261, !srcloc !262
  %3 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !263
  store atomic i32 %1, i32* %3 release, align 4, !dbg !264
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !265, !srcloc !266
  ret void, !dbg !267
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
!3 = !DIFile(filename: "/home/drc/git/libvsync/test/spinlock/caslock.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "1b04f914fe7f505858f532528f964aef")
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
!19 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !20, line: 10, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "test/spinlock/caslock.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "1b04f914fe7f505858f532528f964aef")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "caslock_t", file: !22, line: 21, baseType: !23)
!22 = !DIFile(filename: "./include/vsync/spinlock/caslock.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "0b3ff5813922de394db335c768849f1c")
!23 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "caslock_s", file: !22, line: 19, size: 32, elements: !24)
!24 = !{!25}
!25 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !23, file: !22, line: 20, baseType: !26, size: 32, align: 32)
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
!149 = distinct !DISubprogram(name: "acquire", scope: !20, file: !20, line: 13, type: !150, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!150 = !DISubroutineType(types: !151)
!151 = !{null, !11}
!152 = !DILocalVariable(name: "tid", arg: 1, scope: !149, file: !20, line: 13, type: !11)
!153 = !DILocation(line: 0, scope: !149)
!154 = !DILocation(line: 15, column: 10, scope: !155)
!155 = distinct !DILexicalBlock(scope: !149, file: !20, line: 15, column: 6)
!156 = !DILocation(line: 15, column: 6, scope: !149)
!157 = !DILocation(line: 16, column: 3, scope: !155)
!158 = distinct !{!158, !157, !159, !128}
!159 = !DILocation(line: 17, column: 4, scope: !155)
!160 = !DILocation(line: 19, column: 3, scope: !155)
!161 = !DILocation(line: 20, column: 1, scope: !149)
!162 = distinct !DISubprogram(name: "caslock_tryacquire", scope: !22, file: !22, line: 58, type: !163, scopeLine: 59, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!163 = !DISubroutineType(types: !164)
!164 = !{!165, !167}
!165 = !DIDerivedType(tag: DW_TAG_typedef, name: "vbool_t", file: !7, line: 43, baseType: !166)
!166 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!167 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64)
!168 = !DILocalVariable(name: "l", arg: 1, scope: !162, file: !22, line: 58, type: !167)
!169 = !DILocation(line: 0, scope: !162)
!170 = !DILocation(line: 60, column: 35, scope: !162)
!171 = !DILocation(line: 60, column: 9, scope: !162)
!172 = !DILocation(line: 60, column: 47, scope: !162)
!173 = !DILocation(line: 60, column: 2, scope: !162)
!174 = distinct !DISubprogram(name: "caslock_acquire", scope: !22, file: !22, line: 46, type: !175, scopeLine: 47, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!175 = !DISubroutineType(types: !176)
!176 = !{null, !167}
!177 = !DILocalVariable(name: "l", arg: 1, scope: !174, file: !22, line: 46, type: !167)
!178 = !DILocation(line: 0, scope: !174)
!179 = !DILocation(line: 48, column: 33, scope: !174)
!180 = !DILocation(line: 48, column: 2, scope: !174)
!181 = !DILocation(line: 49, column: 1, scope: !174)
!182 = distinct !DISubprogram(name: "release", scope: !20, file: !20, line: 23, type: !150, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!183 = !DILocalVariable(name: "tid", arg: 1, scope: !182, file: !20, line: 23, type: !11)
!184 = !DILocation(line: 0, scope: !182)
!185 = !DILocation(line: 26, column: 2, scope: !182)
!186 = !DILocation(line: 27, column: 1, scope: !182)
!187 = distinct !DISubprogram(name: "caslock_release", scope: !22, file: !22, line: 68, type: !175, scopeLine: 69, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!188 = !DILocalVariable(name: "l", arg: 1, scope: !187, file: !22, line: 68, type: !167)
!189 = !DILocation(line: 0, scope: !187)
!190 = !DILocation(line: 70, column: 26, scope: !187)
!191 = !DILocation(line: 70, column: 2, scope: !187)
!192 = !DILocation(line: 71, column: 1, scope: !187)
!193 = distinct !DISubprogram(name: "verification_loop_bound", scope: !194, file: !194, line: 80, type: !150, scopeLine: 81, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!194 = !DIFile(filename: "./include/vsync/common/verify.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "3a0b94d9e7ec6d94ef39ae9297c4bc2a")
!195 = !DILocalVariable(name: "bound", arg: 1, scope: !193, file: !194, line: 80, type: !11)
!196 = !DILocation(line: 0, scope: !193)
!197 = !DILocation(line: 83, column: 1, scope: !193)
!198 = distinct !DISubprogram(name: "vatomic32_cmpxchg_acq", scope: !199, file: !199, line: 1102, type: !200, scopeLine: 1103, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!199 = !DIFile(filename: "./include/vsync/atomic/internal/builtins.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "31d9a9647b315cadb2f817a7c8e98ecf")
!200 = !DISubroutineType(types: !201)
!201 = !{!11, !202, !11, !11}
!202 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !26, size: 64)
!203 = !DILocalVariable(name: "a", arg: 1, scope: !198, file: !199, line: 1102, type: !202)
!204 = !DILocation(line: 0, scope: !198)
!205 = !DILocalVariable(name: "e", arg: 2, scope: !198, file: !199, line: 1102, type: !11)
!206 = !DILocalVariable(name: "v", arg: 3, scope: !198, file: !199, line: 1102, type: !11)
!207 = !DILocalVariable(name: "exp", scope: !198, file: !199, line: 1104, type: !11)
!208 = !DILocation(line: 1105, column: 2, scope: !198)
!209 = !{i64 2147856126}
!210 = !DILocation(line: 1106, column: 34, scope: !198)
!211 = !DILocation(line: 1106, column: 2, scope: !198)
!212 = !DILocation(line: 1109, column: 2, scope: !198)
!213 = !{i64 2147856180}
!214 = !DILocation(line: 1110, column: 2, scope: !198)
!215 = distinct !DISubprogram(name: "vatomic32_await_eq_set_acq", scope: !216, file: !216, line: 7487, type: !200, scopeLine: 7488, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!216 = !DIFile(filename: "./include/vsync/atomic/internal/fallback.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "bfc5d50ad810da3af0d582a48b47498f")
!217 = !DILocalVariable(name: "a", arg: 1, scope: !215, file: !216, line: 7487, type: !202)
!218 = !DILocation(line: 0, scope: !215)
!219 = !DILocalVariable(name: "c", arg: 2, scope: !215, file: !216, line: 7487, type: !11)
!220 = !DILocalVariable(name: "v", arg: 3, scope: !215, file: !216, line: 7487, type: !11)
!221 = !DILocation(line: 7489, column: 2, scope: !215)
!222 = !DILocation(line: 7490, column: 9, scope: !223)
!223 = distinct !DILexicalBlock(scope: !215, file: !216, line: 7489, column: 5)
!224 = !DILocation(line: 7491, column: 11, scope: !215)
!225 = !DILocation(line: 7491, column: 42, scope: !215)
!226 = !DILocation(line: 7491, column: 2, scope: !223)
!227 = distinct !{!227, !221, !228, !128}
!228 = !DILocation(line: 7491, column: 46, scope: !215)
!229 = !DILocation(line: 7492, column: 2, scope: !215)
!230 = distinct !DISubprogram(name: "vatomic32_await_eq_rlx", scope: !216, file: !216, line: 4406, type: !231, scopeLine: 4407, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!231 = !DISubroutineType(types: !232)
!232 = !{!11, !202, !11}
!233 = !DILocalVariable(name: "a", arg: 1, scope: !230, file: !216, line: 4406, type: !202)
!234 = !DILocation(line: 0, scope: !230)
!235 = !DILocalVariable(name: "c", arg: 2, scope: !230, file: !216, line: 4406, type: !11)
!236 = !DILocalVariable(name: "ret", scope: !230, file: !216, line: 4408, type: !11)
!237 = !DILocalVariable(name: "o", scope: !230, file: !216, line: 4409, type: !11)
!238 = !DILocation(line: 4410, column: 2, scope: !230)
!239 = distinct !{!239, !238, !240, !128}
!240 = !DILocation(line: 4413, column: 2, scope: !230)
!241 = !DILocation(line: 4414, column: 2, scope: !230)
!242 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !199, file: !199, line: 193, type: !243, scopeLine: 194, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!243 = !DISubroutineType(types: !244)
!244 = !{!11, !202}
!245 = !DILocalVariable(name: "a", arg: 1, scope: !242, file: !199, line: 193, type: !202)
!246 = !DILocation(line: 0, scope: !242)
!247 = !DILocation(line: 195, column: 2, scope: !242)
!248 = !{i64 2147850930}
!249 = !DILocation(line: 197, column: 7, scope: !242)
!250 = !DILocation(line: 196, column: 29, scope: !242)
!251 = !DILocalVariable(name: "tmp", scope: !242, file: !199, line: 196, type: !11)
!252 = !DILocation(line: 198, column: 2, scope: !242)
!253 = !{i64 2147850976}
!254 = !DILocation(line: 199, column: 2, scope: !242)
!255 = distinct !DISubprogram(name: "vatomic32_write_rel", scope: !199, file: !199, line: 438, type: !256, scopeLine: 439, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!256 = !DISubroutineType(types: !257)
!257 = !{null, !202, !11}
!258 = !DILocalVariable(name: "a", arg: 1, scope: !255, file: !199, line: 438, type: !202)
!259 = !DILocation(line: 0, scope: !255)
!260 = !DILocalVariable(name: "v", arg: 2, scope: !255, file: !199, line: 438, type: !11)
!261 = !DILocation(line: 440, column: 2, scope: !255)
!262 = !{i64 2147852358}
!263 = !DILocation(line: 441, column: 23, scope: !255)
!264 = !DILocation(line: 441, column: 2, scope: !255)
!265 = !DILocation(line: 442, column: 2, scope: !255)
!266 = !{i64 2147852404}
!267 = !DILocation(line: 443, column: 1, scope: !255)
