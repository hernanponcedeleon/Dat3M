; ModuleID = '/home/drc/git/Dat3M/output/rwlock.ll'
source_filename = "/home/drc/git/libvsync/test/spinlock/rwlock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.rwlock_s = type { i32, %struct.vatomic32_s, %struct.semaphore_s }
%struct.vatomic32_s = type { i32 }
%struct.semaphore_s = type { %struct.vatomic32_s }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_cs_x = internal global i32 0, align 4, !dbg !0
@g_cs_y = internal global i32 0, align 4, !dbg !38
@.str = private unnamed_addr constant [25 x i8] c"g_cs_x and g_cs_y differ\00", align 1
@.str.1 = private unnamed_addr constant [32 x i8] c"a && \22g_cs_x and g_cs_y differ\22\00", align 1
@.str.2 = private unnamed_addr constant [43 x i8] c"./include/test/boilerplate/reader_writer.h\00", align 1
@__PRETTY_FUNCTION__.reader_cs = private unnamed_addr constant [26 x i8] c"void reader_cs(vuint32_t)\00", align 1
@.str.3 = private unnamed_addr constant [17 x i8] c"g_cs_x == g_cs_y\00", align 1
@__PRETTY_FUNCTION__.check = private unnamed_addr constant [17 x i8] c"void check(void)\00", align 1
@.str.4 = private unnamed_addr constant [12 x i8] c"g_cs_x == 2\00", align 1
@lock = dso_local global %struct.rwlock_s { i32 1073741824, %struct.vatomic32_s zeroinitializer, %struct.semaphore_s { %struct.vatomic32_s { i32 1073741824 } } }, align 4, !dbg !18

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !49 {
  ret void, !dbg !53
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !54 {
  ret void, !dbg !55
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !56 {
  ret void, !dbg !57
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @writer_cs(i32 noundef %0) #0 !dbg !58 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !61, metadata !DIExpression()), !dbg !62
  %2 = load i32, i32* @g_cs_x, align 4, !dbg !63
  %3 = add i32 %2, 1, !dbg !63
  store i32 %3, i32* @g_cs_x, align 4, !dbg !63
  %4 = load i32, i32* @g_cs_y, align 4, !dbg !64
  %5 = add i32 %4, 1, !dbg !64
  store i32 %5, i32* @g_cs_y, align 4, !dbg !64
  ret void, !dbg !65
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @reader_cs(i32 noundef %0) #0 !dbg !66 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !67, metadata !DIExpression()), !dbg !68
  %2 = load i32, i32* @g_cs_x, align 4, !dbg !69
  %3 = load i32, i32* @g_cs_y, align 4, !dbg !70
  %4 = icmp eq i32 %2, %3, !dbg !71
  %5 = zext i1 %4 to i32, !dbg !71
  call void @llvm.dbg.value(metadata i32 %5, metadata !72, metadata !DIExpression()), !dbg !68
  br i1 %4, label %7, label %6, !dbg !73

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1, i64 0, i64 0), i8* noundef getelementptr inbounds ([43 x i8], [43 x i8]* @.str.2, i64 0, i64 0), i32 noundef 120, i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @__PRETTY_FUNCTION__.reader_cs, i64 0, i64 0)) #5, !dbg !73
  unreachable, !dbg !73

7:                                                ; preds = %1
  ret void, !dbg !76
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @check() #0 !dbg !77 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !78
  %2 = load i32, i32* @g_cs_y, align 4, !dbg !78
  %3 = icmp eq i32 %1, %2, !dbg !78
  br i1 %3, label %5, label %4, !dbg !81

4:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([43 x i8], [43 x i8]* @.str.2, i64 0, i64 0), i32 noundef 125, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !78
  unreachable, !dbg !78

5:                                                ; preds = %0
  %6 = icmp eq i32 %1, 2, !dbg !82
  br i1 %6, label %8, label %7, !dbg !85

