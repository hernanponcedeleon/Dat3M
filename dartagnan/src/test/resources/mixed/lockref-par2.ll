; ModuleID = '/home/drc/git/Dat3M/benchmarks/mixed/lockref-par2.c'
source_filename = "/home/drc/git/Dat3M/benchmarks/mixed/lockref-par2.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.lockref = type { %union.anon }
%union.anon = type { i64 }
%struct.spinlock_s = type { i32 }
%struct.anon = type { %struct.spinlock_s, i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@my_lockref = dso_local global %struct.lockref zeroinitializer, align 8, !dbg !0
@.str = private unnamed_addr constant [22 x i8] c"my_lockref.count >= 0\00", align 1
@.str.1 = private unnamed_addr constant [52 x i8] c"/home/drc/git/Dat3M/benchmarks/mixed/lockref-par2.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1
@.str.2 = private unnamed_addr constant [29 x i8] c"my_lockref.count <= NTHREADS\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @await_for_lock(%struct.spinlock_s* noundef %0) #0 !dbg !58 {
  %2 = alloca %struct.spinlock_s*, align 8
  %3 = alloca i32, align 4
  store %struct.spinlock_s* %0, %struct.spinlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.spinlock_s** %2, metadata !63, metadata !DIExpression()), !dbg !64
  br label %4, !dbg !65

4:                                                ; preds = %10, %1
  %5 = load %struct.spinlock_s*, %struct.spinlock_s** %2, align 8, !dbg !66
  %6 = getelementptr inbounds %struct.spinlock_s, %struct.spinlock_s* %5, i32 0, i32 0, !dbg !67
  %7 = load atomic i32, i32* %6 monotonic, align 4, !dbg !68
  store i32 %7, i32* %3, align 4, !dbg !68
  %8 = load i32, i32* %3, align 4, !dbg !68
  %9 = icmp ne i32 %8, 0, !dbg !69
  br i1 %9, label %10, label %11, !dbg !65

10:                                               ; preds = %4
  br label %4, !dbg !65, !llvm.loop !70

11:                                               ; preds = %4
  ret void, !dbg !73
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @try_get_lock(%struct.spinlock_s* noundef %0) #0 !dbg !74 {
  %2 = alloca %struct.spinlock_s*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  store %struct.spinlock_s* %0, %struct.spinlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.spinlock_s** %2, metadata !77, metadata !DIExpression()), !dbg !78
  call void @llvm.dbg.declare(metadata i32* %3, metadata !79, metadata !DIExpression()), !dbg !80
  store i32 0, i32* %3, align 4, !dbg !80
  %6 = load %struct.spinlock_s*, %struct.spinlock_s** %2, align 8, !dbg !81
  %7 = getelementptr inbounds %struct.spinlock_s, %struct.spinlock_s* %6, i32 0, i32 0, !dbg !82
  store i32 1, i32* %4, align 4, !dbg !83
  %8 = load i32, i32* %3, align 4, !dbg !83
  %9 = load i32, i32* %4, align 4, !dbg !83
  %10 = cmpxchg i32* %7, i32 %8, i32 %9 acquire acquire, align 4, !dbg !83
  %11 = extractvalue { i32, i1 } %10, 0, !dbg !83
  %12 = extractvalue { i32, i1 } %10, 1, !dbg !83
  br i1 %12, label %14, label %13, !dbg !83

13:                                               ; preds = %1
  store i32 %11, i32* %3, align 4, !dbg !83
  br label %14, !dbg !83

14:                                               ; preds = %13, %1
  %15 = zext i1 %12 to i8, !dbg !83
  store i8 %15, i8* %5, align 1, !dbg !83
  %16 = load i8, i8* %5, align 1, !dbg !83
  %17 = trunc i8 %16 to i1, !dbg !83
  %18 = zext i1 %17 to i32, !dbg !83
  ret i32 %18, !dbg !84
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @spin_lock(%struct.spinlock_s* noundef %0) #0 !dbg !85 {
  %2 = alloca %struct.spinlock_s*, align 8
  store %struct.spinlock_s* %0, %struct.spinlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.spinlock_s** %2, metadata !86, metadata !DIExpression()), !dbg !87
  br label %3, !dbg !88

3:                                                ; preds = %5, %1
  %4 = load %struct.spinlock_s*, %struct.spinlock_s** %2, align 8, !dbg !89
  call void @await_for_lock(%struct.spinlock_s* noundef %4), !dbg !91
  br label %5, !dbg !92

5:                                                ; preds = %3
  %6 = load %struct.spinlock_s*, %struct.spinlock_s** %2, align 8, !dbg !93
  %7 = call i32 @try_get_lock(%struct.spinlock_s* noundef %6), !dbg !94
  %8 = icmp ne i32 %7, 0, !dbg !95
  %9 = xor i1 %8, true, !dbg !95
  br i1 %9, label %3, label %10, !dbg !92, !llvm.loop !96

10:                                               ; preds = %5
  ret void, !dbg !98
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @spin_unlock(%struct.spinlock_s* noundef %0) #0 !dbg !99 {
  %2 = alloca %struct.spinlock_s*, align 8
  %3 = alloca i32, align 4
  store %struct.spinlock_s* %0, %struct.spinlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.spinlock_s** %2, metadata !100, metadata !DIExpression()), !dbg !101
  %4 = load %struct.spinlock_s*, %struct.spinlock_s** %2, align 8, !dbg !102
  %5 = getelementptr inbounds %struct.spinlock_s, %struct.spinlock_s* %4, i32 0, i32 0, !dbg !103
  store i32 0, i32* %3, align 4, !dbg !104
  %6 = load i32, i32* %3, align 4, !dbg !104
  store atomic i32 %6, i32* %5 release, align 4, !dbg !104
  ret void, !dbg !105
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @lockref_get(%struct.lockref* noundef %0) #0 !dbg !106 {
  %2 = alloca %struct.lockref*, align 8
  %3 = alloca %struct.lockref, align 8
  %4 = alloca i64, align 8
  %5 = alloca %struct.lockref, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8, align 1
  store %struct.lockref* %0, %struct.lockref** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.lockref** %2, metadata !110, metadata !DIExpression()), !dbg !111
  br label %8, !dbg !112

