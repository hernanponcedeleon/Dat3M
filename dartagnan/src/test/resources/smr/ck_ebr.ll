; ModuleID = 'ebr_test.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.ck_epoch = type { i32, i32, %struct.ck_stack }
%struct.ck_stack = type { %struct.ck_stack_entry*, i8* }
%struct.ck_stack_entry = type { %struct.ck_stack_entry* }
%struct.ck_epoch_record = type { %struct.ck_stack_entry, %struct.ck_epoch*, i32, i32, i32, %struct.anon, i32, i32, i32, i8*, [4 x %struct.ck_stack] }
%struct.anon = type { [2 x %struct.ck_epoch_ref] }
%struct.ck_epoch_ref = type { i32, i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }
%struct.ck_epoch_section = type { i32 }
%struct.ck_epoch_entry = type { void (%struct.ck_epoch_entry*)*, %struct.ck_stack_entry }

@stack_epoch = internal global %struct.ck_epoch zeroinitializer, align 8, !dbg !0
@records = dso_local global [4 x %struct.ck_epoch_record] zeroinitializer, align 16, !dbg !69
@.str = private unnamed_addr constant [41 x i8] c"!(local_epoch == 1 && global_epoch == 3)\00", align 1
@.str.1 = private unnamed_addr constant [14 x i8] c"client-code.c\00", align 1
@__PRETTY_FUNCTION__.thread = private unnamed_addr constant [21 x i8] c"void *thread(void *)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main(i32 %0, i8** %1) #0 !dbg !140 {
  %3 = alloca [4 x i64], align 16
  call void @llvm.dbg.value(metadata i32 %0, metadata !145, metadata !DIExpression()), !dbg !146
  call void @llvm.dbg.value(metadata i8** %1, metadata !147, metadata !DIExpression()), !dbg !146
  call void @llvm.dbg.declare(metadata [4 x i64]* %3, metadata !148, metadata !DIExpression()), !dbg !152
  call void @ck_epoch_init(%struct.ck_epoch* @stack_epoch), !dbg !153
  call void @__VERIFIER_loop_bound(i32 5), !dbg !154
  call void @llvm.dbg.value(metadata i32 0, metadata !155, metadata !DIExpression()), !dbg !157
  call void @llvm.dbg.value(metadata i64 0, metadata !155, metadata !DIExpression()), !dbg !157
  call void @ck_epoch_register(%struct.ck_epoch* @stack_epoch, %struct.ck_epoch_record* getelementptr inbounds ([4 x %struct.ck_epoch_record], [4 x %struct.ck_epoch_record]* @records, i64 0, i64 0), i8* null), !dbg !158
  %4 = getelementptr inbounds [4 x i64], [4 x i64]* %3, i64 0, i64 0, !dbg !161
  %5 = call i32 @pthread_create(i64* %4, %union.pthread_attr_t* null, i8* (i8*)* @thread, i8* bitcast ([4 x %struct.ck_epoch_record]* @records to i8*)) #6, !dbg !162
  call void @llvm.dbg.value(metadata i64 1, metadata !155, metadata !DIExpression()), !dbg !157
  call void @llvm.dbg.value(metadata i64 1, metadata !155, metadata !DIExpression()), !dbg !157
  call void @ck_epoch_register(%struct.ck_epoch* @stack_epoch, %struct.ck_epoch_record* getelementptr inbounds ([4 x %struct.ck_epoch_record], [4 x %struct.ck_epoch_record]* @records, i64 0, i64 1), i8* null), !dbg !158
  %6 = getelementptr inbounds [4 x i64], [4 x i64]* %3, i64 0, i64 1, !dbg !161
  %7 = call i32 @pthread_create(i64* %6, %union.pthread_attr_t* null, i8* (i8*)* @thread, i8* bitcast (%struct.ck_epoch_record* getelementptr inbounds ([4 x %struct.ck_epoch_record], [4 x %struct.ck_epoch_record]* @records, i64 0, i64 1) to i8*)) #6, !dbg !162
  call void @llvm.dbg.value(metadata i64 2, metadata !155, metadata !DIExpression()), !dbg !157
  call void @llvm.dbg.value(metadata i64 2, metadata !155, metadata !DIExpression()), !dbg !157
  call void @ck_epoch_register(%struct.ck_epoch* @stack_epoch, %struct.ck_epoch_record* getelementptr inbounds ([4 x %struct.ck_epoch_record], [4 x %struct.ck_epoch_record]* @records, i64 0, i64 2), i8* null), !dbg !158
  %8 = getelementptr inbounds [4 x i64], [4 x i64]* %3, i64 0, i64 2, !dbg !161
  %9 = call i32 @pthread_create(i64* %8, %union.pthread_attr_t* null, i8* (i8*)* @thread, i8* bitcast (%struct.ck_epoch_record* getelementptr inbounds ([4 x %struct.ck_epoch_record], [4 x %struct.ck_epoch_record]* @records, i64 0, i64 2) to i8*)) #6, !dbg !162
  call void @llvm.dbg.value(metadata i64 3, metadata !155, metadata !DIExpression()), !dbg !157
  call void @llvm.dbg.value(metadata i64 3, metadata !155, metadata !DIExpression()), !dbg !157
  call void @ck_epoch_register(%struct.ck_epoch* @stack_epoch, %struct.ck_epoch_record* getelementptr inbounds ([4 x %struct.ck_epoch_record], [4 x %struct.ck_epoch_record]* @records, i64 0, i64 3), i8* null), !dbg !158
  %10 = getelementptr inbounds [4 x i64], [4 x i64]* %3, i64 0, i64 3, !dbg !161
  %11 = call i32 @pthread_create(i64* %10, %union.pthread_attr_t* null, i8* (i8*)* @thread, i8* bitcast (%struct.ck_epoch_record* getelementptr inbounds ([4 x %struct.ck_epoch_record], [4 x %struct.ck_epoch_record]* @records, i64 0, i64 3) to i8*)) #6, !dbg !162
  call void @llvm.dbg.value(metadata i64 4, metadata !155, metadata !DIExpression()), !dbg !157
  call void @llvm.dbg.value(metadata i64 4, metadata !155, metadata !DIExpression()), !dbg !157
  call void @__VERIFIER_loop_bound(i32 5), !dbg !163
  call void @llvm.dbg.value(metadata i32 0, metadata !164, metadata !DIExpression()), !dbg !166
  call void @llvm.dbg.value(metadata i64 0, metadata !164, metadata !DIExpression()), !dbg !166
  %12 = load i64, i64* %4, align 8, !dbg !167
  %13 = call i32 @pthread_join(i64 %12, i8** null), !dbg !169
  call void @llvm.dbg.value(metadata i64 1, metadata !164, metadata !DIExpression()), !dbg !166
  call void @llvm.dbg.value(metadata i64 1, metadata !164, metadata !DIExpression()), !dbg !166
  %14 = load i64, i64* %6, align 8, !dbg !167
  %15 = call i32 @pthread_join(i64 %14, i8** null), !dbg !169
  call void @llvm.dbg.value(metadata i64 2, metadata !164, metadata !DIExpression()), !dbg !166
  call void @llvm.dbg.value(metadata i64 2, metadata !164, metadata !DIExpression()), !dbg !166
  %16 = load i64, i64* %8, align 8, !dbg !167
  %17 = call i32 @pthread_join(i64 %16, i8** null), !dbg !169
  call void @llvm.dbg.value(metadata i64 3, metadata !164, metadata !DIExpression()), !dbg !166
  call void @llvm.dbg.value(metadata i64 3, metadata !164, metadata !DIExpression()), !dbg !166
  %18 = load i64, i64* %10, align 8, !dbg !167
  %19 = call i32 @pthread_join(i64 %18, i8** null), !dbg !169
  call void @llvm.dbg.value(metadata i64 4, metadata !164, metadata !DIExpression()), !dbg !166
  call void @llvm.dbg.value(metadata i64 4, metadata !164, metadata !DIExpression()), !dbg !166
  ret i32 0, !dbg !170
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local void @__VERIFIER_loop_bound(i32) #2

; Function Attrs: noinline nounwind uwtable
define internal i8* @thread(i8* %0) #0 !dbg !171 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !174, metadata !DIExpression()), !dbg !175
  %2 = bitcast i8* %0 to %struct.ck_epoch_record*, !dbg !176
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %2, metadata !177, metadata !DIExpression()), !dbg !175
  call void @ck_epoch_begin(%struct.ck_epoch_record* %2, %struct.ck_epoch_section* null), !dbg !178
  %3 = load atomic i32, i32* getelementptr inbounds (%struct.ck_epoch, %struct.ck_epoch* @stack_epoch, i32 0, i32 0) monotonic, align 8, !dbg !179
  call void @llvm.dbg.value(metadata i32 %3, metadata !180, metadata !DIExpression()), !dbg !175
  %4 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %2, i32 0, i32 3, !dbg !181
  %5 = load atomic i32, i32* %4 monotonic, align 4, !dbg !181
  call void @llvm.dbg.value(metadata i32 %5, metadata !182, metadata !DIExpression()), !dbg !175
  %6 = call zeroext i1 @ck_epoch_end(%struct.ck_epoch_record* %2, %struct.ck_epoch_section* null), !dbg !183
  %7 = icmp eq i32 %5, 1, !dbg !184
  %8 = icmp eq i32 %3, 3, !dbg !184
  %or.cond = select i1 %7, i1 %8, i1 false, !dbg !184
  br i1 %or.cond, label %9, label %10, !dbg !184

9:                                                ; preds = %1
  call void @__assert_fail(i8* getelementptr inbounds ([41 x i8], [41 x i8]* @.str, i64 0, i64 0), i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.1, i64 0, i64 0), i32 63, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @__PRETTY_FUNCTION__.thread, i64 0, i64 0)) #7, !dbg !184
  unreachable, !dbg !184

10:                                               ; preds = %1
  %11 = call zeroext i1 @ck_epoch_poll(%struct.ck_epoch_record* %2), !dbg !187
  ret i8* null, !dbg !188
}

; Function Attrs: nounwind
declare dso_local i32 @pthread_create(i64*, %union.pthread_attr_t*, i8* (i8*)*, i8*) #3

declare dso_local i32 @pthread_join(i64, i8**) #2

; Function Attrs: noinline nounwind uwtable
define internal void @ck_epoch_begin(%struct.ck_epoch_record* %0, %struct.ck_epoch_section* %1) #0 !dbg !189 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %0, metadata !197, metadata !DIExpression()), !dbg !198
  call void @llvm.dbg.value(metadata %struct.ck_epoch_section* %1, metadata !199, metadata !DIExpression()), !dbg !198
  %3 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 1, !dbg !200
  %4 = load %struct.ck_epoch*, %struct.ck_epoch** %3, align 8, !dbg !200
  call void @llvm.dbg.value(metadata %struct.ck_epoch* %4, metadata !201, metadata !DIExpression()), !dbg !198
  %5 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 4, !dbg !202
  %6 = load atomic i32, i32* %5 monotonic, align 8, !dbg !202
  %7 = icmp eq i32 %6, 0, !dbg !204
  br i1 %7, label %8, label %12, !dbg !205

8:                                                ; preds = %2
  store atomic i32 1, i32* %5 monotonic, align 8, !dbg !206
  fence seq_cst, !dbg !208
  %9 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %4, i32 0, i32 0, !dbg !209
  %10 = load atomic i32, i32* %9 monotonic, align 8, !dbg !209
  call void @llvm.dbg.value(metadata i32 %10, metadata !210, metadata !DIExpression()), !dbg !211
  %11 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 3, !dbg !212
  store atomic i32 %10, i32* %11 monotonic, align 4, !dbg !212
  br label %15, !dbg !213

12:                                               ; preds = %2
  %13 = load atomic i32, i32* %5 monotonic, align 8, !dbg !214
  %14 = add i32 %13, 1, !dbg !214
  store atomic i32 %14, i32* %5 monotonic, align 8, !dbg !214
  br label %15

15:                                               ; preds = %12, %8
  %16 = icmp ne %struct.ck_epoch_section* %1, null, !dbg !216
  br i1 %16, label %17, label %18, !dbg !218

17:                                               ; preds = %15
  call void @_ck_epoch_addref(%struct.ck_epoch_record* %0, %struct.ck_epoch_section* %1), !dbg !219
  br label %18, !dbg !219

18:                                               ; preds = %17, %15
  ret void, !dbg !220
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @ck_epoch_end(%struct.ck_epoch_record* %0, %struct.ck_epoch_section* %1) #0 !dbg !221 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %0, metadata !225, metadata !DIExpression()), !dbg !226
  call void @llvm.dbg.value(metadata %struct.ck_epoch_section* %1, metadata !227, metadata !DIExpression()), !dbg !226
  fence release, !dbg !228
  %3 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 4, !dbg !229
  %4 = load atomic i32, i32* %3 monotonic, align 8, !dbg !229
  %5 = sub i32 %4, 1, !dbg !229
  store atomic i32 %5, i32* %3 monotonic, align 8, !dbg !229
  %6 = icmp ne %struct.ck_epoch_section* %1, null, !dbg !230
  br i1 %6, label %7, label %9, !dbg !232

7:                                                ; preds = %2
  %8 = call zeroext i1 @_ck_epoch_delref(%struct.ck_epoch_record* %0, %struct.ck_epoch_section* %1), !dbg !233
  br label %12, !dbg !234

9:                                                ; preds = %2
  %10 = load atomic i32, i32* %3 monotonic, align 8, !dbg !235
  %11 = icmp eq i32 %10, 0, !dbg !236
  br label %12, !dbg !237

12:                                               ; preds = %9, %7
  %.0 = phi i1 [ %8, %7 ], [ %11, %9 ], !dbg !226
  ret i1 %.0, !dbg !238
}

; Function Attrs: noreturn nounwind
declare dso_local void @__assert_fail(i8*, i8*, i32, i8*) #4

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @_ck_epoch_delref(%struct.ck_epoch_record* %0, %struct.ck_epoch_section* %1) #0 !dbg !239 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %0, metadata !246, metadata !DIExpression()), !dbg !247
  call void @llvm.dbg.value(metadata %struct.ck_epoch_section* %1, metadata !248, metadata !DIExpression()), !dbg !247
  %3 = getelementptr inbounds %struct.ck_epoch_section, %struct.ck_epoch_section* %1, i32 0, i32 0, !dbg !249
  %4 = load i32, i32* %3, align 4, !dbg !249
  call void @llvm.dbg.value(metadata i32 %4, metadata !250, metadata !DIExpression()), !dbg !247
  %5 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 5, !dbg !251
  %6 = getelementptr inbounds %struct.anon, %struct.anon* %5, i32 0, i32 0, !dbg !252
  %7 = zext i32 %4 to i64, !dbg !253
  %8 = getelementptr inbounds [2 x %struct.ck_epoch_ref], [2 x %struct.ck_epoch_ref]* %6, i64 0, i64 %7, !dbg !253
  call void @llvm.dbg.value(metadata %struct.ck_epoch_ref* %8, metadata !254, metadata !DIExpression()), !dbg !247
  %9 = getelementptr inbounds %struct.ck_epoch_ref, %struct.ck_epoch_ref* %8, i32 0, i32 1, !dbg !256
  %10 = load i32, i32* %9, align 4, !dbg !257
  %11 = add i32 %10, -1, !dbg !257
  store i32 %11, i32* %9, align 4, !dbg !257
  %12 = icmp ugt i32 %11, 0, !dbg !258
  br i1 %12, label %30, label %13, !dbg !260

13:                                               ; preds = %2
  %14 = add i32 %4, 1, !dbg !261
  %15 = and i32 %14, 1, !dbg !262
  %16 = zext i32 %15 to i64, !dbg !263
  %17 = getelementptr inbounds [2 x %struct.ck_epoch_ref], [2 x %struct.ck_epoch_ref]* %6, i64 0, i64 %16, !dbg !263
  call void @llvm.dbg.value(metadata %struct.ck_epoch_ref* %17, metadata !264, metadata !DIExpression()), !dbg !247
  %18 = getelementptr inbounds %struct.ck_epoch_ref, %struct.ck_epoch_ref* %17, i32 0, i32 1, !dbg !265
  %19 = load i32, i32* %18, align 4, !dbg !265
  %20 = icmp ugt i32 %19, 0, !dbg !267
  br i1 %20, label %21, label %30, !dbg !268