7:                                                ; preds = %5
  call void @__assert_fail(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([43 x i8], [43 x i8]* @.str.2, i64 0, i64 0), i32 noundef 126, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !82
  unreachable, !dbg !82

8:                                                ; preds = %5
  ret void, !dbg !86
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !87 {
  %1 = alloca [4 x i64], align 16
  call void @llvm.dbg.declare(metadata [4 x i64]* %1, metadata !91, metadata !DIExpression()), !dbg !97
  call void @init(), !dbg !98
  call void @llvm.dbg.value(metadata i64 0, metadata !99, metadata !DIExpression()), !dbg !101
  call void @llvm.dbg.value(metadata i64 0, metadata !99, metadata !DIExpression()), !dbg !101
  %2 = getelementptr inbounds [4 x i64], [4 x i64]* %1, i64 0, i64 0, !dbg !102
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @writer, i8* noundef null) #6, !dbg !105
  call void @llvm.dbg.value(metadata i64 1, metadata !99, metadata !DIExpression()), !dbg !101
  call void @llvm.dbg.value(metadata i64 1, metadata !99, metadata !DIExpression()), !dbg !101
  %4 = getelementptr inbounds [4 x i64], [4 x i64]* %1, i64 0, i64 1, !dbg !102
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @writer, i8* noundef inttoptr (i64 1 to i8*)) #6, !dbg !105
  call void @llvm.dbg.value(metadata i64 2, metadata !99, metadata !DIExpression()), !dbg !101
  call void @llvm.dbg.value(metadata i64 2, metadata !99, metadata !DIExpression()), !dbg !101
  call void @llvm.dbg.value(metadata i64 2, metadata !106, metadata !DIExpression()), !dbg !108
  call void @llvm.dbg.value(metadata i64 2, metadata !106, metadata !DIExpression()), !dbg !108
  %6 = getelementptr inbounds [4 x i64], [4 x i64]* %1, i64 0, i64 2, !dbg !109
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @reader, i8* noundef inttoptr (i64 2 to i8*)) #6, !dbg !112
  call void @llvm.dbg.value(metadata i64 3, metadata !106, metadata !DIExpression()), !dbg !108
  call void @llvm.dbg.value(metadata i64 3, metadata !106, metadata !DIExpression()), !dbg !108
  %8 = getelementptr inbounds [4 x i64], [4 x i64]* %1, i64 0, i64 3, !dbg !109
  %9 = call i32 @pthread_create(i64* noundef %8, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @reader, i8* noundef inttoptr (i64 3 to i8*)) #6, !dbg !112
  call void @llvm.dbg.value(metadata i64 4, metadata !106, metadata !DIExpression()), !dbg !108
  call void @llvm.dbg.value(metadata i64 4, metadata !106, metadata !DIExpression()), !dbg !108
  call void @post(), !dbg !113
  call void @llvm.dbg.value(metadata i64 0, metadata !114, metadata !DIExpression()), !dbg !116
  call void @llvm.dbg.value(metadata i64 0, metadata !114, metadata !DIExpression()), !dbg !116
  %10 = load i64, i64* %2, align 8, !dbg !117
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !120
  call void @llvm.dbg.value(metadata i64 1, metadata !114, metadata !DIExpression()), !dbg !116
  call void @llvm.dbg.value(metadata i64 1, metadata !114, metadata !DIExpression()), !dbg !116
  %12 = load i64, i64* %4, align 8, !dbg !117
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !120
  call void @llvm.dbg.value(metadata i64 2, metadata !114, metadata !DIExpression()), !dbg !116
  call void @llvm.dbg.value(metadata i64 2, metadata !114, metadata !DIExpression()), !dbg !116
  %14 = load i64, i64* %6, align 8, !dbg !117
  %15 = call i32 @pthread_join(i64 noundef %14, i8** noundef null), !dbg !120
  call void @llvm.dbg.value(metadata i64 3, metadata !114, metadata !DIExpression()), !dbg !116
  call void @llvm.dbg.value(metadata i64 3, metadata !114, metadata !DIExpression()), !dbg !116
  %16 = load i64, i64* %8, align 8, !dbg !117
  %17 = call i32 @pthread_join(i64 noundef %16, i8** noundef null), !dbg !120
  call void @llvm.dbg.value(metadata i64 4, metadata !114, metadata !DIExpression()), !dbg !116
  call void @llvm.dbg.value(metadata i64 4, metadata !114, metadata !DIExpression()), !dbg !116
  call void @check(), !dbg !121
  call void @fini(), !dbg !122
  ret i32 0, !dbg !123
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @writer(i8* noundef %0) #0 !dbg !124 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !127, metadata !DIExpression()), !dbg !128
  %2 = ptrtoint i8* %0 to i64, !dbg !129
  %3 = trunc i64 %2 to i32, !dbg !130
  call void @llvm.dbg.value(metadata i32 %3, metadata !131, metadata !DIExpression()), !dbg !128
  call void @writer_acquire(i32 noundef %3), !dbg !132
  call void @writer_cs(i32 noundef %3), !dbg !133
  call void @writer_release(i32 noundef %3), !dbg !134
  ret i8* null, !dbg !135
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @reader(i8* noundef %0) #0 !dbg !136 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !137, metadata !DIExpression()), !dbg !138
  %2 = ptrtoint i8* %0 to i64, !dbg !139
  %3 = trunc i64 %2 to i32, !dbg !140
  call void @llvm.dbg.value(metadata i32 %3, metadata !141, metadata !DIExpression()), !dbg !138
  call void @reader_acquire(i32 noundef %3), !dbg !142
  call void @reader_cs(i32 noundef %3), !dbg !143
  call void @reader_release(i32 noundef %3), !dbg !144
  ret i8* null, !dbg !145
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @writer_acquire(i32 noundef %0) #0 !dbg !146 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !147, metadata !DIExpression()), !dbg !148
  call void @rwlock_write_acquire(%struct.rwlock_s* noundef @lock), !dbg !149
  ret void, !dbg !150
}

; Function Attrs: noinline nounwind uwtable
define internal void @rwlock_write_acquire(%struct.rwlock_s* noundef %0) #0 !dbg !151 {
  call void @llvm.dbg.value(metadata %struct.rwlock_s* %0, metadata !155, metadata !DIExpression()), !dbg !156
  %2 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %0, i32 0, i32 1, !dbg !157
  %3 = call i32 @vatomic32_await_eq_set_rlx(%struct.vatomic32_s* noundef %2, i32 noundef 0, i32 noundef 1), !dbg !158
  %4 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %0, i32 0, i32 2, !dbg !159
  %5 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %0, i32 0, i32 0, !dbg !160
  %6 = load i32, i32* %5, align 4, !dbg !160
  call void @semaphore_acquire(%struct.semaphore_s* noundef %4, i32 noundef %6), !dbg !161
  ret void, !dbg !162
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @writer_release(i32 noundef %0) #0 !dbg !163 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !164, metadata !DIExpression()), !dbg !165
  call void @rwlock_write_release(%struct.rwlock_s* noundef @lock), !dbg !166
  ret void, !dbg !167
}

; Function Attrs: noinline nounwind uwtable
define internal void @rwlock_write_release(%struct.rwlock_s* noundef %0) #0 !dbg !168 {
  call void @llvm.dbg.value(metadata %struct.rwlock_s* %0, metadata !169, metadata !DIExpression()), !dbg !170
  %2 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %0, i32 0, i32 1, !dbg !171
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %2, i32 noundef 0), !dbg !172
  %3 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %0, i32 0, i32 2, !dbg !173
  %4 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %0, i32 0, i32 0, !dbg !174
  %5 = load i32, i32* %4, align 4, !dbg !174
  call void @semaphore_release(%struct.semaphore_s* noundef %3, i32 noundef %5), !dbg !175
  ret void, !dbg !176
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @reader_acquire(i32 noundef %0) #0 !dbg !177 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !178, metadata !DIExpression()), !dbg !179
  call void @rwlock_read_acquire(%struct.rwlock_s* noundef @lock), !dbg !180
  ret void, !dbg !181
}

