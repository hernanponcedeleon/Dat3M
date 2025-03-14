; ModuleID = 'ebr_test.ll'
source_filename = "llvm-link"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

%struct.ck_epoch = type { i32, i32, %struct.ck_stack }
%struct.ck_stack = type { %struct.ck_stack_entry*, i8* }
%struct.ck_stack_entry = type { %struct.ck_stack_entry* }
%struct.ck_epoch_record = type { %struct.ck_stack_entry, %struct.ck_epoch*, i32, i32, i32, %struct.anon, i32, i32, i32, i8*, [4 x %struct.ck_stack] }
%struct.anon = type { [2 x %struct.ck_epoch_ref] }
%struct.ck_epoch_ref = type { i32, i32 }
%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }
%struct.ck_epoch_section = type { i32 }
%struct.ck_epoch_entry = type { void (%struct.ck_epoch_entry*)*, %struct.ck_stack_entry }

@stack_epoch = internal global %struct.ck_epoch zeroinitializer, align 8, !dbg !0
@records = global [4 x %struct.ck_epoch_record] zeroinitializer, align 8, !dbg !69
@__func__.thread = private unnamed_addr constant [7 x i8] c"thread\00", align 1
@.str = private unnamed_addr constant [14 x i8] c"client-code.c\00", align 1
@.str.1 = private unnamed_addr constant [32 x i8] c"global_epoch - local_epoch <= 1\00", align 1

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main(i32 noundef %0, i8** noundef %1) #0 !dbg !147 {
  %3 = alloca [4 x %struct._opaque_pthread_t*], align 8
  call void @llvm.dbg.value(metadata i32 %0, metadata !152, metadata !DIExpression()), !dbg !153
  call void @llvm.dbg.value(metadata i8** %1, metadata !154, metadata !DIExpression()), !dbg !153
  call void @llvm.dbg.declare(metadata [4 x %struct._opaque_pthread_t*]* %3, metadata !155, metadata !DIExpression()), !dbg !180
  call void @ck_epoch_init(%struct.ck_epoch* noundef @stack_epoch), !dbg !181
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !182
  call void @llvm.dbg.value(metadata i32 0, metadata !183, metadata !DIExpression()), !dbg !185
  call void @llvm.dbg.value(metadata i64 0, metadata !183, metadata !DIExpression()), !dbg !185
  call void @ck_epoch_register(%struct.ck_epoch* noundef @stack_epoch, %struct.ck_epoch_record* noundef getelementptr inbounds ([4 x %struct.ck_epoch_record], [4 x %struct.ck_epoch_record]* @records, i64 0, i64 0), i8* noundef null), !dbg !186
  %4 = getelementptr inbounds [4 x %struct._opaque_pthread_t*], [4 x %struct._opaque_pthread_t*]* %3, i64 0, i64 0, !dbg !189
  %5 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %4, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread, i8* noundef bitcast ([4 x %struct.ck_epoch_record]* @records to i8*)), !dbg !190
  call void @llvm.dbg.value(metadata i64 1, metadata !183, metadata !DIExpression()), !dbg !185
  call void @llvm.dbg.value(metadata i64 1, metadata !183, metadata !DIExpression()), !dbg !185
  call void @ck_epoch_register(%struct.ck_epoch* noundef @stack_epoch, %struct.ck_epoch_record* noundef getelementptr inbounds ([4 x %struct.ck_epoch_record], [4 x %struct.ck_epoch_record]* @records, i64 0, i64 1), i8* noundef null), !dbg !186
  %6 = getelementptr inbounds [4 x %struct._opaque_pthread_t*], [4 x %struct._opaque_pthread_t*]* %3, i64 0, i64 1, !dbg !189
  %7 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %6, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread, i8* noundef bitcast (%struct.ck_epoch_record* getelementptr inbounds ([4 x %struct.ck_epoch_record], [4 x %struct.ck_epoch_record]* @records, i64 0, i64 1) to i8*)), !dbg !190
  call void @llvm.dbg.value(metadata i64 2, metadata !183, metadata !DIExpression()), !dbg !185
  call void @llvm.dbg.value(metadata i64 2, metadata !183, metadata !DIExpression()), !dbg !185
  call void @ck_epoch_register(%struct.ck_epoch* noundef @stack_epoch, %struct.ck_epoch_record* noundef getelementptr inbounds ([4 x %struct.ck_epoch_record], [4 x %struct.ck_epoch_record]* @records, i64 0, i64 2), i8* noundef null), !dbg !186
  %8 = getelementptr inbounds [4 x %struct._opaque_pthread_t*], [4 x %struct._opaque_pthread_t*]* %3, i64 0, i64 2, !dbg !189
  %9 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %8, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread, i8* noundef bitcast (%struct.ck_epoch_record* getelementptr inbounds ([4 x %struct.ck_epoch_record], [4 x %struct.ck_epoch_record]* @records, i64 0, i64 2) to i8*)), !dbg !190
  call void @llvm.dbg.value(metadata i64 3, metadata !183, metadata !DIExpression()), !dbg !185
  call void @llvm.dbg.value(metadata i64 3, metadata !183, metadata !DIExpression()), !dbg !185
  call void @ck_epoch_register(%struct.ck_epoch* noundef @stack_epoch, %struct.ck_epoch_record* noundef getelementptr inbounds ([4 x %struct.ck_epoch_record], [4 x %struct.ck_epoch_record]* @records, i64 0, i64 3), i8* noundef null), !dbg !186
  %10 = getelementptr inbounds [4 x %struct._opaque_pthread_t*], [4 x %struct._opaque_pthread_t*]* %3, i64 0, i64 3, !dbg !189
  %11 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %10, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread, i8* noundef bitcast (%struct.ck_epoch_record* getelementptr inbounds ([4 x %struct.ck_epoch_record], [4 x %struct.ck_epoch_record]* @records, i64 0, i64 3) to i8*)), !dbg !190
  call void @llvm.dbg.value(metadata i64 4, metadata !183, metadata !DIExpression()), !dbg !185
  call void @llvm.dbg.value(metadata i64 4, metadata !183, metadata !DIExpression()), !dbg !185
  ret i32 0, !dbg !191
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__VERIFIER_loop_bound(i32 noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define internal i8* @thread(i8* noundef %0) #0 !dbg !192 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !195, metadata !DIExpression()), !dbg !196
  %2 = bitcast i8* %0 to %struct.ck_epoch_record*, !dbg !197
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %2, metadata !198, metadata !DIExpression()), !dbg !196
  call void @ck_epoch_begin(%struct.ck_epoch_record* noundef %2, %struct.ck_epoch_section* noundef null), !dbg !199
  %3 = load atomic i32, i32* getelementptr inbounds (%struct.ck_epoch, %struct.ck_epoch* @stack_epoch, i32 0, i32 0) monotonic, align 8, !dbg !200
  call void @llvm.dbg.value(metadata i32 %3, metadata !201, metadata !DIExpression()), !dbg !196
  %4 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %2, i32 0, i32 3, !dbg !202
  %5 = load atomic i32, i32* %4 monotonic, align 4, !dbg !202
  call void @llvm.dbg.value(metadata i32 %5, metadata !203, metadata !DIExpression()), !dbg !196
  %6 = call zeroext i1 @ck_epoch_end(%struct.ck_epoch_record* noundef %2, %struct.ck_epoch_section* noundef null), !dbg !204
  %7 = sub nsw i32 %3, %5, !dbg !205
  %8 = icmp sle i32 %7, 1, !dbg !205
  %9 = xor i1 %8, true, !dbg !205
  %10 = zext i1 %9 to i32, !dbg !205
  %11 = sext i32 %10 to i64, !dbg !205
  br i1 %9, label %12, label %13, !dbg !205

12:                                               ; preds = %1
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @__func__.thread, i64 0, i64 0), i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @.str, i64 0, i64 0), i32 noundef 25, i8* noundef getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1, i64 0, i64 0)) #5, !dbg !205
  unreachable, !dbg !205

13:                                               ; preds = %1
  %14 = call zeroext i1 @ck_epoch_poll(%struct.ck_epoch_record* noundef %2), !dbg !206
  ret i8* null, !dbg !207
}

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define internal void @ck_epoch_begin(%struct.ck_epoch_record* noundef %0, %struct.ck_epoch_section* noundef %1) #0 !dbg !208 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %0, metadata !216, metadata !DIExpression()), !dbg !217
  call void @llvm.dbg.value(metadata %struct.ck_epoch_section* %1, metadata !218, metadata !DIExpression()), !dbg !217
  %3 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 1, !dbg !219
  %4 = load %struct.ck_epoch*, %struct.ck_epoch** %3, align 8, !dbg !219
  call void @llvm.dbg.value(metadata %struct.ck_epoch* %4, metadata !220, metadata !DIExpression()), !dbg !217
  %5 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 4, !dbg !221
  %6 = load atomic i32, i32* %5 monotonic, align 8, !dbg !221
  %7 = icmp eq i32 %6, 0, !dbg !223
  br i1 %7, label %8, label %12, !dbg !224

8:                                                ; preds = %2
  store atomic i32 1, i32* %5 monotonic, align 8, !dbg !225
  fence seq_cst, !dbg !227
  %9 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %4, i32 0, i32 0, !dbg !228
  %10 = load atomic i32, i32* %9 monotonic, align 8, !dbg !228
  call void @llvm.dbg.value(metadata i32 %10, metadata !229, metadata !DIExpression()), !dbg !230
  %11 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 3, !dbg !231
  store atomic i32 %10, i32* %11 monotonic, align 4, !dbg !231
  br label %15, !dbg !232

12:                                               ; preds = %2
  %13 = load atomic i32, i32* %5 monotonic, align 8, !dbg !233
  %14 = add i32 %13, 1, !dbg !233
  store atomic i32 %14, i32* %5 monotonic, align 8, !dbg !233
  br label %15

15:                                               ; preds = %12, %8
  %16 = icmp ne %struct.ck_epoch_section* %1, null, !dbg !235
  br i1 %16, label %17, label %18, !dbg !237

17:                                               ; preds = %15
  call void @_ck_epoch_addref(%struct.ck_epoch_record* noundef %0, %struct.ck_epoch_section* noundef %1), !dbg !238
  br label %18, !dbg !238

18:                                               ; preds = %17, %15
  ret void, !dbg !239
}

; Function Attrs: noinline nounwind ssp uwtable
define internal zeroext i1 @ck_epoch_end(%struct.ck_epoch_record* noundef %0, %struct.ck_epoch_section* noundef %1) #0 !dbg !240 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %0, metadata !244, metadata !DIExpression()), !dbg !245
  call void @llvm.dbg.value(metadata %struct.ck_epoch_section* %1, metadata !246, metadata !DIExpression()), !dbg !245
  fence release, !dbg !247
  %3 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 4, !dbg !248
  %4 = load atomic i32, i32* %3 monotonic, align 8, !dbg !248
  %5 = sub i32 %4, 1, !dbg !248
  store atomic i32 %5, i32* %3 monotonic, align 8, !dbg !248
  %6 = icmp ne %struct.ck_epoch_section* %1, null, !dbg !249
  br i1 %6, label %7, label %9, !dbg !251

7:                                                ; preds = %2
  %8 = call zeroext i1 @_ck_epoch_delref(%struct.ck_epoch_record* noundef %0, %struct.ck_epoch_section* noundef %1), !dbg !252
  br label %12, !dbg !253

9:                                                ; preds = %2
  %10 = load atomic i32, i32* %3 monotonic, align 8, !dbg !254
  %11 = icmp eq i32 %10, 0, !dbg !255
  br label %12, !dbg !256

12:                                               ; preds = %9, %7
  %.0 = phi i1 [ %8, %7 ], [ %11, %9 ], !dbg !245
  ret i1 %.0, !dbg !257
}

; Function Attrs: cold noreturn
declare void @__assert_rtn(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind ssp uwtable
define zeroext i1 @_ck_epoch_delref(%struct.ck_epoch_record* noundef %0, %struct.ck_epoch_section* noundef %1) #0 !dbg !258 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %0, metadata !265, metadata !DIExpression()), !dbg !266
  call void @llvm.dbg.value(metadata %struct.ck_epoch_section* %1, metadata !267, metadata !DIExpression()), !dbg !266
  %3 = getelementptr inbounds %struct.ck_epoch_section, %struct.ck_epoch_section* %1, i32 0, i32 0, !dbg !268
  %4 = load i32, i32* %3, align 4, !dbg !268
  call void @llvm.dbg.value(metadata i32 %4, metadata !269, metadata !DIExpression()), !dbg !266
  %5 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 5, !dbg !270
  %6 = getelementptr inbounds %struct.anon, %struct.anon* %5, i32 0, i32 0, !dbg !271
  %7 = zext i32 %4 to i64, !dbg !272
  %8 = getelementptr inbounds [2 x %struct.ck_epoch_ref], [2 x %struct.ck_epoch_ref]* %6, i64 0, i64 %7, !dbg !272
  call void @llvm.dbg.value(metadata %struct.ck_epoch_ref* %8, metadata !273, metadata !DIExpression()), !dbg !266
  %9 = getelementptr inbounds %struct.ck_epoch_ref, %struct.ck_epoch_ref* %8, i32 0, i32 1, !dbg !275
  %10 = load i32, i32* %9, align 4, !dbg !276
  %11 = add i32 %10, -1, !dbg !276
  store i32 %11, i32* %9, align 4, !dbg !276
  %12 = icmp ugt i32 %11, 0, !dbg !277
  br i1 %12, label %30, label %13, !dbg !279

13:                                               ; preds = %2
  %14 = add i32 %4, 1, !dbg !280
  %15 = and i32 %14, 1, !dbg !281
  %16 = zext i32 %15 to i64, !dbg !282
  %17 = getelementptr inbounds [2 x %struct.ck_epoch_ref], [2 x %struct.ck_epoch_ref]* %6, i64 0, i64 %16, !dbg !282
  call void @llvm.dbg.value(metadata %struct.ck_epoch_ref* %17, metadata !283, metadata !DIExpression()), !dbg !266
  %18 = getelementptr inbounds %struct.ck_epoch_ref, %struct.ck_epoch_ref* %17, i32 0, i32 1, !dbg !284
  %19 = load i32, i32* %18, align 4, !dbg !284
  %20 = icmp ugt i32 %19, 0, !dbg !286
  br i1 %20, label %21, label %30, !dbg !287

21:                                               ; preds = %13
  %22 = getelementptr inbounds %struct.ck_epoch_ref, %struct.ck_epoch_ref* %8, i32 0, i32 0, !dbg !288
  %23 = load i32, i32* %22, align 4, !dbg !288
  %24 = getelementptr inbounds %struct.ck_epoch_ref, %struct.ck_epoch_ref* %17, i32 0, i32 0, !dbg !289
  %25 = load i32, i32* %24, align 4, !dbg !289
  %26 = sub i32 %23, %25, !dbg !290
  %27 = icmp slt i32 %26, 0, !dbg !291
  br i1 %27, label %28, label %30, !dbg !292

28:                                               ; preds = %21
  %29 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 3, !dbg !293
  store atomic i32 %25, i32* %29 monotonic, align 4, !dbg !293
  br label %30, !dbg !295

30:                                               ; preds = %13, %21, %28, %2
  %.0 = phi i1 [ false, %2 ], [ true, %28 ], [ true, %21 ], [ true, %13 ], !dbg !266
  ret i1 %.0, !dbg !296
}