21:                                               ; preds = %13
  %22 = getelementptr inbounds %struct.ck_epoch_ref, %struct.ck_epoch_ref* %8, i32 0, i32 0, !dbg !269
  %23 = load i32, i32* %22, align 4, !dbg !269
  %24 = getelementptr inbounds %struct.ck_epoch_ref, %struct.ck_epoch_ref* %17, i32 0, i32 0, !dbg !270
  %25 = load i32, i32* %24, align 4, !dbg !270
  %26 = sub i32 %23, %25, !dbg !271
  %27 = icmp slt i32 %26, 0, !dbg !272
  br i1 %27, label %28, label %30, !dbg !273

28:                                               ; preds = %21
  %29 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 3, !dbg !274
  store atomic i32 %25, i32* %29 monotonic, align 4, !dbg !274
  br label %30, !dbg !276

30:                                               ; preds = %13, %21, %28, %2
  %.0 = phi i1 [ false, %2 ], [ true, %28 ], [ true, %21 ], [ true, %13 ], !dbg !247
  ret i1 %.0, !dbg !277
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @_ck_epoch_addref(%struct.ck_epoch_record* %0, %struct.ck_epoch_section* %1) #0 !dbg !278 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %0, metadata !281, metadata !DIExpression()), !dbg !282
  call void @llvm.dbg.value(metadata %struct.ck_epoch_section* %1, metadata !283, metadata !DIExpression()), !dbg !282
  %3 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 1, !dbg !284
  %4 = load %struct.ck_epoch*, %struct.ck_epoch** %3, align 8, !dbg !284
  call void @llvm.dbg.value(metadata %struct.ck_epoch* %4, metadata !285, metadata !DIExpression()), !dbg !282
  %5 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %4, i32 0, i32 0, !dbg !286
  %6 = load atomic i32, i32* %5 monotonic, align 8, !dbg !286
  call void @llvm.dbg.value(metadata i32 %6, metadata !287, metadata !DIExpression()), !dbg !282
  %7 = and i32 %6, 1, !dbg !288
  call void @llvm.dbg.value(metadata i32 %7, metadata !289, metadata !DIExpression()), !dbg !282
  %8 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 5, !dbg !290
  %9 = getelementptr inbounds %struct.anon, %struct.anon* %8, i32 0, i32 0, !dbg !291
  %10 = zext i32 %7 to i64, !dbg !292
  %11 = getelementptr inbounds [2 x %struct.ck_epoch_ref], [2 x %struct.ck_epoch_ref]* %9, i64 0, i64 %10, !dbg !292
  call void @llvm.dbg.value(metadata %struct.ck_epoch_ref* %11, metadata !293, metadata !DIExpression()), !dbg !282
  %12 = getelementptr inbounds %struct.ck_epoch_ref, %struct.ck_epoch_ref* %11, i32 0, i32 1, !dbg !294
  %13 = load i32, i32* %12, align 4, !dbg !296
  %14 = add i32 %13, 1, !dbg !296
  store i32 %14, i32* %12, align 4, !dbg !296
  %15 = icmp eq i32 %13, 0, !dbg !297
  br i1 %15, label %16, label %27, !dbg !298

16:                                               ; preds = %2
  %17 = add i32 %7, 1, !dbg !299
  %18 = and i32 %17, 1, !dbg !301
  %19 = zext i32 %18 to i64, !dbg !302
  %20 = getelementptr inbounds [2 x %struct.ck_epoch_ref], [2 x %struct.ck_epoch_ref]* %9, i64 0, i64 %19, !dbg !302
  call void @llvm.dbg.value(metadata %struct.ck_epoch_ref* %20, metadata !303, metadata !DIExpression()), !dbg !304
  %21 = getelementptr inbounds %struct.ck_epoch_ref, %struct.ck_epoch_ref* %20, i32 0, i32 1, !dbg !305
  %22 = load i32, i32* %21, align 4, !dbg !305
  %23 = icmp ugt i32 %22, 0, !dbg !307
  br i1 %23, label %24, label %25, !dbg !308

24:                                               ; preds = %16
  fence acquire, !dbg !309
  br label %25, !dbg !309

25:                                               ; preds = %24, %16
  %26 = getelementptr inbounds %struct.ck_epoch_ref, %struct.ck_epoch_ref* %11, i32 0, i32 0, !dbg !310
  store i32 %6, i32* %26, align 4, !dbg !311
  br label %27, !dbg !312

27:                                               ; preds = %25, %2
  %28 = getelementptr inbounds %struct.ck_epoch_section, %struct.ck_epoch_section* %1, i32 0, i32 0, !dbg !313
  store i32 %7, i32* %28, align 4, !dbg !314
  ret void, !dbg !315
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @ck_epoch_init(%struct.ck_epoch* %0) #0 !dbg !316 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch* %0, metadata !319, metadata !DIExpression()), !dbg !320
  %2 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %0, i32 0, i32 2, !dbg !321
  call void @ck_stack_init(%struct.ck_stack* %2), !dbg !322
  %3 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %0, i32 0, i32 0, !dbg !323
  store atomic i32 1, i32* %3 seq_cst, align 4, !dbg !324
  %4 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %0, i32 0, i32 1, !dbg !325
  store atomic i32 0, i32* %4 seq_cst, align 4, !dbg !326
  fence release, !dbg !327
  ret void, !dbg !328
}

; Function Attrs: noinline nounwind uwtable
define internal void @ck_stack_init(%struct.ck_stack* %0) #0 !dbg !329 {
  call void @llvm.dbg.value(metadata %struct.ck_stack* %0, metadata !333, metadata !DIExpression()), !dbg !334
  %2 = getelementptr inbounds %struct.ck_stack, %struct.ck_stack* %0, i32 0, i32 0, !dbg !335
  %3 = bitcast %struct.ck_stack_entry** %2 to i64*, !dbg !336
  store atomic i64 0, i64* %3 seq_cst, align 8, !dbg !336
  %4 = getelementptr inbounds %struct.ck_stack, %struct.ck_stack* %0, i32 0, i32 1, !dbg !337
  store i8* null, i8** %4, align 8, !dbg !338
  ret void, !dbg !339
}

; Function Attrs: noinline nounwind uwtable
define dso_local %struct.ck_epoch_record* @ck_epoch_recycle(%struct.ck_epoch* %0, i8* %1) #0 !dbg !340 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch* %0, metadata !345, metadata !DIExpression()), !dbg !346
  call void @llvm.dbg.value(metadata i8* %1, metadata !347, metadata !DIExpression()), !dbg !346
  %3 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %0, i32 0, i32 1, !dbg !348
  %4 = load atomic i32, i32* %3 monotonic, align 4, !dbg !348
  %5 = icmp eq i32 %4, 0, !dbg !350
  br i1 %5, label %32, label %6, !dbg !351

6:                                                ; preds = %2
  %7 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %0, i32 0, i32 2, !dbg !352
  %8 = getelementptr inbounds %struct.ck_stack, %struct.ck_stack* %7, i32 0, i32 0, !dbg !352
  %9 = bitcast %struct.ck_stack_entry** %8 to i64*, !dbg !352
  %10 = load atomic i64, i64* %9 monotonic, align 8, !dbg !352
  %11 = inttoptr i64 %10 to %struct.ck_stack_entry*, !dbg !352
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %11, metadata !354, metadata !DIExpression()), !dbg !346
  br label %12, !dbg !352

12:                                               ; preds = %27, %6
  %.01 = phi %struct.ck_stack_entry* [ %11, %6 ], [ %31, %27 ], !dbg !356
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %.01, metadata !354, metadata !DIExpression()), !dbg !346
  %13 = icmp ne %struct.ck_stack_entry* %.01, null, !dbg !357
  br i1 %13, label %14, label %32, !dbg !352

14:                                               ; preds = %12
  %15 = call %struct.ck_epoch_record* @ck_epoch_record_container(%struct.ck_stack_entry* %.01), !dbg !359
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %15, metadata !361, metadata !DIExpression()), !dbg !346
  %16 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %15, i32 0, i32 2, !dbg !362
  %17 = load atomic i32, i32* %16 monotonic, align 8, !dbg !362
  %18 = icmp eq i32 %17, 1, !dbg !364
  br i1 %18, label %19, label %27, !dbg !365

19:                                               ; preds = %14
  fence acquire, !dbg !366
  %20 = atomicrmw xchg i32* %16, i32 0 monotonic, align 4, !dbg !368
  call void @llvm.dbg.value(metadata i32 %20, metadata !369, metadata !DIExpression()), !dbg !346
  %21 = icmp eq i32 %20, 1, !dbg !370
  br i1 %21, label %22, label %27, !dbg !372

22:                                               ; preds = %19
  %23 = atomicrmw add i32* %3, i32 -1 monotonic, align 4, !dbg !373
  %24 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %15, i32 0, i32 9, !dbg !375
  %25 = bitcast i8** %24 to i64*, !dbg !375
  %26 = ptrtoint i8* %1 to i64, !dbg !375
  store atomic i64 %26, i64* %25 monotonic, align 8, !dbg !375
  br label %32, !dbg !376

27:                                               ; preds = %14, %19
  %28 = getelementptr inbounds %struct.ck_stack_entry, %struct.ck_stack_entry* %.01, i32 0, i32 0, !dbg !357
  %29 = bitcast %struct.ck_stack_entry** %28 to i64*, !dbg !357
  %30 = load atomic i64, i64* %29 monotonic, align 8, !dbg !357
  %31 = inttoptr i64 %30 to %struct.ck_stack_entry*, !dbg !357
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %31, metadata !354, metadata !DIExpression()), !dbg !346
  br label %12, !dbg !357, !llvm.loop !377

32:                                               ; preds = %12, %2, %22
  %.0 = phi %struct.ck_epoch_record* [ %15, %22 ], [ null, %2 ], [ null, %12 ], !dbg !346
  ret %struct.ck_epoch_record* %.0, !dbg !380
}

; Function Attrs: noinline nounwind uwtable
define internal %struct.ck_epoch_record* @ck_epoch_record_container(%struct.ck_stack_entry* %0) #0 !dbg !381 {
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %0, metadata !384, metadata !DIExpression()), !dbg !385
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %0, metadata !386, metadata !DIExpression()), !dbg !385
  %2 = bitcast %struct.ck_stack_entry* %0 to i8*, !dbg !387
  %3 = bitcast i8* %2 to %struct.ck_epoch_record*, !dbg !387
  ret %struct.ck_epoch_record* %3, !dbg !387
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @ck_epoch_register(%struct.ck_epoch* %0, %struct.ck_epoch_record* %1, i8* %2) #0 !dbg !388 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch* %0, metadata !391, metadata !DIExpression()), !dbg !392
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %1, metadata !393, metadata !DIExpression()), !dbg !392
  call void @llvm.dbg.value(metadata i8* %2, metadata !394, metadata !DIExpression()), !dbg !392
  %4 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %1, i32 0, i32 1, !dbg !395
  store %struct.ck_epoch* %0, %struct.ck_epoch** %4, align 8, !dbg !396
  %5 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %1, i32 0, i32 2, !dbg !397
  store atomic i32 0, i32* %5 seq_cst, align 4, !dbg !398
  %6 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %1, i32 0, i32 4, !dbg !399
  store atomic i32 0, i32* %6 seq_cst, align 4, !dbg !400
  %7 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %1, i32 0, i32 3, !dbg !401
  store atomic i32 0, i32* %7 seq_cst, align 4, !dbg !402
  %8 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %1, i32 0, i32 8, !dbg !403
  store atomic i32 0, i32* %8 seq_cst, align 4, !dbg !404
  %9 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %1, i32 0, i32 7, !dbg !405
  store atomic i32 0, i32* %9 seq_cst, align 4, !dbg !406
  %10 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %1, i32 0, i32 6, !dbg !407
  store atomic i32 0, i32* %10 seq_cst, align 4, !dbg !408
  %11 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %1, i32 0, i32 9, !dbg !409
  %12 = ptrtoint i8* %2 to i64, !dbg !410
  %13 = bitcast i8** %11 to i64*, !dbg !410
  store atomic i64 %12, i64* %13 seq_cst, align 8, !dbg !410
  %14 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %1, i32 0, i32 5, !dbg !411
  %15 = bitcast %struct.anon* %14 to i8*, !dbg !412
  call void @llvm.memset.p0i8.i64(i8* align 4 %15, i8 0, i64 16, i1 false), !dbg !412
  call void @__VERIFIER_loop_bound(i32 5), !dbg !413
  call void @llvm.dbg.value(metadata i64 0, metadata !414, metadata !DIExpression()), !dbg !392
  call void @llvm.dbg.value(metadata i64 0, metadata !414, metadata !DIExpression()), !dbg !392
  %16 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %1, i32 0, i32 10, !dbg !415
  %17 = getelementptr inbounds [4 x %struct.ck_stack], [4 x %struct.ck_stack]* %16, i64 0, i64 0, !dbg !418
  call void @ck_stack_init(%struct.ck_stack* %17), !dbg !419
  call void @llvm.dbg.value(metadata i64 1, metadata !414, metadata !DIExpression()), !dbg !392
  call void @llvm.dbg.value(metadata i64 1, metadata !414, metadata !DIExpression()), !dbg !392
  %18 = getelementptr inbounds [4 x %struct.ck_stack], [4 x %struct.ck_stack]* %16, i64 0, i64 1, !dbg !418
  call void @ck_stack_init(%struct.ck_stack* %18), !dbg !419
  call void @llvm.dbg.value(metadata i64 2, metadata !414, metadata !DIExpression()), !dbg !392
  call void @llvm.dbg.value(metadata i64 2, metadata !414, metadata !DIExpression()), !dbg !392
  %19 = getelementptr inbounds [4 x %struct.ck_stack], [4 x %struct.ck_stack]* %16, i64 0, i64 2, !dbg !418
  call void @ck_stack_init(%struct.ck_stack* %19), !dbg !419
  call void @llvm.dbg.value(metadata i64 3, metadata !414, metadata !DIExpression()), !dbg !392
  call void @llvm.dbg.value(metadata i64 3, metadata !414, metadata !DIExpression()), !dbg !392
  %20 = getelementptr inbounds [4 x %struct.ck_stack], [4 x %struct.ck_stack]* %16, i64 0, i64 3, !dbg !418
  call void @ck_stack_init(%struct.ck_stack* %20), !dbg !419
  call void @llvm.dbg.value(metadata i64 4, metadata !414, metadata !DIExpression()), !dbg !392
  call void @llvm.dbg.value(metadata i64 4, metadata !414, metadata !DIExpression()), !dbg !392
  fence release, !dbg !420
  %21 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %0, i32 0, i32 2, !dbg !421
  %22 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %1, i32 0, i32 0, !dbg !422
  call void @ck_stack_push_upmc(%struct.ck_stack* %21, %struct.ck_stack_entry* %22), !dbg !423
  ret void, !dbg !424
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #5

; Function Attrs: noinline nounwind uwtable
define internal void @ck_stack_push_upmc(%struct.ck_stack* %0, %struct.ck_stack_entry* %1) #0 !dbg !425 {
  call void @llvm.dbg.value(metadata %struct.ck_stack* %0, metadata !428, metadata !DIExpression()), !dbg !429
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %1, metadata !430, metadata !DIExpression()), !dbg !429
  %3 = getelementptr inbounds %struct.ck_stack, %struct.ck_stack* %0, i32 0, i32 0, !dbg !431
  %4 = bitcast %struct.ck_stack_entry** %3 to i64*, !dbg !431
  %5 = load atomic i64, i64* %4 monotonic, align 8, !dbg !431
  %6 = inttoptr i64 %5 to %struct.ck_stack_entry*, !dbg !431
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %6, metadata !432, metadata !DIExpression()), !dbg !429
  %7 = getelementptr inbounds %struct.ck_stack_entry, %struct.ck_stack_entry* %1, i32 0, i32 0, !dbg !433
  %8 = bitcast %struct.ck_stack_entry** %7 to i64*, !dbg !434
  store atomic i64 %5, i64* %8 seq_cst, align 8, !dbg !434
  fence release, !dbg !435
  br label %9, !dbg !436