8:                                                ; preds = %1
  call void @llvm.dbg.declare(metadata %struct.lockref* %3, metadata !113, metadata !DIExpression()), !dbg !115
  %9 = load %struct.lockref*, %struct.lockref** %2, align 8, !dbg !115
  %10 = getelementptr inbounds %struct.lockref, %struct.lockref* %9, i32 0, i32 0, !dbg !115
  %11 = bitcast %union.anon* %10 to i64*, !dbg !115
  %12 = load atomic i64, i64* %11 seq_cst, align 8, !dbg !115
  store i64 %12, i64* %4, align 8, !dbg !115
  %13 = load i64, i64* %4, align 8, !dbg !115
  %14 = getelementptr inbounds %struct.lockref, %struct.lockref* %3, i32 0, i32 0, !dbg !115
  %15 = bitcast %union.anon* %14 to i64*, !dbg !115
  store atomic i64 %13, i64* %15 seq_cst, align 8, !dbg !115
  br label %16, !dbg !115

16:                                               ; preds = %49, %8
  %17 = getelementptr inbounds %struct.lockref, %struct.lockref* %3, i32 0, i32 0, !dbg !115
  %18 = bitcast %union.anon* %17 to %struct.anon*, !dbg !115
  %19 = getelementptr inbounds %struct.anon, %struct.anon* %18, i32 0, i32 0, !dbg !115
  %20 = getelementptr inbounds %struct.spinlock_s, %struct.spinlock_s* %19, i32 0, i32 0, !dbg !115
  %21 = load atomic i32, i32* %20 seq_cst, align 4, !dbg !115
  %22 = icmp eq i32 %21, 0, !dbg !115
  br i1 %22, label %23, label %50, !dbg !115

23:                                               ; preds = %16
  call void @llvm.dbg.declare(metadata %struct.lockref* %5, metadata !116, metadata !DIExpression()), !dbg !118
  %24 = bitcast %struct.lockref* %5 to i8*, !dbg !118
  %25 = bitcast %struct.lockref* %3 to i8*, !dbg !118
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %24, i8* align 8 %25, i64 8, i1 false), !dbg !118
  %26 = getelementptr inbounds %struct.lockref, %struct.lockref* %5, i32 0, i32 0, !dbg !118
  %27 = bitcast %union.anon* %26 to %struct.anon*, !dbg !118
  %28 = getelementptr inbounds %struct.anon, %struct.anon* %27, i32 0, i32 1, !dbg !118
  %29 = atomicrmw add i32* %28, i32 1 seq_cst, align 4, !dbg !118
  %30 = load %struct.lockref*, %struct.lockref** %2, align 8, !dbg !119
  %31 = getelementptr inbounds %struct.lockref, %struct.lockref* %30, i32 0, i32 0, !dbg !119
  %32 = bitcast %union.anon* %31 to i64*, !dbg !119
  %33 = getelementptr inbounds %struct.lockref, %struct.lockref* %3, i32 0, i32 0, !dbg !119
  %34 = bitcast %union.anon* %33 to i64*, !dbg !119
  %35 = getelementptr inbounds %struct.lockref, %struct.lockref* %5, i32 0, i32 0, !dbg !119
  %36 = bitcast %union.anon* %35 to i64*, !dbg !119
  %37 = load atomic i64, i64* %36 seq_cst, align 8, !dbg !119
  store i64 %37, i64* %6, align 8, !dbg !119
  %38 = load i64, i64* %34, align 8, !dbg !119
  %39 = load i64, i64* %6, align 8, !dbg !119
  %40 = cmpxchg i64* %32, i64 %38, i64 %39 seq_cst seq_cst, align 8, !dbg !119
  %41 = extractvalue { i64, i1 } %40, 0, !dbg !119
  %42 = extractvalue { i64, i1 } %40, 1, !dbg !119
  br i1 %42, label %44, label %43, !dbg !119

43:                                               ; preds = %23
  store i64 %41, i64* %34, align 8, !dbg !119
  br label %44, !dbg !119

44:                                               ; preds = %43, %23
  %45 = zext i1 %42 to i8, !dbg !119
  store i8 %45, i8* %7, align 1, !dbg !119
  %46 = load i8, i8* %7, align 1, !dbg !119
  %47 = trunc i8 %46 to i1, !dbg !119
  br i1 %47, label %48, label %49, !dbg !118

48:                                               ; preds = %44
  br label %65, !dbg !121

49:                                               ; preds = %44
  br label %16, !dbg !115, !llvm.loop !123

50:                                               ; preds = %16
  br label %51, !dbg !115

