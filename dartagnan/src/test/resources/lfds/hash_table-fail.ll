; ModuleID = '/home/ponce/git/Dat3M/output/hash_table.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/lfds/hash_table.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.Entry = type { i32, i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@m_entries = dso_local global [2 x %struct.Entry] zeroinitializer, align 16, !dbg !0
@.str = private unnamed_addr constant [9 x i8] c"key != 0\00", align 1
@.str.1 = private unnamed_addr constant [51 x i8] c"/home/ponce/git/Dat3M/benchmarks/lfds/hash_table.h\00", align 1
@__PRETTY_FUNCTION__.set = private unnamed_addr constant [29 x i8] c"void set(uint32_t, uint32_t)\00", align 1
@.str.2 = private unnamed_addr constant [11 x i8] c"value != 0\00", align 1
@__PRETTY_FUNCTION__.get = private unnamed_addr constant [23 x i8] c"uint32_t get(uint32_t)\00", align 1
@data = dso_local global [2 x i32] zeroinitializer, align 4, !dbg !24
@read_flag = dso_local global [2 x i32] zeroinitializer, align 4, !dbg !33
@read_data = dso_local global [2 x i32] zeroinitializer, align 4, !dbg !36
@.str.3 = private unnamed_addr constant [42 x i8] c"!(read_flag[i] == 1 && read_data[i] == 0)\00", align 1
@.str.4 = private unnamed_addr constant [51 x i8] c"/home/ponce/git/Dat3M/benchmarks/lfds/hash_table.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1
@.str.5 = private unnamed_addr constant [17 x i8] c"count() == PAIRS\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !52 {
  call void @llvm.dbg.value(metadata i32 0, metadata !56, metadata !DIExpression()), !dbg !58
  call void @llvm.dbg.value(metadata i64 0, metadata !56, metadata !DIExpression()), !dbg !58
  store i32 0, i32* getelementptr inbounds ([2 x %struct.Entry], [2 x %struct.Entry]* @m_entries, i64 0, i64 0, i32 0), align 4, !dbg !59
  store i32 0, i32* getelementptr inbounds ([2 x %struct.Entry], [2 x %struct.Entry]* @m_entries, i64 0, i64 0, i32 1), align 4, !dbg !62
  call void @llvm.dbg.value(metadata i64 1, metadata !56, metadata !DIExpression()), !dbg !58
  call void @llvm.dbg.value(metadata i64 1, metadata !56, metadata !DIExpression()), !dbg !58
  store i32 0, i32* getelementptr inbounds ([2 x %struct.Entry], [2 x %struct.Entry]* @m_entries, i64 0, i64 1, i32 0), align 4, !dbg !59
  store i32 0, i32* getelementptr inbounds ([2 x %struct.Entry], [2 x %struct.Entry]* @m_entries, i64 0, i64 1, i32 1), align 4, !dbg !62
  call void @llvm.dbg.value(metadata i64 2, metadata !56, metadata !DIExpression()), !dbg !58
  call void @llvm.dbg.value(metadata i64 2, metadata !56, metadata !DIExpression()), !dbg !58
  ret void, !dbg !63
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @set(i32 noundef %0, i32 noundef %1) #0 !dbg !64 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !71, metadata !DIExpression()), !dbg !72
  call void @llvm.dbg.value(metadata i32 %1, metadata !73, metadata !DIExpression()), !dbg !72
  %3 = icmp ne i32 %0, 0, !dbg !74
  br i1 %3, label %5, label %4, !dbg !77

4:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @.str.1, i64 0, i64 0), i32 noundef 62, i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @__PRETTY_FUNCTION__.set, i64 0, i64 0)) #5, !dbg !74
  unreachable, !dbg !74

5:                                                ; preds = %2
  %6 = icmp ne i32 %1, 0, !dbg !78
  br i1 %6, label %8, label %7, !dbg !81

7:                                                ; preds = %5
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @.str.1, i64 0, i64 0), i32 noundef 63, i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @__PRETTY_FUNCTION__.set, i64 0, i64 0)) #5, !dbg !78
  unreachable, !dbg !78

8:                                                ; preds = %5
  %9 = call i32 @integerHash(i32 noundef %0), !dbg !82
  call void @llvm.dbg.value(metadata i32 %9, metadata !84, metadata !DIExpression()), !dbg !85
  br label %10, !dbg !86

10:                                               ; preds = %26, %8
  %.01 = phi i32 [ %9, %8 ], [ %27, %26 ], !dbg !85
  call void @llvm.dbg.value(metadata i32 %.01, metadata !84, metadata !DIExpression()), !dbg !85
  %11 = and i32 %.01, 1, !dbg !87
  call void @llvm.dbg.value(metadata i32 %11, metadata !84, metadata !DIExpression()), !dbg !85
  %12 = zext i32 %11 to i64, !dbg !90
  %13 = getelementptr inbounds [2 x %struct.Entry], [2 x %struct.Entry]* @m_entries, i64 0, i64 %12, !dbg !90
  %14 = getelementptr inbounds %struct.Entry, %struct.Entry* %13, i32 0, i32 0, !dbg !91
  %15 = load atomic i32, i32* %14 monotonic, align 8, !dbg !92
  call void @llvm.dbg.value(metadata i32 %15, metadata !93, metadata !DIExpression()), !dbg !94
  %16 = icmp ne i32 %15, %0, !dbg !95
  br i1 %16, label %17, label %.loopexit, !dbg !97

