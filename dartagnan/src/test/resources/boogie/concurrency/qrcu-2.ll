; ModuleID = '/home/ponce/git/Dat3M/output/qrcu-2.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-atomic/qrcu-2.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { %struct.__pthread_internal_list*, %struct.__pthread_internal_list* }
%union.pthread_mutexattr_t = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [65 x i8] c"/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-atomic/qrcu-2.c\00", align 1
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1
@idx = dso_local global i32 0, align 4, !dbg !0
@ctr1 = dso_local global i32 1, align 4, !dbg !5
@ctr2 = dso_local global i32 0, align 4, !dbg !9
@readerprogress1 = dso_local global i32 0, align 4, !dbg !11
@readerprogress2 = dso_local global i32 0, align 4, !dbg !13
@mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !15

; Function Attrs: noinline nounwind uwtable
define dso_local void @assume_abort_if_not(i32 noundef %0) #0 !dbg !57 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !61, metadata !DIExpression()), !dbg !62
  %2 = icmp ne i32 %0, 0, !dbg !63
  br i1 %2, label %4, label %3, !dbg !65

3:                                                ; preds = %1
  call void @abort() #6, !dbg !66
  unreachable, !dbg !66

4:                                                ; preds = %1
  ret void, !dbg !68
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noreturn
declare void @abort() #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !69 {
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.1, i64 0, i64 0), i32 noundef 7, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #7, !dbg !72
  unreachable, !dbg !72
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_atomic_use1(i32 noundef %0) #0 !dbg !75 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !76, metadata !DIExpression()), !dbg !77
  %2 = icmp sle i32 %0, 0, !dbg !78
  br i1 %2, label %3, label %6, !dbg !79

3:                                                ; preds = %1
  %4 = load i32, i32* @ctr1, align 4, !dbg !80
  %5 = icmp sgt i32 %4, 0, !dbg !81
  br label %6

6:                                                ; preds = %3, %1
  %7 = phi i1 [ false, %1 ], [ %5, %3 ], !dbg !77
  %8 = zext i1 %7 to i32, !dbg !79
  call void @assume_abort_if_not(i32 noundef %8), !dbg !82
  %9 = load i32, i32* @ctr1, align 4, !dbg !83
  %10 = add nsw i32 %9, 1, !dbg !83
  store i32 %10, i32* @ctr1, align 4, !dbg !83
  ret void, !dbg !84
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_atomic_use2(i32 noundef %0) #0 !dbg !85 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !86, metadata !DIExpression()), !dbg !87
  %2 = icmp sge i32 %0, 1, !dbg !88
  br i1 %2, label %3, label %6, !dbg !89

3:                                                ; preds = %1
  %4 = load i32, i32* @ctr2, align 4, !dbg !90
  %5 = icmp sgt i32 %4, 0, !dbg !91
  br label %6

6:                                                ; preds = %3, %1
  %7 = phi i1 [ false, %1 ], [ %5, %3 ], !dbg !87
  %8 = zext i1 %7 to i32, !dbg !89
  call void @assume_abort_if_not(i32 noundef %8), !dbg !92
  %9 = load i32, i32* @ctr2, align 4, !dbg !93
  %10 = add nsw i32 %9, 1, !dbg !93
  store i32 %10, i32* @ctr2, align 4, !dbg !93
  ret void, !dbg !94
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_atomic_use_done(i32 noundef %0) #0 !dbg !95 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !96, metadata !DIExpression()), !dbg !97
  %2 = icmp sle i32 %0, 0, !dbg !98
  br i1 %2, label %3, label %6, !dbg !100

3:                                                ; preds = %1
  %4 = load i32, i32* @ctr1, align 4, !dbg !101
  %5 = add nsw i32 %4, -1, !dbg !101
  store i32 %5, i32* @ctr1, align 4, !dbg !101
  br label %9, !dbg !103

6:                                                ; preds = %1
  %7 = load i32, i32* @ctr2, align 4, !dbg !104
  %8 = add nsw i32 %7, -1, !dbg !104
  store i32 %8, i32* @ctr2, align 4, !dbg !104
  br label %9

9:                                                ; preds = %6, %3
  ret void, !dbg !106
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_atomic_take_snapshot(i32 noundef %0, i32 noundef %1) #0 !dbg !107 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !110, metadata !DIExpression()), !dbg !111
  call void @llvm.dbg.value(metadata i32 %1, metadata !112, metadata !DIExpression()), !dbg !111
  %3 = load i32, i32* @readerprogress1, align 4, !dbg !113
  call void @llvm.dbg.value(metadata i32 %3, metadata !110, metadata !DIExpression()), !dbg !111
  %4 = load i32, i32* @readerprogress2, align 4, !dbg !114
  call void @llvm.dbg.value(metadata i32 %4, metadata !112, metadata !DIExpression()), !dbg !111
  ret void, !dbg !115
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_atomic_check_progress1(i32 noundef %0) #0 !dbg !116 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !117, metadata !DIExpression()), !dbg !118
  %2 = call i32 (...) @__VERIFIER_nondet_int(), !dbg !119
  %3 = icmp ne i32 %2, 0, !dbg !119
  br i1 %3, label %4, label %13, !dbg !121