51:                                               ; preds = %50
  %52 = load %struct.lockref*, %struct.lockref** %2, align 8, !dbg !124
  %53 = getelementptr inbounds %struct.lockref, %struct.lockref* %52, i32 0, i32 0, !dbg !125
  %54 = bitcast %union.anon* %53 to %struct.anon*, !dbg !125
  %55 = getelementptr inbounds %struct.anon, %struct.anon* %54, i32 0, i32 0, !dbg !125
  call void @spin_lock(%struct.spinlock_s* noundef %55), !dbg !126
  %56 = load %struct.lockref*, %struct.lockref** %2, align 8, !dbg !127
  %57 = getelementptr inbounds %struct.lockref, %struct.lockref* %56, i32 0, i32 0, !dbg !128
  %58 = bitcast %union.anon* %57 to %struct.anon*, !dbg !128
  %59 = getelementptr inbounds %struct.anon, %struct.anon* %58, i32 0, i32 1, !dbg !128
  %60 = atomicrmw add i32* %59, i32 1 seq_cst, align 4, !dbg !129
  %61 = load %struct.lockref*, %struct.lockref** %2, align 8, !dbg !130
  %62 = getelementptr inbounds %struct.lockref, %struct.lockref* %61, i32 0, i32 0, !dbg !131
  %63 = bitcast %union.anon* %62 to %struct.anon*, !dbg !131
  %64 = getelementptr inbounds %struct.anon, %struct.anon* %63, i32 0, i32 0, !dbg !131
  call void @spin_unlock(%struct.spinlock_s* noundef %64), !dbg !132
  br label %65, !dbg !133

65:                                               ; preds = %51, %48
  ret void, !dbg !133
}

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @lockref_put_return(%struct.lockref* noundef %0) #0 !dbg !134 {
  %2 = alloca i32, align 4
  %3 = alloca %struct.lockref*, align 8
  %4 = alloca %struct.lockref, align 8
  %5 = alloca i64, align 8
  %6 = alloca %struct.lockref, align 8
  %7 = alloca i64, align 8
  %8 = alloca i8, align 1
  store %struct.lockref* %0, %struct.lockref** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.lockref** %3, metadata !137, metadata !DIExpression()), !dbg !138
  br label %9, !dbg !139

9:                                                ; preds = %1
  call void @llvm.dbg.declare(metadata %struct.lockref* %4, metadata !140, metadata !DIExpression()), !dbg !142
  %10 = load %struct.lockref*, %struct.lockref** %3, align 8, !dbg !142
  %11 = getelementptr inbounds %struct.lockref, %struct.lockref* %10, i32 0, i32 0, !dbg !142
  %12 = bitcast %union.anon* %11 to i64*, !dbg !142
  %13 = load atomic i64, i64* %12 seq_cst, align 8, !dbg !142
  store i64 %13, i64* %5, align 8, !dbg !142
  %14 = load i64, i64* %5, align 8, !dbg !142
  %15 = getelementptr inbounds %struct.lockref, %struct.lockref* %4, i32 0, i32 0, !dbg !142
  %16 = bitcast %union.anon* %15 to i64*, !dbg !142
  store atomic i64 %14, i64* %16 seq_cst, align 8, !dbg !142
  br label %17, !dbg !142

17:                                               ; preds = %61, %9
  %18 = getelementptr inbounds %struct.lockref, %struct.lockref* %4, i32 0, i32 0, !dbg !142
  %19 = bitcast %union.anon* %18 to %struct.anon*, !dbg !142
  %20 = getelementptr inbounds %struct.anon, %struct.anon* %19, i32 0, i32 0, !dbg !142
  %21 = getelementptr inbounds %struct.spinlock_s, %struct.spinlock_s* %20, i32 0, i32 0, !dbg !142
  %22 = load atomic i32, i32* %21 seq_cst, align 4, !dbg !142
  %23 = icmp eq i32 %22, 0, !dbg !142
  br i1 %23, label %24, label %62, !dbg !142

24:                                               ; preds = %17
  call void @llvm.dbg.declare(metadata %struct.lockref* %6, metadata !143, metadata !DIExpression()), !dbg !145
  %25 = bitcast %struct.lockref* %6 to i8*, !dbg !145
  %26 = bitcast %struct.lockref* %4 to i8*, !dbg !145
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %25, i8* align 8 %26, i64 8, i1 false), !dbg !145
  %27 = getelementptr inbounds %struct.lockref, %struct.lockref* %6, i32 0, i32 0, !dbg !145
  %28 = bitcast %union.anon* %27 to %struct.anon*, !dbg !145
  %29 = getelementptr inbounds %struct.anon, %struct.anon* %28, i32 0, i32 1, !dbg !145
  %30 = atomicrmw sub i32* %29, i32 1 seq_cst, align 4, !dbg !145
  %31 = getelementptr inbounds %struct.lockref, %struct.lockref* %4, i32 0, i32 0, !dbg !146
  %32 = bitcast %union.anon* %31 to %struct.anon*, !dbg !146
  %33 = getelementptr inbounds %struct.anon, %struct.anon* %32, i32 0, i32 1, !dbg !146
  %34 = load atomic i32, i32* %33 seq_cst, align 4, !dbg !146
  %35 = icmp sle i32 %34, 0, !dbg !146
  br i1 %35, label %36, label %37, !dbg !145

36:                                               ; preds = %24
  store i32 -1, i32* %2, align 4, !dbg !146
  br label %64, !dbg !146