17:                                               ; preds = %10
  %18 = icmp ne i32 %15, 0, !dbg !98
  br i1 %18, label %26, label %19, !dbg !101

19:                                               ; preds = %17
  call void @llvm.dbg.value(metadata i32 0, metadata !102, metadata !DIExpression()), !dbg !103
  %20 = cmpxchg i32* %14, i32 0, i32 %0 monotonic monotonic, align 4, !dbg !104
  %21 = extractvalue { i32, i1 } %20, 0, !dbg !104
  %22 = extractvalue { i32, i1 } %20, 1, !dbg !104
  %spec.select = select i1 %22, i32 0, i32 %21, !dbg !104
  call void @llvm.dbg.value(metadata i32 %spec.select, metadata !102, metadata !DIExpression()), !dbg !103
  %23 = zext i1 %22 to i8, !dbg !104
  call void @llvm.dbg.value(metadata i8 %23, metadata !105, metadata !DIExpression()), !dbg !103
  %24 = icmp ne i32 %spec.select, 0, !dbg !107
  %.not = xor i1 %24, true, !dbg !109
  %brmerge = select i1 %.not, i1 true, i1 %22, !dbg !109
  br i1 %brmerge, label %.loopexit, label %26, !dbg !109

.loopexit:                                        ; preds = %10, %19
  %25 = getelementptr inbounds %struct.Entry, %struct.Entry* %13, i32 0, i32 1, !dbg !110
  store atomic i32 %1, i32* %25 monotonic, align 4, !dbg !111
  ret void, !dbg !112

26:                                               ; preds = %19, %17
  %27 = add i32 %11, 1, !dbg !113
  call void @llvm.dbg.value(metadata i32 %27, metadata !84, metadata !DIExpression()), !dbg !85
  br label %10, !dbg !114, !llvm.loop !115
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal i32 @integerHash(i32 noundef %0) #0 !dbg !118 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !121, metadata !DIExpression()), !dbg !122
  ret i32 %0, !dbg !123
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @get(i32 noundef %0) #0 !dbg !124 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !125, metadata !DIExpression()), !dbg !126
  %2 = icmp ne i32 %0, 0, !dbg !127
  br i1 %2, label %4, label %3, !dbg !130

3:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @.str.1, i64 0, i64 0), i32 noundef 94, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.get, i64 0, i64 0)) #5, !dbg !127
  unreachable, !dbg !127

4:                                                ; preds = %1
  %5 = call i32 @integerHash(i32 noundef %0), !dbg !131
  call void @llvm.dbg.value(metadata i32 %5, metadata !133, metadata !DIExpression()), !dbg !134
  br label %6, !dbg !135

6:                                                ; preds = %18, %4
  %.01 = phi i32 [ %5, %4 ], [ %19, %18 ], !dbg !134
  call void @llvm.dbg.value(metadata i32 %.01, metadata !133, metadata !DIExpression()), !dbg !134
  %7 = and i32 %.01, 1, !dbg !136
  call void @llvm.dbg.value(metadata i32 %7, metadata !133, metadata !DIExpression()), !dbg !134
  %8 = zext i32 %7 to i64, !dbg !139
  %9 = getelementptr inbounds [2 x %struct.Entry], [2 x %struct.Entry]* @m_entries, i64 0, i64 %8, !dbg !139
  %10 = getelementptr inbounds %struct.Entry, %struct.Entry* %9, i32 0, i32 0, !dbg !140
  %11 = load atomic i32, i32* %10 monotonic, align 8, !dbg !141
  call void @llvm.dbg.value(metadata i32 %11, metadata !142, metadata !DIExpression()), !dbg !143
  %12 = icmp eq i32 %11, %0, !dbg !144
  br i1 %12, label %13, label %16, !dbg !146

13:                                               ; preds = %6
  %14 = getelementptr inbounds %struct.Entry, %struct.Entry* %9, i32 0, i32 1, !dbg !147
  %15 = load atomic i32, i32* %14 monotonic, align 4, !dbg !148
  br label %20, !dbg !149

16:                                               ; preds = %6
  %17 = icmp eq i32 %11, 0, !dbg !150
  br i1 %17, label %20, label %18, !dbg !152

18:                                               ; preds = %16
  %19 = add i32 %7, 1, !dbg !153
  call void @llvm.dbg.value(metadata i32 %19, metadata !133, metadata !DIExpression()), !dbg !134
  br label %6, !dbg !154, !llvm.loop !155