4:                                                ; preds = %1
  %5 = icmp eq i32 %0, 1, !dbg !122
  br i1 %5, label %6, label %9, !dbg !124

6:                                                ; preds = %4
  %7 = load i32, i32* @readerprogress1, align 4, !dbg !125
  %8 = icmp eq i32 %7, 1, !dbg !126
  br label %9

9:                                                ; preds = %6, %4
  %10 = phi i1 [ false, %4 ], [ %8, %6 ], !dbg !127
  %11 = zext i1 %10 to i32, !dbg !124
  call void @assume_abort_if_not(i32 noundef %11), !dbg !128
  br label %12, !dbg !129

12:                                               ; preds = %9
  call void @llvm.dbg.label(metadata !130), !dbg !132
  call void @reach_error(), !dbg !132
  br label %13, !dbg !133

13:                                               ; preds = %12, %1
  ret void, !dbg !134
}

declare i32 @__VERIFIER_nondet_int(...) #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_atomic_check_progress2(i32 noundef %0) #0 !dbg !135 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !136, metadata !DIExpression()), !dbg !137
  %2 = call i32 (...) @__VERIFIER_nondet_int(), !dbg !138
  %3 = icmp ne i32 %2, 0, !dbg !138
  br i1 %3, label %4, label %13, !dbg !140

4:                                                ; preds = %1
  %5 = icmp eq i32 %0, 1, !dbg !141
  br i1 %5, label %6, label %9, !dbg !143

6:                                                ; preds = %4
  %7 = load i32, i32* @readerprogress2, align 4, !dbg !144
  %8 = icmp eq i32 %7, 1, !dbg !145
  br label %9

9:                                                ; preds = %6, %4
  %10 = phi i1 [ false, %4 ], [ %8, %6 ], !dbg !146
  %11 = zext i1 %10 to i32, !dbg !143
  call void @assume_abort_if_not(i32 noundef %11), !dbg !147
  br label %12, !dbg !148

12:                                               ; preds = %9
  call void @llvm.dbg.label(metadata !149), !dbg !151
  call void @reach_error(), !dbg !151
  br label %13, !dbg !152

13:                                               ; preds = %12, %1
  ret void, !dbg !153
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @qrcu_reader1(i8* noundef %0) #0 !dbg !154 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !158, metadata !DIExpression()), !dbg !159
  br label %2, !dbg !160

2:                                                ; preds = %13, %1
  %3 = load i32, i32* @idx, align 4, !dbg !161
  call void @llvm.dbg.value(metadata i32 %3, metadata !163, metadata !DIExpression()), !dbg !159
  %4 = call i32 (...) @__VERIFIER_nondet_int(), !dbg !164
  %5 = icmp ne i32 %4, 0, !dbg !164
  br i1 %5, label %6, label %7, !dbg !166

6:                                                ; preds = %2
  call void @__VERIFIER_atomic_use1(i32 noundef %3), !dbg !167
  br label %14, !dbg !169

7:                                                ; preds = %2
  %8 = call i32 (...) @__VERIFIER_nondet_int(), !dbg !170
  %9 = icmp ne i32 %8, 0, !dbg !170
  br i1 %9, label %10, label %11, !dbg !173

10:                                               ; preds = %7
  call void @__VERIFIER_atomic_use2(i32 noundef %3), !dbg !174
  br label %14, !dbg !176

11:                                               ; preds = %7
  br label %12

12:                                               ; preds = %11
  br label %13

13:                                               ; preds = %12
  br label %2, !dbg !160, !llvm.loop !177

14:                                               ; preds = %10, %6
  store i32 1, i32* @readerprogress1, align 4, !dbg !179
  store i32 2, i32* @readerprogress1, align 4, !dbg !180
  call void @__VERIFIER_atomic_use_done(i32 noundef %3), !dbg !181
  ret i8* null, !dbg !182
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @qrcu_reader2(i8* noundef %0) #0 !dbg !183 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !184, metadata !DIExpression()), !dbg !185
  br label %2, !dbg !186

2:                                                ; preds = %13, %1
  %3 = load i32, i32* @idx, align 4, !dbg !187
  call void @llvm.dbg.value(metadata i32 %3, metadata !189, metadata !DIExpression()), !dbg !185
  %4 = call i32 (...) @__VERIFIER_nondet_int(), !dbg !190
  %5 = icmp ne i32 %4, 0, !dbg !190
  br i1 %5, label %6, label %7, !dbg !192

6:                                                ; preds = %2
  call void @__VERIFIER_atomic_use1(i32 noundef %3), !dbg !193
  br label %14, !dbg !195

7:                                                ; preds = %2
  %8 = call i32 (...) @__VERIFIER_nondet_int(), !dbg !196
  %9 = icmp ne i32 %8, 0, !dbg !196
  br i1 %9, label %10, label %11, !dbg !199

10:                                               ; preds = %7
  call void @__VERIFIER_atomic_use2(i32 noundef %3), !dbg !200
  br label %14, !dbg !202

11:                                               ; preds = %7
  br label %12

12:                                               ; preds = %11
  br label %13

13:                                               ; preds = %12
  br label %2, !dbg !186, !llvm.loop !203

