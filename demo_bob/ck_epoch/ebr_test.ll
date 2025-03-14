; ModuleID = 'llvm-link'
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
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca [4 x %struct._opaque_pthread_t*], align 8
  %7 = alloca i32, align 4
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !152, metadata !DIExpression()), !dbg !153
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !154, metadata !DIExpression()), !dbg !155
  call void @llvm.dbg.declare(metadata [4 x %struct._opaque_pthread_t*]* %6, metadata !156, metadata !DIExpression()), !dbg !181
  call void @ck_epoch_init(%struct.ck_epoch* noundef @stack_epoch), !dbg !182
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !183
  call void @llvm.dbg.declare(metadata i32* %7, metadata !184, metadata !DIExpression()), !dbg !186
  store i32 0, i32* %7, align 4, !dbg !186
  br label %8, !dbg !187

8:                                                ; preds = %23, %2
  %9 = load i32, i32* %7, align 4, !dbg !188
  %10 = icmp slt i32 %9, 4, !dbg !190
  br i1 %10, label %11, label %26, !dbg !191

11:                                               ; preds = %8
  %12 = load i32, i32* %7, align 4, !dbg !192
  %13 = sext i32 %12 to i64, !dbg !194
  %14 = getelementptr inbounds [4 x %struct.ck_epoch_record], [4 x %struct.ck_epoch_record]* @records, i64 0, i64 %13, !dbg !194
  call void @ck_epoch_register(%struct.ck_epoch* noundef @stack_epoch, %struct.ck_epoch_record* noundef %14, i8* noundef null), !dbg !195
  %15 = load i32, i32* %7, align 4, !dbg !196
  %16 = sext i32 %15 to i64, !dbg !197
  %17 = getelementptr inbounds [4 x %struct._opaque_pthread_t*], [4 x %struct._opaque_pthread_t*]* %6, i64 0, i64 %16, !dbg !197
  %18 = load i32, i32* %7, align 4, !dbg !198
  %19 = sext i32 %18 to i64, !dbg !199
  %20 = getelementptr inbounds [4 x %struct.ck_epoch_record], [4 x %struct.ck_epoch_record]* @records, i64 0, i64 %19, !dbg !199
  %21 = bitcast %struct.ck_epoch_record* %20 to i8*, !dbg !200
  %22 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %17, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread, i8* noundef %21), !dbg !201
  br label %23, !dbg !202

23:                                               ; preds = %11
  %24 = load i32, i32* %7, align 4, !dbg !203
  %25 = add nsw i32 %24, 1, !dbg !203
  store i32 %25, i32* %7, align 4, !dbg !203
  br label %8, !dbg !204, !llvm.loop !205

26:                                               ; preds = %8
  ret i32 0, !dbg !208
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__VERIFIER_loop_bound(i32 noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define internal i8* @thread(i8* noundef %0) #0 !dbg !209 {
  %2 = alloca i8*, align 8
  %3 = alloca %struct.ck_epoch_record*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !212, metadata !DIExpression()), !dbg !213
  call void @llvm.dbg.declare(metadata %struct.ck_epoch_record** %3, metadata !214, metadata !DIExpression()), !dbg !215
  %8 = load i8*, i8** %2, align 8, !dbg !216
  %9 = bitcast i8* %8 to %struct.ck_epoch_record*, !dbg !217
  store %struct.ck_epoch_record* %9, %struct.ck_epoch_record** %3, align 8, !dbg !215
  %10 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %3, align 8, !dbg !218
  call void @ck_epoch_begin(%struct.ck_epoch_record* noundef %10, %struct.ck_epoch_section* noundef null), !dbg !219
  call void @llvm.dbg.declare(metadata i32* %4, metadata !220, metadata !DIExpression()), !dbg !221
  %11 = load atomic i32, i32* getelementptr inbounds (%struct.ck_epoch, %struct.ck_epoch* @stack_epoch, i32 0, i32 0) monotonic, align 8, !dbg !222
  store i32 %11, i32* %5, align 4, !dbg !222
  %12 = load i32, i32* %5, align 4, !dbg !222
  store i32 %12, i32* %4, align 4, !dbg !221
  call void @llvm.dbg.declare(metadata i32* %6, metadata !223, metadata !DIExpression()), !dbg !224
  %13 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %3, align 8, !dbg !225
  %14 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %13, i32 0, i32 3, !dbg !225
  %15 = load atomic i32, i32* %14 monotonic, align 4, !dbg !225
  store i32 %15, i32* %7, align 4, !dbg !225
  %16 = load i32, i32* %7, align 4, !dbg !225
  store i32 %16, i32* %6, align 4, !dbg !224
  %17 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %3, align 8, !dbg !226
  %18 = call zeroext i1 @ck_epoch_end(%struct.ck_epoch_record* noundef %17, %struct.ck_epoch_section* noundef null), !dbg !227
  %19 = load i32, i32* %4, align 4, !dbg !228
  %20 = load i32, i32* %6, align 4, !dbg !228
  %21 = sub nsw i32 %19, %20, !dbg !228
  %22 = icmp sle i32 %21, 1, !dbg !228
  %23 = xor i1 %22, true, !dbg !228
  %24 = zext i1 %23 to i32, !dbg !228
  %25 = sext i32 %24 to i64, !dbg !228
  %26 = icmp ne i64 %25, 0, !dbg !228
  br i1 %26, label %27, label %29, !dbg !228

27:                                               ; preds = %1
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @__func__.thread, i64 0, i64 0), i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @.str, i64 0, i64 0), i32 noundef 25, i8* noundef getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1, i64 0, i64 0)) #5, !dbg !228
  unreachable, !dbg !228

28:                                               ; No predecessors!
  br label %30, !dbg !228

29:                                               ; preds = %1
  br label %30, !dbg !228

30:                                               ; preds = %29, %28
  %31 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %3, align 8, !dbg !229
  %32 = call zeroext i1 @ck_epoch_poll(%struct.ck_epoch_record* noundef %31), !dbg !230
  ret i8* null, !dbg !231
}

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define internal void @ck_epoch_begin(%struct.ck_epoch_record* noundef %0, %struct.ck_epoch_section* noundef %1) #0 !dbg !232 {
  %3 = alloca %struct.ck_epoch_record*, align 8
  %4 = alloca %struct.ck_epoch_section*, align 8
  %5 = alloca %struct.ck_epoch*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  store %struct.ck_epoch_record* %0, %struct.ck_epoch_record** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_epoch_record** %3, metadata !240, metadata !DIExpression()), !dbg !241
  store %struct.ck_epoch_section* %1, %struct.ck_epoch_section** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_epoch_section** %4, metadata !242, metadata !DIExpression()), !dbg !243
  call void @llvm.dbg.declare(metadata %struct.ck_epoch** %5, metadata !244, metadata !DIExpression()), !dbg !245
  %13 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %3, align 8, !dbg !246
  %14 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %13, i32 0, i32 1, !dbg !247
  %15 = load %struct.ck_epoch*, %struct.ck_epoch** %14, align 8, !dbg !247
  store %struct.ck_epoch* %15, %struct.ck_epoch** %5, align 8, !dbg !245
  %16 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %3, align 8, !dbg !248
  %17 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %16, i32 0, i32 4, !dbg !248
  %18 = load atomic i32, i32* %17 monotonic, align 8, !dbg !248
  store i32 %18, i32* %6, align 4, !dbg !248
  %19 = load i32, i32* %6, align 4, !dbg !248
  %20 = icmp eq i32 %19, 0, !dbg !250
  br i1 %20, label %21, label %33, !dbg !251

21:                                               ; preds = %2
  call void @llvm.dbg.declare(metadata i32* %7, metadata !252, metadata !DIExpression()), !dbg !254
  %22 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %3, align 8, !dbg !255
  %23 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %22, i32 0, i32 4, !dbg !255
  store i32 1, i32* %8, align 4, !dbg !255
  %24 = load i32, i32* %8, align 4, !dbg !255
  store atomic i32 %24, i32* %23 monotonic, align 8, !dbg !255
  fence seq_cst, !dbg !256
  %25 = load %struct.ck_epoch*, %struct.ck_epoch** %5, align 8, !dbg !257
  %26 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %25, i32 0, i32 0, !dbg !257
  %27 = load atomic i32, i32* %26 monotonic, align 8, !dbg !257
  store i32 %27, i32* %9, align 4, !dbg !257
  %28 = load i32, i32* %9, align 4, !dbg !257
  store i32 %28, i32* %7, align 4, !dbg !258
  %29 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %3, align 8, !dbg !259
  %30 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %29, i32 0, i32 3, !dbg !259
  %31 = load i32, i32* %7, align 4, !dbg !259
  store i32 %31, i32* %10, align 4, !dbg !259
  %32 = load i32, i32* %10, align 4, !dbg !259
  store atomic i32 %32, i32* %30 monotonic, align 4, !dbg !259
  br label %42, !dbg !260

33:                                               ; preds = %2
  %34 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %3, align 8, !dbg !261
  %35 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %34, i32 0, i32 4, !dbg !261
  %36 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %3, align 8, !dbg !261
  %37 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %36, i32 0, i32 4, !dbg !261
  %38 = load atomic i32, i32* %37 monotonic, align 8, !dbg !261
  store i32 %38, i32* %12, align 4, !dbg !261
  %39 = load i32, i32* %12, align 4, !dbg !261
  %40 = add i32 %39, 1, !dbg !261
  store i32 %40, i32* %11, align 4, !dbg !261
  %41 = load i32, i32* %11, align 4, !dbg !261
  store atomic i32 %41, i32* %35 monotonic, align 8, !dbg !261
  br label %42

42:                                               ; preds = %33, %21
  %43 = load %struct.ck_epoch_section*, %struct.ck_epoch_section** %4, align 8, !dbg !263
  %44 = icmp ne %struct.ck_epoch_section* %43, null, !dbg !265
  br i1 %44, label %45, label %48, !dbg !266

45:                                               ; preds = %42
  %46 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %3, align 8, !dbg !267
  %47 = load %struct.ck_epoch_section*, %struct.ck_epoch_section** %4, align 8, !dbg !268
  call void @_ck_epoch_addref(%struct.ck_epoch_record* noundef %46, %struct.ck_epoch_section* noundef %47), !dbg !269
  br label %48, !dbg !269

48:                                               ; preds = %45, %42
  ret void, !dbg !270
}

; Function Attrs: noinline nounwind ssp uwtable
define internal zeroext i1 @ck_epoch_end(%struct.ck_epoch_record* noundef %0, %struct.ck_epoch_section* noundef %1) #0 !dbg !271 {
  %3 = alloca i1, align 1
  %4 = alloca %struct.ck_epoch_record*, align 8
  %5 = alloca %struct.ck_epoch_section*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %struct.ck_epoch_record* %0, %struct.ck_epoch_record** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_epoch_record** %4, metadata !275, metadata !DIExpression()), !dbg !276
  store %struct.ck_epoch_section* %1, %struct.ck_epoch_section** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_epoch_section** %5, metadata !277, metadata !DIExpression()), !dbg !278
  fence release, !dbg !279
  %9 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %4, align 8, !dbg !280
  %10 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %9, i32 0, i32 4, !dbg !280
  %11 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %4, align 8, !dbg !280
  %12 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %11, i32 0, i32 4, !dbg !280
  %13 = load atomic i32, i32* %12 monotonic, align 8, !dbg !280
  store i32 %13, i32* %7, align 4, !dbg !280
  %14 = load i32, i32* %7, align 4, !dbg !280
  %15 = sub i32 %14, 1, !dbg !280
  store i32 %15, i32* %6, align 4, !dbg !280
  %16 = load i32, i32* %6, align 4, !dbg !280
  store atomic i32 %16, i32* %10 monotonic, align 8, !dbg !280
  %17 = load %struct.ck_epoch_section*, %struct.ck_epoch_section** %5, align 8, !dbg !281
  %18 = icmp ne %struct.ck_epoch_section* %17, null, !dbg !283
  br i1 %18, label %19, label %23, !dbg !284

19:                                               ; preds = %2
  %20 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %4, align 8, !dbg !285
  %21 = load %struct.ck_epoch_section*, %struct.ck_epoch_section** %5, align 8, !dbg !286
  %22 = call zeroext i1 @_ck_epoch_delref(%struct.ck_epoch_record* noundef %20, %struct.ck_epoch_section* noundef %21), !dbg !287
  store i1 %22, i1* %3, align 1, !dbg !288
  br label %29, !dbg !288

23:                                               ; preds = %2
  %24 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %4, align 8, !dbg !289
  %25 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %24, i32 0, i32 4, !dbg !289
  %26 = load atomic i32, i32* %25 monotonic, align 8, !dbg !289
  store i32 %26, i32* %8, align 4, !dbg !289
  %27 = load i32, i32* %8, align 4, !dbg !289
  %28 = icmp eq i32 %27, 0, !dbg !290
  store i1 %28, i1* %3, align 1, !dbg !291
  br label %29, !dbg !291

29:                                               ; preds = %23, %19
  %30 = load i1, i1* %3, align 1, !dbg !292
  ret i1 %30, !dbg !292
}

; Function Attrs: cold noreturn
declare void @__assert_rtn(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind ssp uwtable
define zeroext i1 @_ck_epoch_delref(%struct.ck_epoch_record* noundef %0, %struct.ck_epoch_section* noundef %1) #0 !dbg !293 {
  %3 = alloca i1, align 1
  %4 = alloca %struct.ck_epoch_record*, align 8
  %5 = alloca %struct.ck_epoch_section*, align 8
  %6 = alloca %struct.ck_epoch_ref*, align 8
  %7 = alloca %struct.ck_epoch_ref*, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  store %struct.ck_epoch_record* %0, %struct.ck_epoch_record** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_epoch_record** %4, metadata !300, metadata !DIExpression()), !dbg !301
  store %struct.ck_epoch_section* %1, %struct.ck_epoch_section** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_epoch_section** %5, metadata !302, metadata !DIExpression()), !dbg !303
  call void @llvm.dbg.declare(metadata %struct.ck_epoch_ref** %6, metadata !304, metadata !DIExpression()), !dbg !306
  call void @llvm.dbg.declare(metadata %struct.ck_epoch_ref** %7, metadata !307, metadata !DIExpression()), !dbg !308
  call void @llvm.dbg.declare(metadata i32* %8, metadata !309, metadata !DIExpression()), !dbg !310
  %10 = load %struct.ck_epoch_section*, %struct.ck_epoch_section** %5, align 8, !dbg !311
  %11 = getelementptr inbounds %struct.ck_epoch_section, %struct.ck_epoch_section* %10, i32 0, i32 0, !dbg !312
  %12 = load i32, i32* %11, align 4, !dbg !312
  store i32 %12, i32* %8, align 4, !dbg !310
  %13 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %4, align 8, !dbg !313
  %14 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %13, i32 0, i32 5, !dbg !314
  %15 = getelementptr inbounds %struct.anon, %struct.anon* %14, i32 0, i32 0, !dbg !315
  %16 = load i32, i32* %8, align 4, !dbg !316
  %17 = zext i32 %16 to i64, !dbg !313
  %18 = getelementptr inbounds [2 x %struct.ck_epoch_ref], [2 x %struct.ck_epoch_ref]* %15, i64 0, i64 %17, !dbg !313
  store %struct.ck_epoch_ref* %18, %struct.ck_epoch_ref** %6, align 8, !dbg !317
  %19 = load %struct.ck_epoch_ref*, %struct.ck_epoch_ref** %6, align 8, !dbg !318
  %20 = getelementptr inbounds %struct.ck_epoch_ref, %struct.ck_epoch_ref* %19, i32 0, i32 1, !dbg !319
  %21 = load i32, i32* %20, align 4, !dbg !320
  %22 = add i32 %21, -1, !dbg !320
  store i32 %22, i32* %20, align 4, !dbg !320
  %23 = load %struct.ck_epoch_ref*, %struct.ck_epoch_ref** %6, align 8, !dbg !321
  %24 = getelementptr inbounds %struct.ck_epoch_ref, %struct.ck_epoch_ref* %23, i32 0, i32 1, !dbg !323
  %25 = load i32, i32* %24, align 4, !dbg !323
  %26 = icmp ugt i32 %25, 0, !dbg !324
  br i1 %26, label %27, label %28, !dbg !325

27:                                               ; preds = %2
  store i1 false, i1* %3, align 1, !dbg !326
  br label %58, !dbg !326

28:                                               ; preds = %2
  %29 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %4, align 8, !dbg !327
  %30 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %29, i32 0, i32 5, !dbg !328
  %31 = getelementptr inbounds %struct.anon, %struct.anon* %30, i32 0, i32 0, !dbg !329
  %32 = load i32, i32* %8, align 4, !dbg !330
  %33 = add i32 %32, 1, !dbg !331
  %34 = and i32 %33, 1, !dbg !332
  %35 = zext i32 %34 to i64, !dbg !327
  %36 = getelementptr inbounds [2 x %struct.ck_epoch_ref], [2 x %struct.ck_epoch_ref]* %31, i64 0, i64 %35, !dbg !327
  store %struct.ck_epoch_ref* %36, %struct.ck_epoch_ref** %7, align 8, !dbg !333
  %37 = load %struct.ck_epoch_ref*, %struct.ck_epoch_ref** %7, align 8, !dbg !334
  %38 = getelementptr inbounds %struct.ck_epoch_ref, %struct.ck_epoch_ref* %37, i32 0, i32 1, !dbg !336
  %39 = load i32, i32* %38, align 4, !dbg !336
  %40 = icmp ugt i32 %39, 0, !dbg !337
  br i1 %40, label %41, label %57, !dbg !338

41:                                               ; preds = %28
  %42 = load %struct.ck_epoch_ref*, %struct.ck_epoch_ref** %6, align 8, !dbg !339
  %43 = getelementptr inbounds %struct.ck_epoch_ref, %struct.ck_epoch_ref* %42, i32 0, i32 0, !dbg !340
  %44 = load i32, i32* %43, align 4, !dbg !340
  %45 = load %struct.ck_epoch_ref*, %struct.ck_epoch_ref** %7, align 8, !dbg !341
  %46 = getelementptr inbounds %struct.ck_epoch_ref, %struct.ck_epoch_ref* %45, i32 0, i32 0, !dbg !342
  %47 = load i32, i32* %46, align 4, !dbg !342
  %48 = sub i32 %44, %47, !dbg !343
  %49 = icmp slt i32 %48, 0, !dbg !344
  br i1 %49, label %50, label %57, !dbg !345

50:                                               ; preds = %41
  %51 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %4, align 8, !dbg !346
  %52 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %51, i32 0, i32 3, !dbg !346
  %53 = load %struct.ck_epoch_ref*, %struct.ck_epoch_ref** %7, align 8, !dbg !346
  %54 = getelementptr inbounds %struct.ck_epoch_ref, %struct.ck_epoch_ref* %53, i32 0, i32 0, !dbg !346
  %55 = load i32, i32* %54, align 4, !dbg !346
  store i32 %55, i32* %9, align 4, !dbg !346
  %56 = load i32, i32* %9, align 4, !dbg !346
  store atomic i32 %56, i32* %52 monotonic, align 4, !dbg !346
  br label %57, !dbg !348

57:                                               ; preds = %50, %41, %28
  store i1 true, i1* %3, align 1, !dbg !349
  br label %58, !dbg !349

58:                                               ; preds = %57, %27
  %59 = load i1, i1* %3, align 1, !dbg !350
  ret i1 %59, !dbg !350
}