; Function Attrs: noinline nounwind uwtable
define internal void @rwlock_read_acquire(%struct.rwlock_s* noundef %0) #0 !dbg !182 {
  call void @llvm.dbg.value(metadata %struct.rwlock_s* %0, metadata !183, metadata !DIExpression()), !dbg !184
  %2 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %0, i32 0, i32 1, !dbg !185
  %3 = call i32 @vatomic32_await_eq_rlx(%struct.vatomic32_s* noundef %2, i32 noundef 0), !dbg !186
  %4 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %0, i32 0, i32 2, !dbg !187
  call void @semaphore_acquire(%struct.semaphore_s* noundef %4, i32 noundef 1), !dbg !188
  ret void, !dbg !189
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @reader_release(i32 noundef %0) #0 !dbg !190 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !191, metadata !DIExpression()), !dbg !192
  call void @rwlock_read_release(%struct.rwlock_s* noundef @lock), !dbg !193
  ret void, !dbg !194
}

; Function Attrs: noinline nounwind uwtable
define internal void @rwlock_read_release(%struct.rwlock_s* noundef %0) #0 !dbg !195 {
  call void @llvm.dbg.value(metadata %struct.rwlock_s* %0, metadata !196, metadata !DIExpression()), !dbg !197
  %2 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %0, i32 0, i32 2, !dbg !198
  call void @semaphore_release(%struct.semaphore_s* noundef %2, i32 noundef 1), !dbg !199
  ret void, !dbg !200
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_eq_set_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !201 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !206, metadata !DIExpression()), !dbg !207
  call void @llvm.dbg.value(metadata i32 %1, metadata !208, metadata !DIExpression()), !dbg !207
  call void @llvm.dbg.value(metadata i32 %2, metadata !209, metadata !DIExpression()), !dbg !207
  br label %4, !dbg !210

4:                                                ; preds = %4, %3
  %5 = call i32 @vatomic32_await_eq_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1), !dbg !211
  %6 = call i32 @vatomic32_cmpxchg_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2), !dbg !213
  %7 = icmp ne i32 %6, %1, !dbg !214
  br i1 %7, label %4, label %8, !dbg !215, !llvm.loop !216

8:                                                ; preds = %4
  ret i32 %1, !dbg !219
}

; Function Attrs: noinline nounwind uwtable
define internal void @semaphore_acquire(%struct.semaphore_s* noundef %0, i32 noundef %1) #0 !dbg !220 {
  call void @llvm.dbg.value(metadata %struct.semaphore_s* %0, metadata !224, metadata !DIExpression()), !dbg !225
  call void @llvm.dbg.value(metadata i32 %1, metadata !226, metadata !DIExpression()), !dbg !225
  %3 = getelementptr inbounds %struct.semaphore_s, %struct.semaphore_s* %0, i32 0, i32 0, !dbg !227
  %4 = call i32 @vatomic32_await_ge_sub_acq(%struct.vatomic32_s* noundef %3, i32 noundef %1, i32 noundef %1), !dbg !228
  ret void, !dbg !229
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
define internal i32 @vatomic32_cmpxchg_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !242 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !244, metadata !DIExpression()), !dbg !245
  call void @llvm.dbg.value(metadata i32 %1, metadata !246, metadata !DIExpression()), !dbg !245
  call void @llvm.dbg.value(metadata i32 %2, metadata !247, metadata !DIExpression()), !dbg !245
  call void @llvm.dbg.value(metadata i32 %1, metadata !248, metadata !DIExpression()), !dbg !245
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !249, !srcloc !250
  %4 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !251
  %5 = cmpxchg i32* %4, i32 %1, i32 %2 monotonic monotonic, align 4, !dbg !252
  %6 = extractvalue { i32, i1 } %5, 0, !dbg !252
  %7 = extractvalue { i32, i1 } %5, 1, !dbg !252
  %spec.select = select i1 %7, i32 %1, i32 %6, !dbg !252
  call void @llvm.dbg.value(metadata i32 %spec.select, metadata !248, metadata !DIExpression()), !dbg !245
  %8 = zext i1 %7 to i8, !dbg !252
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !253, !srcloc !254
  ret i32 %spec.select, !dbg !255
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !256 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !259, metadata !DIExpression()), !dbg !260
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !261, !srcloc !262
  %2 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !263
  %3 = load atomic i32, i32* %2 monotonic, align 4, !dbg !264
  call void @llvm.dbg.value(metadata i32 %3, metadata !265, metadata !DIExpression()), !dbg !260
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !266, !srcloc !267
  ret i32 %3, !dbg !268
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_ge_sub_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !269 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !270, metadata !DIExpression()), !dbg !271
  call void @llvm.dbg.value(metadata i32 %1, metadata !272, metadata !DIExpression()), !dbg !271
  call void @llvm.dbg.value(metadata i32 %2, metadata !273, metadata !DIExpression()), !dbg !271
  call void @llvm.dbg.value(metadata i32 0, metadata !274, metadata !DIExpression()), !dbg !271
  %4 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0), !dbg !275
  call void @llvm.dbg.value(metadata i32 %4, metadata !276, metadata !DIExpression()), !dbg !271
  br label %5, !dbg !277

5:                                                ; preds = %11, %3
  %.0 = phi i32 [ %4, %3 ], [ %13, %11 ], !dbg !271
  call void @llvm.dbg.value(metadata i32 %.0, metadata !276, metadata !DIExpression()), !dbg !271
  call void @llvm.dbg.value(metadata i32 %.0, metadata !274, metadata !DIExpression()), !dbg !271
  br label %6, !dbg !278

6:                                                ; preds = %9, %5
  %.01 = phi i32 [ %.0, %5 ], [ %10, %9 ], !dbg !280
  call void @llvm.dbg.value(metadata i32 %.01, metadata !274, metadata !DIExpression()), !dbg !271
  %7 = icmp uge i32 %.01, %1, !dbg !281
  %8 = xor i1 %7, true, !dbg !282
  br i1 %8, label %9, label %11, !dbg !278

9:                                                ; preds = %6
  %10 = call i32 @vatomic32_await_neq_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %.01), !dbg !283
  call void @llvm.dbg.value(metadata i32 %10, metadata !274, metadata !DIExpression()), !dbg !271
  br label %6, !dbg !278, !llvm.loop !285

11:                                               ; preds = %6
  %12 = sub i32 %.01, %2, !dbg !287
  %13 = call i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %0, i32 noundef %.01, i32 noundef %12), !dbg !288
  call void @llvm.dbg.value(metadata i32 %13, metadata !276, metadata !DIExpression()), !dbg !271
  %14 = icmp ne i32 %13, %.01, !dbg !289
  br i1 %14, label %5, label %15, !dbg !290, !llvm.loop !291

