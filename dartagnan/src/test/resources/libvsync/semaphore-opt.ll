; ModuleID = '/home/drc/git/Dat3M/output/semaphore.ll'
source_filename = "/home/drc/git/libvsync/test/spinlock/semaphore.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.semaphore_s = type { %struct.vatomic32_s }
%struct.vatomic32_s = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_cs_x = internal global i32 0, align 4, !dbg !0
@g_cs_y = internal global i32 0, align 4, !dbg !31
@.str = private unnamed_addr constant [25 x i8] c"g_cs_x and g_cs_y differ\00", align 1
@.str.1 = private unnamed_addr constant [32 x i8] c"a && \22g_cs_x and g_cs_y differ\22\00", align 1
@.str.2 = private unnamed_addr constant [43 x i8] c"./include/test/boilerplate/reader_writer.h\00", align 1
@__PRETTY_FUNCTION__.reader_cs = private unnamed_addr constant [26 x i8] c"void reader_cs(vuint32_t)\00", align 1
@.str.3 = private unnamed_addr constant [17 x i8] c"g_cs_x == g_cs_y\00", align 1
@__PRETTY_FUNCTION__.check = private unnamed_addr constant [17 x i8] c"void check(void)\00", align 1
@.str.4 = private unnamed_addr constant [12 x i8] c"g_cs_x == 2\00", align 1
@g_semaphore = dso_local global %struct.semaphore_s zeroinitializer, align 4, !dbg !18

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !42 {
  ret void, !dbg !46
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !47 {
  ret void, !dbg !48
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @writer_cs(i32 noundef %0) #0 !dbg !49 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !52, metadata !DIExpression()), !dbg !53
  %2 = load i32, i32* @g_cs_x, align 4, !dbg !54
  %3 = add i32 %2, 1, !dbg !54
  store i32 %3, i32* @g_cs_x, align 4, !dbg !54
  %4 = load i32, i32* @g_cs_y, align 4, !dbg !55
  %5 = add i32 %4, 1, !dbg !55
  store i32 %5, i32* @g_cs_y, align 4, !dbg !55
  ret void, !dbg !56
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @reader_cs(i32 noundef %0) #0 !dbg !57 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !58, metadata !DIExpression()), !dbg !59
  %2 = load i32, i32* @g_cs_x, align 4, !dbg !60
  %3 = load i32, i32* @g_cs_y, align 4, !dbg !61
  %4 = icmp eq i32 %2, %3, !dbg !62
  %5 = zext i1 %4 to i32, !dbg !62
  call void @llvm.dbg.value(metadata i32 %5, metadata !63, metadata !DIExpression()), !dbg !59
  br i1 %4, label %7, label %6, !dbg !64

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1, i64 0, i64 0), i8* noundef getelementptr inbounds ([43 x i8], [43 x i8]* @.str.2, i64 0, i64 0), i32 noundef 120, i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @__PRETTY_FUNCTION__.reader_cs, i64 0, i64 0)) #5, !dbg !64
  unreachable, !dbg !64

7:                                                ; preds = %1
  ret void, !dbg !67
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @check() #0 !dbg !68 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !69
  %2 = load i32, i32* @g_cs_y, align 4, !dbg !69
  %3 = icmp eq i32 %1, %2, !dbg !69
  br i1 %3, label %5, label %4, !dbg !72

4:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([43 x i8], [43 x i8]* @.str.2, i64 0, i64 0), i32 noundef 125, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !69
  unreachable, !dbg !69

5:                                                ; preds = %0
  %6 = icmp eq i32 %1, 2, !dbg !73
  br i1 %6, label %8, label %7, !dbg !76