9:                                                ; preds = %19, %2
  %.0 = phi %struct.ck_stack_entry* [ %6, %2 ], [ %.1, %19 ], !dbg !437
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %.0, metadata !432, metadata !DIExpression()), !dbg !429
  %10 = ptrtoint %struct.ck_stack_entry* %.0 to i64, !dbg !438
  %11 = ptrtoint %struct.ck_stack_entry* %1 to i64, !dbg !438
  %12 = cmpxchg i64* %4, i64 %10, i64 %11 seq_cst seq_cst, align 8, !dbg !438
  %13 = extractvalue { i64, i1 } %12, 0, !dbg !438
  %14 = extractvalue { i64, i1 } %12, 1, !dbg !438
  %15 = inttoptr i64 %13 to %struct.ck_stack_entry*, !dbg !438
  %.1 = select i1 %14, %struct.ck_stack_entry* %.0, %struct.ck_stack_entry* %15, !dbg !438
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %.1, metadata !432, metadata !DIExpression()), !dbg !429
  %16 = zext i1 %14 to i8, !dbg !438
  %17 = zext i1 %14 to i32, !dbg !438
  %18 = icmp eq i32 %17, 0, !dbg !439
  br i1 %18, label %19, label %21, !dbg !436

19:                                               ; preds = %9
  %20 = ptrtoint %struct.ck_stack_entry* %.1 to i64, !dbg !440
  store atomic i64 %20, i64* %8 seq_cst, align 8, !dbg !440
  fence release, !dbg !442
  br label %9, !dbg !436, !llvm.loop !443

21:                                               ; preds = %9
  ret void, !dbg !445
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @ck_epoch_unregister(%struct.ck_epoch_record* %0) #0 !dbg !446 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %0, metadata !449, metadata !DIExpression()), !dbg !450
  %2 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 1, !dbg !451
  %3 = load %struct.ck_epoch*, %struct.ck_epoch** %2, align 8, !dbg !451
  call void @llvm.dbg.value(metadata %struct.ck_epoch* %3, metadata !452, metadata !DIExpression()), !dbg !450
  %4 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 4, !dbg !453
  store atomic i32 0, i32* %4 seq_cst, align 4, !dbg !454
  %5 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 3, !dbg !455
  store atomic i32 0, i32* %5 seq_cst, align 4, !dbg !456
  %6 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 8, !dbg !457
  store atomic i32 0, i32* %6 seq_cst, align 4, !dbg !458
  %7 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 7, !dbg !459
  store atomic i32 0, i32* %7 seq_cst, align 4, !dbg !460
  %8 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 6, !dbg !461
  store atomic i32 0, i32* %8 seq_cst, align 4, !dbg !462
  %9 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 5, !dbg !463
  %10 = bitcast %struct.anon* %9 to i8*, !dbg !464
  call void @llvm.memset.p0i8.i64(i8* align 4 %10, i8 0, i64 16, i1 false), !dbg !464
  call void @llvm.dbg.value(metadata i64 0, metadata !465, metadata !DIExpression()), !dbg !450
  call void @llvm.dbg.value(metadata i64 0, metadata !465, metadata !DIExpression()), !dbg !450
  %11 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 10, !dbg !466
  %12 = getelementptr inbounds [4 x %struct.ck_stack], [4 x %struct.ck_stack]* %11, i64 0, i64 0, !dbg !469
  call void @ck_stack_init(%struct.ck_stack* %12), !dbg !470
  call void @llvm.dbg.value(metadata i64 1, metadata !465, metadata !DIExpression()), !dbg !450
  call void @llvm.dbg.value(metadata i64 1, metadata !465, metadata !DIExpression()), !dbg !450
  %13 = getelementptr inbounds [4 x %struct.ck_stack], [4 x %struct.ck_stack]* %11, i64 0, i64 1, !dbg !469
  call void @ck_stack_init(%struct.ck_stack* %13), !dbg !470
  call void @llvm.dbg.value(metadata i64 2, metadata !465, metadata !DIExpression()), !dbg !450
  call void @llvm.dbg.value(metadata i64 2, metadata !465, metadata !DIExpression()), !dbg !450
  %14 = getelementptr inbounds [4 x %struct.ck_stack], [4 x %struct.ck_stack]* %11, i64 0, i64 2, !dbg !469
  call void @ck_stack_init(%struct.ck_stack* %14), !dbg !470
  call void @llvm.dbg.value(metadata i64 3, metadata !465, metadata !DIExpression()), !dbg !450
  call void @llvm.dbg.value(metadata i64 3, metadata !465, metadata !DIExpression()), !dbg !450
  %15 = getelementptr inbounds [4 x %struct.ck_stack], [4 x %struct.ck_stack]* %11, i64 0, i64 3, !dbg !469
  call void @ck_stack_init(%struct.ck_stack* %15), !dbg !470
  call void @llvm.dbg.value(metadata i64 4, metadata !465, metadata !DIExpression()), !dbg !450
  call void @llvm.dbg.value(metadata i64 4, metadata !465, metadata !DIExpression()), !dbg !450
  %16 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 9, !dbg !471
  %17 = bitcast i8** %16 to i64*, !dbg !471
  store atomic i64 0, i64* %17 monotonic, align 8, !dbg !471
  fence release, !dbg !472
  %18 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 2, !dbg !473
  store atomic i32 1, i32* %18 monotonic, align 8, !dbg !473
  %19 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %3, i32 0, i32 1, !dbg !474
  %20 = atomicrmw add i32* %19, i32 1 monotonic, align 4, !dbg !474
  ret void, !dbg !475
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @ck_epoch_reclaim(%struct.ck_epoch_record* %0) #0 !dbg !476 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %0, metadata !477, metadata !DIExpression()), !dbg !478
  call void @llvm.dbg.value(metadata i32 0, metadata !479, metadata !DIExpression()), !dbg !478
  call void @llvm.dbg.value(metadata i32 0, metadata !479, metadata !DIExpression()), !dbg !478
  %2 = call i32 @ck_epoch_dispatch(%struct.ck_epoch_record* %0, i32 0, %struct.ck_stack* null), !dbg !480
  call void @llvm.dbg.value(metadata i32 1, metadata !479, metadata !DIExpression()), !dbg !478
  call void @llvm.dbg.value(metadata i32 1, metadata !479, metadata !DIExpression()), !dbg !478
  %3 = call i32 @ck_epoch_dispatch(%struct.ck_epoch_record* %0, i32 1, %struct.ck_stack* null), !dbg !480
  call void @llvm.dbg.value(metadata i32 2, metadata !479, metadata !DIExpression()), !dbg !478
  call void @llvm.dbg.value(metadata i32 2, metadata !479, metadata !DIExpression()), !dbg !478
  %4 = call i32 @ck_epoch_dispatch(%struct.ck_epoch_record* %0, i32 2, %struct.ck_stack* null), !dbg !480
  call void @llvm.dbg.value(metadata i32 3, metadata !479, metadata !DIExpression()), !dbg !478
  call void @llvm.dbg.value(metadata i32 3, metadata !479, metadata !DIExpression()), !dbg !478
  %5 = call i32 @ck_epoch_dispatch(%struct.ck_epoch_record* %0, i32 3, %struct.ck_stack* null), !dbg !480
  call void @llvm.dbg.value(metadata i32 4, metadata !479, metadata !DIExpression()), !dbg !478
  call void @llvm.dbg.value(metadata i32 4, metadata !479, metadata !DIExpression()), !dbg !478
  ret void, !dbg !483
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @ck_epoch_dispatch(%struct.ck_epoch_record* %0, i32 %1, %struct.ck_stack* %2) #0 !dbg !484 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %0, metadata !488, metadata !DIExpression()), !dbg !489
  call void @llvm.dbg.value(metadata i32 %1, metadata !490, metadata !DIExpression()), !dbg !489
  call void @llvm.dbg.value(metadata %struct.ck_stack* %2, metadata !491, metadata !DIExpression()), !dbg !489
  %4 = and i32 %1, 3, !dbg !492
  call void @llvm.dbg.value(metadata i32 %4, metadata !493, metadata !DIExpression()), !dbg !489
  call void @llvm.dbg.value(metadata i32 0, metadata !494, metadata !DIExpression()), !dbg !489
  %5 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 10, !dbg !495
  %6 = zext i32 %4 to i64, !dbg !496
  %7 = getelementptr inbounds [4 x %struct.ck_stack], [4 x %struct.ck_stack]* %5, i64 0, i64 %6, !dbg !496
  %8 = call %struct.ck_stack_entry* @ck_stack_batch_pop_upmc(%struct.ck_stack* %7), !dbg !497
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %8, metadata !498, metadata !DIExpression()), !dbg !489
  call void @__VERIFIER_loop_bound(i32 5), !dbg !499
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %8, metadata !500, metadata !DIExpression()), !dbg !489
  br label %9, !dbg !501

9:                                                ; preds = %23, %3
  %.01 = phi %struct.ck_stack_entry* [ %8, %3 ], [ %16, %23 ], !dbg !503
  %.0 = phi i32 [ 0, %3 ], [ %24, %23 ], !dbg !489
  call void @llvm.dbg.value(metadata i32 %.0, metadata !494, metadata !DIExpression()), !dbg !489
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %.01, metadata !500, metadata !DIExpression()), !dbg !489
  %10 = icmp ne %struct.ck_stack_entry* %.01, null, !dbg !504
  br i1 %10, label %11, label %25, !dbg !506

11:                                               ; preds = %9
  %12 = call %struct.ck_epoch_entry* @ck_epoch_entry_container(%struct.ck_stack_entry* %.01), !dbg !507
  call void @llvm.dbg.value(metadata %struct.ck_epoch_entry* %12, metadata !509, metadata !DIExpression()), !dbg !510
  %13 = getelementptr inbounds %struct.ck_stack_entry, %struct.ck_stack_entry* %.01, i32 0, i32 0, !dbg !511
  %14 = bitcast %struct.ck_stack_entry** %13 to i64*, !dbg !511
  %15 = load atomic i64, i64* %14 monotonic, align 8, !dbg !511
  %16 = inttoptr i64 %15 to %struct.ck_stack_entry*, !dbg !511
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %16, metadata !512, metadata !DIExpression()), !dbg !489
  %17 = icmp ne %struct.ck_stack* %2, null, !dbg !513
  br i1 %17, label %18, label %20, !dbg !515

18:                                               ; preds = %11
  %19 = getelementptr inbounds %struct.ck_epoch_entry, %struct.ck_epoch_entry* %12, i32 0, i32 1, !dbg !516
  call void @ck_stack_push_spnc(%struct.ck_stack* %2, %struct.ck_stack_entry* %19), !dbg !517
  br label %23, !dbg !517

20:                                               ; preds = %11
  %21 = getelementptr inbounds %struct.ck_epoch_entry, %struct.ck_epoch_entry* %12, i32 0, i32 0, !dbg !518
  %22 = load void (%struct.ck_epoch_entry*)*, void (%struct.ck_epoch_entry*)** %21, align 8, !dbg !518
  call void %22(%struct.ck_epoch_entry* %12), !dbg !519
  br label %23

23:                                               ; preds = %20, %18
  %24 = add i32 %.0, 1, !dbg !520
  call void @llvm.dbg.value(metadata i32 %24, metadata !494, metadata !DIExpression()), !dbg !489
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %16, metadata !500, metadata !DIExpression()), !dbg !489
  br label %9, !dbg !521, !llvm.loop !522

25:                                               ; preds = %9
  %26 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 7, !dbg !524
  %27 = load atomic i32, i32* %26 monotonic, align 8, !dbg !524
  call void @llvm.dbg.value(metadata i32 %27, metadata !525, metadata !DIExpression()), !dbg !489
  %28 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 6, !dbg !526
  %29 = load atomic i32, i32* %28 monotonic, align 4, !dbg !526
  call void @llvm.dbg.value(metadata i32 %29, metadata !527, metadata !DIExpression()), !dbg !489
  %30 = icmp ugt i32 %29, %27, !dbg !528
  br i1 %30, label %31, label %32, !dbg !530

31:                                               ; preds = %25
  store atomic i32 %27, i32* %26 monotonic, align 8, !dbg !531
  br label %32, !dbg !531

32:                                               ; preds = %31, %25
  %33 = icmp ugt i32 %.0, 0, !dbg !532
  br i1 %33, label %34, label %39, !dbg !534

34:                                               ; preds = %32
  %35 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 8, !dbg !535
  %36 = atomicrmw add i32* %35, i32 %.0 monotonic, align 4, !dbg !535
  %37 = sub i32 0, %.0, !dbg !537
  %38 = atomicrmw add i32* %28, i32 %37 monotonic, align 4, !dbg !537
  br label %39, !dbg !538

39:                                               ; preds = %34, %32
  ret i32 %.0, !dbg !539
}

; Function Attrs: noinline nounwind uwtable
define internal %struct.ck_stack_entry* @ck_stack_batch_pop_upmc(%struct.ck_stack* %0) #0 !dbg !540 {
  call void @llvm.dbg.value(metadata %struct.ck_stack* %0, metadata !543, metadata !DIExpression()), !dbg !544
  %2 = getelementptr inbounds %struct.ck_stack, %struct.ck_stack* %0, i32 0, i32 0, !dbg !545
  %3 = bitcast %struct.ck_stack_entry** %2 to i64*, !dbg !545
  %4 = atomicrmw xchg i64* %3, i64 0 monotonic, align 8, !dbg !545
  %5 = inttoptr i64 %4 to %struct.ck_stack_entry*, !dbg !545
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %5, metadata !546, metadata !DIExpression()), !dbg !544
  fence acquire, !dbg !547
  ret %struct.ck_stack_entry* %5, !dbg !548
}

; Function Attrs: noinline nounwind uwtable
define internal %struct.ck_epoch_entry* @ck_epoch_entry_container(%struct.ck_stack_entry* %0) #0 !dbg !549 {
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %0, metadata !552, metadata !DIExpression()), !dbg !553
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %0, metadata !554, metadata !DIExpression()), !dbg !553
  %2 = bitcast %struct.ck_stack_entry* %0 to i8*, !dbg !555
  %3 = getelementptr inbounds i8, i8* %2, i64 sub (i64 0, i64 ptrtoint (i1** getelementptr (i1*, i1** null, i32 1) to i64)), !dbg !555
  %4 = bitcast i8* %3 to %struct.ck_epoch_entry*, !dbg !555
  ret %struct.ck_epoch_entry* %4, !dbg !555
}