15:                                               ; preds = %11
  ret i32 %.01, !dbg !293
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_neq_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !294 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !295, metadata !DIExpression()), !dbg !296
  call void @llvm.dbg.value(metadata i32 %1, metadata !297, metadata !DIExpression()), !dbg !296
  call void @llvm.dbg.value(metadata i32 0, metadata !298, metadata !DIExpression()), !dbg !296
  br label %3, !dbg !299

3:                                                ; preds = %3, %2
  %4 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0), !dbg !299
  call void @llvm.dbg.value(metadata i32 %4, metadata !298, metadata !DIExpression()), !dbg !296
  %5 = icmp eq i32 %4, %1, !dbg !299
  br i1 %5, label %3, label %6, !dbg !299, !llvm.loop !300

6:                                                ; preds = %3
  ret i32 %4, !dbg !302
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !303 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !304, metadata !DIExpression()), !dbg !305
  call void @llvm.dbg.value(metadata i32 %1, metadata !306, metadata !DIExpression()), !dbg !305
  call void @llvm.dbg.value(metadata i32 %2, metadata !307, metadata !DIExpression()), !dbg !305
  call void @llvm.dbg.value(metadata i32 %1, metadata !308, metadata !DIExpression()), !dbg !305
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !309, !srcloc !310
  %4 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !311
  %5 = cmpxchg i32* %4, i32 %1, i32 %2 acquire acquire, align 4, !dbg !312
  %6 = extractvalue { i32, i1 } %5, 0, !dbg !312
  %7 = extractvalue { i32, i1 } %5, 1, !dbg !312
  %spec.select = select i1 %7, i32 %1, i32 %6, !dbg !312
  call void @llvm.dbg.value(metadata i32 %spec.select, metadata !308, metadata !DIExpression()), !dbg !305
  %8 = zext i1 %7 to i8, !dbg !312
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !313, !srcloc !314
  ret i32 %spec.select, !dbg !315
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !316 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !319, metadata !DIExpression()), !dbg !320
  call void @llvm.dbg.value(metadata i32 %1, metadata !321, metadata !DIExpression()), !dbg !320
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !322, !srcloc !323
  %3 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !324
  store atomic i32 %1, i32* %3 monotonic, align 4, !dbg !325
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !326, !srcloc !327
  ret void, !dbg !328
}