20:                                               ; preds = %16, %13
  %.0 = phi i32 [ %15, %13 ], [ 0, %16 ], !dbg !143
  ret i32 %.0, !dbg !158
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @count() #0 !dbg !159 {
  call void @llvm.dbg.value(metadata i32 0, metadata !162, metadata !DIExpression()), !dbg !163
  call void @llvm.dbg.value(metadata i32 0, metadata !164, metadata !DIExpression()), !dbg !166
  call void @llvm.dbg.value(metadata i32 0, metadata !162, metadata !DIExpression()), !dbg !163
  call void @llvm.dbg.value(metadata i64 0, metadata !164, metadata !DIExpression()), !dbg !166
  %1 = load atomic i32, i32* getelementptr inbounds ([2 x %struct.Entry], [2 x %struct.Entry]* @m_entries, i64 0, i64 0, i32 0) monotonic, align 8, !dbg !167
  %2 = icmp ne i32 %1, 0, !dbg !171
  br i1 %2, label %3, label %6, !dbg !172

3:                                                ; preds = %0
  %4 = load atomic i32, i32* getelementptr inbounds ([2 x %struct.Entry], [2 x %struct.Entry]* @m_entries, i64 0, i64 0, i32 1) monotonic, align 4, !dbg !173
  %5 = icmp ne i32 %4, 0, !dbg !174
  %spec.select = select i1 %5, i32 1, i32 0, !dbg !175
  br label %6, !dbg !175

6:                                                ; preds = %3, %0
  %.1 = phi i32 [ 0, %0 ], [ %spec.select, %3 ], !dbg !163
  call void @llvm.dbg.value(metadata i32 %.1, metadata !162, metadata !DIExpression()), !dbg !163
  call void @llvm.dbg.value(metadata i64 1, metadata !164, metadata !DIExpression()), !dbg !166
  call void @llvm.dbg.value(metadata i32 %.1, metadata !162, metadata !DIExpression()), !dbg !163
  call void @llvm.dbg.value(metadata i64 1, metadata !164, metadata !DIExpression()), !dbg !166
  %7 = load atomic i32, i32* getelementptr inbounds ([2 x %struct.Entry], [2 x %struct.Entry]* @m_entries, i64 0, i64 1, i32 0) monotonic, align 8, !dbg !167
  %8 = icmp ne i32 %7, 0, !dbg !171
  br i1 %8, label %9, label %13, !dbg !172

9:                                                ; preds = %6
  %10 = load atomic i32, i32* getelementptr inbounds ([2 x %struct.Entry], [2 x %struct.Entry]* @m_entries, i64 0, i64 1, i32 1) monotonic, align 4, !dbg !173
  %11 = icmp ne i32 %10, 0, !dbg !174
  %12 = add i32 %.1, 1
  %spec.select3 = select i1 %11, i32 %12, i32 %.1, !dbg !175
  br label %13, !dbg !175