; Function Attrs: noinline nounwind uwtable
define internal void @ck_stack_push_spnc(%struct.ck_stack* %0, %struct.ck_stack_entry* %1) #0 !dbg !556 {
  call void @llvm.dbg.value(metadata %struct.ck_stack* %0, metadata !557, metadata !DIExpression()), !dbg !558
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %1, metadata !559, metadata !DIExpression()), !dbg !558
  %3 = getelementptr inbounds %struct.ck_stack, %struct.ck_stack* %0, i32 0, i32 0, !dbg !560
  %4 = bitcast %struct.ck_stack_entry** %3 to i64*, !dbg !560
  %5 = load atomic i64, i64* %4 seq_cst, align 8, !dbg !560
  %6 = inttoptr i64 %5 to %struct.ck_stack_entry*, !dbg !560
  %7 = getelementptr inbounds %struct.ck_stack_entry, %struct.ck_stack_entry* %1, i32 0, i32 0, !dbg !561
  %8 = bitcast %struct.ck_stack_entry** %7 to i64*, !dbg !562
  store atomic i64 %5, i64* %8 seq_cst, align 8, !dbg !562
  %9 = ptrtoint %struct.ck_stack_entry* %1 to i64, !dbg !563
  store atomic i64 %9, i64* %4 seq_cst, align 8, !dbg !563
  ret void, !dbg !564
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @ck_epoch_synchronize_wait(%struct.ck_epoch* %0, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* %1, i8* %2) #0 !dbg !565 {
  %4 = alloca i8, align 1
  call void @llvm.dbg.value(metadata %struct.ck_epoch* %0, metadata !574, metadata !DIExpression()), !dbg !575
  call void @llvm.dbg.value(metadata void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* %1, metadata !576, metadata !DIExpression()), !dbg !575
  call void @llvm.dbg.value(metadata i8* %2, metadata !577, metadata !DIExpression()), !dbg !575
  call void @llvm.dbg.declare(metadata i8* %4, metadata !578, metadata !DIExpression()), !dbg !579
  fence seq_cst, !dbg !580
  %5 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %0, i32 0, i32 0, !dbg !581
  %6 = load atomic i32, i32* %5 monotonic, align 8, !dbg !581
  call void @llvm.dbg.value(metadata i32 %6, metadata !582, metadata !DIExpression()), !dbg !575
  call void @llvm.dbg.value(metadata i32 %6, metadata !583, metadata !DIExpression()), !dbg !575
  %7 = add i32 %6, 3, !dbg !584
  call void @llvm.dbg.value(metadata i32 %7, metadata !585, metadata !DIExpression()), !dbg !575
  call void @llvm.dbg.value(metadata i32 0, metadata !586, metadata !DIExpression()), !dbg !575
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* null, metadata !587, metadata !DIExpression()), !dbg !575
  call void @llvm.dbg.value(metadata i32 0, metadata !586, metadata !DIExpression()), !dbg !575
  call void @llvm.dbg.value(metadata i32 %6, metadata !583, metadata !DIExpression()), !dbg !575
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* null, metadata !587, metadata !DIExpression()), !dbg !575
  br label %.outer, !dbg !588

.outer:                                           ; preds = %22, %3
  %.1.ph = phi i32 [ %12, %22 ], [ %6, %3 ]
  br label %8, !dbg !588

8:                                                ; preds = %.outer, %14
  %.13 = phi %struct.ck_epoch_record* [ %9, %14 ], [ null, %.outer ], !dbg !592
  call void @llvm.dbg.value(metadata i32 %.1.ph, metadata !583, metadata !DIExpression()), !dbg !575
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %.13, metadata !587, metadata !DIExpression()), !dbg !575
  %9 = call %struct.ck_epoch_record* @ck_epoch_scan(%struct.ck_epoch* %0, %struct.ck_epoch_record* %.13, i32 %.1.ph, i8* %4), !dbg !593
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %9, metadata !587, metadata !DIExpression()), !dbg !575
  %10 = icmp ne %struct.ck_epoch_record* %9, null, !dbg !594
  br i1 %10, label %11, label %23, !dbg !588

11:                                               ; preds = %8
  %12 = load atomic i32, i32* %5 monotonic, align 8, !dbg !595
  call void @llvm.dbg.value(metadata i32 %12, metadata !597, metadata !DIExpression()), !dbg !598
  %13 = icmp eq i32 %12, %.1.ph, !dbg !599
  br i1 %13, label %14, label %15, !dbg !601

14:                                               ; preds = %11
  call void @epoch_block(%struct.ck_epoch* %0, %struct.ck_epoch_record* %9, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* %1, i8* %2), !dbg !602
  br label %8, !dbg !604, !llvm.loop !605

15:                                               ; preds = %11
  call void @llvm.dbg.value(metadata i32 %12, metadata !583, metadata !DIExpression()), !dbg !575
  %16 = icmp ugt i32 %7, %6, !dbg !607
  %17 = zext i1 %16 to i32, !dbg !607
  %18 = icmp uge i32 %12, %7, !dbg !609
  %19 = zext i1 %18 to i32, !dbg !609
  %20 = and i32 %17, %19, !dbg !610
  %21 = icmp ne i32 %20, 0, !dbg !610
  br i1 %21, label %.loopexit7, label %22, !dbg !611

22:                                               ; preds = %15
  call void @epoch_block(%struct.ck_epoch* %0, %struct.ck_epoch_record* %9, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* %1, i8* %2), !dbg !612
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* null, metadata !587, metadata !DIExpression()), !dbg !575
  br label %.outer, !dbg !588, !llvm.loop !605

23:                                               ; preds = %8
  %24 = load i8, i8* %4, align 1, !dbg !613
  %25 = trunc i8 %24 to i1, !dbg !613
  %26 = zext i1 %25 to i32, !dbg !613
  %27 = icmp eq i32 %26, 0, !dbg !615
  br i1 %27, label %.loopexit7, label %28, !dbg !616

28:                                               ; preds = %23
  %29 = add i32 %.1.ph, 1, !dbg !617
  %30 = cmpxchg i32* %5, i32 %.1.ph, i32 %29 seq_cst seq_cst, align 4, !dbg !617
  %31 = extractvalue { i32, i1 } %30, 0, !dbg !617
  %32 = extractvalue { i32, i1 } %30, 1, !dbg !617
  %spec.select = select i1 %32, i32 %.1.ph, i32 %31, !dbg !617
  call void @llvm.dbg.value(metadata i32 %spec.select, metadata !583, metadata !DIExpression()), !dbg !575
  call void @llvm.dbg.value(metadata i1 %32, metadata !618, metadata !DIExpression(DW_OP_LLVM_convert, 1, DW_ATE_unsigned, DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !619
  fence acquire, !dbg !620
  %33 = zext i1 %32 to i32, !dbg !621
  %34 = add i32 %spec.select, %33, !dbg !622
  call void @llvm.dbg.value(metadata i32 %34, metadata !583, metadata !DIExpression()), !dbg !575
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* null, metadata !587, metadata !DIExpression()), !dbg !575
  call void @llvm.dbg.value(metadata i32 1, metadata !586, metadata !DIExpression()), !dbg !575
  call void @llvm.dbg.value(metadata i32 1, metadata !586, metadata !DIExpression()), !dbg !575
  call void @llvm.dbg.value(metadata i32 %34, metadata !583, metadata !DIExpression()), !dbg !575
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* null, metadata !587, metadata !DIExpression()), !dbg !575
  br label %.outer.1, !dbg !588

.outer.1:                                         ; preds = %59, %28
  %.1.ph.1 = phi i32 [ %50, %59 ], [ %34, %28 ]
  br label %35, !dbg !588

35:                                               ; preds = %60, %.outer.1
  %.13.1 = phi %struct.ck_epoch_record* [ %36, %60 ], [ null, %.outer.1 ], !dbg !592
  call void @llvm.dbg.value(metadata i32 %.1.ph.1, metadata !583, metadata !DIExpression()), !dbg !575
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %.13.1, metadata !587, metadata !DIExpression()), !dbg !575
  %36 = call %struct.ck_epoch_record* @ck_epoch_scan(%struct.ck_epoch* %0, %struct.ck_epoch_record* %.13.1, i32 %.1.ph.1, i8* %4), !dbg !593
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %36, metadata !587, metadata !DIExpression()), !dbg !575
  %37 = icmp ne %struct.ck_epoch_record* %36, null, !dbg !594
  br i1 %37, label %49, label %38, !dbg !588

38:                                               ; preds = %35
  %39 = load i8, i8* %4, align 1, !dbg !613
  %40 = trunc i8 %39 to i1, !dbg !613
  %41 = zext i1 %40 to i32, !dbg !613
  %42 = icmp eq i32 %41, 0, !dbg !615
  br i1 %42, label %.loopexit7, label %.loopexit, !dbg !616

.loopexit:                                        ; preds = %38
  %43 = add i32 %.1.ph.1, 1, !dbg !617
  %44 = cmpxchg i32* %5, i32 %.1.ph.1, i32 %43 seq_cst seq_cst, align 4, !dbg !617
  %45 = extractvalue { i32, i1 } %44, 0, !dbg !617
  %46 = extractvalue { i32, i1 } %44, 1, !dbg !617
  %spec.select10 = select i1 %46, i32 %.1.ph.1, i32 %45, !dbg !617
  call void @llvm.dbg.value(metadata i32 %spec.select10, metadata !583, metadata !DIExpression()), !dbg !575
  call void @llvm.dbg.value(metadata i1 %46, metadata !618, metadata !DIExpression(DW_OP_LLVM_convert, 1, DW_ATE_unsigned, DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !619
  fence acquire, !dbg !620
  %47 = zext i1 %46 to i32, !dbg !621
  %48 = add i32 %spec.select10, %47, !dbg !622
  call void @llvm.dbg.value(metadata i32 %48, metadata !583, metadata !DIExpression()), !dbg !575
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* null, metadata !587, metadata !DIExpression()), !dbg !575
  call void @llvm.dbg.value(metadata i32 2, metadata !586, metadata !DIExpression()), !dbg !575
  call void @llvm.dbg.value(metadata i32 2, metadata !586, metadata !DIExpression()), !dbg !575
  call void @llvm.dbg.value(metadata i32 %48, metadata !583, metadata !DIExpression()), !dbg !575
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* null, metadata !587, metadata !DIExpression()), !dbg !575
  br label %.loopexit7, !dbg !623

49:                                               ; preds = %35
  %50 = load atomic i32, i32* %5 monotonic, align 8, !dbg !595
  call void @llvm.dbg.value(metadata i32 %50, metadata !597, metadata !DIExpression()), !dbg !598
  %51 = icmp eq i32 %50, %.1.ph.1, !dbg !599
  br i1 %51, label %60, label %52, !dbg !601

52:                                               ; preds = %49
  call void @llvm.dbg.value(metadata i32 %50, metadata !583, metadata !DIExpression()), !dbg !575
  %53 = icmp ugt i32 %7, %6, !dbg !607
  %54 = zext i1 %53 to i32, !dbg !607
  %55 = icmp uge i32 %50, %7, !dbg !609
  %56 = zext i1 %55 to i32, !dbg !609
  %57 = and i32 %54, %56, !dbg !610
  %58 = icmp ne i32 %57, 0, !dbg !610
  br i1 %58, label %.loopexit7, label %59, !dbg !611

59:                                               ; preds = %52
  call void @epoch_block(%struct.ck_epoch* %0, %struct.ck_epoch_record* %36, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* %1, i8* %2), !dbg !612
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* null, metadata !587, metadata !DIExpression()), !dbg !575
  br label %.outer.1, !dbg !588, !llvm.loop !605

60:                                               ; preds = %49
  call void @epoch_block(%struct.ck_epoch* %0, %struct.ck_epoch_record* %36, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* %1, i8* %2), !dbg !602
  br label %35, !dbg !604, !llvm.loop !605

.loopexit7:                                       ; preds = %.loopexit, %38, %23, %15, %52
  call void @llvm.dbg.label(metadata !624), !dbg !625
  fence seq_cst, !dbg !626
  ret void, !dbg !627
}

; Function Attrs: noinline nounwind uwtable
define internal %struct.ck_epoch_record* @ck_epoch_scan(%struct.ck_epoch* %0, %struct.ck_epoch_record* %1, i32 %2, i8* %3) #0 !dbg !628 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch* %0, metadata !632, metadata !DIExpression()), !dbg !633
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %1, metadata !634, metadata !DIExpression()), !dbg !633
  call void @llvm.dbg.value(metadata i32 %2, metadata !635, metadata !DIExpression()), !dbg !633
  call void @llvm.dbg.value(metadata i8* %3, metadata !636, metadata !DIExpression()), !dbg !633
  %5 = icmp eq %struct.ck_epoch_record* %1, null, !dbg !637
  br i1 %5, label %6, label %12, !dbg !639

6:                                                ; preds = %4
  %7 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %0, i32 0, i32 2, !dbg !640
  %8 = getelementptr inbounds %struct.ck_stack, %struct.ck_stack* %7, i32 0, i32 0, !dbg !640
  %9 = bitcast %struct.ck_stack_entry** %8 to i64*, !dbg !640
  %10 = load atomic i64, i64* %9 monotonic, align 8, !dbg !640
  %11 = inttoptr i64 %10 to %struct.ck_stack_entry*, !dbg !640
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %11, metadata !642, metadata !DIExpression()), !dbg !633
  store i8 0, i8* %3, align 1, !dbg !643
  br label %14, !dbg !644

12:                                               ; preds = %4
  %13 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %1, i32 0, i32 0, !dbg !645
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %13, metadata !642, metadata !DIExpression()), !dbg !633
  store i8 1, i8* %3, align 1, !dbg !647
  br label %14

14:                                               ; preds = %12, %6
  %.01 = phi %struct.ck_stack_entry* [ %11, %6 ], [ %13, %12 ], !dbg !648
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %.01, metadata !642, metadata !DIExpression()), !dbg !633
  call void @__VERIFIER_loop_bound(i32 5), !dbg !649
  br label %15, !dbg !650

15:                                               ; preds = %.backedge, %14
  %.1 = phi %struct.ck_stack_entry* [ %.01, %14 ], [ %.1.be, %.backedge ], !dbg !633
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %.1, metadata !642, metadata !DIExpression()), !dbg !633
  %16 = icmp ne %struct.ck_stack_entry* %.1, null, !dbg !651
  br i1 %16, label %17, label %47, !dbg !650

17:                                               ; preds = %15
  %18 = call %struct.ck_epoch_record* @ck_epoch_record_container(%struct.ck_stack_entry* %.1), !dbg !652
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %18, metadata !634, metadata !DIExpression()), !dbg !633
  %19 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %18, i32 0, i32 2, !dbg !654
  %20 = load atomic i32, i32* %19 monotonic, align 8, !dbg !654
  call void @llvm.dbg.value(metadata i32 %20, metadata !655, metadata !DIExpression()), !dbg !656
  %21 = and i32 %20, 1, !dbg !657
  %22 = icmp ne i32 %21, 0, !dbg !657
  br i1 %22, label %23, label %28, !dbg !659

23:                                               ; preds = %17
  %24 = getelementptr inbounds %struct.ck_stack_entry, %struct.ck_stack_entry* %.1, i32 0, i32 0, !dbg !660
  %25 = bitcast %struct.ck_stack_entry** %24 to i64*, !dbg !660
  %26 = load atomic i64, i64* %25 monotonic, align 8, !dbg !660
  %27 = inttoptr i64 %26 to %struct.ck_stack_entry*, !dbg !660
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %27, metadata !642, metadata !DIExpression()), !dbg !633
  br label %.backedge, !dbg !662

.backedge:                                        ; preds = %23, %42
  %.1.be = phi %struct.ck_stack_entry* [ %27, %23 ], [ %46, %42 ]
  br label %15, !dbg !633, !llvm.loop !663

28:                                               ; preds = %17
  %29 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %18, i32 0, i32 4, !dbg !665
  %30 = load atomic i32, i32* %29 monotonic, align 8, !dbg !665
  call void @llvm.dbg.value(metadata i32 %30, metadata !666, metadata !DIExpression()), !dbg !656
  %31 = load i8, i8* %3, align 1, !dbg !667
  %32 = trunc i8 %31 to i1, !dbg !667
  %33 = zext i1 %32 to i32, !dbg !667
  %34 = or i32 %33, %30, !dbg !667
  %35 = icmp ne i32 %34, 0, !dbg !667
  %36 = zext i1 %35 to i8, !dbg !667
  store i8 %36, i8* %3, align 1, !dbg !667
  %37 = icmp ne i32 %30, 0, !dbg !668
  br i1 %37, label %38, label %42, !dbg !670

38:                                               ; preds = %28
  %39 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %18, i32 0, i32 3, !dbg !671
  %40 = load atomic i32, i32* %39 monotonic, align 4, !dbg !671
  %41 = icmp ne i32 %40, %2, !dbg !672
  br i1 %41, label %47, label %42, !dbg !673

42:                                               ; preds = %38, %28
  %43 = getelementptr inbounds %struct.ck_stack_entry, %struct.ck_stack_entry* %.1, i32 0, i32 0, !dbg !674
  %44 = bitcast %struct.ck_stack_entry** %43 to i64*, !dbg !674
  %45 = load atomic i64, i64* %44 monotonic, align 8, !dbg !674
  %46 = inttoptr i64 %45 to %struct.ck_stack_entry*, !dbg !674
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %46, metadata !642, metadata !DIExpression()), !dbg !633
  br label %.backedge, !dbg !650