; Function Attrs: noinline nounwind uwtable
define internal void @semaphore_release(%struct.semaphore_s* noundef %0, i32 noundef %1) #0 !dbg !329 {
  call void @llvm.dbg.value(metadata %struct.semaphore_s* %0, metadata !330, metadata !DIExpression()), !dbg !331
  call void @llvm.dbg.value(metadata i32 %1, metadata !332, metadata !DIExpression()), !dbg !331
  %3 = getelementptr inbounds %struct.semaphore_s, %struct.semaphore_s* %0, i32 0, i32 0, !dbg !333
  call void @vatomic32_add_rel(%struct.vatomic32_s* noundef %3, i32 noundef %1), !dbg !334
  ret void, !dbg !335
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_add_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !336 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !337, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata i32 %1, metadata !339, metadata !DIExpression()), !dbg !338
  %3 = call i32 @vatomic32_get_add_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1), !dbg !340
  ret void, !dbg !341
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_add_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !342 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !343, metadata !DIExpression()), !dbg !344
  call void @llvm.dbg.value(metadata i32 %1, metadata !345, metadata !DIExpression()), !dbg !344
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !346, !srcloc !347
  %3 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !348
  %4 = atomicrmw add i32* %3, i32 %1 release, align 4, !dbg !349
  call void @llvm.dbg.value(metadata i32 %4, metadata !350, metadata !DIExpression()), !dbg !344
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !351, !srcloc !352
  ret i32 %4, !dbg !353
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
!llvm.module.flags = !{!41, !42, !43, !44, !45, !46, !47}
!llvm.ident = !{!48}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !40, line: 105, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/drc/git/libvsync/test/spinlock/rwlock.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "c3d2986853f3d85dfbf77ee587d8462c")
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
!17 = !{!18, !0, !38}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !20, line: 16, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "test/spinlock/rwlock.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "c3d2986853f3d85dfbf77ee587d8462c")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "rwlock_t", file: !22, line: 54, baseType: !23)
!22 = !DIFile(filename: "./include/vsync/spinlock/rwlock.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "790816d2f77f891e00fe975aae10d64d")
!23 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "rwlock_s", file: !22, line: 50, size: 96, elements: !24)
!24 = !{!25, !26, !32}
!25 = !DIDerivedType(tag: DW_TAG_member, name: "n", scope: !23, file: !22, line: 51, baseType: !6, size: 32)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "wb", scope: !23, file: !22, line: 52, baseType: !27, size: 32, align: 32, offset: 32)
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !28, line: 62, baseType: !29)
!28 = !DIFile(filename: "./include/vsync/atomic/core.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "1cc0657a82f0605ef67642f178a77e1c")
!29 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !28, line: 60, size: 32, align: 32, elements: !30)
!30 = !{!31}
!31 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !29, file: !28, line: 61, baseType: !6, size: 32)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "rs", scope: !23, file: !22, line: 53, baseType: !33, size: 32, offset: 64)
!33 = !DIDerivedType(tag: DW_TAG_typedef, name: "semaphore_t", file: !34, line: 22, baseType: !35)
!34 = !DIFile(filename: "./include/vsync/spinlock/semaphore.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "70fe43c1342b6b609b68d58fb396fa39")
!35 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "semaphore_s", file: !34, line: 20, size: 32, elements: !36)
!36 = !{!37}
!37 = !DIDerivedType(tag: DW_TAG_member, name: "s", scope: !35, file: !34, line: 21, baseType: !27, size: 32, align: 32)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(name: "g_cs_y", scope: !2, file: !40, line: 106, type: !6, isLocal: true, isDefinition: true)
!40 = !DIFile(filename: "./include/test/boilerplate/reader_writer.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "54e4a8b6c91c55a7191ad9a8296bf783")
!41 = !{i32 7, !"Dwarf Version", i32 5}
!42 = !{i32 2, !"Debug Info Version", i32 3}
!43 = !{i32 1, !"wchar_size", i32 4}
!44 = !{i32 7, !"PIC Level", i32 2}
!45 = !{i32 7, !"PIE Level", i32 2}
!46 = !{i32 7, !"uwtable", i32 1}
!47 = !{i32 7, !"frame-pointer", i32 2}
!48 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!49 = distinct !DISubprogram(name: "init", scope: !40, file: !40, line: 49, type: !50, scopeLine: 50, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!50 = !DISubroutineType(types: !51)
!51 = !{null}
!52 = !{}
!53 = !DILocation(line: 51, column: 1, scope: !49)
!54 = distinct !DISubprogram(name: "post", scope: !40, file: !40, line: 58, type: !50, scopeLine: 59, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!55 = !DILocation(line: 60, column: 1, scope: !54)
!56 = distinct !DISubprogram(name: "fini", scope: !40, file: !40, line: 67, type: !50, scopeLine: 68, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!57 = !DILocation(line: 69, column: 1, scope: !56)
!58 = distinct !DISubprogram(name: "writer_cs", scope: !40, file: !40, line: 109, type: !59, scopeLine: 110, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!59 = !DISubroutineType(types: !60)
!60 = !{null, !6}
!61 = !DILocalVariable(name: "tid", arg: 1, scope: !58, file: !40, line: 109, type: !6)
!62 = !DILocation(line: 0, scope: !58)
!63 = !DILocation(line: 112, column: 8, scope: !58)
!64 = !DILocation(line: 113, column: 8, scope: !58)
!65 = !DILocation(line: 114, column: 1, scope: !58)
!66 = distinct !DISubprogram(name: "reader_cs", scope: !40, file: !40, line: 116, type: !59, scopeLine: 117, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!67 = !DILocalVariable(name: "tid", arg: 1, scope: !66, file: !40, line: 116, type: !6)
!68 = !DILocation(line: 0, scope: !66)
!69 = !DILocation(line: 119, column: 16, scope: !66)
!70 = !DILocation(line: 119, column: 26, scope: !66)
!71 = !DILocation(line: 119, column: 23, scope: !66)
!72 = !DILocalVariable(name: "a", scope: !66, file: !40, line: 119, type: !12)
!73 = !DILocation(line: 120, column: 2, scope: !74)
!74 = distinct !DILexicalBlock(scope: !75, file: !40, line: 120, column: 2)
!75 = distinct !DILexicalBlock(scope: !66, file: !40, line: 120, column: 2)
!76 = !DILocation(line: 121, column: 1, scope: !66)
!77 = distinct !DISubprogram(name: "check", scope: !40, file: !40, line: 123, type: !50, scopeLine: 124, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!78 = !DILocation(line: 125, column: 2, scope: !79)
!79 = distinct !DILexicalBlock(scope: !80, file: !40, line: 125, column: 2)
!80 = distinct !DILexicalBlock(scope: !77, file: !40, line: 125, column: 2)
!81 = !DILocation(line: 125, column: 2, scope: !80)
!82 = !DILocation(line: 126, column: 2, scope: !83)
!83 = distinct !DILexicalBlock(scope: !84, file: !40, line: 126, column: 2)
!84 = distinct !DILexicalBlock(scope: !77, file: !40, line: 126, column: 2)
!85 = !DILocation(line: 126, column: 2, scope: !84)
!86 = !DILocation(line: 127, column: 1, scope: !77)
!87 = distinct !DISubprogram(name: "main", scope: !40, file: !40, line: 153, type: !88, scopeLine: 154, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!88 = !DISubroutineType(types: !89)
!89 = !{!90}
!90 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!91 = !DILocalVariable(name: "t", scope: !87, file: !40, line: 155, type: !92)
!92 = !DICompositeType(tag: DW_TAG_array_type, baseType: !93, size: 256, elements: !95)
!93 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !94, line: 27, baseType: !16)
!94 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!95 = !{!96}
!96 = !DISubrange(count: 4)
!97 = !DILocation(line: 155, column: 12, scope: !87)
!98 = !DILocation(line: 162, column: 2, scope: !87)
!99 = !DILocalVariable(name: "i", scope: !100, file: !40, line: 164, type: !13)
!100 = distinct !DILexicalBlock(scope: !87, file: !40, line: 164, column: 2)
!101 = !DILocation(line: 0, scope: !100)
!102 = !DILocation(line: 165, column: 25, scope: !103)
!103 = distinct !DILexicalBlock(scope: !104, file: !40, line: 164, column: 44)
!104 = distinct !DILexicalBlock(scope: !100, file: !40, line: 164, column: 2)
!105 = !DILocation(line: 165, column: 9, scope: !103)
!106 = !DILocalVariable(name: "i", scope: !107, file: !40, line: 168, type: !13)
!107 = distinct !DILexicalBlock(scope: !87, file: !40, line: 168, column: 2)
!108 = !DILocation(line: 0, scope: !107)
!109 = !DILocation(line: 169, column: 25, scope: !110)
!110 = distinct !DILexicalBlock(scope: !111, file: !40, line: 168, column: 51)
!111 = distinct !DILexicalBlock(scope: !107, file: !40, line: 168, column: 2)
!112 = !DILocation(line: 169, column: 9, scope: !110)
!113 = !DILocation(line: 172, column: 2, scope: !87)
!114 = !DILocalVariable(name: "i", scope: !115, file: !40, line: 174, type: !13)
!115 = distinct !DILexicalBlock(scope: !87, file: !40, line: 174, column: 2)
!116 = !DILocation(line: 0, scope: !115)
!117 = !DILocation(line: 175, column: 22, scope: !118)
!118 = distinct !DILexicalBlock(scope: !119, file: !40, line: 174, column: 44)
!119 = distinct !DILexicalBlock(scope: !115, file: !40, line: 174, column: 2)
!120 = !DILocation(line: 175, column: 9, scope: !118)
!121 = !DILocation(line: 183, column: 2, scope: !87)
!122 = !DILocation(line: 184, column: 2, scope: !87)
!123 = !DILocation(line: 186, column: 2, scope: !87)
!124 = distinct !DISubprogram(name: "writer", scope: !40, file: !40, line: 132, type: !125, scopeLine: 133, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!125 = !DISubroutineType(types: !126)
!126 = !{!5, !5}
!127 = !DILocalVariable(name: "arg", arg: 1, scope: !124, file: !40, line: 132, type: !5)
!128 = !DILocation(line: 0, scope: !124)
!129 = !DILocation(line: 134, column: 29, scope: !124)
!130 = !DILocation(line: 134, column: 18, scope: !124)
!131 = !DILocalVariable(name: "tid", scope: !124, file: !40, line: 134, type: !6)
!132 = !DILocation(line: 135, column: 2, scope: !124)
!133 = !DILocation(line: 136, column: 2, scope: !124)
!134 = !DILocation(line: 137, column: 2, scope: !124)
!135 = !DILocation(line: 138, column: 2, scope: !124)
!136 = distinct !DISubprogram(name: "reader", scope: !40, file: !40, line: 142, type: !125, scopeLine: 143, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!137 = !DILocalVariable(name: "arg", arg: 1, scope: !136, file: !40, line: 142, type: !5)
!138 = !DILocation(line: 0, scope: !136)
!139 = !DILocation(line: 144, column: 29, scope: !136)
!140 = !DILocation(line: 144, column: 18, scope: !136)
!141 = !DILocalVariable(name: "tid", scope: !136, file: !40, line: 144, type: !6)
!142 = !DILocation(line: 145, column: 2, scope: !136)
!143 = !DILocation(line: 146, column: 2, scope: !136)
!144 = !DILocation(line: 147, column: 2, scope: !136)
!145 = !DILocation(line: 149, column: 2, scope: !136)
!146 = distinct !DISubprogram(name: "writer_acquire", scope: !20, file: !20, line: 19, type: !59, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!147 = !DILocalVariable(name: "tid", arg: 1, scope: !146, file: !20, line: 19, type: !6)
!148 = !DILocation(line: 0, scope: !146)
!149 = !DILocation(line: 22, column: 2, scope: !146)
!150 = !DILocation(line: 23, column: 1, scope: !146)
!151 = distinct !DISubprogram(name: "rwlock_write_acquire", scope: !22, file: !22, line: 87, type: !152, scopeLine: 88, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!152 = !DISubroutineType(types: !153)
!153 = !{null, !154}
!154 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64)
!155 = !DILocalVariable(name: "l", arg: 1, scope: !151, file: !22, line: 87, type: !154)
!156 = !DILocation(line: 0, scope: !151)
!157 = !DILocation(line: 89, column: 33, scope: !151)
!158 = !DILocation(line: 89, column: 2, scope: !151)
!159 = !DILocation(line: 90, column: 24, scope: !151)
!160 = !DILocation(line: 90, column: 31, scope: !151)
!161 = !DILocation(line: 90, column: 2, scope: !151)
!162 = !DILocation(line: 91, column: 1, scope: !151)
!163 = distinct !DISubprogram(name: "writer_release", scope: !20, file: !20, line: 25, type: !59, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!164 = !DILocalVariable(name: "tid", arg: 1, scope: !163, file: !20, line: 25, type: !6)
!165 = !DILocation(line: 0, scope: !163)
!166 = !DILocation(line: 28, column: 2, scope: !163)
!167 = !DILocation(line: 29, column: 1, scope: !163)
!168 = distinct !DISubprogram(name: "rwlock_write_release", scope: !22, file: !22, line: 119, type: !152, scopeLine: 120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!169 = !DILocalVariable(name: "l", arg: 1, scope: !168, file: !22, line: 119, type: !154)
!170 = !DILocation(line: 0, scope: !168)
!171 = !DILocation(line: 121, column: 26, scope: !168)
!172 = !DILocation(line: 121, column: 2, scope: !168)
!173 = !DILocation(line: 122, column: 24, scope: !168)
!174 = !DILocation(line: 122, column: 31, scope: !168)
!175 = !DILocation(line: 122, column: 2, scope: !168)
!176 = !DILocation(line: 123, column: 1, scope: !168)
!177 = distinct !DISubprogram(name: "reader_acquire", scope: !20, file: !20, line: 31, type: !59, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!178 = !DILocalVariable(name: "tid", arg: 1, scope: !177, file: !20, line: 31, type: !6)
!179 = !DILocation(line: 0, scope: !177)
!180 = !DILocation(line: 34, column: 2, scope: !177)
!181 = !DILocation(line: 35, column: 1, scope: !177)
!182 = distinct !DISubprogram(name: "rwlock_read_acquire", scope: !22, file: !22, line: 130, type: !152, scopeLine: 131, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!183 = !DILocalVariable(name: "l", arg: 1, scope: !182, file: !22, line: 130, type: !154)
!184 = !DILocation(line: 0, scope: !182)
!185 = !DILocation(line: 132, column: 29, scope: !182)
!186 = !DILocation(line: 132, column: 2, scope: !182)
!187 = !DILocation(line: 133, column: 24, scope: !182)
!188 = !DILocation(line: 133, column: 2, scope: !182)
!189 = !DILocation(line: 134, column: 1, scope: !182)
!190 = distinct !DISubprogram(name: "reader_release", scope: !20, file: !20, line: 37, type: !59, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!191 = !DILocalVariable(name: "tid", arg: 1, scope: !190, file: !20, line: 37, type: !6)
!192 = !DILocation(line: 0, scope: !190)
!193 = !DILocation(line: 40, column: 2, scope: !190)
!194 = !DILocation(line: 41, column: 1, scope: !190)
!195 = distinct !DISubprogram(name: "rwlock_read_release", scope: !22, file: !22, line: 156, type: !152, scopeLine: 157, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!196 = !DILocalVariable(name: "l", arg: 1, scope: !195, file: !22, line: 156, type: !154)
!197 = !DILocation(line: 0, scope: !195)
!198 = !DILocation(line: 158, column: 24, scope: !195)
!199 = !DILocation(line: 158, column: 2, scope: !195)
!200 = !DILocation(line: 159, column: 1, scope: !195)
!201 = distinct !DISubprogram(name: "vatomic32_await_eq_set_rlx", scope: !202, file: !202, line: 7515, type: !203, scopeLine: 7516, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!202 = !DIFile(filename: "./include/vsync/atomic/internal/fallback.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "bfc5d50ad810da3af0d582a48b47498f")
!203 = !DISubroutineType(types: !204)
!204 = !{!6, !205, !6, !6}
!205 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !27, size: 64)
!206 = !DILocalVariable(name: "a", arg: 1, scope: !201, file: !202, line: 7515, type: !205)
!207 = !DILocation(line: 0, scope: !201)
!208 = !DILocalVariable(name: "c", arg: 2, scope: !201, file: !202, line: 7515, type: !6)
!209 = !DILocalVariable(name: "v", arg: 3, scope: !201, file: !202, line: 7515, type: !6)
!210 = !DILocation(line: 7517, column: 2, scope: !201)
!211 = !DILocation(line: 7518, column: 9, scope: !212)
!212 = distinct !DILexicalBlock(scope: !201, file: !202, line: 7517, column: 5)
!213 = !DILocation(line: 7519, column: 11, scope: !201)
!214 = !DILocation(line: 7519, column: 42, scope: !201)
!215 = !DILocation(line: 7519, column: 2, scope: !212)
!216 = distinct !{!216, !210, !217, !218}
!217 = !DILocation(line: 7519, column: 46, scope: !201)
!218 = !{!"llvm.loop.mustprogress"}
!219 = !DILocation(line: 7520, column: 2, scope: !201)
!220 = distinct !DISubprogram(name: "semaphore_acquire", scope: !34, file: !34, line: 54, type: !221, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!221 = !DISubroutineType(types: !222)
!222 = !{null, !223, !6}
!223 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !33, size: 64)
!224 = !DILocalVariable(name: "s", arg: 1, scope: !220, file: !34, line: 54, type: !223)
!225 = !DILocation(line: 0, scope: !220)
!226 = !DILocalVariable(name: "i", arg: 2, scope: !220, file: !34, line: 54, type: !6)
!227 = !DILocation(line: 59, column: 33, scope: !220)
!228 = !DILocation(line: 59, column: 2, scope: !220)
!229 = !DILocation(line: 60, column: 1, scope: !220)
!230 = distinct !DISubprogram(name: "vatomic32_await_eq_rlx", scope: !202, file: !202, line: 4406, type: !231, scopeLine: 4407, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!231 = !DISubroutineType(types: !232)
!232 = !{!6, !205, !6}
!233 = !DILocalVariable(name: "a", arg: 1, scope: !230, file: !202, line: 4406, type: !205)
!234 = !DILocation(line: 0, scope: !230)
!235 = !DILocalVariable(name: "c", arg: 2, scope: !230, file: !202, line: 4406, type: !6)
!236 = !DILocalVariable(name: "ret", scope: !230, file: !202, line: 4408, type: !6)
!237 = !DILocalVariable(name: "o", scope: !230, file: !202, line: 4409, type: !6)
!238 = !DILocation(line: 4410, column: 2, scope: !230)
!239 = distinct !{!239, !238, !240, !218}
!240 = !DILocation(line: 4413, column: 2, scope: !230)
!241 = !DILocation(line: 4414, column: 2, scope: !230)
!242 = distinct !DISubprogram(name: "vatomic32_cmpxchg_rlx", scope: !243, file: !243, line: 1136, type: !203, scopeLine: 1137, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!243 = !DIFile(filename: "./include/vsync/atomic/internal/builtins.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "31d9a9647b315cadb2f817a7c8e98ecf")
!244 = !DILocalVariable(name: "a", arg: 1, scope: !242, file: !243, line: 1136, type: !205)
!245 = !DILocation(line: 0, scope: !242)
!246 = !DILocalVariable(name: "e", arg: 2, scope: !242, file: !243, line: 1136, type: !6)
!247 = !DILocalVariable(name: "v", arg: 3, scope: !242, file: !243, line: 1136, type: !6)
!248 = !DILocalVariable(name: "exp", scope: !242, file: !243, line: 1138, type: !6)
!249 = !DILocation(line: 1139, column: 2, scope: !242)
!250 = !{i64 2147860859}
!251 = !DILocation(line: 1140, column: 34, scope: !242)
!252 = !DILocation(line: 1140, column: 2, scope: !242)
!253 = !DILocation(line: 1143, column: 2, scope: !242)
!254 = !{i64 2147860913}
!255 = !DILocation(line: 1144, column: 2, scope: !242)
!256 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !243, file: !243, line: 193, type: !257, scopeLine: 194, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!257 = !DISubroutineType(types: !258)
!258 = !{!6, !205}
!259 = !DILocalVariable(name: "a", arg: 1, scope: !256, file: !243, line: 193, type: !205)
!260 = !DILocation(line: 0, scope: !256)
!261 = !DILocation(line: 195, column: 2, scope: !256)
!262 = !{i64 2147855479}
!263 = !DILocation(line: 197, column: 7, scope: !256)
!264 = !DILocation(line: 196, column: 29, scope: !256)
!265 = !DILocalVariable(name: "tmp", scope: !256, file: !243, line: 196, type: !6)
!266 = !DILocation(line: 198, column: 2, scope: !256)
!267 = !{i64 2147855525}
!268 = !DILocation(line: 199, column: 2, scope: !256)
!269 = distinct !DISubprogram(name: "vatomic32_await_ge_sub_acq", scope: !202, file: !202, line: 5628, type: !203, scopeLine: 5629, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!270 = !DILocalVariable(name: "a", arg: 1, scope: !269, file: !202, line: 5628, type: !205)
!271 = !DILocation(line: 0, scope: !269)
!272 = !DILocalVariable(name: "c", arg: 2, scope: !269, file: !202, line: 5628, type: !6)
!273 = !DILocalVariable(name: "v", arg: 3, scope: !269, file: !202, line: 5628, type: !6)
!274 = !DILocalVariable(name: "cur", scope: !269, file: !202, line: 5630, type: !6)
!275 = !DILocation(line: 5631, column: 18, scope: !269)
!276 = !DILocalVariable(name: "old", scope: !269, file: !202, line: 5631, type: !6)
!277 = !DILocation(line: 5632, column: 2, scope: !269)
!278 = !DILocation(line: 5634, column: 3, scope: !279)
!279 = distinct !DILexicalBlock(scope: !269, file: !202, line: 5632, column: 5)
!280 = !DILocation(line: 0, scope: !279)
!281 = !DILocation(line: 5634, column: 16, scope: !279)
!282 = !DILocation(line: 5634, column: 10, scope: !279)
!283 = !DILocation(line: 5635, column: 10, scope: !284)
!284 = distinct !DILexicalBlock(scope: !279, file: !202, line: 5634, column: 23)
!285 = distinct !{!285, !278, !286, !218}
!286 = !DILocation(line: 5636, column: 3, scope: !279)
!287 = !DILocation(line: 5637, column: 52, scope: !269)
!288 = !DILocation(line: 5637, column: 18, scope: !269)
!289 = !DILocation(line: 5637, column: 58, scope: !269)
!290 = !DILocation(line: 5637, column: 2, scope: !279)
!291 = distinct !{!291, !277, !292, !218}
!292 = !DILocation(line: 5637, column: 64, scope: !269)
!293 = !DILocation(line: 5638, column: 2, scope: !269)
!294 = distinct !DISubprogram(name: "vatomic32_await_neq_rlx", scope: !202, file: !202, line: 4267, type: !231, scopeLine: 4268, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!295 = !DILocalVariable(name: "a", arg: 1, scope: !294, file: !202, line: 4267, type: !205)
!296 = !DILocation(line: 0, scope: !294)
!297 = !DILocalVariable(name: "c", arg: 2, scope: !294, file: !202, line: 4267, type: !6)
!298 = !DILocalVariable(name: "cur", scope: !294, file: !202, line: 4269, type: !6)
!299 = !DILocation(line: 4270, column: 2, scope: !294)
!300 = distinct !{!300, !299, !301, !218}
!301 = !DILocation(line: 4272, column: 2, scope: !294)
!302 = !DILocation(line: 4273, column: 2, scope: !294)
!303 = distinct !DISubprogram(name: "vatomic32_cmpxchg_acq", scope: !243, file: !243, line: 1102, type: !203, scopeLine: 1103, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!304 = !DILocalVariable(name: "a", arg: 1, scope: !303, file: !243, line: 1102, type: !205)
!305 = !DILocation(line: 0, scope: !303)
!306 = !DILocalVariable(name: "e", arg: 2, scope: !303, file: !243, line: 1102, type: !6)
!307 = !DILocalVariable(name: "v", arg: 3, scope: !303, file: !243, line: 1102, type: !6)
!308 = !DILocalVariable(name: "exp", scope: !303, file: !243, line: 1104, type: !6)
!309 = !DILocation(line: 1105, column: 2, scope: !303)
!310 = !{i64 2147860675}
!311 = !DILocation(line: 1106, column: 34, scope: !303)
!312 = !DILocation(line: 1106, column: 2, scope: !303)
!313 = !DILocation(line: 1109, column: 2, scope: !303)
!314 = !{i64 2147860729}
!315 = !DILocation(line: 1110, column: 2, scope: !303)
!316 = distinct !DISubprogram(name: "vatomic32_write_rlx", scope: !243, file: !243, line: 451, type: !317, scopeLine: 452, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!317 = !DISubroutineType(types: !318)
!318 = !{null, !205, !6}
!319 = !DILocalVariable(name: "a", arg: 1, scope: !316, file: !243, line: 451, type: !205)
!320 = !DILocation(line: 0, scope: !316)
!321 = !DILocalVariable(name: "v", arg: 2, scope: !316, file: !243, line: 451, type: !6)
!322 = !DILocation(line: 453, column: 2, scope: !316)
!323 = !{i64 2147856991}
!324 = !DILocation(line: 454, column: 23, scope: !316)
!325 = !DILocation(line: 454, column: 2, scope: !316)
!326 = !DILocation(line: 455, column: 2, scope: !316)
!327 = !{i64 2147857037}
!328 = !DILocation(line: 456, column: 1, scope: !316)
!329 = distinct !DISubprogram(name: "semaphore_release", scope: !34, file: !34, line: 87, type: !221, scopeLine: 88, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!330 = !DILocalVariable(name: "s", arg: 1, scope: !329, file: !34, line: 87, type: !223)
!331 = !DILocation(line: 0, scope: !329)
!332 = !DILocalVariable(name: "i", arg: 2, scope: !329, file: !34, line: 87, type: !6)
!333 = !DILocation(line: 89, column: 24, scope: !329)
!334 = !DILocation(line: 89, column: 2, scope: !329)
!335 = !DILocation(line: 90, column: 1, scope: !329)
!336 = distinct !DISubprogram(name: "vatomic32_add_rel", scope: !202, file: !202, line: 2303, type: !317, scopeLine: 2304, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!337 = !DILocalVariable(name: "a", arg: 1, scope: !336, file: !202, line: 2303, type: !205)
!338 = !DILocation(line: 0, scope: !336)
!339 = !DILocalVariable(name: "v", arg: 2, scope: !336, file: !202, line: 2303, type: !6)
!340 = !DILocation(line: 2305, column: 8, scope: !336)
!341 = !DILocation(line: 2306, column: 1, scope: !336)
!342 = distinct !DISubprogram(name: "vatomic32_get_add_rel", scope: !243, file: !243, line: 2423, type: !231, scopeLine: 2424, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!343 = !DILocalVariable(name: "a", arg: 1, scope: !342, file: !243, line: 2423, type: !205)
!344 = !DILocation(line: 0, scope: !342)
!345 = !DILocalVariable(name: "v", arg: 2, scope: !342, file: !243, line: 2423, type: !6)
!346 = !DILocation(line: 2425, column: 2, scope: !342)
!347 = !{i64 2147867935}
!348 = !DILocation(line: 2427, column: 7, scope: !342)
!349 = !DILocation(line: 2426, column: 29, scope: !342)
!350 = !DILocalVariable(name: "tmp", scope: !342, file: !243, line: 2426, type: !6)
!351 = !DILocation(line: 2428, column: 2, scope: !342)
!352 = !{i64 2147867981}
!353 = !DILocation(line: 2429, column: 2, scope: !342)