; Function Attrs: noinline nounwind ssp uwtable
define void @_ck_epoch_addref(%struct.ck_epoch_record* noundef %0, %struct.ck_epoch_section* noundef %1) #0 !dbg !351 {
  %3 = alloca %struct.ck_epoch_record*, align 8
  %4 = alloca %struct.ck_epoch_section*, align 8
  %5 = alloca %struct.ck_epoch*, align 8
  %6 = alloca %struct.ck_epoch_ref*, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca %struct.ck_epoch_ref*, align 8
  store %struct.ck_epoch_record* %0, %struct.ck_epoch_record** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_epoch_record** %3, metadata !354, metadata !DIExpression()), !dbg !355
  store %struct.ck_epoch_section* %1, %struct.ck_epoch_section** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_epoch_section** %4, metadata !356, metadata !DIExpression()), !dbg !357
  call void @llvm.dbg.declare(metadata %struct.ck_epoch** %5, metadata !358, metadata !DIExpression()), !dbg !359
  %11 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %3, align 8, !dbg !360
  %12 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %11, i32 0, i32 1, !dbg !361
  %13 = load %struct.ck_epoch*, %struct.ck_epoch** %12, align 8, !dbg !361
  store %struct.ck_epoch* %13, %struct.ck_epoch** %5, align 8, !dbg !359
  call void @llvm.dbg.declare(metadata %struct.ck_epoch_ref** %6, metadata !362, metadata !DIExpression()), !dbg !363
  call void @llvm.dbg.declare(metadata i32* %7, metadata !364, metadata !DIExpression()), !dbg !365
  call void @llvm.dbg.declare(metadata i32* %8, metadata !366, metadata !DIExpression()), !dbg !367
  %14 = load %struct.ck_epoch*, %struct.ck_epoch** %5, align 8, !dbg !368
  %15 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %14, i32 0, i32 0, !dbg !368
  %16 = load atomic i32, i32* %15 monotonic, align 8, !dbg !368
  store i32 %16, i32* %9, align 4, !dbg !368
  %17 = load i32, i32* %9, align 4, !dbg !368
  store i32 %17, i32* %7, align 4, !dbg !369
  %18 = load i32, i32* %7, align 4, !dbg !370
  %19 = and i32 %18, 1, !dbg !371
  store i32 %19, i32* %8, align 4, !dbg !372
  %20 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %3, align 8, !dbg !373
  %21 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %20, i32 0, i32 5, !dbg !374
  %22 = getelementptr inbounds %struct.anon, %struct.anon* %21, i32 0, i32 0, !dbg !375
  %23 = load i32, i32* %8, align 4, !dbg !376
  %24 = zext i32 %23 to i64, !dbg !373
  %25 = getelementptr inbounds [2 x %struct.ck_epoch_ref], [2 x %struct.ck_epoch_ref]* %22, i64 0, i64 %24, !dbg !373
  store %struct.ck_epoch_ref* %25, %struct.ck_epoch_ref** %6, align 8, !dbg !377
  %26 = load %struct.ck_epoch_ref*, %struct.ck_epoch_ref** %6, align 8, !dbg !378
  %27 = getelementptr inbounds %struct.ck_epoch_ref, %struct.ck_epoch_ref* %26, i32 0, i32 1, !dbg !380
  %28 = load i32, i32* %27, align 4, !dbg !381
  %29 = add i32 %28, 1, !dbg !381
  store i32 %29, i32* %27, align 4, !dbg !381
  %30 = icmp eq i32 %28, 0, !dbg !382
  br i1 %30, label %31, label %49, !dbg !383

31:                                               ; preds = %2
  call void @llvm.dbg.declare(metadata %struct.ck_epoch_ref** %10, metadata !384, metadata !DIExpression()), !dbg !386
  %32 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %3, align 8, !dbg !387
  %33 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %32, i32 0, i32 5, !dbg !388
  %34 = getelementptr inbounds %struct.anon, %struct.anon* %33, i32 0, i32 0, !dbg !389
  %35 = load i32, i32* %8, align 4, !dbg !390
  %36 = add i32 %35, 1, !dbg !391
  %37 = and i32 %36, 1, !dbg !392
  %38 = zext i32 %37 to i64, !dbg !387
  %39 = getelementptr inbounds [2 x %struct.ck_epoch_ref], [2 x %struct.ck_epoch_ref]* %34, i64 0, i64 %38, !dbg !387
  store %struct.ck_epoch_ref* %39, %struct.ck_epoch_ref** %10, align 8, !dbg !393
  %40 = load %struct.ck_epoch_ref*, %struct.ck_epoch_ref** %10, align 8, !dbg !394
  %41 = getelementptr inbounds %struct.ck_epoch_ref, %struct.ck_epoch_ref* %40, i32 0, i32 1, !dbg !396
  %42 = load i32, i32* %41, align 4, !dbg !396
  %43 = icmp ugt i32 %42, 0, !dbg !397
  br i1 %43, label %44, label %45, !dbg !398

44:                                               ; preds = %31
  fence acq_rel, !dbg !399
  br label %45, !dbg !399

45:                                               ; preds = %44, %31
  %46 = load i32, i32* %7, align 4, !dbg !400
  %47 = load %struct.ck_epoch_ref*, %struct.ck_epoch_ref** %6, align 8, !dbg !401
  %48 = getelementptr inbounds %struct.ck_epoch_ref, %struct.ck_epoch_ref* %47, i32 0, i32 0, !dbg !402
  store i32 %46, i32* %48, align 4, !dbg !403
  br label %49, !dbg !404

49:                                               ; preds = %45, %2
  %50 = load i32, i32* %8, align 4, !dbg !405
  %51 = load %struct.ck_epoch_section*, %struct.ck_epoch_section** %4, align 8, !dbg !406
  %52 = getelementptr inbounds %struct.ck_epoch_section, %struct.ck_epoch_section* %51, i32 0, i32 0, !dbg !407
  store i32 %50, i32* %52, align 4, !dbg !408
  ret void, !dbg !409
}

; Function Attrs: noinline nounwind ssp uwtable
define void @ck_epoch_init(%struct.ck_epoch* noundef %0) #0 !dbg !410 {
  %2 = alloca %struct.ck_epoch*, align 8
  store %struct.ck_epoch* %0, %struct.ck_epoch** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_epoch** %2, metadata !413, metadata !DIExpression()), !dbg !414
  %3 = load %struct.ck_epoch*, %struct.ck_epoch** %2, align 8, !dbg !415
  %4 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %3, i32 0, i32 2, !dbg !416
  call void @ck_stack_init(%struct.ck_stack* noundef %4), !dbg !417
  %5 = load %struct.ck_epoch*, %struct.ck_epoch** %2, align 8, !dbg !418
  %6 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %5, i32 0, i32 0, !dbg !419
  store atomic i32 1, i32* %6 seq_cst, align 4, !dbg !420
  %7 = load %struct.ck_epoch*, %struct.ck_epoch** %2, align 8, !dbg !421
  %8 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %7, i32 0, i32 1, !dbg !422
  store atomic i32 0, i32* %8 seq_cst, align 4, !dbg !423
  fence release, !dbg !424
  ret void, !dbg !425
}

; Function Attrs: noinline nounwind ssp uwtable
define internal void @ck_stack_init(%struct.ck_stack* noundef %0) #0 !dbg !426 {
  %2 = alloca %struct.ck_stack*, align 8
  store %struct.ck_stack* %0, %struct.ck_stack** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_stack** %2, metadata !430, metadata !DIExpression()), !dbg !431
  %3 = load %struct.ck_stack*, %struct.ck_stack** %2, align 8, !dbg !432
  %4 = getelementptr inbounds %struct.ck_stack, %struct.ck_stack* %3, i32 0, i32 0, !dbg !433
  %5 = bitcast %struct.ck_stack_entry** %4 to i64*, !dbg !434
  store atomic i64 0, i64* %5 seq_cst, align 8, !dbg !434
  %6 = load %struct.ck_stack*, %struct.ck_stack** %2, align 8, !dbg !435
  %7 = getelementptr inbounds %struct.ck_stack, %struct.ck_stack* %6, i32 0, i32 1, !dbg !436
  store i8* null, i8** %7, align 8, !dbg !437
  ret void, !dbg !438
}

; Function Attrs: noinline nounwind ssp uwtable
define %struct.ck_epoch_record* @ck_epoch_recycle(%struct.ck_epoch* noundef %0, i8* noundef %1) #0 !dbg !439 {
  %3 = alloca %struct.ck_epoch_record*, align 8
  %4 = alloca %struct.ck_epoch*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca %struct.ck_epoch_record*, align 8
  %7 = alloca %struct.ck_stack_entry*, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca %struct.ck_stack_entry*, align 8
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  %15 = alloca i32, align 4
  %16 = alloca i8*, align 8
  %17 = alloca %struct.ck_stack_entry*, align 8
  store %struct.ck_epoch* %0, %struct.ck_epoch** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_epoch** %4, metadata !444, metadata !DIExpression()), !dbg !445
  store i8* %1, i8** %5, align 8
  call void @llvm.dbg.declare(metadata i8** %5, metadata !446, metadata !DIExpression()), !dbg !447
  call void @llvm.dbg.declare(metadata %struct.ck_epoch_record** %6, metadata !448, metadata !DIExpression()), !dbg !449
  call void @llvm.dbg.declare(metadata %struct.ck_stack_entry** %7, metadata !450, metadata !DIExpression()), !dbg !452
  call void @llvm.dbg.declare(metadata i32* %8, metadata !453, metadata !DIExpression()), !dbg !454
  %18 = load %struct.ck_epoch*, %struct.ck_epoch** %4, align 8, !dbg !455
  %19 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %18, i32 0, i32 1, !dbg !455
  %20 = load atomic i32, i32* %19 monotonic, align 4, !dbg !455
  store i32 %20, i32* %9, align 4, !dbg !455
  %21 = load i32, i32* %9, align 4, !dbg !455
  %22 = icmp eq i32 %21, 0, !dbg !457
  br i1 %22, label %23, label %24, !dbg !458

23:                                               ; preds = %2
  store %struct.ck_epoch_record* null, %struct.ck_epoch_record** %3, align 8, !dbg !459
  br label %76, !dbg !459

24:                                               ; preds = %2
  %25 = load %struct.ck_epoch*, %struct.ck_epoch** %4, align 8, !dbg !460
  %26 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %25, i32 0, i32 2, !dbg !460
  %27 = getelementptr inbounds %struct.ck_stack, %struct.ck_stack* %26, i32 0, i32 0, !dbg !460
  %28 = bitcast %struct.ck_stack_entry** %27 to i64*, !dbg !460
  %29 = bitcast %struct.ck_stack_entry** %10 to i64*, !dbg !460
  %30 = load atomic i64, i64* %28 monotonic, align 8, !dbg !460
  store i64 %30, i64* %29, align 8, !dbg !460
  %31 = bitcast i64* %29 to %struct.ck_stack_entry**, !dbg !460
  %32 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %31, align 8, !dbg !460
  store %struct.ck_stack_entry* %32, %struct.ck_stack_entry** %7, align 8, !dbg !460
  br label %33, !dbg !460

33:                                               ; preds = %67, %24
  %34 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %7, align 8, !dbg !462
  %35 = icmp ne %struct.ck_stack_entry* %34, null, !dbg !462
  br i1 %35, label %36, label %75, !dbg !460

36:                                               ; preds = %33
  %37 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %7, align 8, !dbg !464
  %38 = call %struct.ck_epoch_record* @ck_epoch_record_container(%struct.ck_stack_entry* noundef %37), !dbg !466
  store %struct.ck_epoch_record* %38, %struct.ck_epoch_record** %6, align 8, !dbg !467
  %39 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %6, align 8, !dbg !468
  %40 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %39, i32 0, i32 2, !dbg !468
  %41 = load atomic i32, i32* %40 monotonic, align 8, !dbg !468
  store i32 %41, i32* %11, align 4, !dbg !468
  %42 = load i32, i32* %11, align 4, !dbg !468
  %43 = icmp eq i32 %42, 1, !dbg !470
  br i1 %43, label %44, label %66, !dbg !471

44:                                               ; preds = %36
  fence acquire, !dbg !472
  %45 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %6, align 8, !dbg !474
  %46 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %45, i32 0, i32 2, !dbg !474
  store i32 0, i32* %12, align 4, !dbg !474
  %47 = load i32, i32* %12, align 4, !dbg !474
  %48 = atomicrmw xchg i32* %46, i32 %47 monotonic, align 4, !dbg !474
  store i32 %48, i32* %13, align 4, !dbg !474
  %49 = load i32, i32* %13, align 4, !dbg !474
  store i32 %49, i32* %8, align 4, !dbg !475
  %50 = load i32, i32* %8, align 4, !dbg !476
  %51 = icmp eq i32 %50, 1, !dbg !478
  br i1 %51, label %52, label %65, !dbg !479

52:                                               ; preds = %44
  %53 = load %struct.ck_epoch*, %struct.ck_epoch** %4, align 8, !dbg !480
  %54 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %53, i32 0, i32 1, !dbg !480
  store i32 -1, i32* %14, align 4, !dbg !480
  %55 = load i32, i32* %14, align 4, !dbg !480
  %56 = atomicrmw add i32* %54, i32 %55 monotonic, align 4, !dbg !480
  store i32 %56, i32* %15, align 4, !dbg !480
  %57 = load i32, i32* %15, align 4, !dbg !480
  %58 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %6, align 8, !dbg !482
  %59 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %58, i32 0, i32 9, !dbg !482
  %60 = load i8*, i8** %5, align 8, !dbg !482
  store i8* %60, i8** %16, align 8, !dbg !482
  %61 = bitcast i8** %59 to i64*, !dbg !482
  %62 = bitcast i8** %16 to i64*, !dbg !482
  %63 = load i64, i64* %62, align 8, !dbg !482
  store atomic i64 %63, i64* %61 monotonic, align 8, !dbg !482
  %64 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %6, align 8, !dbg !483
  store %struct.ck_epoch_record* %64, %struct.ck_epoch_record** %3, align 8, !dbg !484
  br label %76, !dbg !484

65:                                               ; preds = %44
  br label %66, !dbg !485

66:                                               ; preds = %65, %36
  br label %67, !dbg !486

67:                                               ; preds = %66
  %68 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %7, align 8, !dbg !462
  %69 = getelementptr inbounds %struct.ck_stack_entry, %struct.ck_stack_entry* %68, i32 0, i32 0, !dbg !462
  %70 = bitcast %struct.ck_stack_entry** %69 to i64*, !dbg !462
  %71 = bitcast %struct.ck_stack_entry** %17 to i64*, !dbg !462
  %72 = load atomic i64, i64* %70 monotonic, align 8, !dbg !462
  store i64 %72, i64* %71, align 8, !dbg !462
  %73 = bitcast i64* %71 to %struct.ck_stack_entry**, !dbg !462
  %74 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %73, align 8, !dbg !462
  store %struct.ck_stack_entry* %74, %struct.ck_stack_entry** %7, align 8, !dbg !462
  br label %33, !dbg !462, !llvm.loop !487

75:                                               ; preds = %33
  store %struct.ck_epoch_record* null, %struct.ck_epoch_record** %3, align 8, !dbg !489
  br label %76, !dbg !489

76:                                               ; preds = %75, %52, %23
  %77 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %3, align 8, !dbg !490
  ret %struct.ck_epoch_record* %77, !dbg !490
}

; Function Attrs: noinline nounwind ssp uwtable
define internal %struct.ck_epoch_record* @ck_epoch_record_container(%struct.ck_stack_entry* noundef %0) #0 !dbg !491 {
  %2 = alloca %struct.ck_stack_entry*, align 8
  %3 = alloca %struct.ck_stack_entry*, align 8
  store %struct.ck_stack_entry* %0, %struct.ck_stack_entry** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_stack_entry** %2, metadata !494, metadata !DIExpression()), !dbg !495
  call void @llvm.dbg.declare(metadata %struct.ck_stack_entry** %3, metadata !496, metadata !DIExpression()), !dbg !495
  %4 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %2, align 8, !dbg !495
  store %struct.ck_stack_entry* %4, %struct.ck_stack_entry** %3, align 8, !dbg !495
  %5 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %3, align 8, !dbg !495
  %6 = bitcast %struct.ck_stack_entry* %5 to i8*, !dbg !495
  %7 = getelementptr inbounds i8, i8* %6, i64 0, !dbg !495
  %8 = bitcast i8* %7 to %struct.ck_epoch_record*, !dbg !495
  ret %struct.ck_epoch_record* %8, !dbg !495
}

; Function Attrs: noinline nounwind ssp uwtable
define void @ck_epoch_register(%struct.ck_epoch* noundef %0, %struct.ck_epoch_record* noundef %1, i8* noundef %2) #0 !dbg !497 {
  %4 = alloca %struct.ck_epoch*, align 8
  %5 = alloca %struct.ck_epoch_record*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca i64, align 8
  store %struct.ck_epoch* %0, %struct.ck_epoch** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_epoch** %4, metadata !500, metadata !DIExpression()), !dbg !501
  store %struct.ck_epoch_record* %1, %struct.ck_epoch_record** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_epoch_record** %5, metadata !502, metadata !DIExpression()), !dbg !503
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !504, metadata !DIExpression()), !dbg !505
  call void @llvm.dbg.declare(metadata i64* %7, metadata !506, metadata !DIExpression()), !dbg !507
  %8 = load %struct.ck_epoch*, %struct.ck_epoch** %4, align 8, !dbg !508
  %9 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %5, align 8, !dbg !509
  %10 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %9, i32 0, i32 1, !dbg !510
  store %struct.ck_epoch* %8, %struct.ck_epoch** %10, align 8, !dbg !511
  %11 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %5, align 8, !dbg !512
  %12 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %11, i32 0, i32 2, !dbg !513
  store atomic i32 0, i32* %12 seq_cst, align 4, !dbg !514
  %13 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %5, align 8, !dbg !515
  %14 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %13, i32 0, i32 4, !dbg !516
  store atomic i32 0, i32* %14 seq_cst, align 4, !dbg !517
  %15 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %5, align 8, !dbg !518
  %16 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %15, i32 0, i32 3, !dbg !519
  store atomic i32 0, i32* %16 seq_cst, align 4, !dbg !520
  %17 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %5, align 8, !dbg !521
  %18 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %17, i32 0, i32 8, !dbg !522
  store atomic i32 0, i32* %18 seq_cst, align 4, !dbg !523
  %19 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %5, align 8, !dbg !524
  %20 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %19, i32 0, i32 7, !dbg !525
  store atomic i32 0, i32* %20 seq_cst, align 4, !dbg !526
  %21 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %5, align 8, !dbg !527
  %22 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %21, i32 0, i32 6, !dbg !528
  store atomic i32 0, i32* %22 seq_cst, align 4, !dbg !529
  %23 = load i8*, i8** %6, align 8, !dbg !530
  %24 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %5, align 8, !dbg !531
  %25 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %24, i32 0, i32 9, !dbg !532
  %26 = ptrtoint i8* %23 to i64, !dbg !533
  %27 = bitcast i8** %25 to i64*, !dbg !533
  store atomic i64 %26, i64* %27 seq_cst, align 8, !dbg !533
  %28 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %5, align 8, !dbg !534
  %29 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %28, i32 0, i32 5, !dbg !534
  %30 = bitcast %struct.anon* %29 to i8*, !dbg !534
  %31 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %5, align 8, !dbg !534
  %32 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %31, i32 0, i32 5, !dbg !534
  %33 = bitcast %struct.anon* %32 to i8*, !dbg !534
  %34 = call i64 @llvm.objectsize.i64.p0i8(i8* %33, i1 false, i1 true, i1 false), !dbg !534
  %35 = call i8* @__memset_chk(i8* noundef %30, i32 noundef 0, i64 noundef 16, i64 noundef %34) #6, !dbg !534
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !535
  store i64 0, i64* %7, align 8, !dbg !536
  br label %36, !dbg !538

36:                                               ; preds = %44, %3
  %37 = load i64, i64* %7, align 8, !dbg !539
  %38 = icmp ult i64 %37, 4, !dbg !541
  br i1 %38, label %39, label %47, !dbg !542

39:                                               ; preds = %36
  %40 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %5, align 8, !dbg !543
  %41 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %40, i32 0, i32 10, !dbg !544
  %42 = load i64, i64* %7, align 8, !dbg !545
  %43 = getelementptr inbounds [4 x %struct.ck_stack], [4 x %struct.ck_stack]* %41, i64 0, i64 %42, !dbg !543
  call void @ck_stack_init(%struct.ck_stack* noundef %43), !dbg !546
  br label %44, !dbg !546

44:                                               ; preds = %39
  %45 = load i64, i64* %7, align 8, !dbg !547
  %46 = add i64 %45, 1, !dbg !547
  store i64 %46, i64* %7, align 8, !dbg !547
  br label %36, !dbg !548, !llvm.loop !549

47:                                               ; preds = %36
  fence release, !dbg !551
  %48 = load %struct.ck_epoch*, %struct.ck_epoch** %4, align 8, !dbg !552
  %49 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %48, i32 0, i32 2, !dbg !553
  %50 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %5, align 8, !dbg !554
  %51 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %50, i32 0, i32 0, !dbg !555
  call void @ck_stack_push_upmc(%struct.ck_stack* noundef %49, %struct.ck_stack_entry* noundef %51), !dbg !556
  ret void, !dbg !557
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare i64 @llvm.objectsize.i64.p0i8(i8*, i1 immarg, i1 immarg, i1 immarg) #1

; Function Attrs: nounwind
declare i8* @__memset_chk(i8* noundef, i32 noundef, i64 noundef, i64 noundef) #4

