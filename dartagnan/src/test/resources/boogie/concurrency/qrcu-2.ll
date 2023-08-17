; ModuleID = '/home/ponce/git/Dat3M/output/qrcu-2.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-atomic/qrcu-2.i"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, %union.anon }
%union.anon = type { %struct.__pthread_internal_slist }
%struct.__pthread_internal_slist = type { %struct.__pthread_internal_slist* }
%union.pthread_mutexattr_t = type { i32 }
%union.pthread_attr_t = type { i64, [32 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"qrcu-2.c\00", align 1
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1
@idx = dso_local global i32 0, align 4, !dbg !0
@ctr1 = dso_local global i32 1, align 4, !dbg !5
@ctr2 = dso_local global i32 0, align 4, !dbg !9
@readerprogress1 = dso_local global i32 0, align 4, !dbg !11
@readerprogress2 = dso_local global i32 0, align 4, !dbg !13
@mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !15

; Function Attrs: noinline nounwind uwtable
define dso_local void @assume_abort_if_not(i32 noundef %0) #0 !dbg !59 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !63, metadata !DIExpression()), !dbg !64
  %.not = icmp eq i32 %0, 0, !dbg !65
  br i1 %.not, label %2, label %3, !dbg !67

2:                                                ; preds = %1
  call void @abort() #7, !dbg !68
  unreachable, !dbg !68

3:                                                ; preds = %1
  ret void, !dbg !70
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noreturn
declare void @abort() #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !71 {
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i64 0, i64 0), i32 noundef 7, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #8, !dbg !74
  unreachable, !dbg !74
}

; Function Attrs: nocallback noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_atomic_use1(i32 noundef %0) #0 !dbg !77 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !78, metadata !DIExpression()), !dbg !79
  %2 = icmp slt i32 %0, 1, !dbg !80
  %3 = load i32, i32* @ctr1, align 4, !dbg !81
  %4 = icmp sgt i32 %3, 0, !dbg !81
  %5 = select i1 %2, i1 %4, i1 false, !dbg !81
  %6 = zext i1 %5 to i32, !dbg !81
  call void @assume_abort_if_not(i32 noundef %6), !dbg !82
  %7 = load i32, i32* @ctr1, align 4, !dbg !83
  %8 = add nsw i32 %7, 1, !dbg !83
  store i32 %8, i32* @ctr1, align 4, !dbg !83
  ret void, !dbg !84
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_atomic_use2(i32 noundef %0) #0 !dbg !85 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !86, metadata !DIExpression()), !dbg !87
  %2 = icmp sgt i32 %0, 0, !dbg !88
  %3 = load i32, i32* @ctr2, align 4, !dbg !89
  %4 = icmp sgt i32 %3, 0, !dbg !89
  %5 = select i1 %2, i1 %4, i1 false, !dbg !89
  %6 = zext i1 %5 to i32, !dbg !89
  call void @assume_abort_if_not(i32 noundef %6), !dbg !90
  %7 = load i32, i32* @ctr2, align 4, !dbg !91
  %8 = add nsw i32 %7, 1, !dbg !91
  store i32 %8, i32* @ctr2, align 4, !dbg !91
  ret void, !dbg !92
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_atomic_use_done(i32 noundef %0) #0 !dbg !93 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !94, metadata !DIExpression()), !dbg !95
  %2 = icmp slt i32 %0, 1, !dbg !96
  br i1 %2, label %3, label %6, !dbg !98

3:                                                ; preds = %1
  %4 = load i32, i32* @ctr1, align 4, !dbg !99
  %5 = add nsw i32 %4, -1, !dbg !99
  store i32 %5, i32* @ctr1, align 4, !dbg !99
  br label %9, !dbg !101

6:                                                ; preds = %1
  %7 = load i32, i32* @ctr2, align 4, !dbg !102
  %8 = add nsw i32 %7, -1, !dbg !102
  store i32 %8, i32* @ctr2, align 4, !dbg !102
  br label %9

9:                                                ; preds = %6, %3
  ret void, !dbg !104
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_atomic_take_snapshot(i32 noundef %0, i32 noundef %1) #0 !dbg !105 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !108, metadata !DIExpression()), !dbg !109
  call void @llvm.dbg.value(metadata i32 %1, metadata !110, metadata !DIExpression()), !dbg !109
  call void @llvm.dbg.value(metadata i32 undef, metadata !108, metadata !DIExpression()), !dbg !109
  call void @llvm.dbg.value(metadata i32 undef, metadata !110, metadata !DIExpression()), !dbg !109
  ret void, !dbg !111
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_atomic_check_progress1(i32 noundef %0) #0 !dbg !112 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !113, metadata !DIExpression()), !dbg !114
  %2 = call i32 (...) @__VERIFIER_nondet_int() #9, !dbg !115
  %.not = icmp eq i32 %2, 0, !dbg !115
  br i1 %.not, label %9, label %3, !dbg !117