; Function Attrs: noinline nounwind ssp uwtable
define void @_ck_epoch_addref(%struct.ck_epoch_record* noundef %0, %struct.ck_epoch_section* noundef %1) #0 !dbg !297 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %0, metadata !300, metadata !DIExpression()), !dbg !301
  call void @llvm.dbg.value(metadata %struct.ck_epoch_section* %1, metadata !302, metadata !DIExpression()), !dbg !301
  %3 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 1, !dbg !303
  %4 = load %struct.ck_epoch*, %struct.ck_epoch** %3, align 8, !dbg !303
  call void @llvm.dbg.value(metadata %struct.ck_epoch* %4, metadata !304, metadata !DIExpression()), !dbg !301
  %5 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %4, i32 0, i32 0, !dbg !305
  %6 = load atomic i32, i32* %5 monotonic, align 8, !dbg !305
  call void @llvm.dbg.value(metadata i32 %6, metadata !306, metadata !DIExpression()), !dbg !301
  %7 = and i32 %6, 1, !dbg !307
  call void @llvm.dbg.value(metadata i32 %7, metadata !308, metadata !DIExpression()), !dbg !301
  %8 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 5, !dbg !309
  %9 = getelementptr inbounds %struct.anon, %struct.anon* %8, i32 0, i32 0, !dbg !310
  %10 = zext i32 %7 to i64, !dbg !311
  %11 = getelementptr inbounds [2 x %struct.ck_epoch_ref], [2 x %struct.ck_epoch_ref]* %9, i64 0, i64 %10, !dbg !311
  call void @llvm.dbg.value(metadata %struct.ck_epoch_ref* %11, metadata !312, metadata !DIExpression()), !dbg !301
  %12 = getelementptr inbounds %struct.ck_epoch_ref, %struct.ck_epoch_ref* %11, i32 0, i32 1, !dbg !313
  %13 = load i32, i32* %12, align 4, !dbg !315
  %14 = add i32 %13, 1, !dbg !315
  store i32 %14, i32* %12, align 4, !dbg !315
  %15 = icmp eq i32 %13, 0, !dbg !316
  br i1 %15, label %16, label %27, !dbg !317

16:                                               ; preds = %2
  %17 = add i32 %7, 1, !dbg !318
  %18 = and i32 %17, 1, !dbg !320
  %19 = zext i32 %18 to i64, !dbg !321
  %20 = getelementptr inbounds [2 x %struct.ck_epoch_ref], [2 x %struct.ck_epoch_ref]* %9, i64 0, i64 %19, !dbg !321
  call void @llvm.dbg.value(metadata %struct.ck_epoch_ref* %20, metadata !322, metadata !DIExpression()), !dbg !323
  %21 = getelementptr inbounds %struct.ck_epoch_ref, %struct.ck_epoch_ref* %20, i32 0, i32 1, !dbg !324
  %22 = load i32, i32* %21, align 4, !dbg !324
  %23 = icmp ugt i32 %22, 0, !dbg !326
  br i1 %23, label %24, label %25, !dbg !327

24:                                               ; preds = %16
  fence acq_rel, !dbg !328
  br label %25, !dbg !328

25:                                               ; preds = %24, %16
  %26 = getelementptr inbounds %struct.ck_epoch_ref, %struct.ck_epoch_ref* %11, i32 0, i32 0, !dbg !329
  store i32 %6, i32* %26, align 4, !dbg !330
  br label %27, !dbg !331

27:                                               ; preds = %25, %2
  %28 = getelementptr inbounds %struct.ck_epoch_section, %struct.ck_epoch_section* %1, i32 0, i32 0, !dbg !332
  store i32 %7, i32* %28, align 4, !dbg !333
  ret void, !dbg !334
}

; Function Attrs: noinline nounwind ssp uwtable
define void @ck_epoch_init(%struct.ck_epoch* noundef %0) #0 !dbg !335 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch* %0, metadata !338, metadata !DIExpression()), !dbg !339
  %2 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %0, i32 0, i32 2, !dbg !340
  call void @ck_stack_init(%struct.ck_stack* noundef %2), !dbg !341
  %3 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %0, i32 0, i32 0, !dbg !342
  store atomic i32 1, i32* %3 seq_cst, align 4, !dbg !343
  %4 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %0, i32 0, i32 1, !dbg !344
  store atomic i32 0, i32* %4 seq_cst, align 4, !dbg !345
  fence release, !dbg !346
  ret void, !dbg !347
}

; Function Attrs: noinline nounwind ssp uwtable
define internal void @ck_stack_init(%struct.ck_stack* noundef %0) #0 !dbg !348 {
  call void @llvm.dbg.value(metadata %struct.ck_stack* %0, metadata !352, metadata !DIExpression()), !dbg !353
  %2 = getelementptr inbounds %struct.ck_stack, %struct.ck_stack* %0, i32 0, i32 0, !dbg !354
  %3 = bitcast %struct.ck_stack_entry** %2 to i64*, !dbg !355
  store atomic i64 0, i64* %3 seq_cst, align 8, !dbg !355
  %4 = getelementptr inbounds %struct.ck_stack, %struct.ck_stack* %0, i32 0, i32 1, !dbg !356
  store i8* null, i8** %4, align 8, !dbg !357
  ret void, !dbg !358
}

; Function Attrs: noinline nounwind ssp uwtable
define %struct.ck_epoch_record* @ck_epoch_recycle(%struct.ck_epoch* noundef %0, i8* noundef %1) #0 !dbg !359 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch* %0, metadata !364, metadata !DIExpression()), !dbg !365
  call void @llvm.dbg.value(metadata i8* %1, metadata !366, metadata !DIExpression()), !dbg !365
  %3 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %0, i32 0, i32 1, !dbg !367
  %4 = load atomic i32, i32* %3 monotonic, align 4, !dbg !367
  %5 = icmp eq i32 %4, 0, !dbg !369
  br i1 %5, label %32, label %6, !dbg !370

6:                                                ; preds = %2
  %7 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %0, i32 0, i32 2, !dbg !371
  %8 = getelementptr inbounds %struct.ck_stack, %struct.ck_stack* %7, i32 0, i32 0, !dbg !371
  %9 = bitcast %struct.ck_stack_entry** %8 to i64*, !dbg !371
  %10 = load atomic i64, i64* %9 monotonic, align 8, !dbg !371
  %11 = inttoptr i64 %10 to %struct.ck_stack_entry*, !dbg !371
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %11, metadata !373, metadata !DIExpression()), !dbg !365
  br label %12, !dbg !371

12:                                               ; preds = %27, %6
  %.01 = phi %struct.ck_stack_entry* [ %11, %6 ], [ %31, %27 ], !dbg !375
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %.01, metadata !373, metadata !DIExpression()), !dbg !365
  %13 = icmp ne %struct.ck_stack_entry* %.01, null, !dbg !376
  br i1 %13, label %14, label %.loopexit, !dbg !371

14:                                               ; preds = %12
  %15 = call %struct.ck_epoch_record* @ck_epoch_record_container(%struct.ck_stack_entry* noundef %.01), !dbg !378
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %15, metadata !380, metadata !DIExpression()), !dbg !365
  %16 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %15, i32 0, i32 2, !dbg !381
  %17 = load atomic i32, i32* %16 monotonic, align 8, !dbg !381
  %18 = icmp eq i32 %17, 1, !dbg !383
  br i1 %18, label %19, label %27, !dbg !384

19:                                               ; preds = %14
  fence acquire, !dbg !385
  %20 = atomicrmw xchg i32* %16, i32 0 monotonic, align 4, !dbg !387
  call void @llvm.dbg.value(metadata i32 %20, metadata !388, metadata !DIExpression()), !dbg !365
  %21 = icmp eq i32 %20, 1, !dbg !389
  br i1 %21, label %22, label %27, !dbg !391

22:                                               ; preds = %19
  %23 = atomicrmw add i32* %3, i32 -1 monotonic, align 4, !dbg !392
  %24 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %15, i32 0, i32 9, !dbg !394
  %25 = bitcast i8** %24 to i64*, !dbg !394
  %26 = ptrtoint i8* %1 to i64, !dbg !394
  store atomic i64 %26, i64* %25 monotonic, align 8, !dbg !394
  br label %32, !dbg !395

27:                                               ; preds = %14, %19
  %28 = getelementptr inbounds %struct.ck_stack_entry, %struct.ck_stack_entry* %.01, i32 0, i32 0, !dbg !376
  %29 = bitcast %struct.ck_stack_entry** %28 to i64*, !dbg !376
  %30 = load atomic i64, i64* %29 monotonic, align 8, !dbg !376
  %31 = inttoptr i64 %30 to %struct.ck_stack_entry*, !dbg !376
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %31, metadata !373, metadata !DIExpression()), !dbg !365
  br label %12, !dbg !376, !llvm.loop !396

.loopexit:                                        ; preds = %12
  br label %32, !dbg !399

32:                                               ; preds = %.loopexit, %2, %22
  %.0 = phi %struct.ck_epoch_record* [ %15, %22 ], [ null, %2 ], [ null, %.loopexit ], !dbg !365
  ret %struct.ck_epoch_record* %.0, !dbg !399
}

; Function Attrs: noinline nounwind ssp uwtable
define internal %struct.ck_epoch_record* @ck_epoch_record_container(%struct.ck_stack_entry* noundef %0) #0 !dbg !400 {
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %0, metadata !403, metadata !DIExpression()), !dbg !404
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %0, metadata !405, metadata !DIExpression()), !dbg !404
  %2 = bitcast %struct.ck_stack_entry* %0 to i8*, !dbg !406
  %3 = bitcast i8* %2 to %struct.ck_epoch_record*, !dbg !406
  ret %struct.ck_epoch_record* %3, !dbg !406
}

; Function Attrs: noinline nounwind ssp uwtable
define void @ck_epoch_register(%struct.ck_epoch* noundef %0, %struct.ck_epoch_record* noundef %1, i8* noundef %2) #0 !dbg !407 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch* %0, metadata !410, metadata !DIExpression()), !dbg !411
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %1, metadata !412, metadata !DIExpression()), !dbg !411
  call void @llvm.dbg.value(metadata i8* %2, metadata !413, metadata !DIExpression()), !dbg !411
  %4 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %1, i32 0, i32 1, !dbg !414
  store %struct.ck_epoch* %0, %struct.ck_epoch** %4, align 8, !dbg !415
  %5 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %1, i32 0, i32 2, !dbg !416
  store atomic i32 0, i32* %5 seq_cst, align 4, !dbg !417
  %6 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %1, i32 0, i32 4, !dbg !418
  store atomic i32 0, i32* %6 seq_cst, align 4, !dbg !419
  %7 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %1, i32 0, i32 3, !dbg !420
  store atomic i32 0, i32* %7 seq_cst, align 4, !dbg !421
  %8 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %1, i32 0, i32 8, !dbg !422
  store atomic i32 0, i32* %8 seq_cst, align 4, !dbg !423
  %9 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %1, i32 0, i32 7, !dbg !424
  store atomic i32 0, i32* %9 seq_cst, align 4, !dbg !425
  %10 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %1, i32 0, i32 6, !dbg !426
  store atomic i32 0, i32* %10 seq_cst, align 4, !dbg !427
  %11 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %1, i32 0, i32 9, !dbg !428
  %12 = ptrtoint i8* %2 to i64, !dbg !429
  %13 = bitcast i8** %11 to i64*, !dbg !429
  store atomic i64 %12, i64* %13 seq_cst, align 8, !dbg !429
  %14 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %1, i32 0, i32 5, !dbg !430
  %15 = bitcast %struct.anon* %14 to i8*, !dbg !430
  %16 = call i64 @llvm.objectsize.i64.p0i8(i8* %15, i1 false, i1 true, i1 false), !dbg !430
  %17 = call i8* @__memset_chk(i8* noundef %15, i32 noundef 0, i64 noundef 16, i64 noundef %16) #6, !dbg !430
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !431
  call void @llvm.dbg.value(metadata i64 0, metadata !432, metadata !DIExpression()), !dbg !411
  call void @llvm.dbg.value(metadata i64 0, metadata !432, metadata !DIExpression()), !dbg !411
  %18 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %1, i32 0, i32 10, !dbg !433
  %19 = getelementptr inbounds [4 x %struct.ck_stack], [4 x %struct.ck_stack]* %18, i64 0, i64 0, !dbg !436
  call void @ck_stack_init(%struct.ck_stack* noundef %19), !dbg !437
  call void @llvm.dbg.value(metadata i64 1, metadata !432, metadata !DIExpression()), !dbg !411
  call void @llvm.dbg.value(metadata i64 1, metadata !432, metadata !DIExpression()), !dbg !411
  %20 = getelementptr inbounds [4 x %struct.ck_stack], [4 x %struct.ck_stack]* %18, i64 0, i64 1, !dbg !436
  call void @ck_stack_init(%struct.ck_stack* noundef %20), !dbg !437
  call void @llvm.dbg.value(metadata i64 2, metadata !432, metadata !DIExpression()), !dbg !411
  call void @llvm.dbg.value(metadata i64 2, metadata !432, metadata !DIExpression()), !dbg !411
  %21 = getelementptr inbounds [4 x %struct.ck_stack], [4 x %struct.ck_stack]* %18, i64 0, i64 2, !dbg !436
  call void @ck_stack_init(%struct.ck_stack* noundef %21), !dbg !437
  call void @llvm.dbg.value(metadata i64 3, metadata !432, metadata !DIExpression()), !dbg !411
  call void @llvm.dbg.value(metadata i64 3, metadata !432, metadata !DIExpression()), !dbg !411
  %22 = getelementptr inbounds [4 x %struct.ck_stack], [4 x %struct.ck_stack]* %18, i64 0, i64 3, !dbg !436
  call void @ck_stack_init(%struct.ck_stack* noundef %22), !dbg !437
  call void @llvm.dbg.value(metadata i64 4, metadata !432, metadata !DIExpression()), !dbg !411
  call void @llvm.dbg.value(metadata i64 4, metadata !432, metadata !DIExpression()), !dbg !411
  fence release, !dbg !438
  %23 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %0, i32 0, i32 2, !dbg !439
  %24 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %1, i32 0, i32 0, !dbg !440
  call void @ck_stack_push_upmc(%struct.ck_stack* noundef %23, %struct.ck_stack_entry* noundef %24), !dbg !441
  ret void, !dbg !442
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare i64 @llvm.objectsize.i64.p0i8(i8*, i1 immarg, i1 immarg, i1 immarg) #1

; Function Attrs: nounwind
declare i8* @__memset_chk(i8* noundef, i32 noundef, i64 noundef, i64 noundef) #4