14:                                               ; preds = %10, %6
  store i32 1, i32* @readerprogress2, align 4, !dbg !205
  store i32 2, i32* @readerprogress2, align 4, !dbg !206
  call void @__VERIFIER_atomic_use_done(i32 noundef %3), !dbg !207
  ret i8* null, !dbg !208
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @qrcu_updater(i8* noundef %0) #0 !dbg !209 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !210, metadata !DIExpression()), !dbg !211
  call void @llvm.dbg.declare(metadata i32* undef, metadata !212, metadata !DIExpression()), !dbg !213
  %2 = call i32 (...) @__VERIFIER_nondet_int(), !dbg !214
  call void @llvm.dbg.value(metadata i32 %2, metadata !215, metadata !DIExpression()), !dbg !211
  %3 = call i32 (...) @__VERIFIER_nondet_int(), !dbg !216
  call void @llvm.dbg.value(metadata i32 %3, metadata !217, metadata !DIExpression()), !dbg !211
  call void @__VERIFIER_atomic_take_snapshot(i32 noundef %2, i32 noundef %3), !dbg !218
  %4 = call i32 (...) @__VERIFIER_nondet_int(), !dbg !219
  %5 = icmp ne i32 %4, 0, !dbg !219
  br i1 %5, label %6, label %10, !dbg !221

6:                                                ; preds = %1
  %7 = load i32, i32* @ctr1, align 4, !dbg !222
  call void @llvm.dbg.value(metadata i32 %7, metadata !224, metadata !DIExpression()), !dbg !211
  %8 = load i32, i32* @ctr2, align 4, !dbg !222
  %9 = add nsw i32 %7, %8, !dbg !222
  call void @llvm.dbg.value(metadata i32 %9, metadata !224, metadata !DIExpression()), !dbg !211
  br label %14, !dbg !222

10:                                               ; preds = %1
  %11 = load i32, i32* @ctr2, align 4, !dbg !225
  call void @llvm.dbg.value(metadata i32 %11, metadata !224, metadata !DIExpression()), !dbg !211
  %12 = load i32, i32* @ctr1, align 4, !dbg !225
  %13 = add nsw i32 %11, %12, !dbg !225
  call void @llvm.dbg.value(metadata i32 %13, metadata !224, metadata !DIExpression()), !dbg !211
  br label %14

14:                                               ; preds = %10, %6
  %.0 = phi i32 [ %9, %6 ], [ %13, %10 ], !dbg !227
  call void @llvm.dbg.value(metadata i32 %.0, metadata !224, metadata !DIExpression()), !dbg !211
  %15 = icmp sle i32 %.0, 1, !dbg !228
  br i1 %15, label %16, label %28, !dbg !230

16:                                               ; preds = %14
  %17 = call i32 (...) @__VERIFIER_nondet_int(), !dbg !231
  %18 = icmp ne i32 %17, 0, !dbg !231
  br i1 %18, label %19, label %23, !dbg !234

19:                                               ; preds = %16
  %20 = load i32, i32* @ctr1, align 4, !dbg !235
  call void @llvm.dbg.value(metadata i32 %20, metadata !224, metadata !DIExpression()), !dbg !211
  %21 = load i32, i32* @ctr2, align 4, !dbg !235
  %22 = add nsw i32 %20, %21, !dbg !235
  call void @llvm.dbg.value(metadata i32 %22, metadata !224, metadata !DIExpression()), !dbg !211
  br label %27, !dbg !235

23:                                               ; preds = %16
  %24 = load i32, i32* @ctr2, align 4, !dbg !237
  call void @llvm.dbg.value(metadata i32 %24, metadata !224, metadata !DIExpression()), !dbg !211
  %25 = load i32, i32* @ctr1, align 4, !dbg !237
  %26 = add nsw i32 %24, %25, !dbg !237
  call void @llvm.dbg.value(metadata i32 %26, metadata !224, metadata !DIExpression()), !dbg !211
  br label %27

27:                                               ; preds = %23, %19
  %.1 = phi i32 [ %22, %19 ], [ %26, %23 ], !dbg !239
  call void @llvm.dbg.value(metadata i32 %.1, metadata !224, metadata !DIExpression()), !dbg !211
  br label %29, !dbg !240

28:                                               ; preds = %14
  br label %29

29:                                               ; preds = %28, %27
  %.2 = phi i32 [ %.1, %27 ], [ %.0, %28 ], !dbg !211
  call void @llvm.dbg.value(metadata i32 %.2, metadata !224, metadata !DIExpression()), !dbg !211
  %30 = icmp sgt i32 %.2, 1, !dbg !241
  br i1 %30, label %31, label %62, !dbg !243

31:                                               ; preds = %29
  %32 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef @mutex) #8, !dbg !244
  %33 = load i32, i32* @idx, align 4, !dbg !246
  %34 = icmp sle i32 %33, 0, !dbg !248
  br i1 %34, label %35, label %40, !dbg !249

35:                                               ; preds = %31
  %36 = load i32, i32* @ctr2, align 4, !dbg !250
  %37 = add nsw i32 %36, 1, !dbg !250
  store i32 %37, i32* @ctr2, align 4, !dbg !250
  store i32 1, i32* @idx, align 4, !dbg !252
  %38 = load i32, i32* @ctr1, align 4, !dbg !253
  %39 = add nsw i32 %38, -1, !dbg !253
  store i32 %39, i32* @ctr1, align 4, !dbg !253
  br label %45, !dbg !254