; Function Attrs: noinline nounwind ssp uwtable
define internal void @ck_stack_push_upmc(%struct.ck_stack* noundef %0, %struct.ck_stack_entry* noundef %1) #0 !dbg !558 {
  %3 = alloca %struct.ck_stack*, align 8
  %4 = alloca %struct.ck_stack_entry*, align 8
  %5 = alloca %struct.ck_stack_entry*, align 8
  %6 = alloca %struct.ck_stack_entry*, align 8
  %7 = alloca %struct.ck_stack_entry*, align 8
  %8 = alloca i8, align 1
  store %struct.ck_stack* %0, %struct.ck_stack** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_stack** %3, metadata !561, metadata !DIExpression()), !dbg !562
  store %struct.ck_stack_entry* %1, %struct.ck_stack_entry** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_stack_entry** %4, metadata !563, metadata !DIExpression()), !dbg !564
  call void @llvm.dbg.declare(metadata %struct.ck_stack_entry** %5, metadata !565, metadata !DIExpression()), !dbg !566
  %9 = load %struct.ck_stack*, %struct.ck_stack** %3, align 8, !dbg !567
  %10 = getelementptr inbounds %struct.ck_stack, %struct.ck_stack* %9, i32 0, i32 0, !dbg !567
  %11 = bitcast %struct.ck_stack_entry** %10 to i64*, !dbg !567
  %12 = bitcast %struct.ck_stack_entry** %6 to i64*, !dbg !567
  %13 = load atomic i64, i64* %11 monotonic, align 8, !dbg !567
  store i64 %13, i64* %12, align 8, !dbg !567
  %14 = bitcast i64* %12 to %struct.ck_stack_entry**, !dbg !567
  %15 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %14, align 8, !dbg !567
  store %struct.ck_stack_entry* %15, %struct.ck_stack_entry** %5, align 8, !dbg !568
  %16 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %5, align 8, !dbg !569
  %17 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %4, align 8, !dbg !570
  %18 = getelementptr inbounds %struct.ck_stack_entry, %struct.ck_stack_entry* %17, i32 0, i32 0, !dbg !571
  %19 = ptrtoint %struct.ck_stack_entry* %16 to i64, !dbg !572
  %20 = bitcast %struct.ck_stack_entry** %18 to i64*, !dbg !572
  store atomic i64 %19, i64* %20 seq_cst, align 8, !dbg !572
  fence release, !dbg !573
  br label %21, !dbg !574

21:                                               ; preds = %40, %2
  %22 = load %struct.ck_stack*, %struct.ck_stack** %3, align 8, !dbg !575
  %23 = getelementptr inbounds %struct.ck_stack, %struct.ck_stack* %22, i32 0, i32 0, !dbg !575
  %24 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %4, align 8, !dbg !575
  store %struct.ck_stack_entry* %24, %struct.ck_stack_entry** %7, align 8, !dbg !575
  %25 = bitcast %struct.ck_stack_entry** %23 to i64*, !dbg !575
  %26 = bitcast %struct.ck_stack_entry** %5 to i64*, !dbg !575
  %27 = bitcast %struct.ck_stack_entry** %7 to i64*, !dbg !575
  %28 = load i64, i64* %26, align 8, !dbg !575
  %29 = load i64, i64* %27, align 8, !dbg !575
  %30 = cmpxchg i64* %25, i64 %28, i64 %29 monotonic monotonic, align 8, !dbg !575
  %31 = extractvalue { i64, i1 } %30, 0, !dbg !575
  %32 = extractvalue { i64, i1 } %30, 1, !dbg !575
  br i1 %32, label %34, label %33, !dbg !575

33:                                               ; preds = %21
  store i64 %31, i64* %26, align 8, !dbg !575
  br label %34, !dbg !575

34:                                               ; preds = %33, %21
  %35 = zext i1 %32 to i8, !dbg !575
  store i8 %35, i8* %8, align 1, !dbg !575
  %36 = load i8, i8* %8, align 1, !dbg !575
  %37 = trunc i8 %36 to i1, !dbg !575
  %38 = zext i1 %37 to i32, !dbg !575
  %39 = icmp eq i32 %38, 0, !dbg !576
  br i1 %39, label %40, label %46, !dbg !574

40:                                               ; preds = %34
  %41 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %5, align 8, !dbg !577
  %42 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %4, align 8, !dbg !579
  %43 = getelementptr inbounds %struct.ck_stack_entry, %struct.ck_stack_entry* %42, i32 0, i32 0, !dbg !580
  %44 = ptrtoint %struct.ck_stack_entry* %41 to i64, !dbg !581
  %45 = bitcast %struct.ck_stack_entry** %43 to i64*, !dbg !581
  store atomic i64 %44, i64* %45 seq_cst, align 8, !dbg !581
  fence release, !dbg !582
  br label %21, !dbg !574, !llvm.loop !583

46:                                               ; preds = %34
  ret void, !dbg !585
}

; Function Attrs: noinline nounwind ssp uwtable
define void @ck_epoch_unregister(%struct.ck_epoch_record* noundef %0) #0 !dbg !586 {
  %2 = alloca %struct.ck_epoch_record*, align 8
  %3 = alloca %struct.ck_epoch*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %struct.ck_epoch_record* %0, %struct.ck_epoch_record** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_epoch_record** %2, metadata !589, metadata !DIExpression()), !dbg !590
  call void @llvm.dbg.declare(metadata %struct.ck_epoch** %3, metadata !591, metadata !DIExpression()), !dbg !592
  %9 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %2, align 8, !dbg !593
  %10 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %9, i32 0, i32 1, !dbg !594
  %11 = load %struct.ck_epoch*, %struct.ck_epoch** %10, align 8, !dbg !594
  store %struct.ck_epoch* %11, %struct.ck_epoch** %3, align 8, !dbg !592
  call void @llvm.dbg.declare(metadata i64* %4, metadata !595, metadata !DIExpression()), !dbg !596
  %12 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %2, align 8, !dbg !597
  %13 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %12, i32 0, i32 4, !dbg !598
  store atomic i32 0, i32* %13 seq_cst, align 4, !dbg !599
  %14 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %2, align 8, !dbg !600
  %15 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %14, i32 0, i32 3, !dbg !601
  store atomic i32 0, i32* %15 seq_cst, align 4, !dbg !602
  %16 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %2, align 8, !dbg !603
  %17 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %16, i32 0, i32 8, !dbg !604
  store atomic i32 0, i32* %17 seq_cst, align 4, !dbg !605
  %18 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %2, align 8, !dbg !606
  %19 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %18, i32 0, i32 7, !dbg !607
  store atomic i32 0, i32* %19 seq_cst, align 4, !dbg !608
  %20 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %2, align 8, !dbg !609
  %21 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %20, i32 0, i32 6, !dbg !610
  store atomic i32 0, i32* %21 seq_cst, align 4, !dbg !611
  %22 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %2, align 8, !dbg !612
  %23 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %22, i32 0, i32 5, !dbg !612
  %24 = bitcast %struct.anon* %23 to i8*, !dbg !612
  %25 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %2, align 8, !dbg !612
  %26 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %25, i32 0, i32 5, !dbg !612
  %27 = bitcast %struct.anon* %26 to i8*, !dbg !612
  %28 = call i64 @llvm.objectsize.i64.p0i8(i8* %27, i1 false, i1 true, i1 false), !dbg !612
  %29 = call i8* @__memset_chk(i8* noundef %24, i32 noundef 0, i64 noundef 16, i64 noundef %28) #6, !dbg !612
  store i64 0, i64* %4, align 8, !dbg !613
  br label %30, !dbg !615

30:                                               ; preds = %38, %1
  %31 = load i64, i64* %4, align 8, !dbg !616
  %32 = icmp ult i64 %31, 4, !dbg !618
  br i1 %32, label %33, label %41, !dbg !619

33:                                               ; preds = %30
  %34 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %2, align 8, !dbg !620
  %35 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %34, i32 0, i32 10, !dbg !621
  %36 = load i64, i64* %4, align 8, !dbg !622
  %37 = getelementptr inbounds [4 x %struct.ck_stack], [4 x %struct.ck_stack]* %35, i64 0, i64 %36, !dbg !620
  call void @ck_stack_init(%struct.ck_stack* noundef %37), !dbg !623
  br label %38, !dbg !623

38:                                               ; preds = %33
  %39 = load i64, i64* %4, align 8, !dbg !624
  %40 = add i64 %39, 1, !dbg !624
  store i64 %40, i64* %4, align 8, !dbg !624
  br label %30, !dbg !625, !llvm.loop !626

41:                                               ; preds = %30
  %42 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %2, align 8, !dbg !628
  %43 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %42, i32 0, i32 9, !dbg !628
  store i8* null, i8** %5, align 8, !dbg !628
  %44 = bitcast i8** %43 to i64*, !dbg !628
  %45 = bitcast i8** %5 to i64*, !dbg !628
  %46 = load i64, i64* %45, align 8, !dbg !628
  store atomic i64 %46, i64* %44 monotonic, align 8, !dbg !628
  fence release, !dbg !629
  %47 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %2, align 8, !dbg !630
  %48 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %47, i32 0, i32 2, !dbg !630
  store i32 1, i32* %6, align 4, !dbg !630
  %49 = load i32, i32* %6, align 4, !dbg !630
  store atomic i32 %49, i32* %48 monotonic, align 8, !dbg !630
  %50 = load %struct.ck_epoch*, %struct.ck_epoch** %3, align 8, !dbg !631
  %51 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %50, i32 0, i32 1, !dbg !631
  store i32 1, i32* %7, align 4, !dbg !631
  %52 = load i32, i32* %7, align 4, !dbg !631
  %53 = atomicrmw add i32* %51, i32 %52 monotonic, align 4, !dbg !631
  store i32 %53, i32* %8, align 4, !dbg !631
  %54 = load i32, i32* %8, align 4, !dbg !631
  ret void, !dbg !632
}

; Function Attrs: noinline nounwind ssp uwtable
define void @ck_epoch_reclaim(%struct.ck_epoch_record* noundef %0) #0 !dbg !633 {
  %2 = alloca %struct.ck_epoch_record*, align 8
  %3 = alloca i32, align 4
  store %struct.ck_epoch_record* %0, %struct.ck_epoch_record** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_epoch_record** %2, metadata !634, metadata !DIExpression()), !dbg !635
  call void @llvm.dbg.declare(metadata i32* %3, metadata !636, metadata !DIExpression()), !dbg !637
  store i32 0, i32* %3, align 4, !dbg !638
  br label %4, !dbg !640

4:                                                ; preds = %11, %1
  %5 = load i32, i32* %3, align 4, !dbg !641
  %6 = icmp ult i32 %5, 4, !dbg !643
  br i1 %6, label %7, label %14, !dbg !644

7:                                                ; preds = %4
  %8 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %2, align 8, !dbg !645
  %9 = load i32, i32* %3, align 4, !dbg !646
  %10 = call i32 @ck_epoch_dispatch(%struct.ck_epoch_record* noundef %8, i32 noundef %9, %struct.ck_stack* noundef null), !dbg !647
  br label %11, !dbg !647

11:                                               ; preds = %7
  %12 = load i32, i32* %3, align 4, !dbg !648
  %13 = add i32 %12, 1, !dbg !648
  store i32 %13, i32* %3, align 4, !dbg !648
  br label %4, !dbg !649, !llvm.loop !650

14:                                               ; preds = %4
  ret void, !dbg !652
}

; Function Attrs: noinline nounwind ssp uwtable
define internal i32 @ck_epoch_dispatch(%struct.ck_epoch_record* noundef %0, i32 noundef %1, %struct.ck_stack* noundef %2) #0 !dbg !653 {
  %4 = alloca %struct.ck_epoch_record*, align 8
  %5 = alloca i32, align 4
  %6 = alloca %struct.ck_stack*, align 8
  %7 = alloca i32, align 4
  %8 = alloca %struct.ck_stack_entry*, align 8
  %9 = alloca %struct.ck_stack_entry*, align 8
  %10 = alloca %struct.ck_stack_entry*, align 8
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca %struct.ck_epoch_entry*, align 8
  %15 = alloca %struct.ck_stack_entry*, align 8
  %16 = alloca i32, align 4
  %17 = alloca i32, align 4
  %18 = alloca i32, align 4
  %19 = alloca i32, align 4
  %20 = alloca i32, align 4
  %21 = alloca i32, align 4
  %22 = alloca i32, align 4
  store %struct.ck_epoch_record* %0, %struct.ck_epoch_record** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_epoch_record** %4, metadata !657, metadata !DIExpression()), !dbg !658
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !659, metadata !DIExpression()), !dbg !660
  store %struct.ck_stack* %2, %struct.ck_stack** %6, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_stack** %6, metadata !661, metadata !DIExpression()), !dbg !662
  call void @llvm.dbg.declare(metadata i32* %7, metadata !663, metadata !DIExpression()), !dbg !664
  %23 = load i32, i32* %5, align 4, !dbg !665
  %24 = and i32 %23, 3, !dbg !666
  store i32 %24, i32* %7, align 4, !dbg !664
  call void @llvm.dbg.declare(metadata %struct.ck_stack_entry** %8, metadata !667, metadata !DIExpression()), !dbg !668
  call void @llvm.dbg.declare(metadata %struct.ck_stack_entry** %9, metadata !669, metadata !DIExpression()), !dbg !670
  call void @llvm.dbg.declare(metadata %struct.ck_stack_entry** %10, metadata !671, metadata !DIExpression()), !dbg !672
  call void @llvm.dbg.declare(metadata i32* %11, metadata !673, metadata !DIExpression()), !dbg !674
  call void @llvm.dbg.declare(metadata i32* %12, metadata !675, metadata !DIExpression()), !dbg !676
  call void @llvm.dbg.declare(metadata i32* %13, metadata !677, metadata !DIExpression()), !dbg !678
  store i32 0, i32* %13, align 4, !dbg !678
  %25 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %4, align 8, !dbg !679
  %26 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %25, i32 0, i32 10, !dbg !680
  %27 = load i32, i32* %7, align 4, !dbg !681
  %28 = zext i32 %27 to i64, !dbg !679
  %29 = getelementptr inbounds [4 x %struct.ck_stack], [4 x %struct.ck_stack]* %26, i64 0, i64 %28, !dbg !679
  %30 = call %struct.ck_stack_entry* @ck_stack_batch_pop_upmc(%struct.ck_stack* noundef %29), !dbg !682
  store %struct.ck_stack_entry* %30, %struct.ck_stack_entry** %8, align 8, !dbg !683
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !684
  %31 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %8, align 8, !dbg !685
  store %struct.ck_stack_entry* %31, %struct.ck_stack_entry** %10, align 8, !dbg !687
  br label %32, !dbg !688

32:                                               ; preds = %59, %3
  %33 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %10, align 8, !dbg !689
  %34 = icmp ne %struct.ck_stack_entry* %33, null, !dbg !691
  br i1 %34, label %35, label %61, !dbg !692

35:                                               ; preds = %32
  call void @llvm.dbg.declare(metadata %struct.ck_epoch_entry** %14, metadata !693, metadata !DIExpression()), !dbg !695
  %36 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %10, align 8, !dbg !696
  %37 = call %struct.ck_epoch_entry* @ck_epoch_entry_container(%struct.ck_stack_entry* noundef %36), !dbg !697
  store %struct.ck_epoch_entry* %37, %struct.ck_epoch_entry** %14, align 8, !dbg !695
  %38 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %10, align 8, !dbg !698
  %39 = getelementptr inbounds %struct.ck_stack_entry, %struct.ck_stack_entry* %38, i32 0, i32 0, !dbg !698
  %40 = bitcast %struct.ck_stack_entry** %39 to i64*, !dbg !698
  %41 = bitcast %struct.ck_stack_entry** %15 to i64*, !dbg !698
  %42 = load atomic i64, i64* %40 monotonic, align 8, !dbg !698
  store i64 %42, i64* %41, align 8, !dbg !698
  %43 = bitcast i64* %41 to %struct.ck_stack_entry**, !dbg !698
  %44 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %43, align 8, !dbg !698
  store %struct.ck_stack_entry* %44, %struct.ck_stack_entry** %9, align 8, !dbg !699
  %45 = load %struct.ck_stack*, %struct.ck_stack** %6, align 8, !dbg !700
  %46 = icmp ne %struct.ck_stack* %45, null, !dbg !702
  br i1 %46, label %47, label %51, !dbg !703

47:                                               ; preds = %35
  %48 = load %struct.ck_stack*, %struct.ck_stack** %6, align 8, !dbg !704
  %49 = load %struct.ck_epoch_entry*, %struct.ck_epoch_entry** %14, align 8, !dbg !705
  %50 = getelementptr inbounds %struct.ck_epoch_entry, %struct.ck_epoch_entry* %49, i32 0, i32 1, !dbg !706
  call void @ck_stack_push_spnc(%struct.ck_stack* noundef %48, %struct.ck_stack_entry* noundef %50), !dbg !707
  br label %56, !dbg !707

51:                                               ; preds = %35
  %52 = load %struct.ck_epoch_entry*, %struct.ck_epoch_entry** %14, align 8, !dbg !708
  %53 = getelementptr inbounds %struct.ck_epoch_entry, %struct.ck_epoch_entry* %52, i32 0, i32 0, !dbg !709
  %54 = load void (%struct.ck_epoch_entry*)*, void (%struct.ck_epoch_entry*)** %53, align 8, !dbg !709
  %55 = load %struct.ck_epoch_entry*, %struct.ck_epoch_entry** %14, align 8, !dbg !710
  call void %54(%struct.ck_epoch_entry* noundef %55), !dbg !708
  br label %56

56:                                               ; preds = %51, %47
  %57 = load i32, i32* %13, align 4, !dbg !711
  %58 = add i32 %57, 1, !dbg !711
  store i32 %58, i32* %13, align 4, !dbg !711
  br label %59, !dbg !712

59:                                               ; preds = %56
  %60 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %9, align 8, !dbg !713
  store %struct.ck_stack_entry* %60, %struct.ck_stack_entry** %10, align 8, !dbg !714
  br label %32, !dbg !715, !llvm.loop !716

61:                                               ; preds = %32
  %62 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %4, align 8, !dbg !718
  %63 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %62, i32 0, i32 7, !dbg !718
  %64 = load atomic i32, i32* %63 monotonic, align 8, !dbg !718
  store i32 %64, i32* %16, align 4, !dbg !718
  %65 = load i32, i32* %16, align 4, !dbg !718
  store i32 %65, i32* %12, align 4, !dbg !719
  %66 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %4, align 8, !dbg !720
  %67 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %66, i32 0, i32 6, !dbg !720
  %68 = load atomic i32, i32* %67 monotonic, align 4, !dbg !720
  store i32 %68, i32* %17, align 4, !dbg !720
  %69 = load i32, i32* %17, align 4, !dbg !720
  store i32 %69, i32* %11, align 4, !dbg !721
  %70 = load i32, i32* %11, align 4, !dbg !722
  %71 = load i32, i32* %12, align 4, !dbg !724
  %72 = icmp ugt i32 %70, %71, !dbg !725
  br i1 %72, label %73, label %78, !dbg !726

73:                                               ; preds = %61
  %74 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %4, align 8, !dbg !727
  %75 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %74, i32 0, i32 7, !dbg !727
  %76 = load i32, i32* %12, align 4, !dbg !727
  store i32 %76, i32* %18, align 4, !dbg !727
  %77 = load i32, i32* %18, align 4, !dbg !727
  store atomic i32 %77, i32* %75 monotonic, align 8, !dbg !727
  br label %78, !dbg !727

78:                                               ; preds = %73, %61
  %79 = load i32, i32* %13, align 4, !dbg !728
  %80 = icmp ugt i32 %79, 0, !dbg !730
  br i1 %80, label %81, label %95, !dbg !731

81:                                               ; preds = %78
  %82 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %4, align 8, !dbg !732
  %83 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %82, i32 0, i32 8, !dbg !732
  %84 = load i32, i32* %13, align 4, !dbg !732
  store i32 %84, i32* %19, align 4, !dbg !732
  %85 = load i32, i32* %19, align 4, !dbg !732
  %86 = atomicrmw add i32* %83, i32 %85 monotonic, align 4, !dbg !732
  store i32 %86, i32* %20, align 4, !dbg !732
  %87 = load i32, i32* %20, align 4, !dbg !732
  %88 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %4, align 8, !dbg !734
  %89 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %88, i32 0, i32 6, !dbg !734
  %90 = load i32, i32* %13, align 4, !dbg !734
  %91 = sub i32 0, %90, !dbg !734
  store i32 %91, i32* %21, align 4, !dbg !734
  %92 = load i32, i32* %21, align 4, !dbg !734
  %93 = atomicrmw add i32* %89, i32 %92 monotonic, align 4, !dbg !734
  store i32 %93, i32* %22, align 4, !dbg !734
  %94 = load i32, i32* %22, align 4, !dbg !734
  br label %95, !dbg !735