; Function Attrs: noinline nounwind ssp uwtable
define internal void @ck_stack_push_upmc(%struct.ck_stack* noundef %0, %struct.ck_stack_entry* noundef %1) #0 !dbg !443 {
  call void @llvm.dbg.value(metadata %struct.ck_stack* %0, metadata !446, metadata !DIExpression()), !dbg !447
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %1, metadata !448, metadata !DIExpression()), !dbg !447
  %3 = getelementptr inbounds %struct.ck_stack, %struct.ck_stack* %0, i32 0, i32 0, !dbg !449
  %4 = bitcast %struct.ck_stack_entry** %3 to i64*, !dbg !449
  %5 = load atomic i64, i64* %4 monotonic, align 8, !dbg !449
  %6 = inttoptr i64 %5 to %struct.ck_stack_entry*, !dbg !449
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %6, metadata !450, metadata !DIExpression()), !dbg !447
  %7 = getelementptr inbounds %struct.ck_stack_entry, %struct.ck_stack_entry* %1, i32 0, i32 0, !dbg !451
  %8 = bitcast %struct.ck_stack_entry** %7 to i64*, !dbg !452
  store atomic i64 %5, i64* %8 seq_cst, align 8, !dbg !452
  fence release, !dbg !453
  br label %9, !dbg !454

9:                                                ; preds = %19, %2
  %.0 = phi %struct.ck_stack_entry* [ %6, %2 ], [ %.1, %19 ], !dbg !455
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %.0, metadata !450, metadata !DIExpression()), !dbg !447
  %10 = ptrtoint %struct.ck_stack_entry* %.0 to i64, !dbg !456
  %11 = ptrtoint %struct.ck_stack_entry* %1 to i64, !dbg !456
  %12 = cmpxchg i64* %4, i64 %10, i64 %11 monotonic monotonic, align 8, !dbg !456
  %13 = extractvalue { i64, i1 } %12, 0, !dbg !456
  %14 = extractvalue { i64, i1 } %12, 1, !dbg !456
  %15 = inttoptr i64 %13 to %struct.ck_stack_entry*, !dbg !456
  %.1 = select i1 %14, %struct.ck_stack_entry* %.0, %struct.ck_stack_entry* %15, !dbg !456
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %.1, metadata !450, metadata !DIExpression()), !dbg !447
  %16 = zext i1 %14 to i8, !dbg !456
  %17 = zext i1 %14 to i32, !dbg !456
  %18 = icmp eq i32 %17, 0, !dbg !457
  br i1 %18, label %19, label %21, !dbg !454

19:                                               ; preds = %9
  %20 = ptrtoint %struct.ck_stack_entry* %.1 to i64, !dbg !458
  store atomic i64 %20, i64* %8 seq_cst, align 8, !dbg !458
  fence release, !dbg !460
  br label %9, !dbg !454, !llvm.loop !461

21:                                               ; preds = %9
  ret void, !dbg !463
}

; Function Attrs: noinline nounwind ssp uwtable
define void @ck_epoch_unregister(%struct.ck_epoch_record* noundef %0) #0 !dbg !464 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %0, metadata !467, metadata !DIExpression()), !dbg !468
  %2 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 1, !dbg !469
  %3 = load %struct.ck_epoch*, %struct.ck_epoch** %2, align 8, !dbg !469
  call void @llvm.dbg.value(metadata %struct.ck_epoch* %3, metadata !470, metadata !DIExpression()), !dbg !468
  %4 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 4, !dbg !471
  store atomic i32 0, i32* %4 seq_cst, align 4, !dbg !472
  %5 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 3, !dbg !473
  store atomic i32 0, i32* %5 seq_cst, align 4, !dbg !474
  %6 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 8, !dbg !475
  store atomic i32 0, i32* %6 seq_cst, align 4, !dbg !476
  %7 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 7, !dbg !477
  store atomic i32 0, i32* %7 seq_cst, align 4, !dbg !478
  %8 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 6, !dbg !479
  store atomic i32 0, i32* %8 seq_cst, align 4, !dbg !480
  %9 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 5, !dbg !481
  %10 = bitcast %struct.anon* %9 to i8*, !dbg !481
  %11 = call i64 @llvm.objectsize.i64.p0i8(i8* %10, i1 false, i1 true, i1 false), !dbg !481
  %12 = call i8* @__memset_chk(i8* noundef %10, i32 noundef 0, i64 noundef 16, i64 noundef %11) #6, !dbg !481
  call void @llvm.dbg.value(metadata i64 0, metadata !482, metadata !DIExpression()), !dbg !468
  call void @llvm.dbg.value(metadata i64 0, metadata !482, metadata !DIExpression()), !dbg !468
  %13 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 10, !dbg !483
  %14 = getelementptr inbounds [4 x %struct.ck_stack], [4 x %struct.ck_stack]* %13, i64 0, i64 0, !dbg !486
  call void @ck_stack_init(%struct.ck_stack* noundef %14), !dbg !487
  call void @llvm.dbg.value(metadata i64 1, metadata !482, metadata !DIExpression()), !dbg !468
  call void @llvm.dbg.value(metadata i64 1, metadata !482, metadata !DIExpression()), !dbg !468
  %15 = getelementptr inbounds [4 x %struct.ck_stack], [4 x %struct.ck_stack]* %13, i64 0, i64 1, !dbg !486
  call void @ck_stack_init(%struct.ck_stack* noundef %15), !dbg !487
  call void @llvm.dbg.value(metadata i64 2, metadata !482, metadata !DIExpression()), !dbg !468
  call void @llvm.dbg.value(metadata i64 2, metadata !482, metadata !DIExpression()), !dbg !468
  %16 = getelementptr inbounds [4 x %struct.ck_stack], [4 x %struct.ck_stack]* %13, i64 0, i64 2, !dbg !486
  call void @ck_stack_init(%struct.ck_stack* noundef %16), !dbg !487
  call void @llvm.dbg.value(metadata i64 3, metadata !482, metadata !DIExpression()), !dbg !468
  call void @llvm.dbg.value(metadata i64 3, metadata !482, metadata !DIExpression()), !dbg !468
  %17 = getelementptr inbounds [4 x %struct.ck_stack], [4 x %struct.ck_stack]* %13, i64 0, i64 3, !dbg !486
  call void @ck_stack_init(%struct.ck_stack* noundef %17), !dbg !487
  call void @llvm.dbg.value(metadata i64 4, metadata !482, metadata !DIExpression()), !dbg !468
  call void @llvm.dbg.value(metadata i64 4, metadata !482, metadata !DIExpression()), !dbg !468
  %18 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 9, !dbg !488
  %19 = bitcast i8** %18 to i64*, !dbg !488
  store atomic i64 0, i64* %19 monotonic, align 8, !dbg !488
  fence release, !dbg !489
  %20 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 2, !dbg !490
  store atomic i32 1, i32* %20 monotonic, align 8, !dbg !490
  %21 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %3, i32 0, i32 1, !dbg !491
  %22 = atomicrmw add i32* %21, i32 1 monotonic, align 4, !dbg !491
  ret void, !dbg !492
}

; Function Attrs: noinline nounwind ssp uwtable
define void @ck_epoch_reclaim(%struct.ck_epoch_record* noundef %0) #0 !dbg !493 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %0, metadata !494, metadata !DIExpression()), !dbg !495
  call void @llvm.dbg.value(metadata i32 0, metadata !496, metadata !DIExpression()), !dbg !495
  call void @llvm.dbg.value(metadata i32 0, metadata !496, metadata !DIExpression()), !dbg !495
  %2 = call i32 @ck_epoch_dispatch(%struct.ck_epoch_record* noundef %0, i32 noundef 0, %struct.ck_stack* noundef null), !dbg !497
  call void @llvm.dbg.value(metadata i32 1, metadata !496, metadata !DIExpression()), !dbg !495
  call void @llvm.dbg.value(metadata i32 1, metadata !496, metadata !DIExpression()), !dbg !495
  %3 = call i32 @ck_epoch_dispatch(%struct.ck_epoch_record* noundef %0, i32 noundef 1, %struct.ck_stack* noundef null), !dbg !497
  call void @llvm.dbg.value(metadata i32 2, metadata !496, metadata !DIExpression()), !dbg !495
  call void @llvm.dbg.value(metadata i32 2, metadata !496, metadata !DIExpression()), !dbg !495
  %4 = call i32 @ck_epoch_dispatch(%struct.ck_epoch_record* noundef %0, i32 noundef 2, %struct.ck_stack* noundef null), !dbg !497
  call void @llvm.dbg.value(metadata i32 3, metadata !496, metadata !DIExpression()), !dbg !495
  call void @llvm.dbg.value(metadata i32 3, metadata !496, metadata !DIExpression()), !dbg !495
  %5 = call i32 @ck_epoch_dispatch(%struct.ck_epoch_record* noundef %0, i32 noundef 3, %struct.ck_stack* noundef null), !dbg !497
  call void @llvm.dbg.value(metadata i32 4, metadata !496, metadata !DIExpression()), !dbg !495
  call void @llvm.dbg.value(metadata i32 4, metadata !496, metadata !DIExpression()), !dbg !495
  ret void, !dbg !500
}

; Function Attrs: noinline nounwind ssp uwtable
define internal i32 @ck_epoch_dispatch(%struct.ck_epoch_record* noundef %0, i32 noundef %1, %struct.ck_stack* noundef %2) #0 !dbg !501 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %0, metadata !505, metadata !DIExpression()), !dbg !506
  call void @llvm.dbg.value(metadata i32 %1, metadata !507, metadata !DIExpression()), !dbg !506
  call void @llvm.dbg.value(metadata %struct.ck_stack* %2, metadata !508, metadata !DIExpression()), !dbg !506
  %4 = and i32 %1, 3, !dbg !509
  call void @llvm.dbg.value(metadata i32 %4, metadata !510, metadata !DIExpression()), !dbg !506
  call void @llvm.dbg.value(metadata i32 0, metadata !511, metadata !DIExpression()), !dbg !506
  %5 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 10, !dbg !512
  %6 = zext i32 %4 to i64, !dbg !513
  %7 = getelementptr inbounds [4 x %struct.ck_stack], [4 x %struct.ck_stack]* %5, i64 0, i64 %6, !dbg !513
  %8 = call %struct.ck_stack_entry* @ck_stack_batch_pop_upmc(%struct.ck_stack* noundef %7), !dbg !514
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %8, metadata !515, metadata !DIExpression()), !dbg !506
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !516
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %8, metadata !517, metadata !DIExpression()), !dbg !506
  br label %9, !dbg !518

9:                                                ; preds = %23, %3
  %.01 = phi %struct.ck_stack_entry* [ %8, %3 ], [ %16, %23 ], !dbg !520
  %.0 = phi i32 [ 0, %3 ], [ %24, %23 ], !dbg !506
  call void @llvm.dbg.value(metadata i32 %.0, metadata !511, metadata !DIExpression()), !dbg !506
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %.01, metadata !517, metadata !DIExpression()), !dbg !506
  %10 = icmp ne %struct.ck_stack_entry* %.01, null, !dbg !521
  br i1 %10, label %11, label %25, !dbg !523

11:                                               ; preds = %9
  %12 = call %struct.ck_epoch_entry* @ck_epoch_entry_container(%struct.ck_stack_entry* noundef %.01), !dbg !524
  call void @llvm.dbg.value(metadata %struct.ck_epoch_entry* %12, metadata !526, metadata !DIExpression()), !dbg !527
  %13 = getelementptr inbounds %struct.ck_stack_entry, %struct.ck_stack_entry* %.01, i32 0, i32 0, !dbg !528
  %14 = bitcast %struct.ck_stack_entry** %13 to i64*, !dbg !528
  %15 = load atomic i64, i64* %14 monotonic, align 8, !dbg !528
  %16 = inttoptr i64 %15 to %struct.ck_stack_entry*, !dbg !528
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %16, metadata !529, metadata !DIExpression()), !dbg !506
  %17 = icmp ne %struct.ck_stack* %2, null, !dbg !530
  br i1 %17, label %18, label %20, !dbg !532

18:                                               ; preds = %11
  %19 = getelementptr inbounds %struct.ck_epoch_entry, %struct.ck_epoch_entry* %12, i32 0, i32 1, !dbg !533
  call void @ck_stack_push_spnc(%struct.ck_stack* noundef %2, %struct.ck_stack_entry* noundef %19), !dbg !534
  br label %23, !dbg !534

20:                                               ; preds = %11
  %21 = getelementptr inbounds %struct.ck_epoch_entry, %struct.ck_epoch_entry* %12, i32 0, i32 0, !dbg !535
  %22 = load void (%struct.ck_epoch_entry*)*, void (%struct.ck_epoch_entry*)** %21, align 8, !dbg !535
  call void %22(%struct.ck_epoch_entry* noundef %12), !dbg !536
  br label %23

23:                                               ; preds = %20, %18
  %24 = add i32 %.0, 1, !dbg !537
  call void @llvm.dbg.value(metadata i32 %24, metadata !511, metadata !DIExpression()), !dbg !506
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %16, metadata !517, metadata !DIExpression()), !dbg !506
  br label %9, !dbg !538, !llvm.loop !539

25:                                               ; preds = %9
  %26 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 7, !dbg !541
  %27 = load atomic i32, i32* %26 monotonic, align 8, !dbg !541
  call void @llvm.dbg.value(metadata i32 %27, metadata !542, metadata !DIExpression()), !dbg !506
  %28 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 6, !dbg !543
  %29 = load atomic i32, i32* %28 monotonic, align 4, !dbg !543
  call void @llvm.dbg.value(metadata i32 %29, metadata !544, metadata !DIExpression()), !dbg !506
  %30 = icmp ugt i32 %29, %27, !dbg !545
  br i1 %30, label %31, label %32, !dbg !547

31:                                               ; preds = %25
  store atomic i32 %27, i32* %26 monotonic, align 8, !dbg !548
  br label %32, !dbg !548

32:                                               ; preds = %31, %25
  %33 = icmp ugt i32 %.0, 0, !dbg !549
  br i1 %33, label %34, label %39, !dbg !551

34:                                               ; preds = %32
  %35 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 8, !dbg !552
  %36 = atomicrmw add i32* %35, i32 %.0 monotonic, align 4, !dbg !552
  %37 = sub i32 0, %.0, !dbg !554
  %38 = atomicrmw add i32* %28, i32 %37 monotonic, align 4, !dbg !554
  br label %39, !dbg !555

39:                                               ; preds = %34, %32
  ret i32 %.0, !dbg !556
}

; Function Attrs: noinline nounwind ssp uwtable
define internal %struct.ck_stack_entry* @ck_stack_batch_pop_upmc(%struct.ck_stack* noundef %0) #0 !dbg !557 {
  call void @llvm.dbg.value(metadata %struct.ck_stack* %0, metadata !560, metadata !DIExpression()), !dbg !561
  %2 = getelementptr inbounds %struct.ck_stack, %struct.ck_stack* %0, i32 0, i32 0, !dbg !562
  %3 = bitcast %struct.ck_stack_entry** %2 to i64*, !dbg !562
  %4 = atomicrmw xchg i64* %3, i64 0 monotonic, align 8, !dbg !562
  %5 = inttoptr i64 %4 to %struct.ck_stack_entry*, !dbg !562
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %5, metadata !563, metadata !DIExpression()), !dbg !561
  fence acquire, !dbg !564
  ret %struct.ck_stack_entry* %5, !dbg !565
}