40:                                               ; preds = %31
  %41 = load i32, i32* @ctr1, align 4, !dbg !255
  %42 = add nsw i32 %41, 1, !dbg !255
  store i32 %42, i32* @ctr1, align 4, !dbg !255
  store i32 0, i32* @idx, align 4, !dbg !257
  %43 = load i32, i32* @ctr2, align 4, !dbg !258
  %44 = add nsw i32 %43, -1, !dbg !258
  store i32 %44, i32* @ctr2, align 4, !dbg !258
  br label %45

45:                                               ; preds = %40, %35
  %46 = load i32, i32* @idx, align 4, !dbg !259
  %47 = icmp sle i32 %46, 0, !dbg !261
  br i1 %47, label %48, label %54, !dbg !262

48:                                               ; preds = %45
  br label %49, !dbg !263

49:                                               ; preds = %52, %48
  %50 = load i32, i32* @ctr1, align 4, !dbg !265
  %51 = icmp sgt i32 %50, 0, !dbg !266
  br i1 %51, label %52, label %53, !dbg !263

52:                                               ; preds = %49
  br label %49, !dbg !263, !llvm.loop !267

53:                                               ; preds = %49
  br label %60, !dbg !270

54:                                               ; preds = %45
  br label %55, !dbg !271

55:                                               ; preds = %58, %54
  %56 = load i32, i32* @ctr2, align 4, !dbg !273
  %57 = icmp sgt i32 %56, 0, !dbg !274
  br i1 %57, label %58, label %59, !dbg !271

58:                                               ; preds = %55
  br label %55, !dbg !271, !llvm.loop !275

59:                                               ; preds = %55
  br label %60

60:                                               ; preds = %59, %53
  %61 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef @mutex) #8, !dbg !277
  br label %63, !dbg !278

62:                                               ; preds = %29
  br label %63

