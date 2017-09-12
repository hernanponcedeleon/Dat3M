for file in ../benchmarks/*.pts;
do
    echo $file;
    echo "sc-tso"
    timeout 300 time java porthos/Porthos -s sc -t tso -i $file
    echo "sc-power"
    timeout 300 time java porthos/Porthos -s sc -t power -i $file
    echo "tso-power"
    timeout 300 time java porthos/Porthos -s tso -t power -i $file
done