7:                                                ; preds = %5
  call void @__assert_fail(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([43 x i8], [43 x i8]* @.str.2, i64 0, i64 0), i32 noundef 126, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !73
  unreachable, !dbg !73

8:                                                ; preds = %5
  ret void, !dbg !77
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !78 {
  %1 = alloca [4 x i64], align 16
  call void @llvm.dbg.declare(metadata [4 x i64]* %1, metadata !82, metadata !DIExpression()), !dbg !88
  call void @init(), !dbg !89
  call void @llvm.dbg.value(metadata i64 0, metadata !90, metadata !DIExpression()), !dbg !92
  call void @llvm.dbg.value(metadata i64 0, metadata !90, metadata !DIExpression()), !dbg !92
  %2 = getelementptr inbounds [4 x i64], [4 x i64]* %1, i64 0, i64 0, !dbg !93
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @writer, i8* noundef null) #6, !dbg !96
  call void @llvm.dbg.value(metadata i64 1, metadata !90, metadata !DIExpression()), !dbg !92
  call void @llvm.dbg.value(metadata i64 1, metadata !90, metadata !DIExpression()), !dbg !92
  %4 = getelementptr inbounds [4 x i64], [4 x i64]* %1, i64 0, i64 1, !dbg !93
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @writer, i8* noundef inttoptr (i64 1 to i8*)) #6, !dbg !96
  call void @llvm.dbg.value(metadata i64 2, metadata !90, metadata !DIExpression()), !dbg !92
  call void @llvm.dbg.value(metadata i64 2, metadata !90, metadata !DIExpression()), !dbg !92
  call void @llvm.dbg.value(metadata i64 2, metadata !97, metadata !DIExpression()), !dbg !99
  call void @llvm.dbg.value(metadata i64 2, metadata !97, metadata !DIExpression()), !dbg !99
  %6 = getelementptr inbounds [4 x i64], [4 x i64]* %1, i64 0, i64 2, !dbg !100
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @reader, i8* noundef inttoptr (i64 2 to i8*)) #6, !dbg !103
  call void @llvm.dbg.value(metadata i64 3, metadata !97, metadata !DIExpression()), !dbg !99
  call void @llvm.dbg.value(metadata i64 3, metadata !97, metadata !DIExpression()), !dbg !99
  %8 = getelementptr inbounds [4 x i64], [4 x i64]* %1, i64 0, i64 3, !dbg !100
  %9 = call i32 @pthread_create(i64* noundef %8, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @reader, i8* noundef inttoptr (i64 3 to i8*)) #6, !dbg !103
  call void @llvm.dbg.value(metadata i64 4, metadata !97, metadata !DIExpression()), !dbg !99
  call void @llvm.dbg.value(metadata i64 4, metadata !97, metadata !DIExpression()), !dbg !99
  call void @post(), !dbg !104
  call void @llvm.dbg.value(metadata i64 0, metadata !105, metadata !DIExpression()), !dbg !107
  call void @llvm.dbg.value(metadata i64 0, metadata !105, metadata !DIExpression()), !dbg !107
  %10 = load i64, i64* %2, align 8, !dbg !108
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !111
  call void @llvm.dbg.value(metadata i64 1, metadata !105, metadata !DIExpression()), !dbg !107
  call void @llvm.dbg.value(metadata i64 1, metadata !105, metadata !DIExpression()), !dbg !107
  %12 = load i64, i64* %4, align 8, !dbg !108
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !111
  call void @llvm.dbg.value(metadata i64 2, metadata !105, metadata !DIExpression()), !dbg !107
  call void @llvm.dbg.value(metadata i64 2, metadata !105, metadata !DIExpression()), !dbg !107
  %14 = load i64, i64* %6, align 8, !dbg !108
  %15 = call i32 @pthread_join(i64 noundef %14, i8** noundef null), !dbg !111
  call void @llvm.dbg.value(metadata i64 3, metadata !105, metadata !DIExpression()), !dbg !107
  call void @llvm.dbg.value(metadata i64 3, metadata !105, metadata !DIExpression()), !dbg !107
  %16 = load i64, i64* %8, align 8, !dbg !108
  %17 = call i32 @pthread_join(i64 noundef %16, i8** noundef null), !dbg !111
  call void @llvm.dbg.value(metadata i64 4, metadata !105, metadata !DIExpression()), !dbg !107
  call void @llvm.dbg.value(metadata i64 4, metadata !105, metadata !DIExpression()), !dbg !107
  call void @check(), !dbg !112
  call void @fini(), !dbg !113
  ret i32 0, !dbg !114
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !115 {
  call void @semaphore_init(%struct.semaphore_s* noundef @g_semaphore, i32 noundef 4), !dbg !116
  ret void, !dbg !117
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @writer(i8* noundef %0) #0 !dbg !118 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !121, metadata !DIExpression()), !dbg !122
  %2 = ptrtoint i8* %0 to i64, !dbg !123
  %3 = trunc i64 %2 to i32, !dbg !124
  call void @llvm.dbg.value(metadata i32 %3, metadata !125, metadata !DIExpression()), !dbg !122
  call void @writer_acquire(i32 noundef %3), !dbg !126
  call void @writer_cs(i32 noundef %3), !dbg !127
  call void @writer_release(i32 noundef %3), !dbg !128
  ret i8* null, !dbg !129
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @reader(i8* noundef %0) #0 !dbg !130 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !131, metadata !DIExpression()), !dbg !132
  %2 = ptrtoint i8* %0 to i64, !dbg !133
  %3 = trunc i64 %2 to i32, !dbg !134
  call void @llvm.dbg.value(metadata i32 %3, metadata !135, metadata !DIExpression()), !dbg !132
  call void @reader_acquire(i32 noundef %3), !dbg !136
  call void @reader_cs(i32 noundef %3), !dbg !137
  call void @reader_release(i32 noundef %3), !dbg !138
  ret i8* null, !dbg !139
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal void @semaphore_init(%struct.semaphore_s* noundef %0, i32 noundef %1) #0 !dbg !140 {
  call void @llvm.dbg.value(metadata %struct.semaphore_s* %0, metadata !144, metadata !DIExpression()), !dbg !145
  call void @llvm.dbg.value(metadata i32 %1, metadata !146, metadata !DIExpression()), !dbg !145
  %3 = getelementptr inbounds %struct.semaphore_s, %struct.semaphore_s* %0, i32 0, i32 0, !dbg !147
  call void @vatomic32_write(%struct.vatomic32_s* noundef %3, i32 noundef %1), !dbg !148
  ret void, !dbg !149
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @writer_acquire(i32 noundef %0) #0 !dbg !150 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !151, metadata !DIExpression()), !dbg !152
  call void @semaphore_acquire(%struct.semaphore_s* noundef @g_semaphore, i32 noundef 4), !dbg !153
  ret void, !dbg !154
}

