for file in ~/Documents/Projects/Memory-Models/LitmusSuite/reach/*.litmus;
do
    echo $(basename $file);
    herd7 -model ~/Documents/Projects/Memory-Models/herd/power.cat $file > ./rob.out;
    grep -e 'Never' rob.out | wc -l
    rm rob.out
done