47:                                               ; preds = %15, %38
  %.0 = phi %struct.ck_epoch_record* [ %18, %38 ], [ null, %15 ], !dbg !633
  ret %struct.ck_epoch_record* %.0, !dbg !675
}

; Function Attrs: noinline nounwind uwtable
define internal void @epoch_block(%struct.ck_epoch* %0, %struct.ck_epoch_record* %1, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* %2, i8* %3) #0 !dbg !676 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch* %0, metadata !679, metadata !DIExpression()), !dbg !680
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %1, metadata !681, metadata !DIExpression()), !dbg !680
  call void @llvm.dbg.value(metadata void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* %2, metadata !682, metadata !DIExpression()), !dbg !680
  call void @llvm.dbg.value(metadata i8* %3, metadata !683, metadata !DIExpression()), !dbg !680
  %5 = icmp ne void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* %2, null, !dbg !684
  br i1 %5, label %6, label %7, !dbg !686

6:                                                ; preds = %4
  call void %2(%struct.ck_epoch* %0, %struct.ck_epoch_record* %1, i8* %3), !dbg !687
  br label %7, !dbg !687

7:                                                ; preds = %6, %4
  ret void, !dbg !688
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @ck_epoch_synchronize(%struct.ck_epoch_record* %0) #0 !dbg !689 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %0, metadata !690, metadata !DIExpression()), !dbg !691
  %2 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 1, !dbg !692
  %3 = load %struct.ck_epoch*, %struct.ck_epoch** %2, align 8, !dbg !692
  call void @ck_epoch_synchronize_wait(%struct.ck_epoch* %3, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* null, i8* null), !dbg !693
  ret void, !dbg !694
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @ck_epoch_barrier(%struct.ck_epoch_record* %0) #0 !dbg !695 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %0, metadata !696, metadata !DIExpression()), !dbg !697
  call void @ck_epoch_synchronize(%struct.ck_epoch_record* %0), !dbg !698
  call void @ck_epoch_reclaim(%struct.ck_epoch_record* %0), !dbg !699
  ret void, !dbg !700
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @ck_epoch_barrier_wait(%struct.ck_epoch_record* %0, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* %1, i8* %2) #0 !dbg !701 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %0, metadata !704, metadata !DIExpression()), !dbg !705
  call void @llvm.dbg.value(metadata void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* %1, metadata !706, metadata !DIExpression()), !dbg !705
  call void @llvm.dbg.value(metadata i8* %2, metadata !707, metadata !DIExpression()), !dbg !705
  %4 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 1, !dbg !708
  %5 = load %struct.ck_epoch*, %struct.ck_epoch** %4, align 8, !dbg !708
  call void @ck_epoch_synchronize_wait(%struct.ck_epoch* %5, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* %1, i8* %2), !dbg !709
  call void @ck_epoch_reclaim(%struct.ck_epoch_record* %0), !dbg !710
  ret void, !dbg !711
}

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @ck_epoch_poll_deferred(%struct.ck_epoch_record* %0, %struct.ck_stack* %1) #0 !dbg !712 {
  %3 = alloca i8, align 1
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %0, metadata !715, metadata !DIExpression()), !dbg !716
  call void @llvm.dbg.value(metadata %struct.ck_stack* %1, metadata !717, metadata !DIExpression()), !dbg !716
  call void @llvm.dbg.declare(metadata i8* %3, metadata !718, metadata !DIExpression()), !dbg !719
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* null, metadata !720, metadata !DIExpression()), !dbg !716
  %4 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 1, !dbg !721
  %5 = load %struct.ck_epoch*, %struct.ck_epoch** %4, align 8, !dbg !721
  call void @llvm.dbg.value(metadata %struct.ck_epoch* %5, metadata !722, metadata !DIExpression()), !dbg !716
  call void @llvm.dbg.value(metadata i32 0, metadata !723, metadata !DIExpression()), !dbg !716
  %6 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %5, i32 0, i32 0, !dbg !724
  %7 = load atomic i32, i32* %6 monotonic, align 8, !dbg !724
  call void @llvm.dbg.value(metadata i32 %7, metadata !725, metadata !DIExpression()), !dbg !716
  fence seq_cst, !dbg !726
  %8 = call %struct.ck_epoch_record* @ck_epoch_scan(%struct.ck_epoch* %5, %struct.ck_epoch_record* null, i32 %7, i8* %3), !dbg !727
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %8, metadata !720, metadata !DIExpression()), !dbg !716
  %9 = icmp ne %struct.ck_epoch_record* %8, null, !dbg !728
  br i1 %9, label %22, label %10, !dbg !730

10:                                               ; preds = %2
  %11 = load i8, i8* %3, align 1, !dbg !731
  %12 = trunc i8 %11 to i1, !dbg !731
  %13 = zext i1 %12 to i32, !dbg !731
  %14 = icmp eq i32 %13, 0, !dbg !733
  br i1 %14, label %15, label %17, !dbg !734

15:                                               ; preds = %10
  %16 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 3, !dbg !735
  store atomic i32 %7, i32* %16 monotonic, align 4, !dbg !735
  br label %22, !dbg !737

17:                                               ; preds = %10
  call void @llvm.dbg.value(metadata i32 %7, metadata !738, metadata !DIExpression()), !dbg !740
  %18 = add i32 %7, 1, !dbg !741
  %19 = cmpxchg i32* %6, i32 %7, i32 %18 monotonic monotonic, align 4, !dbg !741
  %20 = extractvalue { i32, i1 } %19, 1, !dbg !741
  %21 = zext i1 %20 to i8, !dbg !741
  br label %22, !dbg !742

22:                                               ; preds = %2, %17, %15
  %.0 = phi i1 [ true, %15 ], [ true, %17 ], [ false, %2 ], !dbg !716
  ret i1 %.0, !dbg !743
}

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @ck_epoch_poll(%struct.ck_epoch_record* %0) #0 !dbg !744 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %0, metadata !747, metadata !DIExpression()), !dbg !748
  %2 = call zeroext i1 @ck_epoch_poll_deferred(%struct.ck_epoch_record* %0, %struct.ck_stack* null), !dbg !749
  ret i1 %2, !dbg !750
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noreturn nounwind "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { argmemonly nofree nounwind willreturn writeonly }
attributes #6 = { nounwind }
attributes #7 = { noreturn nounwind }