37:                                               ; preds = %24
  %38 = load %struct.lockref*, %struct.lockref** %3, align 8, !dbg !148
  %39 = getelementptr inbounds %struct.lockref, %struct.lockref* %38, i32 0, i32 0, !dbg !148
  %40 = bitcast %union.anon* %39 to i64*, !dbg !148
  %41 = getelementptr inbounds %struct.lockref, %struct.lockref* %4, i32 0, i32 0, !dbg !148
  %42 = bitcast %union.anon* %41 to i64*, !dbg !148
  %43 = getelementptr inbounds %struct.lockref, %struct.lockref* %6, i32 0, i32 0, !dbg !148
  %44 = bitcast %union.anon* %43 to i64*, !dbg !148
  %45 = load atomic i64, i64* %44 seq_cst, align 8, !dbg !148
  store i64 %45, i64* %7, align 8, !dbg !148
  %46 = load i64, i64* %42, align 8, !dbg !148
  %47 = load i64, i64* %7, align 8, !dbg !148
  %48 = cmpxchg i64* %40, i64 %46, i64 %47 seq_cst seq_cst, align 8, !dbg !148
  %49 = extractvalue { i64, i1 } %48, 0, !dbg !148
  %50 = extractvalue { i64, i1 } %48, 1, !dbg !148
  br i1 %50, label %52, label %51, !dbg !148

51:                                               ; preds = %37
  store i64 %49, i64* %42, align 8, !dbg !148
  br label %52, !dbg !148

52:                                               ; preds = %51, %37
  %53 = zext i1 %50 to i8, !dbg !148
  store i8 %53, i8* %8, align 1, !dbg !148
  %54 = load i8, i8* %8, align 1, !dbg !148
  %55 = trunc i8 %54 to i1, !dbg !148
  br i1 %55, label %56, label %61, !dbg !145

56:                                               ; preds = %52
  %57 = getelementptr inbounds %struct.lockref, %struct.lockref* %6, i32 0, i32 0, !dbg !150
  %58 = bitcast %union.anon* %57 to %struct.anon*, !dbg !150
  %59 = getelementptr inbounds %struct.anon, %struct.anon* %58, i32 0, i32 1, !dbg !150
  %60 = load atomic i32, i32* %59 seq_cst, align 4, !dbg !150
  store i32 %60, i32* %2, align 4, !dbg !150
  br label %64, !dbg !150

61:                                               ; preds = %52
  br label %17, !dbg !142, !llvm.loop !152

62:                                               ; preds = %17
  br label %63, !dbg !142

63:                                               ; preds = %62
  store i32 -1, i32* %2, align 4, !dbg !153
  br label %64, !dbg !153

64:                                               ; preds = %63, %56, %36
  %65 = load i32, i32* %2, align 4, !dbg !154
  ret i32 %65, !dbg !154
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @get(i8* noundef %0) #0 !dbg !155 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !158, metadata !DIExpression()), !dbg !159
  call void @lockref_get(%struct.lockref* noundef @my_lockref), !dbg !160
  ret i8* null, !dbg !161
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @ret(i8* noundef %0) #0 !dbg !162 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !163, metadata !DIExpression()), !dbg !164
  %3 = call i32 @lockref_put_return(%struct.lockref* noundef @my_lockref), !dbg !165
  ret i8* null, !dbg !166
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !167 {
  %1 = alloca i32, align 4
  %2 = alloca [2 x i64], align 16
  %3 = alloca [2 x i64], align 16
  %4 = alloca i64, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [2 x i64]* %2, metadata !170, metadata !DIExpression()), !dbg !176
  call void @llvm.dbg.declare(metadata [2 x i64]* %3, metadata !177, metadata !DIExpression()), !dbg !178
  store i64 0, i64* %4, align 8, !dbg !179
  %9 = load i64, i64* %4, align 8, !dbg !179
  store atomic i64 %9, i64* getelementptr inbounds (%struct.lockref, %struct.lockref* @my_lockref, i32 0, i32 0, i32 0) seq_cst, align 8, !dbg !179
  call void @llvm.dbg.declare(metadata i32* %5, metadata !180, metadata !DIExpression()), !dbg !182
  store i32 0, i32* %5, align 4, !dbg !182
  br label %10, !dbg !183

10:                                               ; preds = %21, %0
  %11 = load i32, i32* %5, align 4, !dbg !184
  %12 = icmp slt i32 %11, 2, !dbg !186
  br i1 %12, label %13, label %24, !dbg !187

13:                                               ; preds = %10
  %14 = load i32, i32* %5, align 4, !dbg !188
  %15 = sext i32 %14 to i64, !dbg !189
  %16 = getelementptr inbounds [2 x i64], [2 x i64]* %2, i64 0, i64 %15, !dbg !189
  %17 = load i32, i32* %5, align 4, !dbg !190
  %18 = sext i32 %17 to i64, !dbg !191
  %19 = inttoptr i64 %18 to i8*, !dbg !192
  %20 = call i32 @pthread_create(i64* noundef %16, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @get, i8* noundef %19) #6, !dbg !193
  br label %21, !dbg !193

21:                                               ; preds = %13
  %22 = load i32, i32* %5, align 4, !dbg !194
  %23 = add nsw i32 %22, 1, !dbg !194
  store i32 %23, i32* %5, align 4, !dbg !194
  br label %10, !dbg !195, !llvm.loop !196

24:                                               ; preds = %10
  call void @llvm.dbg.declare(metadata i32* %6, metadata !198, metadata !DIExpression()), !dbg !200
  store i32 0, i32* %6, align 4, !dbg !200
  br label %25, !dbg !201

25:                                               ; preds = %36, %24
  %26 = load i32, i32* %6, align 4, !dbg !202
  %27 = icmp slt i32 %26, 2, !dbg !204
  br i1 %27, label %28, label %39, !dbg !205

28:                                               ; preds = %25
  %29 = load i32, i32* %6, align 4, !dbg !206
  %30 = sext i32 %29 to i64, !dbg !207
  %31 = getelementptr inbounds [2 x i64], [2 x i64]* %3, i64 0, i64 %30, !dbg !207
  %32 = load i32, i32* %6, align 4, !dbg !208
  %33 = sext i32 %32 to i64, !dbg !209
  %34 = inttoptr i64 %33 to i8*, !dbg !210
  %35 = call i32 @pthread_create(i64* noundef %31, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @ret, i8* noundef %34) #6, !dbg !211
  br label %36, !dbg !211