; Function Attrs: noinline nounwind uwtable
define internal void @semaphore_acquire(%struct.semaphore_s* noundef %0, i32 noundef %1) #0 !dbg !155 {
  call void @llvm.dbg.value(metadata %struct.semaphore_s* %0, metadata !156, metadata !DIExpression()), !dbg !157
  call void @llvm.dbg.value(metadata i32 %1, metadata !158, metadata !DIExpression()), !dbg !157
  %3 = getelementptr inbounds %struct.semaphore_s, %struct.semaphore_s* %0, i32 0, i32 0, !dbg !159
  %4 = call i32 @vatomic32_await_ge_sub_acq(%struct.vatomic32_s* noundef %3, i32 noundef %1, i32 noundef %1), !dbg !160
  ret void, !dbg !161
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @writer_release(i32 noundef %0) #0 !dbg !162 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !163, metadata !DIExpression()), !dbg !164
  call void @semaphore_release(%struct.semaphore_s* noundef @g_semaphore, i32 noundef 4), !dbg !165
  ret void, !dbg !166
}

; Function Attrs: noinline nounwind uwtable
define internal void @semaphore_release(%struct.semaphore_s* noundef %0, i32 noundef %1) #0 !dbg !167 {
  call void @llvm.dbg.value(metadata %struct.semaphore_s* %0, metadata !168, metadata !DIExpression()), !dbg !169
  call void @llvm.dbg.value(metadata i32 %1, metadata !170, metadata !DIExpression()), !dbg !169
  %3 = getelementptr inbounds %struct.semaphore_s, %struct.semaphore_s* %0, i32 0, i32 0, !dbg !171
  call void @vatomic32_add_rel(%struct.vatomic32_s* noundef %3, i32 noundef %1), !dbg !172
  ret void, !dbg !173
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @reader_acquire(i32 noundef %0) #0 !dbg !174 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !175, metadata !DIExpression()), !dbg !176
  call void @semaphore_acquire(%struct.semaphore_s* noundef @g_semaphore, i32 noundef 1), !dbg !177
  ret void, !dbg !178
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @reader_release(i32 noundef %0) #0 !dbg !179 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !180, metadata !DIExpression()), !dbg !181
  call void @semaphore_release(%struct.semaphore_s* noundef @g_semaphore, i32 noundef 1), !dbg !182
  ret void, !dbg !183
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !184 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !189, metadata !DIExpression()), !dbg !190
  call void @llvm.dbg.value(metadata i32 %1, metadata !191, metadata !DIExpression()), !dbg !190
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !192, !srcloc !193
  %3 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !194
  store atomic i32 %1, i32* %3 seq_cst, align 4, !dbg !195
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !196, !srcloc !197
  ret void, !dbg !198
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_ge_sub_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !199 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !203, metadata !DIExpression()), !dbg !204
  call void @llvm.dbg.value(metadata i32 %1, metadata !205, metadata !DIExpression()), !dbg !204
  call void @llvm.dbg.value(metadata i32 %2, metadata !206, metadata !DIExpression()), !dbg !204
  call void @llvm.dbg.value(metadata i32 0, metadata !207, metadata !DIExpression()), !dbg !204
  %4 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0), !dbg !208
  call void @llvm.dbg.value(metadata i32 %4, metadata !209, metadata !DIExpression()), !dbg !204
  br label %5, !dbg !210

5:                                                ; preds = %11, %3
  %.0 = phi i32 [ %4, %3 ], [ %13, %11 ], !dbg !204
  call void @llvm.dbg.value(metadata i32 %.0, metadata !209, metadata !DIExpression()), !dbg !204
  call void @llvm.dbg.value(metadata i32 %.0, metadata !207, metadata !DIExpression()), !dbg !204
  br label %6, !dbg !211

6:                                                ; preds = %9, %5
  %.01 = phi i32 [ %.0, %5 ], [ %10, %9 ], !dbg !213
  call void @llvm.dbg.value(metadata i32 %.01, metadata !207, metadata !DIExpression()), !dbg !204
  %7 = icmp uge i32 %.01, %1, !dbg !214
  %8 = xor i1 %7, true, !dbg !215
  br i1 %8, label %9, label %11, !dbg !211

9:                                                ; preds = %6
  %10 = call i32 @vatomic32_await_neq_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %.01), !dbg !216
  call void @llvm.dbg.value(metadata i32 %10, metadata !207, metadata !DIExpression()), !dbg !204
  br label %6, !dbg !211, !llvm.loop !218