; Function Attrs: noinline nounwind ssp uwtable
define internal %struct.ck_epoch_entry* @ck_epoch_entry_container(%struct.ck_stack_entry* noundef %0) #0 !dbg !566 {
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %0, metadata !569, metadata !DIExpression()), !dbg !570
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %0, metadata !571, metadata !DIExpression()), !dbg !570
  %2 = bitcast %struct.ck_stack_entry* %0 to i8*, !dbg !572
  %3 = getelementptr inbounds i8, i8* %2, i64 sub (i64 0, i64 ptrtoint (%struct.ck_stack_entry* getelementptr inbounds (%struct.ck_epoch_entry, %struct.ck_epoch_entry* null, i32 0, i32 1) to i64)), !dbg !572
  %4 = bitcast i8* %3 to %struct.ck_epoch_entry*, !dbg !572
  ret %struct.ck_epoch_entry* %4, !dbg !572
}

; Function Attrs: noinline nounwind ssp uwtable
define internal void @ck_stack_push_spnc(%struct.ck_stack* noundef %0, %struct.ck_stack_entry* noundef %1) #0 !dbg !573 {
  call void @llvm.dbg.value(metadata %struct.ck_stack* %0, metadata !574, metadata !DIExpression()), !dbg !575
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %1, metadata !576, metadata !DIExpression()), !dbg !575
  %3 = getelementptr inbounds %struct.ck_stack, %struct.ck_stack* %0, i32 0, i32 0, !dbg !577
  %4 = bitcast %struct.ck_stack_entry** %3 to i64*, !dbg !577
  %5 = load atomic i64, i64* %4 seq_cst, align 8, !dbg !577
  %6 = inttoptr i64 %5 to %struct.ck_stack_entry*, !dbg !577
  %7 = getelementptr inbounds %struct.ck_stack_entry, %struct.ck_stack_entry* %1, i32 0, i32 0, !dbg !578
  %8 = bitcast %struct.ck_stack_entry** %7 to i64*, !dbg !579
  store atomic i64 %5, i64* %8 seq_cst, align 8, !dbg !579
  %9 = ptrtoint %struct.ck_stack_entry* %1 to i64, !dbg !580
  store atomic i64 %9, i64* %4 seq_cst, align 8, !dbg !580
  ret void, !dbg !581
}

; Function Attrs: noinline nounwind ssp uwtable
define void @ck_epoch_synchronize_wait(%struct.ck_epoch* noundef %0, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* noundef %1, i8* noundef %2) #0 !dbg !582 {
  %4 = alloca i8, align 1
  call void @llvm.dbg.value(metadata %struct.ck_epoch* %0, metadata !591, metadata !DIExpression()), !dbg !592
  call void @llvm.dbg.value(metadata void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* %1, metadata !593, metadata !DIExpression()), !dbg !592
  call void @llvm.dbg.value(metadata i8* %2, metadata !594, metadata !DIExpression()), !dbg !592
  call void @llvm.dbg.declare(metadata i8* %4, metadata !595, metadata !DIExpression()), !dbg !596
  fence seq_cst, !dbg !597
  %5 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %0, i32 0, i32 0, !dbg !598
  %6 = load atomic i32, i32* %5 monotonic, align 8, !dbg !598
  call void @llvm.dbg.value(metadata i32 %6, metadata !599, metadata !DIExpression()), !dbg !592
  call void @llvm.dbg.value(metadata i32 %6, metadata !600, metadata !DIExpression()), !dbg !592
  %7 = add i32 %6, 3, !dbg !601
  call void @llvm.dbg.value(metadata i32 %7, metadata !602, metadata !DIExpression()), !dbg !592
  call void @llvm.dbg.value(metadata i32 0, metadata !603, metadata !DIExpression()), !dbg !592
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* null, metadata !604, metadata !DIExpression()), !dbg !592
  call void @llvm.dbg.value(metadata i32 0, metadata !603, metadata !DIExpression()), !dbg !592
  call void @llvm.dbg.value(metadata i32 %6, metadata !600, metadata !DIExpression()), !dbg !592
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* null, metadata !604, metadata !DIExpression()), !dbg !592
  br label %.outer, !dbg !605

.outer:                                           ; preds = %22, %3
  %.1.ph = phi i32 [ %12, %22 ], [ %6, %3 ]
  br label %8, !dbg !605

8:                                                ; preds = %.outer, %14
  %.13 = phi %struct.ck_epoch_record* [ %9, %14 ], [ null, %.outer ], !dbg !609
  call void @llvm.dbg.value(metadata i32 %.1.ph, metadata !600, metadata !DIExpression()), !dbg !592
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %.13, metadata !604, metadata !DIExpression()), !dbg !592
  %9 = call %struct.ck_epoch_record* @ck_epoch_scan(%struct.ck_epoch* noundef %0, %struct.ck_epoch_record* noundef %.13, i32 noundef %.1.ph, i8* noundef %4), !dbg !610
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %9, metadata !604, metadata !DIExpression()), !dbg !592
  %10 = icmp ne %struct.ck_epoch_record* %9, null, !dbg !611
  br i1 %10, label %11, label %23, !dbg !605

11:                                               ; preds = %8
  %12 = load atomic i32, i32* %5 monotonic, align 8, !dbg !612
  call void @llvm.dbg.value(metadata i32 %12, metadata !614, metadata !DIExpression()), !dbg !615
  %13 = icmp eq i32 %12, %.1.ph, !dbg !616
  br i1 %13, label %14, label %15, !dbg !618

14:                                               ; preds = %11
  call void @epoch_block(%struct.ck_epoch* noundef %0, %struct.ck_epoch_record* noundef %9, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* noundef %1, i8* noundef %2), !dbg !619
  br label %8, !dbg !621, !llvm.loop !622

15:                                               ; preds = %11
  call void @llvm.dbg.value(metadata i32 %12, metadata !600, metadata !DIExpression()), !dbg !592
  %16 = icmp ugt i32 %7, %6, !dbg !624
  %17 = zext i1 %16 to i32, !dbg !624
  %18 = icmp uge i32 %12, %7, !dbg !626
  %19 = zext i1 %18 to i32, !dbg !626
  %20 = and i32 %17, %19, !dbg !627
  %21 = icmp ne i32 %20, 0, !dbg !627
  br i1 %21, label %.loopexit7.loopexit11, label %22, !dbg !628

22:                                               ; preds = %15
  call void @epoch_block(%struct.ck_epoch* noundef %0, %struct.ck_epoch_record* noundef %9, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* noundef %1, i8* noundef %2), !dbg !629
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* null, metadata !604, metadata !DIExpression()), !dbg !592
  br label %.outer, !dbg !605, !llvm.loop !622

23:                                               ; preds = %8
  %24 = load i8, i8* %4, align 1, !dbg !630
  %25 = trunc i8 %24 to i1, !dbg !630
  %26 = zext i1 %25 to i32, !dbg !630
  %27 = icmp eq i32 %26, 0, !dbg !632
  br i1 %27, label %.loopexit7, label %28, !dbg !633

28:                                               ; preds = %23
  %29 = add i32 %.1.ph, 1, !dbg !634
  %30 = cmpxchg i32* %5, i32 %.1.ph, i32 %29 monotonic monotonic, align 4, !dbg !634
  %31 = extractvalue { i32, i1 } %30, 0, !dbg !634
  %32 = extractvalue { i32, i1 } %30, 1, !dbg !634
  %spec.select = select i1 %32, i32 %.1.ph, i32 %31, !dbg !634
  call void @llvm.dbg.value(metadata i32 %spec.select, metadata !600, metadata !DIExpression()), !dbg !592
  call void @llvm.dbg.value(metadata i1 %32, metadata !635, metadata !DIExpression(DW_OP_LLVM_convert, 1, DW_ATE_unsigned, DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !636
  fence acquire, !dbg !637
  %33 = zext i1 %32 to i32, !dbg !638
  %34 = add i32 %spec.select, %33, !dbg !639
  call void @llvm.dbg.value(metadata i32 %34, metadata !600, metadata !DIExpression()), !dbg !592
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* null, metadata !604, metadata !DIExpression()), !dbg !592
  call void @llvm.dbg.value(metadata i32 1, metadata !603, metadata !DIExpression()), !dbg !592
  call void @llvm.dbg.value(metadata i32 1, metadata !603, metadata !DIExpression()), !dbg !592
  call void @llvm.dbg.value(metadata i32 %34, metadata !600, metadata !DIExpression()), !dbg !592
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* null, metadata !604, metadata !DIExpression()), !dbg !592
  br label %.outer.1, !dbg !605

.outer.1:                                         ; preds = %59, %28
  %.1.ph.1 = phi i32 [ %50, %59 ], [ %34, %28 ]
  br label %35, !dbg !605

35:                                               ; preds = %60, %.outer.1
  %.13.1 = phi %struct.ck_epoch_record* [ %36, %60 ], [ null, %.outer.1 ], !dbg !609
  call void @llvm.dbg.value(metadata i32 %.1.ph.1, metadata !600, metadata !DIExpression()), !dbg !592
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %.13.1, metadata !604, metadata !DIExpression()), !dbg !592
  %36 = call %struct.ck_epoch_record* @ck_epoch_scan(%struct.ck_epoch* noundef %0, %struct.ck_epoch_record* noundef %.13.1, i32 noundef %.1.ph.1, i8* noundef %4), !dbg !610
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %36, metadata !604, metadata !DIExpression()), !dbg !592
  %37 = icmp ne %struct.ck_epoch_record* %36, null, !dbg !611
  br i1 %37, label %49, label %38, !dbg !605

38:                                               ; preds = %35
  %39 = load i8, i8* %4, align 1, !dbg !630
  %40 = trunc i8 %39 to i1, !dbg !630
  %41 = zext i1 %40 to i32, !dbg !630
  %42 = icmp eq i32 %41, 0, !dbg !632
  br i1 %42, label %.loopexit7, label %.loopexit, !dbg !633

.loopexit:                                        ; preds = %38
  %43 = add i32 %.1.ph.1, 1, !dbg !634
  %44 = cmpxchg i32* %5, i32 %.1.ph.1, i32 %43 monotonic monotonic, align 4, !dbg !634
  %45 = extractvalue { i32, i1 } %44, 0, !dbg !634
  %46 = extractvalue { i32, i1 } %44, 1, !dbg !634
  %spec.select10 = select i1 %46, i32 %.1.ph.1, i32 %45, !dbg !634
  call void @llvm.dbg.value(metadata i32 %spec.select10, metadata !600, metadata !DIExpression()), !dbg !592
  call void @llvm.dbg.value(metadata i1 %46, metadata !635, metadata !DIExpression(DW_OP_LLVM_convert, 1, DW_ATE_unsigned, DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !636
  fence acquire, !dbg !637
  %47 = zext i1 %46 to i32, !dbg !638
  %48 = add i32 %spec.select10, %47, !dbg !639
  call void @llvm.dbg.value(metadata i32 %48, metadata !600, metadata !DIExpression()), !dbg !592
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* null, metadata !604, metadata !DIExpression()), !dbg !592
  call void @llvm.dbg.value(metadata i32 2, metadata !603, metadata !DIExpression()), !dbg !592
  call void @llvm.dbg.value(metadata i32 2, metadata !603, metadata !DIExpression()), !dbg !592
  call void @llvm.dbg.value(metadata i32 %48, metadata !600, metadata !DIExpression()), !dbg !592
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* null, metadata !604, metadata !DIExpression()), !dbg !592
  br label %.loopexit7, !dbg !640

49:                                               ; preds = %35
  %50 = load atomic i32, i32* %5 monotonic, align 8, !dbg !612
  call void @llvm.dbg.value(metadata i32 %50, metadata !614, metadata !DIExpression()), !dbg !615
  %51 = icmp eq i32 %50, %.1.ph.1, !dbg !616
  br i1 %51, label %60, label %52, !dbg !618

52:                                               ; preds = %49
  call void @llvm.dbg.value(metadata i32 %50, metadata !600, metadata !DIExpression()), !dbg !592
  %53 = icmp ugt i32 %7, %6, !dbg !624
  %54 = zext i1 %53 to i32, !dbg !624
  %55 = icmp uge i32 %50, %7, !dbg !626
  %56 = zext i1 %55 to i32, !dbg !626
  %57 = and i32 %54, %56, !dbg !627
  %58 = icmp ne i32 %57, 0, !dbg !627
  br i1 %58, label %.loopexit7.loopexit, label %59, !dbg !628

59:                                               ; preds = %52
  call void @epoch_block(%struct.ck_epoch* noundef %0, %struct.ck_epoch_record* noundef %36, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* noundef %1, i8* noundef %2), !dbg !629
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* null, metadata !604, metadata !DIExpression()), !dbg !592
  br label %.outer.1, !dbg !605, !llvm.loop !622

60:                                               ; preds = %49
  call void @epoch_block(%struct.ck_epoch* noundef %0, %struct.ck_epoch_record* noundef %36, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* noundef %1, i8* noundef %2), !dbg !619
  br label %35, !dbg !621, !llvm.loop !622

.loopexit7.loopexit:                              ; preds = %52
  br label %.loopexit7, !dbg !641

.loopexit7.loopexit11:                            ; preds = %15
  br label %.loopexit7, !dbg !641

.loopexit7:                                       ; preds = %.loopexit7.loopexit11, %.loopexit7.loopexit, %.loopexit, %38, %23
  call void @llvm.dbg.label(metadata !642), !dbg !643
  fence seq_cst, !dbg !641
  ret void, !dbg !644
}

; Function Attrs: noinline nounwind ssp uwtable
define internal %struct.ck_epoch_record* @ck_epoch_scan(%struct.ck_epoch* noundef %0, %struct.ck_epoch_record* noundef %1, i32 noundef %2, i8* noundef %3) #0 !dbg !645 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch* %0, metadata !649, metadata !DIExpression()), !dbg !650
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %1, metadata !651, metadata !DIExpression()), !dbg !650
  call void @llvm.dbg.value(metadata i32 %2, metadata !652, metadata !DIExpression()), !dbg !650
  call void @llvm.dbg.value(metadata i8* %3, metadata !653, metadata !DIExpression()), !dbg !650
  %5 = icmp eq %struct.ck_epoch_record* %1, null, !dbg !654
  br i1 %5, label %6, label %12, !dbg !656

6:                                                ; preds = %4
  %7 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %0, i32 0, i32 2, !dbg !657
  %8 = getelementptr inbounds %struct.ck_stack, %struct.ck_stack* %7, i32 0, i32 0, !dbg !657
  %9 = bitcast %struct.ck_stack_entry** %8 to i64*, !dbg !657
  %10 = load atomic i64, i64* %9 monotonic, align 8, !dbg !657
  %11 = inttoptr i64 %10 to %struct.ck_stack_entry*, !dbg !657
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %11, metadata !659, metadata !DIExpression()), !dbg !650
  store i8 0, i8* %3, align 1, !dbg !660
  br label %14, !dbg !661

12:                                               ; preds = %4
  %13 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %1, i32 0, i32 0, !dbg !662
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %13, metadata !659, metadata !DIExpression()), !dbg !650
  store i8 1, i8* %3, align 1, !dbg !664
  br label %14