!llvm.dbg.cu = !{!2, !73}
!llvm.ident = !{!136, !136}
!llvm.module.flags = !{!137, !138, !139}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "stack_epoch", scope: !2, file: !3, line: 48, type: !72, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 12.0.0-3ubuntu1~20.04.5", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !68, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "client-code.c", directory: "/home/ponce/git/SMR-verification/verification/ck/ck_epoch")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 47, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/lib/llvm-12/lib/clang/12.0.0/include/stdatomic.h", directory: "")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0, isUnsigned: true)
!10 = !DIEnumerator(name: "memory_order_consume", value: 1, isUnsigned: true)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2, isUnsigned: true)
!12 = !DIEnumerator(name: "memory_order_release", value: 3, isUnsigned: true)
!13 = !DIEnumerator(name: "memory_order_acq_rel", value: 4, isUnsigned: true)
!14 = !DIEnumerator(name: "memory_order_seq_cst", value: 5, isUnsigned: true)
!15 = !{!16, !17}
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!17 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !18, size: 64)
!18 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_record_t", file: !19, line: 101, baseType: !20)
!19 = !DIFile(filename: "./ck_epoch.h", directory: "/home/ponce/git/SMR-verification/verification/ck/ck_epoch")
!20 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_epoch_record", file: !19, line: 86, size: 1024, elements: !21)
!21 = !{!22, !30, !45, !46, !47, !48, !59, !60, !61, !62, !64}
!22 = !DIDerivedType(tag: DW_TAG_member, name: "record_next", scope: !20, file: !19, line: 87, baseType: !23, size: 64)
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_stack_entry_t", file: !24, line: 41, baseType: !25)
!24 = !DIFile(filename: "./ck_stack.h", directory: "/home/ponce/git/SMR-verification/verification/ck/ck_epoch")
!25 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_stack_entry", file: !24, line: 37, size: 64, elements: !26)
!26 = !{!27}
!27 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !25, file: !24, line: 38, baseType: !28, size: 64)
!28 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !29)
!29 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !25, size: 64)
!30 = !DIDerivedType(tag: DW_TAG_member, name: "global", scope: !20, file: !19, line: 88, baseType: !31, size: 64, offset: 64)
!31 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !32, size: 64)
!32 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_epoch", file: !19, line: 103, size: 192, elements: !33)
!33 = !{!34, !36, !37}
!34 = !DIDerivedType(tag: DW_TAG_member, name: "epoch", scope: !32, file: !19, line: 104, baseType: !35, size: 32)
!35 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !7)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "n_free", scope: !32, file: !19, line: 105, baseType: !35, size: 32, offset: 32)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "records", scope: !32, file: !19, line: 106, baseType: !38, size: 128, offset: 64)
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_stack_t", file: !24, line: 47, baseType: !39)
!39 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_stack", file: !24, line: 43, size: 128, elements: !40)
!40 = !{!41, !42}
!41 = !DIDerivedType(tag: DW_TAG_member, name: "head", scope: !39, file: !24, line: 44, baseType: !28, size: 64)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "generation", scope: !39, file: !24, line: 45, baseType: !43, size: 64, offset: 64)
!43 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 64)
!44 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!45 = !DIDerivedType(tag: DW_TAG_member, name: "state", scope: !20, file: !19, line: 89, baseType: !35, size: 32, offset: 128)
!46 = !DIDerivedType(tag: DW_TAG_member, name: "epoch", scope: !20, file: !19, line: 90, baseType: !35, size: 32, offset: 160)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "active", scope: !20, file: !19, line: 91, baseType: !35, size: 32, offset: 192)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "local", scope: !20, file: !19, line: 94, baseType: !49, size: 128, offset: 224)
!49 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !20, file: !19, line: 92, size: 128, elements: !50)
!50 = !{!51}
!51 = !DIDerivedType(tag: DW_TAG_member, name: "bucket", scope: !49, file: !19, line: 93, baseType: !52, size: 128)
!52 = !DICompositeType(tag: DW_TAG_array_type, baseType: !53, size: 128, elements: !57)
!53 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_epoch_ref", file: !19, line: 80, size: 64, elements: !54)
!54 = !{!55, !56}
!55 = !DIDerivedType(tag: DW_TAG_member, name: "epoch", scope: !53, file: !19, line: 81, baseType: !7, size: 32)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "count", scope: !53, file: !19, line: 82, baseType: !7, size: 32, offset: 32)
!57 = !{!58}
!58 = !DISubrange(count: 2)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "n_pending", scope: !20, file: !19, line: 95, baseType: !35, size: 32, offset: 352)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "n_peak", scope: !20, file: !19, line: 96, baseType: !35, size: 32, offset: 384)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "n_dispatch", scope: !20, file: !19, line: 97, baseType: !35, size: 32, offset: 416)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "ct", scope: !20, file: !19, line: 98, baseType: !63, size: 64, offset: 448)
!63 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !16)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "pending", scope: !20, file: !19, line: 99, baseType: !65, size: 512, offset: 512)
!65 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 512, elements: !66)
!66 = !{!67}
!67 = !DISubrange(count: 4)
!68 = !{!0, !69}
!69 = !DIGlobalVariableExpression(var: !70, expr: !DIExpression())
!70 = distinct !DIGlobalVariable(name: "records", scope: !2, file: !3, line: 71, type: !71, isLocal: false, isDefinition: true)
!71 = !DICompositeType(tag: DW_TAG_array_type, baseType: !18, size: 4096, elements: !66)
!72 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_t", file: !19, line: 108, baseType: !32)
!73 = distinct !DICompileUnit(language: DW_LANG_C99, file: !74, producer: "Ubuntu clang version 12.0.0-3ubuntu1~20.04.5", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !75, retainedTypes: !80, splitDebugInlining: false, nameTableKind: None)
!74 = !DIFile(filename: "ck_epoch.c", directory: "/home/ponce/git/SMR-verification/verification/ck/ck_epoch")
!75 = !{!5, !76}
!76 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !74, line: 140, baseType: !7, size: 32, elements: !77)
!77 = !{!78, !79}
!78 = !DIEnumerator(name: "CK_EPOCH_STATE_USED", value: 0, isUnsigned: true)
!79 = !DIEnumerator(name: "CK_EPOCH_STATE_FREE", value: 1, isUnsigned: true)
!80 = !{!81, !16, !82, !43, !122, !125}
!81 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!82 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !83, size: 64)
!83 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_epoch_record", file: !19, line: 86, size: 1024, elements: !84)
!84 = !{!85, !92, !104, !105, !106, !107, !116, !117, !118, !119, !120}
!85 = !DIDerivedType(tag: DW_TAG_member, name: "record_next", scope: !83, file: !19, line: 87, baseType: !86, size: 64)
!86 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_stack_entry_t", file: !24, line: 41, baseType: !87)
!87 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_stack_entry", file: !24, line: 37, size: 64, elements: !88)
!88 = !{!89}
!89 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !87, file: !24, line: 38, baseType: !90, size: 64)
!90 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !91)
!91 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !87, size: 64)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "global", scope: !83, file: !19, line: 88, baseType: !93, size: 64, offset: 64)
!93 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !94, size: 64)
!94 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_epoch", file: !19, line: 103, size: 192, elements: !95)
!95 = !{!96, !97, !98}
!96 = !DIDerivedType(tag: DW_TAG_member, name: "epoch", scope: !94, file: !19, line: 104, baseType: !35, size: 32)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "n_free", scope: !94, file: !19, line: 105, baseType: !35, size: 32, offset: 32)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "records", scope: !94, file: !19, line: 106, baseType: !99, size: 128, offset: 64)
!99 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_stack_t", file: !24, line: 47, baseType: !100)
!100 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_stack", file: !24, line: 43, size: 128, elements: !101)
!101 = !{!102, !103}
!102 = !DIDerivedType(tag: DW_TAG_member, name: "head", scope: !100, file: !24, line: 44, baseType: !90, size: 64)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "generation", scope: !100, file: !24, line: 45, baseType: !43, size: 64, offset: 64)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "state", scope: !83, file: !19, line: 89, baseType: !35, size: 32, offset: 128)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "epoch", scope: !83, file: !19, line: 90, baseType: !35, size: 32, offset: 160)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "active", scope: !83, file: !19, line: 91, baseType: !35, size: 32, offset: 192)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "local", scope: !83, file: !19, line: 94, baseType: !108, size: 128, offset: 224)
!108 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !83, file: !19, line: 92, size: 128, elements: !109)
!109 = !{!110}
!110 = !DIDerivedType(tag: DW_TAG_member, name: "bucket", scope: !108, file: !19, line: 93, baseType: !111, size: 128)
!111 = !DICompositeType(tag: DW_TAG_array_type, baseType: !112, size: 128, elements: !57)
!112 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_epoch_ref", file: !19, line: 80, size: 64, elements: !113)
!113 = !{!114, !115}
!114 = !DIDerivedType(tag: DW_TAG_member, name: "epoch", scope: !112, file: !19, line: 81, baseType: !7, size: 32)
!115 = !DIDerivedType(tag: DW_TAG_member, name: "count", scope: !112, file: !19, line: 82, baseType: !7, size: 32, offset: 32)
!116 = !DIDerivedType(tag: DW_TAG_member, name: "n_pending", scope: !83, file: !19, line: 95, baseType: !35, size: 32, offset: 352)
!117 = !DIDerivedType(tag: DW_TAG_member, name: "n_peak", scope: !83, file: !19, line: 96, baseType: !35, size: 32, offset: 384)
!118 = !DIDerivedType(tag: DW_TAG_member, name: "n_dispatch", scope: !83, file: !19, line: 97, baseType: !35, size: 32, offset: 416)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "ct", scope: !83, file: !19, line: 98, baseType: !63, size: 64, offset: 448)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "pending", scope: !83, file: !19, line: 99, baseType: !121, size: 512, offset: 512)
!121 = !DICompositeType(tag: DW_TAG_array_type, baseType: !99, size: 512, elements: !66)
!122 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !123, line: 46, baseType: !124)
!123 = !DIFile(filename: "/usr/lib/llvm-12/lib/clang/12.0.0/include/stddef.h", directory: "")
!124 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!125 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !126, size: 64)
!126 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_epoch_entry", file: !19, line: 60, size: 128, elements: !127)
!127 = !{!128, !135}
!128 = !DIDerivedType(tag: DW_TAG_member, name: "function", scope: !126, file: !19, line: 61, baseType: !129, size: 64)
!129 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !130, size: 64)
!130 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_cb_t", file: !19, line: 54, baseType: !131)
!131 = !DISubroutineType(types: !132)
!132 = !{null, !133}
!133 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !134, size: 64)
!134 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_entry_t", file: !19, line: 53, baseType: !126)
!135 = !DIDerivedType(tag: DW_TAG_member, name: "stack_entry", scope: !126, file: !19, line: 62, baseType: !86, size: 64, offset: 64)
!136 = !{!"Ubuntu clang version 12.0.0-3ubuntu1~20.04.5"}
!137 = !{i32 7, !"Dwarf Version", i32 4}
!138 = !{i32 2, !"Debug Info Version", i32 3}
!139 = !{i32 1, !"wchar_size", i32 4}
!140 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 73, type: !141, scopeLine: 74, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !144)
!141 = !DISubroutineType(types: !142)
!142 = !{!81, !81, !143}
!143 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !43, size: 64)
!144 = !{}
!145 = !DILocalVariable(name: "argc", arg: 1, scope: !140, file: !3, line: 73, type: !81)
!146 = !DILocation(line: 0, scope: !140)
!147 = !DILocalVariable(name: "argv", arg: 2, scope: !140, file: !3, line: 73, type: !143)
!148 = !DILocalVariable(name: "threads", scope: !140, file: !3, line: 75, type: !149)
!149 = !DICompositeType(tag: DW_TAG_array_type, baseType: !150, size: 256, elements: !66)
!150 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !151, line: 27, baseType: !124)
!151 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "")
!152 = !DILocation(line: 75, column: 12, scope: !140)
!153 = !DILocation(line: 77, column: 2, scope: !140)
!154 = !DILocation(line: 79, column: 2, scope: !140)
!155 = !DILocalVariable(name: "i", scope: !156, file: !3, line: 80, type: !81)
!156 = distinct !DILexicalBlock(scope: !140, file: !3, line: 80, column: 2)
!157 = !DILocation(line: 0, scope: !156)
!158 = !DILocation(line: 81, column: 3, scope: !159)
!159 = distinct !DILexicalBlock(scope: !160, file: !3, line: 80, column: 37)
!160 = distinct !DILexicalBlock(scope: !156, file: !3, line: 80, column: 2)
!161 = !DILocation(line: 82, column: 19, scope: !159)
!162 = !DILocation(line: 82, column: 3, scope: !159)
!163 = !DILocation(line: 85, column: 2, scope: !140)
!164 = !DILocalVariable(name: "i", scope: !165, file: !3, line: 86, type: !81)
!165 = distinct !DILexicalBlock(scope: !140, file: !3, line: 86, column: 2)
!166 = !DILocation(line: 0, scope: !165)
!167 = !DILocation(line: 87, column: 16, scope: !168)
!168 = distinct !DILexicalBlock(scope: !165, file: !3, line: 86, column: 2)
!169 = !DILocation(line: 87, column: 3, scope: !168)
!170 = !DILocation(line: 89, column: 2, scope: !140)
!171 = distinct !DISubprogram(name: "thread", scope: !3, file: !3, line: 50, type: !172, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !144)
!172 = !DISubroutineType(types: !173)
!173 = !{!16, !16}
!174 = !DILocalVariable(name: "arg", arg: 1, scope: !171, file: !3, line: 50, type: !16)
!175 = !DILocation(line: 0, scope: !171)
!176 = !DILocation(line: 52, column: 30, scope: !171)
!177 = !DILocalVariable(name: "record", scope: !171, file: !3, line: 52, type: !17)
!178 = !DILocation(line: 57, column: 2, scope: !171)
!179 = !DILocation(line: 58, column: 21, scope: !171)
!180 = !DILocalVariable(name: "global_epoch", scope: !171, file: !3, line: 58, type: !81)
!181 = !DILocation(line: 59, column: 20, scope: !171)
!182 = !DILocalVariable(name: "local_epoch", scope: !171, file: !3, line: 59, type: !81)
!183 = !DILocation(line: 60, column: 2, scope: !171)
!184 = !DILocation(line: 63, column: 2, scope: !185)
!185 = distinct !DILexicalBlock(scope: !186, file: !3, line: 63, column: 2)
!186 = distinct !DILexicalBlock(scope: !171, file: !3, line: 63, column: 2)
!187 = !DILocation(line: 65, column: 2, scope: !171)
!188 = !DILocation(line: 67, column: 2, scope: !171)
!189 = distinct !DISubprogram(name: "ck_epoch_begin", scope: !19, file: !19, line: 127, type: !190, scopeLine: 128, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !144)
!190 = !DISubroutineType(types: !191)
!191 = !{null, !17, !192}
!192 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !193, size: 64)
!193 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_section_t", file: !19, line: 72, baseType: !194)
!194 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_epoch_section", file: !19, line: 69, size: 32, elements: !195)
!195 = !{!196}
!196 = !DIDerivedType(tag: DW_TAG_member, name: "bucket", scope: !194, file: !19, line: 70, baseType: !7, size: 32)
!197 = !DILocalVariable(name: "record", arg: 1, scope: !189, file: !19, line: 127, type: !17)
!198 = !DILocation(line: 0, scope: !189)
!199 = !DILocalVariable(name: "section", arg: 2, scope: !189, file: !19, line: 127, type: !192)
!200 = !DILocation(line: 129, column: 35, scope: !189)
!201 = !DILocalVariable(name: "epoch", scope: !189, file: !19, line: 129, type: !31)
!202 = !DILocation(line: 135, column: 6, scope: !203)
!203 = distinct !DILexicalBlock(scope: !189, file: !19, line: 135, column: 6)
!204 = !DILocation(line: 135, column: 39, scope: !203)
!205 = !DILocation(line: 135, column: 6, scope: !189)
!206 = !DILocation(line: 147, column: 3, scope: !207)
!207 = distinct !DILexicalBlock(scope: !203, file: !19, line: 135, column: 45)
!208 = !DILocation(line: 148, column: 3, scope: !207)
!209 = !DILocation(line: 158, column: 13, scope: !207)
!210 = !DILocalVariable(name: "g_epoch", scope: !207, file: !19, line: 136, type: !7)
!211 = !DILocation(line: 0, scope: !207)
!212 = !DILocation(line: 159, column: 3, scope: !207)
!213 = !DILocation(line: 160, column: 2, scope: !207)
!214 = !DILocation(line: 161, column: 3, scope: !215)
!215 = distinct !DILexicalBlock(scope: !203, file: !19, line: 160, column: 9)
!216 = !DILocation(line: 164, column: 14, scope: !217)
!217 = distinct !DILexicalBlock(scope: !189, file: !19, line: 164, column: 6)
!218 = !DILocation(line: 164, column: 6, scope: !189)
!219 = !DILocation(line: 165, column: 3, scope: !217)
!220 = !DILocation(line: 167, column: 2, scope: !189)
!221 = distinct !DISubprogram(name: "ck_epoch_end", scope: !19, file: !19, line: 175, type: !222, scopeLine: 176, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !144)
!222 = !DISubroutineType(types: !223)
!223 = !{!224, !17, !192}
!224 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!225 = !DILocalVariable(name: "record", arg: 1, scope: !221, file: !19, line: 175, type: !17)
!226 = !DILocation(line: 0, scope: !221)
!227 = !DILocalVariable(name: "section", arg: 2, scope: !221, file: !19, line: 175, type: !192)
!228 = !DILocation(line: 178, column: 2, scope: !221)
!229 = !DILocation(line: 179, column: 2, scope: !221)
!230 = !DILocation(line: 181, column: 14, scope: !231)
!231 = distinct !DILexicalBlock(scope: !221, file: !19, line: 181, column: 6)
!232 = !DILocation(line: 181, column: 6, scope: !221)
!233 = !DILocation(line: 182, column: 10, scope: !231)
!234 = !DILocation(line: 182, column: 3, scope: !231)
!235 = !DILocation(line: 184, column: 9, scope: !221)
!236 = !DILocation(line: 184, column: 42, scope: !221)
!237 = !DILocation(line: 184, column: 2, scope: !221)
!238 = !DILocation(line: 185, column: 1, scope: !221)
!239 = distinct !DISubprogram(name: "_ck_epoch_delref", scope: !74, file: !74, line: 153, type: !240, scopeLine: 155, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !144)
!240 = !DISubroutineType(types: !241)
!241 = !{!224, !82, !242}
!242 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !243, size: 64)
!243 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_epoch_section", file: !19, line: 69, size: 32, elements: !244)
!244 = !{!245}
!245 = !DIDerivedType(tag: DW_TAG_member, name: "bucket", scope: !243, file: !19, line: 70, baseType: !7, size: 32)
!246 = !DILocalVariable(name: "record", arg: 1, scope: !239, file: !74, line: 153, type: !82)
!247 = !DILocation(line: 0, scope: !239)
!248 = !DILocalVariable(name: "section", arg: 2, scope: !239, file: !74, line: 154, type: !242)
!249 = !DILocation(line: 157, column: 28, scope: !239)
!250 = !DILocalVariable(name: "i", scope: !239, file: !74, line: 157, type: !7)
!251 = !DILocation(line: 159, column: 21, scope: !239)
!252 = !DILocation(line: 159, column: 27, scope: !239)
!253 = !DILocation(line: 159, column: 13, scope: !239)
!254 = !DILocalVariable(name: "current", scope: !239, file: !74, line: 156, type: !255)
!255 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !112, size: 64)
!256 = !DILocation(line: 160, column: 11, scope: !239)
!257 = !DILocation(line: 160, column: 16, scope: !239)
!258 = !DILocation(line: 162, column: 21, scope: !259)
!259 = distinct !DILexicalBlock(scope: !239, file: !74, line: 162, column: 6)
!260 = !DILocation(line: 162, column: 6, scope: !239)
!261 = !DILocation(line: 174, column: 35, scope: !239)
!262 = !DILocation(line: 174, column: 40, scope: !239)
!263 = !DILocation(line: 174, column: 11, scope: !239)
!264 = !DILocalVariable(name: "other", scope: !239, file: !74, line: 156, type: !255)
!265 = !DILocation(line: 175, column: 13, scope: !266)
!266 = distinct !DILexicalBlock(scope: !239, file: !74, line: 175, column: 6)
!267 = !DILocation(line: 175, column: 19, scope: !266)
!268 = !DILocation(line: 175, column: 23, scope: !266)
!269 = !DILocation(line: 176, column: 22, scope: !266)
!270 = !DILocation(line: 176, column: 37, scope: !266)
!271 = !DILocation(line: 176, column: 28, scope: !266)
!272 = !DILocation(line: 176, column: 44, scope: !266)
!273 = !DILocation(line: 175, column: 6, scope: !239)
!274 = !DILocation(line: 181, column: 3, scope: !275)
!275 = distinct !DILexicalBlock(scope: !266, file: !74, line: 176, column: 50)
!276 = !DILocation(line: 182, column: 2, scope: !275)
!277 = !DILocation(line: 185, column: 1, scope: !239)
!278 = distinct !DISubprogram(name: "_ck_epoch_addref", scope: !74, file: !74, line: 188, type: !279, scopeLine: 190, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !144)
!279 = !DISubroutineType(types: !280)
!280 = !{null, !82, !242}
!281 = !DILocalVariable(name: "record", arg: 1, scope: !278, file: !74, line: 188, type: !82)
!282 = !DILocation(line: 0, scope: !278)
!283 = !DILocalVariable(name: "section", arg: 2, scope: !278, file: !74, line: 189, type: !242)
!284 = !DILocation(line: 191, column: 36, scope: !278)
!285 = !DILocalVariable(name: "global", scope: !278, file: !74, line: 191, type: !93)
!286 = !DILocation(line: 195, column: 10, scope: !278)
!287 = !DILocalVariable(name: "epoch", scope: !278, file: !74, line: 193, type: !7)
!288 = !DILocation(line: 196, column: 12, scope: !278)
!289 = !DILocalVariable(name: "i", scope: !278, file: !74, line: 193, type: !7)
!290 = !DILocation(line: 197, column: 17, scope: !278)
!291 = !DILocation(line: 197, column: 23, scope: !278)
!292 = !DILocation(line: 197, column: 9, scope: !278)
!293 = !DILocalVariable(name: "ref", scope: !278, file: !74, line: 192, type: !255)
!294 = !DILocation(line: 199, column: 11, scope: !295)
!295 = distinct !DILexicalBlock(scope: !278, file: !74, line: 199, column: 6)
!296 = !DILocation(line: 199, column: 16, scope: !295)
!297 = !DILocation(line: 199, column: 19, scope: !295)
!298 = !DILocation(line: 199, column: 6, scope: !278)
!299 = !DILocation(line: 213, column: 39, scope: !300)
!300 = distinct !DILexicalBlock(scope: !295, file: !74, line: 199, column: 25)
!301 = !DILocation(line: 213, column: 44, scope: !300)
!302 = !DILocation(line: 213, column: 15, scope: !300)
!303 = !DILocalVariable(name: "previous", scope: !300, file: !74, line: 201, type: !255)
!304 = !DILocation(line: 0, scope: !300)
!305 = !DILocation(line: 215, column: 17, scope: !306)
!306 = distinct !DILexicalBlock(scope: !300, file: !74, line: 215, column: 7)
!307 = !DILocation(line: 215, column: 23, scope: !306)
!308 = !DILocation(line: 215, column: 7, scope: !300)
!309 = !DILocation(line: 216, column: 4, scope: !306)
!310 = !DILocation(line: 223, column: 8, scope: !300)
!311 = !DILocation(line: 223, column: 14, scope: !300)
!312 = !DILocation(line: 224, column: 2, scope: !300)
!313 = !DILocation(line: 226, column: 11, scope: !278)
!314 = !DILocation(line: 226, column: 18, scope: !278)
!315 = !DILocation(line: 227, column: 2, scope: !278)
!316 = distinct !DISubprogram(name: "ck_epoch_init", scope: !74, file: !74, line: 231, type: !317, scopeLine: 232, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !144)
!317 = !DISubroutineType(types: !318)
!318 = !{null, !93}
!319 = !DILocalVariable(name: "global", arg: 1, scope: !316, file: !74, line: 231, type: !93)
!320 = !DILocation(line: 0, scope: !316)
!321 = !DILocation(line: 234, column: 25, scope: !316)
!322 = !DILocation(line: 234, column: 2, scope: !316)
!323 = !DILocation(line: 235, column: 10, scope: !316)
!324 = !DILocation(line: 235, column: 16, scope: !316)
!325 = !DILocation(line: 236, column: 10, scope: !316)
!326 = !DILocation(line: 236, column: 17, scope: !316)
!327 = !DILocation(line: 237, column: 2, scope: !316)
!328 = !DILocation(line: 238, column: 2, scope: !316)
!329 = distinct !DISubprogram(name: "ck_stack_init", scope: !24, file: !24, line: 337, type: !330, scopeLine: 338, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !73, retainedNodes: !144)
!330 = !DISubroutineType(types: !331)
!331 = !{null, !332}
!332 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !100, size: 64)
!333 = !DILocalVariable(name: "stack", arg: 1, scope: !329, file: !24, line: 337, type: !332)
!334 = !DILocation(line: 0, scope: !329)
!335 = !DILocation(line: 340, column: 9, scope: !329)
!336 = !DILocation(line: 340, column: 14, scope: !329)
!337 = !DILocation(line: 341, column: 9, scope: !329)
!338 = !DILocation(line: 341, column: 20, scope: !329)
!339 = !DILocation(line: 342, column: 2, scope: !329)
!340 = distinct !DISubprogram(name: "ck_epoch_recycle", scope: !74, file: !74, line: 242, type: !341, scopeLine: 243, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !144)
!341 = !DISubroutineType(types: !342)
!342 = !{!343, !93, !16}
!343 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !344, size: 64)
!344 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_record_t", file: !19, line: 101, baseType: !83)
!345 = !DILocalVariable(name: "global", arg: 1, scope: !340, file: !74, line: 242, type: !93)
!346 = !DILocation(line: 0, scope: !340)
!347 = !DILocalVariable(name: "ct", arg: 2, scope: !340, file: !74, line: 242, type: !16)
!348 = !DILocation(line: 248, column: 6, scope: !349)
!349 = distinct !DILexicalBlock(scope: !340, file: !74, line: 248, column: 6)
!350 = !DILocation(line: 248, column: 39, scope: !349)
!351 = !DILocation(line: 248, column: 6, scope: !340)
!352 = !DILocation(line: 251, column: 2, scope: !353)
!353 = distinct !DILexicalBlock(scope: !340, file: !74, line: 251, column: 2)
!354 = !DILocalVariable(name: "cursor", scope: !340, file: !74, line: 245, type: !355)
!355 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !86, size: 64)
!356 = !DILocation(line: 0, scope: !353)
!357 = !DILocation(line: 251, column: 2, scope: !358)
!358 = distinct !DILexicalBlock(scope: !353, file: !74, line: 251, column: 2)
!359 = !DILocation(line: 252, column: 12, scope: !360)
!360 = distinct !DILexicalBlock(scope: !358, file: !74, line: 251, column: 45)
!361 = !DILocalVariable(name: "record", scope: !340, file: !74, line: 244, type: !82)
!362 = !DILocation(line: 254, column: 7, scope: !363)
!363 = distinct !DILexicalBlock(scope: !360, file: !74, line: 254, column: 7)
!364 = !DILocation(line: 254, column: 39, scope: !363)
!365 = !DILocation(line: 254, column: 7, scope: !360)
!366 = !DILocation(line: 256, column: 4, scope: !367)
!367 = distinct !DILexicalBlock(scope: !363, file: !74, line: 254, column: 63)
!368 = !DILocation(line: 257, column: 12, scope: !367)
!369 = !DILocalVariable(name: "state", scope: !340, file: !74, line: 246, type: !7)
!370 = !DILocation(line: 259, column: 14, scope: !371)
!371 = distinct !DILexicalBlock(scope: !367, file: !74, line: 259, column: 8)
!372 = !DILocation(line: 259, column: 8, scope: !367)
!373 = !DILocation(line: 260, column: 5, scope: !374)
!374 = distinct !DILexicalBlock(scope: !371, file: !74, line: 259, column: 38)
!375 = !DILocation(line: 261, column: 5, scope: !374)
!376 = !DILocation(line: 267, column: 5, scope: !374)
!377 = distinct !{!377, !352, !378, !379}
!378 = !DILocation(line: 270, column: 2, scope: !353)
!379 = !{!"llvm.loop.mustprogress"}
!380 = !DILocation(line: 273, column: 1, scope: !340)
!381 = distinct !DISubprogram(name: "ck_epoch_record_container", scope: !74, file: !74, line: 145, type: !382, scopeLine: 145, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !73, retainedNodes: !144)
!382 = !DISubroutineType(types: !383)
!383 = !{!82, !355}
!384 = !DILocalVariable(name: "p", arg: 1, scope: !381, file: !74, line: 145, type: !355)
!385 = !DILocation(line: 0, scope: !381)
!386 = !DILocalVariable(name: "n", scope: !381, file: !74, line: 145, type: !355)
!387 = !DILocation(line: 145, column: 1, scope: !381)
!388 = distinct !DISubprogram(name: "ck_epoch_register", scope: !74, file: !74, line: 276, type: !389, scopeLine: 278, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !144)
!389 = !DISubroutineType(types: !390)
!390 = !{null, !93, !82, !16}
!391 = !DILocalVariable(name: "global", arg: 1, scope: !388, file: !74, line: 276, type: !93)
!392 = !DILocation(line: 0, scope: !388)
!393 = !DILocalVariable(name: "record", arg: 2, scope: !388, file: !74, line: 276, type: !82)
!394 = !DILocalVariable(name: "ct", arg: 3, scope: !388, file: !74, line: 277, type: !16)
!395 = !DILocation(line: 281, column: 10, scope: !388)
!396 = !DILocation(line: 281, column: 17, scope: !388)
!397 = !DILocation(line: 282, column: 10, scope: !388)
!398 = !DILocation(line: 282, column: 16, scope: !388)
!399 = !DILocation(line: 283, column: 10, scope: !388)
!400 = !DILocation(line: 283, column: 17, scope: !388)
!401 = !DILocation(line: 284, column: 10, scope: !388)
!402 = !DILocation(line: 284, column: 16, scope: !388)
!403 = !DILocation(line: 285, column: 10, scope: !388)
!404 = !DILocation(line: 285, column: 21, scope: !388)
!405 = !DILocation(line: 286, column: 10, scope: !388)
!406 = !DILocation(line: 286, column: 17, scope: !388)
!407 = !DILocation(line: 287, column: 10, scope: !388)
!408 = !DILocation(line: 287, column: 20, scope: !388)
!409 = !DILocation(line: 288, column: 10, scope: !388)
!410 = !DILocation(line: 288, column: 13, scope: !388)
!411 = !DILocation(line: 289, column: 18, scope: !388)
!412 = !DILocation(line: 289, column: 2, scope: !388)
!413 = !DILocation(line: 290, column: 2, scope: !388)
!414 = !DILocalVariable(name: "i", scope: !388, file: !74, line: 279, type: !122)
!415 = !DILocation(line: 292, column: 26, scope: !416)
!416 = distinct !DILexicalBlock(scope: !417, file: !74, line: 291, column: 2)
!417 = distinct !DILexicalBlock(scope: !388, file: !74, line: 291, column: 2)
!418 = !DILocation(line: 292, column: 18, scope: !416)
!419 = !DILocation(line: 292, column: 3, scope: !416)
!420 = !DILocation(line: 294, column: 2, scope: !388)
!421 = !DILocation(line: 295, column: 30, scope: !388)
!422 = !DILocation(line: 295, column: 48, scope: !388)
!423 = !DILocation(line: 295, column: 2, scope: !388)
!424 = !DILocation(line: 296, column: 2, scope: !388)
!425 = distinct !DISubprogram(name: "ck_stack_push_upmc", scope: !24, file: !24, line: 57, type: !426, scopeLine: 58, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !73, retainedNodes: !144)
!426 = !DISubroutineType(types: !427)
!427 = !{null, !332, !91}
!428 = !DILocalVariable(name: "target", arg: 1, scope: !425, file: !24, line: 57, type: !332)
!429 = !DILocation(line: 0, scope: !425)
!430 = !DILocalVariable(name: "entry", arg: 2, scope: !425, file: !24, line: 57, type: !91)
!431 = !DILocation(line: 61, column: 10, scope: !425)
!432 = !DILocalVariable(name: "stack", scope: !425, file: !24, line: 59, type: !91)
!433 = !DILocation(line: 62, column: 9, scope: !425)
!434 = !DILocation(line: 62, column: 14, scope: !425)
!435 = !DILocation(line: 63, column: 2, scope: !425)
!436 = !DILocation(line: 65, column: 2, scope: !425)
!437 = !DILocation(line: 61, column: 8, scope: !425)
!438 = !DILocation(line: 65, column: 9, scope: !425)
!439 = !DILocation(line: 65, column: 66, scope: !425)
!440 = !DILocation(line: 66, column: 15, scope: !441)
!441 = distinct !DILexicalBlock(scope: !425, file: !24, line: 65, column: 76)
!442 = !DILocation(line: 67, column: 3, scope: !441)
!443 = distinct !{!443, !436, !444, !379}
!444 = !DILocation(line: 68, column: 2, scope: !425)
!445 = !DILocation(line: 70, column: 2, scope: !425)
!446 = distinct !DISubprogram(name: "ck_epoch_unregister", scope: !74, file: !74, line: 300, type: !447, scopeLine: 301, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !144)
!447 = !DISubroutineType(types: !448)
!448 = !{null, !82}
!449 = !DILocalVariable(name: "record", arg: 1, scope: !446, file: !74, line: 300, type: !82)
!450 = !DILocation(line: 0, scope: !446)
!451 = !DILocation(line: 302, column: 36, scope: !446)
!452 = !DILocalVariable(name: "global", scope: !446, file: !74, line: 302, type: !93)
!453 = !DILocation(line: 305, column: 10, scope: !446)
!454 = !DILocation(line: 305, column: 17, scope: !446)
!455 = !DILocation(line: 306, column: 10, scope: !446)
!456 = !DILocation(line: 306, column: 16, scope: !446)
!457 = !DILocation(line: 307, column: 10, scope: !446)
!458 = !DILocation(line: 307, column: 21, scope: !446)
!459 = !DILocation(line: 308, column: 10, scope: !446)
!460 = !DILocation(line: 308, column: 17, scope: !446)
!461 = !DILocation(line: 309, column: 10, scope: !446)
!462 = !DILocation(line: 309, column: 20, scope: !446)
!463 = !DILocation(line: 310, column: 18, scope: !446)
!464 = !DILocation(line: 310, column: 2, scope: !446)
!465 = !DILocalVariable(name: "i", scope: !446, file: !74, line: 303, type: !122)
!466 = !DILocation(line: 313, column: 26, scope: !467)
!467 = distinct !DILexicalBlock(scope: !468, file: !74, line: 312, column: 2)
!468 = distinct !DILexicalBlock(scope: !446, file: !74, line: 312, column: 2)
!469 = !DILocation(line: 313, column: 18, scope: !467)
!470 = !DILocation(line: 313, column: 3, scope: !467)
!471 = !DILocation(line: 315, column: 2, scope: !446)
!472 = !DILocation(line: 316, column: 2, scope: !446)
!473 = !DILocation(line: 317, column: 2, scope: !446)
!474 = !DILocation(line: 318, column: 2, scope: !446)
!475 = !DILocation(line: 319, column: 2, scope: !446)
!476 = distinct !DISubprogram(name: "ck_epoch_reclaim", scope: !74, file: !74, line: 404, type: !447, scopeLine: 405, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !144)
!477 = !DILocalVariable(name: "record", arg: 1, scope: !476, file: !74, line: 404, type: !82)
!478 = !DILocation(line: 0, scope: !476)
!479 = !DILocalVariable(name: "epoch", scope: !476, file: !74, line: 406, type: !7)
!480 = !DILocation(line: 409, column: 3, scope: !481)
!481 = distinct !DILexicalBlock(scope: !482, file: !74, line: 408, column: 2)
!482 = distinct !DILexicalBlock(scope: !476, file: !74, line: 408, column: 2)
!483 = !DILocation(line: 411, column: 2, scope: !476)
!484 = distinct !DISubprogram(name: "ck_epoch_dispatch", scope: !74, file: !74, line: 363, type: !485, scopeLine: 364, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !73, retainedNodes: !144)
!485 = !DISubroutineType(types: !486)
!486 = !{!7, !82, !7, !487}
!487 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !99, size: 64)
!488 = !DILocalVariable(name: "record", arg: 1, scope: !484, file: !74, line: 363, type: !82)
!489 = !DILocation(line: 0, scope: !484)
!490 = !DILocalVariable(name: "e", arg: 2, scope: !484, file: !74, line: 363, type: !7)
!491 = !DILocalVariable(name: "deferred", arg: 3, scope: !484, file: !74, line: 363, type: !487)
!492 = !DILocation(line: 365, column: 25, scope: !484)
!493 = !DILocalVariable(name: "epoch", scope: !484, file: !74, line: 365, type: !7)
!494 = !DILocalVariable(name: "i", scope: !484, file: !74, line: 368, type: !7)
!495 = !DILocation(line: 370, column: 42, scope: !484)
!496 = !DILocation(line: 370, column: 34, scope: !484)
!497 = !DILocation(line: 370, column: 9, scope: !484)
!498 = !DILocalVariable(name: "head", scope: !484, file: !74, line: 366, type: !355)
!499 = !DILocation(line: 371, column: 2, scope: !484)
!500 = !DILocalVariable(name: "cursor", scope: !484, file: !74, line: 366, type: !355)
!501 = !DILocation(line: 372, column: 7, scope: !502)
!502 = distinct !DILexicalBlock(scope: !484, file: !74, line: 372, column: 2)
!503 = !DILocation(line: 0, scope: !502)
!504 = !DILocation(line: 372, column: 29, scope: !505)
!505 = distinct !DILexicalBlock(scope: !502, file: !74, line: 372, column: 2)
!506 = !DILocation(line: 372, column: 2, scope: !502)
!507 = !DILocation(line: 374, column: 7, scope: !508)
!508 = distinct !DILexicalBlock(scope: !505, file: !74, line: 372, column: 53)
!509 = !DILocalVariable(name: "entry", scope: !508, file: !74, line: 373, type: !125)
!510 = !DILocation(line: 0, scope: !508)
!511 = !DILocation(line: 376, column: 10, scope: !508)
!512 = !DILocalVariable(name: "next", scope: !484, file: !74, line: 366, type: !355)
!513 = !DILocation(line: 377, column: 16, scope: !514)
!514 = distinct !DILexicalBlock(scope: !508, file: !74, line: 377, column: 7)
!515 = !DILocation(line: 377, column: 7, scope: !508)
!516 = !DILocation(line: 378, column: 41, scope: !514)
!517 = !DILocation(line: 378, column: 4, scope: !514)
!518 = !DILocation(line: 380, column: 11, scope: !514)
!519 = !DILocation(line: 380, column: 4, scope: !514)
!520 = !DILocation(line: 382, column: 4, scope: !508)
!521 = !DILocation(line: 372, column: 2, scope: !505)
!522 = distinct !{!522, !506, !523, !379}
!523 = !DILocation(line: 383, column: 2, scope: !502)
!524 = !DILocation(line: 385, column: 11, scope: !484)
!525 = !DILocalVariable(name: "n_peak", scope: !484, file: !74, line: 367, type: !7)
!526 = !DILocation(line: 386, column: 14, scope: !484)
!527 = !DILocalVariable(name: "n_pending", scope: !484, file: !74, line: 367, type: !7)
!528 = !DILocation(line: 389, column: 16, scope: !529)
!529 = distinct !DILexicalBlock(scope: !484, file: !74, line: 389, column: 6)
!530 = !DILocation(line: 389, column: 6, scope: !484)
!531 = !DILocation(line: 390, column: 3, scope: !529)
!532 = !DILocation(line: 392, column: 8, scope: !533)
!533 = distinct !DILexicalBlock(scope: !484, file: !74, line: 392, column: 6)
!534 = !DILocation(line: 392, column: 6, scope: !484)
!535 = !DILocation(line: 393, column: 3, scope: !536)
!536 = distinct !DILexicalBlock(scope: !533, file: !74, line: 392, column: 13)
!537 = !DILocation(line: 394, column: 3, scope: !536)
!538 = !DILocation(line: 395, column: 2, scope: !536)
!539 = !DILocation(line: 397, column: 2, scope: !484)
!540 = distinct !DISubprogram(name: "ck_stack_batch_pop_upmc", scope: !24, file: !24, line: 154, type: !541, scopeLine: 155, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !73, retainedNodes: !144)
!541 = !DISubroutineType(types: !542)
!542 = !{!91, !332}
!543 = !DILocalVariable(name: "target", arg: 1, scope: !540, file: !24, line: 154, type: !332)
!544 = !DILocation(line: 0, scope: !540)
!545 = !DILocation(line: 158, column: 10, scope: !540)
!546 = !DILocalVariable(name: "entry", scope: !540, file: !24, line: 156, type: !91)
!547 = !DILocation(line: 159, column: 2, scope: !540)
!548 = !DILocation(line: 160, column: 2, scope: !540)
!549 = distinct !DISubprogram(name: "ck_epoch_entry_container", scope: !74, file: !74, line: 147, type: !550, scopeLine: 147, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !73, retainedNodes: !144)
!550 = !DISubroutineType(types: !551)
!551 = !{!125, !355}
!552 = !DILocalVariable(name: "p", arg: 1, scope: !549, file: !74, line: 147, type: !355)
!553 = !DILocation(line: 0, scope: !549)
!554 = !DILocalVariable(name: "n", scope: !549, file: !74, line: 147, type: !355)
!555 = !DILocation(line: 147, column: 1, scope: !549)
!556 = distinct !DISubprogram(name: "ck_stack_push_spnc", scope: !24, file: !24, line: 294, type: !426, scopeLine: 295, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !73, retainedNodes: !144)
!557 = !DILocalVariable(name: "target", arg: 1, scope: !556, file: !24, line: 294, type: !332)
!558 = !DILocation(line: 0, scope: !556)
!559 = !DILocalVariable(name: "entry", arg: 2, scope: !556, file: !24, line: 294, type: !91)
!560 = !DILocation(line: 297, column: 24, scope: !556)
!561 = !DILocation(line: 297, column: 9, scope: !556)
!562 = !DILocation(line: 297, column: 14, scope: !556)
!563 = !DILocation(line: 298, column: 15, scope: !556)
!564 = !DILocation(line: 299, column: 2, scope: !556)
!565 = distinct !DISubprogram(name: "ck_epoch_synchronize_wait", scope: !74, file: !74, line: 429, type: !566, scopeLine: 431, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !144)
!566 = !DISubroutineType(types: !567)
!567 = !{null, !93, !568, !16}
!568 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !569, size: 64)
!569 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_wait_cb_t", file: !19, line: 235, baseType: !570)
!570 = !DISubroutineType(types: !571)
!571 = !{null, !572, !343, !16}
!572 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !573, size: 64)
!573 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_t", file: !19, line: 108, baseType: !94)
!574 = !DILocalVariable(name: "global", arg: 1, scope: !565, file: !74, line: 429, type: !93)
!575 = !DILocation(line: 0, scope: !565)
!576 = !DILocalVariable(name: "cb", arg: 2, scope: !565, file: !74, line: 430, type: !568)
!577 = !DILocalVariable(name: "ct", arg: 3, scope: !565, file: !74, line: 430, type: !16)
!578 = !DILocalVariable(name: "active", scope: !565, file: !74, line: 434, type: !224)
!579 = !DILocation(line: 434, column: 7, scope: !565)
!580 = !DILocation(line: 436, column: 2, scope: !565)
!581 = !DILocation(line: 447, column: 18, scope: !565)
!582 = !DILocalVariable(name: "epoch", scope: !565, file: !74, line: 433, type: !7)
!583 = !DILocalVariable(name: "delta", scope: !565, file: !74, line: 433, type: !7)
!584 = !DILocation(line: 448, column: 15, scope: !565)
!585 = !DILocalVariable(name: "goal", scope: !565, file: !74, line: 433, type: !7)
!586 = !DILocalVariable(name: "i", scope: !565, file: !74, line: 433, type: !7)
!587 = !DILocalVariable(name: "cr", scope: !565, file: !74, line: 432, type: !82)
!588 = !DILocation(line: 457, column: 3, scope: !589)
!589 = distinct !DILexicalBlock(scope: !590, file: !74, line: 450, column: 65)
!590 = distinct !DILexicalBlock(scope: !591, file: !74, line: 450, column: 2)
!591 = distinct !DILexicalBlock(scope: !565, file: !74, line: 450, column: 2)
!592 = !DILocation(line: 0, scope: !591)
!593 = !DILocation(line: 457, column: 15, scope: !589)
!594 = !DILocation(line: 458, column: 10, scope: !589)
!595 = !DILocation(line: 467, column: 10, scope: !596)
!596 = distinct !DILexicalBlock(scope: !589, file: !74, line: 458, column: 19)
!597 = !DILocalVariable(name: "e_d", scope: !596, file: !74, line: 459, type: !7)
!598 = !DILocation(line: 0, scope: !596)
!599 = !DILocation(line: 468, column: 12, scope: !600)
!600 = distinct !DILexicalBlock(scope: !596, file: !74, line: 468, column: 8)
!601 = !DILocation(line: 468, column: 8, scope: !596)
!602 = !DILocation(line: 469, column: 5, scope: !603)
!603 = distinct !DILexicalBlock(scope: !600, file: !74, line: 468, column: 22)
!604 = !DILocation(line: 470, column: 5, scope: !603)
!605 = distinct !{!605, !588, !606, !379}
!606 = !DILocation(line: 489, column: 3, scope: !589)
!607 = !DILocation(line: 478, column: 14, scope: !608)
!608 = distinct !DILexicalBlock(scope: !596, file: !74, line: 478, column: 8)
!609 = !DILocation(line: 478, column: 32, scope: !608)
!610 = !DILocation(line: 478, column: 23, scope: !608)
!611 = !DILocation(line: 478, column: 8, scope: !596)
!612 = !DILocation(line: 481, column: 4, scope: !596)
!613 = !DILocation(line: 495, column: 7, scope: !614)
!614 = distinct !DILexicalBlock(scope: !589, file: !74, line: 495, column: 7)
!615 = !DILocation(line: 495, column: 14, scope: !614)
!616 = !DILocation(line: 495, column: 7, scope: !589)
!617 = !DILocation(line: 509, column: 7, scope: !589)
!618 = !DILocalVariable(name: "r", scope: !589, file: !74, line: 451, type: !224)
!619 = !DILocation(line: 0, scope: !589)
!620 = !DILocation(line: 513, column: 3, scope: !589)
!621 = !DILocation(line: 519, column: 19, scope: !589)
!622 = !DILocation(line: 519, column: 17, scope: !589)
!623 = !DILocation(line: 520, column: 2, scope: !591)
!624 = !DILabel(scope: !565, name: "leave", file: !74, line: 527)
!625 = !DILocation(line: 527, column: 1, scope: !565)
!626 = !DILocation(line: 528, column: 2, scope: !565)
!627 = !DILocation(line: 529, column: 2, scope: !565)
!628 = distinct !DISubprogram(name: "ck_epoch_scan", scope: !74, file: !74, line: 323, type: !629, scopeLine: 327, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !73, retainedNodes: !144)
!629 = !DISubroutineType(types: !630)
!630 = !{!82, !93, !82, !7, !631}
!631 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !224, size: 64)
!632 = !DILocalVariable(name: "global", arg: 1, scope: !628, file: !74, line: 323, type: !93)
!633 = !DILocation(line: 0, scope: !628)
!634 = !DILocalVariable(name: "cr", arg: 2, scope: !628, file: !74, line: 324, type: !82)
!635 = !DILocalVariable(name: "epoch", arg: 3, scope: !628, file: !74, line: 325, type: !7)
!636 = !DILocalVariable(name: "af", arg: 4, scope: !628, file: !74, line: 326, type: !631)
!637 = !DILocation(line: 330, column: 9, scope: !638)
!638 = distinct !DILexicalBlock(scope: !628, file: !74, line: 330, column: 6)
!639 = !DILocation(line: 330, column: 6, scope: !628)
!640 = !DILocation(line: 331, column: 12, scope: !641)
!641 = distinct !DILexicalBlock(scope: !638, file: !74, line: 330, column: 18)
!642 = !DILocalVariable(name: "cursor", scope: !628, file: !74, line: 328, type: !355)
!643 = !DILocation(line: 332, column: 7, scope: !641)
!644 = !DILocation(line: 333, column: 2, scope: !641)
!645 = !DILocation(line: 334, column: 17, scope: !646)
!646 = distinct !DILexicalBlock(scope: !638, file: !74, line: 333, column: 9)
!647 = !DILocation(line: 335, column: 7, scope: !646)
!648 = !DILocation(line: 0, scope: !638)
!649 = !DILocation(line: 338, column: 2, scope: !628)
!650 = !DILocation(line: 339, column: 2, scope: !628)
!651 = !DILocation(line: 339, column: 16, scope: !628)
!652 = !DILocation(line: 342, column: 8, scope: !653)
!653 = distinct !DILexicalBlock(scope: !628, file: !74, line: 339, column: 25)
!654 = !DILocation(line: 344, column: 11, scope: !653)
!655 = !DILocalVariable(name: "state", scope: !653, file: !74, line: 340, type: !7)
!656 = !DILocation(line: 0, scope: !653)
!657 = !DILocation(line: 345, column: 13, scope: !658)
!658 = distinct !DILexicalBlock(scope: !653, file: !74, line: 345, column: 7)
!659 = !DILocation(line: 345, column: 7, scope: !653)
!660 = !DILocation(line: 346, column: 13, scope: !661)
!661 = distinct !DILexicalBlock(scope: !658, file: !74, line: 345, column: 36)
!662 = !DILocation(line: 347, column: 4, scope: !661)
!663 = distinct !{!663, !650, !664, !379}
!664 = !DILocation(line: 357, column: 2, scope: !628)
!665 = !DILocation(line: 350, column: 12, scope: !653)
!666 = !DILocalVariable(name: "active", scope: !653, file: !74, line: 340, type: !7)
!667 = !DILocation(line: 351, column: 7, scope: !653)
!668 = !DILocation(line: 353, column: 14, scope: !669)
!669 = distinct !DILexicalBlock(scope: !653, file: !74, line: 353, column: 7)
!670 = !DILocation(line: 353, column: 19, scope: !669)
!671 = !DILocation(line: 353, column: 22, scope: !669)
!672 = !DILocation(line: 353, column: 50, scope: !669)
!673 = !DILocation(line: 353, column: 7, scope: !653)
!674 = !DILocation(line: 356, column: 12, scope: !653)
!675 = !DILocation(line: 360, column: 1, scope: !628)
!676 = distinct !DISubprogram(name: "epoch_block", scope: !74, file: !74, line: 415, type: !677, scopeLine: 417, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !73, retainedNodes: !144)
!677 = !DISubroutineType(types: !678)
!678 = !{null, !93, !82, !568, !16}
!679 = !DILocalVariable(name: "global", arg: 1, scope: !676, file: !74, line: 415, type: !93)
!680 = !DILocation(line: 0, scope: !676)
!681 = !DILocalVariable(name: "cr", arg: 2, scope: !676, file: !74, line: 415, type: !82)
!682 = !DILocalVariable(name: "cb", arg: 3, scope: !676, file: !74, line: 416, type: !568)
!683 = !DILocalVariable(name: "ct", arg: 4, scope: !676, file: !74, line: 416, type: !16)
!684 = !DILocation(line: 419, column: 9, scope: !685)
!685 = distinct !DILexicalBlock(scope: !676, file: !74, line: 419, column: 6)
!686 = !DILocation(line: 419, column: 6, scope: !676)
!687 = !DILocation(line: 420, column: 3, scope: !685)
!688 = !DILocation(line: 422, column: 2, scope: !676)
!689 = distinct !DISubprogram(name: "ck_epoch_synchronize", scope: !74, file: !74, line: 533, type: !447, scopeLine: 534, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !144)
!690 = !DILocalVariable(name: "record", arg: 1, scope: !689, file: !74, line: 533, type: !82)
!691 = !DILocation(line: 0, scope: !689)
!692 = !DILocation(line: 536, column: 36, scope: !689)
!693 = !DILocation(line: 536, column: 2, scope: !689)
!694 = !DILocation(line: 537, column: 2, scope: !689)
!695 = distinct !DISubprogram(name: "ck_epoch_barrier", scope: !74, file: !74, line: 541, type: !447, scopeLine: 542, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !144)
!696 = !DILocalVariable(name: "record", arg: 1, scope: !695, file: !74, line: 541, type: !82)
!697 = !DILocation(line: 0, scope: !695)
!698 = !DILocation(line: 544, column: 2, scope: !695)
!699 = !DILocation(line: 545, column: 2, scope: !695)
!700 = !DILocation(line: 546, column: 2, scope: !695)
!701 = distinct !DISubprogram(name: "ck_epoch_barrier_wait", scope: !74, file: !74, line: 550, type: !702, scopeLine: 552, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !144)
!702 = !DISubroutineType(types: !703)
!703 = !{null, !82, !568, !16}
!704 = !DILocalVariable(name: "record", arg: 1, scope: !701, file: !74, line: 550, type: !82)
!705 = !DILocation(line: 0, scope: !701)
!706 = !DILocalVariable(name: "cb", arg: 2, scope: !701, file: !74, line: 550, type: !568)
!707 = !DILocalVariable(name: "ct", arg: 3, scope: !701, file: !74, line: 551, type: !16)
!708 = !DILocation(line: 554, column: 36, scope: !701)
!709 = !DILocation(line: 554, column: 2, scope: !701)
!710 = !DILocation(line: 555, column: 2, scope: !701)
!711 = !DILocation(line: 556, column: 2, scope: !701)
!712 = distinct !DISubprogram(name: "ck_epoch_poll_deferred", scope: !74, file: !74, line: 570, type: !713, scopeLine: 571, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !144)
!713 = !DISubroutineType(types: !714)
!714 = !{!224, !82, !487}
!715 = !DILocalVariable(name: "record", arg: 1, scope: !712, file: !74, line: 570, type: !82)
!716 = !DILocation(line: 0, scope: !712)
!717 = !DILocalVariable(name: "deferred", arg: 2, scope: !712, file: !74, line: 570, type: !487)
!718 = !DILocalVariable(name: "active", scope: !712, file: !74, line: 575, type: !224)
!719 = !DILocation(line: 575, column: 7, scope: !712)
!720 = !DILocalVariable(name: "cr", scope: !712, file: !74, line: 577, type: !82)
!721 = !DILocation(line: 578, column: 36, scope: !712)
!722 = !DILocalVariable(name: "global", scope: !712, file: !74, line: 578, type: !93)
!723 = !DILocalVariable(name: "n_dispatch", scope: !712, file: !74, line: 579, type: !7)
!724 = !DILocation(line: 581, column: 10, scope: !712)
!725 = !DILocalVariable(name: "epoch", scope: !712, file: !74, line: 576, type: !7)
!726 = !DILocation(line: 584, column: 2, scope: !712)
!727 = !DILocation(line: 598, column: 7, scope: !712)
!728 = !DILocation(line: 599, column: 9, scope: !729)
!729 = distinct !DILexicalBlock(scope: !712, file: !74, line: 599, column: 6)
!730 = !DILocation(line: 599, column: 6, scope: !712)
!731 = !DILocation(line: 603, column: 6, scope: !732)
!732 = distinct !DILexicalBlock(scope: !712, file: !74, line: 603, column: 6)
!733 = !DILocation(line: 603, column: 13, scope: !732)
!734 = !DILocation(line: 603, column: 6, scope: !712)
!735 = !DILocation(line: 604, column: 3, scope: !736)
!736 = distinct !DILexicalBlock(scope: !732, file: !74, line: 603, column: 23)
!737 = !DILocation(line: 609, column: 3, scope: !736)
!738 = !DILocalVariable(name: "A", scope: !739, file: !74, line: 620, type: !7)
!739 = distinct !DILexicalBlock(scope: !712, file: !74, line: 620, column: 8)
!740 = !DILocation(line: 0, scope: !739)
!741 = !DILocation(line: 620, column: 8, scope: !739)
!742 = !DILocation(line: 623, column: 2, scope: !712)
!743 = !DILocation(line: 624, column: 1, scope: !712)
!744 = distinct !DISubprogram(name: "ck_epoch_poll", scope: !74, file: !74, line: 627, type: !745, scopeLine: 628, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !144)
!745 = !DISubroutineType(types: !746)
!746 = !{!224, !82}
!747 = !DILocalVariable(name: "record", arg: 1, scope: !744, file: !74, line: 627, type: !82)
!748 = !DILocation(line: 0, scope: !744)
!749 = !DILocation(line: 630, column: 9, scope: !744)
!750 = !DILocation(line: 630, column: 2, scope: !744)