3:                                                ; preds = %1
  %4 = icmp eq i32 %0, 1, !dbg !118
  %5 = load i32, i32* @readerprogress1, align 4, !dbg !120
  %6 = icmp eq i32 %5, 1, !dbg !120
  %7 = select i1 %4, i1 %6, i1 false, !dbg !120
  %8 = zext i1 %7 to i32, !dbg !120
  call void @assume_abort_if_not(i32 noundef %8), !dbg !121
  call void @llvm.dbg.label(metadata !122), !dbg !124
  call void @reach_error(), !dbg !125
  call void @abort() #7, !dbg !127
  unreachable, !dbg !127

9:                                                ; preds = %1
  ret void, !dbg !128
}

declare i32 @__VERIFIER_nondet_int(...) #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_atomic_check_progress2(i32 noundef %0) #0 !dbg !129 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !130, metadata !DIExpression()), !dbg !131
  %2 = call i32 (...) @__VERIFIER_nondet_int() #9, !dbg !132
  %.not = icmp eq i32 %2, 0, !dbg !132
  br i1 %.not, label %9, label %3, !dbg !134

3:                                                ; preds = %1
  %4 = icmp eq i32 %0, 1, !dbg !135
  %5 = load i32, i32* @readerprogress2, align 4, !dbg !137
  %6 = icmp eq i32 %5, 1, !dbg !137
  %7 = select i1 %4, i1 %6, i1 false, !dbg !137
  %8 = zext i1 %7 to i32, !dbg !137
  call void @assume_abort_if_not(i32 noundef %8), !dbg !138
  call void @llvm.dbg.label(metadata !139), !dbg !141
  call void @reach_error(), !dbg !142
  call void @abort() #7, !dbg !144
  unreachable, !dbg !144

9:                                                ; preds = %1
  ret void, !dbg !145
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @qrcu_reader1(i8* noundef %0) #0 !dbg !146 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !150, metadata !DIExpression()), !dbg !151
  br label %2, !dbg !152

2:                                                ; preds = %6, %1
  %3 = load i32, i32* @idx, align 4, !dbg !153
  call void @llvm.dbg.value(metadata i32 %3, metadata !155, metadata !DIExpression()), !dbg !151
  %4 = call i32 (...) @__VERIFIER_nondet_int() #9, !dbg !156
  %.not = icmp eq i32 %4, 0, !dbg !156
  br i1 %.not, label %6, label %5, !dbg !158

5:                                                ; preds = %2
  call void @__VERIFIER_atomic_use1(i32 noundef %3), !dbg !159
  br label %9, !dbg !161

6:                                                ; preds = %2
  %7 = call i32 (...) @__VERIFIER_nondet_int() #9, !dbg !162
  %.not2 = icmp eq i32 %7, 0, !dbg !162
  br i1 %.not2, label %2, label %8, !dbg !165, !llvm.loop !166

8:                                                ; preds = %6
  call void @__VERIFIER_atomic_use2(i32 noundef %3), !dbg !168
  br label %9, !dbg !170

9:                                                ; preds = %8, %5
  store i32 2, i32* @readerprogress1, align 4, !dbg !171
  call void @__VERIFIER_atomic_use_done(i32 noundef %3), !dbg !172
  ret i8* null, !dbg !173
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @qrcu_reader2(i8* noundef %0) #0 !dbg !174 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !175, metadata !DIExpression()), !dbg !176
  br label %2, !dbg !177

2:                                                ; preds = %6, %1
  %3 = load i32, i32* @idx, align 4, !dbg !178
  call void @llvm.dbg.value(metadata i32 %3, metadata !180, metadata !DIExpression()), !dbg !176
  %4 = call i32 (...) @__VERIFIER_nondet_int() #9, !dbg !181
  %.not = icmp eq i32 %4, 0, !dbg !181
  br i1 %.not, label %6, label %5, !dbg !183

5:                                                ; preds = %2
  call void @__VERIFIER_atomic_use1(i32 noundef %3), !dbg !184
  br label %9, !dbg !186

6:                                                ; preds = %2
  %7 = call i32 (...) @__VERIFIER_nondet_int() #9, !dbg !187
  %.not2 = icmp eq i32 %7, 0, !dbg !187
  br i1 %.not2, label %2, label %8, !dbg !190, !llvm.loop !191

8:                                                ; preds = %6
  call void @__VERIFIER_atomic_use2(i32 noundef %3), !dbg !193
  br label %9, !dbg !195

9:                                                ; preds = %8, %5
  store i32 2, i32* @readerprogress2, align 4, !dbg !196
  call void @__VERIFIER_atomic_use_done(i32 noundef %3), !dbg !197
  ret i8* null, !dbg !198
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @qrcu_updater(i8* noundef %0) #0 !dbg !199 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !200, metadata !DIExpression()), !dbg !201
  call void @llvm.dbg.declare(metadata i32* undef, metadata !202, metadata !DIExpression()), !dbg !203
  %2 = call i32 (...) @__VERIFIER_nondet_int() #9, !dbg !204
  call void @llvm.dbg.value(metadata i32 %2, metadata !205, metadata !DIExpression()), !dbg !201
  %3 = call i32 (...) @__VERIFIER_nondet_int() #9, !dbg !206
  call void @llvm.dbg.value(metadata i32 %3, metadata !207, metadata !DIExpression()), !dbg !201
  call void @__VERIFIER_atomic_take_snapshot(i32 noundef %2, i32 noundef %3), !dbg !208
  %4 = call i32 (...) @__VERIFIER_nondet_int() #9, !dbg !209
  %.not = icmp eq i32 %4, 0, !dbg !209
  br i1 %.not, label %9, label %5, !dbg !211