36:                                               ; preds = %28
  %37 = load i32, i32* %6, align 4, !dbg !212
  %38 = add nsw i32 %37, 1, !dbg !212
  store i32 %38, i32* %6, align 4, !dbg !212
  br label %25, !dbg !213, !llvm.loop !214

39:                                               ; preds = %25
  call void @llvm.dbg.declare(metadata i32* %7, metadata !216, metadata !DIExpression()), !dbg !218
  store i32 0, i32* %7, align 4, !dbg !218
  br label %40, !dbg !219

40:                                               ; preds = %49, %39
  %41 = load i32, i32* %7, align 4, !dbg !220
  %42 = icmp slt i32 %41, 2, !dbg !222
  br i1 %42, label %43, label %52, !dbg !223

43:                                               ; preds = %40
  %44 = load i32, i32* %7, align 4, !dbg !224
  %45 = sext i32 %44 to i64, !dbg !225
  %46 = getelementptr inbounds [2 x i64], [2 x i64]* %2, i64 0, i64 %45, !dbg !225
  %47 = load i64, i64* %46, align 8, !dbg !225
  %48 = call i32 @pthread_join(i64 noundef %47, i8** noundef null), !dbg !226
  br label %49, !dbg !226

49:                                               ; preds = %43
  %50 = load i32, i32* %7, align 4, !dbg !227
  %51 = add nsw i32 %50, 1, !dbg !227
  store i32 %51, i32* %7, align 4, !dbg !227
  br label %40, !dbg !228, !llvm.loop !229

52:                                               ; preds = %40
  %53 = load atomic i32, i32* getelementptr inbounds (%struct.anon, %struct.anon* bitcast (%struct.lockref* @my_lockref to %struct.anon*), i32 0, i32 1) seq_cst, align 4, !dbg !231
  %54 = icmp sge i32 %53, 0, !dbg !231
  br i1 %54, label %55, label %56, !dbg !234

55:                                               ; preds = %52
  br label %57, !dbg !234

56:                                               ; preds = %52
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.1, i64 0, i64 0), i32 noundef 40, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #7, !dbg !231
  unreachable, !dbg !231

57:                                               ; preds = %55
  %58 = load atomic i32, i32* getelementptr inbounds (%struct.anon, %struct.anon* bitcast (%struct.lockref* @my_lockref to %struct.anon*), i32 0, i32 1) seq_cst, align 4, !dbg !235
  %59 = icmp sle i32 %58, 2, !dbg !235
  br i1 %59, label %60, label %61, !dbg !238

60:                                               ; preds = %57
  br label %62, !dbg !238

61:                                               ; preds = %57
  call void @__assert_fail(i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.1, i64 0, i64 0), i32 noundef 41, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #7, !dbg !235
  unreachable, !dbg !235

62:                                               ; preds = %60
  call void @llvm.dbg.declare(metadata i32* %8, metadata !239, metadata !DIExpression()), !dbg !241
  store i32 0, i32* %8, align 4, !dbg !241
  br label %63, !dbg !242

63:                                               ; preds = %72, %62
  %64 = load i32, i32* %8, align 4, !dbg !243
  %65 = icmp slt i32 %64, 2, !dbg !245
  br i1 %65, label %66, label %75, !dbg !246

66:                                               ; preds = %63
  %67 = load i32, i32* %8, align 4, !dbg !247
  %68 = sext i32 %67 to i64, !dbg !248
  %69 = getelementptr inbounds [2 x i64], [2 x i64]* %3, i64 0, i64 %68, !dbg !248
  %70 = load i64, i64* %69, align 8, !dbg !248
  %71 = call i32 @pthread_join(i64 noundef %70, i8** noundef null), !dbg !249
  br label %72, !dbg !249

72:                                               ; preds = %66
  %73 = load i32, i32* %8, align 4, !dbg !250
  %74 = add nsw i32 %73, 1, !dbg !250
  store i32 %74, i32* %8, align 4, !dbg !250
  br label %63, !dbg !251, !llvm.loop !252