95:                                               ; preds = %81, %78
  %96 = load i32, i32* %13, align 4, !dbg !736
  ret i32 %96, !dbg !737
}

; Function Attrs: noinline nounwind ssp uwtable
define internal %struct.ck_stack_entry* @ck_stack_batch_pop_upmc(%struct.ck_stack* noundef %0) #0 !dbg !738 {
  %2 = alloca %struct.ck_stack*, align 8
  %3 = alloca %struct.ck_stack_entry*, align 8
  %4 = alloca %struct.ck_stack_entry*, align 8
  %5 = alloca %struct.ck_stack_entry*, align 8
  store %struct.ck_stack* %0, %struct.ck_stack** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_stack** %2, metadata !741, metadata !DIExpression()), !dbg !742
  call void @llvm.dbg.declare(metadata %struct.ck_stack_entry** %3, metadata !743, metadata !DIExpression()), !dbg !744
  %6 = load %struct.ck_stack*, %struct.ck_stack** %2, align 8, !dbg !745
  %7 = getelementptr inbounds %struct.ck_stack, %struct.ck_stack* %6, i32 0, i32 0, !dbg !745
  store %struct.ck_stack_entry* null, %struct.ck_stack_entry** %4, align 8, !dbg !745
  %8 = bitcast %struct.ck_stack_entry** %7 to i64*, !dbg !745
  %9 = bitcast %struct.ck_stack_entry** %4 to i64*, !dbg !745
  %10 = bitcast %struct.ck_stack_entry** %5 to i64*, !dbg !745
  %11 = load i64, i64* %9, align 8, !dbg !745
  %12 = atomicrmw xchg i64* %8, i64 %11 monotonic, align 8, !dbg !745
  store i64 %12, i64* %10, align 8, !dbg !745
  %13 = bitcast i64* %10 to %struct.ck_stack_entry**, !dbg !745
  %14 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %13, align 8, !dbg !745
  store %struct.ck_stack_entry* %14, %struct.ck_stack_entry** %3, align 8, !dbg !746
  fence acquire, !dbg !747
  %15 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %3, align 8, !dbg !748
  ret %struct.ck_stack_entry* %15, !dbg !749
}

; Function Attrs: noinline nounwind ssp uwtable
define internal %struct.ck_epoch_entry* @ck_epoch_entry_container(%struct.ck_stack_entry* noundef %0) #0 !dbg !750 {
  %2 = alloca %struct.ck_stack_entry*, align 8
  %3 = alloca %struct.ck_stack_entry*, align 8
  store %struct.ck_stack_entry* %0, %struct.ck_stack_entry** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_stack_entry** %2, metadata !753, metadata !DIExpression()), !dbg !754
  call void @llvm.dbg.declare(metadata %struct.ck_stack_entry** %3, metadata !755, metadata !DIExpression()), !dbg !754
  %4 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %2, align 8, !dbg !754
  store %struct.ck_stack_entry* %4, %struct.ck_stack_entry** %3, align 8, !dbg !754
  %5 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %3, align 8, !dbg !754
  %6 = bitcast %struct.ck_stack_entry* %5 to i8*, !dbg !754
  %7 = getelementptr inbounds i8, i8* %6, i64 sub (i64 0, i64 ptrtoint (%struct.ck_stack_entry* getelementptr inbounds (%struct.ck_epoch_entry, %struct.ck_epoch_entry* null, i32 0, i32 1) to i64)), !dbg !754
  %8 = bitcast i8* %7 to %struct.ck_epoch_entry*, !dbg !754
  ret %struct.ck_epoch_entry* %8, !dbg !754
}

; Function Attrs: noinline nounwind ssp uwtable
define internal void @ck_stack_push_spnc(%struct.ck_stack* noundef %0, %struct.ck_stack_entry* noundef %1) #0 !dbg !756 {
  %3 = alloca %struct.ck_stack*, align 8
  %4 = alloca %struct.ck_stack_entry*, align 8
  store %struct.ck_stack* %0, %struct.ck_stack** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_stack** %3, metadata !757, metadata !DIExpression()), !dbg !758
  store %struct.ck_stack_entry* %1, %struct.ck_stack_entry** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_stack_entry** %4, metadata !759, metadata !DIExpression()), !dbg !760
  %5 = load %struct.ck_stack*, %struct.ck_stack** %3, align 8, !dbg !761
  %6 = getelementptr inbounds %struct.ck_stack, %struct.ck_stack* %5, i32 0, i32 0, !dbg !762
  %7 = bitcast %struct.ck_stack_entry** %6 to i64*, !dbg !762
  %8 = load atomic i64, i64* %7 seq_cst, align 8, !dbg !762
  %9 = inttoptr i64 %8 to %struct.ck_stack_entry*, !dbg !762
  %10 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %4, align 8, !dbg !763
  %11 = getelementptr inbounds %struct.ck_stack_entry, %struct.ck_stack_entry* %10, i32 0, i32 0, !dbg !764
  %12 = ptrtoint %struct.ck_stack_entry* %9 to i64, !dbg !765
  %13 = bitcast %struct.ck_stack_entry** %11 to i64*, !dbg !765
  store atomic i64 %12, i64* %13 seq_cst, align 8, !dbg !765
  %14 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %4, align 8, !dbg !766
  %15 = load %struct.ck_stack*, %struct.ck_stack** %3, align 8, !dbg !767
  %16 = getelementptr inbounds %struct.ck_stack, %struct.ck_stack* %15, i32 0, i32 0, !dbg !768
  %17 = ptrtoint %struct.ck_stack_entry* %14 to i64, !dbg !769
  %18 = bitcast %struct.ck_stack_entry** %16 to i64*, !dbg !769
  store atomic i64 %17, i64* %18 seq_cst, align 8, !dbg !769
  ret void, !dbg !770
}

; Function Attrs: noinline nounwind ssp uwtable
define void @ck_epoch_synchronize_wait(%struct.ck_epoch* noundef %0, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* noundef %1, i8* noundef %2) #0 !dbg !771 {
  %4 = alloca %struct.ck_epoch*, align 8
  %5 = alloca void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %struct.ck_epoch_record*, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i8, align 1
  %13 = alloca i32, align 4
  %14 = alloca i8, align 1
  %15 = alloca i32, align 4
  %16 = alloca i32, align 4
  %17 = alloca i32, align 4
  %18 = alloca i8, align 1
  store %struct.ck_epoch* %0, %struct.ck_epoch** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_epoch** %4, metadata !780, metadata !DIExpression()), !dbg !781
  store void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* %1, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)** %5, align 8
  call void @llvm.dbg.declare(metadata void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)** %5, metadata !782, metadata !DIExpression()), !dbg !783
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !784, metadata !DIExpression()), !dbg !785
  call void @llvm.dbg.declare(metadata %struct.ck_epoch_record** %7, metadata !786, metadata !DIExpression()), !dbg !787
  call void @llvm.dbg.declare(metadata i32* %8, metadata !788, metadata !DIExpression()), !dbg !789
  call void @llvm.dbg.declare(metadata i32* %9, metadata !790, metadata !DIExpression()), !dbg !791
  call void @llvm.dbg.declare(metadata i32* %10, metadata !792, metadata !DIExpression()), !dbg !793
  call void @llvm.dbg.declare(metadata i32* %11, metadata !794, metadata !DIExpression()), !dbg !795
  call void @llvm.dbg.declare(metadata i8* %12, metadata !796, metadata !DIExpression()), !dbg !797
  fence seq_cst, !dbg !798
  %19 = load %struct.ck_epoch*, %struct.ck_epoch** %4, align 8, !dbg !799
  %20 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %19, i32 0, i32 0, !dbg !799
  %21 = load atomic i32, i32* %20 monotonic, align 8, !dbg !799
  store i32 %21, i32* %13, align 4, !dbg !799
  %22 = load i32, i32* %13, align 4, !dbg !799
  store i32 %22, i32* %9, align 4, !dbg !800
  store i32 %22, i32* %8, align 4, !dbg !801
  %23 = load i32, i32* %9, align 4, !dbg !802
  %24 = add i32 %23, 3, !dbg !803
  store i32 %24, i32* %10, align 4, !dbg !804
  store i32 0, i32* %11, align 4, !dbg !805
  store %struct.ck_epoch_record* null, %struct.ck_epoch_record** %7, align 8, !dbg !807
  br label %25, !dbg !808

25:                                               ; preds = %94, %3
  %26 = load i32, i32* %11, align 4, !dbg !809
  %27 = icmp ult i32 %26, 2, !dbg !811
  br i1 %27, label %28, label %97, !dbg !812

28:                                               ; preds = %25
  call void @llvm.dbg.declare(metadata i8* %14, metadata !813, metadata !DIExpression()), !dbg !815
  br label %29, !dbg !816

29:                                               ; preds = %62, %44, %28
  %30 = load %struct.ck_epoch*, %struct.ck_epoch** %4, align 8, !dbg !817
  %31 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %7, align 8, !dbg !818
  %32 = load i32, i32* %8, align 4, !dbg !819
  %33 = call %struct.ck_epoch_record* @ck_epoch_scan(%struct.ck_epoch* noundef %30, %struct.ck_epoch_record* noundef %31, i32 noundef %32, i8* noundef %12), !dbg !820
  store %struct.ck_epoch_record* %33, %struct.ck_epoch_record** %7, align 8, !dbg !821
  %34 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %7, align 8, !dbg !822
  %35 = icmp ne %struct.ck_epoch_record* %34, null, !dbg !823
  br i1 %35, label %36, label %67, !dbg !816

36:                                               ; preds = %29
  call void @llvm.dbg.declare(metadata i32* %15, metadata !824, metadata !DIExpression()), !dbg !826
  %37 = load %struct.ck_epoch*, %struct.ck_epoch** %4, align 8, !dbg !827
  %38 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %37, i32 0, i32 0, !dbg !827
  %39 = load atomic i32, i32* %38 monotonic, align 8, !dbg !827
  store i32 %39, i32* %16, align 4, !dbg !827
  %40 = load i32, i32* %16, align 4, !dbg !827
  store i32 %40, i32* %15, align 4, !dbg !828
  %41 = load i32, i32* %15, align 4, !dbg !829
  %42 = load i32, i32* %8, align 4, !dbg !831
  %43 = icmp eq i32 %41, %42, !dbg !832
  br i1 %43, label %44, label %49, !dbg !833

44:                                               ; preds = %36
  %45 = load %struct.ck_epoch*, %struct.ck_epoch** %4, align 8, !dbg !834
  %46 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %7, align 8, !dbg !836
  %47 = load void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)*, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)** %5, align 8, !dbg !837
  %48 = load i8*, i8** %6, align 8, !dbg !838
  call void @epoch_block(%struct.ck_epoch* noundef %45, %struct.ck_epoch_record* noundef %46, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* noundef %47, i8* noundef %48), !dbg !839
  br label %29, !dbg !840, !llvm.loop !841

49:                                               ; preds = %36
  %50 = load i32, i32* %15, align 4, !dbg !843
  store i32 %50, i32* %8, align 4, !dbg !844
  %51 = load i32, i32* %10, align 4, !dbg !845
  %52 = load i32, i32* %9, align 4, !dbg !847
  %53 = icmp ugt i32 %51, %52, !dbg !848
  %54 = zext i1 %53 to i32, !dbg !848
  %55 = load i32, i32* %8, align 4, !dbg !849
  %56 = load i32, i32* %10, align 4, !dbg !850
  %57 = icmp uge i32 %55, %56, !dbg !851
  %58 = zext i1 %57 to i32, !dbg !851
  %59 = and i32 %54, %58, !dbg !852
  %60 = icmp ne i32 %59, 0, !dbg !852
  br i1 %60, label %61, label %62, !dbg !853

61:                                               ; preds = %49
  br label %98, !dbg !854

62:                                               ; preds = %49
  %63 = load %struct.ck_epoch*, %struct.ck_epoch** %4, align 8, !dbg !855
  %64 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %7, align 8, !dbg !856
  %65 = load void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)*, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)** %5, align 8, !dbg !857
  %66 = load i8*, i8** %6, align 8, !dbg !858
  call void @epoch_block(%struct.ck_epoch* noundef %63, %struct.ck_epoch_record* noundef %64, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* noundef %65, i8* noundef %66), !dbg !859
  store %struct.ck_epoch_record* null, %struct.ck_epoch_record** %7, align 8, !dbg !860
  br label %29, !dbg !816, !llvm.loop !841

67:                                               ; preds = %29
  %68 = load i8, i8* %12, align 1, !dbg !861
  %69 = trunc i8 %68 to i1, !dbg !861
  %70 = zext i1 %69 to i32, !dbg !861
  %71 = icmp eq i32 %70, 0, !dbg !863
  br i1 %71, label %72, label %73, !dbg !864

72:                                               ; preds = %67
  br label %97, !dbg !865

73:                                               ; preds = %67
  %74 = load %struct.ck_epoch*, %struct.ck_epoch** %4, align 8, !dbg !866
  %75 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %74, i32 0, i32 0, !dbg !866
  %76 = load i32, i32* %8, align 4, !dbg !866
  %77 = add i32 %76, 1, !dbg !866
  store i32 %77, i32* %17, align 4, !dbg !866
  %78 = load i32, i32* %8, align 4, !dbg !866
  %79 = load i32, i32* %17, align 4, !dbg !866
  %80 = cmpxchg i32* %75, i32 %78, i32 %79 monotonic monotonic, align 4, !dbg !866
  %81 = extractvalue { i32, i1 } %80, 0, !dbg !866
  %82 = extractvalue { i32, i1 } %80, 1, !dbg !866
  br i1 %82, label %84, label %83, !dbg !866

83:                                               ; preds = %73
  store i32 %81, i32* %8, align 4, !dbg !866
  br label %84, !dbg !866

84:                                               ; preds = %83, %73
  %85 = zext i1 %82 to i8, !dbg !866
  store i8 %85, i8* %18, align 1, !dbg !866
  %86 = load i8, i8* %18, align 1, !dbg !866
  %87 = trunc i8 %86 to i1, !dbg !866
  %88 = zext i1 %87 to i8, !dbg !867
  store i8 %88, i8* %14, align 1, !dbg !867
  fence acquire, !dbg !868
  %89 = load i32, i32* %8, align 4, !dbg !869
  %90 = load i8, i8* %14, align 1, !dbg !870
  %91 = trunc i8 %90 to i1, !dbg !870
  %92 = zext i1 %91 to i32, !dbg !870
  %93 = add i32 %89, %92, !dbg !871
  store i32 %93, i32* %8, align 4, !dbg !872
  br label %94, !dbg !873

94:                                               ; preds = %84
  store %struct.ck_epoch_record* null, %struct.ck_epoch_record** %7, align 8, !dbg !874
  %95 = load i32, i32* %11, align 4, !dbg !875
  %96 = add i32 %95, 1, !dbg !875
  store i32 %96, i32* %11, align 4, !dbg !875
  br label %25, !dbg !876, !llvm.loop !877

97:                                               ; preds = %72, %25
  br label %98, !dbg !878

98:                                               ; preds = %97, %61
  call void @llvm.dbg.label(metadata !879), !dbg !880
  fence seq_cst, !dbg !881
  ret void, !dbg !882
}

; Function Attrs: noinline nounwind ssp uwtable
define internal %struct.ck_epoch_record* @ck_epoch_scan(%struct.ck_epoch* noundef %0, %struct.ck_epoch_record* noundef %1, i32 noundef %2, i8* noundef %3) #0 !dbg !883 {
  %5 = alloca %struct.ck_epoch_record*, align 8
  %6 = alloca %struct.ck_epoch*, align 8
  %7 = alloca %struct.ck_epoch_record*, align 8
  %8 = alloca i32, align 4
  %9 = alloca i8*, align 8
  %10 = alloca %struct.ck_stack_entry*, align 8
  %11 = alloca %struct.ck_stack_entry*, align 8
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  %15 = alloca %struct.ck_stack_entry*, align 8
  %16 = alloca i32, align 4
  %17 = alloca i32, align 4
  %18 = alloca %struct.ck_stack_entry*, align 8
  store %struct.ck_epoch* %0, %struct.ck_epoch** %6, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_epoch** %6, metadata !887, metadata !DIExpression()), !dbg !888
  store %struct.ck_epoch_record* %1, %struct.ck_epoch_record** %7, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_epoch_record** %7, metadata !889, metadata !DIExpression()), !dbg !890
  store i32 %2, i32* %8, align 4
  call void @llvm.dbg.declare(metadata i32* %8, metadata !891, metadata !DIExpression()), !dbg !892
  store i8* %3, i8** %9, align 8
  call void @llvm.dbg.declare(metadata i8** %9, metadata !893, metadata !DIExpression()), !dbg !894
  call void @llvm.dbg.declare(metadata %struct.ck_stack_entry** %10, metadata !895, metadata !DIExpression()), !dbg !896
  %19 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %7, align 8, !dbg !897
  %20 = icmp eq %struct.ck_epoch_record* %19, null, !dbg !899
  br i1 %20, label %21, label %31, !dbg !900

21:                                               ; preds = %4
  %22 = load %struct.ck_epoch*, %struct.ck_epoch** %6, align 8, !dbg !901
  %23 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %22, i32 0, i32 2, !dbg !901
  %24 = getelementptr inbounds %struct.ck_stack, %struct.ck_stack* %23, i32 0, i32 0, !dbg !901
  %25 = bitcast %struct.ck_stack_entry** %24 to i64*, !dbg !901
  %26 = bitcast %struct.ck_stack_entry** %11 to i64*, !dbg !901
  %27 = load atomic i64, i64* %25 monotonic, align 8, !dbg !901
  store i64 %27, i64* %26, align 8, !dbg !901
  %28 = bitcast i64* %26 to %struct.ck_stack_entry**, !dbg !901
  %29 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %28, align 8, !dbg !901
  store %struct.ck_stack_entry* %29, %struct.ck_stack_entry** %10, align 8, !dbg !903
  %30 = load i8*, i8** %9, align 8, !dbg !904
  store i8 0, i8* %30, align 1, !dbg !905
  br label %35, !dbg !906

31:                                               ; preds = %4
  %32 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %7, align 8, !dbg !907
  %33 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %32, i32 0, i32 0, !dbg !909
  store %struct.ck_stack_entry* %33, %struct.ck_stack_entry** %10, align 8, !dbg !910
  %34 = load i8*, i8** %9, align 8, !dbg !911
  store i8 1, i8* %34, align 1, !dbg !912
  br label %35

35:                                               ; preds = %31, %21
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !913
  br label %36, !dbg !914

36:                                               ; preds = %81, %49, %35
  %37 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %10, align 8, !dbg !915
  %38 = icmp ne %struct.ck_stack_entry* %37, null, !dbg !916
  br i1 %38, label %39, label %89, !dbg !914

39:                                               ; preds = %36
  call void @llvm.dbg.declare(metadata i32* %12, metadata !917, metadata !DIExpression()), !dbg !919
  call void @llvm.dbg.declare(metadata i32* %13, metadata !920, metadata !DIExpression()), !dbg !921
  %40 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %10, align 8, !dbg !922
  %41 = call %struct.ck_epoch_record* @ck_epoch_record_container(%struct.ck_stack_entry* noundef %40), !dbg !923
  store %struct.ck_epoch_record* %41, %struct.ck_epoch_record** %7, align 8, !dbg !924
  %42 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %7, align 8, !dbg !925
  %43 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %42, i32 0, i32 2, !dbg !925
  %44 = load atomic i32, i32* %43 monotonic, align 8, !dbg !925
  store i32 %44, i32* %14, align 4, !dbg !925
  %45 = load i32, i32* %14, align 4, !dbg !925
  store i32 %45, i32* %12, align 4, !dbg !926
  %46 = load i32, i32* %12, align 4, !dbg !927
  %47 = and i32 %46, 1, !dbg !929
  %48 = icmp ne i32 %47, 0, !dbg !929
  br i1 %48, label %49, label %57, !dbg !930