14:                                               ; preds = %12, %6
  %.01 = phi %struct.ck_stack_entry* [ %11, %6 ], [ %13, %12 ], !dbg !665
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %.01, metadata !659, metadata !DIExpression()), !dbg !650
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !666
  br label %15, !dbg !667

15:                                               ; preds = %.backedge, %14
  %.1 = phi %struct.ck_stack_entry* [ %.01, %14 ], [ %.1.be, %.backedge ], !dbg !650
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %.1, metadata !659, metadata !DIExpression()), !dbg !650
  %16 = icmp ne %struct.ck_stack_entry* %.1, null, !dbg !668
  br i1 %16, label %17, label %47, !dbg !667

17:                                               ; preds = %15
  %18 = call %struct.ck_epoch_record* @ck_epoch_record_container(%struct.ck_stack_entry* noundef %.1), !dbg !669
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %18, metadata !651, metadata !DIExpression()), !dbg !650
  %19 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %18, i32 0, i32 2, !dbg !671
  %20 = load atomic i32, i32* %19 monotonic, align 8, !dbg !671
  call void @llvm.dbg.value(metadata i32 %20, metadata !672, metadata !DIExpression()), !dbg !673
  %21 = and i32 %20, 1, !dbg !674
  %22 = icmp ne i32 %21, 0, !dbg !674
  br i1 %22, label %23, label %28, !dbg !676

23:                                               ; preds = %17
  %24 = getelementptr inbounds %struct.ck_stack_entry, %struct.ck_stack_entry* %.1, i32 0, i32 0, !dbg !677
  %25 = bitcast %struct.ck_stack_entry** %24 to i64*, !dbg !677
  %26 = load atomic i64, i64* %25 monotonic, align 8, !dbg !677
  %27 = inttoptr i64 %26 to %struct.ck_stack_entry*, !dbg !677
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %27, metadata !659, metadata !DIExpression()), !dbg !650
  br label %.backedge, !dbg !679

.backedge:                                        ; preds = %23, %42
  %.1.be = phi %struct.ck_stack_entry* [ %27, %23 ], [ %46, %42 ]
  br label %15, !dbg !650, !llvm.loop !680

28:                                               ; preds = %17
  %29 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %18, i32 0, i32 4, !dbg !682
  %30 = load atomic i32, i32* %29 monotonic, align 8, !dbg !682
  call void @llvm.dbg.value(metadata i32 %30, metadata !683, metadata !DIExpression()), !dbg !673
  %31 = load i8, i8* %3, align 1, !dbg !684
  %32 = trunc i8 %31 to i1, !dbg !684
  %33 = zext i1 %32 to i32, !dbg !684
  %34 = or i32 %33, %30, !dbg !684
  %35 = icmp ne i32 %34, 0, !dbg !684
  %36 = zext i1 %35 to i8, !dbg !684
  store i8 %36, i8* %3, align 1, !dbg !684
  %37 = icmp ne i32 %30, 0, !dbg !685
  br i1 %37, label %38, label %42, !dbg !687

38:                                               ; preds = %28
  %39 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %18, i32 0, i32 3, !dbg !688
  %40 = load atomic i32, i32* %39 monotonic, align 4, !dbg !688
  %41 = icmp ne i32 %40, %2, !dbg !689
  br i1 %41, label %47, label %42, !dbg !690

42:                                               ; preds = %38, %28
  %43 = getelementptr inbounds %struct.ck_stack_entry, %struct.ck_stack_entry* %.1, i32 0, i32 0, !dbg !691
  %44 = bitcast %struct.ck_stack_entry** %43 to i64*, !dbg !691
  %45 = load atomic i64, i64* %44 monotonic, align 8, !dbg !691
  %46 = inttoptr i64 %45 to %struct.ck_stack_entry*, !dbg !691
  call void @llvm.dbg.value(metadata %struct.ck_stack_entry* %46, metadata !659, metadata !DIExpression()), !dbg !650
  br label %.backedge, !dbg !667

47:                                               ; preds = %15, %38
  %.0 = phi %struct.ck_epoch_record* [ %18, %38 ], [ null, %15 ], !dbg !650
  ret %struct.ck_epoch_record* %.0, !dbg !692
}

; Function Attrs: noinline nounwind ssp uwtable
define internal void @epoch_block(%struct.ck_epoch* noundef %0, %struct.ck_epoch_record* noundef %1, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* noundef %2, i8* noundef %3) #0 !dbg !693 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch* %0, metadata !696, metadata !DIExpression()), !dbg !697
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %1, metadata !698, metadata !DIExpression()), !dbg !697
  call void @llvm.dbg.value(metadata void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* %2, metadata !699, metadata !DIExpression()), !dbg !697
  call void @llvm.dbg.value(metadata i8* %3, metadata !700, metadata !DIExpression()), !dbg !697
  %5 = icmp ne void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* %2, null, !dbg !701
  br i1 %5, label %6, label %7, !dbg !703

6:                                                ; preds = %4
  call void %2(%struct.ck_epoch* noundef %0, %struct.ck_epoch_record* noundef %1, i8* noundef %3), !dbg !704
  br label %7, !dbg !704

7:                                                ; preds = %6, %4
  ret void, !dbg !705
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: noinline nounwind ssp uwtable
define void @ck_epoch_synchronize(%struct.ck_epoch_record* noundef %0) #0 !dbg !706 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %0, metadata !707, metadata !DIExpression()), !dbg !708
  %2 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 1, !dbg !709
  %3 = load %struct.ck_epoch*, %struct.ck_epoch** %2, align 8, !dbg !709
  call void @ck_epoch_synchronize_wait(%struct.ck_epoch* noundef %3, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* noundef null, i8* noundef null), !dbg !710
  ret void, !dbg !711
}

; Function Attrs: noinline nounwind ssp uwtable
define void @ck_epoch_barrier(%struct.ck_epoch_record* noundef %0) #0 !dbg !712 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %0, metadata !713, metadata !DIExpression()), !dbg !714
  call void @ck_epoch_synchronize(%struct.ck_epoch_record* noundef %0), !dbg !715
  call void @ck_epoch_reclaim(%struct.ck_epoch_record* noundef %0), !dbg !716
  ret void, !dbg !717
}

; Function Attrs: noinline nounwind ssp uwtable
define void @ck_epoch_barrier_wait(%struct.ck_epoch_record* noundef %0, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* noundef %1, i8* noundef %2) #0 !dbg !718 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %0, metadata !721, metadata !DIExpression()), !dbg !722
  call void @llvm.dbg.value(metadata void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* %1, metadata !723, metadata !DIExpression()), !dbg !722
  call void @llvm.dbg.value(metadata i8* %2, metadata !724, metadata !DIExpression()), !dbg !722
  %4 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 1, !dbg !725
  %5 = load %struct.ck_epoch*, %struct.ck_epoch** %4, align 8, !dbg !725
  call void @ck_epoch_synchronize_wait(%struct.ck_epoch* noundef %5, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* noundef %1, i8* noundef %2), !dbg !726
  call void @ck_epoch_reclaim(%struct.ck_epoch_record* noundef %0), !dbg !727
  ret void, !dbg !728
}

; Function Attrs: noinline nounwind ssp uwtable
define zeroext i1 @ck_epoch_poll_deferred(%struct.ck_epoch_record* noundef %0, %struct.ck_stack* noundef %1) #0 !dbg !729 {
  %3 = alloca i8, align 1
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %0, metadata !732, metadata !DIExpression()), !dbg !733
  call void @llvm.dbg.value(metadata %struct.ck_stack* %1, metadata !734, metadata !DIExpression()), !dbg !733
  call void @llvm.dbg.declare(metadata i8* %3, metadata !735, metadata !DIExpression()), !dbg !736
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* null, metadata !737, metadata !DIExpression()), !dbg !733
  %4 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 1, !dbg !738
  %5 = load %struct.ck_epoch*, %struct.ck_epoch** %4, align 8, !dbg !738
  call void @llvm.dbg.value(metadata %struct.ck_epoch* %5, metadata !739, metadata !DIExpression()), !dbg !733
  call void @llvm.dbg.value(metadata i32 0, metadata !740, metadata !DIExpression()), !dbg !733
  %6 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %5, i32 0, i32 0, !dbg !741
  %7 = load atomic i32, i32* %6 monotonic, align 8, !dbg !741
  call void @llvm.dbg.value(metadata i32 %7, metadata !742, metadata !DIExpression()), !dbg !733
  fence seq_cst, !dbg !743
  %8 = call %struct.ck_epoch_record* @ck_epoch_scan(%struct.ck_epoch* noundef %5, %struct.ck_epoch_record* noundef null, i32 noundef %7, i8* noundef %3), !dbg !744
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %8, metadata !737, metadata !DIExpression()), !dbg !733
  %9 = icmp ne %struct.ck_epoch_record* %8, null, !dbg !745
  br i1 %9, label %22, label %10, !dbg !747

10:                                               ; preds = %2
  %11 = load i8, i8* %3, align 1, !dbg !748
  %12 = trunc i8 %11 to i1, !dbg !748
  %13 = zext i1 %12 to i32, !dbg !748
  %14 = icmp eq i32 %13, 0, !dbg !750
  br i1 %14, label %15, label %17, !dbg !751

15:                                               ; preds = %10
  %16 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %0, i32 0, i32 3, !dbg !752
  store atomic i32 %7, i32* %16 monotonic, align 4, !dbg !752
  br label %22, !dbg !754

17:                                               ; preds = %10
  call void @llvm.dbg.value(metadata i32 %7, metadata !755, metadata !DIExpression()), !dbg !757
  %18 = add i32 %7, 1, !dbg !758
  %19 = cmpxchg i32* %6, i32 %7, i32 %18 monotonic monotonic, align 4, !dbg !758
  %20 = extractvalue { i32, i1 } %19, 1, !dbg !758
  %21 = zext i1 %20 to i8, !dbg !758
  br label %22, !dbg !759

22:                                               ; preds = %2, %17, %15
  %.0 = phi i1 [ true, %15 ], [ true, %17 ], [ false, %2 ], !dbg !733
  ret i1 %.0, !dbg !760
}

