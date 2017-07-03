for file in ../benchmarks/all_rx/*.pts;
do
    echo $(basename $file);
    java athos/Athos -t $1 -i $file
done