75:                                               ; preds = %63
  ret i32 0, !dbg !254
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #5

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly nofree nounwind willreturn }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nounwind }
attributes #7 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!50, !51, !52, !53, !54, !55, !56}
!llvm.ident = !{!57}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "my_lockref", scope: !2, file: !27, line: 10, type: !28, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !26, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/drc/git/Dat3M/benchmarks/mixed/lockref-par2.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "9872d3b44512805c085c6068f1eed744")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 56, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stdatomic.h", directory: "", checksumkind: CSK_MD5, checksum: "de5d66a1ef2f5448cc1919ff39db92bc")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0)
!10 = !DIEnumerator(name: "memory_order_consume", value: 1)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2)
!12 = !DIEnumerator(name: "memory_order_release", value: 3)
!13 = !DIEnumerator(name: "memory_order_acq_rel", value: 4)
!14 = !DIEnumerator(name: "memory_order_seq_cst", value: 5)
!15 = !{!16, !22, !23}
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "int64_t", file: !18, line: 27, baseType: !19)
!18 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "", checksumkind: CSK_MD5, checksum: "55bcbdc3159515ebd91d351a70d505f4")
!19 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !20, line: 44, baseType: !21)
!20 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!21 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!22 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !24, line: 46, baseType: !25)
!24 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!25 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!26 = !{!0}
!27 = !DIFile(filename: "benchmarks/mixed/lockref-par2.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "9872d3b44512805c085c6068f1eed744")
!28 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "lockref", file: !29, line: 20, size: 64, elements: !30)
!29 = !DIFile(filename: "benchmarks/mixed/lockref.h", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "b9ccda7396a151177f0d6861809a19d6")
!30 = !{!31}
!31 = !DIDerivedType(tag: DW_TAG_member, scope: !28, file: !29, line: 21, baseType: !32, size: 64)
!32 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !28, file: !29, line: 21, size: 64, elements: !33)
!33 = !{!34, !36}
!34 = !DIDerivedType(tag: DW_TAG_member, name: "lock_count", scope: !32, file: !29, line: 22, baseType: !35, size: 64)
!35 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !17)
!36 = !DIDerivedType(tag: DW_TAG_member, scope: !32, file: !29, line: 23, baseType: !37, size: 64)
!37 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !32, file: !29, line: 23, size: 64, elements: !38)
!38 = !{!39, !49}
!39 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !37, file: !29, line: 24, baseType: !40, size: 32)
!40 = !DIDerivedType(tag: DW_TAG_typedef, name: "spinlock_t", file: !41, line: 6, baseType: !42)
!41 = !DIFile(filename: "benchmarks/mixed/spinlock.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "9acf6b1095cd147e1cd717e2bbbf8495")
!42 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "spinlock_s", file: !41, line: 3, size: 32, elements: !43)
!43 = !{!44}
!44 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !42, file: !41, line: 4, baseType: !45, size: 32)
!45 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !46)
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !18, line: 26, baseType: !47)
!47 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !20, line: 41, baseType: !48)
!48 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "count", scope: !37, file: !29, line: 25, baseType: !45, size: 32, offset: 32)
!50 = !{i32 7, !"Dwarf Version", i32 5}
!51 = !{i32 2, !"Debug Info Version", i32 3}
!52 = !{i32 1, !"wchar_size", i32 4}
!53 = !{i32 7, !"PIC Level", i32 2}
!54 = !{i32 7, !"PIE Level", i32 2}
!55 = !{i32 7, !"uwtable", i32 1}
!56 = !{i32 7, !"frame-pointer", i32 2}
!57 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!58 = distinct !DISubprogram(name: "await_for_lock", scope: !41, file: !41, line: 8, type: !59, scopeLine: 9, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!59 = !DISubroutineType(types: !60)
!60 = !{null, !61}
!61 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !42, size: 64)
!62 = !{}
!63 = !DILocalVariable(name: "l", arg: 1, scope: !58, file: !41, line: 8, type: !61)
!64 = !DILocation(line: 8, column: 40, scope: !58)
!65 = !DILocation(line: 10, column: 5, scope: !58)
!66 = !DILocation(line: 10, column: 34, scope: !58)
!67 = !DILocation(line: 10, column: 37, scope: !58)
!68 = !DILocation(line: 10, column: 12, scope: !58)
!69 = !DILocation(line: 10, column: 65, scope: !58)
!70 = distinct !{!70, !65, !71, !72}
!71 = !DILocation(line: 10, column: 70, scope: !58)
!72 = !{!"llvm.loop.mustprogress"}
!73 = !DILocation(line: 11, column: 5, scope: !58)
!74 = distinct !DISubprogram(name: "try_get_lock", scope: !41, file: !41, line: 14, type: !75, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!75 = !DISubroutineType(types: !76)
!76 = !{!48, !61}
!77 = !DILocalVariable(name: "l", arg: 1, scope: !74, file: !41, line: 14, type: !61)
!78 = !DILocation(line: 14, column: 37, scope: !74)
!79 = !DILocalVariable(name: "val", scope: !74, file: !41, line: 16, type: !48)
!80 = !DILocation(line: 16, column: 9, scope: !74)
!81 = !DILocation(line: 17, column: 53, scope: !74)
!82 = !DILocation(line: 17, column: 56, scope: !74)
!83 = !DILocation(line: 17, column: 12, scope: !74)
!84 = !DILocation(line: 17, column: 5, scope: !74)
!85 = distinct !DISubprogram(name: "spin_lock", scope: !41, file: !41, line: 20, type: !59, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!86 = !DILocalVariable(name: "l", arg: 1, scope: !85, file: !41, line: 20, type: !61)
!87 = !DILocation(line: 20, column: 35, scope: !85)
!88 = !DILocation(line: 22, column: 5, scope: !85)
!89 = !DILocation(line: 23, column: 24, scope: !90)
!90 = distinct !DILexicalBlock(scope: !85, file: !41, line: 22, column: 8)
!91 = !DILocation(line: 23, column: 9, scope: !90)
!92 = !DILocation(line: 24, column: 5, scope: !90)
!93 = !DILocation(line: 24, column: 27, scope: !85)
!94 = !DILocation(line: 24, column: 14, scope: !85)
!95 = !DILocation(line: 24, column: 13, scope: !85)
!96 = distinct !{!96, !88, !97, !72}
!97 = !DILocation(line: 24, column: 29, scope: !85)
!98 = !DILocation(line: 25, column: 5, scope: !85)
!99 = distinct !DISubprogram(name: "spin_unlock", scope: !41, file: !41, line: 28, type: !59, scopeLine: 29, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!100 = !DILocalVariable(name: "l", arg: 1, scope: !99, file: !41, line: 28, type: !61)
!101 = !DILocation(line: 28, column: 37, scope: !99)
!102 = !DILocation(line: 30, column: 28, scope: !99)
!103 = !DILocation(line: 30, column: 31, scope: !99)
!104 = !DILocation(line: 30, column: 5, scope: !99)
!105 = !DILocation(line: 31, column: 1, scope: !99)
!106 = distinct !DISubprogram(name: "lockref_get", scope: !29, file: !29, line: 37, type: !107, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!107 = !DISubroutineType(types: !108)
!108 = !{null, !109}
!109 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !28, size: 64)
!110 = !DILocalVariable(name: "lockref", arg: 1, scope: !106, file: !29, line: 37, type: !109)
!111 = !DILocation(line: 37, column: 34, scope: !106)
!112 = !DILocation(line: 39, column: 9, scope: !106)
!113 = !DILocalVariable(name: "old", scope: !114, file: !29, line: 39, type: !28)
!114 = distinct !DILexicalBlock(scope: !106, file: !29, line: 39, column: 9)
!115 = !DILocation(line: 39, column: 9, scope: !114)
!116 = !DILocalVariable(name: "new", scope: !117, file: !29, line: 39, type: !28)
!117 = distinct !DILexicalBlock(scope: !114, file: !29, line: 39, column: 9)
!118 = !DILocation(line: 39, column: 9, scope: !117)
!119 = !DILocation(line: 39, column: 9, scope: !120)
!120 = distinct !DILexicalBlock(scope: !117, file: !29, line: 39, column: 9)
!121 = !DILocation(line: 39, column: 9, scope: !122)
!122 = distinct !DILexicalBlock(scope: !120, file: !29, line: 39, column: 9)
!123 = distinct !{!123, !115, !115, !72}
!124 = !DILocation(line: 45, column: 20, scope: !106)
!125 = !DILocation(line: 45, column: 29, scope: !106)
!126 = !DILocation(line: 45, column: 9, scope: !106)
!127 = !DILocation(line: 46, column: 9, scope: !106)
!128 = !DILocation(line: 46, column: 18, scope: !106)
!129 = !DILocation(line: 46, column: 23, scope: !106)
!130 = !DILocation(line: 47, column: 22, scope: !106)
!131 = !DILocation(line: 47, column: 31, scope: !106)
!132 = !DILocation(line: 47, column: 9, scope: !106)
!133 = !DILocation(line: 48, column: 1, scope: !106)
!134 = distinct !DISubprogram(name: "lockref_put_return", scope: !29, file: !29, line: 57, type: !135, scopeLine: 58, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!135 = !DISubroutineType(types: !136)
!136 = !{!48, !109}
!137 = !DILocalVariable(name: "lockref", arg: 1, scope: !134, file: !29, line: 57, type: !109)
!138 = !DILocation(line: 57, column: 40, scope: !134)
!139 = !DILocation(line: 59, column: 9, scope: !134)
!140 = !DILocalVariable(name: "old", scope: !141, file: !29, line: 59, type: !28)
!141 = distinct !DILexicalBlock(scope: !134, file: !29, line: 59, column: 9)
!142 = !DILocation(line: 59, column: 9, scope: !141)
!143 = !DILocalVariable(name: "new", scope: !144, file: !29, line: 59, type: !28)
!144 = distinct !DILexicalBlock(scope: !141, file: !29, line: 59, column: 9)
!145 = !DILocation(line: 59, column: 9, scope: !144)
!146 = !DILocation(line: 59, column: 9, scope: !147)
!147 = distinct !DILexicalBlock(scope: !144, file: !29, line: 59, column: 9)
!148 = !DILocation(line: 59, column: 9, scope: !149)
!149 = distinct !DILexicalBlock(scope: !144, file: !29, line: 59, column: 9)
!150 = !DILocation(line: 59, column: 9, scope: !151)
!151 = distinct !DILexicalBlock(scope: !149, file: !29, line: 59, column: 9)
!152 = distinct !{!152, !142, !142, !72}
!153 = !DILocation(line: 66, column: 9, scope: !134)
!154 = !DILocation(line: 67, column: 1, scope: !134)
!155 = distinct !DISubprogram(name: "get", scope: !27, file: !27, line: 12, type: !156, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!156 = !DISubroutineType(types: !157)
!157 = !{!22, !22}
!158 = !DILocalVariable(name: "unsued", arg: 1, scope: !155, file: !27, line: 12, type: !22)
!159 = !DILocation(line: 12, column: 17, scope: !155)
!160 = !DILocation(line: 14, column: 5, scope: !155)
!161 = !DILocation(line: 16, column: 5, scope: !155)
!162 = distinct !DISubprogram(name: "ret", scope: !27, file: !27, line: 19, type: !156, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!163 = !DILocalVariable(name: "unsued", arg: 1, scope: !162, file: !27, line: 19, type: !22)
!164 = !DILocation(line: 19, column: 17, scope: !162)
!165 = !DILocation(line: 21, column: 5, scope: !162)
!166 = !DILocation(line: 23, column: 5, scope: !162)
!167 = distinct !DISubprogram(name: "main", scope: !27, file: !27, line: 26, type: !168, scopeLine: 26, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!168 = !DISubroutineType(types: !169)
!169 = !{!48}
!170 = !DILocalVariable(name: "g", scope: !167, file: !27, line: 28, type: !171)
!171 = !DICompositeType(tag: DW_TAG_array_type, baseType: !172, size: 128, elements: !174)
!172 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !173, line: 27, baseType: !25)
!173 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!174 = !{!175}
!175 = !DISubrange(count: 2)
!176 = !DILocation(line: 28, column: 15, scope: !167)
!177 = !DILocalVariable(name: "r", scope: !167, file: !27, line: 29, type: !171)
!178 = !DILocation(line: 29, column: 15, scope: !167)
!179 = !DILocation(line: 31, column: 5, scope: !167)
!180 = !DILocalVariable(name: "i", scope: !181, file: !27, line: 33, type: !48)
!181 = distinct !DILexicalBlock(scope: !167, file: !27, line: 33, column: 5)
!182 = !DILocation(line: 33, column: 14, scope: !181)
!183 = !DILocation(line: 33, column: 10, scope: !181)
!184 = !DILocation(line: 33, column: 21, scope: !185)
!185 = distinct !DILexicalBlock(scope: !181, file: !27, line: 33, column: 5)
!186 = !DILocation(line: 33, column: 23, scope: !185)
!187 = !DILocation(line: 33, column: 5, scope: !181)
!188 = !DILocation(line: 34, column: 27, scope: !185)
!189 = !DILocation(line: 34, column: 25, scope: !185)
!190 = !DILocation(line: 34, column: 55, scope: !185)
!191 = !DILocation(line: 34, column: 47, scope: !185)
!192 = !DILocation(line: 34, column: 39, scope: !185)
!193 = !DILocation(line: 34, column: 9, scope: !185)
!194 = !DILocation(line: 33, column: 36, scope: !185)
!195 = !DILocation(line: 33, column: 5, scope: !185)
!196 = distinct !{!196, !187, !197, !72}
!197 = !DILocation(line: 34, column: 56, scope: !181)
!198 = !DILocalVariable(name: "i", scope: !199, file: !27, line: 35, type: !48)
!199 = distinct !DILexicalBlock(scope: !167, file: !27, line: 35, column: 5)
!200 = !DILocation(line: 35, column: 14, scope: !199)
!201 = !DILocation(line: 35, column: 10, scope: !199)
!202 = !DILocation(line: 35, column: 21, scope: !203)
!203 = distinct !DILexicalBlock(scope: !199, file: !27, line: 35, column: 5)
!204 = !DILocation(line: 35, column: 23, scope: !203)
!205 = !DILocation(line: 35, column: 5, scope: !199)
!206 = !DILocation(line: 36, column: 27, scope: !203)
!207 = !DILocation(line: 36, column: 25, scope: !203)
!208 = !DILocation(line: 36, column: 55, scope: !203)
!209 = !DILocation(line: 36, column: 47, scope: !203)
!210 = !DILocation(line: 36, column: 39, scope: !203)
!211 = !DILocation(line: 36, column: 9, scope: !203)
!212 = !DILocation(line: 35, column: 36, scope: !203)
!213 = !DILocation(line: 35, column: 5, scope: !203)
!214 = distinct !{!214, !205, !215, !72}
!215 = !DILocation(line: 36, column: 56, scope: !199)
!216 = !DILocalVariable(name: "i", scope: !217, file: !27, line: 38, type: !48)
!217 = distinct !DILexicalBlock(scope: !167, file: !27, line: 38, column: 5)
!218 = !DILocation(line: 38, column: 14, scope: !217)
!219 = !DILocation(line: 38, column: 10, scope: !217)
!220 = !DILocation(line: 38, column: 21, scope: !221)
!221 = distinct !DILexicalBlock(scope: !217, file: !27, line: 38, column: 5)
!222 = !DILocation(line: 38, column: 23, scope: !221)
!223 = !DILocation(line: 38, column: 5, scope: !217)
!224 = !DILocation(line: 39, column: 24, scope: !221)
!225 = !DILocation(line: 39, column: 22, scope: !221)
!226 = !DILocation(line: 39, column: 9, scope: !221)
!227 = !DILocation(line: 38, column: 36, scope: !221)
!228 = !DILocation(line: 38, column: 5, scope: !221)
!229 = distinct !{!229, !223, !230, !72}
!230 = !DILocation(line: 39, column: 29, scope: !217)
!231 = !DILocation(line: 40, column: 5, scope: !232)
!232 = distinct !DILexicalBlock(scope: !233, file: !27, line: 40, column: 5)
!233 = distinct !DILexicalBlock(scope: !167, file: !27, line: 40, column: 5)
!234 = !DILocation(line: 40, column: 5, scope: !233)
!235 = !DILocation(line: 41, column: 5, scope: !236)
!236 = distinct !DILexicalBlock(scope: !237, file: !27, line: 41, column: 5)
!237 = distinct !DILexicalBlock(scope: !167, file: !27, line: 41, column: 5)
!238 = !DILocation(line: 41, column: 5, scope: !237)
!239 = !DILocalVariable(name: "i", scope: !240, file: !27, line: 43, type: !48)
!240 = distinct !DILexicalBlock(scope: !167, file: !27, line: 43, column: 5)
!241 = !DILocation(line: 43, column: 14, scope: !240)
!242 = !DILocation(line: 43, column: 10, scope: !240)
!243 = !DILocation(line: 43, column: 21, scope: !244)
!244 = distinct !DILexicalBlock(scope: !240, file: !27, line: 43, column: 5)
!245 = !DILocation(line: 43, column: 23, scope: !244)
!246 = !DILocation(line: 43, column: 5, scope: !240)
!247 = !DILocation(line: 44, column: 24, scope: !244)
!248 = !DILocation(line: 44, column: 22, scope: !244)
!249 = !DILocation(line: 44, column: 9, scope: !244)
!250 = !DILocation(line: 43, column: 36, scope: !244)
!251 = !DILocation(line: 43, column: 5, scope: !244)
!252 = distinct !{!252, !246, !253, !72}
!253 = !DILocation(line: 44, column: 29, scope: !240)
!254 = !DILocation(line: 46, column: 5, scope: !167)