49:                                               ; preds = %39
  %50 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %10, align 8, !dbg !931
  %51 = getelementptr inbounds %struct.ck_stack_entry, %struct.ck_stack_entry* %50, i32 0, i32 0, !dbg !931
  %52 = bitcast %struct.ck_stack_entry** %51 to i64*, !dbg !931
  %53 = bitcast %struct.ck_stack_entry** %15 to i64*, !dbg !931
  %54 = load atomic i64, i64* %52 monotonic, align 8, !dbg !931
  store i64 %54, i64* %53, align 8, !dbg !931
  %55 = bitcast i64* %53 to %struct.ck_stack_entry**, !dbg !931
  %56 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %55, align 8, !dbg !931
  store %struct.ck_stack_entry* %56, %struct.ck_stack_entry** %10, align 8, !dbg !933
  br label %36, !dbg !934, !llvm.loop !935

57:                                               ; preds = %39
  %58 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %7, align 8, !dbg !937
  %59 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %58, i32 0, i32 4, !dbg !937
  %60 = load atomic i32, i32* %59 monotonic, align 8, !dbg !937
  store i32 %60, i32* %16, align 4, !dbg !937
  %61 = load i32, i32* %16, align 4, !dbg !937
  store i32 %61, i32* %13, align 4, !dbg !938
  %62 = load i32, i32* %13, align 4, !dbg !939
  %63 = load i8*, i8** %9, align 8, !dbg !940
  %64 = load i8, i8* %63, align 1, !dbg !941
  %65 = trunc i8 %64 to i1, !dbg !941
  %66 = zext i1 %65 to i32, !dbg !941
  %67 = or i32 %66, %62, !dbg !941
  %68 = icmp ne i32 %67, 0, !dbg !941
  %69 = zext i1 %68 to i8, !dbg !941
  store i8 %69, i8* %63, align 1, !dbg !941
  %70 = load i32, i32* %13, align 4, !dbg !942
  %71 = icmp ne i32 %70, 0, !dbg !944
  br i1 %71, label %72, label %81, !dbg !945

72:                                               ; preds = %57
  %73 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %7, align 8, !dbg !946
  %74 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %73, i32 0, i32 3, !dbg !946
  %75 = load atomic i32, i32* %74 monotonic, align 4, !dbg !946
  store i32 %75, i32* %17, align 4, !dbg !946
  %76 = load i32, i32* %17, align 4, !dbg !946
  %77 = load i32, i32* %8, align 4, !dbg !947
  %78 = icmp ne i32 %76, %77, !dbg !948
  br i1 %78, label %79, label %81, !dbg !949

79:                                               ; preds = %72
  %80 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %7, align 8, !dbg !950
  store %struct.ck_epoch_record* %80, %struct.ck_epoch_record** %5, align 8, !dbg !951
  br label %90, !dbg !951

81:                                               ; preds = %72, %57
  %82 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %10, align 8, !dbg !952
  %83 = getelementptr inbounds %struct.ck_stack_entry, %struct.ck_stack_entry* %82, i32 0, i32 0, !dbg !952
  %84 = bitcast %struct.ck_stack_entry** %83 to i64*, !dbg !952
  %85 = bitcast %struct.ck_stack_entry** %18 to i64*, !dbg !952
  %86 = load atomic i64, i64* %84 monotonic, align 8, !dbg !952
  store i64 %86, i64* %85, align 8, !dbg !952
  %87 = bitcast i64* %85 to %struct.ck_stack_entry**, !dbg !952
  %88 = load %struct.ck_stack_entry*, %struct.ck_stack_entry** %87, align 8, !dbg !952
  store %struct.ck_stack_entry* %88, %struct.ck_stack_entry** %10, align 8, !dbg !953
  br label %36, !dbg !914, !llvm.loop !935

89:                                               ; preds = %36
  store %struct.ck_epoch_record* null, %struct.ck_epoch_record** %5, align 8, !dbg !954
  br label %90, !dbg !954

90:                                               ; preds = %89, %79
  %91 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %5, align 8, !dbg !955
  ret %struct.ck_epoch_record* %91, !dbg !955
}

; Function Attrs: noinline nounwind ssp uwtable
define internal void @epoch_block(%struct.ck_epoch* noundef %0, %struct.ck_epoch_record* noundef %1, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* noundef %2, i8* noundef %3) #0 !dbg !956 {
  %5 = alloca %struct.ck_epoch*, align 8
  %6 = alloca %struct.ck_epoch_record*, align 8
  %7 = alloca void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)*, align 8
  %8 = alloca i8*, align 8
  store %struct.ck_epoch* %0, %struct.ck_epoch** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_epoch** %5, metadata !959, metadata !DIExpression()), !dbg !960
  store %struct.ck_epoch_record* %1, %struct.ck_epoch_record** %6, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_epoch_record** %6, metadata !961, metadata !DIExpression()), !dbg !962
  store void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* %2, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)** %7, align 8
  call void @llvm.dbg.declare(metadata void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)** %7, metadata !963, metadata !DIExpression()), !dbg !964
  store i8* %3, i8** %8, align 8
  call void @llvm.dbg.declare(metadata i8** %8, metadata !965, metadata !DIExpression()), !dbg !966
  %9 = load void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)*, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)** %7, align 8, !dbg !967
  %10 = icmp ne void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* %9, null, !dbg !969
  br i1 %10, label %11, label %16, !dbg !970

11:                                               ; preds = %4
  %12 = load void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)*, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)** %7, align 8, !dbg !971
  %13 = load %struct.ck_epoch*, %struct.ck_epoch** %5, align 8, !dbg !972
  %14 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %6, align 8, !dbg !973
  %15 = load i8*, i8** %8, align 8, !dbg !974
  call void %12(%struct.ck_epoch* noundef %13, %struct.ck_epoch_record* noundef %14, i8* noundef %15), !dbg !971
  br label %16, !dbg !971

16:                                               ; preds = %11, %4
  ret void, !dbg !975
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: noinline nounwind ssp uwtable
define void @ck_epoch_synchronize(%struct.ck_epoch_record* noundef %0) #0 !dbg !976 {
  %2 = alloca %struct.ck_epoch_record*, align 8
  store %struct.ck_epoch_record* %0, %struct.ck_epoch_record** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_epoch_record** %2, metadata !977, metadata !DIExpression()), !dbg !978
  %3 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %2, align 8, !dbg !979
  %4 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %3, i32 0, i32 1, !dbg !980
  %5 = load %struct.ck_epoch*, %struct.ck_epoch** %4, align 8, !dbg !980
  call void @ck_epoch_synchronize_wait(%struct.ck_epoch* noundef %5, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* noundef null, i8* noundef null), !dbg !981
  ret void, !dbg !982
}

; Function Attrs: noinline nounwind ssp uwtable
define void @ck_epoch_barrier(%struct.ck_epoch_record* noundef %0) #0 !dbg !983 {
  %2 = alloca %struct.ck_epoch_record*, align 8
  store %struct.ck_epoch_record* %0, %struct.ck_epoch_record** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_epoch_record** %2, metadata !984, metadata !DIExpression()), !dbg !985
  %3 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %2, align 8, !dbg !986
  call void @ck_epoch_synchronize(%struct.ck_epoch_record* noundef %3), !dbg !987
  %4 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %2, align 8, !dbg !988
  call void @ck_epoch_reclaim(%struct.ck_epoch_record* noundef %4), !dbg !989
  ret void, !dbg !990
}

; Function Attrs: noinline nounwind ssp uwtable
define void @ck_epoch_barrier_wait(%struct.ck_epoch_record* noundef %0, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* noundef %1, i8* noundef %2) #0 !dbg !991 {
  %4 = alloca %struct.ck_epoch_record*, align 8
  %5 = alloca void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)*, align 8
  %6 = alloca i8*, align 8
  store %struct.ck_epoch_record* %0, %struct.ck_epoch_record** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_epoch_record** %4, metadata !994, metadata !DIExpression()), !dbg !995
  store void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* %1, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)** %5, align 8
  call void @llvm.dbg.declare(metadata void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)** %5, metadata !996, metadata !DIExpression()), !dbg !997
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !998, metadata !DIExpression()), !dbg !999
  %7 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %4, align 8, !dbg !1000
  %8 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %7, i32 0, i32 1, !dbg !1001
  %9 = load %struct.ck_epoch*, %struct.ck_epoch** %8, align 8, !dbg !1001
  %10 = load void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)*, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)** %5, align 8, !dbg !1002
  %11 = load i8*, i8** %6, align 8, !dbg !1003
  call void @ck_epoch_synchronize_wait(%struct.ck_epoch* noundef %9, void (%struct.ck_epoch*, %struct.ck_epoch_record*, i8*)* noundef %10, i8* noundef %11), !dbg !1004
  %12 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %4, align 8, !dbg !1005
  call void @ck_epoch_reclaim(%struct.ck_epoch_record* noundef %12), !dbg !1006
  ret void, !dbg !1007
}

; Function Attrs: noinline nounwind ssp uwtable
define zeroext i1 @ck_epoch_poll_deferred(%struct.ck_epoch_record* noundef %0, %struct.ck_stack* noundef %1) #0 !dbg !1008 {
  %3 = alloca i1, align 1
  %4 = alloca %struct.ck_epoch_record*, align 8
  %5 = alloca %struct.ck_stack*, align 8
  %6 = alloca i8, align 1
  %7 = alloca i32, align 4
  %8 = alloca %struct.ck_epoch_record*, align 8
  %9 = alloca %struct.ck_epoch*, align 8
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i8, align 1
  %15 = alloca i32, align 4
  %16 = alloca i8, align 1
  store %struct.ck_epoch_record* %0, %struct.ck_epoch_record** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_epoch_record** %4, metadata !1011, metadata !DIExpression()), !dbg !1012
  store %struct.ck_stack* %1, %struct.ck_stack** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_stack** %5, metadata !1013, metadata !DIExpression()), !dbg !1014
  call void @llvm.dbg.declare(metadata i8* %6, metadata !1015, metadata !DIExpression()), !dbg !1016
  call void @llvm.dbg.declare(metadata i32* %7, metadata !1017, metadata !DIExpression()), !dbg !1018
  call void @llvm.dbg.declare(metadata %struct.ck_epoch_record** %8, metadata !1019, metadata !DIExpression()), !dbg !1020
  store %struct.ck_epoch_record* null, %struct.ck_epoch_record** %8, align 8, !dbg !1020
  call void @llvm.dbg.declare(metadata %struct.ck_epoch** %9, metadata !1021, metadata !DIExpression()), !dbg !1022
  %17 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %4, align 8, !dbg !1023
  %18 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %17, i32 0, i32 1, !dbg !1024
  %19 = load %struct.ck_epoch*, %struct.ck_epoch** %18, align 8, !dbg !1024
  store %struct.ck_epoch* %19, %struct.ck_epoch** %9, align 8, !dbg !1022
  call void @llvm.dbg.declare(metadata i32* %10, metadata !1025, metadata !DIExpression()), !dbg !1026
  store i32 0, i32* %10, align 4, !dbg !1026
  %20 = load %struct.ck_epoch*, %struct.ck_epoch** %9, align 8, !dbg !1027
  %21 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %20, i32 0, i32 0, !dbg !1027
  %22 = load atomic i32, i32* %21 monotonic, align 8, !dbg !1027
  store i32 %22, i32* %11, align 4, !dbg !1027
  %23 = load i32, i32* %11, align 4, !dbg !1027
  store i32 %23, i32* %7, align 4, !dbg !1028
  fence seq_cst, !dbg !1029
  %24 = load %struct.ck_epoch*, %struct.ck_epoch** %9, align 8, !dbg !1030
  %25 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %8, align 8, !dbg !1031
  %26 = load i32, i32* %7, align 4, !dbg !1032
  %27 = call %struct.ck_epoch_record* @ck_epoch_scan(%struct.ck_epoch* noundef %24, %struct.ck_epoch_record* noundef %25, i32 noundef %26, i8* noundef %6), !dbg !1033
  store %struct.ck_epoch_record* %27, %struct.ck_epoch_record** %8, align 8, !dbg !1034
  %28 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %8, align 8, !dbg !1035
  %29 = icmp ne %struct.ck_epoch_record* %28, null, !dbg !1037
  br i1 %29, label %30, label %33, !dbg !1038

30:                                               ; preds = %2
  %31 = load i32, i32* %10, align 4, !dbg !1039
  %32 = icmp ugt i32 %31, 0, !dbg !1040
  store i1 %32, i1* %3, align 1, !dbg !1041
  br label %62, !dbg !1041

33:                                               ; preds = %2
  %34 = load i8, i8* %6, align 1, !dbg !1042
  %35 = trunc i8 %34 to i1, !dbg !1042
  %36 = zext i1 %35 to i32, !dbg !1042
  %37 = icmp eq i32 %36, 0, !dbg !1044
  br i1 %37, label %38, label %43, !dbg !1045

38:                                               ; preds = %33
  %39 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %4, align 8, !dbg !1046
  %40 = getelementptr inbounds %struct.ck_epoch_record, %struct.ck_epoch_record* %39, i32 0, i32 3, !dbg !1046
  %41 = load i32, i32* %7, align 4, !dbg !1046
  store i32 %41, i32* %12, align 4, !dbg !1046
  %42 = load i32, i32* %12, align 4, !dbg !1046
  store atomic i32 %42, i32* %40 monotonic, align 4, !dbg !1046
  store i1 true, i1* %3, align 1, !dbg !1048
  br label %62, !dbg !1048

43:                                               ; preds = %33
  call void @llvm.dbg.declare(metadata i32* %13, metadata !1049, metadata !DIExpression()), !dbg !1051
  %44 = load i32, i32* %7, align 4, !dbg !1051
  store i32 %44, i32* %13, align 4, !dbg !1051
  %45 = load %struct.ck_epoch*, %struct.ck_epoch** %9, align 8, !dbg !1051
  %46 = getelementptr inbounds %struct.ck_epoch, %struct.ck_epoch* %45, i32 0, i32 0, !dbg !1051
  %47 = load i32, i32* %7, align 4, !dbg !1051
  %48 = add i32 %47, 1, !dbg !1051
  store i32 %48, i32* %15, align 4, !dbg !1051
  %49 = load i32, i32* %13, align 4, !dbg !1051
  %50 = load i32, i32* %15, align 4, !dbg !1051
  %51 = cmpxchg i32* %46, i32 %49, i32 %50 monotonic monotonic, align 4, !dbg !1051
  %52 = extractvalue { i32, i1 } %51, 0, !dbg !1051
  %53 = extractvalue { i32, i1 } %51, 1, !dbg !1051
  br i1 %53, label %55, label %54, !dbg !1051

54:                                               ; preds = %43
  store i32 %52, i32* %13, align 4, !dbg !1051
  br label %55, !dbg !1051

55:                                               ; preds = %54, %43
  %56 = zext i1 %53 to i8, !dbg !1051
  store i8 %56, i8* %16, align 1, !dbg !1051
  %57 = load i8, i8* %16, align 1, !dbg !1051
  %58 = trunc i8 %57 to i1, !dbg !1051
  %59 = zext i1 %58 to i8, !dbg !1051
  store i8 %59, i8* %14, align 1, !dbg !1051
  %60 = load i8, i8* %14, align 1, !dbg !1051
  %61 = trunc i8 %60 to i1, !dbg !1051
  store i1 true, i1* %3, align 1, !dbg !1052
  br label %62, !dbg !1052

62:                                               ; preds = %55, %38, %30
  %63 = load i1, i1* %3, align 1, !dbg !1053
  ret i1 %63, !dbg !1053
}