11:                                               ; preds = %6
  %12 = sub i32 %.01, %2, !dbg !221
  %13 = call i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %0, i32 noundef %.01, i32 noundef %12), !dbg !222
  call void @llvm.dbg.value(metadata i32 %13, metadata !209, metadata !DIExpression()), !dbg !204
  %14 = icmp ne i32 %13, %.01, !dbg !223
  br i1 %14, label %5, label %15, !dbg !224, !llvm.loop !225

15:                                               ; preds = %11
  ret i32 %.01, !dbg !227
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !228 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !231, metadata !DIExpression()), !dbg !232
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !233, !srcloc !234
  %2 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !235
  %3 = load atomic i32, i32* %2 monotonic, align 4, !dbg !236
  call void @llvm.dbg.value(metadata i32 %3, metadata !237, metadata !DIExpression()), !dbg !232
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !238, !srcloc !239
  ret i32 %3, !dbg !240
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_neq_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !241 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !244, metadata !DIExpression()), !dbg !245
  call void @llvm.dbg.value(metadata i32 %1, metadata !246, metadata !DIExpression()), !dbg !245
  call void @llvm.dbg.value(metadata i32 0, metadata !247, metadata !DIExpression()), !dbg !245
  br label %3, !dbg !248

3:                                                ; preds = %3, %2
  %4 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0), !dbg !248
  call void @llvm.dbg.value(metadata i32 %4, metadata !247, metadata !DIExpression()), !dbg !245
  %5 = icmp eq i32 %4, %1, !dbg !248
  br i1 %5, label %3, label %6, !dbg !248, !llvm.loop !249

