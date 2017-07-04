for file in ../benchmarks/all_sc/*.pts;
do
    echo $(basename $file);
    java athos/Athos -t $1 -i $file
done