5:                                                ; preds = %1
  %6 = load i32, i32* @ctr1, align 4, !dbg !212
  call void @llvm.dbg.value(metadata i32 %6, metadata !214, metadata !DIExpression()), !dbg !201
  %7 = load i32, i32* @ctr2, align 4, !dbg !215
  %8 = add nsw i32 %6, %7, !dbg !216
  call void @llvm.dbg.value(metadata i32 %8, metadata !214, metadata !DIExpression()), !dbg !201
  br label %13, !dbg !217

9:                                                ; preds = %1
  %10 = load i32, i32* @ctr2, align 4, !dbg !218
  call void @llvm.dbg.value(metadata i32 %10, metadata !214, metadata !DIExpression()), !dbg !201
  %11 = load i32, i32* @ctr1, align 4, !dbg !220
  %12 = add nsw i32 %10, %11, !dbg !221
  call void @llvm.dbg.value(metadata i32 %12, metadata !214, metadata !DIExpression()), !dbg !201
  br label %13

13:                                               ; preds = %9, %5
  %.0 = phi i32 [ %8, %5 ], [ %12, %9 ], !dbg !222
  call void @llvm.dbg.value(metadata i32 %.0, metadata !214, metadata !DIExpression()), !dbg !201
  %14 = icmp slt i32 %.0, 2, !dbg !223
  br i1 %14, label %15, label %25, !dbg !225

15:                                               ; preds = %13
  %16 = call i32 (...) @__VERIFIER_nondet_int() #9, !dbg !226
  %.not1 = icmp eq i32 %16, 0, !dbg !226
  br i1 %.not1, label %21, label %17, !dbg !229

17:                                               ; preds = %15
  %18 = load i32, i32* @ctr1, align 4, !dbg !230
  call void @llvm.dbg.value(metadata i32 %18, metadata !214, metadata !DIExpression()), !dbg !201
  %19 = load i32, i32* @ctr2, align 4, !dbg !232
  %20 = add nsw i32 %18, %19, !dbg !233
  call void @llvm.dbg.value(metadata i32 %20, metadata !214, metadata !DIExpression()), !dbg !201
  br label %25, !dbg !234

21:                                               ; preds = %15
  %22 = load i32, i32* @ctr2, align 4, !dbg !235
  call void @llvm.dbg.value(metadata i32 %22, metadata !214, metadata !DIExpression()), !dbg !201
  %23 = load i32, i32* @ctr1, align 4, !dbg !237
  %24 = add nsw i32 %22, %23, !dbg !238
  call void @llvm.dbg.value(metadata i32 %24, metadata !214, metadata !DIExpression()), !dbg !201
  br label %25

25:                                               ; preds = %13, %17, %21
  %.2 = phi i32 [ %20, %17 ], [ %24, %21 ], [ %.0, %13 ], !dbg !201
  call void @llvm.dbg.value(metadata i32 %.2, metadata !214, metadata !DIExpression()), !dbg !201
  %26 = icmp sgt i32 %.2, 1, !dbg !239
  br i1 %26, label %27, label %50, !dbg !241

27:                                               ; preds = %25
  %28 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef nonnull @mutex) #9, !dbg !242
  %29 = load i32, i32* @idx, align 4, !dbg !244
  %30 = icmp slt i32 %29, 1, !dbg !246
  br i1 %30, label %31, label %36, !dbg !247

31:                                               ; preds = %27
  %32 = load i32, i32* @ctr2, align 4, !dbg !248
  %33 = add nsw i32 %32, 1, !dbg !248
  store i32 %33, i32* @ctr2, align 4, !dbg !248
  store i32 1, i32* @idx, align 4, !dbg !250
  %34 = load i32, i32* @ctr1, align 4, !dbg !251
  %35 = add nsw i32 %34, -1, !dbg !251
  store i32 %35, i32* @ctr1, align 4, !dbg !251
  br label %41, !dbg !252

36:                                               ; preds = %27
  %37 = load i32, i32* @ctr1, align 4, !dbg !253
  %38 = add nsw i32 %37, 1, !dbg !253
  store i32 %38, i32* @ctr1, align 4, !dbg !253
  store i32 0, i32* @idx, align 4, !dbg !255
  %39 = load i32, i32* @ctr2, align 4, !dbg !256
  %40 = add nsw i32 %39, -1, !dbg !256
  store i32 %40, i32* @ctr2, align 4, !dbg !256
  br label %41

41:                                               ; preds = %36, %31
  %42 = phi i32 [ %38, %36 ], [ %35, %31 ]
  %43 = phi i32 [ %40, %36 ], [ %33, %31 ]
  br i1 %30, label %46, label %44, !dbg !257