13:                                               ; preds = %9, %6
  %.0.lcssa = phi i32 [ %.1, %6 ], [ %spec.select3, %9 ], !dbg !163
  call void @llvm.dbg.value(metadata i32 %.0.lcssa, metadata !162, metadata !DIExpression()), !dbg !163
  call void @llvm.dbg.value(metadata i64 2, metadata !164, metadata !DIExpression()), !dbg !166
  call void @llvm.dbg.value(metadata i32 %.0.lcssa, metadata !162, metadata !DIExpression()), !dbg !163
  call void @llvm.dbg.value(metadata i64 2, metadata !164, metadata !DIExpression()), !dbg !166
  ret i32 %.0.lcssa, !dbg !176
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_1(i8* noundef %0) #0 !dbg !177 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !180, metadata !DIExpression()), !dbg !181
  %2 = ptrtoint i8* %0 to i64, !dbg !182
  call void @llvm.dbg.value(metadata i64 %2, metadata !183, metadata !DIExpression()), !dbg !181
  %3 = getelementptr inbounds [2 x i32], [2 x i32]* @data, i64 0, i64 %2, !dbg !184
  store atomic i32 1, i32* %3 monotonic, align 4, !dbg !185
  %4 = add nsw i64 %2, 1, !dbg !186
  %5 = trunc i64 %4 to i32, !dbg !187
  call void @set(i32 noundef %5, i32 noundef 1), !dbg !188
  ret i8* null, !dbg !189
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_2(i8* noundef %0) #0 !dbg !190 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !191, metadata !DIExpression()), !dbg !192
  %2 = ptrtoint i8* %0 to i64, !dbg !193
  call void @llvm.dbg.value(metadata i64 %2, metadata !194, metadata !DIExpression()), !dbg !192
  %3 = add nsw i64 %2, 1, !dbg !195
  %4 = trunc i64 %3 to i32, !dbg !196
  %5 = call i32 @get(i32 noundef %4), !dbg !197
  %6 = getelementptr inbounds [2 x i32], [2 x i32]* @read_flag, i64 0, i64 %2, !dbg !198
  store i32 %5, i32* %6, align 4, !dbg !199
  fence acquire, !dbg !200
  %7 = getelementptr inbounds [2 x i32], [2 x i32]* @data, i64 0, i64 %2, !dbg !201
  %8 = load atomic i32, i32* %7 monotonic, align 4, !dbg !202
  %9 = getelementptr inbounds [2 x i32], [2 x i32]* @read_data, i64 0, i64 %2, !dbg !203
  store i32 %8, i32* %9, align 4, !dbg !204
  ret i8* null, !dbg !205
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !206 {
  %1 = alloca [4 x i64], align 16
  call void @llvm.dbg.declare(metadata [4 x i64]* %1, metadata !209, metadata !DIExpression()), !dbg !215
  call void @init(), !dbg !216
  call void @llvm.dbg.value(metadata i32 0, metadata !217, metadata !DIExpression()), !dbg !219
  call void @llvm.dbg.value(metadata i64 0, metadata !217, metadata !DIExpression()), !dbg !219
  %2 = getelementptr inbounds [4 x i64], [4 x i64]* %1, i64 0, i64 0, !dbg !220
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_1, i8* noundef null) #6, !dbg !222
  call void @llvm.dbg.value(metadata i64 1, metadata !217, metadata !DIExpression()), !dbg !219
  call void @llvm.dbg.value(metadata i64 1, metadata !217, metadata !DIExpression()), !dbg !219
  %4 = getelementptr inbounds [4 x i64], [4 x i64]* %1, i64 0, i64 1, !dbg !220
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_1, i8* noundef inttoptr (i64 1 to i8*)) #6, !dbg !222
  call void @llvm.dbg.value(metadata i64 2, metadata !217, metadata !DIExpression()), !dbg !219
  call void @llvm.dbg.value(metadata i64 2, metadata !217, metadata !DIExpression()), !dbg !219
  call void @llvm.dbg.value(metadata i32 0, metadata !223, metadata !DIExpression()), !dbg !225
  call void @llvm.dbg.value(metadata i64 0, metadata !223, metadata !DIExpression()), !dbg !225
  %6 = getelementptr inbounds [4 x i64], [4 x i64]* %1, i64 0, i64 2, !dbg !226
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_2, i8* noundef null) #6, !dbg !228
  call void @llvm.dbg.value(metadata i64 1, metadata !223, metadata !DIExpression()), !dbg !225
  call void @llvm.dbg.value(metadata i64 1, metadata !223, metadata !DIExpression()), !dbg !225
  %8 = getelementptr inbounds [4 x i64], [4 x i64]* %1, i64 0, i64 3, !dbg !226
  %9 = call i32 @pthread_create(i64* noundef %8, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_2, i8* noundef inttoptr (i64 1 to i8*)) #6, !dbg !228
  call void @llvm.dbg.value(metadata i64 2, metadata !223, metadata !DIExpression()), !dbg !225
  call void @llvm.dbg.value(metadata i64 2, metadata !223, metadata !DIExpression()), !dbg !225
  call void @llvm.dbg.value(metadata i32 0, metadata !229, metadata !DIExpression()), !dbg !231
  call void @llvm.dbg.value(metadata i64 0, metadata !229, metadata !DIExpression()), !dbg !231
  %10 = load i64, i64* %2, align 8, !dbg !232
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !234
  call void @llvm.dbg.value(metadata i64 1, metadata !229, metadata !DIExpression()), !dbg !231
  call void @llvm.dbg.value(metadata i64 1, metadata !229, metadata !DIExpression()), !dbg !231
  %12 = load i64, i64* %4, align 8, !dbg !232
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !234
  call void @llvm.dbg.value(metadata i64 2, metadata !229, metadata !DIExpression()), !dbg !231
  call void @llvm.dbg.value(metadata i64 2, metadata !229, metadata !DIExpression()), !dbg !231
  %14 = load i64, i64* %6, align 8, !dbg !232
  %15 = call i32 @pthread_join(i64 noundef %14, i8** noundef null), !dbg !234
  call void @llvm.dbg.value(metadata i64 3, metadata !229, metadata !DIExpression()), !dbg !231
  call void @llvm.dbg.value(metadata i64 3, metadata !229, metadata !DIExpression()), !dbg !231
  %16 = load i64, i64* %8, align 8, !dbg !232
  %17 = call i32 @pthread_join(i64 noundef %16, i8** noundef null), !dbg !234
  call void @llvm.dbg.value(metadata i64 4, metadata !229, metadata !DIExpression()), !dbg !231
  call void @llvm.dbg.value(metadata i64 4, metadata !229, metadata !DIExpression()), !dbg !231
  call void @llvm.dbg.value(metadata i32 0, metadata !235, metadata !DIExpression()), !dbg !237
  call void @llvm.dbg.value(metadata i64 0, metadata !235, metadata !DIExpression()), !dbg !237
  %18 = load i32, i32* getelementptr inbounds ([2 x i32], [2 x i32]* @read_flag, i64 0, i64 0), align 4, !dbg !238
  %19 = icmp eq i32 %18, 1, !dbg !238
  %20 = load i32, i32* getelementptr inbounds ([2 x i32], [2 x i32]* @read_data, i64 0, i64 0), align 4, !dbg !238
  %21 = icmp eq i32 %20, 0, !dbg !238
  %or.cond = select i1 %19, i1 %21, i1 false, !dbg !238
  br i1 %or.cond, label %22, label %23, !dbg !238

