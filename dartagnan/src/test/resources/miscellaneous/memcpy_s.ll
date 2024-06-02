; ModuleID = '/home/ponce/git/Dat3M/output/memcpy_s.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/memcpy_s.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@__const.main.a = private unnamed_addr constant [4 x i32] [i32 1, i32 2, i32 3, i32 4], align 16
@__const.main.b = private unnamed_addr constant [3 x i32] [i32 5, i32 6, i32 7], align 4
@.str = private unnamed_addr constant [8 x i8] c"ret > 0\00", align 1
@.str.1 = private unnamed_addr constant [60 x i8] c"/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/memcpy_s.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1
@.str.2 = private unnamed_addr constant [10 x i8] c"b[0] == 0\00", align 1
@.str.3 = private unnamed_addr constant [10 x i8] c"b[1] == 0\00", align 1
@.str.4 = private unnamed_addr constant [10 x i8] c"b[2] == 0\00", align 1
@.str.5 = private unnamed_addr constant [10 x i8] c"b[2] == 7\00", align 1
@.str.6 = private unnamed_addr constant [9 x i8] c"ret == 0\00", align 1
@.str.7 = private unnamed_addr constant [10 x i8] c"b[0] == 1\00", align 1
@.str.8 = private unnamed_addr constant [10 x i8] c"b[1] == 2\00", align 1
@.str.9 = private unnamed_addr constant [10 x i8] c"b[2] == 3\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !9 {
  %1 = alloca i32, align 4
  %2 = alloca [4 x i32], align 16
  %3 = alloca [3 x i32], align 4
  %4 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [4 x i32]* %2, metadata !14, metadata !DIExpression()), !dbg !18
  %5 = bitcast [4 x i32]* %2 to i8*, !dbg !18
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %5, i8* align 16 bitcast ([4 x i32]* @__const.main.a to i8*), i64 16, i1 false), !dbg !18
  call void @llvm.dbg.declare(metadata [3 x i32]* %3, metadata !19, metadata !DIExpression()), !dbg !23
  %6 = bitcast [3 x i32]* %3 to i8*, !dbg !23
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %6, i8* align 4 bitcast ([3 x i32]* @__const.main.b to i8*), i64 12, i1 false), !dbg !23
  call void @llvm.dbg.declare(metadata i32* %4, metadata !24, metadata !DIExpression()), !dbg !25
  %7 = getelementptr inbounds [4 x i32], [4 x i32]* %2, i64 0, i64 0, !dbg !26
  %8 = call i32 (i8*, i64, i32*, i64, ...) bitcast (i32 (...)* @memcpy_s to i32 (i8*, i64, i32*, i64, ...)*)(i8* null, i64 12, i32* %7, i64 12), !dbg !27
  store i32 %8, i32* %4, align 4, !dbg !28
  %9 = load i32, i32* %4, align 4, !dbg !29
  %10 = icmp sgt i32 %9, 0, !dbg !29
  br i1 %10, label %11, label %12, !dbg !32

11:                                               ; preds = %0
  br label %13, !dbg !32