63:                                               ; preds = %62, %60
  call void @__VERIFIER_atomic_check_progress1(i32 noundef %2), !dbg !279
  call void @__VERIFIER_atomic_check_progress2(i32 noundef %3), !dbg !280
  ret i8* null, !dbg !281
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef) #5

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef) #5

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !282 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !285, metadata !DIExpression()), !dbg !288
  call void @llvm.dbg.declare(metadata i64* %2, metadata !289, metadata !DIExpression()), !dbg !290
  call void @llvm.dbg.declare(metadata i64* %3, metadata !291, metadata !DIExpression()), !dbg !292
  %4 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef @mutex, %union.pthread_mutexattr_t* noundef null) #8, !dbg !293
  %5 = call i32 @pthread_create(i64* noundef %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @qrcu_reader1, i8* noundef null) #8, !dbg !294
  %6 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @qrcu_reader2, i8* noundef null) #8, !dbg !295
  %7 = call i32 @pthread_create(i64* noundef %3, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @qrcu_updater, i8* noundef null) #8, !dbg !296
  %8 = load i64, i64* %1, align 8, !dbg !297
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !298
  %10 = load i64, i64* %2, align 8, !dbg !299
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !300
  %12 = load i64, i64* %3, align 8, !dbg !301
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !302
  %14 = call i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef @mutex) #8, !dbg !303
  ret i32 0, !dbg !304
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef, %union.pthread_mutexattr_t* noundef) #5

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #5

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: nounwind
declare i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef) #5

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { noreturn }
attributes #7 = { noreturn nounwind }
attributes #8 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!49, !50, !51, !52, !53, !54, !55}
!llvm.ident = !{!56}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "idx", scope: !2, file: !7, line: 22, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-atomic/qrcu-2.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "70ab70a8007f12717f2d9b2b1c3c8095")
!4 = !{!0, !5, !9, !11, !13, !15}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(name: "ctr1", scope: !2, file: !7, line: 25, type: !8, isLocal: false, isDefinition: true)
!7 = !DIFile(filename: "../sv-benchmarks/c/pthread-atomic/qrcu-2.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "70ab70a8007f12717f2d9b2b1c3c8095")
!8 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!9 = !DIGlobalVariableExpression(var: !10, expr: !DIExpression())
!10 = distinct !DIGlobalVariable(name: "ctr2", scope: !2, file: !7, line: 25, type: !8, isLocal: false, isDefinition: true)
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(name: "readerprogress1", scope: !2, file: !7, line: 26, type: !8, isLocal: false, isDefinition: true)
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(name: "readerprogress2", scope: !2, file: !7, line: 26, type: !8, isLocal: false, isDefinition: true)
!15 = !DIGlobalVariableExpression(var: !16, expr: !DIExpression())
!16 = distinct !DIGlobalVariable(name: "mutex", scope: !2, file: !7, line: 30, type: !17, isLocal: false, isDefinition: true)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !18, line: 72, baseType: !19)
!18 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!19 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !18, line: 67, size: 320, elements: !20)
!20 = !{!21, !42, !47}
!21 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !19, file: !18, line: 69, baseType: !22, size: 320)
!22 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !23, line: 22, size: 320, elements: !24)
!23 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "3a896f588055d599ccb9e3fe6eaee3e3")
!24 = !{!25, !26, !28, !29, !30, !31, !33, !34}
!25 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !22, file: !23, line: 24, baseType: !8, size: 32)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !22, file: !23, line: 25, baseType: !27, size: 32, offset: 32)
!27 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !22, file: !23, line: 26, baseType: !8, size: 32, offset: 64)
!29 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !22, file: !23, line: 28, baseType: !27, size: 32, offset: 96)
!30 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !22, file: !23, line: 32, baseType: !8, size: 32, offset: 128)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !22, file: !23, line: 34, baseType: !32, size: 16, offset: 160)
!32 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !22, file: !23, line: 35, baseType: !32, size: 16, offset: 176)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !22, file: !23, line: 36, baseType: !35, size: 128, offset: 192)
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !36, line: 53, baseType: !37)
!36 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "4b8899127613e00869e96fcefd314d61")
!37 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !36, line: 49, size: 128, elements: !38)
!38 = !{!39, !41}
!39 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !37, file: !36, line: 51, baseType: !40, size: 64)
!40 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !37, file: !36, line: 52, baseType: !40, size: 64, offset: 64)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !19, file: !18, line: 70, baseType: !43, size: 320)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !44, size: 320, elements: !45)
!44 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!45 = !{!46}
!46 = !DISubrange(count: 40)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !19, file: !18, line: 71, baseType: !48, size: 64)
!48 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!49 = !{i32 7, !"Dwarf Version", i32 5}
!50 = !{i32 2, !"Debug Info Version", i32 3}
!51 = !{i32 1, !"wchar_size", i32 4}
!52 = !{i32 7, !"PIC Level", i32 2}
!53 = !{i32 7, !"PIE Level", i32 2}
!54 = !{i32 7, !"uwtable", i32 1}
!55 = !{i32 7, !"frame-pointer", i32 2}
!56 = !{!"Ubuntu clang version 14.0.6"}
!57 = distinct !DISubprogram(name: "assume_abort_if_not", scope: !7, file: !7, line: 2, type: !58, scopeLine: 2, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!58 = !DISubroutineType(types: !59)
!59 = !{null, !8}
!60 = !{}
!61 = !DILocalVariable(name: "cond", arg: 1, scope: !57, file: !7, line: 2, type: !8)
!62 = !DILocation(line: 0, scope: !57)
!63 = !DILocation(line: 3, column: 7, scope: !64)
!64 = distinct !DILexicalBlock(scope: !57, file: !7, line: 3, column: 6)
!65 = !DILocation(line: 3, column: 6, scope: !57)
!66 = !DILocation(line: 3, column: 14, scope: !67)
!67 = distinct !DILexicalBlock(scope: !64, file: !7, line: 3, column: 13)
!68 = !DILocation(line: 4, column: 1, scope: !57)
!69 = distinct !DISubprogram(name: "reach_error", scope: !7, file: !7, line: 7, type: !70, scopeLine: 7, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!70 = !DISubroutineType(types: !71)
!71 = !{null}
!72 = !DILocation(line: 7, column: 22, scope: !73)
!73 = distinct !DILexicalBlock(scope: !74, file: !7, line: 7, column: 22)
!74 = distinct !DILexicalBlock(scope: !69, file: !7, line: 7, column: 22)
!75 = distinct !DISubprogram(name: "__VERIFIER_atomic_use1", scope: !7, file: !7, line: 42, type: !58, scopeLine: 42, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!76 = !DILocalVariable(name: "myidx", arg: 1, scope: !75, file: !7, line: 42, type: !8)
!77 = !DILocation(line: 0, scope: !75)
!78 = !DILocation(line: 43, column: 29, scope: !75)
!79 = !DILocation(line: 43, column: 34, scope: !75)
!80 = !DILocation(line: 43, column: 37, scope: !75)
!81 = !DILocation(line: 43, column: 41, scope: !75)
!82 = !DILocation(line: 43, column: 3, scope: !75)
!83 = !DILocation(line: 44, column: 7, scope: !75)
!84 = !DILocation(line: 45, column: 1, scope: !75)
!85 = distinct !DISubprogram(name: "__VERIFIER_atomic_use2", scope: !7, file: !7, line: 47, type: !58, scopeLine: 47, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!86 = !DILocalVariable(name: "myidx", arg: 1, scope: !85, file: !7, line: 47, type: !8)
!87 = !DILocation(line: 0, scope: !85)
!88 = !DILocation(line: 48, column: 29, scope: !85)
!89 = !DILocation(line: 48, column: 34, scope: !85)
!90 = !DILocation(line: 48, column: 37, scope: !85)
!91 = !DILocation(line: 48, column: 41, scope: !85)
!92 = !DILocation(line: 48, column: 3, scope: !85)
!93 = !DILocation(line: 49, column: 7, scope: !85)
!94 = !DILocation(line: 50, column: 1, scope: !85)
!95 = distinct !DISubprogram(name: "__VERIFIER_atomic_use_done", scope: !7, file: !7, line: 52, type: !58, scopeLine: 52, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!96 = !DILocalVariable(name: "myidx", arg: 1, scope: !95, file: !7, line: 52, type: !8)
!97 = !DILocation(line: 0, scope: !95)
!98 = !DILocation(line: 53, column: 13, scope: !99)
!99 = distinct !DILexicalBlock(scope: !95, file: !7, line: 53, column: 7)
!100 = !DILocation(line: 53, column: 7, scope: !95)
!101 = !DILocation(line: 53, column: 25, scope: !102)
!102 = distinct !DILexicalBlock(scope: !99, file: !7, line: 53, column: 19)
!103 = !DILocation(line: 53, column: 29, scope: !102)
!104 = !DILocation(line: 54, column: 14, scope: !105)
!105 = distinct !DILexicalBlock(scope: !99, file: !7, line: 54, column: 8)
!106 = !DILocation(line: 55, column: 1, scope: !95)
!107 = distinct !DISubprogram(name: "__VERIFIER_atomic_take_snapshot", scope: !7, file: !7, line: 57, type: !108, scopeLine: 57, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!108 = !DISubroutineType(types: !109)
!109 = !{null, !8, !8}
!110 = !DILocalVariable(name: "readerstart1", arg: 1, scope: !107, file: !7, line: 57, type: !8)
!111 = !DILocation(line: 0, scope: !107)
!112 = !DILocalVariable(name: "readerstart2", arg: 2, scope: !107, file: !7, line: 57, type: !8)
!113 = !DILocation(line: 59, column: 18, scope: !107)
!114 = !DILocation(line: 60, column: 18, scope: !107)
!115 = !DILocation(line: 61, column: 1, scope: !107)
!116 = distinct !DISubprogram(name: "__VERIFIER_atomic_check_progress1", scope: !7, file: !7, line: 63, type: !58, scopeLine: 63, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!117 = !DILocalVariable(name: "readerstart1", arg: 1, scope: !116, file: !7, line: 63, type: !8)
!118 = !DILocation(line: 0, scope: !116)
!119 = !DILocation(line: 65, column: 7, scope: !120)
!120 = distinct !DILexicalBlock(scope: !116, file: !7, line: 65, column: 7)
!121 = !DILocation(line: 65, column: 7, scope: !116)
!122 = !DILocation(line: 66, column: 38, scope: !123)
!123 = distinct !DILexicalBlock(scope: !120, file: !7, line: 65, column: 32)
!124 = !DILocation(line: 66, column: 43, scope: !123)
!125 = !DILocation(line: 66, column: 46, scope: !123)
!126 = !DILocation(line: 66, column: 62, scope: !123)
!127 = !DILocation(line: 0, scope: !123)
!128 = !DILocation(line: 66, column: 5, scope: !123)
!129 = !DILocation(line: 67, column: 5, scope: !123)
!130 = !DILabel(scope: !131, name: "ERROR", file: !7, line: 67)
!131 = distinct !DILexicalBlock(scope: !123, file: !7, line: 67, column: 5)
!132 = !DILocation(line: 67, column: 5, scope: !131)
!133 = !DILocation(line: 68, column: 3, scope: !123)
!134 = !DILocation(line: 69, column: 3, scope: !116)
!135 = distinct !DISubprogram(name: "__VERIFIER_atomic_check_progress2", scope: !7, file: !7, line: 72, type: !58, scopeLine: 72, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!136 = !DILocalVariable(name: "readerstart2", arg: 1, scope: !135, file: !7, line: 72, type: !8)
!137 = !DILocation(line: 0, scope: !135)
!138 = !DILocation(line: 73, column: 7, scope: !139)
!139 = distinct !DILexicalBlock(scope: !135, file: !7, line: 73, column: 7)
!140 = !DILocation(line: 73, column: 7, scope: !135)
!141 = !DILocation(line: 74, column: 38, scope: !142)
!142 = distinct !DILexicalBlock(scope: !139, file: !7, line: 73, column: 32)
!143 = !DILocation(line: 74, column: 43, scope: !142)
!144 = !DILocation(line: 74, column: 46, scope: !142)
!145 = !DILocation(line: 74, column: 62, scope: !142)
!146 = !DILocation(line: 0, scope: !142)
!147 = !DILocation(line: 74, column: 5, scope: !142)
!148 = !DILocation(line: 75, column: 5, scope: !142)
!149 = !DILabel(scope: !150, name: "ERROR", file: !7, line: 75)
!150 = distinct !DILexicalBlock(scope: !142, file: !7, line: 75, column: 5)
!151 = !DILocation(line: 75, column: 5, scope: !150)
!152 = !DILocation(line: 76, column: 3, scope: !142)
!153 = !DILocation(line: 77, column: 3, scope: !135)
!154 = distinct !DISubprogram(name: "qrcu_reader1", scope: !7, file: !7, line: 80, type: !155, scopeLine: 80, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!155 = !DISubroutineType(types: !156)
!156 = !{!157, !157}
!157 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!158 = !DILocalVariable(name: "arg", arg: 1, scope: !154, file: !7, line: 80, type: !157)
!159 = !DILocation(line: 0, scope: !154)
!160 = !DILocation(line: 83, column: 3, scope: !154)
!161 = !DILocation(line: 84, column: 13, scope: !162)
!162 = distinct !DILexicalBlock(scope: !154, file: !7, line: 83, column: 13)
!163 = !DILocalVariable(name: "myidx", scope: !154, file: !7, line: 81, type: !8)
!164 = !DILocation(line: 85, column: 9, scope: !165)
!165 = distinct !DILexicalBlock(scope: !162, file: !7, line: 85, column: 9)
!166 = !DILocation(line: 85, column: 9, scope: !162)
!167 = !DILocation(line: 86, column: 7, scope: !168)
!168 = distinct !DILexicalBlock(scope: !165, file: !7, line: 85, column: 34)
!169 = !DILocation(line: 87, column: 7, scope: !168)
!170 = !DILocation(line: 89, column: 11, scope: !171)
!171 = distinct !DILexicalBlock(scope: !172, file: !7, line: 89, column: 11)
!172 = distinct !DILexicalBlock(scope: !165, file: !7, line: 88, column: 12)
!173 = !DILocation(line: 89, column: 11, scope: !172)
!174 = !DILocation(line: 90, column: 2, scope: !175)
!175 = distinct !DILexicalBlock(scope: !171, file: !7, line: 89, column: 36)
!176 = !DILocation(line: 91, column: 2, scope: !175)
!177 = distinct !{!177, !160, !178}
!178 = !DILocation(line: 94, column: 3, scope: !154)
!179 = !DILocation(line: 95, column: 19, scope: !154)
!180 = !DILocation(line: 96, column: 19, scope: !154)
!181 = !DILocation(line: 98, column: 3, scope: !154)
!182 = !DILocation(line: 99, column: 3, scope: !154)
!183 = distinct !DISubprogram(name: "qrcu_reader2", scope: !7, file: !7, line: 102, type: !155, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!184 = !DILocalVariable(name: "arg", arg: 1, scope: !183, file: !7, line: 102, type: !157)
!185 = !DILocation(line: 0, scope: !183)
!186 = !DILocation(line: 105, column: 3, scope: !183)
!187 = !DILocation(line: 106, column: 13, scope: !188)
!188 = distinct !DILexicalBlock(scope: !183, file: !7, line: 105, column: 13)
!189 = !DILocalVariable(name: "myidx", scope: !183, file: !7, line: 103, type: !8)
!190 = !DILocation(line: 107, column: 9, scope: !191)
!191 = distinct !DILexicalBlock(scope: !188, file: !7, line: 107, column: 9)
!192 = !DILocation(line: 107, column: 9, scope: !188)
!193 = !DILocation(line: 108, column: 7, scope: !194)
!194 = distinct !DILexicalBlock(scope: !191, file: !7, line: 107, column: 34)
!195 = !DILocation(line: 109, column: 7, scope: !194)
!196 = !DILocation(line: 111, column: 11, scope: !197)
!197 = distinct !DILexicalBlock(scope: !198, file: !7, line: 111, column: 11)
!198 = distinct !DILexicalBlock(scope: !191, file: !7, line: 110, column: 12)
!199 = !DILocation(line: 111, column: 11, scope: !198)
!200 = !DILocation(line: 112, column: 2, scope: !201)
!201 = distinct !DILexicalBlock(scope: !197, file: !7, line: 111, column: 36)
!202 = !DILocation(line: 113, column: 2, scope: !201)
!203 = distinct !{!203, !186, !204}
!204 = !DILocation(line: 116, column: 3, scope: !183)
!205 = !DILocation(line: 117, column: 19, scope: !183)
!206 = !DILocation(line: 118, column: 19, scope: !183)
!207 = !DILocation(line: 120, column: 3, scope: !183)
!208 = !DILocation(line: 121, column: 3, scope: !183)
!209 = distinct !DISubprogram(name: "qrcu_updater", scope: !7, file: !7, line: 124, type: !155, scopeLine: 124, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!210 = !DILocalVariable(name: "arg", arg: 1, scope: !209, file: !7, line: 124, type: !157)
!211 = !DILocation(line: 0, scope: !209)
!212 = !DILocalVariable(name: "i", scope: !209, file: !7, line: 125, type: !8)
!213 = !DILocation(line: 125, column: 7, scope: !209)
!214 = !DILocation(line: 126, column: 20, scope: !209)
!215 = !DILocalVariable(name: "readerstart1", scope: !209, file: !7, line: 126, type: !8)
!216 = !DILocation(line: 126, column: 58, scope: !209)
!217 = !DILocalVariable(name: "readerstart2", scope: !209, file: !7, line: 126, type: !8)
!218 = !DILocation(line: 128, column: 3, scope: !209)
!219 = !DILocation(line: 129, column: 3, scope: !220)
!220 = distinct !DILexicalBlock(scope: !209, file: !7, line: 129, column: 3)
!221 = !DILocation(line: 129, column: 3, scope: !209)
!222 = !DILocation(line: 129, column: 3, scope: !223)
!223 = distinct !DILexicalBlock(scope: !220, file: !7, line: 129, column: 3)
!224 = !DILocalVariable(name: "sum", scope: !209, file: !7, line: 127, type: !8)
!225 = !DILocation(line: 129, column: 3, scope: !226)
!226 = distinct !DILexicalBlock(scope: !220, file: !7, line: 129, column: 3)
!227 = !DILocation(line: 0, scope: !220)
!228 = !DILocation(line: 130, column: 11, scope: !229)
!229 = distinct !DILexicalBlock(scope: !209, file: !7, line: 130, column: 7)
!230 = !DILocation(line: 130, column: 7, scope: !209)
!231 = !DILocation(line: 130, column: 19, scope: !232)
!232 = distinct !DILexicalBlock(scope: !233, file: !7, line: 130, column: 19)
!233 = distinct !DILexicalBlock(scope: !229, file: !7, line: 130, column: 17)
!234 = !DILocation(line: 130, column: 19, scope: !233)
!235 = !DILocation(line: 130, column: 19, scope: !236)
!236 = distinct !DILexicalBlock(scope: !232, file: !7, line: 130, column: 19)
!237 = !DILocation(line: 130, column: 19, scope: !238)
!238 = distinct !DILexicalBlock(scope: !232, file: !7, line: 130, column: 19)
!239 = !DILocation(line: 0, scope: !232)
!240 = !DILocation(line: 130, column: 34, scope: !233)
!241 = !DILocation(line: 132, column: 11, scope: !242)
!242 = distinct !DILexicalBlock(scope: !209, file: !7, line: 132, column: 7)
!243 = !DILocation(line: 132, column: 7, scope: !209)
!244 = !DILocation(line: 133, column: 5, scope: !245)
!245 = distinct !DILexicalBlock(scope: !242, file: !7, line: 132, column: 16)
!246 = !DILocation(line: 134, column: 9, scope: !247)
!247 = distinct !DILexicalBlock(scope: !245, file: !7, line: 134, column: 9)
!248 = !DILocation(line: 134, column: 13, scope: !247)
!249 = !DILocation(line: 134, column: 9, scope: !245)
!250 = !DILocation(line: 134, column: 25, scope: !251)
!251 = distinct !DILexicalBlock(scope: !247, file: !7, line: 134, column: 19)
!252 = !DILocation(line: 134, column: 33, scope: !251)
!253 = !DILocation(line: 134, column: 42, scope: !251)
!254 = !DILocation(line: 134, column: 46, scope: !251)
!255 = !DILocation(line: 135, column: 16, scope: !256)
!256 = distinct !DILexicalBlock(scope: !247, file: !7, line: 135, column: 10)
!257 = !DILocation(line: 135, column: 24, scope: !256)
!258 = !DILocation(line: 135, column: 33, scope: !256)
!259 = !DILocation(line: 136, column: 9, scope: !260)
!260 = distinct !DILexicalBlock(scope: !245, file: !7, line: 136, column: 9)
!261 = !DILocation(line: 136, column: 13, scope: !260)
!262 = !DILocation(line: 136, column: 9, scope: !245)
!263 = !DILocation(line: 136, column: 21, scope: !264)
!264 = distinct !DILexicalBlock(scope: !260, file: !7, line: 136, column: 19)
!265 = !DILocation(line: 136, column: 28, scope: !264)
!266 = !DILocation(line: 136, column: 33, scope: !264)
!267 = distinct !{!267, !263, !268, !269}
!268 = !DILocation(line: 136, column: 37, scope: !264)
!269 = !{!"llvm.loop.mustprogress"}
!270 = !DILocation(line: 136, column: 39, scope: !264)
!271 = !DILocation(line: 137, column: 12, scope: !272)
!272 = distinct !DILexicalBlock(scope: !260, file: !7, line: 137, column: 10)
!273 = !DILocation(line: 137, column: 19, scope: !272)
!274 = !DILocation(line: 137, column: 24, scope: !272)
!275 = distinct !{!275, !271, !276, !269}
!276 = !DILocation(line: 137, column: 28, scope: !272)
!277 = !DILocation(line: 138, column: 5, scope: !245)
!278 = !DILocation(line: 139, column: 3, scope: !245)
!279 = !DILocation(line: 140, column: 3, scope: !209)
!280 = !DILocation(line: 141, column: 3, scope: !209)
!281 = !DILocation(line: 142, column: 3, scope: !209)
!282 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 145, type: !283, scopeLine: 145, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!283 = !DISubroutineType(types: !284)
!284 = !{!8}
!285 = !DILocalVariable(name: "t1", scope: !282, file: !7, line: 146, type: !286)
!286 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !18, line: 27, baseType: !287)
!287 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!288 = !DILocation(line: 146, column: 13, scope: !282)
!289 = !DILocalVariable(name: "t2", scope: !282, file: !7, line: 146, type: !286)
!290 = !DILocation(line: 146, column: 17, scope: !282)
!291 = !DILocalVariable(name: "t3", scope: !282, file: !7, line: 146, type: !286)
!292 = !DILocation(line: 146, column: 21, scope: !282)
!293 = !DILocation(line: 147, column: 3, scope: !282)
!294 = !DILocation(line: 148, column: 3, scope: !282)
!295 = !DILocation(line: 149, column: 3, scope: !282)
!296 = !DILocation(line: 150, column: 3, scope: !282)
!297 = !DILocation(line: 151, column: 16, scope: !282)
!298 = !DILocation(line: 151, column: 3, scope: !282)
!299 = !DILocation(line: 152, column: 16, scope: !282)
!300 = !DILocation(line: 152, column: 3, scope: !282)
!301 = !DILocation(line: 153, column: 16, scope: !282)
!302 = !DILocation(line: 153, column: 3, scope: !282)
!303 = !DILocation(line: 154, column: 3, scope: !282)
!304 = !DILocation(line: 155, column: 3, scope: !282)