22:                                               ; preds = %23, %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([42 x i8], [42 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @.str.4, i64 0, i64 0), i32 noundef 58, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !238
  unreachable, !dbg !238

23:                                               ; preds = %0
  call void @llvm.dbg.value(metadata i64 1, metadata !235, metadata !DIExpression()), !dbg !237
  call void @llvm.dbg.value(metadata i64 1, metadata !235, metadata !DIExpression()), !dbg !237
  %24 = load i32, i32* getelementptr inbounds ([2 x i32], [2 x i32]* @read_flag, i64 0, i64 1), align 4, !dbg !238
  %25 = icmp eq i32 %24, 1, !dbg !238
  %26 = load i32, i32* getelementptr inbounds ([2 x i32], [2 x i32]* @read_data, i64 0, i64 1), align 4, !dbg !238
  %27 = icmp eq i32 %26, 0, !dbg !238
  %or.cond19 = select i1 %25, i1 %27, i1 false, !dbg !238
  br i1 %or.cond19, label %22, label %28, !dbg !238

28:                                               ; preds = %23
  call void @llvm.dbg.value(metadata i64 2, metadata !235, metadata !DIExpression()), !dbg !237
  call void @llvm.dbg.value(metadata i64 2, metadata !235, metadata !DIExpression()), !dbg !237
  %29 = call i32 @count(), !dbg !242
  %30 = icmp eq i32 %29, 2, !dbg !242
  br i1 %30, label %32, label %31, !dbg !245

31:                                               ; preds = %28
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @.str.4, i64 0, i64 0), i32 noundef 60, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !242
  unreachable, !dbg !242