; Function Attrs: noinline nounwind ssp uwtable
define zeroext i1 @ck_epoch_poll(%struct.ck_epoch_record* noundef %0) #0 !dbg !761 {
  call void @llvm.dbg.value(metadata %struct.ck_epoch_record* %0, metadata !764, metadata !DIExpression()), !dbg !765
  %2 = call zeroext i1 @ck_epoch_poll_deferred(%struct.ck_epoch_record* noundef %0, %struct.ck_stack* noundef null), !dbg !766
  ret i1 %2, !dbg !767
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #3 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #4 = { nounwind "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #5 = { cold noreturn }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2, !73}
!llvm.ident = !{!136, !136}
!llvm.module.flags = !{!137, !138, !139, !140, !141, !142, !143, !144, !145, !146}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "stack_epoch", scope: !2, file: !3, line: 10, type: !72, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !68, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "client-code.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/demo/ck_epoch")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 56, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/opt/homebrew/Cellar/llvm@14/14.0.6/lib/clang/14.0.6/include/stdatomic.h", directory: "")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0)
!10 = !DIEnumerator(name: "memory_order_consume", value: 1)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2)
!12 = !DIEnumerator(name: "memory_order_release", value: 3)
!13 = !DIEnumerator(name: "memory_order_acq_rel", value: 4)
!14 = !DIEnumerator(name: "memory_order_seq_cst", value: 5)
!15 = !{!16, !17}
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!17 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !18, size: 64)
!18 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_record_t", file: !19, line: 101, baseType: !20)
!19 = !DIFile(filename: "./ck_epoch.h", directory: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/demo/ck_epoch")
!20 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_epoch_record", file: !19, line: 86, size: 1024, elements: !21)
!21 = !{!22, !30, !45, !46, !47, !48, !59, !60, !61, !62, !64}
!22 = !DIDerivedType(tag: DW_TAG_member, name: "record_next", scope: !20, file: !19, line: 87, baseType: !23, size: 64)
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_stack_entry_t", file: !24, line: 41, baseType: !25)
!24 = !DIFile(filename: "./ck_stack.h", directory: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/demo/ck_epoch")
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
!70 = distinct !DIGlobalVariable(name: "records", scope: !2, file: !3, line: 33, type: !71, isLocal: false, isDefinition: true)
!71 = !DICompositeType(tag: DW_TAG_array_type, baseType: !18, size: 4096, elements: !66)
!72 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_t", file: !19, line: 108, baseType: !32)
!73 = distinct !DICompileUnit(language: DW_LANG_C99, file: !74, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !75, retainedTypes: !80, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!74 = !DIFile(filename: "ck_epoch.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/demo/ck_epoch")
!75 = !{!5, !76}
!76 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !74, line: 140, baseType: !7, size: 32, elements: !77)
!77 = !{!78, !79}
!78 = !DIEnumerator(name: "CK_EPOCH_STATE_USED", value: 0)
!79 = !DIEnumerator(name: "CK_EPOCH_STATE_FREE", value: 1)
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
!123 = !DIFile(filename: "/opt/homebrew/Cellar/llvm@14/14.0.6/lib/clang/14.0.6/include/stddef.h", directory: "")
!124 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
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
!136 = !{!"Homebrew clang version 14.0.6"}
!137 = !{i32 7, !"Dwarf Version", i32 4}
!138 = !{i32 2, !"Debug Info Version", i32 3}
!139 = !{i32 1, !"wchar_size", i32 4}
!140 = !{i32 1, !"branch-target-enforcement", i32 0}
!141 = !{i32 1, !"sign-return-address", i32 0}
!142 = !{i32 1, !"sign-return-address-all", i32 0}
!143 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!144 = !{i32 7, !"PIC Level", i32 2}
!145 = !{i32 7, !"uwtable", i32 1}
!146 = !{i32 7, !"frame-pointer", i32 1}
!147 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 35, type: !148, scopeLine: 36, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !151)
!148 = !DISubroutineType(types: !149)
!149 = !{!81, !81, !150}
!150 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !43, size: 64)
!151 = !{}
!152 = !DILocalVariable(name: "argc", arg: 1, scope: !147, file: !3, line: 35, type: !81)
!153 = !DILocation(line: 0, scope: !147)
!154 = !DILocalVariable(name: "argv", arg: 2, scope: !147, file: !3, line: 35, type: !150)
!155 = !DILocalVariable(name: "threads", scope: !147, file: !3, line: 37, type: !156)
!156 = !DICompositeType(tag: DW_TAG_array_type, baseType: !157, size: 256, elements: !66)
!157 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !158, line: 31, baseType: !159)
!158 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!159 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !160, line: 118, baseType: !161)
!160 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!161 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !162, size: 64)
!162 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !160, line: 103, size: 65536, elements: !163)
!163 = !{!164, !166, !176}
!164 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !162, file: !160, line: 104, baseType: !165, size: 64)
!165 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!166 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !162, file: !160, line: 105, baseType: !167, size: 64, offset: 64)
!167 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !168, size: 64)
!168 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !160, line: 57, size: 192, elements: !169)
!169 = !{!170, !174, !175}
!170 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !168, file: !160, line: 58, baseType: !171, size: 64)
!171 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !172, size: 64)
!172 = !DISubroutineType(types: !173)
!173 = !{null, !16}
!174 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !168, file: !160, line: 59, baseType: !16, size: 64, offset: 64)
!175 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !168, file: !160, line: 60, baseType: !167, size: 64, offset: 128)
!176 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !162, file: !160, line: 106, baseType: !177, size: 65408, offset: 128)
!177 = !DICompositeType(tag: DW_TAG_array_type, baseType: !44, size: 65408, elements: !178)
!178 = !{!179}
!179 = !DISubrange(count: 8176)
!180 = !DILocation(line: 37, column: 12, scope: !147)
!181 = !DILocation(line: 39, column: 2, scope: !147)
!182 = !DILocation(line: 41, column: 2, scope: !147)
!183 = !DILocalVariable(name: "i", scope: !184, file: !3, line: 42, type: !81)
!184 = distinct !DILexicalBlock(scope: !147, file: !3, line: 42, column: 2)
!185 = !DILocation(line: 0, scope: !184)
!186 = !DILocation(line: 43, column: 3, scope: !187)
!187 = distinct !DILexicalBlock(scope: !188, file: !3, line: 42, column: 37)
!188 = distinct !DILexicalBlock(scope: !184, file: !3, line: 42, column: 2)
!189 = !DILocation(line: 44, column: 19, scope: !187)
!190 = !DILocation(line: 44, column: 3, scope: !187)
!191 = !DILocation(line: 47, column: 2, scope: !147)
!192 = distinct !DISubprogram(name: "thread", scope: !3, file: !3, line: 12, type: !193, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !151)
!193 = !DISubroutineType(types: !194)
!194 = !{!16, !16}
!195 = !DILocalVariable(name: "arg", arg: 1, scope: !192, file: !3, line: 12, type: !16)
!196 = !DILocation(line: 0, scope: !192)
!197 = !DILocation(line: 14, column: 30, scope: !192)
!198 = !DILocalVariable(name: "record", scope: !192, file: !3, line: 14, type: !17)
!199 = !DILocation(line: 19, column: 2, scope: !192)
!200 = !DILocation(line: 20, column: 21, scope: !192)
!201 = !DILocalVariable(name: "global_epoch", scope: !192, file: !3, line: 20, type: !81)
!202 = !DILocation(line: 21, column: 20, scope: !192)
!203 = !DILocalVariable(name: "local_epoch", scope: !192, file: !3, line: 21, type: !81)
!204 = !DILocation(line: 22, column: 2, scope: !192)
!205 = !DILocation(line: 25, column: 2, scope: !192)
!206 = !DILocation(line: 27, column: 2, scope: !192)
!207 = !DILocation(line: 29, column: 2, scope: !192)
!208 = distinct !DISubprogram(name: "ck_epoch_begin", scope: !19, file: !19, line: 127, type: !209, scopeLine: 128, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !151)
!209 = !DISubroutineType(types: !210)
!210 = !{null, !17, !211}
!211 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !212, size: 64)
!212 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_section_t", file: !19, line: 72, baseType: !213)
!213 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_epoch_section", file: !19, line: 69, size: 32, elements: !214)
!214 = !{!215}
!215 = !DIDerivedType(tag: DW_TAG_member, name: "bucket", scope: !213, file: !19, line: 70, baseType: !7, size: 32)
!216 = !DILocalVariable(name: "record", arg: 1, scope: !208, file: !19, line: 127, type: !17)
!217 = !DILocation(line: 0, scope: !208)
!218 = !DILocalVariable(name: "section", arg: 2, scope: !208, file: !19, line: 127, type: !211)
!219 = !DILocation(line: 129, column: 35, scope: !208)
!220 = !DILocalVariable(name: "epoch", scope: !208, file: !19, line: 129, type: !31)
!221 = !DILocation(line: 135, column: 6, scope: !222)
!222 = distinct !DILexicalBlock(scope: !208, file: !19, line: 135, column: 6)
!223 = !DILocation(line: 135, column: 39, scope: !222)
!224 = !DILocation(line: 135, column: 6, scope: !208)
!225 = !DILocation(line: 147, column: 3, scope: !226)
!226 = distinct !DILexicalBlock(scope: !222, file: !19, line: 135, column: 45)
!227 = !DILocation(line: 148, column: 3, scope: !226)
!228 = !DILocation(line: 158, column: 13, scope: !226)
!229 = !DILocalVariable(name: "g_epoch", scope: !226, file: !19, line: 136, type: !7)
!230 = !DILocation(line: 0, scope: !226)
!231 = !DILocation(line: 159, column: 3, scope: !226)
!232 = !DILocation(line: 160, column: 2, scope: !226)
!233 = !DILocation(line: 161, column: 3, scope: !234)
!234 = distinct !DILexicalBlock(scope: !222, file: !19, line: 160, column: 9)
!235 = !DILocation(line: 164, column: 14, scope: !236)
!236 = distinct !DILexicalBlock(scope: !208, file: !19, line: 164, column: 6)
!237 = !DILocation(line: 164, column: 6, scope: !208)
!238 = !DILocation(line: 165, column: 3, scope: !236)
!239 = !DILocation(line: 167, column: 2, scope: !208)
!240 = distinct !DISubprogram(name: "ck_epoch_end", scope: !19, file: !19, line: 175, type: !241, scopeLine: 176, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !151)
!241 = !DISubroutineType(types: !242)
!242 = !{!243, !17, !211}
!243 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!244 = !DILocalVariable(name: "record", arg: 1, scope: !240, file: !19, line: 175, type: !17)
!245 = !DILocation(line: 0, scope: !240)
!246 = !DILocalVariable(name: "section", arg: 2, scope: !240, file: !19, line: 175, type: !211)
!247 = !DILocation(line: 178, column: 2, scope: !240)
!248 = !DILocation(line: 179, column: 2, scope: !240)
!249 = !DILocation(line: 181, column: 14, scope: !250)
!250 = distinct !DILexicalBlock(scope: !240, file: !19, line: 181, column: 6)
!251 = !DILocation(line: 181, column: 6, scope: !240)
!252 = !DILocation(line: 182, column: 10, scope: !250)
!253 = !DILocation(line: 182, column: 3, scope: !250)
!254 = !DILocation(line: 184, column: 9, scope: !240)
!255 = !DILocation(line: 184, column: 42, scope: !240)
!256 = !DILocation(line: 184, column: 2, scope: !240)
!257 = !DILocation(line: 185, column: 1, scope: !240)
!258 = distinct !DISubprogram(name: "_ck_epoch_delref", scope: !74, file: !74, line: 153, type: !259, scopeLine: 155, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !151)
!259 = !DISubroutineType(types: !260)
!260 = !{!243, !82, !261}
!261 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !262, size: 64)
!262 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_epoch_section", file: !19, line: 69, size: 32, elements: !263)
!263 = !{!264}
!264 = !DIDerivedType(tag: DW_TAG_member, name: "bucket", scope: !262, file: !19, line: 70, baseType: !7, size: 32)
!265 = !DILocalVariable(name: "record", arg: 1, scope: !258, file: !74, line: 153, type: !82)
!266 = !DILocation(line: 0, scope: !258)
!267 = !DILocalVariable(name: "section", arg: 2, scope: !258, file: !74, line: 154, type: !261)
!268 = !DILocation(line: 157, column: 28, scope: !258)
!269 = !DILocalVariable(name: "i", scope: !258, file: !74, line: 157, type: !7)
!270 = !DILocation(line: 159, column: 21, scope: !258)
!271 = !DILocation(line: 159, column: 27, scope: !258)
!272 = !DILocation(line: 159, column: 13, scope: !258)
!273 = !DILocalVariable(name: "current", scope: !258, file: !74, line: 156, type: !274)
!274 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !112, size: 64)
!275 = !DILocation(line: 160, column: 11, scope: !258)
!276 = !DILocation(line: 160, column: 16, scope: !258)
!277 = !DILocation(line: 162, column: 21, scope: !278)
!278 = distinct !DILexicalBlock(scope: !258, file: !74, line: 162, column: 6)
!279 = !DILocation(line: 162, column: 6, scope: !258)
!280 = !DILocation(line: 174, column: 35, scope: !258)
!281 = !DILocation(line: 174, column: 40, scope: !258)
!282 = !DILocation(line: 174, column: 11, scope: !258)
!283 = !DILocalVariable(name: "other", scope: !258, file: !74, line: 156, type: !274)
!284 = !DILocation(line: 175, column: 13, scope: !285)
!285 = distinct !DILexicalBlock(scope: !258, file: !74, line: 175, column: 6)
!286 = !DILocation(line: 175, column: 19, scope: !285)
!287 = !DILocation(line: 175, column: 23, scope: !285)
!288 = !DILocation(line: 176, column: 22, scope: !285)
!289 = !DILocation(line: 176, column: 37, scope: !285)
!290 = !DILocation(line: 176, column: 28, scope: !285)
!291 = !DILocation(line: 176, column: 44, scope: !285)
!292 = !DILocation(line: 175, column: 6, scope: !258)
!293 = !DILocation(line: 181, column: 3, scope: !294)
!294 = distinct !DILexicalBlock(scope: !285, file: !74, line: 176, column: 50)
!295 = !DILocation(line: 182, column: 2, scope: !294)
!296 = !DILocation(line: 185, column: 1, scope: !258)
!297 = distinct !DISubprogram(name: "_ck_epoch_addref", scope: !74, file: !74, line: 188, type: !298, scopeLine: 190, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !151)
!298 = !DISubroutineType(types: !299)
!299 = !{null, !82, !261}
!300 = !DILocalVariable(name: "record", arg: 1, scope: !297, file: !74, line: 188, type: !82)
!301 = !DILocation(line: 0, scope: !297)
!302 = !DILocalVariable(name: "section", arg: 2, scope: !297, file: !74, line: 189, type: !261)
!303 = !DILocation(line: 191, column: 36, scope: !297)
!304 = !DILocalVariable(name: "global", scope: !297, file: !74, line: 191, type: !93)
!305 = !DILocation(line: 195, column: 10, scope: !297)
!306 = !DILocalVariable(name: "epoch", scope: !297, file: !74, line: 193, type: !7)
!307 = !DILocation(line: 196, column: 12, scope: !297)
!308 = !DILocalVariable(name: "i", scope: !297, file: !74, line: 193, type: !7)
!309 = !DILocation(line: 197, column: 17, scope: !297)
!310 = !DILocation(line: 197, column: 23, scope: !297)
!311 = !DILocation(line: 197, column: 9, scope: !297)
!312 = !DILocalVariable(name: "ref", scope: !297, file: !74, line: 192, type: !274)
!313 = !DILocation(line: 199, column: 11, scope: !314)
!314 = distinct !DILexicalBlock(scope: !297, file: !74, line: 199, column: 6)
!315 = !DILocation(line: 199, column: 16, scope: !314)
!316 = !DILocation(line: 199, column: 19, scope: !314)
!317 = !DILocation(line: 199, column: 6, scope: !297)
!318 = !DILocation(line: 213, column: 39, scope: !319)
!319 = distinct !DILexicalBlock(scope: !314, file: !74, line: 199, column: 25)
!320 = !DILocation(line: 213, column: 44, scope: !319)
!321 = !DILocation(line: 213, column: 15, scope: !319)
!322 = !DILocalVariable(name: "previous", scope: !319, file: !74, line: 201, type: !274)
!323 = !DILocation(line: 0, scope: !319)
!324 = !DILocation(line: 215, column: 17, scope: !325)
!325 = distinct !DILexicalBlock(scope: !319, file: !74, line: 215, column: 7)
!326 = !DILocation(line: 215, column: 23, scope: !325)
!327 = !DILocation(line: 215, column: 7, scope: !319)
!328 = !DILocation(line: 216, column: 4, scope: !325)
!329 = !DILocation(line: 223, column: 8, scope: !319)
!330 = !DILocation(line: 223, column: 14, scope: !319)
!331 = !DILocation(line: 224, column: 2, scope: !319)
!332 = !DILocation(line: 226, column: 11, scope: !297)
!333 = !DILocation(line: 226, column: 18, scope: !297)
!334 = !DILocation(line: 227, column: 2, scope: !297)
!335 = distinct !DISubprogram(name: "ck_epoch_init", scope: !74, file: !74, line: 231, type: !336, scopeLine: 232, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !151)
!336 = !DISubroutineType(types: !337)
!337 = !{null, !93}
!338 = !DILocalVariable(name: "global", arg: 1, scope: !335, file: !74, line: 231, type: !93)
!339 = !DILocation(line: 0, scope: !335)
!340 = !DILocation(line: 234, column: 25, scope: !335)
!341 = !DILocation(line: 234, column: 2, scope: !335)
!342 = !DILocation(line: 235, column: 10, scope: !335)
!343 = !DILocation(line: 235, column: 16, scope: !335)
!344 = !DILocation(line: 236, column: 10, scope: !335)
!345 = !DILocation(line: 236, column: 17, scope: !335)
!346 = !DILocation(line: 237, column: 2, scope: !335)
!347 = !DILocation(line: 238, column: 2, scope: !335)
!348 = distinct !DISubprogram(name: "ck_stack_init", scope: !24, file: !24, line: 337, type: !349, scopeLine: 338, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !73, retainedNodes: !151)
!349 = !DISubroutineType(types: !350)
!350 = !{null, !351}
!351 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !100, size: 64)
!352 = !DILocalVariable(name: "stack", arg: 1, scope: !348, file: !24, line: 337, type: !351)
!353 = !DILocation(line: 0, scope: !348)
!354 = !DILocation(line: 340, column: 9, scope: !348)
!355 = !DILocation(line: 340, column: 14, scope: !348)
!356 = !DILocation(line: 341, column: 9, scope: !348)
!357 = !DILocation(line: 341, column: 20, scope: !348)
!358 = !DILocation(line: 342, column: 2, scope: !348)
!359 = distinct !DISubprogram(name: "ck_epoch_recycle", scope: !74, file: !74, line: 242, type: !360, scopeLine: 243, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !151)
!360 = !DISubroutineType(types: !361)
!361 = !{!362, !93, !16}
!362 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !363, size: 64)
!363 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_record_t", file: !19, line: 101, baseType: !83)
!364 = !DILocalVariable(name: "global", arg: 1, scope: !359, file: !74, line: 242, type: !93)
!365 = !DILocation(line: 0, scope: !359)
!366 = !DILocalVariable(name: "ct", arg: 2, scope: !359, file: !74, line: 242, type: !16)
!367 = !DILocation(line: 248, column: 6, scope: !368)
!368 = distinct !DILexicalBlock(scope: !359, file: !74, line: 248, column: 6)
!369 = !DILocation(line: 248, column: 39, scope: !368)
!370 = !DILocation(line: 248, column: 6, scope: !359)
!371 = !DILocation(line: 251, column: 2, scope: !372)
!372 = distinct !DILexicalBlock(scope: !359, file: !74, line: 251, column: 2)
!373 = !DILocalVariable(name: "cursor", scope: !359, file: !74, line: 245, type: !374)
!374 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !86, size: 64)
!375 = !DILocation(line: 0, scope: !372)
!376 = !DILocation(line: 251, column: 2, scope: !377)
!377 = distinct !DILexicalBlock(scope: !372, file: !74, line: 251, column: 2)
!378 = !DILocation(line: 252, column: 12, scope: !379)
!379 = distinct !DILexicalBlock(scope: !377, file: !74, line: 251, column: 45)
!380 = !DILocalVariable(name: "record", scope: !359, file: !74, line: 244, type: !82)
!381 = !DILocation(line: 254, column: 7, scope: !382)
!382 = distinct !DILexicalBlock(scope: !379, file: !74, line: 254, column: 7)
!383 = !DILocation(line: 254, column: 39, scope: !382)
!384 = !DILocation(line: 254, column: 7, scope: !379)
!385 = !DILocation(line: 256, column: 4, scope: !386)
!386 = distinct !DILexicalBlock(scope: !382, file: !74, line: 254, column: 63)
!387 = !DILocation(line: 257, column: 12, scope: !386)
!388 = !DILocalVariable(name: "state", scope: !359, file: !74, line: 246, type: !7)
!389 = !DILocation(line: 259, column: 14, scope: !390)
!390 = distinct !DILexicalBlock(scope: !386, file: !74, line: 259, column: 8)
!391 = !DILocation(line: 259, column: 8, scope: !386)
!392 = !DILocation(line: 260, column: 5, scope: !393)
!393 = distinct !DILexicalBlock(scope: !390, file: !74, line: 259, column: 38)
!394 = !DILocation(line: 261, column: 5, scope: !393)
!395 = !DILocation(line: 267, column: 5, scope: !393)
!396 = distinct !{!396, !371, !397, !398}
!397 = !DILocation(line: 270, column: 2, scope: !372)
!398 = !{!"llvm.loop.mustprogress"}
!399 = !DILocation(line: 273, column: 1, scope: !359)
!400 = distinct !DISubprogram(name: "ck_epoch_record_container", scope: !74, file: !74, line: 145, type: !401, scopeLine: 145, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !73, retainedNodes: !151)
!401 = !DISubroutineType(types: !402)
!402 = !{!82, !374}
!403 = !DILocalVariable(name: "p", arg: 1, scope: !400, file: !74, line: 145, type: !374)
!404 = !DILocation(line: 0, scope: !400)
!405 = !DILocalVariable(name: "n", scope: !400, file: !74, line: 145, type: !374)
!406 = !DILocation(line: 145, column: 1, scope: !400)
!407 = distinct !DISubprogram(name: "ck_epoch_register", scope: !74, file: !74, line: 276, type: !408, scopeLine: 278, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !151)
!408 = !DISubroutineType(types: !409)
!409 = !{null, !93, !82, !16}
!410 = !DILocalVariable(name: "global", arg: 1, scope: !407, file: !74, line: 276, type: !93)
!411 = !DILocation(line: 0, scope: !407)
!412 = !DILocalVariable(name: "record", arg: 2, scope: !407, file: !74, line: 276, type: !82)
!413 = !DILocalVariable(name: "ct", arg: 3, scope: !407, file: !74, line: 277, type: !16)
!414 = !DILocation(line: 281, column: 10, scope: !407)
!415 = !DILocation(line: 281, column: 17, scope: !407)
!416 = !DILocation(line: 282, column: 10, scope: !407)
!417 = !DILocation(line: 282, column: 16, scope: !407)
!418 = !DILocation(line: 283, column: 10, scope: !407)
!419 = !DILocation(line: 283, column: 17, scope: !407)
!420 = !DILocation(line: 284, column: 10, scope: !407)
!421 = !DILocation(line: 284, column: 16, scope: !407)
!422 = !DILocation(line: 285, column: 10, scope: !407)
!423 = !DILocation(line: 285, column: 21, scope: !407)
!424 = !DILocation(line: 286, column: 10, scope: !407)
!425 = !DILocation(line: 286, column: 17, scope: !407)
!426 = !DILocation(line: 287, column: 10, scope: !407)
!427 = !DILocation(line: 287, column: 20, scope: !407)
!428 = !DILocation(line: 288, column: 10, scope: !407)
!429 = !DILocation(line: 288, column: 13, scope: !407)
!430 = !DILocation(line: 289, column: 2, scope: !407)
!431 = !DILocation(line: 290, column: 2, scope: !407)
!432 = !DILocalVariable(name: "i", scope: !407, file: !74, line: 279, type: !122)
!433 = !DILocation(line: 292, column: 26, scope: !434)
!434 = distinct !DILexicalBlock(scope: !435, file: !74, line: 291, column: 2)
!435 = distinct !DILexicalBlock(scope: !407, file: !74, line: 291, column: 2)
!436 = !DILocation(line: 292, column: 18, scope: !434)
!437 = !DILocation(line: 292, column: 3, scope: !434)
!438 = !DILocation(line: 294, column: 2, scope: !407)
!439 = !DILocation(line: 295, column: 30, scope: !407)
!440 = !DILocation(line: 295, column: 48, scope: !407)
!441 = !DILocation(line: 295, column: 2, scope: !407)
!442 = !DILocation(line: 296, column: 2, scope: !407)
!443 = distinct !DISubprogram(name: "ck_stack_push_upmc", scope: !24, file: !24, line: 57, type: !444, scopeLine: 58, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !73, retainedNodes: !151)
!444 = !DISubroutineType(types: !445)
!445 = !{null, !351, !91}
!446 = !DILocalVariable(name: "target", arg: 1, scope: !443, file: !24, line: 57, type: !351)
!447 = !DILocation(line: 0, scope: !443)
!448 = !DILocalVariable(name: "entry", arg: 2, scope: !443, file: !24, line: 57, type: !91)
!449 = !DILocation(line: 61, column: 10, scope: !443)
!450 = !DILocalVariable(name: "stack", scope: !443, file: !24, line: 59, type: !91)
!451 = !DILocation(line: 62, column: 9, scope: !443)
!452 = !DILocation(line: 62, column: 14, scope: !443)
!453 = !DILocation(line: 63, column: 2, scope: !443)
!454 = !DILocation(line: 65, column: 2, scope: !443)
!455 = !DILocation(line: 61, column: 8, scope: !443)
!456 = !DILocation(line: 65, column: 9, scope: !443)
!457 = !DILocation(line: 65, column: 66, scope: !443)
!458 = !DILocation(line: 66, column: 15, scope: !459)
!459 = distinct !DILexicalBlock(scope: !443, file: !24, line: 65, column: 76)
!460 = !DILocation(line: 67, column: 3, scope: !459)
!461 = distinct !{!461, !454, !462, !398}
!462 = !DILocation(line: 68, column: 2, scope: !443)
!463 = !DILocation(line: 70, column: 2, scope: !443)
!464 = distinct !DISubprogram(name: "ck_epoch_unregister", scope: !74, file: !74, line: 300, type: !465, scopeLine: 301, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !151)
!465 = !DISubroutineType(types: !466)
!466 = !{null, !82}
!467 = !DILocalVariable(name: "record", arg: 1, scope: !464, file: !74, line: 300, type: !82)
!468 = !DILocation(line: 0, scope: !464)
!469 = !DILocation(line: 302, column: 36, scope: !464)
!470 = !DILocalVariable(name: "global", scope: !464, file: !74, line: 302, type: !93)
!471 = !DILocation(line: 305, column: 10, scope: !464)
!472 = !DILocation(line: 305, column: 17, scope: !464)
!473 = !DILocation(line: 306, column: 10, scope: !464)
!474 = !DILocation(line: 306, column: 16, scope: !464)
!475 = !DILocation(line: 307, column: 10, scope: !464)
!476 = !DILocation(line: 307, column: 21, scope: !464)
!477 = !DILocation(line: 308, column: 10, scope: !464)
!478 = !DILocation(line: 308, column: 17, scope: !464)
!479 = !DILocation(line: 309, column: 10, scope: !464)
!480 = !DILocation(line: 309, column: 20, scope: !464)
!481 = !DILocation(line: 310, column: 2, scope: !464)
!482 = !DILocalVariable(name: "i", scope: !464, file: !74, line: 303, type: !122)
!483 = !DILocation(line: 313, column: 26, scope: !484)
!484 = distinct !DILexicalBlock(scope: !485, file: !74, line: 312, column: 2)
!485 = distinct !DILexicalBlock(scope: !464, file: !74, line: 312, column: 2)
!486 = !DILocation(line: 313, column: 18, scope: !484)
!487 = !DILocation(line: 313, column: 3, scope: !484)
!488 = !DILocation(line: 315, column: 2, scope: !464)
!489 = !DILocation(line: 316, column: 2, scope: !464)
!490 = !DILocation(line: 317, column: 2, scope: !464)
!491 = !DILocation(line: 318, column: 2, scope: !464)
!492 = !DILocation(line: 319, column: 2, scope: !464)
!493 = distinct !DISubprogram(name: "ck_epoch_reclaim", scope: !74, file: !74, line: 412, type: !465, scopeLine: 413, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !151)
!494 = !DILocalVariable(name: "record", arg: 1, scope: !493, file: !74, line: 412, type: !82)
!495 = !DILocation(line: 0, scope: !493)
!496 = !DILocalVariable(name: "epoch", scope: !493, file: !74, line: 414, type: !7)
!497 = !DILocation(line: 417, column: 3, scope: !498)
!498 = distinct !DILexicalBlock(scope: !499, file: !74, line: 416, column: 2)
!499 = distinct !DILexicalBlock(scope: !493, file: !74, line: 416, column: 2)
!500 = !DILocation(line: 419, column: 2, scope: !493)
!501 = distinct !DISubprogram(name: "ck_epoch_dispatch", scope: !74, file: !74, line: 371, type: !502, scopeLine: 372, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !73, retainedNodes: !151)
!502 = !DISubroutineType(types: !503)
!503 = !{!7, !82, !7, !504}
!504 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !99, size: 64)
!505 = !DILocalVariable(name: "record", arg: 1, scope: !501, file: !74, line: 371, type: !82)
!506 = !DILocation(line: 0, scope: !501)
!507 = !DILocalVariable(name: "e", arg: 2, scope: !501, file: !74, line: 371, type: !7)
!508 = !DILocalVariable(name: "deferred", arg: 3, scope: !501, file: !74, line: 371, type: !504)
!509 = !DILocation(line: 373, column: 25, scope: !501)
!510 = !DILocalVariable(name: "epoch", scope: !501, file: !74, line: 373, type: !7)
!511 = !DILocalVariable(name: "i", scope: !501, file: !74, line: 376, type: !7)
!512 = !DILocation(line: 378, column: 42, scope: !501)
!513 = !DILocation(line: 378, column: 34, scope: !501)
!514 = !DILocation(line: 378, column: 9, scope: !501)
!515 = !DILocalVariable(name: "head", scope: !501, file: !74, line: 374, type: !374)
!516 = !DILocation(line: 379, column: 2, scope: !501)
!517 = !DILocalVariable(name: "cursor", scope: !501, file: !74, line: 374, type: !374)
!518 = !DILocation(line: 380, column: 7, scope: !519)
!519 = distinct !DILexicalBlock(scope: !501, file: !74, line: 380, column: 2)
!520 = !DILocation(line: 0, scope: !519)
!521 = !DILocation(line: 380, column: 29, scope: !522)
!522 = distinct !DILexicalBlock(scope: !519, file: !74, line: 380, column: 2)
!523 = !DILocation(line: 380, column: 2, scope: !519)
!524 = !DILocation(line: 382, column: 7, scope: !525)
!525 = distinct !DILexicalBlock(scope: !522, file: !74, line: 380, column: 53)
!526 = !DILocalVariable(name: "entry", scope: !525, file: !74, line: 381, type: !125)
!527 = !DILocation(line: 0, scope: !525)
!528 = !DILocation(line: 384, column: 10, scope: !525)
!529 = !DILocalVariable(name: "next", scope: !501, file: !74, line: 374, type: !374)
!530 = !DILocation(line: 385, column: 16, scope: !531)
!531 = distinct !DILexicalBlock(scope: !525, file: !74, line: 385, column: 7)
!532 = !DILocation(line: 385, column: 7, scope: !525)
!533 = !DILocation(line: 386, column: 41, scope: !531)
!534 = !DILocation(line: 386, column: 4, scope: !531)
!535 = !DILocation(line: 388, column: 11, scope: !531)
!536 = !DILocation(line: 388, column: 4, scope: !531)
!537 = !DILocation(line: 390, column: 4, scope: !525)
!538 = !DILocation(line: 380, column: 2, scope: !522)
!539 = distinct !{!539, !523, !540, !398}
!540 = !DILocation(line: 391, column: 2, scope: !519)
!541 = !DILocation(line: 393, column: 11, scope: !501)
!542 = !DILocalVariable(name: "n_peak", scope: !501, file: !74, line: 375, type: !7)
!543 = !DILocation(line: 394, column: 14, scope: !501)
!544 = !DILocalVariable(name: "n_pending", scope: !501, file: !74, line: 375, type: !7)
!545 = !DILocation(line: 397, column: 16, scope: !546)
!546 = distinct !DILexicalBlock(scope: !501, file: !74, line: 397, column: 6)
!547 = !DILocation(line: 397, column: 6, scope: !501)
!548 = !DILocation(line: 398, column: 3, scope: !546)
!549 = !DILocation(line: 400, column: 8, scope: !550)
!550 = distinct !DILexicalBlock(scope: !501, file: !74, line: 400, column: 6)
!551 = !DILocation(line: 400, column: 6, scope: !501)
!552 = !DILocation(line: 401, column: 3, scope: !553)
!553 = distinct !DILexicalBlock(scope: !550, file: !74, line: 400, column: 13)
!554 = !DILocation(line: 402, column: 3, scope: !553)
!555 = !DILocation(line: 403, column: 2, scope: !553)
!556 = !DILocation(line: 405, column: 2, scope: !501)
!557 = distinct !DISubprogram(name: "ck_stack_batch_pop_upmc", scope: !24, file: !24, line: 154, type: !558, scopeLine: 155, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !73, retainedNodes: !151)
!558 = !DISubroutineType(types: !559)
!559 = !{!91, !351}
!560 = !DILocalVariable(name: "target", arg: 1, scope: !557, file: !24, line: 154, type: !351)
!561 = !DILocation(line: 0, scope: !557)
!562 = !DILocation(line: 158, column: 10, scope: !557)
!563 = !DILocalVariable(name: "entry", scope: !557, file: !24, line: 156, type: !91)
!564 = !DILocation(line: 159, column: 2, scope: !557)
!565 = !DILocation(line: 160, column: 2, scope: !557)
!566 = distinct !DISubprogram(name: "ck_epoch_entry_container", scope: !74, file: !74, line: 147, type: !567, scopeLine: 147, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !73, retainedNodes: !151)
!567 = !DISubroutineType(types: !568)
!568 = !{!125, !374}
!569 = !DILocalVariable(name: "p", arg: 1, scope: !566, file: !74, line: 147, type: !374)
!570 = !DILocation(line: 0, scope: !566)
!571 = !DILocalVariable(name: "n", scope: !566, file: !74, line: 147, type: !374)
!572 = !DILocation(line: 147, column: 1, scope: !566)
!573 = distinct !DISubprogram(name: "ck_stack_push_spnc", scope: !24, file: !24, line: 294, type: !444, scopeLine: 295, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !73, retainedNodes: !151)
!574 = !DILocalVariable(name: "target", arg: 1, scope: !573, file: !24, line: 294, type: !351)
!575 = !DILocation(line: 0, scope: !573)
!576 = !DILocalVariable(name: "entry", arg: 2, scope: !573, file: !24, line: 294, type: !91)
!577 = !DILocation(line: 297, column: 24, scope: !573)
!578 = !DILocation(line: 297, column: 9, scope: !573)
!579 = !DILocation(line: 297, column: 14, scope: !573)
!580 = !DILocation(line: 298, column: 15, scope: !573)
!581 = !DILocation(line: 299, column: 2, scope: !573)
!582 = distinct !DISubprogram(name: "ck_epoch_synchronize_wait", scope: !74, file: !74, line: 437, type: !583, scopeLine: 439, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !151)
!583 = !DISubroutineType(types: !584)
!584 = !{null, !93, !585, !16}
!585 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !586, size: 64)
!586 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_wait_cb_t", file: !19, line: 235, baseType: !587)
!587 = !DISubroutineType(types: !588)
!588 = !{null, !589, !362, !16}
!589 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !590, size: 64)
!590 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_t", file: !19, line: 108, baseType: !94)
!591 = !DILocalVariable(name: "global", arg: 1, scope: !582, file: !74, line: 437, type: !93)
!592 = !DILocation(line: 0, scope: !582)
!593 = !DILocalVariable(name: "cb", arg: 2, scope: !582, file: !74, line: 438, type: !585)
!594 = !DILocalVariable(name: "ct", arg: 3, scope: !582, file: !74, line: 438, type: !16)
!595 = !DILocalVariable(name: "active", scope: !582, file: !74, line: 442, type: !243)
!596 = !DILocation(line: 442, column: 7, scope: !582)
!597 = !DILocation(line: 444, column: 2, scope: !582)
!598 = !DILocation(line: 455, column: 18, scope: !582)
!599 = !DILocalVariable(name: "epoch", scope: !582, file: !74, line: 441, type: !7)
!600 = !DILocalVariable(name: "delta", scope: !582, file: !74, line: 441, type: !7)
!601 = !DILocation(line: 456, column: 15, scope: !582)
!602 = !DILocalVariable(name: "goal", scope: !582, file: !74, line: 441, type: !7)
!603 = !DILocalVariable(name: "i", scope: !582, file: !74, line: 441, type: !7)
!604 = !DILocalVariable(name: "cr", scope: !582, file: !74, line: 440, type: !82)
!605 = !DILocation(line: 465, column: 3, scope: !606)
!606 = distinct !DILexicalBlock(scope: !607, file: !74, line: 458, column: 65)
!607 = distinct !DILexicalBlock(scope: !608, file: !74, line: 458, column: 2)
!608 = distinct !DILexicalBlock(scope: !582, file: !74, line: 458, column: 2)
!609 = !DILocation(line: 0, scope: !608)
!610 = !DILocation(line: 465, column: 15, scope: !606)
!611 = !DILocation(line: 466, column: 10, scope: !606)
!612 = !DILocation(line: 475, column: 10, scope: !613)
!613 = distinct !DILexicalBlock(scope: !606, file: !74, line: 466, column: 19)
!614 = !DILocalVariable(name: "e_d", scope: !613, file: !74, line: 467, type: !7)
!615 = !DILocation(line: 0, scope: !613)
!616 = !DILocation(line: 476, column: 12, scope: !617)
!617 = distinct !DILexicalBlock(scope: !613, file: !74, line: 476, column: 8)
!618 = !DILocation(line: 476, column: 8, scope: !613)
!619 = !DILocation(line: 477, column: 5, scope: !620)
!620 = distinct !DILexicalBlock(scope: !617, file: !74, line: 476, column: 22)
!621 = !DILocation(line: 478, column: 5, scope: !620)
!622 = distinct !{!622, !605, !623, !398}
!623 = !DILocation(line: 497, column: 3, scope: !606)
!624 = !DILocation(line: 486, column: 14, scope: !625)
!625 = distinct !DILexicalBlock(scope: !613, file: !74, line: 486, column: 8)
!626 = !DILocation(line: 486, column: 32, scope: !625)
!627 = !DILocation(line: 486, column: 23, scope: !625)
!628 = !DILocation(line: 486, column: 8, scope: !613)
!629 = !DILocation(line: 489, column: 4, scope: !613)
!630 = !DILocation(line: 503, column: 7, scope: !631)
!631 = distinct !DILexicalBlock(scope: !606, file: !74, line: 503, column: 7)
!632 = !DILocation(line: 503, column: 14, scope: !631)
!633 = !DILocation(line: 503, column: 7, scope: !606)
!634 = !DILocation(line: 517, column: 7, scope: !606)
!635 = !DILocalVariable(name: "r", scope: !606, file: !74, line: 459, type: !243)
!636 = !DILocation(line: 0, scope: !606)
!637 = !DILocation(line: 521, column: 3, scope: !606)
!638 = !DILocation(line: 527, column: 19, scope: !606)
!639 = !DILocation(line: 527, column: 17, scope: !606)
!640 = !DILocation(line: 528, column: 2, scope: !608)
!641 = !DILocation(line: 536, column: 2, scope: !582)
!642 = !DILabel(scope: !582, name: "leave", file: !74, line: 535)
!643 = !DILocation(line: 535, column: 1, scope: !582)
!644 = !DILocation(line: 537, column: 2, scope: !582)
!645 = distinct !DISubprogram(name: "ck_epoch_scan", scope: !74, file: !74, line: 323, type: !646, scopeLine: 327, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !73, retainedNodes: !151)
!646 = !DISubroutineType(types: !647)
!647 = !{!82, !93, !82, !7, !648}
!648 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !243, size: 64)
!649 = !DILocalVariable(name: "global", arg: 1, scope: !645, file: !74, line: 323, type: !93)
!650 = !DILocation(line: 0, scope: !645)
!651 = !DILocalVariable(name: "cr", arg: 2, scope: !645, file: !74, line: 324, type: !82)
!652 = !DILocalVariable(name: "epoch", arg: 3, scope: !645, file: !74, line: 325, type: !7)
!653 = !DILocalVariable(name: "af", arg: 4, scope: !645, file: !74, line: 326, type: !648)
!654 = !DILocation(line: 330, column: 9, scope: !655)
!655 = distinct !DILexicalBlock(scope: !645, file: !74, line: 330, column: 6)
!656 = !DILocation(line: 330, column: 6, scope: !645)
!657 = !DILocation(line: 331, column: 12, scope: !658)
!658 = distinct !DILexicalBlock(scope: !655, file: !74, line: 330, column: 18)
!659 = !DILocalVariable(name: "cursor", scope: !645, file: !74, line: 328, type: !374)
!660 = !DILocation(line: 337, column: 7, scope: !658)
!661 = !DILocation(line: 338, column: 2, scope: !658)
!662 = !DILocation(line: 339, column: 17, scope: !663)
!663 = distinct !DILexicalBlock(scope: !655, file: !74, line: 338, column: 9)
!664 = !DILocation(line: 340, column: 7, scope: !663)
!665 = !DILocation(line: 0, scope: !655)
!666 = !DILocation(line: 343, column: 2, scope: !645)
!667 = !DILocation(line: 344, column: 2, scope: !645)
!668 = !DILocation(line: 344, column: 16, scope: !645)
!669 = !DILocation(line: 347, column: 8, scope: !670)
!670 = distinct !DILexicalBlock(scope: !645, file: !74, line: 344, column: 25)
!671 = !DILocation(line: 349, column: 11, scope: !670)
!672 = !DILocalVariable(name: "state", scope: !670, file: !74, line: 345, type: !7)
!673 = !DILocation(line: 0, scope: !670)
!674 = !DILocation(line: 350, column: 13, scope: !675)
!675 = distinct !DILexicalBlock(scope: !670, file: !74, line: 350, column: 7)
!676 = !DILocation(line: 350, column: 7, scope: !670)
!677 = !DILocation(line: 351, column: 13, scope: !678)
!678 = distinct !DILexicalBlock(scope: !675, file: !74, line: 350, column: 36)
!679 = !DILocation(line: 352, column: 4, scope: !678)
!680 = distinct !{!680, !667, !681, !398}
!681 = !DILocation(line: 365, column: 2, scope: !645)
!682 = !DILocation(line: 355, column: 12, scope: !670)
!683 = !DILocalVariable(name: "active", scope: !670, file: !74, line: 345, type: !7)
!684 = !DILocation(line: 356, column: 7, scope: !670)
!685 = !DILocation(line: 358, column: 14, scope: !686)
!686 = distinct !DILexicalBlock(scope: !670, file: !74, line: 358, column: 7)
!687 = !DILocation(line: 358, column: 19, scope: !686)
!688 = !DILocation(line: 358, column: 22, scope: !686)
!689 = !DILocation(line: 358, column: 50, scope: !686)
!690 = !DILocation(line: 358, column: 7, scope: !670)
!691 = !DILocation(line: 361, column: 12, scope: !670)
!692 = !DILocation(line: 368, column: 1, scope: !645)
!693 = distinct !DISubprogram(name: "epoch_block", scope: !74, file: !74, line: 423, type: !694, scopeLine: 425, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !73, retainedNodes: !151)
!694 = !DISubroutineType(types: !695)
!695 = !{null, !93, !82, !585, !16}
!696 = !DILocalVariable(name: "global", arg: 1, scope: !693, file: !74, line: 423, type: !93)
!697 = !DILocation(line: 0, scope: !693)
!698 = !DILocalVariable(name: "cr", arg: 2, scope: !693, file: !74, line: 423, type: !82)
!699 = !DILocalVariable(name: "cb", arg: 3, scope: !693, file: !74, line: 424, type: !585)
!700 = !DILocalVariable(name: "ct", arg: 4, scope: !693, file: !74, line: 424, type: !16)
!701 = !DILocation(line: 427, column: 9, scope: !702)
!702 = distinct !DILexicalBlock(scope: !693, file: !74, line: 427, column: 6)
!703 = !DILocation(line: 427, column: 6, scope: !693)
!704 = !DILocation(line: 428, column: 3, scope: !702)
!705 = !DILocation(line: 430, column: 2, scope: !693)
!706 = distinct !DISubprogram(name: "ck_epoch_synchronize", scope: !74, file: !74, line: 541, type: !465, scopeLine: 542, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !151)
!707 = !DILocalVariable(name: "record", arg: 1, scope: !706, file: !74, line: 541, type: !82)
!708 = !DILocation(line: 0, scope: !706)
!709 = !DILocation(line: 544, column: 36, scope: !706)
!710 = !DILocation(line: 544, column: 2, scope: !706)
!711 = !DILocation(line: 545, column: 2, scope: !706)
!712 = distinct !DISubprogram(name: "ck_epoch_barrier", scope: !74, file: !74, line: 549, type: !465, scopeLine: 550, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !151)
!713 = !DILocalVariable(name: "record", arg: 1, scope: !712, file: !74, line: 549, type: !82)
!714 = !DILocation(line: 0, scope: !712)
!715 = !DILocation(line: 552, column: 2, scope: !712)
!716 = !DILocation(line: 553, column: 2, scope: !712)
!717 = !DILocation(line: 554, column: 2, scope: !712)
!718 = distinct !DISubprogram(name: "ck_epoch_barrier_wait", scope: !74, file: !74, line: 558, type: !719, scopeLine: 560, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !151)
!719 = !DISubroutineType(types: !720)
!720 = !{null, !82, !585, !16}
!721 = !DILocalVariable(name: "record", arg: 1, scope: !718, file: !74, line: 558, type: !82)
!722 = !DILocation(line: 0, scope: !718)
!723 = !DILocalVariable(name: "cb", arg: 2, scope: !718, file: !74, line: 558, type: !585)
!724 = !DILocalVariable(name: "ct", arg: 3, scope: !718, file: !74, line: 559, type: !16)
!725 = !DILocation(line: 562, column: 36, scope: !718)
!726 = !DILocation(line: 562, column: 2, scope: !718)
!727 = !DILocation(line: 563, column: 2, scope: !718)
!728 = !DILocation(line: 564, column: 2, scope: !718)
!729 = distinct !DISubprogram(name: "ck_epoch_poll_deferred", scope: !74, file: !74, line: 578, type: !730, scopeLine: 579, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !151)
!730 = !DISubroutineType(types: !731)
!731 = !{!243, !82, !504}
!732 = !DILocalVariable(name: "record", arg: 1, scope: !729, file: !74, line: 578, type: !82)
!733 = !DILocation(line: 0, scope: !729)
!734 = !DILocalVariable(name: "deferred", arg: 2, scope: !729, file: !74, line: 578, type: !504)
!735 = !DILocalVariable(name: "active", scope: !729, file: !74, line: 583, type: !243)
!736 = !DILocation(line: 583, column: 7, scope: !729)
!737 = !DILocalVariable(name: "cr", scope: !729, file: !74, line: 585, type: !82)
!738 = !DILocation(line: 586, column: 36, scope: !729)
!739 = !DILocalVariable(name: "global", scope: !729, file: !74, line: 586, type: !93)
!740 = !DILocalVariable(name: "n_dispatch", scope: !729, file: !74, line: 587, type: !7)
!741 = !DILocation(line: 589, column: 10, scope: !729)
!742 = !DILocalVariable(name: "epoch", scope: !729, file: !74, line: 584, type: !7)
!743 = !DILocation(line: 592, column: 2, scope: !729)
!744 = !DILocation(line: 606, column: 7, scope: !729)
!745 = !DILocation(line: 607, column: 9, scope: !746)
!746 = distinct !DILexicalBlock(scope: !729, file: !74, line: 607, column: 6)
!747 = !DILocation(line: 607, column: 6, scope: !729)
!748 = !DILocation(line: 611, column: 6, scope: !749)
!749 = distinct !DILexicalBlock(scope: !729, file: !74, line: 611, column: 6)
!750 = !DILocation(line: 611, column: 13, scope: !749)
!751 = !DILocation(line: 611, column: 6, scope: !729)
!752 = !DILocation(line: 612, column: 3, scope: !753)
!753 = distinct !DILexicalBlock(scope: !749, file: !74, line: 611, column: 23)
!754 = !DILocation(line: 617, column: 3, scope: !753)
!755 = !DILocalVariable(name: "A", scope: !756, file: !74, line: 628, type: !7)
!756 = distinct !DILexicalBlock(scope: !729, file: !74, line: 628, column: 8)
!757 = !DILocation(line: 0, scope: !756)
!758 = !DILocation(line: 628, column: 8, scope: !756)
!759 = !DILocation(line: 631, column: 2, scope: !729)
!760 = !DILocation(line: 632, column: 1, scope: !729)
!761 = distinct !DISubprogram(name: "ck_epoch_poll", scope: !74, file: !74, line: 635, type: !762, scopeLine: 636, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !151)
!762 = !DISubroutineType(types: !763)
!763 = !{!243, !82}
!764 = !DILocalVariable(name: "record", arg: 1, scope: !761, file: !74, line: 635, type: !82)
!765 = !DILocation(line: 0, scope: !761)
!766 = !DILocation(line: 638, column: 9, scope: !761)
!767 = !DILocation(line: 638, column: 2, scope: !761)