44:                                               ; preds = %44, %41
  %45 = icmp sgt i32 %42, 0, !dbg !258
  br i1 %45, label %44, label %48, !dbg !261, !llvm.loop !262

46:                                               ; preds = %46, %41
  %47 = icmp sgt i32 %43, 0, !dbg !265
  br i1 %47, label %46, label %48, !dbg !267, !llvm.loop !268

48:                                               ; preds = %46, %44
  %49 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef nonnull @mutex) #9, !dbg !270
  br label %50, !dbg !271

50:                                               ; preds = %25, %48
  call void @__VERIFIER_atomic_check_progress1(i32 noundef %2), !dbg !272
  call void @__VERIFIER_atomic_check_progress2(i32 noundef %3), !dbg !273
  ret i8* null, !dbg !274
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef) #5

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef) #5

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !275 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef nonnull @mutex, %union.pthread_mutexattr_t* noundef null) #10, !dbg !278
  call void @llvm.dbg.value(metadata i64* %1, metadata !279, metadata !DIExpression(DW_OP_deref)), !dbg !282
  %5 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @qrcu_reader1, i8* noundef null) #9, !dbg !283
  call void @llvm.dbg.value(metadata i64* %2, metadata !284, metadata !DIExpression(DW_OP_deref)), !dbg !282
  %6 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @qrcu_reader2, i8* noundef null) #9, !dbg !285
  call void @llvm.dbg.value(metadata i64* %3, metadata !286, metadata !DIExpression(DW_OP_deref)), !dbg !282
  %7 = call i32 @pthread_create(i64* noundef nonnull %3, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @qrcu_updater, i8* noundef null) #9, !dbg !287
  %8 = load i64, i64* %1, align 8, !dbg !288
  call void @llvm.dbg.value(metadata i64 %8, metadata !279, metadata !DIExpression()), !dbg !282
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null) #9, !dbg !289
  %10 = load i64, i64* %2, align 8, !dbg !290
  call void @llvm.dbg.value(metadata i64 %10, metadata !284, metadata !DIExpression()), !dbg !282
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null) #9, !dbg !291
  %12 = load i64, i64* %3, align 8, !dbg !292
  call void @llvm.dbg.value(metadata i64 %12, metadata !286, metadata !DIExpression()), !dbg !282
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null) #9, !dbg !293
  %14 = call i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef nonnull @mutex) #10, !dbg !294
  ret i32 0, !dbg !295
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef, %union.pthread_mutexattr_t* noundef) #6

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #5

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef) #6

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nocallback noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nocallback nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { noreturn nounwind }
attributes #8 = { nocallback noreturn nounwind }
attributes #9 = { nounwind }
attributes #10 = { nocallback nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!51, !52, !53, !54, !55, !56, !57}
!llvm.ident = !{!58}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "idx", scope: !2, file: !7, line: 689, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-atomic/qrcu-2.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "a743a38aac7574d38253e56359c2976b")
!4 = !{!0, !5, !9, !11, !13, !15}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(name: "ctr1", scope: !2, file: !7, line: 690, type: !8, isLocal: false, isDefinition: true)
!7 = !DIFile(filename: "../sv-benchmarks/c/pthread-atomic/qrcu-2.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "a743a38aac7574d38253e56359c2976b")
!8 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!9 = !DIGlobalVariableExpression(var: !10, expr: !DIExpression())
!10 = distinct !DIGlobalVariable(name: "ctr2", scope: !2, file: !7, line: 690, type: !8, isLocal: false, isDefinition: true)
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(name: "readerprogress1", scope: !2, file: !7, line: 691, type: !8, isLocal: false, isDefinition: true)
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(name: "readerprogress2", scope: !2, file: !7, line: 691, type: !8, isLocal: false, isDefinition: true)
!15 = !DIGlobalVariableExpression(var: !16, expr: !DIExpression())
!16 = distinct !DIGlobalVariable(name: "mutex", scope: !2, file: !7, line: 692, type: !17, isLocal: false, isDefinition: true)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !7, line: 309, baseType: !18)
!18 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !7, line: 304, size: 256, elements: !19)
!19 = !{!20, !44, !49}
!20 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !18, file: !7, line: 306, baseType: !21, size: 256)
!21 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !7, line: 244, size: 256, elements: !22)
!22 = !{!23, !24, !26, !27, !28, !29}
!23 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !21, file: !7, line: 246, baseType: !8, size: 32)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !21, file: !7, line: 247, baseType: !25, size: 32, offset: 32)
!25 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !21, file: !7, line: 248, baseType: !8, size: 32, offset: 64)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !21, file: !7, line: 249, baseType: !8, size: 32, offset: 96)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !21, file: !7, line: 251, baseType: !25, size: 32, offset: 128)
!29 = !DIDerivedType(tag: DW_TAG_member, scope: !21, file: !7, line: 252, baseType: !30, size: 64, offset: 192)
!30 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !21, file: !7, line: 252, size: 64, elements: !31)
!31 = !{!32, !38}
!32 = !DIDerivedType(tag: DW_TAG_member, name: "__elision_data", scope: !30, file: !7, line: 254, baseType: !33, size: 32)
!33 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !30, file: !7, line: 254, size: 32, elements: !34)
!34 = !{!35, !37}
!35 = !DIDerivedType(tag: DW_TAG_member, name: "__espins", scope: !33, file: !7, line: 254, baseType: !36, size: 16)
!36 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "__eelision", scope: !33, file: !7, line: 254, baseType: !36, size: 16, offset: 16)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !30, file: !7, line: 255, baseType: !39, size: 64)
!39 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_slist_t", file: !7, line: 243, baseType: !40)
!40 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_slist", file: !7, line: 240, size: 64, elements: !41)
!41 = !{!42}
!42 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !40, file: !7, line: 242, baseType: !43, size: 64)
!43 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !40, size: 64)
!44 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !18, file: !7, line: 307, baseType: !45, size: 192)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !46, size: 192, elements: !47)
!46 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!47 = !{!48}
!48 = !DISubrange(count: 24)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !18, file: !7, line: 308, baseType: !50, size: 64)
!50 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!51 = !{i32 7, !"Dwarf Version", i32 5}
!52 = !{i32 2, !"Debug Info Version", i32 3}
!53 = !{i32 1, !"wchar_size", i32 4}
!54 = !{i32 7, !"PIC Level", i32 2}
!55 = !{i32 7, !"PIE Level", i32 2}
!56 = !{i32 7, !"uwtable", i32 1}
!57 = !{i32 7, !"frame-pointer", i32 2}
!58 = !{!"Ubuntu clang version 14.0.6"}
!59 = distinct !DISubprogram(name: "assume_abort_if_not", scope: !7, file: !7, line: 2, type: !60, scopeLine: 2, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!60 = !DISubroutineType(types: !61)
!61 = !{null, !8}
!62 = !{}
!63 = !DILocalVariable(name: "cond", arg: 1, scope: !59, file: !7, line: 2, type: !8)
!64 = !DILocation(line: 0, scope: !59)
!65 = !DILocation(line: 3, column: 7, scope: !66)
!66 = distinct !DILexicalBlock(scope: !59, file: !7, line: 3, column: 6)
!67 = !DILocation(line: 3, column: 6, scope: !59)
!68 = !DILocation(line: 3, column: 14, scope: !69)
!69 = distinct !DILexicalBlock(scope: !66, file: !7, line: 3, column: 13)
!70 = !DILocation(line: 4, column: 1, scope: !59)
!71 = distinct !DISubprogram(name: "reach_error", scope: !7, file: !7, line: 16, type: !72, scopeLine: 16, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!72 = !DISubroutineType(types: !73)
!73 = !{null}
!74 = !DILocation(line: 16, column: 83, scope: !75)
!75 = distinct !DILexicalBlock(scope: !76, file: !7, line: 16, column: 73)
!76 = distinct !DILexicalBlock(scope: !71, file: !7, line: 16, column: 67)
!77 = distinct !DISubprogram(name: "__VERIFIER_atomic_use1", scope: !7, file: !7, line: 693, type: !60, scopeLine: 693, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!78 = !DILocalVariable(name: "myidx", arg: 1, scope: !77, file: !7, line: 693, type: !8)
!79 = !DILocation(line: 0, scope: !77)
!80 = !DILocation(line: 694, column: 29, scope: !77)
!81 = !DILocation(line: 694, column: 34, scope: !77)
!82 = !DILocation(line: 694, column: 3, scope: !77)
!83 = !DILocation(line: 695, column: 7, scope: !77)
!84 = !DILocation(line: 696, column: 1, scope: !77)
!85 = distinct !DISubprogram(name: "__VERIFIER_atomic_use2", scope: !7, file: !7, line: 697, type: !60, scopeLine: 697, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!86 = !DILocalVariable(name: "myidx", arg: 1, scope: !85, file: !7, line: 697, type: !8)
!87 = !DILocation(line: 0, scope: !85)
!88 = !DILocation(line: 698, column: 29, scope: !85)
!89 = !DILocation(line: 698, column: 34, scope: !85)
!90 = !DILocation(line: 698, column: 3, scope: !85)
!91 = !DILocation(line: 699, column: 7, scope: !85)
!92 = !DILocation(line: 700, column: 1, scope: !85)
!93 = distinct !DISubprogram(name: "__VERIFIER_atomic_use_done", scope: !7, file: !7, line: 701, type: !60, scopeLine: 701, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!94 = !DILocalVariable(name: "myidx", arg: 1, scope: !93, file: !7, line: 701, type: !8)
!95 = !DILocation(line: 0, scope: !93)
!96 = !DILocation(line: 702, column: 13, scope: !97)
!97 = distinct !DILexicalBlock(scope: !93, file: !7, line: 702, column: 7)
!98 = !DILocation(line: 702, column: 7, scope: !93)
!99 = !DILocation(line: 702, column: 25, scope: !100)
!100 = distinct !DILexicalBlock(scope: !97, file: !7, line: 702, column: 19)
!101 = !DILocation(line: 702, column: 29, scope: !100)
!102 = !DILocation(line: 703, column: 14, scope: !103)
!103 = distinct !DILexicalBlock(scope: !97, file: !7, line: 703, column: 8)
!104 = !DILocation(line: 704, column: 1, scope: !93)
!105 = distinct !DISubprogram(name: "__VERIFIER_atomic_take_snapshot", scope: !7, file: !7, line: 705, type: !106, scopeLine: 705, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!106 = !DISubroutineType(types: !107)
!107 = !{null, !8, !8}
!108 = !DILocalVariable(name: "readerstart1", arg: 1, scope: !105, file: !7, line: 705, type: !8)
!109 = !DILocation(line: 0, scope: !105)
!110 = !DILocalVariable(name: "readerstart2", arg: 2, scope: !105, file: !7, line: 705, type: !8)
!111 = !DILocation(line: 708, column: 1, scope: !105)
!112 = distinct !DISubprogram(name: "__VERIFIER_atomic_check_progress1", scope: !7, file: !7, line: 709, type: !60, scopeLine: 709, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!113 = !DILocalVariable(name: "readerstart1", arg: 1, scope: !112, file: !7, line: 709, type: !8)
!114 = !DILocation(line: 0, scope: !112)
!115 = !DILocation(line: 710, column: 7, scope: !116)
!116 = distinct !DILexicalBlock(scope: !112, file: !7, line: 710, column: 7)
!117 = !DILocation(line: 710, column: 7, scope: !112)
!118 = !DILocation(line: 711, column: 38, scope: !119)
!119 = distinct !DILexicalBlock(scope: !116, file: !7, line: 710, column: 32)
!120 = !DILocation(line: 711, column: 43, scope: !119)
!121 = !DILocation(line: 711, column: 5, scope: !119)
!122 = !DILabel(scope: !123, name: "ERROR", file: !7, line: 712)
!123 = distinct !DILexicalBlock(scope: !119, file: !7, line: 712, column: 9)
!124 = !DILocation(line: 712, column: 15, scope: !123)
!125 = !DILocation(line: 712, column: 23, scope: !126)
!126 = distinct !DILexicalBlock(scope: !123, file: !7, line: 712, column: 22)
!127 = !DILocation(line: 712, column: 37, scope: !126)
!128 = !DILocation(line: 714, column: 3, scope: !112)
!129 = distinct !DISubprogram(name: "__VERIFIER_atomic_check_progress2", scope: !7, file: !7, line: 716, type: !60, scopeLine: 716, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!130 = !DILocalVariable(name: "readerstart2", arg: 1, scope: !129, file: !7, line: 716, type: !8)
!131 = !DILocation(line: 0, scope: !129)
!132 = !DILocation(line: 717, column: 7, scope: !133)
!133 = distinct !DILexicalBlock(scope: !129, file: !7, line: 717, column: 7)
!134 = !DILocation(line: 717, column: 7, scope: !129)
!135 = !DILocation(line: 718, column: 38, scope: !136)
!136 = distinct !DILexicalBlock(scope: !133, file: !7, line: 717, column: 32)
!137 = !DILocation(line: 718, column: 43, scope: !136)
!138 = !DILocation(line: 718, column: 5, scope: !136)
!139 = !DILabel(scope: !140, name: "ERROR", file: !7, line: 719)
!140 = distinct !DILexicalBlock(scope: !136, file: !7, line: 719, column: 9)
!141 = !DILocation(line: 719, column: 15, scope: !140)
!142 = !DILocation(line: 719, column: 23, scope: !143)
!143 = distinct !DILexicalBlock(scope: !140, file: !7, line: 719, column: 22)
!144 = !DILocation(line: 719, column: 37, scope: !143)
!145 = !DILocation(line: 721, column: 3, scope: !129)
!146 = distinct !DISubprogram(name: "qrcu_reader1", scope: !7, file: !7, line: 723, type: !147, scopeLine: 723, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!147 = !DISubroutineType(types: !148)
!148 = !{!149, !149}
!149 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!150 = !DILocalVariable(name: "arg", arg: 1, scope: !146, file: !7, line: 723, type: !149)
!151 = !DILocation(line: 0, scope: !146)
!152 = !DILocation(line: 725, column: 3, scope: !146)
!153 = !DILocation(line: 726, column: 13, scope: !154)
!154 = distinct !DILexicalBlock(scope: !146, file: !7, line: 725, column: 13)
!155 = !DILocalVariable(name: "myidx", scope: !146, file: !7, line: 724, type: !8)
!156 = !DILocation(line: 727, column: 9, scope: !157)
!157 = distinct !DILexicalBlock(scope: !154, file: !7, line: 727, column: 9)
!158 = !DILocation(line: 727, column: 9, scope: !154)
!159 = !DILocation(line: 728, column: 7, scope: !160)
!160 = distinct !DILexicalBlock(scope: !157, file: !7, line: 727, column: 34)
!161 = !DILocation(line: 729, column: 7, scope: !160)
!162 = !DILocation(line: 731, column: 11, scope: !163)
!163 = distinct !DILexicalBlock(scope: !164, file: !7, line: 731, column: 11)
!164 = distinct !DILexicalBlock(scope: !157, file: !7, line: 730, column: 12)
!165 = !DILocation(line: 731, column: 11, scope: !164)
!166 = distinct !{!166, !152, !167}
!167 = !DILocation(line: 736, column: 3, scope: !146)
!168 = !DILocation(line: 732, column: 2, scope: !169)
!169 = distinct !DILexicalBlock(scope: !163, file: !7, line: 731, column: 36)
!170 = !DILocation(line: 733, column: 2, scope: !169)
!171 = !DILocation(line: 738, column: 19, scope: !146)
!172 = !DILocation(line: 739, column: 3, scope: !146)
!173 = !DILocation(line: 740, column: 3, scope: !146)
!174 = distinct !DISubprogram(name: "qrcu_reader2", scope: !7, file: !7, line: 742, type: !147, scopeLine: 742, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!175 = !DILocalVariable(name: "arg", arg: 1, scope: !174, file: !7, line: 742, type: !149)
!176 = !DILocation(line: 0, scope: !174)
!177 = !DILocation(line: 744, column: 3, scope: !174)
!178 = !DILocation(line: 745, column: 13, scope: !179)
!179 = distinct !DILexicalBlock(scope: !174, file: !7, line: 744, column: 13)
!180 = !DILocalVariable(name: "myidx", scope: !174, file: !7, line: 743, type: !8)
!181 = !DILocation(line: 746, column: 9, scope: !182)
!182 = distinct !DILexicalBlock(scope: !179, file: !7, line: 746, column: 9)
!183 = !DILocation(line: 746, column: 9, scope: !179)
!184 = !DILocation(line: 747, column: 7, scope: !185)
!185 = distinct !DILexicalBlock(scope: !182, file: !7, line: 746, column: 34)
!186 = !DILocation(line: 748, column: 7, scope: !185)
!187 = !DILocation(line: 750, column: 11, scope: !188)
!188 = distinct !DILexicalBlock(scope: !189, file: !7, line: 750, column: 11)
!189 = distinct !DILexicalBlock(scope: !182, file: !7, line: 749, column: 12)
!190 = !DILocation(line: 750, column: 11, scope: !189)
!191 = distinct !{!191, !177, !192}
!192 = !DILocation(line: 755, column: 3, scope: !174)
!193 = !DILocation(line: 751, column: 2, scope: !194)
!194 = distinct !DILexicalBlock(scope: !188, file: !7, line: 750, column: 36)
!195 = !DILocation(line: 752, column: 2, scope: !194)
!196 = !DILocation(line: 757, column: 19, scope: !174)
!197 = !DILocation(line: 758, column: 3, scope: !174)
!198 = !DILocation(line: 759, column: 3, scope: !174)
!199 = distinct !DISubprogram(name: "qrcu_updater", scope: !7, file: !7, line: 761, type: !147, scopeLine: 761, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!200 = !DILocalVariable(name: "arg", arg: 1, scope: !199, file: !7, line: 761, type: !149)
!201 = !DILocation(line: 0, scope: !199)
!202 = !DILocalVariable(name: "i", scope: !199, file: !7, line: 762, type: !8)
!203 = !DILocation(line: 762, column: 7, scope: !199)
!204 = !DILocation(line: 763, column: 20, scope: !199)
!205 = !DILocalVariable(name: "readerstart1", scope: !199, file: !7, line: 763, type: !8)
!206 = !DILocation(line: 763, column: 58, scope: !199)
!207 = !DILocalVariable(name: "readerstart2", scope: !199, file: !7, line: 763, type: !8)
!208 = !DILocation(line: 765, column: 3, scope: !199)
!209 = !DILocation(line: 766, column: 7, scope: !210)
!210 = distinct !DILexicalBlock(scope: !199, file: !7, line: 766, column: 7)
!211 = !DILocation(line: 766, column: 7, scope: !199)
!212 = !DILocation(line: 766, column: 40, scope: !213)
!213 = distinct !DILexicalBlock(scope: !210, file: !7, line: 766, column: 32)
!214 = !DILocalVariable(name: "sum", scope: !199, file: !7, line: 764, type: !8)
!215 = !DILocation(line: 766, column: 58, scope: !213)
!216 = !DILocation(line: 766, column: 56, scope: !213)
!217 = !DILocation(line: 766, column: 64, scope: !213)
!218 = !DILocation(line: 766, column: 79, scope: !219)
!219 = distinct !DILexicalBlock(scope: !210, file: !7, line: 766, column: 71)
!220 = !DILocation(line: 766, column: 97, scope: !219)
!221 = !DILocation(line: 766, column: 95, scope: !219)
!222 = !DILocation(line: 0, scope: !210)
!223 = !DILocation(line: 767, column: 11, scope: !224)
!224 = distinct !DILexicalBlock(scope: !199, file: !7, line: 767, column: 7)
!225 = !DILocation(line: 767, column: 7, scope: !199)
!226 = !DILocation(line: 767, column: 23, scope: !227)
!227 = distinct !DILexicalBlock(scope: !228, file: !7, line: 767, column: 23)
!228 = distinct !DILexicalBlock(scope: !224, file: !7, line: 767, column: 17)
!229 = !DILocation(line: 767, column: 23, scope: !228)
!230 = !DILocation(line: 767, column: 56, scope: !231)
!231 = distinct !DILexicalBlock(scope: !227, file: !7, line: 767, column: 48)
!232 = !DILocation(line: 767, column: 74, scope: !231)
!233 = !DILocation(line: 767, column: 72, scope: !231)
!234 = !DILocation(line: 767, column: 80, scope: !231)
!235 = !DILocation(line: 767, column: 95, scope: !236)
!236 = distinct !DILexicalBlock(scope: !227, file: !7, line: 767, column: 87)
!237 = !DILocation(line: 767, column: 113, scope: !236)
!238 = !DILocation(line: 767, column: 111, scope: !236)
!239 = !DILocation(line: 769, column: 11, scope: !240)
!240 = distinct !DILexicalBlock(scope: !199, file: !7, line: 769, column: 7)
!241 = !DILocation(line: 769, column: 7, scope: !199)
!242 = !DILocation(line: 770, column: 5, scope: !243)
!243 = distinct !DILexicalBlock(scope: !240, file: !7, line: 769, column: 16)
!244 = !DILocation(line: 771, column: 9, scope: !245)
!245 = distinct !DILexicalBlock(scope: !243, file: !7, line: 771, column: 9)
!246 = !DILocation(line: 771, column: 13, scope: !245)
!247 = !DILocation(line: 771, column: 9, scope: !243)
!248 = !DILocation(line: 771, column: 25, scope: !249)
!249 = distinct !DILexicalBlock(scope: !245, file: !7, line: 771, column: 19)
!250 = !DILocation(line: 771, column: 33, scope: !249)
!251 = !DILocation(line: 771, column: 42, scope: !249)
!252 = !DILocation(line: 771, column: 46, scope: !249)
!253 = !DILocation(line: 772, column: 16, scope: !254)
!254 = distinct !DILexicalBlock(scope: !245, file: !7, line: 772, column: 10)
!255 = !DILocation(line: 772, column: 24, scope: !254)
!256 = !DILocation(line: 772, column: 33, scope: !254)
!257 = !DILocation(line: 773, column: 9, scope: !243)
!258 = !DILocation(line: 773, column: 33, scope: !259)
!259 = distinct !DILexicalBlock(scope: !260, file: !7, line: 773, column: 19)
!260 = distinct !DILexicalBlock(scope: !243, file: !7, line: 773, column: 9)
!261 = !DILocation(line: 773, column: 21, scope: !259)
!262 = distinct !{!262, !261, !263, !264}
!263 = !DILocation(line: 773, column: 37, scope: !259)
!264 = !{!"llvm.loop.mustprogress"}
!265 = !DILocation(line: 774, column: 24, scope: !266)
!266 = distinct !DILexicalBlock(scope: !260, file: !7, line: 774, column: 10)
!267 = !DILocation(line: 774, column: 12, scope: !266)
!268 = distinct !{!268, !267, !269, !264}
!269 = !DILocation(line: 774, column: 28, scope: !266)
!270 = !DILocation(line: 775, column: 5, scope: !243)
!271 = !DILocation(line: 776, column: 3, scope: !243)
!272 = !DILocation(line: 777, column: 3, scope: !199)
!273 = !DILocation(line: 778, column: 3, scope: !199)
!274 = !DILocation(line: 779, column: 3, scope: !199)
!275 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 781, type: !276, scopeLine: 781, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!276 = !DISubroutineType(types: !277)
!277 = !{!8}
!278 = !DILocation(line: 783, column: 3, scope: !275)
!279 = !DILocalVariable(name: "t1", scope: !275, file: !7, line: 782, type: !280)
!280 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !7, line: 285, baseType: !281)
!281 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!282 = !DILocation(line: 0, scope: !275)
!283 = !DILocation(line: 784, column: 3, scope: !275)
!284 = !DILocalVariable(name: "t2", scope: !275, file: !7, line: 782, type: !280)
!285 = !DILocation(line: 785, column: 3, scope: !275)
!286 = !DILocalVariable(name: "t3", scope: !275, file: !7, line: 782, type: !280)
!287 = !DILocation(line: 786, column: 3, scope: !275)
!288 = !DILocation(line: 787, column: 16, scope: !275)
!289 = !DILocation(line: 787, column: 3, scope: !275)
!290 = !DILocation(line: 788, column: 16, scope: !275)
!291 = !DILocation(line: 788, column: 3, scope: !275)
!292 = !DILocation(line: 789, column: 16, scope: !275)
!293 = !DILocation(line: 789, column: 3, scope: !275)
!294 = !DILocation(line: 790, column: 3, scope: !275)
!295 = !DILocation(line: 791, column: 3, scope: !275)