6:                                                ; preds = %3
  ret i32 %4, !dbg !251
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !252 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !253, metadata !DIExpression()), !dbg !254
  call void @llvm.dbg.value(metadata i32 %1, metadata !255, metadata !DIExpression()), !dbg !254
  call void @llvm.dbg.value(metadata i32 %2, metadata !256, metadata !DIExpression()), !dbg !254
  call void @llvm.dbg.value(metadata i32 %1, metadata !257, metadata !DIExpression()), !dbg !254
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !258, !srcloc !259
  %4 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !260
  %5 = cmpxchg i32* %4, i32 %1, i32 %2 acquire acquire, align 4, !dbg !261
  %6 = extractvalue { i32, i1 } %5, 0, !dbg !261
  %7 = extractvalue { i32, i1 } %5, 1, !dbg !261
  %spec.select = select i1 %7, i32 %1, i32 %6, !dbg !261
  call void @llvm.dbg.value(metadata i32 %spec.select, metadata !257, metadata !DIExpression()), !dbg !254
  %8 = zext i1 %7 to i8, !dbg !261
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !262, !srcloc !263
  ret i32 %spec.select, !dbg !264
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_add_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !265 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !266, metadata !DIExpression()), !dbg !267
  call void @llvm.dbg.value(metadata i32 %1, metadata !268, metadata !DIExpression()), !dbg !267
  %3 = call i32 @vatomic32_get_add_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1), !dbg !269
  ret void, !dbg !270
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_add_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !271 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !272, metadata !DIExpression()), !dbg !273
  call void @llvm.dbg.value(metadata i32 %1, metadata !274, metadata !DIExpression()), !dbg !273
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !275, !srcloc !276
  %3 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !277
  %4 = atomicrmw add i32* %3, i32 %1 release, align 4, !dbg !278
  call void @llvm.dbg.value(metadata i32 %4, metadata !279, metadata !DIExpression()), !dbg !273
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !280, !srcloc !281
  ret i32 %4, !dbg !282
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!34, !35, !36, !37, !38, !39, !40}
!llvm.ident = !{!41}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !33, line: 105, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/drc/git/libvsync/test/spinlock/semaphore.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "79ccc105286dc43649dcbe2066f5d992")
!4 = !{!5, !6, !13}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !7, line: 34, baseType: !8)
!7 = !DIFile(filename: "./include/vsync/vtypes.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "6ac6784bf37e03e28013e7eed706797e")
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !9, line: 26, baseType: !10)
!9 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !11, line: 42, baseType: !12)
!11 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!12 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!13 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuintptr_t", file: !7, line: 36, baseType: !14)
!14 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !15, line: 90, baseType: !16)
!15 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a48e64edacc5b19f56c99745232c963c")
!16 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!17 = !{!18, !0, !31}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "g_semaphore", scope: !2, file: !20, line: 19, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "test/spinlock/semaphore.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "79ccc105286dc43649dcbe2066f5d992")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "semaphore_t", file: !22, line: 22, baseType: !23)
!22 = !DIFile(filename: "./include/vsync/spinlock/semaphore.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "70fe43c1342b6b609b68d58fb396fa39")
!23 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "semaphore_s", file: !22, line: 20, size: 32, elements: !24)
!24 = !{!25}
!25 = !DIDerivedType(tag: DW_TAG_member, name: "s", scope: !23, file: !22, line: 21, baseType: !26, size: 32, align: 32)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !27, line: 62, baseType: !28)
!27 = !DIFile(filename: "./include/vsync/atomic/core.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "1cc0657a82f0605ef67642f178a77e1c")
!28 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !27, line: 60, size: 32, align: 32, elements: !29)
!29 = !{!30}
!30 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !28, file: !27, line: 61, baseType: !6, size: 32)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(name: "g_cs_y", scope: !2, file: !33, line: 106, type: !6, isLocal: true, isDefinition: true)
!33 = !DIFile(filename: "./include/test/boilerplate/reader_writer.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "54e4a8b6c91c55a7191ad9a8296bf783")
!34 = !{i32 7, !"Dwarf Version", i32 5}
!35 = !{i32 2, !"Debug Info Version", i32 3}
!36 = !{i32 1, !"wchar_size", i32 4}
!37 = !{i32 7, !"PIC Level", i32 2}
!38 = !{i32 7, !"PIE Level", i32 2}
!39 = !{i32 7, !"uwtable", i32 1}
!40 = !{i32 7, !"frame-pointer", i32 2}
!41 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!42 = distinct !DISubprogram(name: "post", scope: !33, file: !33, line: 58, type: !43, scopeLine: 59, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!43 = !DISubroutineType(types: !44)
!44 = !{null}
!45 = !{}
!46 = !DILocation(line: 60, column: 1, scope: !42)
!47 = distinct !DISubprogram(name: "fini", scope: !33, file: !33, line: 67, type: !43, scopeLine: 68, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!48 = !DILocation(line: 69, column: 1, scope: !47)
!49 = distinct !DISubprogram(name: "writer_cs", scope: !33, file: !33, line: 109, type: !50, scopeLine: 110, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!50 = !DISubroutineType(types: !51)
!51 = !{null, !6}
!52 = !DILocalVariable(name: "tid", arg: 1, scope: !49, file: !33, line: 109, type: !6)
!53 = !DILocation(line: 0, scope: !49)
!54 = !DILocation(line: 112, column: 8, scope: !49)
!55 = !DILocation(line: 113, column: 8, scope: !49)
!56 = !DILocation(line: 114, column: 1, scope: !49)
!57 = distinct !DISubprogram(name: "reader_cs", scope: !33, file: !33, line: 116, type: !50, scopeLine: 117, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!58 = !DILocalVariable(name: "tid", arg: 1, scope: !57, file: !33, line: 116, type: !6)
!59 = !DILocation(line: 0, scope: !57)
!60 = !DILocation(line: 119, column: 16, scope: !57)
!61 = !DILocation(line: 119, column: 26, scope: !57)
!62 = !DILocation(line: 119, column: 23, scope: !57)
!63 = !DILocalVariable(name: "a", scope: !57, file: !33, line: 119, type: !12)
!64 = !DILocation(line: 120, column: 2, scope: !65)
!65 = distinct !DILexicalBlock(scope: !66, file: !33, line: 120, column: 2)
!66 = distinct !DILexicalBlock(scope: !57, file: !33, line: 120, column: 2)
!67 = !DILocation(line: 121, column: 1, scope: !57)
!68 = distinct !DISubprogram(name: "check", scope: !33, file: !33, line: 123, type: !43, scopeLine: 124, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!69 = !DILocation(line: 125, column: 2, scope: !70)
!70 = distinct !DILexicalBlock(scope: !71, file: !33, line: 125, column: 2)
!71 = distinct !DILexicalBlock(scope: !68, file: !33, line: 125, column: 2)
!72 = !DILocation(line: 125, column: 2, scope: !71)
!73 = !DILocation(line: 126, column: 2, scope: !74)
!74 = distinct !DILexicalBlock(scope: !75, file: !33, line: 126, column: 2)
!75 = distinct !DILexicalBlock(scope: !68, file: !33, line: 126, column: 2)
!76 = !DILocation(line: 126, column: 2, scope: !75)
!77 = !DILocation(line: 127, column: 1, scope: !68)
!78 = distinct !DISubprogram(name: "main", scope: !33, file: !33, line: 153, type: !79, scopeLine: 154, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!79 = !DISubroutineType(types: !80)
!80 = !{!81}
!81 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!82 = !DILocalVariable(name: "t", scope: !78, file: !33, line: 155, type: !83)
!83 = !DICompositeType(tag: DW_TAG_array_type, baseType: !84, size: 256, elements: !86)
!84 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !85, line: 27, baseType: !16)
!85 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!86 = !{!87}
!87 = !DISubrange(count: 4)
!88 = !DILocation(line: 155, column: 12, scope: !78)
!89 = !DILocation(line: 162, column: 2, scope: !78)
!90 = !DILocalVariable(name: "i", scope: !91, file: !33, line: 164, type: !13)
!91 = distinct !DILexicalBlock(scope: !78, file: !33, line: 164, column: 2)
!92 = !DILocation(line: 0, scope: !91)
!93 = !DILocation(line: 165, column: 25, scope: !94)
!94 = distinct !DILexicalBlock(scope: !95, file: !33, line: 164, column: 44)
!95 = distinct !DILexicalBlock(scope: !91, file: !33, line: 164, column: 2)
!96 = !DILocation(line: 165, column: 9, scope: !94)
!97 = !DILocalVariable(name: "i", scope: !98, file: !33, line: 168, type: !13)
!98 = distinct !DILexicalBlock(scope: !78, file: !33, line: 168, column: 2)
!99 = !DILocation(line: 0, scope: !98)
!100 = !DILocation(line: 169, column: 25, scope: !101)
!101 = distinct !DILexicalBlock(scope: !102, file: !33, line: 168, column: 51)
!102 = distinct !DILexicalBlock(scope: !98, file: !33, line: 168, column: 2)
!103 = !DILocation(line: 169, column: 9, scope: !101)
!104 = !DILocation(line: 172, column: 2, scope: !78)
!105 = !DILocalVariable(name: "i", scope: !106, file: !33, line: 174, type: !13)
!106 = distinct !DILexicalBlock(scope: !78, file: !33, line: 174, column: 2)
!107 = !DILocation(line: 0, scope: !106)
!108 = !DILocation(line: 175, column: 22, scope: !109)
!109 = distinct !DILexicalBlock(scope: !110, file: !33, line: 174, column: 44)
!110 = distinct !DILexicalBlock(scope: !106, file: !33, line: 174, column: 2)
!111 = !DILocation(line: 175, column: 9, scope: !109)
!112 = !DILocation(line: 183, column: 2, scope: !78)
!113 = !DILocation(line: 184, column: 2, scope: !78)
!114 = !DILocation(line: 186, column: 2, scope: !78)
!115 = distinct !DISubprogram(name: "init", scope: !20, file: !20, line: 23, type: !43, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!116 = !DILocation(line: 25, column: 2, scope: !115)
!117 = !DILocation(line: 26, column: 1, scope: !115)
!118 = distinct !DISubprogram(name: "writer", scope: !33, file: !33, line: 132, type: !119, scopeLine: 133, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!119 = !DISubroutineType(types: !120)
!120 = !{!5, !5}
!121 = !DILocalVariable(name: "arg", arg: 1, scope: !118, file: !33, line: 132, type: !5)
!122 = !DILocation(line: 0, scope: !118)
!123 = !DILocation(line: 134, column: 29, scope: !118)
!124 = !DILocation(line: 134, column: 18, scope: !118)
!125 = !DILocalVariable(name: "tid", scope: !118, file: !33, line: 134, type: !6)
!126 = !DILocation(line: 135, column: 2, scope: !118)
!127 = !DILocation(line: 136, column: 2, scope: !118)
!128 = !DILocation(line: 137, column: 2, scope: !118)
!129 = !DILocation(line: 138, column: 2, scope: !118)
!130 = distinct !DISubprogram(name: "reader", scope: !33, file: !33, line: 142, type: !119, scopeLine: 143, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!131 = !DILocalVariable(name: "arg", arg: 1, scope: !130, file: !33, line: 142, type: !5)
!132 = !DILocation(line: 0, scope: !130)
!133 = !DILocation(line: 144, column: 29, scope: !130)
!134 = !DILocation(line: 144, column: 18, scope: !130)
!135 = !DILocalVariable(name: "tid", scope: !130, file: !33, line: 144, type: !6)
!136 = !DILocation(line: 145, column: 2, scope: !130)
!137 = !DILocation(line: 146, column: 2, scope: !130)
!138 = !DILocation(line: 147, column: 2, scope: !130)
!139 = !DILocation(line: 149, column: 2, scope: !130)
!140 = distinct !DISubprogram(name: "semaphore_init", scope: !22, file: !22, line: 39, type: !141, scopeLine: 40, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!141 = !DISubroutineType(types: !142)
!142 = !{null, !143, !6}
!143 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64)
!144 = !DILocalVariable(name: "s", arg: 1, scope: !140, file: !22, line: 39, type: !143)
!145 = !DILocation(line: 0, scope: !140)
!146 = !DILocalVariable(name: "n", arg: 2, scope: !140, file: !22, line: 39, type: !6)
!147 = !DILocation(line: 41, column: 22, scope: !140)
!148 = !DILocation(line: 41, column: 2, scope: !140)
!149 = !DILocation(line: 42, column: 1, scope: !140)
!150 = distinct !DISubprogram(name: "writer_acquire", scope: !20, file: !20, line: 29, type: !50, scopeLine: 30, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!151 = !DILocalVariable(name: "tid", arg: 1, scope: !150, file: !20, line: 29, type: !6)
!152 = !DILocation(line: 0, scope: !150)
!153 = !DILocation(line: 32, column: 2, scope: !150)
!154 = !DILocation(line: 33, column: 1, scope: !150)
!155 = distinct !DISubprogram(name: "semaphore_acquire", scope: !22, file: !22, line: 54, type: !141, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!156 = !DILocalVariable(name: "s", arg: 1, scope: !155, file: !22, line: 54, type: !143)
!157 = !DILocation(line: 0, scope: !155)
!158 = !DILocalVariable(name: "i", arg: 2, scope: !155, file: !22, line: 54, type: !6)
!159 = !DILocation(line: 59, column: 33, scope: !155)
!160 = !DILocation(line: 59, column: 2, scope: !155)
!161 = !DILocation(line: 60, column: 1, scope: !155)
!162 = distinct !DISubprogram(name: "writer_release", scope: !20, file: !20, line: 36, type: !50, scopeLine: 37, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!163 = !DILocalVariable(name: "tid", arg: 1, scope: !162, file: !20, line: 36, type: !6)
!164 = !DILocation(line: 0, scope: !162)
!165 = !DILocation(line: 39, column: 2, scope: !162)
!166 = !DILocation(line: 40, column: 1, scope: !162)
!167 = distinct !DISubprogram(name: "semaphore_release", scope: !22, file: !22, line: 87, type: !141, scopeLine: 88, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!168 = !DILocalVariable(name: "s", arg: 1, scope: !167, file: !22, line: 87, type: !143)
!169 = !DILocation(line: 0, scope: !167)
!170 = !DILocalVariable(name: "i", arg: 2, scope: !167, file: !22, line: 87, type: !6)
!171 = !DILocation(line: 89, column: 24, scope: !167)
!172 = !DILocation(line: 89, column: 2, scope: !167)
!173 = !DILocation(line: 90, column: 1, scope: !167)
!174 = distinct !DISubprogram(name: "reader_acquire", scope: !20, file: !20, line: 42, type: !50, scopeLine: 43, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!175 = !DILocalVariable(name: "tid", arg: 1, scope: !174, file: !20, line: 42, type: !6)
!176 = !DILocation(line: 0, scope: !174)
!177 = !DILocation(line: 45, column: 2, scope: !174)
!178 = !DILocation(line: 46, column: 1, scope: !174)
!179 = distinct !DISubprogram(name: "reader_release", scope: !20, file: !20, line: 49, type: !50, scopeLine: 50, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!180 = !DILocalVariable(name: "tid", arg: 1, scope: !179, file: !20, line: 49, type: !6)
!181 = !DILocation(line: 0, scope: !179)
!182 = !DILocation(line: 52, column: 2, scope: !179)
!183 = !DILocation(line: 53, column: 1, scope: !179)
!184 = distinct !DISubprogram(name: "vatomic32_write", scope: !185, file: !185, line: 425, type: !186, scopeLine: 426, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!185 = !DIFile(filename: "./include/vsync/atomic/internal/builtins.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "31d9a9647b315cadb2f817a7c8e98ecf")
!186 = !DISubroutineType(types: !187)
!187 = !{null, !188, !6}
!188 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !26, size: 64)
!189 = !DILocalVariable(name: "a", arg: 1, scope: !184, file: !185, line: 425, type: !188)
!190 = !DILocation(line: 0, scope: !184)
!191 = !DILocalVariable(name: "v", arg: 2, scope: !184, file: !185, line: 425, type: !6)
!192 = !DILocation(line: 427, column: 2, scope: !184)
!193 = !{i64 2147853445}
!194 = !DILocation(line: 428, column: 23, scope: !184)
!195 = !DILocation(line: 428, column: 2, scope: !184)
!196 = !DILocation(line: 429, column: 2, scope: !184)
!197 = !{i64 2147853491}
!198 = !DILocation(line: 430, column: 1, scope: !184)
!199 = distinct !DISubprogram(name: "vatomic32_await_ge_sub_acq", scope: !200, file: !200, line: 5628, type: !201, scopeLine: 5629, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!200 = !DIFile(filename: "./include/vsync/atomic/internal/fallback.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "bfc5d50ad810da3af0d582a48b47498f")
!201 = !DISubroutineType(types: !202)
!202 = !{!6, !188, !6, !6}
!203 = !DILocalVariable(name: "a", arg: 1, scope: !199, file: !200, line: 5628, type: !188)
!204 = !DILocation(line: 0, scope: !199)
!205 = !DILocalVariable(name: "c", arg: 2, scope: !199, file: !200, line: 5628, type: !6)
!206 = !DILocalVariable(name: "v", arg: 3, scope: !199, file: !200, line: 5628, type: !6)
!207 = !DILocalVariable(name: "cur", scope: !199, file: !200, line: 5630, type: !6)
!208 = !DILocation(line: 5631, column: 18, scope: !199)
!209 = !DILocalVariable(name: "old", scope: !199, file: !200, line: 5631, type: !6)
!210 = !DILocation(line: 5632, column: 2, scope: !199)
!211 = !DILocation(line: 5634, column: 3, scope: !212)
!212 = distinct !DILexicalBlock(scope: !199, file: !200, line: 5632, column: 5)
!213 = !DILocation(line: 0, scope: !212)
!214 = !DILocation(line: 5634, column: 16, scope: !212)
!215 = !DILocation(line: 5634, column: 10, scope: !212)
!216 = !DILocation(line: 5635, column: 10, scope: !217)
!217 = distinct !DILexicalBlock(scope: !212, file: !200, line: 5634, column: 23)
!218 = distinct !{!218, !211, !219, !220}
!219 = !DILocation(line: 5636, column: 3, scope: !212)
!220 = !{!"llvm.loop.mustprogress"}
!221 = !DILocation(line: 5637, column: 52, scope: !199)
!222 = !DILocation(line: 5637, column: 18, scope: !199)
!223 = !DILocation(line: 5637, column: 58, scope: !199)
!224 = !DILocation(line: 5637, column: 2, scope: !212)
!225 = distinct !{!225, !210, !226, !220}
!226 = !DILocation(line: 5637, column: 64, scope: !199)
!227 = !DILocation(line: 5638, column: 2, scope: !199)
!228 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !185, file: !185, line: 193, type: !229, scopeLine: 194, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!229 = !DISubroutineType(types: !230)
!230 = !{!6, !188}
!231 = !DILocalVariable(name: "a", arg: 1, scope: !228, file: !185, line: 193, type: !188)
!232 = !DILocation(line: 0, scope: !228)
!233 = !DILocation(line: 195, column: 2, scope: !228)
!234 = !{i64 2147852101}
!235 = !DILocation(line: 197, column: 7, scope: !228)
!236 = !DILocation(line: 196, column: 29, scope: !228)
!237 = !DILocalVariable(name: "tmp", scope: !228, file: !185, line: 196, type: !6)
!238 = !DILocation(line: 198, column: 2, scope: !228)
!239 = !{i64 2147852147}
!240 = !DILocation(line: 199, column: 2, scope: !228)
!241 = distinct !DISubprogram(name: "vatomic32_await_neq_rlx", scope: !200, file: !200, line: 4267, type: !242, scopeLine: 4268, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!242 = !DISubroutineType(types: !243)
!243 = !{!6, !188, !6}
!244 = !DILocalVariable(name: "a", arg: 1, scope: !241, file: !200, line: 4267, type: !188)
!245 = !DILocation(line: 0, scope: !241)
!246 = !DILocalVariable(name: "c", arg: 2, scope: !241, file: !200, line: 4267, type: !6)
!247 = !DILocalVariable(name: "cur", scope: !241, file: !200, line: 4269, type: !6)
!248 = !DILocation(line: 4270, column: 2, scope: !241)
!249 = distinct !{!249, !248, !250, !220}
!250 = !DILocation(line: 4272, column: 2, scope: !241)
!251 = !DILocation(line: 4273, column: 2, scope: !241)
!252 = distinct !DISubprogram(name: "vatomic32_cmpxchg_acq", scope: !185, file: !185, line: 1102, type: !201, scopeLine: 1103, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!253 = !DILocalVariable(name: "a", arg: 1, scope: !252, file: !185, line: 1102, type: !188)
!254 = !DILocation(line: 0, scope: !252)
!255 = !DILocalVariable(name: "e", arg: 2, scope: !252, file: !185, line: 1102, type: !6)
!256 = !DILocalVariable(name: "v", arg: 3, scope: !252, file: !185, line: 1102, type: !6)
!257 = !DILocalVariable(name: "exp", scope: !252, file: !185, line: 1104, type: !6)
!258 = !DILocation(line: 1105, column: 2, scope: !252)
!259 = !{i64 2147857297}
!260 = !DILocation(line: 1106, column: 34, scope: !252)
!261 = !DILocation(line: 1106, column: 2, scope: !252)
!262 = !DILocation(line: 1109, column: 2, scope: !252)
!263 = !{i64 2147857351}
!264 = !DILocation(line: 1110, column: 2, scope: !252)
!265 = distinct !DISubprogram(name: "vatomic32_add_rel", scope: !200, file: !200, line: 2303, type: !186, scopeLine: 2304, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!266 = !DILocalVariable(name: "a", arg: 1, scope: !265, file: !200, line: 2303, type: !188)
!267 = !DILocation(line: 0, scope: !265)
!268 = !DILocalVariable(name: "v", arg: 2, scope: !265, file: !200, line: 2303, type: !6)
!269 = !DILocation(line: 2305, column: 8, scope: !265)
!270 = !DILocation(line: 2306, column: 1, scope: !265)
!271 = distinct !DISubprogram(name: "vatomic32_get_add_rel", scope: !185, file: !185, line: 2423, type: !242, scopeLine: 2424, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!272 = !DILocalVariable(name: "a", arg: 1, scope: !271, file: !185, line: 2423, type: !188)
!273 = !DILocation(line: 0, scope: !271)
!274 = !DILocalVariable(name: "v", arg: 2, scope: !271, file: !185, line: 2423, type: !6)
!275 = !DILocation(line: 2425, column: 2, scope: !271)
!276 = !{i64 2147864557}
!277 = !DILocation(line: 2427, column: 7, scope: !271)
!278 = !DILocation(line: 2426, column: 29, scope: !271)
!279 = !DILocalVariable(name: "tmp", scope: !271, file: !185, line: 2426, type: !6)
!280 = !DILocation(line: 2428, column: 2, scope: !271)
!281 = !{i64 2147864603}
!282 = !DILocation(line: 2429, column: 2, scope: !271)
