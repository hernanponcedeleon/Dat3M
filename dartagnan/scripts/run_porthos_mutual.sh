for file in ../benchmarks/*.pts;
do
    echo $file;
    timeout 300 time java porthos/Porthos -s $1 -t $2 -i $file
done