12:                                               ; preds = %0
  call void @__assert_fail(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 14, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !29
  unreachable, !dbg !29

13:                                               ; preds = %11
  %14 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !33
  %15 = call i32 (i32*, i64, i8*, i64, ...) bitcast (i32 (...)* @memcpy_s to i32 (i32*, i64, i8*, i64, ...)*)(i32* %14, i64 12, i8* null, i64 12), !dbg !34
  store i32 %15, i32* %4, align 4, !dbg !35
  %16 = load i32, i32* %4, align 4, !dbg !36
  %17 = icmp sgt i32 %16, 0, !dbg !36
  br i1 %17, label %18, label %19, !dbg !39

18:                                               ; preds = %13
  br label %20, !dbg !39

19:                                               ; preds = %13
  call void @__assert_fail(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 18, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !36
  unreachable, !dbg !36

20:                                               ; preds = %18
  %21 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !40
  %22 = load i32, i32* %21, align 4, !dbg !40
  %23 = icmp eq i32 %22, 0, !dbg !40
  br i1 %23, label %24, label %25, !dbg !43

24:                                               ; preds = %20
  br label %26, !dbg !43

25:                                               ; preds = %20
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.2, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 19, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !40
  unreachable, !dbg !40

26:                                               ; preds = %24
  %27 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 1, !dbg !44
  %28 = load i32, i32* %27, align 4, !dbg !44
  %29 = icmp eq i32 %28, 0, !dbg !44
  br i1 %29, label %30, label %31, !dbg !47

30:                                               ; preds = %26
  br label %32, !dbg !47

31:                                               ; preds = %26
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.3, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 20, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !44
  unreachable, !dbg !44

32:                                               ; preds = %30
  %33 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 2, !dbg !48
  %34 = load i32, i32* %33, align 4, !dbg !48
  %35 = icmp eq i32 %34, 0, !dbg !48
  br i1 %35, label %36, label %37, !dbg !51

36:                                               ; preds = %32
  br label %38, !dbg !51

37:                                               ; preds = %32
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.4, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 21, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !48
  unreachable, !dbg !48

38:                                               ; preds = %36
  %39 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !52
  store i32 5, i32* %39, align 4, !dbg !53
  %40 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 1, !dbg !54
  store i32 6, i32* %40, align 4, !dbg !55
  %41 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 2, !dbg !56
  store i32 7, i32* %41, align 4, !dbg !57
  %42 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !58
  %43 = getelementptr inbounds [4 x i32], [4 x i32]* %2, i64 0, i64 0, !dbg !59
  %44 = call i32 (i32*, i64, i32*, i64, ...) bitcast (i32 (...)* @memcpy_s to i32 (i32*, i64, i32*, i64, ...)*)(i32* %42, i64 8, i32* %43, i64 16), !dbg !60
  store i32 %44, i32* %4, align 4, !dbg !61
  %45 = load i32, i32* %4, align 4, !dbg !62
  %46 = icmp sgt i32 %45, 0, !dbg !62
  br i1 %46, label %47, label %48, !dbg !65

47:                                               ; preds = %38
  br label %49, !dbg !65

48:                                               ; preds = %38
  call void @__assert_fail(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 28, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !62
  unreachable, !dbg !62

49:                                               ; preds = %47
  %50 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !66
  %51 = load i32, i32* %50, align 4, !dbg !66
  %52 = icmp eq i32 %51, 0, !dbg !66
  br i1 %52, label %53, label %54, !dbg !69

53:                                               ; preds = %49
  br label %55, !dbg !69

54:                                               ; preds = %49
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.2, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 29, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !66
  unreachable, !dbg !66

55:                                               ; preds = %53
  %56 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 1, !dbg !70
  %57 = load i32, i32* %56, align 4, !dbg !70
  %58 = icmp eq i32 %57, 0, !dbg !70
  br i1 %58, label %59, label %60, !dbg !73

59:                                               ; preds = %55
  br label %61, !dbg !73

60:                                               ; preds = %55
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.3, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 30, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !70
  unreachable, !dbg !70

61:                                               ; preds = %59
  %62 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 2, !dbg !74
  %63 = load i32, i32* %62, align 4, !dbg !74
  %64 = icmp eq i32 %63, 7, !dbg !74
  br i1 %64, label %65, label %66, !dbg !77

65:                                               ; preds = %61
  br label %67, !dbg !77

66:                                               ; preds = %61
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.5, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 32, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !74
  unreachable, !dbg !74

67:                                               ; preds = %65
  %68 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !78
  store i32 5, i32* %68, align 4, !dbg !79
  %69 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 1, !dbg !80
  store i32 6, i32* %69, align 4, !dbg !81
  %70 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 2, !dbg !82
  store i32 7, i32* %70, align 4, !dbg !83
  %71 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !84
  %72 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !85
  %73 = call i32 (i32*, i64, i32*, i64, ...) bitcast (i32 (...)* @memcpy_s to i32 (i32*, i64, i32*, i64, ...)*)(i32* %71, i64 12, i32* %72, i64 12), !dbg !86
  store i32 %73, i32* %4, align 4, !dbg !87
  %74 = load i32, i32* %4, align 4, !dbg !88
  %75 = icmp sgt i32 %74, 0, !dbg !88
  br i1 %75, label %76, label %77, !dbg !91

76:                                               ; preds = %67
  br label %78, !dbg !91

77:                                               ; preds = %67
  call void @__assert_fail(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 39, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !88
  unreachable, !dbg !88

78:                                               ; preds = %76
  %79 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !92
  %80 = load i32, i32* %79, align 4, !dbg !92
  %81 = icmp eq i32 %80, 0, !dbg !92
  br i1 %81, label %82, label %83, !dbg !95

82:                                               ; preds = %78
  br label %84, !dbg !95

83:                                               ; preds = %78
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.2, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 40, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !92
  unreachable, !dbg !92

84:                                               ; preds = %82
  %85 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 1, !dbg !96
  %86 = load i32, i32* %85, align 4, !dbg !96
  %87 = icmp eq i32 %86, 0, !dbg !96
  br i1 %87, label %88, label %89, !dbg !99

88:                                               ; preds = %84
  br label %90, !dbg !99

89:                                               ; preds = %84
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.3, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 41, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !96
  unreachable, !dbg !96

90:                                               ; preds = %88
  %91 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 2, !dbg !100
  %92 = load i32, i32* %91, align 4, !dbg !100
  %93 = icmp eq i32 %92, 0, !dbg !100
  br i1 %93, label %94, label %95, !dbg !103

94:                                               ; preds = %90
  br label %96, !dbg !103

95:                                               ; preds = %90
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.4, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 42, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !100
  unreachable, !dbg !100

96:                                               ; preds = %94
  %97 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !104
  store i32 5, i32* %97, align 4, !dbg !105
  %98 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 1, !dbg !106
  store i32 6, i32* %98, align 4, !dbg !107
  %99 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 2, !dbg !108
  store i32 7, i32* %99, align 4, !dbg !109
  %100 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !110
  %101 = getelementptr inbounds [4 x i32], [4 x i32]* %2, i64 0, i64 0, !dbg !111
  %102 = call i32 (i32*, i64, i32*, i64, ...) bitcast (i32 (...)* @memcpy_s to i32 (i32*, i64, i32*, i64, ...)*)(i32* %100, i64 12, i32* %101, i64 12), !dbg !112
  store i32 %102, i32* %4, align 4, !dbg !113
  %103 = load i32, i32* %4, align 4, !dbg !114
  %104 = icmp eq i32 %103, 0, !dbg !114
  br i1 %104, label %105, label %106, !dbg !117

105:                                              ; preds = %96
  br label %107, !dbg !117

106:                                              ; preds = %96
  call void @__assert_fail(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.6, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 49, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !114
  unreachable, !dbg !114

107:                                              ; preds = %105
  %108 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !118
  %109 = load i32, i32* %108, align 4, !dbg !118
  %110 = icmp eq i32 %109, 1, !dbg !118
  br i1 %110, label %111, label %112, !dbg !121

111:                                              ; preds = %107
  br label %113, !dbg !121

112:                                              ; preds = %107
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.7, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 50, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !118
  unreachable, !dbg !118

113:                                              ; preds = %111
  %114 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 1, !dbg !122
  %115 = load i32, i32* %114, align 4, !dbg !122
  %116 = icmp eq i32 %115, 2, !dbg !122
  br i1 %116, label %117, label %118, !dbg !125

117:                                              ; preds = %113
  br label %119, !dbg !125

118:                                              ; preds = %113
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.8, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 51, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !122
  unreachable, !dbg !122

119:                                              ; preds = %117
  %120 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 2, !dbg !126
  %121 = load i32, i32* %120, align 4, !dbg !126
  %122 = icmp eq i32 %121, 3, !dbg !126
  br i1 %122, label %123, label %124, !dbg !129

123:                                              ; preds = %119
  br label %125, !dbg !129

124:                                              ; preds = %119
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.9, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 52, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !126
  unreachable, !dbg !126

125:                                              ; preds = %123
  ret i32 0, !dbg !130
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #2

declare dso_local i32 @memcpy_s(...) #3

; Function Attrs: noreturn nounwind
declare dso_local void @__assert_fail(i8*, i8*, i32, i8*) #4

attributes #0 = { noinline nounwind uwtable "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly nofree nounwind willreturn }
attributes #3 = { "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noreturn nounwind "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { noreturn nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!5, !6, !7}
!llvm.ident = !{!8}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 12.0.0-3ubuntu1~20.04.5", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/memcpy_s.c", directory: "/home/ponce/git/Dat3M")
!2 = !{}
!3 = !{!4}
!4 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!5 = !{i32 7, !"Dwarf Version", i32 4}
!6 = !{i32 2, !"Debug Info Version", i32 3}
!7 = !{i32 1, !"wchar_size", i32 4}
!8 = !{!"Ubuntu clang version 12.0.0-3ubuntu1~20.04.5"}
!9 = distinct !DISubprogram(name: "main", scope: !10, file: !10, line: 5, type: !11, scopeLine: 6, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!10 = !DIFile(filename: "benchmarks/c/miscellaneous/memcpy_s.c", directory: "/home/ponce/git/Dat3M")
!11 = !DISubroutineType(types: !12)
!12 = !{!13}
!13 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!14 = !DILocalVariable(name: "a", scope: !9, file: !10, line: 7, type: !15)
!15 = !DICompositeType(tag: DW_TAG_array_type, baseType: !13, size: 128, elements: !16)
!16 = !{!17}
!17 = !DISubrange(count: 4)
!18 = !DILocation(line: 7, column: 9, scope: !9)
!19 = !DILocalVariable(name: "b", scope: !9, file: !10, line: 8, type: !20)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !13, size: 96, elements: !21)
!21 = !{!22}
!22 = !DISubrange(count: 3)
!23 = !DILocation(line: 8, column: 9, scope: !9)
!24 = !DILocalVariable(name: "ret", scope: !9, file: !10, line: 10, type: !13)
!25 = !DILocation(line: 10, column: 9, scope: !9)
!26 = !DILocation(line: 13, column: 41, scope: !9)
!27 = !DILocation(line: 13, column: 11, scope: !9)
!28 = !DILocation(line: 13, column: 9, scope: !9)
!29 = !DILocation(line: 14, column: 5, scope: !30)
!30 = distinct !DILexicalBlock(scope: !31, file: !10, line: 14, column: 5)
!31 = distinct !DILexicalBlock(scope: !9, file: !10, line: 14, column: 5)
!32 = !DILocation(line: 14, column: 5, scope: !31)
!33 = !DILocation(line: 17, column: 20, scope: !9)
!34 = !DILocation(line: 17, column: 11, scope: !9)
!35 = !DILocation(line: 17, column: 9, scope: !9)
!36 = !DILocation(line: 18, column: 5, scope: !37)
!37 = distinct !DILexicalBlock(scope: !38, file: !10, line: 18, column: 5)
!38 = distinct !DILexicalBlock(scope: !9, file: !10, line: 18, column: 5)
!39 = !DILocation(line: 18, column: 5, scope: !38)
!40 = !DILocation(line: 19, column: 5, scope: !41)
!41 = distinct !DILexicalBlock(scope: !42, file: !10, line: 19, column: 5)
!42 = distinct !DILexicalBlock(scope: !9, file: !10, line: 19, column: 5)
!43 = !DILocation(line: 19, column: 5, scope: !42)
!44 = !DILocation(line: 20, column: 5, scope: !45)
!45 = distinct !DILexicalBlock(scope: !46, file: !10, line: 20, column: 5)
!46 = distinct !DILexicalBlock(scope: !9, file: !10, line: 20, column: 5)
!47 = !DILocation(line: 20, column: 5, scope: !46)
!48 = !DILocation(line: 21, column: 5, scope: !49)
!49 = distinct !DILexicalBlock(scope: !50, file: !10, line: 21, column: 5)
!50 = distinct !DILexicalBlock(scope: !9, file: !10, line: 21, column: 5)
!51 = !DILocation(line: 21, column: 5, scope: !50)
!52 = !DILocation(line: 22, column: 5, scope: !9)
!53 = !DILocation(line: 22, column: 10, scope: !9)
!54 = !DILocation(line: 23, column: 5, scope: !9)
!55 = !DILocation(line: 23, column: 10, scope: !9)
!56 = !DILocation(line: 24, column: 5, scope: !9)
!57 = !DILocation(line: 24, column: 10, scope: !9)
!58 = !DILocation(line: 27, column: 20, scope: !9)
!59 = !DILocation(line: 27, column: 38, scope: !9)
!60 = !DILocation(line: 27, column: 11, scope: !9)
!61 = !DILocation(line: 27, column: 9, scope: !9)
!62 = !DILocation(line: 28, column: 5, scope: !63)
!63 = distinct !DILexicalBlock(scope: !64, file: !10, line: 28, column: 5)
!64 = distinct !DILexicalBlock(scope: !9, file: !10, line: 28, column: 5)
!65 = !DILocation(line: 28, column: 5, scope: !64)
!66 = !DILocation(line: 29, column: 5, scope: !67)
!67 = distinct !DILexicalBlock(scope: !68, file: !10, line: 29, column: 5)
!68 = distinct !DILexicalBlock(scope: !9, file: !10, line: 29, column: 5)
!69 = !DILocation(line: 29, column: 5, scope: !68)
!70 = !DILocation(line: 30, column: 5, scope: !71)
!71 = distinct !DILexicalBlock(scope: !72, file: !10, line: 30, column: 5)
!72 = distinct !DILexicalBlock(scope: !9, file: !10, line: 30, column: 5)
!73 = !DILocation(line: 30, column: 5, scope: !72)
!74 = !DILocation(line: 32, column: 5, scope: !75)
!75 = distinct !DILexicalBlock(scope: !76, file: !10, line: 32, column: 5)
!76 = distinct !DILexicalBlock(scope: !9, file: !10, line: 32, column: 5)
!77 = !DILocation(line: 32, column: 5, scope: !76)
!78 = !DILocation(line: 33, column: 5, scope: !9)
!79 = !DILocation(line: 33, column: 10, scope: !9)
!80 = !DILocation(line: 34, column: 5, scope: !9)
!81 = !DILocation(line: 34, column: 10, scope: !9)
!82 = !DILocation(line: 35, column: 5, scope: !9)
!83 = !DILocation(line: 35, column: 10, scope: !9)
!84 = !DILocation(line: 38, column: 20, scope: !9)
!85 = !DILocation(line: 38, column: 38, scope: !9)
!86 = !DILocation(line: 38, column: 11, scope: !9)
!87 = !DILocation(line: 38, column: 9, scope: !9)
!88 = !DILocation(line: 39, column: 5, scope: !89)
!89 = distinct !DILexicalBlock(scope: !90, file: !10, line: 39, column: 5)
!90 = distinct !DILexicalBlock(scope: !9, file: !10, line: 39, column: 5)
!91 = !DILocation(line: 39, column: 5, scope: !90)
!92 = !DILocation(line: 40, column: 5, scope: !93)
!93 = distinct !DILexicalBlock(scope: !94, file: !10, line: 40, column: 5)
!94 = distinct !DILexicalBlock(scope: !9, file: !10, line: 40, column: 5)
!95 = !DILocation(line: 40, column: 5, scope: !94)
!96 = !DILocation(line: 41, column: 5, scope: !97)
!97 = distinct !DILexicalBlock(scope: !98, file: !10, line: 41, column: 5)
!98 = distinct !DILexicalBlock(scope: !9, file: !10, line: 41, column: 5)
!99 = !DILocation(line: 41, column: 5, scope: !98)
!100 = !DILocation(line: 42, column: 5, scope: !101)
!101 = distinct !DILexicalBlock(scope: !102, file: !10, line: 42, column: 5)
!102 = distinct !DILexicalBlock(scope: !9, file: !10, line: 42, column: 5)
!103 = !DILocation(line: 42, column: 5, scope: !102)
!104 = !DILocation(line: 43, column: 5, scope: !9)
!105 = !DILocation(line: 43, column: 10, scope: !9)
!106 = !DILocation(line: 44, column: 5, scope: !9)
!107 = !DILocation(line: 44, column: 10, scope: !9)
!108 = !DILocation(line: 45, column: 5, scope: !9)
!109 = !DILocation(line: 45, column: 10, scope: !9)
!110 = !DILocation(line: 48, column: 20, scope: !9)
!111 = !DILocation(line: 48, column: 38, scope: !9)
!112 = !DILocation(line: 48, column: 11, scope: !9)
!113 = !DILocation(line: 48, column: 9, scope: !9)
!114 = !DILocation(line: 49, column: 5, scope: !115)
!115 = distinct !DILexicalBlock(scope: !116, file: !10, line: 49, column: 5)
!116 = distinct !DILexicalBlock(scope: !9, file: !10, line: 49, column: 5)
!117 = !DILocation(line: 49, column: 5, scope: !116)
!118 = !DILocation(line: 50, column: 5, scope: !119)
!119 = distinct !DILexicalBlock(scope: !120, file: !10, line: 50, column: 5)
!120 = distinct !DILexicalBlock(scope: !9, file: !10, line: 50, column: 5)
!121 = !DILocation(line: 50, column: 5, scope: !120)
!122 = !DILocation(line: 51, column: 5, scope: !123)
!123 = distinct !DILexicalBlock(scope: !124, file: !10, line: 51, column: 5)
!124 = distinct !DILexicalBlock(scope: !9, file: !10, line: 51, column: 5)
!125 = !DILocation(line: 51, column: 5, scope: !124)
!126 = !DILocation(line: 52, column: 5, scope: !127)
!127 = distinct !DILexicalBlock(scope: !128, file: !10, line: 52, column: 5)
!128 = distinct !DILexicalBlock(scope: !9, file: !10, line: 52, column: 5)
!129 = !DILocation(line: 52, column: 5, scope: !128)
!130 = !DILocation(line: 54, column: 2, scope: !9)