32:                                               ; preds = %28
  ret i32 0, !dbg !246
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

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
!llvm.module.flags = !{!44, !45, !46, !47, !48, !49, !50}
!llvm.ident = !{!51}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "m_entries", scope: !2, file: !38, line: 37, type: !39, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !23, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lfds/hash_table.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "0d5b25b3f89a0bc141405a258bb44f52")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 56, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.6/include/stdatomic.h", directory: "", checksumkind: CSK_MD5, checksum: "de5d66a1ef2f5448cc1919ff39db92bc")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0)
!10 = !DIEnumerator(name: "memory_order_consume", value: 1)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2)
!12 = !DIEnumerator(name: "memory_order_release", value: 3)
!13 = !DIEnumerator(name: "memory_order_acq_rel", value: 4)
!14 = !DIEnumerator(name: "memory_order_seq_cst", value: 5)
!15 = !{!16, !19, !20}
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !17, line: 87, baseType: !18)
!17 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "24103e292ae21916e87130b926c8d2f8")
!18 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!19 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !21, line: 46, baseType: !22)
!21 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.6/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!22 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!23 = !{!0, !24, !33, !36}
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !26, line: 11, type: !27, isLocal: false, isDefinition: true)
!26 = !DIFile(filename: "benchmarks/lfds/hash_table.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "0d5b25b3f89a0bc141405a258bb44f52")
!27 = !DICompositeType(tag: DW_TAG_array_type, baseType: !28, size: 64, elements: !31)
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !29)
!29 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !30)
!30 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!31 = !{!32}
!32 = !DISubrange(count: 2)
!33 = !DIGlobalVariableExpression(var: !34, expr: !DIExpression())
!34 = distinct !DIGlobalVariable(name: "read_flag", scope: !2, file: !26, line: 12, type: !35, isLocal: false, isDefinition: true)
!35 = !DICompositeType(tag: DW_TAG_array_type, baseType: !30, size: 64, elements: !31)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(name: "read_data", scope: !2, file: !26, line: 12, type: !35, isLocal: false, isDefinition: true)
!38 = !DIFile(filename: "benchmarks/lfds/hash_table.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "846237fdb21c6ddfed7b5119b31b88c6")
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !40, size: 128, elements: !31)
!40 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Entry", file: !38, line: 32, size: 64, elements: !41)
!41 = !{!42, !43}
!42 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !40, file: !38, line: 33, baseType: !28, size: 32)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !40, file: !38, line: 34, baseType: !28, size: 32, offset: 32)
!44 = !{i32 7, !"Dwarf Version", i32 5}
!45 = !{i32 2, !"Debug Info Version", i32 3}
!46 = !{i32 1, !"wchar_size", i32 4}
!47 = !{i32 7, !"PIC Level", i32 2}
!48 = !{i32 7, !"PIE Level", i32 2}
!49 = !{i32 7, !"uwtable", i32 1}
!50 = !{i32 7, !"frame-pointer", i32 2}
!51 = !{!"Ubuntu clang version 14.0.6"}
!52 = distinct !DISubprogram(name: "init", scope: !38, file: !38, line: 53, type: !53, scopeLine: 53, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!53 = !DISubroutineType(types: !54)
!54 = !{null}
!55 = !{}
!56 = !DILocalVariable(name: "i", scope: !57, file: !38, line: 54, type: !30)
!57 = distinct !DILexicalBlock(scope: !52, file: !38, line: 54, column: 5)
!58 = !DILocation(line: 0, scope: !57)
!59 = !DILocation(line: 55, column: 9, scope: !60)
!60 = distinct !DILexicalBlock(scope: !61, file: !38, line: 54, column: 36)
!61 = distinct !DILexicalBlock(scope: !57, file: !38, line: 54, column: 5)
!62 = !DILocation(line: 56, column: 9, scope: !60)
!63 = !DILocation(line: 58, column: 1, scope: !52)
!64 = distinct !DISubprogram(name: "set", scope: !38, file: !38, line: 60, type: !65, scopeLine: 61, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!65 = !DISubroutineType(types: !66)
!66 = !{null, !67, !67}
!67 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !68, line: 26, baseType: !69)
!68 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "d3ea318a915682aaf6645ec16ac9f991")
!69 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !70, line: 42, baseType: !7)
!70 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "f6304b1a6dcfc6bee76e9a51043b5090")
!71 = !DILocalVariable(name: "key", arg: 1, scope: !64, file: !38, line: 60, type: !67)
!72 = !DILocation(line: 0, scope: !64)
!73 = !DILocalVariable(name: "value", arg: 2, scope: !64, file: !38, line: 60, type: !67)
!74 = !DILocation(line: 62, column: 5, scope: !75)
!75 = distinct !DILexicalBlock(scope: !76, file: !38, line: 62, column: 5)
!76 = distinct !DILexicalBlock(scope: !64, file: !38, line: 62, column: 5)
!77 = !DILocation(line: 62, column: 5, scope: !76)
!78 = !DILocation(line: 63, column: 5, scope: !79)
!79 = distinct !DILexicalBlock(scope: !80, file: !38, line: 63, column: 5)
!80 = distinct !DILexicalBlock(scope: !64, file: !38, line: 63, column: 5)
!81 = !DILocation(line: 63, column: 5, scope: !80)
!82 = !DILocation(line: 65, column: 25, scope: !83)
!83 = distinct !DILexicalBlock(scope: !64, file: !38, line: 65, column: 5)
!84 = !DILocalVariable(name: "idx", scope: !83, file: !38, line: 65, type: !67)
!85 = !DILocation(line: 0, scope: !83)
!86 = !DILocation(line: 65, column: 10, scope: !83)
!87 = !DILocation(line: 67, column: 13, scope: !88)
!88 = distinct !DILexicalBlock(scope: !89, file: !38, line: 66, column: 5)
!89 = distinct !DILexicalBlock(scope: !83, file: !38, line: 65, column: 5)
!90 = !DILocation(line: 70, column: 52, scope: !88)
!91 = !DILocation(line: 70, column: 67, scope: !88)
!92 = !DILocation(line: 70, column: 30, scope: !88)
!93 = !DILocalVariable(name: "probedKey", scope: !88, file: !38, line: 70, type: !67)
!94 = !DILocation(line: 0, scope: !88)
!95 = !DILocation(line: 71, column: 23, scope: !96)
!96 = distinct !DILexicalBlock(scope: !88, file: !38, line: 71, column: 13)
!97 = !DILocation(line: 71, column: 13, scope: !88)
!98 = !DILocation(line: 73, column: 27, scope: !99)
!99 = distinct !DILexicalBlock(scope: !100, file: !38, line: 73, column: 17)
!100 = distinct !DILexicalBlock(scope: !96, file: !38, line: 71, column: 31)
!101 = !DILocation(line: 73, column: 17, scope: !100)
!102 = !DILocalVariable(name: "expected", scope: !100, file: !38, line: 77, type: !30)
!103 = !DILocation(line: 0, scope: !100)
!104 = !DILocation(line: 78, column: 34, scope: !100)
!105 = !DILocalVariable(name: "is_successful", scope: !100, file: !38, line: 78, type: !106)
!106 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!107 = !DILocation(line: 80, column: 27, scope: !108)
!108 = distinct !DILexicalBlock(scope: !100, file: !38, line: 80, column: 17)
!109 = !DILocation(line: 80, column: 33, scope: !108)
!110 = !DILocation(line: 87, column: 47, scope: !88)
!111 = !DILocation(line: 87, column: 9, scope: !88)
!112 = !DILocation(line: 88, column: 9, scope: !88)
!113 = !DILocation(line: 65, column: 47, scope: !89)
!114 = !DILocation(line: 65, column: 5, scope: !89)
!115 = distinct !{!115, !116, !117}
!116 = !DILocation(line: 65, column: 5, scope: !83)
!117 = !DILocation(line: 89, column: 5, scope: !83)
!118 = distinct !DISubprogram(name: "integerHash", scope: !38, file: !38, line: 39, type: !119, scopeLine: 40, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!119 = !DISubroutineType(types: !120)
!120 = !{!67, !67}
!121 = !DILocalVariable(name: "h", arg: 1, scope: !118, file: !38, line: 39, type: !67)
!122 = !DILocation(line: 0, scope: !118)
!123 = !DILocation(line: 50, column: 2, scope: !118)
!124 = distinct !DISubprogram(name: "get", scope: !38, file: !38, line: 92, type: !119, scopeLine: 93, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!125 = !DILocalVariable(name: "key", arg: 1, scope: !124, file: !38, line: 92, type: !67)
!126 = !DILocation(line: 0, scope: !124)
!127 = !DILocation(line: 94, column: 5, scope: !128)
!128 = distinct !DILexicalBlock(scope: !129, file: !38, line: 94, column: 5)
!129 = distinct !DILexicalBlock(scope: !124, file: !38, line: 94, column: 5)
!130 = !DILocation(line: 94, column: 5, scope: !129)
!131 = !DILocation(line: 96, column: 25, scope: !132)
!132 = distinct !DILexicalBlock(scope: !124, file: !38, line: 96, column: 5)
!133 = !DILocalVariable(name: "idx", scope: !132, file: !38, line: 96, type: !67)
!134 = !DILocation(line: 0, scope: !132)
!135 = !DILocation(line: 96, column: 10, scope: !132)
!136 = !DILocation(line: 98, column: 13, scope: !137)
!137 = distinct !DILexicalBlock(scope: !138, file: !38, line: 97, column: 5)
!138 = distinct !DILexicalBlock(scope: !132, file: !38, line: 96, column: 5)
!139 = !DILocation(line: 100, column: 52, scope: !137)
!140 = !DILocation(line: 100, column: 67, scope: !137)
!141 = !DILocation(line: 100, column: 30, scope: !137)
!142 = !DILocalVariable(name: "probedKey", scope: !137, file: !38, line: 100, type: !67)
!143 = !DILocation(line: 0, scope: !137)
!144 = !DILocation(line: 101, column: 23, scope: !145)
!145 = distinct !DILexicalBlock(scope: !137, file: !38, line: 101, column: 13)
!146 = !DILocation(line: 101, column: 13, scope: !137)
!147 = !DILocation(line: 102, column: 57, scope: !145)
!148 = !DILocation(line: 102, column: 20, scope: !145)
!149 = !DILocation(line: 102, column: 13, scope: !145)
!150 = !DILocation(line: 103, column: 23, scope: !151)
!151 = distinct !DILexicalBlock(scope: !137, file: !38, line: 103, column: 13)
!152 = !DILocation(line: 103, column: 13, scope: !137)
!153 = !DILocation(line: 96, column: 47, scope: !138)
!154 = !DILocation(line: 96, column: 5, scope: !138)
!155 = distinct !{!155, !156, !157}
!156 = !DILocation(line: 96, column: 5, scope: !132)
!157 = !DILocation(line: 105, column: 5, scope: !132)
!158 = !DILocation(line: 106, column: 1, scope: !124)
!159 = distinct !DISubprogram(name: "count", scope: !38, file: !38, line: 108, type: !160, scopeLine: 109, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!160 = !DISubroutineType(types: !161)
!161 = !{!67}
!162 = !DILocalVariable(name: "itemCount", scope: !159, file: !38, line: 110, type: !67)
!163 = !DILocation(line: 0, scope: !159)
!164 = !DILocalVariable(name: "idx", scope: !165, file: !38, line: 111, type: !67)
!165 = distinct !DILexicalBlock(scope: !159, file: !38, line: 111, column: 5)
!166 = !DILocation(line: 0, scope: !165)
!167 = !DILocation(line: 113, column: 14, scope: !168)
!168 = distinct !DILexicalBlock(scope: !169, file: !38, line: 113, column: 13)
!169 = distinct !DILexicalBlock(scope: !170, file: !38, line: 112, column: 5)
!170 = distinct !DILexicalBlock(scope: !165, file: !38, line: 111, column: 5)
!171 = !DILocation(line: 113, column: 78, scope: !168)
!172 = !DILocation(line: 114, column: 13, scope: !168)
!173 = !DILocation(line: 114, column: 17, scope: !168)
!174 = !DILocation(line: 114, column: 83, scope: !168)
!175 = !DILocation(line: 113, column: 13, scope: !169)
!176 = !DILocation(line: 117, column: 5, scope: !159)
!177 = distinct !DISubprogram(name: "thread_1", scope: !26, file: !26, line: 20, type: !178, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!178 = !DISubroutineType(types: !179)
!179 = !{!19, !19}
!180 = !DILocalVariable(name: "arg", arg: 1, scope: !177, file: !26, line: 20, type: !19)
!181 = !DILocation(line: 0, scope: !177)
!182 = !DILocation(line: 22, column: 21, scope: !177)
!183 = !DILocalVariable(name: "idx", scope: !177, file: !26, line: 22, type: !16)
!184 = !DILocation(line: 23, column: 28, scope: !177)
!185 = !DILocation(line: 23, column: 5, scope: !177)
!186 = !DILocation(line: 28, column: 13, scope: !177)
!187 = !DILocation(line: 28, column: 9, scope: !177)
!188 = !DILocation(line: 28, column: 5, scope: !177)
!189 = !DILocation(line: 29, column: 5, scope: !177)
!190 = distinct !DISubprogram(name: "thread_2", scope: !26, file: !26, line: 32, type: !178, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!191 = !DILocalVariable(name: "arg", arg: 1, scope: !190, file: !26, line: 32, type: !19)
!192 = !DILocation(line: 0, scope: !190)
!193 = !DILocation(line: 34, column: 21, scope: !190)
!194 = !DILocalVariable(name: "idx", scope: !190, file: !26, line: 34, type: !16)
!195 = !DILocation(line: 36, column: 30, scope: !190)
!196 = !DILocation(line: 36, column: 26, scope: !190)
!197 = !DILocation(line: 36, column: 22, scope: !190)
!198 = !DILocation(line: 36, column: 5, scope: !190)
!199 = !DILocation(line: 36, column: 20, scope: !190)
!200 = !DILocation(line: 37, column: 5, scope: !190)
!201 = !DILocation(line: 38, column: 44, scope: !190)
!202 = !DILocation(line: 38, column: 22, scope: !190)
!203 = !DILocation(line: 38, column: 5, scope: !190)
!204 = !DILocation(line: 38, column: 20, scope: !190)
!205 = !DILocation(line: 39, column: 5, scope: !190)
!206 = distinct !DISubprogram(name: "main", scope: !26, file: !26, line: 42, type: !207, scopeLine: 43, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!207 = !DISubroutineType(types: !208)
!208 = !{!30}
!209 = !DILocalVariable(name: "t", scope: !206, file: !26, line: 44, type: !210)
!210 = !DICompositeType(tag: DW_TAG_array_type, baseType: !211, size: 256, elements: !213)
!211 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !212, line: 27, baseType: !22)
!212 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!213 = !{!214}
!214 = !DISubrange(count: 4)
!215 = !DILocation(line: 44, column: 15, scope: !206)
!216 = !DILocation(line: 46, column: 5, scope: !206)
!217 = !DILocalVariable(name: "i", scope: !218, file: !26, line: 48, type: !30)
!218 = distinct !DILexicalBlock(scope: !206, file: !26, line: 48, column: 5)
!219 = !DILocation(line: 0, scope: !218)
!220 = !DILocation(line: 49, column: 25, scope: !221)
!221 = distinct !DILexicalBlock(scope: !218, file: !26, line: 48, column: 5)
!222 = !DILocation(line: 49, column: 9, scope: !221)
!223 = !DILocalVariable(name: "i", scope: !224, file: !26, line: 51, type: !30)
!224 = distinct !DILexicalBlock(scope: !206, file: !26, line: 51, column: 5)
!225 = !DILocation(line: 0, scope: !224)
!226 = !DILocation(line: 52, column: 25, scope: !227)
!227 = distinct !DILexicalBlock(scope: !224, file: !26, line: 51, column: 5)
!228 = !DILocation(line: 52, column: 9, scope: !227)
!229 = !DILocalVariable(name: "i", scope: !230, file: !26, line: 54, type: !30)
!230 = distinct !DILexicalBlock(scope: !206, file: !26, line: 54, column: 5)
!231 = !DILocation(line: 0, scope: !230)
!232 = !DILocation(line: 55, column: 22, scope: !233)
!233 = distinct !DILexicalBlock(scope: !230, file: !26, line: 54, column: 5)
!234 = !DILocation(line: 55, column: 9, scope: !233)
!235 = !DILocalVariable(name: "i", scope: !236, file: !26, line: 57, type: !30)
!236 = distinct !DILexicalBlock(scope: !206, file: !26, line: 57, column: 5)
!237 = !DILocation(line: 0, scope: !236)
!238 = !DILocation(line: 58, column: 9, scope: !239)
!239 = distinct !DILexicalBlock(scope: !240, file: !26, line: 58, column: 9)
!240 = distinct !DILexicalBlock(scope: !241, file: !26, line: 58, column: 9)
!241 = distinct !DILexicalBlock(scope: !236, file: !26, line: 57, column: 5)
!242 = !DILocation(line: 60, column: 5, scope: !243)
!243 = distinct !DILexicalBlock(scope: !244, file: !26, line: 60, column: 5)
!244 = distinct !DILexicalBlock(scope: !206, file: !26, line: 60, column: 5)
!245 = !DILocation(line: 60, column: 5, scope: !244)
!246 = !DILocation(line: 62, column: 5, scope: !206)