; Function Attrs: noinline nounwind ssp uwtable
define zeroext i1 @ck_epoch_poll(%struct.ck_epoch_record* noundef %0) #0 !dbg !1054 {
  %2 = alloca %struct.ck_epoch_record*, align 8
  store %struct.ck_epoch_record* %0, %struct.ck_epoch_record** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.ck_epoch_record** %2, metadata !1057, metadata !DIExpression()), !dbg !1058
  %3 = load %struct.ck_epoch_record*, %struct.ck_epoch_record** %2, align 8, !dbg !1059
  %4 = call zeroext i1 @ck_epoch_poll_deferred(%struct.ck_epoch_record* noundef %3, %struct.ck_stack* noundef null), !dbg !1060
  ret i1 %4, !dbg !1061
}

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
!153 = !DILocation(line: 35, column: 14, scope: !147)
!154 = !DILocalVariable(name: "argv", arg: 2, scope: !147, file: !3, line: 35, type: !150)
!155 = !DILocation(line: 35, column: 26, scope: !147)
!156 = !DILocalVariable(name: "threads", scope: !147, file: !3, line: 37, type: !157)
!157 = !DICompositeType(tag: DW_TAG_array_type, baseType: !158, size: 256, elements: !66)
!158 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !159, line: 31, baseType: !160)
!159 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!160 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !161, line: 118, baseType: !162)
!161 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!162 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !163, size: 64)
!163 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !161, line: 103, size: 65536, elements: !164)
!164 = !{!165, !167, !177}
!165 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !163, file: !161, line: 104, baseType: !166, size: 64)
!166 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!167 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !163, file: !161, line: 105, baseType: !168, size: 64, offset: 64)
!168 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !169, size: 64)
!169 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !161, line: 57, size: 192, elements: !170)
!170 = !{!171, !175, !176}
!171 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !169, file: !161, line: 58, baseType: !172, size: 64)
!172 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !173, size: 64)
!173 = !DISubroutineType(types: !174)
!174 = !{null, !16}
!175 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !169, file: !161, line: 59, baseType: !16, size: 64, offset: 64)
!176 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !169, file: !161, line: 60, baseType: !168, size: 64, offset: 128)
!177 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !163, file: !161, line: 106, baseType: !178, size: 65408, offset: 128)
!178 = !DICompositeType(tag: DW_TAG_array_type, baseType: !44, size: 65408, elements: !179)
!179 = !{!180}
!180 = !DISubrange(count: 8176)
!181 = !DILocation(line: 37, column: 12, scope: !147)
!182 = !DILocation(line: 39, column: 2, scope: !147)
!183 = !DILocation(line: 41, column: 2, scope: !147)
!184 = !DILocalVariable(name: "i", scope: !185, file: !3, line: 42, type: !81)
!185 = distinct !DILexicalBlock(scope: !147, file: !3, line: 42, column: 2)
!186 = !DILocation(line: 42, column: 11, scope: !185)
!187 = !DILocation(line: 42, column: 7, scope: !185)
!188 = !DILocation(line: 42, column: 18, scope: !189)
!189 = distinct !DILexicalBlock(scope: !185, file: !3, line: 42, column: 2)
!190 = !DILocation(line: 42, column: 20, scope: !189)
!191 = !DILocation(line: 42, column: 2, scope: !185)
!192 = !DILocation(line: 43, column: 44, scope: !193)
!193 = distinct !DILexicalBlock(scope: !189, file: !3, line: 42, column: 37)
!194 = !DILocation(line: 43, column: 36, scope: !193)
!195 = !DILocation(line: 43, column: 3, scope: !193)
!196 = !DILocation(line: 44, column: 27, scope: !193)
!197 = !DILocation(line: 44, column: 19, scope: !193)
!198 = !DILocation(line: 44, column: 54, scope: !193)
!199 = !DILocation(line: 44, column: 46, scope: !193)
!200 = !DILocation(line: 44, column: 45, scope: !193)
!201 = !DILocation(line: 44, column: 3, scope: !193)
!202 = !DILocation(line: 45, column: 2, scope: !193)
!203 = !DILocation(line: 42, column: 33, scope: !189)
!204 = !DILocation(line: 42, column: 2, scope: !189)
!205 = distinct !{!205, !191, !206, !207}
!206 = !DILocation(line: 45, column: 2, scope: !185)
!207 = !{!"llvm.loop.mustprogress"}
!208 = !DILocation(line: 47, column: 2, scope: !147)
!209 = distinct !DISubprogram(name: "thread", scope: !3, file: !3, line: 12, type: !210, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !151)
!210 = !DISubroutineType(types: !211)
!211 = !{!16, !16}
!212 = !DILocalVariable(name: "arg", arg: 1, scope: !209, file: !3, line: 12, type: !16)
!213 = !DILocation(line: 12, column: 27, scope: !209)
!214 = !DILocalVariable(name: "record", scope: !209, file: !3, line: 14, type: !17)
!215 = !DILocation(line: 14, column: 21, scope: !209)
!216 = !DILocation(line: 14, column: 51, scope: !209)
!217 = !DILocation(line: 14, column: 30, scope: !209)
!218 = !DILocation(line: 19, column: 17, scope: !209)
!219 = !DILocation(line: 19, column: 2, scope: !209)
!220 = !DILocalVariable(name: "global_epoch", scope: !209, file: !3, line: 20, type: !81)
!221 = !DILocation(line: 20, column: 6, scope: !209)
!222 = !DILocation(line: 20, column: 21, scope: !209)
!223 = !DILocalVariable(name: "local_epoch", scope: !209, file: !3, line: 21, type: !81)
!224 = !DILocation(line: 21, column: 6, scope: !209)
!225 = !DILocation(line: 21, column: 20, scope: !209)
!226 = !DILocation(line: 22, column: 15, scope: !209)
!227 = !DILocation(line: 22, column: 2, scope: !209)
!228 = !DILocation(line: 25, column: 2, scope: !209)
!229 = !DILocation(line: 27, column: 16, scope: !209)
!230 = !DILocation(line: 27, column: 2, scope: !209)
!231 = !DILocation(line: 29, column: 2, scope: !209)
!232 = distinct !DISubprogram(name: "ck_epoch_begin", scope: !19, file: !19, line: 127, type: !233, scopeLine: 128, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !151)
!233 = !DISubroutineType(types: !234)
!234 = !{null, !17, !235}
!235 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !236, size: 64)
!236 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_section_t", file: !19, line: 72, baseType: !237)
!237 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_epoch_section", file: !19, line: 69, size: 32, elements: !238)
!238 = !{!239}
!239 = !DIDerivedType(tag: DW_TAG_member, name: "bucket", scope: !237, file: !19, line: 70, baseType: !7, size: 32)
!240 = !DILocalVariable(name: "record", arg: 1, scope: !232, file: !19, line: 127, type: !17)
!241 = !DILocation(line: 127, column: 35, scope: !232)
!242 = !DILocalVariable(name: "section", arg: 2, scope: !232, file: !19, line: 127, type: !235)
!243 = !DILocation(line: 127, column: 63, scope: !232)
!244 = !DILocalVariable(name: "epoch", scope: !232, file: !19, line: 129, type: !31)
!245 = !DILocation(line: 129, column: 19, scope: !232)
!246 = !DILocation(line: 129, column: 27, scope: !232)
!247 = !DILocation(line: 129, column: 35, scope: !232)
!248 = !DILocation(line: 135, column: 6, scope: !249)
!249 = distinct !DILexicalBlock(scope: !232, file: !19, line: 135, column: 6)
!250 = !DILocation(line: 135, column: 39, scope: !249)
!251 = !DILocation(line: 135, column: 6, scope: !232)
!252 = !DILocalVariable(name: "g_epoch", scope: !253, file: !19, line: 136, type: !7)
!253 = distinct !DILexicalBlock(scope: !249, file: !19, line: 135, column: 45)
!254 = !DILocation(line: 136, column: 16, scope: !253)
!255 = !DILocation(line: 147, column: 3, scope: !253)
!256 = !DILocation(line: 148, column: 3, scope: !253)
!257 = !DILocation(line: 158, column: 13, scope: !253)
!258 = !DILocation(line: 158, column: 11, scope: !253)
!259 = !DILocation(line: 159, column: 3, scope: !253)
!260 = !DILocation(line: 160, column: 2, scope: !253)
!261 = !DILocation(line: 161, column: 3, scope: !262)
!262 = distinct !DILexicalBlock(scope: !249, file: !19, line: 160, column: 9)
!263 = !DILocation(line: 164, column: 6, scope: !264)
!264 = distinct !DILexicalBlock(scope: !232, file: !19, line: 164, column: 6)
!265 = !DILocation(line: 164, column: 14, scope: !264)
!266 = !DILocation(line: 164, column: 6, scope: !232)
!267 = !DILocation(line: 165, column: 20, scope: !264)
!268 = !DILocation(line: 165, column: 28, scope: !264)
!269 = !DILocation(line: 165, column: 3, scope: !264)
!270 = !DILocation(line: 167, column: 2, scope: !232)
!271 = distinct !DISubprogram(name: "ck_epoch_end", scope: !19, file: !19, line: 175, type: !272, scopeLine: 176, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !151)
!272 = !DISubroutineType(types: !273)
!273 = !{!274, !17, !235}
!274 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!275 = !DILocalVariable(name: "record", arg: 1, scope: !271, file: !19, line: 175, type: !17)
!276 = !DILocation(line: 175, column: 33, scope: !271)
!277 = !DILocalVariable(name: "section", arg: 2, scope: !271, file: !19, line: 175, type: !235)
!278 = !DILocation(line: 175, column: 61, scope: !271)
!279 = !DILocation(line: 178, column: 2, scope: !271)
!280 = !DILocation(line: 179, column: 2, scope: !271)
!281 = !DILocation(line: 181, column: 6, scope: !282)
!282 = distinct !DILexicalBlock(scope: !271, file: !19, line: 181, column: 6)
!283 = !DILocation(line: 181, column: 14, scope: !282)
!284 = !DILocation(line: 181, column: 6, scope: !271)
!285 = !DILocation(line: 182, column: 27, scope: !282)
!286 = !DILocation(line: 182, column: 35, scope: !282)
!287 = !DILocation(line: 182, column: 10, scope: !282)
!288 = !DILocation(line: 182, column: 3, scope: !282)
!289 = !DILocation(line: 184, column: 9, scope: !271)
!290 = !DILocation(line: 184, column: 42, scope: !271)
!291 = !DILocation(line: 184, column: 2, scope: !271)
!292 = !DILocation(line: 185, column: 1, scope: !271)
!293 = distinct !DISubprogram(name: "_ck_epoch_delref", scope: !74, file: !74, line: 153, type: !294, scopeLine: 155, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !151)
!294 = !DISubroutineType(types: !295)
!295 = !{!274, !82, !296}
!296 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !297, size: 64)
!297 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_epoch_section", file: !19, line: 69, size: 32, elements: !298)
!298 = !{!299}
!299 = !DIDerivedType(tag: DW_TAG_member, name: "bucket", scope: !297, file: !19, line: 70, baseType: !7, size: 32)
!300 = !DILocalVariable(name: "record", arg: 1, scope: !293, file: !74, line: 153, type: !82)
!301 = !DILocation(line: 153, column: 42, scope: !293)
!302 = !DILocalVariable(name: "section", arg: 2, scope: !293, file: !74, line: 154, type: !296)
!303 = !DILocation(line: 154, column: 30, scope: !293)
!304 = !DILocalVariable(name: "current", scope: !293, file: !74, line: 156, type: !305)
!305 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !112, size: 64)
!306 = !DILocation(line: 156, column: 23, scope: !293)
!307 = !DILocalVariable(name: "other", scope: !293, file: !74, line: 156, type: !305)
!308 = !DILocation(line: 156, column: 33, scope: !293)
!309 = !DILocalVariable(name: "i", scope: !293, file: !74, line: 157, type: !7)
!310 = !DILocation(line: 157, column: 15, scope: !293)
!311 = !DILocation(line: 157, column: 19, scope: !293)
!312 = !DILocation(line: 157, column: 28, scope: !293)
!313 = !DILocation(line: 159, column: 13, scope: !293)
!314 = !DILocation(line: 159, column: 21, scope: !293)
!315 = !DILocation(line: 159, column: 27, scope: !293)
!316 = !DILocation(line: 159, column: 34, scope: !293)
!317 = !DILocation(line: 159, column: 10, scope: !293)
!318 = !DILocation(line: 160, column: 2, scope: !293)
!319 = !DILocation(line: 160, column: 11, scope: !293)
!320 = !DILocation(line: 160, column: 16, scope: !293)
!321 = !DILocation(line: 162, column: 6, scope: !322)
!322 = distinct !DILexicalBlock(scope: !293, file: !74, line: 162, column: 6)
!323 = !DILocation(line: 162, column: 15, scope: !322)
!324 = !DILocation(line: 162, column: 21, scope: !322)
!325 = !DILocation(line: 162, column: 6, scope: !293)
!326 = !DILocation(line: 163, column: 3, scope: !322)
!327 = !DILocation(line: 174, column: 11, scope: !293)
!328 = !DILocation(line: 174, column: 19, scope: !293)
!329 = !DILocation(line: 174, column: 25, scope: !293)
!330 = !DILocation(line: 174, column: 33, scope: !293)
!331 = !DILocation(line: 174, column: 35, scope: !293)
!332 = !DILocation(line: 174, column: 40, scope: !293)
!333 = !DILocation(line: 174, column: 8, scope: !293)
!334 = !DILocation(line: 175, column: 6, scope: !335)
!335 = distinct !DILexicalBlock(scope: !293, file: !74, line: 175, column: 6)
!336 = !DILocation(line: 175, column: 13, scope: !335)
!337 = !DILocation(line: 175, column: 19, scope: !335)
!338 = !DILocation(line: 175, column: 23, scope: !335)
!339 = !DILocation(line: 176, column: 13, scope: !335)
!340 = !DILocation(line: 176, column: 22, scope: !335)
!341 = !DILocation(line: 176, column: 30, scope: !335)
!342 = !DILocation(line: 176, column: 37, scope: !335)
!343 = !DILocation(line: 176, column: 28, scope: !335)
!344 = !DILocation(line: 176, column: 44, scope: !335)
!345 = !DILocation(line: 175, column: 6, scope: !293)
!346 = !DILocation(line: 181, column: 3, scope: !347)
!347 = distinct !DILexicalBlock(scope: !335, file: !74, line: 176, column: 50)
!348 = !DILocation(line: 182, column: 2, scope: !347)
!349 = !DILocation(line: 184, column: 2, scope: !293)
!350 = !DILocation(line: 185, column: 1, scope: !293)
!351 = distinct !DISubprogram(name: "_ck_epoch_addref", scope: !74, file: !74, line: 188, type: !352, scopeLine: 190, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !151)
!352 = !DISubroutineType(types: !353)
!353 = !{null, !82, !296}
!354 = !DILocalVariable(name: "record", arg: 1, scope: !351, file: !74, line: 188, type: !82)
!355 = !DILocation(line: 188, column: 42, scope: !351)
!356 = !DILocalVariable(name: "section", arg: 2, scope: !351, file: !74, line: 189, type: !296)
!357 = !DILocation(line: 189, column: 30, scope: !351)
!358 = !DILocalVariable(name: "global", scope: !351, file: !74, line: 191, type: !93)
!359 = !DILocation(line: 191, column: 19, scope: !351)
!360 = !DILocation(line: 191, column: 28, scope: !351)
!361 = !DILocation(line: 191, column: 36, scope: !351)
!362 = !DILocalVariable(name: "ref", scope: !351, file: !74, line: 192, type: !305)
!363 = !DILocation(line: 192, column: 23, scope: !351)
!364 = !DILocalVariable(name: "epoch", scope: !351, file: !74, line: 193, type: !7)
!365 = !DILocation(line: 193, column: 15, scope: !351)
!366 = !DILocalVariable(name: "i", scope: !351, file: !74, line: 193, type: !7)
!367 = !DILocation(line: 193, column: 22, scope: !351)
!368 = !DILocation(line: 195, column: 10, scope: !351)
!369 = !DILocation(line: 195, column: 8, scope: !351)
!370 = !DILocation(line: 196, column: 6, scope: !351)
!371 = !DILocation(line: 196, column: 12, scope: !351)
!372 = !DILocation(line: 196, column: 4, scope: !351)
!373 = !DILocation(line: 197, column: 9, scope: !351)
!374 = !DILocation(line: 197, column: 17, scope: !351)
!375 = !DILocation(line: 197, column: 23, scope: !351)
!376 = !DILocation(line: 197, column: 30, scope: !351)
!377 = !DILocation(line: 197, column: 6, scope: !351)
!378 = !DILocation(line: 199, column: 6, scope: !379)
!379 = distinct !DILexicalBlock(scope: !351, file: !74, line: 199, column: 6)
!380 = !DILocation(line: 199, column: 11, scope: !379)
!381 = !DILocation(line: 199, column: 16, scope: !379)
!382 = !DILocation(line: 199, column: 19, scope: !379)
!383 = !DILocation(line: 199, column: 6, scope: !351)
!384 = !DILocalVariable(name: "previous", scope: !385, file: !74, line: 201, type: !305)
!385 = distinct !DILexicalBlock(scope: !379, file: !74, line: 199, column: 25)
!386 = !DILocation(line: 201, column: 24, scope: !385)
!387 = !DILocation(line: 213, column: 15, scope: !385)
!388 = !DILocation(line: 213, column: 23, scope: !385)
!389 = !DILocation(line: 213, column: 29, scope: !385)
!390 = !DILocation(line: 213, column: 37, scope: !385)
!391 = !DILocation(line: 213, column: 39, scope: !385)
!392 = !DILocation(line: 213, column: 44, scope: !385)
!393 = !DILocation(line: 213, column: 12, scope: !385)
!394 = !DILocation(line: 215, column: 7, scope: !395)
!395 = distinct !DILexicalBlock(scope: !385, file: !74, line: 215, column: 7)
!396 = !DILocation(line: 215, column: 17, scope: !395)
!397 = !DILocation(line: 215, column: 23, scope: !395)
!398 = !DILocation(line: 215, column: 7, scope: !385)
!399 = !DILocation(line: 216, column: 4, scope: !395)
!400 = !DILocation(line: 223, column: 16, scope: !385)
!401 = !DILocation(line: 223, column: 3, scope: !385)
!402 = !DILocation(line: 223, column: 8, scope: !385)
!403 = !DILocation(line: 223, column: 14, scope: !385)
!404 = !DILocation(line: 224, column: 2, scope: !385)
!405 = !DILocation(line: 226, column: 20, scope: !351)
!406 = !DILocation(line: 226, column: 2, scope: !351)
!407 = !DILocation(line: 226, column: 11, scope: !351)
!408 = !DILocation(line: 226, column: 18, scope: !351)
!409 = !DILocation(line: 227, column: 2, scope: !351)
!410 = distinct !DISubprogram(name: "ck_epoch_init", scope: !74, file: !74, line: 231, type: !411, scopeLine: 232, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !151)
!411 = !DISubroutineType(types: !412)
!412 = !{null, !93}
!413 = !DILocalVariable(name: "global", arg: 1, scope: !410, file: !74, line: 231, type: !93)
!414 = !DILocation(line: 231, column: 32, scope: !410)
!415 = !DILocation(line: 234, column: 17, scope: !410)
!416 = !DILocation(line: 234, column: 25, scope: !410)
!417 = !DILocation(line: 234, column: 2, scope: !410)
!418 = !DILocation(line: 235, column: 2, scope: !410)
!419 = !DILocation(line: 235, column: 10, scope: !410)
!420 = !DILocation(line: 235, column: 16, scope: !410)
!421 = !DILocation(line: 236, column: 2, scope: !410)
!422 = !DILocation(line: 236, column: 10, scope: !410)
!423 = !DILocation(line: 236, column: 17, scope: !410)
!424 = !DILocation(line: 237, column: 2, scope: !410)
!425 = !DILocation(line: 238, column: 2, scope: !410)
!426 = distinct !DISubprogram(name: "ck_stack_init", scope: !24, file: !24, line: 337, type: !427, scopeLine: 338, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !73, retainedNodes: !151)
!427 = !DISubroutineType(types: !428)
!428 = !{null, !429}
!429 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !100, size: 64)
!430 = !DILocalVariable(name: "stack", arg: 1, scope: !426, file: !24, line: 337, type: !429)
!431 = !DILocation(line: 337, column: 32, scope: !426)
!432 = !DILocation(line: 340, column: 2, scope: !426)
!433 = !DILocation(line: 340, column: 9, scope: !426)
!434 = !DILocation(line: 340, column: 14, scope: !426)
!435 = !DILocation(line: 341, column: 2, scope: !426)
!436 = !DILocation(line: 341, column: 9, scope: !426)
!437 = !DILocation(line: 341, column: 20, scope: !426)
!438 = !DILocation(line: 342, column: 2, scope: !426)
!439 = distinct !DISubprogram(name: "ck_epoch_recycle", scope: !74, file: !74, line: 242, type: !440, scopeLine: 243, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !151)
!440 = !DISubroutineType(types: !441)
!441 = !{!442, !93, !16}
!442 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !443, size: 64)
!443 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_record_t", file: !19, line: 101, baseType: !83)
!444 = !DILocalVariable(name: "global", arg: 1, scope: !439, file: !74, line: 242, type: !93)
!445 = !DILocation(line: 242, column: 35, scope: !439)
!446 = !DILocalVariable(name: "ct", arg: 2, scope: !439, file: !74, line: 242, type: !16)
!447 = !DILocation(line: 242, column: 49, scope: !439)
!448 = !DILocalVariable(name: "record", scope: !439, file: !74, line: 244, type: !82)
!449 = !DILocation(line: 244, column: 26, scope: !439)
!450 = !DILocalVariable(name: "cursor", scope: !439, file: !74, line: 245, type: !451)
!451 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !86, size: 64)
!452 = !DILocation(line: 245, column: 20, scope: !439)
!453 = !DILocalVariable(name: "state", scope: !439, file: !74, line: 246, type: !7)
!454 = !DILocation(line: 246, column: 15, scope: !439)
!455 = !DILocation(line: 248, column: 6, scope: !456)
!456 = distinct !DILexicalBlock(scope: !439, file: !74, line: 248, column: 6)
!457 = !DILocation(line: 248, column: 39, scope: !456)
!458 = !DILocation(line: 248, column: 6, scope: !439)
!459 = !DILocation(line: 249, column: 3, scope: !456)
!460 = !DILocation(line: 251, column: 2, scope: !461)
!461 = distinct !DILexicalBlock(scope: !439, file: !74, line: 251, column: 2)
!462 = !DILocation(line: 251, column: 2, scope: !463)
!463 = distinct !DILexicalBlock(scope: !461, file: !74, line: 251, column: 2)
!464 = !DILocation(line: 252, column: 38, scope: !465)
!465 = distinct !DILexicalBlock(scope: !463, file: !74, line: 251, column: 45)
!466 = !DILocation(line: 252, column: 12, scope: !465)
!467 = !DILocation(line: 252, column: 10, scope: !465)
!468 = !DILocation(line: 254, column: 7, scope: !469)
!469 = distinct !DILexicalBlock(scope: !465, file: !74, line: 254, column: 7)
!470 = !DILocation(line: 254, column: 39, scope: !469)
!471 = !DILocation(line: 254, column: 7, scope: !465)
!472 = !DILocation(line: 256, column: 4, scope: !473)
!473 = distinct !DILexicalBlock(scope: !469, file: !74, line: 254, column: 63)
!474 = !DILocation(line: 257, column: 12, scope: !473)
!475 = !DILocation(line: 257, column: 10, scope: !473)
!476 = !DILocation(line: 259, column: 8, scope: !477)
!477 = distinct !DILexicalBlock(scope: !473, file: !74, line: 259, column: 8)
!478 = !DILocation(line: 259, column: 14, scope: !477)
!479 = !DILocation(line: 259, column: 8, scope: !473)
!480 = !DILocation(line: 260, column: 5, scope: !481)
!481 = distinct !DILexicalBlock(scope: !477, file: !74, line: 259, column: 38)
!482 = !DILocation(line: 261, column: 5, scope: !481)
!483 = !DILocation(line: 267, column: 12, scope: !481)
!484 = !DILocation(line: 267, column: 5, scope: !481)
!485 = !DILocation(line: 269, column: 3, scope: !473)
!486 = !DILocation(line: 270, column: 2, scope: !465)
!487 = distinct !{!487, !460, !488, !207}
!488 = !DILocation(line: 270, column: 2, scope: !461)
!489 = !DILocation(line: 272, column: 2, scope: !439)
!490 = !DILocation(line: 273, column: 1, scope: !439)
!491 = distinct !DISubprogram(name: "ck_epoch_record_container", scope: !74, file: !74, line: 145, type: !492, scopeLine: 145, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !73, retainedNodes: !151)
!492 = !DISubroutineType(types: !493)
!493 = !{!82, !451}
!494 = !DILocalVariable(name: "p", arg: 1, scope: !491, file: !74, line: 145, type: !451)
!495 = !DILocation(line: 145, column: 1, scope: !491)
!496 = !DILocalVariable(name: "n", scope: !491, file: !74, line: 145, type: !451)
!497 = distinct !DISubprogram(name: "ck_epoch_register", scope: !74, file: !74, line: 276, type: !498, scopeLine: 278, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !151)
!498 = !DISubroutineType(types: !499)
!499 = !{null, !93, !82, !16}
!500 = !DILocalVariable(name: "global", arg: 1, scope: !497, file: !74, line: 276, type: !93)
!501 = !DILocation(line: 276, column: 36, scope: !497)
!502 = !DILocalVariable(name: "record", arg: 2, scope: !497, file: !74, line: 276, type: !82)
!503 = !DILocation(line: 276, column: 68, scope: !497)
!504 = !DILocalVariable(name: "ct", arg: 3, scope: !497, file: !74, line: 277, type: !16)
!505 = !DILocation(line: 277, column: 11, scope: !497)
!506 = !DILocalVariable(name: "i", scope: !497, file: !74, line: 279, type: !122)
!507 = !DILocation(line: 279, column: 9, scope: !497)
!508 = !DILocation(line: 281, column: 19, scope: !497)
!509 = !DILocation(line: 281, column: 2, scope: !497)
!510 = !DILocation(line: 281, column: 10, scope: !497)
!511 = !DILocation(line: 281, column: 17, scope: !497)
!512 = !DILocation(line: 282, column: 2, scope: !497)
!513 = !DILocation(line: 282, column: 10, scope: !497)
!514 = !DILocation(line: 282, column: 16, scope: !497)
!515 = !DILocation(line: 283, column: 2, scope: !497)
!516 = !DILocation(line: 283, column: 10, scope: !497)
!517 = !DILocation(line: 283, column: 17, scope: !497)
!518 = !DILocation(line: 284, column: 2, scope: !497)
!519 = !DILocation(line: 284, column: 10, scope: !497)
!520 = !DILocation(line: 284, column: 16, scope: !497)
!521 = !DILocation(line: 285, column: 2, scope: !497)
!522 = !DILocation(line: 285, column: 10, scope: !497)
!523 = !DILocation(line: 285, column: 21, scope: !497)
!524 = !DILocation(line: 286, column: 2, scope: !497)
!525 = !DILocation(line: 286, column: 10, scope: !497)
!526 = !DILocation(line: 286, column: 17, scope: !497)
!527 = !DILocation(line: 287, column: 2, scope: !497)
!528 = !DILocation(line: 287, column: 10, scope: !497)
!529 = !DILocation(line: 287, column: 20, scope: !497)
!530 = !DILocation(line: 288, column: 15, scope: !497)
!531 = !DILocation(line: 288, column: 2, scope: !497)
!532 = !DILocation(line: 288, column: 10, scope: !497)
!533 = !DILocation(line: 288, column: 13, scope: !497)
!534 = !DILocation(line: 289, column: 2, scope: !497)
!535 = !DILocation(line: 290, column: 2, scope: !497)
!536 = !DILocation(line: 291, column: 9, scope: !537)
!537 = distinct !DILexicalBlock(scope: !497, file: !74, line: 291, column: 2)
!538 = !DILocation(line: 291, column: 7, scope: !537)
!539 = !DILocation(line: 291, column: 14, scope: !540)
!540 = distinct !DILexicalBlock(scope: !537, file: !74, line: 291, column: 2)
!541 = !DILocation(line: 291, column: 16, scope: !540)
!542 = !DILocation(line: 291, column: 2, scope: !537)
!543 = !DILocation(line: 292, column: 18, scope: !540)
!544 = !DILocation(line: 292, column: 26, scope: !540)
!545 = !DILocation(line: 292, column: 34, scope: !540)
!546 = !DILocation(line: 292, column: 3, scope: !540)
!547 = !DILocation(line: 291, column: 36, scope: !540)
!548 = !DILocation(line: 291, column: 2, scope: !540)
!549 = distinct !{!549, !542, !550, !207}
!550 = !DILocation(line: 292, column: 36, scope: !537)
!551 = !DILocation(line: 294, column: 2, scope: !497)
!552 = !DILocation(line: 295, column: 22, scope: !497)
!553 = !DILocation(line: 295, column: 30, scope: !497)
!554 = !DILocation(line: 295, column: 40, scope: !497)
!555 = !DILocation(line: 295, column: 48, scope: !497)
!556 = !DILocation(line: 295, column: 2, scope: !497)
!557 = !DILocation(line: 296, column: 2, scope: !497)
!558 = distinct !DISubprogram(name: "ck_stack_push_upmc", scope: !24, file: !24, line: 57, type: !559, scopeLine: 58, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !73, retainedNodes: !151)
!559 = !DISubroutineType(types: !560)
!560 = !{null, !429, !91}
!561 = !DILocalVariable(name: "target", arg: 1, scope: !558, file: !24, line: 57, type: !429)
!562 = !DILocation(line: 57, column: 37, scope: !558)
!563 = !DILocalVariable(name: "entry", arg: 2, scope: !558, file: !24, line: 57, type: !91)
!564 = !DILocation(line: 57, column: 68, scope: !558)
!565 = !DILocalVariable(name: "stack", scope: !558, file: !24, line: 59, type: !91)
!566 = !DILocation(line: 59, column: 25, scope: !558)
!567 = !DILocation(line: 61, column: 10, scope: !558)
!568 = !DILocation(line: 61, column: 8, scope: !558)
!569 = !DILocation(line: 62, column: 16, scope: !558)
!570 = !DILocation(line: 62, column: 2, scope: !558)
!571 = !DILocation(line: 62, column: 9, scope: !558)
!572 = !DILocation(line: 62, column: 14, scope: !558)
!573 = !DILocation(line: 63, column: 2, scope: !558)
!574 = !DILocation(line: 65, column: 2, scope: !558)
!575 = !DILocation(line: 65, column: 9, scope: !558)
!576 = !DILocation(line: 65, column: 66, scope: !558)
!577 = !DILocation(line: 66, column: 17, scope: !578)
!578 = distinct !DILexicalBlock(scope: !558, file: !24, line: 65, column: 76)
!579 = !DILocation(line: 66, column: 3, scope: !578)
!580 = !DILocation(line: 66, column: 10, scope: !578)
!581 = !DILocation(line: 66, column: 15, scope: !578)
!582 = !DILocation(line: 67, column: 3, scope: !578)
!583 = distinct !{!583, !574, !584, !207}
!584 = !DILocation(line: 68, column: 2, scope: !558)
!585 = !DILocation(line: 70, column: 2, scope: !558)
!586 = distinct !DISubprogram(name: "ck_epoch_unregister", scope: !74, file: !74, line: 300, type: !587, scopeLine: 301, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !151)
!587 = !DISubroutineType(types: !588)
!588 = !{null, !82}
!589 = !DILocalVariable(name: "record", arg: 1, scope: !586, file: !74, line: 300, type: !82)
!590 = !DILocation(line: 300, column: 45, scope: !586)
!591 = !DILocalVariable(name: "global", scope: !586, file: !74, line: 302, type: !93)
!592 = !DILocation(line: 302, column: 19, scope: !586)
!593 = !DILocation(line: 302, column: 28, scope: !586)
!594 = !DILocation(line: 302, column: 36, scope: !586)
!595 = !DILocalVariable(name: "i", scope: !586, file: !74, line: 303, type: !122)
!596 = !DILocation(line: 303, column: 9, scope: !586)
!597 = !DILocation(line: 305, column: 2, scope: !586)
!598 = !DILocation(line: 305, column: 10, scope: !586)
!599 = !DILocation(line: 305, column: 17, scope: !586)
!600 = !DILocation(line: 306, column: 2, scope: !586)
!601 = !DILocation(line: 306, column: 10, scope: !586)
!602 = !DILocation(line: 306, column: 16, scope: !586)
!603 = !DILocation(line: 307, column: 2, scope: !586)
!604 = !DILocation(line: 307, column: 10, scope: !586)
!605 = !DILocation(line: 307, column: 21, scope: !586)
!606 = !DILocation(line: 308, column: 2, scope: !586)
!607 = !DILocation(line: 308, column: 10, scope: !586)
!608 = !DILocation(line: 308, column: 17, scope: !586)
!609 = !DILocation(line: 309, column: 2, scope: !586)
!610 = !DILocation(line: 309, column: 10, scope: !586)
!611 = !DILocation(line: 309, column: 20, scope: !586)
!612 = !DILocation(line: 310, column: 2, scope: !586)
!613 = !DILocation(line: 312, column: 9, scope: !614)
!614 = distinct !DILexicalBlock(scope: !586, file: !74, line: 312, column: 2)
!615 = !DILocation(line: 312, column: 7, scope: !614)
!616 = !DILocation(line: 312, column: 14, scope: !617)
!617 = distinct !DILexicalBlock(scope: !614, file: !74, line: 312, column: 2)
!618 = !DILocation(line: 312, column: 16, scope: !617)
!619 = !DILocation(line: 312, column: 2, scope: !614)
!620 = !DILocation(line: 313, column: 18, scope: !617)
!621 = !DILocation(line: 313, column: 26, scope: !617)
!622 = !DILocation(line: 313, column: 34, scope: !617)
!623 = !DILocation(line: 313, column: 3, scope: !617)
!624 = !DILocation(line: 312, column: 36, scope: !617)
!625 = !DILocation(line: 312, column: 2, scope: !617)
!626 = distinct !{!626, !619, !627, !207}
!627 = !DILocation(line: 313, column: 36, scope: !614)
!628 = !DILocation(line: 315, column: 2, scope: !586)
!629 = !DILocation(line: 316, column: 2, scope: !586)
!630 = !DILocation(line: 317, column: 2, scope: !586)
!631 = !DILocation(line: 318, column: 2, scope: !586)
!632 = !DILocation(line: 319, column: 2, scope: !586)
!633 = distinct !DISubprogram(name: "ck_epoch_reclaim", scope: !74, file: !74, line: 412, type: !587, scopeLine: 413, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !151)
!634 = !DILocalVariable(name: "record", arg: 1, scope: !633, file: !74, line: 412, type: !82)
!635 = !DILocation(line: 412, column: 42, scope: !633)
!636 = !DILocalVariable(name: "epoch", scope: !633, file: !74, line: 414, type: !7)
!637 = !DILocation(line: 414, column: 15, scope: !633)
!638 = !DILocation(line: 416, column: 13, scope: !639)
!639 = distinct !DILexicalBlock(scope: !633, file: !74, line: 416, column: 2)
!640 = !DILocation(line: 416, column: 7, scope: !639)
!641 = !DILocation(line: 416, column: 18, scope: !642)
!642 = distinct !DILexicalBlock(scope: !639, file: !74, line: 416, column: 2)
!643 = !DILocation(line: 416, column: 24, scope: !642)
!644 = !DILocation(line: 416, column: 2, scope: !639)
!645 = !DILocation(line: 417, column: 21, scope: !642)
!646 = !DILocation(line: 417, column: 29, scope: !642)
!647 = !DILocation(line: 417, column: 3, scope: !642)
!648 = !DILocation(line: 416, column: 48, scope: !642)
!649 = !DILocation(line: 416, column: 2, scope: !642)
!650 = distinct !{!650, !644, !651, !207}
!651 = !DILocation(line: 417, column: 40, scope: !639)
!652 = !DILocation(line: 419, column: 2, scope: !633)
!653 = distinct !DISubprogram(name: "ck_epoch_dispatch", scope: !74, file: !74, line: 371, type: !654, scopeLine: 372, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !73, retainedNodes: !151)
!654 = !DISubroutineType(types: !655)
!655 = !{!7, !82, !7, !656}
!656 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !99, size: 64)
!657 = !DILocalVariable(name: "record", arg: 1, scope: !653, file: !74, line: 371, type: !82)
!658 = !DILocation(line: 371, column: 43, scope: !653)
!659 = !DILocalVariable(name: "e", arg: 2, scope: !653, file: !74, line: 371, type: !7)
!660 = !DILocation(line: 371, column: 64, scope: !653)
!661 = !DILocalVariable(name: "deferred", arg: 3, scope: !653, file: !74, line: 371, type: !656)
!662 = !DILocation(line: 371, column: 79, scope: !653)
!663 = !DILocalVariable(name: "epoch", scope: !653, file: !74, line: 373, type: !7)
!664 = !DILocation(line: 373, column: 15, scope: !653)
!665 = !DILocation(line: 373, column: 23, scope: !653)
!666 = !DILocation(line: 373, column: 25, scope: !653)
!667 = !DILocalVariable(name: "head", scope: !653, file: !74, line: 374, type: !451)
!668 = !DILocation(line: 374, column: 20, scope: !653)
!669 = !DILocalVariable(name: "next", scope: !653, file: !74, line: 374, type: !451)
!670 = !DILocation(line: 374, column: 27, scope: !653)
!671 = !DILocalVariable(name: "cursor", scope: !653, file: !74, line: 374, type: !451)
!672 = !DILocation(line: 374, column: 34, scope: !653)
!673 = !DILocalVariable(name: "n_pending", scope: !653, file: !74, line: 375, type: !7)
!674 = !DILocation(line: 375, column: 15, scope: !653)
!675 = !DILocalVariable(name: "n_peak", scope: !653, file: !74, line: 375, type: !7)
!676 = !DILocation(line: 375, column: 26, scope: !653)
!677 = !DILocalVariable(name: "i", scope: !653, file: !74, line: 376, type: !7)
!678 = !DILocation(line: 376, column: 15, scope: !653)
!679 = !DILocation(line: 378, column: 34, scope: !653)
!680 = !DILocation(line: 378, column: 42, scope: !653)
!681 = !DILocation(line: 378, column: 50, scope: !653)
!682 = !DILocation(line: 378, column: 9, scope: !653)
!683 = !DILocation(line: 378, column: 7, scope: !653)
!684 = !DILocation(line: 379, column: 2, scope: !653)
!685 = !DILocation(line: 380, column: 16, scope: !686)
!686 = distinct !DILexicalBlock(scope: !653, file: !74, line: 380, column: 2)
!687 = !DILocation(line: 380, column: 14, scope: !686)
!688 = !DILocation(line: 380, column: 7, scope: !686)
!689 = !DILocation(line: 380, column: 22, scope: !690)
!690 = distinct !DILexicalBlock(scope: !686, file: !74, line: 380, column: 2)
!691 = !DILocation(line: 380, column: 29, scope: !690)
!692 = !DILocation(line: 380, column: 2, scope: !686)
!693 = !DILocalVariable(name: "entry", scope: !694, file: !74, line: 381, type: !125)
!694 = distinct !DILexicalBlock(scope: !690, file: !74, line: 380, column: 53)
!695 = !DILocation(line: 381, column: 26, scope: !694)
!696 = !DILocation(line: 382, column: 32, scope: !694)
!697 = !DILocation(line: 382, column: 7, scope: !694)
!698 = !DILocation(line: 384, column: 10, scope: !694)
!699 = !DILocation(line: 384, column: 8, scope: !694)
!700 = !DILocation(line: 385, column: 7, scope: !701)
!701 = distinct !DILexicalBlock(scope: !694, file: !74, line: 385, column: 7)
!702 = !DILocation(line: 385, column: 16, scope: !701)
!703 = !DILocation(line: 385, column: 7, scope: !694)
!704 = !DILocation(line: 386, column: 23, scope: !701)
!705 = !DILocation(line: 386, column: 34, scope: !701)
!706 = !DILocation(line: 386, column: 41, scope: !701)
!707 = !DILocation(line: 386, column: 4, scope: !701)
!708 = !DILocation(line: 388, column: 4, scope: !701)
!709 = !DILocation(line: 388, column: 11, scope: !701)
!710 = !DILocation(line: 388, column: 20, scope: !701)
!711 = !DILocation(line: 390, column: 4, scope: !694)
!712 = !DILocation(line: 391, column: 2, scope: !694)
!713 = !DILocation(line: 380, column: 47, scope: !690)
!714 = !DILocation(line: 380, column: 45, scope: !690)
!715 = !DILocation(line: 380, column: 2, scope: !690)
!716 = distinct !{!716, !692, !717, !207}
!717 = !DILocation(line: 391, column: 2, scope: !686)
!718 = !DILocation(line: 393, column: 11, scope: !653)
!719 = !DILocation(line: 393, column: 9, scope: !653)
!720 = !DILocation(line: 394, column: 14, scope: !653)
!721 = !DILocation(line: 394, column: 12, scope: !653)
!722 = !DILocation(line: 397, column: 6, scope: !723)
!723 = distinct !DILexicalBlock(scope: !653, file: !74, line: 397, column: 6)
!724 = !DILocation(line: 397, column: 18, scope: !723)
!725 = !DILocation(line: 397, column: 16, scope: !723)
!726 = !DILocation(line: 397, column: 6, scope: !653)
!727 = !DILocation(line: 398, column: 3, scope: !723)
!728 = !DILocation(line: 400, column: 6, scope: !729)
!729 = distinct !DILexicalBlock(scope: !653, file: !74, line: 400, column: 6)
!730 = !DILocation(line: 400, column: 8, scope: !729)
!731 = !DILocation(line: 400, column: 6, scope: !653)
!732 = !DILocation(line: 401, column: 3, scope: !733)
!733 = distinct !DILexicalBlock(scope: !729, file: !74, line: 400, column: 13)
!734 = !DILocation(line: 402, column: 3, scope: !733)
!735 = !DILocation(line: 403, column: 2, scope: !733)
!736 = !DILocation(line: 405, column: 9, scope: !653)
!737 = !DILocation(line: 405, column: 2, scope: !653)
!738 = distinct !DISubprogram(name: "ck_stack_batch_pop_upmc", scope: !24, file: !24, line: 154, type: !739, scopeLine: 155, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !73, retainedNodes: !151)
!739 = !DISubroutineType(types: !740)
!740 = !{!91, !429}
!741 = !DILocalVariable(name: "target", arg: 1, scope: !738, file: !24, line: 154, type: !429)
!742 = !DILocation(line: 154, column: 42, scope: !738)
!743 = !DILocalVariable(name: "entry", scope: !738, file: !24, line: 156, type: !91)
!744 = !DILocation(line: 156, column: 25, scope: !738)
!745 = !DILocation(line: 158, column: 10, scope: !738)
!746 = !DILocation(line: 158, column: 8, scope: !738)
!747 = !DILocation(line: 159, column: 2, scope: !738)
!748 = !DILocation(line: 160, column: 9, scope: !738)
!749 = !DILocation(line: 160, column: 2, scope: !738)
!750 = distinct !DISubprogram(name: "ck_epoch_entry_container", scope: !74, file: !74, line: 147, type: !751, scopeLine: 147, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !73, retainedNodes: !151)
!751 = !DISubroutineType(types: !752)
!752 = !{!125, !451}
!753 = !DILocalVariable(name: "p", arg: 1, scope: !750, file: !74, line: 147, type: !451)
!754 = !DILocation(line: 147, column: 1, scope: !750)
!755 = !DILocalVariable(name: "n", scope: !750, file: !74, line: 147, type: !451)
!756 = distinct !DISubprogram(name: "ck_stack_push_spnc", scope: !24, file: !24, line: 294, type: !559, scopeLine: 295, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !73, retainedNodes: !151)
!757 = !DILocalVariable(name: "target", arg: 1, scope: !756, file: !24, line: 294, type: !429)
!758 = !DILocation(line: 294, column: 37, scope: !756)
!759 = !DILocalVariable(name: "entry", arg: 2, scope: !756, file: !24, line: 294, type: !91)
!760 = !DILocation(line: 294, column: 68, scope: !756)
!761 = !DILocation(line: 297, column: 16, scope: !756)
!762 = !DILocation(line: 297, column: 24, scope: !756)
!763 = !DILocation(line: 297, column: 2, scope: !756)
!764 = !DILocation(line: 297, column: 9, scope: !756)
!765 = !DILocation(line: 297, column: 14, scope: !756)
!766 = !DILocation(line: 298, column: 17, scope: !756)
!767 = !DILocation(line: 298, column: 2, scope: !756)
!768 = !DILocation(line: 298, column: 10, scope: !756)
!769 = !DILocation(line: 298, column: 15, scope: !756)
!770 = !DILocation(line: 299, column: 2, scope: !756)
!771 = distinct !DISubprogram(name: "ck_epoch_synchronize_wait", scope: !74, file: !74, line: 437, type: !772, scopeLine: 439, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !151)
!772 = !DISubroutineType(types: !773)
!773 = !{null, !93, !774, !16}
!774 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !775, size: 64)
!775 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_wait_cb_t", file: !19, line: 235, baseType: !776)
!776 = !DISubroutineType(types: !777)
!777 = !{null, !778, !442, !16}
!778 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !779, size: 64)
!779 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_t", file: !19, line: 108, baseType: !94)
!780 = !DILocalVariable(name: "global", arg: 1, scope: !771, file: !74, line: 437, type: !93)
!781 = !DILocation(line: 437, column: 44, scope: !771)
!782 = !DILocalVariable(name: "cb", arg: 2, scope: !771, file: !74, line: 438, type: !774)
!783 = !DILocation(line: 438, column: 25, scope: !771)
!784 = !DILocalVariable(name: "ct", arg: 3, scope: !771, file: !74, line: 438, type: !16)
!785 = !DILocation(line: 438, column: 35, scope: !771)
!786 = !DILocalVariable(name: "cr", scope: !771, file: !74, line: 440, type: !82)
!787 = !DILocation(line: 440, column: 26, scope: !771)
!788 = !DILocalVariable(name: "delta", scope: !771, file: !74, line: 441, type: !7)
!789 = !DILocation(line: 441, column: 15, scope: !771)
!790 = !DILocalVariable(name: "epoch", scope: !771, file: !74, line: 441, type: !7)
!791 = !DILocation(line: 441, column: 22, scope: !771)
!792 = !DILocalVariable(name: "goal", scope: !771, file: !74, line: 441, type: !7)
!793 = !DILocation(line: 441, column: 29, scope: !771)
!794 = !DILocalVariable(name: "i", scope: !771, file: !74, line: 441, type: !7)
!795 = !DILocation(line: 441, column: 35, scope: !771)
!796 = !DILocalVariable(name: "active", scope: !771, file: !74, line: 442, type: !274)
!797 = !DILocation(line: 442, column: 7, scope: !771)
!798 = !DILocation(line: 444, column: 2, scope: !771)
!799 = !DILocation(line: 455, column: 18, scope: !771)
!800 = !DILocation(line: 455, column: 16, scope: !771)
!801 = !DILocation(line: 455, column: 8, scope: !771)
!802 = !DILocation(line: 456, column: 9, scope: !771)
!803 = !DILocation(line: 456, column: 15, scope: !771)
!804 = !DILocation(line: 456, column: 7, scope: !771)
!805 = !DILocation(line: 458, column: 9, scope: !806)
!806 = distinct !DILexicalBlock(scope: !771, file: !74, line: 458, column: 2)
!807 = !DILocation(line: 458, column: 17, scope: !806)
!808 = !DILocation(line: 458, column: 7, scope: !806)
!809 = !DILocation(line: 458, column: 25, scope: !810)
!810 = distinct !DILexicalBlock(scope: !806, file: !74, line: 458, column: 2)
!811 = !DILocation(line: 458, column: 27, scope: !810)
!812 = !DILocation(line: 458, column: 2, scope: !806)
!813 = !DILocalVariable(name: "r", scope: !814, file: !74, line: 459, type: !274)
!814 = distinct !DILexicalBlock(scope: !810, file: !74, line: 458, column: 65)
!815 = !DILocation(line: 459, column: 8, scope: !814)
!816 = !DILocation(line: 465, column: 3, scope: !814)
!817 = !DILocation(line: 465, column: 29, scope: !814)
!818 = !DILocation(line: 465, column: 37, scope: !814)
!819 = !DILocation(line: 465, column: 41, scope: !814)
!820 = !DILocation(line: 465, column: 15, scope: !814)
!821 = !DILocation(line: 465, column: 13, scope: !814)
!822 = !DILocation(line: 466, column: 7, scope: !814)
!823 = !DILocation(line: 466, column: 10, scope: !814)
!824 = !DILocalVariable(name: "e_d", scope: !825, file: !74, line: 467, type: !7)
!825 = distinct !DILexicalBlock(scope: !814, file: !74, line: 466, column: 19)
!826 = !DILocation(line: 467, column: 17, scope: !825)
!827 = !DILocation(line: 475, column: 10, scope: !825)
!828 = !DILocation(line: 475, column: 8, scope: !825)
!829 = !DILocation(line: 476, column: 8, scope: !830)
!830 = distinct !DILexicalBlock(scope: !825, file: !74, line: 476, column: 8)
!831 = !DILocation(line: 476, column: 15, scope: !830)
!832 = !DILocation(line: 476, column: 12, scope: !830)
!833 = !DILocation(line: 476, column: 8, scope: !825)
!834 = !DILocation(line: 477, column: 17, scope: !835)
!835 = distinct !DILexicalBlock(scope: !830, file: !74, line: 476, column: 22)
!836 = !DILocation(line: 477, column: 25, scope: !835)
!837 = !DILocation(line: 477, column: 29, scope: !835)
!838 = !DILocation(line: 477, column: 33, scope: !835)
!839 = !DILocation(line: 477, column: 5, scope: !835)
!840 = !DILocation(line: 478, column: 5, scope: !835)
!841 = distinct !{!841, !816, !842, !207}
!842 = !DILocation(line: 497, column: 3, scope: !814)
!843 = !DILocation(line: 485, column: 12, scope: !825)
!844 = !DILocation(line: 485, column: 10, scope: !825)
!845 = !DILocation(line: 486, column: 9, scope: !846)
!846 = distinct !DILexicalBlock(scope: !825, file: !74, line: 486, column: 8)
!847 = !DILocation(line: 486, column: 16, scope: !846)
!848 = !DILocation(line: 486, column: 14, scope: !846)
!849 = !DILocation(line: 486, column: 26, scope: !846)
!850 = !DILocation(line: 486, column: 35, scope: !846)
!851 = !DILocation(line: 486, column: 32, scope: !846)
!852 = !DILocation(line: 486, column: 23, scope: !846)
!853 = !DILocation(line: 486, column: 8, scope: !825)
!854 = !DILocation(line: 487, column: 5, scope: !846)
!855 = !DILocation(line: 489, column: 16, scope: !825)
!856 = !DILocation(line: 489, column: 24, scope: !825)
!857 = !DILocation(line: 489, column: 28, scope: !825)
!858 = !DILocation(line: 489, column: 32, scope: !825)
!859 = !DILocation(line: 489, column: 4, scope: !825)
!860 = !DILocation(line: 496, column: 7, scope: !825)
!861 = !DILocation(line: 503, column: 7, scope: !862)
!862 = distinct !DILexicalBlock(scope: !814, file: !74, line: 503, column: 7)
!863 = !DILocation(line: 503, column: 14, scope: !862)
!864 = !DILocation(line: 503, column: 7, scope: !814)
!865 = !DILocation(line: 504, column: 4, scope: !862)
!866 = !DILocation(line: 517, column: 7, scope: !814)
!867 = !DILocation(line: 517, column: 5, scope: !814)
!868 = !DILocation(line: 521, column: 3, scope: !814)
!869 = !DILocation(line: 527, column: 11, scope: !814)
!870 = !DILocation(line: 527, column: 19, scope: !814)
!871 = !DILocation(line: 527, column: 17, scope: !814)
!872 = !DILocation(line: 527, column: 9, scope: !814)
!873 = !DILocation(line: 528, column: 2, scope: !814)
!874 = !DILocation(line: 458, column: 52, scope: !810)
!875 = !DILocation(line: 458, column: 61, scope: !810)
!876 = !DILocation(line: 458, column: 2, scope: !810)
!877 = distinct !{!877, !812, !878, !207}
!878 = !DILocation(line: 528, column: 2, scope: !806)
!879 = !DILabel(scope: !771, name: "leave", file: !74, line: 535)
!880 = !DILocation(line: 535, column: 1, scope: !771)
!881 = !DILocation(line: 536, column: 2, scope: !771)
!882 = !DILocation(line: 537, column: 2, scope: !771)
!883 = distinct !DISubprogram(name: "ck_epoch_scan", scope: !74, file: !74, line: 323, type: !884, scopeLine: 327, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !73, retainedNodes: !151)
!884 = !DISubroutineType(types: !885)
!885 = !{!82, !93, !82, !7, !886}
!886 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !274, size: 64)
!887 = !DILocalVariable(name: "global", arg: 1, scope: !883, file: !74, line: 323, type: !93)
!888 = !DILocation(line: 323, column: 32, scope: !883)
!889 = !DILocalVariable(name: "cr", arg: 2, scope: !883, file: !74, line: 324, type: !82)
!890 = !DILocation(line: 324, column: 29, scope: !883)
!891 = !DILocalVariable(name: "epoch", arg: 3, scope: !883, file: !74, line: 325, type: !7)
!892 = !DILocation(line: 325, column: 18, scope: !883)
!893 = !DILocalVariable(name: "af", arg: 4, scope: !883, file: !74, line: 326, type: !886)
!894 = !DILocation(line: 326, column: 11, scope: !883)
!895 = !DILocalVariable(name: "cursor", scope: !883, file: !74, line: 328, type: !451)
!896 = !DILocation(line: 328, column: 20, scope: !883)
!897 = !DILocation(line: 330, column: 6, scope: !898)
!898 = distinct !DILexicalBlock(scope: !883, file: !74, line: 330, column: 6)
!899 = !DILocation(line: 330, column: 9, scope: !898)
!900 = !DILocation(line: 330, column: 6, scope: !883)
!901 = !DILocation(line: 331, column: 12, scope: !902)
!902 = distinct !DILexicalBlock(scope: !898, file: !74, line: 330, column: 18)
!903 = !DILocation(line: 331, column: 10, scope: !902)
!904 = !DILocation(line: 337, column: 4, scope: !902)
!905 = !DILocation(line: 337, column: 7, scope: !902)
!906 = !DILocation(line: 338, column: 2, scope: !902)
!907 = !DILocation(line: 339, column: 13, scope: !908)
!908 = distinct !DILexicalBlock(scope: !898, file: !74, line: 338, column: 9)
!909 = !DILocation(line: 339, column: 17, scope: !908)
!910 = !DILocation(line: 339, column: 10, scope: !908)
!911 = !DILocation(line: 340, column: 4, scope: !908)
!912 = !DILocation(line: 340, column: 7, scope: !908)
!913 = !DILocation(line: 343, column: 2, scope: !883)
!914 = !DILocation(line: 344, column: 2, scope: !883)
!915 = !DILocation(line: 344, column: 9, scope: !883)
!916 = !DILocation(line: 344, column: 16, scope: !883)
!917 = !DILocalVariable(name: "state", scope: !918, file: !74, line: 345, type: !7)
!918 = distinct !DILexicalBlock(scope: !883, file: !74, line: 344, column: 25)
!919 = !DILocation(line: 345, column: 16, scope: !918)
!920 = !DILocalVariable(name: "active", scope: !918, file: !74, line: 345, type: !7)
!921 = !DILocation(line: 345, column: 23, scope: !918)
!922 = !DILocation(line: 347, column: 34, scope: !918)
!923 = !DILocation(line: 347, column: 8, scope: !918)
!924 = !DILocation(line: 347, column: 6, scope: !918)
!925 = !DILocation(line: 349, column: 11, scope: !918)
!926 = !DILocation(line: 349, column: 9, scope: !918)
!927 = !DILocation(line: 350, column: 7, scope: !928)
!928 = distinct !DILexicalBlock(scope: !918, file: !74, line: 350, column: 7)
!929 = !DILocation(line: 350, column: 13, scope: !928)
!930 = !DILocation(line: 350, column: 7, scope: !918)
!931 = !DILocation(line: 351, column: 13, scope: !932)
!932 = distinct !DILexicalBlock(scope: !928, file: !74, line: 350, column: 36)
!933 = !DILocation(line: 351, column: 11, scope: !932)
!934 = !DILocation(line: 352, column: 4, scope: !932)
!935 = distinct !{!935, !914, !936, !207}
!936 = !DILocation(line: 365, column: 2, scope: !883)
!937 = !DILocation(line: 355, column: 12, scope: !918)
!938 = !DILocation(line: 355, column: 10, scope: !918)
!939 = !DILocation(line: 356, column: 10, scope: !918)
!940 = !DILocation(line: 356, column: 4, scope: !918)
!941 = !DILocation(line: 356, column: 7, scope: !918)
!942 = !DILocation(line: 358, column: 7, scope: !943)
!943 = distinct !DILexicalBlock(scope: !918, file: !74, line: 358, column: 7)
!944 = !DILocation(line: 358, column: 14, scope: !943)
!945 = !DILocation(line: 358, column: 19, scope: !943)
!946 = !DILocation(line: 358, column: 22, scope: !943)
!947 = !DILocation(line: 358, column: 53, scope: !943)
!948 = !DILocation(line: 358, column: 50, scope: !943)
!949 = !DILocation(line: 358, column: 7, scope: !918)
!950 = !DILocation(line: 359, column: 11, scope: !943)
!951 = !DILocation(line: 359, column: 4, scope: !943)
!952 = !DILocation(line: 361, column: 12, scope: !918)
!953 = !DILocation(line: 361, column: 10, scope: !918)
!954 = !DILocation(line: 367, column: 2, scope: !883)
!955 = !DILocation(line: 368, column: 1, scope: !883)
!956 = distinct !DISubprogram(name: "epoch_block", scope: !74, file: !74, line: 423, type: !957, scopeLine: 425, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !73, retainedNodes: !151)
!957 = !DISubroutineType(types: !958)
!958 = !{null, !93, !82, !774, !16}
!959 = !DILocalVariable(name: "global", arg: 1, scope: !956, file: !74, line: 423, type: !93)
!960 = !DILocation(line: 423, column: 30, scope: !956)
!961 = !DILocalVariable(name: "cr", arg: 2, scope: !956, file: !74, line: 423, type: !82)
!962 = !DILocation(line: 423, column: 62, scope: !956)
!963 = !DILocalVariable(name: "cb", arg: 3, scope: !956, file: !74, line: 424, type: !774)
!964 = !DILocation(line: 424, column: 25, scope: !956)
!965 = !DILocalVariable(name: "ct", arg: 4, scope: !956, file: !74, line: 424, type: !16)
!966 = !DILocation(line: 424, column: 35, scope: !956)
!967 = !DILocation(line: 427, column: 6, scope: !968)
!968 = distinct !DILexicalBlock(scope: !956, file: !74, line: 427, column: 6)
!969 = !DILocation(line: 427, column: 9, scope: !968)
!970 = !DILocation(line: 427, column: 6, scope: !956)
!971 = !DILocation(line: 428, column: 3, scope: !968)
!972 = !DILocation(line: 428, column: 6, scope: !968)
!973 = !DILocation(line: 428, column: 14, scope: !968)
!974 = !DILocation(line: 428, column: 18, scope: !968)
!975 = !DILocation(line: 430, column: 2, scope: !956)
!976 = distinct !DISubprogram(name: "ck_epoch_synchronize", scope: !74, file: !74, line: 541, type: !587, scopeLine: 542, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !151)
!977 = !DILocalVariable(name: "record", arg: 1, scope: !976, file: !74, line: 541, type: !82)
!978 = !DILocation(line: 541, column: 46, scope: !976)
!979 = !DILocation(line: 544, column: 28, scope: !976)
!980 = !DILocation(line: 544, column: 36, scope: !976)
!981 = !DILocation(line: 544, column: 2, scope: !976)
!982 = !DILocation(line: 545, column: 2, scope: !976)
!983 = distinct !DISubprogram(name: "ck_epoch_barrier", scope: !74, file: !74, line: 549, type: !587, scopeLine: 550, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !151)
!984 = !DILocalVariable(name: "record", arg: 1, scope: !983, file: !74, line: 549, type: !82)
!985 = !DILocation(line: 549, column: 42, scope: !983)
!986 = !DILocation(line: 552, column: 23, scope: !983)
!987 = !DILocation(line: 552, column: 2, scope: !983)
!988 = !DILocation(line: 553, column: 19, scope: !983)
!989 = !DILocation(line: 553, column: 2, scope: !983)
!990 = !DILocation(line: 554, column: 2, scope: !983)
!991 = distinct !DISubprogram(name: "ck_epoch_barrier_wait", scope: !74, file: !74, line: 558, type: !992, scopeLine: 560, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !151)
!992 = !DISubroutineType(types: !993)
!993 = !{null, !82, !774, !16}
!994 = !DILocalVariable(name: "record", arg: 1, scope: !991, file: !74, line: 558, type: !82)
!995 = !DILocation(line: 558, column: 47, scope: !991)
!996 = !DILocalVariable(name: "cb", arg: 2, scope: !991, file: !74, line: 558, type: !774)
!997 = !DILocation(line: 558, column: 75, scope: !991)
!998 = !DILocalVariable(name: "ct", arg: 3, scope: !991, file: !74, line: 559, type: !16)
!999 = !DILocation(line: 559, column: 11, scope: !991)
!1000 = !DILocation(line: 562, column: 28, scope: !991)
!1001 = !DILocation(line: 562, column: 36, scope: !991)
!1002 = !DILocation(line: 562, column: 44, scope: !991)
!1003 = !DILocation(line: 562, column: 48, scope: !991)
!1004 = !DILocation(line: 562, column: 2, scope: !991)
!1005 = !DILocation(line: 563, column: 19, scope: !991)
!1006 = !DILocation(line: 563, column: 2, scope: !991)
!1007 = !DILocation(line: 564, column: 2, scope: !991)
!1008 = distinct !DISubprogram(name: "ck_epoch_poll_deferred", scope: !74, file: !74, line: 578, type: !1009, scopeLine: 579, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !151)
!1009 = !DISubroutineType(types: !1010)
!1010 = !{!274, !82, !656}
!1011 = !DILocalVariable(name: "record", arg: 1, scope: !1008, file: !74, line: 578, type: !82)
!1012 = !DILocation(line: 578, column: 48, scope: !1008)
!1013 = !DILocalVariable(name: "deferred", arg: 2, scope: !1008, file: !74, line: 578, type: !656)
!1014 = !DILocation(line: 578, column: 68, scope: !1008)
!1015 = !DILocalVariable(name: "active", scope: !1008, file: !74, line: 583, type: !274)
!1016 = !DILocation(line: 583, column: 7, scope: !1008)
!1017 = !DILocalVariable(name: "epoch", scope: !1008, file: !74, line: 584, type: !7)
!1018 = !DILocation(line: 584, column: 15, scope: !1008)
!1019 = !DILocalVariable(name: "cr", scope: !1008, file: !74, line: 585, type: !82)
!1020 = !DILocation(line: 585, column: 26, scope: !1008)
!1021 = !DILocalVariable(name: "global", scope: !1008, file: !74, line: 586, type: !93)
!1022 = !DILocation(line: 586, column: 19, scope: !1008)
!1023 = !DILocation(line: 586, column: 28, scope: !1008)
!1024 = !DILocation(line: 586, column: 36, scope: !1008)
!1025 = !DILocalVariable(name: "n_dispatch", scope: !1008, file: !74, line: 587, type: !7)
!1026 = !DILocation(line: 587, column: 15, scope: !1008)
!1027 = !DILocation(line: 589, column: 10, scope: !1008)
!1028 = !DILocation(line: 589, column: 8, scope: !1008)
!1029 = !DILocation(line: 592, column: 2, scope: !1008)
!1030 = !DILocation(line: 606, column: 21, scope: !1008)
!1031 = !DILocation(line: 606, column: 29, scope: !1008)
!1032 = !DILocation(line: 606, column: 33, scope: !1008)
!1033 = !DILocation(line: 606, column: 7, scope: !1008)
!1034 = !DILocation(line: 606, column: 5, scope: !1008)
!1035 = !DILocation(line: 607, column: 6, scope: !1036)
!1036 = distinct !DILexicalBlock(scope: !1008, file: !74, line: 607, column: 6)
!1037 = !DILocation(line: 607, column: 9, scope: !1036)
!1038 = !DILocation(line: 607, column: 6, scope: !1008)
!1039 = !DILocation(line: 608, column: 11, scope: !1036)
!1040 = !DILocation(line: 608, column: 22, scope: !1036)
!1041 = !DILocation(line: 608, column: 3, scope: !1036)
!1042 = !DILocation(line: 611, column: 6, scope: !1043)
!1043 = distinct !DILexicalBlock(scope: !1008, file: !74, line: 611, column: 6)
!1044 = !DILocation(line: 611, column: 13, scope: !1043)
!1045 = !DILocation(line: 611, column: 6, scope: !1008)
!1046 = !DILocation(line: 612, column: 3, scope: !1047)
!1047 = distinct !DILexicalBlock(scope: !1043, file: !74, line: 611, column: 23)
!1048 = !DILocation(line: 617, column: 3, scope: !1047)
!1049 = !DILocalVariable(name: "A", scope: !1050, file: !74, line: 628, type: !7)
!1050 = distinct !DILexicalBlock(scope: !1008, file: !74, line: 628, column: 8)
!1051 = !DILocation(line: 628, column: 8, scope: !1050)
!1052 = !DILocation(line: 631, column: 2, scope: !1008)
!1053 = !DILocation(line: 632, column: 1, scope: !1008)
!1054 = distinct !DISubprogram(name: "ck_epoch_poll", scope: !74, file: !74, line: 635, type: !1055, scopeLine: 636, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !151)
!1055 = !DISubroutineType(types: !1056)
!1056 = !{!274, !82}
!1057 = !DILocalVariable(name: "record", arg: 1, scope: !1054, file: !74, line: 635, type: !82)
!1058 = !DILocation(line: 635, column: 39, scope: !1054)
!1059 = !DILocation(line: 638, column: 32, scope: !1054)
!1060 = !DILocation(line: 638, column: 9, scope: !1054)
!1061 = !DILocation(line: 638, column: 2, scope: !1054)
